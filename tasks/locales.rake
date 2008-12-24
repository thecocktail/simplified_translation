namespace :locales do

  desc "List current locales"
  task :list => :environment do
    puts I18n.load_path.collect { |i| i.split('/').last }.uniq!.join(', ')
  end

  desc "Update locale files"
  task :update => :environment do
    I18n.update_locales
  end

  desc "List missing translation strings"
  task :missing => :environment do
    I18n.missing_locales
  end

  desc "Autofill missing translations"
  task :autofill => :environment do
    I18n.autofill_locales
  end

end