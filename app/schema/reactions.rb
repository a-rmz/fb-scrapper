
class Reactions
  attr_accessor :like, :love, :wow, :haha, :sad, :angry

  def initialize(like, love, wow, haha, sad, angry)
    @date = Time.now
    @like = like
    @love = love
    @wow = wow
    @haha = haha
    @sad = sad
    @angry = angry
  end

  def db_obj
    {
      date: @date,
      like: @like,
      love: @love,
      wow: @wow,
      haha: @haha,
      sad: @sad,
      angry: @angry
    } 
  end

end
