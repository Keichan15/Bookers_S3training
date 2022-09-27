class BooksController < ApplicationController

  def index
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
    @books = Book.includes(:favorited_users).
      sort_by { |x|
        x.favorited_users.includes(:favorites).where(created_at: from...to).size
  }.reverse
    @book = Book.new
    @user = current_user
    @book_comment = BookComment.new
    @rank_books = Book.order(impressions_count: 'DESC') # ソート機能を実装(閲覧数を降順で表示)
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: 'You have created book successfully.'
    else
      @user = current_user
      @books = Book.all
      render :index
    end
  end

  def show
    @book = Book.find(params[:id])
    @newbook = Book.new
    @user = @book.user
    @book_comment = BookComment.new
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
    impressionist(@book, nil, unique: [:ip_address]) #Bookの詳細ページにアクセスすると閲覧数が1つ増える。
  end

  def edit
    @book = Book.find(params[:id])
    if @book.user == current_user
      render 'edit'
    else
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: 'You have updated book successfully.'
    else
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
end
