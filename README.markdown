# Simplified Translation

The main idea of this plugin is to keep all field translations on the 
same table. I've worked with other Rails plugins but all of them have 
some caveats, and I needed something really simple.

## Configuration

You can define a default locale so if the language is not defined 
you'll get this field as the translation.

    SimplifiedTranslation.default_locale = 'es'
    SimplifiedTranslation.locale = 'es'

By default `locale` is set to `en`, you can override this settings 
using an initializer.

## Example

### Integration with Typus

    Page:
      fields:
        list: title
        form: title_en, title_es, title_cat, content_en, content_es, content_cat

### Migration

    class CreatePages < ActiveRecord::Migration

      def self.up
        create_table :pages do |t|
          t.column :title_en, :string, :default => "", :null => false
          t.column :title_es, :string, :default => "", :null => false
          t.column :title_cat, :string, :default => "", :null => false
          t.column :content_en, :text, :default => "", :null => false
          t.column :content_es, :text, :default => "", :null => false
          t.column :content_cat, :text, :default => "", :null => false
        end
      end

      def self.down
        drop_table :pages
      end

    end

### Model definition

    class Page < ActiveRecord::Base
      translate :title, :body
    end

## Usage

    $ script/console
    Loading development environment (Rails 2.1.0)
    >> SimplifiedTranslation.default_locale = 'en'
    => "en"
    >> SimplifiedTranslation.locale = 'en'
    => "en"
    >> Page.first.title
    => "Hello World"
    >> SimplifiedTranslation.locale = 'es'
    => "es"
    >> Page.first.title
    => "Hola undo"
    >> Page.first.update_attributes :title => "Hola Mundo"
    => true
    >> Page.first.title
    => "Hola Mundo"
    >> SimplifiedTranslation.locale = 'undefined'
    => "undefined"
    >> Page.first.title
    => "Hello World"      <-- Because is the default locale


Copyright (c) 2008 Francesc Esplugas Marti, released under the MIT license