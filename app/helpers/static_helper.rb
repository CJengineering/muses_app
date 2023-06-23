module StaticHelper
    def create_webflow(slug, name,description)
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
            'high-res'=>description,
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
end
