# Simplified Translation

The main idea of this plugin is to keep all field translations on the 
same table. I've worked with other Rails plugins but all of them have 
some caveats, and I needed something really simple.

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

    class Page < ActiveRecord::Base
      translate :title, :body
    end

## Usage

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