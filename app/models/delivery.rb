class Delivery < ApplicationRecord
  validates :client, presence: true
  validates :nom,presence:true
  validates :adressedelivery,presence:true
  validates :datelivraison,presence:true
  def self.to_csv(options = {})
    desired=["client","nom","adressepickup","adressedelivery","unité","datelivraison","heureentré","heuresortie","commentaire"]
    CSV.generate(options) do |csv|
      csv << desired
      all.each do |command|
        csv << command.attributes.values_at(*desired)
      end
    end
  end

  def self.import(file)
    @listdeliveries=[]
    @importvalid=1
    if(file.present?)
      CSV.foreach(file.path, headers: true) do |row|
        @delivery = Delivery.new(:client => row[0],:nom => row[1],:adressepickup => row[2],:adressedelivery => row[3],:unité => row[4],:datelivraison => row[5],:heureentré => row[6],:heuresortie => row[7],
          :commentaire => row[8])
        @delivery.validationcommande=false
        @delivery.validationlivraison=false
        if !@delivery.unité.present?
          @delivery.unité=1
        end
        if !@delivery.heureentré.present?
          date=DateTime.now.change(hour:10,min:0)
          @delivery.heureentré= date
        end
        if !@delivery.heuresortie.present?
          date=DateTime.now.change(hour:20,min:0)
          @delivery.heuresortie=date
        end
        @listdeliveries.push(@delivery)
      end
      @listdeliveries.each do |v|
        if !v.client.present? || !v.nom.present? || !v.adressedelivery.present? || !v.datelivraison.present?
          @importvalid=0
          break
        end
      end
      if @importvalid == 1
        @listdeliveries.each do |s|
          s.save
        end
      end
    end
  else
    @importvalid=0
  end
  return @importvalid
end
