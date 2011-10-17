# encoding: utf-8

class Need
  include DataMapper::Resource
  storage_names[:default] = 'needs'

  property :id, Serial
  property :title, String
  property :tags, String
  property :description, String
  property :user_id, Integer
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :user

end