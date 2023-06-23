require 'net/http'
require 'open-uri'
require 'simple-rss'
require 'json'
require 'timeout'
require 'nokogiri'
class TextAnalyzer
    require 'net/http'
    require 'uri'
    require 'json'
  
    attr_reader :text, :model
  
    def initialize(text, model = 'text-davinci-003')
      @text = text
      @model = model
    end
  
    def analyze
      uri = URI.parse("https://api.openai.com/v1/completions")
  
      header = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer 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'
      }
  
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri, header)
      
      prompt = "Please provide a comprehensive analysis and summary of the following text: #{@text}"
      
      request.body = { prompt: prompt, model: @model, max_tokens: 400 }.to_json
  
      response = http.request(request)
      
      analyzed_text = JSON.parse(response.body)["choices"].first["text"].strip
  
      # Trim to the nearest sentence.
      analyzed_text = analyzed_text.rpartition('.').first + '.' if analyzed_text.include?('.')
  
      analyzed_text
     
    end
  end
  

  


  