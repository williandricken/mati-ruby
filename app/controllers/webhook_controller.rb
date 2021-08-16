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
    # identity = Identity.find_or_create_by(verification_id: verification_id)
    # (["name = ? and email = ?", "Joe", "joe@example.com"])
    identity.webhooks << webhook
    identity.save!
    # redirect_to index_webhook_path(:data => data)
  end
end
