     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Get period end dates')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEGETPERD - Get Period End Dates.                            *
      *                                                               *
      *  Function:  This module retrieves the period end dates from   *
      *             the Midas database.                               *
      *                                                               *
      *  Component of: DEGETEXCT                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CCB020             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      *  Prev Amend No. CDE002             Date 05Dec00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 16Dec99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CCB020 - COB Restructure - Secondary COB Infrastructure      *
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
      *****************************************************************
     FDEPPERDPD IF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(DEPERDP0: DEPPERDP0)
     FDEHPERDPD IF   E             DISK    INFSR(*PSSR)                                       CDE002
     F                                     RENAME(DEPERDP0: DEHPERDP0)                        CDE002
 
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
 
     D PeriodEDT     E DS                  EXTNAME(DEPPERDPD)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
     D DEEXTCTL      E DS                  EXTNAME(DEEXTCTL)
      ** EXTRACT CONTROL DATA
 
 
      ** MPHAS Data-Area
     D***MPHAS***********DS             1                                                     CCB020
     D***PHASE                  1      1                                                      CCB020
 
 
      *
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           30            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    Proj_Hist         1
      * OUTPUTS
     C                   PARM                    PeriodEDT
 
 
      **  Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
 
      ** Read Extract Control Data
 
     C     *DTAARA       DEFINE                  DEEXTCTL
     C     *LOCK         IN        DEEXTCTL
 
 
      ** Read MPHAS data-area
 
     C******DTAARA       DEFINE                  MPHAS                                        CCB020
     C**********         IN        MPHAS                                                      CCB020
     C                   CALL      'CBC001001'                                                CCB020
     C                   PARM                    COBST             4                          CCB020
 
      * If in input cycle and date checking is required,
      * check whether projections run date
      * or history run date                                                                   CDE002
      * is not equal to run date. It is an error if it is.
 
     C*****PHASE         IFEQ      'A'                                                        CCB020
     C     COBST         IFEQ      '*NO'                                                      CCB020
     C     DECHKD        ANDEQ     'Y'
 
     C     Proj_Hist     IFEQ      'P'                                                        CDE002
     C     DEPRDNB       IFNE      BJRDNB
     C                   EVAL      I#ERMS = 'PROJECTED DATES IN ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ELSE                                                                 CDE002
     C     DEHRDNB       IFNE      BJRDNB                                                     CDE002
     C                   EVAL      I#ERMS = 'HISTORIC DATES IN ERROR'                         CDE002
     C                   EXSR      *PSSR                                                      CDE002
     C                   ENDIF                                                                CDE002
     C                   ENDIF                                                                CDE002
 
     C                   ENDIF
 
      *
      * Get period end dates (projected)
      * (or historic)                                                                         CDE002
      *
     C     Proj_Hist     IFEQ      'P'                                                        CDE002
     C     1             CHAIN     DEPPERDP0                          99
     C   99              READ      DEPPERDP0                              99    *
     C                   ELSE                                                                 CDE002
     C     1             CHAIN     DEHPERDP0                          99                      CDE002
     C   99              READ      DEHPERDP0                              99                  CDE002
     C                   ENDIF                                                                CDE002
      *
      * Error if no record found
      *
     C     *IN99         IFEQ      '1'
     C                   EVAL      I#ERMS = 'NO DEPERDPD RECORD FOUND'
     C                   EXSR      *PSSR
     C                   END
      *
      * Return
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
