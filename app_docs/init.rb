require "bundler/setup"
Bundler.require :default

require_relative "client_key"
abort("client keys is missing") unless Object.const_defined?(:CLIENT_ID) && Object.const_defined?(:CLIENT_SECRET)

require_relative "config"

DataMapper.setup(:default, SQL_URL)

Dir["#{File.dirname(__FILE__)}/models/*.rb"].each do |file|
  require file
end


Bundler.require :test if ENV.fetch("RACK_ENV") == "test"

DataMapper.auto_upgrade!

Document.destroy!
User.all.each do |user|
  rand(10).downto(0).each do |i|
    user.documents.create(name: "document-#{i} of user-#{user.name}", description: "description of document-#{i}")
  end
end