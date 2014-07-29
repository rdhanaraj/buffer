class AuthenticationsController < ApplicationController
  def index
    @authentications = current_user.authentications.all if current_user

    redirect_to edit_user_registration_path
  end

  def create
    omniauth =  request.env['omniauth.auth']
    current_user.authentications.find_or_create_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    flash[:notice] = omniauth['provider'].capitalize + ' authentication a success!'

    session[:omniauth] = omniauth.except 'extra'
    redirect_to authentications_path
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    redirect_to authentications_url, :notice => "Successfully destroyed authentication."
  end
end
