const express = require('express');
const path = require('path');
const app = express();
const PORT = 2368;

// Serve static files
app.use(express.static('public'));

// Routes
app.get('/', (req, res) => {
    res.send(`
        <!DOCTYPE html>
        <html>
        <head>
            <title>Space Ghost Blog</title>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <style>
                body {
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
                    line-height: 1.6;
                    color: #333;
                    max-width: 800px;
                    margin: 0 auto;
                    padding: 20px;
                }
                header {
                    text-align: center;
                    margin-bottom: 40px;
                    padding-bottom: 20px;
                    border-bottom: 1px solid #eee;
                }
                h1 {
                    font-size: 2.5em;
                    margin-bottom: 10px;
                }
                .post {
                    margin-bottom: 40px;
                    padding-bottom: 20px;
                    border-bottom: 1px solid #eee;
                }
                .post-title {
                    font-size: 1.8em;
                    margin-bottom: 10px;
                }
                .post-meta {
                    color: #666;
                    font-size: 0.9em;
                    margin-bottom: 15px;
                }
                .post-content {
                    line-height: 1.8;
                }
                footer {
                    text-align: center;
                    margin-top: 40px;
                    padding-top: 20px;
                    border-top: 1px solid #eee;
                    color: #666;
                }
            </style>
        </head>
        <body>
            <header>
                <h1>Space Ghost Blog</h1>
                <p>Exploring the cosmos, one post at a time</p>
            </header>
            
            <main>
                <article class="post">
                    <h2 class="post-title">Welcome to Space Ghost</h2>
                    <div class="post-meta">Published on November 4, 2025</div>
                    <div class="post-content">
                        <p>Welcome to Space Ghost, your new home for space exploration content! This is a self-hosted blog running on a Raspberry Pi.</p>
                        <p>This blog was set up to be a full-featured, self-hosted solution that you can develop locally and deploy to your Raspberry Pi.</p>
                        <p>Features include:</p>
                        <ul>
                            <li>Local development environment</li>
                            <li>Wireless content synchronization</li>
                            <li>Automated deployment scripts</li>
                            <li>Backup and restore capabilities</li>
                        </ul>
                        <p>Check out the documentation in the project repository for more information on how to customize and extend this blog.</p>
                    </div>
                </article>
                
                <article class="post">
                    <h2 class="post-title">Getting Started with Your Blog</h2>
                    <div class="post-meta">Published on November 4, 2025</div>
                    <div class="post-content">
                        <p>To get started with your new blog:</p>
                        <ol>
                            <li>Customize the site settings in the configuration files</li>
                            <li>Create your first post using the admin interface</li>
                            <li>Deploy to your Raspberry Pi using the deployment script</li>
                            <li>Set up content synchronization for easy updates</li>
                        </ol>
                        <p>As a JavaScript developer, you can easily extend the functionality by modifying the themes or creating custom apps.</p>
                    </div>
                </article>
            </main>
            
            <footer>
                <p>&copy; 2025 Space Ghost Blog. All rights reserved.</p>
            </footer>
        </body>
        </html>
    `);
});

app.get('/admin', (req, res) => {
    res.send(`
        <!DOCTYPE html>
        <html>
        <head>
            <title>Admin Panel - Space Ghost Blog</title>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <style>
                body {
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
                    line-height: 1.6;
                    color: #333;
                    max-width: 800px;
                    margin: 0 auto;
                    padding: 20px;
                }
                header {
                    text-align: center;
                    margin-bottom: 40px;
                    padding-bottom: 20px;
                    border-bottom: 1px solid #eee;
                }
                h1 {
                    font-size: 2em;
                    margin-bottom: 10px;
                }
                .form-group {
                    margin-bottom: 20px;
                }
                label {
                    display: block;
                    margin-bottom: 5px;
                    font-weight: bold;
                }
                input, textarea {
                    width: 100%;
                    padding: 10px;
                    border: 1px solid #ddd;
                    border-radius: 4px;
                    font-family: inherit;
                }
                textarea {
                    height: 200px;
                    resize: vertical;
                }
                button {
                    background-color: #333;
                    color: white;
                    padding: 12px 24px;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
                    font-size: 1em;
                }
                button:hover {
                    background-color: #555;
                }
                .message {
                    padding: 15px;
                    margin-bottom: 20px;
                    border-radius: 4px;
                }
                .success {
                    background-color: #d4edda;
                    color: #155724;
                    border: 1px solid #c3e6cb;
                }
            </style>
        </head>
        <body>
            <header>
                <h1>Admin Panel</h1>
                <p>Manage your Space Ghost Blog</p>
            </header>
            
            <main>
                <div class="message success">
                    <p>Admin panel placeholder. In a full Ghost installation, this would be the actual admin interface.</p>
                </div>
                
                <form>
                    <div class="form-group">
                        <label for="title">Post Title</label>
                        <input type="text" id="title" name="title" placeholder="Enter post title">
                    </div>
                    
                    <div class="form-group">
                        <label for="content">Post Content</label>
                        <textarea id="content" name="content" placeholder="Write your post content here..."></textarea>
                    </div>
                    
                    <button type="submit">Publish Post</button>
                </form>
            </main>
        </body>
        </html>
    `);
});

app.listen(PORT, 'localhost', () => {
    console.log(`Space Ghost Blog is running at http://localhost:${PORT}`);
    console.log(`Admin panel available at http://localhost:${PORT}/admin`);
    console.log(`Server is listening on port ${PORT}`);
});