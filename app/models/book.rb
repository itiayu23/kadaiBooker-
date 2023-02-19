class Book < ApplicationRecord
   belongs_to :user
   has_one_attached :image
   
   validates :title, presence: true
   validates :opinion,presence: true
   
end
