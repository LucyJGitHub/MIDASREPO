     H DEBUG
     H Copyright('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas LE PDCL creation of settlement account keys')    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000823 - PDCL creation of settlement account keys          *
      *                                                               *
      *  Called By: LEC000823 (COB) - PDCL creation of                *
      *             settlement account keys                           *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. MD054245           Date 09Sep19               *
      *  Prev Amend No. MD051883           Date 04Apr19               *
      *                 MD051944           Date 22Sep18               *
      *                 MD049865           Date 06Aug18               *
      *                 MD051242           Date 25Jun18               *
      *                 MD049363           Date 19Sep18               *
      *                 MD051242           Date 25Jun18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD048557           Date 27Nov17               *
      *                 MD048558           Date 21Nov17               *
      *                 MD046080  *CREATE  Date 17Sep17               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054245 - Missing P and S settlement entries on Loan Fee    *
      *  MD051883 - CLE031: Changes to Value Date Account Keys        *
      *  MD051944 - Settlement entries from Principal Increase        *
      *             event is rounded down                             *
      *  MD049865 - Component LEC000823 failed in COB                 *
      *  MD049363 - Percentage allocation error                       *
      *  MD051242 - CLE031: COB: GLC0340 failed with Currency out of  *
      *             balance for fee with no settlement currency       *
      *  MD046248 - Finastra Rebranding                               *
      *  MD048557 - Failing COB Component - LEC000471A                *
      *  MD048558 - Failing COB Component - LEC000823 00002           *
      *  MD046080 - Gap between CLE031 (Settlement to different       *
      *             currency) and CLE134 (PDCL processing)            *
      *                                                               *
      *****************************************************************

      ** Midas LE Past Due Call Loans Account Keys
     FLEPK1L0   UF A E           K DISK
     F                                     PREFIX(L1_)
     F                                     COMMIT                                           MD051242

      ** Midas LE Fee Past Due Call Loans Account Keys
     FLEPK2L0   UF A E           K DISK
     F                                     RENAME(LKEYFEDF:LKEY2DPF)
     F                                     PREFIX(L2_)
     F                                     COMMIT                                           MD051242

      ** Midas LE Fee Past Due Call Loans Account Keys
     FLEPK3L0   UF A E           K DISK
     F                                     RENAME(LKEYFEDF:LKEY3DPF)
     F                                     PREFIX(L3_)
     F                                     COMMIT                                           MD051242

      ** Midas LE Settlement Allocation File
     FLESTALLF  IF   E           K DISK
     F                                     PREFIX(F_)

      ** Settlement Allocation by RONS
     FLESTALLG  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LESTALD0:LESTALD1)
     F                                     PREFIX(G_)

      ** Settlement Allocation by PONS
     FLESTALLH  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LESTALD0:LESTALD2)
     F                                     PREFIX(H_)

      ** Loan Details
     FCLOANL4   IF   E           K DISK    INFSR(*PSSR)

      ** Fee Settl Det by BRCA, CNUM, FACL, LOAN, FSEQ
     FLEFEEDLU  IF   E           K DISK    RENAME(LEFEEDF:LEFEEDFO)
                                                                                            MD048557
     FLEPK1ZZ   UF A E             DISK    INFSR(*PSSR)                                     MD048557
     F                                     RENAME(LKEY1ZZF:LKEYF1ZF)                        MD048557
     F                                     COMMIT                                           MD051242
                                                                                            MD051242
     FLEPK2ZZ   UF A E             DISK    INFSR(*PSSR)                                     MD051242
     F                                     RENAME(LKEYFEZF:LKEYF2ZF)                        MD048557
     F                                     PREFIX(L2_)                                      MD051242
     F                                     COMMIT                                           MD051242
                                                                                            MD051242
     FLEPK3ZZ   UF A E             DISK    INFSR(*PSSR)                                     MD051242
     F                                     RENAME(LKEYFEZF:LKEYF3ZF)                        MD051242
     F                                     PREFIX(L3_)                                      MD051242
     F                                     COMMIT                                           MD051242

      *****************************************************************
      /EJECT
      *****************************************************************
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      ** True       logical = *ON (for indcator processing)
      ** False      logical = *OFF (for indcator processing)
      ** DBErrCtl   10A = 'DBERRCTL' (the name of the database error
      ** handler)
      ** and the following variables:
      ** RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** The following /COPY line includes the definitions for error &
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS

      *****************************************************************
      /EJECT
      *****************************************************************

      ** Data structure for Branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)

      ** Data structure for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data Structure for Account Details

     D ACCNTB        E DS                  EXTNAME(ACCNTAB)

      ** Data structure for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** Data structure for fees ICD details
     D SDFEE         E DS                  EXTNAME(SDFEEPD)
     D DSFDY         E DS
     D DSSDY         E DS

     D wFeekey         DS
     D wFcnu2                  1      6
     D wFlnno                  8     13
     D wFefseq                15     16
     D wFefcod                18     19

     D pReturnCode     s              7
     D CLE134          S              1
     D WRetcd          S              7
     D pAPOS           S              1
     D pCNAME          S             10
     D wPostR          S              1
     D WPARM           S             20A   INZ('LoanCustOriginPurch')

      ** Account
     D wLoan           S              6
     D wcnu2           S              6
     D wFacl           S              5
     D wFseq           S              2
     D wFcod           S              2
     D wFbrcd          S              3

     D wBrca           S              3
     D wCNum           S              6
     D wCCY            S              3
     D wACod           S             10  0
     D wACSq           S              2  0
     D wACodA          S             10
     D wACSqA          S              2

     D ZS2             S              1    DIM(21)
     D                 DS
     D  WORK15                 1     15  0
     D  ZS1                    1     15  0
     D                                     DIM(15)
     D                 DS
     D  AKY                    1     14
     D                                     DIM(14)
     D                 DS                                                                   MD051242
     D  AKP                    1     14                                                     MD051242
     D                                     DIM(14)                                          MD051242

      ** Additional Field Definitions
     D @FECD           S              2
     D WPastDue        S              1
     D WReverse        S              1
     D WDrCr           S              1
     D W@FCUS          S              6
     D W@LOAN          S              6
     D W@FACL          S              5
     D W@FSEQ          S              2
     D W@FCOD          S              2
     D W@PDCL          S              1
     D W@FILE          S             10
     D WMult           S              1  0
     D Wf10            S             10
     D Wtypef          S              1
     D W@Type          S              1

     D WRK01           S              1
     D PPCUST          S              1
     D W@PGNM          S             10

     D WINAMT          S             15  0
     D WRATE           S             13  8
     D WREXI           S              1A
     D WMDIN           S              1A
     D WCCY1           S              3A
     D WCCY2           S              3A
     D WNBDP1          S              1  0
     D WNBDP2          S              1  0
     D WOUTAMT         S             15  0
     D WWWAMT          S             15P 0
     D ORWAMT          S             15P 0
     D WACAMT          S             13P 0                                                  MD048557
     D CLE031          S              1A
     D CLE034          S              1A
     D KRECI           S              1A
     D KLOAN           S              6A
     D WTYPE           S              1A
     D WRKCCY          S              3A
     D WRKEXR          S             13  8
     D WRKEXI          S              1A
     D WKPURC          S              3A
     D WKSALC          S              3A
     D WRKPCY          S              3A
     D WRKSCY          S              3A
     D WIND1           S              1A
     D WRKFCY          S              3A
     D WSET            S             18A
     D WFILE           S             10A                                                    MD051242
     D PDCL            S              1N                                                    MD051242
     D SqlStr          S           2000A   INZ(*BLANKS)                                     MD051242
     D KeyStr          S             14A   INZ(*BLANKS)                                     MD051242
     D QUO             C                   CONST('''')                                      MD051242
     D Counter         S             10S 0 INZ(*ZEROS)                                      MD051242
     D WKLPUR          S              3A                                                    MD051242
     D WKLSAL          S              3A                                                    MD051242
     D KVDAT           S              5P 0                                                  MD049363
     D KLASN           S              3S 0                                                  MD049363

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *****************************************************************
      ** M A I N  P R O C E S S I N G                                 *
      *****************************************************************

      ** store existing trailers amount                                                     MD048557
                                                                                            MD048557
     C                   Z-ADD     0             L1VLRF                                     MD048557
     C                   Z-ADD     0             L1VLRL                                     MD048557
     C                   Z-ADD     0             L1NORE                                     MD048557
     C                   Z-ADD     0             WACAMT                                     MD048557
                                                                                            MD051242
     C                   Z-ADD     0             L2VLRF                                     MD051242
     C                   Z-ADD     0             L2VLRL                                     MD051242
     C                   Z-ADD     0             L2NORE                                     MD051242
                                                                                            MD051242
     C                   Z-ADD     0             L3VLRF                                     MD051242
     C                   Z-ADD     0             L3VLRL                                     MD051242
     C                   Z-ADD     0             L3NORE                                     MD051242
      *                                                                                     MD048557
     C     1             SETLL     LEPK1ZZ                                                  MD048557
     C                   READ      LEPK1ZZ                                88                MD048557
     C     *IN88         IFEQ      *OFF                                                     MD048557
     C                   Z-ADD     NORE          L1NORE                                     MD048557
     C                   Z-ADD     VLRF          L1VLRF                                     MD048557
     C                   Z-ADD     VLRL          L1VLRL                                     MD048557
     C                   ENDIF                                                              MD048557
      *                                                                                     MD051242
     C     1             SETLL     LEPK2ZZ                                                  MD051242
     C                   READ      LEPK2ZZ                                88                MD051242
     C     *IN88         IFEQ      *OFF                                                     MD051242
     C                   Z-ADD     L2_LKNORE     L2NORE                                     MD051242
     C                   Z-ADD     L2_LKVLRF     L2VLRF                                     MD051242
     C                   Z-ADD     L2_LKVLRL     L2VLRL                                     MD051242
     C                   ENDIF                                                              MD051242
      *                                                                                     MD051242
     C     1             SETLL     LEPK3ZZ                                                  MD051242
     C                   READ      LEPK3ZZ                                88                MD051242
     C     *IN88         IFEQ      *OFF                                                     MD051242
     C                   Z-ADD     L3_LKNORE     L3NORE                                     MD051242
     C                   Z-ADD     L3_LKVLRF     L3VLRF                                     MD051242
     C                   Z-ADD     L3_LKVLRL     L3VLRL                                     MD051242
     C                   ENDIF                                                              MD051242
      *                                                                                     MD051242
      ** Read thru LEPK1DPD

     C                   EVAL      WTYPE = 'L'
     C                   EVAL      *IN88 = '0'
     C     *LOVAL        SETLL     LEPK1L0

      ** loop to read a/c keys on LEPK1DPD

     C     *IN88         DOWEQ     *OFF
     C                   READ      LEPK1L0                                88

     C     *IN88         IFEQ      *OFF

     C                   IF        %SUBST(L1_AKEY:9:2) <> 'XP'
     C                             AND %SUBST(L1_AKEY:9:2) <> 'XI'
     C                             AND %SUBST(L1_AKEY:3:1) <> 'S'

     C                   EXSR      SETTLE1

     C                   ENDIF
     C                   ENDIF

     C                   ENDDO

      ** Read thru LEPK2DPD

     C                   EVAL      WTYPE = 'F'
     C                   EVAL      *IN88 = '0'
     C     *LOVAL        SETLL     LEPK2L0

      ** loop to read a/c keys on LEPK2DPD

     C     *IN88         DOWEQ     *OFF
     C                   READ      LEPK2L0                                88

     C     *IN88         IFEQ      *OFF

     C                   IF        %SUBST(L2_LKAKEY:10:1) = 'F'
     C                             AND %SUBST(L2_LKAKEY:4:1) <> 'S'
     C                             AND L2_LKRECI = 'F'
     C                             OR %SUBST(L2_LKAKEY:10:1) = 'F'                          MD051242
     C                             AND %SUBST(L2_LKAKEY:3:1) <> 'S'                         MD051242
     C                             AND L2_LKRECI = 'L'                                      MD051242

     C                   EXSR      SETTLE2

     C                   ENDIF
     C                   ENDIF

     C                   ENDDO

      ** Read thru LEPK3DPD

     C                   EVAL      WTYPE = 'F'
     C                   EVAL      *IN88 = '0'
     C     *LOVAL        SETLL     LEPK3L0

      ** loop to read a/c keys on LEPK3DPD

     C     *IN88         DOWEQ     *OFF
     C                   READ      LEPK3L0                                88

     C     *IN88         IFEQ      *OFF

     C                   IF        %SUBST(L3_LKAKEY:10:1) = 'F'
     C                             AND %SUBST(L3_LKAKEY:4:1) <> 'S'
     C                             AND L3_LKRECI = 'F'
     C                             OR %SUBST(L3_LKAKEY:10:1) = 'F'                          MD051242
     C                             AND %SUBST(L3_LKAKEY:3:1) <> 'S'                         MD051242
     C                             AND L3_LKRECI = 'L'                                      MD051242

     C                   EXSR      SETTLE3

     C                   ENDIF
     C                   ENDIF

     C                   ENDDO
                                                                                            MD048557
     C                   EXSR      STRAIL                                                   MD048557

     C                   EVAL      *INLR       = *ON
     C                   RETURN

      *****************************************************************
     C/EJECT
      *****************************************************************
      *    SRCvtAmt - Convert Amount                                  *
      *****************************************************************
     C     SRCvtAmt      BEGSR

     C                   IF        WTYPE = 'L'

      ** If CLE034 switched ON, get settlement details fro LESTALPD
     C                   IF        CLE034 = 'Y'
     C                             AND STAL = 'Y'
     C                   MOVE      *BLANKS       WSET
     C                   MOVE      L1_OSAC       WSET
     C                   IF        L1_ALASN = 999                                           MD049363
     C                   EVAL      KVDAT = 0                                                MD049363
     C                   EVAL      KLASN = 0                                                MD049363
     C                   ELSE                                                               MD049363
     C                   EVAL      KVDAT = L1_AVDAT                                         MD049363
     C                   EVAL      KLASN = L1_ALASN                                         MD049363
     C                   ENDIF                                                              MD049363
     C                   IF        PTYP <> 66
     C                             AND PTYP <> 67
     C                             AND PTYP <> 69
     C                             AND PTYP <> 72
     C     KSTAL         CHAIN     LESTALLG
     C                   MOVE      G_RSCY        WCCY1
     C                   MOVE      G_REXI        WIND1
     C                   Z-ADD     G_REXR        WRATE
     C                   ELSE
     C     KSTAL         CHAIN     LESTALLH
     C                   MOVE      H_PSCY        WCCY1
     C                   MOVE      H_PEXI        WIND1
     C                   Z-ADD     H_PEXR        WRATE
     C                   ENDIF
     C                   ELSE
     C**********         IF        PTYP <> 66                                               MD051242
     C**********                   AND PTYP <> 67                                           MD051242
     C**********                   AND PTYP <> 69                                           MD051242
     C**********                   AND PTYP <> 72                                           MD051242
     C**********         EVAL      WCCY1 = PSCY                                             MD051242
     C**********         EVAL      WRATE = PEXR                                             MD051242
     C**********         EVAL      WIND1 = PEXI                                             MD051242
     C**********         ELSE                                                               MD051242
     C**********         EVAL      WCCY1 = SCCY                                             MD051242
     C**********         EVAL      WRATE = REXR                                             MD051242
     C**********         EVAL      WIND1 = REXI                                             MD051242
     C                   EVAL      WCCY1 = L1_ECCY                                          MD051242
     C                   EVAL      WRATE = L1_EXRT                                          MD051242
     C                   MOVEL     L1_OTHC       WIND1                                      MD051242
     C**********         ENDIF                                                              MD051242
     C                   ENDIF

     C                   ELSE

      ** If CLE034 switched ON, get settlement details fro LESTALPD
     C                   IF        CLE034 = 'Y'
     C                             AND FESTAL = 'Y'
     C     KAllF         CHAIN     LESTALLF
     C                   IF        %FOUND(LESTALLF)
     C                   EVAL      WCCY1 = F_RSCY
     C                   EVAL      WRATE = F_REXR
     C**********         EVAL      WREXI = F_REXI                                           MD051242
     C                   EVAL      WIND1 = F_REXI                                           MD051242
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   MOVEL     'LESTALLF'    DBFILE
     C                   EVAL      DBASE = 007
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF

     C                   ELSE
     C                   EVAL      WCCY1 = FESCCY
     C                   EVAL      WRATE = FEREXR
     C**********         EVAL      WREXI = FEREXI                                           MD051242
     C                   EVAL      WIND1 = FEREXI                                           MD051242
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      WCCY2 = CCY
     C                   IF        WTYPE = 'F'
     C                   EVAL      WCCY2 = FEFCCY
     C                   ENDIF
     C                   IF        WIND1 = 'M'
     C                   EVAL      WMDIN = 'D'
     C                   ELSE
     C                   EVAL      WMDIN = 'M'
     C                   ENDIF

      ** If one of currencies is blank, skip conversion

     C                   IF        WCCY1 = *BLANKS or WCCY2 = *BLANKS
     C                   EVAL      WOUTAMT = WINAMT
     C                   ELSE

      ** From currency

     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    WCCY1
     C     SDCURR        PARM                    DSSDY

      ** Save necessary details

     C                   EVAL      WNBDP1 = A6NBDP

      ** To currency

     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    WCCY2
     C     SDCURR        PARM                    DSSDY

      ** Save necessary details

     C                   EVAL      WNBDP2 = A6NBDP

      ** Convert amount

     C                   CALL      'ZCONVZ1'
     C                   PARM                    WINAMT
     C                   PARM                    WRATE
     C                   PARM                    WMDIN
     C                   PARM                    WCCY1
     C                   PARM                    WCCY2
     C                   PARM                    WNBDP1
     C                   PARM                    WNBDP2
     C                   PARM                    WOUTAMT

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SETTLE1 - Subroutine to produce four new keys required for   *
      *           settling in a different currency                    *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls     : AKYOUT                                           *
      *                                                               *
      *****************************************************************

     C     SETTLE1       BEGSR

     C                   EVAL      KRECI = 'D'                                              MD051242
     C                   EVAL      KLOAN = L1_LNNO                                          MD051242
     C     KLOANK        CHAIN     CLOANL4                                                  MD051242
     C                   IF        NOT %FOUND                                               MD051242
     C                   EVAL      KRECI = 'M'                                              MD051242
     C     KLOANK        CHAIN     CLOANL4                                                  MD051242
     C                   ENDIF                                                              MD051242
     C                   IF        L1_ECCY = CCY                                            MD051242
     C                   LEAVESR                                                            MD051242
     C                   ENDIF                                                              MD051242
     C                   EVAL      WKLPUR = L1_ECCY                                         MD051242
     C                   EVAL      WKLSAL = CCY                                             MD051242
                                                                                            MD051242
     C                   Z-ADD     0             WACAMT                                     MD051242
     C                   EVAL      WFILE = 'LEPK1DPD'                                       MD051242
     C                   MOVEA     L1_AKEY       AKP                                        MD051242
     C                   MOVEA     L1_AKEY       AKY                                        MD051242

     C                   MOVE      'S'           AKY(3)
     C                   MOVEA     '    '        AKY(6)
      *
     C     L1_SECATC     IFEQ      'OLINT'
     C                   MOVE      'I'           AKY(8)
     C                   ENDIF

      ** Format xxSyybbbFB or xxSyybbbBB key for amount in purchase ccy

     C*****L1_ECCY       IFEQ      BJCYCD                                                   MD051242
     C     WKLPUR        IFEQ      BJCYCD                                                   MD051242
     C                   MOVEA     'BB'          AKY(9)
     C                   ELSE
     C                   MOVEA     'FB'          AKY(9)
     C                   ENDIF

     C                   MOVEA     AKY           L1_AKEY

     C                   WRITE     LKEY1DPF
     C                   EXSR      SRHASH                                                   MD048557

     C                   MOVEA     L1_AKEY       AKY
     C**********         EVAL      KRECI = 'D'                                              MD051242
     C**********         EVAL      KLOAN = L1_LNNO                                          MD051242
     C*****KLOANK        CHAIN     CLOANL4                                                  MD051242
     C**********         IF        NOT %FOUND                                               MD051242
     C******LOCK         IN        LDA                                                      MD048558
     C**********         MOVE      L1_LNNO       Dbkey                                      MD048558
     C**********         MOVEL     'CLOANL4'     Dbfile                                     MD048558
     C**********         Z-ADD     004           Dbase                                      MD048558
     C**********         OUT       LDA                                                      MD048558
     C**********         EXSR      *PSSR                                                    MD048558
     C**********         EVAL      KRECI = 'M'                                     MD048558 MD051242
                                                                                            MD048558
     C*****KLOANK        CHAIN     CLOANL4                                         MD048558 MD051242
     C**********         ENDIF                                                              MD051242

     C                   EVAL      WINAMT = L1_EAMT
     C                   EXSR      SRCvtAmt
     C                   CLEAR                   KeyStr                                     MD051242
     C                   IF        L1_PAMT <> 0                                             MD051242
     C                   MOVEA     'XP'          AKP(09)                                    MD051242
     C                   ELSE                                                               MD051242
     C                   MOVEA     'XI'          AKP(09)                                    MD051242
     C                   ENDIF                                                              MD051242
     C                   MOVEA     AKP           KeyStr                                     MD051242
     C                   EXSR      CheckPDCL                                                MD051242
     C                   IF        NOT(PDCL)                                                MD051242
     C                   EVAL      L1_EAMT = L1_OTHA                                        MD051242
     C                   ELSE                                                               MD051242
     C                   EVAL      L1_EAMT = WOUTAMT
     C                   ENDIF                                                              MD051242

      ** Format xxSyybbbFC or xxSyybbbBC key for amount in purchase ccy

     C*****WCCY1         IFEQ      BJCYCD                                                   MD051242
     C     WKLSAL        IFEQ      BJCYCD                                                   MD051242
     C                   MOVEA     'BC'          AKY(9)
     C                   ELSE
     C                   MOVEA     'FC'          AKY(9)
     C                   ENDIF

     C                   EVAL      L1_ECCY = CCY
     C                   MOVEA     AKY           L1_AKEY
     C                   WRITE     LKEY1DPF
     C                   EXSR      SRHASH                                                   MD048557

     C                   MOVEA     L1_AKEY       AKY
     C                   CALL      'AOCURRR0'                                               MD051944
     C                   PARM      *Blanks       @RTCD                                      MD051944
     C                   PARM      '*KEY'        @OPTN                                      MD051944
     C                   PARM      BJCYCD        WCCY1                                      MD051944
     C     SDCURR        PARM                    DSSDY                                      MD051944
                                                                                            MD051944
      ** Save necessary details                                                             MD051944
                                                                                            MD051944
     C                   EVAL      WNBDP1 = A6NBDP                                          MD051944
                                                                                            MD051944
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      L1_ECCY       WCCY1
     C     SDCURR        PARM                    DSSDY
                                                                                            MD054245
     C                   EVAL      WNBDP2 = A6NBDP                                          MD054245

     C     L1_ECCY       IFEQ      BJCYCD
     C                   Z-ADD     L1_EAMT       BSAMT            13 0
     C                   ELSE
     C*****A6MDIN        IFEQ      'M'                                                      MD051944
     C*****L1_EAMT       MULT      A6SPRT        BSAMT                                      MD051944
     C**********         ELSE                                                               MD051944
     C*****L1_EAMT       DIV       A6SPRT        BSAMT                                      MD051944
     C**********         ENDIF                                                              MD051944
      *                                                                                     MD051944
     C                   CALL      'ZCONVZ1'                                                MD051944
     C                   PARM      L1_EAMT       WINAMT                                     MD051944
     C                   PARM      A6SPRT        WRATE                                      MD051944
     C                   PARM      A6MDIN        WMDIN                                      MD051944
     C                   PARM      L1_ECCY       WCCY1                                      MD051944
     C                   PARM      BJCYCD        WCCY2                                      MD051944
     C**********         PARM      A6NBDP        WNBDP1                            MD051944 MD054245
     C**********         PARM      WNBDP1        WNBDP2                            MD051944 MD054245
     C                   PARM                    WNBDP2                                     MD054245
     C                   PARM                    WNBDP1                                     MD054245
     C                   PARM                    WOUTAMT                                    MD051944
      *                                                                                     MD051944
     C                   EVAL      BSAMT = WOUTAMT                                          MD051944
     C                   ENDIF
     C**********         ENDIF                                                              MD051944
      *
      ** Format xxSyycccbP key for Base Currency Equivalent of Spot Trade
      ** a/c in purchase currency
      *
     C                   MOVEA     ' P'          AKY(9)
     C**********         MOVEA     PSCY          AKY(6)                                     MD051242
     C                   MOVEA     WKLPUR        AKY(6)                                     MD051242
     C                   MOVE      BJCYCD        L1_ECCY
     C                   Z-ADD     BSAMT         L1_EAMT
     C                   MOVEA     AKY           L1_AKEY
     C                   WRITE     LKEY1DPF
     C                   EXSR      SRHASH                                                   MD048557

      ** Format xxsyybcccS key for Base Currency Equivalent of Spot Trade
      ** account in sale currency

     C                   MOVEA     L1_AKEY       AKY
     C                   MOVEA     ' S'          AKY(9)
     C**********         MOVEA     SCCY          AKY(6)                                     MD051242
     C                   MOVEA     WKLSAL        AKY(6)                                     MD051242
     C                   MOVEA     AKY           L1_AKEY
     C                   WRITE     LKEY1DPF
     C                   EXSR      SRHASH                                                   MD048557
     C**********         EVAL      L1NORE = L1NORE + 4                             MD048557 MD051242
     C                   ADD       4             L1NORE                                     MD051242

     C                   ENDSR

      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SETTLE2 - Subroutine to produce four new keys required for   *
      *           settling in a different currency                    *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls     : AKYOUT                                           *
      *                                                               *
      *****************************************************************

     C     SETTLE2       BEGSR

     C                   Z-ADD     0             WACAMT                                     MD051242
     C                   EVAL      WFILE = 'LEPK2DPD'                                       MD051242
     C                   MOVEA     L2_LKAKEY     AKP                                        MD051242

     C     KFEE2         CHAIN     LEFEEDLU
     C                   IF        NOT%FOUND
     C     *LOCK         IN        LDA
     C                   MOVE      L2_LKCNU2     wFcnu2

     C                   IF        L2_LKLOAN <> *BLANKS
     C                   MOVE      L2_LKLOAN     wFlnno
     C                   ELSE
     C                   MOVE      L2_LKFACL     wFlnno
     C                   ENDIF
     C                   MOVE      L2_LKFACL     wFlnno

     C                   MOVE      L2_LKFSE2     wFefseq
     C                   MOVE      L2_LKFCOD     wFefcod
     C                   MOVEL     Wfeekey       DBKEY
     C                   MOVEL     'LEFEED  '    Dbfile
     C                   Z-ADD     005           Dbase
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   MOVEA     L2_LKAKEY     AKY

     C**********         MOVE      'S'           AKY(4)                                     MD051242
     C                   IF        FELOAN > *BLANKS                                         MD051242
     C                   MOVE      'S'           AKY(3)                                     MD051242
     C                   MOVEA     ' '           AKY(6)                                     MD051242
     C                   MOVE      AKY(3)        SAV3              1                        MD051883
     C                   MOVE      AKY(6)        SAV6              1                        MD051883
     C                   ELSE                                                               MD051242
     C                   MOVE      'S'           AKY(4)                                     MD051242
     C                   MOVEA     '  '          AKY(5)
     C                   MOVE      AKY(4)        SAV4              1                        MD051883
     C                   MOVE      AKY(5)        SAV5              1                        MD051883
     C                   ENDIF                                                              MD051242

     C                   IF        PTFI <> ' '
     C                   MOVE      FEPSCY        WRKCCY
     C                   Z-ADD     FEPEXR        WRKEXR
     C                   MOVE      FEPEXI        WRKEXI
     C                   ELSE
     C                   MOVE      FESCCY        WRKCCY
     C                   Z-ADD     FEREXR        WRKEXR
     C                   MOVE      FEREXI        WRKEXI
     C                   ENDIF
      *                                                                                     MD051242
     C                   IF        WRKCCY = *BLANKS                                         MD051242
     C                   LEAVESR                                                            MD051242
     C                   ENDIF                                                              MD051242
                                                                                            MD051883
     C                   IF        FELOAN = *BLANKS                                         MD051883
     C                   MOVE      'R'           AKY(4)                                     MD051883
     C                   ELSE                                                               MD051883
     C                   MOVE      'R'           AKY(3)                                     MD051883
     C                   ENDIF                                                              MD051883
     C                   MOVE      'V'           AKY(10)                                    MD051883
     C                   MOVEA     AKY           L2_LKAKEY                                  MD051883
     C                   UPDATE    LKEY2DPF                                                 MD051883
     C                   IF        FELOAN = *BLANKS                                         MD051883
     C                   MOVE      SAV4          AKY(4)                                     MD051883
     C                   MOVE      SAV5          AKY(5)                                     MD051883
     C                   ELSE                                                               MD051883
     C                   MOVE      SAV3          AKY(3)                                     MD051883
     C                   MOVE      SAV6          AKY(6)                                     MD051883
     C                   ENDIF                                                              MD051883
                                                                                            MD051883

     C     PTFI          IFEQ      'P'
     C     PTFI          OREQ      'S'
     C     PTFI          OREQ      'R'
     C                   MOVE      FEFCCY        WRKPCY
     C                   MOVE      WRKCCY        WRKSCY
     C                   ELSE
     C                   MOVE      WRKCCY        WRKPCY
     C                   MOVE      FEFCCY        WRKSCY
     C                   ENDIF

     C                   MOVE      'B'           AKY(10)

      ** Format nnnSbbFffB or nnnSbbBffB for Amount in Purchase Ccy

     C     WRKPCY        IFEQ      BJCYCD
     C                   MOVE      'B'           AKY(7)
     C                   ELSE
     C                   MOVE      'F'           AKY(7)
     C                   ENDIF

     C                   MOVE      WRKPCY        L2_LKECCY
     C                   MOVEA     AKY           L2_LKAKEY

     C                   WRITE     LKEY2DPF
     C                   EXSR      SRHASH                                                   MD051242

     C                   MOVEA     L2_LKAKEY     AKY
     C                   MOVE      'C'           AKY(10)

     C     WRKSCY        IFEQ      BJCYCD
     C                   MOVE      'B'           AKY(7)
     C                   ELSE
     C                   MOVE      'F'           AKY(7)
     C                   ENDIF

     C                   EVAL      WINAMT = L2_LKEAMT
     C                   EXSR      SRCvtAmt
     C                   MOVEA     'D'           AKP(10)                                    MD051242
     C                   MOVEA     AKP           KeyStr                                     MD051242
     C                   EXSR      CheckPDCL                                                MD051242
     C                   IF        NOT(PDCL)                                                MD051242
     C                   EVAL      L2_LKEAMT = L2_LKOTHA                                    MD051242
     C                   ELSE                                                               MD051242
     C                   EVAL      L2_LKEAMT = WOUTAMT
     C                   ENDIF                                                              MD051242

     C                   MOVE      WRKSCY        L2_LKECCY
     C                   MOVEA     AKY           L2_LKAKEY
     C                   WRITE     LKEY2DPF
     C                   EXSR      SRHASH                                                   MD051242
                                                                                            MD051883
     C                   IF        FELOAN = *BLANKS                                         MD051883
     C                   MOVE      'R'           AKY(4)                                     MD051883
     C                   ELSE                                                               MD051883
     C                   MOVE      'R'           AKY(3)                                     MD051883
     C                   ENDIF                                                              MD051883
     C                   MOVE      ' '           AKY(7)                                     MD051883
     C                   MOVE      'J'           AKY(10)                                    MD051883
     C                   MOVEA     AKY           L2_LKAKEY                                  MD051883
     C                   WRITE     LKEY2DPF                                                 MD051883
     C                   EXSR      SRHASH                                                   MD051883

     C                   MOVEA     L2_LKAKEY     AKY
     C                   IF        FELOAN = *BLANKS                                         MD051883
     C                   MOVE      SAV4          AKY(4)                                     MD051883
     C                   MOVE      SAV5          AKY(5)                                     MD051883
     C                   ELSE                                                               MD051883
     C                   MOVE      SAV3          AKY(3)                                     MD051883
     C                   MOVE      SAV6          AKY(6)                                     MD051883
     C                   ENDIF                                                              MD051883
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      BJCYCD        WCCY1
     C     SDCURR        PARM                    DSSDY

      ** Save necessary details

     C                   EVAL      WNBDP1 = A6NBDP

     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      FEFCCY        WCCY1
     C     SDCURR        PARM                    DSSDY
                                                                                            MD054245
     C                   EVAL      WNBDP2 = A6NBDP                                          MD054245

     C*****WRKFCY        IFEQ      BJCYCD                                                   MD051242
     C     FEFCCY        IFEQ      BJCYCD                                                   MD051242
     C                   Z-ADD     L2_LKEAMT     BSAMT
     C                   ELSE

     C                   CALL      'ZCONVZ1'
     C                   PARM      L2_LKEAMT     WINAMT
     C                   PARM      A6SPRT        WRATE
     C                   PARM      A6MDIN        WMDIN
     C                   PARM      FEFCCY        WCCY1
     C                   PARM      BJCYCD        WCCY2
     C**********         PARM      A6NBDP        WNBDP1                                     MD054245
     C**********         PARM      WNBDP1        WNBDP2                                     MD054245
     C                   PARM                    WNBDP2                                     MD054245
     C                   PARM                    WNBDP1                                     MD054245
     C                   PARM                    WOUTAMT

     C                   EVAL      BSAMT = WOUTAMT
     C                   ENDIF
      *
      ** Format xxSyycccbP key for Base Currency Equivalent of Spot Trade
      ** a/c in purchase currency
      *
     C                   MOVE      'P'           AKY(10)
     C                   IF        FELOAN > *BLANKS                                         MD051242
     C                   MOVEA     WRKPCY        AKY(6)                                     MD051242
     C                   MOVEA     ' '           AKY(9)                                     MD051242
     C                   ELSE                                                               MD051242
     C                   MOVEA     WRKPCY        AKY(5)
     C                   MOVEA     '  '          AKY(8)                                     MD051242
     C                   ENDIF                                                              MD051242
     C                   MOVE      BJCYCD        L2_LKECCY
     C                   Z-ADD     BSAMT         L2_LKEAMT
     C                   MOVEA     AKY           L2_LKAKEY
     C                   WRITE     LKEY2DPF
     C                   EXSR      SRHASH                                                   MD051242

      ** Format xxsyybcccS key for Base Currency Equivalent of Spot Trade
      ** account in sale currency

     C                   MOVEA     L2_LKAKEY     AKY
     C                   MOVE      'S'           AKY(10)
     C                   IF        FELOAN > *BLANKS                                         MD051242
     C                   MOVEA     WRKSCY        AKY(6)                                     MD051242
     C                   MOVEA     ' '           AKY(9)                                     MD051242
     C                   ELSE                                                               MD051242
     C                   MOVEA     WRKSCY        AKY(5)
     C                   MOVEA     '  '          AKY(8)                                     MD051242
     C                   ENDIF                                                              MD051242
     C                   MOVEA     AKY           L2_LKAKEY
     C                   WRITE     LKEY2DPF
     C                   EXSR      SRHASH                                                   MD051242
     C**********         ADD       4             L2NORE                            MD051242 MD051883
     C                   ADD       5             L2NORE                                     MD051883

     C                   ENDSR

      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SETTLE3 - Subroutine to produce four new keys required for   *
      *           settling in a different currency                    *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls     : AKYOUT                                           *
      *                                                               *
      *****************************************************************

     C     SETTLE3       BEGSR

     C                   Z-ADD     0             WACAMT                                     MD051242
     C                   EVAL      WFILE = 'LEPK3DPD'                                       MD051242
     C                   MOVEA     L3_LKAKEY     AKP                                        MD051242

     C     KFEE          CHAIN     LEFEEDLU
     C                   IF        NOT%FOUND
     C     *LOCK         IN        LDA
     C                   MOVE      L3_LKCNU2     wFcnu2

     C                   IF        L3_LKLOAN <> *BLANKS
     C                   MOVE      L3_LKLOAN     wFlnno
     C                   ELSE
     C                   MOVE      L3_LKFACL     wFlnno
     C                   ENDIF
     C                   MOVE      L3_LKFACL     wFlnno

     C                   MOVE      L3_LKFSE2     wFefseq
     C                   MOVE      L3_LKFCOD     wFefcod
     C                   MOVEL     Wfeekey       DBKEY
     C                   MOVEL     'LEFEED  '    Dbfile
     C                   Z-ADD     006           Dbase
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   MOVEA     L3_LKAKEY     AKY

     C**********         MOVE      'S'           AKY(4)                                     MD051242
     C                   IF        FELOAN > *BLANKS                                         MD051242
     C                   MOVE      'S'           AKY(3)                                     MD051242
     C                   MOVEA     ' '           AKY(6)                                     MD051242
     C                   MOVE      AKY(3)        SAV3                                       MD051883
     C                   MOVE      AKY(6)        SAV6                                       MD051883
     C                   ELSE                                                               MD051242
     C                   MOVE      'S'           AKY(4)                                     MD051242
     C                   MOVE      ' '           AKY(5)
     C                   MOVE      AKY(4)        SAV4                                       MD051883
     C                   MOVE      AKY(5)        SAV5                                       MD051883
     C                   ENDIF                                                              MD051242

     C                   IF        FEPYON = 'S'
     C                   MOVE      'S'           AKY(6)
     C                   MOVE      AKY(6)        SAV6                                       MD051883
     C                   ENDIF

     C                   IF        PTFI <> ' '
     C                   MOVE      FEPSCY        WRKCCY
     C                   Z-ADD     FEPEXR        WRKEXR
     C                   MOVE      FEPEXI        WRKEXI
     C                   ELSE
     C                   MOVE      FESCCY        WRKCCY
     C                   Z-ADD     FEREXR        WRKEXR
     C                   MOVE      FEREXI        WRKEXI
     C                   ENDIF
      *                                                                                     MD051242
     C                   IF        WRKCCY = *BLANKS                                         MD051242
     C                   LEAVESR                                                            MD051242
     C                   ENDIF                                                              MD051242
                                                                                            MD051883
     C                   IF        FELOAN = *BLANKS                                         MD051883
     C                   MOVE      'R'           AKY(4)                                     MD051883
     C                   ELSE                                                               MD051883
     C                   MOVE      'R'           AKY(3)                                     MD051883
     C                   ENDIF                                                              MD051883
     C                   MOVE      'V'           AKY(10)                                    MD051883
     C                   MOVEA     AKY           L3_LKAKEY                                  MD051883
     C                   UPDATE    LKEY3DPF                                                 MD051883
     C                   IF        FELOAN = *BLANKS                                         MD051883
     C                   MOVE      SAV4          AKY(4)                                     MD051883
     C                   MOVE      SAV5          AKY(5)                                     MD051883
     C                   ELSE                                                               MD051883
     C                   MOVE      SAV3          AKY(3)                                     MD051883
     C                   MOVE      SAV6          AKY(6)                                     MD051883
     C                   ENDIF                                                              MD051883
                                                                                            MD051883

     C     PTFI          IFEQ      'P'
     C     PTFI          OREQ      'S'
     C     PTFI          OREQ      'R'
     C                   MOVE      FEFCCY        WKPURC
     C                   MOVE      WRKCCY        WKSALC
     C                   ELSE
     C                   MOVE      WRKCCY        WKPURC
     C                   MOVE      FEFCCY        WKSALC
     C                   ENDIF

     C                   MOVE      'B'           AKY(10)

      ** Format xxSyybbbFB or xxSyybbbBB key for amount in purchase ccy

     C     WKPURC        IFEQ      BJCYCD
     C                   MOVE      'B'           AKY(7)
     C                   ELSE
     C                   MOVE      'F'           AKY(7)
     C                   ENDIF

     C                   MOVE      WKPURC        L3_LKECCY
     C                   MOVEA     AKY           L3_LKAKEY

     C                   WRITE     LKEY3DPF
     C                   EXSR      SRHASH                                                   MD051242

     C                   MOVEA     L3_LKAKEY     AKY
     C                   MOVE      'C'           AKY(10)

     C     WKSALC        IFEQ      BJCYCD
     C                   MOVE      'B'           AKY(7)
     C                   ELSE
     C                   MOVE      'F'           AKY(7)
     C                   ENDIF

     C                   EVAL      WINAMT = L3_LKEAMT
     C                   EXSR      SRCvtAmt
     C                   MOVEA     'D'           AKP(10)                                    MD051242
     C                   MOVEA     AKP           KeyStr                                     MD051242
     C                   EXSR      CheckPDCL                                                MD051242
     C                   IF        NOT(PDCL)                                                MD051242
     C                   EVAL      L3_LKEAMT = L3_LKOTHA                                    MD051242
     C                   ELSE                                                               MD051242
     C                   EVAL      L3_LKEAMT = WOUTAMT
     C                   ENDIF                                                              MD051242

     C                   MOVE      WKSALC        L3_LKECCY
     C                   MOVEA     AKY           L3_LKAKEY
     C                   WRITE     LKEY3DPF
     C                   EXSR      SRHASH                                                   MD051242
                                                                                            MD051883
     C                   IF        FELOAN = *BLANKS                                         MD051883
     C                   MOVE      'R'           AKY(4)                                     MD051883
     C                   ELSE                                                               MD051883
     C                   MOVE      'R'           AKY(3)                                     MD051883
     C                   ENDIF                                                              MD051883
     C                   MOVE      ' '           AKY(7)                                     MD051883
     C                   MOVE      'J'           AKY(10)                                    MD051883
     C                   MOVEA     AKY           L3_LKAKEY                                  MD051883
     C                   WRITE     LKEY3DPF                                                 MD051883
     C                   EXSR      SRHASH                                                   MD051883

     C                   MOVEA     L3_LKAKEY     AKY
     C                   IF        FELOAN = *BLANKS                                         MD051883
     C                   MOVE      SAV4          AKY(4)                                     MD051883
     C                   MOVE      SAV5          AKY(5)                                     MD051883
     C                   ELSE                                                               MD051883
     C                   MOVE      SAV3          AKY(3)                                     MD051883
     C                   MOVE      SAV6          AKY(6)                                     MD051883
     C                   ENDIF                                                              MD051883
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      BJCYCD        WCCY1
     C     SDCURR        PARM                    DSSDY

      ** Save necessary details

     C                   EVAL      WNBDP1 = A6NBDP

     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      FEFCCY        WCCY1
     C     SDCURR        PARM                    DSSDY

     C                   EVAL      WNBDP2 = A6NBDP                                          MD054245
                                                                                            MD054245
     C     FEFCCY        IFEQ      BJCYCD
     C                   Z-ADD     L3_LKEAMT     BSAMT            13 0
     C                   ELSE

     C                   CALL      'ZCONVZ1'
     C                   PARM      L3_LKEAMT     WINAMT
     C                   PARM      A6SPRT        WRATE
     C                   PARM      A6MDIN        WMDIN
     C                   PARM      FEFCCY        WCCY1
     C                   PARM      BJCYCD        WCCY2
     C**********         PARM      A6NBDP        WNBDP1                                     MD054245
     C**********         PARM      WNBDP1        WNBDP2                                     MD054245
     C                   PARM                    WNBDP2                                     MD054245
     C                   PARM                    WNBDP1                                     MD054245
     C                   PARM                    WOUTAMT

     C                   EVAL      BSAMT = WOUTAMT
     C                   ENDIF
      *
      ** Format xxSyycccbP key for Base Currency Equivalent of Spot Trade
      ** a/c in purchase currency
      *
     C                   MOVE      'P'           AKY(10)
     C                   IF        FELOAN > *BLANKS                                         MD051242
     C                   MOVEA     WKPURC        AKY(6)                                     MD051242
     C                   MOVEA     ' '           AKY(9)                                     MD051242
     C                   ELSE                                                               MD051242
     C                   MOVEA     WKPURC        AKY(5)
     C                   MOVEA     '  '          AKY(8)
     C                   ENDIF                                                              MD051242
     C                   MOVE      BJCYCD        L3_LKECCY
     C                   Z-ADD     BSAMT         L3_LKEAMT
     C                   MOVEA     AKY           L3_LKAKEY
     C                   WRITE     LKEY3DPF
     C                   EXSR      SRHASH                                                   MD051242
      *
      ** Format xxsyybcccS key for Base Currency Equivalent of Spot Trade
      ** account in sale currency
      *
     C                   MOVEA     L3_LKAKEY     AKY
     C                   MOVE      'S'           AKY(10)
     C                   IF        FELOAN > *BLANKS                                         MD051242
     C                   MOVEA     WKSALC        AKY(6)                                     MD051242
     C                   MOVEA     ' '           AKY(9)                                     MD051242
     C                   ELSE                                                               MD051242
     C                   MOVEA     WKSALC        AKY(5)
     C                   MOVEA     '  '          AKY(8)
     C                   ENDIF                                                              MD051242
     C                   MOVEA     AKY           L3_LKAKEY
     C                   WRITE     LKEY3DPF
     C                   EXSR      SRHASH                                                   MD051242
     C**********         ADD       4             L3NORE                            MD051242 MD051883
     C                   ADD       5             L3NORE                                     MD051883

     C                   ENDSR

      *****************************************************************
      *                                                               *                     MD048557
      *  STRAIL - Update trailer record on LEPK1ZZ                    *                     MD048557
      *                                                               *                     MD048557
      *  Called from MAIN Processing                                  *                     MD048557
      *                                                               *                     MD048557
      *****************************************************************                     MD048557
     C     STRAIL        BEGSR                                                              MD048557
      *                                                                                     MD048557
     C     1             SETLL     LEPK1ZZ                                                  MD048557
     C                   READ      LEPK1ZZ                                88                MD048557
     C                   Z-ADD     L1NORE        NORE                                       MD048557
     C                   Z-ADD     L1VLRF        VLRF                                       MD048557
     C                   Z-ADD     L1VLRL        VLRL                                       MD048557
     C     *IN88         IFEQ      *ON                                                      MD048557
     C                   MOVE      'T'           RECI                                       MD048557
     C                   ADD       2             NORE                                       MD048557
     C                   WRITE     LKEYF1ZF                                                 MD048557
     C                   ELSE                                                               MD048557
     C     NORE          IFEQ      0                                                        MD048557
     C                   ADD       2             NORE                                       MD048557
     C                   MOVE      'T'           RECI                                       MD048557
     C                   END                                                                MD048557
     C                   UPDATE    LKEYF1ZF                                                 MD048557
     C                   ENDIF                                                              MD048557
      *                                                                                     MD048557
     C     1             SETLL     LEPK2ZZ                                                  MD051242
     C                   READ      LEPK2ZZ                                88                MD051242
     C                   Z-ADD     L2NORE        L2_LKNORE                                  MD051242
     C                   Z-ADD     L2VLRF        L2_LKVLRF                                  MD051242
     C                   Z-ADD     L2VLRL        L2_LKVLRL                                  MD051242
     C     *IN88         IFEQ      *ON                                                      MD051242
     C                   MOVE      'T'           L2_LKRECI                                  MD051242
     C                   ADD       2             L2_LKNORE                                  MD051242
     C                   WRITE     LKEYF2ZF                                                 MD051242
     C                   ELSE                                                               MD051242
     C     L2_LKNORE     IFEQ      0                                                        MD051242
     C                   ADD       2             L2_LKNORE                                  MD051242
     C                   MOVE      'T'           L2_LKRECI                                  MD051242
     C                   END                                                                MD051242
     C                   UPDATE    LKEYF2ZF                                                 MD051242
     C                   ENDIF                                                              MD051242
      *                                                                                     MD051242
     C     1             SETLL     LEPK3ZZ                                                  MD051242
     C                   READ      LEPK3ZZ                                88                MD051242
     C                   Z-ADD     L3NORE        L3_LKNORE                                  MD051242
     C                   Z-ADD     L3VLRF        L3_LKVLRF                                  MD051242
     C                   Z-ADD     L3VLRL        L3_LKVLRL                                  MD051242
     C     *IN88         IFEQ      *ON                                                      MD051242
     C                   MOVE      'T'           L3_LKRECI                                  MD051242
     C                   ADD       2             L3_LKNORE                                  MD051242
     C                   WRITE     LKEYF3ZF                                                 MD051242
     C                   ELSE                                                               MD051242
     C     L3_LKNORE     IFEQ      0                                                        MD051242
     C                   ADD       2             L3_LKNORE                                  MD051242
     C                   MOVE      'T'           L3_LKRECI                                  MD051242
     C                   END                                                                MD051242
     C                   UPDATE    LKEYF3ZF                                                 MD051242
     C                   ENDIF                                                              MD051242
      *                                                                                     MD051242
     C                   ENDSR                                                              MD048557
      *                                                                                     MD048557
      *****************************************************************                     MD048557
      *                                                               *                     MD048557
      *  SRHASH - Add amounts                                         *                     MD048557
      *                                                               *                     MD048557
      *  Called from SETTLE1, SETTLE, SETTLE3                         *                     MD048557
      *                                                               *                     MD048557
      *****************************************************************                     MD048557
     C     SRHASH        BEGSR                                                              MD048557
                                                                                            MD048557
     C                   SELECT                                                             MD051242
     C                   WHEN      WFILE = 'LEPK1DPD'                                       MD051242
     C     L1_EAMT       IFGT      0                                                        MD048557
     C                   Z-ADD     L1_EAMT       WACAMT                                     MD048557
     C                   ELSE                                                               MD048557
     C                   Z-SUB     L1_EAMT       WACAMT                                     MD048557
     C                   ENDIF                                                              MD048557
                                                                                            MD048557
     C     WACAMT        DIV       1000          ZZAMT                  80                  MD048557
     C                   Z-ADD     L1VLRF        ZZTOTI                                     MD048557
     C                   Z-ADD     L1VLRL        ZZTOTD                                     MD048557
     C                   EXSR      GLZADD                                                   MD048557
     C                   Z-ADD     ZZTOTI        L1VLRF                                     MD048557
     C                   Z-ADD     ZZTOTD        L1VLRL                                     MD048557
                                                                                            MD051242
     C                   WHEN      WFILE = 'LEPK2DPD'                                       MD051242
     C     L2_LKEAMT     IFGT      0                                                        MD051242
     C                   Z-ADD     L2_LKEAMT     WACAMT                                     MD051242
     C                   ELSE                                                               MD051242
     C                   Z-SUB     L2_LKEAMT     WACAMT                                     MD051242
     C                   ENDIF                                                              MD051242
                                                                                            MD051242
     C     WACAMT        DIV       1000          ZZAMT                  80                  MD051242
     C                   Z-ADD     L2VLRF        ZZTOTI                                     MD051242
     C                   Z-ADD     L2VLRL        ZZTOTD                                     MD051242
     C                   EXSR      GLZADD                                                   MD051242
     C                   Z-ADD     ZZTOTI        L2VLRF                                     MD051242
     C                   Z-ADD     ZZTOTD        L2VLRL                                     MD051242
                                                                                            MD051242
     C                   WHEN      WFILE = 'LEPK3DPD'                                       MD051242
     C     L3_LKEAMT     IFGT      0                                                        MD051242
     C                   Z-ADD     L3_LKEAMT     WACAMT                                     MD051242
     C                   ELSE                                                               MD051242
     C                   Z-SUB     L3_LKEAMT     WACAMT                                     MD051242
     C                   ENDIF                                                              MD051242
                                                                                            MD051242
     C     WACAMT        DIV       1000          ZZAMT                  80                  MD051242
     C                   Z-ADD     L3VLRF        ZZTOTI                                     MD051242
     C                   Z-ADD     L3VLRL        ZZTOTD                                     MD051242
     C                   EXSR      GLZADD                                                   MD051242
     C                   Z-ADD     ZZTOTI        L3VLRF                                     MD051242
     C                   Z-ADD     ZZTOTD        L3VLRL                                     MD051242
     C                   ENDSL                                                              MD051242
                                                                                            MD048557
     C                   ENDSR                                                              MD048557
                                                                                            MD048557
      *****************************************************************                     MD048557
      /EJECT                                                                                MD048557
      *****************************************************************                     MD048557
      * GLZADD  -  Adds an amount (ZZAMT) to the total (ZZTOTI,ZZTOTD)*                     MD048557
      *                                                               *                     MD048557
      * Called by: GLZSUB                                             *                     MD048557
      *                                                               *                     MD048557
      * Calls: GLZSUM                                                 *                     MD048557
      *                                                               *                     MD048557
      *****************************************************************                     MD048557
     C     GLZADD        BEGSR                                                              MD048557
      *                                                                                     MD048557
     C     ZZAMT         IFNE      *ZERO                                                    MD048557
      *                                                                                     MD048557
      ***  Split ZZAMT into integer and decimal fields                                      MD048557
      *                                                                                     MD048557
     C                   Z-ADD     ZZAMT         ZZAMTI           15 0                      MD048557
     C                   MOVE      ZZAMT         ZZAMTD            3 0                      MD048557
      *                                                                                     MD048557
      ***  Both ZZAMTI and ZZAMTD contain a 'sign' zone now                                 MD048557
      *                                                                                     MD048557
     C                   EXSR      GLZSUM                                                   MD048557
     C                   ENDIF                                                              MD048557
      *                                                                                     MD048557
     C                   ENDSR                                                              MD048557
      *****************************************************************                     MD048557
      /EJECT                                                                                MD048557
      *****************************************************************                     MD048557
      * GLZSUM  -  Carries out the addition of the amounts            *                     MD048557
      *                                                               *                     MD048557
      * Called by: GLZADD                                             *                     MD048557
      *                                                               *                     MD048557
      * Calls: *None                                                  *                     MD048557
      *                                                               *                     MD048557
      *****************************************************************                     MD048557
     C     GLZSUM        BEGSR                                                              MD048557
      *                                                                                     MD048557
      ***  Save values of indicators to be used in the program                              MD048557
      *                                                                                     MD048557
     C                   MOVE      *IN91         WIN91             1                        MD048557
     C                   MOVE      *IN92         WIN92             1                        MD048557
     C                   MOVE      *IN93         WIN93             1                        MD048557
     C                   MOVE      *IN94         WIN94             1                        MD048557
     C                   MOVE      *IN95         WIN95             1                        MD048557
     C                   MOVE      *IN96         WIN96             1                        MD048557
     C                   SETOFF                                       919293                MD048557
     C                   SETOFF                                       949599                MD048557
      *                                                                                     MD048557
      ***  Determine sign of ZZAMTI and ZZAMTD, 92 if neg                                   MD048557
      *                                                                                     MD048557
     C     ZZAMTI        COMP      0                                    9293                MD048557
     C   93ZZAMTD        COMP      0                                    9293                MD048557
     C   93              GOTO      ZZSEND                                                   MD048557
      *                                                                                     MD048557
      ***  Determine sign of ZZTOTI and ZZTOTD, 91 if neg                                   MD048557
      *                                                                                     MD048557
     C     ZZTOTI        COMP      0                                    9193                MD048557
     C   93ZZTOTD        COMP      0                                    9193                MD048557
      *                                                                                     MD048557
      ***  If ZZTOTAL is zero, return ZZAMOUNT                                              MD048557
      *                                                                                     MD048557
     C   93              Z-ADD     ZZAMTI        ZZTOTI           15 0                      MD048557
     C   93              Z-ADD     ZZAMTD        ZZTOTD            3 0                      MD048557
     C   93              GOTO      ZZSEND                                                   MD048557
      *                                                                                     MD048557
      ***  If signs differ, bypass overflow checks                                          MD048557
      *                                                                                     MD048557
     C   91                                                                                 MD048557
     CANN92                                                                                 MD048557
     CORN91                                                                                 MD048557
     CAN 92              GOTO      ZZOFPS                                                   MD048557
     C*                                                                                     MD048557
     C     ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0                      MD048557
     C     ZZWK2         COMP      999                                93                    MD048557
     C  N93ZZWK2         COMP      -999                                 93                  MD048557
     C*                                                                                     MD048557
     C   93                                                                                 MD048557
     CANN92ZZAMTI        ADD       1             ZZWK3            15 0                      MD048557
     C   93                                                                                 MD048557
     CAN 92ZZAMTI        SUB       1             ZZWK3                                      MD048557
     C   93ZZTOTI        ADD       ZZWK3         ZZWK3                                      MD048557
     C  N93ZZTOTI        ADD       ZZAMTI        ZZWK3                                      MD048557
      *                                                                                     MD048557
      ***  If the modulus of ZZWK3 is lt mod. ZZTOTI then O/F has occured                   MD048557
      *                                                                                     MD048557
     C  N92ZZWK3         COMP      ZZTOTI                               99                  MD048557
     C   92ZZWK3         COMP      ZZTOTI                             99                    MD048557
     C  N99              Z-ADD     ZZWK2         ZZTOTD                                     MD048557
     C  N99              Z-ADD     ZZWK3         ZZTOTI                                     MD048557
      *                                                                                     MD048557
      ***  If O/F zeroise ZZAMT, Ind '99' set and ZZTOT fields left intact                  MD048557
      *                                                                                     MD048557
     C   99              Z-ADD     0             ZZAMT            15 3                      MD048557
     C                   GOTO      ZZSEND                                                   MD048557
      *                                                                                     MD048557
      ***  The 'signs' are different                                                        MD048557
      *                                                                                     MD048557
     C     ZZOFPS        TAG                                                                MD048557
      *                                                                                     MD048557
      ***  If ZZAMT was negative, make it pos. to como with ZZTOT                           MD048557
      *                                                                                     MD048557
     C   92              Z-SUB     ZZAMTI        ZZAMTI           15 0                      MD048557
     C   92              Z-SUB     ZZAMTD        ZZAMTD            3 0                      MD048557
      *                                                                                     MD048557
      ***  If ZZTOT was negative, make it pos. to comp with ZZAMT.                          MD048557
      *                                                                                     MD048557
     C   91              Z-SUB     ZZTOTI        ZZTOTI                                     MD048557
     C   91              Z-SUB     ZZTOTD        ZZTOTD                                     MD048557
      *                                                                                     MD048557
      ***  Both ZZAMT and ZZTOT are now positive                                            MD048557
      *                                                                                     MD048557
     C     ZZTOTI        COMP      ZZAMTI                             93  95                MD048557
     C   95ZZTOTD        COMP      ZZAMTD                             93  95                MD048557
      *                                                                                     MD048557
      ***  If ZZTOT eq. ZZAMT return ZERO.                                                  MD048557
      *                                                                                     MD048557
     C   95              Z-ADD     0             ZZTOTI                                     MD048557
     C   95              Z-ADD     0             ZZTOTD                                     MD048557
     C   95              GOTO      ZZSEND                                                   MD048557
      *                                                                                     MD048557
      ***  If ZZTOT gt. ZZAMT.                                                              MD048557
      *                                                                                     MD048557
     C   93ZZAMTD        COMP      ZZTOTD                             94                    MD048557
     C   93                                                                                 MD048557
     CAN 94ZZTOTI        SUB       1             ZZTOTI                                     MD048557
     C   93                                                                                 MD048557
     CAN 94ZZTOTD        ADD       1000          ZZWK2                                      MD048557
     C   93ZZTOTI        SUB       ZZAMTI        ZZTOTI                                     MD048557
     C   93                                                                                 MD048557
     CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD                                     MD048557
     C   93                                                                                 MD048557
     CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD                                     MD048557
      *                                                                                     MD048557
      ***  If ZZAMT gt. ZZTOT.                                                              MD048557
      *                                                                                     MD048557
     C  N93ZZTOTD        COMP      ZZAMTD                             94                    MD048557
     C  N93                                                                                 MD048557
     CAN 94ZZAMTI        SUB       1             ZZWK3            15 0                      MD048557
     C  N93                                                                                 MD048557
     CAN 94ZZAMTD        ADD       1000          ZZWK2                                      MD048557
     C  N93                                                                                 MD048557
     CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI                                     MD048557
     C  N93                                                                                 MD048557
     CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI                                     MD048557
     C  N93                                                                                 MD048557
     CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD                                     MD048557
     C  N93                                                                                 MD048557
     CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD                                     MD048557
      *                                                                                     MD048557
      ***  Reverse sign of ZZTOT if larger I/P fields were negative                         MD048557
      *                                                                                     MD048557
     C                   SETOFF                                       94                    MD048557
     C   93                                                                                 MD048557
     CAN 91                                                                                 MD048557
     CORN93                                                                                 MD048557
     CAN 92              SETON                                        94                    MD048557
     C   94              Z-SUB     ZZTOTI        ZZTOTI                                     MD048557
     C   94              Z-SUB     ZZTOTD        ZZTOTD                                     MD048557
      *                                                                                     MD048557
      ***  Restore sign of ZZAMTI & ZZAMTD if it was reversed                               MD048557
      *                                                                                     MD048557
     C   92              Z-SUB     ZZAMTI        ZZAMTI                                     MD048557
     C   92              Z-SUB     ZZAMTD        ZZAMTD                                     MD048557
     C     ZZSEND        TAG                                                                MD048557
      *                                                                                     MD048557
      ***  If ZZTOTD is zero, and ZZTOTI is neg. set up ZZNEGD.                             MD048557
      *                                                                                     MD048557
     C                   SETOFF                                       96                    MD048557
     C     ZZTOTD        COMP      0                                      91                MD048557
     C   91ZZTOTI        COMP      0                                    96                  MD048557
     C   96              MOVE      '.000-'       ZZNEGD            5                        MD048557
      *                                                                                     MD048557
      ***  Restore previous indicator values                                                MD048557
      *                                                                                     MD048557
     C                   MOVE      WIN91         *IN91                                      MD048557
     C                   MOVE      WIN92         *IN92                                      MD048557
     C                   MOVE      WIN93         *IN93                                      MD048557
     C                   MOVE      WIN94         *IN94                                      MD048557
     C                   MOVE      WIN95         *IN95                                      MD048557
     C                   MOVE      WIN96         *IN96                                      MD048557
      *                                                                                     MD048557
     C                   ENDSR                                                              MD048557
      *****************************************************************                     MD051242
     C/EJECT                                                                                MD051242
      *****************************************************************                     MD051242
      *    CheckPDCL                                                  *                     MD051242
      *****************************************************************                     MD051242
      /free
       Begsr CheckPDCL;
             Select;
               When wFile = 'LEPK1DPD';
                    SQLStr = 'select count(*)' +
                    ' from ' +  wFile + 'where AKEY = ' +
                             QUO + KeyStr + QUO + ' and ' +
                             'LNNO =  ' + QUO + L1_LNNO + QUO + ' and ' +
                             'CNUM = ' + QUO + L1_CNUM + QUO + ' and ' +
                             'BRCA = ' + QUO + L1_BRCA + QUO + 'and ' +
                             'ACSQ = ' + %CHAR(L1_ACSQ) + ' and ' +
                             'OSAC = ' + QUO + %TRIM(L1_OSAC) + QUO;

               When wFile = 'LEPK2DPD';
                    SQLStr = 'select count(*)' +
                             ' from ' +  wFile + 'where LKAKEY = ' +
                             QUO + KeyStr + QUO + ' and ' +
                             'LKLNNO =  ' + QUO + L2_LKLNNO + QUO + ' and ' +
                             'LKCNUM = ' + QUO + L2_LKCNUM + QUO + ' and ' +
                             'LKBRCD = ' + QUO + L2_LKBRCD + QUO +  ' and ' +
                             'LKACSQ = ' + %CHAR(L2_LKACSQ) + ' and ' +
                             'LKOSAC = ' + QUO + %TRIM(L2_LKOSAC) + QUO;
               Other;
                    SQLStr = 'select count(*)' +
                             ' from ' +  wFile + 'where LKAKEY = ' +
                             QUO + KeyStr + QUO + ' and ' +
                             'LKLNNO =  ' + QUO + L3_LKLNNO + QUO + ' and ' +
                             'LKCNUM = ' + QUO + L3_LKCNUM + QUO + ' and ' +
                             'LKBRCD = ' + QUO + L3_LKBRCD + QUO +  ' and ' +
                             'LKACSQ = ' + %CHAR(L3_LKACSQ) + ' and ' +
                             'LKOSAC = ' + QUO + %TRIM( L3_LKOSAC) + QUO;
             EndSl;

             Exec Sql Prepare P1 from :SQLStr;
             Exec Sql Declare P1 cursor for P1;
             Exec Sql Open P1;
             Exec Sql Fetch P1 into :Counter;

            If Sqlcod <> 0 and SqlCod <> 100;
               DbFile = %Trim(wFile);
               Dbase  = 1;
               DbKey  = %Trim(KeyStr);
               DbPgm  = 'LE000823';
               Exsr *Pssr;
            Endif;
            If Counter = 0;
               PDCL = False;
            Else;
               PDCL = True;
            Endif;
             Exec Sql Close P1;
       Endsr;
      /end-free

      *****************************************************************
     C/EJECT
      *****************************************************************
      *    *INZSR - Initialization Subroutine                         *
      *****************************************************************
      *
     C     *INZSR        BEGSR

     C                   EVAL      dbPgm       = PSProcPgm
     C     *LIKE         DEFINE    VLRF          L1VLRF                                     MD048557
     C     *LIKE         DEFINE    VLRL          L1VLRL                                     MD048557
     C     *LIKE         DEFINE    NORE          L1NORE                                     MD048557
     C     *LIKE         DEFINE    L2_LKVLRF     L2VLRF                                     MD051242
     C     *LIKE         DEFINE    L2_LKVLRL     L2VLRL                                     MD051242
     C     *LIKE         DEFINE    L2_LKNORE     L2NORE                                     MD051242
     C     *LIKE         DEFINE    L3_LKVLRF     L3VLRF                                     MD051242
     C     *LIKE         DEFINE    L3_LKVLRL     L3VLRL                                     MD051242
     C     *LIKE         DEFINE    L3_LKNORE     L3NORE                                     MD051242

     C     KAllF         KLIST
     C                   KFLD                    L2_LKCNU2
     C                   KFLD                    L2_LKLOAN
     C                   KFLD                    L2_LKFACL
     C                   KFLD                    L2_LKFSE2
     C                   KFLD                    L2_LKOSAC

     C     KSTAL         KLIST
     C                   KFLD                    LNRF
     C                   KFLD                    KVDAT                                      MD049363
     C                   KFLD                    KLASN                                      MD049363
     C                   KFLD                    WSET

     C     KLOANK        KLIST
     C                   KFLD                    KRECI
     C                   KFLD                    KLOAN


     C     Kfee2         KLIST
     C                   KFLD                    L2_lkfbrc
     C                   KFLD                    L2_lkcnu2
     C                   KFLD                    L2_lkfacl
     C                   KFLD                    L2_lkloan
     C                   KFLD                    L2_lkfse2

     C     Kfee          KLIST
     C                   KFLD                    L3_lkfbrc
     C                   KFLD                    L3_lkcnu2
     C                   KFLD                    L3_lkfacl
     C                   KFLD                    L3_lkloan
     C                   KFLD                    L3_lkfse2

     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Determine if Freq Fee & Allocation, Sett Ccy, Roll Utilisation

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE031'      @SARD

     C                   IF        @RTCD       = *BLANKS
     C                   EVAL      CLE031      = 'Y'
     C                   ENDIF

      ** Determine if Freq Fee & Allocation, Sett Ccy, Roll Utilisation

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE034'      @SARD

     C                   IF        @RTCD       = *BLANKS
     C                   EVAL      CLE034      = 'Y'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  *PSSR - Subroutine to handle abnormal error conditions       *
      *****************************************************************
     C     *PSSR         BEGSR

     C**********         ROLBK                                                              MD048558
     C                   IF        runBefore <> 'Y'
     C                   EVAL      runBefore   = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      pReturnCode = '*ERROR*'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      ********************************************************************
     C/COPY ZSRSRC,ZSEDITZ3LE
