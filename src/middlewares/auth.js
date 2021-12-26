// use this middleware in protected routes
function isAuth(req, res, next) {
    console.log("checking authentication...");
    if (req.isAuthenticated()) {
        console.log(`${req.user.name}(id:${req.user.id}) authenticated`);
        next();
    } else {
        console.error("not authenticated");
        res.status(401).json({ message: "not authenticated" });
    }
}

function isAdmin(req, res, next) {
    console.log("checking admin privileges...");
    if (req.isAuthenticated() && req.user.affiliation === "admin") {
        console.log(
            `admin access granted for ${req.user.name}(id:${req.user.id})`
        );
        next();
    } else {
        console.error("admin access denied");
        res.status(401).json({ message: "admin access denied" });
    }
}

module.exports = { isAuth, isAdmin };
