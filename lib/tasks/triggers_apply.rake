namespace :triggers_apply do
  desc 'Creates all listed triggers in database'
  task all: :environment do
    Rake::Task['triggers_apply:create_prevent_records_delete_function'].invoke
    Rake::Task['triggers_apply:prevent_movement_delete'].invoke
  end

  desc 'Create function that prevents deleting records'
  task create_prevent_records_delete_function: :environment do
    query_text = <<~TRIGGER
      CREATE OR REPLACE FUNCTION prevent_records_delete() RETURNS trigger
        AS
        $func$
        BEGIN
          RAISE EXCEPTION 'Deleting of entity is unacceptable';
          RETURN OLD;
        END
        $func$
      LANGUAGE plpgsql;
    TRIGGER

    ActiveRecord::Base.connection.execute(query_text)
  end

  desc 'Prevents deleting movements'
  task prevent_movement_delete: :environment do
    query_text = <<~QUERY
      DROP TRIGGER IF EXISTS prevent_movement_delete ON movements;

      CREATE TRIGGER prevent_movement_delete BEFORE DELETE ON movements
          FOR EACH ROW EXECUTE PROCEDURE prevent_records_delete();
    QUERY

    Rake::Task['triggers_apply:create_prevent_records_delete_function'].invoke
    ActiveRecord::Base.connection.execute(query_text)
  end
end

#
# Добавление триггеров в при подготовке тестовой базы
#
Rake::Task['db:test:prepare'].enhance do
  Rake::Task['triggers_apply:all'].invoke
end
