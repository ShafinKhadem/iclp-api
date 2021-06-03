// use this middleware in protected routes
module.exports = function isAuth(req, res, next) {
    console.log("checking authentication...");
    if (req.isAuthenticated()) {
        console.log('authenticated');
        next();
    } else {
        console.error("not authenticated");
        res.status(401).json({ message: "not authenticated" });
    }
};
