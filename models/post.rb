

# ===general===


def run_sql(sql)
    db = PG.connect(dbname: 'hospitality_app')
    results = db.exec(sql)
    db.close
    return results
end


# ----------------CRUD Methods--------------------


# ===CREATE===


def create_post(title, description, user_id, is_front_of_house, is_back_of_house)
    run_sql("INSERT into posts (title, description, user_id, is_front_of_house, is_back_of_house) values ('#{ title }', '#{ description }', #{ user_id }, '#{ is_front_of_house }', '#{ is_back_of_house }');")
end

def find_all_posts
    run_sql("SELECT * FROM posts ;")
end


# ===READ===


def find_posts_front_of_house
    run_sql("SELECT * FROM posts WHERE is_front_of_house = '1';")
end

def find_posts_back_of_house
    run_sql("SELECT * FROM posts WHERE is_back_of_house = '1';")
end


def find_one_post_by_id(id)
    posts = run_sql("SELECT * FROM posts where id = #{id};")
    posts.first
end


# ===DELETE===


def delete_post(id)
    run_sql("DELETE FROM posts WHERE id = #{ id };")
end


# ===UPDATE===


def update_post(id, title, description, is_front_of_house, is_back_of_house)
    run_sql("UPDATE posts SET title = '#{ title }', description = '#{ description }', is_front_of_house = '#{ is_front_of_house }', is_back_of_house = '#{ is_back_of_house }' WHERE id = #{ id};")
end