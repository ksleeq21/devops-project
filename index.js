const express = require('express')
const app = express()
const path = require('path')
const router = express.Router()
const port = 8000

router.get('/', (req, res) => {
  res.sendFile(path.join(__dirname + '/public/index.html'))
})

app.use('/', router)
app.listen(port)

const greeting = 'Hello'

console.log(`Running at Port port ${port}`)