require 'sales_engine/item'
require 'sales_engine/model'

describe Merchant do
  let(:items) do
    Item.all
  end
  let(:item) do
    Item.find_by_id(1)
  end

  context "belongs_to assocation" do
    it "returns an instance of an invoice item" do
      item.invoice_item.should_not be_nil
    end
    it "returns an instance of merchant" do
      item.merchant.should_not be_nil
    end
  end
end
