class TrailsController < ApplicationController
  # GET /trails
  # GET /trails.xml
  def index
    @trails = Trail.all

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
      format.html # show.html.erb
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
  end

  # POST /trails
  # POST /trails.xml
  def create
    @trail = Trail.new(params[:trail])

    respond_to do |format|
      if @trail.save
        flash[:notice] = 'Trail was successfully created.'
        format.html { redirect_to(@trail) }
        format.xml  { render :xml => @trail, :status => :created, :location => @trail }
      else
        format.html { render :action => "new" }
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
        format.html { redirect_to(@trail) }
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
    @trail.destroy

    respond_to do |format|
      format.html { redirect_to(trails_url) }
      format.xml  { head :ok }
    end
  end
end
