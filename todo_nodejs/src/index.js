var express = require("express");
const mongojs = require('mongojs');
const {ObjectId} = require('mongodb'); // or ObjectID 
const e = require("express");
var cors = require('cors')
const bodyParser = require("body-parser");
const cluster = require('cluster');
const numCPUs = require('os').cpus().length;
var nodemailer = require("nodemailer");



var config = {
    servive : 'gmail',
    host: "smtp.gmail.com",
    auth: {
      user: "xxxxyouremailxxxxx", 
      pass: "xxxxxxyourpassxxxxxxx"
    }, 
  }

   

let transporter = nodemailer.createTransport(config);


transporter.verify((err, success) => {
    if (err) console.error(err);
    console.log('Your config is correct');
});



var db = mongojs("User");

// 3. Log any mongodb errors
db.on("error", function(error) {
});

var app = express();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded());
app.use(bodyParser.json());





app.post('/send',function(req,res){
    var mailOptions={
        to : req.body.to,
        subject : req.body.subject,
        text : req.body.text
    }
    console.log(mailOptions);
    transporter.sendMail(mailOptions, function(error, response){
     if(error){
        console.log(error);
        res.end("error");
     }else{
        console.log("Message sent: " + response.message);
        res.end("sent");
         }
});
});

app.post( 
    "/userReg" , function(req , res) {

        var userName = req.body.userName;
        var email = req.body.email;
        var password = req.body.password;
        if (email && userName && password && userName.length && password.length && email.length)
        {   

            db.users.find({"email":email} , function(err , doc)
            {
                if (err)
                {
                    res.statusCode = 400;
                    res.send("Not able to fetch data");
                    return 
                }
                else if(doc[0]){
                   res.statusCode = 201;
                   res.send("User Already exist"); 
                }else{

                    db.lists.insert({"lists" : [ { "listTitle" : "Your Title" , "todos" : [ { "completed" : false , "title" : "Your todo last" },{ "completed" : true , "title" : "Your todo last" }] } ] } , function(err ,doc){
                        if (err)
                        {
                            res.statusCode = 400;
                            res.send("Not able to create User");
                            return
                        }
                        req.body.listId = doc._id;


                        db.tokens.insert({"token" : new Date()} , function(err , doc)
                        {
                            if (err)
                            {
                                res.statusCode = 400;
                                res.send("Note able to create User");
                                return 
                            }
                            req.body.tokenId = doc._id;
                            db.users.insert( req.body , function(err , doc){
                                if (err)
                                {
                                    res.statusCode = 400;
                                    res.send("Not able to create User");
                                    return
                                }
                                res.statusCode = 200;
                                res.send(doc);
                                return
                
                            })
    
                            
                        })

                        })

                    
                }

            });            
        }
    
        
    }
)


app.post("/token" ,function(req , res) {

    var _id = req.body._id;
    if ( _id && _id.length)
    {
        db.tokens.findOne( { "_id" : ObjectId(_id) } , function (err , doc) {
            if (!doc)
            {
                res.statusCode = 400;
                res.send({"hasToken" : false});
                return 
            }
            res.statusCode = 200;
            res.send({"hasToken" : true});
            return 
        })
        
    }
    else
    {
        res.statusCode = 400;
        return 
        
    }


})

app.post( 
    "/userLog" , function(req , res) {
        var email = req.body.email;
        var password = req.body.password;
        if (email && password && email.length && password.length)
        {   
            db.users.findOne({"email":email , "password": password} , function(err , doc){
                
                if (!doc)
                {
                    res.statusCode = 400;
                    res.send("Not able to find User");
                    return
                }
                db.tokens.insert({"token" : new Date()} , function(err , doc2)
                        {
                            if (err)
                            {
                                res.statusCode = 400;
                                res.send("Note able to create User");
                                return 
                            }
                            db.users.updateOne( {  "_id"  : doc._id } , { $set : { "tokenId" :  doc2._id  }} , function(err , doc3){
                                console.log("Update Token Called");
                                
                                if (err)
                                {
                                    res.statusCode = 400;
                                    res.send("Not able to find User");
                                    return
                                }
                                
                                doc['tokenId'] = doc2._id;
                                res.statusCode = 200;
                                res.send(doc);
                                return
                            })
            })
            
        })
    
    }}
)

app.post("/user" , function(req ,res){
    db.users.findOne( { "_id" : ObjectId(req.body._id)} , function(err , docs){
        if (!docs)
        {
            res.statusCode = 400;
            res.send("Not able to get Users");
            return 
        }
            
        res.statusCode = 200;
        res.send(docs);
        return;

        });
})

app.post("/updateUserDetails" , function(req ,res){
    db.users.updateOne( { "_id" : ObjectId(req.body._id)} , {$set : { "userName" :  req.body.userName , "dob" : req.body.dob}} , function(err , docs){
        if (!docs)
        {
            res.statusCode = 400;
            res.send("Not able update Details");
            return 
        }
            
        res.statusCode = 200;
        res.send("Success");
        return;

        });
})


app.post("/updatePassword" , function(req ,res){
    db.users.updateOne( { "_id" : ObjectId(req.body._id)} , {$set : { "password" :  req.body.password}} , function(err , docs){
        if (!docs)
        {
            res.statusCode = 400;
            res.send("Not able update Details");
            return 
        }
            
        res.statusCode = 200;
        res.send("Success");
        return;

        });
})

app.post("/addList" , function(req , res){
    db.lists.updateOne( { "_id" : ObjectId(req.body._id)} , { $push : { "lists" :  { "listTitle" : req.body.listTitle ,   "todos" : req.body.todos } } }  , function(err , doc){
        if (err)
        {
            res.statusCode = 400;
            res.send(err);
            return;
        }
        res.statusCode = 200;
        res.send(doc);
        return;

    })
})


app.post("/removeList" , function(req , res){
    db.lists.update(  { "_id" : ObjectId(req.body._id)} , { $pull : {"lists" : {"listTitle": req.body.listTitle } }} , function(err , doc){
        if (err)
        {
            res.statusCode = 400;
            res.send(err);
            return;
        }
        res.statusCode = 200;
        res.send(doc);
        return;

    })
})


// app.put("/addTodo" , function(req , res){
//     db.lists.updateOne( { "_id" : ObjectId(req.body._id) , "lists.listTitle" : req.body.listTitle } , { $push : { "lists.$.todos" : req.body.todo } }, function(err , doc){
//         if (err)
//         {
//             res.statusCode = 400;
//             res.send(err);
//         }
//         res.statusCode = 200;
//         res.send(doc);
//     })
// })


app.post("/updateList" , function(req , res){
    db.lists.updateOne( { "_id" : ObjectId(req.body._id) , "lists.listTitle" : req.body.listTitle } , {$set :  { "lists.$.todos" : req.body.todos } },function(err , doc){
        if (err)
        {
            res.statusCode = 400;
            res.send(err);
            return;

        }
        res.statusCode = 200;
        res.send("Bingo!");
        return;

    })
})


app.post("/lists" , function(req ,res){
    db.lists.findOne( { "_id" : ObjectId(req.body._id)} , function(err , docs){
        if (!docs)
        {
            res.statusCode = 400;
            res.send("Not able to get lists");
            return 
        }
        res.statusCode = 200;
        res.send(docs["lists"]);
        return;
    });
})



if (cluster.isMaster) {
  
    // Fork workers.
    for (let i = 0; i < numCPUs; i++) {
      cluster.fork();
    }
  
    cluster.on('exit', (worker, code, signal) => {
        console.log("Worker Died" + code.toString())
    });
  } else {
    app.listen(5000, () => {
       });
       

  }
