class AddAgeAndCityToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :age, :string
    add_column :users, :city, :string
  end
end
