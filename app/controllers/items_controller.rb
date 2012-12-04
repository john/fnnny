class ItemsController < ApplicationController
  require 'addressable/uri'
  
  before_filter :authenticate_user!, :except => [:show]
  
  protect_from_forgery :except => :create 
  
  def more
    if signed_in?
      @items = Item.order('created_at DESC').paginate( :page => params[:page], :per_page => Item::PER_PAGE )
      
      if @items.present?
        @out = ''
        @items.each do |item|
          @out += '<li>'
          @out += render_to_string :partial => "items/item_mobile", :locals => {:item => item}
          @out += '</li>'
        end
        
        unless @items.size < Item::PER_PAGE
          @out += render_to_string :partial => '/items/more', :locals => {:page => params[:page]}
        end
        
      else
        @out = ''
      end
    end
    
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  
  def since
    if signed_in?
      
      @since_item = Item.find( params[:id] )
      @items = Item.where("created_at > '#{@since_item.created_at}'").order('created_at DESC').limit(20)
      
      @out = ''
      
      if @items.blank?
        @out += "<div style='padding: 5px 20px; font-style: italic; background-color: #eee; border-bottom: 1px solid #ccc;' class='items_since'>"
        @out += "<a class='btn' style='float: right;' href='#' onclick=\"$('.items_since').fadeOut();\">close</a>"
        @out += "<small>#{Time.now.strftime("%l:%M%P")}</small>"
        @out += "<div style='font-weight: bold;'>No updates</div>"
        @out += '</div>'
      else
        @since = @items.first.created_at
        # @out = '<script>'
        # @out = "alert('phu');"
        # @out = '</script>'
        
        @items.each do |item|
          @out += '<li>'
          @out += render_to_string :partial => "items/item_mobile", :locals => {:item => item}
          @out += '</li>'
        end
      end
      
    end
    # render :text => @out
  end
  
  def before
  end
  
  def like
    if signed_in?
      @item = Item.find(Base64.urlsafe_decode64(params[:id]))
      current_user.vote_exclusively_for(@item)
      @suggest_facebook = true
      render :partial => "items/like_or_unlike", :locals => {:item => @item}
    end
  end
  
  def clear_vote
    if signed_in?
      @item = Item.find(Base64.urlsafe_decode64(params[:id]))
      current_user.unvote_for(@item)
      render :partial => "items/like_or_unlike", :locals => {:item => @item}
    end
  end
  
  def unlike
    if signed_in?
      @item = Item.find(Base64.urlsafe_decode64(params[:id]))
      current_user.vote_exclusively_against(@item)
      @suggest_facebook = true
      render :partial => "items/like_or_unlike", :locals => {:item => @item}
    end
  end
  
  
  # GET /items
  # GET /items.json
  def index
    if current_user.admin?
      @items = Item.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @items }
      end
    else
      redirect_to root_path, :alert => 'Not fnnny.'
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @item = Item.find(params[:id])
    @title = @item.name
    user_agent = UserAgent.parse( request.env["HTTP_USER_AGENT"] )
    @mobile = true #if user_agent.present? && (user_agent.platform == 'iPhone' || (user_agent.mobile? && user_agent.platform == 'Android'))
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/new
  # GET /items/new.json
  def new
    @item = Item.new
    
    if params[:u] && params[:t]
      @item.url = params[:u] if params[:u]
      if params[:t]
        if params[:t].include?('|')
          title = params[:t].split('|')[0].strip
        else
          title = params[:t]
        end
        @item.name = title
      end
      @item.user_id = current_user.id
      @bookmarklet_view = true
    end

    respond_to do |format|
      format.html do
        render :layout => 'popup' if @bookmarklet_view
      end
      format.json { render json: @item }
    end
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
    @item.belongs_to(current_user)
  end

  # POST /items
  # POST /items.json
  def create
    
    # TODO:
    # - find_or_create_by_url?
    # - be sure to normalize URLs (including removing tracking code, if possible)
    # - create association to found/created item
    # - update code elsewhere to attach stuff to the join (comments, images, likes, etc.)
    @item = Item.new(item_params)
    @item.user_id = current_user.id
    @item.name = @item.name.split('|')[0].strip if @item.name.include?('|')
    @item.user.tag(@item, :with => params[:tag_list], :on => :tags) if params[:tag_list]
    @item.url = Addressable::URI.parse( @item.url ).normalize.to_s unless @item.url.blank?
    
    if @item.original_image_url.present?
      @item.remote_image_url = @item.original_image_url
    end
    
    respond_to do |format|
      if @item.save
        
        format.html do
          if params[:bookmarklet] == 'true'
            render :partial => "items/thanks_bye"
          else
            redirect_to @item, notice: 'Item was successfully created.'
          end
        end
        format.json { render json: @item, status: :created, location: @item }
      else
        format.html { render action: "new" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.json
  def update
    @item = Item.find(params[:id])
    @item.belongs_to(current_user)
    
    respond_to do |format|
      if @item.update_attributes(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item = Item.find(params[:id])
    @item.belongs_to(current_user) unless current_user.admin?
    
    @item.destroy
    
    respond_to do |format|
      format.html { redirect_to items_path, :notice => "Gone forever." }
      format.json { head :no_content }
    end
  end
  
  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def item_params
      params.require(:item).permit(:description, :latitude, :location, :longitude, :name, :url, :image, :image_cache, :original_image_url, :user_id, :tag_list)
    end
end
