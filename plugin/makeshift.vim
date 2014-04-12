if exists('g:loaded_makeshift') || &cp || version < 700
    finish
endif

let g:loaded_makeshift = 1
let s:default_autochdir = &autochdir
let s:keepcpo = &cpo
set cpo&vim

function! s:build_defaults()
    let s:build_systems = {
                \'Jamfile': 'bjam',
                \'Makefile': 'make',
                \'Rakefile': 'rake',
                \'SConstruct': 'scons',
                \'build.gradle': 'gradle',
                \'build.xml': 'ant',
                \'mix.exs': 'mix',
                \'pom.xml': 'mvn',
                \}
endfunction

function! s:add_user_systems()
    if exists('g:makeshift_systems')
        call extend(s:build_systems, g:makeshift_systems, 'force')
    endif
endfunction

function! s:remove_user_systems()
    if exists('g:makeshift_ignored')
        for l:ignored in g:makeshift_ignored
            try
                echomsg "Ignoring" . l:ignored
                call remove(s:build_systems, l:ignored)
            catch
                " NOOP
            endtry
        endfor
    endif
endfunction

function! s:determine_build_system(dir)
    for [l:filename, l:program] in items(s:build_systems)
        let l:found = globpath(a:dir, l:filename)
        if filereadable(l:found)
            let b:makeshift_root = fnameescape(a:dir)
            return l:program
        endif
    endfor

    let l:parent = fnamemodify(a:dir, ':h')
    if l:parent != a:dir
        return s:determine_build_system(l:parent)
    endif

    return ''
endfunction

function! s:set_makeprg(program)
    if len(a:program)
        let &l:makeprg=a:program
    endif
endfunction

function! s:set_makedir(change_dir)
    if a:change_dir
        if exists('g:makeshift_chdir') && g:makeshift_chdir
            setlocal noautochdir
            if exists('b:makeshift_root')
                exec "cd! " . b:makeshift_root
            endif
        endif
    elseif exists('g:makeshift_chdir') && g:makeshift_chdir
        let &autochdir = s:default_autochdir
    endif
endfunction

function! s:makeshift()
    call s:build_defaults()
    call s:remove_user_systems()
    call s:add_user_systems()
    let l:program = s:determine_build_system(expand('%:p:h'))
    call s:set_makeprg(l:program)
    call s:set_makedir(len(l:program) > 0)
endfunction

function s:make_from_root(...)
    exec "cd! " . b:makeshift_root
    exec "make " . join(a:000)
    cd! -
endfunction

if exists(':Makeshift') != 2
    if !exists('g:makeshift_define_command') || g:makeshift_define_command != 0
        command -nargs=0 Makeshift :call s:makeshift()
    endif
endif

if exists(':MakeshiftBuild') != 2
    command -nargs=* MakeshiftBuild :call s:make_from_root(<q-args>)
endif

if !exists('g:makeshift_on_startup') || g:makeshift_on_startup
    call s:makeshift()
endif

if !exists('g:makeshift_on_bufread') || g:makeshift_on_bufread
    autocmd BufRead * call s:makeshift()
endif

if !exists('g:makeshift_on_bufnewfile') || g:makeshift_on_bufnewfile
    autocmd BufNewFile * call s:makeshift()
endif

if !exists('g:makeshift_on_bufenter') || g:makeshift_on_bufenter
    autocmd BufEnter * call s:makeshift()
endif

let &cpo=s:keepcpo
unlet s:keepcpo
" vim: et:sw=4:ts=8:ft=vim
