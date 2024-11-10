# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable
  before_action :set_comment, only: :destroy
  before_action :authenticate_created_user, only: :destroy

  def create
    @comment = @commentable.comments.new(comment_params)

    if @comment.save
      redirect_to @commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      redirect_to @commentable, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy

    redirect_to @commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private

  def set_commentable
    if params[:book_id]
      @commentable = Book.find(params[:book_id])
    elsif params[:report_id]
      @commentable = Report.find(params[:report_id])
    else
      redirect_to root_url, status: :unprocessable_entity
    end
  end

  def set_comment
    @comment = @commentable.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user)
  end

  def authenticate_created_user
    redirect_to @commentable, status: :unauthorized unless @comment.created_by?(current_user)
  end
end
