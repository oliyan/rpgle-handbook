// --------------------------------------------------------------
//                        EX6
// --------------------------------------------------------------
**free
  ctl-opt dftactgrp(*no) ;

  dcl-pr IsPrimeNumber char(1);
    thisNumber packed(2);
  end-pr;

  dcl-s primeCount packed(2) inz(0);
  dcl-s thisNum packed(2) inz(1);
  dcl-s result char(52);

  dcl-c TRUE const('1');
  dcl-c START const(1);
  dcl-c END const(100);
  dcl-c COMMA const (',');

  for thisNum = START to END;
  if IsPrimeNumber(thisNum) = TRUE;
    if result = *blanks;
      result = %char(thisNum);
    else;
      result = %trim(result) + COMMA + %char(thisNum);
    endif;
    primeCount += 1;
  endif;
  if primeCount = 20;
    leave;
  endif;
endfor;

dsply result;
*inlr = TRUE;


dcl-proc IsPrimeNumber export;
  dcl-pi *n char(1);
    thisNumb packed(2);
  end-pi;

  dcl-s end packed(3);
  dcl-s count packed(3);

  dcl-c TRUE const('1');
  dcl-c FALSE const('0');
  dcl-c START const(2);

  end = %int(thisNumb/START);

  if thisNumb < START;
    return FALSE;
  endif;

  for count = START to end;
    if %rem(thisNumb:count) = 0;
      return FALSE;
    endif;
  endfor;

  return TRUE;
end-proc;
