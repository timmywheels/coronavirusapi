class StatesController < ApplicationController
  before_action :set_state, only: [:show, :edit, :update, :destroy]

  STATE_COUNT = 51
 
  def summary
    @states = State.all.limit(STATE_COUNT).order(id: :desc).reverse

    @updated_date = @states.first.created_at.to_s

    @tested = @states.map {|s| s.tested}.compact.sum
    @positive = @states.map {|s| s.positive}.compact.sum
    @deaths = @states.map {|s| s.deaths}.compact.sum

    @sources = @states.map {|s| s.tested_source} + @states.map {|s| s.positive_source} + @states.map {|s| s.deaths_source}
    @sources = @sources.compact.uniq.sort

    y=State.all.each_slice(51).to_a.map {|arr| [((arr[0].created_at.to_i.to_f/3600/24-18329)*100).round.to_f/100,
						arr.map {|i| (i.tested ? i.tested : 0)}.sum, arr.map {|i| (i.positive ? i.positive : 0)}.sum, arr.map {|i| (i.deaths ? i.deaths : 0) }.sum ].flatten }
    @chart_tested = {}
    @chart_pos = {}
    @chart_deaths = {}
    y.each do |x, tested, pos, deaths|
	@chart_tested[x] = tested
    	@chart_pos[x] = pos
    	@chart_deaths[x] = deaths
    end

    names = @states.to_a.sort {|i,j| j.positive <=> i.positive}.map {|i| i.name }[0..4]

    @chart_states = names.map do |name|
            h = {}
            State.where("name='#{name}'").to_a.map {|s| h[((s.created_at.to_i.to_f/3600/24-18329)*100).round.to_f/100] = s.positive }
      {'name' => name,
       'data' => h
      }
    end
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

  def export_all
	  data = State.all.map {|s| [s.created_at.to_i, s.name, s.tested, s.positive, s.deaths]}
	  attributes = %w{seconds_since_Epoch state tested positive deaths}
	  out = CSV.generate(headers: true) do |csv|
		  csv << attributes
		  data.each { |i| csv << i}
	  end
          respond_to do |format|
                  format.csv { send_data out, filename: "export_all.csv" }
          end
  end



  def export_time_series_csv
	  data = State.all.each_slice(51).to_a.map {|arr| [arr[0].created_at.to_s[0..18].split(" "),arr[0].created_at.to_i,arr.map {|i| (i.tested ? i.tested : 0)}.sum, arr.map {|i| (i.positive ? i.positive : 0)}.sum, arr.map {|i| (i.deaths ? i.deaths : 0) }.sum ].flatten }

attributes = %w{date time seconds_since_Epoch tested positive deaths}
                out = CSV.generate(headers: true) do |csv|
                        csv << attributes
			data.each { |i| csv << i }
                end

	  respond_to do |format|
                  format.csv { send_data out, filename: "time_series.csv" }
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
