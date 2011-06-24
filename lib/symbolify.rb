# Symbolify
require 'symbolify/core_ext'
require 'symbolify/symbol_attribute_mixin'

class ActiveRecord::Base
	include SymbolAttributeMixin
end