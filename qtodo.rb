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
      t.string :region
      t.string :date_requested
      t.string :due_date
      t.string :bl
      t.string :requestor
      t.string :request_type
      t.string :priority
      t.string :tn
      t.string :brand
      t.string :device_type
      t.string :remote
      t.string :target
      t.string :published_ids
      t.string :exec
      t.string :capture_type
      t.string :split_ids
      t.string :requestor_notified
      t.string :comments
      t.string :tn_location
      t.string :tn_status
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
      Tn.create(:region => tn["Region"],
                :date_requested => tn["Date Requested"],
                :due_date => tn["Due Date"],
                :bl => tn["BL"],
                :requestor => tn["Requestor"],
                :request_type => tn["Request Type"],
                :priority => tn["Priority"],
                :tn => tn["TN"],
                :brand => tn["Brand"],
                :device_type => tn["Device"],
                :remote => tn["Remote #"],
                :target => tn["Target #"],
                :published_ids => tn["Published ID(s)"],
                :exec => tn["Exec"],
                :capture_type => tn["Capture Type"],
                :split_ids => tn["Split ID(s)"],
                :requestor_notified => tn["Requestor Notified (Y/N)"],
                :comments => tn["Comment(s)"])
    else
      Tn.update(existing_tn.id, {
                :region => tn["Region"],
                :date_requested => tn["Date Requested"],
                :due_date => tn["Due Date"],
                :bl => tn["BL"],
                :requestor => tn["Requestor"],
                :request_type => tn["Request Type"],
                :priority => tn["Priority"],
                :tn => tn["TN"],
                :brand => tn["Brand"],
                :device_type => tn["Device"],
                :remote => tn["Remote #"],
                :target => tn["Target #"],
                :published_ids => tn["Published ID(s)"],
                :exec => tn["Exec"],
                :capture_type => tn["Capture Type"],
                :split_ids => tn["Split ID(s)"],
                :requestor_notified => tn["Requestor Notified (Y/N)"],
                :comments => tn["Comment(s)"]})
    end
  end
  redirect '/'
end

get '/stylesheet.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :stylesheet
end
