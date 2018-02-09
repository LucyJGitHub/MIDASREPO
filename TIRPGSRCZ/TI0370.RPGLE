     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas TI COB Shadow posting of TI postings')           *
     F*****************************************************************
     F*                                                               *
     F*  Midas/TI Interface                                           *
     F*                                                               *
     F*  TI0370 - COB Shadow Posting of forward dated TI postings     *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27045A          Date 13Apr10               *
      *                 BUG27045           Date 18Feb10               *
      *                 CAP205             Date 16Mar10               *
      *                 CAP204             Date 09Feb10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 212558             Date 30Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CTI003             Date 10May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185145             Date 10Nov00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 151068             Date 26Apr99               *
     F*                 CTI001    Create   DATE 27AUG97               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  BUG27045A - Override the fix of Bug 27045 (Recompile)        *
      *  BUG27045 - Amend via SOAP removes Document Linkage           *
      *             (Recompile)                                       *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *  CAP204 - Teller Related APIs - Account Transfer (Recompile)  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
     F*  212558 - Change TIPOST DS and TIKEY as TIPOSTL0 key          *
     F*           definition has changed.                             *
     F*  CTI003 - Recompiled for change to TIPOSTL0.                  *
     F*  185145 - Records with "Posting Error Flag" set to "Y" should *
     F*           not be processed.                                   *
     F*  151068 - No narrative on shadow postings. If nothing passed  *
     F*           from TI then use the Deal Type and Deal Reference.  *
     F*  CTI001 - Midas/TI Interface (Phase 1)                        *
     F*                                                               *
     F*****************************************************************
     F*
     FTIPOSTL0  UF   E           K DISK
     F                                     RENAME(TIPOSTD0:@TIPSTL0)
     F*
     FRSACMTPD  O  A E           K DISK
     F*
     F/COPY WNCPYSRC,TI0370F001
     FSTOPCL1   IF   E           K DISK
      * RE Stopped Cheques
     F*
     D********************************************************************
     D*  DATA STRUCTURE FOR COMPILATION  - COPYRIGHT INSERTION
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              COPYRIGHT STATEME
     D*
     D*     ACCNT key for error reporting
     D ACNERR          DS
     D**##CNUM**               1      6  0                                                    CSD027
     D  ##CNUM                 1      6A                                                      CSD027
     D  ##CCY                  7      9
     D***##ACOD*               10     13  0                                                   CGL029
     D***##ACSQ*               14     15  0                                                   CGL029
     D***##BRCA*               16     18                                                      CGL029
     D  ##ACOD                10     19  0                                                    CGL029
     D  ##ACSQ                20     21  0                                                    CGL029
     D  ##BRCA                22     24                                                       CGL029
     D*
     D*     TIPOSTL0 key for error reporting
     D TIPOST          DS
     D  TRANID                 1      4                                                       212558
     D  TIDLBR                 5      8                                                       212558
     D  TIEVRF                 9     25                                                       212558
     D  TISEQN                26     28  0                                                    212558
     D  TIVALD                29     35  0                                                    212558
     D**TIDLBR**               1      4                                                       212558
     D**TIDLTP**               5      7                                                       212558
     D**TIDLRF**               8     20                                                       212558
     D**TISEQN**              21     23  0                                                    212558
     D**TIVALD**              24     30  0                                                    212558
     D*
     D LDA           E DS                  EXTNAME(LDA)
     D* Local Data Area to identify database errors
     D*
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D* Bank Details
     D*
     D SDACNT        E DS                  EXTNAME(ACCNTAB)
     D* Account Details
     D*
     D SDTIIN        E DS                  EXTNAME(SDTIINPD)
     D* TI ICD details
     D*
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAP205
     D  XLCD         E                     EXTFLD(LCD)                                        CAP205
     D* Switchable features data structure                                                    CAP205
     D*                                                                                       CAP205
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D* SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     D/COPY WNCPYSRC,TI0370D001
                                                                                              CGL029
     D W0ACCD          S             10A                                                      CGL029
     D P@ACCD          S             10P 0                                                    CGL029
     D*
     D********************************************************************
     C*
     C     *ENTRY        PLIST
     C                   PARM                    RTNCDE            1
     C*
     C*     Program initialisation
     C*
     C     FSTCAL        IFEQ      ' '
     C                   EXSR      INITSR
     C                   ENDIF
     C*
     C*     Transaction processing
     C*
     C                   SETOFF                                       10
     C     *LOVAL        SETLL     @TIPSTL0
     C                   READ      @TIPSTL0                               10
     C*
     C     *IN10         DOWEQ     '0'
      *                                                                         185145
     C     PSTERR        IFNE      'Y'                                          185145
     C*
     C** Move account keys to DS for error processing
     C**********         Z-ADD     CNUM          ##CNUM                                       CSD027
     C                   EVAL      ##CNUM = CNUM                                              CSD027
     C                   MOVE      CCY           ##CCY
     C                   Z-ADD     ACOD          ##ACOD
     C                   Z-ADD     ACSQ          ##ACSQ
     C                   MOVE      BRCA          ##BRCA
     C*
     C** Move numeric fields to alpha for call.
     C                   MOVE      CNUM          W0CNUM
     C                   MOVE      ACOD          W0ACCD
     C                   MOVE      ACSQ          W0ACSQ
     C*
     C* Get Account Details
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       W0RTCD
     C                   PARM      '*KEY    '    W0OPTN
     C                   PARM      *BLANK        W0RETL           10
     C                   PARM                    W0CNUM            6
     C                   PARM      CCY           W0CCY             3
     C**********         PARM                    W0ACCD            4                          CGL029
     C                   PARM                    W0ACCD                                       CGL029
     C                   PARM                    W0ACSQ            2
     C                   PARM      BRCA          W0BRCA            3
     C     SDACNT        PARM      SDACNT        DSSDY
     C*
     C** Database error
     C     W0RTCD        IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      'TI0370'      DBPGM
     C                   MOVEL(P)  'AOACCTR0'    DBFILE
     C                   MOVEL(P)  ACNERR        DBKEY                          ************
     C                   Z-ADD     03            DBASE                          *DB ERROR 03
     C                   EXSR      ERRSR                                        ************
     C                   END
     C*
     C                   MOVE      'N'           UPDIND            1
     C*
     C*  Process the posting if this is a retail account and
     C*  Value Date = Run Day
     C     ATYP          IFEQ      'R'
     C     MTIVD         ANDEQ     BJRDNB
     C                   EXSR      RETAIL
     C                   ENDIF
     C*
     C     UPDIND        IFEQ      'Y'
     C     NONB          ANDEQ     0
     C                   EXSR      RSACSR
     C     TIKEY         CHAIN     @TIPSTL0                           11
     C     *IN11         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      'TI0370'      DBPGM
     C                   MOVEL(P)  'TIPOSTL0'    DBFILE
     C                   MOVEL(P)  TIPOST        DBKEY                          ************
     C                   Z-ADD     04            DBASE                          *DB ERROR 04
     C                   EXSR      ERRSR                                        ************
     C                   ENDIF
     C*
     C                   MOVE      'SHP'         PSTS
     C                   UPDATE    @TIPSTL0                             11
     C*  Data base error if update fails
     C     *IN11         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      'TI0370'      DBPGM
     C                   MOVEL(P)  'TIPOSTL0'    DBFILE
     C                   MOVEL(P)  TIPOST        DBKEY                          ************
     C                   Z-ADD     05            DBASE                          *DB ERROR 05
     C                   EXSR      ERRSR                                        ************
     C                   ENDIF
     C*
     C                   ENDIF
      *                                                                         185145
     C                   ENDIF                                                  185145
     C*
     C                   READ      @TIPSTL0                               10
     C                   ENDDO
     C*
     C                   RETURN
     C********************************************************************
     C*
     C********************************************************************
     C*     Subroutine:   RETAIL                                         *
     C*     Memos processing - (Retail)                                  *
     C*                                                                  *
     C********************************************************************
     C*
     C     RETAIL        BEGSR
     C*
     C*
     C*    VALIDATION
     C                   MOVE      'N'           VALERR            1
     C*
     C* Account must be open to be valid
     C     DACC          IFNE      *ZERO
     C                   MOVE      'Y'           VALERR
     C                   GOTO      ENDVAL
     C                   ENDIF
     C*
     C*  Check status of retail account?
     C     TIREAS        IFEQ      'Y'
     C*
     C*   Bit 0 - Refer Debits?
     C*   Bit 1 - Refer Credits?
     C*   Bit 2 - Block Debits?
     C*   Bit 3 - Block Credits?
     C*   Bit 4 - Account is Inactive?
     C*   Bit 6 - Bankrupt/Liquidation?
     C*   Bit 7 - Bad Debt?
     C*
     C                   TESTB     '467'         RETB                 87
     C     *IN87         IFEQ      *OFF
     C                   MOVE      'Y'           VALERR
     C                   GOTO      ENDVAL
     C                   ENDIF
     C*
     C     TIDCIN        IFEQ      'D'
     C                   TESTB     '02'          RETB                 87
     C     *IN87         IFEQ      *OFF
     C                   MOVE      'Y'           VALERR
     C                   GOTO      ENDVAL
     C                   ENDIF
     C                   ENDIF
     C*
     C     TIDCIN        IFEQ      'C'
     C                   TESTB     '13'          RETB                 87
     C     *IN87         IFEQ      *OFF
     C                   MOVE      'Y'           VALERR
     C                   GOTO      ENDVAL
     C                   ENDIF
     C                   ENDIF
     C*
      *  Stopped cheques for this account?
     C     ACNO          CHAIN     STOPCL1                            86
     C     *IN86         IFEQ      *OFF
     C                   MOVE      'Y'           VALERR
     C                   GOTO      ENDVAL
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C*  If validation is successful update MEMOS file
     C*
     C*  If a credit transaction reverse the sign.
     C     TIDCIN        IFEQ      'C'
     C                   EVAL      W0AMT = TIAMNT * (-1)
     C                   ELSE
     C                   Z-ADD     TIAMNT        W0AMT
     C                   ENDIF
     C*
     C** Call Access Object AOMEMSU0
     C                   CALL      'AOMEMSU0'
     C                   PARM      *BLANKS       W0RTCD
     C                   PARM      ACNO          P@RETL           10 0
     C**********         PARM      CNUM          P@CNUM            6 0                        CSD027
     C                   PARM      CNUM          P@CNUM            6                          CSD027
     C                   PARM      CCY           W0CCY
     C**********         PARM      ACOD          P@ACCD            4 0                        CGL029
     C                   PARM      ACOD          P@ACCD                                       CGL029
     C                   PARM      ACSQ          P@ACSQ            2 0
     C                   PARM      BRCA          W0BRCA
     C                   PARM      BJRDNB        W0RUND            5 0
     C                   PARM      MTIVD         W0VDAT            5 0
     C                   PARM                    W0AMT            15 0
     C                   PARM      'N'           W0FTOV            1
     C*
     C     W0RTCD        IFNE      '       '
     C     *LOCK         IN        LDA
     C                   MOVE      'TI0370'      DBPGM
     C                   MOVEL(P)  'AOMEMSU0'    DBFILE
     C                   MOVEL(P)  ACNERR        DBKEY                          ************
     C                   Z-ADD     06            DBASE                          *DB ERROR 06
     C                   EXSR      ERRSR                                        ************
     C                   ENDIF
     C/COPY WNCPYSRC,TI0370C001
     C*
     C     ENDVAL        TAG
     C     VALERR        IFEQ      'N'
     C                   MOVE      'Y'           UPDIND
     C                   ENDIF
     C*
     C                   ENDSR
     C********************************************************************
     C*
     C********************************************************************
     C*                                                                  *
     C*     RSACSR SR     SUB-ROUTINE                                    *
     C*     Shadow postings to RSACMTPD                                  *
     C*                                                                  *
     C********************************************************************
     C*
     C     RSACSR        BEGSR
     C*
     C**********         Z-ADD     CNUM          CUSN                           Customer      CSD027
     C                   EVAL      CUSN = CNUM                                  Customer      CSD027
     C                   Z-ADD     ACOD          ACDE                           Accnt Code
     C                   Z-ADD     ACSQ          ASNC                           Accnt Seq
     C*
     C                   MOVE      CCY           CCYD                           Currency
     C                   Z-ADD     BJRDNB        PTDT                           Post Date
     C                   Z-ADD     MTIVD         VUDT                           Value Date
     C                   MOVE      'TI'          TRYP                           Trans Type
     C                   MOVE      *BLANK        NRTC                           Narr Code
     C     TINAR1        IFEQ      *BLANKS                                      151068
     C                   MOVEL     TIDLTP        TINAR16          16            151068
     C                   MOVE      TIDLRF        TINAR16                        151068
     C                   MOVEL     TINAR16       NRTD                           151068
     C                   ELSE                                                   151068
     C                   MOVEL     TINAR1        NRTD                           Narr Desc
     C                   END                                                    151068
     C                   MOVEL     *BLANK        TNMR                           Trans Num
     C                   Z-ADD     0             CQNR                           Cheque Num
     C                   Z-ADD     TIAMNT        MVAM                           Mvmt Amt
     C     TIDCIN        IFEQ      'D'
     C                   Z-ADD     *ZERO         DORC                           D/C Ind
     C                   ELSE
     C                   Z-ADD     1             DORC
     C                   ENDIF
     C                   MOVE      *BLANK        FUND
     C                   MOVE      *BLANK        TBID
     C                   MOVE      *BLANK        APBI
     C                   MOVE      *BLANK        PASS
      *                                                                                       CAP205
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'TI'          CMOD                                         CAP205
     C                   MOVEL     'F'           MTYP                                         CAP205
     C                   ENDIF                                                                CAP205
     C*
     C                   WRITE     RSACMTPO                             10
     C*
     C*     Data base error if write fails
     C     *IN10         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      'TI0370'      DBPGM                          ************
     C                   Z-ADD     07            DBASE                          *DB ERROR 07 *
     C                   MOVE      'RSACMTPD'    DBFILE                         ************
     C                   MOVEL     'ON WRITE'    DBKEY
     C                   EXSR      ERRSR
     C                   ENDIF
     C/COPY WNCPYSRC,TI0370C002
     C*
     C                   ENDSR
     C********************************************************************
     C*
     C********************************************************************
     C*     INITSR SR     SUB-ROUTINE                                    *
     C*     Program initialisation                                       *
     C*                                                                  *
     C********************************************************************
     C*
     C     INITSR        BEGSR
     C*
     C                   MOVE      'N'           FSTCAL            1
     C*
     C                   MOVEA     CPY@          BIS@             80
     C*
     C* Define LDA
     C     *DTAARA       DEFINE                  LDA
     C*
     C     TIKEY         KLIST
     C                   KFLD                    TRANID                                       212558
     C                   KFLD                    TIDLBR
     C**********         KFLD                    TIDLTP                                       212558
     C**********         KFLD                    TIDLRF                                       212558
     C                   KFLD                    TIEVRF                                       212558
     C                   KFLD                    TISEQN
     C                   KFLD                    TIVALD
     C*
     C* Access bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       W0RTCD            7
     C                   PARM      '*FIRST  '    W0OPTN            7
     C     SDBANK        PARM      SDBANK        DSSDY
     C*
     C** Database error
     C     W0RTCD        IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      'TI0370'      DBPGM
     C                   MOVEL(P)  'AOBANKR0'    DBFILE
     C                   MOVEL(P)  '*CALL'       DBKEY                          ************
     C                   Z-ADD     01            DBASE                          *DB ERROR 01
     C                   EXSR      ERRSR                                        ************
     C                   END
     C*
     C*  Retrieve TI Details
     C                   CALL      'AOTIINR0'
     C                   PARM      '*MSG'        W0RTCD
     C                   PARM      '*FIRST'      W0OPTN
     C     SDTIIN        PARM      SDTIIN        DSFDY
     C*
     C** Database error
     C     W0RTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      'TI0370'      DBPGM
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'AOTIINR0'    DBFILE                         ************
     C                   Z-ADD     2             DBASE                          *DB ERROR 02
     C                   EXSR      ERRSR                                        ************
     C                   ENDIF
      *                                                                                       CAP205
      ** Access AOSARDR0 and check if CAP205 is installed                                     CAP205
      *                                                                                       CAP205
     C                   CALL      'AOSARDR0'                                                 CAP205
     C                   PARM      *BLANKS       W0RTCD                                       CAP205
     C                   PARM      '*VERIFY'     W0OPTN                                       CAP205
     C                   PARM      'CAP205'      W0SARD            6                          CAP205
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP205
      *                                                                                       CAP205
     C     W0RTCD        IFNE      *BLANKS                                                    CAP205
     C     W0RTCD        ANDNE     '*NRF    '                                                 CAP205
     C     *LOCK         IN        LDA                                                        CAP205
     C                   MOVE      'TI0370'      DBPGM                                        CAP205
     C                   MOVEL     'CAP205'      DBKEY                                        CAP205
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************  CAP205
     C                   Z-ADD     8             DBASE                          *DB ERROR 08  CAP205
     C                   EXSR      ERRSR                                        ************  CAP205
     C                   ENDIF                                                                CAP205
      *                                                                                       CAP205
     C     W0RTCD        IFEQ      *BLANKS                                                    CAP205
     C                   MOVE      'Y'           CAP205            1                          CAP205
     C                   ELSE                                                                 CAP205
     C                   MOVE      'N'           CAP205                                       CAP205
     C                   ENDIF                                                                CAP205
      *                                                                                       CAP205
     C/COPY WNCPYSRC,TI0370C003
     C*
     C                   ENDSR
     C********************************************************************
     C*
     C********************************************************************
     C*     ERRSR  SR     SUB-ROUTINE                                    *
     C*     Error routine                                                *
     C*                                                                  *
     C********************************************************************
     C*
     C     ERRSR         BEGSR
     C*
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   MOVE      'E'           RTNCDE
     C                   RETURN
     C*
     C                   ENDSR
     C*
     C********************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2001
