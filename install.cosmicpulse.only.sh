#!/bin/bash

# CosmicPulse Theme Installer for Pterodactyl Blueprint
# Tema ispirato a Nebula con design spaziale e moderno
# Author: CosmicPulse Team
# Version: 1.0.0

set -e

# Colori per output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Banner ASCII
show_banner() {
    clear
    echo -e "${PURPLE}${BOLD}"
    echo "  ╔═══════════════════════════════════════════════════════════════╗"
    echo "  ║                                                               ║"
    echo "  ║    ██████╗ ██████╗ ███████╗███╗   ███╗██╗ ██████╗            ║"
    echo "  ║   ██╔══██╗██╔══██╗██╔════╝████╗ ████║██║██╔════╝            ║"
    echo "  ║   ██║  ██║██████╔╝█████╗  ██╔████╔██║██║██║                 ║"
    echo "  ║   ██║  ██║██╔══██╗██╔══╝  ██║╚██╔╝██║██║██║                 ║"
    echo "  ║   ██████╔╝██║  ██║███████╗██║ ╚═╝ ██║██║╚██████╗            ║"
    echo "  ║   ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚═╝ ╚═════╝            ║"
    echo "  ║                                                               ║"
    echo "  ║        ██████╗██╗   ██╗██╗     ███████╗███████╗               ║"
    echo "  ║       ██╔══██╗██║   ██║██║     ██╔════╝██╔════╝               ║"
    echo "  ║       ██████╔╝██║   ██║██║     ███████╗█████╗                 ║"
    echo "  ║       ██╔═══╝ ██║   ██║██║     ╚════██║██╔══╝                 ║"
    echo "  ║       ██║     ╚██████╔╝███████╗███████║███████╗               ║"
    echo "  ║       ╚═╝      ╚═════╝ ╚══════╝╚══════╝╚══════╝               ║"
    echo "  ║                                                               ║"
    echo "  ║              🌌 CosmicPulse Theme Installer 🌌                ║"
    echo "  ║                   Blueprint Extension                         ║"
    echo "  ║                                                               ║"
    echo "  ╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${CYAN}Installazione tema spaziale per Pterodactyl Panel${NC}"
    echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo
}

# Funzione per log con timestamp
log() {
    echo -e "${CYAN}[$(date +'%H:%M:%S')]${NC} $1"
}

# Funzione per errori
error() {
    echo -e "${RED}[ERRORE]${NC} $1" >&2
    exit 1
}

# Funzione per successi
success() {
    echo -e "${GREEN}[SUCCESSO]${NC} $1"
}

# Funzione per warning
warning() {
    echo -e "${YELLOW}[AVVISO]${NC} $1"
}

# Verifica permessi root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "Questo script deve essere eseguito come root (sudo)"
    fi
}

# Verifica installazione Blueprint
check_blueprint() {
    log "Verifico installazione Blueprint..."
    
    if ! command -v blueprint &> /dev/null; then
        error "Blueprint non è installato. Installa prima Blueprint."
    fi
    
    BLUEPRINT_VERSION=$(blueprint -v 2>/dev/null | head -n1 | cut -d' ' -f2 || echo "unknown")
    success "Blueprint trovato (versione: $BLUEPRINT_VERSION)"
}

# Verifica Pterodactyl
check_pterodactyl() {
    log "Verifico installazione Pterodactyl..."
    
    PTERODACTYL_PATH="/var/www/pterodactyl"
    if [[ ! -d "$PTERODACTYL_PATH" ]]; then
        error "Pterodactyl non trovato in $PTERODACTYL_PATH"
    fi
    
    success "Pterodactyl trovato in $PTERODACTYL_PATH"
}

# Crea struttura tema
create_theme_structure() {
    log "Creazione struttura tema CosmicPulse..."
    
    THEME_DIR="/tmp/cosmicpulse_theme"
    rm -rf "$THEME_DIR"
    mkdir -p "$THEME_DIR"
    
    # Crea conf.yml
    cat > "$THEME_DIR/conf.yml" << 'EOF'
info:
  name: "CosmicPulse"
  description: "Tema spaziale moderno ispirato a Nebula per Pterodactyl Panel"
  author: "CosmicPulse Team"
  version: "1.0.0"
  target: "indev"
  
admin:
  view: "admin/extensions/cosmicpulse/index.blade.php"
  controller: "Admin/Extensions/CosmicPulse/CosmicPulseExtensionController.php"
  css: "cosmicpulse.css"
  wrapper: "admin/extensions/cosmicpulse/wrapper.blade.php"

requests:
  routers:
    client: "routes/client.php"
    admin: "routes/admin.php"
  views:
    client: "resources/views/client"
    admin: "resources/views/admin"
  controllers:
    client: "app/Http/Controllers/Client"
    admin: "app/Http/Controllers/Admin"

database:
  migrations: "database/migrations"
EOF

    # Crea CSS principale
    mkdir -p "$THEME_DIR/public"
    cat > "$THEME_DIR/public/cosmicpulse.css" << 'EOF'
/* CosmicPulse Theme - Ispirato a Nebula */

:root {
    --cosmic-bg-primary: #0a0a0f;
    --cosmic-bg-secondary: #151520;
    --cosmic-bg-tertiary: #1e1e2e;
    --cosmic-accent: #7c3aed;
    --cosmic-accent-light: #a855f7;
    --cosmic-accent-dark: #5b21b6;
    --cosmic-text-primary: #ffffff;
    --cosmic-text-secondary: #d1d5db;
    --cosmic-text-muted: #9ca3af;
    --cosmic-border: #374151;
    --cosmic-success: #10b981;
    --cosmic-warning: #f59e0b;
    --cosmic-error: #ef4444;
    --cosmic-glow: 0 0 20px rgba(124, 58, 237, 0.3);
    --cosmic-glow-strong: 0 0 30px rgba(124, 58, 237, 0.5);
}

/* Animazioni base */
@keyframes cosmic-float {
    0%, 100% { transform: translateY(0px); }
    50% { transform: translateY(-10px); }
}

@keyframes cosmic-pulse {
    0%, 100% { opacity: 1; }
    50% { opacity: 0.7; }
}

@keyframes cosmic-glow {
    0%, 100% { box-shadow: var(--cosmic-glow); }
    50% { box-shadow: var(--cosmic-glow-strong); }
}

@keyframes starfield {
    0% { transform: translateY(0px); }
    100% { transform: translateY(-100vh); }
}

/* Background cosmico */
body {
    background: var(--cosmic-bg-primary);
    background-image: 
        radial-gradient(circle at 25% 25%, rgba(124, 58, 237, 0.1) 0%, transparent 50%),
        radial-gradient(circle at 75% 75%, rgba(168, 85, 247, 0.1) 0%, transparent 50%);
    color: var(--cosmic-text-primary);
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
    min-height: 100vh;
    position: relative;
    overflow-x: hidden;
}

/* Stelle animate di background */
body::before {
    content: '';
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 200vh;
    background-image: 
        radial-gradient(2px 2px at 20px 30px, #fff, transparent),
        radial-gradient(2px 2px at 40px 70px, rgba(255,255,255,0.8), transparent),
        radial-gradient(1px 1px at 90px 40px, #fff, transparent),
        radial-gradient(1px 1px at 130px 80px, rgba(255,255,255,0.6), transparent),
        radial-gradient(2px 2px at 160px 30px, #fff, transparent);
    background-repeat: repeat;
    background-size: 200px 100px;
    animation: starfield 50s linear infinite;
    pointer-events: none;
    z-index: -1;
    opacity: 0.3;
}

/* Login Page Styling */
.login-container {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 2rem;
    position: relative;
}

.login-card {
    background: var(--cosmic-bg-secondary);
    border: 1px solid var(--cosmic-border);
    border-radius: 1rem;
    padding: 3rem;
    width: 100%;
    max-width: 400px;
    box-shadow: var(--cosmic-glow);
    backdrop-filter: blur(10px);
    position: relative;
    overflow: hidden;
}

.login-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 1px;
    background: linear-gradient(90deg, transparent, var(--cosmic-accent), transparent);
}

.login-header {
    text-align: center;
    margin-bottom: 2rem;
}

.login-logo {
    width: 80px;
    height: 80px;
    margin: 0 auto 1rem;
    background: linear-gradient(135deg, var(--cosmic-accent), var(--cosmic-accent-light));
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 2rem;
    color: white;
    animation: cosmic-float 3s ease-in-out infinite;
}

.login-title {
    font-size: 1.5rem;
    font-weight: 600;
    color: var(--cosmic-text-primary);
    margin-bottom: 0.5rem;
}

.login-subtitle {
    color: var(--cosmic-text-muted);
    font-size: 0.875rem;
}

/* Form Styling */
.form-group {
    margin-bottom: 1.5rem;
}

.form-label {
    display: block;
    margin-bottom: 0.5rem;
    color: var(--cosmic-text-secondary);
    font-weight: 500;
    font-size: 0.875rem;
}

.form-control {
    width: 100%;
    padding: 0.75rem 1rem;
    background: var(--cosmic-bg-tertiary);
    border: 1px solid var(--cosmic-border);
    border-radius: 0.5rem;
    color: var(--cosmic-text-primary);
    font-size: 0.875rem;
    transition: all 0.3s ease;
}

.form-control:focus {
    outline: none;
    border-color: var(--cosmic-accent);
    box-shadow: 0 0 0 3px rgba(124, 58, 237, 0.1);
}

.form-control::placeholder {
    color: var(--cosmic-text-muted);
}

/* Button Styling */
.btn {
    padding: 0.75rem 1.5rem;
    border-radius: 0.5rem;
    font-weight: 500;
    font-size: 0.875rem;
    border: none;
    cursor: pointer;
    transition: all 0.3s ease;
    position: relative;
    overflow: hidden;
}

.btn-primary {
    background: linear-gradient(135deg, var(--cosmic-accent), var(--cosmic-accent-light));
    color: white;
    width: 100%;
}

.btn-primary:hover {
    background: linear-gradient(135deg, var(--cosmic-accent-dark), var(--cosmic-accent));
    box-shadow: var(--cosmic-glow);
    transform: translateY(-1px);
}

.btn-primary::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
    transition: left 0.5s;
}

.btn-primary:hover::before {
    left: 100%;
}

/* Navigation */
.navbar {
    background: rgba(21, 21, 32, 0.95);
    backdrop-filter: blur(10px);
    border-bottom: 1px solid var(--cosmic-border);
    position: sticky;
    top: 0;
    z-index: 100;
}

.navbar-brand {
    color: var(--cosmic-text-primary) !important;
    font-weight: 600;
    font-size: 1.25rem;
}

.nav-link {
    color: var(--cosmic-text-secondary) !important;
    transition: color 0.3s ease;
}

.nav-link:hover {
    color: var(--cosmic-accent-light) !important;
}

/* Cards */
.card {
    background: var(--cosmic-bg-secondary);
    border: 1px solid var(--cosmic-border);
    border-radius: 0.75rem;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    transition: all 0.3s ease;
}

.card:hover {
    box-shadow: var(--cosmic-glow);
    transform: translateY(-2px);
}

.card-header {
    background: var(--cosmic-bg-tertiary);
    border-bottom: 1px solid var(--cosmic-border);
    color: var(--cosmic-text-primary);
    font-weight: 600;
}

.card-body {
    color: var(--cosmic-text-secondary);
}

/* Tables */
.table {
    color: var(--cosmic-text-secondary);
}

.table-dark {
    background: var(--cosmic-bg-secondary);
}

.table-dark th {
    background: var(--cosmic-bg-tertiary);
    border-color: var(--cosmic-border);
    color: var(--cosmic-text-primary);
}

.table-dark td {
    border-color: var(--cosmic-border);
}

/* Alerts */
.alert-success {
    background: rgba(16, 185, 129, 0.1);
    border: 1px solid var(--cosmic-success);
    color: var(--cosmic-success);
}

.alert-warning {
    background: rgba(245, 158, 11, 0.1);
    border: 1px solid var(--cosmic-warning);
    color: var(--cosmic-warning);
}

.alert-danger {
    background: rgba(239, 68, 68, 0.1);
    border: 1px solid var(--cosmic-error);
    color: var(--cosmic-error);
}

/* Server Cards */
.server-card {
    background: var(--cosmic-bg-secondary);
    border: 1px solid var(--cosmic-border);
    border-radius: 0.75rem;
    padding: 1.5rem;
    transition: all 0.3s ease;
    position: relative;
    overflow: hidden;
}

.server-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 2px;
    background: linear-gradient(90deg, var(--cosmic-accent), var(--cosmic-accent-light));
}

.server-card:hover {
    box-shadow: var(--cosmic-glow);
    transform: translateY(-3px);
}

.server-status.online {
    color: var(--cosmic-success);
}

.server-status.offline {
    color: var(--cosmic-error);
}

.server-status.starting {
    color: var(--cosmic-warning);
    animation: cosmic-pulse 2s infinite;
}

/* Status Indicators */
.status-dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    display: inline-block;
    margin-right: 0.5rem;
    animation: cosmic-pulse 2s infinite;
}

.status-dot.online {
    background: var(--cosmic-success);
}

.status-dot.offline {
    background: var(--cosmic-error);
}

.status-dot.starting {
    background: var(--cosmic-warning);
}

/* Scrollbar Styling */
::-webkit-scrollbar {
    width: 8px;
}

::-webkit-scrollbar-track {
    background: var(--cosmic-bg-primary);
}

::-webkit-scrollbar-thumb {
    background: var(--cosmic-accent);
    border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
    background: var(--cosmic-accent-light);
}

/* Responsive */
@media (max-width: 768px) {
    .login-card {
        padding: 2rem;
        margin: 1rem;
    }
    
    .server-card {
        padding: 1rem;
    }
}

/* Loading Animation */
.cosmic-loader {
    width: 40px;
    height: 40px;
    border: 3px solid var(--cosmic-bg-tertiary);
    border-top: 3px solid var(--cosmic-accent);
    border-radius: 50%;
    animation: spin 1s linear infinite;
    margin: 0 auto;
}

@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}

/* Cosmic Effects */
.cosmic-glow {
    animation: cosmic-glow 3s ease-in-out infinite;
}

.cosmic-float {
    animation: cosmic-float 4s ease-in-out infinite;
}
EOF

    # Crea template login
    mkdir -p "$THEME_DIR/resources/views/auth"
    cat > "$THEME_DIR/resources/views/auth/login.blade.php" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>{{ config('app.name', 'Pterodactyl') }} - Login</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <meta name="robots" content="noindex">
    
    <link rel="apple-touch-icon" sizes="180x180" href="/favicons/apple-touch-icon.png">
    <link rel="icon" type="image/png" href="/favicons/favicon-32x32.png" sizes="32x32">
    <link rel="icon" type="image/png" href="/favicons/favicon-16x16.png" sizes="16x16">
    <link rel="manifest" href="/favicons/manifest.json">
    <link rel="mask-icon" href="/favicons/safari-pinned-tab.svg" color="#bc6e3c">
    <link rel="shortcut icon" href="/favicons/favicon.ico">
    <meta name="msapplication-config" content="/favicons/browserconfig.xml">
    <meta name="theme-color" content="#0e4688">
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="{{ mix('css/app.css') }}">
    <link rel="stylesheet" href="/css/cosmicpulse.css">
</head>
<body class="login-page">
    <div class="login-container">
        <div class="login-card cosmic-glow">
            <div class="login-header">
                <div class="login-logo cosmic-float">
                    🌌
                </div>
                <h1 class="login-title">{{ config('app.name', 'Pterodactyl') }}</h1>
                <p class="login-subtitle">Accedi al tuo pannello di controllo cosmico</p>
            </div>
            
            @if (count($errors) > 0)
                <div class="alert alert-danger">
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    @lang('auth.auth_error')
                </div>
            @endif
            
            @if (session('status'))
                <div class="alert alert-success">
                    {{ session('status') }}
                </div>
            @endif
            
            <form id="loginForm" action="{{ route('auth.login') }}" method="POST">
                <div class="form-group">
                    <label class="form-label" for="user">@lang('strings.user_identifier')</label>
                    <input class="form-control" type="text" name="user" id="user" required autofocus placeholder="Email o Username">
                </div>
                
                <div class="form-group">
                    <label class="form-label" for="password">@lang('strings.password')</label>
                    <input class="form-control" type="password" name="password" id="password" required placeholder="Password">
                </div>
                
                <div class="form-group">
                    <div class="checkbox">
                        <input type="checkbox" name="remember_me" id="remember_me" value="1">
                        <label for="remember_me" class="form-label">@lang('auth.remember_me')</label>
                    </div>
                </div>
                
                {!! csrf_field() !!}
                <button class="btn btn-primary" type="submit">
                    <span class="btn-text">@lang('auth.sign_in')</span>
                </button>
            </form>
            
            @if(!empty($recaptcha_enabled))
                @include('partials/recaptcha')
            @endif
            
            <div class="text-center" style="margin-top: 1.5rem;">
                <a href="{{ route('auth.password') }}" class="small" style="color: var(--cosmic-accent);">
                    @lang('auth.forgot_password')
                </a>
            </div>
        </div>
    </div>
    
    <script src="{{ mix('js/app.js') }}"></script>
    
    <script>
        // Effetti particellari aggiuntivi
        function createParticles() {
            const particleCount = 50;
            const particles = [];
            
            for (let i = 0; i < particleCount; i++) {
                const particle = document.createElement('div');
                particle.className = 'cosmic-particle';
                particle.style.cssText = `
                    position: fixed;
                    width: 2px;
                    height: 2px;
                    background: rgba(124, 58, 237, 0.6);
                    border-radius: 50%;
                    pointer-events: none;
                    z-index: -1;
                `;
                document.body.appendChild(particle);
                particles.push({
                    element: particle,
                    x: Math.random() * window.innerWidth,
                    y: Math.random() * window.innerHeight,
                    vx: (Math.random() - 0.5) * 0.5,
                    vy: (Math.random() - 0.5) * 0.5
                });
            }
            
            function animateParticles() {
                particles.forEach(particle => {
                    particle.x += particle.vx;
                    particle.y += particle.vy;
                    
                    if (particle.x < 0 || particle.x > window.innerWidth) particle.vx *= -1;
                    if (particle.y < 0 || particle.y > window.innerHeight) particle.vy *= -1;
                    
                    particle.element.style.left = particle.x + 'px';
                    particle.element.style.top = particle.y + 'px';
                });
                
                requestAnimationFrame(animateParticles);
            }
            
            animateParticles();
        }
        
        // Avvia particelle dopo il caricamento
        window.addEventListener('load', createParticles);
        
        // Animazione form
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const btn = this.querySelector('.btn-primary');
            const btnText = btn.querySelector('.btn-text');
            
            btnText.innerHTML = '<div class="cosmic-loader"></div>';
            btn.disabled = true;
        });
    </script>
</body>
</html>
EOF

    # Crea layout principale
    mkdir -p "$THEME_DIR/resources/views/layouts"
    cat > "$THEME_DIR/resources/views/layouts/app.blade.php" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>{{ config('app.name', 'Pterodactyl') }}</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="{{ mix('css/app.css') }}">
    <link rel="stylesheet" href="/css/cosmicpulse.css">
</head>
<body>
    <nav class="navbar">
        <div class="container">
            <a class="navbar-brand" href="{{ route('index') }}">
                🌌 {{ config('app.name', 'Pterodactyl') }}
            </a>
        </div>
    </nav>
    
    <main class="container" style="margin-top: 2rem;">
        @yield('content')
    </main>
    
    <script src="{{ mix('js/app.js') }}"></script>
</body>
</html>
EOF

    success "Struttura tema creata"
}

# Installa tema
install_theme() {
    log "Installazione tema CosmicPulse..."
    
    # Verifica e prepara directory CSS
    CSS_DIR="/var/www/pterodactyl/public/css"
    
    if [[ -f "$CSS_DIR" ]]; then
        # Se css esiste come file, fai backup e rimuovi
        warning "File 'css' trovato invece di directory, creando backup..."
        mv "$CSS_DIR" "${CSS_DIR}.backup.$(date +%s)"
    fi
    
    # Crea directory CSS se non esiste
    mkdir -p "$CSS_DIR"
    
    # Verifica che la directory sia stata creata correttamente
    if [[ ! -d "$CSS_DIR" ]]; then
        error "Impossibile creare directory $CSS_DIR"
    fi
    
    # Copia file CSS
    cp "$THEME_DIR/public/cosmicpulse.css" "$CSS_DIR/"
    
    # Verifica che il file sia stato copiato
    if [[ ! -f "$CSS_DIR/cosmicpulse.css" ]]; then
        error "Impossibile copiare il file CSS"
    fi
    
    # Installa tramite Blueprint se disponibile
    if command -v blueprint &> /dev/null; then
        cd "$THEME_DIR"
        blueprint -install
    else
        # Installazione manuale
        warning "Blueprint non disponibile, installazione manuale..."
        
        # Verifica e crea directory per i template
        mkdir -p "/var/www/pterodactyl/resources/views/auth"
        mkdir -p "/var/www/pterodactyl/resources/views/layouts"
        
        # Copia templates
        cp -r "$THEME_DIR/resources/views/"* "/var/www/pterodactyl/resources/views/" 2>/dev/null || true
        
        # Imposta permessi
        chown -R www-data:www-data "/var/www/pterodactyl/resources/views/" 2>/dev/null || true
        chown www-data:www-data "/var/www/pterodactyl/public/css/cosmicpulse.css" 2>/dev/null || true
    fi
    
    success "Tema installato con successo"
}

# Configura tema
configure_theme() {
    log "Configurazione tema..."
    
    # Backup configurazioni esistenti
    if [[ -f "/var/www/pterodactyl/config/app.php" ]]; then
        cp "/var/www/pterodactyl/config/app.php" "/var/www/pterodactyl/config/app.php.backup.$(date +%s)"
        success "Backup configurazione creato"
    fi
    
    # Riavvia servizi se necessario
    if systemctl is-active --quiet nginx; then
        systemctl reload nginx
        success "Nginx ricaricato"
    fi
    
    if systemctl is-active --quiet apache2; then
        systemctl reload apache2
        success "Apache ricaricato"
    fi
}

# Cleanup
cleanup() {
    log "Pulizia file temporanei..."
    rm -rf "$THEME_DIR"
    success "Pulizia completata"
}

# Test installazione
test_installation() {
    log "Test installazione..."
    
    if [[ -f "/var/www/pterodactyl/public/css/cosmicpulse.css" ]]; then
        success "File CSS trovato"
        
        # Test dimensione file
        CSS_SIZE=$(stat -c%s "/var/www/pterodactyl/public/css/cosmicpulse.css")
        if [[ $CSS_SIZE -gt 1000 ]]; then
            success "File CSS valido (${CSS_SIZE} bytes)"
        else
            warning "File CSS potrebbe essere corrotto"
        fi
    else
        error "File CSS non trovato dopo l'installazione"
    fi
}

# Mostra informazioni finali
show_completion_info() {
    clear
    echo -e "${GREEN}${BOLD}"
    echo "  ╔═══════════════════════════════════════════════════════════════╗"
    echo "  ║                                                               ║"
    echo "  ║                    ✨ INSTALLAZIONE COMPLETATA ✨             ║"
    echo "  ║                                                               ║"
    echo "  ║                   🌌 CosmicPulse Theme 🌌                    ║"
    echo "  ║                        Attivo e Funzionante                   ║"
    echo "  ║                                                               ║"
    echo "  ╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${CYAN}📋 Informazioni installazione:${NC}"
    echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✓${NC} Tema CosmicPulse installato"
    echo -e "${GREEN}✓${NC} File CSS attivati"
    echo -e "${GREEN}✓${NC} Template di login personalizzati"
    echo -e "${GREEN}✓${NC} Effetti cosmici abilitati"
    echo -e "${GREEN}✓${NC} Animazioni spaziali attive"
    echo
    
    echo -e "${YELLOW}🚀 Caratteristiche del tema:${NC}"
    echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "• 🌌 Design spaziale ispirato a Nebula"
    echo -e "• ✨ Animazioni fluide e moderne"
    echo -e "• 🎨 Palette colori viola/cosmic"
    echo -e "• 🌟 Effetti particellari animati"
    echo -e "• 📱 Design responsive per mobile"
    echo -e "• 🔒 Pagina login personalizzata"
    echo -e "• ⚡ Performance ottimizzate"
    echo
    
    echo -e "${PURPLE}🎯 Prossimi passi:${NC}"
    echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "1. Svuota cache del browser (Ctrl+F5)"
    echo -e "2. Accedi al pannello per vedere il nuovo tema"
    echo -e "3. Controlla che tutti gli elementi siano visibili"
    echo -e "4. Se hai problemi, controlla i log di nginx/apache"
    echo
    
    echo -e "${BLUE}🔧 Comandi utili:${NC}"
    echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "• Ricarica nginx: ${CYAN}sudo systemctl reload nginx${NC}"
    echo -e "• Ricarica apache: ${CYAN}sudo systemctl reload apache2${NC}"
    echo -e "• Check logs: ${CYAN}sudo tail -f /var/log/nginx/error.log${NC}"
    echo -e "• Backup ripristino: ${CYAN}Backup salvati in /var/www/pterodactyl/config/${NC}"
    echo
    
    echo -e "${GREEN}🌟 Grazie per aver scelto CosmicPulse! 🌟${NC}"
    echo -e "${CYAN}Il tuo pannello Pterodactyl ora ha un aspetto cosmico! 🚀${NC}"
    echo
}

# Menu principale
show_menu() {
    while true; do
        show_banner
        echo -e "${WHITE}Seleziona un'opzione:${NC}"
        echo -e "${CYAN}1)${NC} Installazione completa (Consigliata)"
        echo -e "${CYAN}2)${NC} Solo installazione tema"
        echo -e "${CYAN}3)${NC} Solo test sistema"
        echo -e "${CYAN}4)${NC} Disinstalla tema"
        echo -e "${CYAN}5)${NC} Mostra informazioni"
        echo -e "${CYAN}0)${NC} Esci"
        echo
        echo -ne "${YELLOW}Inserisci la tua scelta [0-5]: ${NC}"
        read -r choice
        
        case $choice in
            1)
                full_installation
                break
                ;;
            2)
                theme_only_installation
                break
                ;;
            3)
                system_test
                ;;
            4)
                uninstall_theme
                ;;
            5)
                show_info
                ;;
            0)
                echo -e "${GREEN}Arrivederci! 👋${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Opzione non valida!${NC}"
                sleep 2
                ;;
        esac
    done
}

# Installazione completa
full_installation() {
    show_banner
    echo -e "${CYAN}🚀 Avvio installazione completa CosmicPulse...${NC}"
    echo
    
    check_root
    check_pterodactyl
    check_blueprint
    create_theme_structure
    install_theme
    configure_theme
    test_installation
    cleanup
    show_completion_info
    
    echo -ne "${YELLOW}Premi INVIO per continuare...${NC}"
    read -r
}

# Solo installazione tema
theme_only_installation() {
    show_banner
    echo -e "${CYAN}🎨 Installazione solo tema...${NC}"
    echo
    
    check_root
    check_pterodactyl
    create_theme_structure
    install_theme
    test_installation
    cleanup
    
    success "Tema installato! Ricarica il browser per vedere i cambiamenti."
    echo -ne "${YELLOW}Premi INVIO per continuare...${NC}"
    read -r
}

# Test sistema
system_test() {
    show_banner
    echo -e "${CYAN}🔍 Test sistema in corso...${NC}"
    echo
    
    check_root
    check_pterodactyl
    check_blueprint
    
    # Test aggiuntivi
    log "Test permessi directory..."
    
    # Verifica struttura directory Pterodactyl
    CSS_DIR="/var/www/pterodactyl/public/css"
    
    if [[ -f "$CSS_DIR" ]]; then
        warning "File 'css' trovato invece di directory"
        log "Verrà convertito in directory durante l'installazione"
    elif [[ -d "$CSS_DIR" ]]; then
        if [[ -w "$CSS_DIR" ]]; then
            success "Directory CSS scrivibile"
        else
            warning "Directory CSS non scrivibile"
        fi
    else
        log "Directory CSS non esiste, verrà creata"
    fi
    
    log "Test spazio disco..."
    DISK_SPACE=$(df /var/www/pterodactyl | awk 'NR==2 {print $4}')
    if [[ $DISK_SPACE -gt 100000 ]]; then
        success "Spazio disco sufficiente"
    else
        warning "Spazio disco limitato"
    fi
    
    log "Test servizi web..."
    if systemctl is-active --quiet nginx || systemctl is-active --quiet apache2; then
        success "Server web attivo"
    else
        warning "Nessun server web attivo rilevato"
    fi
    
    echo -e "${GREEN}Test completato!${NC}"
    echo -ne "${YELLOW}Premi INVIO per continuare...${NC}"
    read -r
}

# Disinstallazione tema
uninstall_theme() {
    show_banner
    echo -e "${RED}🗑️  Disinstallazione CosmicPulse...${NC}"
    echo
    
    echo -ne "${YELLOW}Sei sicuro di voler disinstallare il tema? [y/N]: ${NC}"
    read -r confirm
    
    if [[ $confirm =~ ^[Yy]$ ]]; then
        log "Rimozione file tema..."
        
        # Rimuovi CSS
        if [[ -f "/var/www/pterodactyl/public/css/cosmicpulse.css" ]]; then
            rm "/var/www/pterodactyl/public/css/cosmicpulse.css"
            success "File CSS rimosso"
        fi
        
        # Ripristina backup se disponibile
        BACKUP_FILE=$(ls -t /var/www/pterodactyl/config/app.php.backup.* 2>/dev/null | head -n1)
        if [[ -f "$BACKUP_FILE" ]]; then
            cp "$BACKUP_FILE" "/var/www/pterodactyl/config/app.php"
            success "Configurazione ripristinata da backup"
        fi
        
        success "Tema disinstallato!"
    else
        log "Disinstallazione annullata"
    fi
    
    echo -ne "${YELLOW}Premi INVIO per continuare...${NC}"
    read -r
}

# Mostra informazioni
show_info() {
    show_banner
    echo -e "${CYAN}ℹ️  Informazioni CosmicPulse Theme${NC}"
    echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo
    echo -e "${BOLD}Nome:${NC} CosmicPulse"
    echo -e "${BOLD}Versione:${NC} 1.0.0"
    echo -e "${BOLD}Compatibilità:${NC} Pterodactyl Panel + Blueprint"
    echo -e "${BOLD}Tema ispirato a:${NC} Nebula Space Theme"
    echo -e "${BOLD}Caratteristiche:${NC}"
    echo -e "  • Design spaziale moderno"
    echo -e "  • Animazioni CSS avanzate"
    echo -e "  • Effetti particellari"
    echo -e "  • Login page personalizzata"
    echo -e "  • Palette colori viola/cosmic"
    echo -e "  • Responsive design"
    echo
    echo -e "${BOLD}Requisiti:${NC}"
    echo -e "  • Pterodactyl Panel (ultima versione)"
    echo -e "  • Blueprint Extension (opzionale ma consigliato)"
    echo -e "  • Nginx o Apache"
    echo -e "  • Permessi root per installazione"
    echo
    echo -e "${BOLD}File installati:${NC}"
    echo -e "  • /var/www/pterodactyl/public/css/cosmicpulse.css"
    echo -e "  • /var/www/pterodactyl/resources/views/auth/login.blade.php"
    echo -e "  • /var/www/pterodactyl/resources/views/layouts/app.blade.php"
    echo
    echo -ne "${YELLOW}Premi INVIO per continuare...${NC}"
    read -r
}

# Gestione errori
handle_error() {
    echo -e "${RED}${BOLD}❌ ERRORE CRITICO${NC}"
    echo -e "${RED}Lo script è stato interrotto a causa di un errore.${NC}"
    echo -e "${YELLOW}Controlla i log sopra per maggiori dettagli.${NC}"
    cleanup
    exit 1
}

# Trap per gestire interruzioni
trap handle_error ERR
trap 'echo -e "\n${YELLOW}Script interrotto dall utente${NC}"; cleanup; exit 1' INT

# Controlli preliminari
preliminary_checks() {
    # Controlla connessione internet
    if ! ping -c 1 google.com &> /dev/null; then
        warning "Connessione internet non disponibile"
    fi
    
    # Controlla se è già installato
    if [[ -f "/var/www/pterodactyl/public/css/cosmicpulse.css" ]]; then
        warning "CosmicPulse sembra già installato"
        echo -ne "${YELLOW}Vuoi reinstallare? [y/N]: ${NC}"
        read -r reinstall
        if [[ ! $reinstall =~ ^[Yy]$ ]]; then
            exit 0
        fi
    fi
}

# Script principale
main() {
    # Controlli preliminari
    preliminary_checks
    
    # Mostra menu se non ci sono argomenti
    if [[ $# -eq 0 ]]; then
        show_menu
    else
        # Modalità automatica con argomenti
        case "$1" in
            "install"|"--install")
                full_installation
                ;;
            "theme-only"|"--theme-only")
                theme_only_installation
                ;;
            "test"|"--test")
                system_test
                ;;
            "uninstall"|"--uninstall")
                uninstall_theme
                ;;
            "info"|"--info")
                show_info
                ;;
            *)
                echo -e "${RED}Argomento non riconosciuto: $1${NC}"
                echo -e "${CYAN}Uso: $0 [install|theme-only|test|uninstall|info]${NC}"
                exit 1
                ;;
        esac
    fi
}

# Avvia script
main "$@"
