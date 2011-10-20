# encoding: utf-8

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'

require_relative '../app.rb'

def app() App end
include Rack::Test::Methods