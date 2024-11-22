-- migrate:up
create table player (
    player_id serial primary key not null,
    username varchar(255) not null UNIQUE,
    email varchar(255) not null UNIQUE,
    password varchar(255) not null,
    role varchar(50) default 'player' not null check (role in ('admin', 'player')),
    created_at timestamp default current_timestamp,
    time_activity timestamp default current_timestamp
);
-- migrate:down
drop table if exists player cascade;
