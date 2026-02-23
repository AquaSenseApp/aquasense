const jwt = require('jsonwebtoken');

const protect = (req, res, next) => {
    let token;

    // 1. Check if the header exists and starts with Bearer
    if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
        try {
            token = req.headers.authorization.split(' ')[1];

            // 2. Verify the token using the SAME secret as userController.js
            const decoded = jwt.verify(token, process.env.JWT_SECRET || 'aqua_secret_key_2026');

            // 3. Attach user data and move to the next function
            req.user = decoded;
            return next(); 
        } catch (error) {
            console.error("❌ Token verification failed");
            return res.status(401).json({ message: 'Not authorized, token failed' });
        }
    }

    // 4. If the code reaches here, it means NO token was found in the header
    if (!token) {
        console.log("🚫 No token found in request headers");
        return res.status(401).json({ message: 'Not authorized, no token' });
    }
};

module.exports = { protect };