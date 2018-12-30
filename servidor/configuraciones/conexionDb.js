const datosDb = require('./servidorDb');
const pgp = require('pg-promise')({
    noWarnings: true
 });

class dbConexion {
    constructor(usuarioDb) {
        this.usuarioDb = usuarioDb;
    }
    conecta() {
        let userName = datosDb[this.usuarioDb].userName;
        let password = datosDb[this.usuarioDb].password;
        
        let db = pgp("postgres://" + userName + ":" + password +
            "@" + datosDb.hostName + ":" + datosDb.port + "/" + datosDb.dbName);
        return db;
    }
    desconecta() {
        let db = pgp.end;
        return db;
    }

}

module.exports = dbConexion;