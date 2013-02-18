"""
Each file that starts with test... in this directory is scanned for subclasses of unittest.TestCase or testLib.RestTestCase
"""

import unittest
import os
import testLib

class TestAddUserAdditional(testLib.RestTestCase):
    def testAddUserExists(self):
        # make sure trying to add an existent user results in ERR_USER_EXISTS

        # resetfixture and create a new user, so we know the state of the system
        respData = self.makeRequest("/TESTAPI/resetFixture", method="POST")
        actualErrCode = int(float(respData['errCode']))
	self.assertTrue(actualErrCode == testLib.RestTestCase.SUCCESS)
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user1', 'password' : 'password'} )
        actualErrCode = int(float(respData['errCode']))
        self.assertTrue(actualErrCode == testLib.RestTestCase.SUCCESS)        
        
        # make sure adding the same user with same and different passwords both error as expected
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user1', 'password' : 'password'} )
        actualErrCode = int(float(respData['errCode']))
        self.assertTrue(actualErrCode == testLib.RestTestCase.ERR_USER_EXISTS)

        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user1', 'password' : 'randomthingnotapassword'} )
        actualErrCode = int(float(respData['errCode']))
        self.assertTrue(actualErrCode == testLib.RestTestCase.ERR_USER_EXISTS)

    def testAddUserNameTooLong(self):
        # make sure trying to add a user longer than 128 ascii letters for username doesn't work

        # resetfixture to make sure already-exists error doesn't occur
        respData = self.makeRequest("/TESTAPI/resetFixture", method="POST")
        actualErrCode = int(float(respData['errCode']))
	self.assertTrue(actualErrCode == testLib.RestTestCase.SUCCESS)

        # 128 letters, corner case which should work
        OneTwoEightLetters = ""
        for i in range(128):
            OneTwoEightLetters = OneTwoEightLetters + "a"
        longUserNameOK = OneTwoEightLetters
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : longUserNameOK, 'password' : 'password'} )
        actualErrCode = int(float(respData['errCode']))
        self.assertTrue(actualErrCode == testLib.RestTestCase.SUCCESS)

        # 129 letters, corner case should error
        longUserNameBad = OneTwoEightLetters + "a"
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : longUserNameBad, 'password' : 'password'} )
        actualErrCode = int(float(respData['errCode']))
        self.assertTrue(actualErrCode == testLib.RestTestCase.ERR_BAD_USERNAME)

    def testAddUserPassTooLong(self):
        # make sure trying to add a password longer than 128 ascii letters doesn't work
        
        # resetfixture to make sure already-exists error doesn't occur
        respData = self.makeRequest("/TESTAPI/resetFixture", method="POST")
        actualErrCode = int(float(respData['errCode']))
	self.assertTrue(actualErrCode == testLib.RestTestCase.SUCCESS)

        # 128 letters, corner case which should work
        OneTwoEightLetters = ""
        for i in range(128):
            OneTwoEightLetters = OneTwoEightLetters + "a"
        longPassOK = OneTwoEightLetters
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user1', 'password' : longPassOK} )
        actualErrCode = int(float(respData['errCode']))
        self.assertTrue(actualErrCode == testLib.RestTestCase.SUCCESS)

        # 129 letters, corner case should error
        longPassBad = OneTwoEightLetters + "a"
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user2', 'password' : longPassBad} )
        actualErrCode = int(float(respData['errCode']))
        self.assertTrue(actualErrCode == testLib.RestTestCase.ERR_BAD_PASSWORD)

class TestResetFixture(testLib.RestTestCase):
    def testReset(self):
        # add 2 users, making sure they're either added correctly (SUCCESS) or already in db (ERR_USER_EXISTS)
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user1', 'password' : 'password'} )
        actualErrCode = int(float(respData['errCode']))
        self.assertTrue(actualErrCode == testLib.RestTestCase.SUCCESS or actualErrorCode == testLib.RestTestCase.ERR_USER_EXISTS)
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user2', 'password' : 'password'} )
        actualErrCode = int(float(respData['errCode']))
        self.assertTrue(actualErrCode == testLib.RestTestCase.SUCCESS or actualErrorCode == testLib.RestTestCase.ERR_USER_EXISTS)
	
	# make TESTAPI/ResetFixture request, make sure that error code is SUCCESS
        respData = self.makeRequest("/TESTAPI/resetFixture", method="POST")
        actualErrCode = int(float(respData['errCode']))
	self.assertTrue(actualErrCode == testLib.RestTestCase.SUCCESS)

        # try to log in with user1 and user2, make sure they'r both gone
        respData = self.makeRequest("/users/login", method="POST", data = { 'user' : 'user1', 'password' : 'password'} )
        actualErrCode = int(float(respData['errCode']))
        self.assertTrue(actualErrCode == testLib.RestTestCase.ERR_BAD_CREDENTIALS)
        respData = self.makeRequest("/users/login", method="POST", data = { 'user' : 'user2', 'password' : 'password'} )
        actualErrCode = int(float(respData['errCode']))
        self.assertTrue(actualErrCode == testLib.RestTestCase.ERR_BAD_CREDENTIALS)


class TestLoginUser(testLib.RestTestCase):

    def testLoginWithNonExistentUser(self):
        # make sure logging in with user that doesn't exist results in bad credentials

        # resetFixture to make sure no user exists
        respData = self.makeRequest("/TESTAPI/resetFixture", method="POST")
        actualErrCode = int(float(respData['errCode']))
	self.assertTrue(actualErrCode == testLib.RestTestCase.SUCCESS)

        # add a user to test for nonempty case
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user1', 'password' : 'password'} )
        actualErrCode = int(float(respData['errCode']))
        self.assertTrue(actualErrCode == testLib.RestTestCase.SUCCESS)

        # try to login with nonexistent user
        respData = self.makeRequest("/users/login", method="POST", data = { 'user' : 'user2', 'password' : 'password'} )
        actualErrCode = int(float(respData['errCode']))
        self.assertTrue(actualErrCode == testLib.RestTestCase.ERR_BAD_CREDENTIALS)

    def testLoginWithBadPassword(self):
        # make sure logging in with bad user/password combination results in bad credentials

        # add a user
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user1', 'password' : 'password'} )
        actualErrCode = int(float(respData['errCode']))
        self.assertTrue(actualErrCode == testLib.RestTestCase.SUCCESS or actualErrorCode == testLib.RestTestCase.ERR_USER_EXISTS)

        # try to login with a bad password for the user
        respData = self.makeRequest("/users/login", method="POST", data = { 'user' : 'user1', 'password' : 'gibberishnotrealpassword'} )
        actualErrCode = int(float(respData['errCode']))
        self.assertTrue(actualErrCode == testLib.RestTestCase.ERR_BAD_CREDENTIALS)

    def testLoginWithEmptyUsername(self):
        # make sure logging in with an empty password results in bad credentials

        # try to login with an empty username
        respData = self.makeRequest("/users/login", method="POST", data = { 'user' : '', 'password' : 'password'} )
        actualErrCode = int(float(respData['errCode']))
        self.assertTrue(actualErrCode == testLib.RestTestCase.ERR_BAD_CREDENTIALS)
    def testLoginNormal(self):
        # make sure normal login (with correct information) results in SUCCESS and counter increment
        
        # clear db and create a new user
        respData = self.makeRequest("/TESTAPI/resetFixture", method="POST")
        actualErrCode = int(float(respData['errCode']))
	self.assertTrue(actualErrCode == testLib.RestTestCase.SUCCESS)
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user1', 'password' : 'password'} )
        actualErrCode = int(float(respData['errCode']))
        self.assertTrue(actualErrCode == testLib.RestTestCase.SUCCESS)
        # keep track of old count to make sure it gets incremented by 1
        count = respData['count']
        # log in with correct information
        respData = self.makeRequest("/users/login", method="POST", data = { 'user' : 'user1', 'password' : 'password'} )
        actualErrCode = int(float(respData['errCode']))
        self.assertTrue(actualErrCode == testLib.RestTestCase.SUCCESS)
        self.assertTrue(respData['count'] == count+1)

        
