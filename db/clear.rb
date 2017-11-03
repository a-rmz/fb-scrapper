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

rdb_config[:tables].each do |table|
  begin
    r.db(rdb_config[:db]).table(table).delete().run(connection)
    puts "Table #{table} successfully cleaned."
  rescue RethinkDB::RqlRuntimeError => err
    puts err
  end
end

puts ""
puts ""

connection.close
