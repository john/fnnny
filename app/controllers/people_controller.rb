class PeopleController < ApplicationController

  def show
    @user = User.find(params[:id])
  end
  
end
