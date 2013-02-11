class User < ActiveRecord::Base
  attr_accessible :count, :name, :password

  def self.login(userString, passwordString)
    if !verifyString(userString) || !verifyString(passwordString)
        return LoginCounter::Application.config.ERR_BAD_CREDENTIALS
    end
    @existentUser = User.find_by_name_and_password(userString, passwordString)
    if @existentUser == nil
        return LoginCounter::Application.config.ERR_BAD_CREDENTIALS
    end
    oldCount = @existentUser.count
    @existentUser.update_attribute(:count, oldCount+1)
    return @existentUser.count
  end

  def self.add(userString, passwordString)
    if !verifyString(userString) # username is bad  
        return LoginCounter::Application.config.ERR_BAD_USERNAME
    end
    if !verifyString(passwordString) # password is bad
        return LoginCounter::Application.config.ERR_BAD_PASSWORD
    end
    @existentUser = User.find_by_name(userString)
    if @existentUser != nil # user already exists
        return LoginCounter::Application.config.ERR_USER_EXISTS
    end
    
    user = User.create(name: userString, password: passwordString, count: 1)
    return LoginCounter::Application.config.SUCCESS
  end

  def self.TESTAPI_resetFixture()
    User.destroy_all
    if User.all.count == 0
        return LoginCounter::Application.config.SUCCESS
    end
    return -1
  end
  
  def self.verifyString(str)
    # 1 is valid
    # -1 is too long or empty
    if str == nil || str == "" || str.length > 128
      return false
    end
    return true
  end

end
