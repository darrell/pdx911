# app.rb

require 'bundler/setup'
require 'sinatra'
require 'sinatra/activerecord'
require './environments'
require 'json'
require 'rgeo/geo_json'
require 'time'

class Entry < ActiveRecord::Base
  RGeo::ActiveRecord::GeometryMixin.set_json_generator(:geojson)
  attr_reader :factory
  def initialize
    @factory ||= ::RGeo::Geographic.simple_mercator_factory()
  end
  def to_geojson
    html = "<p><b>Time: #{self.published.localtime}</b><br><b>Address:</b> #{self.address}<br><b>Call Type:</b> #{self.call_type}<br><b>Agency:</b> #{self.agency}</p>"
    RGeo::GeoJSON::Feature.new(self.geom, self.entry_id, {:address => self.address, :call_type => self.call_type, :agency => self.agency, :updated => self.updated, :published => self.published, :html => html}) 
  end
  
end

def calls_since(time)
  x=RGeo::GeoJSON::FeatureCollection.new(Entry.where("published >= ?", time).order(:published).map(&:to_geojson))
  RGeo::GeoJSON.encode(x).to_json
end

get "/" do 
  redirect "/index.html"  
end

get "/calls" do
  calls_since(Time.now() - 30.minutes)
end

get "/calls/:since" do
  # since X seconds prior to now
  # if error, return empty
  begin
    secs=params[:since].to_i
    secs = secs > 28800 ? 28800 : secs
    time=Time.now() - secs.seconds
    calls_since(time)
  rescue =>  e 
    puts e
    '{"type"=>"FeatureCollection", "features"=>[]}'
  end
end
