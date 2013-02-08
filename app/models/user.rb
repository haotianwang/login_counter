class User < ActiveRecord::Base
  attr_accessible :count, :name, :password
end
