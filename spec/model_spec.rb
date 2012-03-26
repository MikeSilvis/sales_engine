require 'sales_engine/model'
include SalesEngine

module TestNamespace
  class Invoice
    include Model

    has_many :invoice_items
    has_many :items, :through => :invoice_items
    field :indexable
    attr_accessor :unindexable
  end

  class InvoiceItem
    include Model

    belongs_to :invoice
    belongs_to :item
  end

  class Item
    include Model

    has_many :invoice_items
    has_many :invoices, :through => :invoice_items
  end
end

describe Model do
  before do
    TestNamespace::Invoice.delete_all
    TestNamespace::InvoiceItem.delete_all
    TestNamespace::Item.delete_all
  end

  context "#new" do
    it "#new does not add to collection" do
      invoice = TestNamespace::Invoice.new
      TestNamespace::Invoice.all.should be_empty
    end

    it "#new does not set #id" do
      invoice = TestNamespace::Invoice.new
      invoice.id.should be_nil
    end

    context ".create" do
      it "returns a new saved record" do
        invoice = TestNamespace::Invoice.create
        TestNamespace::Invoice.all.include?(invoice).should == true
      end
    end
  end

  context "querying" do
    it "find_by_id" do
      (0..10).each { |n| TestNamespace::Invoice.create(unindexable: n.to_s) }
      TestNamespace::Invoice.find_by_id(5).unindexable.should == "5"
    end

    it "find_all_by_id" do
      (0..10).each { |n| TestNamespace::Invoice.create(note: n.even?) }
      found = TestNamespace::Invoice.find_all_by_note(true)
      found.map(&:id).should == [0,2,4,6,8,10]
    end

    it ""
  end

  context "#save" do
    it "sets created_at and updated_at" do
      now = DateTime.now
      DateTime.stub(:now => now)

      invoice = TestNamespace::Invoice.new
      invoice.save

      # TODO: WTF? Why can't I compare DateTime's in a sane manner?
      invoice.created_at.to_time.to_i.should == now.to_time.to_i
      invoice.updated_at.to_time.to_i.should == now.to_time.to_i
    end

    it "adds to collection" do
      invoice = TestNamespace::Invoice.new
      invoice.save

      TestNamespace::Invoice.all.include?(invoice).should == true
    end

    it "sets a new id" do
      invoice = TestNamespace::Invoice.new
      invoice.save
      invoice.id.should == 0

      invoice = TestNamespace::Invoice.new
      invoice.save
      invoice.id.should == 1
    end
  end
end
