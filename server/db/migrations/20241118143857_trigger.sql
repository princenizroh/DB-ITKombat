-- migrate:up

-- update_last_activity
create or replace function update_last_activity()
returns trigger 
as $$
begin
	update player 
	set time_activity = current_timestamp
	where player_id = new.player_id;

	return new;
end;
$$ language plpgsql;

create or replace trigger trg_update_last_activity
after insert on login_history 
for each row 
execute function update_last_activity();

-- migrate:down
