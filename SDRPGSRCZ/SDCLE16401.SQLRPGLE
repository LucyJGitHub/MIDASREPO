     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas SD Initialize SDRPKYTD new fields')              *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  SDCLE16401 -  Initialise new fields (Take-on Only)           *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No.  MD046248             Date 05Feb18            *
      *  Prev Amend No.  MD036852             Date 11Dec15            *
      *                  MD031687  *CREATE    Date 18Dec14            *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD036852 - Resolve spelling errors                           *
      *  MD031687 - Initialise data for SDRPKYTD                      *
      *             Repayment Priority Key                            *
      *                                                               *
      *****************************************************************
      *
      *
     FSDRPKYTD  IF A E             DISK
      *

     C/exec SQL
     C+ insert into SDRPKYTD Values
     C+ (
     C+   'RepaymentPR'
     C+ , 'Repayment Priority'
     C+ , 01
     C+ , 'A'
     C+ , ' '
     C+ )
     C/end-exec

     C/exec SQL
     C+ insert into SDRPKYTD Values
     C+ (
     C****'CategoryCoPR'                                                                    MD036852
     C+   'CategoryCOPR'                                                                    MD036852
     C+ , 'Category Code Repayment Priority'
     C+ , 02
     C+ , 'A'
     C+ , ' '
     C+ )
     C/end-exec

     C/exec SQL
     C+ insert into SDRPKYTD Values
     C+ (
     C+   'ORTStartDate'
     C+ , 'Start Date of Loan / Fee (Original Transaction)'
     C+ , 10
     C+ , 'D'
     C+ , ' '
     C+ )
     C/end-exec

     C/exec SQL
     C+ insert into SDRPKYTD Values
     C+ (
     C+   'ORTEndDate'
     C+ , 'Maturity / End Date of Loan / Fee (Original Transaction)'
     C+ , 15
     C+ , 'D'
     C+ , ' '
     C+ )
     C/end-exec

     C/exec SQL
     C+ insert into SDRPKYTD Values
     C+ (
     C+   'Reference'
     C+ , 'Transaction Reference'
     C+ , 20
     C+ , 'A'
     C+ , ' '
     C+ )
     C/end-exec

     C/exec SQL
     C+ insert into SDRPKYTD Values
     C+ (
     C****'PayValueDate'                                                                    MD036852
     C+   'PAYValueDate'                                                                    MD036852
     C+ , 'Value Date of Payment'
     C+ , 25
     C+ , 'D'
     C+ , ' '
     C+ )
     C/end-exec

     C/exec SQL
     C+ insert into SDRPKYTD Values
     C+ (
     C+   'PDCLValueDate'
     C+ , 'Start / Value Date of Past Due Call Loan'
     C+ , 0
     C+ , ' '
     C+ , ' '
     C+ )
     C/end-exec

     C/exec SQL
     C+ insert into SDRPKYTD Values
     C+ (
     C+   'Amount'
     C+ , 'Amount'
     C+ , 0
     C+ , ' '
     C+ , ' '
     C+ )
     C/end-exec

     C/exec SQL
     C+ insert into SDRPKYTD Values
     C+ (
     C+   'Timestamp'
     C+ , 'Timestamp'
     C+ , 0
     C+ , ' '
     C+ , ' '
     C+ )
     C/end-exec

     C                   SETON                                        LR

