module SimplifiedTranslation

  @@default_locale = 'en'
  mattr_accessor :default_locale

  @@locale = 'en'
  mattr_accessor :locale

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def translate(*args)

      args.each do |arg|

        define_method(arg.to_s) do
          attribute = "#{arg}_#{SimplifiedTranslation.locale}"
          default_attribute = "#{arg}_#{SimplifiedTranslation.default_locale}"
          begin
            return send(attribute).empty? ? send(default_attribute) : send(attribute)
          rescue
            return send(default_attribute)
          end
        end

        define_method(arg.to_s + "=") do |data|
          attribute = "#{arg}_#{SimplifiedTranslation.locale}"
          write_attribute attribute, data if self.respond_to? attribute
        end

      end

    end

  end

end

ActiveRecord::Base.send :include, SimplifiedTranslation