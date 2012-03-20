require 'sales_engine/ext'

describe String do
  it "#constantize" do
    "Module::Object".constantize.should == Object
  end
end
