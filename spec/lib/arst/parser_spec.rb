def raise_parse_error
  raise_error(ARST::Parser::ParseFailed)
end

describe ARST::Parser do
  describe '#constant' do
    subject { described_class.new.constant }

    it "should parse correctly" do
      expect { subject.parse("A") }.not_to raise_error
      expect { subject.parse("This") }.not_to raise_error
      expect { subject.parse("FooBar") }.not_to raise_error
      expect { subject.parse("T1000") }.not_to raise_error
      expect { subject.parse("TIME") }.not_to raise_error
      expect { subject.parse("FOO_BAR") }.not_to raise_error

      expect { subject.parse("123") }.to raise_parse_error
      expect { subject.parse("foo") }.to raise_parse_error
      expect { subject.parse("_WOAH") }.to raise_parse_error
    end
  end

  describe '#identifier' do
    subject { described_class.new.identifier }

    it "should parse correctly" do
      expect { subject.parse("a") }.not_to raise_error
      expect { subject.parse("this") }.not_to raise_error
      expect { subject.parse("fooBar") }.not_to raise_error
      expect { subject.parse("t1000") }.not_to raise_error
      expect { subject.parse("time") }.not_to raise_error
      expect { subject.parse("foo_bar") }.not_to raise_error
      expect { subject.parse("_baz12") }.not_to raise_error

      expect { subject.parse("123") }.to raise_parse_error
      expect { subject.parse("FOO") }.to raise_parse_error
    end
  end

  describe '#namespace' do
    subject { described_class.new.namespace }

    it "should parse correctly" do
      expect { subject.parse("A") }.not_to raise_error
      expect { subject.parse("This") }.not_to raise_error
      expect { subject.parse("FooBar") }.not_to raise_error
      expect { subject.parse("T1000") }.not_to raise_error
      expect { subject.parse("TIME") }.not_to raise_error
      expect { subject.parse("FOO_BAR") }.not_to raise_error
      expect { subject.parse("A::B") }.not_to raise_error
      expect { subject.parse("This::That") }.not_to raise_error
      expect { subject.parse("FooBar::BarBaz") }.not_to raise_error
      expect { subject.parse("T1000::LOL123") }.not_to raise_error

      # TODO: These /should/ raise an error if TIME isn't a module or class
      expect { subject.parse("TIME::FOO") }.not_to raise_error
      expect { subject.parse("FOO_BAR::BAR_BAZ") }.not_to raise_error

      expect { subject.parse("123") }.to raise_parse_error
      expect { subject.parse("foo") }.to raise_parse_error
      expect { subject.parse("_WOAH") }.to raise_parse_error
      expect { subject.parse("123::321") }.to raise_parse_error
      expect { subject.parse("foo::bar") }.to raise_parse_error
      expect { subject.parse("_WOAH::_FOO") }.to raise_parse_error
    end
  end

  describe '#module_keyword' do
    subject { described_class.new.module_keyword }

    it "should parse correctly" do
      expect { subject.parse("module A") }.not_to raise_error
      expect { subject.parse("module This") }.not_to raise_error
      expect { subject.parse("module FooBar") }.not_to raise_error
      expect { subject.parse("module T1000") }.not_to raise_error
      expect { subject.parse("module TIME") }.not_to raise_error
      expect { subject.parse("module FOO_BAR") }.not_to raise_error
      expect { subject.parse("module A::B") }.not_to raise_error
      expect { subject.parse("module This::That") }.not_to raise_error
      expect { subject.parse("module FooBar::BarBaz") }.not_to raise_error
      expect { subject.parse("module T1000::LOL123") }.not_to raise_error

      expect { subject.parse("module 123") }.to raise_parse_error
      expect { subject.parse("module foo") }.to raise_parse_error
      expect { subject.parse("module _WOAH") }.to raise_parse_error
      expect { subject.parse("module 123::321") }.to raise_parse_error
      expect { subject.parse("module foo::bar") }.to raise_parse_error
      expect { subject.parse("module _WOAH::_FOO") }.to raise_parse_error
      expect { subject.parse("class FooBar") }.to raise_parse_error
      expect { subject.parse("class FooBar::BarBaz") }.to raise_parse_error
      expect { subject.parse("123") }.to raise_parse_error
      expect { subject.parse("foo") }.to raise_parse_error
      expect { subject.parse("FOO") }.to raise_parse_error
      expect { subject.parse("FOO::BAR") }.to raise_parse_error
      expect { subject.parse("Foo::Bar") }.to raise_parse_error
    end
  end

  describe '#class_keyword' do
    subject { described_class.new.class_keyword }

    it "should parse correctly" do
      expect { subject.parse("class A") }.not_to raise_error
      expect { subject.parse("class This") }.not_to raise_error
      expect { subject.parse("class FooBar") }.not_to raise_error
      expect { subject.parse("class T1000") }.not_to raise_error
      expect { subject.parse("class TIME") }.not_to raise_error
      expect { subject.parse("class FOO_BAR") }.not_to raise_error
      expect { subject.parse("class A::B") }.not_to raise_error
      expect { subject.parse("class This::That") }.not_to raise_error
      expect { subject.parse("class FooBar::BarBaz") }.not_to raise_error
      expect { subject.parse("class T1000::LOL123") }.not_to raise_error
      expect { subject.parse("class This < That") }.not_to raise_error
      expect { subject.parse("class This::That < FooBar") }.not_to raise_error

      expect { subject.parse("class 123") }.to raise_parse_error
      expect { subject.parse("class foo") }.to raise_parse_error
      expect { subject.parse("class _WOAH") }.to raise_parse_error
      expect { subject.parse("class 123::321") }.to raise_parse_error
      expect { subject.parse("class foo::bar") }.to raise_parse_error
      expect { subject.parse("class _WOAH::_FOO") }.to raise_parse_error
      expect { subject.parse("module FooBar") }.to raise_parse_error
      expect { subject.parse("module FooBar::BarBaz") }.to raise_parse_error
      expect { subject.parse("123") }.to raise_parse_error
      expect { subject.parse("foo") }.to raise_parse_error
      expect { subject.parse("FOO") }.to raise_parse_error
      expect { subject.parse("FOO::BAR") }.to raise_parse_error
      expect { subject.parse("Foo::Bar") }.to raise_parse_error
    end
  end

  describe '#include_keyword' do
    subject { described_class.new.include_keyword }

    it "should parse correctly" do
      expect { subject.parse("include A") }.not_to raise_error
      expect { subject.parse("include This") }.not_to raise_error
      expect { subject.parse("include FooBar") }.not_to raise_error
      expect { subject.parse("include T1000") }.not_to raise_error
      expect { subject.parse("include TIME") }.not_to raise_error
      expect { subject.parse("include FOO_BAR") }.not_to raise_error
      expect { subject.parse("include A::B") }.not_to raise_error
      expect { subject.parse("include This::That") }.not_to raise_error
      expect { subject.parse("include FooBar::BarBaz") }.not_to raise_error
      expect { subject.parse("include T1000::LOL123") }.not_to raise_error

      expect { subject.parse("include 123") }.to raise_parse_error
      expect { subject.parse("include foo") }.to raise_parse_error
      expect { subject.parse("include _WOAH") }.to raise_parse_error
      expect { subject.parse("include 123::321") }.to raise_parse_error
      expect { subject.parse("include foo::bar") }.to raise_parse_error
      expect { subject.parse("include _WOAH::_FOO") }.to raise_parse_error
      expect { subject.parse("extend FooBar") }.to raise_parse_error
      expect { subject.parse("extend FooBar::BarBaz") }.to raise_parse_error
      expect { subject.parse("123") }.to raise_parse_error
      expect { subject.parse("foo") }.to raise_parse_error
      expect { subject.parse("FOO") }.to raise_parse_error
      expect { subject.parse("FOO::BAR") }.to raise_parse_error
      expect { subject.parse("Foo::Bar") }.to raise_parse_error
    end
  end

  describe '#extend_keyword' do
    subject { described_class.new.extend_keyword }

    it "should parse correctly" do
      expect { subject.parse("extend A") }.not_to raise_error
      expect { subject.parse("extend This") }.not_to raise_error
      expect { subject.parse("extend FooBar") }.not_to raise_error
      expect { subject.parse("extend T1000") }.not_to raise_error
      expect { subject.parse("extend TIME") }.not_to raise_error
      expect { subject.parse("extend FOO_BAR") }.not_to raise_error
      expect { subject.parse("extend A::B") }.not_to raise_error
      expect { subject.parse("extend This::That") }.not_to raise_error
      expect { subject.parse("extend FooBar::BarBaz") }.not_to raise_error
      expect { subject.parse("extend T1000::LOL123") }.not_to raise_error

      expect { subject.parse("extend 123") }.to raise_parse_error
      expect { subject.parse("extend foo") }.to raise_parse_error
      expect { subject.parse("extend _WOAH") }.to raise_parse_error
      expect { subject.parse("extend 123::321") }.to raise_parse_error
      expect { subject.parse("extend foo::bar") }.to raise_parse_error
      expect { subject.parse("extend _WOAH::_FOO") }.to raise_parse_error
      expect { subject.parse("include FooBar") }.to raise_parse_error
      expect { subject.parse("include FooBar::BarBaz") }.to raise_parse_error
      expect { subject.parse("123") }.to raise_parse_error
      expect { subject.parse("foo") }.to raise_parse_error
      expect { subject.parse("FOO") }.to raise_parse_error
      expect { subject.parse("FOO::BAR") }.to raise_parse_error
      expect { subject.parse("Foo::Bar") }.to raise_parse_error
    end
  end

  describe '#def_keyword' do
    subject { described_class.new.def_keyword }

    it "should parse correctly" do
      expect { subject.parse("def a") }.not_to raise_error
      expect { subject.parse("def this") }.not_to raise_error
      expect { subject.parse("def fooBar") }.not_to raise_error
      expect { subject.parse("def t1000") }.not_to raise_error
      expect { subject.parse("def time") }.not_to raise_error
      expect { subject.parse("def foo_bar") }.not_to raise_error
      expect { subject.parse("def _baz12") }.not_to raise_error
      expect { subject.parse("def test(thing)") }.not_to raise_error
      expect { subject.parse("def foo(bar=123)") }.not_to raise_error
      expect { subject.parse("def foo(bar=baz)") }.not_to raise_error
      expect { subject.parse("def foo(bar=BAZ)") }.not_to raise_error

      expect { subject.parse("def 123") }.to raise_parse_error
      expect { subject.parse("def FOO") }.to raise_parse_error
      expect { subject.parse("def 123(foobar=123)") }.to raise_parse_error
      expect { subject.parse("def FOO(foobar=123)") }.to raise_parse_error
    end
  end

  describe '#keyword' do
    subject { described_class.new.keyword }

    it "should parse correctly" do
      expect { subject.parse("module Foo") }.not_to raise_error
      expect { subject.parse("class Foo") }.not_to raise_error
      expect { subject.parse("include Foo") }.not_to raise_error
      expect { subject.parse("extend Foo") }.not_to raise_error
      expect { subject.parse("def foo") }.not_to raise_error

      expect { subject.parse("") }.to raise_parse_error
      expect { subject.parse("    ") }.to raise_parse_error
      expect { subject.parse("\r") }.to raise_parse_error
      expect { subject.parse("\r\n") }.to raise_parse_error
      expect { subject.parse("\n") }.to raise_parse_error
      expect { subject.parse("\r\t   \t") }.to raise_parse_error
    end
  end

  describe '#parse' do
    subject { described_class.new }

    it "should parse correctly" do
      expect { subject.parse("module Foo") }.not_to raise_error
      expect { subject.parse("class Foo") }.not_to raise_error
      expect { subject.parse("include Foo") }.not_to raise_error
      expect { subject.parse("extend Foo") }.not_to raise_error
      expect { subject.parse("def foo") }.not_to raise_error
      expect { subject.parse("") }.not_to raise_error
      expect { subject.parse("    ") }.not_to raise_error
      expect { subject.parse("\r") }.not_to raise_error
      expect { subject.parse("\r\n") }.not_to raise_error
      expect { subject.parse("\n") }.not_to raise_error
      expect { subject.parse("\r\t   \t") }.not_to raise_error
    end
  end
end
