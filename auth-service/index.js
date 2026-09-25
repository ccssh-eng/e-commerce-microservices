const express = require('express');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
require('dotenv').config();

const app = express();
app.use(express.json());

console.log("Auth service démarré...")

app.post('/login', async (req, res) => {
  const { username, password } = req.body;
  // check DB
  if (username === 'admin' && password === 'password') {
    const token = jwt.sign({ username }, process.env.JWT_SECRET, { expiresIn: '1h' });
    return res.json({ token });
  }
  res.status(401).json({ error: 'Invalid credentials' });
});

app.get('/health', (req, res) => res.send('Auth OK'));

app.listen(3001, () => console.log('Auth Service on 3001'));

console.log("Auth service démarré...")
