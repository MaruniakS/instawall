
class HomeController < ApplicationController
  require 'rest_client'
  require 'json'
  def index
    @response = HTTParty.get("https://api.instagram.com/v1/users/self/media/liked/?access_token=2552384949.a0b5e2e.4562a4d19eff4123b473fb25364e7a2f")
    #json = JSON.parse(response)
    #@pretty_json = JSON.pretty_generate(json)
  end
end
#2552384949.a0b5e2e.4562a4d19eff4123b473fb25364e7a2f