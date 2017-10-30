require 'koala'
require 'yaml'

require_relative 'schema/reactions'

class Scrapper
  def initialize()
    @fb_config = YAML.load_file('config/facebook.yaml')

    Koala.config.api_version = "v2.10"
    @oauth = Koala::Facebook::OAuth.new(
      @fb_config['app_id'],
      @fb_config['app_secret'],
      @fb_config['callback_url']
    )

    @access_token = @oauth.get_app_access_token
    @fb_api = Koala::Facebook::API.new(@access_token)
  end

  def scrape_page(page_id)
    @fb_api.get_object(page_id, {
      fields: ['id', 'name', 'fan_count']
    })
  end

  def scrape_posts(page_id, since)
    posts = []
    result = @fb_api.get_connection(page_id, 'posts', {
      limit: 5,
      since: "#{since.day}-#{since.month}-#{since.year}",
      fields: [
        'id',
        'message',
        'story',
        'created_time',
        'reactions.type(LIKE).limit(0).summary(1).as(like)',
        'reactions.type(LOVE).limit(0).summary(1).as(love)',
        'reactions.type(WOW).limit(0).summary(1).as(wow)',
        'reactions.type(HAHA).limit(0).summary(1).as(haha)',
        'reactions.type(SAD).limit(0).summary(1).as(sad)',
        'reactions.type(ANGRY).limit(0).summary(1).as(angry)',
        'reactions.type(THANKFUL).limit(0).summary(1).as(thankful)',
        'reactions.type(PRIDE).limit(0).summary(1).as(pride)'
      ]
    })

    loop do
      posts += result
      result = result.next_page
      break if !result
    end
    posts
  end

end

