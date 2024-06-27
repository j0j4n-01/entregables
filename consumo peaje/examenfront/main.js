const express = require('express')
const hbs = require('hbs')

const app = express()
const port = 5000

app.set('view engine', 'hbs');
hbs.registerPartials(__dirname + '/views/partials', function (err) { console.log(err); });

app.use(express.static('public'))

// --------------------------------------URL----------------------------------------------
app.get('/', (req, res) => {
  res.render('peaje')
});

app.get('*', (req, res) => {
  res.send('error de ruta')
})

// ---------------------------------------------------------------------------------------


app.listen(port, () => {
  console.log(`http://localhost:${port}`)
});