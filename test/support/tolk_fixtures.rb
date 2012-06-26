module Tolk
  module Fixtures
    # Custom fixtures to avoid cross polluting the application's database
    # 
    # TODO: figure out a way to get Rails to handle this use case more gracefully...
    #
    def self.included(klass)
      klass.class_eval do
        self.use_transactional_fixtures = true
        self.use_instantiated_fixtures  = false

        @@fixtures = {}
        self.fixture_class_names = {:tolk_locales => 'Tolk::Locale', :tolk_phrases => 'Tolk::Phrase', :tolk_translations => 'Tolk::Translation'}

        self.fixture_class_names.each do |table, class_name|
          klass = class_name.constantize
          @@fixtures[table] = {}

          YAML.load(File.read(File.dirname(__FILE__) + "/../fixtures/#{table}.yml")).each do |fixture_id, fixture|
            klass.create(fixture)
            @@fixtures[table][fixture_id] = ActiveRecord::Fixture.new(fixture, klass)
          end

          define_method(table) do |*fixtures|
            instances = fixtures.map do |fixture|
              @@fixtures[table][fixture.to_s].find
            end

            instances.size == 1 ? instances.first : instances
          end
        end
      end
    end
  end
end
