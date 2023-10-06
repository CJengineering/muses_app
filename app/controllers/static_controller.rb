class StaticController < ApplicationController
   #skip_before_action :authenticate_user!, except: :home
  # skip_before_action :verify_authenticity_token
  <skip_before_action :verify_authenticity_token
  #  before_action :authenticate_devise_api_token!, :resource_class
  include StaticHelper
  require 'net/http'
  require 'open-uri'
  require 'simple-rss'
  require 'json'
  require 'timeout'
  def resource_class; end

  def home
    render json: { message: 'you are not logged in' }
    #  devise_api_token = current_devise_api_token
    #   if devise_api_token
    #     render json: { message: "you are logged in as #{devise_api_token.resource_owner.email}" }, status: :ok
    #   else
    #     render json: { message: 'you are not logged in' }, status: :unauthorized
    #   end

    #   if Article.last
    #     @article_published = Article.last.published.slice(0..10)
    #     @article_last_title = Article.last.title.gsub('&lt;/b&gt;', '').gsub('&lt;b&gt;', '').gsub('&amp;#39;', '')
    #   end
    #   if KeyWord.last
    #     @key_word_last_date = KeyWord.last.created_at.strftime('%B %d, %Y')
    #     @key_word_last = KeyWord.last.key_word
    #   end
    #   @articles_count = Article.all.count
    #   @key_words_count = KeyWord.all.count
    #   @articles = Article.last(5)
  end
  # FOR TESTING ONLY

  def gosearts_test
    key_words = KeyWord.where(combined: true)
    words_to_search = KeyWord.pluck(:key_word).freeze
    goseart_links = Goseart.pluck(:url_link).to_set

    key_words.find_each do |keyword|
      encoded_query = URI.encode_www_form_component(keyword.key_word)
      url = "https://www.googleapis.com/customsearch/v1?key=AIzaSyBYXKqIved2ZtTNMNohTjNS26FolJxQvcI&cx=47940e58570224fb6&q=#{encoded_query}&tbm=nws&sort=date"
      response = Net::HTTP.get(URI(url))
      json_data = JSON.parse(response)
      if json_data['items']
        json_data['items'].each do |item|
          next unless item['link'] && item['title']

          link = item['link']
          title = item['title']
          next if goseart_links.include?(link)

          article_scores = scorer(link, words_to_search, keyword.key_word, keyword)
          article_obj = {}
          article_obj[:key_word_id] = keyword.id
          article_obj[:title] = title
          article_obj[:url_link] = link
          article_obj[:score] = article_scores[0]
          article_obj[:score_second] = article_scores[1]
          score_sum = article_obj[:score] + article_obj[:score_second]
          article_new = Goseart.new(article_obj)
          if article_new.valid? && score_sum > 0
            if article_new.save
              goseart_links.add(link) # Add the link to the set
            else
              puts "Error saving article: #{article_new.errors.full_messages}"
            end
          else
            puts 'Invalid article or score sum is zero or less'
          end
        end
      end
    rescue StandardError => e
      puts "Error occurred while processing keyword: #{keyword.key_word}. Error message: #{e.message}"
    end
  end

  def keyword_list
    @keyword = KeyWord.all
    render json: @keyword
  end

  def dashboard
    articles_count_today = Article.where('created_at >= ?', Date.today.beginning_of_day).count
    bing_articles_count_today = BingArticle.where('created_at >= ?', Date.today.beginning_of_day).count
    gosearts_count_today = Goseart.where('created_at >= ?', Date.today.beginning_of_day).count

    # Article
    article_with_highest_score_today = Article.order(score: :desc).limit(5)
    article_with_highest_score_second_today = Article.where('created_at >= ?',
                                                            Date.today.beginning_of_day).order(score_second: :desc).first

    # BingArticle
    bing_article_with_highest_score_today = BingArticle.where('created_at >= ?',
                                                              Date.today.beginning_of_day).order(score: :desc).first
    bing_article_with_highest_score_second_today = BingArticle.where('created_at >= ?',
                                                                     Date.today.beginning_of_day).order(score_second: :desc).first

    # Goseart
    goseart_with_highest_score_today = Goseart.where('created_at >= ?',
                                                     Date.today.beginning_of_day).order(score: :desc).first
    goseart_with_highest_score_second_today = Goseart.where('created_at >= ?',
                                                            Date.today.beginning_of_day).order(score_second: :desc).first

    render json: { google_alerts_count: article_with_highest_score_today }
  end

  def test_webflow
    @medium = Medium.all

    @medium.each do |medium|
      next unless medium.images.attached?

      medium.images.each do |image|
        slug = "slug-n#{medium.id}"
        name = " gdgdgdggd #{url_for(image)}"
        description = url_for(image)
        create_webflow(slug, name, description)
      end
    end
  end

  def test
    @key_words = KeyWord.where(factiva: true)
    @key_words.each do |key_word|
      uri = URI.parse(key_word.rss_url)
      response = Net::HTTP.get_response(uri)
      rss = SimpleRSS.parse response.body
      articles = rss.items
      articles.each do |article|
        article_obj = {}
        article_obj[:key_word_id] = key_word.id
        article_obj[:title] = article.title.gsub('&lt;/b&gt;', '').gsub('&lt;b&gt;', '').gsub('&amp;#39;', '')
        article_obj[:description] = article.description
        article_obj[:published] = article.pubDate
        article_obj[:factiva_link] = article.link
        article_obj[:posted] = false

        # code for google improve later
        # url = "https://www.google.com/search?q=#{article.description} #{article.author}  "
        # puts " this is the url #{url}"
        # html = URI.open(url)
        # doc = Nokogiri::HTML.parse(html)
        # Get the first two search results
        # results = doc.css('div div div a')

        # first_url = results[12][:href].gsub(/\/url\?q=/, '')
        # second_url = results[13][:href].gsub(/\/url\?q=/, '')

        # Get the title and URL of each search result

        # article_obj[:url_g_1]=first_url
        # article_obj[:url_g_2] = second_url
        article_new = FactivaArticle.new(article_obj)
        next unless article_new.valid?
        next unless article_new.save
      end
    end

    # Save the article with the scraped content and URLs
  end

  def article_creator
    post_id = params[:id]
    post= Post.find_by(id: post_id)
    post.update(category_label: 'published')
    article_link = params[:link]
    text_to_analyze = fetch_raw_text(article_link)
    analyzer = ArticleGenerator.new(text_to_analyze)
    analyzed_object = analyzer.analyze
    data = { article: analyzed_object, link: article_link }
    original_title = analyzed_object['title']


    slug = original_title
    

    create_webflow_news(slug, analyzed_object['title'], analyzed_object['arabic_title'],
                        analyzed_object['body'], article_link)
  end
  def analyzer_new
    id = params[:id]
    Rails.logger.info("Analyzing article: ID=#{id}")
    post = Post.find_by(id: id)
    link = post&.link

    return unless post.summary.blank?

    text_to_analyze = fetch_raw_text(link)
    analyzer = TextAnalyzer.new(text_to_analyze)
    summary_text = analyzer.analyze
    puts(summary_text)
    summary_attributes = { summary_text: }
    summary_attributes[:post_id] = post.id
    summary = Summary.new(summary_attributes)
    if summary.save
      Rails.logger.info('Summary saved successfully!')
    else
      Rails.logger.error("Error saving summary: #{summary.errors.full_messages}")
    end
  rescue StandardError => e
    Rails.logger.error("An error occurred: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))


  end

  def analyzer
    article_id = params[:id]
    article_type = params[:type]

    Rails.logger.info("Analyzing article: ID=#{article_id}, Type=#{article_type}")

    case article_type
    when 'articles'
      article = Article.find_by(id: article_id)
      link = article&.link
    when 'gosearts'
      article = Goseart.find_by(id: article_id)
      link = article&.url_link
    when 'bing_articles'
      article = BingArticle.find_by(id: article_id)
      link = article&.link
    when 'articleinterns'
      article = Articleintern.find_by(id: article_id)
      link = article&.link
    else
      Rails.logger.error("Invalid article type: #{article_type}")
      return
    end

    Rails.logger.info("Article link: #{link}")

    return unless article.summary.blank?

    text_to_analyze = fetch_raw_text(link)
    analyzer = TextAnalyzer.new(text_to_analyze)
    summary_text = analyzer.analyze
    puts(summary_text)
    summary_attributes = { summary_text: }

    case article_type
    when 'articles'
      summary_attributes[:article_id] = article.id
    when 'gosearts'
      summary_attributes[:goseart_id] = article.id
    when 'bing_articles'
      summary_attributes[:bing_article_id] = article.id
    when 'articleinterns'
      summary_attributes[:articleintern_id] = article.id
    end
    Rails.logger.info("Summary attrinutes #{summary_attributes}")
    summary = Summary.new(summary_attributes)

    if summary.save
      Rails.logger.info('Summary saved successfully!')
    else
      Rails.logger.error("Error saving summary: #{summary.errors.full_messages}")
    end
  rescue StandardError => e
    Rails.logger.error("An error occurred: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
  end

  def bing_news
    key_words = KeyWord.where(factiva: false)
    words_to_search = KeyWord.pluck(:key_word).freeze
    bing_articles_links = Post.pluck(:link).to_set

    key_words.find_each do |keyword|
      bing_data = search_bing(keyword.key_word)

      bing_data.each do |bing_data_array|
        if bing_data_array && bing_data_array.size >= 3
          title, link, date = bing_data_array

          next if bing_articles_links.include?(link)

          article_scores = scorer(link, words_to_search, keyword.key_word, keyword)
          score, score_second = article_scores
          keyword_id = keyword.id
          score_sum = score + score_second

          article_bing = Post.new(title:, published: date, key_word_id: keyword_id, score: score_sum,
                                         score_second:, link:, source:'bing')

          if article_bing.valid? && score_sum > 0
            if article_bing.save
              bing_articles_links.add(link)
              puts 'article saved '
            else
              puts "Error saving article: #{article_bing.errors.full_messages}"
            end
          else
            puts 'Invalid article or score sum is zero or less'
          end
        else
          puts 'Error with search_bing response'
        end
      end
    end
  end

  def test_webhook
    puts 'it works'
    puts params[:static]
    @params = params[:static]
  end

  def articleintern
    words_to_search = KeyWord.pluck(:key_word).freeze
    keyword = KeyWord.find(params[:id])
    link = params[:link]
    article_scores = scorer(link, words_to_search, keyword.key_word, keyword)

    begin
      html_content = URI.open(link).read
    rescue OpenURI::HTTPError => e
      # Handle 403 Forbidden error
      response.headers['X-Status-Reason'] = 'Forbidden'
      render plain: 'Access to the requested URL is forbidden.', status: :forbidden
      return
    end

    parsed_html = Nokogiri::HTML(html_content)
    parsed_h1 = parsed_html.at('h1')
    title = parsed_h1&.text || 'No title found'

    # Create an Articlesintern object
    article_obj = {}
    article_obj[:title] = title

    article_obj[:link] = link
    article_obj[:key_word_id] = keyword.id
    article_obj[:score] = article_scores[0] +article_scores[1]
    article_obj[:score_second] = article_scores[1]
    article_obj[:source]= 'custom'

    # Create a new Articlesintern instance
    article_new = Post.new(article_obj)

    # Check if the new article is valid and save it
    if article_new.valid? && article_new.save
      # Do something after successful save
    else
      # Handle validation or saving errors
    end
  end

  def gosearts
    key_words = KeyWord.where(factiva: false)
    words_to_search = KeyWord.pluck(:key_word).freeze
    goseart_links = Goseart.pluck(:url_link).to_set

    key_words.find_each do |keyword|
      encoded_query = URI.encode_www_form_component(keyword.key_word)
      url = "https://www.googleapis.com/customsearch/v1?key=AIzaSyBYXKqIved2ZtTNMNohTjNS26FolJxQvcI&cx=47940e58570224fb6&q=#{encoded_query}&tbm=nws&sort=date"
      response = Net::HTTP.get(URI(url))
      json_data = JSON.parse(response)
      if json_data['items']
        json_data['items'].each do |item|
          next unless item['link'] && item['title']

          link = item['link']
          title = item['title']
          next if goseart_links.include?(link)

          article_scores = scorer(link, words_to_search, keyword.key_word, keyword)
          article_obj = {}
          article_obj[:key_word_id] = keyword.id
          article_obj[:title] = title
          article_obj[:link] = link
          article_obj[:source]='google'
          article_obj[:score] = article_scores[0] +  article_scores[1]
          article_obj[:score_second] = article_scores[1]
          score_sum = article_obj[:score] + article_obj[:score_second]
          article_new = Post.new(article_obj)
          if article_new.valid? && score_sum > 0
            if article_new.save
              goseart_links.add(link) # Add the link to the set
            else
              puts "Error saving article: #{article_new.errors.full_messages}"
            end
          else
            puts 'Invalid article or score sum is zero or less'
          end
        end
      end
    rescue StandardError => e
      puts "Error occurred while processing keyword: #{keyword.key_word}. Error message: #{e.message}"
    end
  end

  def scraper
    @article = Article.find(806)
    @words_count = count_words(@article.link)
    @link = @article.link
  end

  def test_post
    words_to_search = KeyWord.pluck(:key_word).freeze
    @key_words = KeyWord.where(factiva: false)
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
        article_scores = scorer(article.link.match(/url=(.*?)&amp;ct/)[1], words_to_search, key_word.key_word, key_word)
        article_obj = {}
        article_obj[:key_word_id] = key_word.id
        article_obj[:title] = article.title.gsub('&lt;/b&gt;', '').gsub('&lt;b&gt;', '').gsub('&amp;#39;', '')
        article_obj[:published] = article.published
        article_obj[:link] = article.link.match(/url=(.*?)&amp;ct/)[1]
   
        article_obj[:score] = article_scores[0] + article_scores[1]
        article_obj[:score_second] = article_scores[1]
        article_obj[:source]='google_alert'
        article_new = Post.new(article_obj)
        next unless article_new.valid?
        next unless article_new.save
      end
    end
  end

  private

  # def scorer(article_url, words_to_search, keyword)
  #   url = article_url # Specify the website URL
  #   score = 0
  #   score_second = 0
  #   begin
  #     Timeout.timeout(5) do
  #       response = URI.open(url)
  #       html = response.read
  #       doc = Nokogiri::HTML(html)
  #       score = doc.text.scan(/\b#{Regexp.escape(keyword)}\b/i).size
  #       array_score_second = []
  #       words_to_search.each do |word|
  #         occurrences = doc.text.scrub('').scan(/\b#{Regexp.escape(word)}\b/i).size
  #         array_score_second << occurrences
  #       end
  #       score_second = array_score_second.sum
  #     end
  #   rescue OpenURI::HTTPError => e
  #     if e.io.status[0] == '404'
  #       score = 0
  #       score_second = 0
  #     end
  #   rescue StandardError => e
  #     score = 0
  #     score_second = 0
  #   end
  #   [score, score_second]
  # end
  def scorer(article_url, words_to_search, keyword, key_word)
    url = article_url # Specify the website URL
    score = 0
    score_second = 0
    combined = key_word.combined || false
    begin
      Timeout.timeout(5) do
        response = URI.open(url)
        html = response.read
        doc = Nokogiri::HTML(html)

        if combined
          puts 'we are in combined'
          keywords_to_search = keyword.split(' ').map(&:strip)
          found_all_keywords = keywords_to_search.all? { |kw| doc.text =~ /\b#{Regexp.escape(kw)}\b/i }
          score = found_all_keywords ? 1 : 0
          puts "this is the score: #{score}"
        else
          puts 'we are in NOT combined'
          score = doc.text.scan(/\b#{Regexp.escape(keyword)}\b/i).size
          puts "this is the score: #{score}"
        end

        array_score_second = []
        words_to_search.each do |word|
          occurrences = doc.text.scrub('').scan(/\b#{Regexp.escape(word)}\b/i).size
          array_score_second << occurrences
        end
        score_second = array_score_second.sum
      end
    rescue OpenURI::HTTPError => e
      if e.io.status[0] == '404'
        score = 0
        score_second = 0
      end
    rescue StandardError => e
      score = 0
      score_second = 0
    end
    [score, score_second]
  end

  def search_bing(query)
    uri = URI('https://api.bing.microsoft.com/v7.0/news/search')
    uri.query = URI.encode_www_form({ q: query })

    request = Net::HTTP::Get.new(uri)
    request['Ocp-Apim-Subscription-Key'] = '8a2d79d6daaf49d9a0c6c3a795dd4812'

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    case response
    when Net::HTTPSuccess
      json_response = JSON.parse(response.body)
      if json_response.key?('value') && !json_response['value'].empty?
        json_response['value'].map do |item|
          [item['name'], item['url'], item['datePublished']]
        end
      else
        []
      end
    else
      raise "Request failed with code #{response.code}"
    end
  end

  def count_words(_url)
    # Fetch the webpage content using Nokogiri and open-uri
    html = URI.open('https://www.biometricupdate.com/202305/j-pal-shares-lessons-from-indias-digital-id-program-aadhaar')
    doc = Nokogiri::HTML(html)

    # Define the words you want to search for
    words_to_search = KeyWord.pluck(:key_word).freeze

    # Initialize a hash to store the word counts
    word_counts = Hash.new(0)

    # Iterate over each word and count its occurrences
    words_to_search.each do |word|
      # Find all occurrences of the word in the webpage content
      occurrences = doc.text.scrub('').scan(/#{word}/i).size

      # Store the count in the hash
      word_counts[word] = occurrences
    end

    # Return the word counts
    word_counts
  end
end

def scrape_and_limit(url)
  headers = {
    'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'
  }

  # Fetch the webpage content with headers using OpenURI
  html_content = URI.open(url, headers:).read

  # Parse the HTML content using Nokogiri
  doc = Nokogiri::HTML(html_content)

  # Define the selectors to include and exclude
  selectors_to_include = %w[h1 h2 h3 p div] # Include specific tags, add 'div' to include div elements
  selectors_to_exclude = %w[script style] # Exclude specific tags

  # Extract body content
  body = extract_filtered_text(doc, selectors_to_include, selectors_to_exclude)

  # Remove consecutive spaces and newlines
  body = body.gsub(/\s+/, ' ')

  # Limit the body content to 10000 characters
  max_body_length = 10_000
  body.slice(0, max_body_length)
rescue OpenURI::HTTPError, Errno::ENOENT => e
  puts "Error: #{e}"
  nil
end

def extract_filtered_text(doc, include_selectors, exclude_selectors)
  text = ''
  include_selectors.each do |selector|
    doc.css(selector).each do |element|
      text << element.text.strip + ' ' unless exclude_selectors.any? { |exclude| element.matches?(exclude) }
    end
  end
  text
end

def fetch_raw_text(url)
  html = URI.open(url)
  doc = Nokogiri::HTML(html)
  text_elements = doc.css('h1, p')
  concatenated_text = text_elements.map(&:text).join(' ')

  # Limit the concatenated text to 10000 characters
  max_length = 10_000
  concatenated_text.slice(0, max_length)
rescue OpenURI::HTTPError, URI::InvalidURIError, Nokogiri::SyntaxError, SocketError, StandardError => e
  "An error occurred: #{e}"
end
