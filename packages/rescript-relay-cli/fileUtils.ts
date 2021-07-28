import glob from "fast-glob";
import ora from "ora";
import path from "path";
import fs from "fs";

export const getAllGeneratedFiles = async (
  artifactDirectoryLocation: string
) => {
  const allGeneratedFiles = await glob(`${artifactDirectoryLocation}/*.res`, {
    absolute: true,
    onlyFiles: true,
  });

  return allGeneratedFiles;
};

export const sourceLocExtractor = new RegExp(
  /(?<=\/\* @sourceLoc )[A-Za-z_.0-9]+(?= \*\/)/g
);

export const findAllSourceFilesFromGeneratedFiles = async (
  allGeneratedFiles: string[],
  spinner?: ora.Ora
) => {
  const sourceLocs = await Promise.all(
    allGeneratedFiles.map(async (fileLocation) => {
      if (spinner != null) {
        spinner.text = `Checking ${path.basename(fileLocation)}...`;
      }

      const fileContents = await fs.promises.readFile(fileLocation, {
        encoding: "utf-8",
      });

      return fileContents.match(sourceLocExtractor)?.[0];
    })
  );

  const sourcesToFind = sourceLocs.reduce((acc: string[], curr) => {
    if (curr != null) {
      const targetPath = curr;
      if (!acc.includes(targetPath)) {
        acc.push(targetPath);
      }
      return acc;
    }

    return acc;
  }, []);

  return sourcesToFind;
};

export const getSrcCwd = (src: string) =>
  path.resolve(path.join(process.cwd(), src));

export const findSourceFiles = async (fileNames: string[], src: string) => {
  const cwd = getSrcCwd(src);

  const files = await glob(
    fileNames.map((name) => `**/${name}`),
    {
      cwd,
      absolute: true,
      onlyFiles: true,
    }
  );

  return files;
};
