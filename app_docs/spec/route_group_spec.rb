# encoding: utf-8
require_relative 'spec_helper'

describe "route group" do
  it "should redirect to root path without params" do
    get "/tgp"
    last_response.status.must_equal 302
  end

  it "should see tgp response body with params" do
    get "/tgp", { first: 'first', second: 'second' }
    last_response.status.must_equal 200
    last_response.body.index("This in TGP!").wont_be_nil
  end
end