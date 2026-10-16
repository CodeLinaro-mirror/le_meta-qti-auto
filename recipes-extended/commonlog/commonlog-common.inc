# ============================================================================
# Backend Configuration Flags
# 0 = disabled
# 1 = enabled
# ============================================================================

CLOG_ENABLE_DLT ?= "1"
CLOG_ENABLE_DIAG ?= "1"
CLOG_ENABLE_SYSLOG ?= "1"
CLOG_ENABLE_LOGCAT ?= "1"
CLOG_ENABLE_FILE ?= "1"
CLOG_ENABLE_CONSOLE ?= "1"
CLOG_ENABLE_DEBUG ?= "0"

# ============================================================================
# Dependencies based on enabled backends
# ============================================================================

DEPENDS:append = "${@' dlt-daemon' if d.getVar('CLOG_ENABLE_DLT') == '1' else ''}"
DEPENDS:append = "${@' diag' if d.getVar('CLOG_ENABLE_DIAG') == '1' else ''}"
DEPENDS:append = "${@' liblog' if d.getVar('CLOG_ENABLE_LOGCAT') == '1' else ''}"

# ============================================================================
# Configure Arguments based on enabled backends
# ============================================================================

EXTRA_OECONF:append = "${@' --with-dlt' if d.getVar('CLOG_ENABLE_DLT') == '1' else ' --without-dlt'}"
EXTRA_OECONF:append = "${@' --with-diag' if d.getVar('CLOG_ENABLE_DIAG') == '1' else ' --without-diag'}"
EXTRA_OECONF:append = "${@' --with-syslog' if d.getVar('CLOG_ENABLE_SYSLOG') == '1' else ' --without-syslog'}"
EXTRA_OECONF:append = "${@' --with-logcat' if d.getVar('CLOG_ENABLE_LOGCAT') == '1' else ' --without-logcat'}"
EXTRA_OECONF:append = "${@' --with-file' if d.getVar('CLOG_ENABLE_FILE') == '1' else ' --without-file'}"
EXTRA_OECONF:append = "${@' --with-console' if d.getVar('CLOG_ENABLE_CONSOLE') == '1' else ' --without-console'}"
EXTRA_OECONF:append = "${@' --with-debug' if d.getVar('CLOG_ENABLE_DEBUG') == '1' else ' --without-debug'}"

# ============================================================================
# Configuration Summary
# ============================================================================

do_configure() {
    bbnote "=========================================="
    bbnote "CLOG Configuration Summary"
    bbnote "=========================================="
    bbnote "DLT Backend:     ${@'ENABLED' if d.getVar('CLOG_ENABLE_DLT') == '1' else 'DISABLED'}"
    bbnote "DIAG Backend:    ${@'ENABLED' if d.getVar('CLOG_ENABLE_DIAG') == '1' else 'DISABLED'}"
    bbnote "Syslog Backend:  ${@'ENABLED' if d.getVar('CLOG_ENABLE_SYSLOG') == '1' else 'DISABLED'}"
    bbnote "Logcat Backend:  ${@'ENABLED' if d.getVar('CLOG_ENABLE_LOGCAT') == '1' else 'DISABLED'}"
    bbnote "File Backend:    ${@'ENABLED' if d.getVar('CLOG_ENABLE_FILE') == '1' else 'DISABLED'}"
    bbnote "Console Backend: ${@'ENABLED' if d.getVar('CLOG_ENABLE_CONSOLE') == '1' else 'DISABLED'}"
    bbnote "Debug Trace:     ${@'ENABLED' if d.getVar('CLOG_ENABLE_DEBUG') == '1' else 'DISABLED'}"
    bbnote "=========================================="

    autotools_do_configure
}
