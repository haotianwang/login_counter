class UsersController < ApplicationController
  def index
  end
  
  def account
  end

  def login
    count = nil
    if request.method == "POST"
        @errCode = User.login(params[:name], params[:password])
        render :partial => "addOrLogin.json"
    end
    if request.method == "GET"
        render :nothing => true
    end
  end
  
  def add
    if request.method == "POST"
        @errCode = User.add(params[:name], params[:password])
        render :partial => "addOrLogin.json"
    end
    if request.method == "GET"
        render :nothing => true
    end
  end
end
