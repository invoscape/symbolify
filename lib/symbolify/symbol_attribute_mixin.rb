module SymbolAttributeMixin
    #--- Trigger when include to a model
    private
    def self.included(base)
        #--- Add a method for symbol_attribute inside the model
        private
        def base.symbol_attribute(*attributes)
            attributes.each do |attribute|
                create_methods_for_symbol_attribute(attribute.to_s)
            end
        end
        
        def base.create_methods_for_symbol_attribute(attribute_name)
            self.class_eval do
                #--- Create methods for the symbol attribute
                # Try someother better method than eval %Q{ } to include these methods into the class
                # Check the error with missing attribute. https://rails.lighthouseapp.com/projects/8994/tickets/3165-activerecordmissingattributeerror-after-update-to-rails-v-234
                # Only so, we have used the read_attribute and write_attribute
                eval %Q{
                    def #{attribute_name}
                    	value_from_db = read_attribute("#{attribute_name}_symbol".to_sym)
                    	
                        return nil if value_from_db.nil?
                    
                        return value_from_db.to_eqv_sym
                    end
                    
                    def #{attribute_name}=(value)
                        if value.nil?
                            write_attribute("#{attribute_name}_symbol".to_sym, nil)
                            return
                        end
                        
                        raise "The value for this symbol attribute must be a symbol only" if not value.is_a? Symbol
                        
                        write_attribute("#{attribute_name}_symbol".to_sym, value.to_eqv_s)
                    end
                }
            end
        end
    end
end