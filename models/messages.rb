# ===CREATE===

def create_message(message, from_user_id, to_user_id)
    run_sql("INSERT into messages (message, from_user_id, to_user_id) values ($1, $2, $3);", [message, from_user_id, to_user_id])
end

# ===READ===

def find_messages_to_user(id)
    messages = run_sql("SELECT * FROM messages INNER JOIN users ON messages.from_user_id = users.id WHERE to_user_id = $1;", [id])
end

def find_messages_from_user(id)
    messages = run_sql("SELECT * FROM messages INNER JOIN users ON messages.to_user_id = users.id WHERE from_user_id = $1;", [id])
end

# ===DELETE===

def delete_message(id)
    run_sql("DELETE FROM gigs WHERE id = $1;", [id])
end

# ===UPDATE===

def update_message(id, message, from_user_id, to_user_id)
    run_sql("UPDATE gigs SET message = $1, from_user_id = $2, to_user_id = $3 WHERE id = $4;", [message, from_user_id, to_user_id, id])
end