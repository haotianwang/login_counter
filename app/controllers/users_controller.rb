class UsersController < ApplicationController
  def login
    errCode = 1
    count = nil
    if request.method == "POST"

    else
        respond_to do |format|
            format.html { redirect_to :action => "index" }
        end
    end
  end
  
  def add
    if request.method == "POST"
        respond_to do |format|
            format.html { render action: "add"}
        end
    end
    if request.method == "GET"
        respond_to do |format|
            format.html { render action: "index"}
        end
    end
  end
end
