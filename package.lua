return {
  name = "nihildeb/lit-sqlite3-sample",
  version = "0.0.0",
  homepage = "https://github.com/nihildeb/lit-sqlite3-sample",
  dependencies = {
    -- project deps
    "luvit/require@1.1.0",
    "nihildeb/sqlite3@1.0.0",

    -- luv fs mod and deps
    "luvit/fs@1.1.0",
    "luvit/utils@1",
    "luvit/path@1",
    "luvit/los@1",
    "luvit/core@1",
    "luvit/stream@1",

    -- test deps
    "luvit/tap@0.1.0",
    "luvit/deep-equal@0.1.0",
  },
  files = {
    "*.lua",
    "test/*",
    "README.md",
    "LICENSE",
  }
}
