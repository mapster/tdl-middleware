module JcoruHelper
  def jcoru_test files
    begin
      response = HTTParty.post(Rails.configuration.jcoru_url,
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