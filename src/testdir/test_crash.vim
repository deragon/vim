" Some tests, that used to crash Vim
source check.vim
source screendump.vim

CheckScreendump

func Test_crash1()
  if !executable('sh')
    throw 'Skipped: sh not executable!'
  endif
  " The following used to crash Vim
  let opts = #{cmd: 'sh'}
  let vim  = GetVimProg()

  let buf = RunVimInTerminal('sh', opts)

  let file = 'crash/poc_huaf1'
  let cmn_args = "%s -u NONE -i NONE -n -e -s -S %s -c ':qa!'"
  let args = printf(cmn_args, vim, file)
  call term_sendkeys(buf, args ..
    \ '  && echo "crash 1: [OK]" > X_crash1_result.txt' .. "\<cr>")
  call TermWait(buf, 50)

  let file = 'crash/poc_huaf2'
  let args = printf(cmn_args, vim, file)
  call term_sendkeys(buf, args ..
    \ '  && echo "crash 2: [OK]" >> X_crash1_result.txt' .. "\<cr>")
  call TermWait(buf, 50)

  let file = 'crash/poc_huaf3'
  let args = printf(cmn_args, vim, file)
  call term_sendkeys(buf, args ..
    \ '  && echo "crash 3: [OK]" >> X_crash1_result.txt' .. "\<cr>")
  call TermWait(buf, 100)

  let file = 'crash/bt_quickfix_poc'
  let args = printf(cmn_args, vim, file)
  call term_sendkeys(buf, args ..
    \ '  && echo "crash 4: [OK]" >> X_crash1_result.txt' .. "\<cr>")
  " clean up
  call delete('Xerr')

  " This test takes a bit longer
  call TermWait(buf, 200)

  " clean up
  call delete('Xerr')
  exe buf .. "bw!"

  sp X_crash1_result.txt

  let expected = [
      \ 'crash 1: [OK]',
      \ 'crash 2: [OK]',
      \ 'crash 3: [OK]',
      \ 'crash 4: [OK]',
      \ ]

  call assert_equal(expected, getline(1, '$'))
  bw!

  call delete('X_crash1_result.txt')
endfunc

func Test_crash2()
  " The following used to crash Vim
  let opts = #{wait_for_ruler: 0, rows: 20}
  let args = ' -u NONE -i NONE -n -e -s -S '
  let buf = RunVimInTerminal(args .. ' crash/vim_regsub_both', opts)
  call VerifyScreenDump(buf, 'Test_crash_01', {})
  exe buf .. "bw!"
endfunc

" vim: shiftwidth=2 sts=2 expandtab