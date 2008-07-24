module SimplifiedTranslation

  @@options = { :locale => 'en' }

  mattr_reader :options

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def translate(*options)

      columns = []

      options.each do |option|
        columns << option if option.is_a? Symbol
      end

      mod = Module.new do |m|
        columns.each do |column|
          define_method("#{column}") do
            lang = GetText.locale.language
            begin
              send("#{column}_#{lang}").empty? ? send("#{column}_#{SimplifiedTranslation.options[:locale]}") : send("#{column}_#{lang}")
            rescue
              send("#{column}_#{SimplifiedTranslation.options[:locale]}")
            end
          end
        end
      end

      include mod

    end

  end

end

ActiveRecord::Base.send :include, SimplifiedTranslation