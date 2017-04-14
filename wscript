top = '.'
out = '.'

graphviz_files = ['docs/img/ecosystem-data.dot',
                  'docs/img/rootdata.dot',]

def configure(cfg):
    cfg.find_program('mkdocs', var='MKDOCS', mandatory=True)
    cfg.find_program('dot', var='DOT', mandatory=False)

def build(bld):

    if bld.env.DOT:
        for dot in graphviz_files:
            bld(rule='${DOT} -Tpdf -o ${TGT} ${SRC}',
                source = dot,
                target = dot.replace('.dot','.pdf'))
            bld(rule='${DOT} -Tsvg -o ${TGT} ${SRC}',
                source = dot,
                target = dot.replace('.dot','.svg'))
            bld(rule='${DOT} -Tcmapx -o ${TGT[0].abspath()} -Tpng -o ${TGT[1].abspath()} ${SRC}',
                source = dot,
                target = [dot.replace('.dot','.map'), dot.replace('.dot','.png')])

    # # note, mkdocs always rebuilds everything
    # bld(rule='${MKDOCS} build',
    #     source = 'docs/img/ecosystem-data.png',
    #     target = 'site/img/ecosystem-data.png')
