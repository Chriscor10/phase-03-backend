class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
      create_table :companies do |t|
        t.string :name
        t.string :phone
        t.string :address
        t.integer :rating
        t.belongs_to :service, foreign_key: true
      end
  end
end
