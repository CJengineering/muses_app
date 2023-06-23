class KeyWord < ApplicationRecord
    require 'date'
    has_many :articles, dependent: :destroy
    has_many :gosearts, dependent: :destroy
    has_many :factiva_articles, dependent: :destroy
    #after_initialize :initialize_keyword



    def has_new_article 
       if self.articles.count > 0  
           self.articles.each do |article|
              article_date= DateTime.parse(article.published)
              time_diff= (DateTime.now - article_date) * 24
              if time_diff < 72
                return true
              end
             end
       end
      false
       
    end

end
# article_date= DatTime.parse(article.published)
# time_diff= (DatTime.now - article_date) * 24
# if time_diff < 72
#  return true
# end