require 'json'
require 'net/http'
require 'uri'
require 'httparty'
    
class ZenodowebhookController < ApplicationController
  #does not work when setting the header as accept-json
 
  def webhooks
    #code in url, means we are requesting the code
    puts "getting Zenodo code"
    puts "code"
    puts params[:code]
    code = params[:code]
    
    if !code.nil?    
        #result = HTTParty.post("https://sandbox.zenodo.org/oauth/token", 
        result = HTTParty.post(Rails.application.config_for(:tess)["zenodo"][:url] + "oauth/token",
           :body => { 
                  'client_id': Rails.application.config_for(:tess)["zenodo"][:client_id],
                  'client_secret': Rails.application.secrets[:zenodo][:client_secret],
                  'grant_type': 'authorization_code',
                  'code': code,
                  'redirect_uri': Rails.application.config_for(:tess)["zenodo"][:redirect_uri]
                 })    
        puts result.code, result.message, result
        
        access_token = result["access_token"]

        if !access_token.nil?          
            #puts "access_token", access_token
            session[:zenodo_access_token] = access_token
            #puts session[:zenodo_access_token] 
            
            refresh_token = result["refresh_token"]
            #puts "refresh_token", refresh_token
            session[:zenodo_refresh_token] = refresh_token
            #puts session[:zenodo_refresh_token]     
            
            current_user.profile.zenodotokenchoice = true
            current_user.save             
            
            respond_to do |format|
                format.html { redirect_to materials_path, notice: 'Successfully linked Pan-training with your Zenodo account.' }
            end                 
        else
            respond_to do |format|
                format.html { redirect_to materials_path, alert: 'Failed to link Pan-training with your Zenodo account.'}
            end       
        end    
        
    else
        respond_to do |format|
            format.html { redirect_to materials_path, alert: 'Failed to link Pan-training with your Zenodo account.'}
        end    
    end
          
  end

  #will need to do refresh logic
  def refresh_token
      #check this correctly checks that a session for the zenodo_refresh_token has been previously set
      puts "refreshing token"
      refresh_token = session[:zenodo_refresh_token] 
      if refresh_token
          puts "Zenodo token refreshed"
          
          result = HTTParty.post(Rails.application.config_for(:tess)["zenodo"][:url] + "oauth/token",
              :body => { 
                  'client_id': Rails.application.config_for(:tess)["zenodo"][:client_id],
                  'client_secret': Rails.application.secrets[:zenodo][:client_secret],
                  'grant_type': 'refresh_token',
                  'refresh_token': refresh_token,
                  'redirect_uri': Rails.application.config_for(:tess)["zenodo"][:redirect_uri]
              })    
          puts result.code, result.message, result          
          
      else
          puts "Zenodo refresh token never set before"
      end
  end

end
