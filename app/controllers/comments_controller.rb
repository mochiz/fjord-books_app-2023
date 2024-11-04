# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable

  def create
    @comment = @commentable.comments.new(comment_params)

    if @comment.save
      redirect_to @commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      redirect_to @commentable, alert: t('controllers.common.alert_error')
    end
  end

  def destroy
    @comment = @commentable.comments.find(params[:id])

    if @comment.user_id == current_user.id
      @comment.destroy
      redirect_to @commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
    else
      redirect_to @commentable, alert: t('controllers.common.alert_error')
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user)
  end

  def set_commentable
    resource, id = request.path.split('/')[1, 2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end
end
