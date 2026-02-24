const express = require('express');
const router = express.Router();
const sensorController = require('../controllers/sensorController');
const { protect } = require('../middleware/authMiddleware'); // 1. Import the security guard

// 2. Protected: Register a new hardware sensor
// Requires Header: Authorization: Bearer <token>
router.post('/register', protect, sensorController.registerSensor);

// 3. Protected: Get all sensors belonging to a specific user
router.get('/user/:userId', protect, sensorController.getMySensors);

// 4. Protected: Get 24-hour analytics for a specific sensor
router.get('/analytics/:sensorId', protect, sensorController.getSensorAnalytics);

module.exports = router