#  require 'net/http'
# require 'open-uri'
# require 'simple-rss'
#  require 'json'
# require 'nokogiri'

# words_to_search = ["J-PAL","take"]

# def count_words(url)
#     # Fetch the webpage content using Nokogiri and open-uri
#     html = URI.open(url)
#     doc = Nokogiri::HTML(html)
  
#     # Define the words you want to search for
#     words_to_search = ["J-PAL","take"]
  
#     # Initialize a hash to store the word counts
#     word_counts = Hash.new(0)
#     array = []
#     # Iterate over each word and count its occurrences
#     words_to_search.each do |word|
#       # Find all occurrences of the word in the webpage content
#       occurrences =doc.text.scrub('').scan(/#{word}/i).size
#       array << occurrences
#       # Store the count in the hash
#       word_counts[word] = occurrences
#     end
  
#     # Return the word counts
#     return word_counts, array.sum
#    end

# def scorer(article_url,words_to_search, keyword)
#     url = article_url # Specify the website URL
#     begin
     
#       response = URI.open(url)
#       html =response.read
#           doc = Nokogiri::HTML(html)
#           score = doc.text.scan(/#{keyword}/i).size
#           array_score_second = []
#           words_to_search.each do |word|
#             occurrences =doc.text.scrub('').scan(/#{word}/i).size
#             array_score_second << occurrences
#           end
#          score_second = array_score_second.sum
#     rescue OpenURI::HTTPError => error
#       if error.io.status[0] == '404'
#           score =0
#           score_second =0
#       end
#     rescue StandardError => error  
#       score =0
#       score_second =0
#     end  
#     return score, score_second        
#   end

# test_score = scorer('test', words_to_search,'J-PAL')
# test_count = count_words("https://www.povertyactionlab.org/person/larreguy")
# puts test_score[0]
# puts test_count


# # <%= form_tag articles_path, method: :get, class: "sort-form" do %>
# #     <label for="sort_by">Sort by:</label>
# #      <%= select_tag :sort_by, options_for_select([['Ascending', 'asc'],['Descending', 'desc'] ]), {prompt: "Select an option"} %>
# #      <%= submit_tag "Sort", class: "btn btn-primary" %>
# #   <% end %>
# #   <%= form_tag articles_path, method: :get do %>
# #      <%= label_tag :date, 'Sort by Date:' %>
# #      <%= date_field_tag :date, params[:date] %>
# #      <%= submit_tag 'Sort', class: 'btn btn-warning' %>
# #  <% end %>


# <%= form_with(model: article) do |form| %>
#     <% if article.errors.any? %>
#       <div style="color: red">
#         <h2><%= pluralize(article.errors.count, "error") %> prohibited this article from being saved:</h2>
  
#         <ul>
#           <% article.errors.each do |error| %>
#             <li><%= error.full_message %></li>
#           <% end %>
#         </ul>
#       </div>
#     <% end %>
  
  
#       <%= form.hidden_field :category_label, value: nil %>
  
#     <div>
#       <%= form.submit "Pending", class:"btn btn-warning"%>
#     </div>
#   <% end %>

# elsif params[:published] == "published" && params[:date].present?
   
#     @pagy, @articles = pagy(Article.where(category_label: "published", published: Date.parse(params[:date]).beginning_of_day..Date.parse(params[:date]).end_of_day).order(published: order))
#     @name = "Published"
#   elsif params[:published] == "published"
 
  
#    @pagy, @articles = pagy(Article.where(category_label: "published").order(published: order))
#    @name = "Published"
#   elsif params[:date].present?

#     @pagy,  @articles = pagy(Article.where( published: Date.parse(params[:date]).beginning_of_day..Date.parse(params[:date]).end_of_day).order(published: order))
#     @name = "Pending"
#   else 
#     order = if params[:sort_by] == 'desc' || params[:sort_by].nil?
#          "asc"
#        elsif params[:sort_by] == 'asc'
#         "desc" 
#        end
#     @pagy, @articles = pagy(Article.all.order(published: order))
#     @name = "Pending"

# require 'net/http'
# require 'uri'
# require 'json'

# def search_bing(query)
#   uri = URI('https://api.bing.microsoft.com/v7.0/news/search')
#   uri.query = URI.encode_www_form({ q: query })

#   request = Net::HTTP::Get.new(uri)
#   request['Ocp-Apim-Subscription-Key'] = '26e2390ca1a34767a703fdec8700518f'

#   response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
#     http.request(request)
#   end

#   case response
#   when Net::HTTPSuccess then
#     json_response = JSON.parse(response.body)
#     if json_response.key?("value") && !json_response["value"].empty?
#       return json_response["value"].map { |item| [item["name"], item["url"], item["datePublished"]] }
#     end
#   else
#     raise "Request failed with code #{response.code}"
#   end
# end


  