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

create or replace view show_store as
SELECT
    s.store_id,
    s.value_price AS price,
    n.npc_name AS seller_name,
    n.npc_type AS seller_type,
    COALESCE(g.gear_name, i.item_name, c.character_name) AS sales,
    CASE
        WHEN g.gear_name IS NOT NULL THEN g.gear_type
        WHEN i.item_name IS NOT NULL THEN it.type_name
        WHEN c.character_name IS NOT NULL THEN cc.class_name
    END AS sales_classification
FROM 
    store s
JOIN 
	npc_sales ns 
ON 
	s.sale_id = ns.sale_id
LEFT JOIN 
	npc n 
ON 
	ns.npc_id = n.npc_id
LEFT JOIN 
	gears g 
ON 
	ns.gear_id = g.gear_id
LEFT JOIN 
	items i 
ON 
	ns.item_id = i.item_id
LEFT JOIN 
	item_type it 
ON 
	i.item_type = it.type_id
LEFT JOIN 
	characters c 
ON 
	ns.character_id = c.character_id
LEFT JOIN 
	character_class cc 
ON 
	c.character_class = cc.class_id;
-- migrate:down


