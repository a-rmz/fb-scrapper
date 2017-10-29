require 'rethinkdb'

include RethinkDB::Shortcuts

def connect_to_db(config)
  rdb_config = {
    :db=>config['development']['db_name'],
    :host=>config['development']['host'],
    :port=>config['development']['port']
  }

  r.connect(rdb_config)
end
