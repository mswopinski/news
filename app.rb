require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "c52ab0514053f3ddcbd3c5d31866ae23"



get "/" do
  # show a view that asks for the location
  view "ask"
end

get "/news" do
  # do everything else
    results = Geocoder.search(params["location"])
    @lat_long = results.first.coordinates # => [lat, long]
    @city = results.first.city
  
    # define lat and long
    @lat = @lat_long[0].to_s
    @long = @lat_long[1].to_s
                          
    # Results from Geocoder
    @forecast = ForecastIO.forecast("#{@lat}" , "#{@long}").to_hash
 
@url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=041c812de2784a17925c66b071e26618"
news = HTTParty.get(@url).parsed_response.to_hash
@articles = news["articles"]
   
  
    view "news"
  
end