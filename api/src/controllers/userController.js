const User = require('../models/model users');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

// 1. Updated Registration logic to handle ALL required fields
exports.registerUser = async (req, res) => {
    try {
      console.log("--- DEBUG START ---");
        console.log("Headers:", req.headers['content-type']);
        console.log("Body received:", req.body); // If this shows {}, Postman is the issue
        console.log("--- DEBUG END ---");
        const { username, email, password, full_name, organization_type } = req.body;
        const hashedPassword = await bcrypt.hash(password, 10);

        const newUser = await User.create({ 
            username, 
            email, 
            password: hashedPassword,
            full_name,
            organization_type 
        });

        res.status(201).json({ message: "User created!", userId: newUser.id });
    } catch (error) {
        res.status(500).json({ message: "Registration error", error: error.message });
    }
};

// 2. Login logic remains the same
exports.login = async (req, res) => {
    try {
        const { email, password } = req.body;
        const user = await User.findOne({ where: { email } });
        if (!user) return res.status(404).json({ message: "User not found" });

        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) return res.status(401).json({ message: "Invalid credentials" });

        const token = jwt.sign(
            { id: user.id, email: user.email }, 
            process.env.JWT_SECRET || 'aqua_secret_key_2026', 
            { expiresIn: '24h' }
        );

        res.status(200).json({ message: "Login successful!", token, userId: user.id });
    } catch (error) {
        res.status(500).json({ message: "Login error", error: error.message });
    }
};