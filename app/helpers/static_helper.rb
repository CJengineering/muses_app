module StaticHelper
  def transform_string(input_string, max_length = 256)
    sanitized_string = input_string.gsub(/[^a-zA-Z0-9 ]/, ' ')
  
  words = sanitized_string.split(' ')
  result = []
  current_length = 0

  words.each do |word|
    if current_length + word.length + result.length <= max_length
      result << word
      current_length += word.length
    else
      break
    end
  end

  result.join('-').downcase
  end

  def create_webflow(slug, name, description)
    collection_id = '6463241b942400c686377f1f'
    api_token = '0fc8c24824ead0d28a472c2b884aa58e05c635fbd1a0dd7b59aeb1b72bd8cfd7'

    url = URI.parse("https://api.webflow.com/collections/#{collection_id}/items")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url.path)
    request['accept'] = 'application/json'
    request['authorization'] = "Bearer #{api_token}"
    request['content-type'] = 'application/json'

    request.body = {
      'fields' => {
        'slug' => slug,
        'name' => name,
        'high-res' => description,
        '_archived' => false,
        '_draft' => false
      }
    }.to_json

    response = http.request(request)

    if response.code.to_i == 201
      item_id = JSON.parse(response.body)['data']['_id']
      puts "Item created successfully. Item ID: #{item_id}"
    else
      puts "Failed to create item. Error: #{response.body}"
    end
  end

  def create_webflow_news(slug, name, arabic_title, description, external_link)
    # collection_id = '6463241b942400c686377f1f'
    # api_token = '0fc8c24824ead0d28a472c2b884aa58e05c635fbd1a0dd7b59aeb1b72bd8cfd7'

    collection_id = '61ee828a15a3185c99bde543'
    api_token = '77c77368fbc66f79d70e2150c7e2108853bf41dc45d0849576e504e8eb3bd73f'

    url = URI.parse("https://api.webflow.com/beta/collections/#{collection_id}/items")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url.path)
    request['accept'] = 'application/json'
    request['authorization'] = "Bearer #{api_token}"
    request['content-type'] = 'application/json'
    slug_modified = transform_string(slug)
    puts slug_modified
    data = {
      isArchived: false,
      isDraft: true,
      fieldData: {
        name:,
        'arabic-title' => arabic_title,
        slug: slug_modified,
        'external-link' => external_link,
        summary: description
      }
    }
    request.body = data.to_json

    response = http.request(request)

    if response.code.to_i == 201
      item_id = JSON.parse(response.body)['data']['_id']
      puts "Item created successfully. Item ID: #{item_id}"
    else
      puts "Failed to create item. Error: #{response.body}"
    end
  end
end
