ENV['RACK_ENV'] = 'test'
gem "minitest"
require 'rack/test'
require 'minitest/autorun'
require 'minitest/color'
require_relative '../services/parser.rb'
require_relative 'helpers.rb'

# Custom methods to simulate Rspec’s “expect {}.to change {}.by(x)”.
include Rack::Test::Methods

describe "check parser" do
  before do
    @data = File.open('test.json').read
    @json_hash = JSON.parse(@data)
    @payload = Parser.new(@data).payload 
  end

  it "checks some fields" do
    assert(@payload['externalCode'] == @json_hash['id'].to_s)
    assert(@payload['deliveryFee'] == @json_hash['total_shipping'].to_s)
  end

  it "checks if timezone is correct" do
    parser = Parser.new(@data)
    formatted_datetime = parser.format_timezone @json_hash['payments'][0]['date_created']
    assert(@payload['dtOrderCreate'] == formatted_datetime)
    assert(formatted_datetime[-1] == 'Z', 'not in UTC timezone')
  end
end
