# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'rubygems'
require 'json'
require 'neography'


@permindex = "permutation"
@perm = "perm"
@neighbor = "neighbor"
@neo = Neography::Rest.new({:protocol => 'http://', 
                            :server => 'localhost', 
                            :port => 7474, 
                           })
@neo.create_node_index(@permindex)

def loadfile
  file = File.open("../../5.json", "r")
  jsoncontent = file.read
  JSON.parse(jsoncontent)
end

def make_sure_node_exists(node)
  foundnode = @neo.get_node_index(@permindex, @perm, node)
  
  if ( foundnode == nil )
    creatednode = @neo.create_node(@perm => node)
    @neo.add_node_to_index(@permindex, @perm, node, creatednode)
    foundnode = creatednode
    puts "created node " + node
  end
  
  foundnode
end

def make_connection(node1, node2)
  neonode1 = make_sure_node_exists(node1)
  neonode2 = make_sure_node_exists(node2)

  rel1 = @neo.create_relationship(@neighbor, neonode1, neonode2)
end


data = loadfile["pairs"]

data.each do |pair|
  node1 = pair[0].to_s
  node2 = pair[1].to_s
  
  make_connection(node1, node2)
end
