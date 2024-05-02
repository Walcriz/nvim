if exists("b:current_syntax")
    finish
endif

let s:save_cpo = &cpo
set cpo&vim

syn match htcComment '#.*$'

syntax match htcStringEscape '\v\\%([abfnrtv'"\\]|x[[0-9a-fA-F]]\{2}|25[0-5]|2[0-4][0-9]|[0-1][0-9][0-9])' contained

syntax region htcString start=/"/ skip=/\\\\\|\\"/ end=/["^\n]/ excludenl contains=htcStringEscape,@Spell,htcStringInterp
syntax region htcString start=/'/ skip=/\\\\\|\\'/ end=/['^\n]/ excludenl contains=htcStringEscape,@Spell,htcStringInterp

syntax match htcNumber "\v\c<[-+]?\d*\.?\d*%([eE][-+]?\d+)?>"
syntax match htcNumber "\v\c<[-+]?0x[0-9A-F]*\.?[0-9A-F]*>"

syn match htcDelimiter '[{}()\[\],.]'
syn match htcOperator '[-+/*=]'

syn keyword htcBoolean true false

" targets: {
"     target: target_filter {
"         mode: closest_angle
"         type: entity_type[type="mobs"]
"         max_distance: 15
"         max_angle: 30
"         max_targets: 4
"     }
" }
"
" target_filter is class
" math 'hwelk920_2 {'
syn match htcClass '\([a-zA-Z][a-zA-Z0-9_]*\)\ze\s*{'

" Define a generic syntax region for key-value pairs
syn region htcKeyValuePair start="^\s*\w\+:" end="$" contains=htcKey,htcValue transparent

" Define a syntax group for the key part (e.g., "time:", "type:", etc.)
syn match htcKey "\v^\s*\w+:"

" Define a syntax group for the value part (anything after the key part)
syn match htcValue "\v[^:]*$" contains=htcString,htcNumber,htcOperator,htcClass,htcComment,htcBoolean,htcKeyValuePair,htcDelimiter

syntax region htcTable matchgroup=htcDelimiter start='{' end='}' fold transparent
syntax region htcMap matchgroup=htcDelimiter start='\[' end='\]' fold transparent

" Vim commentary support
setlocal commentstring=#\ %s

syntax sync fromstart

hi def link htcComment Comment
hi def link htcString String
hi def link htcNumber Number
hi def link htcOperator Operator
hi def link htcClass Function
hi def link htcStringEscape Operator
hi def link htcAssign Delimiter
hi def link htcBoolean Boolean
hi def link htcKey Special

hi def link htcDelimiter Delimiter

let b:current_syntax = "htc"

let &cpo = s:save_cpo
unlet s:save_cpo
