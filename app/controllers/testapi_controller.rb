class TestapiController < ApplicationController
  def resetFixture
    result = User.TESTAPI_resetFixture()
    render :json => { "errCode" => result }
  end

  def unitTests
    output = `rake db:migrate && rake db:test:prepare && ruby -Itest test/unit/user_test.rb`
    lines = output.split(/\n/)
    lastLine = ""
    lines.each do |line|
        if line.include?("tests") && line.include?("assertions") && line.include?("failures") && line.include?("errors") && line.include?("skips")
            lastLine = line
        end
    end
    chunks = lastLine.split(",")
    totalTests = Integer(chunks[0].gsub(" tests",""))
    nrFailed = Integer(chunks[2].gsub(" failures",""))
    #render :json => { 'output' => chunks }
    render :json => { "totalTests" => totalTests, "nrFailed" => nrFailed, "output" => output }
  end
end
