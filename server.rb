require "sinatra"
require "pg"
require_relative "./app/models/article"

set :views, File.join(File.dirname(__FILE__), "app", "views")

configure :development do
  set :db_config, { dbname: "news_aggregator_development" }
end

configure :test do
  set :db_config, { dbname: "news_aggregator_test" }
end

def db_connection
  begin
    connection = PG.connect(Sinatra::Application.db_config)
    yield(connection)
  ensure
    connection.close
  end
end

get '/' do
  @articles = File.readlines('./views/articles.csv')
  erb :index
end

post '/articles' do
  article = params['title']
  url = params['article_url']
  description = params['description']

  File.open('./views/articles.csv', 'a') do |file|
    file.puts("\"#{article}\",\"#{url}\",\"#{description}\"")
  end

  redirect '/'
end

get '/articles/new' do
  erb :post_form
end
