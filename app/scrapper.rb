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
      fields: [
        'id',
        'message',
        'created_time',
        'reactions.type(LIKE).limit(0).summary(1).as(like)',
        'reactions.type(LOVE).limit(0).summary(1).as(love)',
        'reactions.type(WOW).limit(0).summary(1).as(wow)',
        'reactions.type(HAHA).limit(0).summary(1).as(haha)',
        'reactions.type(SAD).limit(0).summary(1).as(sad)',
        'reactions.type(ANGRY).limit(0).summary(1).as(angry)'
      ]
    })

    loop do
      posts += result
      t = result.last['created_time']
      last_time = Time.new(t[0..3], t[5..6], t[8..9], t[11..12], t[14..15], t[17..18])
      result = result.next_page
      break if last_time < since
    end
    posts
  end
end

