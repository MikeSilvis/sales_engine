require 'sales_engine/ext'

describe String do
  it "#constantize" do
    "Module::Object".constantize.should == Object
  end

  expected_constant = %w{
    ::Foo::Bar      Foo
    ::Foo::Bar::Baz Foo::Bar
  }
  expected_constant += ["::Foo", ""]

  expected_constant.each_slice(2) do |constant, expected|
    it "#deconstantize #{constant} #{expected}" do
      constant.deconstantize.should == expected
    end
  end
end
