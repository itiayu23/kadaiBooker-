class BooksController < ApplicationController
  def index
    @books = Book.all
    @books = Books.all.order(created_at: :desc)
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
    params.require(:book).permit(:title, :body, :star)
  end


end
