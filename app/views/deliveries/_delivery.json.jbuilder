json.extract! delivery, :id, :client, :nom, :adresseA, :adresseB, :zipcode, :unité, :prix, :datelivraison, :heureentré, :heuresortie, :validationcommande, :validationlivraison, :created_at, :updated_at
json.url delivery_url(delivery, format: :json)
