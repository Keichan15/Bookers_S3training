class RoomsController < ApplicationController

  def index
  end

  def show
    @room = Room.find(params[:id])
    @messages = @room.messages.all
    @message = Message.new
    @entries = @room.entries
    @another_entry = @entries.where.not(user_id: current_user.id).first
  end

  def create
    @room = Room.create
    current_entry = Entry.create(room_id: @room.id, user_id: current_user.id)
    another_entry = Entry.create(user_id: params[:entry][:user_id], room_id: @room.id)
    redirect_to room_path(@room)
  end
end
