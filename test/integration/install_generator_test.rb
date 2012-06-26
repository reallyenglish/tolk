require "test_helper"
require "rails/generators"
require File.expand_path("../../../lib/generators/tolk/install_generator", __FILE__)

class InstallGeneratorTest < Rails::Generators::TestCase
  tests Tolk::InstallGenerator
  destination File.expand_path("../dummy", File.dirname(__FILE__))

  def setup
    $stdin.stubs(:gets).returns("n\n") # no, we don't want to install the optional configuration file

    FileUtils.cp("#{destination_root}/config/database.withouttolk.yml","#{destination_root}/config/database.yml")
    FileUtils.rm_f("#{destination_root}/db/tolk.sqlite3")
  end

  def teardown
    FileUtils.rm_f("#{destination_root}/config/initializers/tolk.rb.example")
  end

  test "uses separate db by default for new installations" do
    run_generator 

    assert_file "db/tolk.sqlite3"

    database_yml = File.read("#{destination_root}/config/database.yml")

    assert_match /tolk:/, database_yml
  end

  test "uses development db by default if tolk has been installed previously" do
    dummy_tolk_config = "#{destination_root}/config/initializers/tolk.rb"

    FileUtils.touch(dummy_tolk_config)

    run_generator
    
    assert_no_file "db/tolk.sqlite3"

    FileUtils.rm(dummy_tolk_config)

    database_yml = File.read("#{destination_root}/config/database.yml")

    assert_no_match /tolk:/, database_yml

    FileUtils.cp("#{destination_root}/config/database.withtolk.yml", "#{destination_root}/config/database.yml")
  end
end
