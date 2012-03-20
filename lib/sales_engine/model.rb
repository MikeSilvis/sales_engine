module SalesEngine
  module Model
    def self.included(base)
      base.extend(ModelClassMethods)
    end

    def id
      # TODO
    end

    module ModelClassMethods
      def has_many(attr)
        [name, attr.to_s.deconstantize].join("::").constantize
      end
    end
  end
end
