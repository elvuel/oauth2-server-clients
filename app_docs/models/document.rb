# encoding: utf-8

class Document
  include DataMapper::Resource

  storage_names[:default] = 'documents'

  property :id, Serial
  property :name, String, :required => true
  property :tags, String
  property :description, String
  property :rights, Boolean, :default => true
  property :user_id, Integer

  belongs_to :user

end