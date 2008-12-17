I18n.load_path += Dir[ File.join(RAILS_ROOT, 'config', 'locales', '*.{rb,yml}') ]

module I18n

  def self.extract(folders = Dir["{app,lib}/**/*.{rb,rhtml,erb,rjs}"])
    content = []
    folders.map do |f|
      content << File.read(f).scan(/.*[^\w]t\s*[\"\'](.*?)[\"\']/)
      content << File.read(f).scan(/.*[^\w]translate\s*[\"\'](.*?)[\"\']/)
    end
    return content.uniq.flatten
  end

  def self.update_translations(locale_folder = "#{RAILS_ROOT}/config/locales" )
    content = {}
    extract.each { |c| content[c] = nil }
    Dir[ File.join(locale_folder, '*.yml') ].each do |file|
      locale = File.basename(file, '.yml')
      hsh = YAML.load_file(file) || {}
      hsh = { locale => {} } if hsh[locale].nil?
      hsh_to_merge = { locale => content }
      hsh_to_merge[locale].merge!(hsh[locale])
      File.open(file, 'w+') { |f| f.write(hsh_to_merge.to_yaml) }
    end
  end

end