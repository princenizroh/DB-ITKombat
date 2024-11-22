-- migrate:up

-- player_activity
create or replace view player_activity as
select
	p.username,
	p.time_activity,
	lh.login_type
from 
	player p
left join 
	login_history lh 
on 
	p.player_id = lh.player_id

-- migrate:down


