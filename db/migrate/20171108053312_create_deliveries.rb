class CreateDeliveries < ActiveRecord::Migration[5.1]
  def change
    create_table :deliveries do |t|
      t.string :client
      t.string :nom
      t.string :adressedelivery
      t.string :adressepickup
      t.integer :unité
      t.date :datelivraison
      t.time :heureentré
      t.time :heuresortie
      t.boolean :validationcommande
      t.boolean :validationlivraison
      t.text :commentaire

      t.timestamps
    end
  end
end
