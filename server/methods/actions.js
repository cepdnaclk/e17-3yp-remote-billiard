//actions
//add data to db
var User = require('../models/user')
var jwt = require('jwt-simple')
var config = require('../config/dbconfig')

var functions = {
    addNew: function (req, res) {
        if (((req.body.name)== null) || ((req.body.password)== null)) { // it thease fields are missing
            console.log(typeof(req.body.name));
            res.json({success: false, msg: 'Enter all fields'}) //display a message
        }
        else {
            var newUser = User({ //add data to json
                name: req.body.name,
                password: req.body.password
            });
            newUser.save(function (err, newUser) { //save in database
                if (err) {
                    res.json({success: false, msg: 'Failed to save'})
                }
                else {
                    res.json({success: true, msg: 'Successfully saved'})
                }
            })
        }
    },
    authenticate: function (req, res) {
        User.findOne({ //find user name  ---  "User" is a object from user.js
            name: req.body.name
        }, function (err, user) {
                if (err) throw err
                if (!user) { //error code user not found
                    res.status(403).send({success: false, msg: 'Authentication Failed, User not found'})//error code from backend
                }

                else {
                    user.comparePassword(req.body.password, function (err, isMatch) {
                        if (isMatch && !err) {
                            var token = jwt.encode(user, config.secret)
                            res.json({success: true, token: token})
                        }
                        else {
                            return res.status(403).send({success: false, msg: 'Authentication failed, wrong password'})
                        }
                    })
                }
        }
        )
    },
    //get info of user to display
    getinfo: function (req, res) {
        if (req.headers.authorization && req.headers.authorization.split(' ')[0] === 'Bearer') {
            
            var token = req.headers.authorization.split(' ')[1] //extract token from header
            var decodedtoken = jwt.decode(token, config.secret) //decode token
            return res.json({success: true, msg: 'Hello ' + decodedtoken.name}) //with theuse of token--> display hello userb
        }
        else {
            return res.json({success: false, msg: 'No Headers'})
        }
    },
    getallUsers:function(req,res){
     User.find().select("name")
     
     .then((users)=>{
        res.status(200).json({users:users})
    })
    .catch(err=>console.log(err));


     }
   

    
}

module.exports = functions // to use in elsewhere