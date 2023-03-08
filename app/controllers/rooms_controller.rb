class RoomsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @room = Room.create
    @current_entry = Entry.create(user_id: current_user.id, room_id: room.id)
    @another_entry = Entry.create(params.require(:entry).permit(:user_id, :room_id).merge(room_id: @room.id))
    redirect_to "/rooms/#{@room.id}"
  end
  
  def index
    # ログインユーザー所属ルームID取得
    current_entries = current_user.entries
    my_room_id = []
    current_entries.each do |entry|
      my_room_id << entry.room.id
    end
    # 自分のroom_idでuser_idが自分じゃないのを取得
    @another_entries = Entry.where(room_id: my_room_id).where.not(user_id: current_user.id)
    
  end
  
  def show
    @room = Room.find(params[:id])
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
    @messages = @room.messages.all
    @message = Message.new
    @entries = @room.entries
    else
     redirect_back(fallback_location: room_path)
    end
    
    
  end
end