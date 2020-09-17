Creating spss tables from a sas datasets best methods sas r and python                                           
                                                                                                                 
GitHub                                                                                                           
https://tinyurl.com/yytsork7                                                                                     
https://github.com/rogerjdeangelis/utl-creating-spss-tables-from-a-sas-datasets-using-sas-r-and-python           
                                                                                                                 
Creating-a-SPSS-table-from-a-SAS-dataset-best-methods;                                                           
                                                                                                                 
  Three Methods ( R appears to be better? Non of the languages handled the dataset label)                        
                                                                                                                 
       a. R Best (handles format catalog directly (only tested date, datetime, simple                            
          character and numeric user forms, numeric value for date and datetime                                  
          was mapped correctly to SPSS -- 0 date is Number of seconds since October 14, 1582. )                  
                                                                                                                 
       b. Could not get SAS to handle the format catalog or a format control in dataset.                         
          (I may not have coded it correctly, I have very little knowledge of 'proc export')                     
          ( Also sas seems to apply the wrong format to datetime - easily fixed)                                 
                                                                                                                 
       c. Could not get python packages to create SPSS labels from sas user formats.                             
          Python did apply the formats changing the type of a numeric variable to character                      
          value containing the label. Python changes the data by applying formats)                               
          (I may not have coded it correctly)                                                                    
/*                   _                                                                                           
(_)_ __  _ __  _   _| |_                                                                                         
| | `_ \| `_ \| | | | __|                                                                                        
| | | | | |_) | |_| | |_                                                                                         
|_|_| |_| .__/ \__,_|\__|                                                                                        
        |_|                                                                                                      
*/                                                                                                               
                                                                                                                 
proc format lib=sd1.torpy;                                                                                       
                                                                                                                 
  value $sex                                                                                                     
      "M"="Male"                                                                                                 
      "F"="Female"                                                                                               
  ;                                                                                                              
  value logi                                                                                                     
     1 = "TRUE"                                                                                                  
     0 = "FALSE"                                                                                                 
  ;                                                                                                              
run;quit;                                                                                                        
                                                                                                                 
proc format lib=sd1.torpy cntlout=sd1.sas_cntl_out;                                                              
run;quit;                                                                                                        
                                                                                                                 
options fmtsearch=(sd1.torpy work.formats);                                                                      
libname sd1 "d:/sd1";                                                                                            
data sd1.have(label="student data");                                                                             
  retain name;                                                                                                   
  format date ddmmyyd10. datetym  DATETIME. name $8. age z4. sex $1. weight e8.1 height 4.                       
         sex $sex. logic logi.;                                                                                  
  label                                                                                                          
       name ="student name"                                                                                      
        age ="student age"                                                                                       
        sex ="student sex"                                                                                       
     height ="student height"                                                                                    
     weight ="student weight"                                                                                    
  ;                                                                                                              
  set sashelp.class;                                                                                             
  logic=mod(_n_,2);                                                                                              
  date    = today();                                                                                             
  datetym = datetime();                                                                                          
run;quit;                                                                                                        
                                                                                                                 
/*                                                                                                               
                                                                                                                 
                Variables in Creation Order                                                                      
                                                                                                                 
    Variable    Type    Len    Format        Label                                                               
                                                                                                                 
    NAME        Char      8    $8.           student name                                                        
    DATE        Num       8    DDMMYYD10.                                                                        
    DATETYM     Num       8    DATETIME.                                                                         
    AGE         Num       8    Z4.           student age                                                         
    SEX         Char      1    $SEX.         student sex                                                         
    WEIGHT      Num       8    E8.1          student weight                                                      
    HEIGHT      Num       8    4.            student height                                                      
    LOGIC       Num       8    LOGI.                                                                             
                                                                                                                 
                                                                                                                 
Up to 40 obs from SD1.HAVE total obs=19                                                                          
                                                                                                                 
Obs    NAME        DATE       DATETYM      AGE    SEX    WEIGHT    HEIGHT    LOGIC                               
                                                                                                                 
  1    Joyce      22175    1915985669.3     11     F       50.5     51.3       1                                 
  2    Louise     22175    1915985669.3     12     F       77.0     56.3       0                                 
  3    Alice      22175    1915985669.3     13     F       84.0     56.5       1                                 
  4    James      22175    1915985669.3     12     M       83.0     57.3       0                                 
....                                                                                                             
                                                                                                                 
                                                                                                                 
/*           _               _                                                                                   
  ___  _   _| |_ _ __  _   _| |_                                                                                 
 / _ \| | | | __| `_ \| | | | __|                                                                                
| (_) | |_| | |_| |_) | |_| | |_                                                                                 
 \___/ \__,_|\__| .__/ \__,_|\__|                                                                                
 ____           |_|                                                                                              
|  _ \                                                                                                           
| |_) |                                                                                                          
|  _ <                                                                                                           
|_| \_\                                                                                                          
                                                                                                                 
*/                                                                                                               
                                                                                                                 
 R CAPTURES ALL ATTRIBUTES EXCEPT THE DATASET LABEL, "Student Data"                                              
 ==================================================================                                              
                                                                                                                 
 $ NAME   : chr [1:19] "Joyce" "Louise" "Alice" "James" ...                                                      
  ..- attr(*, "label")= chr "student name"                                                                       
  ..- attr(*, "format.sas")= chr "$"                                                                             
                                                                                                                 
 $ DATE   : Date[1:19], format: "2020-09-17" "2020-09-17" ...                                                    
                                                                                                                 
 $ DATETYM: POSIXct[1:19], format: "2020-09-17 18:14:29" "2020-09-17 18:14:29" ...                               
                                                                                                                 
 $ AGE    : num [1:19] 11 12 13 12 11 12 12 15 13 14 ...                                                         
  ..- attr(*, "label")= chr "student age"                                                                        
  ..- attr(*, "format.sas")= chr "Z"                                                                             
                                                                                                                 
 $ SEX    : chr+lbl [1:19] F, F, F, M, M, M, F, F, M, F, M, F, M, F, F, M, M, M, M                               
   ..@ label     : chr "student sex"                                                                             
   ..@ format.sas: chr "$SEX"                                                                                    
   ..@ labels    : Named chr [1:2] "M" "F"                                                                       
   .. ..- attr(*, "names")= chr [1:2] "Male" "Female"                                                            
                                                                                                                 
 $ WEIGHT : num [1:19] 50.5 77 84 83 85 ...                                                                      
  ..- attr(*, "label")= chr "student weight"                                                                     
  ..- attr(*, "format.sas")= chr "E"                                                                             
                                                                                                                 
 $ HEIGHT : num [1:19] 51.3 56.3 56.5 57.3 57.5 59 59.8 62.5 62.5 62.8 ...                                       
  ..- attr(*, "label")= chr "student height"                                                                     
                                                                                                                 
 $ LOGIC  : dbl+lbl [1:19] 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1                               
   ..@ format.sas: chr "LOGI"                                                                                    
   ..@ labels    : Named num [1:2] 1 0                                                                           
   .. ..- attr(*, "names")= chr [1:2] "TRUE" "FALSE"                                                             
                                                                                                                 
 - attr(*, "label")= chr "HAVE                                                                                   
                       "                                                                                         
Note SPSS has the correct dates and formatting (SAS user formats were converted to SPSS label)                   
                                                                                                                 
Data List                                                                                                        
   NAME         DATE          DATETYM    AGE   WEIGHT   HEIGHT    LOGIC    SEX                                   
---------------------------------------------------------------------------------                                
  Joyce   09/17/2020 2020-09-17 16:29  11.00    50.50    51.30     TRUE    Female                                
 Louise   09/17/2020 2020-09-17 16:29  12.00    77.00    56.30     FALSE   Female                                
  Alice   09/17/2020 2020-09-17 16:29  13.00    84.00    56.50     TRUE    Female                                
  James   09/17/2020 2020-09-17 16:29  12.00    83.00    57.30     FALSE   Male                                  
 Thomas   09/17/2020 2020-09-17 16:29  11.00    85.00    57.50     TRUE    Male                                  
   John   09/17/2020 2020-09-17 16:29  12.00    99.50    59.00     FALSE   Male                                  
   Jane   09/17/2020 2020-09-17 16:29  12.00    84.50    59.80     TRUE    Female                                
  Janet   09/17/2020 2020-09-17 16:29  15.00   112.50    62.50     FALSE   Female                                
Jeffrey   09/17/2020 2020-09-17 16:29  13.00    84.00    62.50     TRUE    Male                                  
  Carol   09/17/2020 2020-09-17 16:29  14.00   102.50    62.80     FALSE   Female                                
  Henry   09/17/2020 2020-09-17 16:29  14.00   102.50    63.50     TRUE    Male                                  
   Judy   09/17/2020 2020-09-17 16:29  14.00    90.00    64.30     FALSE   Female                                
 Robert   09/17/2020 2020-09-17 16:29  12.00   128.00    64.80     TRUE    Male                                  
Barbara   09/17/2020 2020-09-17 16:29  13.00    98.00    65.30     FALSE   Female                                
   Mary   09/17/2020 2020-09-17 16:29  15.00   112.00    66.50     TRUE    Female                                
William   09/17/2020 2020-09-17 16:29  15.00   112.00    66.50     FALSE   Male                                  
 Ronald   09/17/2020 2020-09-17 16:29  15.00   133.00    67.00     TRUE    Male                                  
 Alfred   09/17/2020 2020-09-17 16:29  14.00   112.50    69.00     FALSE   Male                                  
 Philip   09/17/2020 2020-09-17 16:29  16.00   150.00    72.00     TRUE    Male                                  
                                                                                                                 
                                                                                                                 
DISPLAY DICTIONARY COMMAND IN SPSS                                                                               
===================================                                                                              
                                                                                                                 
Variable Description        Position                                                                             
------------------------------------                                                                             
    DATE Format: ADATE10           1                                                                             
         Display Width: 8             SPSS date (note numeric - I mapped SPSS ADATE10, format )                  
                                      (note still numeric - I mapped SPSS ADATE10, format )                      
 DATETYM Format: YMDHMS16.0        2                                                                             
         Display Width: 9                                                                                        
                                                                                                                 
    NAME Format: A7                3                                                                             
         Display Width: 8                                                                                        
                                                                                                                 
     AGE Format: F8.2              4                                                                             
         Display Width: 8                                                                                        
                                                                                                                 
     SEX Format: A1                5                                                                             
         Display Width: 8                                                                                        
                                                                                                                 
         ?------------?                                                                                          
         ¦Value¦Label ¦                                                                                          
         +-----+------¦                                                                                          
         ¦    F¦Female¦                                                                                          
         ¦    M¦Male  ¦                                                                                          
         ?------------?                                                                                          
                                                                                                                 
  WEIGHT Format: F8.2              6                                                                             
         Display Width: 8                                                                                        
                                                                                                                 
  HEIGHT Format: F8.2              7                                                                             
         Display Width: 8                                                                                        
                                                                                                                 
   LOGIC Format: F1.0              8                                                                             
         Display Width: 8              User numeric format                                                       
                                                                                                                 
         ?-----------?                                                                                           
         ¦Value¦Label¦                                                                                           
         +-----+-----¦                                                                                           
         ¦    0¦FALSE¦                                                                                           
         ¦    1¦TRUE ¦                                                                                           
         ?-----------?                                                                                           
                                                                                                                 
/*           _   _                                                                                               
 _ __  _   _| |_| |__   ___  _ __                                                                                
| `_ \| | | | __| `_ \ / _ \| `_ \                                                                               
| |_) | |_| | |_| | | | (_) | | | |                                                                              
| .__/ \__, |\__|_| |_|\___/|_| |_|                                                                              
|_|    |___/                                                                                                     
*/                                                                                                               
                                                                                                                 
Pyreadstat does not capture Labels                                                                               
                                                                                                                 
DISPLAY DICTIONARY COMMAND IN SPSS                                                                               
===================================                                                                              
                                                                                                                 
Variable Description        Position                                                                             
------------------------------------                                                                             
    DATE Format: ADATE10           1                                                                             
         Display Width: 8             SPSS date (note numeric - I mapped SPSS ADATE10, format )                  
                                      (note still numeric - I mapped SPSS ADATE10, format )                      
 DATETYM Format: YMDHMS16.0        2                                                                             
         Display Width: 9                                                                                        
                                                                                                                 
    NAME Format: A7                3                                                                             
         Display Width: 8                                                                                        
                                                                                                                 
     AGE Format: F8.2              4                                                                             
         Display Width: 8                                                                                        
                                                                                                                 
     SEX Format: A1                5  ==> MISSING SPSS LABELS !!!!                                               
                                                                                                                 
  WEIGHT Format: F8.2              6                                                                             
         Display Width: 8                                                                                        
                                                                                                                 
  HEIGHT Format: F8.2              7                                                                             
         Display Width: 8                                                                                        
                                                                                                                 
   LOGIC Format: F1.0              8                                                                             
         Display Width: 8             ==> MISSING SPSS LABELS !!!!                                               
                                                                                                                 
/*                                                                                                               
 ___  __ _ ___                                                                                                   
/ __|/ _` / __|                                                                                                  
\__ \ (_| \__ \                                                                                                  
|___/\__,_|___/                                                                                                  
                                                                                                                 
*/                                                                                                               
                                                                                                                 
                                                                                                                 
DISPLAY DICTIONARY COMMAND IN SPSS                                                                               
===================================                                                                              
                                                                                                                 
Variable Description        Position                                                                             
------------------------------------                                                                             
    DATE Format: DATE12            1   Automatically assigned SPSS DATE12                                        
         Display Width: 8                                                                                        
                                                                                                                 
 DATETYM Format: DTIME16.0         2   Automatically assigned SPSS DATE12                                        
         Display Width: 9                                                                                        
                                                                                                                 
    NAME Format: A7                3                                                                             
         Display Width: 8                                                                                        
                                                                                                                 
     AGE Format: F8.2              4                                                                             
         Display Width: 8                                                                                        
                                                                                                                 
     SEX Format: A1                5  ==> MISSING SPSS LABELS !!!!                                               
                                                                                                                 
  WEIGHT Format: F8.2              6                                                                             
         Display Width: 8                                                                                        
                                                                                                                 
  HEIGHT Format: F8.2              7                                                                             
         Display Width: 8                                                                                        
                                                                                                                 
   LOGIC Format: F1.0              8                                                                             
         Display Width: 8             ==> MISSING SPSS LABELS !!!!                                               
                                                                                                                 
                                                                                                                 
DTIME does not seem to be the right format doe datetime.                                                         
                                                                                                                 
                                                                                                                 
Data List                                                                                                        
   NAME         DATE          DATETYM  AGE SEX   WEIGHT HEIGHT    LOGIC                                          
-----------------------------------------------------------------------                                          
  Joyce  17-SEP-2020  159950 18:14:29   11   F     50.5     51        1                                          
 Louise  17-SEP-2020  159950 18:14:29   12   F     77.0     56        0                                          
  Alice  17-SEP-2020  159950 18:14:29   13   F     84.0     57        1                                          
  James  17-SEP-2020  159950 18:14:29   12   M     83.0     57        0                                          
 Thomas  17-SEP-2020  159950 18:14:29   11   M     85.0     58        1                                          
   John  17-SEP-2020  159950 18:14:29   12   M     99.5     59        0                                          
   Jane  17-SEP-2020  159950 18:14:29   12   F     84.5     60        1                                          
  Janet  17-SEP-2020  159950 18:14:29   15   F    112.5     63        0                                          
Jeffrey  17-SEP-2020  159950 18:14:29   13   M     84.0     63        1                                          
  Carol  17-SEP-2020  159950 18:14:29   14   F    102.5     63        0                                          
  Henry  17-SEP-2020  159950 18:14:29   14   M    102.5     64        1                                          
   Judy  17-SEP-2020  159950 18:14:29   14   F     90.0     64        0                                          
 Robert  17-SEP-2020  159950 18:14:29   12   M    128.0     65        1                                          
Barbara  17-SEP-2020  159950 18:14:29   13   F     98.0     65        0                                          
   Mary  17-SEP-2020  159950 18:14:29   15   F    112.0     67        1                                          
William  17-SEP-2020  159950 18:14:29   15   M    112.0     67        0                                          
 Ronald  17-SEP-2020  159950 18:14:29   15   M    133.0     67        1                                          
 Alfred  17-SEP-2020  159950 18:14:29   14   M    112.5     69        0                                          
 Philip  17-SEP-2020  159950 18:14:29   16   M    150.0     72        1                                          
                                                                                                                 
I switched to 'YMDHMS16.0' and the datetime was corrrect                                                         
                                                                                                                 
/*                                                                                                               
 _ __  _ __ ___   ___ ___  ___ ___                                                                               
| `_ \| `__/ _ \ / __/ _ \/ __/ __|                                                                              
| |_) | | | (_) | (_|  __/\__ \__ \                                                                              
| .__/|_|  \___/ \___\___||___/___/                                                                              
|_|                                                                                                              
 ____                                                                                                            
|  _ \                                                                                                           
| |_) |                                                                                                          
|  _ <                                                                                                           
|_| \_\                                                                                                          
                                                                                                                 
*/                                                                                                               
*/                                                                                                               
                                                                                                                 
%utl_submit_r64('                                                                                                
library(haven);                                                                                                  
have<-read_sas("d:/sd1/have.sas7bdat","d:/sd1/torpy.sas7bcat");                                                  
str(have);                                                                                                       
write_sav(have,"d:/sav/want.sav");                                                                               
');                                                                                                              
                                                                                                                 
/*           _   _                                                                                               
 _ __  _   _| |_| |__   ___  _ __                                                                                
| `_ \| | | | __| `_ \ / _ \| `_ \                                                                               
| |_) | |_| | |_| | | | (_) | | | |                                                                              
| .__/ \__, |\__|_| |_|\___/|_| |_|                                                                              
|_|    |___/                                                                                                     
*/                                                                                                               
                                                                                                                 
%utl_submit_py64_38("                                                                                            
import pandas as pd;                                                                                             
import pyreadstat;                                                                                               
want, meta = pyreadstat.read_sas7bdat('d:/sd1/have.sas7bdat',catalog_file='d:/sd1/torpy.sas7bcat');              
print(want);                                                                                                     
print(meta.column_names);                                                                                        
print(meta.column_labels);                                                                                       
print(meta.column_names_to_labels);                                                                              
print(meta.number_rows);                                                                                         
print(meta.number_columns);                                                                                      
print(meta.file_label);                                                                                          
print(meta.file_encoding);                                                                                       
want.info();                                                                                                     
variable_value_labels = {'SEX': {'M': 'Male', 'F': 'Female'}, 'LOGI': {1: 'TRUE', 0: 'FALSE'}};                  
pyreadstat.write_sav(want,'d:/sav/want_py.sav',variable_value_labels=variable_value_labels);                     
");                                                                                                              
                                                                                                                 
/*                                                                                                               
 ___  __ _ ___                                                                                                   
/ __|/ _` / __|                                                                                                  
\__ \ (_| \__ \                                                                                                  
|___/\__,_|___/                                                                                                  
                                                                                                                 
*/                                                                                                               
                                                                                                                 
libname sd1 "d:/sd1";                                                                                            
proc export data=sd1.have                                                                                        
   file="d:/sav/sas2spss.sav"                                                                                    
   dbms=spss replace;                                                                                            
   fmtlib=sd1.sas_cntl_out;                                                                                      
run;quit;                                                                                                        
                                                                                                                 
