module SymbolAttributeMixin
    private
    def self.included(base)
        base.class_eval do
            attr_reader :after_initialize #- This method should be defined since after_initialize is used as macro
        end
        
        #--- Bind active record callbacks (in instance level) to process symbol attributes
        base.after_initialize :load_symbol_attributes
        base.before_save :save_symbol_attributes
        base.after_save :load_symbol_attributes
        
        #--- Method for declaratively calling from a model to create an symbol attribute
        private 
        def base.symbol_attribute(attribute_name)
            #--- Store the attribute info in an array
            @symbol_attributes ||= Array.new
            @symbol_attributes.push(attribute_name)
            
            #--- Method to expose the symbol attributes list to instance methods
            private
            def self.symbol_attributes
                return @symbol_attributes
            end
        end
    end
    
    private
    def load_symbol_attributes
        return if not self.class.respond_to?(:symbol_attributes)
        
        @symbol_attributes = self.class.symbol_attributes
        
        @symbol_attributes.each do |attr_name|
            attribute_value = read_attribute(attr_name)
            
            #--- Convert string to equivalent symbol
            if attribute_value.is_a?(String)
                write_attribute(attr_name, attribute_value.to_eqv_sym)
            end
        end
    end
    
    private
    def save_symbol_attributes
        return if not self.class.respond_to?(:symbol_attributes)
        
        @symbol_attributes.each do |attr_name|
            #--- Convert from symbol to equivalent string
            write_attribute(attr_name, read_attribute(attr_name).to_eqv_s) if not read_attribute(attr_name).nil?
        end
    end
end