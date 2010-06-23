class User
  include DataMapper::Resource
  has n, :trails
  has n, :pings_sent, :model=>'Ping', :child_key => [ :sender_id ]
  has n, :pings_received, :model=>'Ping', :child_key => [ :receiver_id ]
  
  property :id,           Serial
  property :name,         String,        :required => true, :length => 500
  property :twitter_name, String,        :required => true, :length => 500
  property :twitter_id,   Integer,       :required => true
  property :atoken,       String,        :required => true, :length => 500
  property :asecret,      String,        :required => true, :length => 500
  property :is_following, Boolean,       :default=> false 
  property :photo_url,    Link,          :required => true
  
  property :trailcount,   Integer,       :required => true, :default => 0

  property :notify_message,       Boolean,       :default=> true 
  property :twitt_trail_new,      Boolean,       :default=> true 
  property :twitt_trail_oneline,  Boolean,       :default=> true 
  
  property :place_id,             Integer,       :default=> true , :default=>123

  timestamps :at 
  

  def self.create_from_oauth!(oauth_worker)
    user = new(:atoken => oauth_worker.access_token.token,
             :asecret => oauth_worker.access_token.secret,
             :created_at => Time.now)
    user.update_twitter_info
    user.save
  end
    
  def update_from_oauth!(oauth_worker)
    self.atoken = oauth_worker.access_token.token
    self.asecret = oauth_worker.access_token.secret
    update_twitter_info
    save
    self
  end  
  
  def update_twitter_info
    twitter_info = client.verify_credentials
    self.name = twitter_info[:name]
    self.twitter_name = twitter_info[:screen_name]
    self.twitter_id = twitter_info[:id].to_i
    self.photo_url = twitter_info[:profile_image_url]
  end
  
  def client
    if !@oauth
      @oauth = Twitter::OAuth.new(OauthConsumerConfig['token'],
                  OauthConsumerConfig['secret'], :sign_in => true)
      @oauth.authorize_from_access(self.atoken, self.asecret)
    end
    @client ||= Twitter::Base.new(@oauth)
  end
    
  def past_trails
    now = Time.now
    trails.select {|t| t.date <= now}
  end

  def future_trails
    now = Time.now
    trails.select {|t| t.date > now}
  end   
  
  def photo_url_big
    !photo_url.index("default_profile") ? photo_url.sub("_normal","") : photo_url
  end 
end
# 
# 
# u = User.new
# u.name = "moshe"
# u.twitter_name = "moshe"
# u.twitter_id = 123456
# u.description = "moshe"
# u.created_at = Time.now
# u.atoken = "kishkkushkishkkushkishkkush"
# u.photo_url = "http://photourl"
