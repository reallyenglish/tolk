require "test_helper"

class TolkDatabaseTest < ActiveSupport::TestCase
  test "connects tolk models to correct db" do
    [Tolk::Locale, Tolk::Phrase, Tolk::Translation].each do |tolk_class| 
      assert_equal true, tolk_class.table_exists?
      assert_match tolk_class.connection.instance_eval { @config[:database] }, /\/tolk.sqlite3$/
    end
  end

  test "does not affect application's db" do
    assert_match ActiveRecord::Base.connection.instance_eval { @config[:database] }, /\/test.sqlite3$/
  end
end
