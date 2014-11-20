require 'sinatra'
require 'station_master'
require 'haml'
require 'pry'

set :haml, format: :html5
set :public_folder, File.dirname(__FILE__) + '/assets'

get '/' do
  haml :index
end

get '/autocomplete' do
  StationMaster::Station.find_by_city(params[:term])
    .inject([]) do |array, (key, value)|
      array << { value: key, key: value }
    end.to_json
end

get '/show' do
  redirect to('/') if params[:station_code].blank?

  case params[:view_mode]
    when 'departures' then haml :departures, locals: {
      departures: StationMaster::Schedule.find_station_departures(params[:station_code]).first(5)
    }
    when 'arrivals' then haml :arrivals, locals: {
      arrivals: StationMaster::Schedule.find_station_arrivals(params[:station_code]).first(5)
    }
    else haml :show, locals: {
      departures: StationMaster::Schedule.find_station_departures(params[:station_code]).first(5),
      arrivals: StationMaster::Schedule.find_station_arrivals(params[:station_code]).first(5)
    }
  end
end