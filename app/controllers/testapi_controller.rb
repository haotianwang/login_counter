class TestapiController < ApplicationController
  def resetFixture
    result = User.TESTAPI_resetFixture()
    render :json => { 'errCode' => result }
  end

  def unitTests
    cmd = "pwd"
    output = `#{cmd}`
    render :json => { 'output' => output }
  end
end
