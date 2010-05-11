class Trail
  include DataMapper::Resource
  belongs_to :user
  belongs_to :place
    
    property :id,       String
    property :text,     String,        :required => true, :length => 140
    property :date,    Date,          :required => false
    timestamps :at 
end



