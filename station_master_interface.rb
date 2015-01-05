require 'sinatra/base'
require 'station_master'
require 'haml'

$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'lib/services'

class StationMasterInterface < Sinatra::Base
  set :haml, format: :html5

  set :public_folder, File.dirname(__FILE__) + '/assets'

  set :bind, '192.168.2.14'
  set :bind, 'localhost'

  set :time_zone, StationMaster::TIME_ZONE

  get '/' do
    haml :index
  end

  get '/autocomplete' do
    content_type :json
    Services::Station::Autocomplete.call(params[:term]).to_json
  end

  get '/show' do
    redirect to('/') if params[:station_code].blank?

    case params[:view_mode]
      when 'departures' then haml :departures
      when 'arrivals' then haml :arrivals
      else haml :show
    end
  end

  get '/departures' do
    content_type :json
    Services::Schedule::Departure.call(params[:station_code], (params[:schedule_count] || 3).to_i).to_json if params[:station_code]
  end

  get '/arrivals' do
    content_type :json
    Services::Schedule::Arrival.call(params[:station_code], (params[:schedule_count] || 3).to_i).to_json if params[:station_code]
  end

  get '/current_time' do
    content_type :text
    Time.now.in_time_zone(settings.time_zone).strftime('%H:%M')
  end
end