// Require the Ghost module
const ghost = require('ghost');

// Start Ghost
ghost({
    backend: true,
    frontend: true,
    server: true
}).then(function (ghostServer) {
    console.log('Ghost server started');
    // Server is now running
}).catch(function (err) {
    console.error(err);
    process.exit(1);
});