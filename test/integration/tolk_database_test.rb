require "test_helper"

class TolkDatabaseTest < ActiveSupport::TestCase
  def test_connects_tolk_models_to_correct_db
    [Tolk::Locale, Tolk::Phrase, Tolk::Translation].each do |tolk_class| 
      assert_equal true, tolk_class.table_exists?
      assert_match tolk_class.connection.instance_eval { @config[:database] }, /\/tolk.sqlite3$/
    end
  end

  def test_does_not_affect_applications_db
    assert_match ActiveRecord::Base.connection.instance_eval { @config[:database] }, /\/test.sqlite3$/
  end
end
