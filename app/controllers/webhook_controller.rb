class WebhookController < ActionController::Base
  skip_before_action :verify_authenticity_token
  def index
    @webhook = Webhook.last
    @identity = @webhook.identity
  end

  def receive
    data = JSON.parse(request.body.read)
    webhook = Webhook.new
    verification_id = data["resource"].split("/").last
    webhook.data = data
    holder = Identity.where(["verification_id = ?", "#{verification_id}"])
    identity = Identity.find(holder[0]["id"])
    identity.webhooks << webhook
    identity.save!
    return "OK!"
  end

  def receive_govcheck
    data = JSON.parse(request.body.read)
    webhook = Govwebhook.new
    webhook.data = data
    # webhook.save!
    customers = Nggovcheck.where(id: 300..500)
    # data2 = data.gsub("\n", "")
    # data3 = data2.gsub("=>", ":")
    # array = []
    customers.each do |customer|
      name = customer.bvn_name.strip.split /\s+/
      dob = customer.bvn_dob.split("-")
      dob2 = dob[2] + "-" + dob[1] + "-" + dob[0]
      if (webhook.data.include?(name.first) || webhook.data.include?(name.last)) && webhook.data.include?(dob2)
        customer.govwebhooks << webhook
        customer.save!
        # data3.split(',').each do |pair|
        #   if (pair.exclude? "signature")
        #     array << pair
        #   end
        # end
      end
    end
    # webhook.data = array
    # webhook.data = data
    # govID = Govwebhook.last.id + 1
    # # govID = 1
    # govcheck = Nggovcheck.find(govID)
    # govcheck.govwebhooks << webhook
    # govcheck.save!
    return "OK!"
  end
end
