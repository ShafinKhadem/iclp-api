// use this middleware in protected routes
function isAuth(req, res, next) {
    console.log("checking authentication...");
    if (req.isAuthenticated()) {
        console.log("authenticated");
        next();
    } else {
        console.error("not authenticated");
        res.status(401).json({ message: "not authenticated" });
    }
}

function isAdmin(req, res, next) {
    console.log("checking admin previledges...");
    if (req.isAuthenticated() && req.user.affiliation === "admin") {
        console.log(`admin access granted for id ${req.user.id}`);
        next();
    } else {
        console.error("not an admin");
        res.status(401).json({ message: "admin access denied" });
    }
}

module.exports = { isAuth, isAdmin };
