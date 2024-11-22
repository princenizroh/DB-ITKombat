-- migrate:up
create or replace procedure getPlayerById(
	p_player_id int
)
language plpgsql
as $$
declare
  v_player_id int;
begin
  -- transaction
  begin
    select player_id into v_player_id
    from player
    where player_id = p_player_id;

    if not found then
    --   rollback;
      raise exception 'id player tidak ditemukan: %', p_player_id;
    end if;
	commit;
	raise notice 'Menemukan id player: %', p_player_id;
  end;
end;
$$;

create or replace procedure getAdminById(
	p_player_id int
)
language plpgsql
as $$
declare
  	v_player_id int;
begin
  	-- transaction
  	begin
    	select player_id into v_player_id
    	from player
    	where player_id = p_player_id and role = 'admin';

	    if not found then
	    	rollback;
	    	raise exception 'id player dengan role admin tidak ditemukan: %', p_player_id;
	    end if;

		commit;
		raise notice 'Menemukan id player: %', p_player_id;
  	end;
end;
$$;


-- migrate:down
drop procedure if exists getPlayerById;
drop procedure if exists getAdminById;
