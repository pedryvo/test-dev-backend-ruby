# encoding: UTF-8
require 'rubygems'
require 'sinatra'
require 'json'
require 'data_mapper'
require 'dm-postgres-types'
require "sinatra/namespace"
require "sinatra/base"
require 'rest-client'
require './services/parser'

configure :development, :test, :production do
  register ::Sinatra::Namespace
  set :protection, true
  # Allows local requests such as Postman (Chrome extension):
  set :protection, origin_whitelist: ["chrome-extension://fdmmgilgnpjigdojojpjoooidkmcomcm", "http://127.0.0.1"]
  set :protect_from_csrf, true
  set :server, :puma
end

# Live Postgres for Heroku (Production):
DataMapper.setup(:default, ENV['DATABASE_URL'] || {
  :adapter => "postgres",
  :database => "test",
  :username => "postgres",
  :password => "postgres",
  :host => "localhost"
})

# Main classes for the orders API.
class Order
  include DataMapper::Resource
  property :id, Serial
  property :data, PgJSON, load_raw_value: true
  property :status, String
end

DataMapper.finalize
DataMapper.auto_upgrade!

get '/' do
  'GET /api/v1/orders'
end

# Namespacing the API for version one.
namespace '/api/v1' do

  # Index
  get '/orders' do
    orders = Order.all
    orders.to_json
  end

  # Show
  get '/orders/:id' do
    order = Order.get(params[:id])
    if order.nil?
      halt 404
    end
    order.to_json
  end

  # Create
  post '/order' do
    json = request.body.read
    parsed_json = Parser.new(json).payload.to_json
    
    if parsed_json.nil? || parsed_json['externalCode'].nil?
      halt 400
    end

    order = Order.new(data: parsed_json)

    begin
      api_url = 'https://delivery-center-recruitment-ap.herokuapp.com/'
      response = RestClient.post(api_url, parsed_json, headers={'X-Sent': Time.new.strftime("%Hh%M - %d/%m/%Y")})            
      order.status = response.body
      order.save!

      halt 500 unless order.saved?
      status 201
      order.to_json
    rescue RestClient::ExceptionWithResponse => e
      puts e.response
    end
  end

  # Delete
  delete '/orders/:id' do
    order ||= Order.get(params[:id]) || halt(404)
    halt 404 if order.nil?

    if order.destroy
      "Your order with an id of #{order.id} was deleted."
    else
      halt 500
    end
  end

  before do
    content_type 'application/json'
    headers["X-CSRF-Token"] = session[:csrf] ||= SecureRandom.hex(32)
    # To allow Cross Domain XHR
    # headers["Access-Control-Allow-Origin"] ||= request.env["HTTP_ORIGIN"]
  end
end
