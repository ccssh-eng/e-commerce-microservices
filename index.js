const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();
const PORT = 3001;

app.use(cors());
app.use(express.json());

// Connect to MongoDB
mongoose.connect(process.env.MONGO_URI || 'mongodb://mongo:27017/auth', {
  useNewUrlParser: true,
  useUnifiedTopology: true
}).then(() => console.log(' Connected to MongoDB'))
  .catch(err => console.error('❌ MongoDB connection error:', err));

// User model
const User = mongoose.model('User', new mongoose.Schema({
  username: String,
  password: String
}));

// Routes
app.get('/users', async (req, res) => {
  const users = await User.find();
  res.json(users);
});

app.post('/users', async (req, res) => {
  const { username, password } = req.body;
  const user = new User({ username, password });
  await user.save();
  res.status(201).json(user);
});

app.listen(PORT, () => {
  console.log(` Auth Service running at http://localhost:${PORT}`);
});

