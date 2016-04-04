class JcoruProxy
  
  def initialize(url = Rails.configuration.jcoru_url)
    @url = url
  end  
  
  def run_junit files
    begin
      response = HTTParty.post(@url,
        :body => (files.map {|f| {:filename => f.name, :sourcecode => f.contents}}).to_json,
        :headers => {
          'Content-Type' => 'application/json'
        }
      )
      response.body
    rescue
      {'server_error' => $!.to_s}.to_json
    end
  end
end