# encoding: utf-8

class User
  include DataMapper::Resource
  storage_names[:default] = 'users'
  is :reflective #is_reflective also
  reflect

  has n, :app_connections
  has n, :documents
end