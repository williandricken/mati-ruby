class GovcheckController < ApplicationController

  def index
    # checks = Nggovcheck.all
    # checks.each do |check|
    #   check.user = check.user.remove("\t")
    #   check.phone = check.phone.remove("\t")
    #   check.bvn = check.bvn.remove("\t")
    #   check.bvn_name = check.bvn_name.remove("\t")
    #   check.bvn_phone s= check.bvn_phone.remove("\t")
    #   check.bvn_dob = check.bvn_dob.remove("\t")
    #   check.save!
    # end
    customers = Nggovcheck.where(id: 300..500)
    # customer = Nggovcheck.first
    access_token = get_access_token()
    @responses = []
    customers.each do |customer|
      url = URI("https://api.getmati.com/govchecks/v1/ng/nin")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/json"
      request["Authorization"] = "Bearer #{access_token}"
      request.body = JSON.dump({
        "phone": "#{customer.phone.remove("234")}",
        "callbackUrl": "http://f17f-191-177-184-7.ngrok.io/webhook/receive_govcheck"
      })
      @responses << https.request(request)
      sleep 5
      # return @response.read_body
    end
    return @responses
  end

  def get_access_token
    mati_api_credentials = Base64.encode64(ENV['MATI_API_CREDENTIALS'].to_s).gsub(/\n/, '')

    url = URI("https://api.getmati.com/oauth")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/x-www-form-urlencoded"
    request["Authorization"] = "Basic #{mati_api_credentials}"
    request.body = "grant_type=client_credentials"

    response = https.request(request)
    result = JSON.parse(response.read_body)
    return result["access_token"]
  end

  def webhooks
    # data = Nggovcheck.first.govwebhooks.first.data
    # data2 = data.gsub("\n", "")
    # data3 = data2.gsub("=>", ":")
    # hash = {}
    # array = []
    # data3.split(',').each do |pair|
    #   if (pair.exclude? "signature")
    #     array << pair
    #   end
    # end
    # @webhooks = hash.values
    # array =
    # @webhooks = Govwebhook.all
    @customers = Nggovcheck.where(id: 1..6500)
    @array = 0
    @customers.each do |customer|
      if customer.govwebhooks.count == 0
        @array = @array + 1
      end
    end
    # @webhooks = Govwebhook.all
    respond_to do |format|
      format.xlsx
      format.html { render :webhooks }
    end

  end

  # {
  #     "name": "invalid_token",
  #     "message": "jwt expired",delete_at(index)
  #     "code": 401
  # }

end
