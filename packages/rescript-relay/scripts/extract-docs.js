const { spawnSync } = require("child_process");
const fs = require("fs");
const path = require("path");

const srcDir = path.resolve(path.join(__dirname, "../src/"));

const srcFile = fs.readFileSync(
  path.resolve(path.join(srcDir, "RescriptRelay.resi")),
  "utf-8"
);

const extractParts = (json) => {
  return json.matches.reduce((acc, curr) => {
    const entry = {};
    curr.environment.forEach((env) => {
      if (env.variable === "_") {
        return;
      }

      entry[env.variable] = env.value;
    });

    acc.push(entry);
    return acc;
  }, []);
};

const runComby = (content, command, extract = true) => {
  const res = spawnSync(
    "comby",
    [
      `'${command}'`,
      "''",
      "-stdin",
      "-match-only",
      "-json-lines",
      "-match-newline-at-toplevel",
      "-matcher",
      ".re",
    ],
    {
      shell: true,
      stdio: "pipe",
      encoding: "utf-8",
      input: content,
    }
  );

  const output = res.output.filter(Boolean).join("");

  if (output[0] !== "{") {
    return [];
  }

  const matched = JSON.parse(res.output.filter(Boolean).join(""));

  return extract ? extractParts(matched) : matched;
};

const matchExternals = (content) => [
  ...runComby(
    content,
    '@ocaml.doc(:[doc]) :[__annotations] external :[name]: :[signature] = ":[]" // DOCEND'
  ),
  ...runComby(
    content,
    '@ocaml.doc(:[doc]) external :[name]: :[signature] = ":[]" // DOCEND'
  ),
];

const matchValues = (content) =>
  runComby(content, "@ocaml.doc(:[doc]) let :[name]: :[signature] // DOCEND");

const matchTypes = (content) =>
  runComby(
    content,
    "@ocaml.doc(:[doc]) type :[name~[a-zA-Z0-9]*]:[~ =] :[signature] // DOCEND"
  );

const matchAbstractTypes = (content) =>
  runComby(content, "@ocaml.doc(:[doc]) type :[name~[a-zA-Z0-9]*] // DOCEND");

const matchModules = (content, extract) =>
  runComby(content, "@ocaml.doc(:[doc]) module :[name]: {:[content]}", extract);

const makeContainer = () => ({
  modules: {},
  types: {},
  abstractTypes: {},
  values: {},
  externals: {},
});

let res = makeContainer();

const getSrcWithoutModules = (src) => {
  const modules = matchModules(src, false);

  if (!modules.matches) {
    return src;
  }

  let srcWithoutModules = "";
  let lastIndex = 0;

  modules.matches.forEach((m) => {
    srcWithoutModules += src.slice(lastIndex, m.range.start.offset);
    lastIndex = m.range.end.offset;
  });

  return srcWithoutModules + '\n\n@@ocaml.doc("")';
};

const trimDoc = (t) => {
  if (t.doc) {
    if (t.doc.startsWith("Internal, do not use")) {
      delete t.doc;
    } else {
      t.doc = t.doc.trim().replace(/^\"|\"$/gm, "");
    }
  }

  if (t.signature) {
    t.signature = t.signature.trim().replace(/@\n/g, "");
    if (t.signature.endsWith("@")) {
      t.signature = t.signature.slice(0, t.signature.length - 2);
    }
    if (t.signature.startsWith("|")) {
      t.isVariant = true;
    }
  }

  return t;
};

const extractFromSource = (src, target) => {
  const withoutModules = getSrcWithoutModules(src);

  const modules = matchModules(src);
  const types = matchTypes(withoutModules);
  const externals = matchExternals(withoutModules);

  const abstractTypes = matchAbstractTypes(withoutModules);
  const values = matchValues(withoutModules);

  abstractTypes.forEach((t) => {
    if (!t.name.includes("=")) {
      t.name = t.name.split("\n")[0];
      trimDoc(t);
      if (!t.doc.startsWith("Internal, do not use")) {
        target.abstractTypes[t.name] = t;
      }
    }
  });

  types.forEach((t) => {
    trimDoc(t);
    t.name = t.name.split("\n")[0];

    if (!t.doc.startsWith("Internal, do not use")) {
      target.types[t.name] = t;
    }
  });

  externals.forEach((t) => {
    trimDoc(t);
    if (!t.doc.startsWith("Internal, do not use")) {
      target.externals[t.name] = t;
    }
  });

  values.forEach((t) => {
    trimDoc(t);
    if (!t.doc.startsWith("Internal, do not use")) {
      target.values[t.name] = t;
    }
  });

  modules.forEach((m) => {
    const mod = makeContainer();
    trimDoc(m);
    mod.doc = m.doc;
    mod.name = m.name;
    extractFromSource(m.content, mod);
    target.modules[m.name] = mod;
  });
};

extractFromSource(srcFile, res);

let tokens = [];

const extractTokens = (target, currentPath) => {
  Object.keys({
    ...target.types,
    ...target.abstractTypes,
    ...target.values,
    ...target.externals,
  }).forEach((n) => {
    tokens.push([...currentPath, n].join("."));
  });

  Object.keys(target.modules).forEach((name) => {
    const m = target.modules[name];
    tokens.push(name);
    extractTokens(m, [...currentPath, name]);
  });
};

extractTokens(res, []);

tokens = [...tokens, ...tokens.map((n) => `RescriptRelay.${n}`)];

res.tokens = tokens;

/****************/
const makeSlugify = () => {
  var charMap = JSON.parse(
    '{"$":"dollar","%":"percent","&":"and","<":"less",">":"greater","|":"or","¢":"cent","£":"pound","¤":"currency","¥":"yen","©":"(c)","ª":"a","®":"(r)","º":"o","À":"A","Á":"A","Â":"A","Ã":"A","Ä":"A","Å":"A","Æ":"AE","Ç":"C","È":"E","É":"E","Ê":"E","Ë":"E","Ì":"I","Í":"I","Î":"I","Ï":"I","Ð":"D","Ñ":"N","Ò":"O","Ó":"O","Ô":"O","Õ":"O","Ö":"O","Ø":"O","Ù":"U","Ú":"U","Û":"U","Ü":"U","Ý":"Y","Þ":"TH","ß":"ss","à":"a","á":"a","â":"a","ã":"a","ä":"a","å":"a","æ":"ae","ç":"c","è":"e","é":"e","ê":"e","ë":"e","ì":"i","í":"i","î":"i","ï":"i","ð":"d","ñ":"n","ò":"o","ó":"o","ô":"o","õ":"o","ö":"o","ø":"o","ù":"u","ú":"u","û":"u","ü":"u","ý":"y","þ":"th","ÿ":"y","Ā":"A","ā":"a","Ă":"A","ă":"a","Ą":"A","ą":"a","Ć":"C","ć":"c","Č":"C","č":"c","Ď":"D","ď":"d","Đ":"DJ","đ":"dj","Ē":"E","ē":"e","Ė":"E","ė":"e","Ę":"e","ę":"e","Ě":"E","ě":"e","Ğ":"G","ğ":"g","Ģ":"G","ģ":"g","Ĩ":"I","ĩ":"i","Ī":"i","ī":"i","Į":"I","į":"i","İ":"I","ı":"i","Ķ":"k","ķ":"k","Ļ":"L","ļ":"l","Ľ":"L","ľ":"l","Ł":"L","ł":"l","Ń":"N","ń":"n","Ņ":"N","ņ":"n","Ň":"N","ň":"n","Ō":"O","ō":"o","Ő":"O","ő":"o","Œ":"OE","œ":"oe","Ŕ":"R","ŕ":"r","Ř":"R","ř":"r","Ś":"S","ś":"s","Ş":"S","ş":"s","Š":"S","š":"s","Ţ":"T","ţ":"t","Ť":"T","ť":"t","Ũ":"U","ũ":"u","Ū":"u","ū":"u","Ů":"U","ů":"u","Ű":"U","ű":"u","Ų":"U","ų":"u","Ŵ":"W","ŵ":"w","Ŷ":"Y","ŷ":"y","Ÿ":"Y","Ź":"Z","ź":"z","Ż":"Z","ż":"z","Ž":"Z","ž":"z","Ə":"E","ƒ":"f","Ơ":"O","ơ":"o","Ư":"U","ư":"u","ǈ":"LJ","ǉ":"lj","ǋ":"NJ","ǌ":"nj","Ș":"S","ș":"s","Ț":"T","ț":"t","ə":"e","˚":"o","Ά":"A","Έ":"E","Ή":"H","Ί":"I","Ό":"O","Ύ":"Y","Ώ":"W","ΐ":"i","Α":"A","Β":"B","Γ":"G","Δ":"D","Ε":"E","Ζ":"Z","Η":"H","Θ":"8","Ι":"I","Κ":"K","Λ":"L","Μ":"M","Ν":"N","Ξ":"3","Ο":"O","Π":"P","Ρ":"R","Σ":"S","Τ":"T","Υ":"Y","Φ":"F","Χ":"X","Ψ":"PS","Ω":"W","Ϊ":"I","Ϋ":"Y","ά":"a","έ":"e","ή":"h","ί":"i","ΰ":"y","α":"a","β":"b","γ":"g","δ":"d","ε":"e","ζ":"z","η":"h","θ":"8","ι":"i","κ":"k","λ":"l","μ":"m","ν":"n","ξ":"3","ο":"o","π":"p","ρ":"r","ς":"s","σ":"s","τ":"t","υ":"y","φ":"f","χ":"x","ψ":"ps","ω":"w","ϊ":"i","ϋ":"y","ό":"o","ύ":"y","ώ":"w","Ё":"Yo","Ђ":"DJ","Є":"Ye","І":"I","Ї":"Yi","Ј":"J","Љ":"LJ","Њ":"NJ","Ћ":"C","Џ":"DZ","А":"A","Б":"B","В":"V","Г":"G","Д":"D","Е":"E","Ж":"Zh","З":"Z","И":"I","Й":"J","К":"K","Л":"L","М":"M","Н":"N","О":"O","П":"P","Р":"R","С":"S","Т":"T","У":"U","Ф":"F","Х":"H","Ц":"C","Ч":"Ch","Ш":"Sh","Щ":"Sh","Ъ":"U","Ы":"Y","Ь":"","Э":"E","Ю":"Yu","Я":"Ya","а":"a","б":"b","в":"v","г":"g","д":"d","е":"e","ж":"zh","з":"z","и":"i","й":"j","к":"k","л":"l","м":"m","н":"n","о":"o","п":"p","р":"r","с":"s","т":"t","у":"u","ф":"f","х":"h","ц":"c","ч":"ch","ш":"sh","щ":"sh","ъ":"u","ы":"y","ь":"","э":"e","ю":"yu","я":"ya","ё":"yo","ђ":"dj","є":"ye","і":"i","ї":"yi","ј":"j","љ":"lj","њ":"nj","ћ":"c","ѝ":"u","џ":"dz","Ґ":"G","ґ":"g","Ғ":"GH","ғ":"gh","Қ":"KH","қ":"kh","Ң":"NG","ң":"ng","Ү":"UE","ү":"ue","Ұ":"U","ұ":"u","Һ":"H","һ":"h","Ә":"AE","ә":"ae","Ө":"OE","ө":"oe","฿":"baht","ა":"a","ბ":"b","გ":"g","დ":"d","ე":"e","ვ":"v","ზ":"z","თ":"t","ი":"i","კ":"k","ლ":"l","მ":"m","ნ":"n","ო":"o","პ":"p","ჟ":"zh","რ":"r","ს":"s","ტ":"t","უ":"u","ფ":"f","ქ":"k","ღ":"gh","ყ":"q","შ":"sh","ჩ":"ch","ც":"ts","ძ":"dz","წ":"ts","ჭ":"ch","ხ":"kh","ჯ":"j","ჰ":"h","Ẁ":"W","ẁ":"w","Ẃ":"W","ẃ":"w","Ẅ":"W","ẅ":"w","ẞ":"SS","Ạ":"A","ạ":"a","Ả":"A","ả":"a","Ấ":"A","ấ":"a","Ầ":"A","ầ":"a","Ẩ":"A","ẩ":"a","Ẫ":"A","ẫ":"a","Ậ":"A","ậ":"a","Ắ":"A","ắ":"a","Ằ":"A","ằ":"a","Ẳ":"A","ẳ":"a","Ẵ":"A","ẵ":"a","Ặ":"A","ặ":"a","Ẹ":"E","ẹ":"e","Ẻ":"E","ẻ":"e","Ẽ":"E","ẽ":"e","Ế":"E","ế":"e","Ề":"E","ề":"e","Ể":"E","ể":"e","Ễ":"E","ễ":"e","Ệ":"E","ệ":"e","Ỉ":"I","ỉ":"i","Ị":"I","ị":"i","Ọ":"O","ọ":"o","Ỏ":"O","ỏ":"o","Ố":"O","ố":"o","Ồ":"O","ồ":"o","Ổ":"O","ổ":"o","Ỗ":"O","ỗ":"o","Ộ":"O","ộ":"o","Ớ":"O","ớ":"o","Ờ":"O","ờ":"o","Ở":"O","ở":"o","Ỡ":"O","ỡ":"o","Ợ":"O","ợ":"o","Ụ":"U","ụ":"u","Ủ":"U","ủ":"u","Ứ":"U","ứ":"u","Ừ":"U","ừ":"u","Ử":"U","ử":"u","Ữ":"U","ữ":"u","Ự":"U","ự":"u","Ỳ":"Y","ỳ":"y","Ỵ":"Y","ỵ":"y","Ỷ":"Y","ỷ":"y","Ỹ":"Y","ỹ":"y","‘":"\'","’":"\'","“":"\\"","”":"\\"","†":"+","•":"*","…":"...","₠":"ecu","₢":"cruzeiro","₣":"french franc","₤":"lira","₥":"mill","₦":"naira","₧":"peseta","₨":"rupee","₩":"won","₪":"new shequel","₫":"dong","€":"euro","₭":"kip","₮":"tugrik","₯":"drachma","₰":"penny","₱":"peso","₲":"guarani","₳":"austral","₴":"hryvnia","₵":"cedi","₸":"kazakhstani tenge","₹":"indian rupee","₺":"turkish lira","₽":"russian ruble","₿":"bitcoin","℠":"sm","™":"tm","∂":"d","∆":"delta","∑":"sum","∞":"infinity","♥":"love","元":"yuan","円":"yen","﷼":"rial"}'
  );
  var locales = JSON.parse(
    '{"de":{"Ä":"AE","ä":"ae","Ö":"OE","ö":"oe","Ü":"UE","ü":"ue"},"vi":{"Đ":"D","đ":"d"}}'
  );

  function replace(string, options) {
    if (typeof string !== "string") {
      throw new Error("slugify: string argument expected");
    }

    options =
      typeof options === "string" ? { replacement: options } : options || {};

    var locale = locales[options.locale] || {};

    var replacement =
      options.replacement === undefined ? "-" : options.replacement;

    var slug = string
      .split("")
      // replace characters based on charMap
      .reduce(function (result, ch) {
        return (
          result +
          (locale[ch] || charMap[ch] || ch)
            // remove not allowed characters
            .replace(options.remove || /[^\w\s$*_+~.()'"!\-:@]+/g, "")
        );
      }, "")
      // trim leading/trailing spaces
      .trim()
      // convert spaces to replacement character
      // also remove duplicates of the replacement character
      .replace(new RegExp("[\\s" + replacement + "]+", "g"), replacement);

    if (options.lower) {
      slug = slug.toLowerCase();
    }

    if (options.strict) {
      // remove anything besides letters, numbers, and the replacement char
      slug = slug
        .replace(new RegExp("[^a-zA-Z0-9" + replacement + "]", "g"), "")
        // remove duplicates of the replacement character
        .replace(new RegExp("[\\s" + replacement + "]+", "g"), replacement);
    }

    return slug;
  }

  replace.extend = function (customMap) {
    for (var key in customMap) {
      charMap[key] = customMap[key];
    }
  };

  return replace;
};

const rawSlugify = makeSlugify();
const slugify = (c) => rawSlugify(c, { strict: true, lower: true });
const printType = (t) =>
  `type ${t.name} = ${t.isVariant ? "\n  " : ""}${t.signature}`;
const printAbstractType = (t) => `type ${t.name}`;
const printValue = (t) => `let ${t.name}: ${t.signature}`;
const makeHeadlineFromLevel = (level) =>
  Array.from({ length: level })
    .map((_) => "#")
    .join("");

const makeTokenLink = (token) => {
  const cleanToken = token.replace("RescriptRelay.", "");
  return "[" + cleanToken + "](#" + slugify(cleanToken) + ")";
};

const transformDoc = (doc, level) => {
  const baseHeadline = makeHeadlineFromLevel(3) + " ";
  const baseSubHeadline = makeHeadlineFromLevel(4) + " ";

  const newHeadline = makeHeadlineFromLevel(level) + " ";
  const subLevelHeadline = makeHeadlineFromLevel(level + 1) + " ";

  let res = doc;

  if (baseHeadline !== newHeadline) {
    res = res
      .replace(new RegExp(`/${baseSubHeadline}/g`), subLevelHeadline)
      .replace(new RegExp(`/${baseHeadline}/g`), newHeadline);
  }

  res = res
    .split("`")
    .map((s, i) => {
      // Is this a token?
      const leadingText = /^[a-zA-Z_.]*/g.exec(s)[0];

      if (leadingText === s) {
        const token = tokens.find((t) => t === s);

        if (token) {
          return makeTokenLink(token) + " `REMOVE__";
        }
      }

      return i > 0 ? "`" + s : s;
    })
    .join("")
    .replace(/`REMOVE__`/gm, "")
    .replace(/\\"/g, '"');

  return res;
};

const printInReScriptTag = (c, name, prefix) => {
  let content = c.replace(/(@bs)([\s\S]*?)((,|\n)[\n\t\r ]*)/g, "");
  let res = "```reason\n" + content + "\n```";

  const tokensInCode = [
    ...tokens.filter(
      (t) =>
        (content.includes(`: ${t}`) || content.includes(`=> ${t}`)) &&
        t !== name
    ),
    ...(prefix
      ? tokens.filter(
          (t) =>
            content.includes(`: ${t.replace(prefix + ".", "")}`) ||
            content.includes(`=> ${t.replace(prefix + ".", "")}`)
        )
      : []),
  ];

  if (
    (prefix && content.includes("(t,")) ||
    content.includes(": t,") ||
    content.includes(" t)") ||
    content.includes(" t =>") ||
    content.includes(" t,\n")
  ) {
    tokensInCode.unshift(`${prefix}.t`);
  }

  if (tokensInCode.length > 0) {
    res += `\n> Read more about: ${tokensInCode
      .reduce((acc, curr) => {
        if (!acc.includes(curr)) {
          acc.push(curr);
        }
        return acc;
      }, [])
      .map((t) => makeTokenLink(t))
      .join(", ")}`;
  }

  return res;
};

const makeSection = (title, content, level = 2, currentPath) =>
  `${Array.from({ length: level })
    .map((_) => "#")
    .join("")} [${[...currentPath, title].join(".")}](#${slugify(
    [...currentPath, title].join(".")
  )})\n${content}`;

const printContents = (r, currentPath, level = 2) => {
  let str = `${Object.values(r.types)
    .map((t) =>
      makeSection(
        t.name,
        `${printInReScriptTag(
          printType(t),
          t.name,
          currentPath.join(".")
        )}\n\n${transformDoc(t.doc, level)}`,
        level,
        currentPath
      )
    )
    .join("\n\n")}
    
${Object.values(r.abstractTypes)
  .map((t) =>
    makeSection(
      t.name,
      `${printInReScriptTag(
        printAbstractType(t),
        t.name,
        currentPath.join(".")
      )}\n\n${transformDoc(t.doc, level)}`,
      level,
      currentPath
    )
  )
  .join("\n\n")}
    
${[...Object.values(r.values), ...Object.values(r.externals)]
  .map((t) =>
    makeSection(
      t.name,
      `${printInReScriptTag(
        printValue(t),
        t.name,
        currentPath.join(".")
      )}\n\n${transformDoc(t.doc, level)}`,
      level,
      currentPath
    )
  )
  .join("\n\n")}`;

  Object.keys(r.modules).forEach((name) => {
    const m = r.modules[name];
    str +=
      `\n## ${name}\n\n${transformDoc(m.doc, level)}\n\n` +
      printContents(m, [...currentPath, name], level + 1) +
      "\n\n";
  });

  return str;
};

const resToMd = (r) => {
  let str = `---
  id: reference
  title: Reference
  sidebar_label: Reference
---

# Types, values and functions
${printContents(r, [])}`;

  return str.replace(/```rescript/g, "```reason");
};

fs.writeFileSync(
  path.resolve(
    path.join(
      __dirname,
      "../../../rescript-relay-documentation/docs",
      "reference.md"
    )
  ),
  resToMd(res)
);

fs.writeFileSync(
  path.resolve(path.join(__dirname, "output.json")),
  JSON.stringify(res, null, 2)
);

console.log("Done!");
