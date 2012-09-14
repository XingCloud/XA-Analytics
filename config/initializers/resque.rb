Resque::Server.use(Rack::Auth::Basic) do |user, password|  
    user == "resque" and password == "secret"
end
