class BooksController < ApplicationController
    #onlyで指定したメソッドだけにログイン済ユーザーのみにアクセスを許可する
    before_action :authenticate_user!,only: [:create,:edit,:update,:destroy,:index]

    def index
      @books = Book.all
      @book = Book.new
    end

    def show
        @book = Book.find(params[:id])
        @book_comment = BookComment.new
        @book_comments = @book.book_comments#wakaran
    end

    def edit
        @book = Book.find(params[:id])
        screen_user(@book)#wakaran
    end

    def create#wakaran
        @book = Book.new(book_params)
        @book.user_id = current_user.id
        if @book.save
            redirect_to @book
        else
            @books = Book.all
            render 'index'
        end
    end

    def update
        @book = Book.find(params[:id])
        if @book.update(book_params)
            redirect_to @book
        else
            render 'edit'
        end
    end

    def destroy
        @book = Book.find(params[:id])
        @book.destroy
        redirect_to book_url
    end

    private
    def book_params
      params.require(:book).permit(:title, :body)
    end

    def screen_user(book)#wakaran
        if book.user.id != current_user.id
            redirect_to books_path
        end
  end
end
