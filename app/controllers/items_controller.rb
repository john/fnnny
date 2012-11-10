class ItemsController < ApplicationController
  
  before_filter :authenticate_user!
  
  protect_from_forgery :except => :create 
  
  
  def like
    if signed_in?
      @item = Item.find(Base64.urlsafe_decode64(params[:id]))
      current_user.vote_exclusively_for(@item)
      @suggest_facebook = true
      render :partial => "items/like_or_unlike", :locals => {:item => @item}
    end
  end
  
  def unlike
    if signed_in?
      @item = Item.find(Base64.urlsafe_decode64(params[:id]))
      current_user.unvote_for(@item)
      render :partial => "items/like_or_unlike", :locals => {:item => @item}
    end
  end
  
  
  # GET /items
  # GET /items.json
  def index
    @items = Item.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items }
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @item = Item.find(params[:id])

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
      @item.name = params[:t] if params[:t]
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
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)
    @item.user.tag(@item, :with => params[:tag_list], :on => :tags) if params[:tag_list]

    respond_to do |format|
      if @item.save
        
        Cloudinary::Uploader.upload(@item.original_img_url, :public_id => @item.id, :eager => {:width => 320, :format => 'png'})
        
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
    @item.destroy

    respond_to do |format|
      format.html { redirect_to root_path, :notice => "Gone forever." }
      format.json { head :no_content }
    end
  end
  
  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def item_params
      params.require(:item).permit(:description, :latitude, :location, :longitude, :name, :url, :original_img_url, :small_img_url, :medium_img_url, :large_img_url, :square_img_url, :user_id, :tag_list)
    end
end
