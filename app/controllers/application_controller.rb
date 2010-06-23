# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  helper_method :current_user, :logged_in?
  
  # rescue_from Twitter::Unauthorized, :with => :force_sign_in

  private
  def current_user
    return nil unless session[:user_id]
    @current_user ||= User.find_by_id session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def login_required
    !!current_user || access_denied
  end

  def access_denied
    respond_to do |format|
      format.json { render :json=> "Login required.".to_json, :status => :forbidden }
      format.html { redirect_to "/session/new"}
    end
  end  
  
  def oauth
    @oauth ||= Twitter::OAuth.new(OauthConsumerConfig['token'],
                OauthConsumerConfig['secret'], :sign_in => true)
  end

  # def client
  #   oauth.authorize_from_access(session[:atoken], session[:asecret])
  #   @client ||= Twitter::Base.new(oauth)
  # end
  # helper_method :client
  
  def twittrail
    @twittrail = User.first(:twitter_name => 'twit_trail')
  end
  helper_method :twittrail

  def direct_message(to,text)
    to.client.direct_message_create(to.twitter_id,"@twit_trail " + text)
  end  

  def update_status(user,text)
    user.client.update(text)
  end

  def force_sign_in(exception)
    reset_session
    flash[:error] = 'Seems your credentials are not good anymore. Please sign in again.'
    redirect_to new_session_path
  end
  
  def try_twice(&block)
    retries = 0
    begin
      block.call
      return true
    rescue AppEngine::URLFetch::DownloadError => e
      if retries==0 
        retries+=1
        retry
      end
      return false
    end
  end  
end
