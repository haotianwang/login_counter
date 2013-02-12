require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "resetFixture" do
  
    code = User.add("user1", "password") # add a user first so we have something to delete
    assert code == LoginCounter::Application.config.SUCCESS || code == LoginCounter::Application.config.ERR_USER_EXISTS, "valid user.add didn't succeed and didn't already exist"
    assert User.all.count > 0, "valid user.add resulted in success but db count didn't increase"
    code = User.TESTAPI_resetFixture()
    assert code == LoginCounter::Application.config.SUCCESS, "resetfixture didn't succeed"
    assert User.all.count == 0, "resetfixture succeeded but db count isn't 0"
  end
  
  test "add with empty username" do
    prevCount = User.all.count
    code = User.add("", "password")
    assert code == LoginCounter::Application.config.ERR_BAD_USERNAME, "add with empty username did not result in err_bad_username"
    assert prevCount == User.all.count, "add with empty username resulted in err_bad_username but db was still added to"
  end
  
  test "add with too long username" do
    code = User.TESTAPI_resetFixture()
    assert code == LoginCounter::Application.config.SUCCESS, "resetfixture didn't succeed"
    assert User.all.count == 0, "resetfixture succeeded but db count isn't 0"
    longName = ""
    (1..128).each do |i| # make sure 128-lengthed username still works, corner case
        longName = longName + "a"
    end
    code = User.add(longName, "password")
    assert code == LoginCounter::Application.config.SUCCESS, "add with 128-lengthed username didn't succeed"
    assert User.all.count == 1, "add with 128-lengthed username succeeded but count didn't rise"
    
    longName = ""
    (1..129).each do |i| # make sure 129-lengthed username doesn't work
        longName = longName + "a"
    end
    code = User.add(longName, "password")
    assert code == LoginCounter::Application.config.ERR_BAD_USERNAME, "add with too long username did not result in err_bad_username"
    assert User.all.count == 1, "add with too long username resulted in err_bad_username but db was still added to"
  end
  
  test "add with empty password" do #first clear db so there would be ERR_USER_EXISTS
    code = User.TESTAPI_resetFixture()
    assert code == LoginCounter::Application.config.SUCCESS, "resetfixture didn't succeed"
    assert User.all.count == 0, "resetfixture succeeded but db count isn't 0"
    code = User.add("user1", "")
    assert code == LoginCounter::Application.config.ERR_BAD_PASSWORD, "add with empty username didn't result in bad password"
    assert User.all.count == 0, "add with empty username resulted in bad username but db count still increased"
  end
  
  test "add with too long password" do
    code = User.TESTAPI_resetFixture()
    assert code == LoginCounter::Application.config.SUCCESS, "resetfixture didn't succeed"
    assert User.all.count == 0, "resetfixture succeeded but db count isn't 0"
    longPass = ""
    (1..128).each do |i| # make sure 128-lengthed password still works, corner case
        longPass = longPass + "a"
    end
    code = User.add("user1", longPass)
    assert code == LoginCounter::Application.config.SUCCESS, "add with 128-lengthed password didn't succeed"
    assert User.all.count == 1, "add with 128-lengthed password succeeded but count didn't rise"
    
    longPass = ""
    (1..129).each do |i| # make sure 129-lengthed username doesn't work
        longPass = longPass + "a"
    end
    code = User.add("user2", longPass)
    assert code == LoginCounter::Application.config.ERR_BAD_PASSWORD, "add with too long password did not result in err_bad_password"
    assert User.all.count == 1, "add with too long password resulted in err_bad_password but db was still added to"
  end
  
  test "add with valid username password" do
    code = User.TESTAPI_resetFixture() # reset db first to ensure there will be no user-exists error
    assert code == LoginCounter::Application.config.SUCCESS, "resetfixture didn't succeed"
    assert User.all.count == 0, "resetfixture succeeded but db count isn't 0"
    code = User.add("user1", "password")
    assert code == LoginCounter::Application.config.SUCCESS, "valid user.add didn't succeed"
    assert User.all.count > 0, "valid user.add resulted in success but db count didn't increase"
  end
  
  test "add duplicate account" do
    code = User.TESTAPI_resetFixture() # reset db first to ensure there will be no user-exists error
    assert code == LoginCounter::Application.config.SUCCESS, "resetfixture didn't succeed"
    assert User.all.count == 0, "resetfixture succeeded but db count isn't 0"
    code = User.add("user1", "password") # add the first account so we can duplicate its add
    assert code == LoginCounter::Application.config.SUCCESS, "valid user.add didn't succeed"
    assert User.all.count == 1, "valid user.add resulted in success but db count didn't increase"
  
    code = User.add("user1", "anypassword") # add same account with different password, just same username alone should make it fail
    assert code == LoginCounter::Application.config.ERR_USER_EXISTS, "duplicate user add didn't result in err-user-exists"
    assert User.all.count == 1, "duplicate user add resulted in err-user-exists but db count still increased"
  end
  
  test "login with bad username" do
    code = User.TESTAPI_resetFixture() # reset db first to ensure there will be no user-exists error
    assert code == LoginCounter::Application.config.SUCCESS, "resetfixture didn't succeed"
    assert User.all.count == 0, "resetfixture succeeded but db count isn't 0"
    code = User.add("user1", "password") # add new user so we know the username/password
    assert code == LoginCounter::Application.config.SUCCESS, "valid user.add didn't succeed"
    assert User.all.count > 0, "valid user.add resulted in success but db count didn't increase"
    
    code = User.login("user2", "password")
    assert code = LoginCounter::Application.config.ERR_BAD_CREDENTIALS, "bad username login didn't result in bad credentials"
  end
  
  test "login with bad password" do
    code = User.TESTAPI_resetFixture() # reset db first to ensure there will be no user-exists error
    assert code == LoginCounter::Application.config.SUCCESS, "resetfixture didn't succeed"
    assert User.all.count == 0, "resetfixture succeeded but db count isn't 0"
    code = User.add("user1", "password") # add new user so we know the username/password
    assert code == LoginCounter::Application.config.SUCCESS, "valid user.add didn't succeed"
    assert User.all.count > 0, "valid user.add resulted in success but db count didn't increase"
    
    code = User.login("user1", "badpassword")
    assert code = LoginCounter::Application.config.ERR_BAD_CREDENTIALS, "bad password login didn't result in bad credentials"
  end
  
  test "login with good username and password" do
    code = User.TESTAPI_resetFixture() # reset db first to ensure there will be no user-exists error
    assert code == LoginCounter::Application.config.SUCCESS, "resetfixture didn't succeed"
    assert User.all.count == 0, "resetfixture succeeded but db count isn't 0"
    code = User.add("user1", "password") # add new user so we know the username/password
    assert code == LoginCounter::Application.config.SUCCESS, "valid user.add didn't succeed"
    assert User.all.count > 0, "valid user.add resulted in success but db count didn't increase"
    
    code = User.login("user1", "password")
    assert code == 2, "valid login didn't result in return of count == 2, which is 1 add and 1 login"
    
    code = User.login("user1", "password")
    assert code == 3, "valid login didn't resint in return of count == 3, which is 1 add and 2 logins"
  end
  
  test "multiple valid adds" do
    code = User.TESTAPI_resetFixture() # reset db first to ensure there will be no user-exists error
    assert code == LoginCounter::Application.config.SUCCESS, "resetfixture didn't succeed"
    assert User.all.count == 0, "resetfixture succeeded but db count isn't 0"
    code = User.add("user1", "password") # add the first account
    assert code == LoginCounter::Application.config.SUCCESS, "valid user.add didn't succeed"
    assert User.all.count == 1, "valid user.add resulted in success but db count didn't increase"
    code = User.add("user2", "password") # add the second account
    assert code == LoginCounter::Application.config.SUCCESS, "valid user.add didn't succeed"
    assert User.all.count == 2, "valid user.add resulted in success but db count didn't increase"
  end
end
