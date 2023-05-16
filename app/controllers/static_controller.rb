class StaticController < ApplicationController
  skip_before_action :authenticate_user!, except: :home
  require 'net/http'
  require 'open-uri'
  require 'simple-rss'

  def home
    if Article.last
      @article_published = Article.last.published.slice(0..10) 
      @article_last_title = Article.last.title.gsub("&lt;/b&gt;", '').gsub("&lt;b&gt;","").gsub("&amp;#39;","")
    end
    if KeyWord.last
        @key_word_last_date = KeyWord.last.created_at.strftime("%B %d, %Y")
         @key_word_last = KeyWord.last.key_word
    end
    @articles_count = Article.all.count
    @key_words_count = KeyWord.all.count
    
   
    
    @articles = Article.last(5)
  end

  def test
    @key_words= KeyWord.where(factiva: true)
    @key_words.each do |key_word|
      uri = URI.parse(key_word.rss_url)
      response = Net::HTTP.get_response(uri)
      rss = SimpleRSS.parse response.body
      articles = rss.items
      articles.each do |article|
        article_obj={}
        article_obj[:key_word_id]=key_word.id
        article_obj[:title] = article.title.gsub("&lt;/b&gt;", '').gsub("&lt;b&gt;","").gsub("&amp;#39;","")
        article_obj[:description]=article.description
        article_obj[:published] = article.pubDate
        article_obj[:factiva_link] = article.link
        article_obj[:posted] = false
        
        #code for google improve later 
      # url = "https://www.google.com/search?q=#{article.description} #{article.author}  "
       # puts " this is the url #{url}"
        #html = URI.open(url)
        #doc = Nokogiri::HTML.parse(html)
        # Get the first two search results
        #results = doc.css('div div div a')

     
        #first_url = results[12][:href].gsub(/\/url\?q=/, '')
        #second_url = results[13][:href].gsub(/\/url\?q=/, '')
      
        
        # Get the title and URL of each search result
       
        #article_obj[:url_g_1]=first_url
        #article_obj[:url_g_2] = second_url
        article_new =  FactivaArticle.new(article_obj) 
        next unless article_new.valid?
        next unless article_new.save
      end
    end

        
   
    # Save the article with the scraped content and URLs
 
  end

  def test_post
    @key_words= KeyWord.where(factiva: false)
    @key_words.each do |key_word|
      uri = URI.parse(key_word.rss_url)
      response = Net::HTTP.get_response(uri)
      rss = SimpleRSS.parse response.body
      articles = rss.items
      articles.each do |article|
        article_obj={}
        article_obj[:key_word_id]=key_word.id
        article_obj[:title] = article.title.gsub("&lt;/b&gt;", '').gsub("&lt;b&gt;","").gsub("&amp;#39;","")
        article_obj[:published] = article.published
        article_obj[:link] = article.link.match(/url=(.*?)&amp;ct/)[1]
        article_obj[:posted] = false
        article_new =  Article.new(article_obj) 
        next unless article_new.valid?
        next unless article_new.save
        
      end
    end
  end
end
