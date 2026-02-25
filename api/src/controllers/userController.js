const User = require('../models/model users');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

// Fail fast on misconfiguration
if (!process.env.JWT_SECRET) {
    throw new Error('❌ JWT_SECRET is not defined');
}

/**
 * REGISTER
 */
exports.registerUser = async (req, res) => {
    try {
        const { username, email, password, full_name, organization_type } = req.body;

        // 1. Validate input
        if (!username || !email || !password || !full_name || !organization_type) {
            return res.status(400).json({ message: 'All fields are required' });
        }

        if (password.length < 6) {
            return res.status(400).json({ message: 'Password must be at least 6 characters' });
        }

        // 2. Check duplicates
        const existingUser = await User.findOne({ where: { email } });
        if (existingUser) {
            return res.status(409).json({ message: 'Email already registered' });
        }

        // 3. Hash password
        const hashedPassword = await bcrypt.hash(password, 10);

        // 4. Create user
        const newUser = await User.create({
            username,
            email,
            password: hashedPassword,
            full_name,
            organization_type,
        });

        return res.status(201).json({
            message: 'User created successfully',
            userId: newUser.id,
        });

    } catch (error) {
        console.error('❌ Registration failed:', error);
        return res.status(500).json({ message: 'Server error' });
    }
};

/**
 * LOGIN
 */
exports.login = async (req, res) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({ message: 'Email and password are required' });
        }

        const user = await User.findOne({ where: { email } });
        if (!user) {
            return res.status(401).json({ message: 'Invalid credentials' });
        }

        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(401).json({ message: 'Invalid credentials' });
        }

        const token = jwt.sign(
            { id: user.id, email: user.email },
            process.env.JWT_SECRET,
            { expiresIn: '24h' }
        );

        return res.status(200).json({
            message: 'Login successful',
            token,
        });

    } catch (error) {
        console.error('❌ Login failed:', error);
        return res.status(500).json({ message: 'Server error' });
    }
};