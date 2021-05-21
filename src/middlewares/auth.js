// use this middleware in protected routes
module.exports = function isAuth(req, res, next) {
    console.log("here1");
    if (req.isAuthenticated()) {
        next();
    } else {
        res.status(401).json({ message: "You are not authenticated." });
    }
};
