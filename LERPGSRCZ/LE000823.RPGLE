     H DEBUG
     H Copyright('(c) Misys International Banking Systems Ltd. 2017')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
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
      *  (c) Misys International Banking Systems Ltd. 2017            *
      *                                                               *
      *  Last Amend No. MD048558           Date 21Nov17               *
      *  Prev Amend No. MD046080  *CREATE  Date 17Sep17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD048558 - Failing COB Component - LEC000823 00002           *
      *  MD046080 - Gap between CLE031 (Settlement to different       *
      *             currency) and CLE134 (PDCL processing)            *
      *                                                               *
      *****************************************************************
 
      ** Midas LE Past Due Call Loans Account Keys
     FLEPK1L0   UF A E           K DISK
     F                                     PREFIX(L1_)
 
      ** Midas LE Fee Past Due Call Loans Account Keys
     FLEPK2L0   UF A E           K DISK
     F                                     RENAME(LKEYFEDF:LKEY2DPF)
     F                                     PREFIX(L2_)
 
      ** Midas LE Fee Past Due Call Loans Account Keys
     FLEPK3L0   UF A E           K DISK
     F                                     RENAME(LKEYFEDF:LKEY3DPF)
     F                                     PREFIX(L3_)
 
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
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      ** M A I N  P R O C E S S I N G                                 *
      *****************************************************************
 
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
 
     C                   EXSR      SETTLE3
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
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
     C                   IF        PTYP <> 66
     C                             AND PTYP <> 67
     C                             AND PTYP <> 69
     C                             AND PTYP <> 72
     C                   EVAL      WCCY1 = PSCY
     C                   EVAL      WRATE = PEXR
     C                   EVAL      WIND1 = PEXI
     C                   ELSE
     C                   EVAL      WCCY1 = SCCY
     C                   EVAL      WRATE = REXR
     C                   EVAL      WIND1 = REXI
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
      ** If CLE034 switched ON, get settlement details fro LESTALPD
     C                   IF        CLE034 = 'Y'
     C                             AND FESTAL = 'Y'
     C     KAllF         CHAIN     LESTALLF
     C                   IF        %FOUND(LESTALLF)
     C                   EVAL      WCCY1 = F_RSCY
     C                   EVAL      WRATE = F_REXR
     C                   EVAL      WREXI = F_REXI
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
     C                   EVAL      WREXI = FEREXI
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
 
     C                   MOVEA     L1_AKEY       AKY
 
     C                   MOVE      'S'           AKY(3)
     C                   MOVEA     '    '        AKY(6)
      *
     C     L1_SECATC     IFEQ      'OLINT'
     C                   MOVE      'I'           AKY(8)
     C                   ENDIF
 
      ** Format xxSyybbbFB or xxSyybbbBB key for amount in purchase ccy
 
     C     L1_ECCY       IFEQ      BJCYCD
     C                   MOVEA     'BB'          AKY(9)
     C                   ELSE
     C                   MOVEA     'FB'          AKY(9)
     C                   ENDIF
 
     C                   MOVEA     AKY           L1_AKEY
 
     C                   WRITE     LKEY1DPF
 
     C                   MOVEA     L1_AKEY       AKY
     C                   EVAL      KRECI = 'D'
     C                   EVAL      KLOAN = L1_LNNO
     C     KLOANK        CHAIN     CLOANL4
     C                   IF        NOT %FOUND
     C******LOCK         IN        LDA                                                      MD048558
     C**********         MOVE      L1_LNNO       Dbkey                                      MD048558
     C**********         MOVEL     'CLOANL4'     Dbfile                                     MD048558
     C**********         Z-ADD     004           Dbase                                      MD048558
     C**********         OUT       LDA                                                      MD048558
     C**********         EXSR      *PSSR                                                    MD048558
     C                   EVAL      KRECI = 'M'                                              MD048558
                                                                                            MD048558
     C     KLOANK        CHAIN     CLOANL4                                                  MD048558
     C                   ENDIF
 
     C                   EVAL      WINAMT = L1_EAMT
     C                   EXSR      SRCvtAmt
     C                   EVAL      L1_EAMT = WOUTAMT
 
      ** Format xxSyybbbFC or xxSyybbbBC key for amount in purchase ccy
 
     C     WCCY1         IFEQ      BJCYCD
     C                   MOVEA     'BC'          AKY(9)
     C                   ELSE
     C                   MOVEA     'FC'          AKY(9)
     C                   ENDIF
 
     C                   EVAL      L1_ECCY = CCY
     C                   MOVEA     AKY           L1_AKEY
     C                   WRITE     LKEY1DPF
 
     C                   MOVEA     L1_AKEY       AKY
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      L1_ECCY       WCCY1
     C     SDCURR        PARM                    DSSDY
 
     C     L1_ECCY       IFEQ      BJCYCD
     C                   Z-ADD     L1_EAMT       BSAMT            13 0
     C                   ELSE
     C     A6MDIN        IFEQ      'M'
     C     L1_EAMT       MULT      A6SPRT        BSAMT
     C                   ELSE
     C     L1_EAMT       DIV       A6SPRT        BSAMT
     C                   ENDIF
     C                   ENDIF
      *
      ** Format xxSyycccbP key for Base Currency Equivalent of Spot Trade
      ** a/c in purchase currency
      *
     C                   MOVEA     ' P'          AKY(9)
     C                   MOVEA     PSCY          AKY(6)
     C                   MOVE      BJCYCD        L1_ECCY
     C                   Z-ADD     BSAMT         L1_EAMT
     C                   MOVEA     AKY           L1_AKEY
     C                   WRITE     LKEY1DPF
 
      ** Format xxsyybcccS key for Base Currency Equivalent of Spot Trade
      ** account in sale currency
 
     C                   MOVEA     L1_AKEY       AKY
     C                   MOVEA     ' S'          AKY(9)
     C                   MOVEA     SCCY          AKY(6)
     C                   MOVEA     AKY           L1_AKEY
     C                   WRITE     LKEY1DPF
 
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
 
     C                   MOVE      'S'           AKY(4)
     C                   MOVEA     '  '          AKY(5)
 
     C                   IF        PTFI <> ' '
     C                   MOVE      FEPSCY        WRKCCY
     C                   Z-ADD     FEPEXR        WRKEXR
     C                   MOVE      FEPEXI        WRKEXI
     C                   ELSE
     C                   MOVE      FESCCY        WRKCCY
     C                   Z-ADD     FEREXR        WRKEXR
     C                   MOVE      FEREXI        WRKEXI
     C                   ENDIF
 
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
 
     C                   MOVEA     L2_LKAKEY     AKY
     C                   MOVE      'C'           AKY(10)
 
     C     WRKSCY        IFEQ      BJCYCD
     C                   MOVE      'B'           AKY(7)
     C                   ELSE
     C                   MOVE      'F'           AKY(7)
     C                   ENDIF
 
     C                   EVAL      WINAMT = L2_LKEAMT
     C                   EXSR      SRCvtAmt
     C                   EVAL      L2_LKEAMT = WOUTAMT
 
     C                   MOVE      WRKSCY        L2_LKECCY
     C                   MOVEA     AKY           L2_LKAKEY
     C                   WRITE     LKEY2DPF
 
     C                   MOVEA     L2_LKAKEY     AKY
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
 
     C     WRKFCY        IFEQ      BJCYCD
     C                   Z-ADD     L2_LKEAMT     BSAMT
     C                   ELSE
 
     C                   CALL      'ZCONVZ1'
     C                   PARM      L2_LKEAMT     WINAMT
     C                   PARM      A6SPRT        WRATE
     C                   PARM      A6MDIN        WMDIN
     C                   PARM      FEFCCY        WCCY1
     C                   PARM      BJCYCD        WCCY2
     C                   PARM      A6NBDP        WNBDP1
     C                   PARM      WNBDP1        WNBDP2
     C                   PARM                    WOUTAMT
 
     C                   EVAL      BSAMT = WOUTAMT
     C                   ENDIF
      *
      ** Format xxSyycccbP key for Base Currency Equivalent of Spot Trade
      ** a/c in purchase currency
      *
     C                   MOVE      'P'           AKY(10)
     C                   MOVEA     WRKPCY        AKY(6)
     C                   MOVE      BJCYCD        L2_LKECCY
     C                   Z-ADD     BSAMT         L2_LKEAMT
     C                   MOVEA     AKY           L2_LKAKEY
     C                   WRITE     LKEY2DPF
 
      ** Format xxsyybcccS key for Base Currency Equivalent of Spot Trade
      ** account in sale currency
 
     C                   MOVEA     L2_LKAKEY     AKY
     C                   MOVE      'S'           AKY(10)
     C                   MOVEA     WRKSCY        AKY(6)
     C                   MOVEA     AKY           L2_LKAKEY
     C                   WRITE     LKEY2DPF
 
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
 
     C                   MOVE      'S'           AKY(4)
     C                   MOVE      ' '           AKY(5)
 
     C                   IF        FEPYON = 'S'
     C                   MOVE      'S'           AKY(6)
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
 
     C                   MOVEA     L3_LKAKEY     AKY
     C                   MOVE      'C'           AKY(10)
 
     C     WKSALC        IFEQ      BJCYCD
     C                   MOVE      'B'           AKY(7)
     C                   ELSE
     C                   MOVE      'F'           AKY(7)
     C                   ENDIF
 
     C                   EVAL      WINAMT = L3_LKEAMT
     C                   EXSR      SRCvtAmt
     C                   EVAL      L3_LKEAMT = WOUTAMT
 
     C                   MOVE      WKSALC        L3_LKECCY
     C                   MOVEA     AKY           L3_LKAKEY
     C                   WRITE     LKEY3DPF
 
     C                   MOVEA     L3_LKAKEY     AKY
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
 
     C     FEFCCY        IFEQ      BJCYCD
     C                   Z-ADD     L3_LKEAMT     BSAMT            13 0
     C                   ELSE
 
     C                   CALL      'ZCONVZ1'
     C                   PARM      L3_LKEAMT     WINAMT
     C                   PARM      A6SPRT        WRATE
     C                   PARM      A6MDIN        WMDIN
     C                   PARM      FEFCCY        WCCY1
     C                   PARM      BJCYCD        WCCY2
     C                   PARM      A6NBDP        WNBDP1
     C                   PARM      WNBDP1        WNBDP2
     C                   PARM                    WOUTAMT
 
     C                   EVAL      BSAMT = WOUTAMT
     C                   ENDIF
      *
      ** Format xxSyycccbP key for Base Currency Equivalent of Spot Trade
      ** a/c in purchase currency
      *
     C                   MOVE      'P'           AKY(10)
     C                   MOVEA     WKPURC        AKY(5)
     C                   MOVEA     '  '          AKY(8)
     C                   MOVE      BJCYCD        L3_LKECCY
     C                   Z-ADD     BSAMT         L3_LKEAMT
     C                   MOVEA     AKY           L3_LKAKEY
     C                   WRITE     LKEY3DPF
      *
      ** Format xxsyybcccS key for Base Currency Equivalent of Spot Trade
      ** account in sale currency
      *
     C                   MOVEA     L3_LKAKEY     AKY
     C                   MOVE      'S'           AKY(10)
     C                   MOVEA     WKSALC        AKY(5)
     C                   MOVEA     '  '          AKY(8)
     C                   MOVEA     AKY           L3_LKAKEY
     C                   WRITE     LKEY3DPF
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *    *INZSR - Initialization Subroutine                         *
      *****************************************************************
      *
     C     *INZSR        BEGSR
 
     C                   EVAL      dbPgm       = PSProcPgm
 
     C     KAllF         KLIST
     C                   KFLD                    L2_LKCNU2
     C                   KFLD                    L2_LKLOAN
     C                   KFLD                    L2_LKFACL
     C                   KFLD                    L2_LKFSE2
     C                   KFLD                    L2_LKOSAC
 
     C     KSTAL         KLIST
     C                   KFLD                    LNRF
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
