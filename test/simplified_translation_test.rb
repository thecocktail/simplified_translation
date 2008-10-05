require 'test/unit'
require 'rubygems'
require 'active_record'
require 'gettext'
require 'simplified_translation'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")

def setup_db

  silence_stream(STDOUT) do

    ActiveRecord::Schema.define(:version => 1) do

      ##
      # Pages Table
      #
      create_table :pages, :force => true do |t|
        t.string :title_en, :default => "", :null => false
        t.string :title_es, :default => "", :null => false
        t.text :body_en, :default => "", :null => false
        t.text :body_es, :default => "", :null => false
      end

    end

  end

end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

class Page < ActiveRecord::Base
  translate :title, :body
end

class SimplifiedTranslationTest < Test::Unit::TestCase

  def setup
    SimplifiedTranslation.default_locale = 'en'
    SimplifiedTranslation.locale = 'en'
    setup_db
    Page.create :title_en => "About", 
                :title_es => "Acerca", 
                :body_en => "Content of the page.", 
                :body_es => "Contenido de la página."
  end

  def teardown
    teardown_db
  end

  def test_should_get_title_en_of_the_page
    page = Page.find(:first)
    assert_equal page.title, page.send("title_en")
  end

  def test_should_get_title_es_of_the_page
    SimplifiedTranslation.locale = 'es'
    page = Page.find(:first)
    assert_equal page.title, page.send("title_es")
  end

  def test_should_get_body_en_of_the_page
    page = Page.find(:first)
    assert_equal page.body, page.send("body_en")
  end

  def test_should_get_body_es_of_the_page
    SimplifiedTranslation.locale = 'es'
    page = Page.find(:first)
    assert_equal page.body, page.send("body_es")
  end

  def test_should_return_title_en_when_undefined_locale
    SimplifiedTranslation.locale = 'undefined'
    page = Page.find(:first)
    assert_equal page.title, page.send("title_en")
  end

  def test_should_return_title_es_because_is_the_default_locale
    SimplifiedTranslation.default_locale = 'es'
    SimplifiedTranslation.locale = 'undefined'
    page = Page.find(:first)
    assert_equal page.title, page.send("title_es")
  end

  def test_should_set_title_and_set_it_on_title_en
    page = Page.find(:first)
    page.title = 'Chunky Bacon'
    assert_equal page.title, page.send('title_en')
  end

  def test_should_set_title_and_save_it_on_title_en
    page = Page.find(:first)
    page.title = 'Chunky Bacon'
    page.save
    page = Page.find(:first)
    assert_equal "Chunky Bacon", page.send('title_en')
  end

  def test_should_not_set_title_if_locale_doesnt_exist
    SimplifiedTranslation.locale = 'undefined'
    page = Page.find(:first)
    page.title = 'Chunky Bacon'
    page.save
    assert_equal 'About', page.send('title_en')
  end

end