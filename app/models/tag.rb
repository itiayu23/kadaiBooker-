class Tag < ApplicationRecord
  
  # Tagsテーブルから中間テーブルに対する関連付け
  has_many :book_tag_relations, dependent: :destroy
  # Tagsテーブルから中間テーブルを介してArticleテーブルへの関連付け
  has_many :books, through: :book_tag_relations, dependent: :destroy
end
