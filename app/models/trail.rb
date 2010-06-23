class Trail
  include DataMapper::Resource
  belongs_to :user
  belongs_to :place
    
  property :id,       Serial
  property :text,     String,         :required => false, :length => 140
  property :date,     DateTime,       :required => true
  property :datemili, Integer,        :required => false
  timestamps :at 
    
  before :save do
    self.datemili = date.to_time.to_i
    true
  end  
  
  before :create do
    raise "Place don't exist in new created trail" if !place
    place.reload
    place.trail_count += 1
    place.over_3_people = place.future_trails(:limit=>4).length > 3
    place.save!
  end
  
  before :destroy do
    return if !place
    place.reload
    place.trail_count -= 1
    place.over_3_people = place.future_trails(:limit=>4).length > 3
    place.save!
  end
  
end



