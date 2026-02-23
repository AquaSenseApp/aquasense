const { Sequelize } = require("sequelize");
const path = require('path'); // Add this built-in Node module
require("dotenv").config({ path: path.join(__dirname, '../../.env') }); // This points back to your root .env

const sequelize = new Sequelize(
process.env.DB_NAME,     // This looks at 'aquasense_ai' in your .env
  process.env.DB_USER,     // This looks at 'root' in your .env
  process.env.DB_PASSWORD, // This safely pulls 'Fides8660?' as a string
  {
    host: process.env.DB_HOST, // Matches your .env line 4
    dialect: "mysql",
    logging: false 
  }
);

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