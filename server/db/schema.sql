SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: getadminbyid(integer); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.getadminbyid(IN p_player_id integer)
    LANGUAGE plpgsql
    AS $$
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


--
-- Name: getplayerbyid(integer); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.getplayerbyid(IN p_player_id integer)
    LANGUAGE plpgsql
    AS $$
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


--
-- Name: login(character varying, character varying, character varying); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.login(IN p_username character varying, IN p_password character varying, IN p_role character varying DEFAULT 'player'::character varying)
    LANGUAGE plpgsql
    AS $$
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


--
-- Name: logout(character varying); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.logout(IN p_username character varying)
    LANGUAGE plpgsql
    AS $$
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
$$;


--
-- Name: register(character varying, character varying, character varying, character varying); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.register(IN p_username character varying, IN p_email character varying, IN p_password character varying, IN p_role character varying DEFAULT 'player'::character varying)
    LANGUAGE plpgsql
    AS $$
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


--
-- Name: update_last_activity(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_last_activity() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
	update player
	set time_activity = current_timestamp
	where player_id = new.player_id;

	return new;
end;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: login_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.login_history (
    login_history_id integer NOT NULL,
    player_id integer NOT NULL,
    login_type character varying(50) NOT NULL,
    last_login timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: login_history_login_history_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.login_history_login_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: login_history_login_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.login_history_login_history_id_seq OWNED BY public.login_history.login_history_id;


--
-- Name: player; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.player (
    player_id integer NOT NULL,
    username character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    role character varying(50) DEFAULT 'player'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    time_activity timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT player_role_check CHECK (((role)::text = ANY ((ARRAY['admin'::character varying, 'player'::character varying])::text[])))
);


--
-- Name: player_activity; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.player_activity AS
 SELECT p.username,
    p.time_activity,
    lh.login_type
   FROM (public.player p
     LEFT JOIN public.login_history lh ON ((p.player_id = lh.player_id)));


--
-- Name: player_player_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.player_player_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: player_player_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.player_player_id_seq OWNED BY public.player.player_id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying(128) NOT NULL
);


--
-- Name: login_history login_history_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.login_history ALTER COLUMN login_history_id SET DEFAULT nextval('public.login_history_login_history_id_seq'::regclass);


--
-- Name: player player_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.player ALTER COLUMN player_id SET DEFAULT nextval('public.player_player_id_seq'::regclass);


--
-- Name: login_history login_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.login_history
    ADD CONSTRAINT login_history_pkey PRIMARY KEY (login_history_id);


--
-- Name: player player_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.player
    ADD CONSTRAINT player_email_key UNIQUE (email);


--
-- Name: player player_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.player
    ADD CONSTRAINT player_pkey PRIMARY KEY (player_id);


--
-- Name: player player_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.player
    ADD CONSTRAINT player_username_key UNIQUE (username);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: login_history trg_update_last_activity; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_update_last_activity AFTER INSERT ON public.login_history FOR EACH ROW EXECUTE FUNCTION public.update_last_activity();


--
-- Name: login_history login_history_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.login_history
    ADD CONSTRAINT login_history_player_id_fkey FOREIGN KEY (player_id) REFERENCES public.player(player_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--


--
-- Dbmate schema migrations
--

INSERT INTO public.schema_migrations (version) VALUES
    ('20241118130530'),
    ('20241118150848'),
    ('20241118163704'),
    ('20241118163847'),
    ('20241118163857'),
    ('20241120003832');
