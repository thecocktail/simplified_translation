# Simplified Translation

The main idea of this plugin is to keep all field translations on the 
same table. I've worked with other Rails plugins but all of them have 
some caveats, and I needed something really simple.

With the release of Rails 2.2.X, with the I18n integrated now it's 
easier to translate an Rails application, GetText is no longer needed. 
So I've added a few tasks which allow to extract translatable text 
from the models, views and controllers.

    fesplugas@sueisfine:test_i18n $ rake -T i18n
    (in /home/fesplugas/projects/simplified_plugins)
    rake i18n:autofill  # Autofill missing translations
    rake i18n:locales   # List current locales
    rake i18n:missing   # List missing translation strings
    rake i18n:update    # Update translations files

## Quick explanation

We have a page model with the following attributes.

    Page: title_en, title_cat, title_es

By default Rails defines the current locale as `:en` and the default 
locale to `:en`. If we add "translate :title" to our model we can get 
the content of the attribute without defining the locale, and we'll 
get the localized field.

    @page_title = Page.find(:first).title

We can change the locale with `I18n.locale`.

    I18n.locale = :cat
    @page_title = Page.find(:first).title

And we'll get the `title` attribute of the defined locale.

## Large example

    ##
    # app/views/welcome/index.html.erb
    #
    <%=t "Today is {{value}}.", :value => Date.today %>

    ##
    # app/controllers/welcome_controller.rb
    #
    class WelcomeController < ApplicationController

      def index
        @text = translate "Today is {{value}}.", :value => Date.today
      end

    end

    ##
    # app/controllers/application.rb
    #
    class ApplicationController < ActionController::Base

      before_filter :set_locale

      def set_locale
        I18n.locale = params[:locale] || 'es'
      end

    end

### Sample migration

    class CreatePages < ActiveRecord::Migration

      def self.up
        create_table :pages do |t|
          t.string :title_en, :null => false
          t.string :title_es, :null => false
          t.string :title_cat, :null => false
          t.text :content_en, :null => false
          t.text :content_es, :null => false
          t.text :content_cat, :null => false
          t.boolean :status, :null => false, :default => false
        end
      end

      def self.down
        drop_table :pages
      end

    end

### Model definition

    ##
    # app/models/page.rg
    #
    class Page < ActiveRecord::Base
      translate :title, :body
    end

## Usage from the console

    $ script/console
    Loading development environment (Rails 2.2.2)
    >> I18n.default_locale
    => :en
    >> I18n.locale
    => :en
    >> Page.first.title
    => "Hello World"
    >> I18n.locale = :es
    => :es
    >> Page.first.title
    => "Hola Mundo"
    >> Page.first.update_attributes :title => "Hola Mundo"
    => true
    >> Page.first.title
    => "Hola Mundo"
    >> I18n.locale = :undefined
    => :undefined
    >> Page.first.title
    => "Hello World"    <== Because is the default locale

Copyright (c) 2008 Francesc Esplugas Marti, released under the MIT license