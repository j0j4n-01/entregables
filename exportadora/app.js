// Importar los módulos necesarios
const express = require('express');
const path = require('path');
const exphbs = require('express-handlebars'); // Importar Handlebars

// Crear una instancia de Express
const app = express();

// Configurar Handlebars como motor de plantillas
app.set('view engine', '.hbs');
app.engine('.hbs', exphbs({ extname: '.hbs' }));


// Middleware para servir archivos estáticos desde la carpeta 'public'
app.use(express.static(path.join(__dirname, 'public')));

// Endpoint para obtener credenciales
app.get('/api/credentials', (req, res) => {
    res.json({
        username: process.env.API_USERNAME,
        password: process.env.API_PASSWORD
    });
});

// Ruta principal para renderizar el archivo HTML
app.get('/', (req, res) => {
    res.render('index'); // Renderizar la vista 'index.hbs'
});

// Manejar cualquier otra ruta
app.get('*', (req, res) => {
    res.status(404).send('Error 404: Página no encontrada');
});

// Puerto en el que se ejecutará el servidor
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Servidor escuchando en el puerto: http://localhost:${PORT}`);
});
