Makeshift
=========

Selects the right 'makeprg' for your build system

Introduction
------------

I wrote this plugin because I work on a lot of projects with different build
systems. I wanted Vim to be able to detect my current build system and set
[`'makeprg'`](http://vimdoc.sourceforge.net/htmldoc/options.html#'makeprg')
accordingly.

To make building really fast, map the
[`:make`](http://vimdoc.sourceforge.net/htmldoc/quickfix.html#:make_makeprg)
command to a function key in your `$VIMRC`:

```vim
    nnoremap    <F5>   :<C-U>make<CR>
```

Installation
------------

I recommend installing [pathogen.vim](https://github.com/tpope/vim-pathogen),
and then simply copy and paste:

```sh
    cd ~/.vim/bundle
    git clone git://github.com/johnsyweb/vim-makeshift.git
```

Restart Vim and then:

```vim
    :Helptags
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
particularly common when `'autochdir'` is set. For this reason :Makeshift sets
g:makeshift_root to be the directory containing the build script that it used to
determine the build system.

`:MakeshiftBuild` is a wrapper around Vim's own `:make` command, which changes
directory to `g:makeshift_root` before calling `:make` with any arguments you
provide and then returns to your working directory. If you often work in
subdirectories, you may want to map the `:MakeshiftBuild` command to a function
key in your `vimrc`:

```vim
    nnoremap    <F5>   :<C-U>MakeshiftBuild<CR>
    nnoremap    <F6>   :<C-U>MakeshiftBuild check<CR>
    ...
```

Settings
--------

To prevent Makeshift from setting `'makeprg'` on start-up, put the following
in your `vimrc`:

    let g:makeshift_on_startup = 0

To prevent Makeshift from setting `'makeprg'` on
[BufRead](http://vimdoc.sourceforge.net/htmldoc/autocmd.html#BufRead), put the
following in your `vimrc`:

    let g:makeshift_on_bufread = 0

Build Systems
-------------

Makeshift currently associates the following files with their build systems:

    * Jamfile: bjam
    * Makefile: make
    * Rakefile: rake
    * SConstruct: scons
    * build.gradle: gradle
    * build.xml: ant
    * pom.xml: mvn

Adding a new build system
-------------------------

If Makeshift doesn't already know about your build system, or you wish to
override the default program for a given file, you can define a dictionary,
which has filenames as keys and corresponding programs as values.

    let g:makeshift_systems = {
        \'build.ninja ': 'ninja',
        \}


Removing a build system
-----------------------

If you don't want Makeshift to set `'makeprg'` for a given build system, you
can disable it by defining a list of the files to ignore.

    let g:makeshift_ignored = ['Jamfile']

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

