require 'sinatra'
require 'station_master'

$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'lib/services'

require 'haml'
require 'pry'

set :haml, format: :html5

set :public_folder, File.dirname(__FILE__) + '/assets'

set :bind, '192.168.2.14'

get '/' do
  haml :index
end

get '/autocomplete' do
  Services::Station::Autocomplete.call(params[:term]).to_json
end

get '/show' do
  redirect to('/') if params[:station_code].blank?

  case params[:view_mode]
    when 'departures' then haml :departures, locals: {
      departures: Services::Schedule::Departure.call(params[:station_code], 20)
    }
    when 'arrivals' then haml :arrivals, locals: {
      arrivals: Services::Schedule::Arrival.call(params[:station_code], 20),
    }
    else haml :show, locals: {
      departures: Services::Schedule::Departure.call(params[:station_code], 10),
      arrivals: Services::Schedule::Arrival.call(params[:station_code], 10)
    }
  end
end