
class Post
  attr_accessor :id, :page_id, :message, :story, :link, :created_time, :reactions

  def initialize(id, page_id, message, story, link, created_time, reactions)
    @id = id
    @page_id = page_id
    @message = message
    @story = story
    @link = link
    @created_time = created_time
    @reactions = reactions
  end

  def db_obj
    {
      id: @id,
      page_id: @page_id,
      message: @message,
      story: @story,
      link: @link,
      created_time: @created_time,
      reactions: [ @reactions.db_obj ]
    }
  end
end
