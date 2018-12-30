const express = require('express');
const crudControlador = require('../controladores/crud');
const autentifica = require('../identificaciones/autentificaciones');
const api = express.Router();

api.post("/crea", crudControlador.creaUno);
api.post("/crea-masivo", crudControlador.creaMasivo);
//api.get("/pruebaToken", autentifica.validaToken, sesionControlador.pruebaToken);

module.exports = api;