class SessionController < ApplicationController
  
  def new
    if try_twice {
        oauth.set_callback_url(url_for(:action=>"create"))
        session['rtoken'] = oauth.request_token.token
        session['rsecret'] = oauth.request_token.secret
        redirect_to oauth.request_token.authorize_url
      } == false
      render :text => "Hurg... twitter timed out again <a href='/session/new'>Give it another try</a> "
      return
    end
  end
  
  def new_save
    session[:user_save] = {}

    # when creating new trail
    session[:user_save][:back_url] = params[:back_url] if params[:back_url]
    session[:user_save][:place] = params[:trail][:place] if params[:trail] && params[:trail][:place]
    session[:user_save][:date] = params[:trail][:date] if params[:trail] && params[:trail][:date]

    # when pinging
    session[:user_save][:trail_id] = params[:trail_id] if params[:trail_id]

    redirect_to :action=>"new" 
  end
  
  def create
    if try_twice {
        oauth.authorize_from_request(session['rtoken'],session['rsecret'],params['oauth_verifier'])
      } == false
      render :text => "Hurg... twitter timed out again (2) <a href='/session/new'>Give it another try</a> "
      return
    end
        
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
      if try_twice {
        user = User.create_from_oauth!(oauth_worker)
        } == false
        render :text => "Hurg... twitter timed out again (3) <a href='/session/new'>Give it another try</a> "
        return
      end 
      user = User.find_by_twitter_id(twitter_info[:id].to_i)
      login_user(user)
    end
  end

  def login_user(user)
    session[:user_id] = user.id

    flash[:notice] = 'Twitter login successfull - please continue and add your trail'      
    if (session[:user_save])
      if (session[:user_save][:trail_id])
        # redirect back from ping - cuz we have trail_id
        t = Trail.get(session[:user_save][:trail_id])
        session[:user_save] = nil
        redirect_to t.place
      else
s        # redirect back from new trail
        redirect_to session[:user_save][:back_url]
        return
      end
    else
      redirect_to root_path
      return
    end
  end

  def clear_session
    session['rtoken'] = nil
    session['rsecret'] = nil
  end


end