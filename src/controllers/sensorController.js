const Sensor = require('../models/model sensor');
const Reading = require('../models/model reading');
const crypto = require('crypto');
const { Op } = require('sequelize'); 

// 1. For POST /register
exports.registerSensor = async (req, res) => {
    try {
        const { sensor_name, location, userId } = req.body;
        const apiKey = `AQ-${crypto.randomBytes(16).toString('hex')}`;
        const newSensor = await Sensor.create({
            sensor_name,
            location,
            api_key: apiKey,
            userId 
        });
        res.status(201).json({
            message: "Sensor registered successfully!",
            sensorId: newSensor.id,
            apiKey: newSensor.api_key
        });
    } catch (error) {
        res.status(500).json({ message: "Error registering sensor", error: error.message });
    }
};

// 2. For GET /user/:userId
exports.getMySensors = async (req, res) => {
    try {
        const { userId } = req.params;
        const sensors = await Sensor.findAll({ where: { userId } });
        res.status(200).json(sensors);
    } catch (error) {
        res.status(500).json({ message: "Error fetching sensors", error: error.message });
    }
};

// 3. For GET /analytics/:sensorId (Your Analytics Code)
exports.getSensorAnalytics = async (req, res) => {
    try {
        const { sensorId } = req.params;
        const oneDayAgo = new Date(Date.now() - 24 * 60 * 60 * 1000);

        const readings = await Reading.findAll({
            where: {
                sensorId,
                createdAt: { [Op.gte]: oneDayAgo }
            }
        });

        if (readings.length === 0) {
            return res.status(200).json({ message: "No data for the last 24 hours" });
        }

        const avgPh = readings.reduce((sum, r) => sum + r.ph, 0) / readings.length;
        const avgTurb = readings.reduce((sum, r) => sum + r.turbidity, 0) / readings.length;

        res.status(200).json({
            sensorId,
            period: "Last 24 Hours",
            readingCount: readings.length,
            averages: {
                ph: avgPh.toFixed(2),
                turbidity: avgTurb.toFixed(2)
            },
            status: avgPh < 6.5 || avgTurb > 5 ? "UNSTABLE" : "STABLE"
        });
    } catch (error) {
        res.status(500).json({ message: "Error calculating analytics", error: error.message });
    }
};