require 'sales_engine/ext'

describe String do

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

  it "#constantize" do
    "Module::Object".constantize.should == Object
  end

  it "#tableize" do
    "InvoiceItem".tableize.should == "invoice_items"
  end

  it "#depluralize" do
    "Leases".depluralize.should == "Lease"
  end
end
