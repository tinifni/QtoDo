require 'rubygems'
require 'active_record'
require 'sinatra'
require 'csv'
require 'sass'
require 'compass'
require 'sinatra/reloader' if development?


configure do
  Compass.configuration do |config|
    config.project_path = File.dirname(__FILE__)
    config.sass_dir = 'views'
  end

  set :haml, {:format => :html5}
  set :sass, Compass.sass_engine_options
end

ActiveRecord::Base.establish_connection(
  :adapter =>  'sqlite3',
  :database => 'qtodo.sqlite3.db'
)

begin
  ActiveRecord::Schema.define do
    create_table :tns do |t|
      t.string :tn
      t.string :target
      t.string :request_type
      t.string :device_type
      t.string :region
      t.string :date_requested
      t.string :priority
      t.string :due_date
      t.string :capture_type
      t.string :brand
      t.string :requestor
    end
  end
rescue ActiveRecord::StatementInvalid
end

class Tn < ActiveRecord::Base
end

get '/' do
  @tns = Tn.all
  haml :index
end

get '/upload' do
  haml :upload
end

post '/upload' do
  unless params[:file] && (tmpfile = params[:file][:tempfile]) && (name = params[:file][:filename])
    @error = "No file selected"
    return haml :upload
  end
  blk = tmpfile.read(65536)
  csv_data = CSV.parse(blk)
  headers = csv_data.shift.map {|i| i.to_s }
  string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
  array_of_hashes = string_data.map {|row| Hash[*headers.zip(row).flatten] }
  array_of_hashes.each do |tn|
    existing_tn = Tn.find(:first, :conditions => { :tn => tn["TN"] })
    unless existing_tn
      Tn.create(:tn => tn["TN"],
                :target => tn["Target #"],
                :request_type => tn["Request Type"],
                :device_type => tn["Device"],
                :region => tn["Region"],
                :date_requested => tn["Date Requested"],
                :priority => tn["Priority"],
                :due_date => tn["Due Date"],
                :capture_type => tn["Capture Type"],
                :brand => tn["Brand"],
                :requestor => tn["Requestor"])
    else
      Tn.update(existing_tn.id, {
                :tn => tn["TN"],
                :target => tn["Target #"],
                :request_type => tn["Request Type"],
                :device_type => tn["Device"],
                :region => tn["Region"],
                :date_requested => tn["Date Requested"],
                :priority => tn["Priority"],
                :due_date => tn["Due Date"],
                :capture_type => tn["Capture Type"],
                :brand => tn["Brand"],
                :requestor => tn["Requestor"]})
    end
  end
  redirect '/'
end

get '/stylesheet.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :stylesheet
end
