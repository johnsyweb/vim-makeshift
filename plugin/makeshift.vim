if exists("g:loaded_makeshift") || &cp || version < 700
    finish
endif
let g:loaded_makeshift = 0.1
let s:keepcpo = &cpo
set cpo&vim

function! s:build_defaults()
    let s:build_systems = {
                \'Jamfile': 'bjam',
                \'Makefile': 'make',
                \'Rakefile': 'rake',
                \'SConstruct': 'scons',
                \'build.xml': 'ant',
                \'pom.xml': 'mvn',
                \}
endfunction


function! s:add_user_systems()
    if exists("g:makeshift_systems")
        call extend(s:build_systems, g:makeshift_systems, "force")
    endif
endfunction


function! s:remove_user_systems()
    if exists("g:makeshift_ignored")
        for l:ignored in g:makeshift_ignored
            try
                call remove(s:build_systems, l:ignored)
            catch
                " NOOP
            endtry
        endfor
    endif
endfunction


function! s:determine_build_system()
    for [l:filename, l:program] in items(s:build_systems)
        if filereadable(l:filename)
            execute "setlocal makeprg=" . l:program
            break
        endif
    endfor
endfunction


function! s:makeshift()
    call s:build_defaults()
    call s:remove_user_systems()
    call s:add_user_systems()
    call s:determine_build_system()
endfunction


if !exists(":Makeshift")
    command -nargs=0 Makeshift :call s:makeshift()
endif


if !exists("g:makeshift_on_startup") || g:makeshift_on_startup
    call s:makeshift()
endif


let &cpo=s:keepcpo
unlet s:keepcpo
" vim:noet:sw=4:ts=4:ft=vim
