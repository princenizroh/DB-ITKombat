-- migrate:up

-- login
create or replace procedure login(
	p_username varchar,
	p_password varchar,
	p_role varchar default 'player'
)
language plpgsql
as $$
declare 
	v_player_id int;
begin
	--transaction
	begin
		select player_id into v_player_id 
		from player 
		where username = p_username and password = p_password and role = p_role;
	
		if not found then
			rollback;
			raise exception 'username dan password salah';
		end if;
	
		--masukan ke dalam login_history
		insert into login_history(player_id, login_type)
		values (v_player_id, 'login');

		commit;
	
		raise notice 'login berhasil: %', p_username;
	end;
end;
$$;

-- register
create or replace procedure register(
	p_username varchar,
	p_email varchar,
	p_password varchar,
	p_role varchar default 'player'
)
language plpgsql
as $$
begin
	--transaction
	begin
		if exists (select 1 from player where username = p_username or email = p_email) then
			rollback;
			raise exception 'Username atau email sudah terpakai';
		end if;

		insert into player (username, email, password)
		values (p_username, p_email, p_password);
		
		commit;

		raise notice 'Register berhasil: %', p_username;
	end;
end;
$$;

-- logout
create or replace procedure logout(
	p_username varchar
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
		where username = p_username;

		if not found then
			rollback;
			raise exception 'user tidak ditemukan: %', p_username;
		end if;
		
		insert into login_history(player_id, login_type)
		values (v_player_id, 'logout');
	end;
end;
$$

-- findPlayerBy Id
-- create or replace procedure getPlayerById(
-- 	p_player_id int
-- )
-- language plpgsql
-- as $$
-- declare
--   v_player_id int;
-- begin
--   -- transaction
-- --   begin
--     select player_id into v_player_id
--     from player
--     where player_id = p_player_id;
--
--     if not found then
--     --   rollback;
--       raise exception 'id player tidak ditemukan: %', p_player_id;
--     end if;
-- 	-- commit;
-- 	raise notice 'Menemukan id player: %', p_player_id;
-- --   end;
-- end;
-- $$;

-- -- show player_activity
--
-- CREATE OR REPLACE PROCEDURE show_player_activity()
-- LANGUAGE plpgsql
-- AS $$
-- DECLARE
--     rec RECORD;
-- BEGIN
--     RAISE NOTICE 'Mengambil player activity...';
--     FOR rec IN
--         SELECT  username, time_activity, login_type
-- 		FROM player_activity
-- 		order by username asc
--     LOOP
--         RAISE NOTICE 'Username: %, Time Activity: %, Login Type: %',
--             rec.username, rec.time_activity, rec.login_type;
--     END LOOP;
-- END;
-- $$;

-- migrate:down
drop procedure if exists login;
drop procedure if exists register;
drop procedure if exists logout;
drop procedure if exists findPlayerById;
