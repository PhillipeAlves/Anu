

# ===general===


def run_sql(sql)
    db = PG.connect(dbname: 'anu')
    results = db.exec(sql)
    db.close
    return results
end


# ----------------CRUD Methods--------------------


# ===CREATE===


def create_gig(title, description, user_id, date, is_front_of_house, is_back_of_house)
    run_sql("INSERT into gigs (title, description, user_id, date, is_front_of_house, is_back_of_house) values ('#{ title }', $$#{ description }$$, #{ user_id }, '#{ date }', '#{ is_front_of_house }', '#{ is_back_of_house }');")
end

def find_all_gigs
    run_sql("SELECT * FROM gigs ;")
end


# ===READ===


def find_gigs_front_of_house
    run_sql("SELECT * FROM gigs WHERE is_front_of_house = '1';")
end

def find_gigs_back_of_house
    run_sql("SELECT * FROM gigs WHERE is_back_of_house = '1';")
end

def find_one_gig_by_id(id)
    gigs = run_sql("SELECT * FROM gigs where id = #{id};")
    gigs.first
end
def find_gigs_from_user(id)
    gigs = run_sql("SELECT * FROM gigs where user_id = #{id};")
    gigs.first
end


# ===DELETE===


def delete_gig(id)
    run_sql("DELETE FROM gigs WHERE id = #{ id };")
end

def delete_gigs_from_user(id)
    run_sql("DELETE FROM gigs WHERE user_id = #{ id };")
end

# ===UPDATE===


def update_gig(id, title, description, date, is_front_of_house, is_back_of_house)
    run_sql("UPDATE gigs SET title = '#{ title }', description = $$#{ description }$$, date = '#{ date }', is_front_of_house = '#{ is_front_of_house }', is_back_of_house = '#{ is_back_of_house }' WHERE id = #{ id};")
end

