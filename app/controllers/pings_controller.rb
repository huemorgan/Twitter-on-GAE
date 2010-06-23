class PingsController < ApplicationController
  before_filter :login_required, :except =>[]
  
  # GET /pings
  # GET /pings.xml
  def index
    @pings = Ping.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pings }
    end
  end

  # GET /pings/1
  # GET /pings/1.xml
  def show
    @ping = Ping.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ping }
    end
  end

  # GET /pings/new
  # GET /pings/new.xml
  def new
    @ping = Ping.new
    @ping.icon = "env"

    respond_to do |format|
      format.html { render :layout=>false}
      format.xml  { render :xml => @ping }
    end
  end

  # GET /pings/1/edit
  def edit
    @ping = Ping.find(params[:id])
  end

  # POST /pings
  # POST /pings.xml
  def create
    receiver = User.find(params[:receiver_id])
    if (receiver.nil?)
      respond_to do |format|
          format.html { render :json => {:success=>false}}
          format.xml  { render :xml => {:message=>"receiver_id not valid"}, :status => :unprocessable_entity, :location => @ping }
      end
      return
    end
    
    trail = Trail.find(params[:trail_id])
    @ping = Ping.new(params[:ping])
    @ping.sender = current_user
    @ping.receiver = receiver
    @ping.trail = trail

    respond_to do |format|
      if @ping.save
        direct_message(receiver,"you just got pinged by @#{current_user.twitter_name} #{url_for(receiver)}") if receiver.notify_message
        format.html { render :json => {:success=>true}}
        format.xml  { render :xml => @ping, :status => :created, :location => @ping }
      else
        format.html { render :action => "new", :layout=>false }
        format.xml  { render :xml => @ping.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pings/1
  # PUT /pings/1.xml
  def update
    @ping = Ping.find(params[:id])

    respond_to do |format|
      if @ping.update_attributes(params[:ping])
        flash[:notice] = 'Ping was successfully updated.'
        format.html { redirect_to(@ping) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ping.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pings/1
  # DELETE /pings/1.xml
  def destroy
    @ping = Ping.find(params[:id])
    @receiver = @ping.receiver
    @ping.destroy

    respond_to do |format|
      format.html { redirect_to(@receiver) }
      format.xml  { head :ok }
    end
  end
end
