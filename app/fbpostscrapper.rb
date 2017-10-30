require 'yaml'
require_relative 'scrapper'
require_relative 'storage' 

require_relative 'schema/page'
require_relative 'schema/post'
require_relative 'schema/fan_count'

module Fbpostscrapper

  @scrapper = Scrapper.new()
  @storage = Storage.new()

  @page_list = ['MiguelOsorioChong',
    'SilvanoAureoles',
    'MargaritaZavalaMX',
    'emilioalvarezicaza',
    'JaimeRodriguezElBronco',
    'JoseAMeadeK',
    'MiguelAngelMancera',
    'lopezobrador.org.mx'
  ]

  @page_list.each do |page_id|
    scrapped_page = @scrapper.scrape_page(page_id)

    page = Page.new(
      scrapped_page['id'],
      page_id,
      scrapped_page['name'],
      scrapped_page['fan_count']
    )

    page_result = @storage.insert_page(page)
    if page_result['error'] then
      puts 'Page retreived successfully'
    elsif page_result['skipped'] then
      puts 'Page skipped'
    else
      puts 'Error while inserting page'
    end
   
    puts "Scrapping: #{page.name}"
    since = Time.new("2017", "10", "20")
    posts = @scrapper.scrape_posts(page.slug_id, since)

    results = { :success=>0, :error=>0, :skipped=>0 }
    posts.each do |post|
      id = post['id']
      message = post['message']
      story = post['story']
      link = post['link']
      created_time = post['created_time']
      like = post['like']['summary']['total_count']
      love = post['love']['summary']['total_count']
      wow = post['wow']['summary']['total_count']
      haha = post['haha']['summary']['total_count']
      sad = post['sad']['summary']['total_count']
      angry = post['angry']['summary']['total_count']
      thankful = post['thankful']['summary']['total_count']
      pride = post['pride']['summary']['total_count']

      reactions = Reactions.new(like, love, wow, haha, sad, angry, thankful, pride)
      post_obj = Post.new(id, page.id, message, story, link, created_time, reactions)
      
      result = @storage.insert_post(post_obj)
      if result[:error] then
        results[:error] += 1
      elsif result[:skipped] then
        results[:skipped] += 1
      else
        results[:success] += 1
      end
    end
  
    puts "#{results[:success]} posts inserted successfully"
    puts "#{results[:skipped]} posts skipped"
    puts "#{results[:error]} errors"
    puts  ""
    puts  ""
  end # end do

end
