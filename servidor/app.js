
const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const loginRuta = require('./rutas/login');
const crudRuta = require('./rutas/crud');

app.use(bodyParser.urlencoded({extended:false}));
app.use(bodyParser.json());
app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', 'i');
    res.header('Access-Control-Allow-Headers', 'Authorization, X-API-KEY, Origin, X-Requested-With, Content-Type, Accept, Access-Control-Allow-Request-Method');
    res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
    res.header('Allow', 'GET, POST, PUT, DELETE');
    next();
});
app.use('/server', loginRuta);
app.use('/transaccion', crudRuta);

module.exports = app;

