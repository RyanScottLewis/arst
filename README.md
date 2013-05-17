# ARST

Abstract Ruby Syntax Tree (ARST) is a high-level language syntax denoting the object domain of a Ruby project.

ARST can be used to generate:

* Pure Ruby
* C Ruby extensions
* Test::Unit, MiniTest::Unit, MiniTest::Spec, or RSpec tests
* GraphViz graphs
* Custom output

ARST files can also be generated from existing projects which allows:

* Bootstrapping C Ruby extensions
* Bootstrapping Test::Unit, MiniTest::Unit, MiniTest::Spec, or RSpec tests
* Generating GraphViz graphs

Integrations:

* [Rake](https://github.com/RyanScottLewis/rake-arst)
* [Thor](https://github.com/RyanScottLewis/thor-arst)
* [Guard](https://github.com/RyanScottLewis/guard-arst)

Generators:

* ARST::Generator::Ruby (baked into this gem)
* ARST::Generator::CRuby (baked into this gem)
* [ARST::Generator::JRuby](https://github.com/RyanScottLewis/arst-generator-jruby)
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
* `def instance_method(arg1, *other_args)` (and anything else accepted method arguments in Ruby's syntax)
* `def self.class_method(arg1, opts={})` (and anything else accepted method arguments in Ruby's syntax)

### Indentation

ARST is an indentation-sensitive syntax meaning that the following are **not** equivalent:

<table width="100%"><tr><td>
```rb
module Foo
  module Bar
```
</td><td>
```rb
module Foo
module Bar
```
</td></tr><table>
  
When interpreting the ARST syntax, the parser accepts 2 identical sequential whitespace characters
at the start of a line as an "indentation step".  
Valid whitespace characters are the space (` `) and tab (`\t`) characters.

Once the first indentation step is found while parsing, all subsequent indentation steps must contain the same
amount of whitespace characters as the first step:

<table width="100%"><tr><td>
**Valid**
```rb
module Foo
  module Bar
    module Baz
```
</td><td>
**Invalid**
```rb
module Foo
  module Bar
         module Baz
```
</td></tr><table>

## Usage

## Copyright

Copyright © 2013 Ryan Scott Lewis <ryan@rynet.us>.

The MIT License (MIT) - See LICENSE for further details.
