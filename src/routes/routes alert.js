const express = require('express');
const router = express.Router();
const alertController = require('../controllers/alertController');
const { protect } = require('../middleware/authMiddleware'); // 1. Import the security guard

// This matches the /user/:userId part of your Postman URL
router.get('/user/:userId', protect, alertController.getUserAlerts);

module.exports = router; // <--- This must be at the bottom!