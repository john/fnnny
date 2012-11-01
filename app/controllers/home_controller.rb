class HomeController < ApplicationController

  def index
    @title = configatron.app_name
    @items = Item.all
  end
  
  def fnnnymarklet
    respond_to do |format|
      format.js
    end
  end
  
end
