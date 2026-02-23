const Alert = require('../models/model alerts');
const Reading = require('../models/model reading');
const Sensor = require('../models/model sensor');

exports.getUserAlerts = async (req, res) => {
    try {
        const { userId } = req.params;

        // Find all alerts for sensors belonging to this specific user
        const alerts = await Alert.findAll({
            include: [{
                model: Reading,
                include: [{
                    model: Sensor,
                    where: { userId: userId }
                }]
            }],
            order: [['createdAt', 'DESC']] // Show newest alerts first
        });

        res.status(200).json(alerts);
    } catch (error) {
        res.status(500).json({ message: "Error fetching alerts", error: error.message });
    }
};