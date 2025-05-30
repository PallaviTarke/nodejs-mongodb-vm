const express = require('express');
   const mongoose = require('mongoose');
   const dotenv = require('dotenv');

   dotenv.config();

   const app = express();
   app.use(express.json());

   // MongoDB connection
   mongoose.connect(process.env.MONGO_URI, {
     useNewUrlParser: true,
     useUnifiedTopology: true
   })
   .then(() => console.log('Connected to MongoDB'))
   .catch(err => console.error('MongoDB connection error:', err));

   // Simple schema and model
   const ItemSchema = new mongoose.Schema({
     name: String
   });
   const Item = mongoose.model('Item', ItemSchema);

   // Routes
   app.get('/items', async (req, res) => {
     const items = await Item.find();
     res.json(items);
   });

   app.post('/items', async (req, res) => {
     const item = new Item({ name: req.body.name });
     await item.save();
     res.json(item);
   });

   // Prometheus metrics endpoint
   app.get('/metrics', async (req, res) => {
     res.set('Content-Type', 'text/plain');
     res.send('nodejs_app_up 1\n');
   });

   const PORT = process.env.PORT || 3000;
   app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
