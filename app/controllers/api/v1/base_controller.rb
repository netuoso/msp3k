class Api::V1::BaseController < ApplicationController
  
  protect_from_forgery with: :null_session

  before_action :verify_api_key

  private

  def verify_api_key
    raise "You must provide a user and api_key" unless permitted_params[:app_user].present? && permitted_params[:api_key].present?
    @apiuser = User.where('lower(username) like lower(?)', permitted_params[:app_user]).first
    @apiuser.update!(provided_api_key: nil)
    @apiuser.update!(provided_api_key: permitted_params[:api_key].upcase)
    authorize @apiuser, :verify_api_key
  end

  def permitted_params
    params.permit(:app_user,:api_key,:bots,:url)
  end

end