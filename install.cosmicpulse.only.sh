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
        "js": ["public/js/cosmicpulse.js"],
        "views": ["resources/views/"]
    },
    "dependencies": [],
    "installation": {
        "requirements": ["php >= 8.0", "pterodactyl >= 1.0.0"],
        "steps": [
            "Copia dei file CSS e JS",
            "Applicazione del tema",
            "Configurazione completata"
        ]
    }
}
EOF

    # Create views directory structure
    mkdir -p "$theme_dir/resources/views/auth"
    mkdir -p "$theme_dir/resources/views/layouts"
    mkdir -p "$theme_dir/resources/views/partials"
    
    # Create login view
    cat > "$theme_dir/resources/views/auth/login.blade.php" << 'EOF'
@extends('layouts.auth')

@section('title', 'Login')

@section('content')
<div class="login-container">
    <div class="cosmic-particles"></div>
    <div class="login-card">
        <div class="login-logo">
            <h1>CosmicPulse</h1>
            <p class="text-muted">Accedi al tuo universo</p>
        </div>
        
        <form method="POST" action="{{ route('auth.login') }}">
            @csrf
            
            <div class="form-group mb-3">
                <label for="user">{{ __('auth.username_or_email') }}</label>
                <input type="text" 
                       class="form-control @error('user') is-invalid @enderror" 
                       id="user" 
                       name="user" 
                       value="{{ old('user') }}" 
                       placeholder="Inserisci username o email"
                       required 
                       autofocus>
                @error('user')
                    <div class="invalid-feedback">{{ $message }}</div>
                @enderror
            </div>
            
            <div class="form-group mb-3">
                <label for="password">{{ __('auth.password') }}</label>
                <input type="password" 
                       class="form-control @error('password') is-invalid @enderror" 
                       id="password" 
                       name="password" 
                       placeholder="Inserisci la password"
                       required>
                @error('password')
                    <div class="invalid-feedback">{{ $message }}</div>
                @enderror
            </div>
            
            <div class="form-group mb-4">
                <div class="form-check">
                    <input type="checkbox" class="form-check-input" id="remember" name="remember">
                    <label class="form-check-label" for="remember">
                        {{ __('auth.remember_me') }}
                    </label>
                </div>
            </div>
            
            <button type="submit" class="btn btn-primary btn-block mb-3">
                <i class="fas fa-sign-in-alt"></i> {{ __('auth.sign_in') }}
            </button>
            
            <div class="text-center">
                <a href="{{ route('auth.password') }}" class="text-muted">
                    {{ __('auth.forgot_password') }}
                </a>
            </div>
        </form>
    </div>
</div>
@endsection

@section('scripts')
<script>
    // Add extra cosmic effects for login page
    document.addEventListener('DOMContentLoaded', function() {
        // Add glow effect to login form
        const loginCard = document.querySelector('.login-card');
        if (loginCard) {
            loginCard.style.animation = 'cosmic-glow 3s ease-in-out infinite alternate';
        }
        
        // Form submission effect
        const form = document.querySelector('form');
        if (form) {
            form.addEventListener('submit', function() {
                const submitBtn = this.querySelector('button[type="submit"]');
                submitBtn.innerHTML = '<div class="cosmic-loader"></div> Connessione in corso...';
                submitBtn.disabled = true;
            });
        }
    });
</script>
@endsection
EOF

    # Create main layout
    cat > "$theme_dir/resources/views/layouts/app.blade.php" << 'EOF'
<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>@yield('title') - {{ config('app.name', 'Pterodactyl') }}</title>
    
    <!-- Cosmic Theme CSS -->
    <link href="{{ asset('themes/cosmicpulse/css/cosmicpulse.css') }}" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    @yield('styles')
</head>
<body class="cosmic-theme">
    <!-- Cosmic Background -->
    <div class="cosmic-particles"></div>
    
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="{{ route('index') }}">
                <i class="fas fa-rocket"></i> CosmicPulse
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="{{ route('index') }}">
                            <i class="fas fa-home"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="{{ route('server.index') }}">
                            <i class="fas fa-server"></i> Server
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="{{ route('account') }}">
                            <i class="fas fa-user"></i> Account
                        </a>
                    </li>
                </ul>
                
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user-circle"></i> {{ Auth::user()->name_first }}
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="{{ route('account') }}">Account</a></li>
                            <li><a class="dropdown-item" href="{{ route('account.security') }}">Sicurezza</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="{{ route('auth.logout') }}">Logout</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    
    <!-- Main Content -->
    <main class="content-wrapper">
        <div class="container-fluid py-4">
            @yield('content')
        </div>
    </main>
    
    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="text-center">
                <p>&copy; {{ date('Y') }} CosmicPulse Theme. Powered by Pterodactyl Panel.</p>
            </div>
        </div>
    </footer>
    
    <!-- Scripts -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script src="{{ asset('themes/cosmicpulse/js/cosmicpulse.js') }}"></script>
    @yield('scripts')
</body>
</html>
EOF

    # Create auth layout
    cat > "$theme_dir/resources/views/layouts/auth.blade.php" << 'EOF'
<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>@yield('title') - {{ config('app.name', 'Pterodactyl') }}</title>
    
    <!-- Cosmic Theme CSS -->
    <link href="{{ asset('themes/cosmicpulse/css/cosmicpulse.css') }}" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        @keyframes cosmic-glow {
            0% { box-shadow: 0 20px 60px rgba(120, 9, 183, 0.3); }
            100% { box-shadow: 0 20px 60px rgba(66, 226, 184, 0.3); }
        }
    </style>
    
    @yield('styles')
</head>
<body class="cosmic-theme">
    @yield('content')
    
    <!-- Scripts -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script src="{{ asset('themes/cosmicpulse/js/cosmicpulse.js') }}"></script>
    @yield('scripts')
</body>
</html>
EOF

    echo -e "${GREEN}✅ File di configurazione creati${NC}"
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
    
    # Copy views if they exist
    if [ -d "$theme_dir/resources/views" ]; then
        sudo mkdir -p "$pterodactyl_dir/resources/views/themes/cosmicpulse"
        sudo cp -r "$theme_dir/resources/views/"* "$pterodactyl_dir/resources/views/themes/cosmicpulse/"
    fi
    
    # Set proper permissions
    sudo chown -R www-data:www-data "$pterodactyl_dir/public/themes/cosmicpulse"
    sudo chmod -R 755 "$pterodactyl_dir/public/themes/cosmicpulse"
    
    echo -e "${GREEN}✅ File del tema installati${NC}"
}

# Configure theme
configure_theme() {
    echo -e "${BLUE}⚙️ Configurando CosmicPulse Theme...${NC}"
    
    local pterodactyl_dir="/var/www/pterodactyl"
    
    # Create theme configuration
    cat > "/tmp/cosmicpulse_config.php" << 'EOF'
<?php

return [
    'name' => 'CosmicPulse',
    'version' => '1.0.0',
    'author' => 'CosmicPulse Team',
    'description' => 'Un tema spaziale moderno con effetti cosmici',
    
    'assets' => [
        'css' => [
            'themes/cosmicpulse/css/cosmicpulse.css'
        ],
        'js' => [
            'themes/cosmicpulse/js/cosmicpulse.js'
        ]
    ],
    
    'settings' => [
        'particle_effects' => true,
        'cosmic_glow' => true,
        'cursor_trail' => true,
        'animations' => true,
        'color_scheme' => 'cosmic'
    ]
];
EOF

    sudo mv "/tmp/cosmicpulse_config.php" "$pterodactyl_dir/config/themes/cosmicpulse.php"
    sudo chown www-data:www-data "$pterodactyl_dir/config/themes/cosmicpulse.php"
    
    echo -e "${GREEN}✅ Tema configurato${NC}"
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
    echo "  ║   ✅ Cursore luminoso                                         ║"
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
    configure_theme
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

/* Particles effect */
.cosmic-particles {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    pointer-events: none;
    z-index: -1;
}

.particle {
    position: absolute;
    width: 2px;
    height: 2px;
    background: var(--cosmic-cyan);
    border-radius: 50%;
    animation: float 6s ease-in-out infinite;
}

@keyframes float {
    0%, 100% { transform: translateY(0px) rotate(0deg); opacity: 0; }
    50% { transform: translateY(-20px) rotate(180deg); opacity: 1; }
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

.btn::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
    transition: left 0.5s ease;
}

.btn:hover::before {
    left: 100%;
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

.btn-secondary {
    background: linear-gradient(45deg, var(--cosmic-blue), var(--cosmic-cyan));
    border: none;
    box-shadow: 0 4px 15px rgba(45, 130, 183, 0.4);
}

.btn-success {
    background: linear-gradient(45deg, var(--cosmic-cyan), #00ff88);
    border: none;
}

.btn-danger {
    background: linear-gradient(45deg, var(--cosmic-pink), #ff4757);
    border: none;
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

.login-card::before {
    content: '';
    position: absolute;
    top: -50%;
    left: -50%;
    width: 200%;
    height: 200%;
    background: conic-gradient(
        var(--cosmic-purple),
        var(--cosmic-blue),
        var(--cosmic-cyan),
        var(--cosmic-purple)
    );
    animation: rotate 20s linear infinite;
    z-index: -1;
}

.login-card::after {
    content: '';
    position: absolute;
    inset: 2px;
    background: rgba(22, 33, 62, 0.95);
    border-radius: 18px;
    z-index: -1;
}

@keyframes rotate {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}

.login-logo {
    text-align: center;
    margin-bottom: 30px;
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

.form-control::placeholder {
    color: rgba(255, 255, 255, 0.6);
}

/* Tables */
.table {
    background: rgba(22, 33, 62, 0.9);
    border-radius: 15px;
    overflow: hidden;
    border: 1px solid var(--cosmic-gray);
}

.table th {
    background: var(--cosmic-secondary);
    color: var(--cosmic-light);
    border-color: var(--cosmic-gray);
    font-weight: 600;
}

.table td {
    color: var(--cosmic-light);
    border-color: var(--cosmic-gray);
}

.table-striped tbody tr:nth-of-type(odd) {
    background: rgba(255, 255, 255, 0.05);
}

/* Progress Bars */
.progress {
    background: rgba(255, 255, 255, 0.1);
    border-radius: 10px;
    overflow: hidden;
}

.progress-bar {
    background: linear-gradient(45deg, var(--cosmic-purple), var(--cosmic-cyan));
    transition: width 0.6s ease;
}

/* Alerts */
.alert {
    border: none;
    border-radius: 15px;
    backdrop-filter: blur(10px);
}

.alert-success {
    background: rgba(66, 226, 184, 0.2);
    color: var(--cosmic-cyan);
    border: 1px solid var(--cosmic-cyan);
}

.alert-danger {
    background: rgba(247, 37, 133, 0.2);
    color: var(--cosmic-pink);
    border: 1px solid var(--cosmic-pink);
}

.alert-info {
    background: rgba(45, 130, 183, 0.2);
    color: var(--cosmic-blue);
    border: 1px solid var(--cosmic-blue);
}

/* Sidebar */
.sidebar {
    background: rgba(26, 13, 46, 0.95) !important;
    border-right: 1px solid var(--cosmic-gray);
    backdrop-filter: blur(10px);
}

.sidebar .nav-link {
    color: rgba(255, 255, 255, 0.8);
    transition: all 0.3s ease;
    border-radius: 10px;
    margin: 5px 10px;
}

.sidebar .nav-link:hover,
.sidebar .nav-link.active {
    background: linear-gradient(45deg, var(--cosmic-purple), var(--cosmic-blue));
    color: var(--cosmic-light);
    box-shadow: 0 4px 15px rgba(120, 9, 183, 0.4);
}

/* Content Area */
.content-wrapper {
    background: transparent;
    min-height: calc(100vh - 60px);
}

/* Footer */
.footer {
    background: rgba(26, 13, 46, 0.9);
    color: var(--cosmic-light);
    padding: 20px 0;
    border-top: 1px solid var(--cosmic-gray);
    text-align: center;
}

/* Responsive Design */
@media (max-width: 768px) {
    .login-card {
        margin: 20px;
        padding: 30px 20px;
    }
    
    .card {
        margin: 10px;
    }
    
    .login-logo h1 {
        font-size: 2rem;
    }
}

/* Custom Scrollbar */
::-webkit-scrollbar {
    width: 8px;
}

::-webkit-scrollbar-track {
    background: var(--cosmic-dark);
}

::-webkit-scrollbar-thumb {
    background: linear-gradient(45deg, var(--cosmic-purple), var(--cosmic-cyan));
    border-radius: 10px;
}

::-webkit-scrollbar-thumb:hover {
    background: linear-gradient(45deg, var(--cosmic-cyan), var(--cosmic-purple));
}

/* Loading Animation */
.cosmic-loader {
    display: inline-block;
    width: 40px;
    height: 40px;
    border: 3px solid rgba(255, 255, 255, 0.3);
    border-radius: 50%;
    border-top-color: var(--cosmic-cyan);
    animation: spin 1s ease-in-out infinite;
}

@keyframes spin {
    to { transform: rotate(360deg); }
}

/* Status Indicators */
.status-online {
    color: var(--cosmic-cyan) !important;
    text-shadow: 0 0 10px var(--cosmic-cyan);
}

.status-offline {
    color: var(--cosmic-pink) !important;
    text-shadow: 0 0 10px var(--cosmic-pink);
}

.status-starting {
    color: var(--cosmic-orange) !important;
    text-shadow: 0 0 10px var(--cosmic-orange);
}

/* Animations */
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

/* Console Terminal */
.console {
    background: var(--cosmic-dark) !important;
    border: 1px solid var(--cosmic-purple);
    border-radius: 10px;
    font-family: 'Courier New', monospace;
    color: var(--cosmic-cyan);
    padding: 20px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
}

.console pre {
    color: var(--cosmic-light);
    margin: 0;
}

/* Modal */
.modal-content {
    background: rgba(22, 33, 62, 0.95);
    border: 1px solid var(--cosmic-purple);
    border-radius: 15px;
    backdrop-filter: blur(15px);
}

.modal-header {
    border-bottom: 1px solid var(--cosmic-gray);
    background: linear-gradient(45deg, var(--cosmic-purple), var(--cosmic-blue));
}

.modal-footer {
    border-top: 1px solid var(--cosmic-gray);
}

/* Dropdown */
.dropdown-menu {
    background: rgba(22, 33, 62, 0.95);
    border: 1px solid var(--cosmic-gray);
    border-radius: 10px;
    backdrop-filter: blur(10px);
}

.dropdown-item {
    color: var(--cosmic-light);
    transition: all 0.3s ease;
}

.dropdown-item:hover {
    background: var(--cosmic-purple);
    color: var(--cosmic-light);
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
    initializeInteractions();
});

// Initialize cosmic particle effects
function initializeCosmicEffects() {
    createParticles();
    initializeGlowEffects();
}

// Create floating particles
function createParticles() {
    const particlesContainer = document.createElement('div');
    particlesContainer.className = 'cosmic-particles';
    document.body.appendChild(particlesContainer);
    
    for (let i = 0; i < 50; i++) {
        const particle = document.createElement('div');
        particle.className = 'particle';
        particle.style.left = Math.random() * 100 + '%';
        particle.style.top = Math.random() * 100 + '%';
        particle.style.animationDelay = Math.random() * 6 + 's';
        particle.style.animationDuration = (Math.random() * 3 + 3) + 's';
        particlesContainer.appendChild(particle);
    }
}

// Initialize glow effects
function initializeGlowEffects() {
    const buttons = document.querySelectorAll('.btn');
    buttons.forEach(btn => {
        btn.addEventListener('mouseenter', function() {
            this.style.boxShadow = '0 0 20px rgba(120, 9, 183, 0.8)';
        });
        
        btn.addEventListener('mouseleave', function() {
            this.style.boxShadow = '';
        });
    });
}

// Initialize page animations
function initializeAnimations() {
    const cards = document.querySelectorAll('.card, .panel');
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('fade-in-up');
            }
        });
    });
    
    cards.forEach(card => {
        observer.observe(card);
    });
}

// Initialize interactive elements
function initializeInteractions() {
    // Add ripple effect to buttons
    document.querySelectorAll('.btn').forEach(btn => {
        btn.addEventListener('click', createRipple);
    });
    
    // Add cosmic cursor trail
    initializeCursorTrail();
}

// Create ripple effect
function createRipple(event) {
    const button = event.currentTarget;
    const ripple = document.createElement('span');
    const rect = button.getBoundingClientRect();
    const size = Math.max(rect.width, rect.height);
    const x = event.clientX - rect.left - size / 2;
    const y = event.clientY - rect.top - size / 2;
    
    ripple.style.cssText = `
        position: absolute;
        width: ${size}px;
        height: ${size}px;
        left: ${x}px;
        top: ${y}px;
        background: rgba(255, 255, 255, 0.3);
        border-radius: 50%;
        transform: scale(0);
        animation: ripple 0.6s ease-out;
        pointer-events: none;
    `;
    
    button.style.position = 'relative';
    button.style.overflow = 'hidden';
    button.appendChild(ripple);
    
    setTimeout(() => {
        ripple.remove();
    }, 600);
}

// Add CSS for ripple animation
const style = document.createElement('style');
style.textContent = `
    @keyframes ripple {
        to {
            transform: scale(2);
            opacity: 0;
        }
    }
`;
document.head.appendChild(style);

// Initialize cursor trail
function initializeCursorTrail() {
    const trail = [];
    const trailLength = 20;
    
    for (let i = 0; i < trailLength; i++) {
        const dot = document.createElement('div');
        dot.style.cssText = `
            position: fixed;
            width: 4px;
            height: 4px;
            background: rgba(66, 226, 184, ${1 - i / trailLength});
            border-radius: 50%;
            pointer-events: none;
            z-index: 9999;
            transition: opacity 0.3s ease;
        `;
        document.body.appendChild(dot);
        trail.push(dot);
    }
    
    let mouseX = 0, mouseY = 0;
    let currentX = 0, currentY = 0;
    
    document.addEventListener('mousemove', (e) => {
        mouseX = e.clientX;
        mouseY = e.clientY;
    });
    
    function updateTrail() {
        currentX += (mouseX - currentX) * 0.1;
        currentY += (mouseY - currentY) * 0.1;
        
        trail.forEach((dot, index) => {
            const nextDot = trail[index + 1] || { offsetLeft: currentX, offsetTop: currentY };
            dot.style.left = nextDot.offsetLeft + 'px';
            dot.style.top = nextDot.offsetTop + 'px';
        });
        
        if (trail[0]) {
            trail[0].style.left = currentX + 'px';
            trail[0].style.top = currentY + 'px';
        }
        
        requestAnimationFrame(updateTrail);
    }
    
    updateTrail();
}

// Status indicators animation
function animateStatusIndicators() {
    const statusElements = document.querySelectorAll('.status-online, .status-offline, .status-starting');
    
    statusElements.forEach(element => {
        if (element.classList.contains('status-online')) {
            element.style.animation = 'pulse 2s ease-in-out infinite';
        }
    });
}

// Console typing effect
function initializeConsoleEffect() {
    const consoleElements = document.querySelectorAll('.console pre');
    
    consoleElements.forEach(console => {
        const text = console.textContent;
        console.textContent = '';
        
        let i = 0;
        const typeWriter = () => {
            if (i < text.length) {
                console.textContent += text.charAt(i);
                i++;
                setTimeout(typeWriter, 50);
            }
        };
        
        typeWriter();
    });
}

// Loading animation
function showCosmicLoader(element) {
    const loader = document.createElement('div');
    loader.className = 'cosmic-loader';
    element.appendChild(loader);
    return loader;
}

// Form validation with cosmic effects
function initializeFormValidation() {
    const forms = document.querySelectorAll('form');
    
    forms.forEach(form => {
        const inputs = form.querySelectorAll('input, textarea, select');
        
        inputs.forEach(input => {
            input.addEventListener('focus', function() {
                this.style.borderColor = 'var(--cosmic-cyan)';
                this.style.boxShadow = '0 0 20px rgba(66, 226, 184, 0.3)';
            });
            
            input.addEventListener('blur', function() {
                if (this.checkValidity()) {
                    this.style.borderColor = 'var(--cosmic-cyan)';
                } else {
                    this.style.borderColor = 'var(--cosmic-pink)';
                    this.style.boxShadow = '0 0 20px rgba(247, 37, 133, 0.3)';
                }
            });
        });
    });
}

// Initialize theme on page load
window.addEventListener('load', function() {
    animateStatusIndicators();
    initializeConsoleEffect();
    initializeFormValidation();
    
    // Add cosmic class to body
    document.body.classList.add('cosmic-theme');
    
    // Preload animations
    setTimeout(() => {
        document.body.style.opacity = '1';
        document.body.style.transition = 'opacity 0.5s ease-in-out';
    }, 100);
});
EOF
