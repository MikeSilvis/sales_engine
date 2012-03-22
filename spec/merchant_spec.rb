require 'sales_engine/merchant'
require 'sales_engine/model'

describe Merchant do 
  let(:merchants) do 
    Merchant.all
  end
  let(:merchant) do 
    Merchant.find_by_name("Zulauf, O'Kon and Hickle")
  end

  context "has_many assocations" do
    it "returns a collection of items" do
      merchant.items.should_not be_nil
    end
    it "returns a collection of invoices" do
      merchant.invoices.should_not be_nil
    end
  end

end