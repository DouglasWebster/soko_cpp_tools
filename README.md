# soko_cpp_tools


**MAIN BRANCH:**

[![ci](https://github.com/DouglasWebster/soko_cpp_tools/actions/workflows/ci.yml/badge.svg)](https://github.com/DouglasWebster/soko_cpp_tools/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/DouglasWebster/soko_cpp_tools/branch/main/graph/badge.svg?token=PFJ3VM644J)](https://codecov.io/gh/DouglasWebster/soko_cpp_tools)
[![CodeQL](https://github.com/DouglasWebster/soko_cpp_tools/actions/workflows/codeql-analysis.yml/badge.svg)](https://github.com/DouglasWebster/soko_cpp_tools/actions/workflows/codeql-analysis.yml)


**DEVELOP BRANCH**

[![ci](https://github.com/DouglasWebster/soko_cpp_tools/actions/workflows/ci.yml/badge.svg?branch=develop)](https://github.com/DouglasWebster/soko_cpp_tools/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/DouglasWebster/soko_cpp_tools/branch/develop/graph/badge.svg?token=PFJ3VM644J)](https://codecov.io/gh/DouglasWebster/soko_cpp_tools)
[![CodeQL](https://github.com/DouglasWebster/soko_cpp_tools/actions/workflows/codeql-analysis.yml/badge.svg?branch=develop)](https://github.com/DouglasWebster/soko_cpp_tools/actions/workflows/codeql-analysis.yml)



## About soko_cpp_tools
Tools required to create artifacts for use in the Sokoban game [godot_sokoban](https://github.com/DouglasWebster/godot_sokoban) being developed for the Godot4 platform.


### Make Level files
This utility will take Sokoban level files and convert them to a format suitable for parsing into a game.  The output is stored in a Json file and has the following format.

```json
{
  "Collections" : [
    {
      "name" : "collection_1_name",
      "authors": "collection 1 author(s)",
      "comments": "things like licence etc...",
      "levels" : [
        {
          "level_id": 1,
          "rows" : [ "row 1 data", "row 2 data", "etc..."],
          "author" : "author of the level 1",
          "comment" : "any comment about the level 1" 
        },
        {
          "level_id": 2,
          "rows" : [ "row 1 data", "row 2 data", "etc..."],
          "author" : "author of the level 2",
          "comment" : "any comment about the level 2" 
        }
        {
          "etc": "more level data!"
        }
      ]
    }
  ]  
}
```