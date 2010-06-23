class Ping
  include DataMapper::Resource
  belongs_to :sender,   :model=>'User'
  belongs_to :receiver, :model=>'User'
  belongs_to :trail
  
  property :id,   Serial
  property :text, String,        :required => false, :length => 500
  property :icon, String,        :required => true, :length => 20
  timestamps :at
end
