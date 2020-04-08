import { maskDots, unmaskDots } from "../Utils.gen";

describe("masking and unmasking dots", () => {
  test("masking and unmasking dots work", () => {
    let test = "Module.hello";
    expect(unmaskDots(maskDots(test))).toBe(test);
  });
});
