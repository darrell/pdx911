#!/usr/bin/env ruby

require 'bundler/setup'
require 'nokogiri'
require 'pry'
require 'open-uri'
#require 'sinatra'
#require 'sinatra/activerecord'
#require './environments'
require 'active_record'
require 'rgeo'


ActiveRecord::Base.establish_connection(
    :adapter  => 'postgis',
    :host     => 'localhost',
    :database => 'pdxcrimes',
    :encoding => 'utf8'
  )

class Entry < ActiveRecord::Base
end

def main
  feed = Nokogiri::XML(open("http://www.portlandonline.com/scripts/911incidents.cfm"))
  feed.remove_namespaces!


  feed.xpath('/feed/entry').each do |e|
     id = e.xpath('id')
     lat,lng = e.xpath('point').inner_text.split
     updated=Time.parse(e.xpath('updated').inner_text)
     published=Time.parse(e.xpath('published').inner_text)
     h=Nokogiri::HTML(e.xpath('content').inner_text)
     attrs={}
     h.search('dt').each do |node|
       key=node.text.sub(/:$/,'').sub(/\s+/,'_').downcase.to_sym
       attrs[key]=node.next_element.text
     end
     ent = Entry.find_by(entry_id: attrs[:id])
     is_new = ent.nil?
     ent = Entry.find_or_create_by(entry_id: attrs[:id])
     ent.call_type = attrs[:call_type]
     ent.latitude = lat
     ent.longitude = lng
     ent.updated = updated
     ent.published = published
     ent.agency = attrs[:agency]
     ent.address = attrs[:address]
     ent.save!
#     if is_new
#       puts "added: #{ent.inspect}" 
#     end
  end
end

main


# binding.pry
