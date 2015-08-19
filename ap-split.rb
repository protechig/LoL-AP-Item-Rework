require 'sinatra'
require 'sinatra/config_file'
require 'sinatra/reloader' if development?
require 'lol'
require 'json'

config_file 'config.yml'

set :client, Lol::Client.new(settings.apikey,
                             { :region => 'na',
                               :redis  => 'redis://localhost:6379',
                               :ttl    => 900 })

helpers do
  def get_match(id)
    settings.client.match.get id
  end
end

get '/match/:id' do |id|
  content_type :json
  begin
    match = get_match id
    response = {
      :success => true,
      :match   => match
    }
  rescue Exception => e
    response = {
      :success => false,
      :error   => e.message
    }
  end

  response.to_json
end
