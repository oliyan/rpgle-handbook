**free                                                  
  exec sql SET OPTION COMPILEOPT = 'DBGVIEW(*SOURCE)';  
                                                        
  dcl-f ex2d workstn;                                   
                                                        
  dcl-c TRUE const('1');                                
                                                        
  dow *in12 = *off;                                     
    exfmt datetest;                                     
    test(de) *mdy dated;                                
    if (%error);                                        
      *in69 = *on;                                      
    else;                                               
      *in69 = *off;                                     
    endif;                                              
  enddo;                                                

*inlr = TRUE;