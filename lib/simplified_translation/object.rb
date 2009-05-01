class Object

  def _(msg, *args)
    options = args.extract_options!
    options[:default] = msg
    I18n.t(msg, options)
  end

end