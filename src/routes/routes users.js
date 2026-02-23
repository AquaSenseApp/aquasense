const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const { protect } = require('../middleware/authMiddleware'); // 1. Import the security guard

// Change 'register' to 'registerUser' to match your controller
router.post('/register', protect, userController.registerUser);

// This one already matches 'exports.login' in your controller
router.post('/login', protect, userController.login); 

module.exports = router;