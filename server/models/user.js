//user data entry (class and functions)
var mongoose = require('mongoose')
var Schema = mongoose.Schema;
var bcrypt = require('bcrypt')
var userSchema = new Schema({
    name: { //model
        type: String,
        require: true
    },
    password: {
        type: String,
        require: true
    }
})
//save the given password as a encripted password
userSchema.pre('save', function (next) {
    var user = this;
    if (this.isModified('password') || this.isNew) { //modify or new password
        bcrypt.genSalt(10, function (err, salt) { //creating a salt
            if (err) {
                return next(err) //notify server when a error happend
            }
            bcrypt.hash(user.password, salt, function (err, hash) { //use salt to encrpy the password --hashing
                if (err) {
                    return next(err)
                }
                user.password = hash; //to save the password
                next()
            })
        })
    }
    else {
        return next()
    }
})

userSchema.methods.comparePassword = function (passw, cb) { //authentivation by coparing poassword sent to us
    bcrypt.compare(passw, this.password, function (err, isMatch) { //cd----callback
        if(err) {
            return cb(err)
        }
        cb(null, isMatch)
    })
} 

module.exports = mongoose.model('User', userSchema)