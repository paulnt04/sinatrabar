require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'erb'
require File.join(File.dirname(__FILE__), 'environment')

configure do
  set :views, "#{File.dirname(__FILE__)}/views"
end

error do
  e = request.env['sinatra.error']
  Kernel.puts e.backtrace.join("\n")
  'Application error'
end

helpers do

  def is_running?
    `ps aux | grep -e pianobar | grep -v grep` =~ /.+/ ? true : false
  end

  def stations_list
    stations = {}
    info = {}
    File.new("#{File.dirname(__FILE__)}/tmp/song_details.txt").readlines.each do |hash|
      info = eval(hash)
    end
    info.each do |key,value|
      if key =~ /station\d+/i
        number = key.gsub(/[A-Za-z]/,'')
        station = value.gsub(/\n/,'')
        station = {number=>station}
        stations.merge! station
      end
    end
    return stations
  end

  def song_info
    info = {}
    File.new("#{File.dirname(__FILE__)}/tmp/song_details.txt").readlines.each do |hash|
      info = eval(hash)
    end
    return info
  end

  def song_control control
    case control
      when /next/
        # Next Controls
      when /pause/
        # Pause Controls
      when /bookmark/
        # Song/Artist Bookmark
      when /love/
        # Love song
      when /hate/
        # Hate song
      else
        # Do Nothing
    end
  end

end

# root page
get '/' do
  @song_info = song_info
  erb :index
end

get '/api/current' do
  @song_info = song_info
  erb :song_details
end

get '/api/stations' do
  @stations = stations_list
  erb :stations
end

get '/api/controls/:command' do
  song_control(command)
end
