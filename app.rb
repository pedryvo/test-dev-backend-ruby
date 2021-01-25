# encoding: UTF-8
require 'rubygems'
require 'sinatra'
require 'json'
require 'data_mapper'
require 'puma'
require "sinatra/namespace"
require "sinatra/base"
require 'debugger'
require 'haml'
require './services/parser'

configure :development, :test, :production do
  register ::Sinatra::Namespace
  set :protection, true
  # Allows local requests such as Postman (Chrome extension):
  set :protection, origin_whitelist: ["chrome-extension://fdmmgilgnpjigdojojpjoooidkmcomcm", "http://127.0.0.1"]
  set :protect_from_csrf, true
  set :server, :puma
  # Local Sqlite (Development):
  # set :datamapper_url, "sqlite3://#{File.dirname(__FILE__)}/test.sqlite3"
end

# Live Postgres for Heroku (Production):
DataMapper.setup(:default, ENV['HEROKU_POSTGRESQL_AMBER_URL'] || 'postgres://localhost/mydb')
# Local SQlite Locally (Development):
# DataMapper.setup(:default, "sqlite::memory:")


# Main classes for the order of the pixel API.
class Order
  include DataMapper::Resource
  property :id, Serial
  property :data, PgJSON, load_raw_value: true
end

DataMapper.finalize
DataMapper.auto_migrate!

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
    json = request.body.read.to_json
    parsed_json = Parser.new(json).payload

    if data.nil? || data['id'].nil?
      halt 400
    end

    order = Order.new(data: parsed_json)

    halt 500 unless order.save
    status 201
    order.to_json
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
    headers["Access-Control-Allow-Origin"] ||= request.env["HTTP_ORIGIN"] 
  end
end
