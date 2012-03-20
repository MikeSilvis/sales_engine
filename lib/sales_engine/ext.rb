class String
  def constantize
    self.split("::").inject(Module) do |mod, str|
      mod.const_get(str)
    end
  end

  def deconstantize
    #self.
  end
end
