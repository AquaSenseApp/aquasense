const { Sequelize } = require("sequelize");
const path = require('path');
require("dotenv").config({ path: path.join(__dirname, '../../.env') });

const sequelize = new Sequelize(process.env.DB_URL, {
  dialect: "mysql", 
  logging: false
});

async function connectDB() {
  try {
    await sequelize.authenticate();
    console.log("✅ Database connected successfully");
  } catch (error) {
    console.error("❌ Unable to connect to database:", error);
  }
}

connectDB();

module.exports = sequelize;
