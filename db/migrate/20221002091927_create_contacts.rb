class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.string :email, null: false
      t.text :first_name, null: false
      t.text :last_name, null: false
      t.text :company, null: false
      t.text :website

      t.timestamps
    end

    add_index :contacts, :email, unique: true

    create_table :events do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :events, :name, unique: true

    create_table :contacts_events do |t|
      t.belongs_to :contact
      t.belongs_to :event

      t.timestamps
    end
  end
end
