require "bundler/setup"
Bundler.require :default

require_relative "client_key"

unless Object.const_defined?(:CLIENT_ID) && Object.const_defined?(:CLIENT_SECRET)
  abort("client keys is missing")
end