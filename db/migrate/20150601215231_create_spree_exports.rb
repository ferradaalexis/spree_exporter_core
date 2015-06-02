class CreateSpreeExports < ActiveRecord::Migration
  def change
    create_table :spree_exports do |t|
      t.attachment :document
      t.datetime   :started_at
      t.datetime   :finished_at
      t.string     :state
      t.string     :exporter
      t.text       :messages

      t.timestamps
    end
  end
end
