const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const User = sequelize.define('User', {
    username: { type: DataTypes.STRING, allowNull: false }, // Added this
    full_name: { type: DataTypes.STRING, allowNull: false },
    email: { type: DataTypes.STRING, unique: true, allowNull: false },
    password: { type: DataTypes.STRING, allowNull: false },
    organization_type: { 
        type: DataTypes.ENUM('SME', 'School', 'Hospital', 'Residential'), 
        allowNull: false 
    }
});

module.exports = User;