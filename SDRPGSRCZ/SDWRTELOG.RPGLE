     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Write Error Log Entries')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDWRTELOG - Write Error Log Entries                          *
      *                                                               *
      *  Function:  This module can be called by functions            *
      *             when they end abnormally. It will write details   *
      *             of the error to the error log file SDELOGPD.      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CRE008  *CREATE    Data 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FSDELOGPD  O    E             DISK
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
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
     C                   PARM                    I_PGM            10
     C                   PARM                    I_MOD            10
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
     C                   EVAL      ELDATE = PSRunDateA
     C                   EVAL      ELTIME = BUF_TIME
     C                   EVAL      ELJOB  = PSJobName
     C                   EVAL      ELUSER = PSUser
     C                   EVAL      ELJOBN = PSJobNoA
     C                   EVAL      ELPGM  = I_PGM
     C                   EVAL      ELMOD  = I_MOD
     C                   EVAL      ELB200 = I_BUF200
      *
     C                   WRITE     SDELOGD0
      *
     C                   SETON                                        LR
     C                   RETURN
