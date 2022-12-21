class LikesController < ApplicationController

  before_action :authenticate_user!

  def index
    @likes = current_user.likes.order('created_at DESC')
  end
  
  def create
    @like = current_user.likes.where(like_params).first_or_initialize
    @like.assign_attributes(like_params)

    if @like.save
      respond_to do |format|
        format.json { render json: @like.to_json, status: :ok }
      end
    else
      respond_to do |format|
        format.json { render json: @like.errors.to_json, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @like = current_user.likes.where(like_params).first
    if @like.destroy
      respond_to do |format|
        format.json { render json: {}, status: :ok }
      end
    else
      respond_to do |format|
        format.json { render json: {}, status: :unprocessable_entity }
      end
    end
  end
  
  private

  def like_params
    params.require(:like).permit(:resource_type, :resource_id)
  end

end
