require 'yaml'
require_relative 'scrapper'
require_relative 'storage' 

require_relative 'schema/page'
require_relative 'schema/post'
require_relative 'schema/fan_count'

module Fbpostscrapper

  @scrapper = Scrapper.new()
  @storage = Storage.new()

  page_list = ['MiguelOsorioChong',
    'SilvanoAureoles',
    'MargaritaZavalaMX',
    'emilioalvarezicaza',
    'JaimeRodriguezElBronco',
    'JoseAMeadeK',
    'MiguelAngelMancera',
    'lopezobrador.org.mx'
  ]

  page_list.each do |page_id|
    scrapped_page = @scrapper.scrape_page(page_id)

    page = Page.new(
      scrapped_page['id'],
      page_id,
      scrapped_page['name'],
      scrapped_page['fan_count']
    )

#     @storage.insert_page(page)

    posts = @scrapper.scrape_posts(page.slug_id, Time.new("2017", "10", "16"))
    posts.each do |post|

      id = post['id']
      message = post['message']
      created_time = post['created_time']
      like = post['like']['summary']['total_count']
      love = post['love']['summary']['total_count']
      wow = post['wow']['summary']['total_count']
      haha = post['haha']['summary']['total_count']
      sad = post['sad']['summary']['total_count']
      angry = post['angry']['summary']['total_count']

      reactions = Reactions.new(like, love, wow, haha, sad, angry)
      post_obj = Post.new(id, page.id, message, created_time, reactions)
      @storage.insert_post(post_obj)
    end
  puts  ""
  puts  ""
  end # end do

end
