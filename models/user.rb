require 'bcrypt'


# ===CREATE===


def create_user(email, password)
    password_digest = BCrypt::Password.create(password)
    run_sql("INSERT INTO users (email, password_digest) values($1, $2);", [email, password_digest])
end


# ===READ===


def find_all_users
    run_sql("SELECT * FROM users;")
    # an array of users
end  

def find_matches(sql)
    run_sql(sql)
end 

def find_users_front_of_house
    run_sql("SELECT * FROM users WHERE is_front_of_house = '1';")
end

def find_users_back_of_house
    run_sql("SELECT * FROM users WHERE is_back_of_house = 't';")
end

def find_one_user_by_id(id)
    users = run_sql("SELECT * FROM users WHERE id = $1;", [id])
    users.first
end

def find_one_user_by_email(email)
    users = run_sql("SELECT * FROM users WHERE email = $1;", [email])
    users.first
end


# ===DELETE===


def delete_user(id)
    sql = "DELETE from users WHERE id = $1;"
    run_sql(sql, [id])
end


# ===UPDATE===


def update_user(id, user_name, bio, skills, image_data, is_front_of_house, is_back_of_house)
    run_sql("UPDATE users SET user_name = $1, bio = $2, skills = $3, image_data = $4, is_front_of_house = $5, is_back_of_house = $6 WHERE id = $7;", [user_name, bio, skills, image_data, is_front_of_house, is_back_of_house, id])
end


