require 'yaml'
require 'rethinkdb'

require_relative '../db/connect'

include RethinkDB::Shortcuts

class Storage
  def initialize()
    @db_config = YAML.load_file('config/database.yaml')
    @db = connect_to_db(@db_config)
  end

  def insert_page(page)
    get = r.table('pages').get(page.id)

    if get.run(@db)
      puts get.update{ |doc| 
        { :fan_count => (doc['fan_count'] + [ page.fan_count.db_obj ]) }
      }.run(@db)
    else
      puts r.table('pages').insert(page.db_obj).run(@db)
    end
  end

  def insert_post(post)
    get = r.table('posts').get(post.id)

    if get.run(@db)
      puts get.update{ |doc| 
        { :reactions => (doc['reactions'] + [ post.reactions.db_obj ]) }
      }.run(@db)
    else
      puts r.table('posts').insert(post.db_obj).run(@db)
    end

  end
end

