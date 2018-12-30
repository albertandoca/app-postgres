const pgp = require('pg-promise');

const RespuestaConsulta = new pgp.helpers.ColumnSet([
    {
        name: 'ok',
        cast: 'boolean'
    },
    'datos:csv',
    'mensaje#'
]);

module.exports = {
    RespuestaConsulta
};