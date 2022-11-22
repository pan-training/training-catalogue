require 'json'
require 'net/http'
require 'uri'
require 'httparty'
    
class ZenodowebhookController < ApplicationController
  #will need to do refresh logic
  #does not work when setting the header as accept-json
 
  def webhooks
    #code in url, means we are requesting the code
    puts "code"
    puts params[:code]
    code = params[:code]
    
    if !code.nil?    
        result = HTTParty.post("https://sandbox.zenodo.org/oauth/token", 
           :body => { 
                  'client_id': 'EtYnAQE4b17oc5GdKutYH7dS8T1PJgIyC5A0SBPA',
                  'client_secret': Rails.application.secrets[:zenodo][:client_secret],
                  'grant_type': 'authorization_code',
                  'code': code,
                  'redirect_uri': 'http://localhost:3000/zenodowebhook' #update this value later on for production
                 })    
        puts result.code, result.message, result
        
        access_token = result["access_token"]

        if !access_token.nil?          
            puts "access_token", access_token
            session[:zenodo_access_token] = access_token
            puts session[:zenodo_access_token] 
            
            refresh_token = result["refresh_token"]
            puts "refresh_token", refresh_token
            session[:zenodo_refresh_token] = refresh_token
            puts session[:zenodo_refresh_token]     
            
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

end
