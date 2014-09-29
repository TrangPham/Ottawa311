require 'CSV'
class ServiceRequestsController < ApplicationController
  before_action :set_service_request, only: [:show, :edit, :update, :destroy]

  # GET /service_requests
  # GET /service_requests.json
  def index
    @service_requests = ServiceRequest.all
    ingest
  end

  # GET /service_requests/1
  # GET /service_requests/1.json
  def show
  end

  # GET /service_requests/new
  def new
    @service_request = ServiceRequest.new
  end

  # GET /service_requests/1/edit
  def edit
  end

  # POST /service_requests
  # POST /service_requests.json
  def create
    @service_request = ServiceRequest.new(service_request_params)

    respond_to do |format|
      if @service_request.save
        format.html { redirect_to @service_request, notice: 'Service request was successfully created.' }
        format.json { render :show, status: :created, location: @service_request }
      else
        format.html { render :new }
        format.json { render json: @service_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /service_requests/1
  # PATCH/PUT /service_requests/1.json
  def update
    respond_to do |format|
      if @service_request.update(service_request_params)
        format.html { redirect_to @service_request, notice: 'Service request was successfully updated.' }
        format.json { render :show, status: :ok, location: @service_request }
      else
        format.html { render :edit }
        format.json { render json: @service_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /service_requests/1
  # DELETE /service_requests/1.json
  def destroy
    @service_request.destroy
    respond_to do |format|
      format.html { redirect_to service_requests_url, notice: 'Service request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service_request
      @service_request = ServiceRequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_request_params
      params.require(:service_request).permit(:creation_date, :ward, :call_description, :call_type, :maintenance_yard, :source)
    end

    # Only call when ingesting all the CSV files in files/
    def ingest
      ServiceRequest.all.delete_all
      @files = Dir["files/*.csv"]
      ServiceRequest.transaction do 
        @files.each do |file|
          ImportFormat::ServiceRequestCSV.conform(CSV.open(file), skip_first: true).each do |r|
            begin
              ServiceRequest.create(creation_date: r.creation_date,
                                  ward: r.ward,
                                  call_description: r.call_description,
                                  call_type: r.call_type,
                                  maintenance_yard: r.maintenance_yard,
                                  source: file,
                                  month: r.creation_date.strftime('%B'))
            rescue Exception => e
              puts "#{e.class}: #{e}"
            end
          end
        end
      end
    end
end