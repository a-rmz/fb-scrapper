
class Post
  attr_accessor :id, :page_id, :message, :created_time, :reactions

  def initialize(id, page_id, message, created_time, reactions)
    @id = id
    @page_id = page_id
    @message = message
    @created_time = created_time
    @reactions = reactions
  end

  def db_obj
    {
      id: @id,
      page_id: @page_id,
      message: @message,
      created_time: @created_time,
      reactions: [ @reactions.db_obj ]
    }
  end
end
