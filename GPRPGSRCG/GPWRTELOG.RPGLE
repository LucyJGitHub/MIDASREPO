     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Write error log entries')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPWRTELOG - Write Error Log Entries                          *
      *                                                               *
      *  Function:  This module is called by all global processing    *
      *             functions when they end abnormally. It will write *
      *             details of the error to the error log file        *
      *             GPELOGPD.                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FGPELOGPD  O    E             DISK
 
 
     D/COPY GPCPYSRCG,STD_D_SPEC
 
      ** +--------------------------------------+
      ** ¦ Program Status Data Structure layout ¦
      ** ¦ ==================================== ¦
      ** +--------------------------------------+
 
     D/COPY GPCPYSRCG,PSDS
 
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
 
     D                 DS                                                                     CPK018
     D PSRunDateA              1      6                                                       CPK018
     D PSRunDateN              1      6  0                                                    CPK018
     D                 DS                                                                     CPK018
     D PSJobNoA                1      6                                                       CPK018
     D PSJobNoN                1      6  0                                                    CPK018
 
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
     C*****              EVAL      BUFFER = 'Date:' + PSRunDate + '.' +                       CPK018
     C                   EVAL      PSRunDateN = PSRunDate                                     CPK018
     C                   EVAL      PSJobNoN = PSJobNo                                         CPK018
     C                   EVAL      BUFFER = 'Date:' + PSRunDateA + '.' +                      CPK018
     C                                      ' Time:' + BUF_TIME  + '.' +
     C*****                                 ' Job:' + PSJobNo + '/' +                         CPK018
     C                                      ' Job:' + PSJobNoA + '/' +                        CPK018
     C                                      PSUser + '/' + PSJobName + '.' +
     C                                      ' Error in global processing: ' +
     C                                      I_BUFFER
      *
     C                   WRITE     GPELOGP0
      *
     C                   SETON                                        LR
     C                   RETURN
