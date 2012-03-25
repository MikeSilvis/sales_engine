require 'sales_engine/lazy_value'

class String
  def constantize
    split("::").reject(&:empty?).inject(Module) do |mod, str|
      mod.const_get(str)
    end
  end

  def deconstantize
    split("::").reject(&:empty?)[0..-2].join("::")
  end

  def tableize
    word = self
    word = word.gsub(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
    word = word.gsub(/([a-z\d])([A-Z])/,'\1_\2')
    word.downcase.pluralize
  end

  def pluralize
    if end_with?("ss")
      self + "es"
    else
      self + "s"
    end
  end

  def depluralize
    if end_with?("sses")
      gsub(/es$/, '')
    else
      gsub(/s$/, '')
    end
  end

  def camelize
    gsub(/[a-z\d]*/, &:capitalize).gsub('_', '')
  end
end

class Object
  def lazy(&block)
    LazyValue.new do
      block.call
    end
  end
end

module Enumerable
  def sum(&block)
    if block
      inject(0) {|sum, n| sum + block.call(n)}
    else
      inject(&:+)
    end
  end
end

class DateTime
  def to_date
    Date.new(year, month, day)
  end
end
