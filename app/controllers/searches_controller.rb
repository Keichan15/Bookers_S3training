class SearchesController < ApplicationController
  def search
    @model = params[:model] # フォームで選択した検索対象
    @content = params[:content] # 入力した値
    @method = params[:method] # フォームで選択した検索方法

    if @model == 'user' # フォームで送られた@modelの値が 'user' だった時
      @records = User.search_for(@content, @method) # @records に入っているのは
    else
      @records = Book.search_for(@content, @method)
    end
  end
end
