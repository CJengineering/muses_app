
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
        'Authorization': " Bearer  #{ENV['OPEN_AI_KEY']}"
      }
    
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri, header)
    
      prompt = "Please provide a comprehensive analysis and summary of the following text: #{@text}"
    
      request.body = { prompt: prompt, model: @model, max_tokens: 400 }.to_json
    
      response = http.request(request)
    
      unless response.is_a?(Net::HTTPSuccess)
        raise "API request failed with response: #{response.code} #{response.message}"
      end
    
      response_body = JSON.parse(response.body)
    
      unless response_body.include?("choices")
        raise "API response does not include 'choices'. Full response: #{response_body}"
      end
    
      choices = response_body["choices"]
    
      if choices.empty?
        raise "API response includes an empty 'choices' array"
      end
    
      choice = choices.first
    
      unless choice.include?("text")
        raise "First choice does not include 'text'"
      end
    
      analyzed_text = choice["text"].strip
    
      # Trim to the nearest sentence.
      analyzed_text = analyzed_text.rpartition('.').first + '.' if analyzed_text.include?('.')
    
      analyzed_text
    end
    
  end
  

  


  