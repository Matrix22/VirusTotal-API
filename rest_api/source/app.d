import vibe.vibe;
import virus_total;
import db_conn;

import std.stdio;

void main() {

    auto dbClient = DBConnection("root", "example", "mongo", "27017", "testing");
    auto virusTotalAPI = new VirusTotalAPI(dbClient);

    auto router = new URLRouter;
    router.registerRestInterface(virusTotalAPI);

    auto settings = new HTTPServerSettings;
    settings.port = 8080;
    settings.bindAddresses = ["0.0.0.0"];

    router.get("/", &landingHandler);
    router.get("/login", &loginHandler);
    router.get("/register", &registerHandler);
    router.get("/home", &homeHandler);
    router.get("/home/file", &fileHandler);
    router.get("/home/url", &urlHandler);
    router.get("/home/logout", &logoutHandler);

    auto listener = listenHTTP(settings, router);
    
    scope (exit) {
        listener.stopListening();
    }

    writeln(router.getAllRoutes());
    runApplication();
}

void landingHandler(HTTPServerRequest req, HTTPServerResponse res) {
    if (req.cookies().length) {
        auto accessToken = req.cookies().get("AccessToken");

        if (accessToken.empty) {
            render!("landing.dt")(res);
        } else {
            res.redirect("/home");
        }
    } else {
        render!("landing.dt")(res);
    }
}

void loginHandler(HTTPServerRequest req, HTTPServerResponse res) {
    if (req.cookies().length) {
        auto accessToken = req.cookies().get("AccessToken");

        if (accessToken.empty) {
            render!("login.dt")(res);
        } else {
            res.redirect("/home");
        }
    } else {
        render!("login.dt")(res);
    }
}

void registerHandler(HTTPServerRequest req, HTTPServerResponse res) {
    if (req.cookies().length) {
        auto accessToken = req.cookies().get("AccessToken");

        if (accessToken.empty) {
            render!("register.dt")(res);
        } else {
            res.redirect("/home");
        }
    } else {
        render!("register.dt")(res);
    }
}

void homeHandler(HTTPServerRequest req, HTTPServerResponse res) {
    if (req.cookies().length) {
        auto accessToken = req.cookies().get("AccessToken");

        if (accessToken.empty) {
            res.redirect("/login");
        } else {
            auto userEmail = req.cookies().get("userEmail");
            render!("home.dt", userEmail)(res);
        }
    } else {
        res.redirect("/login");
    }
}

void fileHandler(HTTPServerRequest req, HTTPServerResponse res) {
    if (req.cookies().length) {
        auto accessToken = req.cookies().get("AccessToken");

        if (accessToken.empty) {
            res.redirect("/login");
        } else {
            auto userEmail = req.cookies().get("userEmail");
            render!("file.dt", userEmail)(res);
        }
    } else {
        res.redirect("/login");
    }
}

void urlHandler(HTTPServerRequest req, HTTPServerResponse res) {
    if (req.cookies().length) {
        auto accessToken = req.cookies().get("AccessToken");

        if (accessToken.empty) {
            res.redirect("/login");
        } else {
            auto userEmail = req.cookies().get("userEmail");
            render!("url.dt", userEmail)(res);
        }
    } else {
        res.redirect("/login");
    }
}

void logoutHandler(HTTPServerRequest req, HTTPServerResponse res) {
    if (req.cookies().length) {
        auto accessToken = req.cookies().get("AccessToken");

        if (accessToken.empty) {
            res.redirect("/");
        } else {
            res.setCookie("AccessToken", null);
            res.setCookie("userEmail", null);
            res.redirect("/");
        }
    } else {
        res.redirect("/");
    }
}
