module PaytmHelper
  require './lib/encryption_new_pg.rb'
  include EncryptionNewPG
  def generate_checksum
    
   # new_pg_checksum(@paramList,"MwjkJxSWnJOIzdsY").gsub("\n",'')
    # new_pg_checksum_by_String(@paramList,"MUBUL!hKGtxvcmXM")#.gsub("\n",'').gsub("\\+", "%2b")
    new_pg_checksum(@paramList,"MUBUL!hKGtxvcmXM")#.gsub("\n",'').gsub("\\+", "%2b")

  end

 end

