require 'sales_engine/item'
require 'sales_engine/model'

describe Item do
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

  context "Business intelligence (According to Jeff...)" do
    it ".most_revenue(x)" do
      Item.most_revenue(2).should_not be_nil
    end
    it ".most_items(x)" do
      Item.most_items(2).should_not be_nil
    end
    it "#best_day" do
      item.best_day
    end

  end

end
