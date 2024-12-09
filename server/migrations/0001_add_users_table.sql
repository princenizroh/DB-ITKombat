create database itkombat;

create user client_user with password 'user123';


set role client_user;

set role prince;

grant usage on schema public to client_user;
grant execute on all functions in schema public to client_user;
grant execute on all procedures in schema public to client_user;

grant all privileges on all tables in schema public to client_user;
grant usage, select on all sequences in schema public to client_user;

revoke all on all tables in schema public from client_user;
revoke all on all sequences in schema public from client_user;

select * from activity_history ah ;
DO $$
DECLARE
    table_name text;
    sequence_name text;
BEGIN
    FOR table_name IN
        SELECT 'player'
		union all 
		select 'activity_history'
    LOOP
        -- Grant akses pada tabel
        EXECUTE format('GRANT SELECT, INSERT ON %I TO client_user;', table_name);

		IF table_name = 'player' THEN
            sequence_name := 'player_player_id_seq';
        ELSIF table_name = 'activity_history' THEN
            sequence_name := 'activity_history_activity_history_id_seq';
        ELSE
            RAISE NOTICE 'No sequence configured for table %', table_name;
            CONTINUE; -- Lewati tabel tanpa sequence
        END IF;

        -- Grant akses pada sequence
        EXECUTE format('GRANT USAGE, SELECT ON SEQUENCE %s TO client_user;', sequence_name);
    END LOOP;
END
$$;


SELECT relname AS sequence_name
FROM pg_class
WHERE relkind = 'S' AND relnamespace = 'public'::regnamespace;



select grantee, privilege_type, specific_name
from information_schema.role_routine_grants
where routine_schema = 'public';

GRANT SELECT
ON ALL TABLES
IN SCHEMA "public"
TO client_user;

grant select 
on player 
to client_user;





-----================================================================================= CREATE TABLE =================================================================================-----
create table player (
    player_id serial primary key not null,
    username varchar(255) not null UNIQUE,
    email varchar(255) not null UNIQUE,
    password varchar(255) not null,
    role varchar(50) default 'player' not null check (role in ('admin', 'player')),
    created_at timestamp default now(),
    updated_at timestamp default now(),
    activity_at timestamp default now()
);

create table activity_history (
    activity_history_id serial primary key,
    player_id int not null references player(player_id) on delete cascade,
    type_activity varchar(50) not null check (type_activity in ('signin', 'signup', 'signout')),
    last_activity timestamp default current_timestamp
);


create table balances (
    balance_id serial primary key,
    danus int default 0 check (danus >= 0),
    ukt int default 0 check (ukt >= 0),
    player_id int references player(player_id)
);

create table transaction_logs (
    log_id serial primary key,
    player_id int references player(player_id)  on delete cascade,
    transaction_date timestamp not null default now(),
    transaction_type varchar(50) not null check (transaction_type in ('Topup UKT', 'Purchase Danus', 'Store Purchase')),
    amount_before int not null,
    amount_after int not null
);


create table purchase_logs (
    log_id int primary key references transaction_logs(log_id),
    package_id int references ukt_packages(package_id),
    method_id int references payment_methods(method_id),
    payment_amount int not null
);


create table ukt_packages (
	package_id serial primary key,
	ukt_amount int not null check (ukt_amount in (20, 60, 300, 900, 1980)),
	price int not null check (price in (6000, 16000, 79000, 249000, 479000)),
	currency varchar(10) default 'IDR'
);

create table danus_packages (
    package_id serial primary key,
    danus_amount int not null check (danus_amount in (500, 1000, 2500, 10000, 60000, 100000)),         
    required_ukt int not null check (required_ukt in (5, 10, 25, 100, 600, 1000))         
);


create table payment_methods (
	method_id serial primary key,
	method_name varchar(50) not null
)


create table tiers(
	tier_id serial primary key,
	tier_name varchar(50) not null
)

create table item_type(
	type_id serial primary key,
	type_name varchar(255) not null
);

create table items (
    item_id serial primary key,
    item_name varchar(255),
    item_type int references item_type(type_id),
	item_tier int references tiers(tier_id),
    item_base_value int default 0
);


create table items_inventory (
    item_inventory_id serial primary key,
    player_id int references player(player_id),
    item_id int references items(item_id),
    item_value int default 0
);

create table character_class(
	class_id serial primary key,
	class_name varchar(255) not null
)

create table characters (
    character_id serial primary key,
    character_name varchar(255),
    character_class int references character_class(class_id)  on delete cascade,
    character_tier int references tiers(tier_id)  on delete cascade,
    base_attack int default 0,
    base_defense int default 0,
    base_intelligence int default 0
);

create table characters_inventory (
    character_inventory_id serial primary key,
    player_id int references player(player_id)  on delete cascade,
    character_id int references characters(character_id)  on delete cascade,
    attack_value int default 0,
    defense_value int default 0,
    intelligence_value int default 0
);

create table gears (
    gear_id serial primary key,
    gear_name varchar(255),
    gear_type varchar(50) not null check (gear_type in ('Weapon', 'Armor', 'Accessories')),
    gear_tier int references tiers(tier_id),
	base_attack int default 0,
    base_defense int default 0,
    base_intelligence int default 0
);

create table gears_inventory (
    gear_inventory_id serial primary key,
    player_id int references player(player_id),
    gear_id int references gears(gear_id),
    attack_value int default 0,
    defense_value int default 0,
    intelligence_value int default 0
);

create table player_inventory (
    inventory_id serial primary key,        
    player_id int references player(player_id),                
    item_type varchar(50) not null,         
    item_id int,                            
    acquired_date timestamp default now()
);


create table npc (
    npc_id serial primary key,
    npc_name varchar(255),
    npc_type varchar(50) not null check (npc_type in ('Gear seller', 'Item seller', 'Character seller'))
);

create table npc_sales(
	sale_id serial primary key, 
    npc_id int references npc(npc_id)  on delete cascade, 
    item_id int default null references items(item_id)  on delete cascade, 
    gear_id int default null references gears(gear_id)  on delete cascade,
    character_id int default null references characters(character_id)  on delete cascade
);



create table store (
    store_id serial primary key,
    sale_id int references npc_sales(sale_id)  on delete cascade,
    value_price int not null,
    currency varchar(50) not null check (currency in ('ukt', 'danus'))
);

create table store_history (
	store_history serial primary key,
	player_id int references player(player_id),
	store_id int references store(store_id),
	purchase_date timestamp default now(),
	item_type varchar(50) not null check (item_type in ('Gear', 'Item', 'Character'))
)

create table profile (
    profile_id serial primary key,
    player_exp int default 0,
    player_level int default 1,
    player_rank int default 1,
    sk2pm int default 0,
    player_id int references player(player_id)
);

create table match_logs (
    match_log_id serial primary key,
    player_id int references player(player_id),
    opponent_id int references player(player_id),
    is_ranked boolean not null,
    rounds_won int not null,
    total_rounds int not null,
    total_hits_taken int not null,
    player_hp int not null,
    created_at timestamp default current_timestamp
);

create table match_history (
    match_id serial primary key,
    player_id int references player(player_id),
    match_log_id int references match_logs(match_log_id),
    new_sk2pm int,
    danus_reward int,
    performance_points int,
    match_date timestamp default current_timestamp
);

create table level_exp (
    level serial primary key,
    exp_needed int default null
);



-----================================================================================= DROP TABLE =================================================================================-----
drop table if exists player cascade;
drop table if exists activity_history cascade;
drop table if exists balances cascade;
drop table if exists payment_method cascade;
drop table if exists transaction_logs cascade;
drop table if exists purchase_logs cascade;
drop table if exists ukt_packages cascade;
drop table if exists danus_packages cascade;
drop table if exists stats cascade;
drop table if exists item_type cascade;
drop table if exists items cascade;
drop table if exists character_class cascade;
drop table if exists characters cascade;
drop table if exists gears cascade;
drop table if exists store_history cascade;
drop table if exists store cascade;
drop table if exists npc_sales cascade;
drop table if exists npc cascade;
drop table if exists player_inventory cascade;
drop table if exists gears_inventory cascade;
drop table if exists items_inventory cascade;
drop table if exists characters_inventory cascade;
drop table if exists profile cascade;
drop table if exists match_history cascade;
drop table if exists match_logs cascade;
drop table if exists leaderboards cascade;
drop table if exists rewards cascade;
--drop table if exists announcement cascade;


-----================================================================================= INSERT VALUES =================================================================================-----
insert into player (username, email, password)
values 
('izaki', 'izaki@gmail.com', 'admin123')
--('zaky', 'zaky@gmail.com', 'admin123'),
--('dio', 'dio@gmail.com', 'admin123'),
--('akbar', 'akbar@gmail.com', 'admin123'),
--('pangestu', 'pangestu@gmail.com', 'admin123')

insert into player (username, password, email, role)
values 
('admin_user', 'admin@gmail.com', 'admin123', 'admin')


insert into profile (profile_id, player_exp, player_level, player_rank, sk2pm, player_id)
values
(1, 1500, 2, 1, 1200, 1),
(2, 1000, 1, 2, 1300, 2),
(3, 800, 1, 3, 1200, 3),
(4, 700, 1, 4, 1300, 4)

insert into balances (balance_id, danus, ukt, player_id)
values
(1, 5000, 1000, 1),
(2, 3000, 1200, 2),
(3, 4000, 1500, 3),
(4, 2000, 2500, 4)


insert into transaction_history (transaction_date, transaction_before, transaction_after, transaction_id)
values
('2024-01-02 14:30:00', 5000, 500, 1),
('2024-01-02 14:30:00', 1200, 200, 2),
('2024-01-02 22:30:00', 4000, 400, 3),
('2024-01-02 22:30:00', 2500, 200, 4)

insert into ukt_packages (ukt_amount, price, currency)
values
	(20, 6000, 'IDR'),
    (60, 16000, 'IDR'),
    (300, 79000, 'IDR'),
    (900, 249000, 'IDR'),
    (1980, 479000, 'IDR');
   
insert into danus_packages (danus_amount, required_ukt)
values
	(500, 5),
	(1000, 10),
    (2500, 25),
    (10000, 100),
    (60000, 600),
    (100000, 1000);
   
insert into payment_methods (method_name)
values
    ('Gopay'), ('Dana'), ('OVO'), ('Transfer Bank'), ('Pulsa');
   
insert into leaderboards (leaderboard_id, profile_id)
values
(1, 1),
(2, 2),
(3, 3),
(4, 4)


insert into tiers (tier_name) values
('Prodi'), ('Ukm'), ('Dosen'),
('Normal'), ('Rare'), ('Special'),
('Legend');

insert into item_type (type_name)
values
('Rempah'),
('Batu Akik'),
('Chest'),
('Ticket');

insert into items (item_name, item_type, item_tier, item_base_value)
values
('Rempah Manis', 1, 4, 100),
('Rempah Pahit', 1, 5, 1000),
('Rempah Asin', 1, 6, 4500),
('Rempah Sepet', 1, 7, 7000),
('Bacan', 2, 4, 1),
('Sulaiman', 2, 5, 1),
('Safir', 2, 6, 1),
('Zamrud', 2, 7, 1),
('Paket Harian', 3, 1, 1),
('Paket Item Acak', 3, 2, 1),
('Paket Gear Acak', 3, 3, 1),
('Paket Character Acak', 3, 4, 1),
('Tiket Gacha Kecil', 4, 1, 1),
('Tiket Gacha Sedang', 4, 2, 1),
('Tiket Gacha Besar', 4, 3, 1),
('Tiket Gacha Luar Biasa', 4, 3, 1);

insert into items_inventory (item_inventory_id, player_id, item_id)
values
(1, 1, 1),
(2, 2, 2),
(3, 3, 2),
(4, 4, 1);

insert into character_class (class_name)
values
('Manipulation'),
('Fighter'),
('Mind Control'),
('Support');


insert into characters (character_name, character_class, character_tier, base_attack, base_defense, base_intelligence)
values
('Informathics', 1, 1,39, 19, 40),
('Machine', 2, 1, 43, 22, 20),
('Marine', 2, 1, 42, 20, 26),
('Physics', 3, 1, 38, 18, 4),
('Chemical', 4, 1, 34, 18, 50),
('Taekwondo', 2, 2, 46, 23, 20),
('Fajri', 2, 3, 50, 18, 56),
('Bowo', 2, 3, 52, 20, 56)

insert into characters_inventory (character_inventory_id, player_id, character_id)
values
(1, 1, 1),
(2, 2, 2),
(3, 3, 2),
(4, 4, 1);

insert into gears (gear_name, gear_type, gear_tier, base_attack, base_defense, base_intelligence)
values
('Ochabot', 'Weapon', 4, 10, 5, 0),
('Indokey', 'Weapon', 4, 14, 0, 0),
('Twodent', 'Weapon', 4, 14, 0, 0),
('Twosula', 'Weapon', 4, 10, 0, 0),
('C4h10', 'Weapon', 4, 8, 0, 0),
('Dragonkick', 'Weapon', 5, 14, 5, 0),
('Elderstaf', 'Weapon', 6, 16, 0, 0),
('Bogem', 'Weapon', 6, 16, 5, 0),
('Bariershield', 'Armor', 4, 0, 15, 0),
('Gladiator', 'Armor', 4, 10, 20, 0),
('Leaqua', 'Armor', 4, 0, 15, 0),
('Bamus', 'Armor', 4, 0, 13, 0),
('Jaslab', 'Armor', 4, 0, 13, 0),
('Spincrest', 'Armor', 5, 12, 16, 0),
('Ascetic', 'Armor', 6, 0, 22, 0),
('Lecture', 'Armor', 6, 0, 22, 0),
('Glovy', 'Accessories', 4, 0, 0, 20),
('Wargir', 'Accessories', 4, 0, 0, 5),
('Aqualock', 'Accessories', 4, 0, 0, 15),
('Ensten', 'Accessories', 4, 0, 0,150),
('Buffy', 'Accessories', 4, 0, 0, 22),
('Belt', 'Accessories', 5, 0, 0, 17),
('Wiper', 'Accessories', 6, 0, 0, 15),
('Udud', 'Accessories', 6, 0, 0, 25);


insert into gears_inventory (gear_inventory_id, player_id, gear_id, gear_stats_1, gear_stats_2, gear_stats_value_1, gear_stats_value_2)
values
(1, 1, 1, 1, 2, 10, 5),
(2, 2, 2, 2, 1, 15, 8),
(3, 3, 2, 2, 1, 15, 8),
(4, 4, 1, 1, 2, 10, 5);

insert into store_transactions (transaction_id, transaction_item_id, transaction_date)
values
(1, 1, '2024-01-02 14:50:00'),
(2, 2, '2024-01-02 14:50:00'),
(3, 2, '2024-01-02 22:50:00'),
(4, 1, '2024-01-02 22:50:00')

insert into store (sale_id, value_price, currency)
values
(1, 7000, 'danus'), (2, 7000, 'danus'), (3, 7000, 'danus'), (4, 7000, 'danus'), -- Weapons
(5, 7000, 'danus'), (6, 7000, 'danus'), (7, 7000, 'danus'), (8, 7000, 'danus'),
(9, 4000, 'danus'), (10, 7000, 'danus'), (11, 4000, 'danus'), (12, 4000, 'danus'), -- Armors
(13, 4000, 'danus'), (14, 4000, 'danus'), (15, 4000, 'danus'), (16, 4000, 'danus'),
(17, 3000, 'danus'), (18, 3000, 'danus'), (19, 3000, 'danus'), (20, 3000, 'danus'), -- Accessories
(21, 3000, 'danus'), (22, 3000, 'danus'), (23, 3000, 'danus'), (24, 3000, 'danus'),
(25, 10, 'danus'), (26, 50, 'danus'), (27, 450, 'danus'), (28, 700, 'danus'), -- Rempah
(29, 1000, 'danus'), (30, 2000, 'danus'), (31, 5000, 'danus'), (32, 10000, 'danus'), -- Batu Akik
(33, 500, 'danus'), (34, 2000, 'danus'), (35, 2000, 'danus'), (36, 10000, 'danus'), -- Paket Box
(37, 1000, 'danus'), (38, 14, 'ukt'), (39, 20, 'ukt'), (40, 28, 'ukt'), -- Tiket Gacha
(41, 180, 'ukt'), (42, 180, 'ukt'), (43, 180, 'ukt'), (44, 180, 'ukt'),  -- Characters
(45, 180, 'ukt'), (46, 340, 'ukt'), (47, 900, 'ukt'), (48, 900, 'ukt');

insert into npc_sales (npc_id, gear_id)
values
(1, 1),(1, 2), (1, 3), (1, 4), -- Weapons
(1, 5), (1, 6), (1, 7), (1, 8),
(1, 9), (1, 10), (1, 11), (1, 12),-- Armors
(1, 13), (1, 14), (1, 15), (1, 16),
(1, 17), (1, 18), (1, 19), (1, 20),
(1, 21), (1, 22), (1, 23), (1, 24); -- Accessories 

insert into npc_sales (npc_id, item_id)
values
(2, 1), (2, 2), (2, 3), (2, 4), -- Rempah
(2, 5), (2, 6), (2, 7), (2, 8), -- Batu Akik
(2, 9), (2, 10), (2, 11), (2, 12), -- Paket Box
(2, 13), (2, 14), (2, 15), (2, 16); -- Tiket Gacha

insert into npc_sales (npc_id, character_id)
values
(3, 1), (3, 2), (3, 3), (3, 4),
(3, 5), (3, 6), (3, 7), (3, 8);

insert into npc (npc_name, npc_type)
values
('Jokowi', 'Gear seller'),
('Gibran', 'Item seller'),
('Prabowo', 'Character seller');

insert into game_mode (battle_mode_id, battle_name_mode)
values
(1, 'rangked'),
(2, 'Unrangked');

insert into matches (match_id, match_date, max_skor_match, duration_match, battle_mode_id)
values
(1, '2024-10-01 15:00:00', 3, 10, 1),
(2, '2024-10-02 15:10:00', 5, 15, 2),
(3, '2024-10-02 15:25:00', 4, 13, 2),
(4, '2024-10-02 15:38:00', 3, 10, 1),
(5, '2024-10-01 22:00:00', 5, 15, 2),
(6, '2024-10-02 22:15:00', 4, 13, 1),
(7, '2024-10-02 22:28:00', 5, 15, 2),
(8, '2024-10-02 22:43:00', 3, 10, 1),
(18, '2024-10-02 22:43:00', 3, 10, 1),
(20, '2024-10-02 22:43:00', 3, 10, 1),
(21, '2024-10-02 22:43:00', 3, 10, 1);

insert into player_match (player_match_id, player_match_score, player_id, match_id)
values
(1, 3, 1, 1),
(2, 0, 2, 1),
(3, 2, 1, 2),
(4, 3, 2, 2),
(5, 1, 1, 3),
(6, 3, 2, 3),
(7, 0, 1, 4),
(8, 3, 2, 4),
(9, 3, 3, 5),
(10, 2, 4, 5),
(11, 1, 3, 6),
(12, 3, 4, 6),
(13, 2, 3, 7),
(14, 3, 4, 7),
(15, 3, 3, 8),
(16, 0, 4, 8);


insert into rewards (reward_id, reward_danus, reward_exp, reward_sk2pm, player_match_id)
values
(1, 250, 250, 25, 1),
(2, 50, 50, 5, 2),
(3, 200, 200, 0, 3),
(4, 250, 250, 0, 4),
(5, 150, 150, 0, 5),
(6, 250, 250, 0, 6),
(7, 50, 50, 5, 7),
(8, 250, 250, 25, 8),
(9, 250, 250, 0, 9),
(10, 200, 200, 0, 10),
(11, 150, 150, 15, 11),
(12, 250, 250, 25, 12),
(13, 200, 200, 0, 13),
(14, 250, 250, 0, 14),
(15, 250, 250, 25, 15),
(16, 50, 50, 5, 16);

-- Insert kebutuhan EXP untuk setiap level
insert into level_exp (exp_needed)
values
(0),                   
(100),                 
(150),                 
(220),                 
(300),                 
(380),                
(470),
(570),
(680),
(800),                 
(930),                 
(1070),                 
(1220),                
(1380),
(1550),
(1730),
(1920),
(2120),
(2330),
(2550),
(2780),
(3020),
(3270),
(3530),
(3800),
(4080),
(4370),
(4670),
(4980),
(5300),
(5630),
(5970),
(6320),
(6680),
(7050),
(7430),
(7820),
(8220),
(8630),
(9050),
(9480),
(9920),
(10370),
(10830),
(11300),
(11780),
(12270),
(12770),
(13280),
(13800),
(14330),
(14870),
(15420),
(15980),
(16550),
(17130),
(17720),
(18320),
(18930),
(19550),
(20180),
(20820),
(21470),
(22130),
(22800),
(23480),
(24170),
(24870),
(25580),
(26300),
(27030),
(27770),
(28520),
(29280),
(30050),
(30830),
(31620),
(32420),
(33230),
(34050),
(34880),
(35720),
(36570),
(37430),
(38300),
(39180),
(40070),
(40970),
(41880),
(42800),
(43730),
(44670),
(45620),
(46580),
(47550),
(48530),
(49520),
(50520),
(51530),
(52550),
(53580);
-----================================================================================= DELETE VALUES =================================================================================-----
TRUNCATE TABLE player cascade;
TRUNCATE TABLE transaction_history cascade;
TRUNCATE TABLE rewards cascade;
TRUNCATE TABLE player_match cascade;
TRUNCATE TABLE matches cascade;
TRUNCATE TABLE battle_mode cascade;
TRUNCATE TABLE npc cascade;
TRUNCATE TABLE npc_type cascade;
TRUNCATE TABLE store cascade;
TRUNCATE TABLE store_transactions cascade;
TRUNCATE TABLE gears_inventory cascade;
TRUNCATE TABLE gears cascade;
TRUNCATE TABLE gear_type cascade;
TRUNCATE TABLE stats cascade;
TRUNCATE TABLE characters_inventory cascade;
TRUNCATE TABLE characters cascade;
TRUNCATE TABLE program_studi cascade;
TRUNCATE TABLE items_inventory cascade;
TRUNCATE TABLE items cascade;
TRUNCATE TABLE leaderboards cascade;
TRUNCATE TABLE transactions cascade;
TRUNCATE TABLE balances cascade;
TRUNCATE TABLE profile cascade;

drop view player_activity;
-----================================================================================= VIEW =================================================================================-----

create or replace view player_total_rewards as
select 
    p.player_id, 
    p.username, 
    sum(r.reward_danus) as total_danus, 
    sum(r.reward_exp) as total_exp, 
    sum(r.reward_sk2pm) as total_sk2pm
from player p
join player_match pm on p.player_id = pm.player_id
join rewards r on pm.player_match_id = r.player_match_id
group by p.player_id, p.username
order by p.player_id asc;

select * from player_total_rewards;


create or replace view player_stats_overview as
select 
    p.player_id, 
    p.username, 
    pr.player_exp, 
    pr.player_level, 
    pr.player_rank, 
    l.profile_id as leaderboard_profile, 
    count(pm.match_id) as total_matches,
    sum(pm.player_match_score) as total_score
from player p
join profile pr on p.player_id = pr.player_id
left join leaderboards l on pr.profile_id = l.profile_id
left join player_match pm on p.player_id = pm.player_id
group by p.player_id, p.username, pr.player_exp, pr.player_level, pr.player_rank, l.profile_id;

select * from player_stats_overview;

-- gunakan ini dulu yang sudah diterapkan di usecase


----
create or replace view mypage_info as
select 
	p.player_id,
	p.username,
	p.email,
	p.password
from player p;
	
select * from mypage_info;
---
create or replace view player_activity as
select
    p.player_id,
    p.username,
    ah.type_activity,
    max(ah.last_activity) as time_activity
from 
    player p
left join 
    activity_history ah on p.player_id = ah.player_id
group by 
    p.player_id, p.username, ah.type_activity
order by 
    p.player_id asc, time_activity desc;

select * from player_activity;
---

create or replace view player_balance as 
select 
	p.player_id,
	p.username,
	b.danus, 
	b.ukt
from
	player p
left join 
	balances b on p.player_id = b.player_id
order by p.player_id asc;

select * from player_balance;
---

create or replace view show_ukt_packages as
select 
    package_id, 
    ukt_amount, 
    price, 
    concat('Rp.', price, ' / ', ukt_amount, ' UKT') as description
from 
	ukt_packages;

select * from show_ukt_packages;
---

select * from player;


create or replace view show_danus_packages as
select 
    package_id, 
    danus_amount, 
    required_ukt, 
    concat(required_ukt, ' UKT / ', danus_amount, ' Danus') as description
from
	danus_packages;

select * from show_danus_packages;

---

-- view untuk log pembelian
create or replace view purchase_details as
select 
    pl.log_id,
    tl.player_id,
    pm.method_name as payment_method, 
    uktp.ukt_amount as ukt_purchased, 
    pl.payment_amount as amount_paid,
    tl.transaction_date as purchase_date
from 
	purchase_logs pl
join 
	payment_methods pm on pl.method_id = pm.method_id
left join 
	ukt_packages uktp on pl.package_id = uktp.package_id
join 
	transaction_logs tl on pl.log_id = tl.log_id;

select * from purchase_details;


create or replace view transaction_details as
select
    tl.log_id,
    tl.player_id,
    tl.transaction_date,
    tl.transaction_type,
    tl.amount_before,
    tl.amount_after,
    case
        when tl.transaction_type in ('Topup UKT', 'Purchase Danus') then 'UKT'
        when tl.transaction_type = 'Store Purchase' 
        	and sl.payment_amount is not null then 'UKT'
        when tl.transaction_type = 'Store Purchase' 
        	and sl.payment_amount is null then 'Danus'
        else 'Unknown'
    end as currency_type
from
    transaction_logs tl
left join
    purchase_logs sl on tl.log_id = sl.log_id
order by tl.log_id asc;
   
select * from transaction_details;


create or replace view show_seller as
select 
	npc_id as seller_id,
	npc_name as seller_name,
	npc_type as seler_type
from npc;

select * from show_seller;

create or replace view show_store as
select
    s.store_id,
    n.npc_name as seller_name,
    n.npc_type as seller_type,
    coalesce(g.gear_name, i.item_name, c.character_name) as sales,
    case
        when g.gear_name is not null then g.gear_type
        when i.item_name is not null then it.type_name
        when c.character_name is not null then cc.class_name
    end as sales_class,
    s.value_price as price,
    s.currency as currency
from 
    store s
left join 
	npc_sales ns on s.sale_id = ns.sale_id
left join 
	npc n on ns.npc_id = n.npc_id
left join 
	gears g on ns.gear_id = g.gear_id
left join 
	items i on ns.item_id = i.item_id
left join 
	item_type it on i.item_type = it.type_id
left join 
	characters c on ns.character_id = c.character_id
left join 
	character_class cc on c.character_class = cc.class_id

select * from show_store;

---- 

create or replace view show_payment_methods as
select
	pm.method_id,
	pm.method_name
from 
	payment_methods pm 
	
select * from show_payment_methods;
---

create or replace view store_details as
select 
    s.store_id,
	n.npc_type as seller_type,
    coalesce(i.item_name, g.gear_name, c.character_name) as entity_name,
    t.tier_name as entity_tier,
    case 
        when i.item_id is not null then it.type_name 
        when g.gear_id is not null then g.gear_type 
        when c.character_id is not null then cc.class_name 
    end as entity_type,
    coalesce(g.base_attack, c.base_attack, 0) as base_attack,
    coalesce(g.base_defense, c.base_defense, 0) as base_defense,
    coalesce(g.base_intelligence, c.base_intelligence, 0) as base_intelligence,
    coalesce(
    	i.item_base_value, 
    	c.base_attack + c.base_defense + c.base_intelligence, 
    	g.base_attack + g.base_defense + g.base_intelligence
    ) as item_value
from 
    store s
left join 
    npc_sales ns on s.sale_id = ns.sale_id
left join 
	npc n on ns.npc_id = n.npc_id
left join 
    items i on ns.item_id = i.item_id
left join 
    item_type it on i.item_type = it.type_id 
left join 
    gears g on ns.gear_id = g.gear_id
left join 
    characters c on ns.character_id = c.character_id
left join 
    character_class cc on c.character_class = cc.class_id
left join
    tiers t 
on 
	t.tier_id = coalesce (
   		i.item_tier, g. gear_tier, c.character_tier
    );

select * from store_details;

create or replace view show_player_inventory as
select
    pi.inventory_id,
    pi.player_id,
    pi.item_type,
    case 
        when pi.item_type = 'Item' then i.item_name
        when pi.item_type = 'Gear' then g.gear_name
        when pi.item_type = 'Character' then c.character_name
        else 'unknown'
    end as item_name,
    pi.acquired_date
from
    player_inventory pi
left join
    items i on pi.item_type = 'Item' and pi.item_id = i.item_id
left join
    gears g on pi.item_type = 'Gear' and pi.item_id = g.gear_id
left join
    characters c on pi.item_type = 'Character' and pi.item_id = c.character_id;

select * from show_player_inventory;

drop view inventory_details

create or replace view inventory_details as
select 
    pi.inventory_id,
    pi.player_id,
    pi.item_type,
    case 
        when pi.item_type = 'Character' then c.character_name
        when pi.item_type = 'Gear' then g.gear_name
        when pi.item_type = 'Item' then i.item_name
    end as entity_name,
	t.tier_name as entity_tier,
    case 
        when pi.item_type = 'Character' then cc.class_name
        when pi.item_type = 'Gear' then g.gear_type
        when pi.item_type = 'Item' then it.type_name
    end as entity_type,
    coalesce(c.base_attack, g.base_attack, 0) as base_attack,
    coalesce(c.base_defense, g.base_defense, 0) as base_defense,
    coalesce(c.base_intelligence, g.base_intelligence, 0) as base_intelligence,
    coalesce(
    	i.item_base_value, 
    	c.base_attack + c.base_defense + c.base_intelligence, 
    	g.base_attack + g.base_defense + g.base_intelligence
    ) as item_value
from 
    player_inventory pi
left join 
	characters c on pi.item_id = c.character_id and pi.item_type = 'Character'
left join 
	character_class cc on c.character_class = cc.class_id
left join 
	gears g on pi.item_id = g.gear_id and pi.item_type = 'Gear'
left join 
	items i on pi.item_id = i.item_id and pi.item_type = 'Item'
left join 
	item_type it on i.item_type = it.type_id
left join
    tiers t 
on 
	t.tier_id = coalesce (
   		i.item_tier, g. gear_tier, c.character_tier
    );

select * from inventory_details;
----- 
drop view player_profile;
create or replace view player_profile as
select 
    p.player_id,
    p.username,
    pr.player_exp,
    pr.player_level,
    pr.player_rank,
    pr.sk2pm,
    count(ml.match_log_id) as total_matches,
    sum(
    	case 
	    	when ml.rounds_won > (ml.total_rounds / 2) 
    	then 1 else 0 end
    ) as total_wins,
    sum(
    	case 
	    	when ml.rounds_won <= (ml.total_rounds / 2) 
    	then 1 else 0 end
    ) as total_lose,
    (sum(
        case 
            when ml.rounds_won > (ml.total_rounds / 2) 
        then 1 else 0 end
    )::float / count(ml.match_log_id)) * 100 as win_rate
from 
    player p
left join 
    profile pr on p.player_id = pr.player_id
left join 
    match_logs ml on p.player_id = ml.player_id
group by 
    p.player_id, pr.player_exp, pr.player_level, pr.sk2pm, pr.player_rank
order by 
	p.player_id asc;
   
select * from player_profile;

drop view match_history_player;
create or replace view match_history_player as
select 
    mh.match_id,
    p1.username as player_name,
    p2.username as opponent_name,
    case 
        when ml.is_ranked then 'ranked'
        else 'unranked'
    end as match_mode,
    mh.new_sk2pm as sk2pm,
    mh.match_date
from 
    match_history mh 
left join 
	match_logs ml on mh.match_id = ml.match_log_id
left join 
    player p1 on ml.player_id = p1.player_id
left join 
    player p2 on ml.opponent_id = p2.player_id
order by 
	mh.match_id asc;

select * from match_history_player;

drop view match_details;
create or replace view match_details as
select 
    mh.match_id,
    p1.username as player_name,
    p2.username as opponent_name,
        case 
        when ml.is_ranked then 'ranked'
        else 'unranked'
    end as match_mode,
    mh.performance_points,
    (case 
        when mh.performance_points >= 246 then 'Perfect'
        when mh.performance_points >= 200 then 'Excellent'
        when mh.performance_points >= 143 then 'Good'
        else 'Nice Try'
    end) as performance_rating,
    mh.new_sk2pm as sk2pm,
    mh.danus_reward,
    ml.rounds_won,
    ml.total_rounds,
    ml.total_hits_taken,
    mh.match_date
from 
    match_history mh
left join 
	match_logs ml on mh.match_id = ml.match_log_id
left join 
    player p1 on ml.player_id = p1.player_id
left join 
    player p2 on ml.opponent_id = p2.player_id

select * from match_details;

create or replace view leaderboards_rank as
select 
    row_number() over (order by pr.sk2pm desc) as rank,
    p.username,
    pr.sk2pm,
    pr.player_level
from 
    profile pr
join 
    player p on pr.player_id = p.player_id;
   

select * from leaderboards_rank;
-----================================================================================= DROP QUERRY=================================================================================-----

drop view if exists player_total_rewards;
drop view if exists player_match_scores;
drop view if exists player_inventory;
drop view if exists player_transactions;
drop view if exists player_stats_overview;
drop view if exists transaction_summary;
drop view if exists player_activity;

drop procedure if exists signin;
drop procedure if exists signup;
drop procedure if exists signout;
drop procedure if exists validate_password;
drop procedure if exists getPlayerById;
drop procedure if exists add_transaction_and_update_balance;
drop procedure if exists purchase_item;
drop procedure if exists update_player_rank;
drop procedure if exists add_item_to_inventory;
drop procedure if exists complete_match;
drop procedure if exists show_player_activity;

drop function if exists purchase_item;
drop function if exists complete_match cascade;
drop function if exists get_activity_player cascade;
drop function if exists get_player_activity;

drop trigger if exists update_balance_after_transaction on transactions;


-----======================= FUNCTION SHOW =======================-----

-----================================================================================= Show Player  =================================================================================-----

create or replace function get_player_activity()
returns table (
	player_id int,
    username varchar,
    type_activity varchar,
    time_activity timestamp
) as $$
begin
	return query
	select * from player_activity;
end;
$$ language plpgsql
security definer;

select * from get_player_activity()

create or replace function get_mypage_info()
returns table (
	player_id int,
	username varchar,
	email varchar,
	password varchar
) as $$
begin 
	return query
	select * from mypage_info;
end;
$$ language plpgsql
security definer;

select username, email, password from get_mypage_info() where player_id = 1;

-----================================================================================= Show Store  =================================================================================-----

create or replace function get_store()
returns table (
	store_id int,
	seller_name varchar,
	seller_type varchar,
	sales varchar,
	sales_class varchar,
	price int,
	currency varchar
) as $$
begin
	return query 
	select * from show_store;
end;
$$ language plpgsql
security definer;

select * from get_store();

select store_id, sales, sales_class from get_store() where store_id = 1;

create or replace function get_seller()
returns table (
	seller_id int,
	seller_name varchar,
	seller_type varchar
) as $$
begin
	return query
	select * from show_seller;
end;
$$ language plpgsql
security definer;

select * from get_seller()

drop function get_store_details;
create or replace function get_store_details()
returns table (
	store_id int,
	seller_type varchar,
	entity_name varchar,
	entity_tier varchar,
	entity_type varchar,
	base_attack int,
	base_defense int,
	base_intelligence int,
	item_value int
) as $$
begin
	return query
	select * from store_details;
end;
$$ language plpgsql
security definer;

select * from get_store_details();

select store_id, entity_name, entity_type, base_attack, base_defense, base_intelligence from get_store_details() where store_id = 1;


-----================================================================================= Show Balance  =================================================================================-----
create or replace function get_player_balance()
returns table (
	player_id int,
	username varchar,
	danus int,
	ukt int
) as $$
begin
	return query
	select * from player_balance;
end;
$$ language plpgsql
security definer;

select * from get_player_balance();
select danus, ukt from get_player_balance() where player_id = 1;

create or replace function get_payment_methods()
returns table (
	method_id int,
	method_name varchar
) as $$
begin
	return query
	select * from show_payment_methods;
end;
$$ language plpgsql
security definer;

-----================================================================================= Show Packages UKT & Danus  =================================================================================-----

create or replace function get_ukt_packages()
returns table(
	package_id int, 
	ukt_amount int, 
	price int, 
	description text
) as $$
begin
    return query 
	select * from show_ukt_packages;
end;
$$ language plpgsql
security definer;

select * from get_ukt_packages();

create or replace function get_danus_packages()
returns table(
	package_id int, 
	danus_amount int, 
	required_ukt int, 
	description text
) as $$
begin
    return query 
	select * from show_danus_packages;
end;
$$ language plpgsql
security definer;

select * from get_danus_packages();
-----================================================================================= Show purchase logs & transaction history  =================================================================================-----
drop function get_purchase_logs;

create or replace function get_purchase_logs()
returns table(
	log_id int, 
	player_id int, 
	payment_method character varying(50), 
	ukt_purchased int, 
	amount_paid int, 
	purchase_date timestamp
) as $$
begin
    return query 
	select * from purchase_details;
end;
$$ language plpgsql
security definer;

select * from get_purchase_logs();

select log_id, payment_method, ukt_purchased, amount_paid, purchase_date from get_purchase_logs() where player_id = 1;

drop function get_transaction_history;

create or replace function get_transaction_history()
returns table(
	log_id int, 
	player_id int, 
	transaction_date timestamp, 
	transaction_type varchar(50), 
	amount_before int,
	amount_after int, 
	currency_type text
) as $$
begin
    return query 
	select * from transaction_details;
end;
$$ language plpgsql
security definer;

select * from get_transaction_history();

-----================================================================================= Show Player Inventory  =================================================================================-----
create or replace function get_player_inventory()
returns table (
	inventory_id int,
	player_id int,
	item_type varchar(50),
	item_name varchar(50),
	acquired_date timestamp
) as $$
begin
	return query
	select * from show_player_inventory;
end;
$$ language plpgsql
security definer;

select * from get_player_inventory();
drop function get_inventory_details;

create or replace function get_inventory_details()
returns table (
	inventory_id int,
	player_id int,
	item_type varchar(50),
	entity_name varchar(50),
	entity_tier varchar(50),
	entity_type varchar(50),
	base_attack int,
	base_defense int,
	base_intelligence int,
	item_value int
) as $$
begin
	return query
	select * from inventory_details;
end;
$$ language plpgsql
security definer;

select * from get_inventory_details();

-----================================================================================= Debug function exists=================================================================================-----

select n.nspname, p.proname, pg_catalog.pg_get_functiondef(p.oid)
from pg_catalog.pg_proc p
left join pg_catalog.pg_namespace n on n.oid = p.pronamespace
where p.proname = 'calculate_rewards';
-----================================================================================= Debug procedure exists=================================================================================-----
select proname, oid, pronargs, proargtypes::regtype[] 
from pg_proc 
where proname = 'update_player_rank';



drop procedure signin(character varying,character varying, integer, character varying, character varying);
drop procedure logout(integer);
drop procedure logout(character varying);
drop procedure login(character varying, character varying);

-----================================================================================= Debug trigger exists=================================================================================-----
SELECT tgname FROM pg_trigger WHERE tgname = 'tr_insert_transaction_history';
-----================================================================================= Debug Testing =================================================================================-----

DO $$
DECLARE
    v_password VARCHAR := 'admin123'; -- Password yang ingin divalidasi
    v_is_valid BOOLEAN;               -- Variabel untuk menampung hasil validasi
BEGIN
    -- Panggil prosedur
    CALL validate_password(v_password, v_is_valid);

    -- Tampilkan hasil
    RAISE NOTICE 'Password Valid: %', v_is_valid;
END;
$$;

-----================================================================================= Debug Query =================================================================================-----

explain analyze select * from player where email = 'zaki@gmail.com';

explain analyze select * from player;

-----=======================TRIGGER=======================-----
-----================================================================================= last activity =================================================================================-----
create or replace function update_last_activity()
returns trigger 
as $$
begin
	update player 
	set activity_at = current_timestamp
	where player_id = new.player_id;

	return new;
end;
$$ language plpgsql
security definer;

create or replace trigger trg_update_last_activity
after insert on activity_history
for each row 
execute procedure update_last_activity();

-----================================================================================= Data Validation =================================================================================-----
create or replace function check_username()
returns trigger
as $$
begin
	if position (' ' in new.username) > 0 then
		raise exception 'username tidak boleh ada spasi';
	end if;

	return new;
end;
$$ language plpgsql
security definer;

create or replace trigger trg_check_username
before insert on player
for each row 
execute function check_username();

-----================================================================================= Initial Balance =================================================================================-----
create or replace function set_initial_balance()
returns trigger
as $$
begin
	insert into balances(danus, ukt, player_id)
	values (0, 0, new.player_id);
	return new;
end;
$$ language plpgsql
security definer;

create or replace trigger trg_set_initial_balance
after insert on player
for each row 
execute function set_initial_balance();

-----================================================================================= Initial Profile =================================================================================-----

create or replace function set_initial_profile()
returns trigger as $$
begin
    insert into profile (player_id, player_exp, player_level, sk2pm, player_rank)
    values (
        new.player_id,  
        0,              
        1,              
        0,              
        null               
    );

	perform update_player_rank();

    return new;
end;
$$ language plpgsql;

create or replace trigger trg_set_initial_profile
after insert on player
for each row
execute function set_initial_profile();

drop procedure update_player_rank cascade;

create or replace function update_player_rank()
returns void
language plpgsql
as $$
begin
    with ranked_players as (
        select player_id, 
               row_number() over (order by sk2pm desc, player_id asc) as rank
        from profile
    )
    update profile
    set player_rank = ranked_players.rank
    from ranked_players
    where profile.player_id = ranked_players.player_id;
end;
$$;

-----================================================================================= Update Balance After Match =================================================================================-----
create or replace function update_match_danus()
returns trigger as $$
begin
    update balances
    set danus = danus + new.danus_reward
    where player_id = new.player_id;

    return new;
end;
$$ language plpgsql;

create or replace trigger trg_update_match_danus
after insert on match_history
for each row
execute function update_match_danus();

-----================================================================================= Calculate Rewards Player  =================================================================================-----
create or replace function calculate_rewards()
returns trigger 
as $$
declare
    k constant int := 30;            -- sensitivitas perubahan sk2pm
    e float;                         -- ekspektasi
    s float;                         -- skor per ronde
    sadjust float;                   -- skor per ronde yang disesuaikan
    s_performance_factor float;      -- performance factor yang disesuaikan
    basic_points int := 246;         -- maksimal poin performa
    hp_penalty int := 0;             -- penalti darah
    hit_penalty int := 0;            -- penalti hit
    round_penalty int := 0;          -- penalti untuk ronde tambahan
	bonus_round int := 0;			 -- bonus ronde tambahan
    performance_points int;          -- poin performa total
    new_sk2pm int;                   -- sk2pm baru
    danus_reward int;                -- reward danus
    opponent_sk2pm int;              -- sk2pm lawan
	player_hp int := 100; 			 -- player hp 
	player_rounds_won int;			 -- menang ronde player
begin
    -- ambil sk2pm lawan
    select sk2pm into opponent_sk2pm from profile where player_id = new.opponent_id;

    player_rounds_won := new.rounds_won;
    -- penalti ronde tambahan
    if new.total_rounds = 4 then
        round_penalty := 20;
		bonus_round := 70;
		round_penalty := bonus_round - round_penalty;
    elsif new.total_rounds = 5 then
        round_penalty := 40;
		bonus_round := 140;
		round_penalty := bonus_round - round_penalty;
    end if;

	if player_rounds_won = 0 then
		round_penalty := 210;
	elsif player_rounds_won = 1 then
		round_penalty := 140;
	elsif player_rounds_won = 2 then
		round_penalty := 70;
	end if;

    -- penalti darah
    if player_hp < 80 then
        hp_penalty := 40;
    elsif player_hp < 50 then
        hp_penalty := 20;
    elsif player_hp < 20 then
        hp_penalty := 8;
    end if;

    -- penalti berdasarkan hit
    hit_penalty := least(new.total_hits_taken * 3, 3);

    -- hitung poin performa setelah penalti
    performance_points := basic_points - round_penalty - hp_penalty - hit_penalty;

    -- hitung ekspektasi
    e := 1 / (1 + power(10, (opponent_sk2pm - (select sk2pm from profile where player_id = new.player_id)) / 400.0));

    -- hitung skor s
    s := new.rounds_won::float / new.total_rounds::float;

    -- hitung performance factor
    s_performance_factor := greatest(0, performance_points / 246.0);

    -- hitung sadjust
    sadjust := s + s_performance_factor;
    if sadjust > 1 then
        sadjust := 1;
    end if;

    -- hitung sk2pm baru
    if new.is_ranked then
        new_sk2pm := (select sk2pm from profile where player_id = new.player_id) + k * (sadjust - e);

		if new_sk2pm < 0 then
            new_sk2pm := 0;
        end if;
        -- update sk2pm di tabel profile
        update profile
        set sk2pm = new_sk2pm
        where player_id = new.player_id;

		perform update_player_rank();
    end if;

    -- hitung reward danus
    if new.is_ranked then
        danus_reward := ceil(1.2 * performance_points);
    else
        danus_reward := ceil(0.5 * performance_points);
    end if;


    -- masukkan ke tabel `match_history`
    insert into match_history (
        player_id, match_log_id, new_sk2pm, danus_reward, performance_points, match_date
    )
    values (
        new.player_id, new.match_log_id, new_sk2pm, danus_reward, performance_points, current_timestamp
    );
	return new;
end;
$$ language plpgsql;

create or replace trigger trg_calculate_rewards
after insert on match_logs
for each row
execute function calculate_rewards();

-----================================================================================= Calculate Exp dan Level  =================================================================================-----
create or replace function calculate_exp()
returns trigger as $$
declare
    current_exp int;
    new_level int;
begin
    -- ambil exp saat ini dari profile
    select player_exp into current_exp from profile where player_id = new.player_id;

 
    current_exp := current_exp + 50 + (new.performance_points * 0.1);

    update profile
    set player_exp = current_exp
    where player_id = new.player_id;

    select max(level) into new_level
    from level_exp
    where exp_needed <= current_exp;

    if new_level > (select player_level from profile where player_id = new.player_id) then
        update profile
        set player_level = new_level
        where player_id = new.player_id;
    end if;

    return new;
end;
$$ language plpgsql;

create or replace trigger trg_update_exp
after insert on match_history
for each row
execute function calculate_exp();

-----================================================================================= Append to Inventory  =================================================================================-----

create or replace function add_to_inventory()
returns trigger 
as $$
declare
    v_character_id int; 
    v_gear_id int;
    v_item_id int;
    v_attack_value int;
    v_defense_value int;
    v_intelligence_value int;
    v_item_value int;
begin
    -- Mendapatkan item yang dibeli dari tabel npc_sales
    select ns.character_id, ns.gear_id, ns.item_id
    into v_character_id, v_gear_id, v_item_id
    from npc_sales ns
    join store s on s.sale_id = ns.sale_id
    where s.store_id = new.store_id;

    if new.item_type = 'Character' then
        select base_attack, base_defense, base_intelligence
        into v_attack_value, v_defense_value, v_intelligence_value
        from characters
        where character_id = v_character_id;

        insert into characters_inventory (player_id, character_id, attack_value, defense_value, intelligence_value)
        values (new.player_id, v_character_id, v_attack_value, v_defense_value, v_intelligence_value);

        insert into player_inventory (player_id, item_type, item_id, acquired_date)
        values (new.player_id, 'Character', v_character_id, now());

    elsif new.item_type = 'Gear' then
        select base_attack, base_defense, base_intelligence
        into v_attack_value, v_defense_value, v_intelligence_value
        from gears
        where gear_id = v_gear_id;

        insert into gears_inventory (player_id, gear_id, attack_value, defense_value, intelligence_value)
        values (new.player_id, v_gear_id, v_attack_value, v_defense_value, v_intelligence_value);

        insert into player_inventory (player_id, item_type, item_id, acquired_date)
        values (new.player_id, 'Gear', v_gear_id, now());

    elsif new.item_type = 'Item' then
        select item_base_value
        into v_item_value
        from items
        where item_id = v_item_id;

        insert into items_inventory (player_id, item_id, item_value)
        values (new.player_id, v_item_id, v_item_value);

        insert into player_inventory (player_id, item_type, item_id, acquired_date)
        values (new.player_id, 'Item', v_item_id, now());
    end if;

    return new;
end;
$$ language plpgsql 
security definer;

create or replace trigger trigger_add_to_inventory
after insert on store_history
for each row
execute function add_to_inventory();

-----======================= STORED PROCEDURE =======================-----
-----================================================================================= Signin =================================================================================-----
create or replace procedure signin(
  inout p_username varchar,
  inout p_password varchar,
  inout p_role varchar default 'player',
  inout p_player_id int default null,
  inout p_type_activity varchar default 'signin'
)
as $$
begin
	p_player_id := validate_player_credentials(p_username, p_password, p_role);
	  
	if p_player_id is null then
		rollback;
		raise exception 'username dan password salah';
	end if;
	  
	perform insert_activity_history(p_player_id, p_type_activity);
	commit;
	raise notice 'signin berhasil: %', p_username;
end;
$$;

create or replace function validate_player_credentials(p_username varchar, p_password varchar, p_role varchar)
returns int
language plpgsql security definer
as $$
declare
	v_player_id int;
begin
	select player_id into v_player_id
	from player
	where username = p_username and password = p_password and role = p_role;
	  
	if not found then
		return null;
	end if;
	  
	return v_player_id;
end;
$$;

call signin('ryuzaki', 'admin123');
call signin('admin','admin123', 'admin');
call signin('zaky', 'admin123');
call signin('zaki', 'admin123');
call signin('dio', 'admin123');
call signin('sule', 'admin123');
call signin('developer', 'admin123', 'admin')

-----================================================================================= Signup =================================================================================-----

create or replace procedure signup(
	inout p_username varchar,
	inout p_email varchar,
	inout p_password varchar,
	inout p_role varchar default 'player',
	inout p_type_activity varchar default 'signup'
)
language plpgsql 
as $$
declare 
	v_player_id int;
begin
	if is_username_or_email_taken(p_username, p_email) then
		rollback;
		raise exception 'Username atau email sudah terpakai';
	end if;

  	v_player_id := insert_player(p_username, p_email, p_password, p_role);
	perform insert_activity_history(v_player_id, p_type_activity);

	commit;
	raise notice 'Signup berhasil: %', p_username;
end;
$$;

create or replace function is_username_or_email_taken(p_username varchar, p_email varchar)
returns boolean
language plpgsql
security definer
as $$
begin
	return exists (select 1 from player where username = p_username or email = p_email);
end;
$$;

create or replace function insert_player(p_username varchar, p_email varchar, p_password varchar, p_role varchar)
returns int
language plpgsql
security definer
as $$
declare
  v_player_id int;
begin
	insert into player (username, email, password, role)
	values (p_username, p_email, p_password, p_role)
	returning player_id into v_player_id;
	return v_player_id;
end;
$$;

create or replace function insert_activity_history(p_player_id int, p_type_activity varchar)
returns void
language plpgsql 
security definer
as $$
begin
	insert into activity_history(player_id, type_activity)
	values (p_player_id, p_type_activity);
end;
$$;


call signup('ryuzaki', 'ryuzaki@gamil.com', 'admin123');
call signup('zaky', 'zaky@gmail.com', 'admin123');
call signup('dio', 'dio@gmail.com', 'admin123');
call signup('akbar', 'akbar@gmail.com', 'admin123');
call signup('admin', 'admin@gmail.com', 'admin123', 'admin');
call signup('developer', 'developer@gmail.com', 'admin123', 'admin');


-----================================================================================= Signout =================================================================================-----
drop procedure signout;

create or replace procedure signout(
	inout p_player_id int,
	inout p_type_activity varchar default 'signout'
)
language plpgsql
as $$
begin
	if not is_player_exists(p_player_id) then
		rollback;
		raise exception 'user tidak ditemukan: %', p_player_id;
	end if;
	
	perform insert_activity_history(p_player_id, p_type_activity);
	commit;
	
	raise notice 'Signout berhasil: %', p_player_id;
end;
$$

create or replace function is_player_exists(p_player_id int)
returns boolean
language plpgsql
security definer
as $$
begin
	return exists (select 1 from player where player_id = p_player_id);
end;
$$;

call signout(1);


call signout('ryuzaki');
call signout('zaki');
call signout('admin');

-----================================================================================= getBy... =================================================================================-----
create or replace procedure get_player_by_id(
  inout p_player_id int
)
language plpgsql
as $$
begin
	if not is_player_exists(p_player_id) then
		rollback;
		raise exception 'user tidak ditemukan: %', p_player_id;
	end if;
	commit;
	raise notice 'Menemukan id player: %', p_player_id;
end;
$$;

call getPlayerById(1);

drop procedure getAdminById;

create or replace procedure get_admin_by_id(
	inout p_player_id int,
	inout p_role varchar
)
language plpgsql 
as $$
begin
    if not is_admin_exists(p_player_id, p_role) then
        raise exception 'id player dengan role admin tidak ditemukan: % dan %', p_player_id, p_role;
    end if;
  
    raise notice 'Menemukan id player: %', p_player_id;
end;
$$;

call getAdminById(2);

drop function is_admin_exists;
create or replace function is_admin_exists(p_player_id int, p_role varchar)
returns boolean
language plpgsql
security definer
as $$
begin
    return exists (select 1 from player where player_id = p_player_id and role = p_role);
end;
$$;


-----================================================================================= Validate =================================================================================-----

create or replace procedure validate_password(
  inout p_password varchar,
  inout p_player_id int
)
language plpgsql 
as $$
declare
	v_player_id int;
begin
	if not is_password_valid(p_password, p_player_id) then
		rollback;
		raise exception 'password invalid: %', p_password;
	end if;
	  
	p_player_id := p_player_id;
	commit;
	raise notice 'password valid: %', p_password;
end;
$$;

create or replace function is_password_valid(p_password varchar, p_player_id int)
returns boolean
language plpgsql 
security definer
as $$
begin
	return exists (select 1 from player where password = p_password and player_id = p_player_id);
end;
$$;

call validate_password('admin123', 1);
-----================================================================================= Tansaction Top Up =================================================================================-----

create or replace procedure add_ukt_purchase(
	inout p_player_id int,
	inout p_package_id int,
	inout p_payment_method varchar,
	inout p_payment_amount int
)
language plpgsql 
as $$
declare
	v_package_price int;
	v_ukt_amount int;
	v_method_id int;
	v_current_balance int;
	v_new_balance int;
	v_log_id int;
begin
	select price, ukt_amount into v_package_price, v_ukt_amount
	from ukt_packages
	where package_id = p_package_id;

	if not found then
		raise exception 'Silahkan pilih sesuai yang diinginkan';
	end if;

	select method_id into v_method_id
	from payment_methods
	where method_name = p_payment_method;

	if not found then 
		raise exception 'Metode pembayaran harus sesuai dengan yang tertera';
	end if;

	if p_payment_amount != v_package_price then
		raise exception 'Pembayaran harus sama dengan harga yant tertera!';
	end if;

	select ukt 
	into v_current_balance 
	from balances 
	where player_id = p_player_id;

	v_new_balance = v_current_balance + v_ukt_amount;

	update balances 
	set ukt = v_new_balance 
	where player_id = p_player_id;


	if not found then 
		raise exception 'player tidak ditemukan!';
	end if;

	insert into transaction_logs (
		player_id, transaction_date, transaction_type, amount_before, amount_after
	)
	values (
		p_player_id, now(), 'Topup UKT', v_current_balance, v_new_balance
	)
	returning log_id into v_log_id;

	insert into purchase_logs(
		log_id, package_id, method_id, payment_amount
	)
	values (
		v_log_id, p_package_id, v_method_id, p_payment_amount
	);
end;
$$;

call add_ukt_purchase(1, 2, 'Gopay', 16000);

create or replace procedure add_danus_purchase(
	inout p_player_id int,
	inout p_package_id int
)
language plpgsql security definer
as $$
declare
	v_required_ukt int;
	v_danus_amount int; 
	v_current_balance int;
	v_new_balance int;
	v_log_id int;
begin
	select 
		required_ukt, 
		danus_amount 
	into 
		v_required_ukt, 
		v_danus_amount
	from danus_packages
	where 
		package_id = p_package_id;

	if not found then
		raise exception 'Package tidak ditemukan';
	end if;

	select ukt into v_current_balance
	from balances
	where player_id = p_player_id;
 
	if v_current_balance < v_required_ukt then 
		raise exception 'Saldo UKT tidak mencukupi';
	end if;

	v_new_balance := v_current_balance - v_required_ukt;

	update balances
	set 
		ukt = v_new_balance,
		danus = coalesce(danus, 0) + v_danus_amount
	where player_id = p_player_id;

	insert into transaction_logs (
		player_id, transaction_date, transaction_type, amount_before, amount_after
	)
	values (
		p_player_id, now(), 'Purchase Danus', v_current_balance, v_new_balance
	)
	returning log_id into v_log_id;

	insert into purchase_logs (
		log_id, package_id, method_id, payment_amount
	)
    values (
		v_log_id, p_package_id, null, v_required_ukt
	);
end;
$$

call add_danus_purchase(3, 1);

-----================================================================================= purchase at store =================================================================================-----


create or replace procedure purchase_store(
	inout p_player_id int,
	inout p_store_id int
)
language plpgsql security definer
as $$
declare
	v_item_id int;
	v_gear_id int;
	v_character_id int;
	v_price int;
	v_item_type varchar(50);
	v_currency_type varchar(50);
	v_current_balance int;
	v_new_balance int;
	v_log_id int;
begin
	select 
		ns.item_id, ns.gear_id, ns.character_id, 
		s.value_price, s.currency
	into
		v_item_id, v_gear_id, v_character_id, 
		v_price, v_currency_type
	from store s
	join npc_sales ns
	on 
		s.sale_id = ns.sale_id
	where
		s.store_id = p_store_id;

	if v_item_id is not null then
        v_item_type := 'Item';
    elsif v_gear_id is not null then
        v_item_type := 'Gear';
    else
        if not exists (select 1 from characters where character_id = v_character_id) then
            raise exception 'character id % tidak ditemukan di tabel characters', v_character_id;
        end if;
        v_item_type := 'Character';
    end if;

	if v_currency_type = 'ukt' then
        select ukt into v_current_balance from balances where player_id = p_player_id;
    else
        select danus into v_current_balance from balances where player_id = p_player_id;
    end if;
	
	if v_current_balance < v_price then
		raise exception 'Saldo tidak cukup untuk melakukan pembelian';
	end if;
	
	v_new_balance := v_current_balance - v_price;

	if v_currency_type = 'ukt' then
        update balances set ukt = v_new_balance where player_id = p_player_id;
    else
        update balances set danus = v_new_balance where player_id = p_player_id;
    end if;
	
	insert into transaction_logs (
		player_id, transaction_date, transaction_type, amount_before, amount_after
	)
	values (
		p_player_id, now(), 'Store Purchase', v_current_balance, v_new_balance
	);
	insert into store_history (
		player_id, store_id, item_type
	)
	values (
		p_player_id, p_store_id, v_item_type
	);

end;
$$;

call purchase_store(1,6);

-----================================================================================= CRUD dynamic add items =================================================================================-----
create or replace procedure sp_dynamic_insert(
    in p_table_name text,             
    in p_columns text[],              
    in p_values text[]                 
)
language plpgsql
as $$
declare
    query text;                       
begin
    if array_length(p_columns, 1) <> array_length(p_values, 1) then
        raise exception 'Jumlah kolom dan nilai tidak cocok.';
    end if;

    query := format(
        'insert into %I (%s) values (%s)',
        p_table_name,                                      
        array_to_string(p_columns, ','),                  
        array_to_string(
            array(
                select quote_literal(v) from unnest(p_values) as v 
            ),
            ','
        )
    );

    raise notice 'Query yang akan dieksekusi: %', query;

    execute query;
end;
$$;


call sp_dynamic_insert(
    'characters',
    array['character_name', 'character_class', 'character_tier', 'base_attack', 'base_defense', 'base_intelligence'],
    array['Riska', '2', '3', '44', '19', '51']
);
call sp_dynamic_insert(
    'characters',
    array['character_name', 'character_class', 'character_tier', 'base_attack', 'base_defense', 'base_intelligence'],
    array['Nisa', '4', '3', '42', '19', '56']
);
call sp_dynamic_insert(
    'characters',
    array['character_name', 'character_class', 'character_tier', 'base_attack', 'base_defense', 'base_intelligence'],
    array['Cahyo', '2', '3', '43', '23', '53']
);
call sp_dynamic_insert(
    'characters',
    array['character_name', 'character_class', 'character_tier', 'base_attack', 'base_defense', 'base_intelligence'],
    array['bima', '2', '3', '43', '23', '53']
);
call sp_dynamic_insert(
    'characters',
    array['character_name', 'character_class', 'character_tier', 'base_attack', 'base_defense', 'base_intelligence'],
    array['gusti', '2', '3', '43', '23', '53']
);
call sp_dynamic_insert(
    'items',
    array['item_name', 'item_type', 'item_tier', 'item_base_value'],
    array['Tiket masuk surga', '4', '4', '1']
);

call sp_dynamic_insert(
    'items',
    array['item_name', 'item_type', 'item_tier', 'item_base_value'],
    array['Tiket masuk neraka', '4', '4', '1']
);

call sp_dynamic_insert(
    'items',
    array['item_name', 'item_type', 'item_tier', 'item_base_value'],
    array['Rempah Mariam', '1', '4', '1']
);


create or replace procedure sp_dynamic_update(
    in p_table_name text,            
    in p_columns text[],               
    in p_values text[],                
    in p_condition text                
)
language plpgsql
as $$
declare
    query text;                        
    updates text;                      
begin

    if array_length(p_columns, 1) <> array_length(p_values, 1) then
        raise exception 'jumlah kolom dan nilai tidak cocok.';
    end if;

    updates := array_to_string(
        array(
            select format('%I = %L', p_columns[i], p_values[i]) 
            from generate_subscripts(p_columns, 1) AS i
        ),
        ', '
    );

    query := format(
        'UPDATE %I SET %s WHERE %s',
        p_table_name,  
        updates,       
        p_condition    
    );

    raise notice 'Query yang akan dieksekusi: %', query;

    execute query;
end;
$$;

call sp_dynamic_update(
    'characters',
    array['character_name', 'base_attack'],
    array['Nisa', '42'],
    'character_id = 9'
);

create or replace procedure sp_dynamic_delete(
    in p_table_name text,              
    in p_condition text                
)
language plpgsql
as $$
declare
    query text;                        
begin
    if p_condition is null or trim(p_condition) = '' then
        raise exception 'Kondisi WHERE tidak boleh kosong untuk DELETE.';
    end if;
    IF p_table_name = 'characters' THEN
        EXECUTE format('DELETE FROM characters_inventory WHERE character_id IN (SELECT character_id FROM %I WHERE %s)', p_table_name, p_condition);
        EXECUTE format('DELETE FROM npc_sales WHERE character_id IN (SELECT character_id FROM %I WHERE %s)', p_table_name, p_condition);
	ELSIF p_table_name = 'gears' THEN
        EXECUTE format('DELETE FROM gears_inventory WHERE gear_id IN (SELECT gear_id FROM %I WHERE %s)', p_table_name, p_condition);
        EXECUTE format('DELETE FROM npc_sales WHERE gear_id IN (SELECT gear_id FROM %I WHERE %s)', p_table_name, p_condition);
    ELSIF p_table_name = 'items' THEN
        EXECUTE format('DELETE FROM items_inventory WHERE item_id IN (SELECT item_id FROM %I WHERE %s)', p_table_name, p_condition);
        EXECUTE format('DELETE FROM npc_sales WHERE item_id IN (SELECT item_id FROM %I WHERE %s)', p_table_name, p_condition);
    END IF;
	query := format(
        'delete from %I where %s',
        p_table_name,  
        p_condition    
    );

    raise notice 'query yang akan dieksekusi: %', query;

    execute query;

	IF p_table_name = 'characters' THEN
        PERFORM reorder_characters();
	elsIF p_table_name = 'items' THEN
        PERFORM reorder_items();
	end if;
end;
$$;

call sp_dynamic_delete(
    'characters',
    'character_id = 9'
);


call sp_dynamic_delete(
    'items',
    'item_id = 17'
);



CREATE OR REPLACE FUNCTION fn_reorder_and_sync_ids()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
   IF TG_TABLE_NAME = 'characters' THEN
        UPDATE characters
        SET character_id = -character_id;

        WITH cte AS (
            SELECT 
                -character_id AS old_character_id,
                ROW_NUMBER() OVER (PARTITION BY character_tier ORDER BY character_tier, character_id) AS new_id
            FROM characters
        )
        UPDATE characters
        SET character_id = cte.new_id
        FROM cte
        WHERE characters.character_id = cte.old_character_id;

        UPDATE characters
        SET character_id = ABS(character_id);

        PERFORM setval(
            pg_get_serial_sequence('characters', 'character_id'),
            COALESCE(MAX(character_id), 1)
        ) FROM characters;

	end if;

    -- Untuk tabel 'items'
    IF TG_TABLE_NAME = 'items' THEN
        DROP TABLE IF EXISTS temp_item_mapping;

        CREATE TEMP TABLE temp_item_mapping AS
        SELECT item_id AS old_item_id, 
               ROW_NUMBER() OVER (ORDER BY item_id) + 
               (SELECT COUNT(*) FROM items WHERE item_id <= OLD.item_id) AS new_item_id
        FROM items
        WHERE item_id > OLD.item_id;

        -- Update item_id
        UPDATE items
        SET item_id = temp_item_mapping.new_item_id
        FROM temp_item_mapping
        WHERE items.item_id = temp_item_mapping.old_item_id;

        -- Update npc_sales untuk item_id
        UPDATE npc_sales
        SET item_id = temp_item_mapping.new_item_id
        FROM temp_item_mapping
        WHERE npc_sales.item_id = temp_item_mapping.old_item_id;

        DROP TABLE temp_item_mapping;

        PERFORM setval('items_item_id_seq', (SELECT MAX(item_id) FROM items));
    END IF;

    -- Untuk tabel 'gears'
    IF TG_TABLE_NAME = 'gears' THEN
        -- Gunakan ROW_NUMBER untuk mengubah gear_id dengan cara yang aman
        DROP TABLE IF EXISTS temp_gear_mapping;

        CREATE TEMP TABLE temp_gear_mapping AS
        SELECT gear_id AS old_gear_id, 
               ROW_NUMBER() OVER (ORDER BY gear_id) AS new_gear_id
        FROM gears
        WHERE gear_id > OLD.gear_id;

        -- Update gear_id
        UPDATE gears
        SET gear_id = temp_gear_mapping.new_gear_id
        FROM temp_gear_mapping
        WHERE gears.gear_id = temp_gear_mapping.old_gear_id;

        -- Update npc_sales untuk gear_id
        UPDATE npc_sales
        SET gear_id = temp_gear_mapping.new_gear_id
        FROM temp_gear_mapping
        WHERE npc_sales.gear_id = temp_gear_mapping.old_gear_id;

        DROP TABLE temp_gear_mapping;

        PERFORM setval('gears_gear_id_seq', (SELECT MAX(gear_id) FROM gears));
    END IF;

    RETURN NULL;
END;
$$;


drop function fn_reorder_item_ids cascade;
drop function fn_reorder_and_sync_ids cascade;


create or replace trigger trg_reorder_and_sync_ids_characters
after delete on characters
for each row
execute function fn_reorder_and_sync_ids();

create or replace trigger trg_reorder_and_sync_ids_items
after delete on items
for each row
execute function fn_reorder_and_sync_ids();

create or replace  trigger trg_reorder_and_sync_ids_gears
after delete on gears
for each row
execute function fn_reorder_and_sync_ids();

drop function update_npc_sales cascade;

CREATE OR REPLACE FUNCTION update_npc_sales()
RETURNS TRIGGER AS $$
DECLARE
    v_npc_id INT;
BEGIN
    -- Tentukan npc_id berdasarkan tabel yang diubah
    IF TG_TABLE_NAME = 'characters' THEN
        v_npc_id := 3; -- npc_id untuk karakter
        -- Tambahkan karakter ke npc_sales
        INSERT INTO npc_sales (npc_id, character_id)
        VALUES (v_npc_id, NEW.character_id);
    ELSIF TG_TABLE_NAME = 'gears' THEN
        v_npc_id := 1; -- npc_id untuk gear
        -- Tambahkan gear ke npc_sales
        INSERT INTO npc_sales (npc_id, gear_id)
        VALUES (v_npc_id, NEW.gear_id);
    ELSIF TG_TABLE_NAME = 'items' THEN
        v_npc_id := 2; -- npc_id untuk item
        -- Tambahkan item ke npc_sales
        INSERT INTO npc_sales (npc_id, item_id)
        VALUES (v_npc_id, NEW.item_id);
    END IF;

    -- Reset urutan sale_id
    PERFORM reorder_npc_sales();
	perform reorder_items();
    PERFORM reorder_characters(); -- Reorder untuk characters
    PERFORM reorder_gears();  

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION reorder_npc_sales()
RETURNS VOID AS $$
DECLARE
BEGIN
    -- Hapus constraint primary key sementara
    ALTER TABLE npc_sales DROP CONSTRAINT npc_sales_pkey;

    -- Update sale_id dengan urutan baru menggunakan ROW_NUMBER()
    WITH ordered_sales AS (
        SELECT sale_id, ROW_NUMBER() OVER (ORDER BY npc_id, sale_id) AS new_sale_id
        FROM npc_sales
    )
    UPDATE npc_sales
    SET sale_id = ordered_sales.new_sale_id
    FROM ordered_sales
    WHERE npc_sales.sale_id = ordered_sales.sale_id;

    -- Tambahkan kembali primary key
    ALTER TABLE npc_sales ADD CONSTRAINT npc_sales_pkey PRIMARY KEY (sale_id);

    -- Sinkronkan sequence dengan sale_id terbaru
    PERFORM setval('npc_sales_sale_id_seq', (SELECT MAX(sale_id) FROM npc_sales));
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION reorder_items()
RETURNS VOID AS $$
DECLARE
BEGIN
    -- Hapus tabel sementara jika sudah ada
    DROP TABLE IF EXISTS temp_item_mapping;

    -- Buat tabel sementara untuk menyimpan urutan baru
    CREATE TEMP TABLE temp_item_mapping AS
    SELECT item_id AS old_item_id, ROW_NUMBER() OVER (ORDER BY item_id) AS new_item_id
    FROM items;

    -- Perbarui item_id di tabel items menggunakan tabel sementara
    UPDATE items
    SET item_id = t.new_item_id
    FROM temp_item_mapping t
    WHERE items.item_id = t.old_item_id;

    -- Perbarui referensi item_id di tabel npc_sales
    UPDATE npc_sales
    SET item_id = t.new_item_id
    FROM temp_item_mapping t
    WHERE npc_sales.item_id = t.old_item_id;

    -- Sinkronkan sequence item_id
    PERFORM setval('items_item_id_seq', (SELECT MAX(item_id) FROM items));
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION reorder_characters()
RETURNS VOID AS $$
DECLARE
BEGIN
    -- Buat tabel sementara untuk mapping character_id
    DROP TABLE IF EXISTS temp_character_mapping;

    CREATE TEMP TABLE temp_character_mapping AS
    SELECT character_id AS old_character_id,
           ROW_NUMBER() OVER (ORDER BY character_id) AS new_character_id
    FROM characters;

    -- Set semua character_id ke nilai sementara negatif
    UPDATE characters
    SET character_id = -character_id;

    -- Perbarui character_id dengan nilai baru dari tabel sementara
    UPDATE characters
    SET character_id = t.new_character_id
    FROM temp_character_mapping t
    WHERE characters.character_id = -t.old_character_id;

    -- Perbarui referensi character_id di tabel npc_sales
    UPDATE npc_sales
    SET character_id = t.new_character_id
    FROM temp_character_mapping t
    WHERE npc_sales.character_id = t.old_character_id;

    -- Sinkronkan sequence
    PERFORM setval('characters_character_id_seq', (SELECT MAX(character_id) FROM characters));
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION reorder_gears()
RETURNS VOID AS $$
DECLARE
BEGIN
    -- Hapus tabel sementara jika sudah ada
    DROP TABLE IF EXISTS temp_gear_mapping;

    -- Buat tabel sementara untuk menyimpan urutan baru
    CREATE TEMP TABLE temp_gear_mapping AS
    SELECT gear_id AS old_gear_id, ROW_NUMBER() OVER (ORDER BY gear_id) AS new_gear_id
    FROM gears;

    -- Perbarui gear_id di tabel gears menggunakan tabel sementara
    UPDATE gears
    SET gear_id = t.new_gear_id
    FROM temp_gear_mapping t
    WHERE gears.gear_id = t.old_gear_id;

    -- Perbarui referensi gear_id di tabel npc_sales
    UPDATE npc_sales
    SET gear_id = t.new_gear_id
    FROM temp_gear_mapping t
    WHERE npc_sales.gear_id = t.old_gear_id;

    -- Sinkronkan sequence gear_id
    PERFORM setval('gears_gear_id_seq', (SELECT MAX(gear_id) FROM gears));
END;
$$ LANGUAGE plpgsql;


-- Trigger untuk tabel characters
CREATE or replace TRIGGER trg_update_sales_character
AFTER INSERT ON characters
FOR EACH ROW
EXECUTE FUNCTION update_npc_sales();

-- Trigger untuk tabel gears
CREATE or replace TRIGGER trg_update_sales_gear
AFTER INSERT ON gears
FOR EACH ROW
EXECUTE FUNCTION update_npc_sales();

-- Trigger untuk tabel items
CREATE or replace TRIGGER trg_update_sales_item
AFTER INSERT ON items
FOR EACH ROW
EXECUTE FUNCTION update_npc_sales();

CREATE OR REPLACE FUNCTION delete_from_npc_sales()
RETURNS TRIGGER AS $$
BEGIN
    -- Hapus berdasarkan kolom terkait
    IF TG_TABLE_NAME = 'characters' THEN
        DELETE FROM npc_sales WHERE character_id = OLD.character_id;
    ELSIF TG_TABLE_NAME = 'gears' THEN
        DELETE FROM npc_sales WHERE gear_id = OLD.gear_id;
    ELSIF TG_TABLE_NAME = 'items' THEN
        DELETE FROM npc_sales WHERE item_id = OLD.item_id;
    END IF;

	PERFORM reorder_npc_sales();
	perform reorder_items();
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Trigger untuk tabel characters
CREATE or replace TRIGGER trg_delete_sales_character
AFTER DELETE ON characters
FOR EACH ROW
EXECUTE FUNCTION delete_from_npc_sales();

-- Trigger untuk tabel gears
CREATE or replace TRIGGER trg_delete_sales_gear
AFTER DELETE ON gears
FOR EACH ROW
EXECUTE FUNCTION delete_from_npc_sales();

-- Trigger untuk tabel items
CREATE or replace TRIGGER trg_delete_sales_item
AFTER DELETE ON items
FOR EACH ROW
EXECUTE FUNCTION delete_from_npc_sales();

-----================================================================================= CRUD item in store =================================================================================-----

drop procedure add_store_item;
drop procedure update_store_item;
drop procedure delete_store_item;
drop function reorder_store_items;
drop function trigger_reorder_store cascade;


create or replace procedure add_store_item(
    in seller_type text,
    in sale_name text,
    in sales_class text,
    in price numeric,
    in currency text
)
language plpgsql
as $$
begin
    insert into store (seller_type, sales, sales_class, price, currency)
    values (seller_type, sale_name, sales_class, price, currency);

    perform reorder_store_items();
end;
$$;

CALL add_store_item('Item seller', 'New Item', 'Chest', 5000, 'danus');

select * from get_store();

create or replace procedure update_store_item(
    in target_store_id int,
    in new_seller_type text,
    in new_sale_name text,
    in new_sales_class text,
    in new_price numeric,
    in new_currency text
)
language plpgsql
as $$
begin
    update store
	set seller_type = new_seller_type,
        sales = new_sale_name,
        sales_class = new_sales_class,
        price = new_price,
        currency = new_currency
    where store_id = target_store_id;

    perform reorder_store_items();
end;
$$;

create or replace procedure delete_store_item(in target_store_id int)
language plpgsql
as $$
begin
    delete from store where store_id = target_store_id;

    perform reorder_store_items();
end;
$$;

create or replace function reorder_store_items()
returns void
language plpgsql
as $$
declare
    rec record;
    new_store_id int := 1;
begin
    for rec in
        select *
        from store
        order by seller_type, sales_class, store_id
    loop
        update store
        set store_id = new_store_id
        where store_id = rec.store_id;

        new_store_id := new_store_id + 1;
    end loop;
end;
$$;

create or replace function trigger_reorder_store()
returns trigger
language plpgsql
as $$
begin
    perform reorder_store_items();
    return null;
end;
$$;

create or replace trigger trigger_reorder_store_items
after insert or update or delete
on store
for each statement
execute function trigger_reorder_store();


-----================================================================================= Battle Mode =================================================================================-----
create or replace procedure initiate_match(
    p_player_id int,     
    p_is_ranked boolean  
)
language plpgsql
as $$
declare
    opponent_id int;         
    opponent_sk2pm int;      
    player_rounds_won int;  
	opponent_rounds_won int;        
    total_rounds int;        
    total_hits_taken_player int;
	total_hits_taken_opponent int;    
	player_hp int := 100;
begin
    -- pilih lawan secara acak (selain diri sendiri)
    select player_id
    into opponent_id
    from player
    where player_id != p_player_id
    order by random()
    limit 1;

    -- ambil sk2pm lawan
    select sk2pm
    into opponent_sk2pm
    from profile
    where player_id = opponent_id;

    -- randomisasi parameter pertandingan
	total_rounds := FLOOR(random() * 3 + 3);

	-- random skor pemenang
    if total_rounds = 3 then
        if random() < 0.5 then
            player_rounds_won := 3;
            opponent_rounds_won := 0;
        else
            player_rounds_won := 0;
            opponent_rounds_won := 3;
        end if;
    elsif total_rounds = 4 then
        if random() < 0.5 then
            player_rounds_won := 3;
            opponent_rounds_won := 1;
        else
            player_rounds_won := 1;
            opponent_rounds_won := 3;
        end if;
    else -- total_rounds = 5
        if random() < 0.5 then
            player_rounds_won := 3;
            opponent_rounds_won := 2;
        else
            player_rounds_won := 2;
            opponent_rounds_won := 3;
        end if;
    end if;    

	-- Distribusi hits dengan logika terkait hasil pertandingan
    if player_rounds_won > opponent_rounds_won then
        total_hits_taken_player := floor(random() * 10 + 5); 
        total_hits_taken_opponent := floor(random() * 15 + 10);
    else
        total_hits_taken_player := floor(random() * 15 + 10); 
        total_hits_taken_opponent := floor(random() * 10 + 5);
    end if;  

	insert into match_logs (
        player_id, opponent_id, is_ranked, rounds_won, total_rounds, total_hits_taken, player_hp
    )
    values (
        p_player_id, opponent_id, p_is_ranked, player_rounds_won, total_rounds, total_hits_taken_player, player_hp
    );
	
	insert into match_logs (
        player_id, opponent_id, is_ranked, rounds_won, total_rounds, total_hits_taken, player_hp
    )
    values (
        opponent_id, p_player_id, p_is_ranked, opponent_rounds_won, total_rounds, total_hits_taken_opponent, player_hp
    );
    
end;
$$;

call initiate_match(1, true);

-----================================================================================= TESTING LOGIC =================================================================================-----


-- testing logic untuk rewards
create or replace function test_rewards_with_penalties(
    is_ranked boolean,        
    sk2pm_old int,            -- sk2pm pemain 
    opponent_sk2pm int,       -- sk2pm lawan
    rounds_won int,           
    total_rounds int,         
    player_hp int,            
    total_hits_taken int      
)
returns table (
    new_sk2pm int,            
    danus_reward int,         
    performance_points int   
) as $$
declare
    k constant int := 30;            -- sensitivitas perubahan sk2pm
    e float;                         -- ekspektasi
    s float;                         -- skor per ronde
    sadjust float;                   -- skor per ronde yang disesuaikan
    s_performance_factor float;      -- performance factor yang disesuaikan
    basic_points int := 246;         -- maksimal poin performa untuk 3-0 sempurna
    hp_penalty int := 0;             -- penalti darah
    hit_penalty int := 0;            -- penalti hit
	bonus_round int := 0;			 -- bonus ronde tambahan
    round_penalty int := 0;          -- penalti untuk ronde tambahan
begin

    -- mengurangi poin dasar untuk ronde tambahan
    if total_rounds = 4 then
        round_penalty := 20;
		bonus_round := 70;
		round_penalty := bonus_round - round_penalty;
    elsif total_rounds = 5 then
        round_penalty := 40;
		bonus_round := 140;
		round_penalty := bonus_round - round_penalty;
    end if;

	if rounds_won = 0 then
		round_penalty := 210;
	elsif rounds_won = 1 then
		round_penalty := 140;
	elsif rounds_won = 2 then
		round_penalty := 70;
	end if;

    -- penalti berdasarkan darah
	if player_hp == 100 then
		hp_penalty := 0;
    elsif player_hp < 80 then
        hp_penalty := 40;
    elsif player_hp < 50 then
        hp_penalty := 20;
    elsif player_hp < 20 then
        hp_penalty := 8;
    end if;

    -- penalti berdasarkan hit
    hit_penalty := total_hits_taken * 3;
	hit_penalty := least(hit_penalty, 3);

    -- menghitung total poin performa setelah penalti
    performance_points := basic_points - round_penalty - hp_penalty - hit_penalty;

    -- menghitung ekspektasi (e)
    e := 1 / (1 + power(10, (opponent_sk2pm - sk2pm_old) / 400.0));

    -- menghitung skor s (rasio kemenangan ronde)
    s := rounds_won::float / total_rounds::float;

    -- menghitung performance factor
    s_performance_factor := greatest(0, performance_points / 246.0);
	raise notice 'performance_factor: %', s_performance_factor;
	raise notice 'performance_points: %', performance_points;

    -- menyesuaikan s
    sadjust := s + s_performance_factor;

    -- membatasi nilai sadjust agar tidak lebih dari 1
    if sadjust > 1 then
        sadjust := 1;
    end if;

    -- menghitung sk2pm baru (jika ranked)
    if is_ranked then
        new_sk2pm := sk2pm_old + k * (sadjust - e);
    else
        new_sk2pm := sk2pm_old; 
    end if;

    -- menghitung reward danus
    if is_ranked then
        danus_reward := ceil(1.2 * performance_points);
    else
        danus_reward := ceil(0.5 * performance_points);
    end if;

    -- mengembalikan hasil
    return query select new_sk2pm, danus_reward, performance_points;
end;
$$ language plpgsql;

-- Ranked match (3-1, darah tersisa 50, hit diterima 5)
select * from test_rewards_with_penalties(
    true,        -- is_ranked
    1200,        -- sk2pm_old
    1300,        -- opponent_sk2pm
    3,           -- rounds_won (score )
    3,           -- total_rounds
    100,          -- player_hp
    0            -- total_hits_taken
);







