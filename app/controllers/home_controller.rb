class HomeController < ApplicationController

  def index
    @title = "#{configatron.app_name}: Delight and amuse"
    
    # all items
    @items = Item.find(:all, :order => 'created_at DESC')
    
    # items from followers
    # @items = ...
    
  end
  
  def bookmarklet
    respond_to do |format|
      format.html
      format.js
    end
  end
  
end
