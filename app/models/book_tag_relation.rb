class BookTagRelation < ApplicationRecord
  belongs_to :Book
  belongs_to :tag
end
