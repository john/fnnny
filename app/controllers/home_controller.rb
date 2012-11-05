class HomeController < ApplicationController

  def index
    @title = configatron.app_name
    @items = Item.find(:all, :order => 'created_at DESC')
  end
  
  def bookmarklet
    respond_to do |format|
      format.html
      format.js
    end
  end
  
end
