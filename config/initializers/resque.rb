Resque::Server.use(Rack::Auth::Basic) do |user, password|  
    user == "resque" and password == "GFctnLKn6dJNU8PF"
end
