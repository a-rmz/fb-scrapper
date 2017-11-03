require 'logger'
require 'time'
require 'time_difference'
require 'yaml'

require_relative 'scrapper'
require_relative 'storage' 

require_relative 'schema/comment'
require_relative 'schema/page'
require_relative 'schema/post'
require_relative 'schema/fan_count'

module Fbpostscrapper

  log_date = Time.now.strftime "%Y-%m-%d_%H:%M:%S"
  @logger = Logger.new("log/#{log_date}.log")

  @scrapper = Scrapper.new()
  @storage = Storage.new()

  @page_list = YAML.load_file('page_list.yaml')
  @scrapper_config = YAML.load_file('config/scrapper.yaml')

  @since = Time.parse(@scrapper_config['date_range']['since'])
  @start_time = Time.now

  @logger.info "Starting job at #{@start_time.inspect}"
  @logger.info ""
  @logger.info "Scrapping posts since #{@since.asctime}"
  @logger.info ""
  @logger.info ""

  @page_list.each do |page_id|
    scrapped_page = @scrapper.scrape_page(page_id)

    page = Page.new(
      scrapped_page['id'],
      page_id,
      scrapped_page['name'],
      scrapped_page['fan_count']
    )

    @logger.info "Scrapping: #{page.name}"
    page_result = @storage.insert_page(page)
    if page_result['inserted'] == 1 then
      @logger.info 'Page inserted successfully'
    elsif page_result['skipped'] == 1 then
      @logger.info 'Page skipped'
    elsif page_result['replaced'] == 1 then
      @logger.info 'Page updated'
    else
      @logger.info 'Error while inserting page'
    end
   
    posts = @scrapper.scrape_posts(page.slug_id, @since)

    post_results = { :success=>0, :error=>0, :skipped=>0 }
    comment_results = { :success=>0, :error=>0, :skipped=>0 }
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

      if result['errors'] == 1 then
        post_results[:error] += 1
      elsif result['skipped'] == 1 then
        post_results[:skipped] += 1
      else
        post_results[:success] += 1
      end

      # Scrape the comments!
      comments = @scrapper.scrape_comments(post_obj.id)

      comments_processed = 0

      comments.each do |comment|
        id = comment['id']
        message = comment['message']
        created_time = comment['created_time']
        from = comment['from']
        like = comment['like']['summary']['total_count']
        love = comment['love']['summary']['total_count']
        wow = comment['wow']['summary']['total_count']
        haha = comment['haha']['summary']['total_count']
        sad = comment['sad']['summary']['total_count']
        angry = comment['angry']['summary']['total_count']
        thankful = comment['thankful']['summary']['total_count']
        pride = comment['pride']['summary']['total_count']

        reactions = Reactions.new(like, love, wow, haha, sad, angry, thankful, pride)
        comment_obj = Comment.new(id, post_obj.id, message, created_time, from, reactions, [])
       
        result = @storage.insert_comment(comment_obj)
        comments_processed += 1
        print "#{comments_processed} comments processed\r"
        $stdout.flush

        if result['errors'] == 1 then
          comment_results[:error] += 1
        elsif result['skipped'] == 1 then
          comment_results[:skipped] += 1
        else
          comment_results[:success] += 1
        end
      end # end comments do

    end # end posts do
  
    @logger.info "#{post_results[:success]} posts inserted successfully"
    @logger.info "#{post_results[:skipped]} posts skipped"
    @logger.info "#{post_results[:error]} errors"
    @logger.info  ""
    @logger.info "#{comment_results[:success]} comments inserted successfully"
    @logger.info "#{comment_results[:skipped]} comments skipped"
    @logger.info "#{comment_results[:error]} errors"
    @logger.info  ""
    @logger.info  ""
  end # end pages do

  @end_time = Time.now
  @time_difference = TimeDifference.between(@start_time, @end_time)
  @logger.info "Ending job at #{@end_time.inspect}"
  @logger.info "Time elapsed: #{@time_difference.humanize}"

end
