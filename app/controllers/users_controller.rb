class UsersController < ApplicationController
  def index
     @users = User.all
     @user = current_user
     @books = @user.books
     @book = Book.new

  end

  def show
    @user = User.find(params[:id])

    # DM用コントローラー
    @current_entry = Entry.where(user_id: current_user.id)
    @another_entry = Entry.where(user_id: @user.id)
     
      unless @user.id == current_user.id
        @current_entry.each do |current|
          @another_entry.each do |another|
            if current.room_id == another.room_id then
              @is_room = true
              @room_id = current.room_id
            end
          end
        end
        if @is_room
        else
          @room = Room.new
          @entry = Entry.new
        end
      end
      # ここまでDM
    @books = @user.books
    @book = Book.new
  end

  def edit
    is_matching_login_user
    @user = User.find(params[:id])
  end

  def update

    is_matching_login_user

    @user = User.find(params[:id])
   if @user.update(user_params)
     flash[:notice] = "You have updated user successfully."
    redirect_to user_path(@user.id)
   else
    render :edit
   end
  end

private
def user_params
  params.require(:user).permit(:name, :profile_image, :introduction)
end



   def is_matching_login_user
    user_id = params[:id].to_i
    unless user_id == current_user.id
      redirect_to user_path(current_user.id)
    end
   end
end

