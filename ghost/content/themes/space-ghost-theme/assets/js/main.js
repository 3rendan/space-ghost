// Space Ghost Theme - Main JavaScript

(function() {
    'use strict';

    // Theme initialization
    function initTheme() {
        // Handle color scheme preference
        const colorScheme = document.documentElement.getAttribute('data-color-scheme');
        if (colorScheme === 'auto') {
            // Auto color scheme is handled by CSS media queries
            console.log('Auto color scheme enabled');
        }

        // Add smooth scrolling
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // Add loading states for images
        const images = document.querySelectorAll('img');
        images.forEach(img => {
            img.addEventListener('load', function() {
                this.classList.add('loaded');
            });
            
            if (img.complete) {
                img.classList.add('loaded');
            }
        });

        // Add reading progress indicator
        if (document.body.classList.contains('post-template')) {
            addReadingProgress();
        }
    }

    // Reading progress indicator
    function addReadingProgress() {
        const progressBar = document.createElement('div');
        progressBar.className = 'reading-progress';
        progressBar.innerHTML = '<div class="reading-progress-bar"></div>';
        document.body.appendChild(progressBar);

        const bar = progressBar.querySelector('.reading-progress-bar');
        
        window.addEventListener('scroll', () => {
            const scrollTop = window.pageYOffset;
            const docHeight = document.body.scrollHeight - window.innerHeight;
            const scrollPercent = (scrollTop / docHeight) * 100;
            bar.style.width = scrollPercent + '%';
        });
    }

    // Initialize theme when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initTheme);
    } else {
        initTheme();
    }

    // Add some theme-specific styles via JavaScript
    const style = document.createElement('style');
    style.textContent = `
        .reading-progress {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 3px;
            background: rgba(0,0,0,0.1);
            z-index: 1000;
        }
        
        .reading-progress-bar {
            height: 100%;
            background: var(--ghost-accent-color);
            width: 0%;
            transition: width 0.1s ease;
        }
        
        img {
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        img.loaded {
            opacity: 1;
        }
    `;
    document.head.appendChild(style);

})();