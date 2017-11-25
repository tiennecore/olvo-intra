module Request
  class OlvoApi < Grape::API
    prefix :api
    version 'v1', using: :path
    format :json

    resource :deliveries do
      #  /api/v1/deliveries test
      get do
        deliveries=Delivery.all
        {deliveries: deliveries}
      end

      delete 'delete/:client/:nom/:adressedelivery/:datelivraison' do
        delivery=Delivery.find(params[:client,:nom,:adressedelivery,:datelivraison])
        if delivery.validationcommande?

        else
          delivery.delete
        end
      end

      #  /api/v1/deliveries/:id value of a daliveries
      get ':client/:nom/:adressedelivery/:datelivraison' do
        delivery=Delivery.find(params[:client,:nom,:adressedelivery,:datelivraison])
        {deliveries_id: delivery}
      end

      params do
        requires :delivery, type: Hash do
          requires :client, type: String
          requires :nom, type: String
          optional :adressepickup, type: String
          requires :adressedelivery, type: String
          optional :unité, type: Integer
          requires :datelivraison, type: Date
          optional :heureentré, type: Time
          optional :heuresortie, type: Time
          optional :commentaire
        end
      end
      #  /api/v1/deliveries/new
      post 'new' do
        command = Delivery.new(declared(params)[:delivery])
        command.validationcommande=false
        command.validationlivraison=false
        if !command.heureentré.present?
          date=DateTime.now.change(hour:10,min:0)
          command.heureentré= date
        end
        if !command.heuresortie.present?
          date=DateTime.now.change(hour:20,min:0)
          command.heuresortie=date
        end
        if !command.unité.present? || command.unité < 1
          command.unité=1
        end
        command.save
      end

      post 'update/:client/:nom/:adressedelivery/:datelivraison' do
        delivery=Delivery.find(params[:client,:nom,:adressedelivery,:datelivraison])
        delivery.update_attributes(params[:delivery])
        delivery.save

      end
    end

  end
end
