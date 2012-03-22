require 'set'

module SalesEngine
  class ObjectStore
    def initialize
      @items = Set.new
      @caches_by_attribute = Hash.new
      @sets_containing_item = Hash.new([])
    end

    def update(item)
      @items << item
      remove_item_from_cached_sets(item)
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

    def find_cached(attribute, value)
      set = cache_for(attribute.to_sym)[value]
      set.to_a
    end

    def find_uncached(attribute, value)
      @items.select do |item|
        item.send(attribute) == value
      end
    end

    private

    def cache_for(attribute)
      @caches_by_attribute[attribute] ||= generate_cache_for_attribute(attribute)
    end

    def remove_item_from_cached_sets(item)
      @sets_containing_item[item].each do |set|
        set.delete(item)
      end

      @sets_containing_item.delete(item)
    end

    def add_item_to_cached_sets(item)
      cached_attributes.each do |attribute|
        value = item.send(attribute)
        cache = cache_for(attribute)
        set = (cache[value] ||= Set.new)
        set << value
        @sets_containing_item[item] << set
      end
    end

    def generate_cache_for_attribute(attribute)
      cache = items.group_by(&attribute)
      cache.keys.each do |key|
        set = cache[key] = Set.new(cache[key])
        set.each do |item|
          @sets_containing_item[item] << set
        end
      end

      cache
    end

    def cached_attributes
      @caches_by_attribute.keys
    end
  end
end
