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

get '/match/:id' do |id|
  content_type :json
  match = settings.client.match
  match.get(id).to_json
end
