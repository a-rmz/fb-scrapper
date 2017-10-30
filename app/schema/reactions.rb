
class Reactions
  attr_accessor :like, :love, :wow, :haha, :sad, :angry, :thankful, :pride

  def initialize(like, love, wow, haha, sad, angry, thankful, pride)
    @date = Time.now
    @like = like
    @love = love
    @wow = wow
    @haha = haha
    @sad = sad
    @angry = angry
    @thankful = thankful ||= 0
    @pride = pride ||= 0
  end

  def db_obj
    {
      date: @date,
      like: @like,
      love: @love,
      wow: @wow,
      haha: @haha,
      sad: @sad,
      angry: @angry,
      thankful: @thankful,
      pride: @pride
    } 
  end

end
