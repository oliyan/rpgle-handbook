**FREE

ctl-opt
 debug
 option(*nodebugio:*srcstmt)
 datfmt(*iso-) timfmt(*iso.)
 indent('| ') truncnbr(*yes) expropts(*resdecpos)
 copyright('| SAMPLEPNL V000 Example Single Page Subfile');

dcl-f nick workstn sfile(SFL01:rrn)  indDs(dspf);

dcl-s p_Indicators pointer inz(%addr(*in));
dcl-ds dspf qualified based(p_Indicators);
  help ind pos(01);
  exit ind pos(03);
  refresh ind pos(05);
  previous ind pos(12);
  pageup ind pos(25);
  pagedown ind pos(26);
  sflclr ind pos(32);
  sfldsp ind pos(30);
  sflctl ind pos(31);
  sflEnd   ind pos(35);
end-ds;

dcl-ds dsp_fields extname('SAMPLETBL') end-ds;

dcl-s rrn like(sflrrn);
dcl-s previousPosition like(position);
dcl-s pagesize zoned(2) inz(20);

exec sql
  set option commit = *none,
             closqlcsr = *endmod;

// initially let's force a refresh to load first page
dspf.refresh = *on;

dou dspf.exit or dspf.previous;

  if dspf.refresh;
    clear position;
    clearSubfile();
    setPosition();
    loadSubfile();
  elseif dspf.pageUp;
    setPosition();
    pageUp();
  elseif dspf.pagedown;
    pageDown();
  endif;

  showSubfile();

enddo;

*inlr = *on;
return;





// Clear Subfile procedure...
dcl-proc clearSubfile;

  dspf.sflEnd = *off;
  dspf.sflclr = *on;
  write ctl01;
  dspf.sflclr = *off;

end-proc;





// Build Subfile procedure...
dcl-proc loadSubfile;

  dspf.sflEnd = *off;
  rrn = 0;

  exec sql
    fetch next from mycursor
      into :dsp_fields;

  previousPosition = code;

  dow sqlcode >= 0 and sqlcode < 100;
    rrn += 1;
    write SFL01;
    if rrn = pagesize;
      leave;
    endif;

    exec sql
      fetch next from mycursor
        into :dsp_fields;
  enddo;

  // if we didnt load a full page then set END OF SUBFILE
  if rrn < pagesize;
    dspf.sflEnd = *on;
  endif;

end-proc;





// Display Subfile procedure...
dcl-proc showSubfile;

  if rrn > 0;
    dspf.sfldsp = *on;
  else;
    dspf.sfldsp = *off;
    errormsg = 'No data loaded from SAMPLETBL!';
  endif;

  dspf.sflctl = *on;

  write cmd01;
  exfmt ctl01;

  clear ERRORMSG;

end-proc;





// Declare cursor procedure...
dcl-proc setPosition;

  exec sql
    close mycursor;

  exec sql
    declare mycursor scroll cursor for
      select code,
             forename,
             surname,
             birthday,
             phone,
             email,
             street1,
             street2,
             city,
             statecode,
             zip,
             country
        from sampletbl
        where code >= :position
        order by code
        for read only;

  exec sql
    open mycursor;

end-proc;





// Page up procedure...
dcl-proc pageUp;

  // set start cursor RRN at first row of previous page
  if rrn = pagesize;
    position = previousPosition;
  else;
    clear position;
  endif;

  // Build the subfile starting at *position*
  clearSubfile();
  loadSubfile();

  // If the cursor already in the top the list
  if rrn <= pagesize;
    errormsg = 'Start of customer list';
  endif;

end-proc;





// Page down procedure...
dcl-proc pageDown;

  // Build the subfile starting at *position*
  clearSubfile();
  loadSubfile();

  // If more to read then show sflend
  if rrn < pagesize;
    errormsg = 'You have reached the bottom of the customer list.';
  endif;

end-proc;
// -- end of code -- 