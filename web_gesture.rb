#!/usr/bin/env ruby
require 'bundler'
Bundler.setup :default, :web

require 'sinatra'

class WebGestureApp < Sinatra::Application

  helpers do
  end

  # Root HTML.
  get '/' do
    redirect '/hand_input'
  end

  # Input test HTML.
  get '/hand_input' do
    erb :hand_input
  end

  # WebSocket input JS.
  get '/application.js' do
    coffee Dir.glob('javascripts/**/*.coffee').sort.map { |f| File.read f }.
      join("\n")
  end

  # WebSocket input CSS
  get('/application.css') {
    scss :"../stylesheets/application" }
end
