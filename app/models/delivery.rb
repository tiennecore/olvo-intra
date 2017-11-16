class Delivery < ApplicationRecord

  def self.to_csv(options = {})
    desired=["client","nom","adresseA","adresseB","zipcode","unité","prix","datelivraison","heureentré","heuresortie"]
    CSV.generate(options) do |csv|
      csv << desired
      all.each do |command|
        csv << command.attributes.values_at(*desired)
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      @deliveries = Delivery.create(:client => row[0],:nom => row[1],:adressepickup => row[2],:adressedelivery => row[3],:zipcode => row[4],:unité => row[5],:prix => row[6],:datelivraison => row[7],:heureentré => row[8],:heuresortie => row[9],
        :commentaire => row[10])

    end
  end

end
