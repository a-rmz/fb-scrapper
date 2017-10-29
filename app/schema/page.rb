
require_relative 'fan_count'

class Page
  attr_accessor :id, :slug_id, :name, :fan_count

  def initialize(id, slug_id, name, count)
    @id = id
    @slug_id = slug_id
    @name = name
    @fan_count = FanCount.new(count)
  end

  def db_obj
    {
      id: @id,
      slug_id: @slug_id,
      name: @name,
      fan_count: [ @fan_count.db_obj ]
    }
  end
end

