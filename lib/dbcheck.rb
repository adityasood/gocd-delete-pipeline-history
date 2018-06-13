require 'pg'
require_relative '../setting'
## conn=PGconn.connect( :hostaddr=>"127.0.0.1", :port=>5432, :dbname=>"cruise", :user=>"postgres", :password=>'postgres')

begin

    con = PG.connect :hostaddr=> @dbhost, :port=> @dbport, :dbname => @database, :user => @dbuser, :password=> @dbpassword
    
        rs = con.exec "START TRANSACTION;"

        rs = con.exec "delete from pipelinematerialrevisions  where pipelineid in (select id from pipelines where name='#{ENV['PIPELINE_NAME']}');"
        rs = con.exec "delete from materials where id in (select pipelinematerialrevisions.materialid from pipelinematerialrevisions, pipelines  where pipelinematerialrevisions.pipelineid=pipelines.id and pipelines.name='#{ENV['PIPELINE_NAME']}');"
        rs = con.exec "delete from modifications where pipelineid in (select id from pipelines where name='#{ENV['PIPELINE_NAME']}');"
        rs = con.exec "delete from stageartifactcleanupprohibited where pipelinename in (select name from pipelines where name='#{ENV['PIPELINE_NAME']}');"
        rs = con.exec "delete from buildstatetransitions where stageid in (select id from stages where pipelineid in (select id from pipelines where name='#{ENV['PIPELINE_NAME']}'));"
        rs = con.exec "delete from builds where stageid in (select id from stages where pipelineid in (select id from pipelines where name='#{ENV['PIPELINE_NAME']}'));"
        rs = con.exec "delete from stages where pipelineid in (select id from pipelines where name='#{ENV['PIPELINE_NAME']}');"
		rs = con.exec "delete from notificationfilters where pipeline in (select name from pipelines where name='#{ENV['PIPELINE_NAME']}');"
		rs = con.exec "delete from pipelinelabelcounts where pipelinename in (select name from pipelines where name='#{ENV['PIPELINE_NAME']}');"
		rs = con.exec "delete from pipelines where name='#{ENV['PIPELINE_NAME']}';"

		rs = con.exec "commit;"

        

    puts "Pileine '#{ENV['PIPELINE_NAME']}' history deleted!!"

rescue PG::Error => e
    
    rs = con.exec "rollback;" 
    puts "deletion '#{ENV['PIPELINE_NAME']}' abort!! Pipeline has a dependency which needs to be removed first."     
    puts e.message 
    
ensure

    con.close if con
    
end