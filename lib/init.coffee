# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.
#
# An example hack to log to the console when each text editor is saved.
#
# atom.workspace.observeTextEditors (editor) ->
#   editor.onDidSave ->
#     console.log "Saved! #{editor.getPath()}"


#plugin = require './plugin'
getHtmlPreview = require('./preview').getHtmlPreview

child_process = require('child_process')
File = require('vinyl')
plugin = require('lupa').analysis;
Metadata = require('lupa').Metadata;
getMetadata = Metadata.getMetadata
getFileForModule = require('./getFileFor').getFileForModule
getFileForSymbol = require('./getFileFor').getFileForSymbol
getFileForRequire = require('./getFileFor').getFileForRequire

fs = require 'fs'
path_ = require 'path'


el = document.createElement('div');
el.style.overflow = 'scroll'
doc = document


el.innerHTML = "
<div id='lupa-info'></div>
<div id='moje'
    style='padding: 10px; width:240px;overflow:scroll;'>sss <br> <br>
atom.workspace.addLeftPanel(item: el)


</div>
<style>
.lupa-file {
    color: #cca;
    cursor: pointer;
}
</style>
<div style='margin-bottom:10px'>
    <div style='display:none'>
        <label>glob file pattern to analyze (e.g. /Users/john/my-project/src/**/*.js  )
        <div><input id='lupa-project-root' type='text'></div></label>
        <br>
    </div>
    <button id='lupa-index-project'>Index project</button>
    (It requires lupaProject.json file.)
</div>
<div style='display:none'>
<input id='lupa-index-file' type='text'><br>
<button id='lupa-load-index-file'>Load index file (not implemented)</button></div>"

el.addEventListener('click',
    (e) ->
        target = e.target
        if target.className.indexOf('lupa-label') != -1
            label = target.getAttribute('data-label')
            plugin
                .filterFiles (f) ->
                    getMetadata(f).filter (item)->
                        item.type == 'label' && item.data == label
                    .length
                .toArray().subscribe (files) ->
                    paths = files.map (f) ->
                        "<div data-path='#{f.path}'> #{path_.basename(f.path)} </div>"
                    .join('')
                    doc.getElementById('lupa-info').innerHTML = "Files with this label '#{label}: #{paths}"

        path = e.target.getAttribute('data-path')
        console.log("path, open file:", path)
        if path
            if !fs.existsSync(path)
                path = getFileForRequire(allFiles, path).path
            atom.workspace.open(path)


)


getFileFor = (name) ->
    return ''
    # files = plugin.lupa.getState().files
    # found = files.filter(
    #     (f) -> f.metadata.filter(
    #         (entry) -> entry.name == 'modules' && entry.data.indexOf(name) != -1
    #     ).length
    # )
    # console.log('getFileFor ' + name, files)
    # console.log('getFileFor found', found)
    # if found.length
    #     return "(" + found[0].path + ")"
    # return ''

currentFile = ''

atom.workspace.addLeftPanel(item: el)
#'/Users/lukasz/sandbox/Mancy/src/**/*'
document.getElementById('lupa-index-project').addEventListener('click', () ->
    path = document.getElementById('lupa-project-root').value;
    # plugin.indexProject({filePattern: path})
    alert "Click ok to start indexing (it can take few minutes)."
    plugin.indexProject(path_.dirname(currentFile))
)

lastState = {}
allFiles = []

update1 = ->
    identitity = (v) ->
        v
    plugin.filterFiles(identitity).toArray().subscribe (files) ->
        allFiles = files
    editor = atom.workspace.getActivePaneItem()
    if (!editor)
        return
    if (!editor.buffer)
        return

    el = document.getElementById('moje')

    print = {
        'imported by': (entry) ->
            "<h3 style='color:grey'>#{entry.name}</h3>" +
            entry.data.map (importer) ->
                "<div class='lupa-file' data-path='#{importer.path}'> #{path_.basename(importer.path)}</div>"
            .join("<br>")
        imports: (entry) ->
            "<h3 style='color:grey'>#{entry.name}</h3>" +
            entry.data.map (item) ->
                "<div> #{item.name} from
                <span class='lupa-file' data-path='#{item.source}'>#{item.originalSource}</span>
                </div>"
            .join("<br>")
        label: (entry) ->
            "<span
                data-label='#{entry.data}'
                class='lupa-label'
                style='display: inline-block;text-shadow: 1px 1px 2px black; color: #eee; background: #b73; padding: 4px; margin: 4px;border-radius: 4px;'>
             #{entry.data} </span>"


        classes: (entry) ->
            "<h3 style='color:grey'>#{entry.name}</h3>" +
                entry.data.map(
                    (cls) ->
                        "<h4>#{cls.name}</h4>" + cls.methods.join('<br>')
                ).join('<br>') +
                '<br>'
        symbol: (entry) ->
            "<h3 style='color:blue'>#{entry.name}</h3>" +
                entry.data.map(
                    (n) -> "<div data-path='#{getFileForSymbol(allFiles, n).path}'>#{n}</div>"
                    #(n) -> "<div data-path=''>#{n}</div>"
                ).join('<br>') +
                '<br>'
        default: (entry) ->
            if entry.data.length
                "<h3 style='color:grey'>#{entry.name}</h3>" +
                    entry.data.map(
                        (n) -> "<div data-path='#{getFileForModule(lastState, n).path}' class='lupa-entry'>#{n}</div>"
                    ).join('<br>') +
                    '<br>'
            else
                '' #"<br><em style='color:grey'>no #{entry.name}</em>"

    }
    if editor.buffer.file
        filename = editor.buffer.file.path
    else
        filename = ''

    currentFile = filename;

    update = (f)->
        moduleName = path_.basename(filename, path_.extname(filename))
        #moduleName = filename
        # TODO uncomment filename
        plugin.findImporters(moduleName).toArray().subscribe( (importers) =>
            state = {files: [f]}
            if !state.files
                console.log("got message from child", state)
                return
            lastState = state
            console.log("got message")
            found = state.files.filter( (f) -> f.path == filename)
            if (!found.length)
                console.log("error: !found.length")
                return

            html = '...'
            if path_.extname(found[0].path) == '.html'
                html = getHtmlPreview(found[0])
            else
                fixture =
                    name:'imported by'
                    data: importers #.map((f) => path_.basename(f.path))

                html = getMetadata(found[0]).concat(fixture).map (entry) ->
                    render = print[entry.name] || print.default
                    render(entry)
                .join('')
            el.innerHTML = html

        )


    el.innerHTML = ''

    # assign to global variable
    onUpdate = update
    #plugin.on('message', update)
    plugin.process(new File({
        path: filename,
        contents: fs.readFileSync(filename)
    })).subscribe(update)



atom.workspace.onDidChangeActivePaneItem ->
    update1()

update1()
