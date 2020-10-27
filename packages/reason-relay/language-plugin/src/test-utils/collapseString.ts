const collapseString = (str: string): string =>
  str.replace(/\r?\n|\r|\t/g, "").replace(/\s+/g, " ");

export default collapseString;
