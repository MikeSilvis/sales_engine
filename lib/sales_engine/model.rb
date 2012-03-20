module SalesEngine
  module Model
    def self.included(base)
      base.extend(ModelClassMethods)
    end

    module ModelClassMethods
      def has_many(attr)
        [name, attr.to_s].join("::").constantize
      end
    end
  end
end
