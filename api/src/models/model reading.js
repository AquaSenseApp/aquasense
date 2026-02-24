const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Reading = sequelize.define('Reading', {
  ph: { type: DataTypes.FLOAT },
  turbidity: { type: DataTypes.FLOAT },
  flow_rate: { type: DataTypes.FLOAT },
  risk_level: { type: DataTypes.STRING }, // Low, Medium, High
  ai_explanation: { type: DataTypes.TEXT } // The "Plain-language" part [cite: 113]
});

module.exports = Reading;