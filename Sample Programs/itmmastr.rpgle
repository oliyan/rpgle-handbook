**free
// -------------------------------------------------------------------------------------------------
// PROGRAM NAME: ITMASTER
// DESCRIPTION : Maintain ITMMAST (Item Master File).
//
//
// -------------------------------------------------------------------------------------------------

// -------------------------------------------------------------------------------------------------
// Definition of program control statements.
// -------------------------------------------------------------------------------------------------
  ctl-opt option(*nodebugio:*srcstmt:*nounref) dftactgrp(*no);

// -------------------------------------------------------------------------------------------------
// Definition of display file.
// -------------------------------------------------------------------------------------------------
  dcl-f itmmastd workstn Indds(subfile) sfile(ITSFL:D_RRN);
  dcl-f itmmastf usage(*update) keyed;


// -------------------------------------------------------------------------------------------------
// Definition of Standalone Variables
// -------------------------------------------------------------------------------------------------

dcl-s rrn like(D_RRN);
dcl-s previousPosition like(D_POSTO);
dcl-s position like(D_POSTO);

// -------------------------------------------------------------------------------------------------
// Definition of SubProcedures
// -------------------------------------------------------------------------------------------------
dcl-pr validate_sf char(1);
end-pr;


// -------------------------------------------------------------------------------------------------
// Definition of Data Structures
// -------------------------------------------------------------------------------------------------
  dcl-s p_Indicators pointer inz(%addr(*in));
  dcl-ds subfile qualified based(p_Indicators);
    exit        ind pos(03);
    refresh     ind pos(05);
    previous    ind pos(12);
    pageup      ind pos(25);
    pagedown    ind pos(26);
    dsp         ind pos(31);
    ctl         ind pos(32);
    clr         ind pos(33);
    isEnd       ind pos(34);
  end-ds;

  dcl-ds PgmDs psds qualified;
    PgmName *proc;
  end-ds;


// -------------------------------------------------------------------------------------------------
// Definition of Global Constants
// -------------------------------------------------------------------------------------------------
  dcl-c TRUE const('1');
  dcl-c FALSE const('0');
  dcl-c PageSize const(5);

// -------------------------------------------------------------------------------------------------
// Start of the Main logic
// -------------------------------------------------------------------------------------------------
*inlr = TRUE;


  Initialize();

  dow subfile.exit = FALSE;
    if validate_sf() = TRUE;
      process_sf();
    endif;
    Display_sf();
  enddo;


return;
// -------------------------------------------------------------------------------------------------
// Start of Sub-Procedures
// -------------------------------------------------------------------------------------------------

// Initialize for the first run.
dcl-proc Initialize;
  Clear_sf();
  clear position;
  SetPointer();
  Load_sf();
  Display_sf();
end-proc;

// Clear subfile before loading
dcl-proc Clear_sf;
  subfile.isEnd = FALSE;
  subfile.clr = TRUE;
  write ITCTL;
  subfile.clr = FALSE;
end-proc;

// Load the subfile
dcl-proc Load_sf;
  subfile.isEnd = FALSE;
  D_RRN = 0;

  read itmmastf;
  if not %eof(itmmastf);
    PreviousPosition = ITNUM;
  endif;

  dow not %eof(itmmastf);
    D_RRN += 1;
    D_ITNUM    = ITNUM;
    D_ITDESC   = ITDESC;
    D_ITPRICE  = ITPRICE;
    D_ITQTY    = ITQTY;

    write ITSFL;

    if D_RRN = PageSize;
      leave;
    endif;

    read itmmastf;

  enddo;

  //
  if %eof(itmmastf) = TRUE;
    subfile.isEnd = TRUE;
    //setgt (ITNUM) itmmastf;
  endif;

end-proc;


// Set the pointer for the record access.
dcl-proc SetPointer;
    setll (position) itmmastf;
end-proc;

// Display the subfile.
dcl-proc Display_sf;

   write ITFOOTER;
   write ITHEADER;
  if D_RRN > 0;
    subfile.dsp = TRUE;
  else;
    subfile.dsp = FALSE;
    write itempty;
  endif;

  subfile.ctl = TRUE;
  exfmt ITCTL;
  D_ERROR = *blanks;

end-proc;


// Validate the Main Subfile
dcl-proc validate_sf;
  dcl-pi *n char(1);
  end-pi;
  
  dcl-s isError char(1) inz('0');

  dcl-c TRUE const('1');
  dcl-c FALSE const('0');

  // If both position to and search are entered.
  if D_POSTO  <> *zeros and 
     D_SEARCH <> *blanks;

    D_ERROR = 'Enter either Position-to or Search field';
    return FALSE;
  endif;

  if isError = FALSE;
    return TRUE;
  endif;
end-proc;

// Process the user input
dcl-proc process_sf;
  
  if subfile.pagedown = TRUE;
    Clear_sf();
    Load_sf();


  elseif subfile.pageup = TRUE;
    Clear_sf();
    PageUp();
    SetPointer();
    Load_sf();

  endif;

  return;
end-proc;

// Set the pointer to previous page. 
dcl-proc PageUp;
  dcl-s counter packed(2) inz;
  dcl-s endpoint packed(2) inz;

  endpoint = 2 * pagesize;
  setgt (itnum) itmmastf;
  for counter = 1 to endpoint;
    readp itmmastf;
  endfor;
  position = ITNUM;
end-proc;