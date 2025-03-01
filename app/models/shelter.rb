class Shelter < ApplicationRecord
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true

  has_many :pets, dependent: :destroy

  def self.order_by_recently_created
    order(created_at: :desc)
  end

  def self.order_by_number_of_pets
    select("shelters.*, count(pets.id) AS pets_count")
      .joins("LEFT OUTER JOIN pets ON pets.shelter_id = shelters.id")
      .group("shelters.id")
      .order("pets_count DESC")
  end

  def self.order_reverse_alphabetically
    find_by_sql("SELECT * FROM shelters ORDER BY name DESC")
  end

  def self.with_pending_applications
    select("shelters.*").distinct
      .joins("INNER JOIN pets ON pets.shelter_id = shelters.id
              INNER JOIN application_pets ON pets.id = application_pets.pet_id
              INNER JOIN applications ON application_pets.application_id = applications.id")
      .where("applications.status = 'Pending'")
      .order(:name)
  end

  def pet_count
    pets.count
  end

  def adoptable_pets
    pets.where(adoptable: true)
  end

  def alphabetical_pets
    adoptable_pets.order(name: :asc)
  end

  def shelter_pets_filtered_by_age(age_filter)
    adoptable_pets.where('age >= ?', age_filter)
  end

  def adoptable_pets_average_age
    adoptable_pets.average(:age)
  end

  def adoptable_pet_count
    adoptable_pets.count
  end

  def action_required_pets
    pets.joins(:application_pets, :applications)
    .select("pets.*, applications.id AS application_id")
    .where("application_pets.status = 0 AND applications.status = 'Pending'")
  end

  # def action_required_applications
  #   action_required = []
  #   action_required_pets.each do |pet|
  #     pet.application_pets.each do |application_pet|
  #       if Application.find(application_pet.application_id).status == "Pending"
  #         action_required << Application.find(application_pet.application_id)
  #       end
  #     end
  #   end
  #   action_required
  # end

  def adopted_pet_count
    pets.where(adoptable: false).count
  end

  def self.make_address_readable(shelter_id)
    if find(shelter_id).address
      find_by_sql("SELECT id, CONCAT(address,' ',city,', ',state,' ',zip_code) AS address FROM shelters WHERE id=#{shelter_id}").first.address
    end
  end
end
