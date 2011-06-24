class String
    def to_eqv_sym
        string = self
        string = string.downcase.gsub(' ', '_')
        string = string.delete(":")
        symbol = string.to_sym
    end
end

class Symbol
    def to_eqv_s
        symbol = self
        string = ":" + symbol.to_s
    end
end	