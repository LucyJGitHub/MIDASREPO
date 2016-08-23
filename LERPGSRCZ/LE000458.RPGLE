     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE PDCL process: retrieve set a/c priority')     *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000458 - Past Due Call Loans: Retrieve Settlement account  *
      *                                                               *
      *  Function:  This program retrieves the settlement a/c and the *
      *             Settlement priority field and returns them to     *
      *             the calling function                              *
      *                                                               *
      *  (COB)                                                        *
      *                                                               *
      *  Called By: LE0450, LER130 and LER135                         *
      *                                                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CLE164               Date 18Aug14             *
      *  Prev Amend No. AR1097202            Date 28Mar13             *
      *                 AR1063739            Date 03Dec12             *
      *                 AR741212             Date 14Oct12             *
      *                 AR402543             Date 01Aug12             *
      *                 AR214036             Date 01Aug12             *
      *                 CLE134  *CREATE      Date 01Aug12             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *  AR1097202 - LEC000479 00001 failed                           *
      *  AR1063739 - SettlementAccount09 Issues                       *
      *  AR741212 - Manual Repayment settling against a nostro account*
      *             created a PDCL. Pass account tupe to the calling  *
      *             program. (Child: AR741213)                        *
      *  AR402543 - To produce the report in I/C showing missing a/k  *
      *             (Child: AR402544)                                 *
      *  AR214036 - Error in LE0458                                   *
      *             Wrong Currency field used for accessing Nostros   *
      *             file.                                             *
      *             (Child: AR214096)                                 *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
     FACKEY     IF   E           K DISK    INCLUDE(ACKEYALF)
     FACNUM     IF   E           K DISK
     F***LEACCNL4  IF   E           K DISK                                                    CLE164
 
      ** Nostro details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D QQACCD2       E                     EXTFLD(QQACCD)
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D QQACCD1       E                     EXTFLD(QQACCD)
     D ACCNT         E DS                  EXTNAME(ACCNTAB)                                 AR741212
     D                                     PREFIX(A_)                                       AR741212
 
     D DSFDY         E DS
     D DSSDY         E DS
 
     D PRETURNCODE     S              7
     D WPARM           S             20A   INZ('LoanCustOriginPurch')
 
      ** Account
     D WLNRF           S              6
     D WFCNUM          S              6
     D WFLOAN          S              6
     D WFFACL          S              5  0
     D WFSEQ           S              2  0
     D WFCOD           S              2  0
     D WLOAN           S              6
     D WCNU2           S              6
     D WFACL           S              5
     D WFBRCD          S              3
 
     D WBRCA           S              3
     D WCNUM           S              6
     D WCCY            S              3
     D WACOD           S             10  0
     D WACSQ           S              2  0
     D WACODA          S             10
     D WACSQA          S              2
 
     D                 DS
     D OSACDS                  1     18
     D OSACCN                  1      6
     D OSACAC                  7     16
     D OSACAS                 17     18
 
     D/COPY ZACPYSRC,STD_D_SPEC
     D/copy zacpysrc,psds
 
     D SVAL            S             20    DIM(4) CTDATA PERRCD(1)
 
      ** Additional Field Definitions
     D IACKEY          S             14
     D IECCY           S              3
     D ILNRF           S              6
     D IFCNUM          S              6
     D IFLOAN          S              6
     D IFFACL          S              5  0
     D IFSEQ           S              2  0
     D IFCOD           S              2  0
     D ISCCY           S              3
     D IOSAC           S             18
     D ISETP           S              2  0
     D IOLNO           S              6
     D IOSBR           S              3
     D IBRCA           S              3
     D ICNUM           S              6
     D ICCY            S              3
     D IACOD           S             10  0
     D IACSQ           S              2  0
     D*OPCNK****       S              5  0                                                    CLE164
     D WNOSTRO         S              2
     D WRETCD          S              7
     D @CUSN           S              6
     D @CURR           S              3
     D @ACCD           S             10
     D @ACSN           S              2
     D @NONB           S              2
     D @BRCA           S              3
     D @CSSN           S             10
     D @PNOI           S              1
     D WRETN           S             10  0
     D BRANCH          S              3
     D CLE033          S              1
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
     D SET09           S              1
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
     D WRK01           S              1
     D PPCUST          S              1
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Receives input parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    PRETURNCODE
     C                   PARM                    IACKEY
     C                   PARM                    IECCY
     C                   PARM                    ILNRF
     C                   PARM                    IFCNUM
     C                   PARM                    IFLOAN
     C                   PARM                    IFFACL
     C                   PARM                    IFSEQ
     C                   PARM                    IFCOD
 
     C                   PARM                    ISCCY
     C                   PARM                    IOSAC
     C                   PARM                    ISETP
     C                   PARM                    IOLNO
     C                   PARM                    IOSBR
 
     C                   PARM                    IBRCA
     C                   PARM                    ICNUM
     C                   PARM                    ICCY
     C                   PARM                    IACOD
     C                   PARM                    IACSQ
     C**********         PARM                    OPCNK                                        CLE164
     C                   PARM                    IATYP             1                        AR741212
 
     C                   CLEAR                   IBRCA
     C                   CLEAR                   ICNUM
     C                   CLEAR                   ICCY
     C                   CLEAR                   IACOD
     C                   CLEAR                   IACSQ
     C                   CLEAR                   IATYP                                      AR741212
 
     C                   MOVE      ILNRF         WLNRF
     C                   MOVE      IFCNUM        WFCNUM
     C                   MOVE      IFLOAN        WFLOAN
     C                   MOVE      IFFACL        WFFACL
     C                   MOVE      IFSEQ         WFSEQ
     C                   MOVE      IFCOD         WFCOD
 
      ** Chec if account key has posting ref 2
 
     C                   EXSR      CHECKAC
 
      ** Set Account fields depending on settlement type
 
     C                   EXSR      POSTR2
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
      /EJECT
      *****************************************************************
      *  CHECKAC - Check whether the account key has posting reference*
      ** in the debit posting reference. If none of the debit posting *
      ** reference is 2, then flag the a/c key as processed and       *
      ** skip to next record of LEPK3DPD                              *
      *****************************************************************
     C     CHECKAC       BEGSR
 
     C     IACKEY        CHAIN     ACKEY
 
      ** Dump if account key not found
 
     C                   IF        NOT %FOUND(ACKEY)
     C**********         RETURN                                                             AR402543
     C                   ELSE
 
      ** Check if posting reference 2 exists
      ** in one of the 3 debit accont
 
     C                   IF        PRF1 <> 2
     C                             AND PRF2 <> 2 AND PRF3 <> 2
     C**********         RETURN                                                             AR402543
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  POSTR2 - Derive account                                      *
      *****************************************************************
     C     POSTR2        BEGSR
 
      ** Derive account depending on the value of Settlement type
 
     C                   MOVE      IOSBR         WBRCA
 
     C                   MOVE      IOSBR         BRANCH
     C                   EXSR      GETBRCA
 
      ** Settlement type 03
 
     C                   SELECT
     C     ISETP         WHENEQ    03
     C                   EXSR      ACC03
 
     C     ISETP         WHENEQ    05
     C                   EXSR      ACC05
 
      ** Settlement type 04
 
     C     ISETP         WHENEQ    04
     C                   MOVE      BLACCD        WACOD
     C                   EXSR      ACC04
 
      ** Nostro Settlement type
 
     C     ISETP         WHENEQ    01
     C     ISETP         OREQ      02
     C     ISETP         OREQ      07
     C     ISETP         OREQ      08
     C     ISETP         OREQ      12
     C                   EXSR      ACCNS
 
      ** Suspense a/c settlement type
 
     C     ISETP         WHENEQ    00
     C     ISETP         OREQ      06
     C                   MOVE      BKACCD        WACOD
     C                   EXSR      ACC04
 
      ** Retail
 
     C     ISETP         WHENEQ    14
     C                   EXSR      ACCRE
 
      ** Settlement type 09
 
     C     ISETP         WHENEQ    09
     C                   EXSR      ACC09
 
     C                   ENDSL
 
      ** Retrieve settlement priority
 
     C                   EXSR      CHKSETTP
      *                                                                                     AR741212
      ** Retrieve account details                                                           AR741212
      *                                                                                     AR741212
     C                   MOVE      IACOD         WWACOD                                     AR741212
     C                   MOVE      IACSQ         WWACSQ                                     AR741212
      *                                                                                     AR741212
     C                   CALL      'AOACCTR0'                                               AR741212
     C                   PARM      '*MSG   '     WWRTCD            7                        AR741212
     C                   PARM      '*KEY   '     WWOPTN            7                        AR741212
     C                   PARM      *BLANKS       WWACNO           10                        AR741212
     C                   PARM      ICNUM         WWCUST            6                        AR741212
     C                   PARM      ICCY          WWCURR            3                        AR741212
     C                   PARM                    WWACOD           10                        AR741212
     C                   PARM                    WWACSQ            2                        AR741212
     C                   PARM      IBrca         WWBRCD            3                        AR741212
     C     ACCNT         PARM      ACCNT         DSSDY                                      AR741212
      *                                                                                     AR741212
     C     WWRTCD        IFEQ      *BLANKS                                                  AR741212
     C                   MOVE      A_ATYP        IATYP                                      AR741212
     C                   ENDIF                                                              AR741212
      *                                                                                     AR741212
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  CHKSETTP - Check Set-Up                                      *
      *****************************************************************
     C     CHKSETTP      BEGSR
 
     C                   MOVE      WBRCA         IBRCA
     C                   MOVE      WCCY          ICCY
     C                   MOVE      WCNUM         ICNUM
     C                   MOVE      WACOD         IACOD
     C                   MOVE      WACSQ         IACSQ
 
     C**********         Z-ADD     0             OPCNK                                        CLE164
     C*****KLEACC        CHAIN     LEACCNL4                                                   CLE164
     C**********         IF        %FOUND(LEACCNL4)                                           CLE164
     C**********         Z-ADD     RPPCKO        OPCNK                                        CLE164
     C**********         ENDIF                                                                CLE164
      *****************************************************************                       CLE164
     C*****OPCNK         IFEQ      0                                                          CLE164
     C**********         Z-ADD     99999         OPCNK                                        CLE164
     C**********         ENDIF                                                                CLE164
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  ACC03 - Settlement type 03                                   *
      *****************************************************************
     C     ACC03         BEGSR
 
     C                   MOVE      A8BICN        WCNUM
     C                   MOVE      IECCY         WCCY
     C                   MOVE      01            WACSQ
     C                   MOVE      BLACCD        WACOD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  ACC04 - Settlement type 04, 00 and 06                        *
      *****************************************************************
     C     ACC04         BEGSR
 
     C     PPCUST        IFEQ      'O'
     C                   MOVE      IOLNO         WCNUM
     C                   ELSE
     C                   MOVE      ICNUM         WCNUM
     C                   ENDIF
     C                   MOVE      IECCY         WCCY
     C                   MOVE      01            WACSQ
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  ACC05 - Settlement type 05                                   *
      *****************************************************************
     C     ACC05         BEGSR
 
     C                   MOVE      IOSAC         OSACDS
     C                   MOVE      IECCY         WCCY
     C                   MOVE      OSACCN        WCNUM
     C                   MOVE      OSACAC        WACOD
     C                   MOVE      OSACAS        WACSQ
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  ACCNS - settlement type 01, 02, 07, 08, 12 (Nostro)          *
      *****************************************************************
     C     ACCNS         BEGSR
 
     C                   MOVEL     IOSAC         WNOSTRO
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       WRETCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @CUSN
     C**********         PARM      ICCY          @Curr                                      AR214036
     C                   PARM      IECCY         @CURR                                      AR214036
     C                   PARM                    @ACCD
     C                   PARM                    @ACSN
     C                   PARM      WNOSTRO       @NONB
     C                   PARM                    @BRCA
     C                   PARM                    @CSSN
     C                   PARM                    @PNOI
     C     SDNOST        PARM                    DSFDY
 
     C     WRETCD        IFNE      *BLANKS
     C                   MOVEL     'AONOSTR0'    DBFILE
     C                   Z-ADD     001           DBASE
     C**********         MOVEL     ICCY          DBKEY                                      AR214036
     C                   MOVEL     IECCY         DBKEY                                      AR214036
     C                   MOVE      WNOSTRO       DBKEY
     C                   EXSR      *PSSR
 
      ** Set nostro account
 
     C                   ELSE
     C                   MOVE      A7CUST        WCNUM
     C                   MOVE      IECCY         WCCY
     C                   MOVE      A7ACCD        WACOD
     C                   MOVE      A7ACSN        WACSQ
     C**********         MOVE      A7ACSN        WBRCA                                     AR1097202
     C                   MOVE      A7BRCD        WBRCA                                     AR1097202
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  ACCRE - Settlement type 14 (Retail)                          *
      *****************************************************************
     C     ACCRE         BEGSR
 
     C                   MOVEL     IOSAC         WRETN
     C     WRETN         CHAIN     ACNUM
     C                   IF        %FOUND(ACNUM)
     C                   MOVE      BRCA          WBRCA
     C                   MOVE      ACOD          WACOD
     C                   MOVE      ACSQ          WACSQ
     C                   MOVE      CCY           WCCY
     C                   MOVE      CNUM          WCNUM
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  ACC09 - Settlement type 09                                   *
      *****************************************************************
     C     ACC09         BEGSR
 
     C                   MOVEL     P@VL01        WCNUM
     C                   MOVEL     P@VL02        WACOD
     C                   MOVEL     IECCY         WCCY
     C                   MOVEL     01            WACSQ
     C     SET09         IFEQ      'T'
     C                   MOVEL     ISCCY         WCCY
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  GETBRCA - Get Branch Details                                 *
      *****************************************************************
     C     GETBRCA       BEGSR
 
     C     BRANCH        IFNE      *BLANKS
     C                   CALL      'AOBRCHR1'
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    BRANCH
     C     SDBRCH        PARM                    DSSDY
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - *INZSR                                              *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C                   EVAL      DBPGM = PSPROCPGM
 
     C     KLEACC        KLIST
     C                   KFLD                    WBRCA
     C                   KFLD                    WCCY
     C                   KFLD                    WCNUM
     C                   KFLD                    WACOD
     C                   KFLD                    WACSQ
 
      ** Loan
     C                   KFLD                    WLNRF
 
      ** Fee details
     C                   KFLD                    WFCNUM
     C                   KFLD                    WFLOAN
     C                   KFLD                    WFFACL
     C                   KFLD                    WFSEQ
     C                   KFLD                    WFCOD
 
      ** Access General Ledger details
 
     C                   CALL      'AOGELRR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDGELR        PARM      SDGELR        DSSDY
 
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
     C                   PARM      *BLANKS       WRETCD
     C                   PARM      SVAL(1)       P@OP01
     C                   PARM      *BLANKS       P@VL01
     C                   PARM      SVAL(2)       P@OP02
     C                   PARM      *BLANKS       P@VL02
     C                   PARM      SVAL(3)       P@OP03
     C                   PARM      *BLANKS       P@VL03
     C                   PARM      SVAL(4)       P@OP04
     C                   PARM      *BLANKS       P@VL04
     C                   PARM      *BLANKS       P@OP05
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
 
     C     WRETCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'LE0458  '    DBPGM
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
 
      ** Call Access object
 
     C                   CALL      'AOSVALR0'
     C                   PARM                    WRETCD
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
 
     C     WRETCD        IFNE      '        '
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
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *PSSR - Default Error Handling Subroutine                    *
      *****************************************************************
     C     *PSSR         BEGSR
     C                   IF        RUNBEFORE <> 'Y'
     C                   EVAL      RUNBEFORE = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EVAL      *INLR = '1'
     C                   EVAL      PRETURNCODE = '*ERROR*'
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
**  CPY@
(c) MIsys International Banking Systems Ltd. 2012
**   SVAL  -  SYSTEM VALUES ARRAY
Settlement09Customer
Settlement09AccCode
Settlement09Hostpgm
Settlement09Postings
