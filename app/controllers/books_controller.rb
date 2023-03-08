class BooksController < ApplicationController
  # カテゴリー分けに関するところのみ記載
  def comic
    @comics = Book.where(category:"comic")
  end

def business
  @businesses = Book.where(category:"business")
end

def novel
  @novels = Book.where(category:"novel")
end

 def index
    if params[:latest]
      @books = Book.latest
    elsif params[:old]
      @books = Book.old
      # ★レビュー追加後
    # elsif params[:star_count]
    #   @books = Book.star_count
    else
      @books = Book.all
    
      # タグのAND検索
      if params[:tag_ids]
        @books = []
        params[:tag_ids].each do |key, value|
          if value == "1"
            tag_books = Tag.find_by(name: key).books
            @books = @books.empty? ? tag_books : @books & tag_books
          end
        end
      end
      # ここまで
    end
    if params[:tag]
      Tag.create(name: params[:tag])
    end
    
    @book_new = Book.new
    @user = current_user
    @book_comment = BookComment.new

 end

  def create
    
    @book_new = Book.new(book_params)
    @book_new.user_id = current_user.id
  if @book_new.save
    flash[:notice] = "You have created book successfully."
    redirect_to book_path(@book_new.id)
  else
    @books = Book.all
    @user = current_user
    render :index
  end
  end

  def show
    @book = Book.find(params[:id])
    unless ViewCount.find_by(user_id: current_user.id, book_id: @book.id)
      current_user.view_counts.create(book_id: @book.id)
    end
    @book_comment = BookComment.new
    @book_new = Book.new
    @user = @book.user
    
  end

  def edit
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
   if @book.update(book_params)
     flash[:notice] = "You have updated book successfully."
    redirect_to book_path(@book.id)
   else
    render :edit
   end
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to '/books'

  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :star, :category, tag_ids: [])
  end


end
