def configure(cfg):
    cfg.recurse("manual")

def build(bld):
    # style directory
    styledir = bld.path.find_dir("styles")
    bld.install_files('${PREFIX}/styles', styledir.ant_glob('**'),
                      cwd=styledir, relative_trick=True)
    bld.recurse("manual")
