namespace :tolk do
  desc "Update locale"
  task :update_locale, [:old_name, :new_name] => :environment do |t, args|
    old_name, new_name = args[:old_name], args[:new_name]
    puts Tolk::Locale.rename(old_name, new_name)
  end

  desc "Add database tables, copy over the assets, and import existing translations"
  task :setup => :environment do
    system 'rails g tolk:install'

    Rake::Task['tolk:create_database'].invoke
    Rake::Task['tolk:sync'].invoke
    Rake::Task['tolk:import'].invoke
  end

  desc "Sync Tolk with the default locale's yml file"
  task :sync => :environment do
    Tolk::Locale.sync!
  end

  desc "Generate yml files for all the locales defined in Tolk"
  task :dump_all => :environment do
    Tolk::Locale.dump_all
  end

  desc "Imports data all non default locale yml files to Tolk"
  task :import => :environment do
    Rake::Task['tolk:sync'].invoke
    Tolk::Locale.import_secondary_locales
  end

  desc "Show all the keys potentially containing HTML values and no _html postfix"
  task :html_keys => :environment do
    bad_translations = Tolk::Locale.primary_locale.translations_with_html
    bad_translations.each do |bt|
      puts "#{bt.phrase.key} - #{bt.text}"
    end
  end

  desc "Create an sqlite database for tolk"
  task :create_database => :environment do
    puts "Creating tolk database"
    ActiveRecord::Base.establish_connection(Tolk::Config.database_config)

    ActiveRecord::Migrator.migrate(File.join(File.dirname(__FILE__), "..", "..", "db", "migrate"))

    ActiveRecord::Base.establish_connection(Rails.env) # hand the default database back to the current Rails environment
  end
end
