# Migrate database down
#
# @param version [Integer] Version to migrate to. Defaults to latest.
# @param database [String] Sequel database instance to use. Defaults to first connected.
# @param migrations [String] Path to migrations. Defaults to 'migrate/'
def down(version: 0, database: nil, migrations: migrations_path)
  migrate(database, version, migrations)
end

# Migrate database up
#
# @param database [String] Sequel database instance to use. Defaults to first connected.
# @param migrations [String] Path to migrations. Defaults to 'migrate/'
def up(database: nil, migrations: migrations_path)
  migrate(database, nil, migrations)
end

# Bounce database
#
# @param database [String] Sequel database instance to use. Defaults to first connected.
# @param migrations [String] Path to migrations. Defaults to 'migrate/'
def bounce(database: nil, migrations: migrations_path)
  migrate(database, 0, migrations)
  migrate(database, nil, migrations)
end

# Set up new project
def setup
  require "framework"
  require "fileutils"

  config_file = Framework.root.join("config/database.rb")
  unless config_file.exist?
    config_file.write(<<~RUBY)
      require "sequel"

      DB = Sequel.connect(ENV.fetch("DATABASE_URL"))

      # Set up any custom Sequel extensions here
      # DB.extension :pg_json
    RUBY
  end

  FileUtils.mkdir_p(migrations_path)
  migration_file = Framework.root.join(migrations_path, "001_tables.rb")
  unless migration_file.exist?
    migration_file.write(<<~RUBY)
      Sequel.migration do
        change do

        end
      end
    RUBY
  end
end

private

def migrate(database, version, migrations_path)
  call("framework:application")
  database = resolve_database(database)

  require "sequel"
  Sequel.extension :migration
  database.logger = Framework.logger
  Sequel::Migrator.run(database, migrations_path, target: version)
end

def migrations_path
  "migrate"
end

def resolve_database(database)
  case database
  in String
    Object.const_get(database)
  else
    Sequel::DATABASES.first
  end
end
