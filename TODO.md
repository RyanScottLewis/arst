* `require` statements when generating Ruby code with the `split_files` option on
  Within a tree, find all superclasses, and modules which are extended/included
  For each of these, search the tree for modules/classes with the same name.
    If found, generate the filename from that nodes ancestor tree (using `join` and `underscore`) and `require` that.
    If not, just `require` the `underscore`d node name
* Generating C Ruby
* Syntax checking