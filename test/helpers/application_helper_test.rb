require "test_helper"

class ApplicationHelperTest < ActiveSupport::TestCase
  include Tolk::ApplicationHelper

  test "handles boolean values" do
    assert_equal format_i18n_value(false), "false"
  end
end
