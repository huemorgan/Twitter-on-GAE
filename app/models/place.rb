class Place
  include DataMapper::Resource
  has_many :trails
  
  property :id,       String
  property :name,     String,        :required => true, :length => 140
  property :tag,      String,        :required => false
  timestamps :at 
end



