class AddFiltersToSpreeExports < ActiveRecord::Migration
  def change
    add_column :spree_exports, :filters, :text
  end
end
