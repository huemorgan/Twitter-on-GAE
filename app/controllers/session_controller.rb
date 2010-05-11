class SessionController < ApplicationController
  
  def new
    oauth.set_callback_url(url_for(:action=>"create"))
    session['rtoken'] = oauth.request_token.token
    session['rsecret'] = oauth.request_token.secret
    redirect_to oauth.request_token.authorize_url
  end

  def create
    oauth.authorize_from_request(session['rtoken'],session['rsecret'],params['oauth_verifier'])
        
    login_or_create_user_from_oauth(oauth)
  end

  def destroy
    reset_session
    redirect_to root_url
  end

  private
  
  def login_or_create_user_from_oauth(oauth_worker)
    client = Twitter::Base.new(oauth_worker)
    twitter_info = client.verify_credentials

    if user = User.find_by_twitter_id(twitter_info[:id].to_i)
      user.update_from_oauth!(oauth_worker)
      login_user(user)
    else
      user = User.create_from_oauth!(oauth_worker)
      login_user(user)
    end
  end

  def login_user(user)
    session[:user_id] = user.id
    redirect_to root_path
    return
  end

  def clear_session
    session['rtoken'] = nil
    session['rsecret'] = nil
  end


end