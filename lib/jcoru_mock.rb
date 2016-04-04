class JcoruMock
  
  attr_accessor :test_files, :report
  
  def run_junit files
    @test_files = files
    @report
  end
end