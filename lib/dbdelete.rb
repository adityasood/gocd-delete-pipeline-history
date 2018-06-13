require 'pg'
require_relative '../setting'

begin

    con = PG.connect :hostaddr=> @dbhost, :port=> @dbport, :dbname => @database, :user => @dbuser, :password=> @dbpassword
    rs = con.exec "select count(*) from pipelines where name='PipelineD'"

  
    
rescue PG::Error => e

    puts e.message 
    
ensure

    rs.clear if rs
   
    
end