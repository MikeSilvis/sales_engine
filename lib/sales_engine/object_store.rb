require 'set'

module SalesEngine
  class ObjectStore
    def initialize
      @items = Set.new
      @index_by_attribute = Hash.new
      @sets_containing_item = Hash.new([])
    end

    def update(item)
      @items << item
      remove_item_from_index_sets(item)
      add_item_to_cached_sets(item)
    end

    alias :<< :update

    def merge(items)
      items.each do |item|
        update(item)
      end
    end

    def items
      @items.to_a
    end

    def find_indexed(attribute, value)
      set = index_for(attribute.to_sym)[value]
      set.to_a
    end

    def find_unindexed(attribute, value)
      @items.select do |item|
        item.send(attribute) == value
      end
    end

    def clear
      @items = Set.new
      @index_by_attribute = Hash.new
      @sets_containing_item = Hash.new([])
    end

    private

    def index_for(attribute)
      @index_by_attribute[attribute] ||=
        generate_cache_for_attribute(attribute)
    end

    def remove_item_from_index_sets(item)
      @sets_containing_item[item].each do |set|
        set.delete(item)
      end

      @sets_containing_item.delete(item)
    end

    def add_item_to_cached_sets(item)
      indexed_attributes.each do |attribute|
        value = item.send(attribute)
        index = index_for(attribute)
        set = (index[value] ||= Set.new)
        set << item
        @sets_containing_item[item] << set
      end
    end

    def generate_cache_for_attribute(attribute)
      if indexed_attributes.include?(attribute)
        raise "An index already exists for #{attribute}"
      end

      cache = items.group_by(&attribute)
      cache.keys.each do |key|
        set = cache[key] = Set.new(cache[key])
        set.each do |item|
          @sets_containing_item[item] << set
        end
      end

      cache
    end

    def indexed_attributes
      @index_by_attribute.keys
    end
  end
end
