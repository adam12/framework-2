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
  require "fileutils"

  config_file = "config/database.rb"
  unless File.exist?(config_file)
    File.write(config_file, <<~RUBY)
      require "sequel"

      db = Sequel.connect(ENV.fetch("DATABASE_URL"))
      Sequel::Model.db = db
    RUBY
  end

  FileUtils.mkdir_p(migrations_path)
  migration_file = File.join(migrations_path, "001_tables.rb")
  unless File.exist?(migration_file)
    File.write(migration_file, <<~RUBY)
      Sequel.migration do

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
  database.logger = Console.logger
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
