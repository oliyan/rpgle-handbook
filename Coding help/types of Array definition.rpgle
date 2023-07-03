**free
// Run Time Array definition using Standalone
dcl-s RT_Array varchar(20) dim(12) inz;
// Population of array
RT_Array(1) = 'Jan'
RT_Array(2) = 'Feb'
RT_Array(3) = 'Mar'
//...
RT_Array(12) = 'Dec'

// Run Time Array definition using Data Structure
dcl-ds month qualified inz; 
   name varchar(20) dim(12)
end-ds;
// Population of array
month.name(1) = 'Jan';
month.name(2) = 'Feb';
//...
month.name(12) = 'Dec';

// Compile Time Array
dcl-ds months varchar(20) dim(12) ctdata; // ctdata keyword specifies it as CT array.
// Population of array
**CTDATA months
Jan
Feb
...
Dec
