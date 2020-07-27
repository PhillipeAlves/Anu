

# ===general===

def run_sql(sql, arr = [])
    db = PG.connect(ENV['DATABASE_URL'] || { dbname: 'anu' })
    results = db.exec_params(sql, arr)
    db.close
    return results
  end
  

# ----------------CRUD Methods--------------------


# ===CREATE===


def create_gig(title, description, user_id, date, is_front_of_house, is_back_of_house)
    run_sql("INSERT into gigs (title, description, user_id, date, is_front_of_house, is_back_of_house) values ($1, $2, $3, $4, $5, $6);", [title, description, user_id, date, is_front_of_house, is_back_of_house])
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
    gigs = run_sql("SELECT * FROM gigs where id = $1;", [id])
    gigs.first
end
def find_gigs_from_user(id)
    gigs = run_sql("SELECT * FROM gigs where user_id = $1;", [id])
    gigs.first
end


# ===DELETE===


def delete_gig(id)
    run_sql("DELETE FROM gigs WHERE id = $1;", [id])
end

def delete_gigs_from_user(id)
    run_sql("DELETE FROM gigs WHERE user_id = $1;", [id])
end

# ===UPDATE===


def update_gig(id, title, description, date, is_front_of_house, is_back_of_house)
    run_sql("UPDATE gigs SET title = $1, description = $2, date = $3, is_front_of_house = $4, is_back_of_house = $5 WHERE id = $6;", [title, description, date, is_front_of_house, is_back_of_house, id])
end