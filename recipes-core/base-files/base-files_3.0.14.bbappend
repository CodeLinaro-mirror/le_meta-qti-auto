
dirs755_append_sa8155 +="/firmware /dsp "

do_install_append_sa8155(){
    ln -s /firmware/image ${D}/lib/firmware
}
