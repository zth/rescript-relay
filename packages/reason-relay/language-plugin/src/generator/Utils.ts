export const maskDots = (str: string): string => str.split(".").join("__oo__");
export const unmaskDots = (str: string): string =>
  str.split("__oo__").join(".");
