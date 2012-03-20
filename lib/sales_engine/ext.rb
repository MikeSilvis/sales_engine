class String
  def constantize
    split("::").reject(&:empty?).inject(Module) do |mod, str|
      mod.const_get(str)
    end
  end

  def deconstantize
    split("::").reject(&:empty?)[0..-2].join("::")
  end
end
