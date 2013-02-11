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
  
  def verifyString(str)
      // 1 is valid
      // -1 is too long
      if str == nil || str == "" || str.length > 128
        return -1
      end
      return 1
  end

end
