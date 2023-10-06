
class ArticleGenerator
    require 'net/http'
    require 'uri'
    require 'json'
  
    attr_reader :text, :model
    def initialize(text, model = 'text-davinci-003')
      @text = text
      @model = model
    end
  
    def generate_content(prompt, max_tokens)
      url = URI.parse("https://api.openai.com/v1/completions")
      open_ai_key = Rails.application.credentials.open_ai_key 
  
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
  
      headers = {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{open_ai_key}"
      }
  
      data = {
        prompt: "Given the following text: #{@text}, #{prompt}",
        model: @model,
        max_tokens: max_tokens
      }
  
      response = http.post(url.path, data.to_json, headers)
  
      unless response.is_a?(Net::HTTPSuccess)
        raise "API request failed with response: #{response.code} #{response.message}"
      end
  
      response_body = JSON.parse(response.body)
  
      unless response_body.key?('choices')
        raise "API response does not include 'choices'. Full response: #{response_body}"
      end
  
      choices = response_body['choices']
  
      if choices.empty?
        raise "API response includes an empty 'choices' array"
      end
  
      choice = choices.first
  
      unless choice.key?('text')
        raise "First choice does not include 'text'"
      end
  
      analyzed_text = choice['text']
  
      # Trim to the nearest sentence.
      #analyzed_text = analyzed_text.rpartition('.')[0] + '.' if analyzed_text.include?('.')
  
      analyzed_text
    end
  
    def analyze
      analyzed_title = generate_content('Please generate a title for this article, output rich text format, max 200 characters', 600)
      analyzed_arabic_title = generate_content('Please generate a title in Arabic for this article, output raw text', 600)
      analyzed_text = generate_content('Please generate an article in a British Style, with no indentation, in rich text format ', 600)
  
      {
        'title' => analyzed_title,
        'arabic_title' => analyzed_arabic_title,
        'body' => analyzed_text
      }
    end
  end