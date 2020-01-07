import { maskDots, unmaskDots, findObjName } from "../Utils.gen";
import { printCode } from "../Printer.gen";

import {
  // @ts-ignore
  printConnectionTraverser
  // @ts-ignore
} from "../UtilsPrinter.bs";

describe("masking and unmasking dots", () => {
  test("masking and unmasking dots work", () => {
    let test = "Module.hello";
    expect(unmaskDots(maskDots(test))).toBe(test);
  });
});

describe("finding appropriate object names", () => {
  test("with no already used names", () => {
    expect(
      findObjName({
        prefix: null,
        usedRecordNames: [],
        path: ["location", "me", "response"]
      })
    ).toBe("location");
  });

  test("with already used names, nested 1 level", () => {
    expect(
      findObjName({
        prefix: null,
        usedRecordNames: ["location"],
        path: ["location", "me", "response"]
      })
    ).toBe("me_location");
  });

  test("with used names, nested 2 levels", () => {
    expect(
      findObjName({
        prefix: null,
        usedRecordNames: ["location", "me_location"],
        path: ["location", "me", "response"]
      })
    ).toBe("response_me_location");
  });

  describe("prefixed", () => {
    test("with no already used names", () => {
      expect(
        findObjName({
          prefix: "prefix",
          usedRecordNames: [],
          path: ["location", "me", "response"]
        })
      ).toBe("prefix_location");
    });

    test("with already used names, nested 1 level", () => {
      expect(
        findObjName({
          prefix: "prefix",
          usedRecordNames: ["prefix_location"],
          path: ["location", "me", "response"]
        })
      ).toBe("prefix_me_location");
    });

    test("with used names, nested 2 levels", () => {
      expect(
        findObjName({
          prefix: "prefix",
          usedRecordNames: ["prefix_location", "prefix_me_location"],
          path: ["location", "me", "response"]
        })
      ).toBe("prefix_response_me_location");
    });
  });
});
