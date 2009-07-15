require 'test/unit'
require 'rubygems'
require 'active_record'

$LOAD_PATH << File.expand_path("#{File.dirname(__FILE__)}/../lib")
require 'simplified_translation'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")

def setup_db

  silence_stream(STDOUT) do
    ActiveRecord::Schema.define(:version => 1) do
      create_table :pages, :force => true do |t|
        t.string :name_en, :default => "", :null => false
        t.string :name_es, :default => "", :null => false
        t.text :body_en, :default => "", :null => false
        t.text :body_es, :default => "", :null => false
        t.datetime :created_at
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
  translate :name, 'body'
end

class SimplifiedTranslationTest < Test::Unit::TestCase

  def setup
    setup_db
    
    Page.create :name_en => "Name", 
                :name_es => "Nombre", 
                :body_en => "Content", 
                :body_es => "Contenido",
                :created_at => Time.now - 60

    Page.create :name_en => "Second Name",
                :name_es => "Nombre",
                :body_en => "Second Content",
                :body_es => "Segundo Contenido",
                :created_at => Time.now
    
    I18n.default_locale = :en
    I18n.locale = :en
  end

  def teardown
    teardown_db
  end

  def test_should_get_title_en_of_the_page
    page = Page.find(:first)
    assert_equal page.send('name_en'), page.name
  end

  def test_should_get_title_es_of_the_page
    I18n.locale = :es
    page = Page.find(:first)
    assert_equal page.send('name_es'), page.name
  end

  def test_should_get_body_en_of_the_page
    page = Page.find(:first)
    assert_equal page.send('body_en'), page.body
  end

  def test_should_get_body_es_of_the_page
    I18n.locale = :es
    page = Page.find(:first)
    assert_equal page.send('body_es'), page.body
  end

  def test_should_return_title_en_when_undefined_locale
    I18n.locale = :undefined
    page = Page.find(:first)
    assert_equal page.send('name_en'), page.name
  end

  def test_should_return_title_es_because_is_the_default_locale
    I18n.default_locale = :es
    I18n.locale = :undefined
    page = Page.find(:first)
    assert_equal page.send('name_es'), page.name
  end
 
  def test_should_find_by_translated_attribute
    I18n.locale = :es
    page = Page.find_by_name('Nombre')
    assert_equal page.name , 'Nombre'

    I18n.locale = :en
    page2 = Page.find_by_name('Name')
    assert_equal page.name, 'Name'
    assert_equal page.body, 'Content'
  end

  def test_should_find_with_options
    I18n.locale = :es
    pages = Page.find_all_by_name('Nombre')
    assert_equal pages.length , 2
 
    I18n.locale = :es
    pages = Page.find_all_by_name('Nombre', :limit => 1)
    assert_equal pages.length , 1
    
    I18n.locale = :es
    pages = Page.find_all_by_name('Nombre', :limit => 1, :order => "created_at desc")
    assert_equal pages.length , 1
    assert_equal pages[0].body, "Segundo Contenido"

    I18n.locale = :es
    pages = Page.find_all_by_name('Nombre', :limit => 1, :order => "created_at asc")
    assert_equal pages.length , 1
    assert_equal pages[0].body, "Contenido"


    I18n.locale = :en
    pages = Page.find_all_by_name('Name')
    assert_equal pages.length , 1
  end
    
end
