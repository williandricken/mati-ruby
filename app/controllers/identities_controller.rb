class IdentitiesController < ApplicationController
  before_action :set_identity, only: %i[ show edit update destroy ]

  # GET /identities or /identities.json
  def index
    @identities = Identity.all
  end

  # GET /identities/1 or /identities/1.json
  def show
  end

  # GET /identities/new
  def new
    @identity = Identity.new
  end

  # GET /identities/1/edit
  def edit
  end

  # POST /identities or /identities.json
  def create
    @identity = Identity.new(identity_params)

    respond_to do |format|
      if @identity.save
        format.html { redirect_to @identity, notice: "Identity was successfully created." }
        format.json { render :show, status: :created, location: @identity }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @identity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /identities/1 or /identities/1.json
  def update
    respond_to do |format|
      if @identity.update(identity_params)
        format.html { redirect_to @identity, notice: "Identity was successfully updated." }
        format.json { render :show, status: :ok, location: @identity }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @identity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /identities/1 or /identities/1.json
  def destroy
    @identity.destroy
    respond_to do |format|
      format.html { redirect_to identities_url, notice: "Identity was successfully destroyed." }
      format.json { head :no_content }
    end
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
