xml.tag! 'infrno-connection-info' do
  xml.IP(@game.d20pro_ip)
  xml.password(@game.d20pro_password)
  xml.port(@game.d20pro_port)
  xml.alias(@d20pro_alias)
end
