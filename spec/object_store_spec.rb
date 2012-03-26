require 'sales_engine/object_store'
include SalesEngine

describe ObjectStore do
  let(:items) do
    (0..9).map do |n|
      stub("item #{n}", :id => n, :even => n.even?)
    end
  end

  let(:store) { ObjectStore.new.tap { |store| store.merge(items) } }

  it "items are accessable" do
    store.items.should == items
  end

  it "finds via index correctly" do
    store.find_indexed("even", true).should == items.select(&:even)
  end

  it "finds without index correctly" do
    store.find_unindexed("even", true).should == items.select(&:even)
  end

  context "index invalidation" do
    it "query first, then change attribute" do
      store.find_indexed("even", true)

      item5 = items.find {|i| i.id == 5}
      item5.even == true

      store.find_indexed("even", true).should == items.select(&:even)
      store.find_indexed("even", false).should == items.reject(&:even)
    end

    it "query first, then add item" do
      store.find_indexed("even", true)

      item10 = stub("item 10", :id => 10, :even => true)
      store << item10

      store.find_indexed("even", true).should == items.select(&:even) + [item10]
      store.find_indexed("even", false).should == items.reject(&:even)
    end
  end
end
