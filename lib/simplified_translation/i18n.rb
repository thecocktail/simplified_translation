I18n.load_path += Dir[ File.join(RAILS_ROOT, 'config', 'locales', '*.{rb,yml}') ]

module I18n

  def self.extract_messages(folders = Dir["{app,lib}/**/*.{rb,rhtml,erb,rjs}"])
    content = []
    folders.map do |f|
      content << File.read(f).scan(/.*[^\w]t\s*[\"\'](.*?)[\"\']/)
      content << File.read(f).scan(/.*[^\w]translate\s*[\"\'](.*?)[\"\']/)
    end
    return content.uniq.flatten
  end

  def self.update_locales(folder = "#{RAILS_ROOT}/config/locales")
    content = {}
    extract_messages.each { |c| content[c] = nil }
    Dir[ File.join(folder, '*.yml') ].each do |file|
      locale = File.basename(file, '.yml')
      hsh = YAML.load_file(file) || {}
      hsh = { locale => {} } if hsh[locale].nil?
      hsh_to_merge = { locale => content }
      hsh_to_merge[locale].merge!(hsh[locale])
      File.open(file, 'w+') { |f| f.write(hsh_to_merge.to_yaml) }
    end
  end

  def self.missing_locales(folder = "#{RAILS_ROOT}/config/locales")
    Dir[ File.join(folder, '*.yml') ].each do |file|
      basename = File.basename(file, ".yml")
      missing = ["[#{file}]"]
      content = YAML.load_file(file)
      content[basename].each do |key, value|
        missing << "- #{key}" if value.nil? || value.empty?
      end
      puts missing.join("\n") unless missing.size == 1
    end
  end

  def self.autofill_locales(folder = "#{RAILS_ROOT}/config/locales")
    Dir[ File.join(folder, '*.yml') ].each do |file|
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