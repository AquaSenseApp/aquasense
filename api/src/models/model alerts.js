const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Alert = sequelize.define('Alert', {
  message: { type: DataTypes.STRING, allowNull: false },
  status: { type: DataTypes.ENUM('active', 'resolved'), defaultValue: 'active' }
});

module.exports = Alert;