require 'bundler'
Bundler.require
configure :devlopment do
  set :database, "sqlite3:db/notebook.db"
end