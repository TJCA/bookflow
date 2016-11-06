class RecordsController < ApplicationController
  load_and_authorize_resource
  
  def user_index
    @user_records = Record.where(:subject => current_user.school_id).order(updated_at: :desc).paginate(:page => (params[:page]) ? params[:page].to_i : 1, :per_page => 10)
  end
end