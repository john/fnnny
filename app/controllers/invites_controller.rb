class InvitesController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :require_admin, :except => [:create, :update]
  
  # GET /invites
  # GET /invites.json
  def index
    @invites = Invite.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @invites }
    end
  end

  # GET /invites/1
  # GET /invites/1.json
  def show
    @invite = Invite.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @invite }
    end
  end

  # GET /invites/new
  # GET /invites/new.json
  def new
    @invite = Invite.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @invite }
    end
  end

  # GET /invites/1/edit
  def edit
    @invite = Invite.find(params[:id])
  end

  # POST /invites
  # POST /invites.json
  def create
    if params[:invite]
      @invite = Invite.new(invite_params)
    elsif params[:user_id]
      @invite = Invite.new(:user_id => params[:user_id], :request_id => params[:request_id], :to_id => params[:to_id] )
    end
    @invite.state = 'sent' if @invite.state.blank?

    respond_to do |format|
      if @invite.save
        format.html { redirect_to @invite, notice: 'Invite was successfully created.' }
        format.json { render json: @invite, status: :created, location: @invite }
      else
        format.html { render action: "new" }
        format.json { render json: @invite.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invites/1
  # PATCH/PUT /invites/1.json
  def update
    @invite = Invite.find(params[:id])

    respond_to do |format|
      if @invite.update_attributes(invite_params)
        format.html { redirect_to @invite, notice: 'Invite was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @invite.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invites/1
  # DELETE /invites/1.json
  def destroy
    @invite = Invite.find(params[:id])
    @invite.destroy

    respond_to do |format|
      format.html { redirect_to invites_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def invite_params
      params.require(:invite).permit(:request_id, :state, :to_id, :user_id)
    end
end
