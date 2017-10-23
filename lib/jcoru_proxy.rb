class JcoruProxy

  JCORU_URL_ENV = "JCORU_URL"

  def initialize
    jcoru_url = ENV[JCORU_URL_ENV]

    raise "The JCORU_URL environment variable is not set" if jcoru_url.to_s.empty?

    @url = "#{jcoru_url}/test"
  end  
  
  def run_junit files
    puts "jcoru: #{@url}"
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