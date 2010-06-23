class PlacesController < ApplicationController
  before_filter :login_required, :except =>[:show,:index]
  # GET /places
  # GET /places.xml
  def index
    @places = Place.lookfor(params[:q])
    @places = @places.map{|p| {:tag=>p.tag,:id=>p.id,:name=>p.name}}
    respond_to do |format|
      format.xml  { render :xml => @places }
    end
  end

  # GET /places/1
  # GET /places/1.xml
  def show
    @place = params[:tag] ? Place.find_by_tag(params[:tag]) : Place.find(params[:id])
    @place && @place.trails.sort! {|x,y| x.date <=> y.date }
    
    if (session[:user_save] != nil) # get back data from session after login
      @before_date = session[:user_save][:date]
    end    
    
    respond_to do |format|
      format.html { 
        if !@place 
          render 'no_place', :layout => "home"
          return
        end
      }
      format.xml  { render :xml => @place }
      format.json {render :json => @place}
    end
  end
  
  def map
    @place = Place.find(params[:id])
    respond_to do |format|
      format.html { render :layout => true }
    end
  end

  # GET /places/new
  # GET /places/new.xml
  def new
    @place = Place.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @place }
    end
  end

  # GET /places/1/edit
  def edit
    @place = Place.find(params[:id])
  end

  # POST /places
  # POST /places.xml
  def create
    @place = Place.new(params[:place])

    respond_to do |format|
      if @place.save
        flash[:notice] = 'Place was successfully created.'
        format.html { redirect_to(@place) }
        format.xml  { render :xml => @place, :status => :created, :location => @place }
      else
        format.html { render :action => "new", :layout=>false }
        format.xml  { render :xml => @place.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /places/1
  # PUT /places/1.xml
  def update
    @place = Place.find(params[:id])

    respond_to do |format|
      if @place.update_attributes(params[:place])
        flash[:notice] = 'Place was successfully updated.'
        format.html { redirect_to(@place) }
        format.xml  { head :ok }
        format.json { render :nothing =>  true }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @place.errors, :status => :unprocessable_entity }
        format.json { render :nothing =>  true }
      end
    end
  end

  
  # DELETE /places/1
  # DELETE /places/1.xml
  def destroy
    @place = Place.find(params[:id])
    @place.destroy

    respond_to do |format|
      format.html { redirect_to(places_url) }
      format.xml  { head :ok }
    end
  end
end
