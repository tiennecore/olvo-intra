class Delivery < ApplicationRecord
  validates :client, presence: true
  validates :nom,presence:true
  validates :adressedelivery,presence:true
  validates :zipcode,presence:true
  validates :unité,presence:true
  validates :datelivraison,presence:true
  def self.to_csv(options = {})
    desired=["client","nom","adressepickup","adressedelivery","zipcode","unité","prix","datelivraison","heureentré","heuresortie","commentaire"]
    CSV.generate(options) do |csv|
      csv << desired
      all.each do |command|
        csv << command.attributes.values_at(*desired)
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      @delivery = Delivery.create(:client => row[0],:nom => row[1],:adressepickup => row[2],:adressedelivery => row[3],:zipcode => row[4],:unité => row[5],:datelivraison => row[6],:heureentré => row[7],:heuresortie => row[8],
        :commentaire => row[9])
      @delivery.validationcommande=false
      @delivery.validationlivraison=false
      @delivery.save

    end
  end

end
