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
    scan(/[A-Z][a-z]+/).map(&:downcase).join("_").pluralize
  end
  
  def depluralize
    if self =~ /sses$/
      gsub(/sses$/, 'ss')
    else
      gsub(/s$/, '')
    end
  end

  def pluralize
    if self =~ /ess$/
      self + "es"
    else
      self + "s"
    end
  end  
end
