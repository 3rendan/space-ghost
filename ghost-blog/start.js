const path = require('path');
const bootGhost = require('./node_modules/ghost/core/boot');

// Set the environment
process.env.NODE_ENV = process.env.NODE_ENV || 'development';

// Start Ghost
bootGhost({
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