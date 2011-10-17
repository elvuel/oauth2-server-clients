# encoding: utf-8

class AppConnection
  include DataMapper::Resource
  storage_names[:default] = 'app_connections'
  is :reflective #is_reflective also
  reflect

  belongs_to :user
end