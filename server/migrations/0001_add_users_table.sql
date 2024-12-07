create database itkombat;

create user client_user with password 'user123';

grant usage on schema public to client_user;
grant execute on all functions in schema public to client_user;
grant execute on all procedures in schema public to client_user;
alter default privileges in schema public grant execute on functions to client_user;

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

set role client_user;

set role prince;


show tables;

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
    player_id int not null,
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

create table profile (
    profile_id serial primary key,
    player_exp int default 0,
    player_level int default 1,
    player_rank int default 1,
    sk2pm int default 0,
    player_id int references player(player_id)
);

create table leaderboards (
    leaderboard_id serial primary key,
    profile_id int references profile(profile_id)
);

--create table stats (
--	stat_id serial primary key,
--	stat_name varchar(50) not null check (stat_name in ('Attack', 'Deffense', 'Intelligence'))
--);

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
    character_class int references character_class(class_id),
    character_tier int references tiers(tier_id),
    base_attack int default 0,
    base_defense int default 0,
    base_intelligence int default 0
);

create table characters_inventory (
    character_inventory_id serial primary key,
    player_id int references player(player_id),
    character_id int references characters(character_id),
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
    npc_id int references npc(npc_id), 
    item_id int default null references items(item_id), 
    gear_id int default null references gears(gear_id),
    character_id int default null references characters(character_id)
)

create table store (
    store_id serial primary key,
    sale_id int references npc_sales(sale_id),
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

create table battle_mode (
    battle_mode_id serial primary key, 
    battle_name_mode varchar(255) not null,
    number_players int not null
);


create table matches (
    match_id serial primary key, 
    match_date timestamp not null, 
    max_skor_match int not null, 
    duration_match int not null, 
    battle_mode_id int references battle_mode(battle_mode_id) 
);

create table player_match (
    player_match_id serial primary key,
    player_match_score int not null,
    player_id int references player(player_id),
    match_id int references matches(match_id)
);

create table rewards (
    reward_id serial primary key, 
    reward_danus int not null, 
    reward_exp int not null, 
    reward_sk2pm int not null, 
    player_match_id int references player_match(player_match_id)
);

-----================================================================================= DROP TABLE =================================================================================-----
drop table if exists player cascade;
drop table if exists activity_history cascade;
drop table if exists balances cascade;
drop table if exists battle_mode cascade;
drop table if exists payment_method cascade;
drop table if exists transaction_logs cascade;
drop table if exists purchase_logs cascade;
drop table if exists ukt_packages cascade;
drop table if exists danus_packages cascade;
drop table if exists profile cascade;
drop table if exists leaderboards cascade;
drop table if exists stats cascade;
drop table if exists item_type cascade;
drop table if exists items cascade;
drop table if exists character_class cascade;
drop table if exists characters cascade;
drop table if exists gears cascade;
drop table if exists rewards cascade;
drop table if exists player_match cascade;
drop table if exists matches cascade;
drop table if exists store_history cascade;
drop table if exists store cascade;
drop table if exists npc_sales cascade;
drop table if exists npc cascade;
drop table if exists player_inventory cascade;
drop table if exists gears_inventory cascade;
drop table if exists items_inventory cascade;
drop table if exists characters_inventory cascade;
--drop table if exists announcement cascade;


-----================================================================================= INSERT VALUES =================================================================================-----
insert into player (username, email, password)
values 
('izaki', 'izaki@gmail.com', 'admin123'),
('zaky', 'zaky@gmail.com', 'admin123'),
('dio', 'dio@gmail.com', 'admin123'),
('akbar', 'akbar@gmail.com', 'admin123'),
('pangestu', 'pangestu@gmail.com', 'admin123')

insert into player (username, password, email, role)
values 
('admin_user', 'admin@gmail.com', 'admin123', 'admin')


insert into profile (profile_id, player_exp, player_level, player_rank, sk2pm, player_id)
values
(1, 1500, 2, 1, 200, 1),
(2, 1000, 1, 2, 150, 2),
(3, 800, 1, 3, 50, 3),
(4, 700, 1, 4, 30, 4)

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

insert into battle_mode (battle_mode_id, battle_name_mode, number_players)
values
(1, 'rangked', 4),
(2, 'Unrangked', 2);

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
    case
	    when i.item_id is not null then 
	end as entity_tier
    coalesce(g.gear_tier, c.character_tier, i.item_tier) as entity_tier,
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
    character_class cc on c.character_class = cc.class_id;

select * from store_details;

create or replace view inventory_details as
select 
    pi.inventory_id,
    pi.item_type,
    case 
        when pi.item_type = 'Character' then c.character_name
        when pi.item_type = 'Gear' then g.gear_name
        when pi.item_type = 'Item' then i.item_name
    end as entity_name,
	case 
        when pi.item_type = 'Character' then c.character_tier
        when pi.item_type = 'Gear' then g.gear_tier
        when pi.item_type = 'Item' then null
    end as entity_tier,
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
	item_type it on i.item_type = it.type_id;

select * from inventory_details;
----- 
create or replace view player_match_scores as
select 
    m.match_id, 
    p.player_id, 
    p.username, 
    m.match_date, 
    m.max_skor_match, 
    pm.player_match_score,
    bm.battle_name_mode
from player p
join player_match pm on p.player_id = pm.player_id
join matches m on pm.match_id = m.match_id
join battle_mode bm on m.battle_mode_id = bm.battle_mode_id
order by m.match_id, p.player_id asc;

select * from player_match_scores;
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
	entity_tier int,
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

select log_id, payment_method, ukt_purchased, amount_paid, purchase_date from get_purchase_logs() where player_id = 3;

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

---======---- trash -----======------
alter table characters
drop column stat_att,
drop column stat_def,
drop column stat_int;


-----================================================================================= Debug function exists=================================================================================-----

select n.nspname, p.proname, pg_catalog.pg_get_functiondef(p.oid)
from pg_catalog.pg_proc p
left join pg_catalog.pg_namespace n on n.oid = p.pronamespace
where p.proname = 'add_to_inventory';
-----================================================================================= Debug procedure exists=================================================================================-----
select proname, oid, pronargs, proargtypes::regtype[] 
from pg_proc 
where proname = 'purchase_store';

drop procedure register;

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

-----================================================================================= Initial Balance  =================================================================================-----
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


-----================================================================================= Append to Inventory  =================================================================================-----

create or replace function add_to_inventory()
returns trigger 
as $$
declare
    v_character_id int; 
    v_gear_id int;
    v_item_id int;
begin
    select ns.character_id, ns.gear_id, ns.item_id
    into v_character_id, v_gear_id, v_item_id
    from npc_sales ns
    join store s on s.sale_id = ns.sale_id
    where s.store_id = new.store_id;

    if new.item_type = 'Character' then
        insert into characters_inventory (player_id, character_id)
        values (new.player_id, v_character_id);
        insert into player_inventory (player_id, item_type, item_id, acquired_date)
        values (new.player_id, 'Character', v_character_id, now());
    elsif new.item_type = 'Gear' then
        insert into gears_inventory (player_id, gear_id)
        values (new.player_id, v_gear_id);
        insert into player_inventory (player_id, item_type, item_id, acquired_date)
        values (new.player_id, 'Gear', v_gear_id, now());
    elsif new.item_type = 'Item' then
        insert into items_inventory (player_id, item_id)
        values (new.player_id, v_item_id);
        insert into player_inventory (player_id, item_type, item_id, acquired_date)
        values (new.player_id, 'Item', v_item_id, now());
    end if;

    return new;
end;
$$ language plpgsql 
security definer;

drop function add_to_inventory;

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

    -- Jika item adalah karakter
    if new.item_type = 'Character' then
        select base_attack, base_defense, base_intelligence
        into v_attack_value, v_defense_value, v_intelligence_value
        from characters
        where character_id = v_character_id;

        insert into characters_inventory (player_id, character_id, attack_value, defense_value, intelligence_value)
        values (new.player_id, v_character_id, v_attack_value, v_defense_value, v_intelligence_value);

        insert into player_inventory (player_id, item_type, item_id, acquired_date)
        values (new.player_id, 'Character', v_character_id, now());

    -- Jika item adalah gear
    elsif new.item_type = 'Gear' then
        select base_attack, base_defense, base_intelligence
        into v_attack_value, v_defense_value, v_intelligence_value
        from gears
        where gear_id = v_gear_id;

        insert into gears_inventory (player_id, gear_id, attack_value, defense_value, intelligence_value)
        values (new.player_id, v_gear_id, v_attack_value, v_defense_value, v_intelligence_value);

        insert into player_inventory (player_id, item_type, item_id, acquired_date)
        values (new.player_id, 'Gear', v_gear_id, now());

    -- Jika item adalah item biasa
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

-----================================================================================= Signin =================================================================================-----
create or replace procedure signin(
	inout p_username varchar,
	inout p_password varchar,
	inout p_player_id int default null,
	inout p_role varchar default 'player',
	inout p_type_activity varchar default 'signin'
)
language plpgsql security definer
as $$
begin
		select player_id into p_player_id 
		from player 
		where username = p_username and password = p_password and role = p_role;
	
		if not found then
			raise exception 'username dan password salah';
		end if;
	
		--masukan ke dalam acitivity_history
		insert into activity_history(player_id, type_activity)
		values (p_player_id, p_type_activity);
	
		raise notice 'sign berhasil: %', p_username;
exception
    when others then
        raise;
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
language plpgsql security definer
as $$
declare 
	v_player_id int;
begin
	if exists (select 1 from player where username = p_username or email = p_email) then
		raise exception 'Username atau email sudah terpakai';
	end if;

	insert into player (username, email, password, role)
	values (p_username, p_email, p_password, p_role)
	returning player_id into v_player_id;

	insert into activity_history(player_id, type_activity)
	values (v_player_id, p_type_activity);
	
	
	raise notice 'Signup berhasil: %', p_username;
exception
    when others then
		raise;
end;
$$;


call signup('ryuzaki', 'ryuzaki@gamil.com', 'admin123');
call signup('zaky', 'zaky@gmail.com', 'admin123');
call signup('dio', 'dio@gmail.com', 'admin123');
call signup('admin', 'admin@gmail.com', 'admin123', 'admin');
call signup('developer', 'developer@gmail.com', 'admin123', 'admin');


-----================================================================================= Signout =================================================================================-----
create or replace procedure signout(
	inout p_player_id int,
	inout p_type_activity varchar default 'signout'
)
language plpgsql security definer
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
			rollback;
			raise exception 'user tidak ditemukan: %', p_player_id;
		end if;
		
		insert into activity_history(player_id, type_activity)
		values (v_player_id, p_type_activity);
		commit;
		
		raise notice 'Signout berhasil: %', p_player_id;
	end;
end;
$$

call signout(1);


call signout('ryuzaki');
call signout('zaki');
call signout('admin');

-----================================================================================= getBy... =================================================================================-----
create or replace procedure getPlayerById(
  inout p_player_id int
)
language plpgsql security definer
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
      rollback;
      raise exception 'id player tidak ditemukan: %', p_player_id;
    end if;
	commit;
	raise notice 'Menemukan id player: %', p_player_id;
  end;
end;
$$;

call getPlayerById(1)

create or replace procedure getAdminById(
	inout p_player_id int
)
language plpgsql security definer
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

call getAdminById(1)



-----======================= STORED PROCEDURE =======================-----
-----================================================================================= Validate =================================================================================-----

create or replace procedure validate_password(
	inout p_password varchar,
	inout p_player_id int
)
language plpgsql security definer
as $$
declare
	v_player_id int;
begin
	begin
		select player_id into v_player_id
		from player
		where password = p_password  and player_id = p_player_id ;

		if not found then
			rollback;
			raise exception 'password invalid: %', p_password;
		end if;
		
		
		p_player_id := v_player_id;
		
		commit;
		raise notice 'password valid: %', p_password;
	end;
end;
$$;

call validate_password('admin123', 1);
-----================================================================================= Tansaction Top Up =================================================================================-----
drop procedure add_ukt_purchase;

create or replace procedure add_ukt_purchase(
	inout p_player_id int,
	inout p_package_id int,
	inout p_payment_method varchar,
	inout p_payment_amount int
)
language plpgsql security definer
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

-----================================================================================= Purchase at store =================================================================================-----


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



-----================================================================================= Battle Mode =================================================================================-----


CREATE OR REPLACE FUNCTION complete_match(
    p_player_id INT,
    p_match_id INT,
    p_player_score INT,
    p_reward_danus INT,
    p_reward_exp INT,
    p_reward_sk2pm INT
) RETURNS VOID AS $$
DECLARE
    v_player_match_id INT;
    v_current_balance INT;
BEGIN
    -- Periksa apakah pasangan player_id dan match_id sudah ada
    SELECT player_match_id INTO v_player_match_id
    FROM player_match
    WHERE player_id = p_player_id AND match_id = p_match_id;

    IF v_player_match_id IS NOT NULL THEN
        RAISE EXCEPTION 'Error: Data player dan match sudah ada di player_match.';
    END IF;

    -- Jika belum ada, lanjutkan memasukkan skor pemain
    INSERT INTO player_match (player_match_score, player_id, match_id)
    VALUES (p_player_score, p_player_id, p_match_id)
    RETURNING player_match_id INTO v_player_match_id;

    -- Insert reward ke rewards table
    INSERT INTO rewards (reward_danus, reward_exp, reward_sk2pm, player_match_id)
    VALUES (p_reward_danus, p_reward_exp, p_reward_sk2pm, v_player_match_id);

    -- Update balances pemain
    UPDATE balances
    SET danus = danus + p_reward_danus
    WHERE player_id = p_player_id;

    -- Update profile pemain dengan EXP dan SK2PM
    UPDATE profile
    SET player_exp = player_exp + p_reward_exp,
        sk2pm = sk2pm + p_reward_sk2pm
    WHERE player_id = p_player_id;

    -- Hitung level berdasarkan EXP (contoh sederhana, bisa diperluas)
    UPDATE profile
    SET player_level = CASE
        WHEN player_exp >= 100 THEN 5
        WHEN player_exp >= 50 THEN 3
        WHEN player_exp >= 20 THEN 2
        ELSE 1
    END
    WHERE player_id = p_player_id;

    RAISE NOTICE 'Prosedur complete_match selesai untuk player_id % dan match_id %', p_player_id, p_match_id;
END;
$$ LANGUAGE plpgsql;


-- Membuat trigger setelah insert ke rewards
CREATE TRIGGER after_insert_rewards
AFTER INSERT ON rewards
FOR EACH ROW
EXECUTE FUNCTION update_balances_and_profile();

-- ganti dahulu bagian matches nilainya 
-- lalu parameter complete_match diganti menjadi yang terdapat match_id 
SELECT complete_match(
    1,   -- p_player_id
    21,   -- p_match_id
    3,   -- p_player_score
    250, -- p_reward_danus
    100, -- p_reward_exp
    20   -- p_reward_sk2pm
);

CREATE OR REPLACE FUNCTION add_match_and_complete(
    p_match_id INT,
    p_match_date TIMESTAMP,
    p_max_skor_match INT,
    p_duration_match INT,
    p_battle_mode_id INT,
    p_player_id INT,
    p_player_score INT,
    p_reward_danus INT,
    p_reward_exp INT,
    p_reward_sk2pm INT
) RETURNS VOID LANGUAGE plpgsql AS $$
BEGIN
    -- Insert data ke tabel matches
    INSERT INTO matches (match_id, match_date, max_skor_match, duration_match, battle_mode_id)
    VALUES (p_match_id, p_match_date, p_max_skor_match, p_duration_match, p_battle_mode_id);
    
    -- Panggil fungsi complete_match
    PERFORM complete_match(p_player_id, p_match_id, p_player_score, p_reward_danus, p_reward_exp, p_reward_sk2pm);
    
    RAISE NOTICE 'Match % ditambahkan dan complete_match dipanggil untuk player_id %', p_match_id, p_player_id;
END;
$$;

SELECT add_match_and_complete(
    22,                    -- p_match_id
    '2024-10-02 22:43:00', -- p_match_date
    3,                     -- p_max_skor_match
    10,                    -- p_duration_match
    1,                     -- p_battle_mode_id
    1,                     -- p_player_id
    3,                     -- p_player_score
    250,                   -- p_reward_danus
    100,                   -- p_reward_exp
    20                     -- p_reward_sk2pm
);

-----


-- Function untuk Menghitung Total Skor dari Player Matches --error
create or replace function calculate_total_score(p_player_id int)
returns int
language plpgsql
as $$
declare
    total_score int;
begin
    select sum(player_match_score) into total_score
    from player_match
    where player_id = p_player_id;
    
    return total_score;
end;
$$;

SELECT calculate_total_score(1);

-- Function untuk Menghitung Total Hadiah (Danus/EXP/SK2PM) --error 
create or replace function calculate_total_rewards(p_player_id int)
returns table(total_danus int, total_exp int, total_sk2pm int)
language plpgsql
as $$
begin
    return query
    select sum(reward_danus), sum(reward_exp), sum(reward_sk2pm)
    from rewards r
    join player_match pm on r.player_match_id = pm.player_match_id
    where pm.player_id = p_player_id;
end;
$$;

SELECT * FROM calculate_total_rewards(1);

-- belum kepake
create or replace function get_gear_stats(p_player_id int)
returns table(gear_name varchar, gear_type varchar, stat_1_name varchar, stat_1_value int, stat_2_name varchar, stat_2_value int)
language plpgsql
as $$
begin
    return query
    select 
        g.gear_name, 
        gt.type_name, 
        s1.stats_name as stat_1_name, 
        gi.gear_stats_value_1 as stat_1_value, 
        s2.stats_name as stat_2_name, 
        gi.gear_stats_value_2 as stat_2_value
    from gears_inventory gi
    join gears g on gi.gear_id = g.gear_id
    join gear_type gt on g.gear_type = gt.type_id
    join stats s1 on gi.gear_stats_1 = s1.stat_id
    join stats s2 on gi.gear_stats_2 = s2.stat_id
    where gi.player_id = p_player_id;
end;
$$;

SELECT * FROM get_gear_stats(1);

create or replace function calculate_total_gear_stats(p_player_id int)
returns table(total_attack int, total_defense int, total_intelligent int)
language plpgsql
as $$
begin
    return query
    select 
        sum(case when gi.gear_stats_1 = 1 then gi.gear_stats_value_1 else 0 end) +
        sum(case when gi.gear_stats_2 = 1 then gi.gear_stats_value_2 else 0 end) as total_attack,
        sum(case when gi.gear_stats_1 = 2 then gi.gear_stats_value_1 else 0 end) +
        sum(case when gi.gear_stats_2 = 2 then gi.gear_stats_value_2 else 0 end) as total_defense,
        sum(case when gi.gear_stats_1 = 3 then gi.gear_stats_value_1 else 0 end) +
        sum(case when gi.gear_stats_2 = 3 then gi.gear_stats_value_2 else 0 end) as total_intelligent
    from gears_inventory gi
    where gi.player_id = p_player_id;
end;
$$;

select * from calculate_total_gear_stats(1);

create or replace function count_player_matches(p_player_id int)
returns int
language plpgsql
as $$
declare
    match_count int;
begin
    select count(*) into match_count
    from player_match
    where player_id = p_player_id;

    return match_count;
end;
$$;


select count_player_matches(1);

-----================================================================================= Trigger =================================================================================-----
;


create trigger update_rank_after_sk2pm_change
after update on profile
for each row
when (OLD.sk2pm <> NEW.sk2pm)
execute procedure update_player_rank(NEW.player_id);

create trigger add_item_to_inventory_after_purchase
after insert on purchases
for each row
execute procedure add_item_to_inventory(NEW.player_id, NEW.item_id);

create trigger update_level_after_exp_change
after update on profile
for each row
when (OLD.player_exp <> NEW.player_exp)
execute procedure update_exp_and_level(NEW.player_id, NEW.player_exp - OLD.player_exp);

create trigger validate_transaction
before insert on transactions
for each row
when (NEW.transaction_amount <= 0)
execute procedure raise_exception('Transaction amount must be positive!');


create trigger update_leaderboard_after_rank_change
after update on profile
for each row
when (OLD.player_rank <> NEW.player_rank)
execute procedure update_leaderboard(NEW.player_id);


-----================================================================================= Transaction =================================================================================-----
begin;

-- Tambahkan transaksi pembelian
insert into transactions (transaction_type, transaction_amount, player_id)
values ('item', 1000, 1);


call add_transaction_and_update_balance(1, 'danus', -1000);


call add_item_to_inventory(1, 2);

commit;

begin;


call update_exp_and_level(1, 500);


call update_player_rank(1);

commit;


begin;

-- Cek saldo saat ini
declare
    current_balance int;
begin
    select danus into current_balance from balances where player_id = 1;

    if current_balance >= 1000 then
        -- Tambahkan transaksi pembelian
        call add_transaction_and_update_balance(1, 'danus', -1000);
        -- Tambahkan item ke inventory
        call add_item_to_inventory(1, 2);
    else
        raise exception 'Insufficient danus balance!';
    end if;
end;

commit;






create or replace function is_admin_exists(p_player_id int)
returns boolean
language plpgsql
as $$
begin
    return exists (select 1 from player where player_id = p_player_id and role = 'admin');
end;
$$;

create or replace procedure getAdminById(
  inout p_player_id int
)
language plpgsql 
as $$
begin
    if not is_admin_exists(p_player_id) then
        raise exception 'id player dengan role admin tidak ditemukan: %', p_player_id;
    end if;
  
    raise notice 'Menemukan id player: %', p_player_id;
end;
$$;