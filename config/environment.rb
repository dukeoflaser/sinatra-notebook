require 'bundler'
Bundler.require

configure :development do
  set :database, "sqlite3:db/notebook.db"
end

require_all 'app'