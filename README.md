![Banner](/public/anu.gif)

## The Project

After over a decade working in hospitality as a chef, it became
obvious to me that there are some key issues in the industry
that need addressing. It is common, due to various reasons, that
staff typically work long hours under a lot of stress in
comparison to other industries. Even when sick, employees are
pressured to come to work because employers lack the tools to
connect with temporary or freelance staff. Anu is a tool that
serves this need.

This project came as an effort to think about how to connect
people to allow freelancing in hospitality. One of the
solutions that became a core idea is a booking system that
allows workers to get gigs based on their availability. In
parallel, businesses can browse for workers based on their
profile and post job openings.

## The features

This was the very first project I did using Ruby. The app
is structured using Sinatra and ERB templating. For my
database I used Postgres, in which I created three tables.
One for users, one for messages between users and one for
gigs.
The User’s table stores login details and profile picture
details from photos that can be uploaded by the user on
his personal page. The photos are stored are stored on
Cloudinary. The User’s is based on one-to-many data model.
The Gig’s table is a one-to-many relationship that allows
the user to create and manage posts.
The Message’s table is a many-to-many model that helps to
keep track of a multidimensional interaction between
users, gigs and personal messages.
The user’s password is encrypted using Bcrypt and the
Session is managed with Sinatra to help to persist
information across the application.

## Technologies

- HTML5
- CSS
- Ruby
- PostgreSQL
- Sinatra
- Cloudinary
- Heroku
- BCrypt

[<img alt="project-view" src="https://us.123rf.com/450wm/giamportone/giamportone1804/giamportone180400109/99753262-stock-vector-click-here-button-with-arrow-pointer-icon.jpg?ver=6" width="40%">.](https://intense-beach-35347.herokuapp.com/)
