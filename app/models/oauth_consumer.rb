class OauthConsumer
  attr_accessor :worker

  def initialize
    @worker ||= Twitter::OAuth.new(OauthConsumerConfig['token'],
                OauthConsumerConfig['secret'], :sign_in => true)
  end
end
