require 'sinatra'
require 'sqlite3'
require 'slim'
require 'sinatra/reloader'





# Routen /
get('/') do
  redirect '/tasks'
end

get ('') do
    slim(:new)
end

get('/tasks') do

  query = params[:q]


  #gör en kopplong till db
  db = SQLite3::Database.new("db/todos.db")

  db.results_as_hash = true

  #hämta från db



  if query && !query.empty?
    @databased = db.execute("SELECT * FROM todos WHERE name LIKE ?","%#{query}%")
  else
    @databased = db.execute("SELECT * FROM todos")
  end

  p @databased


  #visa med slim
  slim(:"CRUD/index")



end

post('/tasks') do

  new_task = params[:titel]
  description = params[:beskrivning]
  db = SQLite3::Database.new("db/todos.db")
  db.execute("INSERT INTO todos (name, description) VALUES (?, ?)", [new_task, description])
  redirect('/tasks')
end

post('/tasks/:id/update')do
  #plocka upp id
  id = params[:id].to_i
  name = params[:name]
  description = params[:description].to_s

  db = SQLite3::Database.new("db/todos.db")
  db.execute("UPDATE todos SET name=?,description=? WHERE id=?",[name,description,id])

  redirect('/tasks')
end

get('/tasks/delete')do
  slim(:"CRUD/delete")
end

post('/tasks/:id/delete')do

id = params[:id].to_i

db = SQLite3::Database.new("db/todos.db")

db.execute("DELETE FROM todos WHERE id = ?",id)
redirect('/tasks')
end



get('/incomplete') do

  slim(:incomplete)
end

get('/tasks/:id/edit') do
  db = SQLite3::Database.new("db/todos.db")
  db.results_as_hash = true
  id = params[:id].to_i
  @this_task = db.execute("SELECT * FROM todos WHERE id = ?", id).first
  
  slim(:"CRUD/edit")
end