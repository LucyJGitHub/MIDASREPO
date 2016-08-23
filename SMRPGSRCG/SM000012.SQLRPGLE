     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Check and update status on SMCNUMPD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM000012 - Update the Update Flag (i.e. CNUPDF) in the file  *
      *             SMCNUMPD.                                         *
      *                                                               *
      *  Function:  This program will update all the Updation flags   *
      *  (in file SMCNUMPD) back to blanks if there is no error       *
      *  encountered while updating the data from Zeros to Blanks and *
      *  all the impacted files have been updated successfully.       *
      *                                                               *
      *  Called By: *NONE                                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027  *CREATE    Date 01Nov05               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Change customer number from numeric to alpha.       *
      *                                                               *
      *****************************************************************
     D TCOUNT          S             10S 0 INZ(0)
     D YCOUNT          S             10S 0 INZ(0)
     D NCOUNT          S             10S 0 INZ(0)
      *
     C     *ENTRY        PLIST
     C                   PARM                    OKFLG             1
      *
     C/Exec SQL
     C+ SELECT COUNT(*) INTO :TCOUNT FROM SMCNUMPD
     C/End-Exec
      *
     C/Exec SQL
     C+ SELECT COUNT(*) INTO :YCOUNT FROM SMCNUMPD WHERE CNUPDF = 'Y'
     C/End-Exec
      *
     C/Exec SQL
     C+ SELECT COUNT(*) INTO :NCOUNT FROM SMCNUMPD WHERE CNUPDF = 'N'
     C/End-Exec
      *
     C                   If        TCOUNT > 0
      *
     C                   If        TCOUNT = YCOUNT + NCOUNT
     C/Exec SQL
     C+ UPDATE SMCNUMPD SET CNUPDF = ' '
     C/End-Exec
     C                   Eval      OKFLG = 'Y'
     C                   EndIf
      *
     C                   EndIf
      *
     C                   Seton                                        LR
