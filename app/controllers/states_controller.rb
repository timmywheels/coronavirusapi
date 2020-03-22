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

    y=State.all.each_slice(STATE_COUNT).to_a.map {|arr| [arr[0].created_at,
						arr.map {|i| (i.tested ? i.tested : 0)}.sum, arr.map {|i| (i.positive ? i.positive : 0)}.sum, arr.map {|i| (i.deaths ? i.deaths : 0) }.sum ].flatten }
    @chart_tested = {}
    @chart_pos = {}
    @chart_deaths = {}
    y.each do |x, tested, pos, deaths|
	@chart_tested[x] = tested
	@chart_pos[x] = pos
	#@chart_pos[x] = Math.log(pos.to_f, 10)
    	@chart_deaths[x] = deaths
    end

    names = @states.to_a.sort {|i,j| j.positive.to_i <=> i.positive.to_i}.map {|i| i.name }[0..9]

    @chart_states = names.map do |name|
            h = {}
            State.where("name='#{name}'").to_a.map {|s| h[((s.created_at.to_i.to_f/3600/24-18329)*10).round.to_f/10] = s.positive }
      {'name' => name,
       'data' => h
      }
    end

    h_pop = {"AL"=>4779736, "AK"=>710231, "AZ"=>6392017, "AR"=>2915918, "CA"=>37253956, "CO"=>5029196, "CT"=>3574097, "DE"=>897934, "DC"=>601723, "FL"=>18801310, "GA"=>9687653, "HI"=>1360301, "ID"=>1567582, "IL"=>12830632, "IN"=>6483802, "IA"=>3046355, "KS"=>2853118, "KY"=>4339367, "LA"=>4533372, "ME"=>1328361, "MD"=>5773552, "MA"=>6547629, "MI"=>9883640, "MN"=>5303925, "MS"=>2967297, "MO"=>5988144, "MT"=>989415, "NE"=>1826341, "NV"=>2700551, "NH"=>1316470, "NJ"=>8791894, "NM"=>2059179, "NY"=>19378102, "NC"=>9535483, "ND"=>672591, "OH"=>11536504, "OK"=>3751351, "OR"=>3831074, "PA"=>12702379, "RI"=>1052567, "SC"=>4625364, "SD"=>814180, "TN"=>6346165, "TX"=>25145561, "US"=>308745538, "UT"=>2763885, "VT"=>625741, "VA"=>8001024, "WA"=>6724540, "WV"=>1852994, "WI"=>5686986, "WY"=>563626}

names = @states.to_a.sort {|i,j| j.positive.to_f/h_pop[j.name.upcase] <=> i.positive.to_f/h_pop[i.name.upcase]}.map {|i| i.name }[0..9]
    @chart_states2 = names.map do |name|
            h = {}
	    State.where("name='#{name}'").to_a.map {|s| h[((s.created_at.to_i.to_f/3600/24-18329)*10).round.to_f/10] = (s.positive.to_f/h_pop[name.upcase]*1000_000_0).round.to_f/10 }
      {'name' => name,
       'data' => h
      }
    end
  end

  def summary_test
    summary
  end

  def export_csv
	  max_id = State.last.id
	  @states = State.where("id>#{max_id - STATE_COUNT + 1}")
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
	  data = State.all.each_slice(STATE_COUNT).to_a.map {|arr| [arr[0].created_at.to_s[0..18].split(" "),arr[0].created_at.to_i,arr.map {|i| (i.tested ? i.tested : 0)}.sum, arr.map {|i| (i.positive ? i.positive : 0)}.sum, arr.map {|i| (i.deaths ? i.deaths : 0) }.sum ].flatten }

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
