require 'action_view/helpers/tag_helper'

module ActionView

  module Helpers

    module TranslationHelper

      def translate(key, options = {})
        options[:raise] = true
        I18n.translate(key, options)
      rescue I18n::MissingTranslationData => e
        keys = I18n.send(:normalize_translation_keys, e.locale, e.key, e.options[:scope])
        !Rails.env.production? ? content_tag('span', keys.join(', '), :class => 'translation_missing') : key
      end

      alias :t :translate

      def localize(*args)
        I18n.localize *args
      end

      alias :l :localize

    end

  end

end