namespace :i18n do

  desc "List current locales"
  task :locales => :environment do
    puts I18n.load_path.collect { |i| i.split('/').last }.uniq!.join(', ')
  end

  desc "Generate locales"
  task :generate_locales => :environment do
    puts "TODO"
  end

  desc "Update translations"
  task :update => :environment do
    I18n.update_translations
  end

  desc "Missing translations"
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

  desc "Autofille missing translations"
  task :autofill => :environment do
    Dir["#{Rails.root}/config/locales/*.yml"].each do |file|
      basename = File.basename(file, ".yml")
      missing = ["- #{file}"]
      content = YAML.load_file(file)
      content[basename].each do |key, value|
        value = key if value.empty?
      end
      File.open(file, 'w+') { |f| f.write(content.to_yaml) }
    end
  end

end