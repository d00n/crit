require 'active_record'

namespace :db_utils do

  desc 'Make db more dev friendly'
  task :prepDevDb do

    sql_1 = "update users set email = concat ('staging', id, '@infrno.net');"
    sql_2 = "update photos set photo_file_name='TheThirdMan.png';"
    sql_3 = "update posts set post='Get outta my hood';"
    sql_4 = "update posts set raw_post='Get outta my hood';"

    ActiveRecord::Base.establish_connection(
      adapter: "mysql2",
      database: "pax_XX",
      username: "root",
      password: "",
      host: "localhost",
      socket: "/var/lib/mysql/mysql.sock"
    )
    ActiveRecord::Base.connection.execute(sql_1)
    ActiveRecord::Base.connection.execute(sql_2)
    ActiveRecord::Base.connection.execute(sql_3)
    ActiveRecord::Base.connection.execute(sql_4)

  end

end
