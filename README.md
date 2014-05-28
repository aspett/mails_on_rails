Running on ECS Systems
======================

In order to run ruby/rails on the ECS systems, you must set up 2 environment variables.

`
setenv GEM_HOME ~/.gem
`

`
setenv HTTP_PROXY "http://www-cache.ecs.vuw.ac.nz:8080/"
`

Installing required libraries
=============================

Once you have set the environment variables, you will need to download the gems/libraries that are required to run this project. You should be able to simply go to the root directory of the project and type

`bundle`

This may take a while.

Setting up the database
=======================
We are using SQLite3 in order to make it as easy as possible to run the program on the ECS systems. 
To set up the database, type the following commands in the root directory of the project

`bundle exec rake db:create db:migrate db:seed`

Starting up the server
======================
To start up the server, navigate to the root directory of the project and run the following command

bundle exec rails server

Accessing the website
=====================
Open your web browser, and navigate to http://localhost:3000.
There will be 2 users set up for use;

Username: Manager
Password: managermanager

Username: Clerk
Password: clerkclerk

Note: The usernames _are_ case sensitive.

Shutting down the server
========================
To shut down the server, simply hit CTRL + C in the console window where you first opened the server.
