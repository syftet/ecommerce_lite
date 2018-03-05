class CreateNewsletterSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :newsletter_subscriptions do |t|

      t.string :email
      t.boolean :active, default: true
      t.timestamps
    end
  end
end
