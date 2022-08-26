class UsersController < ApplicationController

  def index
    @users = User.all
    @user = current_user
    @book = Book.new
  end

  def show
    @user = User.find(params[:id])
    @book = Book.new
    @books = @user.books
    @current_entry = Entry.where(user_id: current_user.id) # ログインしているユーザー情報と合致するデータをEntryより取得
    @another_entry = Entry.where(user_id: @user.id) # メッセージ相手のユーザー情報をEntryより取得
    unless @user.id == current_user.id # paramsで取得したuser.idがログインユーザーと同一でなければ…
      @current_entry.each do |current| 
        @another_entry.each do |another|
          if current.room_id == another.room_id # 取得した2種類の情報から
            @is_room = true
            @room_id = current.room_id
          end
        end
      end
      unless @is_room # roomが存在しなければ…
        @room = Room.new # 新しくroomを作成
        @entry = Entry.new
      end
    end
  end

  def edit
    @user = User.find(params[:id])
    if @user == current_user
      render 'edit'
    else
      redirect_to user_path(current_user)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'You have updated user successfully.'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end
end
