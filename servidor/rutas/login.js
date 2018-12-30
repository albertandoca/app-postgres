
const express = require('express');
const sesionControlador = require('../controladores/sesion');
const autentifica = require('../identificaciones/autentificaciones');
const api = express.Router();

api.post("/prueba", sesionControlador.inicio);
api.get("/pruebaToken", autentifica.validaToken, sesionControlador.pruebaToken);

module.exports = api;
