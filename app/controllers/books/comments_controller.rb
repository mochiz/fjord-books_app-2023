# frozen_string_literal: true

module Books
  class CommentsController < ApplicationController
    before_action :set_book

    def create
      comment = @book.comments.new(comment_params)
      comment.user = current_user

      if comment.save
        redirect_to @book, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
      else
        redirect_to @book, status: :unprocessable_entity
      end
    end

    def destroy
      comment = current_user.comments.find(params[:id])
      comment.destroy

      redirect_to @book, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
    end

    private

    def set_book
      @book = Book.find(params[:book_id])
    end

    def comment_params
      params.require(:comment).permit(:body)
    end
  end
end
