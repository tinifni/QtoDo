require 'rubygems'
require 'active_record'
require 'sinatra'
require 'csv'
require 'sass'
require 'haml'
require 'compass'
#require 'sinatra/reloader' if development?

#enable :run
#set :views, File.dirname(__FILE__) + "/views"
#set :public, File.dirname(__FILE__) + "/public"

configure do
  Compass.configuration do |config|
    config.project_path = File.dirname(__FILE__)
    config.sass_dir = 'views'
  end

  set :haml, {:format => :html5}
  set :sass, Compass.sass_engine_options
end

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => 'qtodo.sqlite3.db'
)

begin
  ActiveRecord::Schema.define do
    create_table :tns do |t|
      t.string :region
      t.date :date_requested
      t.date :due_date
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
      t.string :location
      t.string :status
    end
  end
rescue ActiveRecord::StatementInvalid
end

class Tn < ActiveRecord::Base
end

get '/' do
	@tns = Tn.find(:all, :conditions => "status IS NOT 'Complete'", :order => "due_date, tn")
  haml :index
end

get '/tns' do
  @tns = Tn.find(:all, :order => "due_date, tn")
  haml :tns
end

get %r{/tns/status/(\w*)} do |c|
	@tns = Tn.find(:all, :conditions => "status IS '#{c}'", :order => "tn")
	if c == "Complete"
		haml :status_complete
	else
		haml :status
	end
end

get %r{/tns/location/(\w*)} do |c|
	@tns = Tn.find(:all, :conditions => "location IS '#{c}'", :order => "tn")
	haml :location
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
		tn["Date Requested"].length == 8 ? tn["Date Requested"].insert(6, '20') : nil
		tn["Due Date"].length == 8 ? tn["Due Date"].insert(6, '20') : tn["Due Date"] = "01/01/9999"
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

get %r{/tns/(\d{5})/location} do |c|
  existing_tn = Tn.find(:first, :conditions => { :tn => c })
  if existing_tn
    "#{existing_tn.location}"
  else
    "Unknown"
  end
end

post %r{/tns/(\d{5})/location} do |c|
  existing_tn = Tn.find(:first, :conditions => { :tn => c })
  if existing_tn && params[:location]
    Tn.update(existing_tn.id, :location => params[:location])
  end
  redirect '/'
end

get %r{/tns/(\d{5})/status} do |c|
  existing_tn = Tn.find(:first, :conditions => { :tn => c })
  if existing_tn
    "#{existing_tn.status}"
  else
    "Unknown"
  end
end

post %r{/tns/(\d{5})/status} do |c|
  existing_tn = Tn.find(:first, :conditions => { :tn => c })
  if existing_tn && params[:status]
    Tn.update(existing_tn.id, :status => params[:status])
  end
  redirect '/'
end

get %r{/tns/(\d{5})} do |c|
  existing_tn = Tn.find(:first, :conditions => { :tn => c })
  if existing_tn
    "#{existing_tn.location} #{existing_tn.status}"
  else
    "Unknown"
  end
end

post %r{/tns/(\d{5})} do |c|
  existing_tn = Tn.find(:first, :conditions => { :tn => c })
  if existing_tn && params[:location] && params[:status]
    Tn.update(existing_tn.id, :location => params[:location], :status => params[:status])
  end
  redirect '/'
end

get %r{/search} do
	@tns = [Tn.find(:first, :conditions => {:tn => params[:q]})]
  haml :search
end

get '/stylesheet.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :stylesheet
end
