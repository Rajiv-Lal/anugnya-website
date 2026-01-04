/* ============================================
   ANUGNYA HOLISTIC CARE - SHARED JAVASCRIPT
   Version: 3.0 Multi-page
   ============================================ */

// ==================================================
// CONFIGURATION
// ==================================================

const CONFIG = {
    whatsappNumber: '918106248800',
    whatsappMessage: 'Hi, I found you online and would like to know more about your cancer support services.',
    googleScriptUrl: 'https://script.google.com/macros/s/AKfycbwqQsPq-7yDEww-D14LCb1g4k-vOauWjfLVLllQdSRVFweiQqM4EI3Nam2ew97Wsdf5/exec',
    calendlyUrl: 'https://calendly.com/anugnyaholisticcare/welcome'
};

// ==================================================
// MOBILE NAVIGATION
// ==================================================

function toggleMobileNav() {
    const nav = document.getElementById('mainNav');
    if (nav) {
        nav.classList.toggle('active');
    }
}

function closeMobileNav() {
    const nav = document.getElementById('mainNav');
    if (nav) {
        nav.classList.remove('active');
    }
}

// Close mobile nav when clicking outside
document.addEventListener('click', function(event) {
    const nav = document.getElementById('mainNav');
    const toggle = document.querySelector('.nav-toggle');
    
    if (nav && toggle) {
        if (!nav.contains(event.target) && !toggle.contains(event.target)) {
            nav.classList.remove('active');
        }
    }
});

// Close mobile nav when clicking a link
document.addEventListener('DOMContentLoaded', function() {
    const navLinks = document.querySelectorAll('.nav a');
    navLinks.forEach(link => {
        link.addEventListener('click', closeMobileNav);
    });
});

// ==================================================
// FAQ ACCORDION
// ==================================================

function initFaqAccordion() {
    const faqItems = document.querySelectorAll('.faq-item');
    
    faqItems.forEach(item => {
        const question = item.querySelector('.faq-question');
        
        if (question) {
            question.addEventListener('click', function() {
                // Close all other items
                faqItems.forEach(otherItem => {
                    if (otherItem !== item) {
                        otherItem.classList.remove('active');
                    }
                });
                
                // Toggle current item
                item.classList.toggle('active');
            });
        }
    });
}

// ==================================================
// VIDEO MODAL
// ==================================================

let currentVideoModal = null;

function openVideoModal(videoId, title) {
    // Create modal if it doesn't exist
    let modal = document.getElementById('videoModal');
    
    if (!modal) {
        modal = document.createElement('div');
        modal.id = 'videoModal';
        modal.className = 'modal-overlay';
        modal.innerHTML = `
            <div class="modal" style="max-width: 800px;">
                <div class="modal-header">
                    <h3 id="videoModalTitle"></h3>
                    <button class="modal-close" onclick="closeVideoModal()">&times;</button>
                </div>
                <div class="modal-body" style="padding: 0;">
                    <div class="video-modal-content" id="videoModalContent"></div>
                </div>
            </div>
        `;
        document.body.appendChild(modal);
    }
    
    // Set content
    document.getElementById('videoModalTitle').textContent = title || 'Video';
    document.getElementById('videoModalContent').innerHTML = `
        <div style="position: relative; padding-bottom: 56.25%; height: 0;">
            <iframe 
                style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"
                src="https://www.youtube.com/embed/${videoId}?autoplay=1" 
                frameborder="0" 
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
                allowfullscreen>
            </iframe>
        </div>
    `;
    
    modal.classList.add('active');
    document.body.style.overflow = 'hidden';
    currentVideoModal = modal;
}

function closeVideoModal() {
    const modal = document.getElementById('videoModal');
    if (modal) {
        modal.classList.remove('active');
        document.getElementById('videoModalContent').innerHTML = '';
        document.body.style.overflow = '';
    }
}

// Close modal on overlay click
document.addEventListener('click', function(event) {
    if (event.target.classList.contains('modal-overlay')) {
        closeVideoModal();
        closeBookingModal();
    }
});

// Close modal on Escape key
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        closeVideoModal();
        closeBookingModal();
    }
});

// ==================================================
// BOOKING MODAL
// ==================================================

function openBookingModal() {
    const modal = document.getElementById('bookingModal');
    if (modal) {
        modal.classList.add('active');
        document.body.style.overflow = 'hidden';
    }
}

function closeBookingModal() {
    const modal = document.getElementById('bookingModal');
    if (modal) {
        modal.classList.remove('active');
        document.body.style.overflow = '';
    }
}

// ==================================================
// WHATSAPP
// ==================================================

function openWhatsApp(customMessage = null) {
    const message = customMessage || CONFIG.whatsappMessage;
    const encodedMessage = encodeURIComponent(message);
    const url = `https://wa.me/${CONFIG.whatsappNumber}?text=${encodedMessage}`;
    window.open(url, '_blank');
}

// ==================================================
// SERVICE DETAILS
// ==================================================

function showServiceDetail(serviceId) {
    // Hide all service details
    document.querySelectorAll('.service-details').forEach(detail => {
        detail.classList.remove('active');
    });
    
    // Show selected service detail
    const detail = document.getElementById(`service-${serviceId}`);
    if (detail) {
        detail.classList.add('active');
        
        // Scroll to detail
        setTimeout(() => {
            detail.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
        }, 100);
    }
}

function closeServiceDetail() {
    document.querySelectorAll('.service-details').forEach(detail => {
        detail.classList.remove('active');
    });
}

// ==================================================
// FORM SUBMISSION
// ==================================================

async function submitForm(event, formType) {
    event.preventDefault();
    
    const form = event.target;
    const formData = new FormData(form);
    const data = Object.fromEntries(formData.entries());
    data.formType = formType;
    data.timestamp = new Date().toISOString();
    
    try {
        const response = await fetch(CONFIG.googleScriptUrl, {
            method: 'POST',
            mode: 'no-cors',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data)
        });
        
        // Show success message
        showSuccessMessage();
        form.reset();
        
    } catch (error) {
        console.error('Form submission error:', error);
        alert('There was an error submitting your form. Please try again or contact us via WhatsApp.');
    }
}

function showSuccessMessage() {
    const successDiv = document.getElementById('success-message');
    if (successDiv) {
        successDiv.style.display = 'block';
        successDiv.scrollIntoView({ behavior: 'smooth' });
    }
}

// ==================================================
// CALENDLY INTEGRATION
// ==================================================

function openCalendly() {
    if (typeof Calendly !== 'undefined') {
        Calendly.initPopupWidget({
            url: CONFIG.calendlyUrl
        });
    } else {
        window.open(CONFIG.calendlyUrl, '_blank');
    }
}

// ==================================================
// SUPPORT GROUP
// ==================================================

function joinSupportGroup() {
    const message = 'Hi, I would like to join the Cancer Support Group.';
    openWhatsApp(message);
}

// ==================================================
// EXTRACT YOUTUBE VIDEO ID
// ==================================================

function getYouTubeVideoId(url) {
    const regExp = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|&v=)([^#&?]*).*/;
    const match = url.match(regExp);
    return (match && match[2].length === 11) ? match[2] : null;
}

// ==================================================
// SET ACTIVE NAV LINK
// ==================================================

function setActiveNavLink() {
    const currentPage = window.location.pathname.split('/').pop() || 'index.html';
    const navLinks = document.querySelectorAll('.nav a');
    
    navLinks.forEach(link => {
        const href = link.getAttribute('href');
        if (href === currentPage || (currentPage === '' && href === 'index.html')) {
            link.classList.add('active');
        } else {
            link.classList.remove('active');
        }
    });
}

// ==================================================
// INITIALIZATION
// ==================================================

document.addEventListener('DOMContentLoaded', function() {
    // Initialize FAQ accordion if on FAQ page
    if (document.querySelector('.faq-container')) {
        initFaqAccordion();
    }
    
    // Set active nav link
    setActiveNavLink();
    
    // Smooth scroll for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({ behavior: 'smooth' });
            }
        });
    });
});
