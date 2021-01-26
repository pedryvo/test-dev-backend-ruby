ENV['RACK_ENV'] = 'test'
gem "minitest"
require 'rack/test'
require 'minitest/autorun'
require 'minitest/color'
require_relative '../app.rb'
require_relative 'helpers.rb'

# Custom methods to simulate Rspec’s “expect {}.to change {}.by(x)”.
include Rack::Test::Methods

def app
  Sinatra::Application
end

describe "See all orders" do
  it "responds with OK to orders index call" do
    get "/api/v1/orders"
    last_response.status.must_equal 200
  end
end

describe "See a order" do
  before do
    data = File.open('test.json').read
    post "/api/v1/order", data
  end

  it "responds with OK to order show call" do
    get "/api/v1/orders/1"
    last_response.status.must_equal 200
  end
end

describe "Create a order" do
  before do
    @data = File.open('test.json').read
  end

  it "check if the order has been created accordingly" do
    post_data = post "/api/v1/order", @data
    resp = JSON.parse(post_data.body)
    resp["status"].must_equal "OK"
  end
end
