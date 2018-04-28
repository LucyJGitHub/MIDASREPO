     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Update Generic Transaction details')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEUPDGETR - Update Generic Transaction Details               *
      *                                                               *
      *  Function:  This module will take the projected extract files *
      *             created on a daily basis during COB and maintain  *
      *             details of the generic transaction files. The     *
      *             generic transaction files may then be used to     *
      *             create historic extract files for reporting of    *
      *             revenue within CCRM.                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CGL029             Date 01Sep03               *
      *                 CLE034             Date 16Sep03               *
      *                 216909             Date 14Apr03               *
      *                 CDE005             Date 22Aug02               *
      *                 CDE003             Date 11Dec02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002  *CREATE    Date 05Dec00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE034 - Lending Enhancements for Phase 1 Priority 1A        *
      *           (recompiled).                                       *
      *  216909 - Recompiled due to change in DEPPOSNPD format.       *
      *  CDE005 - Data Export - Reservation ID (Recompile)            *
      *  CDE003 - Data Export - MCR Limits Phase II (Recompiled)      *
      *  208221 - should be able to change generic opening positions  *
      *           for FEES                                            *
      *           Should not check DEGEVNTPD before calling ADD_EVNT  *
      *           also should be able to change generic events        *
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
      *                                                               *
      *****************************************************************
 
     FDEPTRANL1 UP   E           K DISK
     F                                     RENAME(DETRANP0: DEPTRANP0)
     F                                     COMMIT
     FDEPPOSNL1 IF   E           K DISK
     F                                     RENAME(DEPOSNP0: DEPPOSNP0)
     FDEPEVNTL1 IF   E           K DISK
     F                                     RENAME(DEEVNTP0: DEPEVNTP0)
     FDEGTRANL1 UF A E           K DISK
     F                                     PREFIX(G_)
     F                                     RENAME(DETRANP0: DEGTRANP0)
     F                                     COMMIT
     FDEGPOSNL1 UF A E           K DISK
     F                                     PREFIX(G_)
     F                                     RENAME(DEPOSNP0: DEGPOSNP0)
     F                                     COMMIT
     FDEGEVNTL1 UF A E           K DISK
     F                                     PREFIX(G_)
     F                                     RENAME(DEEVNTP0: DEGEVNTP0)
     F                                     COMMIT
     FDEGVALUL1 UF A E           K DISK
     F                                     RENAME(DEVALUP0: DEGVALUP0)
     F                                     COMMIT
     FSDBANKPD  IF   E             DISK
     FDEUPDGTP1 O    F  132        PRINTER
 
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** T R A N S A C T I O N    D E T A I L S
     D p#TRAN        E DS                  EXTNAME(DEPTRANPD)
     D g#TRAN        E DS                  EXTNAME(DEPTRANPD)
     D                                     PREFIX(G_)
      ** P O S I T I O N    D E T A I L S
     D p#POSN        E DS                  EXTNAME(DEPPOSNPD)
     D g#POSN        E DS                  EXTNAME(DEPPOSNPD)
     D                                     PREFIX(G_)
      ** E V E N T    D E T A I L S
     D p#EVNT        E DS                  EXTNAME(DEPEVNTPD)
     D g#EVNT        E DS                  EXTNAME(DEPEVNTPD)
     D                                     PREFIX(G_)
 
      ** Array 'NAR' changed for shorter narratives.                                          CGL029
     D*NAR******       S             45    DIM(4) CTDATA PERRCD(1)                            CGL029
     D NAR             S             24    DIM(4) CTDATA PERRCD(1)                            CGL029
     D TABTYP          S              2    DIM(22) CTDATA PERRCD(1)
     D TABNAR          S             20    DIM(22) ALT(TABTYP)
 
      * If transaction 'commit' record, bypass
 
     C     T#ACTN        IFEQ      'C'
     C                   GOTO      FINISH
     C                   ENDIF
 
      * Add transaction (if not present) else update it
 
     C     TRANKEY       CHAIN     DEGTRANP0                          99        *
 
      * No record present
     C     *in99         IFEQ      '1'
     C     T#ACTN        IFNE      'D'
     C                   MOVEL     p#TRAN        g#TRAN
     C                   WRITE     DEGTRANP0
     C**********         MOVEL     NAR(1)        TNNARR           40                          CGL029
     C                   MOVEL     NAR(1)        TNNARR           24                          CGL029
     C                   ELSE
     C                   MOVEL     NAR(2)        TNNARR
     C                   ENDIF
 
     C                   ELSE
      * Record present
     C     T#ACTN        IFEQ      'D'
     C                   MOVEL     NAR(3)        TNNARR
     C                   DELETE    DEGTRANP0
     C                   ELSE
     C                   MOVEL     p#TRAN        g#TRAN
     C                   UPDATE    DEGTRANP0
     C                   MOVEL     NAR(4)        TNNARR
     C                   ENDIF
     C                   ENDIF
 
      * Set 'matured' narrative
 
     C     T#MATR        IFEQ      'Y'
     C                   MOVEL     'YES'         matnat            3
     C                   ELSE
     C                   MOVEL     '   '         matnat
     C                   ENDIF
 
      * Report transaction
 
     C                   SETOFF                                       53
     C     T#VCDP        COMP      1                                  525051
     C   52T#VCDP        COMP      2                                    5352
     C                   Z-ADD     4             CHLINE            3 0
     C                   EXSR      PAG
     C                   EXCEPT    THEAD
 
      * If transaction deleted,
      * delete all generic positions, events & valuation details
 
     C     T#ACTN        IFEQ      'D'
     C                   EXSR      DEL_POSN
     C                   EXSR      DEL_EVNT
     C                   EXSR      DEL_VALU
     C                   GOTO      FINISH
     C                   ENDIF
 
      * Initalize market value
      * if transaction is an FRA and it has reached value date
      * if transaction is a SWAP and it has reached maturity date
 
     C     T#TCAT        IFEQ      'FRAS'
     C     T#VALR        ANDEQ     'Y'
     C     T#TCAT        OREQ      'SWAP'
     C     T#MATR        ANDEQ     'Y'
     C                   Z-ADD     *ZERO         T#MKVL
     C                   ENDIF
 
      * ADD TO VALUATION DETAILS
 
     C     TRANKEY       SETGT     DEGVALUP0
     C     TRANKEY       READPE    DEGVALUP0                              99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     T#MOD         V#MOD
     C                   MOVEL     T#TREF        V#TREF
     C                   Z-ADD     *ZERO         V#MKVL
     C                   ENDIF
 
     C                   Z-ADD     BJRDNB        V#VLDT
     C                   Z-ADD     *ZERO         V#PROF
     C                   Z-ADD     *ZERO         V#LOSS
 
     C                   SELECT
 
     C     T#MKVL        WHENGE    0
     C     V#MKVL        ANDGE     0
     C     T#MKVL        SUB       V#MKVL        V#PROF
 
     C     T#MKVL        WHENLE    0
     C     V#MKVL        ANDLE     0
     C     T#MKVL        SUB       V#MKVL        V#LOSS
 
     C     T#MKVL        WHENGE    0
     C     V#MKVL        ANDLE     0
     C                   Z-ADD     T#MKVL        V#PROF
     C                   Z-SUB     V#MKVL        V#LOSS
 
     C     T#MKVL        WHENLE    0
     C     V#MKVL        ANDGE     0
     C                   Z-ADD     T#MKVL        V#LOSS
     C                   Z-SUB     V#MKVL        V#PROF
 
     C                   ENDSL
 
     C                   Z-ADD     T#MKVL        V#MKVL
 
     C     V#PROF        IFNE      0
     C     V#LOSS        ORNE      0
     C                   WRITE     DEGVALUP0
     C                   ENDIF
 
 
      * PROCESS POSITIONS
 
 
      * Check if initial asset position exists. If not add it.
     C                   MOVEL     'A'           P#ASLI
     C     POSNKEY       SETLL     DEGPOSNP0
     C     POSNKEY       READE     DEGPOSNP0                              99    *
     C******in99         IFEQ      '1'                                                        208221
     C     POSNKEY       SETLL     DEPPOSNP0
     C*****POSNKEY       READE     DEPPOSNP0                              99    *             208221
     C******in99         IFEQ      '0'                                                        208221
     C     POSNKEY       READE     DEPPOSNP0                              98    *             208221
     C     *in98         IFEQ      '0'                                                        208221
     C     *in99         IFEQ      '1'                                                        208221
     C     *in99         OREQ      '0'                                                        208221
     C     T#TCAT        ANDEQ     'FEES'                                                     208221
     C     p#POSN        ANDNE     g#POSN                                                     208221
     C                   EXSR      ADD_POSN
     C                   ENDIF
     C                   ENDIF
 
      * Check if initial liability position exists. If not add it.
     C                   MOVEL     'L'           P#ASLI
     C     POSNKEY       SETLL     DEGPOSNP0
     C     POSNKEY       READE     DEGPOSNP0                              99    *
     C******in99         IFEQ      '1'                                                        208221
     C     POSNKEY       SETLL     DEPPOSNP0
     C*****POSNKEY       READE     DEPPOSNP0                              99    *             208221
     C******in99         IFEQ      '0'                                                        208221
     C     POSNKEY       READE     DEPPOSNP0                              98    *             208221
     C     *in98         IFEQ      '0'                                                        208221
     C     *in99         IFEQ      '1'                                                        208221
     C     *in99         OREQ      '0'                                                        208221
     C     T#TCAT        ANDEQ     'FEES'                                                     208221
     C     p#POSN        ANDNE     g#POSN                                                     208221
     C                   EXSR      ADD_POSN
     C                   ENDIF
     C                   ENDIF
 
      * PROCESS EVENTS
 
 
      * Add asset events
     C                   MOVEL     'A'           E#ASLI
     C     EVNTKEY       SETLL     DEPEVNTP0
     C     EVNTKEY       READE     DEPEVNTP0                              99    *
     C     *in99         IFEQ      '0'
     C                   EXSR      ADD_EVNT
     C                   ENDIF
 
      * Add liability events
     C                   MOVEL     'L'           E#ASLI
     C     EVNTKEY       SETLL     DEPEVNTP0
     C     EVNTKEY       READE     DEPEVNTP0                              99    *
     C     *in99         IFEQ      '0'
     C                   EXSR      ADD_EVNT
     C                   ENDIF
 
     C     FINISH        TAG
 
      * Delete transaction and commit updates
 
     C                   DELETE    DEPTRANP0
     C                   COMMIT
      *
     C********************************************************************
     C     ADD_POSN      BEGSR
      *
      * add position
     C                   MOVEL     p#POSN        g#POSN
     C     *in99         IFEQ      '1'                                                        208221
     C                   WRITE     DEGPOSNP0
     C                   ELSE                                                                 208221
     C                   UPDATE    DEGPOSNP0                                                  208221
     C                   ENDIF                                                                208221
      * report position
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAG
     C     P#ASLI        IFEQ      'A'
     C     *in99         IFEQ      '1'                                                        208221
     C                   EXCEPT    NSASSP
     C                   ELSE                                                                 208221
     C                   EXCEPT    CHASSP                                                     208221
     C                   ENDIF                                                                208221
     C                   ELSE
     C     *in99         IFEQ      '1'                                                        208221
     C                   EXCEPT    NSLIAP
     C                   ELSE                                                                 208221
     C                   EXCEPT    CHLIAP                                                     208221
     C                   ENDIF                                                                208221
     C                   ENDIF
 
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAG
     C                   EXCEPT    NSPOSH
 
     C                   Z-ADD     P#IACD        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        PSDATE            7
     C                   SETOFF                                       53
     C     P#NCDP        COMP      1                                  525051
     C   52P#NCDP        COMP      2                                    5352
 
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAG
     C                   EXCEPT    PLINE
      *
     C                   ENDSR
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     ADD_EVNT      BEGSR
 
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAG
     C     E#ASLI        IFEQ      'A'
     C                   EXCEPT    NSASSE
     C                   ELSE
     C                   EXCEPT    NSLIAE
     C                   ENDIF
      *
     C     *IN99         DOWEQ     '0'
      *                                                                                       208221
     C     EVNTKY2       SETLL     DEGEVNTP0                                                  208221
     C     EVNTKY2       READE     DEGEVNTP0                              98    *             208221
     C     *in98         IFEQ      '1'                                                        208221
     C     *in98         OREQ      '0'                                                        208221
     C     p#EVNT        ANDNE     g#EVNT                                                     208221
      *
      * add event
     C                   MOVEL     p#EVNT        g#EVNT
     C     *in98         IFEQ      '1'                                                        208221
     C                   WRITE     DEGEVNTP0
     C                   ELSE                                                                 208221
     C                   UPDATE    DEGEVNTP0                                                  208221
     C                   ENDIF                                                                208221
      *
     C                   SETOFF                                       53
     C     E#NCDP        COMP      1                                  525051
     C   52E#NCDP        COMP      2                                    5352
     C                   Z-ADD     E#PRDT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        EVDATE            7
     C     E#EVTP        LOOKUP    TABTYP        TABNAR                   99
     C     *IN99         IFEQ      '1'
     C                   MOVEL     TABNAR        EVNARR           18
     C                   ELSE
     C                   MOVEL     '*ERROR  '    EVNARR
     C                   ENDIF
     C     E#RTSP        COMP      *ZERO                              2121      *
     C     E#CFCT        COMP      *ZERO                              2222      *
     C     E#CPDP        COMP      *ZERO                              2323      *
     C     E#IRAT        COMP      *ZERO                              2424      *
     C     E#NOML        COMP      *ZERO                              2525      *
     C     E#PRAM        COMP      *ZERO                              2626      *
     C     E#INTA        COMP      *ZERO                              2727      *
     C     E#COMM        COMP      *ZERO                              2828      *
     C     E#TAMT        COMP      *ZERO                              2929      *
     C                   SETOFF                                       30
 
     C     E#EVTP        IFEQ      'TP'
     C     E#EVTP        OREQ      'TS'
     C                   SETOFF                                       29
     C                   SETON                                        30
     C                   ENDIF
 
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAG
     C                   EXCEPT    TEVT
     C                   ENDIF                                                                208221
 
     C     EVNTKEY       READE     DEPEVNTP0                              99    *
     C                   ENDDO
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     DEL_POSN      BEGSR
 
      * Delete all positions
 
     C     TRANKEY       SETLL     DEGPOSNP0
     C     TRANKEY       READE     DEGPOSNP0                              99    *
     C     *in99         DOWEQ     '0'
     C                   DELETE    DEGPOSNP0
     C     TRANKEY       READE     DEGPOSNP0                              99    *
     C                   ENDDO
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     DEL_EVNT      BEGSR
 
      * Delete all events
 
     C     TRANKEY       SETLL     DEGEVNTP0
     C     TRANKEY       READE     DEGEVNTP0                              99    *
     C     *in99         DOWEQ     '0'
     C                   DELETE    DEGEVNTP0
     C     TRANKEY       READE     DEGEVNTP0                              99    *
     C                   ENDDO
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     DEL_VALU      BEGSR
 
      * Delete all valuation details
 
     C     TRANKEY       SETLL     DEGVALUP0
     C     TRANKEY       READE     DEGVALUP0                              99    *
     C     *in99         DOWEQ     '0'
     C                   DELETE    DEGVALUP0
     C     TRANKEY       READE     DEGVALUP0                              99    *
     C                   ENDDO
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     ZDATE2        BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0          Value date
     C                   PARM      BJDFIN        ZDATFM            1            Date format ind
     C                   PARM      *ZERO         ZDATE             6 0          Value date
     C                   PARM      *BLANK        ZADATE            7            Run-date in DDM
     C                   ENDSR
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     PAG           BEGSR
     C                   ADD       CHLINE        LINENO
     C     LINENO        IFGT      59
     C                   ADD       1             PAGNUM            3 0
     C                   EXCEPT    HEAD
     C     4             ADD       CHLINE        LINENO            3 0
     C                   ENDIF
     C                   ENDSR
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    T#TCAT            4
 
     C                   Z-ADD     99            LINENO
     C     1             CHAIN     SDBANKPD                           99
 
     C     TRANKEY       KLIST
     C                   KFLD                    T#MOD
     C                   KFLD                    T#TREF
 
     C     POSNKEY       KLIST
     C                   KFLD                    T#MOD
     C                   KFLD                    T#TREF
     C                   KFLD                    P#ASLI
 
     C     EVNTKEY       KLIST
     C                   KFLD                    T#MOD
     C                   KFLD                    T#TREF
     C                   KFLD                    E#ASLI
 
     C     EVNTKY2       KLIST                                                                208221
     C                   KFLD                    E#MOD                                        208221
     C                   KFLD                    E#TREF                                       208221
     C                   KFLD                    E#ASLI                                       208221
     C                   KFLD                    E#PRDT                                       208221
     C                   KFLD                    E#PRSQ                                       208221
     C                   KFLD                    E#EVTP                                       208221
     C                   KFLD                    E#EVRF                                       208221
                                                                                              208221
     C                   ENDSR
     C********************************************************************
     ODEUPDGTP1 E            HEAD             01
     O                                           13 'REF.DEUPDGETR'
     O                       T#TCAT              53
     O                                           59 'DAILY'
     O                                           79 'TRANSACTIONS REPORT'
     O                                          112 'DATE'
     O                       BJMRDT             120
     O                                          127 'PAGE'
     O                       PAGNUM        Z    131
     O          E            HEAD           1 02
     O                                           54 '-----'
     O                                           59 '-----'
     O                                           79 '--------------------'
     O          E            THEAD       1  0
     O                                           24 '========================'
     O                                           48 '========================'
     O                                           72 '========================'
     O                                           96 '========================'
     O                                          120 '========================'
     O                                          132 '========================'
     O          E            THEAD       1  0
     O                                            2 'Md'
     O**********                                 23 '<-Transaction Ref.->'                    CGL029
     O**********                                 29 'Type'                                    CGL029
     O**********                                 34 'SbTp'                                    CGL029
     O**********                                 57 '<---Description---> '                    CGL029
     O**********                                 65 'Customer'                                CGL029
     O**********                                 86 'Market Value'                            CGL029
     O**********                                120 'Action'                                  CGL029
     O**********                                132 'Matured'                                 CGL029
     O                                           29 '<----Transaction Ref.---->'              CGL029
     O                                           35 'Type'                                    CGL029
     O                                           40 'SbTp'                                    CGL029
     O                                           63 '<---Description---> '                    CGL029
     O                                           71 'Customer'                                CGL029
     O                                           92 'Market Value'                            CGL029
     O                                          127 'Action'                                  CGL029
     O                                          132 'Mat'                                     CGL029
     O          E            THEAD       1  0
     O                                          132 '.'
     O          E            THEAD       1  0
     O                       T#MOD                2
     O**********             T#TREF              23                                           CGL029
     O**********             T#TRTP              30                                           CGL029
     O**********             T#TRST              35                                           CGL029
     O**********             T#TDES              57                                           CGL029
     O**********             T#RCST              64                                           CGL029
     O**********     50      T#MKVL              87 '   ,   ,   ,   ,   -'                    CGL029
     O**********     51      T#MKVL              87 '  ,   ,   ,   ,   . -'                   CGL029
     O**********     52      T#MKVL              87 ' ,   ,   ,   ,   .  -'                   CGL029
     O**********     53      T#MKVL              87 '   ,   ,   ,   .   -'                    CGL029
     O**********             T#VCCY              91                                           CGL029
     O**********             TNNARR             132                                           CGL029
     O**********             matnat             131                                           CGL029
     O                       T#TREF              29                                           CGL029
     O                       T#TRTP              36                                           CGL029
     O                       T#TRST              41                                           CGL029
     O                       T#TDES              63                                           CGL029
     O                       T#RCST              70                                           CGL029
     O               50      T#MKVL              93 '   ,   ,   ,   ,   -'                    CGL029
     O               51      T#MKVL              93 '  ,   ,   ,   ,   . -'                   CGL029
     O               52      T#MKVL              93 ' ,   ,   ,   ,   .  -'                   CGL029
     O               53      T#MKVL              93 '   ,   ,   ,   .   -'                    CGL029
     O                       T#VCCY              97                                           CGL029
     O                       TNNARR             125                                           CGL029
     O                       matnat             132                                           CGL029
     O          E            NSASSP      1  0
     O                                           18 'New asset position'
     O          E            NSLIAP      1  0
     O                                           22 'New liability position'
     O          E            CHASSP      1  0                                                 208221
     O                                           22 'Changed asset position'                  208221
     O          E            CHLIAP      1  0                                                 208221
     O                                           26 'Changed liability position'              208221
     O          E            NSPOSH      1  0
     O                                            8 'Date'
     O                                           22 'Principal'
     O                                           28 'Ccy'
     O                                           32 'BR'
     O                                           44 'Base Rate'
     O                                           56 'Rate/spread'
     O                                           71 'Interest Rate'
     O          E            PLINE       1  0
     O               50      P#NOML              25 '   ,   ,   ,   , 0 -'
     O               51      P#NOML              25 '  ,   ,   ,   , 0 . -'
     O               52      P#NOML              25 ' ,   ,   ,   , 0 .  -'
     O               53      P#NOML              25 '   ,   ,   , 0 .   -'
     O                       PSDATE              10
     O                       P#CCY               28
     O                       P#BRTT              32
     O                       P#BRTE              44 '   0.       '
     O                       P#RTSP              56 '   0.       '
     O                       P#IRAT              70 '   0.       '
     O          E            NSASSE      1  0
     O                                           18 'Asset events'
     O          E            NSLIAE      1  0
     O                                           22 'Liability events'
     O          E            TEVT        1  0
     O                       EVDATE              10
     O                       E#EVRF              17
     O                       EVNARR              36
     O               50 25   E#NOML              55 '   ,   ,   ,   ,   -'
     O               51 25   E#NOML              55 '  ,   ,   ,   ,   . -'
     O               52 25   E#NOML              55 ' ,   ,   ,   ,   .  -'
     O               53 25   E#NOML              55 '   ,   ,   ,   .   -'
     O                  25                       40 'NOM:'
     O               50 26   E#PRAM              74 '   ,   ,   ,   ,   -'
     O               51 26   E#PRAM              74 '  ,   ,   ,   ,   . -'
     O               52 26   E#PRAM              74 ' ,   ,   ,   ,   .  -'
     O               53 26   E#PRAM              74 '   ,   ,   ,   .   -'
     O              N30 26                       59 'PRIN:'
     O               30 26                       59 'CON:'
     O               50 27   E#INTA              93 '   ,   ,   ,   ,   -'
     O               51 27   E#INTA              93 '  ,   ,   ,   ,   . -'
     O               52 27   E#INTA              93 ' ,   ,   ,   ,   .  -'
     O               53 27   E#INTA              93 '   ,   ,   ,   .   -'
     O                  27                       78 'INT:'
     O               50 28   E#COMM             112 '   ,   ,   ,   ,   -'
     O               51 28   E#COMM             112 '  ,   ,   ,   ,   . -'
     O               52 28   E#COMM             112 ' ,   ,   ,   ,   .  -'
     O               53 28   E#COMM             112 '   ,   ,   ,   .   -'
     O                  28                       97 'COM:'
     O               50 29   E#TAMT             131 '   ,   ,   ,   ,   -'
     O               51 29   E#TAMT             131 '  ,   ,   ,   ,   . -'
     O               52 29   E#TAMT             131 ' ,   ,   ,   ,   .  -'
     O               53 29   E#TAMT             131 '   ,   ,   ,   .   -'
     O                  29                      116 'TOT:'
     O               21      E#RTSP              65 '    .       '
     O               22      E#CFCT              65 ' .         '
     O               23      E#CPDP              65 '            .   '
     O               24      E#IRAT              65 '    .       '
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** NAR
Newly added transaction
Deleted transaction - input today
Deleted transaction - input before today
Existing transaction
** TAB
DDDEAL DATE
VDVALUE DATE
FEFEE (OR PREMIUM)
XMFOREX MARGIN
MIMAN.ADJ.INTEREST
SASTOP ACCRUALS
PIPRINCIPAL INCREASE
PDPRINCIPAL DECREASE
IPINTEREST PAYMENT
ODOVERDUE
REREPAYMENT
MRMANUAL REPAYMENT
SCSPREAD CHANGE
BCBASE RATE CHANGE
ROROLLOVER
PEPERIOD END
MTMATURITY
PPPART PAYMENT
MPMORTGAGE PAYMENT
TPTRADE PURCHASE
TSTRADE SALE
IRRATE CHANGE
