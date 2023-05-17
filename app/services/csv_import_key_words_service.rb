class CsvImportKeyWordsService
    require 'csv'
  
    def call(file)
      file = File.open(file)
      csv = CSV.parse(file, headers: true)
      csv.each do |row|
        key_word_hash = {}
        key_word_hash[:key_word] = row['key word']
        key_word_hash[:rss_url] = row['rss']
        key_word_hash[:factiva] = false
      
        KeyWord.find_or_create_by!(key_word_hash)
        # binding.b
        # p row
      end
    end
  end

