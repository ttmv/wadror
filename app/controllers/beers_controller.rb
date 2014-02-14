class BeersController < ApplicationController
  before_action :set_beer, only: [:show, :edit, :update, :destroy]
  before_action :set_styles, only: [:new, :edit]
  before_action :ensure_that_signed_in, except: [:index, :show]
  before_action :ensure_that_admin, only: [:destroy]

  # GET /beers
  # GET /beers.json
  def index
    @beers = Beer.all
  end

  # GET /beers/1
  # GET /beers/1.json
  def show
    @rating = Rating.new
    @rating.beer = @beer
  end

  # GET /beers/new
  def new
    @beer = Beer.new
    @breweries = Brewery.all
   # @styles = ["Weizen", "Lager", "Pale ale", "IPA", "Porter"]
  end

  # GET /beers/1/edit
  def edit
    @breweries = Brewery.all
   # @styles = ["Weizen", "Lager", "Pale ale", "IPA", "Porter"]
 end

  # POST /beers
  # POST /beers.json
  def create
    @beer = Beer.new(beer_params)

    respond_to do |format|
      if @beer.save
        format.html { redirect_to beers_path, notice: 'Beer was successfully created.' }
        format.json { render action: 'show', status: :created, location: @beer }
      else
        @breweries = Brewery.all
        set_styles
        format.html { render action: 'new' }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beers/1
  # PATCH/PUT /beers/1.json
  def update
    respond_to do |format|
      if @beer.update(beer_params)
        format.html { redirect_to @beer, notice: 'Beer was successfully updated.' }
        format.json { head :no_content }
      else
        @breweries = Brewery.all
        set_styles
        format.html { render action: 'edit' }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beers/1
  # DELETE /beers/1.json
  def destroy
    @beer.destroy
    respond_to do |format|
      format.html { redirect_to beers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_beer
      @beer = Beer.find(params[:id])
    end


    def set_styles
      @styles = Style.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def beer_params
      params.require(:beer).permit(:name, :style, :brewery_id, :style_id)
    end
end
