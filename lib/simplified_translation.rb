module SimplifiedTranslation
    module Translated
      def self.included(base)
        base.extend(ActsMethods)
      end

      module ActsMethods

        def translate(*args)
          args.each do |arg|
            define_method(arg.to_s) do
              attribute = "#{arg}_#{I18n.locale}"
              default_attribute = "#{arg}_#{I18n.default_locale}"
              begin
                return send(attribute).empty? ? send(default_attribute) : send(attribute)
              rescue
                return send(default_attribute)
              end
            end

            define_method(arg.to_s + '=') do |data|
              attribute = "#{arg}_#{I18n.locale}"
              write_attribute attribute, data if self.respond_to? attribute
            end

          end
          extend ClassMethods
        end # translate

        module ClassMethods
        
        def method_missing(method, *args)
          if method.to_s =~ /^find_(all_by|by)_([_a-zA-Z]\w*)$/
            if column_methods_hash.include?($2.to_sym)
              super
            else
              modifier = $1
              attribute = "#{$2}_#{I18n.locale.to_s}"
              send("find_#{modifier}_#{attribute}".to_sym, args)
            end
          end
        end 
        end 
      end 
    end 
end 

ActiveRecord::Base.send :include, SimplifiedTranslation::Translated
