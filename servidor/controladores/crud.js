/* jshint ignore:start|end */

const token = require('../identificaciones/token');
const cn = require('../configuraciones/conexionDb');

let creaUno = (req, res) => {
    let datos = req.body;
    let dbInicio = new cn(datos.usuarioDb)
    let db = dbInicio.conecta();
    db.result('INSERT INTO ${tabla^}(${columnas~}) VALUES (${valores:csv})', datos)
        .then(result => {
            db = dbInicio.deconecta();
            return res.status(200).json({
                ok: true,
                data: result.rowCount,
                mensaje: `${result.rowCount} registros añadidos`
            });
        })
        .catch(error => {
            db = dbInicio.deconecta();
            return res.status(400).json({
                ok: false,
                data: error,
                mensaje: 'Los datos no pudieron ser guardados'
            });
        });
};

let creaMasivo = (req, res) => {
    var datos = req.body;
    let dbInicio = new cn(datos.usuarioDb);
    let db = dbInicio.conecta();
    var registros = [];
    var errores = [];
    var contador = 0;
    datos.valores.forEach(async(elemento) => {
         return await db.one('INSERT INTO $1^ ($2~) VALUES ($3:csv) RETURNING _id, $2~', [datos.tabla, datos.columnas, elemento])
            .then(resultado => {
                registros.push(resultado);
                contador ++;
                if((datos.valores.length) == contador){
                    db = dbInicio.desconecta();
                    return res.status(200).json({
                        'ok': true,
                        'data': {'registros': registros, 'errores': errores},
                        'mensaje': `${registros.length} nuevos registros, ${errores.length} errores`
                    });
                }
            })
            .catch(error => {
                errores.push(elemento);
                contador ++;
                if((datos.valores.length) == contador){
                    db = dbInicio.desconecta();
                    return res.status(200).json({
                        'ok': true,
                        'data': {'registros': registros, 'errores': errores},
                        'mensaje': `${registros.length} nuevos registros, ${errores.length} errores`
                    });
                }
            });        
    });
};

let modifica = (req, res) => {

};

let consultaUno = (req, res) => {
    let datos = req.body;
    let dbInicio = new cn(datos.usuarioDb)
    let db = dbInicio.conecta();
    db.one('SELECT ${columnas~} FROM ${tabla^} WHERE ${condicion}', datos)
        .then(data => {
            db = dbInicio.deconecta();
            return res.status(200).json({
                ok: true,
                data: data,
                mensaje: 'Registros encontrados'
            });
        })
        .catch(error => {
            db = dbInicio.deconecta();
            return res.status(400).json({
                ok: false,
                data: error,
                mensaje: 'No se encontraron registros'
            });
        });
};

let consultaVarios = (req, res) => {

};

let consultaPaginado = (req, res) => {

};
module.exports = {
    creaUno,
    creaMasivo,
    modifica,
    consultaUno,
    consultaVarios,
    consultaPaginado
};