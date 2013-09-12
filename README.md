# ARST

Abstract Ruby Syntax Tree (ARST) is a high-level language syntax denoting the object domain of a Ruby project and a polyglot source code generator.

ARST can be used to generate:

* Pure Ruby code
* C Ruby extensions
* Java Ruby extensions
* Test::Unit, MiniTest::Unit, MiniTest::Spec, or RSpec tests
* GraphViz graphs
* Custom output

ARST files can also be generated from existing projects which allows:

* Bootstrapping C Ruby extensions
* Bootstrapping Test::Unit, MiniTest::Unit, MiniTest::Spec, or RSpec tests
* Generating GraphViz graphs

Integrations:

* Rake (baked in)
* [Thor](https://github.com/RyanScottLewis/thor-arst)
* [Guard](https://github.com/RyanScottLewis/guard-arst)

Generators:

* ARST::Generator::Ruby (baked in)
* ARST::Generator::C (baked in)
* [ARST::Generator::Java](https://github.com/RyanScottLewis/arst-generator-java)
* [ARST::Generator::Test::Unit](https://github.com/RyanScottLewis/arst-generator-test-unit)
* [ARST::Generator::MiniTest::Unit](https://github.com/RyanScottLewis/arst-generator-minitest-unit)
* [ARST::Generator::MiniTest::Spec](https://github.com/RyanScottLewis/arst-generator-minitest-spec)
* [ARST::Generator::RSpec](https://github.com/RyanScottLewis/arst-generator-rspec)
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
  
When interpreting the ARST syntax, the parser accepts 2 identical sequential whitespace characters
at the start of a line as an "indentation step".  
Valid whitespace characters are the space and tab characters.

Once the first indentation step is found while parsing, all subsequent indentation steps must contain the same
amount of whitespace characters as the first step:

<table width="100%"><tr><td>
<b>Valid</b>
<pre>
module Foo
  module Bar
    module Baz
</pre>
</td><td>
<b>Invalid</b>
<pre>
module Foo
  module Bar
         module Baz
</pre>
</td></tr></table>

## Usage

### Constructing ARST file

The first step is to create an `.arst` file within your project. There is no convention as to where to place this file,
but I like to put it in the root directory and name it the same as my project, like a `.gemspec` file.

`stupid_record.arst`

```rb
module StupidModel
  module Validations
  module Callbacks
  module Serialization
    module ClassMethods
    module InstanceMethods
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
  t.generate(:ruby, input_path: 'stupid_record.arst', split_files: false, output_path: 'lib/stupid_record.rb')
end
```

### Generate your code

### Ruby

Running `rake arst:ruby` will generate the following Ruby code in the `lib/stupid_record.rb` file:

```rb
module StupidModel
  module Validations
  end
  module Callbacks
  end
  module Serialization
    module ClassMethods
    end
    module InstanceMethods
    end
  end
  class Base
    extend Callbacks
    include Validations
    include Serialization
  end
end
module StupidRecord
  module Persistence
  end
  class Base < StupidModel::Base
    include Persistence
  end
end
```

Tasty! We turned 14 lines into 24 lines, like magic! But wait.. this isn't how conventional Ruby projects file hierarchies
are structured. The above is great for generating simple example Ruby files, but what about bootstrapping an entire project?

Let's refactor our Rake task:

`Rakefile`

```rb
require 'arst/rake_task'

ARST::RakeTask.new do |t|
  t.generate(:ruby, input_path: 'stupid_record.arst')
end
```

> Note: The `:split_files` option is `true` and the `output_path` option is `'lib'` by default in the Ruby generator.  
> Each generator has it's own set of options.

Now, when we run the `rake arst:ruby` task to generate our code, the project is bootstrapped in a more conventional manner:

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

Holy Moses! Now we're saving some typing!  
This may not be exactly the code you were looking to generate, but it's close enough to start working quickly.

The ARST Ruby generator attempts to be as smart about adding `require` statements as possible.

> Warning: When we generate the files, they are OVERWRITTEN. Meaning you WILL LOSE CODE if the file already exists.  
> There are plans in the *far* future for generating only missing nodes in the ARST and removing code that is NOT within the ARST.

## Copyright

Copyright © 2013 Ryan Scott Lewis <ryan@rynet.us>.

The MIT License (MIT) - See LICENSE for further details.
