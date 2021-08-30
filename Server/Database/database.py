
const my_sql = require('mysql');

const mysqlConnection = my_sql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'safenet'
});

mysqlConnection.connect(function(error){
    if(error){
        console.log(error);
    
    }else{
        console.log('');
    }

module.exports=mysqlConnection;