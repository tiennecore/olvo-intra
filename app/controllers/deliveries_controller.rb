class DeliveriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_delivery, only: [:show, :edit, :update, :destroy]
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  def front_date (list)
    @listDate = []
    tmplist=list.find_all { |e| e and e.datelivraison }
    list=tmplist.uniq.sort_by { |obj| obj.datelivraison }
    if !list.empty?
      @firstDate = list.first.datelivraison
      list.each do |element|
        if @firstDate > element.datelivraison
          @firstDate = element.datelivraison
        end
      end

      dateBefore = list.first.datelivraison
      @listDate.push(dateBefore)
      list.each do |commande|
        if commande.datelivraison != dateBefore
          @listDate.each do |tmpdate|
            if commande.datelivraison == tmpdate
              break
            end
          end
          dateBefore=commande.datelivraison
          @listDate.push(commande.datelivraison)
        end
      end
    end
  end

  # GET /deliveries
  # GET /deliveries.json
  def indexhistorique

    searchclient=params[:findclient]
    searchadresse=params[:findadresse]
    searchdate=params[:finddate]
    @deliveries= Delivery.all
    if (searchclient.present?)
      @deliveries = @deliveries.where("client LIKE ?","%#{params[:findclient]}%")
    end
    if (searchadresse.present?)
      @deliveries = @deliveries.where("adressedelivery LIKE ? or adressepickup LIKE ?","%#{params[:findadresse]}%","%#{params[:findadresse]}%")
    end
    if (searchdate.present?)
      @deliveries = @deliveries.where("datelivraison LIKE ?","%#{params[:finddate]}%")
    end
    front_date(@deliveries)

    respond_to do |format|
      format.html
      format.csv { send_data @deliveries.to_csv }
    end
  end
  def index

    searchclient=params[:findclient]
    searchadresse=params[:findadresse]
    searchdate=params[:finddate]
    @deliveries= Delivery.where(validationcommande: false,validationlivraison:false)
    if (searchclient.present?)
      @deliveries = @deliveries.where("client LIKE ?","%#{params[:findclient]}%")
    end
    if (searchadresse.present?)
      @deliveries = @deliveries.where("adressedelivery LIKE ? or adressepickup LIKE ?","%#{params[:findadresse]}%","%#{params[:findadresse]}%")
    end
    if (searchdate.present?)
      @deliveries = @deliveries.where("datelivraison LIKE ?","%#{params[:finddate]}%")
    end
    front_date(@deliveries)

    respond_to do |format|
      format.html
      format.csv { send_data @deliveries.to_csv }
    end
  end

  def indexlivraison
    @deliveries= Delivery.where(validationcommande: true,validationlivraison: false)
    searchclient=params[:findclient]
    searchadresse=params[:findadresse]
    searchdate=params[:finddate]
    if (searchclient.present?)
      @deliveries = @deliveries.where("client LIKE ?","%#{params[:findclient]}%")
    end
    if (searchadresse.present?)
      @deliveries = @deliveries.where("adressedelivery LIKE ? or adressepickup LIKE ?","%#{params[:findadresse]}%","%#{params[:findadresse]}%")
    end
    if (searchdate.present?)
      @deliveries = @deliveries.where("datelivraison LIKE ?","%#{params[:finddate]}%")
    end
    front_date(@deliveries)

    respond_to do |format|
      format.html
      format.csv { send_data @deliveries.to_csv }
    end
  end

  def indexday
    @deliveries= Delivery.where(datelivraison: Date.today)
    searchclient=params[:findclient]
    searchadresse=params[:findadresse]
    if (searchclient.present?)
      @deliveries = @deliveries.where("client LIKE ?","%#{params[:findclient]}%")
    end
    if (searchadresse.present?)
      @deliveries = @deliveries.where("adressedelivery LIKE ? or adressepickup LIKE ?","%#{params[:findadresse]}%","%#{params[:findadresse]}%")
    end
    front_date(@deliveries)

    respond_to do |format|
      format.html
      format.csv { send_data @deliveries.to_csv }
    end
  end

  def indexweek
    dateB=Date.today.beginning_of_week(:monday)
    dateE=Date.today.end_of_week(:monday)
    @deliveries= Delivery.where(datelivraison: dateB..dateE)
    searchclient=params[:findclient]
    searchadresse=params[:findadresse]

    if (searchclient.present?)
      @deliveries = @deliveries.where("client LIKE ?","%#{params[:findclient]}%")
    end
    if (searchadresse.present?)
      @deliveries = @deliveries.where("adressedelivery LIKE ? or adressepickup LIKE ?","%#{params[:findadresse]}%","%#{params[:findadresse]}%")
    end
    front_date(@deliveries)

    respond_to do |format|
      format.html
      format.csv { send_data @deliveries.to_csv }
    end
  end




  def toggle
    @delivery = Delivery.find(params[:id])

    if @delivery.update_attributes(:validationcommande => params[:validationcommande])
      # ... update successful
    else
      set_flash "Erreur, réessayer .."
      # ... update failed
    end
  end

  def toggle2
    @delivery = Delivery.find(params[:id])

    if @delivery.update_attributes(:validationlivraison => params[:validationlivraison])
      # ... update successful
    else
      set_flash "Erreur, réessayer .."
      # ... update failed
    end
  end

  def import

    respond_to do |format|
      if (Delivery.import(params[:file]) == 1)
        format.html { redirect_to deliveries_url, notice: 'Les livraisons ont été créées.' }
      else
        format.html { redirect_to new_delivery_path , notice: 'il y a une erreur dans votre csv'}
      end
    end
  end

  # GET /deliveries/1
  # GET /deliveries/1.json
  def show
  end

  # GET /deliveries/new
  def new
    @deliveries=Delivery.where(validationcommande: nil)
    @delivery = Delivery.new
    respond_to do |format|
      format.html
      format.csv { send_data @deliveries.to_csv }
    end
  end

  # GET /deliveries/1/edit
  def edit
  end

  # POST /deliveries
  # POST /deliveries.json
  def create
    @delivery = Delivery.new(delivery_params)
    @delivery.validationcommande=false
    @delivery.validationlivraison=false
    if !@delivery.heureentré.present?
      date=DateTime.now.change(hour:10,min:0)
      @delivery.heureentré= date
    end
    if !@delivery.heuresortie.present?
      date=DateTime.now.change(hour:20,min:0)
      @delivery.heuresortie=date
    end
    respond_to do |format|
      if @delivery.save
        format.html { redirect_to deliveries_url, notice: 'La livraison a été créée.' }
        format.json { render :show, status: :created, location: @delivery }
      else
        format.html { render :new }
        format.json { render json: @delivery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deliveries/1
  # PATCH/PUT /deliveries/1.json
  def update
    respond_to do |format|
      if @delivery.update(delivery_params)
        format.html { redirect_to deliveries_url, notice: 'La livraison à été modifié.' }
        format.json { render :show, status: :ok, location: @delivery }
      else
        format.html { render :edit }
        format.json { render json: @delivery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deliveries/1
  # DELETE /deliveries/1.json
  def destroy
    @delivery.destroy
    respond_to do |format|
      format.html { redirect_to deliveries_url, notice: 'Delivery was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_delivery
      @delivery = Delivery.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def delivery_params
      params.require(:delivery).permit(:client, :nom, :adressedelivery, :adressepickup, :unité, :datelivraison, :heureentré, :heuresortie, :validationcommande, :validationlivraison, :commentaire)
    end
end
