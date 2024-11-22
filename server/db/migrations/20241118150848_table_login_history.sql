-- migrate:up
create table login_history (
    login_history_id serial primary key,
    player_id int not null references player(player_id) on delete cascade,
    login_type varchar(50) not null,
    last_login timestamp default current_timestamp
);

-- migrate:down
drop table if exists login_history cascade;
