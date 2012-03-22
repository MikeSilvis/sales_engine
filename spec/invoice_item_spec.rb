require 'sales_engine/invoice_item'
require 'sales_engine/model'

describe InvoiceItem do
  let(:invoice_items) do
    InvoiceItem.all
  end
  let(:invoice_item) do
    InvoiceItem.find_by_id(1)
  end

  context "belongs_to assocations" do
    it "returns an instance of an invoice" do
      invoice_item.invoice.merchant_id.should == 92
    end
    it "returns an instance of an item" do
      invoice_item.item.name.should == "Item Repellat Ratione"
    end
  end

end
