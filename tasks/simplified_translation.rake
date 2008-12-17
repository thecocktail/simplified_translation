namespace :i18n do

  desc "List current locales"
  task :locales => :environment do
    puts I18n.load_path.collect { |i| i.split('/').last }.uniq!.join(', ')
  end

  desc "Update translations files"
  task :update => :environment do
    I18n.update_translations
  end

  desc "List missing translation strings"
  task :missing => :environment do
    Dir["#{Rails.root}/config/locales/*.yml"].each do |file|
      basename = File.basename(file, ".yml")
      missing = ["[#{file}]"]
      content = YAML.load_file(file)
      content[basename].each do |key, value|
        missing << "- #{key}" if value.empty?
      end
      puts missing.join("\n") unless missing.size == 1
    end
  end

  desc "Autofill missing translations"
  task :autofill => :environment do
    Dir["#{Rails.root}/config/locales/*.yml"].each do |file|
      basename = File.basename(file, ".yml")
      missing = ["[#{file}]"]
      content = YAML.load_file(file)
      content[basename].each do |key, value|
        if value.nil?
          missing << "- #{key} (autofilled)"
          content[basename][key] = key
        end
      end
      puts missing.join("\n") unless missing.size == 1
      File.open(file, 'w+') { |f| f.write(content.to_yaml) }
    end
  end

end