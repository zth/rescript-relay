/**
 * release-postinstall.js
 *
 * This script is bundled with the `npm` package and executed on release.
 * Since we have a 'fat' NPM package (with all platform binaries bundled),
 * this postinstall script extracts them and puts the current platform's
 * bits in the right place.
 */

var path = require("path");
var cp = require("child_process");
var fs = require("fs");
var { isNonGlibcLinux } = require("detect-libc");
var platform = process.platform;

function getRelayCompilerPlatformSuffix() {
  if (process.platform === "win32") {
    return "win-x64";
  } else if (process.platform === "darwin" && process.arch === "x64") {
    return "macos-x64";
  } else if (process.platform === "darwin" && process.arch === "arm64") {
    return "macos-arm64";
  } else if (process.platform === "linux" && isNonGlibcLinux) {
    return "linux-musl";
  } else if (process.platform === "linux" && process.arch === "x64") {
    return "linux-x64";
  }

  return "linux-x64";
}

/**
 * Since os.arch returns node binary's target arch, not
 * the system arch.
 * Credits: https://github.com/feross/arch/blob/af080ff61346315559451715c5393d8e86a6d33c/index.js#L10-L58
 */

function ppxArch() {
  /**
   * Use Rosetta for ARM on macOS
   */
  if (platform === "darwin" && process.arch === "arm64") {
    return "x64";
  }

  /**
   * The running binary is 64-bit, so the OS is clearly 64-bit.
   */
  if (process.arch === "x64") {
    return "x64";
  }

  /**
   * All recent versions of Mac OS are 64-bit.
   */
  if (process.platform === "darwin") {
    return "x64";
  }

  /**
   * On Windows, the most reliable way to detect a 64-bit OS from within a 32-bit
   * app is based on the presence of a WOW64 file: %SystemRoot%\SysNative.
   * See: https://twitter.com/feross/status/776949077208510464
   */
  if (process.platform === "win32") {
    var useEnv = false;
    try {
      useEnv = !!(
        process.env.SYSTEMROOT && fs.statSync(process.env.SYSTEMROOT)
      );
    } catch (err) {}

    var sysRoot = useEnv ? process.env.SYSTEMROOT : "C:\\Windows";

    // If %SystemRoot%\SysNative exists, we are in a WOW64 FS Redirected application.
    var isWOW64 = false;
    try {
      isWOW64 = !!fs.statSync(path.join(sysRoot, "sysnative"));
    } catch (err) {}

    return isWOW64 ? "x64" : "x86";
  }

  /**
   * On Linux, use the `getconf` command to get the architecture.
   */
  if (process.platform === "linux") {
    var output = cp.execSync("getconf LONG_BIT", { encoding: "utf8" });
    return output === "64\n" ? "x64" : "x86";
  }

  /**
   * If none of the above, assume the architecture is 32-bit.
   */
  return "x86";
}

function copyPlatformBinaries(platform) {
  /**
   * Copy the PPX
   */
  fs.copyFileSync(
    path.join(__dirname, "ppx-" + platform),
    path.join(__dirname, "ppx")
  );
  fs.chmodSync(path.join(__dirname, "ppx"), 0777);

  // Windows seems to need an .exe file as well.
  if (platform === "windows-latest") {
    fs.copyFileSync(
      path.join(__dirname, "ppx-" + platform),
      path.join(__dirname, "ppx.exe")
    );
    fs.chmodSync(path.join(__dirname, "ppx.exe"), 0777);
  }

  /**
   * Copy the Relay compiler
   */

  var platformSuffix = getRelayCompilerPlatformSuffix();

  fs.copyFileSync(
    path.join(
      __dirname,
      "relay-compiler-" + platformSuffix,
      platformSuffix === "win-x64" ? "relay.exe" : "relay"
    ),
    path.join(__dirname, "rescript-relay-compiler.exe")
  );
  fs.chmodSync(path.join(__dirname, "rescript-relay-compiler.exe"), 0777);
}

function removeInitialBinaries() {
  fs.unlinkSync(path.join(__dirname, "ppx-macos-latest"));
  fs.unlinkSync(path.join(__dirname, "ppx-windows-latest"));
  fs.unlinkSync(path.join(__dirname, "ppx-linux"));
  fs.rmSync(path.join(__dirname, "relay-compiler-linux-x64"), {
    recursive: true,
    force: true,
  });
  fs.rmSync(path.join(__dirname, "relay-compiler-macos-x64"), {
    recursive: true,
    force: true,
  });
  fs.rmSync(path.join(__dirname, "relay-compiler-macos-arm64"), {
    recursive: true,
    force: true,
  });
  fs.rmSync(path.join(__dirname, "relay-compiler-linux-musl"), {
    recursive: true,
    force: true,
  });
}

switch (platform) {
  case "win32": {
    if (ppxArch() !== "x64") {
      console.warn("error: x86 is currently not supported on Windows");
      process.exit(1);
    }
    copyPlatformBinaries("windows-latest");
    break;
  }
  case "linux":
    copyPlatformBinaries(platform);
    break;
  case "darwin":
    copyPlatformBinaries("macos-latest");
    break;
  default:
    console.warn("error: no release built for the " + platform + " platform");
    process.exit(1);
}

removeInitialBinaries();
