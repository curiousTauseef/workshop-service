'use strict';

const express = require('express');
const bodyParser = require('body-parser');

const port = process.env.PORT || 3000;
const app = express();
const uuid = require('uuidv4')

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({
    extended: true
}));

const router = express.Router({});

var customers = [];

router.get('/swagger', function (req, res) {
    res.sendFile(__dirname + '/swagger.yml', function(err) {
        if (err) {
            console.error(err);
        }
    })
});

router.post("/customers", function (req, res) {
    var customer = req.body;

    if (!customer.ref) {
        res.status(400)
            .send({ "error" : "no customer reference set" });
        return;
    }

    if (!customer.name) {
        res.status(400)
            .send,({ "error" : "no customer name set" });
        return;
    }

    if (!uuid.is(customer.ref)) {
        res.status(400)
            .send({ "error" : "bad format for customer reference" });
        return;
    }

    var duplicate = customers.find(function(c) {
        return c.ref == customer.ref;
    });


    if (duplicate) {
        res.sendStatus(409);
        return;
    }

    customer.id = customers.length + 1;

    customers.push(customer);

    res.location("/customers/" + customer.id);

    res.status(201)
       .json()
});

router.get("/customers/:customerId", function (req, res) {
    var id = req.params.customerId;

    var customer = customers.find(function(c) {
        return c.id == id;
    });

    if (!customer) {
        res.sendStatus(404);
    } else {
        res.status(200)
            .json(customer);
    }
});

app.use('/', router);

app.listen(port);

console.log('Running on http://localhost:' + port);