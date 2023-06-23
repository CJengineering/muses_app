class Medium < ApplicationRecord
    has_one_attached :thumbnail
    has_one_attached :image
    has_one_attached :video 
    has_one_attached :hires_image
    has_many_attached :images
end
