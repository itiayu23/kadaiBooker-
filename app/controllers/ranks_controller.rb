class RanksController < ApplicationController
  def rank
    # 投稿数のいいね順
    @book_favorite_ranks = Book.find(Favorite.group(:book_id).order('count(book_id) desc').pluck(:book_id))
    
    # 投稿のコメント多い順
    # @book_comment_ranks = Book.find(Comment.group(:book_id).order('count(book_id) desc').pluck(:book_id))
    
    # 自分の投稿いいねランキング
    @my_book_favorite_ranks = current_user.books.sort { |a, b| b.favorites.count <=> a.favorites.count }
    
  end
end
