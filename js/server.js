const express = require('express');
const { MongoClient } = require('mongodb');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

const url = 'mongodb://localhost:27017';
const client = new MongoClient(url);
const dbName = 'MaternalHealth';

async function startServer() {
    await client.connect();
    const db = client.db(dbName);
    console.log("🚀 Connected to MongoDB via Compass");

    // 1. SIMPLE LOGIN (No bullshit version)
    app.post('/login', async (req, res) => {
        const { email, password } = req.body;
        const user = await db.collection('users').findOne({ email, password });
        if (user) res.send({ success: true, user });
        else res.status(401).send({ success: false });
    });

    // 2. GET ALL PATIENTS
    app.get('/patients', async (req, res) => {
        const patients = await db.collection('patients').find({}).toArray();
        res.send(patients);
    });

    app.listen(3000, () => console.log('Server running on http://localhost:3000'));
}

startServer();