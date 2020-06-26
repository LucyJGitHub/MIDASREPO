     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade settlement instruction validation')     *
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module.                             *
      *                                                               *
      *  SETSETIVAL - Trade Settlement Instruction Validation         *
      *                                                               *
      *  Function:  This module performs the validation for the       *
      *             settlement instruction details.                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. AR706553           Date 22May20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CSF011A            Date 28Nov11               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 162270 (180358)    Date 19Dec06               *
      *                 BUG13248A          Date 16Feb07               *
      *                 BUG13286A          Date 14Feb07               *
      *                 BUG13286           Date 12Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE071             Date 19Jul05               *
      *                 225161             Date 30Apr04               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3122            Date 17Jul04               *
      *                 BUG2582            Date 07Jul04               *
      *                 BUG3145            Date 15Jun04               *
      *                 CGL014             Date 20Oct03               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG1603            Date 25Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 10Jul03               *
      *                 CSE039             Date 21Jan03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 211554             Date 26Nov02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 188320             Date 24Apr02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 204757             Date 19Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 175718             Date 28Feb00               *
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 31Aug99               *
      *                 167953             Date 28Oct99               *
      *                 167488             Date 19OCT99               *
      *                 165014             Date 29Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CSE013             Date 29Jul98               *
      *                 CA0016 *CREATE     Date 25Mar98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR706553 - Trades Input API processing error, incorrect Pay  *
      *             To/From branch is defaulted. Patterned after fix  *
      *             245195. (Child: AR706554)                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  162270 - Amended program such that for TP trades with a pay  *
      *           code of 1, clearance type of 3 or 4, a 'pay from'   *
      *           customer different to the 'delivered to' customer   *
      *           will be allowed to be inserted.                     *
      *           In fact, it is fix for 180358.                      *
      *  BUG13248A - For book transfer, disregard validation for      *
      *              Deliver From/To fields.
/*    *  BUG13286A - Incorrect error message.                         *
/*    *  BUG13286 - Incorrect error message.                          *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL031 - Taxation of Savings Income (Recompiled)             *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  225161 - Remove some of the validations as swift is expected *
      *           to cover these validations.                         *
      *         - Deliver From and Deliver To accounts not setup and  *
      *           is set to blank.                                    *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  BUG2582 - allow blank clearence type, pay code and           *
      *            settlement method for book transfer.               *
      *  BUG3145 - Charges and Commission are being missed out of the *
      *            calculation of countervalue.                       *
      *  CGL014 - Collaterals Processing                              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  BUG1603- Allow Pay from/Pay to if settlement method is '04'  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Only Pay to/from branch if settlement method is not *
      *           '00'                                                *
      *  CSE039 - Auto-settlement of trades                           *
      *  211554 - Error message shown when amending a trade if trade  *
      *           is complete and settlement method is '00'. This     *
      *           must not happen if the security's market type is 'G'*
      *  188320 - Error code 607 appears even if user inputs no Profit*
      *           Centre. Only show error if default/entered Profit   *
      *           Centre does not exist.                              *
      *  204757 - Deliver From account of not being set up.           *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *  CSE022 - Depository Definition Enhancement                   *
      *  175718 - Setup of FldNamXAr with Clearance Type is wrong.    *
      *           There are 2 clearance type, one on Primary trade    *
      *           and the second on settlement                        *
      *  CPB001 - 'Private Banking' Module                            *
      *           /COPY SE_CUSTDT Changed                             *
      *  167953 - Correct Profit Centre defaulting                    *
      *  167488 - Profit Centre defaulting not working on ? validation*
      *  165014 - Change Profit Centre defaulting                     *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CSE013 - Short Position Warning                              *
      *  CA0016 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FACCNT     IF   E           K DISK
     FACNUM     IF   E           K DISK
     F                                     RENAME(ACCNTABF:ACNUMF)
     FSEPCBD    IF   E           K DISK                                         S01117
     FSEPCCD    IF   E           K DISK                                         S01117

     F/COPY WNCPYSRC,SETSETIVF1
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------

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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Trade Settlement Instructions in screen format
     D TrSett        E DS                  EXTNAME(SETRSTPD)

      ** Trade Settlement Instructions OK indicators
     D OKTrSett      E DS                  EXTNAME(SEETRSTPD)


      ** The following /COPY includes the customer details data structure
     D/COPY SECPYSRC,SE_CUSTDT
      ** The following /COPY includes the currency details data structures
     D/COPY SECPYSRC,SE_CCYDT


      ** Special Instruction line
     D SIL             S              1    DIM(35)

      ** Valid codeword characters
     D UPA             S              1    DIM(27) CTDATA PERRCD(27)

      ** Valid codeword characters for Swift 2001                                             CSW201
     D UPB             S              1    DIM(37) CTDATA PERRCD(37)                          CSW201
                                                                                              CSW201
      ** Valid SWIFT ISO characters
     D SWCH            S              1    DIM(47) CTDATA PERRCD(47)

     D APF             S              1    DIM(16)


      ** Branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)

      ** Nostro details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)

      ** Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D QQDFC1        E                     EXTFLD(QQDFAC)                                     CGL029

      ** Security Customer details
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
     D QQACC1        E                     EXTFLD(QQACCD)                                     CGL029

      ** Counterparty nostros
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)

      ** Currencies
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** Profit Centres
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)

      ** Account Officers                                                                     188320
     D SDACOF        E DS                  EXTNAME(SDACOFPD)                                  188320

      ** DS for customer/book standard settlement instruction                                 CSE039
      **  to be passed to SESSIR0                                                             CSE039
     D PCBSTD        E DS                  EXTNAME(STDSED) OCCURS(2)                          CSE039
     D                                     PREFIX(X1)                                         CSE039
      *                                                                                       CSE039
      ** Data structure for standard additional settlement details                            CSE039
      ** for customer/book to be passed to SESSIR0                                            CSE039
     D PCBSAD        E DS                  EXTNAME(STDADSED) OCCURS(8)                        CSE039
     D                                     PREFIX(X2)                                         CSE039
                                                                                              188320
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** External DS for Switchable features details                                          162270
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  162270
                                                                                              162270
     D/COPY WNCPYSRC,SETSETIVD1

     D DSACCT          DS
     D**CNUM****               1      6  0                                                    CSD027
     D  CNUM                   1      6                                                       CSD027
     D  CCY                    7      9
     D**ACODD***              100    133 00                                                   CGL029
     D**ACSQQ***              144    155 00                                                   CGL029
     D**BRCAA***              166    188                                                      CGL029
     D  ACOD                  10     19  0                                                    CGL029
     D  ACSQ                  20     21  0                                                    CGL029
     D  BRCA                  22     24                                                       CGL029

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Output field(s)
      ** ---------------

     D*TCNR*****       S              6S 0                                                    CSD027
     D*SDC1*****       S              6S 0                                                    CSD027
     D*SDC2*****       S              6S 0                                                    CSD027
     D*SDC3*****       S              6S 0                                                    CSD027
     D TCNR            S              6A                                                      CSD027
     D SDC1            S              6A                                                      CSD027
     D SDC2            S              6A                                                      CSD027
     D SDC3            S              6A                                                      CSD027

      ** Output field(s)
      ** ---------------

     D SMTH            S              2S 0
     D ASNM            S              2S 0
     D*DELF*****       S              6S 0                                                    CSD027
     D*DELT*****       S              6S 0                                                    CSD027
     D DELF            S              6A                                                      CSD027
     D DELT            S              6A                                                      CSD027

      ** Working Variables
      ** -----------------

      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
      ** Index for arrays of of Warning message ids etc
     D WIx             S              3P 0

     D @ERR            S              1P 0
     D @DSNB           S              3A
     D @SCKY           S              6A
     D @QRY            S              1A
     D @CPNC           S              8A
     D @KEY1           S             10A
     D @KYST           S              7A
     D @ZOBRX          S              3A
     D CUL             S              1A
     D SSF             S              1A
     D FC1DI           S              1A
     D TC1DI           S              1A
     D USRCB           S              5A
     D SCKY            S              6A
     D***P@ACCD*         S              4A                                                    CGL029
     D P@ACCD          S             10A                                                      CGL029
     D P@ACSN          S              2A
     D P@BRCD          S              3A
     D P@CSSN          S             10A
     D P@CUST          S              6A
     D P@CYCD          S              3A
     D P@NONB          S              2A
     D P@PNOI          S              1A
     D WPF10           S             10A
     D*WPYFM****       S              6P 0                                                    CSD027
     D WPYFM           S              6A                                                      CSD027
     D***WCOSQ**         S              6A                                                    CGL029
     D***WPRAC**         S             12A                                                    CGL029
     D WCOSQ           S             12A                                                      CGL029
     D WPRAC           S             18A                                                      CGL029
     D*WWCNUM***       S              6P 0                                                    CSD027
     D*WDELF****       S              6P 0                                                    CSD027
     D*WDELT****       S              6P 0                                                    CSD027
     D WWCNUM          S              6A                                                      CSD027
     D WDELF           S              6A                                                      CSD027
     D WDELT           S              6A                                                      CSD027
     D WCHECK          S              1A
     D WFL10           S             10A
     D***WFLD6**         S              6A                                                    CGL029
     D WFLD6           S             12A                                                      CGL029
     D WPYFB           S              3A
     D*WPAYT****       S              6P 0                                                    CSD027
     D WPAYT           S              6A                                                      CSD027
     D WPY10           S             10A
     D WPT10           S             10A
     D WPYTB           S              3A
     D KEY10           S             10P 0
     D WCSNM           S             10A
     D WCUST           S              6A
     D***WOUT06*         S              6A                                                    CGL029
     D WOUT06          S             12A                                                      CGL029
     D ErrInd          S              1A
     D ZDAYNO          S              5P 0
     D ZCCY            S              3A
     D ZLOC            S              3A
     D ZIND            S              1A
     D ShortFlag       S              1A                                        CSE013
     D WRtnCd          S              7A                                                      CSW201
     D CSW201          S              1A                                                      CSW201
     D BMACCD          S             10A                                                      CGL029
     D PAYT            S             18A                                                      CGL029
     D PYFM            S             18A                                                      CGL029

     D POTYP           S              1A   INZ('D')                                           CSE039
     D PBRCH           S              3A                                                      CSE039
     D PCUST           S              6A                                                      CSE039
     D PBOOK           S              2A                                                      CSE039
     D PCURR           S              3A                                                      CSE039
     D PMRKT           S              2A                                                      CSE039
     D PINVT           S              3A                                                      CSE039
     D PPTFR           S              4A                                                      CSE039
     D PRTCD           S              5A                                                      CSE039
                                                                                              CSE039
     D*CGL014**********S              1                                               CGL014 BUG3145
     D*TCTR************S             15  0                                            CGL014 BUG3145
     D*PTAMNT**********S             15  0                                            CGL014 BUG3145
     D*PTCCY***********S              3                                               CGL014 BUG3145
     D*PABRCA**********S              3                                               CGL014 BUG3145
     D*PACNUM**********S              6                                               CGL014 BUG3145
     D*PACCY***********S              3                                               CGL014 BUG3145
     D*PAACOD**********S             10                                               CGL014 BUG3145
     D*PAACSQ**********S              2                                               CGL014 BUG3145
     D*PAACNO**********S             10  0                                            CGL014 BUG3145
     D*PRTNCD**********S              7                                               CGL014 BUG3145
                                                                                      CGL014 BUG3145
     D IdX1            S              2P 0
     D IdY1            S              2P 0
     D IdL             S              3P 0

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************


      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Initialization
      *
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIDXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             WIx

      ** Clear output trade fields

     C                   Z-ADD     0             SMTH
     C                   MOVE      *BLANK        PYFM
     C                   MOVE      *BLANK        PYFA
     C                   MOVE      *BLANK        PAYT
     C                   MOVE      *BLANK        PYTA
     C                   MOVE      *BLANK        TDFA
     C                   Z-ADD     0             ASNM
     C                   MOVE      *BLANK        CLTY
     C**********         Z-ADD     0             DELT                                         CSD027
     C                   EVAL      DELT = *BLANKS                                             CSD027
     C                   MOVE      *BLANK        DTFA
     C**********         Z-ADD     0             DELF                                         CSD027
     C                   EVAL      DELF = *BLANKS                                             CSD027
     C                   MOVE      *BLANK        DFFA
     C                   MOVE      *BLANK        TDSI
     C                   MOVE      *BLANK        PRYC
     C                   MOVE      *BLANK        PCOD
     C                   MOVE      *BLANK        AUTS
      *
      ** Process all fields with '?' entry
      *
     C                   EXSR      SRProcQRY
      *
      ** Perform validation
      *
     C                   EXSR      SRValidate

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcQRY - Subroutine to perform the process input for '?'   *
      *             entries.  (D3QRY)                                 *
      *                                                               *
      *****************************************************************
     C     SRProcQRY     BEGSR

      *
      ** Originating Branch
      ** ------------------
      *
     C                   MOVEL     DDORBR        @QRY

     C     @QRY          IFEQ      '?'

     C                   MOVE      DDORBR        @DSNB

     C                   EXSR      AOBRCH

     C     @RTCD         IFEQ      '*NOSEL '
     C                   MOVE      *BLANKS       DDORBR
     C                   ELSE
     C                   MOVE      A8BRCD        DDORBR
     C                   END

     C                   END
      *
      ** Pay From (a/c)
      ** --------------
      *
     C                   MOVEL     DDPYFM        @QRY

     C     @QRY          IFEQ      '?'
      *
     C     DDTDTP        IFEQ      'TP'

     C     DDSMTH        IFEQ      '01'
     C     DDSMTH        OREQ      '02'
     C     DDSMTH        OREQ      '07'
     C     DDSMTH        OREQ      '08'
     C     DDSMTH        OREQ      '12'
     C                   MOVEL     DDPYFM        P@NONB
     C                   MOVEL     DDSETC        P@CYCD

     C                   EXSR      AONOST

     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      *BLANKS       DDPYFM

     C                   ELSE
     C                   MOVE      *BLANKS       DDPYFM
     C                   MOVEL     A7NONB        DDPYFM
     C                   END

     C                   END

     C     DDSMTH        IFEQ      '15'
     C                   MOVEL     DDPYFM        WCSNM

     C                   EXSR      AOCUST

     C     @RTCD         IFEQ      '*NOSEL '
     C                   MOVE      *BLANKS       DDPYFM
     C                   ELSE
     C                   MOVE      *BLANKS       DDPYFM
     C                   MOVEL     BBCUST        DDPYFM
     C                   END

     C                   END
     C                   END

     C     DDTDTP        IFEQ      'TS'
     C     DDSMTH        IFEQ      '01'
     C     DDSMTH        OREQ      '07'
     C     DDSMTH        OREQ      '08'
     C                   MOVEL     DDPYFM        WCSNM

     C                   EXSR      AOCUST

     C     @RTCD         IFEQ      '*NOSEL '
     C                   MOVE      *BLANKS       DDPYFM
     C                   ELSE
     C                   MOVE      *BLANKS       DDPYFM
     C                   MOVEL     BBCUST        DDPYFM
     C                   END

     C                   END
     C                   END
     C                   END
      *
      ** Pay From Branch
      ** ---------------
      *
     C                   MOVEL     DDPYFB        @QRY
     C     @QRY          IFEQ      '?'
     C                   MOVE      DDPYFB        @DSNB

     C                   EXSR      AOBRCH

     C     @RTCD         IFEQ      '*NOSEL '
     C                   MOVE      *BLANKS       DDPYFB
     C                   ELSE
     C                   MOVE      A8BRCD        DDPYFB
     C                   END

     C                   END
      *
      ** Pay To (a/c)
      ** ------------
      *
     C                   MOVEL     DDPAYT        @QRY
     C     @QRY          IFEQ      '?'

     C     DDTDTP        IFEQ      'TS'
     C     DDSMTH        IFEQ      '01'
     C     DDSMTH        OREQ      '02'
     C     DDSMTH        OREQ      '07'
     C     DDSMTH        OREQ      '08'
     C     DDSMTH        OREQ      '12'
     C                   MOVEL     DDPAYT        P@NONB
     C                   MOVEL     DDSETC        P@CYCD

     C                   EXSR      AONOST

     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      *BLANKS       DDPAYT
     C                   ELSE
     C                   MOVE      *BLANKS       DDPAYT
     C                   MOVEL     A7NONB        DDPAYT
     C                   END

     C                   END

     C     DDSMTH        IFEQ      '15'
     C                   MOVEL     DDPAYT        WCSNM

     C                   EXSR      AOCUST

     C     @RTCD         IFEQ      '*NOSEL '
     C                   MOVE      *BLANKS       DDPAYT
     C                   ELSE
     C                   MOVE      *BLANKS       DDPAYT
     C                   MOVEL     BBCUST        DDPAYT
     C                   END
     C                   END
     C                   END
     C*
     C     DDTDTP        IFEQ      'TP'
     C     DDSMTH        IFEQ      '01'
     C     DDSMTH        OREQ      '07'
     C     DDSMTH        OREQ      '08'
     C                   MOVEL     DDPAYT        WCSNM

     C                   EXSR      AOCUST

     C     @RTCD         IFEQ      '*NOSEL '
     C                   MOVE      *BLANKS       DDPAYT
     C                   ELSE
     C                   MOVE      *BLANKS       DDPAYT
     C                   MOVEL     BBCUST        DDPAYT
     C                   END
     C                   END
     C                   END
     C                   END
      *
      ** Pay To Branch
      ** -------------
      *
     C                   MOVEL     DDPYTB        @QRY

     C     @QRY          IFEQ      '?'
     C                   MOVE      DDPYTB        @DSNB

     C                   EXSR      AOBRCH

     C     @RTCD         IFEQ      '*NOSEL '
     C                   MOVE      *BLANKS       DDPYTB
     C                   ELSE
     C                   MOVE      A8BRCD        DDPYTB
     C                   END

     C                   END
      *
      ** Pay For A/C Of
      ** --------------
      *
     C                   MOVEL     DDTDFA        @QRY

     C     @QRY          IFEQ      '?'
     C                   MOVEL     DDTDFA        WCSNM
     C                   EXSR      AOCUST

     C     @RTCD         IFEQ      '*NOSEL '
     C                   MOVE      *BLANKS       DDTDFA
     C                   ELSE
     C                   MOVE      *BLANKS       DDTDFA
     C                   MOVEL     BBCUST        DDTDFA
     C                   END

     C                   END
      *
      ** Deliver From
      ** ------------
      *
     C                   MOVEL     DDDELF        @QRY

     C     @QRY          IFEQ      '?'
     C                   MOVEL     DDDELF        WCUST

     C                   EXSR      AOSECS

     C     @RTCD         IFEQ      '*NOSEL '
     C                   MOVE      *BLANKS       DDDELF
     C                   ELSE
     C                   MOVE      *BLANKS       DDDELF
     C                   MOVEL     BFCUST        DDDELF
     C                   END

     C                   END
      *
      ** Deliver To
      ** ----------
      *
     C                   MOVEL     DDDELT        @QRY

     C     @QRY          IFEQ      '?'
     C                   MOVEL     DDDELT        WCUST

     C                   EXSR      AOSECS

     C     @RTCD         IFEQ      '*NOSEL '
     C                   MOVE      *BLANKS       DDDELT
     C                   ELSE
     C                   MOVE      *BLANKS       DDDELT
     C                   MOVEL     BFCUST        DDDELT
     C                   END

     C                   END
      *
      ** Deliver From - For A/C Of
      ** -------------------------
      *
     C                   MOVEL     DDDFFA        @QRY

     C     @QRY          IFEQ      '?'
     C                   MOVEL     DDDFFA        WCUST

     C                   EXSR      AOSECS

     C     @RTCD         IFEQ      '*NOSEL '
     C                   MOVE      *BLANKS       DDDFFA
     C                   ELSE
     C                   MOVE      *BLANKS       DDDFFA
     C                   MOVEL     BFCUST        DDDFFA
     C                   END

     C                   END
      *
      ** Deliver To - For A/C Of
      ** -----------------------
      *
     C                   MOVEL     DDDTFA        @QRY

     C     @QRY          IFEQ      '?'
     C                   MOVEL     DDDTFA        WCUST

     C                   EXSR      AOSECS

     C     @RTCD         IFEQ      '*NOSEL '
     C                   MOVE      *BLANKS       DDTDFA
     C                   ELSE
     C                   MOVE      *BLANKS       DDTDFA
     C                   MOVEL     BFCUST        DDTDFA
     C                   END

     C                   END
      *
      ** 'In' Currency in Field 72
      ** -------------------------
      *
     C                   MOVEL     DDICCY        @QRY

     C     @QRY          IFEQ      '?'
     C                   MOVE      DDICCY        @AJCD
     C                   EXSR      AOCURR

     C     @RTCD         IFEQ      '*NOSEL '
     C                   MOVE      *BLANKS       DDICCY
     C                   ELSE
     C                   MOVE      A6CYCD        DDICCY
     C                   END

     C                   END

      *
      ** 'Profit centre
      ** ---------------
      *
     C                   MOVEL     DDPRFC        @QRY                                         167488
     C     @QRY          IFEQ      '?'                                                        167488
     C                   MOVE      DDPRFC        @PCCD                                        167488
     C                   EXSR      AOPRFC                                                     167488
     C     @RTCD         IFEQ      '*NOSEL '                                                  167488
     C                   MOVE      *BLANKS       DDPRFC                                       167488
     C                   ELSE                                                                 167488
     C                   MOVE      DSPCCD        DDPRFC                                       167488
     C                   ENDIF                                                                167488
     C                   ENDIF                                                                167488
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidate - Subroutine to perform the validation of the      *
      *              settlement fields.                               *
      *                                                               *
      *****************************************************************
     C     SRValidate    BEGSR
      *
      ** Validate Settlement Method
      ** --------------------------
      *
     C                   EXSR      ValSetMet
      *
      ** Validate Originating Branch
      ** ---------------------------
      *
     C                   EXSR      ValOrgBrh
      *
      ** Validate Pay From (Purchases)
      ** -----------------------------
      *
     C     DDTDTP        IFEQ      'TP'
     C                   EXSR      ValPayFrmP
     C                   ENDIF
      *
      ** Validate Pay From (Sales)
      ** -------------------------
      *
     C     DDTDTP        IFEQ      'TS'
     C                   EXSR      ValPayFrmS
     C                   ENDIF
      *
      ** Validate Pay From Branch
      ** ------------------------
      *
     C                   EXSR      ValPyFrBrh
      *
      ** Validate Pay To (Purchases)
      ** ---------------------------
      *
     C     DDTDTP        IFEQ      'TP'
     C                   EXSR      ValPayToP
     C                   END
      *
      ** Validate Pay To (Sales)
      ** ---------------------------
      *
     C     DDTDTP        IFEQ      'TS'
     C                   EXSR      ValPayToS
     C                   END
      *
      ** Validate Pay To Branch
      ** ----------------------
      *
     C                   EXSR      ValPyToBrh

      *                                                                                     AR706553
      ** Default  Pay To/From branch                                                        AR706553
      ** ---------------------------                                                        AR706553
      *                                                                                     AR706553
     C     DDSMTH        IFNE      '00'                                                     AR706553
     C     DDPYFB        IFEQ      *BLANKS                                                  AR706553
     C                   EXSR      DEFPYFRBR                                                AR706553
     C                   MOVE      DDPYFB        PYFA                                       AR706553
     C                   ENDIF                                                              AR706553
     C     DDPYTB        IFEQ      *BLANKS                                                  AR706553
     C                   EXSR      DEFPYTOBR                                                AR706553
     C                   MOVE      DDPYTB        PYTA                                       AR706553
     C                   ENDIF                                                              AR706553
     C                   ENDIF                                                              AR706553
      *                                                                                     AR706553
      ** Defaulting Procedure for Pay To, Pay From
      ** For Settlement type 04 (Prime Retail Account)

     C     DDSMTH        IFEQ      '04'
     C     DDSMTHok      ANDNE     'N'
     C                   EXSR      SetPrimRet
     C                   END
      *
      ** Validate For Account of (Pay To)
      ** --------------------------------
      *
     C                   EXSR      ValFrAcPyT
      *
      ** Validate For A/C Sequence No.
      ** -----------------------------
      *
     C                   EXSR      ValAcSeq
      *
      ** Validate Deliver From entry
      ** ---------------------------
      *
     C                   EXSR      ValDelvrFm
      *
      ** Validate Deliver to entry
      ** -------------------------
      *
     C                   EXSR      ValDelvrTo
      *
      ** Validate Deliver To/Deliver From entries - Purchases
      ** ----------------------------------------------------
      *
     C     DDDFFA        IFEQ      *BLANKS
     C     CustClass     ANDNE     'S'
     C     CustClass     ANDNE     'D'
     C     CustClass     ANDNE     'I'                                                     BUG13248A
     C     DDTDTP        ANDEQ     'TP'
     C                   EXSR      ValDTDF_P
     C                   END
      *
      ** Validate Deliver To/Deliver From entries - Sales
      ** ------------------------------------------------
      *
     C     DDDTFA        IFEQ      *BLANKS
     C     CustClass     ANDNE     'S'
     C     CustClass     ANDNE     'D'
     C     CustClass     ANDNE     'I'                                                     BUG13248A
     C     DDTDTP        ANDEQ     'TS'
     C                   EXSR      ValDTDF_S
     C                   END
      *****************************************************************                       CSE022
      ***Validate*Deliver*To/Deliver*From*entries*-*KassenVerein*******                       CSE022
      ***-------------------------------------------------------*******                       CSE022
      *****************************************************************                       CSE022
     C**********         EXSR      ValDTDF_K                                                  CSE022
      *
      ** Validate For Account of (Deliver to)
      ** ------------------------------------
      *
     C                   EXSR      ValFrAcDlT
      *
      ** Validate For Account of (Deliver From)
      ** --------------------------------------
      *
     C**********         EXSR      ValFrAcDlT                                                 204757
     C                   EXSR      ValFrAcDF                                                  204757
      *
      ** Validate Special Instruction field
      ** ----------------------------------
      *
     C                   EXSR      ValSplInst
     C/COPY WNCPYSRC,SETSETIVK6
      *
      ** Validate Clearance Type
      ** -----------------------
      *
     C                   EXSR      ValClearTp
      *
      ** Validate 'In' Currency in Field 72
      ** ----------------------------------
      *
     C     CEU005        IFEQ      'Y'
     C     DDICCY        ANDNE     *BLANK
     C                   EXSR      ValICcy72
     C                   END
      *
      ** Validate Profit Centre
      ** ----------------------
      **  If Profit Centres used
      **  and Profit Centre Accounting Module is not installed
      *
     C     BKPRCU        IFEQ      'Y'
     C     BGN0ST        ANDNE     'Y'
     C                   EXSR      ValProfitC
     C                   END
      *
      ** Validate Priority Code
      ** ----------------------
      *
     C                   EXSR      ValPriorit
      *
      ** Validate Pay Code
      ** -----------------
      *
     C                   EXSR      ValPayCode
      *
      ** Validate Auto-Settle Ind
      ** ------------------------
      *
     C                   EXSR      ValAutoSet

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValSetMet -  Subroutine to perform the validation for the     *
      *              settlement method.                               *
      *                                                               *
      *****************************************************************
     C     ValSetMet     BEGSR
      *
      ** Validate Settlement Method
     C/COPY WNCPYSRC,SETSETIVC8
      *
      **   .. if Market Ind. is 'G', must be blank or '00'
      *
     C     DDTDMI        IFEQ      'G'

     C     DDSMTH        IFNE      *BLANKS
     C     DDSMTH        ANDNE     '00'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0251'
     C                   EVAL      FldNamXAr (Idx) = 'DDSMTH'
     C                   EVAL      DDSMTHok = 'N'
     C                   GOTO      EValSetMet
     C                   END
      *
      ** If Market Ind. not 'G', must be a valid MIDAS settlement method
      *
     C                   ELSE

     C     DDSMTH        IFLT      '00'
     C     DDSMTH        OREQ      '09'
     C     DDSMTH        OREQ      '10'
     C     DDSMTH        OREQ      '11'
     C     DDSMTH        OREQ      '13'
     C     DDSMTH        ORGT      '15'
     C/COPY WNCPYSRC,SETSETIVC3
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0251'
     C                   EVAL      FldNamXAr (Idx) = 'DDSMTH'
     C                   EVAL      DDSMTHok = 'N'
     C                   GOTO      EValSetMet
     C                   END
     C/COPY WNCPYSRC,SETSETIVK7

     C                   END

     C     S01496        IFEQ      'Y'
     C     CustClass     ANDNE     'I'                                                       BUG2582
      *
      ****If*'00'*and*not*incomplete***********************************                       211554
      *
      ** If the Settlement Method is '00', the security's market type                         211554
      ** is not 'G' and the trade is not incomplete - error message                           211554
      *                                                                                       211554
     C     DDSMTH        IFEQ      '00'
     C     DDINCS        ANDNE     'I'
     C     DDTDMI        ANDNE     'G'                                                        211554
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0252'
     C                   EVAL      FldNamXAr (Idx) = 'DDSMTH'
     C                   EVAL      DDSMTHok = 'N'
     C                   GOTO      EValSetMet
     C                   END
      *
      ** If settlement method not '00', then for customers
      ** of bank only settl. method 04,05,14,15 allowed
      *
   1 C                   MOVE      'N'           WCHECK

     C     DDSMTH        IFNE      '00'

     C     CustClass     IFEQ      'S'
     C     CustClass     OREQ      'D'

     C     DDSMTH        IFEQ      '04'
     C     DDSMTH        OREQ      '05'
     C     DDSMTH        OREQ      '14'
     C     DDSMTH        OREQ      '15'
      *
      **   .. only for those customer and settl. methods will be
      **   .. checked, if the same cust. (Warn) and portfolio (Warn)
      **   .. at the counterparty and at the settlement account
      *
   1 C                   MOVE      'Y'           WCHECK
     C                   ELSE
     C                   ADD       1             WIx
     C                   EVAL      WMsgIDXAr(WIx) = 'MMA0253'
     C                   EVAL      WFldNmXAr(WIx) = 'DDSMTH'
     C                   EVAL      DDSMTHok = 'W'
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

     C                   ENDIF
      *
      ** If '04' or '14' the Retail Module must be present
      *
     C     DDSMTH        IFEQ      '04'
     C     DDSMTH        OREQ      '14'

     C     BGRTBN        IFNE      'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'ESM0903'
     C                   EVAL      FldNamXAr (Idx) = 'DDSMTH'
     C                   EVAL      DDSMTHok = 'N'
     C                   GOTO      EValSetMet
     C                   END

     C                   END
      *
      ** If '07' settlement currency must equal US dollar currency code
      *
     C     DDSMTH        IFEQ      '07'

     C     DDSETC        IFNE      BLUSCY
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'ESM0905'
     C                   EVAL      FldNamXAr (Idx) = 'DDSMTH'
     C                   EVAL      DDSMTHok = 'N'
     C                   GOTO      EValSetMet
     C                   END

     C                   END
      *
      ** .. if '06' Clearance Type must be '5'
      *
     C     DDCLTY        IFNE      '5'
     C     DDSMTH        ANDEQ     '06'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0254'
     C                   EVAL      FldNamXAr (Idx) = 'DDSMTH'
     C                   EVAL      DDSMTHok = 'N'
     C                   GOTO      EValSetMet
     C                   END
      *
      **   .. if '04' must reference an active ACCNT record
      *
     C     DDSMTH        IFEQ      '04'
     C     CustNum       IFNE      *BLANKS
     C                   MOVE      CustNum       CNUM
     C                   MOVEL     DDSETC        CCY
     C                   MOVE      BMACCD        ACOD
     C                   Z-ADD     1             ACSQ
     C                   MOVE      DDBRCD        BRCA

     C     KLACCT        KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    BRCA

     C     KLACCT        CHAIN     ACCNTABF                           44
     C                   END

     C     CustNum       IFEQ      *BLANKS
     C     *IN44         OREQ      '1'
     C     RECI          OREQ      '*'
     C     DACO          ORGT      TDVD
     C     ACST          OREQ      'C'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0255'
     C                   EVAL      FldNamXAr (Idx) = 'DDSMTH'
     C                   EVAL      DDSMTHok = 'N'
     C                   GOTO      EValSetMet

     C                   ELSE

     C                   TESTB     '2'           RETB                     99

     C     DDTDTP        IFEQ      'TP'
     C     *IN99         ANDEQ     '1'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0255'
     C                   EVAL      FldNamXAr (Idx) = 'DDSMTH'
     C                   EVAL      DDSMTHok = 'N'
     C                   GOTO      EValSetMet
     C                   END

     C                   TESTB     '3'           RETB                     99

     C     DDTDTP        IFEQ      'TS'
     C     *IN99         ANDEQ     '1'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0255'
     C                   EVAL      FldNamXAr (Idx) = 'DDSMTH'
     C                   EVAL      DDSMTHok = 'N'
     C                   GOTO      EValSetMet
     C                   END

     C                   END
     C                   END

      *   if not a nostro settlement, must not be a holiday in local
      *     currency/system location

     C     DDSMTH        IFNE      '01'
     C     DDSMTH        ANDNE     '02'
     C     DDSMTH        ANDNE     '07'
     C     DDSMTH        ANDNE     '08'
     C     DDSMTH        ANDNE     '12'
     C/COPY WNCPYSRC,SETSETIVC4
     C                   MOVE      BJSLCD        ZLOC
     C                   Z-ADD     TDVD          ZDAYNO
     C                   MOVE      BJLCCY        ZCCY

     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND

     C     ZIND          IFEQ      'H'
     C                   ADD       1             WIx
     C                   EVAL      WMsgIDXAr(WIx) = 'MMA0256'
     C                   EVAL      WFldNmXAr(WIx) = 'DDSMTH'
     C                   EVAL      DDSMTHok = 'W'
     C                   END

     C                   END

      * If valid, update trade field

     C     DDSMTHok      IFNE      'N'
     C/COPY WNCPYSRC,SETSETIVC9
     C                   MOVEL (P) DDSMTH        SMTH
     C/COPY WNCPYSRC,SETSETIVK1
     C                   END

     C     EValSetMet    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValOrgBrh - Subroutine to perform the validation for the      *
      *             Originating Branch Field                          *
      *                                                               *
      *****************************************************************
     C     ValOrgBrh     BEGSR

     C     BKOBRU        IFEQ      'Y'
      *
     C     DDORBR        IFEQ      *BLANKS
     C                   MOVE      DDBRCD        DDORBR
     C                   ELSE
     C                   MOVE      DDORBR        @DSNB

     C                   EXSR      AOBRCH

     C     @RTCD         IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMM0013'
     C                   EVAL      FldNamXAr (Idx) = 'DDORBR'
     C                   EVAL      DDORBRok = 'N'
     C                   END

     C                   END
     C*
     C     BKOBUV        IFEQ      'Y'
     C     RespMode      ANDEQ     'S'

     C                   Z-ADD     *ZERO         @ERR

     C                   CALL      'ZVOBU'
     C                   PARM      DDORBR        @ZOBRX
     C                   PARM                    @ERR
     C*
     C     @ERR          IFEQ      1
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0198'
     C                   EVAL      FldNamXAr (Idx) = 'DDORBR'
     C                   EVAL      DDORBRok = 'N'

     C                   ELSE

     C     @ERR          IFEQ      2
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0199'
     C                   EVAL      FldNamXAr (Idx) = 'DDORBR'
     C                   EVAL      DDORBRok = 'N'
     C                   END
     C                   END
     C                   END
     C*
     C                   ELSE
     C                   MOVE      DDBRCD        DDORBR
     C                   END

      * If valid, update trade field

     C     DDORBRok      IFNE      'N'
     C                   MOVE      DDORBR        ORBR
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValPayFrmP - Subroutine to perform the validation for the     *
      *              Pay From field if trade is a purchase            *
      *                                                               *
      *****************************************************************
     C     ValPayFrmP    BEGSR
      *
      **   .. entry only allowed for certain Settlement Methods
      *
     C     DDPYFM        IFNE      *BLANKS
     C     DDSMTH        ANDNE     '01'
     C     DDSMTH        ANDNE     '02'
     C     DDSMTH        ANDNE     '03'
     C     DDSMTH        ANDNE     '05'
     C     DDSMTH        ANDNE     '07'
     C     DDSMTH        ANDNE     '08'
     C     DDSMTH        ANDNE     '12'
     C     DDSMTH        ANDNE     '14'
     C     DDSMTH        ANDNE     '15'
      *                                                                                      BUG1603
     C     BGRTBN        IFNE      'Y'                                                       BUG1603
     C     DDPYFM        ANDNE     *BLANKS                                                   BUG1603
     C     DDSMTH        ANDNE     '04'                                                      BUG1603
      *                                                                                      BUG1603
     C/COPY WNCPYSRC,SETSETIVC5

     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0257'
     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'
     C                   EVAL      DDPYFMok = 'N'
     C                   GOTO      EValPayFrP
     C                   END
      *                                                                                      BUG1603
     C                   END                                                                 BUG1603
      *
      ** if Settlement Method '01' '02' '07' '08' or '12' must
      ** reference an active Nostro on SDNOSTPD and Pay From
      ** branch must match branch of Nostro
      *
     C     DDSMTH        IFEQ      '01'
     C     DDSMTH        OREQ      '02'
     C     DDSMTH        OREQ      '07'
     C     DDSMTH        OREQ      '08'
     C     DDSMTH        OREQ      '12'
     C/COPY WNCPYSRC,SETSETIVC6

     C                   MOVE      DDPYFM        WFL10
     C                   MOVE      *BLANKS       @RTCD
     C                   MOVE      DDSETC        P@CYCD
     C                   MOVEL     DDPYFM        P@NONB

     C                   EXSR      AONOST

     C                   MOVEL     DDPYFM        PYFM

     C     @RTCD         IFNE      *BLANKS
     C     WFL10         ORNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0258'
     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'
     C                   EVAL      DDPYFMok = 'N'
     C                   GOTO      EValPayFrP
      *
      **  Find Nostro location code for holiday validation
      *
     C                   ELSE
     C                   MOVE      '*DBERR '     @RTCD
     C                   MOVE      A7BRCD        @DSNB

     C                   EXSR      AOBRCH

     C                   MOVE      A8LCCD        ZLOC
      *
      ** If Clearance Type '1' or '2', must not be holiday in
      ** Euroclear currency
      *
     C     DDCLTY        IFEQ      '1'
     C     DDCLTY        OREQ      '2'
     C                   Z-ADD     TDVD          ZDAYNO
     C                   MOVE      BVEUCY        ZCCY

     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND

     C     ZIND          IFEQ      'H'
     C                   ADD       1             WIx
     C                   EVAL      WMsgIDXAr(WIx) = 'MMA0259'
     C                   EVAL      WFldNmXAr(WIx) = 'DDPYFM'
     C                   EVAL      DDPYFMok = 'W'
     C                   END

     C                   END
      *
      ** If Clearance Type '3' or '4', must not be holiday in
      ** Cedel currency.
      *
     C     DDCLTY        IFEQ      '3'
     C     DDCLTY        OREQ      '4'
     C                   Z-ADD     TDVD          ZDAYNO
     C                   MOVE      BVCCCY        ZCCY

     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND

     C     ZIND          IFEQ      'H'
     C                   ADD       1             WIx
     C                   EVAL      WMsgIDXAr(WIx) = 'MMA0260'
     C                   EVAL      WFldNmXAr(WIx) = 'DDPYFM'
     C                   EVAL      DDPYFMok = 'W'
     C                   END
     C                   END
      *
      ** If Clearance Type '2','4' or '5', must not be holiday in
      ** settlement currency
      *
     C     DDCLTY        IFEQ      '2'
     C     DDCLTY        OREQ      '4'
     C     DDCLTY        OREQ      '5'

     C     DDSETC        IFNE      *BLANKS
     C                   Z-ADD     TDVD          ZDAYNO
     C                   MOVE      DDSETC        ZCCY
     C                   ELSE

     C     CustCurr      IFNE      *BLANKS
     C                   MOVE      CustCurr      ZCCY
     C                   ELSE
     C                   MOVE      NMCY          ZCCY
     C                   END

     C                   END

     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND

     C     ZIND          IFEQ      'H'
     C                   ADD       1             WIx
     C                   EVAL      WMsgIDXAr(WIx) = 'MMA0261'
     C                   EVAL      WFldNmXAr(WIx) = 'DDPYFM'
     C                   EVAL      DDPYFMok = 'W'
     C                   END

     C                   END

     C                   END
     C                   MOVE      A7CUST        WPYFM

     C                   END
      *
      ** If Settlement Method is '03' may contain a Trade Ref. number.
      *
     C     DDSMTH        IFEQ      '03'

     C     DDPYFM        IFNE      *BLANKS
      *
     C                   MOVEA     *BLANKS       APF
     C                   MOVEA     DDPYFM        APF
     C                   SETOFF                                           99
      *
      ** Find first non blank character
      *
     C                   Z-ADD     1             IdX1
     C     IdX1          DOWLE     13
     C     APF(IdX1)     ANDEQ     ' '
     C                   ADD       1             IdX1
     C                   END
      *
      **          Ensure each character is numeric
      *
     C                   Z-ADD     0             IdY1
     C     IdX1          DOWLE     13
     C     APF(IdX1)     ANDNE     *BLANK
     C     *IN99         ANDNE     '1'
      *
     C     APF(IdX1)     COMP      '0'                                  99
     C  N99APF(IdX1)     COMP      '9'                                99
     C  N99              ADD       1             IdX1
     C  N99              ADD       1             IdY1
      *
     C                   END
      *
      **          Ensure than number is 6 digits
      *
     C  N99IdY1          COMP      6                                  9999
      *
     C     *IN99         IFEQ      '1'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0264'
     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'
     C                   EVAL      DDPYFMok = 'N'
     C                   GOTO      EValPayFrP
     C                   END

     C     DDPYFMok      IFNE      'N'
     C                   MOVEL     DDPYFM        PYFM
     C                   END
      *
      **   Pay from must not be blank.
      *
     C                   ELSE

     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0264'
     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'
     C                   EVAL      DDPYFMok = 'N'
     C                   GOTO      EValPayFrP
     C                   END

     C                   END
      *
      ** If Settlement Method '05' must reference an active ACCNT record
      ** for Pay From Branch
      *
     C     DDSMTH        IFEQ      '05'
     C**********         TESTN                   DDPYFM               35                      CSD027
      *
      ** If not multi-branching then use single branch code.
      *
     C     @MBIN         IFEQ      'N'
     C     DDPYFB        IFEQ      *BLANK
     C                   MOVEL     BJSBRC        DDPYFB
     C                   END
     C                   END

     C******IN35         IFEQ      '1'                                                        CSD027
      *
     C                   MOVE      DDPYFM        WFLD6
     C                   MOVEL     DDPYFM        CNUM
     C                   MOVEL     DDSETC        CCY
     C                   MOVEL     WFLD6         ACOD
     C                   MOVE      WFLD6         ACSQ
     C                   MOVE      DDPYFB        BRCA

     C     KLACCT        CHAIN     ACCNTABF                           44
     C**********         END                                                                  CSD027

     C******IN35         IFEQ      '0'                                                        CSD027
     C******IN44         OREQ      '1'                                                        CSD027
     C     *IN44         IFEQ      '1'                                                        CSD027
     C     RECI          OREQ      '*'
     C     DACO          ORGT      TDVD
     C     ACST          OREQ      'C'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0262'
     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'
     C                   EVAL      DDPYFMok = 'N'
     C                   GOTO      EValPayFrP
      *
      ** Else check account is not blocked
      *
     C                   ELSE
     C                   TESTB     '2'           RETB                     99

     C     DDTDTP        IFEQ      'TP'
     C     *IN99         ANDEQ     '1'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0262'
     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'
     C                   EVAL      DDPYFMok = 'N'
     C                   GOTO      EValPayFrP
     C                   END

     C                   END
     C**********         Z-ADD     CNUM          WPYFM                                        CSD027
     C                   EVAL      WPYFM = CNUM                                               CSD027
     C                   MOVEL     DDPYFM        PYFM
     C                   END
      *
      ** If Settlement Method '14' must reference an active
      ** account on ACNUM
      *
     C     DDSMTH        IFEQ      '14'
      *
      ** If not multibranching then use single branch code.
      *
     C     @MBIN         IFEQ      'N'
     C     DDPYFB        IFEQ      *BLANK
     C                   MOVEL     BJSBRC        DDPYFB
     C                   END
     C                   END

     C                   MOVE      DDPYFB        WPYFB
     C                   MOVEL     DDPYFM        WPF10
     C**********         TESTN                   WPF10                35                      CSD027

     C******IN35         IFEQ      '1'                                                        CSD027
     C                   MOVEL     DDPYFM        KEY10
     C     KEY10         CHAIN     ACNUMF                             44

     C     *IN44         IFEQ      '0'
     C     RECI          ANDNE     '*'
     C     KLACCT        CHAIN     ACCNTABF                           44
     C                   END
     C**********         END                                                                  CSD027
      *
     C******IN35         IFEQ      '0'                                                        CSD027
     C******IN44         OREQ      '1'                                                        CSD027
     C     *IN44         IFEQ      '1'                                                        CSD027
     C     RECI          OREQ      '*'
     C     DACO          ORGT      TDVD
     C     ACST          OREQ      'C'
     C*****CCY**         ORNE      DDSETC                                                  BUG13286A
     C*****BRCA*         ORNE      WPYFB                                                   BUG13286A
     C*****WPYFB         ANDNE     *BLANK                                                  BUG13286A
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0263'
     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'
     C                   EVAL      DDPYFMok = 'N'
     C                   GOTO      EValPayFrP
      *
      ** Else check account is not blocked
      *
     C                   ELSE

     C                   TESTB     '2'           RETB                     99

     C     DDTDTP        IFEQ      'TP'
     C     *IN99         ANDEQ     '1'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0263'
     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'
     C                   EVAL      DDPYFMok = 'N'
     C                   GOTO      EValPayFrP
     C                   END
      *
     C                   END
     C**********         Z-ADD     CNUM          WPYFM                                        CSD027
     C     CCY           IFNE      DDSETC                                                  BUG13286A
     C     *IN44         ANDEQ     '0'                                                     BUG13286A
     C                   ADD       1             Idx                                       BUG13286A
     C                   EVAL      MsgIDXAr(Idx) = 'USR9379'                               BUG13286A
     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'                              BUG13286A
     C                   EVAL      DDPYFMok = 'N'                                          BUG13286A
     C                   GOTO      EValPayFrP                                              BUG13286A
     C                   ENDIF                                                             BUG13286A
      *                                                                                    BUG13286A
     C     BRCA          IFNE      WPYFB                                                   BUG13286A
     C     WPYFB         ANDNE     *BLANK                                                  BUG13286A
     C     *IN44         ANDEQ     '0'                                                     BUG13286A
     C                   ADD       1             Idx                                       BUG13286A
     C                   EVAL      MsgIDXAr(Idx) = 'USR9381'                               BUG13286A
     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'                              BUG13286A
     C                   EVAL      DDPYFMok = 'N'                                          BUG13286A
     C                   GOTO      EValPayFrP                                              BUG13286A
     C                   ENDIF                                                             BUG13286A
      *                                                                                    BUG13286A
     C                   EVAL      WPYFM = CNUM                                               CSD027
     C                   MOVEL     DDPYFM        PYFM
     C                   END
      *
      ** If Settlement Method '15' may reference an active
      ** account on ACCNT for Booking Branch.
      *
     C     DDSMTH        IFEQ      '15'
     C     DDPYFM        ANDNE     *BLANKS
     C                   MOVEL     DDPYFM        WCSNM
     C                   MOVE      *BLANKS       @RTCD

     C                   EXSR      AOCUST

     C     @RTCD         IFNE      *BLANKS

     C                   MOVEL     DDPYFM        WCUST
     C**********         TESTN                   WCUST                35                      CSD027

     C******IN35         IFEQ      '0'                                                        CSD027
     C**********         MOVE      *BLANKS       WCUST                                        CSD027
     C**********         END                                                                  CSD027
      *
      **  Convert shortname to customer number
      *
     C                   ELSE
     C                   MOVE      *BLANKS       DDPYFM
     C                   MOVEL     BBCUST        DDPYFM
     C                   MOVEL     BBCUST        WCUST
     C                   END

     C                   MOVE      *BLANKS       @RTCD
     C                   EXSR      AOSECS

     C     @RTCD         IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0265'
     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'
     C                   EVAL      DDPYFMok = 'N'
     C                   GOTO      EValPayFrP
     C                   ELSE
     C                   MOVEL     DDSETC        CCY
     C                   MOVE      BFCUST        CNUM
     C                   MOVEL     BFACCD        ACOD
     C                   Z-ADD     BFACSN        ACSQ

     C     DDPYFB        IFNE      *BLANKS
     C                   MOVE      DDPYFB        BRCA
     C                   ELSE
     C                   MOVE      DDBRCD        BRCA
     C                   END

     C     KLACCT        CHAIN     ACCNTABF                           44
      *
     C     *IN44         IFEQ      '1'
     C     RECI          OREQ      '*'
     C     DACO          ORGT      TDVD
     C     ACST          OREQ      'C'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0265'
     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'
     C                   EVAL      DDPYFMok = 'N'
     C                   GOTO      EValPayFrP
      *
      ** Else check account is not blocked
      *
     C                   ELSE
     C                   TESTB     '2'           RETB                     99

     C     DDTDTP        IFEQ      'TP'
     C     *IN99         ANDEQ     '1'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0265'
     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'
     C                   EVAL      DDPYFMok = 'N'
     C                   GOTO      EValPayFrP
     C                   END

     C                   END
     C**********         Z-ADD     CNUM          WPYFM                                        CSD027
     C                   EVAL      WPYFM = CNUM                                               CSD027

     C     BFACCD        IFNE      *BLANKS
     C                   MOVEL     BFACCD        WOUT06
     C                   ELSE
     C**********         MOVEL     '0000'        WOUT06                                       CGL029
     C                   MOVEL     '0000000000'  WOUT06                                       CGL029
     C                   END
     C                   MOVE      BFACSN        WOUT06

     C                   MOVE      WOUT06        DDPYFM
     C                   MOVEL     DDPYFM        PYFM
     C                   END
     C                   END
      *
      ** If Settlement Method is 15 and PAY FROM is Blank, Output error
      *
     C     DDSMTH        IFEQ      '15'
     C     DDPYFM        ANDEQ     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0266'
     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'
     C                   EVAL      DDPYFMok = 'N'
     C                   GOTO      EValPayFrP
     C                   END
      *
     C     S01496        IFEQ      'Y'
      *
      ** If settlement method is 04/05/14/15 and counterparty was
      ** entered, settlement a/c customer must be the same
      *
     C     WCHECK        IFEQ      'Y'
     C                   MOVE      CustNum       WWCNUM

     C     WPYFM         IFNE      WWCNUM
     C*****WPYFM         ANDNE     *ZERO                                                      CSD027
     C     WPYFM         ANDNE     *BLANKS                                                    CSD027
     C                   ADD       1             WIx
     C                   EVAL      WMsgIDXAr(WIx) = 'MMA0267'
     C                   EVAL      WFldNmXAr(WIx) = 'DDPYFM'
     C                   EVAL      DDPYFMok = 'W'
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF
     C/COPY WNCPYSRC,SETSETIVK8

     C     EValPayFrP    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValPayFrmS - Subroutine to perform the validation for the     *
      *              Pay From field if trade is a sale                *
      *                                                               *
      *****************************************************************
     C     ValPayFrmS    BEGSR
      *
      ** Entry only allowed for Settlement Methods '01' '07' '08'
      *
     C     DDPYFM        IFNE      *BLANKS

     C     DDSMTH        IFNE      '01'
     C     DDSMTH        ANDNE     '07'
     C     DDSMTH        ANDNE     '08'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0268'
     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'
     C                   EVAL      DDPYFMok = 'N'
     C                   GOTO      EValPayFrS
     C                   END
      *
      ** If entered, must be a valid Customer, Shortname or
      ** Counterparty Nostro
      *
     C                   MOVEL     DDPYFM        WCSNM
     C                   MOVE      *BLANKS       @RTCD

     C                   EXSR      AOCUST

     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     DDPYFM        @CPNC

     C                   EXSR      AOCNST

     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     DDPYFM        PYFM
     C                   ELSE
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0269'
     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'
     C                   EVAL      DDPYFMok = 'N'
     C                   GOTO      EValPayFrS
     C                   END
      *
      **  Convert shortname to customer number
      *
     C                   ELSE
     C                   MOVEL     BBCUST        PYFM
     C                   MOVE      *BLANKS       DDPYFM
     C                   MOVEL     BBCUST        DDPYFM
     C                   MOVE      BBCUST        WPYFM
     C                   END

     C                   END

     C     EValPayFrS    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValPyFrBrh -  Subroutine to perform the validation for the    *
      *               Pay From Branch field.                          *
      *                                                               *
      *****************************************************************
     C     ValPyFrBrh    BEGSR
      *
      ** For Settlement Method 01, 02, 07, 08 and 12,
      ** Pay From branch must equal branch of the Nostro
      *
     C     DDSMTH        IFEQ      '01'
     C     DDSMTH        OREQ      '02'
     C     DDSMTH        OREQ      '07'
     C     DDSMTH        OREQ      '08'
     C     DDSMTH        OREQ      '12'
     C/COPY WNCPYSRC,SETSETIVK2

     C     DDPYFB        IFNE      A7BRCD
     C     DDPYFB        ANDNE     *BLANK
     C     DDTDTP        ANDEQ     'TP'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0270'
     C                   EVAL      FldNamXAr (Idx) = 'DDPYFB'
     C                   EVAL      DDPYFBok = 'N'
     C                   END

     C                   END
      *
      ** For Settlement Method 14
      ** Pay From branch must equal branch of the account
      *
     C     DDSMTH        IFEQ      '14'
     C     DDSMTH        OREQ      '15'

     C     DDPYFB        IFNE      BRCA
     C     DDPYFB        ANDNE     *BLANK
     C     DDTDTP        ANDEQ     'TP'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0270'
     C                   EVAL      FldNamXAr (Idx) = 'DDPYFB'
     C                   EVAL      DDPYFBok = 'N'
     C                   END

     C                   END
      *
      ** For Settlement Method other than 01, 02, 05, 07, 08, 12 & 14, & 15
      ** Pay From branch must equal Trade Booking branch
      *
     C     DDPYFB        IFNE      DDBRCD
     C     DDPYFB        ANDNE     *BLANK
     C     DDTDTP        ANDEQ     'TP'
     C     DDSMTH        ANDNE     '01'
     C     DDSMTH        ANDNE     '02'
     C     DDSMTH        ANDNE     '05'
     C     DDSMTH        ANDNE     '07'
     C     DDSMTH        ANDNE     '08'
     C     DDSMTH        ANDNE     '12'
     C     DDSMTH        ANDNE     '14'
     C     DDSMTH        ANDNE     '15'
     C     DDTDMI        ANDNE     'G'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0271'
     C                   EVAL      FldNamXAr (Idx) = 'DDPYFB'
     C                   EVAL      DDPYFBok = 'N'
     C                   END
      *
      **   .. if entered must exist on SDBRCHPD
      *
     C     DDPYFB        IFNE      *BLANKS
     C                   MOVE      DDPYFB        @DSNB

     C                   EXSR      AOBRCH

     C     @RTCD         IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0272'
     C                   EVAL      FldNamXAr (Idx) = 'DDPYFB'
     C                   EVAL      DDPYFBok = 'N'
     C                   END

     C                   END

     C     DDTDTP        IFEQ      'TP'
     C     @MBIN         ANDEQ     'Y'
     C     DDSMTH        ANDEQ     '05'
     C     DDPYFB        ANDEQ     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0325'
     C                   EVAL      FldNamXAr (Idx) = 'DDPYFB'
     C                   EVAL      DDPYFBok = 'N'
     C                   END
      *
      ** Determine default
      *
     C*****DDSMTH        IFNE      '00'                                              CAP084 AR706553
     C*****DDPYFB        IFEQ      *BLANKS                                                  AR706553
     C**********         EXSR      DefPyFrBr                                                AR706553
     C**********         END                                                                AR706553
     C**********         ENDIF                                                       CAP084 AR706553

      * Update trade field

     C                   MOVE      DDPYFB        PYFA

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValPayToP -  Subroutine to perform the validation for the Pay *
      *              To field if trade is a purchase                  *
      *                                                               *
      *****************************************************************
     C     ValPayToP     BEGSR
      *
      ** Entry only allowed if Settlement Methods '01' '07' '08'
      *
     C     DDPAYT        IFNE      *BLANKS
      *
     C     DDSMTH        IFNE      '01'
     C     DDSMTH        ANDNE     '07'
     C     DDSMTH        ANDNE     '08'
     C/COPY WNCPYSRC,SETSETIVC7
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0273'
     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
     C                   EVAL      DDPAYTok = 'N'
     C                   GOTO      EValPayToP
     C                   END
      *
      ** If entered, must be a valid Customer, Shortname or
      ** Counterparty Nostro
      *
     C                   MOVEL     DDPAYT        WCSNM
     C                   MOVE      *BLANKS       @RTCD

     C                   EXSR      AOCUST

     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     DDPAYT        @CPNC

     C                   EXSR      AOCNST

     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     DDPAYT        PAYT
     C                   ELSE
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0274'
     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
     C                   EVAL      DDPAYTok = 'N'
     C                   GOTO      EValPayToP
     C                   END
      *
      **  convert shortname to customer number
      *
     C                   ELSE
     C                   MOVEL     BBCUST        PAYT
     C                   MOVE      *BLANKS       DDPAYT
     C                   MOVEL     BBCUST        DDPAYT
     C                   MOVE      BBCUST        WPAYT
     C                   END

     C                   END

     C     EValPayToP    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValPayToS -  Subroutine to perform the validation for the Pay *
      *              To field if trade is a sale                      *
      *                                                               *
      *****************************************************************
     C     ValPayToS     BEGSR
      *
      **   .. entry only allowed for certain Settlement Methods
      *
     C     DDPAYT        IFNE      *BLANKS
     C     DDSMTH        ANDNE     '01'
     C     DDSMTH        ANDNE     '02'
     C     DDSMTH        ANDNE     '03'
     C     DDSMTH        ANDNE     '05'
     C     DDSMTH        ANDNE     '07'
     C     DDSMTH        ANDNE     '08'
     C     DDSMTH        ANDNE     '12'
     C     DDSMTH        ANDNE     '14'
     C     DDSMTH        ANDNE     '15'

     C     BGRTBN        IFNE      'Y'                                                       BUG1603
     C     DDPYFM        ANDNE     *BLANKS                                                   BUG1603
     C     DDSMTH        ANDNE     '04'                                                      BUG1603
      *                                                                                      BUG1603
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0275'
     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
     C                   EVAL      DDPAYTok = 'N'
     C                   GOTO      EValPayToS
     C                   END
      *                                                                                      BUG1603
     C                   END                                                                 BUG1603
      *
      ** if Settlement Method '01' '02' '07' '08' or '12' must
      ** reference an active Nostro on SDNOSTPD and Pay To
      ** branch must match branch of Nostro
      *
     C     DDSMTH        IFEQ      '01'
     C     DDSMTH        OREQ      '02'
     C     DDSMTH        OREQ      '07'
     C     DDSMTH        OREQ      '08'
     C     DDSMTH        OREQ      '12'

     C                   MOVE      DDPAYT        WFL10
     C                   MOVE      *BLANKS       @RTCD
     C                   MOVEL     DDSETC        P@CYCD
     C                   MOVEL     DDPAYT        P@NONB

     C                   EXSR      AONOST

     C                   MOVEL     DDPAYT        PAYT

     C     @RTCD         IFNE      *BLANKS
     C     WFL10         ORNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0276'
     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
     C                   EVAL      DDPAYTok = 'N'
     C                   GOTO      EValPayToS
      *
      **  Find nostro location code for holiday validation
      *
     C                   ELSE
     C                   MOVE      '*DBERR '     @RTCD
     C                   MOVE      A7BRCD        @DSNB

     C                   EXSR      AOBRCH

     C                   MOVE      A8LCCD        ZLOC
      *
      ** If Clearance Type '1' or '2', must not be holiday in
      ** Euroclear currency
      *
     C     DDCLTY        IFEQ      '1'
     C     DDCLTY        OREQ      '2'
     C                   Z-ADD     TDVD          ZDAYNO
     C                   MOVE      BVEUCY        ZCCY

     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND

     C     ZIND          IFEQ      'H'
     C                   ADD       1             WIx
     C                   EVAL      WMsgIDXAr(WIx) = 'MMA0277'
     C                   EVAL      WFldNmXAr(WIx) = 'DDPAYT'
     C                   EVAL      DDPAYTok = 'W'
     C                   END

     C                   END
      *
      ** If Clearance Type '3' or '4', must not be holiday in
      ** Cedel currency.
      *
     C     DDCLTY        IFEQ      '3'
     C     DDCLTY        OREQ      '4'
     C                   Z-ADD     TDVD          ZDAYNO
     C                   MOVE      BVCCCY        ZCCY

     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND

     C     ZIND          IFEQ      'H'
     C                   ADD       1             WIx
     C                   EVAL      WMsgIDXAr(WIx) = 'MMA0278'
     C                   EVAL      WFldNmXAr(WIx) = 'DDPAYT'
     C                   EVAL      DDPAYTok = 'W'
     C                   END
     C                   END
      *
      ** If Clearance Type '2','4' or '5', must not be holiday in
      ** settlement currency
      *
     C     DDCLTY        IFEQ      '2'
     C     DDCLTY        OREQ      '4'
     C     DDCLTY        OREQ      '5'

     C     DDSETC        IFNE      *BLANKS
     C                   Z-ADD     TDVD          ZDAYNO
     C                   MOVE      DDSETC        ZCCY
     C                   ELSE
      *
     C     CustCurr      IFNE      *BLANKS
     C                   MOVE      CustCurr      ZCCY
     C                   ELSE
     C                   MOVE      NMCY          ZCCY
     C                   END
      *
     C                   END

     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND

     C     ZIND          IFEQ      'H'
     C                   ADD       1             WIx
     C                   EVAL      WMsgIDXAr(WIx) = 'MMA0279'
     C                   EVAL      WFldNmXAr(WIx) = 'DDPAYT'
     C                   EVAL      DDPAYTok = 'W'
     C                   END

     C                   END

     C                   END
     C                   MOVE      A7CUST        WPAYT

     C                   END
      *
      ** If Settlement Method is '03' may contain a Trade Ref. Number
      *
     C     DDSMTH        IFEQ      '03'

     C     DDPAYT        IFNE      *BLANKS
      *
     C                   MOVEA     *BLANKS       APF
     C                   MOVEA     DDPAYT        APF
     C                   SETOFF                                           99
      *
      ** Find first non blank character
      *
     C                   Z-ADD     1             IdX1
     C     IdX1          DOWLE     13
     C     APF(IdX1)     ANDEQ     ' '
     C                   ADD       1             IdX1
     C                   END
      *
      **          Ensure each character is numeric
      *
     C                   Z-ADD     0             IdY1
     C     IdX1          DOWLE     13
     C     APF(IdX1)     ANDNE     *BLANK
     C     *IN99         ANDNE     '1'
      *
     C     APF(IdX1)     COMP      '0'                                  99
     C  N99APF(IdX1)     COMP      '9'                                99
     C  N99              ADD       1             IdX1
     C  N99              ADD       1             IdY1
      *
     C                   END
      *
      **          Ensure than number is 6 digits
      *
     C  N99IdY1          COMP      6                                  9999
      *
     C     *IN99         IFEQ      '1'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0280'
     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
     C                   EVAL      DDPAYTok = 'N'
     C                   GOTO      EValPayToS
     C                   END

     C     DDPAYTok      IFNE      'N'
     C                   MOVEL     DDPAYT        PAYT
     C                   END
      *
      **  Pay to must not be blank.
      *
     C                   ELSE

     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0280'
     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
     C                   EVAL      DDPAYTok = 'N'
     C                   GOTO      EValPayToS
     C                   END

     C                   END
      *
      ** If Settlement Method '05' must reference an active ACCNT record
      ** for Pay To Branch
      *
     C     DDSMTH        IFEQ      '05'
     C**********         TESTN                   DDPAYT               35                      CSD027
      *
      ** If not multi-branching then use single branch code.
      *
     C     @MBIN         IFEQ      'N'
     C     DDPYTB        IFEQ      *BLANK
     C                   MOVEL     BJSBRC        DDPYTB
     C                   END
     C                   END

     C******IN35         IFEQ      '1'                                                        CSD027

     C                   MOVE      DDPAYT        WFLD6
     C                   MOVEL     DDPAYT        CNUM
     C                   MOVEL     DDSETC        CCY
     C                   MOVEL     WFLD6         ACOD
     C                   MOVE      WFLD6         ACSQ
     C                   MOVE      DDPYTB        BRCA

     C     KLACCT        CHAIN     ACCNTABF                           44
     C**********         END                                                                  CSD027

     C******IN35         IFEQ      '0'                                                        CSD027
     C******IN44         OREQ      '1'                                                        CSD027
     C     *IN44         IFEQ      '1'                                                        CSD027
     C     RECI          OREQ      '*'
     C     DACO          ORGT      TDVD
     C     ACST          OREQ      'C'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0281'
     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
     C                   EVAL      DDPAYTok = 'N'
     C                   GOTO      EValPayToS
      *
      ** else check account is not blocked
      *
     C                   ELSE
     C                   TESTB     '3'           RETB                     99

     C     DDTDTP        IFEQ      'TS'
     C     *IN99         ANDEQ     '1'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0281'
     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
     C                   EVAL      DDPAYTok = 'N'
     C                   GOTO      EValPayToS
     C                   END

     C                   END
     C**********         Z-ADD     CNUM          WPAYT                                        CSD027
     C                   EVAL      WPAYT = CNUM                                               CSD027
     C                   MOVE      DDPAYT        PAYT
     C                   END
      *
      ** If Settlement Method '14' must reference an active
      ** account on ACNUM
      *
     C     DDSMTH        IFEQ      '14'
      *
      ** If not multibranching then use single branch code.
      *
     C     @MBIN         IFEQ      'N'
     C     DDPYTB        IFEQ      *BLANK
     C                   MOVEL     BJSBRC        DDPYTB
     C                   END
     C                   END

     C                   MOVE      DDPYTB        WPYTB
     C                   MOVEL     DDPAYT        WPT10
     C**********         TESTN                   WPT10                35                      CSD027

     C******IN35         IFEQ      '1'                                                        CSD027
     C                   MOVEL     DDPAYT        KEY10
     C     KEY10         CHAIN     ACNUMF                             44

     C     *IN44         IFEQ      '0'
     C     RECI          ANDNE     '*'
     C     KLACCT        CHAIN     ACCNTABF                           44
     C                   END
     C**********         END                                                                  CSD027

     C******IN35         IFEQ      '0'                                                        CSD027
     C******IN44         OREQ      '1'                                                        CSD027
     C     *IN44         IFEQ      '1'                                                        CSD027
     C     RECI          OREQ      '*'
     C     DACO          ORGT      TDVD
     C     ACST          OREQ      'C'
     C*****CCY**         ORNE      DDSETC                                                  BUG13286A
     C*****BRCA*         ORNE      WPYTB                                                    BUG13286
     C*****WPYTB         ANDNE     *BLANK                                                   BUG13286
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0282'
     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
     C                   EVAL      DDPAYTok = 'N'
     C                   GOTO      EValPayToS
      *
      ** Else check account is not blocked
      *
     C                   ELSE

     C                   TESTB     '3'           RETB                     99

     C     DDTDTP        IFEQ      'TS'
     C     *IN99         ANDEQ     '1'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0282'
     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
     C                   EVAL      DDPAYTok = 'N'
     C                   GOTO      EValPayToS
     C                   END
      *
     C                   END
      *                                                                                     BUG13286
     C     BRCA          IFNE      WPYTB                                                    BUG13286
     C     WPYTB         ANDNE     *BLANK                                                   BUG13286
     C     *IN44         ANDEQ     '0'                                                     BUG13286A
     C                   ADD       1             Idx                                        BUG13286
     C                   EVAL      MsgIDXAr(Idx) = 'USR9380'                                BUG13286
     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'                               BUG13286
     C                   EVAL      DDPAYTok = 'N'                                           BUG13286
     C                   GOTO      EValPayToS                                               BUG13286
     C                   ENDIF                                                              BUG13286
      *                                                                                     BUG13286
     C     CCY           IFNE      DDSETC                                                  BUG13286A
     C     *IN44         ANDEQ     '0'                                                     BUG13286A
     C                   ADD       1             Idx                                       BUG13286A
     C                   EVAL      MsgIDXAr(Idx) = 'USR9379'                               BUG13286A
     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'                              BUG13286A
     C                   EVAL      DDPayTok = 'N'                                          BUG13286A
     C                   GOTO      EValPayToS                                              BUG13286A
     C                   ENDIF                                                             BUG13286A
      *                                                                                    BUG13286A
     C**********         Z-ADD     CNUM          WPAYT                                        CSD027
     C                   EVAL      WPAYT = CNUM                                               CSD027
     C                   MOVE      DDPAYT        PAYT
                                                                                             BUG3145
      ** Move this additional validation into a new module SETRADAVAL                        BUG3145
                                                                                      CGL014 BUG3145
     C**********         IF        CGL014 = 'Y'  AND  DDPAYTok <> 'N'                 CGL014 BUG3145
     C**********         MOVE      CNUM          PACNUM                               CGL014 BUG3145
     C**********         MOVE      ACOD          PAACOD                               CGL014 BUG3145
     C**********         MOVE      ACSQ          PAACSQ                               CGL014 BUG3145
                                                                                      CGL014 BUG3145
     C**********         CALLB     'GL006000'                                         CGL014 BUG3145
     C**********         PARM      TCTR          PTAMNT                               CGL014 BUG3145
     C**********         PARM      NMCY          PTCCY                                CGL014 BUG3145
     C**********         PARM      BRCA          PABRCA                               CGL014 BUG3145
     C**********         PARM                    PACNUM                               CGL014 BUG3145
     C**********         PARM      CCY           PACCY                                CGL014 BUG3145
     C**********         PARM                    PAACOD                               CGL014 BUG3145
     C**********         PARM                    PAACSQ                               CGL014 BUG3145
     C**********         PARM      ACNO          PAACNO                               CGL014 BUG3145
     C**********         PARM      *BLANKS       PRTNCD                               CGL014 BUG3145
                                                                                      CGL014 BUG3145
      ***Error:**Available*balance*is*not*sufficient*******************               CGL014 BUG3145
      ***to*cover*blocked*amount***************************************               CGL014 BUG3145
                                                                                      CGL014 BUG3145
     C**********         IF        PRTNCD = '*BLKERR'                                 CGL014 BUG3145
     C**********         ADD       1             Idx                                  CGL014 BUG3145
     C**********         EVAL      MsgIDXAr(Idx) = 'MMA0862'                          CGL014 BUG3145
     C**********         EVAL      FldNamXAr(Idx) = 'DDPAYT'                          CGL014 BUG3145
     C**********         EVAL      DDPAYTok = 'N'                                     CGL014 BUG3145
     C**********         GOTO      EValPayToS                                         CGL014 BUG3145
     C**********         ENDIF                                                        CGL014 BUG3145
                                                                                      CGL014 BUG3145
      ***Warning:**Balance*is*greater*than*blocked*amount*but*less*****               CGL014 BUG3145
      ***than*minimum*balance;*minimum*balance*will*be*exceeded********               CGL014 BUG3145
                                                                                      CGL014 BUG3145
     C**********         IF        PRTNCD = '*WARN  '                                 CGL014 BUG3145
     C**********         ADD       1             WIx                                  CGL014 BUG3145
     C**********         EVAL      WMsgIDXAr(WIx) = 'MMA0863'                         CGL014 BUG3145
     C**********         EVAL      WFldNmXAr(WIx) = 'DDPAYT'                          CGL014 BUG3145
     C**********         EVAL      DDPAYTok = 'W'                                     CGL014 BUG3145
     C**********         ENDIF                                                        CGL014 BUG3145
                                                                                      CGL014 BUG3145
     C**********         ENDIF                                                        CGL014 BUG3145
                                                                                      CGL014 BUG3145
     C                   END
      *
      ** If Settlement Method '15' may reference an active
      ** account on ACCNT for Booking Branch.
      *
     C     DDSMTH        IFEQ      '15'
     C     DDPAYT        ANDNE     *BLANKS
     C                   MOVEL     DDPAYT        WCSNM
     C                   MOVE      *BLANKS       @RTCD

     C                   EXSR      AOCUST

     C     @RTCD         IFNE      *BLANKS
      *
     C                   MOVEL     DDPAYT        WCUST
     C**********         TESTN                   WCUST                35                      CSD027

     C******IN35         IFEQ      '0'                                                        CSD027
     C**********         MOVE      *BLANKS       WCUST                                        CSD027
     C**********         END                                                                  CSD027
      *
      ** Convert shortname to customer number
      *
     C                   ELSE
     C                   MOVE      *BLANKS       DDPAYT
     C                   MOVEL     BBCUST        DDPAYT
     C                   MOVEL     BBCUST        WCUST
     C                   END

     C                   MOVE      *BLANKS       @RTCD
     C                   EXSR      AOSECS

     C     @RTCD         IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0286'
     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
     C                   EVAL      DDPAYTok = 'N'
     C                   GOTO      EValPayToS
     C                   ELSE
     C                   MOVEL     DDSETC        CCY
     C                   MOVE      BFCUST        CNUM
     C                   MOVEL     BFACCD        ACOD
     C                   Z-ADD     BFACSN        ACSQ

     C     DDPYTB        IFNE      *BLANKS
     C                   MOVE      DDPYTB        BRCA
     C                   ELSE
     C                   MOVE      DDBRCD        BRCA
     C                   END

     C     KLACCT        CHAIN     ACCNTABF                           44

     C     *IN44         IFEQ      '1'
     C     RECI          OREQ      '*'
     C     DACO          ORGT      TDVD
     C     ACST          OREQ      'C'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0282'
     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
     C                   EVAL      DDPAYTok = 'N'
     C                   GOTO      EValPayToS
      *
      ** else check account is not blocked
      *
     C                   ELSE
     C                   TESTB     '3'           RETB                     99

     C     DDTDTP        IFEQ      'TS'
     C     *IN99         ANDEQ     '1'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0282'
     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
     C                   EVAL      DDPAYTok = 'N'
     C                   GOTO      EValPayToS
     C                   END

     C                   END
     C**********         Z-ADD     CNUM          WPAYT                                        CSD027
     C                   EVAL      WPAYT = CNUM                                               CSD027

     C     BFACCD        IFNE      *BLANKS
     C                   MOVEL     BFACCD        WOUT06
     C                   ELSE
     C**********         MOVEL     '0000'        WOUT06                                       CGL029
     C                   MOVEL     '0000000000'  WOUT06                                       CGL029
     C                   END
     C                   MOVE      BFACSN        WOUT06

     C                   MOVE      WOUT06        DDPAYT
     C                   MOVEL     DDPAYT        PAYT
     C                   END
     C                   END
      *
      ** If settlement method is 15 and Pay To is Blank output Error
      *
     C     DDSMTH        IFEQ      '15'
     C     DDPAYT        ANDEQ     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0284'
     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
     C                   EVAL      DDPAYTok = 'N'
     C                   GOTO      EValPayToS
     C                   END

     C     S01496        IFEQ      'Y'
      *
      ** If settlement method is 04/05/14/15 and counterparty was
      ** entered, settlement a/c customer must be the same
      *
     C     WCHECK        IFEQ      'Y'
     C                   MOVE      CustNum       WWCNUM

     C     WPAYT         IFNE      WWCNUM
     C*****WPAYT         ANDNE     *ZERO                                                      CSD027
     C     WPAYT         ANDNE     *BLANKS                                                    CSD027
     C                   ADD       1             WIx
     C                   EVAL      WMsgIDXAr(WIx) = 'MMA0285'
     C                   EVAL      WFldNmXAr(WIx) = 'DDPAYT'
     C                   EVAL      DDPAYTok = 'W'
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

     C     EValPayToS    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValPyToBrh- Subroutine to perform the validation for the Pay  *
      *             To Branch field.                                  *
      *                                                               *
      *****************************************************************
     C     ValPyToBrh    BEGSR
      *
      ** For Settlement Method 01, 02, 07, 08 and 12,
      ** Pay To branch must equal branch of the Nostro
      *
     C     DDSMTH        IFEQ      '01'
     C     DDSMTH        OREQ      '02'
     C     DDSMTH        OREQ      '07'
     C     DDSMTH        OREQ      '08'
     C     DDSMTH        OREQ      '12'

     C     DDPYTB        IFNE      A7BRCD
     C     DDPYTB        ANDNE     *BLANK
     C     DDTDTP        ANDEQ     'TS'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0287'
     C                   EVAL      FldNamXAr (Idx) = 'DDPYTB'
     C                   EVAL      DDPYTBok = 'N'
     C                   END

     C                   END
      *
      ** For Settlement Method 14
      ** Pay To branch must equal branch of the account
      *
     C     DDSMTH        IFEQ      '14'
     C     DDSMTH        OREQ      '15'

     C     DDPYTB        IFNE      BRCA
     C     DDPYTB        ANDNE     *BLANK
     C     DDTDTP        ANDEQ     'TS'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0288'
     C                   EVAL      FldNamXAr (Idx) = 'DDPYTB'
     C                   EVAL      DDPYTBok = 'N'
     C                   END

     C                   END
      *
      ** For Settlement Method other than 01, 02, 05, 07, 08, 12 & 14, & 15
      ** Pay To branch must equal Trade Booking branch
      *
     C     DDPYTB        IFNE      DDBRCD
     C     DDPYTB        ANDNE     *BLANK
     C     DDTDTP        ANDEQ     'TS'
     C     DDSMTH        ANDNE     '01'
     C     DDSMTH        ANDNE     '02'
     C     DDSMTH        ANDNE     '05'
     C     DDSMTH        ANDNE     '07'
     C     DDSMTH        ANDNE     '08'
     C     DDSMTH        ANDNE     '12'
     C     DDSMTH        ANDNE     '14'
     C     DDSMTH        ANDNE     '15'
     C     DDTDMI        ANDNE     'G'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0289'
     C                   EVAL      FldNamXAr (Idx) = 'DDPYTB'
     C                   EVAL      DDPYTBok = 'N'
     C                   END
      *
      ** If entered must exist on SDBRCHPD
      *
     C     DDPYTB        IFNE      *BLANKS
     C                   MOVE      DDPYTB        @DSNB

     C                   EXSR      AOBRCH

     C     @RTCD         IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0290'
     C                   EVAL      FldNamXAr (Idx) = 'DDPYTB'
     C                   EVAL      DDPYTBok = 'N'
     C                   END

     C                   END

     C     DDTDTP        IFEQ      'TS'
     C     @MBIN         ANDEQ     'Y'
     C     DDSMTH        ANDEQ     '05'
     C     DDPYTB        ANDEQ     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0324'
     C                   EVAL      FldNamXAr (Idx) = 'DDPYTB'
     C                   EVAL      DDPYTBok = 'N'
     C                   END
      *
      ** Determine default
      *
      *
     C*****DDSMTH        IFNE      '00'                                              CAP084 AR706553
     C*****DDPYTB        IFEQ      *BLANKS                                                  AR706553
     C**********         EXSR      DefPyToBr                                                AR706553
     C**********         END                                                                AR706553
     C**********         ENDIF                                                       CAP084 AR706553

      * Update trade field

     C                   MOVE      DDPYTB        PYTA

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValFrAcPyT- Subroutine to perform the validation for the      *
      *             For Account of (Pay To).                          *
      *                                                               *
      *****************************************************************
     C     ValFrAcPyT    BEGSR

     C     DDTDFA        IFNE      *BLANKS

     C/COPY WNCPYSRC,SETSETIVK9
     C     DDTDTP        IFNE      'TP'
     C     DDTDTP        OREQ      'TP'
     C     DDSMTH        ANDNE     '01'
     C     DDSMTH        ANDNE     '07'
     C     DDSMTH        ANDNE     '08'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0291'
     C                   EVAL      FldNamXAr (Idx) = 'DDTDFA'
     C                   EVAL      DDTDFAok = 'N'
     C                   END
     C/COPY WNCPYSRC,SETSETIVM1
      *
      ** If entered, must be a valid Customer, Shortname or counterparty
      ** Nostro
      *
     C                   MOVEL     *BLANKS       WCSNM
     C                   MOVEL     DDTDFA        WCSNM
     C                   MOVE      *BLANKS       @RTCD

     C                   EXSR      AOCUST

     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     BBCUST        TDFA
     C                   MOVEL     *BLANK        DDTDFA
     C                   MOVEL     BBCUST        DDTDFA
     C                   ELSE
     C                   MOVEL     DDTDFA        @CPNC

     C                   EXSR      AOCNST

     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     DDTDFA        TDFA
     C                   ELSE
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0292'
     C                   EVAL      FldNamXAr (Idx) = 'DDTDFA'
     C                   EVAL      DDTDFAok = 'N'
     C                   END

     C                   END
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValAcSeq  - Subroutine to perform the validation for the      *
      *             Account Sequence field.                           *
      *                                                               *
      *****************************************************************
     C     ValAcSeq      BEGSR

      *
      ** If entered, must be numeric
      *
     C     DDASNM        IFNE      *BLANKS
     C                   TESTN                   DDASNM               35

     C     *IN35         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0293'
     C                   EVAL      FldNamXAr (Idx) = 'DDASNM'
     C                   EVAL      DDASNMok = 'N'
     C                   ELSE
     C                   MOVEL     DDASNM        ASNM
     C                   END

     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValDelvrFm - Subroutine to perform the validation for the     *
      *              Deliver From field.                              *
      *                                                               *
      *****************************************************************
     C     ValDelvrFm    BEGSR
      *
      ** - For Complete trade (not Grey Market)
      ** - Mandatory if portfolio customer or market client if sale
      *
     C     DDINCS        IFEQ      'C'
     C     DDTDMI        ANDNE     'G'

     C     CustClass     IFEQ      'S'
     C     CustClass     OREQ      'D'
     C     CustClass     OREQ      'M'
     C     DDTDTP        ANDEQ     'TS'

     C     DDDELF        IFEQ      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0294'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
     C                   EVAL      DDDELFok = 'N'
     C                   GOTO      EValDelFm
     C                   END
     C                   END
     C                   END
      *
      ** If entered, must be a valid Customer or Shortname
      *
     C     DDDELF        IFNE      *BLANKS
     C                   MOVEL     DDDELF        WCSNM
     C                   MOVE      *BLANKS       @RTCD

     C                   EXSR      AOCUST

     C     @RTCD         IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0294'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
     C                   EVAL      DDDELFok = 'N'
     C                   GOTO      EValDelFm
     C                   ELSE
     C                   MOVE      BBCUST        WCUST
     C                   MOVE      *BLANKS       @RTCD

     C                   EXSR      AOSECS

     C     @RTCD         IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0294'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
     C                   EVAL      DDDELFok = 'N'
     C                   GOTO      EValDelFm
      *
      ** Portfolio customers are not valid for Deliver From entry.
      *
     C                   ELSE

     C     BFCLAS        IFEQ      'S'
     C     BFCLAS        OREQ      'D'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0295'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
     C                   EVAL      DDDELFok = 'N'
     C                   GOTO      EValDelFm
     C                   END

     C                   END
     C                   END
     C                   MOVE      BFCLAS        FC1DI
     C                   MOVE      BFCUST        WDELF
     C                   MOVEL     WDELF         DELF
     C                   ELSE
     C                   MOVE      *BLANK        FC1DI
     C**********         Z-ADD     *ZEROS        WDELF                                        CSD027
     C                   EVAL      WDELF = *BLANKS                                            CSD027
     C                   MOVEL     WDELF         DELF
     C                   END
      *
      ** Check combinations of clearance type/discretionary ind.
      *
     C     DDCLTY        IFEQ      '0'
     C     DDDELF        ANDNE     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0296'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
     C                   EVAL      DDDELFok = 'N'
     C                   GOTO      EValDelFm
     C                   END
      *
     C     DDCLTY        IFEQ      '1'
     C     FC1DI         ANDNE     'E'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0296'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
     C                   EVAL      DDDELFok = 'N'
     C                   GOTO      EValDelFm
     C                   END
      *
     C     DDCLTY        IFEQ      '2'

     C     DDTDTP        IFEQ      'TS'
     C     FC1DI         ANDNE     'E'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0296'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
     C                   EVAL      DDDELFok = 'N'
     C                   GOTO      EValDelFm
     C                   END
     C                   END
      *
     C     DDCLTY        IFEQ      '2'

     C     DDTDTP        IFEQ      'TP'
     C     FC1DI         ANDEQ     'E'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0296'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
     C                   EVAL      DDDELFok = 'N'
     C                   GOTO      EValDelFm
     C                   END

     C                   END
      *
     C     DDCLTY        IFEQ      '3'
     C     FC1DI         ANDNE     'C'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0296'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
     C                   EVAL      DDDELFok = 'N'
     C                   GOTO      EValDelFm
     C                   END
      *
     C     DDCLTY        IFEQ      '4'

     C     DDTDTP        IFEQ      'TS'
     C     FC1DI         ANDNE     'C'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0296'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
     C                   EVAL      DDDELFok = 'N'
     C                   GOTO      EValDelFm
     C                   END

     C                   END
      *
     C     DDCLTY        IFEQ      '4'

     C     DDTDTP        IFEQ      'TP'
     C     FC1DI         ANDEQ     'C'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0296'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
     C                   EVAL      DDDELFok = 'N'
     C                   GOTO      EValDelFm
     C                   END

     C                   END
      *
     C     DDCLTY        IFEQ      '5'
     C     DDTDTP        ANDEQ     'TS'

     C     FC1DI         IFEQ      'E'
     C     FC1DI         OREQ      'C'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0296'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
     C                   EVAL      DDDELFok = 'N'
     C                   GOTO      EValDelFm
     C                   END

     C                   END
      *
      **  Warning error if depot is not on investment type for security
      **  or there is no security reference code for the depot
      *
     C     DDTDTP        IFEQ      'TS'
      *
     C     FC1DI         IFEQ      'E'
     C     FC1DI         OREQ      'C'
     C*****FC1DI         OREQ      'K'                                                        CSE022
     C     FC1DI         OREQ      'X'
      *
      ** For Clearance Types 1 - 4, output warning message if there is
      ** no security reference code for the depot.
      *
     C     DDCLTY        IFNE      '5'

     C     WDELF         IFEQ      SDC1
     C     DASR          ANDNE     *BLANKS
     C     WDELF         OREQ      SDC2
     C     DCSR          ANDNE     *BLANKS
     C     WDELF         OREQ      SDC3
     C     DDSR          ANDNE     *BLANKS
     C                   ELSE
     C                   ADD       1             WIx
     C                   EVAL      WMsgIDXAr(WIx) = 'MMA0297'
     C                   EVAL      WFldNmXAr(WIx) = 'DDDELF'
     C                   EVAL      DDDELFok = 'W'
     C                   END

     C                   END
      *
     C                   END
     C                   END
     C/COPY WNCPYSRC,SETSETIVM2
      *
      ** If Pay Code is '1' & Clearance Type 1 - 4, Pay To (Sales)
      ** must refer to same customer as Deliver From
      ** - not if settlement method is '00'
      ** - not if settkement method is '04'
      *
     C     DDTDTP        IFEQ      'TS'

     C     DDPCOD        IFEQ      '1'
     C     DDPCOD        OREQ      '5'

     C     DDCLTY        IFGE      '1'
     C     DDCLTY        ANDLE     '4'
     C     WPAYT         ANDNE     WDELF
     C     DDSMTH        ANDNE     '00'
     C     DDSMTH        ANDNE     '04'
      *
      ** This validation for the Pay To field is palced on this
      ** subroutine to gain access on the delivery details. (Err 334)
      *
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0298'
     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
     C                   EVAL      DDPAYTok = 'N'
     C                   GOTO      EValDelFm
     C                   END

     C                   END
     C                   END
     C/COPY WNCPYSRC,SETSETIVM3

      *                                                                         CSE013
      ** If CSE013 present, call Short Position Warning module                  CSE013
     C     CSE013        IFEQ      'Y'                                          CSE013
     C     DDDELFok      ANDNE     'N'
                                                                                CSE013
     C     DDTDTP        IFEQ      'TP'                                         CSE013
     C     CustClass     ANDEQ     'S'                                          CSE013
                                                                                CSE013
     C     DDTDTP        OREQ      'TP'                                         CSE013
     C     Custclass     ANDEQ     'D'                                          CSE013
                                                                                CSE013
     C                   CALLB     'SESHPOSWN'                                  CSE013
      *                                                                         CSE013
      ** INPUTS                                                                 CSE013
      *                                                                         CSE013
      ** Return Code                                                            CSE013
     C                   PARM                    ReturnCode                     CSE013
      ** Branch Code (3A)                                                       CSE013
      ** Customer number (6A)                                                   CSE013
      ** Security Shortname (10A)                                               CSE013
      ** Nominal Amount (11P 0)                                                 CSE013
      ** Deliver From (6 0)                                                     CSE013
      ** Trade/Value Date Valuation (1A)                                        CSE013
     C                   PARM                    DDBRCD                         CSE013
     C                   PARM                    CustNum                        CSE013
     C                   PARM                    DDSESN                         CSE013
     C                   PARM                    NOML                           CSE013
     C                   PARM                    DELF                           CSE013
     C                   PARM                    BVTVDV                         CSE013
      *                                                                         CSE013
      ** OUTPUT                                                                 CSE013
      *                                                                         CSE013
     C                   PARM                    ShortFlag                      CSE013
      *                                                                         CSE013
      ** Setup Warning message                                                  CSE013
     C     ShortFlag     IFEQ      '1'                                          CSE013
     C                   ADD       1             WIx                            CSE013
     C                   EVAL      WMsgIDXAr(WIx) = 'MMA0663'                   CSE013
     C                   EVAL      WFldNmXAr(WIx) = 'DDDELF'                    CSE013
     C                   EVAL      DDDELFok = 'W'                               CSE013
     C                   ENDIF                                                  CSE013
     C                   ENDIF                                                  CSE013
      *                                                                         CSE013
      ** CSE013 End                                                             CSE013
     C                   ENDIF                                                  CSE013
                                                                                CSE013
     C     EValDelFm     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValDelvrTo - Subroutine to perform the validation for the     *
      *              Delivery To field.                               *
      *                                                               *
      *****************************************************************
     C     ValDelvrTo    BEGSR
      *
      ** - For Complete trade (not Grey Market) ..
      ** - Mandatory if portfolio customer  or market client if purchase
      *
     C     DDINCS        IFEQ      'C'
     C     DDTDMI        ANDNE     'G'

     C     CustClass     IFEQ      'S'
     C     CustClass     OREQ      'D'
     C     CustClass     OREQ      'M'
     C     DDTDTP        ANDEQ     'TP'

     C     DDDELT        IFEQ      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0299'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
     C                   EVAL      DDDELTok = 'N'
     C                   GOTO      EValDelTo
     C                   END
     C                   END
     C                   END
      *
      ** If entered, must be a valid Customer or Shortname
      *
     C     DDDELT        IFNE      *BLANKS
     C                   MOVEL     DDDELT        WCSNM
     C                   MOVE      *BLANKS       @RTCD

     C                   EXSR      AOCUST

     C     @RTCD         IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0299'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
     C                   EVAL      DDDELTok = 'N'
     C                   GOTO      EValDelTo

     C                   ELSE
     C                   MOVE      BBCUST        WCUST
     C                   MOVE      *BLANKS       @RTCD

     C                   EXSR      AOSECS

     C     @RTCD         IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0299'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
     C                   EVAL      DDDELTok = 'N'
     C                   GOTO      EValDelTo
      *
      ** Portfolio Customers are not valid for DELIVER TO.
      *
     C                   ELSE

     C     BFCLAS        IFEQ      'S'
     C     BFCLAS        OREQ      'D'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0300'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
     C                   EVAL      DDDELTok = 'N'
     C                   GOTO      EValDelTo
     C                   END

     C                   END
     C                   END

     C                   MOVE      BFCLAS        TC1DI
     C                   MOVE      BFCUST        WDELT
     C                   MOVEL     WDELT         DELT
     C                   ELSE
     C                   MOVE      *BLANK        TC1DI
     C**********         Z-ADD     *ZEROS        WDELT                                        CSD027
     C                   EVAL      WDELT = *BLANKS                                            CSD027
     C                   MOVEL     WDELT         DELT
     C                   END
      *
      ** Check combinations of clearance type/discretionary ind.
      *
     C     DDCLTY        IFEQ      '0'
     C     DDDELT        ANDNE     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0301'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
     C                   EVAL      DDDELTok = 'N'
     C                   GOTO      EValDelTo
     C                   END
      *
     C     DDCLTY        IFEQ      '1'
     C     TC1DI         ANDNE     'E'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0301'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
     C                   EVAL      DDDELTok = 'N'
     C                   GOTO      EValDelTo
     C                   END
      *
     C     DDCLTY        IFEQ      '2'
     C     DDTDTP        IFEQ      'TP'
     C     TC1DI         ANDNE     'E'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0301'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
     C                   EVAL      DDDELTok = 'N'
     C                   GOTO      EValDelTo
     C                   END
     C                   END
      *
     C     DDCLTY        IFEQ      '2'
     C     DDTDTP        ANDEQ     'TS'

     C     TC1DI         IFEQ      'E'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0301'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
     C                   EVAL      DDDELTok = 'N'
     C                   GOTO      EValDelTo
     C                   END
     C                   END
      *
     C     DDCLTY        IFEQ      '3'
     C     TC1DI         ANDNE     'C'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0301'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
     C                   EVAL      DDDELTok = 'N'
     C                   GOTO      EValDelTo
     C                   END
      *
     C     DDCLTY        IFEQ      '4'

     C     DDTDTP        IFEQ      'TP'
     C     TC1DI         ANDNE     'C'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0301'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
     C                   EVAL      DDDELTok = 'N'
     C                   GOTO      EValDelTo
     C                   END

     C                   END
      *
     C     DDCLTY        IFEQ      '4'

     C     DDTDTP        IFEQ      'TS'
     C     TC1DI         ANDEQ     'C'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0301'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
     C                   EVAL      DDDELTok = 'N'
     C                   GOTO      EValDelTo
     C                   END

     C                   END
      *
     C     DDCLTY        IFEQ      '5'
     C     DDTDTP        ANDEQ     'TP'

     C     TC1DI         IFEQ      'E'
     C     TC1DI         OREQ      'C'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0301'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
     C                   EVAL      DDDELTok = 'N'
     C                   GOTO      EValDelTo
     C                   END

     C                   END
      *
      ** Warning error if depot is not on investment type for security
      ** or there is no security reference code for the depot
      *
     C     DDTDTP        IFEQ      'TP'
      *
     C     TC1DI         IFEQ      'E'
     C     TC1DI         OREQ      'C'
     C*****TC1DI         OREQ      'K'                                                        CSE022
     C     TC1DI         OREQ      'X'
      *
      ** For Clearance Types 1 - 4, output warning message if there is
      ** no security reference code for the depot.
      *
     C     DDCLTY        IFNE      '5'

     C     WDELT         IFEQ      SDC1
     C     DASR          ANDNE     *BLANKS
     C     WDELT         OREQ      SDC2
     C     DCSR          ANDNE     *BLANKS
     C     WDELT         OREQ      SDC3
     C     DDSR          ANDNE     *BLANKS
     C                   ELSE
     C                   ADD       1             WIx
     C                   EVAL      WMsgIDXAr(WIx) = 'MMA0302'
     C                   EVAL      WFldNmXAr(WIx) = 'DDDELT'
     C                   EVAL      DDDELTok = 'W'
     C                   END

     C                   END
      *
     C                   END
     C                   END
      *
      ** If receiving from outside Euroclear/Cedel to Euroclear Pay To
      ** is mandatory
      *
     C     DDTDTP        IFEQ      'TP'
     C     TC1DI         ANDEQ     'E'
     C     FC1DI         ANDNE     'E'
     C     FC1DI         ANDNE     'C'
     C     DDSMTH        ANDEQ     '01'
     C     DDPCOD        ANDNE     '2'
     C     DDPCOD        ANDNE     '3'
     C     DDPCOD        ANDNE     '4'
      *
     C     DDPAYT        IFEQ      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0303'
     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
     C                   EVAL      DDPAYTok = 'N'
     C                   GOTO      EValDelTo
     C                   END

     C                   END
      *
      ** If Pay Code is '1' & Clearance Type 1 - 4, Pay From (Purch)
      ** must refer to same customer as Deliver To
      **  - not if settlement method is 00
      **  - not if settlement method is 04
      *
     C     DDTDTP        IFEQ      'TP'

     C/COPY WNCPYSRC,SETSETIVK3
     ** If CSE099 is switched on, ...                                                         162270
     ** For TP trades with a pay code of 1, clearance type of 3 or 4,                         162270
     ** a 'pay from' customer different to the 'delivered to' customer                        162270
     ** will be allowed to be inserted.                                                       162270
     C     WPYFM         IFNE      WDELT                                                      162270
     C     DDPCOD        ANDEQ     '1'                                                        162270
     C     DDCLTY        ANDEQ     '3'                                                        162270
     C     CSE099        ANDEQ     'Y'                                                        162270
     C     WPYFM         ORNE      WDELT                                                      162270
     C     DDPCOD        ANDEQ     '1'                                                        162270
     C     DDCLTY        ANDEQ     '4'                                                        162270
     C     CSE099        ANDEQ     'Y'                                                        162270
     C                   ELSE                                                                 162270
      *                                                                                       162270
     C     DDPCOD        IFEQ      '1'
     C     DDPCOD        OREQ      '5'

     C     DDCLTY        IFGE      '1'
     C     DDCLTY        ANDLE     '4'
     C     WPYFM         ANDNE     WDELT
     C     DDSMTH        ANDNE     '00'
     C     DDSMTH        ANDNE     '04'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0304'
     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'
     C                   EVAL      DDPYFMok = 'N'
     C                   GOTO      EValDelTo
     C                   END

     C                   END
     C/COPY WNCPYSRC,SETSETIVK5
     C                   END                                                                  162270
     C                   END
     C/COPY WNCPYSRC,SETSETIVK4

     C     EValDelTo     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValDTDF_P - Subroutine to perform the validation for the      *
      *             Delivery To and Deliver From fields - Purchases   *
      *                                                               *
      *****************************************************************
     C     ValDTDF_P     BEGSR
      *
      ** Reset Error indicator
      *
     C                   MOVE      '0'           ErrInd
      *
     C     TC1DI         IFEQ      'E'
     C     FC1DI         ANDEQ     'E'

     C     CustPNp1      IFNE      'P '

     C     ErrInd        IFNE      '1'
     C                   MOVE      '1'           ErrInd
      ** Deliver To
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0305'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
     C                   EVAL      DDDELTok = 'N'
      ** Deliver From
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0305'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
     C                   EVAL      DDDELFok = 'N'
     C                   END

     C                   END
     C                   END
      *
     C     CustPNp1      IFNE      'P '
     C     CustPNp1      ANDNE     'NP'

     C     TC1DI         IFEQ      'E'
     C     FC1DI         ANDNE     'C'

     C     ErrInd        IFNE      '1'
     C                   MOVE      '1'           ErrInd

      ** Deliver To
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0306'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
     C                   EVAL      DDDELTok = 'N'

      ** Deliver From
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0306'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
     C                   EVAL      DDDELFok = 'N'
     C                   END

     C                   END

     C                   END
      *
     C     DDCLTY        IFEQ      '5'

     C     FC1DI         IFEQ      'C'
     C     CustPNp2      ANDNE     'P '
     C     FC1DI         OREQ      'E'
     C     CustPNp1      ANDNE     'P '

     C     ErrInd        IFNE      '1'
     C                   MOVE      '1'           ErrInd
      ** Deliver From
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0307'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
     C                   EVAL      DDDELFok = 'N'
     C                   END

     C                   END
     C                   END
      *
     C     CustPNp2      IFNE      'P '

     C     FC1DI         IFEQ      'C'

     C     ErrInd        IFNE      '1'
     C                   MOVE      '1'           ErrInd
      ** Deliver To
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0308'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
     C                   EVAL      DDDELTok = 'N'

      ** Deliver From
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0308'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
     C                   EVAL      DDDELFok = 'N'
     C                   END

     C                   END
     C                   END
      *
     C     CustPNp1      IFNE      'P '

     C     FC1DI         IFEQ      'E'
     C     TC1DI         ANDEQ     'C'

     C     ErrInd        IFNE      '1'
     C                   MOVE      '1'           ErrInd

      ** Deliver To
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0309'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
     C                   EVAL      DDDELTok = 'N'

      ** Deliver From
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0309'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
     C                   EVAL      DDDELFok = 'N'
     C                   END

     C                   END
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValDTDF_S - Subroutine to perform the validation for the      *
      *             Delivery To and Deliver From fields - Sales       *
      *                                                               *
      *****************************************************************
     C     ValDTDF_S     BEGSR
      *
      ** Reset Error Indicator
      *
     C                   MOVE      '0'           ErrInd
      *
     C     TC1DI         IFEQ      'E'
     C     FC1DI         ANDEQ     'E'

     C     CustPNp1      IFNE      'P '

     C     ErrInd        IFNE      '1'
     C                   MOVE      '1'           ErrInd

      ** Deliver To
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0305'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
     C                   EVAL      DDDELTok = 'N'
      ** Deliver From
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0305'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
     C                   EVAL      DDDELFok = 'N'

     C                   END

     C                   END
     C                   END
      *
     C     CustPNp1      IFNE      'P '
     C     CustPNp1      ANDNE     'NP'

     C     FC1DI         IFEQ      'E'
     C     TC1DI         ANDNE     'C'

     C     ErrInd        IFNE      '1'
     C                   MOVE      '1'           ErrInd
      ** Deliver To
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0310'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
     C                   EVAL      DDDELTok = 'N'
      ** Deliver From
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0310'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
     C                   EVAL      DDDELFok = 'N'

     C                   END

     C                   END
     C                   END
      *
     C     CustPNp2      IFNE      'P '

     C     TC1DI         IFEQ      'C'

     C     ErrInd        IFNE      '1'
     C                   MOVE      '1'           ErrInd
      ** Deliver To
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0311'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
     C                   EVAL      DDDELTok = 'N'
      ** Deliver From
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0311'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
     C                   EVAL      DDDELFok = 'N'
     C                   END

     C                   END
     C                   END
      *
     C     CustPNp1      IFNE      'P '

     C     TC1DI         IFEQ      'E'
     C     FC1DI         ANDEQ     'C'

     C     ErrInd        IFNE      '1'
     C                   MOVE      '1'           ErrInd
      ** Deliver To
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0312'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
     C                   EVAL      DDDELTok = 'N'
      ** Deliver From
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0312'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
     C                   EVAL      DDDELFok = 'N'
     C                   END

     C                   END
     C                   END
      *
     C     DDCLTY        IFEQ      '5'

     C     TC1DI         IFEQ      'C'
     C     CustPNp2      ANDNE     'P '
     C     TC1DI         OREQ      'E'
     C     CustPNp1      ANDNE     'P '

     C     ErrInd        IFNE      '1'
     C                   MOVE      '1'           ErrInd
      ** Deliver To
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0313'
     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
     C                   EVAL      DDDELTok = 'N'
     C                   END

     C                   END
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      */EJECT**********************************************************                       CSE022
      *****************************************************************                       CSE022
      *****************************************************************                       CSE022
      **ValDTDF_K*-*Subroutine*to*perform*the*validation*for*the*******                       CSE022
      **************Delivery*To*and*Deliver*From*fields*-*KassenVerein*                       CSE022
      *****************************************************************                       CSE022
      *****************************************************************                       CSE022
     C*****ValDTDF_K     BEGSR                                                                CSE022
      *****************************************************************                       CSE022
     C*****TC1DI         IFEQ      'K'                                                        CSE022
      *****************************************************************                       CSE022
     C*****SetCcySWCY    IFNE      'DEM'                                                      CSE022
      ***Deliver*To****************************************************                       CSE022
     C**********         ADD       1             Idx                                          CSE022
     C**********         EVAL      MsgIDXAr(Idx) = 'MMA0315'                                  CSE022
     C**********         EVAL      FldNamXAr (Idx) = 'DDDELT'                                 CSE022
     C**********         EVAL      DDDELTok = 'N'                                             CSE022
     C**********         END                                                                  CSE022
      *****************************************************************                       CSE022
     C**********         END                                                                  CSE022
      *****************************************************************                       CSE022
     C*****FC1DI         IFEQ      'K'                                                        CSE022
      *****************************************************************                       CSE022
     C*****SetCcySWCY    IFNE      'DEM'                                                      CSE022
      ***Deliver*From**************************************************                       CSE022
     C**********         ADD       1             Idx                                          CSE022
     C**********         EVAL      MsgIDXAr(Idx) = 'MMA0314'                                  CSE022
     C**********         EVAL      FldNamXAr (Idx) = 'DDDELF'                                 CSE022
     C**********         EVAL      DDDELFok = 'N'                                             CSE022
     C**********         END                                                                  CSE022
      *****************************************************************                       CSE022
     C**********         END                                                                  CSE022
      *****************************************************************                       CSE022
     C**********         ENDSR                                                                CSE022
      *****************************************************************                       CSE022
      /EJECT
      *****************************************************************
      *                                                               *
      * ValFrAcDlT - Subroutine to perform the validation for the     *
      *              For Account of (Delivery To) field.              *
      *                                                               *
      *****************************************************************
     C     ValFrAcDlT    BEGSR
      *
      ** If entered, must be a valid Customer or Shortname
      *
     C     DDDTFA        IFNE      *BLANKS

     C                   MOVEL     *BLANKS       WCSNM
     C                   MOVEL     DDDTFA        WCSNM
     C                   MOVE      *BLANKS       @RTCD

     C                   EXSR      AOCUST

     C     @RTCD         IFNE      *BLANKS

     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0316'
     C                   EVAL      FldNamXAr (Idx) = 'DDDTFA'
     C                   EVAL      DDDTFAok = 'N'

     C                   ELSE

     C                   MOVE      BBCUST        WCUST
     C                   MOVE      *BLANKS       @RTCD

     C                   EXSR      AOSECS

     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     BFCUST        DTFA
     C                   MOVE      *BLANKS       DDDTFA
     C                   MOVEL     BFCUST        DDDTFA
     C                   ELSE
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0316'
     C                   EVAL      FldNamXAr (Idx) = 'DDDTFA'
     C                   EVAL      DDDTFAok = 'N'
     C                   END

     C                   END
     C                   END
      *
      ** EUCLID Changes
      *
     C     DDTDTP        IFEQ      'TP'
     C     DDDTFA        ANDNE     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0317'
     C                   EVAL      FldNamXAr (Idx) = 'DDDTFA'
     C                   EVAL      DDDTFAok = 'N'
     C                   END
      *
     C*****DDTDTP        IFEQ      'TS'                                                       225161
     C*****DDDTFA        ANDNE     *BLANKS                                                    225161
      **********                                                                              225161
     C*****DDCLTY        IFEQ      '0'                                                        225161
     C*****DDDTFA        ANDNE     *BLANKS                                                    225161
     C**********         ADD       1             Idx                                          225161
     C**********         EVAL      MsgIDXAr(Idx) = 'MMA0318'                                  225161
     C**********         EVAL      FldNamXAr (Idx) = 'DDDTFA'                                 225161
     C**********         EVAL      DDDTFAok = 'N'                                             225161
     C**********         END                                                                  225161
      **********                                                                              225161
     C*****DDCLTY        IFEQ      '1'                                                        225161
     C*****BFPNP1        ANDNE     'P '                                                       225161
     C**********         ADD       1             Idx                                          225161
     C**********         EVAL      MsgIDXAr(Idx) = 'MMA0318'                                  225161
     C**********         EVAL      FldNamXAr (Idx) = 'DDDTFA'                                 225161
     C**********         EVAL      DDDTFAok = 'N'                                             225161
     C**********         END                                                                  225161
      **********                                                                              225161
     C*****DDCLTY        IFEQ      '2'                                                        225161
      **********                                                                              225161
     C*****BFPNP1        IFNE      'P '                                                       225161
     C*****BFPNP1        ANDNE     'NP'                                                       225161
     C*****TC1DI         ANDNE     'C'                                                        225161
     C**********         ADD       1             Idx                                          225161
     C**********         EVAL      MsgIDXAr(Idx) = 'MMA0318'                                  225161
     C**********         EVAL      FldNamXAr (Idx) = 'DDDTFA'                                 225161
     C**********         EVAL      DDDTFAok = 'N'                                             225161
     C**********         END                                                                  225161
      **********                                                                              225161
     C**********         END                                                                  225161
      **********                                                                              225161
     C*****DDCLTY        IFEQ      '3'                                                        225161
     C*****BFPNP2        ANDNE     'P '                                                       225161
     C**********         ADD       1             Idx                                          225161
     C**********         EVAL      MsgIDXAr(Idx) = 'MMA0318'                                  225161
     C**********         EVAL      FldNamXAr (Idx) = 'DDDTFA'                                 225161
     C**********         EVAL      DDDTFAok = 'N'                                             225161
     C**********         END                                                                  225161
      **********                                                                              225161
     C*****DDCLTY        IFEQ      '4'                                                        225161
     C*****TC1DI         ANDEQ     'E'                                                        225161
      **********                                                                              225161
     C*****BFPNP1        IFNE      'P '                                                       225161
     C**********         ADD       1             Idx                                          225161
     C**********         EVAL      MsgIDXAr(Idx) = 'MMA0318'                                  225161
     C**********         EVAL      FldNamXAr (Idx) = 'DDDTFA'                                 225161
     C**********         EVAL      DDDTFAok = 'N'                                             225161
     C**********         END                                                                  225161
      **********                                                                              225161
     C**********         END                                                                  225161
      **********                                                                              225161
     C*****DDCLTY        IFEQ      '5'                                                        225161
      **********                                                                              225161
     C*****TC1DI         IFEQ      'C'                                                        225161
     C*****BFPNP2        ANDNE     'P '                                                       225161
     C*****TC1DI         OREQ      'E'                                                        225161
     C*****BFPNP1        ANDNE     'P '                                                       225161
     C**********         ADD       1             Idx                                          225161
     C**********         EVAL      MsgIDXAr(Idx) = 'MMA0318'                                  225161
     C**********         EVAL      FldNamXAr (Idx) = 'DDDTFA'                                 225161
     C**********         EVAL      DDDTFAok = 'N'                                             225161
     C**********         END                                                                  225161
      **********                                                                              225161
     C**********         END                                                                  225161
      **********                                                                              225161
     C**********         END                                                                  225161

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValFrAcDF - Subroutine to perform the validation for the      *
      *             For Account of (Deliver From).                    *
      *                                                               *
      *****************************************************************
     C     ValFrAcDF     BEGSR
      *
      ** If entered, must be a valid Customer or Shortname
      *
     C     DDDFFA        IFNE      *BLANKS
     C                   MOVEL     *BLANKS       WCSNM
     C                   MOVEL     DDDFFA        WCSNM
     C                   MOVE      *BLANKS       @RTCD

     C                   EXSR      AOCUST

     C     @RTCD         IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0319'
     C                   EVAL      FldNamXAr (Idx) = 'DDDFFA'
     C                   EVAL      DDDFFAok = 'N'
     C                   ELSE
     C                   MOVE      BBCUST        WCUST
     C                   MOVE      *BLANKS       @RTCD

     C                   EXSR      AOSECS

     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     BFCUST        DFFA
     C                   MOVEL     *BLANK        DDDFFA
     C                   MOVEL     BFCUST        DDDFFA
     C                   ELSE
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0319'
     C                   EVAL      FldNamXAr (Idx) = 'DDDFFA'
     C                   EVAL      DDDFFAok = 'N'
     C                   END

     C                   END
     C                   END
      *
      ** EUCLID Changes
      *
     C     DDTDTP        IFEQ      'TS'
     C     DDDFFA        ANDNE     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0320'
     C                   EVAL      FldNamXAr (Idx) = 'DDDFFA'
     C                   EVAL      DDDFFAok = 'N'
     C                   END
     C*
     C*****DDTDTP        IFEQ      'TP'                                                       225161
     C*****DDDFFA        ANDNE     *BLANKS                                                    225161
     C**********                                                                              225161
     C*****DDCLTY        IFEQ      '0'                                                        225161
     C*****DDDFFA        ANDNE     *BLANKS                                                    225161
     C**********         ADD       1             Idx                                          225161
     C**********         EVAL      MsgIDXAr(Idx) = 'MMA0321'                                  225161
     C**********         EVAL      FldNamXAr (Idx) = 'DDDFFA'                                 225161
     C**********         EVAL      DDDFFAok = 'N'                                             225161
     C**********         END                                                                  225161
     C**********                                                                              225161
     C*****DDCLTY        IFEQ      '1'                                                        225161
     C*****BFPNP1        ANDNE     'P '                                                       225161
     C**********         ADD       1             Idx                                          225161
     C**********         EVAL      MsgIDXAr(Idx) = 'MMA0321'                                  225161
     C**********         EVAL      FldNamXAr (Idx) = 'DDDFFA'                                 225161
     C**********         EVAL      DDDFFAok = 'N'                                             225161
     C**********         END                                                                  225161
     C**********                                                                              225161
     C*****DDCLTY        IFEQ      '2'                                                        225161
      **********                                                                              225161
     C*****BFPNP1        IFNE      'P '                                                       225161
     C*****BFPNP1        ANDNE     'NP'                                                       225161
     C*****FC1DI         ANDNE     'C'                                                        225161
     C**********         ADD       1             Idx                                          225161
     C**********         EVAL      MsgIDXAr(Idx) = 'MMA0321'                                  225161
     C**********         EVAL      FldNamXAr (Idx) = 'DDDFFA'                                 225161
     C**********         EVAL      DDDFFAok = 'N'                                             225161
     C**********         END                                                                  225161
      **********                                                                              225161
     C**********         END                                                                  225161
     C**********                                                                              225161
     C*****DDCLTY        IFEQ      '3'                                                        225161
     C*****BFPNP2        ANDNE     'P '                                                       225161
     C**********         ADD       1             Idx                                          225161
     C**********         EVAL      MsgIDXAr(Idx) = 'MMA0321'                                  225161
     C**********         EVAL      FldNamXAr (Idx) = 'DDDFFA'                                 225161
     C**********         EVAL      DDDFFAok = 'N'                                             225161
     C**********         END                                                                  225161
     C**********                                                                              225161
     C*****DDCLTY        IFEQ      '4'                                                        225161
     C*****FC1DI         ANDEQ     'E'                                                        225161
      **********                                                                              225161
     C*****BFPNP1        IFNE      'P '                                                       225161
     C**********         ADD       1             Idx                                          225161
     C**********         EVAL      MsgIDXAr(Idx) = 'MMA0321'                                  225161
     C**********         EVAL      FldNamXAr (Idx) = 'DDDFFA'                                 225161
     C**********         EVAL      DDDFFAok = 'N'                                             225161
     C**********         END                                                                  225161
      **********                                                                              225161
     C**********         END                                                                  225161
     C**********                                                                              225161
     C*****DDCLTY        IFEQ      '5'                                                        225161
      **********                                                                              225161
     C*****FC1DI         IFEQ      'C'                                                        225161
     C*****BFPNP2        ANDNE     'P '                                                       225161
     C*****FC1DI         OREQ      'E'                                                        225161
     C*****BFPNP1        ANDNE     'P '                                                       225161
     C**********         ADD       1             Idx                                          225161
     C**********         EVAL      MsgIDXAr(Idx) = 'MMA0321'                                  225161
     C**********         EVAL      FldNamXAr (Idx) = 'DDDFFA'                                 225161
     C**********         EVAL      DDDFFAok = 'N'                                             225161
     C**********         END                                                                  225161
      **********                                                                              225161
     C**********         END                                                                  225161
     C**********                                                                              225161
     C**********         END                                                                  225161

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValSplInst - Subroutine to perform the validation for the     *
      *              Special Instruction field.                       *
      *                                                               *
      *****************************************************************
     C     ValSplInst    BEGSR
      *
      ** Validate the format of the special instruction field
      ** for an electronic pay settlement method
      *
     C     DDTDSI        IFNE      *BLANKS

     C     DDSMTH        IFEQ      '01'
     C     DDSMTH        OREQ      '08'
     C                   MOVEA     *BLANKS       SIL
     C                   MOVEA     DDTDSI        SIL

     C                   EXSR      SEPTVS

     C     CUL           IFEQ      'E'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0652'
     C                   EVAL      FldNamXAr (Idx) = 'DDTDSI'
     C                   EVAL      DDTDSIok = 'N'
     C                   END

     C     CUL           IFEQ      'X'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0653'
     C                   EVAL      FldNamXAr (Idx) = 'DDTDSI'
     C                   EVAL      DDTDSIok = 'N'
     C                   ENDIF

     C                   END
     C                   END

      * Update trade field

     C                   MOVEL     DDTDSI        TDSI

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SEPTVS -  Subroutine to perform the primary validation for    *
      *           the special instruction field.                      *
      *                                                               *
      *****************************************************************
     C     SEPTVS        BEGSR

      *
     C                   Z-ADD     1             IdL
     C                   MOVE      *BLANK        CUL
     C                   MOVE      'F'           SSF

     C                   SETOFF                                       88
      *
      ** First position must be a '/'
      *
     C     SIL(IdL)      IFNE      '/'
     C                   MOVE      'E'           CUL
     C                   END
      *
     C                   Z-ADD     2             IdL
      *
      ** The first special instruction line cannot have '/'
      ** in position 2
      *
     C     SIL(IdL)      IFEQ      '/'
     C                   MOVE      'E'           CUL
     C                   END
      *
      ** Check the line for '8a/', where 8a represents
      ** up to eight upper case alphabetic charaters
      ** ... alphanumeric characters, if CSW201 is installed                                  CSW201
      *
     C     SSF           DOUEQ     'T'
     C     IdL           ORGT      10
     C     CUL           OREQ      'E'
      *
     C     CSW201        IFEQ      'Y'                                                        CSW201
     C     SIL(IdL)      LOOKUP    UPB                                    88                  CSW201
     C                   ELSE                                                                 CSW201
     C     SIL(IdL)      LOOKUP    UPA                                    88
     C                   ENDIF                                                                CSW201
      *
     C     *IN88         IFNE      '1'
     C                   MOVE      'E'           CUL
     C                   END
      *
     C     SIL(IdL)      IFEQ      '/'
     C                   MOVE      'T'           SSF
     C                   END
      *
     C                   ADD       1             IdL
      *
     C                   END
      *
      ** Invalid if a second slash is not found
      ** within the first ten characters of the
      ** field being checked
      *
     C     SSF           IFEQ      'F'
     C                   MOVE      'E'           CUL
     C                   END
      *
      ** Test the rest of the line for ISO format characters
      *
     C     IdL           DOUGT     35
     C     CUL           OREQ      'E'
      *
     C     SIL(IdL)      LOOKUP    SWCH                                   88
      *
     C     *IN88         IFEQ      '0'
     C                   MOVE      'E'           CUL
     C                   END
      *
     C                   ADD       1             IdL
      *
     C                   END
      *
      ** Check for "/RCB/"
      *
     C                   MOVEL     *BLANKS       USRCB
     C                   MOVEA     SIL(1)        USRCB

     C     USRCB         IFEQ      '/RCB/'
     C                   MOVE      'X'           CUL
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValClearTp - Subroutine to perform the validation for the     *
      *              Clearance Type field.                            *
      *                                                               *
      *****************************************************************
     C     ValClearTp    BEGSR
      *
      ** Clearance type
      ** must be in the range 0 - 5
      *
      ** Only if it is not a book transfer                                                   BUG2582
     C     CustClass     IFNE      'I'                                                       BUG2582
                                                                                             BUG2582
     C     DDCLTY        IFLT      '0'
     C     DDCLTY        ORGT      '5'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0654'
     C*******            EVAL      FldNamXAr (Idx) = 'DDCLTY'                   175718
     C                   EVAL      FldNamXAr (Idx) = 'DDCLTY2'                  175718
     C                   EVAL      DDCLTYok = 'N'
     C                   END
     C                   ENDIF                                                               BUG2582
      *
      **  .. if Market indicator is 'G', must be '0'
      *
     C     DDTDMI        IFEQ      'G'
     C     DDCLTY        ANDNE     '0'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0654'
     C*******            EVAL      FldNamXAr (Idx) = 'DDCLTY'                   175718
     C                   EVAL      FldNamXAr (Idx) = 'DDCLTY2'                  175718
     C                   EVAL      DDCLTYok = 'N'
     C                   END
      *
      ** .. if Market indicator is not 'G' must not be '0' for a
      **    complete trade
      *
     C     DDTDMI        IFNE      'G'
     C     DDINCS        ANDEQ     'C'
     C     DDCLTY        ANDEQ     '0'
     C     CustClass     ANDNE     'I'                                                       BUG2582
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0655'
     C*******            EVAL      FldNamXAr (Idx) = 'DDCLTY'                   175718
     C                   EVAL      FldNamXAr (Idx) = 'DDCLTY2'                  175718
     C                   EVAL      DDCLTYok = 'N'
     C                   END
      *
      * Update trade field
      *
     C                   MOVE      DDCLTY        CLTY
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValICcy72 -  Validate 'In' Currency in Field 72               *
      *                                                               *
      *****************************************************************
     C     ValICcy72     BEGSR
      *
      * It must be a valid currency
      *
     C                   MOVE      DDICCY        @AJCD
     C                   EXSR      AOCURR
     C     @RTCD         IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0664'
     C                   EVAL      FldNamXAr (Idx) = 'DDICCY'
     C                   EVAL      DDICCYok = 'N'
     C                   ENDIF
      *
      * It must be an 'in' currency
      *
     C     A6INCY        IFNE      'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0665'
     C                   EVAL      FldNamXAr (Idx) = 'DDICCY'
     C                   EVAL      DDICCYok = 'N'
     C                   ENDIF
      *
      * It must be equal to nominal currency or nominal currency
      * must equal EURO currency.
      *
     C     DDICCY        IFNE      NMCY
     C     NMCY          ANDNE     BKEURO
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0666'
     C                   EVAL      FldNamXAr (Idx) = 'DDICCY'
     C                   EVAL      DDICCYok = 'N'
     C                   ENDIF
      *
      * Settlement method must be 01 or 08.
      *
     C     DDSMTH        IFNE      '01'
     C     DDSMTH        ANDNE     '08'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0667'
     C                   EVAL      FldNamXAr (Idx) = 'DDICCY'
     C                   EVAL      DDICCYok = 'N'
     C                   ENDIF
      *
      * Update trade field
      *
     C                   MOVE      DDICCY        ICCY

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValProfitC - Subroutine to perform the validation for the     *
      *              Profit Centre field.                             *
      *                                                               *
      *****************************************************************
     C     ValProfitC    BEGSR
      *
      * Define key list for file SEPCBD
      *
     C     KLSPCB        KLIST
     C                   KFLD                    BOKC
     C                   KFLD                    BRCA
     C                   KFLD                    SESN
     C                   KFLD                    MKTI
      *
      * Define key list for file SEPCCD
      *
     C     KLSPCC        KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    BRCA
     C                   KFLD                    SESN
      *
      * Set up keys for SEPCBD and SEPCCD
      *
     C                   MOVEL     DDBPBK        BOKC
     C                   MOVEL     DDBRCD        BRCA
     C                   MOVEL     DDSESN        SESN
     C                   MOVEL     DDTDMI        MKTI
     C**********         Z-ADD     TCNR          CNUM                                         CSD027
     C                   EVAL      CNUM = TCNR                                                CSD027
      *
      *  If book position/profit centres are to be reconciled
     C*                                                                                       167488
     C*   If Profit Centre used                                                               167488
     C*   and Analytical Accounting Module is off and profit centre                           167488
     C*   blank.                                                                              167488
     C*                                                                                       167488
     C     BKPRCU        IFEQ      'Y'                                                        167488
     C     BGN0ST        ANDNE     'Y'                                                        167488
     C     DDPRFC        ANDEQ     *BLANK                                                     167488
     C*                                                                                       167488
      *
     C     BVTBRC        IFEQ      'Y'
      *
      *  Access book position profit centre record
      *
     C     KLSPCB        CHAIN     SEPCBD                             99
      *
      * If record found, default the profit cente to that on it
      *
     C     *IN99         IFEQ      '0'
     C                   MOVE      PCBK          DDPRFC
      *
      *  Else, default from the matrix
      *
     C                   ELSE
     C     BKPCDU        IFEQ      'Y'
     C                   EXSR      AOPRFM
     C     #RTCD         IFEQ      '0'
     C                   MOVE      @PRFC         DDPRFC
     C                   END
     C                   END
     C                   END
     C                   END
      *
      *  If book position/profit centres are NOT to be reconciled
      *  Only need to default if the profit centre has not been entered                       165014
      *
     C     BVTBRC        IFNE      'Y'
     C     DDPRFC        ANDEQ     *BLANK                                                     165014
      *
      *  Access customer position profit centre record
      *
     C     KLSPCC        CHAIN     SEPCCD                             99
      *
      * If record found, default the profit cente to that on it
      *
     C     *IN99         IFEQ      '0'
     C                   MOVE      PCCU          DDPRFC
      *
      *  Else, default from the matrix
      *
     C                   ELSE
     C     BKPCDU        IFEQ      'Y'
     C                   EXSR      AOPRFM
     C     #RTCD         IFEQ      '0'
     C                   MOVE      @PRFC         DDPRFC
     C                   END
     C                   END
     C                   END
     C                   END
      *
     C                   END                                                                  167488
      * Profit centre must be valid
      *
     C     DDPRFC        IFNE      *BLANK                                                     165014
     C                   EXSR      AOPRFC
     C     @RTCD         IFEQ      '*NOSEL '                                                  165014
     C                   MOVE      *BLANK        @RTCD                                        165014
     C                   MOVE      *BLANK        DDPRFC                                       165014
     C                   END                                                                  165014
     C**********         END                                                           165014 188320
      *
      * Error if not found
      *
     C     @RTCD         IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0660'
     C                   EVAL      FldNamXAr (Idx) = 'DDPRFC'
     C                   EVAL      DDPRFCok = 'N'
     C                   END
     C                   ENDIF                                                                188320
      *
      *  If book position/profit centres are to be reconciled
      *
     C     BVTBRC        IFEQ      'Y'

     C     KLSPCB        CHAIN     SEPCBD                             99
      *
      ** Error if the trade profit centre does not match
      ** the position profit centre.
      *
     C     *IN99         IFEQ      '0'
     C     DDPRFC        ANDNE     PCBK
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0661'
     C                   EVAL      FldNamXAr (Idx) = 'DDPRFC'
     C                   EVAL      DDPRFCok = 'N'
     C                   END
     C                   END
      *
      * Update trade field
      *
     C                   MOVE      DDPRFC        PRFC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValPriorit - Subroutine to perform the validation for the     *
      *              Priority field.                                  *
      *                                                               *
      *****************************************************************
     C     ValPriorit    BEGSR
      *
      ** DEFAULT to 'R' (Normal)
      *
     C     DDPRYC        IFEQ      *BLANKS
     C                   MOVE      'R'           DDPRYC
     C                   END
      *
      ** Validate priority code
      *
     C     DDPRYC        IFNE      'R'
     C     DDPRYC        ANDNE     'P'
     C     DDPRYC        ANDNE     'W'
     C     DDPRYC        ANDNE     'L'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0657'
     C                   EVAL      FldNamXAr (Idx) = 'DDPRYC'
     C                   EVAL      DDPRYCok = 'N'
     C                   END
      *
      * Update trade field
      *
     C                   MOVE      DDPRYC        PRYC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValPayCode - Subroutine to perform the validation for the     *
      *              Pay Code field.                                  *
      *                                                               *
      *****************************************************************
     C     ValPayCode    BEGSR
      *
      ** Pay code
      **    .. must be in the range 0 - 5
      *
      ** Only if it is not a book transfer                                                   BUG2582
     C     CustClass     IFNE      'I'                                                       BUG2582
                                                                                             BUG2582
     C     DDPCOD        IFLT      '0'
     C     DDPCOD        ORGT      '5'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0658'
     C                   EVAL      FldNamXAr (Idx) = 'DDPCOD'
     C                   EVAL      DDPCODok = 'N'
     C                   END
     C                   ENDIF                                                               BUG2582
      *
      **  .. if settle method is '03', pay code must be '2', '3' or '4'.
      *
     C     DDSMTH        IFEQ      '03'

     C     DDPCOD        IFNE      '2'
     C     DDPCOD        ANDNE     '3'
     C     DDPCOD        ANDNE     '4'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0658'
     C                   EVAL      FldNamXAr (Idx) = 'DDPCOD'
     C                   EVAL      DDPCODok = 'N'
     C                   END

     C                   END
      *
      * Update trade field
      *
     C                   MOVE      DDPCOD        PCOD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValAutoSet - Subroutine to perform the validation for the     *
      *              Auto-Settle indicator.                           *
      *                                                               *
      *****************************************************************
     C     ValAutoSet    BEGSR
      *
     C                   IF        CSE039 = 'Y' AND CustClass = 'M'                           CSE039
     C                             AND DDAUTS = *BLANKS                                       CSE039
                                                                                              CSE039
      ** Default the Auto-Settle indicator with the value held for the                        CSE039
      *  Depo Customer.                                                                       CSE039
      *                                                                                       CSE039
     C                   EVAL      PCUST = *BLANKS                                            CSE039
      *                                                                                       CSE039
      ** If Trade Purchase use Deliver To Customer                                            CSE039
      *  If Trade Sale use Deliver From Customer                                              CSE039
     C                   IF        DDTDTP = 'TP'                                              CSE039
     C                   IF        DDDELT <> *BLANKS                                          CSE039
     C                   MOVEL     DDDELT        PCUST                                        CSE039
     C                   ENDIF                                                                CSE039
     C                   ELSE                                                                 CSE039
     C                   IF        DDDELF <> *BLANKS                                          CSE039
     C                   MOVEL     DDDELF        PCUST                                        CSE039
     C                   ENDIF                                                                CSE039
     C                   ENDIF                                                                CSE039
      *                                                                                       CSE039
     C                   IF        PCUST <> *BLANKS                                           CSE039
     C                   CALL      'SESSIR0'                                                  CSE039
     C                   PARM                    POTYP                                        CSE039
     C                   PARM      DDBRCD        PBRCH                                        CSE039
     C                   PARM                    PCUST                                        CSE039
     C                   PARM      DDBPBK        PBOOK                                        CSE039
     C                   PARM      DDSETC        PCURR                                        CSE039
     C                   PARM      DDMRKT        PMRKT                                        CSE039
     C                   PARM      DDINVT        PINVT                                        CSE039
     C                   PARM      DDPTFR        PPTFR                                        CSE039
     C                   PARM                    PCBSTD                                       CSE039
     C                   PARM                    PCBSAD                                       CSE039
     C                   PARM      *BLANKS       PRTCD                                        CSE039
      *                                                                                       CSE039
      ** Retrieve DS for Customer.                                                            CSE039
     C                   IF        PRTCD <> '*NRF ' AND PRTCD <> '*NCRF'                      CSE039
     C     2             OCCUR     PCBSTD                                                     CSE039
     C                   IF        X1RECI = 'D'                                               CSE039
     C                   MOVE      X1SASI        DDAUTS                                       CSE039
     C                   ENDIF                                                                CSE039
     C                   ENDIF                                                                CSE039
      *                                                                                       CSE039
     C                   IF        PRTCD = '*NRF ' OR PRTCD = '*NCRF'                         CSE039
     C                             OR X1RECI <> 'D'                                           CSE039
      ** If no record found then use the Aut-Sett indicator from SDSEC                        CSE039
     C                   MOVE      PCUST         WCUST                                        CSE039
     C                   EXSR      AOSECS                                                     CSE039
     C                   MOVE      BFASIN        DDAUTS                                       CSE039
     C                   ENDIF                                                                CSE039
      *                                                                                       CSE039
     C                   ENDIF                                                                CSE039
     C                   ENDIF                                                                CSE039
      *                                                                                       CSE039
      *                                                                                       CSE039
      **  Default Auto-Settle Indicator
      *
     C     DDAUTS        IFEQ      *BLANKS
     C     DDTDMI        IFNE      'G'
     C                   MOVE      CustAuts      DDAUTS
     C                   ELSE
     C                   MOVE      'N'           DDAUTS
     C                   END
     C                   END
      *
      **  Autosettle indicator    ...  must be 'Y' or 'N'
      *
     C     DDAUTS        IFNE      'Y'
     C     DDAUTS        ANDNE     'N'
     C     CSE039        ANDEQ     'N'                                                        CSE039
     C     DDAUTS        OREQ      'Y'
     C     DDTDMI        ANDEQ     'G'
     C     CSE039        ANDEQ     'N'                                                        CSE039
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0659'
     C                   EVAL      FldNamXAr (Idx) = 'DDAUTS'
     C                   EVAL      DDAUTSok = 'N'
     C                   END
      *
     C     CSE039        IFEQ      'Y'                                                        CSE039
     C     DDAUTS        ANDNE     'Y'                                                        CSE039
     C     DDAUTS        ANDNE     'N'                                                        CSE039
     C     DDAUTS        ANDNE     'A'                                                        CSE039
     C                   ADD       1             Idx                                          CSE039
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0794'                                  CSE039
     C                   EVAL      FldNamXAr (Idx) = 'DDAUTS'                                 CSE039
     C                   EVAL      DDAUTSok = 'N'                                             CSE039
     C                   END                                                                  CSE039
      *                                                                                       CSE039
      * Update trade field
      *
     C                   MOVE      DDAUTS        AUTS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SetPrimRet - Subroutine to build the Prime Retail Account     *
      *              for Settlement method 04.                        *
      *                                                               *
      *****************************************************************
     C     SetPrimRet    BEGSR
      *
     C                   MOVEL     ACOD          WCOSQ
     C                   MOVE      ACSQ          WCOSQ
     C                   MOVEL     CNUM          WPRAC
     C                   MOVE      WCOSQ         WPRAC
      *
     C     DDTDTP        IFEQ      'TP'
     C                   MOVEL     WPRAC         PYFM
     C                   ELSE
     C                   MOVEL     WPRAC         PAYT
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DefPyFrBr -  Subroutine to perform the defaulting procedure   *
      *              for the Pay From Branch field.                   *
      *                                                               *
      *****************************************************************
     C     DefPyFrBr     BEGSR

     C     DDSMTH        IFEQ      '01'
     C     DDSMTH        OREQ      '02'
     C     DDSMTH        OREQ      '07'
     C     DDSMTH        OREQ      '08'
     C     DDSMTH        OREQ      '12'
     C                   MOVEL     A7BRCD        DDPYFB
     C                   ELSE

     C     DDSMTH        IFEQ      '14'
     C     DDSMTH        OREQ      '15'
     C                   MOVEL     BRCA          DDPYFB
     C                   ELSE

     C     DDSMTH        IFNE      '05'
     C                   MOVEL     DDBRCD        DDPYFB
     C                   END

     C                   END
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DefPytoBr -  Subroutine to perform the defaulting procedure   *
      *              for the Pay To Branch field.                     *
      *                                                               *
      *****************************************************************
     C     DefPyToBr     BEGSR

     C     DDSMTH        IFEQ      '01'
     C     DDSMTH        OREQ      '02'
     C     DDSMTH        OREQ      '07'
     C     DDSMTH        OREQ      '08'
     C     DDSMTH        OREQ      '12'
     C                   MOVEL     A7BRCD        DDPYTB
     C                   ELSE

     C     DDSMTH        IFEQ      '14'
     C     DDSMTH        OREQ      '15'
     C                   MOVEL     BRCA          DDPYTB
     C                   ELSE

     C     DDSMTH        IFNE      '05'
     C                   MOVEL     DDBRCD        DDPYTB
     C                   END

     C                   END
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AOBRCH -  Subroutine to retrieve branch details.              *
      *                                                               *
      *****************************************************************
     C     AOBRCH        BEGSR
      *
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM                    @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @DSNB
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AOCUST -  Subroutine to accsess customer details.             *
      *                                                               *
      *****************************************************************
     C     AOCUST        BEGSR

     C                   CALLB     'AOCUSTR0'
     C                   PARM                    @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WCSNM         @KEY1
     C                   PARM                    @KYST
     C     SDCUST        PARM      SDCUST        DSSDY

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AOSECS -   Subroutine to access Security Customer details     *
      *                                                               *
      *****************************************************************
     C     AOSECS        BEGSR

     C                   CALLB     'AOSECSR0'
     C                   PARM                    @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WCUST         @SCKY
     C     SDSECS        PARM      SDSECS        DSSDY

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AOCNST - Subroutine to retrieved Counterparty Nostro details. *
      *                                                               *
      *****************************************************************
     C     AOCNST        BEGSR

     C                   CALL      'AOCNSTR0'
     C                   PARM                    @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @CPNC
     C     SDCNST        PARM      SDCNST        DSFDY

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AOPRFM - Subroutine to default profit centres.                *
      *                                                               *
      *****************************************************************
     C     AOPRFM        BEGSR
      *                                                                                       167953
      ** Get account officer for matrix defaulting                                            167953
      *                                                                                       167953
     C                   MOVEL     TCNR          WCSNM                                        167953
     C                   EXSR      AOCUST                                                     167953
                                                                                              167953
     C                   MOVE      *BLANKS       @ACOC                                        167953
     C     @RTCD         IFEQ      *BLANKS                                                    167953
     C                   MOVEL     BBACOC        @ACOC                                        167953
      *                                                                                       188320
      ** Get Department code for matrix defaulting                                            188320
      *                                                                                       188320
     C                   EXSR      AOACOF                                                     188320
     C     @RTCD         IFEQ      *BLANKS                                                    188320
     C                   MOVEL     AZDPCD        @DPCD                                        188320
     C                   ENDIF                                                                188320
     C                   ENDIF                                                                167953

     C                   MOVEL     DDTDTP        @TRTY
     C                   MOVEL     TCNR          @CUST

     C                   CALL      'AOPRFMR0'
     C                   PARM      *BLANK        #RTCD             1
     C                   PARM      DDBPBK        @BKCD             2
     C                   PARM                    @TRTY             5
     C                   PARM      DDTSUB        @SBTY             2
     C                   PARM      DDBRCD        @BRCD             3
     C**********         PARM      *BLANKS       @DPCD             3                          188320
     C                   PARM                    @DPCD             3                          188320
     C                   PARM      PSUser        @USID            10
     C*******************PARM      *BLANKS       @ACOC             2                          167953
     C                   PARM                    @ACOC             2                          167953
     C                   PARM                    @CUST             6
     C                   PARM                    @PRFC             4

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AOPRFC - Subroutine to validate profit centres.               *
      *                                                               *
      *****************************************************************
     C     AOPRFC        BEGSR

     C                   CALL      'AOPRFCR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C**********         PARM      DDPRFC        @PCCD             4                          165014
     C     DDPRFC        PARM      DDPRFC        @PCCD             4                          165014
     C     SDPRFC        PARM      SDPRFC        DSFDY

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       188320
      *                                                               *                       188320
      * AOACOF - Subroutine to access Account Officer details.        *                       188320
      *                                                               *                       188320
      *****************************************************************                       188320
     C     AOACOF        BEGSR                                                                188320
                                                                                              188320
     C                   CALL      'AOACOFR0'                                                 188320
     C                   PARM      *BLANKS       @RTCD                                        188320
     C                   PARM      '*KEY   '     @OPTN                                        188320
     C                   PARM                    @ACOC             2                          188320
     C     SDACOF        PARM      SDACOF        DSFDY                                        188320
                                                                                              188320
     C                   ENDSR                                                                188320
      *****************************************************************                       188320
      /EJECT                                                                                  188320
      *****************************************************************
      *                                                               *
      * AONOST - Subroutine to retrieve Nosto Details                 *
      *                                                               *
      *****************************************************************
     C     AONOST        BEGSR

     C                   CALLB     'AONOSTR0'
     C                   PARM                    @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       P@CUST
     C                   PARM                    P@CYCD
     C                   PARM      *BLANKS       P@ACCD
     C                   PARM      *BLANKS       P@ACSN
     C                   PARM                    P@NONB
     C                   PARM      *BLANKS       P@BRCD
     C                   PARM      *BLANKS       P@CSSN
     C                   PARM      *BLANKS       P@PNOI
     C     SDNOST        PARM      SDNOST        DSFDY

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AOCURR - Subroutine to retrieve Currency Details              *
      *                                                               *
      *****************************************************************
     C     AOCURR        BEGSR

     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *inzsr        BEGSR

     C     *entry        PLIST

      * INPUTS

      * Response mode
     C                   PARM                    RespMode          1

      ** Trade Settlement Instructions
     C                   PARM                    TrSett

      ** OTHER SCREEN FIELDS
      ** Security
      ** Incomplete Ind
      ** Trade Type
      ** Book
      ** Trade Sub Type
      ** Market Indicator
      ** Booking branch
      ** Settlement Currency
      ** Market Centre                                                                        CSE039
      ** Portfolio Reference                                                                  CSE039
     C                   PARM                    DDSESN           10
     C                   PARM                    DDINCS            1
     C                   PARM                    DDTDTP            2
     C                   PARM                    DDBPBK            2
     C                   PARM                    DDTSUB            2
     C                   PARM                    DDTDMI            1
     C                   PARM                    DDBRCD            3
     C                   PARM                    DDSETC            3
     C                   PARM                    DDMRKT            2                          CSE039
     C                   PARM                    DDPTFR            4                          CSE039

      ** TRADE FIELDS
      ** Counterparty
      ** Value Date
      ** Nominal
      ***Countervalue********                                                         CGL014 BUG3145
     C                   PARM                    TCNR
     C                   PARM                    TDVD              5 0
     C                   PARM                    NOML             11 0          CSE013
     C**********         PARM                    TCTR                                 CGL014 BUG3145

      ** Nominal Currency Details
      ** Settlement Currency Details
     C                   PARM                    NomCcyDts
     C                   PARM                    SetCcyDts

      ** Security Info (from SECTYD)
      ** Nominal Currency
      ** Depot 1 Security Reference
      ** Depot 2 Security Reference
      ** Depot 3 Security Reference

     C                   PARM                    NMCY              3
     C                   PARM                    DASR             12
     C                   PARM                    DCSR             12
     C                   PARM                    DDSR             12

      ** Investment Type Info (from INVTPD)
      ** Settlement depots 1,2,3
      ** Investment Type                                                                      CSE039
     C                   PARM                    SDC1
     C                   PARM                    SDC2
     C                   PARM                    SDC3
     C                   PARM                    DDINVT            3                          CSE039
      *
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts                                       S0111

      ** ICD
      ** Multi-branching Ind
      ** Local currency
      ** System branch
      ** System location
      ** Originating branches used
      ** Originating branches v. user validation
      ** Profit centres used
      ** Profit centre defaulting
      ** Profit Centre Accounting installed
      ** Euro Currency Code
      ** Retail installed
      ** US dollar currency code
      ** Retail current a/c code
      ** Cedel currency code
      ** Euroclear currency code
      ** Trade & Book Positions Reconciliable
      ** Trade/Value Date Valuation
      ** CSE013 - Short position warning
      ** S01496 - Private Banking SE enhancements
      ** CEU005 - EMU SE Settlement Currency Conversion

     C                   PARM                    @MBIN             1
     C                   PARM                    BJLCCY            3
     C                   PARM                    BJSBRC            3
     C                   PARM                    BJSLCD            3
     C                   PARM                    BKOBRU            1
     C                   PARM                    BKOBUV            1
     C                   PARM                    BKPRCU            1
     C                   PARM                    BKPCDU            1
     C                   PARM                    BKEURO            3
     C                   PARM                    BGN0ST            1
     C                   PARM                    BGRTBN            1
     C                   PARM                    BLUSCY            3
     C**********         PARM                    BMACCD            4                          CGL029
     C                   PARM                    BMACCD                                       CGL029
     C                   PARM                    BVCCCY            3
     C                   PARM                    BVEUCY            3
     C                   PARM                    BVTBRC            1
     C                   PARM                    BVTVDV            1            CSE013
     C                   PARM                    CSE013            1            CSE013
     C                   PARM                    S01496            1
     C                   PARM                    CEU005            1
     C**********         PARM                    CGL014                               CGL014 BUG3145
      *
      * OUTPUTS
      *
      ** Trade details
      ** Originating branch
      ** Settlement Method
      ** Pay From
      ** Pay From Branch
      ** Pay To
      ** Pay To Branch
      ** For Account of (Pay to)
      ** Account Sequence Number
      ** Clearance Type
      ** Deliver to
      ** For Account of (Deliver to)
      ** Deliver From
      ** For Account of-Deliver From
      ** Special Instructions
      ** In Currency in Field 72
      ** Profit Centre
      ** Priority Code
      ** Pay Code
      ** Auto-settle Indicator
     C                   PARM                    ORBR              3
     C                   PARM                    SMTH
     C**********         PARM                    PYFM             12                          CGL029
     C                   PARM                    PYFM                                         CGL029
     C                   PARM                    PYFA              3
     C**********         PARM                    PAYT             12                          CGL029
     C                   PARM                    PAYT                                         CGL029
     C                   PARM                    PYTA              3
     C                   PARM                    TDFA              8
     C                   PARM                    ASNM
     C                   PARM                    CLTY              1
     C                   PARM                    DELT
     C                   PARM                    DTFA              8
     C                   PARM                    DELF
     C                   PARM                    DFFA              8
     C                   PARM                    TDSI             35
     C                   PARM                    ICCY              3
     C                   PARM                    PRFC              4
     C                   PARM                    PRYC              1
     C                   PARM                    PCOD              1
     C                   PARM                    AUTS              1
      *
      ** Trade Settlement Instructions OK
     C                   PARM                    OKTrSett

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
                                                                                              CSW201
     C     *LOCK         IN        LDA                                                        CSW201
     C                   EVAL      DBPGM = 'SETSETIVAL'                                       CSW201
     C                   OUT       LDA                                                        CSW201
                                                                                              CSW201
      ** Check if CSW201 - Swift 2001 Standards Update is installed                           CSW201
                                                                                              CSW201
     C                   CALL      'SWIF2001'                           9090                  CSW201
     C                   PARM      *BLANKS       WRtnCd                                       CSW201
                                                                                              CSW201
     C                   IF        *IN90 = *ON                                                CSW201
     C     *LOCK         IN        LDA                                                        CSW201
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSW201
     C                   EVAL      DBASE = 001                                                CSW201
     C                   EVAL      DBKEY = 'CSW201'                                           CSW201
     C                   OUT       LDA                                                        CSW201
     C                   EXSR      *PSSR                                                      CSW201
                                                                                              CSW201
     C                   ELSE                                                                 CSW201
     C                   IF        WRtnCd = 'CSW2001'                                         CSW201
     C                   EVAL      CSW201 = 'Y'                                               CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      CSW201 = 'N'                                               CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSE039
      ** Check if CSE039 is installed                                                         CSE039
     C                   CALL      'AOSARDR0'                                                 CSE039
     C                   PARM      *BLANKS       @RTCD             7                          CSE039
     C                   PARM      '*VERIFY'     @OPTN             7                          CSE039
     C                   PARM      'CSE039'      @SARD             6                          CSE039
      *                                                                                       CSE039
     C     @RTCD         IFEQ      *BLANKS                                                    CSE039
     C                   MOVE      'Y'           CSE039            1                          CSE039
     C                   ELSE                                                                 CSE039
     C                   MOVE      'N'           CSE039                                       CSE039
     C                   ENDIF                                                                CSE039

      ** Access SAR details file to determine if CSE099 installed.                            162270
      *                                                                                       162270
     C                   CALLB     'AOSARDR0'                                                 162270
     C                   PARM      *BLANKS       @RTCD                                        162270
     C                   PARM      '*VERIFY'     @OPTN                                        162270
     C                   PARM      'CSE099'      @SARD                                        162270
     C     SCSARD        PARM      SCSARD        DSFDY                                        162270
      *                                                                                       162270
     C     @RTCD         IFEQ      *BLANK                                                     162270
     C                   MOVEL     'Y'           CSE099            1                          162270
     C                   ELSE                                                                 162270
     C                   MOVEL     'N'           CSE099                                       162270
     C                   ENDIF                                                                162270
      *                                                                                       162270
      **--------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
     C/COPY WNCPYSRC,SETSETIVC1

     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY WNCPYSRC,SETSETIVC2
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
**   UPA   -  Valid codeword characters
ABCDEFGHIJKLMNOPQRSTUVWXYZ/
**   UPB   -  Valid codeword characters for Swift 2001                                        CSW201
ABCDEFGHIJKLMNOPQRSTUVWXYZ/0123456789                                                         CSW201
**   SWCH  -  Valid SWIFT ISO fromat characters
ABCDEFGHIJKLMNOPQRSTUVWXYZ 1234567890/-?:().,'+
