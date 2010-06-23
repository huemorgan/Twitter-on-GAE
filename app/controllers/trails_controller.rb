class TrailsController < ApplicationController
  before_filter :login_required, :except =>[:show]
  # GET /trails
  # GET /trails.xml
  def index
    # @trails = Trail.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @trails }
    end
  end

  # GET /trails/1
  # GET /trails/1.xml
  def show
    @trail = Trail.find(params[:id])

    respond_to do |format|
      format.html { render :layout=>false }
      format.xml  { render :xml => @trail }
    end
  end

  # GET /trails/new
  # GET /trails/new.xml
  def new
    @trail = Trail.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @trail }
    end
  end

  # GET /trails/1/edit
  def edit
    @trail = Trail.find(params[:id])
    render :layout=>false
  end

  # POST /trails
  # POST /trails.xml
  def create
    session[:user_save] = nil
    # create place
    @place = Place.find_or_create_place(params[:trail][:place].downcase,current_user)
    # create trail
    @trail = Trail.new()
    @trail.date = params[:trail][:date]
    # update trail
    @trail.user = current_user
    @trail.place = @place

    respond_to do |format|
      if @place.errors.length==0 && @trail.save
        flash[:notice] = 'Trail was successfully created.'
        format.html { render :json => {:success=>true,:redirect_to=>url_for(@place)}}
        format.xml  { render :xml => @trail, :status => :created, :location => @trail }
      else
        @trail.errors.add(:place, "Place name must be 3 to 20 characters long") if !@place.errors.length==0
        format.html { render :action => "new", :layout=>false }
        format.xml  { render :xml => @trail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /trails/1
  # PUT /trails/1.xml
  def update
    @trail = Trail.find(params[:id])

    respond_to do |format|
      if @trail.update_attributes(params[:trail])
        flash[:notice] = 'Trail was successfully updated.'
        format.html { redirect_to(@trail.place) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @trail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /trails/1
  # DELETE /trails/1.xml
  def destroy
    @trail = Trail.find(params[:id])
    if (@trail.user.id != current_user.id)
      respond_to do |format|
        format.html { render :text=> "not allowed" }
        format.xml  { head :not_allowed }
      end
      return
    end     
    place = @trail.place
    @trail.destroy

    respond_to do |format|
      format.html { redirect_to(place) }
      format.xml  { head :ok }
    end
  end
end
