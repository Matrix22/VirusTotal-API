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
    
    auto listener = listenHTTP(settings, router);
    
    scope (exit) {
        listener.stopListening();
    }

    writeln(router.getAllRoutes());
    runApplication();
}

void landingHandler(HTTPServerRequest req, HTTPServerResponse res) {
    render!("landing.dt")(res);
}

void loginHandler(HTTPServerRequest req, HTTPServerResponse res) {
    render!("login.dt")(res);
}

void registerHandler(HTTPServerRequest req, HTTPServerResponse res) {
    render!("register.dt")(res);
}

void homeHandler(HTTPServerRequest req, HTTPServerResponse res) {
    render!("home.dt")(res);
}

void fileHandler(HTTPServerRequest req, HTTPServerResponse res) {
    render!("file.dt")(res);
}

void urlHandler(HTTPServerRequest req, HTTPServerResponse res) {
    render!("url.dt")(res);
}
