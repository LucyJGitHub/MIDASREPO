     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas SD Initialize SDRPKYTD new fields')              *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  SDCLE16403 -  Delete data for new fields                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No.  MD031687  *CREATE    Date 18Dec14            *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031687 - Initialise data for SDRPKYTD                      *
      *             Repayment Priority Key                            *
      *                                                               *
      *****************************************************************
      *
      *
     FSDRPKYTD  IF A E             DISK
      *

     C/exec SQL
     C+ Delete from SDRPKYTD
     C/end-exec

     C                   SETON                                        LR
