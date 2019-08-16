class AddNoDeleteMovementTrigger < ActiveRecord::Migration[5.2]
  def up
    Rake::Task['triggers_apply:prevent_movement_delete'].invoke
  end

  def down
    conn = ActiveRecord::Base.connection
    conn.execute('DROP TRIGGER IF EXISTS prevent_movement_delete ON movements')
    conn.execute('DROP FUNCTION prevent_records_delete()')
  end
end
