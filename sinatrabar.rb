require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'erb'
require 'json'
require File.join(File.dirname(__FILE__),'config','environment')

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
    info.each do |key,value|
      info[key] = value.gsub(/\n/,'')
    end
    info.reject! {|key,value| key =~ /station\d+/}
    return info
  end

  def switch_station id=""
    %x[echo 's#{id}' > ~/.config/pianobar/ctl]
    return "Station has been changed"
  end

  def song_control control=""
    case control
      when /next/
        # Next Controls
        char = "n"
        value = "Next Song"
      when /(play|pause)/
        # Pause Controls
        char = "p"
        value = "Play/pause"
      when /bookmark/
        # Song/Artist Bookmark
        if control =~ /song/
          char = "bs"
          value = "Song has been bookmarked"
        elsif control =~ /artist/
          char = "ba"
          value = "Artist has been bookmarked"
        else
          value = "Bookmark not understood"
        end
      when /love/
        # Love song
        char = "+"
        value = "Song has been loved"
      when /hate/
        # Hate song
        char = "-"
        value = "Song has been banned"
      else
        # Failure
        value = "Unrecognized Command"
    end
    %x[echo -n '#{char}' > ~/.config/pianobar/ctl ]
    return value
  end

end

# root page
get '/' do
  @song_info = song_info
  erb :index
end

post '/api/current' do
  @song_info = song_info
  @song_info.to_json
end

post '/api/stations' do
  @stations = stations_list
  @stations.to_json
end

post '/api/station/:id' do
  switch_station(params[:id])
end

post '/api/controls/:command' do
  song_control(params[:command])
end
