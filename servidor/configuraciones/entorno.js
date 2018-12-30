let entorno = () => {
    process.env.CLAVEJWT = process.env.CLAVEJWT || 'clave de desarrollo / cambiar en producción';
    process.env.PORT = process.env.PORT || 3000;
    process.env.OPCIONESJWT = process.env.OPCIONESJWT || JSON.stringify({expiresIn: 60 * 20, algorithm: 'HS256', jwtid: '5', keyid: '5'});
};

module.exports = {
    entorno
};


