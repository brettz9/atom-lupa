# Lupa 🔍

- Better navigation
- Better understanding the codebase 
- Semantic code search
- JavaScript/ES6 support

Navigation sidebar capable to perform full indexing of JavaScript project. 

It shows structure of each JavaScript file, with clickable list of functions, imports etc. It allows you to navigate also between different files in project, shows what modules in project import particular file.

##### It allows you to filter entries by name or type, e.g.:

![atom screenshot](https://raw.githubusercontent.com/hex13/atom-lupa/master/screenshot-3.png)

##### You can also perform deep searching, e.g. you can find all functions that have their first parameter named `err`:


![atom screenshot](https://raw.githubusercontent.com/hex13/atom-lupa/master/screenshot-deepsearch.png)

examples of semantic search (DSL can change in future versions):

type:objectLiteral

type:function

type:class

type:todo

params.length:2 

params[0].name:err

jsx:true

loc.start.column:7

loc.start.row:3

Finds external imports: 

source:node_modules

##### It has support for:

* ES5 (just plain old JavaScript)
* ES6 (e.g. it detects imports/exports, ES6 classes and arrow functions)
* JSX  
* CommonJS (it detects `require(...)`s ) 
* AngularJS (partially)
* CoffeeScript (partially)

##### Breadcrumbs: 

![atom screenshot](https://raw.githubusercontent.com/hex13/atom-lupa/master/screenshot-breadcrumbs.png)
Sidepanel:
![atom screenshot](https://raw.githubusercontent.com/hex13/atom-lupa/master/screenshot-1.png)
Project explorer:
![atom screenshot](https://raw.githubusercontent.com/hex13/atom-lupa/master/screenshot-2.png)

To allow full project indexing you have to create `lupaProject.json` in root directory of your project. Example file:
```
{
    "filePattern": "src/**/*.js",
    "autolabels": [
        ["angular", "angular"],
        ["foo", "foo"],
        ["numbers", "\\d+"],
    ]
}
```

# CHANGELOG
# 2016-05-03
* better AngularJS support (jumping to definition/location information)

# 2016-05-02
* deep search (e.g. params[0].name )

# 2016-05-01
* support for object literals
* support for CSS class names in JSX

# 2016-04-30
* settings: autoRefresh(on/off)
* filter by type (e.g. type:function)
* breadcrumbs (you must enable it in settings)

# 2016-04-29
* now it's possible to filter symbols by name
* better class preview in sidepanel
* project explorer now uses components from sidepanel
* changeColors button for users with light backgrounds 

# 2016-04-27
* better support for functions

# 2016-04-23
* redesign, rewrite, refactor
* support for TODOs
* fix bug with line highlighting in ProjectExplorer
* fix other bugs

# 2016-04-20
* Smalltalk-like project explorer

# 2016-04-16
* support for CoffeeScript

# 2016-04-15
* highlight labels

# 2016-04-12
* basic support for css/scss

# 2016-04-10
* fix bug when there is no node_modules in directory tree
* fix bug when there is no lupaProject.json in directory tree
* line count in color (green, yellow, orange, red)
* fix bug when user clicks on pane item which is not a text editor (e.g. settings)
* use react
* better list of files in dashboard (clickable and with loc colors)
# 2016-04-09

* list of files in separate pane item (dashboard)
* highlight function range in editor

# 2016-04-08

* support for @providesModule
* jump to function
* few other improvements

# 2016-04-03

* configurable indexing (config must be in lupaProject.json file)
* "autolabel" feature (define regexps in lupaProject.json file)
* feature: files that import current file
* bug: doesn't show imports like that import {aa} from 'aabc.js' (needed something like that  {from:'abc.js', name:'ss'} instead of strings)
* rewrite plugin to use new Lupa version
* fix bug that prevented pane to scroll (remove height: 100% from pane)
* regression: analysis is not done in separate process anymore

# 2016-03-17
* fix bug when switching to empty(non saved) file

# 2016-03-16
* experimental "go to definition" feature for angular modules

# 2016-03-16

* analyze files in separate process - to avoid freezing Atom.


LICENSES:
- Atom-Lupa: MIT

- The AngularJS logo design is licensed under a "[Creative Commons Attribution-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-sa/3.0/)"
