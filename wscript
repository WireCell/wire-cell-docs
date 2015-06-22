top = '.'
out = '.'

graphviz_files = ['docs/img/ecosystem-data.dot',]

def configure(cfg):
    cfg.find_program('mkdocs', var='MKDOCS', mandatory=True)
    cfg.find_program('dot', var='DOT', mandatory=False)

def build(bld):
    
    if bld.env.DOT:
        for ext in ['png','pdf']:
            for dot in graphviz_files:
                bld(rule='${DOT} -T%s -o ${TGT} ${SRC}'%ext,
                    source = dot,
                    target = dot.replace('.dot','.'+ext))

    # note, mkdocs always rebuilds everything 
    bld(rule='${MKDOCS} build',
        source = 'docs/img/ecosystem-data.png',
        target = 'site/img/ecosystem-data.png')