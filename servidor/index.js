const entorno = require('./configuraciones/entorno');
const app = require('./app');

entorno.entorno();

app.listen(process.env.PORT, () => {
    console.log(`El servicos está funcionando en el puerto ${ process.env.PORT }`);
});