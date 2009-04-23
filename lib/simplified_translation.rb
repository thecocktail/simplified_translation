module SimplifiedTranslation

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

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

    end

  end

end

ActiveRecord::Base.send :include, SimplifiedTranslation