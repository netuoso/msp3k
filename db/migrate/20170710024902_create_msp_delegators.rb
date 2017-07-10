class CreateMspDelegators < ActiveRecord::Migration[5.1]
  def change
    create_table :msp_delegators do |t|
      t.string :username
      t.float :delegated_mvests
      t.integer :delegated_sp
      t.boolean :blacklisted

      t.timestamps
    end
  end
end
