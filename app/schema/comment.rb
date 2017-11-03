
class Comment
  attr_accessor :id, :post_id, :message, :created_time, :from, :reactions, :comments

  def initialize(id, post_id, message, created_time, from, reactions, comments)
    @id = id
    @post_id = post_id
    @message = message
    @created_time = created_time
    @from = from
    @reactions = reactions
    @comments = comments ||= []
  end

  def db_obj
    {
      id: @id,
      post_id: @post_id,
      message: @message,
      created_time: @created_time,
      from: @from,
      reactions: [ @reactions.db_obj ],
      comments: @comments.map { |c| c.db_obj }
    }
  end
end
