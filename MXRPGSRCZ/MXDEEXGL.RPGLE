     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/***********BASEMOD                                                   *                       260324
/*CRT *  CRTRPGMOD                                                    *                       260324
/*CRT *  MODULE(**********/**********)                                *                       260324
/*CRT *  SRCFILE(**********/**********)                               *                       260324
/*CRT *  SRCMBR(*MODULE) OUTPUT(*PRINT)                               *                       260324
/*CRT *  INDENT(*NONE) TGTRLS(V5R3M0)                                 *                       260324
/*CRT *  TEXT('Midas MX Daily Events Extract - General Ledger')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXDEEXGL - Daily Events Extract - General Ledger Module      *
      *                                                               *
      *  Function:  This module extracts general ledger daily events  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. 260324             Date 27May09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242925             Date 10Oct06               *
      *                 241970             Data 05Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX003             Date 05Nov00               *
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  260324 - Recompile with FIXNBR(*NONE) to prevent endless     *
      *           joblogs ni MXC0500. Internalised Create Parameters. *
      *  242925 - Increase Account Code to 10 digits Signed (not P)   *
      *           Amend hook MXCPYSRC/MXFLTACOD and recompiled        *
      *  241970 - Recompiled due to change in MXACSPRME.              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *           (RE-COMPILE OVER CHANGED /COPY)                     *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FSADETB    IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(ACDETABF: ACCNTABF)
     FSEDPO     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(APOSTPDF)
     FMXACREL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(APOSTPDF: MXACREP0)
     FMXBLGLPD  IF   E           K DISK    INFSR(*PSSR)
     FMXDEGLPD  O    E             DISK    INFSR(*PSSR)
     F                                     PREFIX(G_)
     FMXDGDTPD  IF   E           K DISK    INFSR(*PSSR)
     FMXDGECPD  IF   E           K DISK    INFSR(*PSSR)
     FMXDEEXGAU O    E             PRINTER INFSR(*PSSR)  USROPN
 
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
 
 
      * Maximum number of events
     D MaxNoEvts       C                   CONST(200)
 
      * VALUE DATE/TRANSACTION TYPE ARRAY
     D #_VDTT          S             10A   DIM(MaxNoEvts)
 
      * POSTING AMOUNT ARRAY
     D #_PSTA          S             15S 0 DIM(MaxNoEvts)
 
      * COUNT OF POSTINGS ARRAY
     D #_CNTP          S              5S 0 DIM(MaxNoEvts)
 
 
     D TG              S              1    DIM(99)
     D CC              S              2    DIM(99)
     D S1              S              4    DIM(99)
     D S2              S              4    DIM(99)
 
 
     D MXEXPCTL      E DS                  EXTNAME(MXEXPCTL)
      ** Export Control Data
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for CURRENCY details
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      * Current Account ID
     D                 DS
     D***Curr_ACCID              1     18                                                     CGL029
     D Curr_ACCID              1     24                                                       CGL029
     D*Curr_CNUM               1      6S 0                                                    CSD027
     D Curr_CNUM               1      6A                                                      CSD027
     D Curr_CCY                7      9
     D***Curr_ACOD              10     13S 0                                                  CGL029
     D***Curr_ACSQ              14     15S 0                                                  CGL029
     D***Curr_BRCA              16     18                                                     CGL029
     D Curr_ACOD              10     19S 0                                                    CGL029
     D Curr_ACSQ              20     21S 0                                                    CGL029
     D Curr_BRCA              22     24                                                       CGL029
 
      * Previous Account ID
     D                 DS
     D***Prev_ACCID              1     18                                                     CGL029
     D Prev_ACCID              1     24                                                       CGL029
     D*Prev_CNUM               1      6S 0                                                    CSD027
     D Prev_CNUM               1      6A                                                      CSD027
     D Prev_CCY                7      9
     D***Prev_ACOD              10     13S 0                                                  CGL029
     D***Prev_ACSQ              14     15S 0                                                  CGL029
     D***Prev_BRCA              16     18                                                     CGL029
     D Prev_ACOD              10     19S 0                                                    CGL029
     D Prev_ACSQ              20     21S 0                                                    CGL029
     D Prev_BRCA              22     24                                                       CGL029
 
      * Previous Original Transaction Sub Type (on MXACREPD)
     D                 DS
     D Prev_OTST               1     10
     D Prev_OTRFQQ             1     15                                                       CGL029
     D***Prev_DINC               1      4                                                     CGL029
     D***Prev_CEXP               7     10                                                     CGL029
 
     D I#ACOD          S             10S 0                                                    242925
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
     C                   PARM                    I#EVTT            4
 
      * Extract accounts opened and closed
 
     C     I#EVTT        IFEQ      'OPCL'
     C     @OPEN         IFNE      0
     C     @CLOS         ORNE      0
     C                   EXSR      EXT_OPCL
     C                   ENDIF
     C                   ENDIF
 
      * Extract postings
 
     C     I#EVTT        IFEQ      'POST'
     C     @DEBT         IFNE      0
     C     @CRED         ORNE      0
     C                   EXSR      EXT_POST
     C                   ENDIF
     C                   ENDIF
 
      * Extract accrual of retail interest
 
     C     I#EVTT        IFEQ      'ACRE'
     C     @DEBT         IFNE      0
     C     @CRED         ORNE      0
     C                   EXSR      EXT_ACRE
     C                   ENDIF
     C                   ENDIF
 
      * Extract start of month balances
 
     C     I#EVTT        IFEQ      'SOM '
     C     @SOM          IFNE      0
     C                   EXSR      EXT_SOM
     C                   ENDIF
     C                   ENDIF
 
     C                   SETON                                        LR
 
     CLR                 EXSR      TOTALS
      /SPACE 5
      ********************************************************************
      * Extract accounts opened and closed
      ********************************************************************
     C     EXT_OPCL      BEGSR
 
      * Read an account
 
     C                   READ      SADETB                                 99    *
 
      * Do until all accounts have been read
 
     C     *IN99         DOWEQ     '0'
 
      * Add 1 to count of accounts read
 
     C                   add       1             acc_cnt
 
      * On change of branch
      * Determine if branch is to be included in the export
 
     C     BRCA          IFNE      Prev_BRCA
     C                   MOVE      'D'           I#LD
     C                   MOVEL     BRCA          I#BRCA
     C                   EXSR      BRCA_FLT
     C                   MOVEL     BRCA          Prev_BRCA
     C                   ENDIF
 
      * On change of account code
      * Determine if account code is to be included in the export
 
     C     ACOD          IFNE      Prev_ACOD
     C                   MOVE      'D'           I#LD
     C                   Z-ADD     ACOD          I#ACOD
     C                   EXSR      ACOD_FLT
     C                   MOVEL     ACOD          Prev_ACOD
     C                   ENDIF
 
      * If branch is for export
      * and account code is for export
      * and last change date is today
 
     C     Exp_BRCA      IFEQ      'Y'
     C     Exp_ACOD      ANDEQ     'Y'
     C     LCD           ANDEQ     BJRDNB
 
      * If the account was closed or opened
      * Write account opening/closing event
 
     C     RECI          IFEQ      'C'
     C     @CLOS         ANDNE     0
     C     CHTP          OREQ      'I'
     C     RECI          ANDNE     'C'
     C     @OPEN         ANDNE     0
     C                   EXSR      WRT_OPCL
     C                   ENDIF
 
     C                   ENDIF
 
      * Read an account
 
     C                   READ      SADETB                                 99    *
     C                   ENDDO
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      *********************************************************************
      * Write account opening/closing event
      ********************************************************************
     C     WRT_OPCL      BEGSR
 
      * Set event category attributes
 
     C     RECI          IFEQ      'C'
     C                   MOVEL     CC(@CLOS)     G_DECATC
     C                   MOVEL     S1(@CLOS)     G_DESNM1
     C                   MOVEL     S2(@CLOS)     G_DESNM2
     C                   ELSE
     C                   MOVEL     CC(@OPEN)     G_DECATC
     C                   MOVEL     S1(@OPEN)     G_DESNM1
     C                   MOVEL     S2(@OPEN)     G_DESNM2
     C                   ENDIF
 
      * Set account ID on event
 
     C**********         Z-ADD     CNUM          G_CNUM                                       CSD027
     C                   Eval      G_CNUM = CNUM                                              CSD027
     C                   MOVE      CCY           G_CCY
     C                   Z-ADD     ACOD          G_ACOD
     C                   Z-ADD     ACSQ          G_ACSQ
     C                   MOVE      BRCA          G_BRCA
 
      * Set posting date and value date
 
     C                   Z-ADD     BJRDNB        G_PSTD
     C     RECI          IFEQ      'C'
     C                   Z-ADD     DACC          G_VALD
     C                   ELSE
     C                   Z-ADD     DACO          G_VALD
     C                   ENDIF
 
      * Initialize unused fields
 
     C                   MOVEL     *BLANK        G_TRATA
     C                   Z-ADD     *ZERO         G_SPSTA
     C                   Z-ADD     *ZERO         G_DRCR
     C                   Z-ADD     *ZERO         G_ACDP
     C                   Z-ADD     *ZERO         G_BCEQ
     C                   MOVEL     *BLANK        G_BCCY
     C                   Z-ADD     *ZERO         G_BCDP
     C                   Z-ADD     *ZERO         G_CNTPST
 
      * Write account opening/closing event
 
     C     RECI          IFEQ      'C'
     C                   add       1             CLevt_cnt
     C                   ELSE
     C                   add       1             OPevt_cnt
     C                   ENDIF
 
     C                   ADD       1             G_EAEVID
     C                   WRITE     MXDEGLP0
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Extract postings
      ********************************************************************
     C     EXT_POST      BEGSR
 
      * Read a posting
 
     C                   READ      SEDPO                                  99    *
 
      * Do until all of today's postings have been read
 
     C     *IN99         DOWEQ     '0'
 
      * Add 1 to count of postings read
 
     C                   add       1             pst_cnt
 
      * Set up account ID
      * and posting date and DR/CR indicator
 
     C**********         Z-ADD     CNUM          Curr_CNUM                                    CSD027
     C                   Eval      Curr_CNUM = CNUM                                           CSD027
     C                   MOVE      CCY           Curr_CCY
     C                   Z-ADD     ACOD          Curr_ACOD
     C                   Z-ADD     ACSQ          Curr_ACSQ
     C                   MOVE      BRCA          Curr_BRCA
 
      * If branch is for export
      * and account code is for export
 
     C     Exp_BRCA      IFEQ      'Y'
     C     Exp_ACOD      ANDEQ     'Y'
 
      * On change of account ID, posting date and DR/CR indicator
      * Write summary posting
 
     C     Curr_ACCID    IFNE      Prev_ACCID
     C     PSTD          ORNE      Prev_PSTD
     C     DRCR          ORNE      Prev_DRCR
     C     Prev_DRCR     IFEQ      1
     C     @CRED         ANDGT     0
     C     Prev_DRCR     OREQ      0
     C     @DEBT         ANDGT     0
     C                   EXSR      WRT_POST
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      * On change of branch
      * Determine if branch is to be included in the export
 
     C     BRCA          IFNE      Prev_BRCA
     C                   MOVE      'D'           I#LD
     C                   MOVEL     BRCA          I#BRCA
     C                   EXSR      BRCA_FLT
     C                   ENDIF
 
      * On change of account code
      * Determine if account code is to be included in the export
 
     C     ACOD          IFNE      Prev_ACOD
     C                   MOVE      'D'           I#LD
     C                   Z-ADD     ACOD          I#ACOD
     C                   EXSR      ACOD_FLT
     C                   ENDIF
 
      * If branch is for export
      * and account code is for export
 
     C     Exp_BRCA      IFEQ      'Y'
     C     Exp_ACOD      ANDEQ     'Y'
 
      * If Dr/CR posting amounts are triggers
 
     C     DRCR          IFEQ      1
     C     @CRED         ANDGT     0
     C     DRCR          OREQ      0
     C     @DEBT         ANDGT     0
 
      * Add posting amount to totals
 
     C                   EXSR      ADD_PSTA
 
     C                   ENDIF
     C                   ENDIF
 
      * Update the previous account ID
      * and posting date and DR/CR indicator
 
     C                   MOVEL     Curr_ACCID    Prev_ACCID
     C                   Z-ADD     PSTD          Prev_PSTD         5 0
     C                   Z-ADD     DRCR          Prev_DRCR         1 0
 
      * Read a posting
 
     C                   READ      SEDPO                                  99    *
     C                   ENDDO
 
      * If branch is for export
      * and account code is for export
 
     C     Exp_BRCA      IFEQ      'Y'
     C     Exp_ACOD      ANDEQ     'Y'
 
      * Write summary posting
 
     C     Prev_DRCR     IFEQ      1
     C     @CRED         ANDGT     0
     C     Prev_DRCR     OREQ      0
     C     @DEBT         ANDGT     0
     C                   EXSR      WRT_POST
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Extract accrual of retail interest
      ********************************************************************
     C     EXT_ACRE      BEGSR
 
      * Read an accrual posting
 
     C                   READ      MXACREL1                               99    *
 
      * Do until all of today's accrual postings have been read
 
     C     *IN99         DOWEQ     '0'
 
      * Add 1 to count of accrual postings read
 
     C                   add       1             pst_cnt
 
      * Set up account ID
      * and posting date and DR/CR indicator
 
     C**********         Z-ADD     CNUM          Curr_CNUM                                    CSD027
     C                   Eval      Curr_CNUM = CNUM                                           CSD027
     C                   MOVE      CCY           Curr_CCY
     C                   Z-ADD     ACOD          Curr_ACOD
     C                   Z-ADD     ACSQ          Curr_ACSQ
     C                   MOVE      BRCA          Curr_BRCA
 
      * If branch is for export
      * and account code is for export
 
     C     Exp_BRCA      IFEQ      'Y'
     C     Exp_ACOD      ANDEQ     'Y'
 
      * On change of account ID, posting date and DR/CR indicator
      * Write summary posting
 
     C     Curr_ACCID    IFNE      Prev_ACCID
     C     PSTD          ORNE      Prev_PSTD
     C     DRCR          ORNE      Prev_DRCR
     C     Prev_DRCR     IFEQ      1
     C     @CRED         ANDGT     0
     C     Prev_DRCR     OREQ      0
     C     @DEBT         ANDGT     0
     C                   EXSR      WRT_POST
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      * On change of branch
      * Determine if branch is to be included in the export
 
     C     BRCA          IFNE      Prev_BRCA
     C                   MOVE      'D'           I#LD
     C                   MOVEL     BRCA          I#BRCA
     C                   EXSR      BRCA_FLT
     C                   ENDIF
 
      * On change of account code
      * Determine if account code is to be included in the export
 
     C     ACOD          IFNE      Prev_ACOD
     C                   MOVE      'D'           I#LD
     C                   Z-ADD     ACOD          I#ACOD
     C                   EXSR      ACOD_FLT
     C                   ENDIF
 
      * If branch is for export
      * and account code is for export
 
     C     Exp_BRCA      IFEQ      'Y'
     C     Exp_ACOD      ANDEQ     'Y'
 
      * If Dr/CR posting amounts are triggers
 
     C     DRCR          IFEQ      1
     C     @CRED         ANDGT     0
     C     DRCR          OREQ      0
     C     @DEBT         ANDGT     0
 
      * Add posting amount to totals
 
     C                   EXSR      ADD_PSTA
 
     C                   ENDIF
     C                   ENDIF
 
      * Update the previous account ID
      * and posting date and DR/CR indicator
      * and original transaction sub type
 
     C                   MOVEL     Curr_ACCID    Prev_ACCID
     C                   Z-ADD     PSTD          Prev_PSTD         5 0
     C                   Z-ADD     DRCR          Prev_DRCR         1 0
     C                   MOVEL     OTST          Prev_OTST
     C                   MOVEL     OTRFQQ        Prev_OTRFQQ                                  CGL029
 
      * Read an accrual posting
 
     C                   READ      MXACREL1                               99    *
     C                   ENDDO
 
      * If branch is for export
      * and account code is for export
 
     C     Exp_BRCA      IFEQ      'Y'
     C     Exp_ACOD      ANDEQ     'Y'
 
      * Write summary posting
 
     C     Prev_DRCR     IFEQ      1
     C     @CRED         ANDGT     0
     C     Prev_DRCR     OREQ      0
     C     @DEBT         ANDGT     0
     C                   EXSR      WRT_POST
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      *********************************************************************
      * Write summary posting
      ********************************************************************
     C     WRT_POST      BEGSR
 
      * Set event category attributes
 
     C     Prev_DRCR     IFEQ      1
     C                   MOVEL     CC(@CRED)     G_DECATC
     C                   MOVEL     S1(@CRED)     G_DESNM1
     C                   MOVEL     S2(@CRED)     G_DESNM2
     C                   ELSE
     C                   MOVEL     CC(@DEBT)     G_DECATC
     C                   MOVEL     S1(@DEBT)     G_DESNM1
     C                   MOVEL     S2(@DEBT)     G_DESNM2
     C                   ENDIF
 
      * Set account ID on posting
 
     C**********         Z-ADD     Prev_CNUM     G_CNUM                                       CSD027
     C                   Eval      G_CNUM = Prev_CNUM                                         CSD027
     C                   MOVE      Prev_CCY      G_CCY
     C                   Z-ADD     Prev_ACOD     G_ACOD
     C                   Z-ADD     Prev_ACSQ     G_ACSQ
     C                   MOVE      Prev_BRCA     G_BRCA
 
      * Posting date and DR/CR indicator
 
     C                   Z-ADD     Prev_PSTD     G_PSTD
     C                   Z-ADD     Prev_DRCR     G_DRCR
 
      * Loop through all value dates
     C                   Z-ADD     1             @I
 
     C     @I            DOWLE     MaxNoEvts
     C     #_VDTT(@I)    ANDNE     *BLANK
 
     C                   MOVEL     #_VDTT(@I)    G_VALD
     C                   MOVE      #_VDTT(@I)    G_TRATA
     C                   Z-ADD     #_PSTA(@I)    G_SPSTA
     C                   Z-ADD     #_CNTP(@I)    G_CNTPST
 
      * DR/CR Account Codes
     C     I#EVTT        IFEQ      'ACRE'
     C*****Prev_DINC     IFNE      *BLANK                                                     CGL029
     C     Prev_OTST     IFNE      *BLANK                                                     CGL029
     C**********         MOVEL     Prev_DINC     G_EADAC1                                     CGL029
     C                   MOVEL     Prev_OTST     G_EADAC1                                     CGL029
     C                   ENDIF
     C*****Prev_CEXP     IFNE      *BLANK                                                     CGL029
     C     Prev_OTRFQQ   IFNE      *BLANK                                                     CGL029
     C**********         MOVEL     Prev_CEXP     G_EACAC1                                     CGL029
     C                   MOVEL     Prev_OTRFQQ   G_EACAC1                                     CGL029
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     0             G_EADAC1
     C                   Z-ADD     0             G_EACAC1
     C                   ENDIF
 
      * Write summary of postings event
 
     C                   add       1             POevt_cnt
     C                   EXSR      CAL_BSCYEQ
     C                   ADD       1             G_EAEVID
     C                   WRITE     MXDEGLP0
 
     C                   MOVEL     *blank        #_VDTT(@I)
     C                   Z-ADD     *zero         #_PSTA(@I)
     C                   Z-ADD     *zero         #_CNTP(@I)
 
     C                   ADD       1             @I
 
     C                   ENDDO
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      *********************************************************************
      * Add posting amount to totals
      ********************************************************************
     C     ADD_PSTA      BEGSR
 
      * Add posting amount to posting amount array
 
 
     C                   MOVEL     VALD          VDTT             10
     C                   MOVE      TRAT          VDTT             10
 
     C                   Z-ADD     1             @I                6 0
     C     VDTT          LOOKUP    #_VDTT(@I)                             99    *
     C     *in99         IFEQ      '1'
     C                   ADD       PSTA          #_PSTA(@I)
     C                   ELSE
     C                   Z-ADD     1             @I
     C     *BLANK        LOOKUP    #_VDTT(@I)                             99    *
     C                   MOVEL     VDTT          #_VDTT(@I)
     C                   ADD       PSTA          #_PSTA(@I)
     C                   ENDIF
 
     C                   ADD       1             #_CNTP(@I)
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Extract start of month balances
      ********************************************************************
     C     EXT_SOM       BEGSR
 
      * Read a start of month balance
 
     C                   READ      MXBLGLP0                               99    *
 
      * Do until all of balances have been read
 
     C     *IN99         DOWEQ     '0'
 
      * Add 1 to count of balances read
 
     C                   add       1             bal_cnt
 
      * Write a start of month balance
 
     C                   EXSR      WRT_SOM
 
      * Read a start of month balance
 
     C                   READ      MXBLGLP0                               99    *
     C                   ENDDO
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      *********************************************************************
      * Write a start of month balance
      ********************************************************************
     C     WRT_SOM       BEGSR
 
      * Set event category attributes
 
     C                   MOVEL     CC(@SOM)      G_DECATC
     C                   MOVEL     S1(@SOM)      G_DESNM1
     C                   MOVEL     S2(@SOM)      G_DESNM2
 
      * Set account ID on start of month balance
 
     C**********         Z-ADD     CNUM          G_CNUM                                       CSD027
     C                   Eval      G_CNUM = CNUM                                              CSD027
     C                   MOVE      CCY           G_CCY
     C                   Z-ADD     ACOD          G_ACOD
     C                   Z-ADD     ACSQ          G_ACSQ
     C                   MOVE      BRCA          G_BRCA
 
      * Posting date, value date and balance
 
     C                   Z-ADD     DATE          G_PSTD
     C                   Z-ADD     DATE          G_VALD
     C                   Z-ADD     BAL           G_SPSTA
 
      * Initialize unused fields
 
     C                   MOVE      *BLANK        G_TRATA
     C                   Z-ADD     *ZERO         G_DRCR
     C                   Z-ADD     *ZERO         G_ACDP
     C                   Z-ADD     *ZERO         G_BCEQ
     C                   MOVEL     *BLANK        G_BCCY
     C                   Z-ADD     *ZERO         G_BCDP
     C                   Z-ADD     *ZERO         G_CNTPST
     C                   Z-ADD     0             G_EADAC1
     C                   Z-ADD     0             G_EACAC1
 
      * Write start of month balance event
 
     C                   add       1             SMevt_cnt
     C                   ADD       1             G_EAEVID
     C                   WRITE     MXDEGLP0
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      *********************************************************************
      * PAG - Page change processing
      ********************************************************************
     C     PAG           BEGSR
     C                   ADD       CHLINE        LINENO
     C     LINENO        IFGT      59
     C                   ADD       1             PAGNUM            3 0
     C     DIAGEV        COMP      'Y'                                    50    *
     C                   WRITE     PAGEHEAD
     C     4             ADD       CHLINE        LINENO            3 0
     C                   ENDIF
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      *********************************************************************
      * Output totals
      ********************************************************************
     C     TOTALS        BEGSR
 
      * Output end of report totals
 
     C     I#EVTT        IFEQ      'OPCL'
     C                   Z-ADD     10            CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     ENDOFREPA
     C                   ENDIF
 
     C     I#EVTT        IFEQ      'POST'
     C                   Z-ADD     8             CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     ENDOFREPP
     C                   ENDIF
 
     C     I#EVTT        IFEQ      'ACRE'
     C                   Z-ADD     8             CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     ENDOFREPP
     C                   ENDIF
 
     C     I#EVTT        IFEQ      'SOM '
     C                   Z-ADD     8             CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     ENDOFREPS
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      *********************************************************************
      * Load event categories for selection (and template)
      ********************************************************************
     C     LOAD_DGEC     BEGSR
 
      * Clear outputs
 
     C                   MOVEL     *BLANK        TG
     C                   MOVEL     *BLANK        CC
     C                   MOVEL     *BLANK        S1
     C                   MOVEL     *BLANK        S2
 
      * Get Data Group Details
 
     C     DGDTAG        CHAIN     MXDGDTP0                           99        *
     C     *in99         IFEQ      '1'
     C                   EVAL      I#ERMS = 'NO RECORD ON MXDGDTPD'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If the data group is not enabled, then end immediately
 
     C     DGENAB        IFNE      'Y'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
 
      * Get data group event categories
 
     C                   Z-ADD     0             @X                3 0
     C     DGDTAG        SETLL     MXDGECP0
     C     DGDTAG        READE     MXDGECP0                               99    *
     C     *in99         DOWEQ     '0'
     C                   ADD       1             @X
     C                   MOVEL     DETRIG        TG(@X)
     C                   MOVEL     DECATC        CC(@X)
     C                   MOVEL     DESNM1        S1(@X)
     C                   MOVEL     DESNM2        S2(@X)
     C     DGDTAG        READE     MXDGECP0                               99    *
     C                   ENDDO
 
      * Get start of month category code
 
     C                   Z-ADD     1             @X
     C     '01'          LOOKUP    CC(@X)                                 99    *
     C     *in99         IFEQ      '1'
     C     TG(@X)        ANDEQ     'Y'
     C                   Z-ADD     @X            @SOM              3 0
     C                   ELSE
     C                   Z-ADD     *ZERO         @SOM
     C                   ENDIF
 
      * Get DR posting category code
 
     C                   Z-ADD     1             @X
     C     '11'          LOOKUP    CC(@X)                                 99    *
     C     *in99         IFEQ      '1'
     C     TG(@X)        ANDEQ     'Y'
     C                   Z-ADD     @X            @DEBT             3 0
     C                   ELSE
     C                   Z-ADD     *ZERO         @DEBT
     C                   ENDIF
 
      * Get CR posting category code
 
     C                   Z-ADD     1             @X
     C     '12'          LOOKUP    CC(@X)                                 99    *
     C     *in99         IFEQ      '1'
     C     TG(@X)        ANDEQ     'Y'
     C                   Z-ADD     @X            @CRED             3 0
     C                   ELSE
     C                   Z-ADD     *ZERO         @CRED
     C                   ENDIF
 
      * Get account opening category code
 
     C                   Z-ADD     1             @X
     C     '20'          LOOKUP    CC(@X)                                 99    *
     C     *in99         IFEQ      '1'
     C     TG(@X)        ANDEQ     'Y'
     C                   Z-ADD     @X            @OPEN             3 0
     C                   ELSE
     C                   Z-ADD     *ZERO         @OPEN
     C                   ENDIF
 
      * Get account closing category code
 
     C                   Z-ADD     1             @X
     C     '21'          LOOKUP    CC(@X)                                 99    *
     C     *in99         IFEQ      '1'
     C     TG(@X)        ANDEQ     'Y'
     C                   Z-ADD     @X            @CLOS             3 0
     C                   ELSE
     C                   Z-ADD     *ZERO         @CLOS
     C                   ENDIF
 
     C     ELOAD_DGEC    ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * Calculate Base Currency Equivalent Of Posting Amount
      ********************************************************************
     C     CAL_BSCYEQ    BEGSR
 
      * Get account currency details
 
     C                   MOVEL     G_CCY         I#LFD1
     C                   CALLB     'MXACSCURR'
     C/COPY MXCPYSRC,MXACSPRME
 
      * Error if the currency code was not found
 
     C     ACS_RTCD      IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'INVALID CURRENCY IN MXACSCURR'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      SDCURR = InData
 
      * Set account currency decimal places
 
     C                   Z-ADD     A6NBDP        G_ACDP
 
      *  Convert the event amount to base currency
 
     C                   CALLB     'ZCONV'
     C                   PARM      G_SPSTA       ZAMTCI           15 0
     C                   PARM      A6SPRT        ZEXCH            13 8
     C                   PARM      A6MDIN        ZMD               1
     C                   PARM      G_CCY         ZCCYI             3
     C                   PARM      BJCYCD        ZCCYO             3
     C                   PARM      A6NBDP        ZCDPI             1 0
     C                   PARM      BasCcyDec     ZCDPO             1 0
     C                   PARM      *ZERO         ZAMTCO           15 0
 
     C                   Z-ADD     ZAMTCO        G_BCEQ
 
      * Set base currency and base currency decimal places
 
     C                   MOVEL     BJCYCD        G_BCCY
     C                   Z-ADD     BasCcyDec     G_BCDP
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
      * Set up constants
 
     C                   MOVEL     'ACCT'        DGDTAG
     C                   MOVEL     'A'           I#EXTT
 
      **  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Get export control details on data-area
 
     C     *DTAARA       DEFINE                  MXEXPCTL
     C                   IN        MXEXPCTL
 
      * Get base currency details
 
     C                   MOVEL     BJCYCD        I#LFD1
     C                   CALLB     'MXACSCURR'
     C/COPY MXCPYSRC,MXACSPRME
 
      * Error if the base currency was not found
 
     C     ACS_RTCD      IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'INVALID BASE CURRENCY'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Set base currency decimal places
 
     C                   EVAL      SDCURR = InData
     C                   Z-ADD     A6NBDP        BasCcyDec         1 0
 
      * Initialize Event Generation Date & Event ID
 
     C                   Z-ADD     BJRDNB        G_EAEVGD
     C     I#EVTT        IFEQ      'POST'
     C                   Z-ADD     *ZERO         G_EAEVID
     C                   ENDIF
     C     I#EVTT        IFEQ      'ACRE'
     C                   Z-ADD     5000000       G_EAEVID
     C                   ENDIF
     C     I#EVTT        IFEQ      'SOM '
     C                   Z-ADD     7000000       G_EAEVID
     C                   ENDIF
     C     I#EVTT        IFEQ      'OPCL'
     C                   Z-ADD     9000000       G_EAEVID
     C                   ENDIF
 
 
      * Load ACCT event categories for selection
 
     C                   EXSR      LOAD_DGEC
 
      * Load branches for export
 
     C                   MOVE      'L'           I#LD
     C                   EXSR      BRCA_FLT
 
      * Load account codes for export
 
     C                   MOVE      'L'           I#LD
     C                   Z-ADD     *ZERO         I#ACOD
     C                   EXSR      ACOD_FLT
 
      * Open the printer file
 
     C                   OPEN      MXDEEXGAU
 
      * Output audit report page headings
 
     C                   Z-ADD     *ZERO         CHLINE
     C                   Z-ADD     99            LINENO
     C                   EXSR      PAG
 
      * Zeroize count of accounts and postings read
      * Zeroize counts of events
 
     C                   Z-ADD     *ZERO         acc_cnt           6 0
     C                   Z-ADD     *ZERO         pst_cnt           6 0
     C                   Z-ADD     *ZERO         bal_cnt           6 0
     C                   Z-ADD     *ZERO         CLevt_cnt         6 0
     C                   Z-ADD     *ZERO         OPevt_cnt         6 0
     C                   Z-ADD     *ZERO         POevt_cnt         6 0
     C                   Z-ADD     *ZERO         SMevt_cnt         6 0
 
      * Initialize previous account ID
 
     C**********         Z-ADD     *ZERO         Prev_CNUM                                    CSD027
     C                   Eval      Prev_CNUM = *Blanks                                        CSD027
     C                   MOVE      *BLANK        Prev_CCY
     C                   Z-ADD     *ZERO         Prev_ACOD
     C                   Z-ADD     *ZERO         Prev_ACSQ
     C                   MOVE      *BLANK        Prev_BRCA
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * B R A N C H   F I L T E R
      /COPY MXCPYSRC,MXFLTBRCA
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * A C C O U N T   C O D E   F I L T E R
      /COPY MXCPYSRC,MXFLTACOD
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
