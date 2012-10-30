class HomeController < ApplicationController

  def index
    @title = configatron.app_name
    
    @items = Item.all
  end
  
end
