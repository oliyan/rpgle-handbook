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


// -------------------------------------------------------------------------------------------------
// Definition of Standalone Variables
// -------------------------------------------------------------------------------------------------

dcl-s rrn like(D_RRN);
dcl-s PreviousPosition like(D_POSTO);
dcl-s PageSize zoned(2) inz(20);


// -------------------------------------------------------------------------------------------------
// Definition of Data Structures
// -------------------------------------------------------------------------------------------------
  dcl-s p_Indicators pointer inz(%addr(*in));
  dcl-ds subfile qualified based(p_Indicators);
    help        ind pos(01);
    exit        ind pos(03);
    refresh     ind pos(05);
    previous    ind pos(12);
    pageup      ind pos(25);
    pagedown    ind pos(26);
    clr         ind pos(32);
    dsp         ind pos(30);
    ctl         ind pos(31);
    isEnd       ind pos(35);
  end-ds;

  dcl-ds PgmDs psds qualified;
    PgmName *proc;
  end-ds;

// -------------------------------------------------------------------------------------------------
// Definition of Global Constants
// -------------------------------------------------------------------------------------------------
  dcl-c TRUE const('1');
  dcl-c FALSE const('0');


// -------------------------------------------------------------------------------------------------
// Start of the Main logic
// -------------------------------------------------------------------------------------------------
*inlr = TRUE;

  Initialize();



return;
// -------------------------------------------------------------------------------------------------
// Start of Sub-Procedures
// -------------------------------------------------------------------------------------------------
dcl-proc Initialize;
  Clear_sf();
  Load_sf();
  Display_sf();
end-proc;


dcl-proc Clear_sf;
  subfile.end = FALSE;
  subfile.clr = TRUE;
  write ITCTL;
  subfile.clr = FALSE;
end-proc;

dcl-proc Load_sf;

end-proc;

dcl-proc Display_sf;
  D_RRN = *zeros;
end-proc;
