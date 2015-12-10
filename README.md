# ARST

ARST is a language syntax denoting the object domain model of a Ruby project and a polyglot source code generator.

ARST files can be used to generate:

* Pure Ruby code  
* * To quickly generate source files for gems or projects.  
* * To map out the domain model of the objects for new or proposed projects.
* Tests
* * Bootstrap RSpec, Test::Unit, MiniTest::Unit, or MiniTest::Spec files based on your current codebase.
* Ruby extensions
* * Bootstrap C, Java, or MRuby specific code.
* GraphViz graphs
* * Map out the domain model of your project.
* Custom output
* * Create your own generators.

ARST files can also be generated which allows all of the above an already existing projects.

Integrations:

* Rake (baked in)
* * Rake commands to generate files based on an ARST file or generate an ARST files based on project files.
* [Guard](https://github.com/RyanScottLewis/guard-arst)
* * Regenerate the ARST file whenever a project or test file is changed.
* * Generate methods or tests whenever the ARST file is changed.
* [Rails](https://github.com/RyanScottLewis/arst-rails)
* * Generate ARST files from Rails projects.

Generators:

* ARST::Generator::Ruby (baked in)
* ARST::Generator::C (baked in)
* [ARST::Generator::Java](https://github.com/RyanScottLewis/arst-generator-java)
* [ARST::Generator::MRuby](https://github.com/RyanScottLewis/arst-generator-mruby)
* [ARST::Generator::RSpec](https://github.com/RyanScottLewis/arst-generator-rspec)
* [ARST::Generator::Test::Unit](https://github.com/RyanScottLewis/arst-generator-test-unit)
* [ARST::Generator::MiniTest::Unit](https://github.com/RyanScottLewis/arst-generator-minitest-unit)
* [ARST::Generator::MiniTest::Spec](https://github.com/RyanScottLewis/arst-generator-minitest-spec)
* [ARST::Generator::Graphviz](https://github.com/RyanScottLewis/arst-generator-graphviz)

## Install

### Bundler: `gem 'arst'` in `group :development`

### RubyGems: `gem install arst`

## Syntax

### Ruby

ARST syntax implements most keywords and declarations of the Ruby language's syntax.
This means that most syntax highlighters for Ruby will also work for ARST.

**Valid Ruby syntax within ARST:**

* `module ModuleName`
* `class ClassName < SuperClassName`
* `include ModuleName`
* `extend ModuleName`

**Not Yet Implemented:**

* `def instance_method(arg1, *other_args)` (and anything else accepted method arguments in Ruby's syntax)
* `def self.class_method(arg1, opts={})` (and anything else accepted method arguments in Ruby's syntax)
* `alias` and `alias_method`
* `alias_module` which generate `NewClassName = OldClassName`

### Indentation

ARST is an indentation-sensitive syntax meaning that the following are **not** equivalent:

<table width="100%"><tr><td>
<pre>
module Foo
  module Bar
</pre>
</td><td>
<pre>
module Foo
module Bar
</pre>
</td></tr></table>

The parser reads line by line, comparing the current line's indentation with the last parsed line's indentation and scope.  
This allows it to be loose in regards to how it interprets indentation:

    If the current line contains a `module` or `class` node
      And it is more indented than the last `module` or `class` node
        And the last line contains a `module` or `class` node
          Then the node will be contained within the last line's scope
        And the last line does not contain a `module` or `class` node
          Then the node will be contained within the current scope
      And it is the same indentation
        Then the node will be contained within the current scope
      And it is less indented than the last
        Then the node will be contained within the outer scope
    If the current line does not contain a `module` or `class` node
      Then the node will be contained within the current scope

Below is an example of oddly indented (but still valid) ARST code.

<table width="100%" markdown="1"><tr markdown="1"><td markdown="1">

**ARST**

    module Foo
      class Bar
           def self.a
             attr_reader :b
               module Zed
        module Qux
      module Baz

</td><td markdown="1">

**Parsed Indentation**

    module Foo
    |- class Bar
    |  |- def self.a
    |  |- attr_reader :b
    |  |- module Zed
    |- class Baz

</td></tr></table>

It's very recommended to maintain consistant indentation throughout the document:

    module Foo
      class Bar
        def self.a
        attr_reader :b
        module Zed
        module Qux
      module Baz

## Usage

### Constructing ARST file

The first step is to create an ARST file within your project. There is no convention as to where to place or name this file.

For projects, I tend to use a single `.arst` in the root directory of the project.  
When maintaining a projects with multiple subprojects, I'll use `project_one.arst` and `project_two.arst` in the directory containing those
project directories.

`stupid_record.arst`

```rb
module StupidModel
  module Validations
  module Callbacks
  module Serialization
    module ClassMethods
  class Base
    extend Callbacks
    include Validations
    include Serialization
module StupidRecord
  module Persistence
  class Base < StupidModel::Base
    include Persistence
```

### Setup Rake task

`Rakefile`

```rb
require 'arst/rake_task'

ARST::RakeTask.new do |t|
  # Define a generate task
  t.generate(name: :stupid_model, generator: :ruby, input_path: 'stupid_record.arst', output_path: 'lib')
end
```

By default, the name of the task defined is the same as the generator, but in the example above, we named ours `:stupid_model`.  
This defines the `arst:stupid_model` Rake task.

`:input_path` and `:output_path` are options on the ARST::Generator::Ruby class.  
Each generator has it's own set of options and defaults.

### Generate your code

### Ruby

Running `rake arst:stupid_model` will generate the following files:

`lib/stupid_model.rb`

```rb
require 'stupid_model/base'

module StupidModel
end
```

`lib/stupid_model/validations.rb`

```rb
module StupidModel
  module Validations
  end
end
```

`lib/stupid_model/callbacks.rb`

```rb
module StupidModel
  module Callbacks
  end
end
```

`lib/stupid_model/serialization.rb`

```rb
require 'stupid_model/serialization/class_methods'
require 'stupid_model/serialization/instance_methods'

module StupidModel
  module Serialization
  end
end
```

`lib/stupid_model/serialization/class_methods.rb`

```rb
module StupidModel
  module Serialization
    module ClassMethods
    end
  end
end
```

`lib/stupid_model/serialization/instance_methods.rb`

```rb
module StupidModel
  module Serialization
    module InstanceMethods
    end
  end
end
```

`lib/stupid_model/base.rb`

```rb
require 'stupid_model/validations'
require 'stupid_model/callbacks'
require 'stupid_model/serialization'

module StupidModel
  class Base
    extend Callbacks
    include Validations
    include Serialization
  end
end
```

`lib/stupid_record.rb`

```rb
require 'stupid_record/base'

module StupidRecord
end
```

`lib/stupid_record/persistence.rb`

```rb
module StupidRecord
  module Persistence
  end
end
```

`lib/stupid_record/base.rb`

```rb
require 'stupid_model/base'
require 'stupid_record/persistence'

module StupidRecord
  class Base < StupidModel::Base
    include Persistence
  end
end
```

Now we're saving some typing!  
This may not be exactly the code you were looking to generate, but it's close enough to start working quickly.

> Warning: When we generate the files, they are OVERWRITTEN. Meaning you WILL LOSE CODE if the file already exists.  
> There are plans in the *far* future for generating only missing nodes in the ARST and removing code that is NOT within the ARST.

### Requiring

The ARST Ruby generator attempts to be as smart about adding `require` calls as possible.

A require call will be added when:

* A module includes any classes.
* A class includes or extends a module.
* A class subclasses another.

## How It Works

ARST works by parsing ARST Notation or transforming a Ruby AST of a file or project into an "Abstract Ruby Syntax Tree" which is a 
minimal version of the Ruby AST. With this ARST, we can generate/modify Ruby or ARST files based on this tree.

### ARST Notation

ARST Notation (ARST-N) is the actual syntax that is contained within ARST files.

## Copyright

Copyright © 2013 Ryan Scott Lewis <ryan@rynet.us>.

The MIT License (MIT) - See LICENSE for further details.
