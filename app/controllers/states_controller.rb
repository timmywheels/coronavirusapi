class StatesController < ApplicationController
  before_action :set_state, only: [:show, :edit, :update, :destroy]

  STATE_COUNT = 51
  
  def summary
    @updated_date = State.last.created_at.to_s

    @states = State.all.limit(STATE_COUNT).order(id: :desc).reverse

    @tested = @states.map {|s| s.tested}.compact.sum
    @positive = @states.map {|s| s.positive}.compact.sum
    @deaths = @states.map {|s| s.deaths}.compact.sum

    @sources = @states.map {|s| s.tested_source} + @states.map {|s| s.positive_source} + @states.map {|s| s.deaths_source}
    @sources = @sources.compact.uniq.sort
  end

  def summary_test
    summary
  end

  def export_csv
	  @states = State.where("id>#{State.count - STATE_COUNT}")
	  respond_to do |format|
		  format.csv { send_data @states.to_csv, filename: "states.csv" }
	  end
  end


  # GET /states
  # GET /states.json
  def index
    @states = State.all
  end

  # GET /states/1
  # GET /states/1.json
  def show
  end

  # GET /states/new
  def new
    @state = State.new
  end

  # GET /states/1/edit
  def edit
  end

  # POST /states
  # POST /states.json
  def create
    @state = State.new(state_params)

    respond_to do |format|
      if @state.save
        format.html { redirect_to @state, notice: 'State was successfully created.' }
        format.json { render :show, status: :created, location: @state }
      else
        format.html { render :new }
        format.json { render json: @state.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /states/1
  # PATCH/PUT /states/1.json
  def update
    respond_to do |format|
      if @state.update(state_params)
        format.html { redirect_to @state, notice: 'State was successfully updated.' }
        format.json { render :show, status: :ok, location: @state }
      else
        format.html { render :edit }
        format.json { render json: @state.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /states/1
  # DELETE /states/1.json
  def destroy
    @state.destroy
    respond_to do |format|
      format.html { redirect_to states_url, notice: 'State was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_state
      @state = State.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def state_params
      params.require(:state).permit(:name, :tested, :positive, :deaths, :tested_crawl_date, :positive_crawl_date, :deaths_crawl_date, :tested_source, :positive_source, :deaths_source)
    end
end
