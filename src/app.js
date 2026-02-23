const express = require('express');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const sequelize = require('./config/database');
require('dotenv').config();

// 1. IMPORT ROUTES
const userRoutes = require('./routes/routes users');
const sensorRoutes = require('./routes/routes sensors');
const readingRoutes = require('./routes/routes readings');
const alertRoutes = require('./routes/routes alert');

const app = express();

// 2. CYBERSECURITY MIDDLEWARE
app.use(helmet()); 
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, 
  max: 1000, // Increase this from 100 to 500 so you don't get blocked while testing
  message: "Too many requests..."
});
app.use(limiter);
app.use(express.json());

// 4. IMPORT MODELS FOR RELATIONSHIPS
const User = require('./models/model users');
const Sensor = require('./models/model sensor');
const Reading = require('./models/model reading');
const Alert = require('./models/model alerts');

// 5. DEFINE RELATIONSHIPS
User.hasMany(Sensor, { foreignKey: 'UserId', onDelete: 'CASCADE' });
Sensor.belongsTo(User, { foreignKey: 'UserId' });

Sensor.hasMany(Reading, { foreignKey: 'SensorId', onDelete: 'CASCADE' });
Reading.belongsTo(Sensor, { foreignKey: 'SensorId' });

Reading.hasOne(Alert, { foreignKey: 'ReadingId', onDelete: 'CASCADE' });
Alert.belongsTo(Reading, { foreignKey: 'ReadingId' });

// 3. REGISTER ROUTES
app.use('/api/users', userRoutes);
app.use('/api/sensors', sensorRoutes);
app.use('/api/readings', readingRoutes);
app.use('/api/alerts', alertRoutes); // Activating the Alerts route

// 6. START SERVER
async function startServer() {
  try {
    await sequelize.authenticate();
    console.log('✅ Database connected successfully');
    
    // Using force: true will recreate your tables on every restart
    await sequelize.sync({ alter: true });
    console.log('✅ All database tables synchronized successfully.');

    // CHANGE 3000 TO 5000 HERE
    const PORT = 5000; 
    app.listen(PORT, () => {
      console.log(`🚀 AquaSense API is running on http://localhost:${PORT}`);
    });
  } catch (error) {
    console.error('❌ Failed to start server:', error);
  }
}
startServer();