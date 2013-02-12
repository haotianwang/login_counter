class UsersController < ApplicationController
  def login
    count = nil
    if request.method == "POST"
	puts params[:user]
	puts params[:password]
        @errCode = User.login(params[:user], params[:password])
        render :partial => "addOrLogin", :formats => [:json]
    end
    if request.method == "GET"
        render :nothing => true
    end
  end
  
  def add
    if request.method == "POST"
        @errCode = User.add(params[:user], params[:password])
        render :partial => "addOrLogin", :formats => [:json]
    end
    if request.method == "GET"
        render :nothing => true
    end
  end
end
