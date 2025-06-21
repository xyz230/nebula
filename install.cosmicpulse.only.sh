#!/bin/bash

# CosmicPulse Theme Installer for Pterodactyl Panel
# Version: 1.0.0
# Compatible with Blueprint Extension System

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Animation function
animate_text() {
    local text="$1"
    local delay=0.05
    for ((i=0; i<${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep $delay
    done
    echo
}

# Logo and intro
show_intro() {
    clear
    echo -e "${PURPLE}"
    echo "  ╔═══════════════════════════════════════════════════════════════╗"
    echo "  ║                                                               ║"
    echo "  ║    ██████╗ ██████╗ ███████╗███╗   ███╗██╗ ██████╗            ║"
    echo "  ║   ██╔════╝██╔═══██╗██╔════╝████╗ ████║██║██╔════╝            ║"
    echo "  ║   ██║     ██║   ██║███████╗██╔████╔██║██║██║                 ║"
    echo "  ║   ██║     ██║   ██║╚════██║██║╚██╔╝██║██║██║                 ║"
    echo "  ║   ╚██████╗╚██████╔╝███████║██║ ╚═╝ ██║██║╚██████╗            ║"
    echo "  ║    ╚═════╝ ╚═════╝ ╚══════╝╚═╝     ╚═╝╚═╝ ╚═════╝            ║"
    echo "  ║                                                               ║"
    echo "  ║   ██████╗ ██╗   ██╗██╗     ███████╗███████╗                  ║"
    echo "  ║   ██╔══██╗██║   ██║██║     ██╔════╝██╔════╝                  ║"
    echo "  ║   ██████╔╝██║   ██║██║     ███████╗█████╗                    ║"
    echo "  ║   ██╔═══╝ ██║   ██║██║     ╚════██║██╔══╝                    ║"
    echo "  ║   ██║     ╚██████╔╝███████╗███████║███████╗                  ║"
    echo "  ║   ╚═╝      ╚═════╝ ╚══════╝╚══════╝╚══════╝                  ║"
    echo "  ║                                                               ║"
    echo "  ║                    Premium Theme for Blueprint                ║"
    echo "  ╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${CYAN}"
    animate_text "🌌 Benvenuto nell'installer di CosmicPulse Theme"
    echo -e "${WHITE}Un tema spaziale moderno per il tuo pannello Pterodactyl${NC}"
    echo
    sleep 2
}

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        echo -e "${RED}❌ Questo script non deve essere eseguito come root!${NC}"
        echo -e "${YELLOW}💡 Eseguilo con un utente normale che ha accesso sudo${NC}"
        exit 1
    fi
}

# Check system requirements
check_requirements() {
    echo -e "${BLUE}🔍 Controllo requisiti di sistema...${NC}"
    
    # Check if Pterodactyl is installed
    if [ ! -d "/var/www/pterodactyl" ]; then
        echo -e "${RED}❌ Pterodactyl Panel non trovato in /var/www/pterodactyl${NC}"
        echo -e "${YELLOW}💡 Assicurati che Pterodactyl sia installato correttamente${NC}"
        exit 1
    fi
    
    # Check if Blueprint is installed
    if [ ! -f "/var/www/pterodactyl/blueprint.sh" ]; then
        echo -e "${RED}❌ Blueprint non trovato!${NC}"
        echo -e "${YELLOW}💡 Blueprint è richiesto per installare questo tema${NC}"
        echo -e "${WHITE}📥 Installando Blueprint automaticamente...${NC}"
        install_blueprint
    fi
    
    # Check required commands
    local commands=("curl" "unzip" "php" "composer")
    for cmd in "${commands[@]}"; do
        if ! command -v $cmd &> /dev/null; then
            echo -e "${RED}❌ $cmd non trovato${NC}"
            exit 1
        fi
    done
    
    echo -e "${GREEN}✅ Tutti i requisiti soddisfatti${NC}"
}

# Install Blueprint if not present
install_blueprint() {
    echo -e "${BLUE}📦 Installando Blueprint...${NC}"
    cd /var/www/pterodactyl
    
    # Download Blueprint
    sudo curl -L https://raw.githubusercontent.com/BlueprintFramework/framework/main/scripts/install.sh -o blueprint_install.sh
    sudo chmod +x blueprint_install.sh
    sudo bash blueprint_install.sh
    
    echo -e "${GREEN}✅ Blueprint installato con successo${NC}"
}

# Create main theme files
create_theme_files() {
    local theme_dir="$1"
    
    # Create conf.yml
    cat > "$theme_dir/conf.yml" << 'EOF'
info:
  name: "CosmicPulse"
  description: "Un tema spaziale moderno con effetti cosmici e design futuristico"
  author: "CosmicPulse Team"
  version: "1.0.0"
  target: "indev"
  
admin:
  view: "/admin"
  controller: "/admin"
  admin: true
  
requests:
  routers:
    client: "CosmicPulseServiceProvider"
    admin: "CosmicPulseServiceProvider"
    
data:
  public: "public"
  console: false
  database: false
  
export:
  console: false
  database: false
  zip: false
EOF

    # Create routes
    mkdir -p "$theme_dir/routes"
    cat > "$theme_dir/routes/web.php" << 'EOF'
<?php

use Illuminate\Support\Facades\Route;

Route::get('/cosmicpulse', function () {
    return response()->json(['status' => 'CosmicPulse Theme Active']);
});
EOF
}

# Create CSS files
create_css_files() {
    local theme_dir="$1"
    mkdir -p "$theme_dir/public/css"
    
    # Main theme CSS
    cat > "$theme_dir/public/css/cosmicpulse.css" << 'EOF'
/* CosmicPulse Theme - Cosmic Space Design */

:root {
    --cosmic-primary: #1a0d2e;
    --cosmic-secondary: #16213e;
    --cosmic-accent: #0f3460;
    --cosmic-highlight: #533483;
    --cosmic-purple: #7209b7;
    --cosmic-blue: #2d82b7;
    --cosmic-cyan: #42e2b8;
    --cosmic-pink: #f72585;
    --cosmic-orange: #fb8500;
    --cosmic-dark: #0a0a0f;
    --cosmic-light: #ffffff;
    --cosmic-gray: rgba(255, 255, 255, 0.1);
}

/* Global Styles */
* {
    box-sizing: border-box;
}

body {
    background: linear-gradient(135deg, var(--cosmic-dark) 0%, var(--cosmic-primary) 50%, var(--cosmic-secondary) 100%);
    background-attachment: fixed;
    color: var(--cosmic-light);
    font-family: 'Inter', 'Segoe UI', sans-serif;
    margin: 0;
    padding: 0;
    min-height: 100vh;
    overflow-x: hidden;
}

/* Animated background */
body::before {
    content: '';
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: 
        radial-gradient(circle at 20% 50%, rgba(120, 9, 183, 0.3) 0%, transparent 50%),
        radial-gradient(circle at 80% 20%, rgba(45, 130, 183, 0.3) 0%, transparent 50%),
        radial-gradient(circle at 40% 80%, rgba(66, 226, 184, 0.2) 0%, transparent 50%);
    animation: cosmicPulse 20s ease-in-out infinite;
    z-index: -1;
}

@keyframes cosmicPulse {
    0%, 100% { opacity: 0.3; }
    50% { opacity: 0.8; }
}

/* Navigation */
.navbar, nav {
    background: rgba(26, 13, 46, 0.9) !important;
    backdrop-filter: blur(10px);
    border-bottom: 1px solid var(--cosmic-gray);
    box-shadow: 0 4px 20px rgba(120, 9, 183, 0.3);
}

.navbar-brand, .nav-link {
    color: var(--cosmic-light) !important;
    transition: all 0.3s ease;
}

.nav-link:hover {
    color: var(--cosmic-cyan) !important;
    text-shadow: 0 0 10px var(--cosmic-cyan);
}

/* Cards and Panels */
.card, .panel {
    background: rgba(22, 33, 62, 0.9) !important;
    border: 1px solid var(--cosmic-gray);
    border-radius: 15px;
    backdrop-filter: blur(10px);
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.card:hover, .panel:hover {
    transform: translateY(-5px);
    box-shadow: 0 15px 40px rgba(120, 9, 183, 0.4);
}

.card-header {
    background: linear-gradient(45deg, var(--cosmic-purple), var(--cosmic-blue)) !important;
    border-bottom: none;
    color: var(--cosmic-light);
    font-weight: 600;
}

/* Buttons */
.btn {
    border-radius: 25px;
    font-weight: 500;
    text-transform: uppercase;
    letter-spacing: 1px;
    transition: all 0.3s ease;
    position: relative;
    overflow: hidden;
}

.btn-primary {
    background: linear-gradient(45deg, var(--cosmic-purple), var(--cosmic-pink));
    border: none;
    box-shadow: 0 4px 15px rgba(120, 9, 183, 0.4);
}

.btn-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 25px rgba(120, 9, 183, 0.6);
}

/* Login Form */
.login-container {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    position: relative;
}

.login-card {
    background: rgba(22, 33, 62, 0.95);
    border: 1px solid var(--cosmic-purple);
    border-radius: 20px;
    padding: 40px;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
    backdrop-filter: blur(15px);
    max-width: 400px;
    width: 100%;
    position: relative;
    overflow: hidden;
}

.login-logo h1 {
    background: linear-gradient(45deg, var(--cosmic-purple), var(--cosmic-cyan));
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    font-size: 2.5rem;
    font-weight: 700;
    margin: 0;
    text-shadow: 0 0 20px rgba(120, 9, 183, 0.5);
}

/* Form Controls */
.form-control {
    background: rgba(255, 255, 255, 0.1) !important;
    border: 1px solid var(--cosmic-gray);
    border-radius: 10px;
    color: var(--cosmic-light);
    padding: 12px 15px;
    transition: all 0.3s ease;
}

.form-control:focus {
    background: rgba(255, 255, 255, 0.15) !important;
    border-color: var(--cosmic-cyan);
    box-shadow: 0 0 20px rgba(66, 226, 184, 0.3);
    color: var(--cosmic-light);
}

/* Responsive Design */
@media (max-width: 768px) {
    .login-card {
        margin: 20px;
        padding: 30px 20px;
    }
    
    .login-logo h1 {
        font-size: 2rem;
    }
}
EOF
}

# Create JavaScript files
create_js_files() {
    local theme_dir="$1"
    mkdir -p "$theme_dir/public/js"
    
    # Main theme JavaScript
    cat > "$theme_dir/public/js/cosmicpulse.js" << 'EOF'
// CosmicPulse Theme JavaScript
document.addEventListener('DOMContentLoaded', function() {
    initializeCosmicEffects();
    initializeAnimations();
});

// Initialize cosmic particle effects
function initializeCosmicEffects() {
    createParticles();
}

// Create floating particles
function createParticles() {
    const particlesContainer = document.createElement('div');
    particlesContainer.className = 'cosmic-particles';
    document.body.appendChild(particlesContainer);
    
    for (let i = 0; i < 30; i++) {
        const particle = document.createElement('div');
        particle.style.cssText = `
            position: absolute;
            width: 2px;
            height: 2px;
            background: #42e2b8;
            border-radius: 50%;
            left: ${Math.random() * 100}%;
            top: ${Math.random() * 100}%;
            animation: float ${Math.random() * 3 + 3}s ease-in-out infinite;
            animation-delay: ${Math.random() * 6}s;
        `;
        particlesContainer.appendChild(particle);
    }
}

// Initialize page animations
function initializeAnimations() {
    const cards = document.querySelectorAll('.card, .panel');
    
    cards.forEach((card, index) => {
        card.style.animationDelay = `${index * 0.1}s`;
        card.classList.add('fade-in-up');
    });
}

// Add CSS animations
const style = document.createElement('style');
style.textContent = `
    @keyframes float {
        0%, 100% { transform: translateY(0px) rotate(0deg); opacity: 0; }
        50% { transform: translateY(-20px) rotate(180deg); opacity: 1; }
    }
    
    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    
    .fade-in-up {
        animation: fadeInUp 0.8s ease-out;
    }
`;
document.head.appendChild(style);
EOF
}

# Create config files
create_config_files() {
    local theme_dir="$1"
    
    # Create Blueprint extension config
    mkdir -p "$theme_dir/blueprint"
    cat > "$theme_dir/blueprint/extension.json" << 'EOF'
{
    "name": "CosmicPulse",
    "version": "1.0.0",
    "description": "Un tema spaziale moderno con effetti cosmici",
    "author": "CosmicPulse Team",
    "website": "https://github.com/cosmicpulse/theme",
    "pterodactyl": ">=1.0.0",
    "blueprint": ">=1.0.0",
    "type": "theme",
    "license": "MIT",
    "tags": ["theme", "cosmic", "space", "modern"],
    "icon": "🌌",
    "files": {
        "css": ["public/css/cosmicpulse.css"],
        "js": ["public/js/cosmicpulse.js"]
    }
}
EOF

    echo -e "${GREEN}✅ File di configurazione creati${NC}"
}

# Create theme structure
create_theme_structure() {
    echo -e "${BLUE}🏗️ Creando struttura del tema...${NC}"
    
    local theme_dir="/tmp/cosmicpulse_theme"
    # Fix permission issues
    sudo rm -rf $theme_dir 2>/dev/null || true
    mkdir -p $theme_dir
    
    # Create main theme files
    create_theme_files $theme_dir
    create_css_files $theme_dir
    create_js_files $theme_dir
    create_config_files $theme_dir
    
    echo -e "${GREEN}✅ Struttura tema creata${NC}"
}

# Install theme
install_theme() {
    echo -e "${BLUE}🚀 Installando CosmicPulse Theme...${NC}"
    
    local theme_dir="/tmp/cosmicpulse_theme"
    local pterodactyl_dir="/var/www/pterodactyl"
    
    # Create theme directory in pterodactyl
    sudo mkdir -p "$pterodactyl_dir/public/themes/cosmicpulse"
    
    # Copy files
    echo -e "${YELLOW}📋 Copiando file del tema...${NC}"
    sudo cp -r "$theme_dir/public/"* "$pterodactyl_dir/public/themes/cosmicpulse/"
    
    # Set proper permissions
    sudo chown -R www-data:www-data "$pterodactyl_dir/public/themes/cosmicpulse"
    sudo chmod -R 755 "$pterodactyl_dir/public/themes/cosmicpulse"
    
    echo -e "${GREEN}✅ File del tema installati${NC}"
}

# Apply theme
apply_theme() {
    echo -e "${BLUE}🎨 Applicando CosmicPulse Theme...${NC}"
    
    local pterodactyl_dir="/var/www/pterodactyl"
    
    # Create custom CSS injection
    cat > "/tmp/cosmicpulse_inject.css" << 'EOF'
/* CosmicPulse Theme Auto-Injection */
@import url('/themes/cosmicpulse/css/cosmicpulse.css');

/* Additional global overrides */
body {
    font-family: 'Inter', sans-serif !important;
}

.navbar-brand {
    font-weight: 700;
    text-shadow: 0 0 10px rgba(120, 9, 183, 0.5);
}

/* Ensure theme loads on all pages */
html {
    background: linear-gradient(135deg, #0a0a0f 0%, #1a0d2e 50%, #16213e 100%);
    min-height: 100vh;
}
EOF

    # Inject CSS into main layout
    if [ -f "$pterodactyl_dir/resources/views/layouts/admin.blade.php" ]; then
        sudo sed -i '/<\/head>/i\    <link href="{{ asset('"'"'themes/cosmicpulse/css/cosmicpulse.css'"'"') }}" rel="stylesheet">' "$pterodactyl_dir/resources/views/layouts/admin.blade.php"
    fi
    
    if [ -f "$pterodactyl_dir/resources/views/templates/wrapper.blade.php" ]; then
        sudo sed -i '/<\/head>/i\    <link href="{{ asset('"'"'themes/cosmicpulse/css/cosmicpulse.css'"'"') }}" rel="stylesheet">' "$pterodactyl_dir/resources/views/templates/wrapper.blade.php"
    fi
    
    # Copy inject CSS
    sudo cp "/tmp/cosmicpulse_inject.css" "$pterodactyl_dir/public/themes/cosmicpulse/css/"
    
    echo -e "${GREEN}✅ Tema applicato con successo${NC}"
}

# Clear cache
clear_cache() {
    echo -e "${BLUE}🧹 Pulendo cache...${NC}"
    
    cd /var/www/pterodactyl
    sudo php artisan config:clear
    sudo php artisan cache:clear
    sudo php artisan view:clear
    sudo php artisan route:clear
    
    echo -e "${GREEN}✅ Cache pulita${NC}"
}

# Show completion message
show_completion() {
    clear
    echo -e "${PURPLE}"
    echo "  ╔═══════════════════════════════════════════════════════════════╗"
    echo "  ║                                                               ║"
    echo "  ║                 🌌 INSTALLAZIONE COMPLETATA! 🌌                ║"
    echo "  ║                                                               ║"
    echo "  ║   CosmicPulse Theme è stato installato con successo!          ║"
    echo "  ║                                                               ║"
    echo "  ║   Funzionalità installate:                                    ║"
    echo "  ║   ✅ Design spaziale con effetti cosmici                      ║"
    echo "  ║   ✅ Animazioni fluide e transizioni                         ║"
    echo "  ║   ✅ Login personalizzato                                     ║"
    echo "  ║   ✅ Effetti particellari                                     ║"
    echo "  ║   ✅ Interfaccia completamente funzionante                    ║"
    echo "  ║                                                               ║"
    echo "  ║   Riavvia il tuo browser e goditi il nuovo tema!              ║"
    echo "  ║                                                               ║"
    echo "  ╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${CYAN}🎉 Installazione completata con successo!${NC}"
    echo -e "${WHITE}📱 Il tema è ora attivo sul tuo pannello Pterodactyl${NC}"
    echo -e "${YELLOW}🔄 Ricarica la pagina per vedere il nuovo tema${NC}"
    echo
    echo -e "${GREEN}Grazie per aver scelto CosmicPulse Theme!${NC}"
}

# Main installation process
main() {
    show_intro
    
    echo -e "${CYAN}🚀 Iniziando l'installazione di CosmicPulse Theme...${NC}"
    echo
    
    # Initial cleanup
    echo -e "${YELLOW}🧹 Pulizia file temporanei precedenti...${NC}"
    sudo rm -rf /tmp/cosmicpulse_theme 2>/dev/null || true
    sudo rm -f /tmp/cosmicpulse_* 2>/dev/null || true
    
    check_root
    check_requirements
    create_theme_structure
    install_theme
    apply_theme
    clear_cache
    
    # Cleanup with proper permissions
    sudo rm -rf /tmp/cosmicpulse_theme 2>/dev/null || true
    sudo rm -f /tmp/cosmicpulse_*.css 2>/dev/null || true
    sudo rm -f /tmp/cosmicpulse_*.php 2>/dev/null || true
    
    show_completion
}

# Error handling
trap 'echo -e "${RED}❌ Errore durante l'\''installazione!${NC}"; sudo rm -rf /tmp/cosmicpulse_theme 2>/dev/null || true; exit 1' ERR

# Run main function
main "$@"
