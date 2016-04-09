     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Accruals to Retail Accounts Update')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACREUPD - Accruals to Retail Accounts Update               *
      *                                                               *
      *  Function:  This module updates the account ID on accrual     *
      *             entries to that of the account that has accrued.  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 241970             Data 05Sep06               *
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 200018             Data 06Jun06               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL020             Date 12Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                         *CREATE    Date                       *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  241970 - Recompiled due to change in MXACSPRME.              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  200018 - Remove DUMP statement                               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL020 - Midas Compliance Watch - Additional A/C Postings    *
      *           Information (Recompile)                             *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXACREL1  UP   E           K DISK    PREFIX(P_)
     F                                     INFSR(*PSSR)
     FACNUM     IF   E           K DISK    RENAME(ACCNTABF:ACNUMABF)
     F                                     INFSR(*PSSR)
 
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
 
 
      * POSTING NARRATIVE
     D                 DS
     D P_PNAR                  1     30
     D #_PNAR                  1     30    DIM(30)
 
 
      * ACCOUNT NUMBER
     D                 DS
     D A_ACNO                  1     10
     D #_ACNO                  1     10    DIM(10)
 
 
     D #_NUM           S              1    DIM(10) CTDATA PERRCD(10)
 
 
     D SDACOD        E DS                  EXTNAME(SDACODPD)
      ** External DS for ACCOUNT CODE details
 
     D S_ACOD          S             10A                                                      CGL029
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
 
      * Store the accrual account code
 
     C**********         MOVEL     P_ACOD        S_ACOD            4                          CGL029
     C                   MOVEL     P_ACOD        S_ACOD                                       CGL029
 
      * Find the account number (in the posting narrative)
 
     C                   MOVE      *BLANK        #_ACNO
     C                   EXSR      FIND_ACNO
 
      * If this posting is to be processed
 
     C     ProcesPOST    IFEQ      'Y'
 
      * Error if the a/c number does not point to a valid account
 
     C                   MOVEL     A_ACNO        ACNO
     C     ACNO          CHAIN     ACNUMABF                           99        *
     C     *in99         IFEQ      '1'
     C                   EVAL      I#ERMS = 'INVALID ACCOUNT NO.:' + A_ACNO
     C************       DUMP                                                   200018
     C                   ELSE
 
      * Overwrite the account ID on the posting
      * with that from the account
 
     C**********         Z-ADD     CNUM          P_CNUM                                       CSD027
     C                   EVAL      P_CNUM = CNUM                                              CSD027
     C                   MOVEL     CCY           P_CCY
     C                   Z-ADD     ACOD          P_ACOD
     C                   Z-ADD     ACSQ          P_ACSQ
     C                   MOVEL     BRCA          P_BRCA
 
      * Access the account code details
      * to determine what sort of entry this is
 
     C                   EXSR      ACS_ACOD
 
      * Update the posting
 
     C                   EXCEPT    UPD_ACRE
 
     C                   ENDIF
     C                   ENDIF
 
      /SPACE 5
      *********************************************************************
      * Find the account number (in the posting narrative)
      ********************************************************************
     C     FIND_ACNO     BEGSR
 
      * Look for a series of numbers in the narrative
 
     C                   Z-ADD     *ZERO         #N1               2 0
     C                   Z-ADD     *ZERO         #N2               2 0
     C     #N1           DOUEQ     30
     C     #N2           OREQ      10
     C                   ADD       1             #N1
     C     #_PNAR(#N1)   LOOKUP    #_NUM                                  99    *
     C     *IN99         IFEQ      '1'
     C                   ADD       1             #N2
     C                   MOVE      #_PNAR(#N1)   #_ACNO(#N2)
     C                   ENDIF
     C                   ENDDO
 
      * If 10 digits have been found, process this posting
 
     C     #N2           IFEQ      10
     C                   MOVEL     'Y'           ProcesPOST        1
     C                   ELSE
     C                   MOVEL     'N'           ProcesPOST
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * Access the account code details
      ********************************************************************
     C     ACS_ACOD      BEGSR
 
      * Get account code details
 
     C                   MOVEL     P_ACOD        I#LFD1
     C                   CALLB     'MXACSACOD'
     C/COPY MXCPYSRC,MXACSPRME
 
      * Error if the account code was not found
 
     C     ACS_RTCD      IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'INVALID ACCOUNT CODE ' + I#LFD1
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      SDACOD = InData
 
      * DIAC = debit int. income      (credit posting)
      * DIAD = debit int. receivable  (debit  posting)
      * CIAD = credit int. expense    (debit  posting)
      * CIAC = credit int. payable    (credit posting)
 
     C                   MOVEL     *BLANK        P_OTST
     C                   MOVEL     *BLANK        P_OTRFQQ                                     CGL029
      * Either DR int. income or CR int. expense
     C     A5DIAC        IFEQ      A5CIAD
     C                   Z-ADD     99997         P_TRAT
     C                   MOVEL     S_ACOD        P_OTST
     C**********         MOVE      S_ACOD        P_OTST                                       CGL029
     C                   MOVE      S_ACOD        P_OTRFQQ                                     CGL029
     C                   ELSE
      * DR int. income
     C     S_ACOD        IFEQ      A5DIAC
     C                   Z-ADD     99998         P_TRAT
     C                   MOVEL     S_ACOD        P_OTST
     C                   ELSE
      * CR int. expense
     C                   Z-ADD     99999         P_TRAT
     C**********         MOVE      S_ACOD        P_OTST                                       CGL029
     C                   MOVE      S_ACOD        P_OTRFQQ                                     CGL029
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     ACIDKY        KLIST
     C                   KFLD                    P_CNUM
     C                   KFLD                    P_CCY
     C                   KFLD                    P_ACOD
     C                   KFLD                    P_ACSQ
     C                   KFLD                    P_BRCA
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
     OAPOSTPDF  E            UPD_ACRE
     O                       P_CNUM
     O                       P_CCY
     O                       P_ACOD
     O                       P_ACSQ
     O                       P_BRCA
     O                       P_TRAT
     O                       P_OTRFQQ                                                         CGL029
     O                       P_OTST
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** #_NUM
0123456789
