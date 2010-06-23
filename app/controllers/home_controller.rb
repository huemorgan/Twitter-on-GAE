class HomeController < ApplicationController
  
  def index
    # session[:user_id] = 6
    @trail = Trail.new
    @trail.date = session[:user_save][:date] if session[:user_save]
    # @place= Place.new(:tag=>session[:user_save][:place]) if session[:user_save]

    @places = Place.all(:over_3_people=>true, :limit=>10 ,:order => [ :updated_at.desc])
  end
  
  def test
    places = Place.all
    count = 0
    places.each do |x|
      x.over_3_people = x.future_trails(:limit=>4).length > 1
      x.save
      count += 1
    end
    render :text=>"Count:#{count}"
    return
  end

  def follow
    ret = true
    begin
      ret = ret && current_user.client.friendship_create(twittrail.twitter_id, follow = true)
    rescue Exception => e
      Rails.logger.info (e)
      ret = ret && !!e.to_s.index("already on your list")
    end

    begin
      twittrail.client.friendship_create(current_user.twitter_id, follow = true)
    rescue Exception => e
    end

    if ret 
      current_user.is_following = true
      current_user.save
    end
    render :text => ret ? "ok" : "not ok"
    return
  end
  
  def upgrade
    # places = Place.all
    # places.each do |place|
    #   place.trail_count = 0
    #   place.save
    # end 
    render :text => "ok"
    return
  end
end
