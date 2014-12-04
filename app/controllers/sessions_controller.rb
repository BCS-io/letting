#####
#
# SessionsController
#
# Handles the authentication into the system.
#
# Users 'log into' the system when a create action occurs.
# Users 'log out' of the system when a destroy action occurs.
#
# When a user authenticates the user_id it is saved in the session.
# The application accesses the user_id through the application_controller using
# the current_user. Each request has the session's user_id verify against the
# the application database's users table.
#
#####
#
class SessionsController < ApplicationController
  def create
    user = user_from_email
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, flash: { info: 'Logged in!' }
    else
      alert_authentication_failed
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, flash: { info: 'Logged out!' }
  end

  private

  def user_from_email
    User.find_by email: params[:email]
  end

  def alert_authentication_failed
    flash.now.alert = 'Email or password is invalid'
  end
end
