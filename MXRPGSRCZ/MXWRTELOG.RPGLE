     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Write Error Log Entries')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXWRTELOG - Write Error Log Entries                          *
      *                                                               *
      *  Function:  This module is called by all data export functions*
      *             when they end abnormally. It will write details   *
      *             of the error to the error log file MXELOGPD.      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CMX001  *CREATE    Data 01Jan00               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXELOGPD  O    E             DISK
 
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
 
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
 
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
     C                   PARM                    I_BUF200        200
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
     C                   MOVEL     PSRunDate     PSRunDateA        6
     C                   MOVEL     PSJobNo       PSJobNoA          6
      *
      * Log an error on the error log
      *
     C                   CLEAR                   BUF200
     C                   EVAL      BUF200 = 'Date:' + PSRunDateA + '.' +
     C                                      ' Time:' + BUF_TIME  + '.' +
     C                                      ' Job:' + PSJobName + '/' +
     C                                      PSUser + '/' + PSJobNoA + '. ' +
     C                                      I_BUF200
      *
     C                   WRITE     MXELOGP0
      *
     C                   SETON                                        LR
     C                   RETURN
**  CPY@
(c) Finastra International Limited 2001
