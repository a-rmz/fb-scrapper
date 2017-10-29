
require 'date'

class FanCount
  attr_accessor :date, :count

  def initialize(count)
    @count = count
    @date = Time.new
  end

  def db_obj
    { count: @count, date: @date }
  end
end
