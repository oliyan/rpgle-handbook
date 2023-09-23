**free
// Declaring as a template
dcl-ds personal_info_T qualified template;
    first_name varchar(25);
    date_of_birth date;
end-ds;

// This template can be used to declare DS and Arrays.
dcl-ds personal_info likeds(personal_info_T) inz;
dcl-ds personal_info_array likeds(personal_info_T) dim(20) inz;

personal_info.first_name = 'Ravi';
personal_info.date_of_birth = %date('1991-10-11': *iso);

personal_info_array(1) = personal_info;


