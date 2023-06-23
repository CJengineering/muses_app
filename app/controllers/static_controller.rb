class StaticController < ApplicationController
  #skip_before_action :authenticate_user!, except: :home
  #skip_before_action :verify_authenticity_token
  #skip_before_action :verify_authenticity_token
 # before_action :authenticate_devise_api_token!, :resource_class
  include  StaticHelper
  require 'net/http'
  require 'open-uri'
  require 'simple-rss'
  require 'json'
  require 'timeout'
  def  resource_class
   
  end
  def home
    devise_api_token =  current_devise_api_token
    if devise_api_token
      render json: {message: "you are logged in as #{devise_api_token.resource_owner.email}"}, status: :ok
    else
      render json: {message: "you are not logged in"}, status: :unauthorized 
    end

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
  def test_webflow
    @medium = Medium.all

   @medium.each do |medium|
     if medium.images.attached?
        medium.images.each do |image|
         slug="slug-n#{medium.id}"
         name =" gdgdgdggd #{url_for(image)}"
         description = url_for(image)
         create_webflow(slug, name,description)
        end
     end
   end
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
  def test_webhook
    puts "it works"
    puts params[:static]
    @params =params[:static]
  end
  
  def gosearts
    key_words= KeyWord.where(factiva: false)
    words_to_search = KeyWord.pluck(:key_word).freeze
    key_words.each do |keyword|
      encoded_query = URI.encode_www_form_component(keyword.key_word)
      url = "https://www.googleapis.com/customsearch/v1?key=AIzaSyBYXKqIved2ZtTNMNohTjNS26FolJxQvcI&cx=47940e58570224fb6&q=#{encoded_query}&tbm=nws&sort=date"
      response = Net::HTTP.get(URI(url))
      json_data = JSON.parse(response)
      if json_data["items"]
        json_data["items"].each do |item|
          if item["link"] && item["title"]
            link = item["link"]
            title = item["title"]
            next if Goseart.exists?(url_link: link)
            article_scores = scorer(link,words_to_search, keyword.key_word)
            article_obj ={}
            article_obj[:key_word_id]=keyword.id
            article_obj[:title]=title
            article_obj[:url_link]=link
            article_obj[:score] = article_scores[0]
            article_obj[:score_second] = article_scores[1]
            article_new =  Goseart.new(article_obj) 
            next unless article_new.valid?
            next unless article_new.save
            
          end
        end
      end
    end
  end

  def scraper
    @article = Article.find(806)
    @words_count = count_words(@article.link)
    @link =@article.link

  end

  def test_post
    words_to_search = KeyWord.pluck(:key_word).freeze
    @key_words= KeyWord.where(factiva: false)
    @key_words.each do |key_word|
 
      uri = URI.parse(key_word.rss_url)
      response = Net::HTTP.get_response(uri)
      begin
        rss = SimpleRSS.parse(response.body)
      rescue SimpleRSSError => e
        # Handling the poorly formatted feed error
        puts "Error: Poorly formatted feed for #{key_word.rss_url}"
        next
      end
  
      articles = rss.items
      articles.each do |article|
        article_scores = scorer(article.link.match(/url=(.*?)&amp;ct/)[1], words_to_search, key_word.key_word)
        article_obj={}
        article_obj[:key_word_id]=key_word.id
        article_obj[:title] = article.title.gsub("&lt;/b&gt;", '').gsub("&lt;b&gt;","").gsub("&amp;#39;","")
        article_obj[:published] = article.published
        article_obj[:link] = article.link.match(/url=(.*?)&amp;ct/)[1]
        article_obj[:posted] = false
        article_obj[:score] = article_scores[0]
        article_obj[:score_second] = article_scores[1]
        article_new =  Article.new(article_obj) 
        next unless article_new.valid?
        next unless article_new.save
        
      end
    end
  end

  private



  def scorer(article_url,words_to_search, keyword)
    url = article_url # Specify the website URL
    score = 0
    score_second = 0
    begin
      Timeout.timeout(5) do
      response = URI.open(url)
      html =response.read
      doc = Nokogiri::HTML(html)
      score = doc.text.scan(/#{keyword}/i).size
      array_score_second = []
      words_to_search.each do |word|
         occurrences =doc.text.scrub('').scan(/#{word}/i).size
         array_score_second << occurrences
      end
         score_second = array_score_second.sum
    end
    rescue OpenURI::HTTPError => error
      if error.io.status[0] == '404'
          score =0
          score_second =0
      end
    rescue StandardError => error  
      score =0
      score_second =0
    end  
    return score, score_second        
  end


  def count_words(url)
   # Fetch the webpage content using Nokogiri and open-uri
   html = URI.open("https://www.biometricupdate.com/202305/j-pal-shares-lessons-from-indias-digital-id-program-aadhaar")
   doc = Nokogiri::HTML(html)
 
   # Define the words you want to search for
   words_to_search = KeyWord.pluck(:key_word).freeze
 
   # Initialize a hash to store the word counts
   word_counts = Hash.new(0)
 
   # Iterate over each word and count its occurrences
   words_to_search.each do |word|
     # Find all occurrences of the word in the webpage content
     occurrences =doc.text.scrub('').scan(/#{word}/i).size
 
     # Store the count in the hash
     word_counts[word] = occurrences
   end
 
   # Return the word counts
   word_counts
  end

end
