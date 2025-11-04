# Simple Space Ghost Blog

A lightweight, self-hosted blog for space-ghost.org built with Express.js.

## Why This Approach?

We encountered compatibility issues with Ghost and Node.js v22. This simple Express.js implementation provides:

1. A functional blog that can be developed locally
2. Easy deployment to Raspberry Pi
3. Content synchronization capabilities
4. A foundation that can be extended over time

## Features

- Responsive design
- Simple admin panel placeholder
- Easy to customize and extend
- Lightweight and fast
- Runs on Node.js v22

## Project Structure

```
simple-blog/
├── public/              # Static assets (CSS, JS, images)
├── server.js            # Main server file
├── package.json         # Node.js package file
└── README.md            # This file
```

## Development

1. Install dependencies: `npm install`
2. Start the server: `npm start`
3. Visit http://localhost:2368 to see the blog
4. Visit http://localhost:2368/admin to see the admin panel

## Deployment to Raspberry Pi

1. Copy the entire `simple-blog` directory to your Raspberry Pi
2. Install Node.js v22 on your Raspberry Pi
3. Run `npm install` to install dependencies
4. Start the server with `npm start`
5. Set up systemd service for automatic startup (see below)

### Running as a Service

Create a systemd service file at `/etc/systemd/system/space-ghost.service`:

```ini
[Unit]
Description=Space Ghost Blog
After=network.target

[Service]
Type=simple
User=pi
WorkingDirectory=/path/to/simple-blog
ExecStart=/usr/bin/node server.js
Restart=always
RestartSec=10
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=space-ghost

[Install]
WantedBy=multi-user.target
```

Then enable and start the service:
```bash
sudo systemctl enable space-ghost
sudo systemctl start space-ghost
```

## Customization

### Adding Content

Edit `server.js` to add new blog posts or modify existing content.

### Styling

Add CSS files to the `public/` directory and link them in the HTML templates.

### JavaScript

Add JavaScript files to the `public/` directory and include them in the HTML templates.

## Future Enhancements

This simple implementation can be enhanced over time:

1. Add a database for dynamic content
2. Implement a real admin panel
3. Add user authentication
4. Create a content management system
5. Add support for Markdown content
6. Implement a REST API for content management

## Content Synchronization

The content synchronization scripts from the original Ghost setup can still be used with this implementation:

```bash
# Push content from local to remote
../ghost-blog/sync-content.sh -h [RASPBERRY_PI_IP] push

# Pull content from remote to local
../ghost-blog/sync-content.sh -h [RASPBERRY_PI_IP] pull
```

Note: You'll need to adapt these scripts to work with your content structure.