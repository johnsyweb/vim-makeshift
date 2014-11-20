Makeshift
=========

Plugin for detecting your build system.

Introduction
------------

You'll want to use this plugin if you work on a lot of projects with different
build systems. You want your editor to be able to detect your current build
system and set `'makeprg'` accordingly.

To make building really fast, map the `:make` command to a function key in
your vimrc.

```vim
nnoremap <F5> :<C-U>make<CR>
```

Installation
------------

I recommend installing [pathogen.vim](https://github.com/tpope/vim-pathogen),
and then simply copy and paste:

```sh
cd ~/.vim/bundle
git clone git://github.com/johnsyweb/vim-makeshift.git
vim -cHelptags
```

Once help tags have been generated, you can view the manual with

```vim
:help makeshift
```

How it works
------------

This plug-in works by looking for known build files in the current working
directory upwards, and sets `'makeprg'`; by default this happens on start-up.
You can use the command to re-evaluate `'makeprg'`:

```vim
:Makeshift
```

Sometimes your build script won't be in the current working directory, this is
particularly common when `'autochdir'` is set. For this reason `:Makeshift` sets
`b:makeshift_root` to be the directory containing the build script that it used
to determine the build system.

`:MakeshiftBuild` is a wrapper around Vim's own `:make` command, which changes
directory to `b:makeshift_root` before calling `:make` with any arguments you
provide and then returns to your working directory. If you often work in
subdirectories, you may want to map the `:MakeshiftBuild` command to a function
key in your `vimrc`:

```vim
nnoremap <F5> :<C-U>MakeshiftBuild<CR>
nnoremap <F6> :<C-U>MakeshiftBuild check<CR>
...
```

Alternatively you can use the `makeshift_chdir` option to automatically change
the current working directory to the one containing your build script.

==============================================================================

Settings
--------

To tune the behaviour of this plugin, add any of the following switches to
your `vimrc`:

    let g:makeshift_on_startup = 0

To prevent Makeshift from setting `'makeprg'` on
[BufRead](http://vimdoc.sourceforge.net/htmldoc/autocmd.html#BufRead):

    let g:makeshift_on_bufread = 0

To prevent Makeshift from setting `'makeprg'` on
[BufNewFile](http://vimdoc.sourceforge.net/htmldoc/autocmd.html#BufNewFile):

    let g:makeshift_on_bufnewfile = 0

To prevent Makeshift from setting `'makeprg'` on
[BufEnter](http://vimdoc.sourceforge.net/htmldoc/autocmd.html#BufEnter):

    let g:makeshift_on_bufenter = 0

To automatically change directory to `'b:makeshift_root'` when it is discovered:

    let g:makeshift_chdir = 1

To try the build file in the current directory before searching from the file directory:

    let g:makeshift_use_pwd_first = 1

Build Systems
-------------

Makeshift currently associates the following files with their build systems:

    * Jamfile: bjam
    * Makefile: make
    * GNUmakefile: make
    * Rakefile: rake
    * SConstruct: scons
    * build.gradle: gradle
    * build.xml: ant
    * mix.exs: mix
    * pom.xml: mvn
    * build.ninja: ninja

Adding a new build system
-------------------------

If Makeshift doesn't already know about your build system, or you wish to
override the default program for a given file, you can define a dictionary,
which has filenames as keys and corresponding programs as values.

```vim
let g:makeshift_systems = {
    \'build.sbt ': 'sbt',
    \}
```


Removing a build system
-----------------------

If you don't want Makeshift to set `'makeprg'` for a given build system, you
can disable it by defining a list of the files to ignore.

```vim
let g:makeshift_ignored = ['Jamfile']
```

License
-------

Makeshift is licensed under the same terms as Vim itself (see [`:help
license`](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license)).

Thanks
------

If you find this plug-in useful, please follow this repository on
[GitHub](https://github.com/johnsyweb/vim-makeshift) and vote for it
[vim.org](http://www.vim.org/scripts/script.php?script_id=4278). If you have
something to say, you can contact [johnsyweb](http://johnsy.com/about/) on
[Twitter](http://twitter.com/johnsyweb/) and
[GitHub](https://github.com/johnsyweb/).

Many thanks
-----------

I'm grateful for contributions to what was a solo project (hooray for [GitHub
:octocat:](http://github.com/))! If you'd like to thank the contributors, you
can find their details here:

https://github.com/johnsyweb/vim-makeshift/graphs/contributors

