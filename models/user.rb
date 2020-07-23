require 'bcrypt'


# ===CREATE===


def create_user(email, password)
    password_digest = BCrypt::Password.create(password)
    run_sql("INSERT INTO users (email, password_digest) values('#{email}', '#{password_digest}');")
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
    run_sql("SELECT * FROM users WHERE is_front_of_house = 't';")
end

def find_users_back_of_house
    run_sql("SELECT * FROM users WHERE is_back_of_house = 't';")
end

def find_one_user_by_id(id)
    users = run_sql("SELECT * FROM users WHERE id = #{id};")
    users.first
end

def find_one_user_by_email(email)
    users = run_sql("SELECT * FROM users WHERE email = '#{email}';")
    users.first
end


# ===DELETE===


def delete_user(id)
    sql = "DELETE from users WHERE id = #{id};"
    run_sql(sql)
end


# ===UPDATE===


def update_user(id, user_name, bio, skills, image_data, is_front_of_house, is_back_of_house)
    run_sql("UPDATE users SET user_name = '#{ user_name }', bio = '#{ bio }', skills = '#{ skills }', image_data = '#{ image_data }', is_front_of_house = '#{ is_front_of_house }', is_back_of_house = '#{ is_back_of_house }' WHERE id = #{ id};")
end


