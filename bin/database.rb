class Database
  require 'yaml'
  require 'active_record'
  require 'mysql2'

  #Read the database.yml file
  @@database_info = YAML.load(File.new(File.dirname(__FILE__) + "/../config/database.yml"))

  def self.connect_to(environment = nil, type = 'active_record')
    if @@database_info.nil?
      @@database_info = YAML.load(File.new(File.dirname(__FILE__) + "/../config/database.yml"))
    end

    if type == 'mysql2'
      return Mysql2::Client.new(@@database_info[environment].to_s)
    else
      if environment.nil?
        directory = Dir.pwd

        #try to detect what environment to run in
        if directory.include? "testing"
          environment = 'testing'
          puts "You need to include an environment as a command-line argument.\n" +
               "Testing environment detected. Connecting to 'testing' database."
        elsif directory.include? "staging"
          environment = 'staging'
          puts "You need to include an environment as a command-line argument.\n" +
               "Staging environment detected. Connecting to 'staging' database."
        elsif directory.include? "production"
          puts "You need to include an environment as a command-line argument.\n" +
                "Production environment detected."
          raise "WILL NOT CONNECT TO 'production' DATABASE WITHOUT COMMAND-LINE ARGUMENT!"
        else
          puts "You should include an environment as a command-line argument. (development, production, etc). Defaulting to development."
          environment = 'development'
        end
      end

      #Establish database connection
      ActiveRecord::Base.establish_connection(@@database_info[environment.to_s])
    end
  end

  def self.connect(environment = nil, type)
    connect_to(environment, type)
  end
end