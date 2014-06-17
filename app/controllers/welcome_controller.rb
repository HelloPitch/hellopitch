class WelcomeController < ApplicationController

  def index
  end

  def oauth2
    session[:state] = rand(99999999999999).to_s
    callback = "#{url_by_env}/oauth2_callback"
    url_params = ['response_type=code',
                  "client_id=#{ENV['LINKED_IN_KEY']}",
                  'scope=r_fullprofile,r_emailaddress,r_network,r_contactinfo',
                  "state=#{session[:state]}",
                  "redirect_uri=#{CGI.escape(callback)}"]
    redirect_to "https://www.linkedin.com/uas/oauth2/authorization?#{url_params.join('&')}"
  end

  def oauth2_callback
    if session[:state] != params[:state]
      render :text => 'state does not match'
      return
    end

    if params[:error]
      render :text => 'authorization failed.'
      return
    end

    callback = "#{url_by_env}/oauth2_callback"
    uri = URI.parse 'https://www.linkedin.com/uas/oauth2/accessToken'
    request = Net::HTTP::Post.new(uri.path)
    request.set_form_data({grant_type: 'authorization_code',
                           code: params[:code],
                           redirect_uri: callback,
                           client_id: ENV['LINKED_IN_KEY'],
                           client_secret: ENV['LINKED_IN_SECRET']})

    Net::HTTP.start(uri.hostname, uri.port, 
      :use_ssl => true, :verify_mode => OpenSSL::SSL::VERIFY_PEER) do |http|
      response = http.request(request)
      data = JSON.parse(response.body)
      if data['error']
        render :text => response.body
        return
      else
        json = save_oauth2_access_token(data['access_token'])
        user = User.new
        user.first_name = json['firstName']
        user.last_name = json['lastName']
        user.access_token = data['access_token']
        user.lid = json['id']
        user.public_url = data['publicProfileUrl']
        user.save
        session[:lid] = user.lid
        redirect_to root_path
      end
    end

  end

  private

  def save_oauth2_access_token(access_token)
    body = URI.parse('https://api.linkedin.com/v1/people/~:(id,public-profile-url,firstName,lastName)?format=json&oauth2_access_token='+access_token).read
    JSON.parse(body.encode('utf-8', 'iso-8859-1'))
  end

  def url_by_env
    return "http://localhost:3001" if Rails.env == 'development'
    "http://www.hellopitch.com"
  end

end
