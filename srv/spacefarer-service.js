const cds = require('@sap/cds');
const nodemailer = require('nodemailer');

const LOG = cds.log('spacefarers');

// Use the configured SMTP server if available, otherwise only log the email
const transporter = process.env.SMTP_HOST
    ? nodemailer.createTransport({
        host: process.env.SMTP_HOST,
        port: Number(process.env.SMTP_PORT) || 587,
        auth: { user: process.env.SMTP_USER, pass: process.env.SMTP_PASS }
    })
    : nodemailer.createTransport({ jsonTransport: true });

module.exports = class SpacefarerService extends cds.ApplicationService {
    init() {
        const { Spacefarers } = this.entities;

        this.before('CREATE', Spacefarers, (req) => {
            const s = req.data;

            // Validation
            if (s.stardustCollection < 0) {
                req.error(400, 'Stardust collection cannot be negative', 'stardustCollection');
            }
            if (s.wormholeNavigationSkill < 1 || s.wormholeNavigationSkill > 10) {
                req.error(400, 'Wormhole navigation skill must be between 1 and 10', 'wormholeNavigationSkill');
            }

            // Enhancement
            s.stardustCollection = (s.stardustCollection ?? 0) + 10; // welcome bonus
            s.wormholeNavigationSkill ??= 1;

            // A spacefarer always belongs to the planet of the user who creates it
            s.originPlanet = req.user.attr.planet ?? s.originPlanet;
        });

        this.after('CREATE', Spacefarers, async (result, req) => {
            const { name, email } = req.data;

            try {
                const info = await transporter.sendMail({
                    from: 'mission-control@galaxy.example',
                    to: email,
                    subject: 'Welcome aboard, spacefarer!',
                    text: `Dear ${name},\n\nCongratulations on starting your adventurous journey among the stars!`
                });
                LOG.info('Welcome email sent to', email, info.message ?? '');
            } catch (err) {
                // A failed email must not fail the creation of the spacefarer
                LOG.error('Failed to send welcome email:', err.message);
            }
        });

        return super.init();
    }
};
