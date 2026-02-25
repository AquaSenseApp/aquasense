const jwt = require('jsonwebtoken');

const protect = (req, res, next) => {
    // 🔥 Fail fast if misconfigured
    if (!process.env.JWT_SECRET) {
        console.error('❌ JWT_SECRET is not defined');
        return res.status(500).json({ message: 'Server misconfiguration' });
    }

    let token;

    // 1. Check Authorization header
    if (
        req.headers.authorization &&
        req.headers.authorization.startsWith('Bearer ')
    ) {
        try {
            token = req.headers.authorization.split(' ')[1];

            // 2. Verify token (NO FALLBACKS)
            const decoded = jwt.verify(token, process.env.JWT_SECRET);

            // 3. Attach decoded payload
            req.user = decoded;

            return next();
        } catch (error) {
            console.error('❌ Token verification failed:', error.message);
            return res.status(401).json({ message: 'Not authorized, token invalid' });
        }
    }

    // 4. No token at all
    return res.status(401).json({ message: 'Not authorized, no token provided' });
};

module.exports = { protect };