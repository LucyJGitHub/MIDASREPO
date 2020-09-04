     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*S*D****RPGBASEBND****************************************************                     CLE075BI
/*STD *  RPGSQLBND                                                    *                     CLE075BI
/*EXI *  TEXT('Midas LE PDCL process: retrieve set a/c priority')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE007054 - Past Due Call Loans: Retrieve Settlement account  *
      *            and block all debit indicator                      *
      *                                                               *
      *  Function:  This program retrieves the settlement a/c and the *
      *             Settlement block all debit indicator              *
      *                                                               *
      *  (COB)                                                        *
      *                                                               *
      *  Called By: LE0370, LE0390, LE0440                            *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CLE075BI           Date 06Aug12               *
      *  Prev Amend No. AR1063739          Date 03Dec12               *
      *                 AR700107 *CREATE   Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE075BI - COB Restructure - LE COB Optimisation Phase 1     *
      *  AR1063739 - SettlementAccount09 Issues                       *
      *  AR700107 - Prevent generation of RE/MR events for PDCLs that *
      *             have settlement a/c block all debit = 'Y'.        *
      *             (Child: AR700108)                                 *
      *                                                               *
      *****************************************************************
      /SPACE
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
     FACNUM     IF   E           K DISK
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Nostro details

     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D QQACCD2       E                     EXTFLD(QQACCD)
     D  NostCount                          LIKE(RCSQ.Nost)                                  CLE075BI

     D GLACNT        E DS                  EXTNAME(ACCNTAB)
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D QQACCD1       E                     EXTFLD(QQACCD)

     D                 DS
     D OSACDS                  1     18
     D OSACCN                  1      6
     D OSACAC                  7     16
     D OSACAS                 17     18

     D DSFDY         E DS
     D DSSDY         E DS

     D SVAL            S             20    DIM(5) CTDATA PERRCD(1)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D pReturnCode     S              7
     D WPARM           S             20A   INZ('LoanCustOriginPurch')

      ** Account
     D wBrca           S              3
     D wCNum           S              6
     D wCCY            S              3
     D wACod           S             10  0
     D wACSq           S              2  0
     D wACodA          S             10
     D wACSqA          S              2

      ** Entry Parms
     D IECCY           S              3
     D ILCNUM          S              6
     D ISccy           S              3
     D IOSAC           S             18
     D ISetp           S              2  0
     D IOlno           S              6
     D IOSBr           S              3
     D OBLCD           S              1

      ** AOACCTR0 Parms
     D PRtCd           S              7
     D POptn           S              7
     D PRetAcc         S             10
     D PCNum           S              6
     D PCcy            S              3
     D PACod           S             10
     D PASeq           S              2
     D PBrch           S              3

      ** AONOSTR0 Parms
     D***Wnostro         S              2                                                   CLE075BI
     D WRetcd          S              7
     D @Cusn           S              6
     D @Curr           S              3
     D @Accd           S             10
     D @Acsn           S              2
     D @Nonb           S              2
     D @Brca           S              3
     D @Cssn           S             10
     D @Pnoi           S              1

      ** AOBRCHR1 Parms
     D Branch          S              3

      ** AOSVALR0 Parms
     D P@OP01          S             20
     D P@VL01          S            200
     D P@OP02          S             20
     D P@VL02          S            200
     D P@OP03          S             20
     D P@VL03          S            200
     D P@OP04          S             20
     D P@VL04          S            200
     D P@OP05          S             20
     D P@VL05          S            200
     D P@OP06          S             20
     D P@VL06          S            200
     D P@OP07          S             20
     D P@VL07          S            200
     D P@OP08          S             20
     D P@VL08          S            200
     D P@OP09          S             20
     D P@VL09          S            200
     D P@OP10          S             20
     D P@VL10          S            200

     D SVALK1          S             20
     D SVAL1           S            200
     D SVALK2          S             20
     D SVAL2           S            200
     D SVALK3          S             20
     D SVAL3           S            200
     D SVALK4          S             20
     D SVAL4           S            200
     D SVALK5          S             20
     D SVAL5           S            200
     D SVALK6          S             20
     D SVAL6           S            200
     D SVALK7          S             20
     D SVAL7           S            200
     D SVALK8          S             20
     D SVAL8           S            200
     D SVALK9          S             20
     D SVAL9           S            200
     D SVALK0          S             20
     D SVAL10          S            200

     D WRetn           S             10  0

     D WRK01           S              1

     D PPCUST          S              1

     D CLE033          S              1
     D SET09           S              1

      ** +--------------------------------------+                                           CLE075BI
      ** ¦ Cache Work Variables and Storage     ¦                                           CLE075BI
      ** ¦ ================================     ¦                                           CLE075BI
      ** +--------------------------------------+                                           CLE075BI
                                                                                            CLE075BI
     D ULimit          S              4P 0 INZ                                              CLE075BI
     D CacheHit        S               N   INZ                                              CLE075BI
                                                                                            CLE075BI
      ** Cache Sizes for key and detail storage                                             CLE075BI
      ** Note: Cache size should be at least equal to BSearchMin                            CLE075BI
                                                                                            CLE075BI
     D BSearchMin      C                   CONST(100)                                       CLE075BI
     D ArrSzBranch     C                   CONST(900)                                       CLE075BI
     D ArrSzNost       C                   CONST(300)                                       CLE075BI
                                                                                            CLE075BI
      ** Record Counter for Searches Made                                                   CLE075BI
                                                                                            CLE075BI
     D RCSQ            DS                  INZ QUALIFIED                                    CLE075BI
     D  Nost                         13P 0                                                  CLE075BI
                                                                                            CLE075BI
      ** Search Arguments for Cache                                                         CLE075BI
                                                                                            CLE075BI
     D SrcBranch       S                   INZ LIKE(A8BRCD)                                 CLE075BI
     D SrcNost         DS                  INZ                                              CLE075BI
     D  NSCcy                              LIKE(A7CYCD)                                     CLE075BI
     D  NsNum                              LIKE(A7NONB)                                     CLE075BI
                                                                                            CLE075BI
      ** Branch Cache (key and detail storage)                                              CLE075BI
                                                                                            CLE075BI
     D KeyBranch       S                   INZ LIKE(SrcBranch)                              CLE075BI
     D                                     DIM(ArrSzBranch) ASCEND                          CLE075BI
                                                                                            CLE075BI
     D DSBranch      E DS                  INZ EXTNAME(SDBRCHPD)                            CLE075BI
     D                                     DIM(ArrSzBranch) QUALIFIED                       CLE075BI
                                                                                            CLE075BI
      ** Nostro Cache (key and detail storage)                                              CLE075BI
                                                                                            CLE075BI
     D KeyNost         S                   INZ LIKE(SrcNost)                                CLE075BI
     D                                     DIM(ArrSzNost) ASCEND                            CLE075BI
                                                                                            CLE075BI
     D DSNost          DS                  INZ QUALIFIED                                    CLE075BI
     D  Data                               LIKE(SDNOST)                                     CLE075BI
     D                                     DIM(ArrSzNost)                                   CLE075BI
     D   Key                               LIKE(SrcNost)                                    CLE075BI
     D                                     OVERLAY(Data)                                    CLE075BI
     D   Count                             LIKE(RCSQ.Nost)                                  CLE075BI
     D                                     OVERLAY(Data:210)                                CLE075BI
                                                                                            CLE075BI
      ** Cache index                                                                        CLE075BI
                                                                                            CLE075BI
     D NostIdx         DS                  INZ QUALIFIED                                    CLE075BI
     D  Last                               LIKE(ULimit)                                     CLE075BI
     D  Current                            LIKE(ULimit) INZ(1)                              CLE075BI
     D  Prev                               LIKE(ULimit) INZ(1)                              CLE075BI
                                                                                            CLE075BI
     D BrchIdx         DS                  INZ QUALIFIED                                    CLE075BI
     D  Last                               LIKE(ULimit)                                     CLE075BI
     D  Current                            LIKE(ULimit) INZ(1)                              CLE075BI
     D  Prev                               LIKE(ULimit) INZ(1)                              CLE075BI
                                                                                            CLE075BI
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      ** Receives input parameters

     C     *ENTRY        PLIST
     C                   PARM                    IECCY
     C                   PARM                    ILCNUM

     C                   PARM                    ISccy
     C                   PARM                    IOSAC
     C                   PARM                    ISetp
     C                   PARM                    IOlno
     C                   PARM                    IOSBr

     C                   PARM                    OBLCD

      ** Set Account fields depending on settlement type

     C                   IF        P@VL05 = 'Y'                                             CLE075BI
     C                   EXSR      SRRtvAcc
     C                   ENDIF                                                              CLE075BI

     C**********         EVAL      *INLR = *ON                                              CLE075BI

     C                   RETURN

      *****************************************************************
     C/EJECT
      *****************************************************************
      * SRRtvAcc - Derive account depending on the value of           *
      *            Settlement type                                    *
      *****************************************************************

     C     SRRtvACc      BEGSR

     C                   MOVE      IOSBR         wBrca

     C                   MOVE      IOSBR         Branch
     C**********         EXSR      SRGetBrca                                                CLE075BI

      ** Settlement type 03

     C                   SELECT
     C     ISetp         WHENEQ    03
     C                   EXSR      SRGetBrca                                                CLE075BI
     C                   EXSR      SRAcc03

     C     ISetp         WHENEQ    05
     C                   EXSR      SRAcc05

      ** Settlement type 04

     C     Isetp         WHENEQ    04
     C                   MOVE      BLACCD        wAcod
     C                   EXSR      SRAcc04

      ** Nostro Settlement type

     C     Isetp         WHENEQ    01
     C     Isetp         OREQ      02
     C     Isetp         OREQ      07
     C     ISetp         OREQ      08
     C     ISetp         OREQ      12
     C                   EXSR      SRAccNs

      ** Suspense a/c settlement type

     C     ISetp         WHENEQ    00
     C     ISetp         OREQ      06
     C                   MOVE      BKACCD        wAcod
     C                   EXSR      SRAcc04

      ** Retail

     C     ISetp         WHENEQ    14
     C                   EXSR      SRAccRE

      ** Settlement type 09

     C     ISetp         WHENEQ    09
     C                   EXSR      SRAcc09

     C                   ENDSL

      ** Retrieve account details

     C                   EXSR      SRRetACcD

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRetAccd - Retrieve account details                          *
      *****************************************************************

     C     SRRetAccd     BEGSR

     C                   MOVE      Wacod         Wacoda
     C                   MOVE      Wacsq         Wacsqa

     C                   IF        ISetP <> 14                                              CLE075BI
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      *BLANKS       PRetAcc
     C                   PARM      WCnum         PCNum
     C                   PARM      Wccy          PCcy
     C                   PARM      Wacoda        PACod
     C                   PARM      Wacsqa        PASeq
     C                   PARM      Wbrca         PBrch
     C     GLACNT        PARM      GLACNT        DSSDY
     C                   ENDIF                                                              CLE075BI

      ** Check RETB if PDCLBlockDebit is Y

     C**********         IF        P@VL05 = 'Y'                                             CLE075BI
     C                   TESTB     '2'           RETB                     80
     C                   IF        *IN80 = *ON
     C                   EVAL      OBLCD  = 'Y'
     C                   ENDIF
     C**********         ENDIF                                                              CLE075BI

     C                   ENDSR

      *****************************************************************
     C/EJECT
      *****************************************************************
      * SRAcc03 - Settlement type 03                                  *
      *****************************************************************

     C     SRAcc03       BEGSR

     C                   MOVE      A8BICN        wCnum
     C                   MOVE      IECCY         wCcy
     C                   MOVE      01            wAcsq
     C                   MOVE      BLACCD        wAcod

     C                   ENDSR

      *****************************************************************
     C/EJECT
      *****************************************************************
      * SRAcc04 - Settlement type 04, 00 and 06                       *
      *****************************************************************

     C     SRAcc04       BEGSR

     C     PPCUST        IFEQ      'O'
     C                   MOVE      IOlno         wCnum
     C                   ELSE
     C                   MOVE      ILCnum        wCnum
     C                   ENDIF
     C                   MOVE      IECCY         wCcy
     C                   MOVE      01            wAcsq

     C                   ENDSR

      *****************************************************************
     C/EJECT
      *****************************************************************
      * SRAcc05 - Settlement type 05                                  *
      *****************************************************************

     C     SRAcc05       BEGSR

     C                   MOVE      IOSAC         OSACDS
     C                   MOVE      IECCY         wCcy
     C                   MOVE      OSACCN        wCnum
     C                   MOVE      OSACAC        wAcod
     C                   MOVE      OSACAS        wAcsq

     C                   ENDSR

      *****************************************************************
     C/EJECT
      *****************************************************************
      * SRAccNs - settlement type 01, 02, 07, 08, 12 (Nostro)         *
      *****************************************************************

     C     SRAccNs       BEGSR

     C                   EVAL      NSNum = IOSAC                                            CLE075BI
     C                   EVAL      NSCcy = IECCY                                            CLE075BI
     C                   EXSR      CHKNOST                                                  CLE075BI
                                                                                            CLE075BI
     C                   IF        NOT CacheHit                                             CLE075BI
     C                   EXSR      GETNOST                                                  CLE075BI
     C                   ENDIF                                                              CLE075BI
     C**********         MOVEL     IOsac         Wnostro                                    CLE075BI
     C**********         CALL      'AONOSTR0'                                               CLE075BI
     C**********         PARM      *BLANKS       WRetcd                                     CLE075BI
     C**********         PARM      '*KEY   '     @Optn                                      CLE075BI
     C**********         PARM                    @Cusn                                      CLE075BI
     C**********         PARM      IECCY         @Curr                                      CLE075BI
     C**********         PARM                    @Accd                                      CLE075BI
     C**********         PARM                    @Acsn                                      CLE075BI
     C**********         PARM      WNostro       @Nonb                                      CLE075BI
     C**********         PARM                    @Brca                                      CLE075BI
     C**********         PARM                    @Cssn                                      CLE075BI
     C**********         PARM                    @Pnoi                                      CLE075BI
     C*****SDNOST        PARM                    DSFDY                                      CLE075BI

      ** DBERR 001

     C     WRetCd        IFNE      *BLANKS
     C                   MOVEL     'AONOSTR0'    DBFILE
     C                   Z-ADD     001           DBASE
     C**********         MOVEL     IECCY         DBKEY                                      CLE075BI
     C**********         MOVE      Wnostro       DBKEY                                      CLE075BI
     C                   EVAL      DBKEY = IECCY + IOSAC                                    CLE075BI
     C                   EXSR      *PSSR

      ** Set nostro account

     C                   ELSE
     C                   MOVE      A7CUST        WCnum
     C                   MOVE      IECCY         WCCY
     C                   MOVE      A7ACCD        WAcod
     C                   MOVE      A7ACSN        WAcsq
     C                   MOVE      A7ACSN        WBrca
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
     C/EJECT
      *****************************************************************
      * SRAccRE - Settlement type 14 (Retail)                         *
      *****************************************************************

     C     SRAccRE       BEGSR

     C                   MOVEL     IOSAC         WRetn
     C     WRetn         CHAIN     ACNUM
     C                   IF        %FOUND
     C                   MOVE      BRCA          WBrca
     C                   MOVE      ACOD          WAcod
     C                   MOVE      ACSQ          WAcsq
     C                   MOVE      CCY           WCcy
     C                   MOVE      CNUM          WCnum
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
     C/EJECT
      *****************************************************************
      * SRAcc09 - Settlement type 09                                  *
      *****************************************************************

     C     SRAcc09       BEGSR

     C                   MOVEL     P@VL01        WCnum
     C                   MOVEL     P@VL02        WAcod
     C                   MOVEL     IECCY         WCCY
     C                   MOVEL     01            WAcsq
     C     SET09         IFEQ      'T'
     C                   MOVEL     ISCCY         WCCY
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
     C/EJECT
      *****************************************************************
      * SRGetBrca - Retrieve Branch Details                           *
      *****************************************************************

     C     SRGetBrca     BEGSR

     C     Branch        IFNE      *BLANKS
     C                   EVAL      SrcBranch = Branch                                       CLE075BI
     C                   EXSR      CHKBRCH                                                  CLE075BI
                                                                                            CLE075BI
     C                   IF        NOT CacheHit                                             CLE075BI
     C                   CALL      'AOBRCHR1'
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    Branch
     C     SDBRCH        PARM                    DSSDY
     C                   ENDIF

     C                   ENDIF                                                              CLE075BI
     C                   ENDSR

      *****************************************************************
     C/EJECT
      *****************************************************************
      * Initialisation subroutine                                     *
      *****************************************************************

     C     *INZSR        BEGSR

     C                   EVAL      dbPgm = PSProcPgm

      ** Access General Ledger details

     C                   CALL      'AOGELRR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDGELR        PARM      SDGELR        DSSDY

      ** DBERR 002

     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF

      ** Retrieve trading data

     C                   CALL      'AOTRADR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDTRAD        PARM      SDTRAD        DSFDY

      ** DBERR 003

     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '*FIRST'      DBKEY
     C                   MOVEL     'SDTRADPD'    DBFILE
     C                   Z-ADD     003           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Check for presence of feature CLE033

     C                   MOVE      'N'           CLE033
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE033'      @SARD

     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CLE033 = 'Y'
     C                   ELSE
     C                   EVAL      CLE033 = 'N'
     C                   ENDIF

     C                   IF        CLE033 = 'Y'                                            AR1063739
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       wRETCD
     C                   PARM      SVAL(1)       P@OP01
     C                   PARM      *BLANKS       P@VL01
     C                   PARM      SVAL(2)       P@OP02
     C                   PARM      *BLANKS       P@VL02
     C                   PARM      SVAL(3)       P@OP03
     C                   PARM      *BLANKS       P@VL03
     C                   PARM      SVAL(4)       P@OP04
     C                   PARM      *BLANKS       P@VL04
     C                   PARM      SVAL(5)       P@OP05
     C                   PARM      *BLANKS       P@VL05
     C                   PARM      *BLANKS       P@OP06
     C                   PARM      *BLANKS       P@VL06
     C                   PARM      *BLANKS       P@OP07
     C                   PARM      *BLANKS       P@VL07
     C                   PARM      *BLANKS       P@OP08
     C                   PARM      *BLANKS       P@VL08
     C                   PARM      *BLANKS       P@OP09
     C                   PARM      *BLANKS       P@VL09
     C                   PARM      *BLANKS       P@OP10
     C                   PARM      *BLANKS       P@VL10

     C     WRetcd        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'LE007054'    DBPGM
     C                   MOVEL     'SDSVALPD'    DBFILE
     C                   MOVEL     '*KEY   '     DBKEY
     C                   Z-ADD     004           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Save value of Settlement09Postings in a one character field

     C                   MOVEL     P@VL04        SET09
     C                   ENDIF                                                             AR1063739

      ** Check System Value: Use Original Borrower or Purchased From?
      ** Set up parameter so access object checks LoanCustOriginPurch

     C                   MOVEL     WPARM         SVALK1

      ** Call Access object:

     C                   CALL      'AOSVALR0'
     C                   PARM                    WRetcd
     C                   PARM                    SVALK1
     C                   PARM                    SVAL1
     C                   PARM                    SVALK2
     C                   PARM                    SVAL2
     C                   PARM                    SVALK3
     C                   PARM                    SVAL3
     C                   PARM                    SVALK4
     C                   PARM                    SVAL4
     C                   PARM                    SVALK5
     C                   PARM                    SVAL5
     C                   PARM                    SVALK6
     C                   PARM                    SVAL6
     C                   PARM                    SVALK7
     C                   PARM                    SVAL7
     C                   PARM                    SVALK8
     C                   PARM                    SVAL8
     C                   PARM                    SVALK9
     C                   PARM                    SVAL9
     C                   PARM                    SVALK0
     C                   PARM                    SVAL10

      ** If the system value is not found then default value to 'P'

     C     WRetcd        IFNE      '        '
     C                   MOVE      'P'           PPCUST
     C                   ELSE

      ** Isolate the first character of SVAL1 which = 'P' or 'O'.

     C                   MOVEL     SVAL1         WRK01
     C     WRK01         IFEQ      'O'
     C                   MOVE      'O'           PPCUST
     C                   ELSE
     C                   MOVE      'P'           PPCUST
     C                   ENDIF
     C                   ENDIF
                                                                                            CLE075BI
      ** Load the Branch Cache                                                              CLE075BI
      ** Note: rows in optimize should be equal to array size                               CLE075BI
                                                                                            CLE075BI
     C                   EVAL      ULimit = ArrSzBranch                                     CLE075BI
                                                                                            CLE075BI
     C/EXEC SQL                                                                             CLE075BI
     C+ declare BrchCur insensitive cursor for                                              CLE075BI
     C+ select * from SDBRCHPD                                                              CLE075BI
     C+ order by A8BRCD ASC                                                                 CLE075BI
     C+ optimize for 900 Rows                                                               CLE075BI
     C/END-EXEC                                                                             CLE075BI
                                                                                            CLE075BI
     C/EXEC SQL                                                                             CLE075BI
     C+ open BrchCur                                                                        CLE075BI
     C/END-EXEC                                                                             CLE075BI
                                                                                            CLE075BI
     C/EXEC SQL                                                                             CLE075BI
     C+ fetch BrchCur for :ULimit rows into :DSBranch                                       CLE075BI
     C/END-EXEC                                                                             CLE075BI
                                                                                            CLE075BI
     C                   EVAL      BrchIdx.Last = SQLER3                                    CLE075BI
                                                                                            CLE075BI
     C/EXEC SQL                                                                             CLE075BI
     C+ close BrchCur                                                                       CLE075BI
     C/END-EXEC                                                                             CLE075BI
                                                                                            CLE075BI
     C                   IF        BrchIdx.Last > 0                                         CLE075BI
     C                   FOR       BrchIdx.Current = 1 to BrchIdx.Last                      CLE075BI
     C                   EVAL      KeyBranch(BrchIdx.Current) =                             CLE075BI
     C                                DSBranch(BrchIdx.Current).A8BRCD                      CLE075BI
     C                   ENDFOR                                                             CLE075BI
     C                   ENDIF                                                              CLE075BI
      *
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************                     CLE075BI
      *                                                               *                     CLE075BI
      * ChkNost - Check if Nostro in Cache                            *                     CLE075BI
      *                                                               *                     CLE075BI
      *****************************************************************                     CLE075BI
      *                                                                                     CLE075BI
     C     CHKNOST       BEGSR                                                              CLE075BI
                                                                                            CLE075BI
     C                   EVAL      CacheHit = False                                         CLE075BI
     C                   EVAL      RCSQ.Nost = RCSQ.Nost + 1                                CLE075BI
                                                                                            CLE075BI
      ** Only search cache if Search Key is not blank                                       CLE075BI
      ** and cache not empty                                                                CLE075BI
                                                                                            CLE075BI
     C                   IF        SrcNost = *BLANKS OR                                     CLE075BI
     C                             NostIdx.Last = 0                                         CLE075BI
     C                   LEAVESR                                                            CLE075BI
     C                   ENDIF                                                              CLE075BI
                                                                                            CLE075BI
      ** Perform search if key is not the recent search                                     CLE075BI
      ** otherwise, just resend the details from previous cache                             CLE075BI
                                                                                            CLE075BI
     C                   IF        SrcNost = KeyNost( NostIdx.Prev )                        CLE075BI
     C                   EVAL      CacheHit = True                                          CLE075BI
     C                   EVAL      NostIdx.Current = NostIdx.Prev                           CLE075BI
                                                                                            CLE075BI
     C                   ELSE                                                               CLE075BI
                                                                                            CLE075BI
      ** Sequential lookup                                                                  CLE075BI
                                                                                            CLE075BI
     C                   IF        NostIdx.Last < BSearchMin                                CLE075BI
     C                   EVAL      NostIdx.Current =                                        CLE075BI
     C                                  %LOOKUP( SrcNost                                    CLE075BI
     C                                         : DSNost.Key                                 CLE075BI
     C                                         : 1 : NostIdx.Last )                         CLE075BI
     C                   ELSE                                                               CLE075BI
                                                                                            CLE075BI
      ** binary search                                                                      CLE075BI
                                                                                            CLE075BI
     C                   EVAL      NostIdx.Current =                                        CLE075BI
     C                                  %LOOKUP( SrcNost                                    CLE075BI
     C                                         : KeyNost                                    CLE075BI
     C                                         :  1 : NostIdx.Last )                        CLE075BI
     C                   ENDIF                                                              CLE075BI
                                                                                            CLE075BI
     C                   IF        NostIdx.Current > 0                                      CLE075BI
     C                   EVAL      CacheHit = True                                          CLE075BI
     C                   ENDIF                                                              CLE075BI
                                                                                            CLE075BI
     C                   ENDIF                                                              CLE075BI
                                                                                            CLE075BI
     C                   IF        CacheHit                                                 CLE075BI
     C                   EVAL      DSNost.Count( NostIdx.Current ) =                        CLE075BI
     C                                       RCSQ.Nost                                      CLE075BI
     C                   EVAL      SDNOST =                                                 CLE075BI
     C                                  DSNost.Data( NostIdx.Current )                      CLE075BI
     C                   EVAL      NostIdx.Prev = NostIdx.Current                           CLE075BI
     C                   ENDIF                                                              CLE075BI
                                                                                            CLE075BI
     C                   ENDSR                                                              CLE075BI
     ******************************************************************                     CLE075BI
      /EJECT                                                                                CLE075BI
      *****************************************************************                     CLE075BI
      *                                                               *                     CLE075BI
      * GetNost - Check if Nostro in Cache                            *                     CLE075BI
      *                                                               *                     CLE075BI
      *****************************************************************                     CLE075BI
      *                                                                                     CLE075BI
     C     GETNOST       BEGSR                                                              CLE075BI
                                                                                            CLE075BI
      ** Retrieve details from Access Object program                                        CLE075BI
      ** Add to cache afterwards                                                            CLE075BI
                                                                                            CLE075BI
     C                   CALL      'AONOSTR0'                                               CLE075BI
     C                   PARM      *BLANKS       WRetcd                                     CLE075BI
     C                   PARM      '*KEY   '     @Optn                                      CLE075BI
     C                   PARM                    @Cusn                                      CLE075BI
     C                   PARM      NSCcy         @Curr                                      CLE075BI
     C                   PARM                    @Accd                                      CLE075BI
     C                   PARM                    @Acsn                                      CLE075BI
     C                   PARM      NSNum         @Nonb                                      CLE075BI
     C                   PARM                    @Brca                                      CLE075BI
     C                   PARM                    @Cssn                                      CLE075BI
     C                   PARM                    @Pnoi                                      CLE075BI
     C     SDNOST        PARM                    DSFDY                                      CLE075BI
                                                                                            CLE075BI
     C                   IF        WRetCd <> *BLANKS                                        CLE075BI
     C                   LEAVESR                                                            CLE075BI
     C                   ENDIF                                                              CLE075BI
                                                                                            CLE075BI
      ** Add retrieved details to cache depending on when:                                  CLE075BI
      ** there is no room in cache, replace stale entry in cache                            CLE075BI
                                                                                            CLE075BI
     C                   EVAL      NostCount = RCSQ.Nost                                    CLE075BI
                                                                                            CLE075BI
     C                   IF        NostIdx.Last = ArrSzNost                                 CLE075BI
                                                                                            CLE075BI
     C                   SORTA     %SUBARR( DSNost.Count                                    CLE075BI
     C                                    : 1 : NostIdx.Last )                              CLE075BI
     C                   EVAL      DSNost.Data( 1 ) = SDNOST                                CLE075BI
     C                   EVAL      NostIdx.Current = 1                                      CLE075BI
     C                   ENDIF                                                              CLE075BI
                                                                                            CLE075BI
      ** there is still room in cache                                                       CLE075BI
                                                                                            CLE075BI
     C                   IF        NostIdx.Last < ArrSzNost                                 CLE075BI
     C                   EVAL      NostIdx.Last = NostIdx.Last + 1                          CLE075BI
     C                   EVAL      NostIdx.Current = NostIdx.Last                           CLE075BI
     C                   EVAL      DSNost.Data( NostIdx.Current ) =                         CLE075BI
     C                                   SDNOST                                             CLE075BI
     C                   EVAL      KeyNost( NostIdx.Current ) =                             CLE075BI
     C                                   DSNost.Key( NostIdx.Current )                      CLE075BI
     C                   ENDIF                                                              CLE075BI
                                                                                            CLE075BI
      ** Sort array for binary search                                                       CLE075BI
                                                                                            CLE075BI
     C                   IF        NostIdx.Last >= BSearchMin                               CLE075BI
     C                   SORTA     %SUBARR( DSNost.Key                                      CLE075BI
     C                                    : 1 : NostIdx.Last )                              CLE075BI
     C                   EVAL      %SUBARR( KeyNost : 1 : NostIdx.Last)                     CLE075BI
     C                                      = DSNost.Key                                    CLE075BI
     C                   ENDIF                                                              CLE075BI
                                                                                            CLE075BI
     C                   EVAL      NostIdx.Prev = NostIdx.Current                           CLE075BI
     C                   ENDSR                                                              CLE075BI
     ******************************************************************                     CLE075BI
      /EJECT                                                                                CLE075BI
      *****************************************************************                     CLE075BI
      *                                                               *                     CLE075BI
      * ChkBRCH - Check if Branch in Cache                            *                     CLE075BI
      *                                                               *                     CLE075BI
      *****************************************************************                     CLE075BI
      *                                                                                     CLE075BI
     C     CHKBRCH       BEGSR                                                              CLE075BI
                                                                                            CLE075BI
      ** Only search cache if Search Key is not blank                                       CLE075BI
      ** and cache not empty                                                                CLE075BI
                                                                                            CLE075BI
     C                   EVAL      CacheHit = False                                         CLE075BI
     C                   IF        SrcBranch = *BLANKS OR                                   CLE075BI
     C                             BrchIdx.Last = 0                                         CLE075BI
     C                   LEAVESR                                                            CLE075BI
     C                   ENDIF                                                              CLE075BI
                                                                                            CLE075BI
      ** Perform search if key is not the recent search                                     CLE075BI
      ** otherwise, just resend the details from previous cache                             CLE075BI
                                                                                            CLE075BI
     C                   IF        SrcBranch =                                              CLE075BI
     C                                KeyBranch( BrchIdx.Prev )                             CLE075BI
     C                   EVAL      CacheHit = True                                          CLE075BI
     C                   EVAL      BrchIdx.Current = BrchIdx.Prev                           CLE075BI
                                                                                            CLE075BI
     C                   ELSE                                                               CLE075BI
     C                   EVAL      BrchIdx.Current =                                        CLE075BI
     C                                   %LOOKUP( SrcBranch                                 CLE075BI
     C                                          : KeyBranch                                 CLE075BI
     C                                          : 1 : BrchIdx.Last )                        CLE075BI
     C                   IF        BrchIdx.Current > 0                                      CLE075BI
     C                   EVAL      CacheHit = True                                          CLE075BI
     C                   ENDIF                                                              CLE075BI
                                                                                            CLE075BI
     C                   ENDIF                                                              CLE075BI
                                                                                            CLE075BI
     C                   IF        CacheHit                                                 CLE075BI
     C                   EVAL-CORR SDBRCH = DSBranch( BrchIdx.Current )                     CLE075BI
     C                   EVAL      BrchIdx.Prev = BrchIdx.Current                           CLE075BI
     C                   ENDIF                                                              CLE075BI
                                                                                            CLE075BI
     C                   ENDSR                                                              CLE075BI
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILEB
      *****************************************************************

**  CPY@
(c) Misys International Banking Systems Ltd. 2012
**   SVAL  -  SYSTEM VALUES ARRAY
Settlement09Customer
Settlement09AccCode
Settlement09Hostpgm
Settlement09Postings
PDCLBlockDebit
