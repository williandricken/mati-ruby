class IdentitiesController < ApplicationController
  before_action :set_identity, only: %i[ show edit update destroy ]
# = f.input :document_name, as: :radio_buttons, collection: [['national-id', 'National ID'], ['passport', 'Passport'], ['driving-license', 'Driving License'], ['proof-of-residency', 'Proof of Residency']], label_method: :second, value_method: :first
  # GET /identities or /identities.json
  def index
    @identities = Identity.all
  end

  # GET /identities/1 or /identities/1.json
  def show
  end

  # GET /identities/new
  def new

  end

  def flow_step1
    @url = verification_path
    @document_type = 'driving-license'
    @input_type = 'document-photo'
    session[:tmp_identity] = create_identity()
    @step = 1
  end

  def flow_step2
    @url = verification_path
    @document_type = 'driving-license'
    @input_type = 'document-photo'
    @step = 2
  end

  def flow_step3
    @url = verification_path
    @document_type = 'selfie'
    @input_type = 'selfie-photo'
    @step = 3
  end

  def verification
    step = params[:inputs][:step]
    document_type = params[:inputs][:document_type]
    input_type = params[:inputs][:input_type]
    document_file_path = params[:inputs][:document_file].path()
    # document_back_path = params[:inputs][:document_back].path()
    # selfie_photo_path = params[:inputs][:selfie_photo].path()
    document_file_name = params[:inputs][:document_file].path().split('/').last
    # document_back_name = params[:inputs][:document_back].path().split('/').last
    # selfie_photo_name = params[:inputs][:selfie_photo].path().split('/').last
    # input_type_document = 'document'
    # input_type_selfie = 'selfie'
    # resources = create_identity()
    # identity = params[:inputs][:identity]
    identity = session[:tmp_identity]
    # access_token = resources.last

    if document_type == 'driving-license' && step == "1"
      document_file_input = "[{\"inputType\": \"#{input_type}\",\"group\": 0,\"data\": {\"type\": \"#{document_type}\",\"country\": \"BR\", \"page\": \"front\",\"filename\": \"#{document_file_name}\"}}]"
    elsif document_type == 'driving-license' && step == "2"
      document_file_input = "[{\"inputType\": \"#{input_type}\",\"group\": 0,\"data\": {\"type\": \"#{document_type}\",\"country\": \"BR\", \"page\": \"back\",\"filename\": \"#{document_file_name}\"}}]"
    else
      document_file_input = "[{\"inputType\": \"#{input_type}\",\"data\": {\"type\": \"#{document_type}\",\"filename\": \"#{document_file_name}\"}}]"
    end
    # document_back_input = "[{\"inputType\": \"document-photo\",\"group\": 0,\"data\": {\"type\": \"#{document_type}\",\"country\": \"BR\",\"region\": \"\",\"page\": \"back\",\"filename\": \"#{document_back_name}\"}}]"
    # document_selfie_input = "[{\"inputType\": \"selfie-photo\",\"data\": {\"type\": \"selfie\",\"filename\": \"#{selfie_photo_name}\"}}]"

    document_file = File.open(document_file_path)
    # document_back_file = File.open(document_back_path)
    # document_selfie_file = File.open(selfie_photo_path)

    response_api = send_input(document_file_input, document_file, identity, input_type)
    result = JSON.parse(response_api)
    # @document_back_response = send_input(document_back_input, document_back_file, identity, input_type_document)
    # @document_selfie_response = send_input(document_selfie_input, document_selfie_file, identity, input_type_selfie)

    if result[0]["result"]
      next_step(step)
    else
      redo_step(step)
    end
  end

  def next_step(step)
    # @identity = identity
    case step
    when "1"
      # render :flow_step2, @identity
      redirect_to flow_step2_path
    when "2"
      redirect_to flow_step3_path
    when "3"
      redirect_to identities_path
    end
  end

  def redo_step(step)
    case step
    when 1
      flash.now[:danger] = "Algo de errado aconteceu."
      render :flow_step1
    when 2
      flash.now[:danger] = "Algo de errado aconteceu."
      render :flow_step2
    when 3
      flash.now[:danger] = "Algo de errado aconteceu."
      render :flow_step3
    end
  end

  def send_input (input, file, identity, input_type)
    access_token = get_access_token()
    url = URI("https://api.getmati.com/v2/identities/#{identity}/send-input")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(url)
    request["Authorization"] = "Bearer #{access_token}"

    # type = "'" + input_type.split('-').first + "'"
    type = input_type.split('-').first
    form_data = [['inputs', input],[type, file]]
    request.set_form form_data, 'multipart/form-data'

    response = https.request(request)

    return response.read_body
  end

  def create_identity
    access_token = get_access_token()
    mati_flow_id = ENV['MATI_FLOW_ID']
    url = URI("https://api.getmati.com/v2/verifications")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Authorization"] = "Bearer #{access_token}"
    request["Content-Type"] = "application/json"
    request.body = JSON.dump({
      "flowId": "#{mati_flow_id}",
      "metadata": {
        "user": "test ruby",
        "id": "rails"
      }
    })

    response = https.request(request)
    result = JSON.parse(response.read_body)
    identity = Identity.new(verification_id: result["id"],
       document: result["documents"],
        expired: result["expired"],
         flow: result["flow"],
          identity: result["identity"],
           input: result["inputs"],
            metadata: result["metadata"],
             step: result["steps"],
              device_fingerprint: result["deviceFingerprint"],
               has_problem: result["hasProblem"])
    identity.save!
    # token_identity = []
    # token_identity << identity
    # token_identity << access_token
    return identity.identity
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



  # GET /identities/1/edit
  # def edit
  # end

  # POST /identities or /identities.json
  # def create
  #   @identity = Identity.new(identity_params)
  #
  #   respond_to do |format|
  #     if @identity.save
  #       format.html { redirect_to @identity, notice: "Identity was successfully created." }
  #       format.json { render :show, status: :created, location: @identity }
  #     else
  #       format.html { render :new, status: :unprocessable_entity }
  #       format.json { render json: @identity.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /identities/1 or /identities/1.json
  # def update
  #   respond_to do |format|
  #     if @identity.update(identity_params)
  #       format.html { redirect_to @identity, notice: "Identity was successfully updated." }
  #       format.json { render :show, status: :ok, location: @identity }
  #     else
  #       format.html { render :edit, status: :unprocessable_entity }
  #       format.json { render json: @identity.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /identities/1 or /identities/1.json
  # def destroy
  #   @identity.destroy
  #   respond_to do |format|
  #     format.html { redirect_to identities_url, notice: "Identity was successfully destroyed." }
  #     format.json { head :no_content }
  #   end
  # end

  def input_params
    params.permit(:inputs)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_identity
      @identity = Identity.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def identity_params
      params.fetch(:identity, {})
    end

end
