class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!


  def update
    if current_user.update(user_params)
      if current_user.admin?
        UpdateUserJob.perform_later(current_user.id)  # <- The job is queued
      end
      flash[:notice] = "Your profile has been updated"
      redirect_to root_path
    else
      render :edit
    end
  end



end
