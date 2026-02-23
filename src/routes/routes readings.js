const express = require('express');
const router = express.Router();
// IMPORTANT: Make sure this name matches your filename (readingController.js)
const readingController = require('../controllers/readingController'); 
const { protect } = require('../middleware/authMiddleware'); // 1. Import the security guard

// This matches the /submit part of your Postman URL
router.post('/submit',  protect, readingController.submitReading);

module.exports = router; // <--- Without this, you get a 404