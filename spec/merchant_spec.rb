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
    it "returns aq collection of items" do
      merchant.items.should_not be_nil
    end
    it "returns a collection of invoices" do
      merchant.invoices.should_not be_nil
    end
  end

  context "Business Intelligence... (According to Jeff)" do
    it ".most_revenue(x)" do
      Merchant.most_revenue(2).should_not be_nil
    end
    it ".most_items(x)" do
      Merchant.most_items(2).should_not be_nil
    end
    it ".revenue(date)" do
      date = DateTime.parse("2012-02-14 20:56:56 UTC")
      Merchant.revenue(date)
    end
    it "#revenue" do
      merchant.revenue.should_not be_nil
    end
    it "#revenue(date)" do 
      date = DateTime.parse("2012-02-14 20:56:56 UTC")
      merchant.revenue(date)
    end
    it "#favorite_customer" do
      merchant.favorite_customer.should_not be_nil
    end
    it "#customers_with_pending_invoices" do
      merchant.customers_with_pending_invoices.should_not be_nil
    end
  end
  context "Extensions" do 
    it ".dates_by_revenue" do 
      merchant.dates_by_revenue.should_not be_nil
    end
  end

end