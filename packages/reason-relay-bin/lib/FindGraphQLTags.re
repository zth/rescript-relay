let reason_regex =
  Str.regexp(
    "/(?<=\[%%relay\.(query|fragment|mutation|subscription))([\s\S]*?)(?=];)/g",
  );
