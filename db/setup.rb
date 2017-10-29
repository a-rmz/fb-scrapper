#!/usr/bin/env ruby

require 'bundler/setup'
require 'rethinkdb'
require 'yaml'

include RethinkDB::Shortcuts

config = YAML.load_file('config/database.yaml')

rdb_config = {
  :db=>config['development']['db_name'],
  :host=>config['development']['host'],
  :port=>config['development']['port'],
  :tables=>['pages', 'posts', 'comments']
}

connection = r.connect(
  :host=>rdb_config[:host],
  :port=>rdb_config[:port]
)

begin
  r.db_create(rdb_config[:db]).run(connection)
rescue RethinkDB::RqlRuntimeError => err
  puts "The database #{rdb_config[:db]} already exists"
end

rdb_config[:tables].each do |table|
  begin
    r.db(rdb_config[:db]).table_create(table).run(connection)
    puts "Table #{table} successfully created."
  rescue RethinkDB::RqlRuntimeError => err
    puts "Table #{table} already exists."
  end
end

connection.close


