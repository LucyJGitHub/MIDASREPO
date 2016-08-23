     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Write error log entries')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEWRTELOG - Write Error Log Entries                          *
      *                                                               *
      *  Function:  This module is called by all data export functions*
      *             when they end abnormally. It will write details   *
      *             of the error to the error log file DEELOGPD.      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *  Prev Amend No. CDE001  *CREATE    Date 23Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
      *****************************************************************
 
     FDEELOGPD  O    E             DISK
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** +--------------------------------------+
      ** ¦ Program Status Data Structure layout ¦
      ** ¦ ==================================== ¦
      ** +--------------------------------------+
 
     DPSDS            SDS
 
      ** Procedure name
     D PSProcName        *PROC
 
      ** Status code
     D PSPgmStat         *STATUS
 
      ** Previous status
     D PSPrvStat              16     20S 0
 
      ** Source listing line number
     D PSLineNum              21     28
 
      ** Routine name
     D PSRoutine         *ROUTINE
 
      **  Number of passed parameters
     D PSNoOfParm        *PARMS
 
      **  Exception type
     D PSExcpType             40     42
 
      **  Exception number
     D PSExcpNo               43     46
 
      **  Program library
     D PSPgmLib               81     90
 
      **  Exception data
     D PSExcpData             91    170
 
      **  Exception Id
     D PSExcpID              171    174
 
      **  Date (*DATE format)
     D PSDate                191    198
 
      ** Year (*YEAR format)
     D PSYear                199    200S 0
 
      ** Last file used
     D PSLastFile            201    208
 
      ** File error information
     D PSFileInfo            209    243
 
      ** Job name
     D PSJobName             244    253
 
      ** User name
     D PSUser                254    263
 
      ** Job number
     D PSJobNo               264    269
 
      ** Date (UDATE format)
     D PSJobDate             270    275S 0
 
      ** Run date (UDATE format)
     D PSRunDate             276    281
 
      ** Run time (UDATE format)
     D PSRunTime             282    287S 0
 
      ** Creation date
     D PSCrtDate             288    293
 
      ** Creation time
     D PSCrtTime             294    299
 
      ** Compiler level
     D PSCompLvl             300    303
 
      ** Source file
     D PSSrcfile             304    313
 
      ** Source file library
     D PSSrcLib              314    323
 
      ** Source file member
     D PSSrcMbr              324    333
 
      ** Program containing procedure
     D PSProcPgm             334    343
 
      ** Module containing procedure
     D PSProcMod             344    353
 
 
     D                 DS
     D  BUF_TIME               1      8
     D  BUF_HH                 1      2
     D  BUF_C1                 3      3
     D  BUF_MM                 4      5
     D  BUF_C2                 6      6
     D  BUF_SS                 7      8
 
     D                 DS
     D  ALP_TIME               1      6
     D  ALP_HH                 1      2
     D  ALP_MM                 3      4
     D  ALP_SS                 5      6
 
 
      *
     C     *ENTRY        PLIST
 
      * INPUTS
     C                   PARM                    I_BUFFER       4000
      *
      * Record the time
      *
     C                   TIME                    NUM_TIME          6 0
     C                   MOVEL     NUM_TIME      ALP_TIME          6
     C                   MOVEL     ALP_HH        BUF_HH
     C                   MOVEL     ALP_MM        BUF_MM
     C                   MOVEL     ALP_SS        BUF_SS
     C                   MOVEL     ':'           BUF_C1
     C                   MOVEL     ':'           BUF_C2
      *
      * Log an error on the error log
      *
     C                   CLEAR                   BUFFER
     C                   EVAL      BUFFER = 'Date:' + PSRunDate + '.' +
     C                                      ' Time:' + BUF_TIME  + '.' +
     C                                      ' Job:' + PSJobName + '/' +
     C                                      PSUser + '/' + PSJobNo + '.' +
     C                                      ' Error in data export: ' +
     C                                      I_BUFFER
      *
     C                   WRITE     DEELOGP0
      *
     C                   SETON                                        LR
     C                   RETURN
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
