module PaytmHelper
  require './lib/encryption_new_pg.rb'
  include EncryptionNewPG
  def generate_checksum
    # new_pg_checksum(@paramList,"dEYuOcfiwv038LF0").gsub("\n",'')
   new_pg_checksum(@paramList,"MwjkJxSWnJOIzdsY").gsub("\n",'')
  end

 end