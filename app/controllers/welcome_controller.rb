class WelcomeController < ApplicationController
  before_action do
    if session[:current_user_id] != nil
      redirect_to profile_url
    end
  end

  def index
  end

end
