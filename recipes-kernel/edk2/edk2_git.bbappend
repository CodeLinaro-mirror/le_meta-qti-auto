
python sstate_task_prefunc () {
    import os
    shared_state = sstate_state_fromvars(d)
    ssmanifest = "%s/manifest-%s-%s.deploy" % (d.getVar("SSTATE_MANIFESTS"), d.getVar("SSTATE_MANMACH") , d.getVar("PN"))
    if (shared_state['task'] == "deploy") and (os.path.exists(ssmanifest)):
        cmd = "echo '%s/abl.elf' > %s" % (d.getVar("DEPLOY_DIR_IMAGE"), ssmanifest)
        os.system(cmd)
    sstate_clean(shared_state, d)
}
