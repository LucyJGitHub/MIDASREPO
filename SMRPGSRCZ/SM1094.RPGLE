     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Add new zone SDBRCHPD recs to GZSDBRCHPD')    *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM1094  - Add new zone SDBRCHPD records to GZSDDBRCHPD       *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR756177           Date 16May11               *
      *                 CUP004             Date 20Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGP009             Date 22Dec04               *
      *                 CPK019             Date 21Jul04               *
      *                 CUP025  *CREATE    Date 08Jun04               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR756177 - Update zone field on SDBRCHPD too.                *
      *  CUP004 - Replacement for SCBEGIN.                            *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGP009 - Local Zone Time Difference (Recompile)              *
      *  CPK019 - Remove the use of LDA for data base error handling. *
      *  CUP025 - Change branches utility                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *       60         EOF (SDBRCHPD)                               *
      *       62         No record found (GPZONEL2)                   *
      *       64         No record found (GZSDBRCHL0)                 *
      *                                                               *
     F*****************************************************************
      *                                                               *
      *  Subroutines                                                  *
      *                                                               *
      * *INZSR        - Initialise                                    *
      * *PSSR         - Error processing                              *
      *                                                               *
      *****************************************************************
 
     F***SDBRCHPD  IF   E             DISK    INFSR(*PSSR)                                  AR756177
     FSDBRCHPD  UF   E             DISK    INFSR(*PSSR)                                     AR756177
      * RTV : Midas SD Branch codes
 
     FGZSDBRCHL0UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDBRCHD0:GZBRCHD0)
      * WRT : Midas GZ Branch codes by Branch
 
     FGPZONEL2  IF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
      * RTV : Midas GP Zones by zone system prefix
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D*LDA*****      E DS           256    EXTNAME(LDA)                                       CPK019
      *
      ***Local*data*area*for*database*error*details                                           CPK019
      ****LOCK*IN*LDA*immediately*before*and*OUT*LDA*immediately                              CPK019
      ***after*each*database*error*handling.                                                  CPK019
      *********                                                                               CPK019
      *********                             134 141 DBFILE                                    CPK019
      *********Defines:                     142 170 DBKEY                                     CPK019
      *********                             171 180 DBPGM                                     CPK019
      *********                             181 1830DBASE                                     CPK019
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Program data structure
     D/COPY GPCPYSRCG,PSDS
 
     D Wrun            S              1                                         *PSSR has been run?
     D KBrchCode       S              3                                         key to GZSDBRCHL0
 
      *****************************************************************
      * Main processing                                               *
      *****************************************************************
      *
      * Read in each record from SDBRCHPD
     C                   READ      SDBRCHPD                               60    EOF
      *
     C                   DOW       *IN60 = '0'                                  not EOF
      *
      * Set up key value to access GZSDBRCHL0 for the branch
     C                   EVAL      KBrchCode = A8BRCD
      *
     C     KBrchCode     CHAIN     GZSDBRCHL0                         64        Record not found
      *
      * If record with same branch code not found in GZSDBRCGL0, copy record
      *    from SDBRCHPD to GZSDBRCGL0.
     C                   IF        *IN64  = '1'
     C                   EVAL      A8ZONE = ZOZONE
     C                   WRITE     GZBRCHD0
     C                   ELSE                                                                 CUP004
     C                   EVAL      A8ZONE = ZOZONE                                            CUP004
     C                   UPDATE    GZBRCHD0                                                   CUP004
     C                   ENDIF                                                  FI *IN64 = '1'
                                                                                            AR756177
     C                   UPDATE    SDBRCHD0                                                 AR756177
      *
      * Read next record from SDBRCHPD
     C                   READ      SDBRCHPD                               60    EOF
      *
     C                   ENDDO
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      * *INZSR -   Program Initialisation routine                     *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls:     *PSSR                                              *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
 
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0ZoMSys          2            Zone System id
      *
     C******DTAARA       DEFINE                  LDA                                          CPK019
      *
     C                   OPEN      GPZONEL2
      *
      * Get Zone name from GPZONEL2 for the Zone System Id
     C     P0ZoMSys      CHAIN     GPZONEL2                           62        No record found
      *
      **If*no*record*found,*update*LDA*and*call**PSSR*to*terminate*this*program.              CPK019
      * If no record found, call *PSSR to terminate this program.                             CPK019
     C                   IF        *IN62 = '1'
     C******LOCK         IN        LDA                                                        CPK019
     C******             EVAL      DBFILE =  'GPZONEL2'                                       CPK019
     C******             EVAL      DBKEY  =  P0ZoMSys                                         CPK019
     C******             EVAL      DBPGM  =  PSProcPgm                                        CPK019
     C******             EVAL      DBASE  =  001                                              CPK019
     C******             EVAL      DBPROC =  '*INZSR'                                         CPK019
     C******             OUT       LDA                                                        CPK019
     C                   EXSR      *PSSR
     C                   ENDIF                                                  FI *IN62 = '1'
      *
     C                   CLOSE     GPZONEL2
      *
     C     INZSRE        ENDSR
      *
      *****************************************************************
      *                                                               *
      * *PSSR  -   Program exception error routine                    *
      *            Called automatically if a program error occurs,    *
      *            or directly by the program code using EXSR.        *
      *            This subroutine DUMPs the program just once.       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Wrun = *BLANK
     C                   EVAL      Wrun = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
