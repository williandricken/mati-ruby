class MatiController < ActionController::Base

  def index
    @welcome = "hi"
  end

  # def send_input
  #   document_type = params[:inputs][:document_name]
  #   document_front_path = params[:inputs][:document_front].path()
  #   document_back_path = params[:inputs][:document_back].path()
  #   selfie_photo_path = params[:inputs][:selfie_photo].path()
  #   document_front_name = params[:inputs][:document_front].path().split('/').last
  #   document_back_name = params[:inputs][:document_back].path().split('/').last
  #   selfie_photo_name = params[:inputs][:selfie_photo].path().split('/').last
  #   resources = create_identity()
  #   identity = resources.first
  #   access_token = resources.last
  #
  #   url = URI("https://api.getmati.com/v2/identities/#{identity.identity}/send-input")
  #
  #   https = Net::HTTP.new(url.host, url.port)
  #   https.use_ssl = true
  #
  #   request = Net::HTTP::Post.new(url)
  #   request["Authorization"] = "Bearer #{access_token}"
  #   inputs = "[{\"inputType\": \"document-photo\",\"group\": 0,\"data\": {\"type\": \"#{document_type}\",\"country\": \"BR\",\"region\": \"\",\"page\": \"front\",\"filename\": \"#{document_front_name}\"}},
  #   {\"inputType\": \"document-photo\",\"group\": 0,\"data\": {\"type\": \"#{document_type}\",\"country\": \"BR\",\"region\": \"\",\"page\": \"back\",\"filename\": \"#{document_back_name}\"}},
  #   {\"inputType\": \"selfie-photo\",\"data\": {\"type\": \"selfie\",\"filename\": \"#{selfie_photo_name}\"}}]"
  #   form_data = [
  #     ['inputs', inputs],
  #   ['document', File.open(document_front_path)],
  #   ['document', File.open(document_back_path)],
  #   ['selfie', File.open(selfie_photo_path)]]
  #   request.set_form form_data, 'multipart/form-data'
  #   test = https.request(request)
  #   @response = test.read_body
  #   # @response = form_data
  # end
  #
  # def create_identity
  #   access_token = get_access_token()
  #   mati_flow_id = ENV['MATI_FLOW_ID']
  #   url = URI("https://api.getmati.com/v2/verifications")
  #
  #   https = Net::HTTP.new(url.host, url.port)
  #   https.use_ssl = true
  #
  #   request = Net::HTTP::Post.new(url)
  #   request["Authorization"] = "Bearer #{access_token}"
  #   request["Content-Type"] = "application/json"
  #   request.body = JSON.dump({
  #     "flowId": "#{mati_flow_id}",
  #     "metadata": {
  #       "user": "test ruby",
  #       "id": "rails"
  #     }
  #   })
  #
  #   response = https.request(request)
  #   result = JSON.parse(response.read_body)
  #   identity = Identity.new(verification_id: result["id"],
  #      document: result["documents"],
  #       expired: result["expired"],
  #        flow: result["flow"],
  #         identity: result["identity"],
  #          input: result["inputs"],
  #           metadata: result["metadata"],
  #            step: result["steps"],
  #             device_fingerprint: result["deviceFingerprint"],
  #              has_problem: result["hasProblem"])
  #   identity.save!
  #   token_identity = []
  #   token_identity << identity
  #   token_identity << access_token
  #   return token_identity
  # end
  #
  # def get_access_token
  #   mati_api_credentials = Base64.encode64(ENV['MATI_API_CREDENTIALS'].to_s).gsub(/\n/, '')
  #
  #   url = URI("https://api.getmati.com/oauth")
  #
  #   https = Net::HTTP.new(url.host, url.port)
  #   https.use_ssl = true
  #
  #   request = Net::HTTP::Post.new(url)
  #   request["Content-Type"] = "application/x-www-form-urlencoded"
  #   request["Authorization"] = "Basic #{mati_api_credentials}"
  #   request.body = "grant_type=client_credentials"
  #
  #   response = https.request(request)
  #   result = JSON.parse(response.read_body)
  #   return result["access_token"]
  #
  # end
  #
  # def input_params
  #   params.permit(:inputs)
  # end
end
