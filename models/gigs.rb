

# ===general===


def run_sql(sql)
    db = PG.connect(dbname: 'anu')
    results = db.exec(sql)
    db.close
    return results
end


# ----------------CRUD Methods--------------------


# ===CREATE===


def create_gig(title, description, user_id, is_front_of_house, is_back_of_house)
    run_sql("INSERT into gigs (title, description, user_id, is_front_of_house, is_back_of_house) values ('#{ title }', '#{ description }', #{ user_id }, '#{ is_front_of_house }', '#{ is_back_of_house }');")
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


# ===DELETE===


def delete_gig(id)
    run_sql("DELETE FROM gigs WHERE id = #{ id };")
end


# ===UPDATE===


def update_gig(id, title, description, is_front_of_house, is_back_of_house)
    run_sql("UPDATE gigs SET title = '#{ title }', description = '#{ description }', is_front_of_house = '#{ is_front_of_house }', is_back_of_house = '#{ is_back_of_house }' WHERE id = #{ id};")
end

