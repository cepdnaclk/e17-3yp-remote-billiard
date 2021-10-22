
const connectDB = require('./config/db')
var User = require('./models/user')
var config = require('./config/dbconfig')



var webSocketsServerPort = 3000; 


var webSocketServer = require('websocket').server;
var http = require('http');
let connection;

connectDB()


var server = http.createServer(function(request, response) {
 
});

var wsServer = new webSocketServer({
  
  httpServer: server
});

server.listen(webSocketsServerPort, function() {
    console.log((new Date()) + " Server is now listening on port "+ webSocketsServerPort);
});


var Players = [];



function Player(id, connection){
    this.id = id;
    this.connection = connection;
    this.name = "";
    this.opponentIndex = null;
    this.index = Players.length;
    this.available = false;

}



Player.prototype = {
    getId: function(){
        return {name: this.name, id: this.id, availability: this.available};
    },
    setOpponent: function(id){
        var self = this;
        Players.forEach(function(player, index){
            if (player.id == id){
                self.opponentIndex = index;
                Players[index].opponentIndex = self.index;
                return false;
            }
        });
    }
};





wsServer.on('request', function(request) {
  
  var connection = request.accept(null, request.origin)

  var player = new Player(request.key, connection);
  connection.sendUTF(JSON.stringify({action:'connect',data: player.id}));

  connection.on('message', function(data) {
      
  
  
    console.log('Websocket status', data.utf8Data);
    var message = JSON.parse(data.utf8Data);
    switch(message.action){
        case 'LOGIN':
            
            var emailAndPassword = message.data.split(':');
            console.log(emailAndPassword[0])
            User.findOne({email:emailAndPassword[0]},(err,results)=>{
               
                if (err) return connection.sendUTF(JSON.stringify({ msg: err }));
                else if(results == null){
                    player.connection.sendUTF(JSON.stringify({'action':'userValidity', data:false}));
                }
                else{
                    var usernameFetched;
                    usernameFetched = JSON.stringify(results["name"]);
                    player.name = usernameFetched;
                    console.log(player.name);
                    console.log(Players);
            
                    if(Players.length == 0){
                        console.log("INITIAL");
                       
                        player.connection.sendUTF(JSON.stringify({'action':'userValidity', data:true}));
                        
                        player.available = true;
                        
                        Players.push(player);
                    }else if(Players.length > 0){
                        console.log("NOT INITIAL");
                        var logged = 0;
                        
                        Players.forEach(function(user){ 
                            if( usernameFetched  == user.name){
                                logged = 1; 
                            }
                        });

                        if(logged == 0){
                            player.connection.sendUTF(JSON.stringify({'action':'userValidity', data:true}));
                        
                           
                            player.available = true;
                            
                            Players.push(player);
                        } else{
                            
                            player.connection.sendUTF(JSON.stringify({'action':'userValidity', data:false}));
                        }

                    }
                
                    
                
                }
    
            }); 
            break;
            
        case 'SIGNUP':
            var dataSignIn = message.data.split(':');
            console.log(message.data)

            var newUser = User({ 
                name: dataSignIn[0],
                email: dataSignIn[1],
                password: dataSignIn[2],
                dob:dataSignIn[3]
            });
            newUser.save(function (err, newUser) { 
                if (err) {
                    connection.sendUTF(JSON.stringify({success: false, msg: 'Failed to save'}))
                    console.log(err)
                }
                else {
                    connection.sendUTF(JSON.stringify({success: true, msg: 'Successfully saved'}))
                }
            })

       
            break;
        case 'getallUsers':
          User.find().select("name")
     
           .then((users)=>{
           connection.sendUTF(JSON.stringify({
             'action':'returnAllUsers',
             'data':users}));
      
          })
          .catch(err=>console.log(err));
        break;
        case 'new_game':
            data = message.data.split(";");
            player.setOpponent(data[0]);
            Players[player.opponentIndex].connection.sendUTF(JSON.stringify({'action':'new_game', 'data': (player.name).concat(";")
           .concat(player.id).concat(";").
            concat(data[2])}));

        player.available = false;
        Players[player.opponentIndex].available = false;

        
        
        
        
        
        console.log(data[2]);
      
        break;


        case 'request_players_list':
                request_player_id = player.id;
               

                var playersList = [];
                Players.forEach(function(player){
                   
                        playersList.push(player.getId());
                 
                });
            
                player.connection.sendUTF(JSON.stringify({
                    'action': 'players_list',
                    'data': playersList
                }));
                break;


                case 'exit_game':
                    opponent_id = message.data;

                    
                    player.available = true;
                    Players[player.opponentIndex].available = true;

                    
                    id_1 = (player.id).concat(";").concat(Players[player.opponentIndex].id);
                    id_2 = (Players[player.opponentIndex].id).concat(";").concat(player.id);

                    Matches.forEach(function(match){
                        if(match.id == id_1 || match.id == id_2){
                            match.viewList.forEach(function(viewer){
                               
                                Players.forEach(function(p){
                                    if(p.id == viewer){
                                        p.connection.sendUTF(JSON.stringify({'action':'exit_game', 'data': ""}));
                                    }
                                });

                            });
                            
                            Matches.splice(Matches.indexOf(match),1);
                        }
                    });

                   
                    Players[player.opponentIndex].connection.sendUTF(JSON.stringify({'action':'exit_game', 'data': ''}))
                    break;

               
                case 'LOGOUT':
                    
                    var index = Players.indexOf(player);
                    if (index > -1) {
                        Players.splice(index, 1);
                    }
                 
                    break;
                case 'Chat':
                        opponent_id = message.data;

                        player.setOpponent(opponent_id);
                        Players[player.opponentIndex].connection.sendUTF(JSON.stringify({'action':'Chat', 'data': (player.name).concat(";")
                        .concat(player.id)
                        }));
                
                
                       
                        break;
                case 'chatmessage':
                        opponent_id = message.data;
                        data = message.data;

                        player.setOpponent(opponent_id);
                        Players[player.opponentIndex].connection.sendUTF(JSON.stringify({'action':'receiveChat', 'data':message.data
                        }));
                
                
                       
                        break;
                case 'CallForFoul':
                            opponent_id = message.data;
                          
                            player.setOpponent(opponent_id);
                            Players[player.opponentIndex].connection.sendUTF(JSON.stringify({'action':'CallForFoul',  'data': "FOUL?".concat(";")
                            .concat(player.id)
                            }));
                    
                           
                            break;
                            
                case 'sendfoul':
                                  opponent_id = message.data;
                                data = message.data.split(";");
                                PlayerId=data[1];
                                player.setOpponent(PlayerId);
                               
                                Players[player.opponentIndex].connection.sendUTF(JSON.stringify({'action':'notifications', 'data':data[2]}));
                        
                        
                        
                               
                                break;
                               
                case 'choosepocket':
                                data = message.data.split(";");
                                opponent_id = data[0];
                                player.setOpponent(opponent_id);
                                Players[player.opponentIndex].connection.sendUTF(JSON.stringify({'action':'choosepocket',  'data': data[1]
                               
                                }));
                        
                                break;
                                
                case 'toss':
                                    opponent_id = message.data;
                                    player.setOpponent(opponent_id);
                                    opponentname=Players[player.opponentIndex].name;
                            
                                    var toss = Math.random() * 2;
                                    var floor = Math.floor(toss)
                                    if(floor === 0){
                                        Players[player.opponentIndex].connection.sendUTF(JSON.stringify({'action':'toss',  'data': player.name
                                            }));

                                        connection.sendUTF(JSON.stringify({'action':'toss',  'data': player.name
                                        }));
                                        
                                    }else if(floor === 1)
                                    {
                                        Players[player.opponentIndex].connection.sendUTF(JSON.stringify({'action':'toss',  'data': opponentname
                                        }));
                                        connection.sendUTF(JSON.stringify({'action':'toss',  'data': opponentname
                                        }));
                                    }    
                               
                        
                                break;
        }
  
    });

        connection.on('close', function(connection) {
           
            var index = Players.indexOf(player);
            if (index > -1) {
                Players.splice(index, 1);
            }});
    
   
  
  
});
