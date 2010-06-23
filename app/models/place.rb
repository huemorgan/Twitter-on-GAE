class Place
  include DataMapper::Resource
  has n, :trails
 	has 1, :user
  
  property :id,           Serial
  property :tag,          String,         :required => true , :length => (3..20)

  property :name,         String,         :length => 140, :required => false
  # has 1, :writer_name, :model=>'User', :child_key => [ :writer_name_id ], :required => false
    
  property :address,      String,         :length => 140, :required => false
  property :lat,          Float,          :default => 0.0, :required => false
  property :long,         Float,          :default => 0.0, :required => false
  # has 1, :writer_geo, :model=>'User', :child_key => [ :writer_geo_id ], :required => false

  property :category,     String,         :required => false , :length => (3..20)
  # has 1, :writer_category, :model=>'User', :child_key => [ :writer_category_id ], :required => false
  
  property :trail_count,  Integer,        :default => 0
  property :over_3_people,Boolean,        :default => false
  property :created_at,   DateTime
  property :updated_at,   DateTime
  
  def self.find_or_create_place(tag,current_user)
    place = Place.find_by_tag(tag)
    if place.nil?
      place = Place.new(:tag=>tag)
      place.user = current_user
      place.save
    end  
    place
  end
  
  def past_trails(options = {})
    now = Time.now
    @past_trails ||= Trail.all(:datemili.lt=>Time.now.to_i, :place=>self, :order => [ :datemili.desc ], :limit=>(options[:limit] ? options[:limit] : 100))
  end

  def future_trails(options = {})
    now = Time.now
    filters = {:datemili.gt=>Time.now.to_i, :place=>self, :order => [ :datemili.asc ], :limit=>(options[:limit] ? options[:limit] : 100)}
    Trail.all(filters)
  end
      
  def user_trails(user)
    future_trails.select{|t| t.user.id == user.id}
  end
  
  def self.lookfor(prefix)
    Place.all(:conditions => {:tag.gt => prefix, :tag.lt => prefix+"\xfffd"})
  end
end



