class User < ActiveRecord::Base
  attr_accessible :count, :name, :password

  def login(userString, passwordString)
      return 1
  end

  def add(userString, passwordString)
      return 1
  end

  def TESTAPI_resetFixture()
      return -1
  end

end
