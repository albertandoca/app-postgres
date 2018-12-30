const pgp = require('pg-promise');

const Credencial = new pgp.helpers.ColumnSet([
    '?id',
    {
        name: 'idTipoIdentificacion',
        cast: int[1]
    },
    {
        name: 'identificacion',
        cast: 'varchar'
    },
    {
        name: 'primerNombre',
        cast: 'varchar'
    },
    {
        name: 'segundoNombre',
        cast: 'varchar'
    },
    {
        name: 'primerApellido',
        cast: 'varchar'
    },
    {
        name: 'segundoApellido',
        cast: 'varchar'
    },
    {
        name: 'emailInstitucional',
        cast: 'varchar'
    },
    {
        name: 'fechaRegistro',
        cast: 'int[1]'
    },
    {
        name: 'fechaCaducidad',
        cast: 'timestamp'
    },
    {
        name: 'idEstadoRegistro',
        cast: 'int[1]',
        def: 2
    }
    
], {table: {table:'credenciales', schema: 'sesion'}});

const CredencialeToken = new pgp.helpers.ColumnSet([
    '?id',
    {
        name: 'identificacion',
        cast: 'varchar'
    },
    {
        name: 'primerNombre',
        cast: 'varchar'
    },
    {
        name: 'segundoNombre',
        cast: 'varchar'
    },
    {
        name: 'primerApellido',
        cast: 'varchar'
    },
    {
        name: 'segundoApellido',
        cast: 'varchar'
    },
    {
        name: 'emailInstitucional',
        cast: 'varchar'
    }
]);

const TipoIdentificacion = new pgp.helpers.ColumnSet([
    '?id',
    {
        name: 'descripcion',
        cast: varchar
    },    
], {table: {table:'tipoIdentificacion', schema: 'sesion'}});

const EstadoRegistro = new pgp.helpers.ColumnSet([
    '?id',
    {
        name: 'descripcion',
        cast: varchar
    },    
], {table: {table:'estadoRegistros', schema: 'sistema'}});

module.exports = {
    RespuestaConsulta,
    CredencialesToken,
    TipoIdentificacion,
    EstadoRegistro
};