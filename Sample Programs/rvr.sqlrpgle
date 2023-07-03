**free
// -------------------------------------------------------------------------------------------------
// PROGRAM NAME: RVR
// DESCRIPTION : To Reverse the String and align it as per user's choice. (Right. Left or Centered)
//
//
// -------------------------------------------------------------------------------------------------

// -------------------------------------------------------------------------------------------------
// Definition of program control statements.
// -------------------------------------------------------------------------------------------------
  ctl-opt dftactgrp(*no) ;

// -------------------------------------------------------------------------------------------------
// Definition of display file.
// -------------------------------------------------------------------------------------------------
  dcl-f rvrd workstn Indds(indicator_ds);

// -------------------------------------------------------------------------------------------------
// Definition of procedures
// -------------------------------------------------------------------------------------------------
  dcl-pr ReverseIt char(30);
    *n char(30);
  end-pr;

// -------------------------------------------------------------------------------------------------
// Definition of Standalone Variables
// -------------------------------------------------------------------------------------------------
  dcl-s reversedString char(30) inz;
  dcl-s StartPos packed(2);


// -------------------------------------------------------------------------------------------------
// Definition of Data Structures
// -------------------------------------------------------------------------------------------------
  dcl-ds indicator_ds;
    exit                      ind pos(3);
    refresh                   ind pos(5);
    errorinput                ind pos(30);
    erroralign                ind pos(31);
  end-ds;


// -------------------------------------------------------------------------------------------------
// Definition of Constants
// -------------------------------------------------------------------------------------------------
  dcl-c TRUE const('1');
  dcl-c FALSE const('0');


// -------------------------------------------------------------------------------------------------
// Start of the Main logic
// -------------------------------------------------------------------------------------------------
*inlr = TRUE;

Dou  exit = TRUE;
  exfmt rvrr;
  outputd    = *blanks;
  errmsgd  = *blanks;
  errorinput = FALSE;
  erroralign = FALSE;

  // If user pressed F3, then exit the program
  if exit = TRUE;
    leave;
  endif;

  // If user pressed F5, then clear the fieds and display the screen again
  if refresh = TRUE;
    refresh  = FALSE;
    exit     = FALSE;
    errmsgd  = *blanks;
    inputd   = *blanks;
    alignd   = *blanks;
    outputd  = *blanks;
    iter;
  endif;

  // Validation of Input field
  if inputd    = *blanks;
    errmsgd    = 'Enter input';
    errorinput = TRUE;
    iter;
  endif;

  // Validation of Alignment field
  alignd = %upper(alignd);
  if alignd <> 'C' and
     alignd <> 'L' and
     alignd <> 'R' and
     alignd <> *blanks;

    errmsgd    = 'Invalid Alignment';
    erroralign =  TRUE;
    iter;
  endif;

  // Populate the result
  reversedString = reverseit(inputd);
    select;
  when alignd = 'C';
    startpos = %int((60 - (%len(%trim(reversedString))))/2) + 1;
    outputd = %replace(reversedString: outputd: StartPos);

  when alignd = 'L';
    outputd = %trim(reversedString);

  when alignd = 'R' or alignd = *blanks;
    evalR outputd = %trim(reversedString);
  endsl;

EndDo;

return;
// -------------------------------------------------------------------------------------------------
// Start of Sub-Procedures
// -------------------------------------------------------------------------------------------------
dcl-proc ReverseIt export;
  dcl-pi *n char(30);
    thisString char(30);
  end-pi;

  dcl-s TotalLength packed(3);
  dcl-s count packed(3);
  dcl-s endPos packed(3);
  dcl-s outString char(30) inz;

  dcl-c ONE const(1);

  thisString = %trim(thisString);
  totalLength = %len(%trim(thisString));
  endPos = TotalLength;
  for count = ONE to TotalLength;
    outString = %trim(outString) + %subst(thisString:endPos:ONE);
    endPos -= ONE;
  endfor;


  return outString;
end-proc;
