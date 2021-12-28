module.exports = Object.freeze({
    COOKIE_OPTIONS: {
        sameSite: process.env.NODE_ENV === "production" ? 'none' : 'lax', // must be 'none' to enable cross-site delivery
        secure: process.env.NODE_ENV === "production", // must be explicitly specified if sameSite='none'
        maxAge: 30 * 24 * 60 * 60 * 1000
    }
});
