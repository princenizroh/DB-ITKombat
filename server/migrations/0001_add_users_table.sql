CREATE OR REPLACE FUNCTION purchase_item(
    p_player_id INT,
    p_item_id INT,
    p_npc_id INT,
    p_payment_type VARCHAR -- 'danus' atau 'ukt'
) RETURNS BOOLEAN AS $$
DECLARE
    v_item_price INT;
    v_store_id INT;
    inserted_transaction_id INT;
BEGIN
    -- Pastikan item tersedia di tabel Items
    IF NOT EXISTS (SELECT 1 FROM Items WHERE item_id = p_item_id) THEN
        RAISE EXCEPTION 'Item with ID % does not exist', p_item_id;
    END IF;

    -- Cari harga item di Store
    SELECT s.value_price, s.store_id
    INTO v_item_price, v_store_id
    FROM Store s
    WHERE s.item_id = p_item_id AND s.store_id = p_npc_id;

    -- Tambahkan item ke inventaris pemain
    INSERT INTO Items_inventory (player_id, item_id)
    VALUES (p_player_id, p_item_id);

    -- Panggil procedure untuk transaksi dan update balance
    -- Menggunakan nilai negatif karena balance akan berkurang
    CALL add_transaction_and_update_balance(p_player_id, p_payment_type, -v_item_price);

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;