     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Caps/Cllrs/Flrs IRS Conv File to Scrn Fmt')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Module                                       *
      *                                                               *
      *  IRCACFCVT - Caps/Collars/Floors Convert File to Screen       *
      *              Format                                           *
      *                                                               *
      *  Function:  This module converts the fields of a Caps/        *
      *             Collars/Floors Deal from their format as on file  *
      *             to a screen format.                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Last Amend No. 244404             Date 13Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 BUG6472            Date 23Apr05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG5443            Date 24Feb05               *
      *                 BUG5707            Date 28Jan05               *
      *                 CAP084             Date 10Feb04               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      *                 CAP043             Date 02May02               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      *                 CAP055  *CREATE    Date 13Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  244404 - Correct formatting of Buy Out amount                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type                              *
      *  BUG6472- Added a sign field for short term rate              *
      *  CDL028 - Automatic Rate Interpolations                       *
      *  BUG5443- Apply code for CDL005 feature                       *
      *  BUG5707- Parameter mismatch                                  *
      *  CAP084 - Include Buy amount in output                        *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CAP043 - Additional APIs for IRS Schedules                   *
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  CAP056 - Automatic Authorisation of Interface deals          *
      *           (Recompile)                                         *
      *  CIR008 - FRA/IRS Deals Authorisation                         *
      *  CAP055 - Caps/Collars/Floors API                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Test Bit Result Indicator                       *
      *    02         Test Bit Result Indicator                       *
      *                                                               *
      *    LR         Last Record Indicator (program termination)     *
      *    U7 and U8  DB Error Processing Indicator                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrSetFld  - Set Output Screen Fields                         *
      *  SrFmtAmt  - Format Amount for Display                        *
      *  SrScalRat - Scale Rate                                       *
      *  SrZDate2  - Format a date for output                         *
      *  SrInit    - Initialization                                   *
      *                                                               *
      * *INZSR - Initialise                                           *
      * *PSSR - Error processing                                      *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
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
 
      ** Deal Status
     D*WDealStat*******S             24    DIM(2) CTDATA PERRCD(1)                            CIR008
     D WDealStat       S             24    DIM(5) CTDATA PERRCD(1)                            CIR008
 
      ** Deal in File Format
     D CrIRFilFmt    E DS                  EXTNAME(DEALSDG)
     D DGLCD         E                     EXTFLD(LCD)
     D WBsDayFil            2063   2126
 
      ** Deal in Screen Format
     D CrIRScnFmt    E DS                  EXTNAME(IRCACFPD)
     D WBsDayScn             205    268
 
      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for Broker Code Details
     D SDBROK        E DS                  EXTNAME(SDBROKPD)
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAP043
      ** EXTERNAL DS FOR SAR DETAILS                                                          CAP043
                                                                                              CAP043
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                 BUG5443
      ** EXTERNAL DS FOR CURRENCY DETAILS                                                    BUG5443
                                                                                             BUG5443
      ** First DS For Access Programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS For Access Programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                              CAP043
     D CIR001          S              1A                                                      CAP043
     D WUNBDP          S              1  0                                                    CAP043
     D WTNBDP          S              1  0                                                    CAP043
     D CDL028          S              1A                                                      CDL028
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input Parameters
     D PRetCodeIn      S             10A
     D PActCode        S              1A
 
      ** Switchable Feature
     D CIR005          S              1A
     D CIR006          S              1A
     D CIR008          S              1A                                                      CIR008
 
      ** Standing Data Fields
     D PDatFmtInd      S              1A
     D PPortMgmt       S              1A
 
      ** Output Parameters
     D PDealStat       S             24A
 
      ** Parameters for AOCURRR0/AOBROKR0
     D PRetrnCde       S              7A
     D POption         S              7A
     D PCurrency       S              3A
     D PBrkrCde        S              4A
 
      ** Parameter for ZDATE2
     D PZDayNo         S              5P 0
     D PZDate          S              6P 0
     D PZADate         S              7A
 
      ** Parameter for ZA0920
     D PRtCd           S             10A
     D PAmountIn       S             13P 0
     D PNbrDecPl       S              1P 0
     D PDeciSep        S              1A
     D PAmountOut      S             14A
 
      ** Parameter for ZA1150
     D P1CcyScExp      S              1S 0
     D P2CcyScExp      S              1S 0
     D PRate           S             13P 8
     D PMultDivInd     S              1A
     D PScalRate       S             13P 8
     D PInvScalRate    S             13P 8
     D PErrCode        S              1P 0
 
     D WFstDig         S              1P 0
     D WShtAve         S                   LIKE(UEINR)
 
     D POPTN           S              7A                                                      CAP043
     D PSARD           S              6A                                                      CAP043
                                                                                              CAP043
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   EXSR      SRInit
 
      ** Set output screen fields
 
     C                   EXSR      SrSetFld
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrSetFld - Set Output Screen Fields                          *
      *****************************************************************
     C     SrSetFld      BEGSR
 
      ** Action Code
 
     C                   EVAL      #0ACCD = PActCode
 
      ** Deal Number
 
     C                   MOVE      DLNO          #0DLNO
 
      ** Deal Type
 
     C                   EVAL      #0DTYP = DTYP
 
      ** Deal Sub-type
 
     C                   EVAL      #0DLST = DLST
 
      ** Deal date.
      ** Call ZDATE2 to convert date from Midas Dayno. format to
      ** DDMMYY format.
 
     C                   EVAL      PZDayNo = DDAT
     C                   EXSR      SrZDate2
     C                   MOVE      PZDate        #0DDAT
 
      ** Branch code.
 
     C                   EVAL      #0BRCA = BRCA
 
      ** Broker Code.
 
     C                   EVAL      #0BRKC = BRKC
 
      ** Brokerage amount.
 
     C                   IF        BAGE = *ZERO OR BRKC = 'TELX'
     C                             OR BRKC = 'PHON' OR BRKC = 'MAIL'
 
     C                   EVAL      #0BAGE = *BLANKS
 
     C                   ELSE
 
      ** Call Access Program to check Broker Code
 
     C                   CALL      'AOBROKR0'
     C                   PARM      '*DBERR'      PRetrnCde
     C                   PARM      '*KEY   '     POption
     C                   PARM      BRKC          PBrkrCde
     C     SDBROK        PARM      SDBROK        DSFDY
 
      ** Database error
 
     C                   IF        PRetrnCde <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'SDBROKPD'
     C                   EVAL      DBKEY  =  '*CALL'
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBPROC =  'SR/SrSetFld'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access currency for number of decimal places of broker currency.
 
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     PRetrnCde
     C                   PARM      '*KEY   '     POption
     C                   PARM      A9BRCY        PCurrency
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database error
 
     C                   IF        PRetrnCde <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'SDCURRPD'
     C                   EVAL      DBKEY  =  '*CALL'
     C                   EVAL      DBASE  =  002
     C                   EVAL      DBPROC =  'SR/SrSetFld'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If Brokerage a number, reformat
 
     C                   EVAL      PAmountIn = BAGE
     C                   Z-ADD     A6NBDP        PNbrDecPl
     C                   EXSR      SrFmtAmt
     C                   EVAL      #0BAGE = PAmountOut
     C                   ENDIF
 
      ** Linked Deal Number.
 
     C                   IF        LNKDN = *ZERO
     C                   EVAL      #0LNKD = *BLANK
     C                   ELSE
     C                   MOVE      LNKDN         #0LNKD
     C                   ENDIF
 
      ** Customer.
     C**  Customer can be displayed in cust. no. or shortname format                         BUG5443
 
     C     CustFormat    IFEQ      'N'                                                       BUG5443
     C                   MOVEL     CNUM          #0CNUM
     C                   ELSE                                                                BUG5443
     C*                                                                                      BUG5443
     C** Access customer file for shortname                                                  BUG5443
     C                   MOVEL     CNUM          @CLKEY                                      BUG5443
     C*                                                                                      BUG5443
     C                   CALLB     'AOCUSTR0'                                                BUG5443
     C                   PARM      '       '     @RTCD             7                         BUG5443
     C                   PARM      '*KEY   '     @OPTN             7                         BUG5443
     C                   PARM                    @CLKEY           10                         BUG5443
     C                   PARM      '       '     @KYSTS            7                         BUG5443
     C     SDCUST        PARM      SDCUST        DSSDY                                       BUG5443
      *  Error if not on file                                                                BUG5443
     C     @RTCD         IFNE      *BLANKS                                                   BUG5443
     C                   MOVEL     CNUM          DBKEY                                       BUG5443
     C                   MOVEL     'SDCUSTPD'    DBFILE                         *************BUG5443
     C                   MOVEL     '004'         DBASE                          * DBERR 004 *BUG5443
     C                   EXSR      *PSSR                                        *************BUG5443
     C                   ELSE                                                                BUG5443
     C                   MOVEL     BBCSSN        #0CNUM                                      BUG5443
     C                   END                                                                 BUG5443
     C*                                                                                      BUG5443
     C                   END                                                                 BUG5443
 
      ** Value date.
      ** Call ZDATE2 to convert date from Midas Dayno. format to
      ** DDMMYY format.
 
     C                   EVAL      PZDayNo = VDAT
     C                   EXSR      SrZDate2
 
     C                   MOVE      PZDate        #0VDAT
 
      ** Maturity Date.
      ** Call ZDATE2 to convert date from Midas Dayno. format to
      ** DDMMYY format.
 
     C                   EVAL      PZDayNo = MDAT
     C                   EXSR      SrZDate2
 
     C                   MOVE      PZDate        #0MDAT
 
      ** Account Sequence Number.
 
     C                   MOVE      CDAS          #0CDAS
 
      ** Currency Code.
 
     C                   EVAL      #0CUCY = UCUCY
 
      ** Deal Amount/Our Principal Amount
 
      ** Access currency for number of decimal places of deal currency.
 
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     PRetrnCde
     C                   PARM      '*KEY   '     POption
     C                   PARM      UCUCY         PCurrency
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database error
 
     C                   IF        PRetrnCde <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'SDCURRPD'
     C                   EVAL      DBKEY  =  '*CALL'
     C                   EVAL      DBASE  =  003
     C                   EVAL      DBPROC =  'SR/SrSetFld'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Format Deal Amount, using deal ccy decimal places
 
     C                   Z-ADD     UPAMT         PAmountIn
     C                   Z-ADD     A6NBDP        PNbrDecPl
     C                   EXSR      SrFmtAmt
     C                   EVAL      #0PAMT = PAmountOut
 
      ** Federal funds indicator
      ** (Federal Funds Indicator is a bit setting on DEALSDG)
 
     C                   TESTB     '2'           UDSTI                    01
     C                   IF        *IN01 = *ON
     C                   EVAL      #0FEFI = 'Y'
     C                   ELSE
     C                   EVAL      #0FEFI = *BLANK
     C                   ENDIF
 
      ** Base Currency Rate.
      ** Scale the Base Currency Exchange Rate.
 
     C                   EVAL      P1CcyScExp = A6SCEX
     C                   EVAL      P2CcyScExp = 0
     C                   EVAL      PRate = UBCXR
     C                   EVAL      PMultDivInd = 'M'
     C                   EXSR      SrScalRat
 
      ** Format the rate, using 8 decimal places
 
     C                   IF        PScalRate <> 0
     C     PScalRate     MULT      100000000     PAmountIn
     C                   Z-ADD     8             PNbrDecPl
 
      ** Fix to allow for 5 integers, if required (& only 7 decimal)
 
     C                   EVAL      WFstDig = *ZERO
     C                   MOVEL     PScalRate     WFstDig
 
     C                   IF        WFstDig <> *ZERO
     C                   EVAL      PNbrDecPl = 7
     C     PAmountIn     DIV       10            PAmountIn
     C                   ENDIF
 
     C                   EXSR      SrFmtAmt
     C                   MOVE      PAmountOut    #0BCXR
     C                   ENDIF
 
      ** Book code.
 
     C                   EVAL      #0BOKC = BOKC
 
      ** Interest Calculation Basis.
 
     C                   MOVE      UICBS         #0ICBS
 
      ** Taxable Indicator.
 
     C                   EVAL      #0TAXI = TAXI
 
      ** Profit Centre
 
     C                   EVAL      #0PRFC = PRFC
 
      ** Originating Branch
 
     C                   EVAL      #0ORBR = ORBR
 
      ** Set up Average Rate Method
 
     C                   TESTB     '3'           UDSTI                    02
     C                   IF        *IN02 = *ON
     C                   EVAL      #0AVRM = 'Y'
     C                   ELSE
     C                   TESTB     '3'           TDSTI                    02
     C                   IF        *IN02 = *ON
     C                   EVAL      #0AVRM = 'Y'
     C                   ELSE
     C                   EVAL      #0AVRM = 'N'
     C                   ENDIF
     C                   ENDIF
 
      ** FRA/IRS Buy/Sell Indicator
 
     C                   EVAL      #0BYSL = BYSL
 
     C                   IF        (DTYP = 'RP' AND BYSL = 'B')
     C                             OR (DTYP = 'RR' AND BYSL = 'B')
     C                             OR (DTYP = 'RF' AND BYSL = 'S')
 
      ** Their Base Rate Code/Type
 
     C                   MOVE      TBRTT         #0BRTT
 
      ** Their Spread/Rate.
      ** Scale the 'Their Spread Rate'.
 
     C                   IF        TRTSP = *ZERO
     C                   EVAL      #0RTSP = *BLANKS
 
     C                   ELSE
 
     C                   EVAL      P1CcyScExp = A6SCEX
     C                   EVAL      P2CcyScExp = 0
     C                   EVAL      PRate = TRTSP
     C                   EVAL      PMultDivInd = 'M'
     C                   EXSR      SrScalRat
 
      ** Format the rate, using 7 decimal places
 
     C                   IF        PScalRate <> 0
     C     PScalRate     MULT      10000000      PAmountIn
     C                   EVAL      PNbrDecPl = 7
     C                   EXSR      SrFmtAmt
     C                   MOVE      PAmountOut    #0RTSP
     C                   ENDIF
 
     C                   ENDIF
 
      ** Their Spread Indicator
 
     C                   EVAL      #0SPIN = TSPIN
 
      ** Their Rate Fix Days.
 
     C                   TESTB     '3'           TDSTI                    01
 
     C                   IF        TFRFD=*ZERO AND *IN01 = *ON
     C                   EVAL      #0FRFD = *BLANKS
     C                   ELSE
     C                   MOVE      TFRFD         #0FRFD
     C                   ENDIF
 
      ** Their Rate Change Date.
      ** Call ZDATE2 to convert date from Midas Dayno. format to
      ** DDMMYY format.
 
     C                   IF        TNICD = *ZERO
     C                   EVAL      #0NICD = *BLANKS
 
     C                   ELSE
 
     C                   EVAL      PZDayNo = TNICD
     C                   EXSR      SrZDate2
 
     C                   MOVE      PZDate        #0NICD
     C                   ENDIF
 
      ** Their Rate Change Frequency
 
     C                   EVAL      #0ICFR = TICFR
 
      ** Their Rate Change Day in Month
 
     C                   IF        TICFD = *ZERO
     C                   EVAL      #0ICFD = *BLANKS
     C                   ELSE
     C                   MOVE      TICFD         #0ICFD
     C                   ENDIF
 
      ** Their Next Interest Payment Date.
      ** Call ZDATE2 to convert date from Midas Dayno. format to
      ** DDMMYY format.
 
     C                   IF        TNIPD = *ZERO
     C                   EVAL      #0NIPD = *BLANKS
 
     C                   ELSE
 
     C                   EVAL      PZDayNo = TNIPD
     C                   EXSR      SrZDate2
 
     C                   MOVE      PZDate        #0NIPD
     C                   ENDIF
 
      ** Their Interest Payment Frequency
 
     C                   EVAL      #0IPFR = TIPFR
 
      ** Their Interest Payment Day in Month
 
     C                   IF        TIPFD = *ZERO
     C                   EVAL      #0IPFD = *BLANKS
     C                   ELSE
     C                   MOVE      TIPFD         #0IPFD
     C                   ENDIF
 
      ** Their Short Term Rate.
      ** Scale the Rate
 
      ** If Average Rate method is 'Y', display current average from
      ** Actual Average Calc. Rate field
 
     C                   IF        #0AVRM = 'Y'
     C                   EVAL      WShtAve = AACRT
 
      ** Else, display short term rate from Effective Int. Rate field
 
     C                   ELSE
     C                   EVAL      WShtAve = TEINR
     C                   ENDIF
 
     C                   IF        WShtAve = *ZERO
     C                   EVAL      #0EINR = *BLANKS
 
     C                   ELSE
 
     C                   EVAL      P1CcyScExp = A6SCEX
     C                   EVAL      P2CcyScExp = 0
     C                   EVAL      PRate = WShtAve
     C                   EVAL      PMultDivInd = 'M'
     C                   EXSR      SrScalRat
 
      ** Format the rate, using 7 decimal places
 
     C                   IF        PScalRate <> 0
     C     PScalRate     MULT      10000000      PAmountIn
     C                   EVAL      PNbrDecPl = 7
     C     PAmountIn     IFLT      0                                                         BUG6472
     C                   MULT      -1            PAmountIn                                   BUG6472
     C                   ENDIF                                                               BUG6472
     C                   EXSR      SrFmtAmt
     C                   MOVE      PAmountOut    #0EINR
     C                   ELSE
     C                   EVAL      #0EINR = *BLANKS
     C                   ENDIF
     C                   ENDIF
      *                                                                                      BUG6472
      ** Output sign of their short term interest rate                                       BUG6472
      *                                                                                      BUG6472
     C     #0EINR        IFEQ      *BLANKS                                                   BUG6472
     C                   MOVE      ' '           #0SIGN                                      BUG6472
     C                   ELSE                                                                BUG6472
      *                                                                                      BUG6472
     C     TEINR         IFLT      0                                                         BUG6472
     C                   MOVE      '-'           #0SIGN                                      BUG6472
     C                   ELSE                                                                BUG6472
     C                   MOVE      '+'           #0SIGN                                      BUG6472
     C                   ENDIF                                                               BUG6472
      *                                                                                      BUG6472
     C                   ENDIF                                                               BUG6472
                                                                                              CDL028
      ** If Automatic Rate Interpolations is ON                                               CDL028
                                                                                              CDL028
     C                   IF        CDL028 = 'Y'                                               CDL028
                                                                                              CDL028
      ** Start Date.                                                                          CDL028
      ** Call ZDATE2 to convert date from Midas Dayno. format to DDMMYY format                CDL028
                                                                                              CDL028
     C                   IF        FSTSDT = *ZERO                                             CDL028
     C                   EVAL      #0OSDT = *BLANKS                                           CDL028
                                                                                              CDL028
     C                   ELSE                                                                 CDL028
     C                   EVAL      PZDayNo = FSTSDT                                           CDL028
     C                   EXSR      SrZDate2                                                   CDL028
                                                                                              CDL028
     C                   MOVE      PZDate        #0OSDT                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** Start - 1st Term Base Rate Code                                                      CDL028
                                                                                              CDL028
     C                   IF        FSTS1B = *ZERO                                             CDL028
     C                   EVAL      #0OS1B = *BLANKS                                           CDL028
     C                   ELSE                                                                 CDL028
     C                   MOVE      FSTS1B        #0OS1B                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** Start - 1st Term End Date                                                            CDL028
      ** Call ZDATE2 to convert date from Midas Dayno. format to DDMMYY format                CDL028
                                                                                              CDL028
     C                   IF        FSTS1D = *ZERO                                             CDL028
     C                   EVAL      #0OS1D = *BLANKS                                           CDL028
                                                                                              CDL028
     C                   ELSE                                                                 CDL028
     C                   EVAL      PZDayNo = FSTS1D                                           CDL028
     C                   EXSR      SrZDate2                                                   CDL028
                                                                                              CDL028
     C                   MOVE      PZDate        #0OS1D                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** Start - 2nd Term Base Rate Code                                                      CDL028
                                                                                              CDL028
     C                   IF        FSTS2B = *ZERO                                             CDL028
     C                   EVAL      #0OS2B = *BLANKS                                           CDL028
     C                   ELSE                                                                 CDL028
     C                   MOVE      FSTS2B        #0OS2B                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** Start - 2nd Term End Date                                                            CDL028
      ** Call ZDATE2 to convert date from Midas Dayno. format to DDMMYY format                CDL028
                                                                                              CDL028
     C                   IF        FSTS2D = *ZERO                                             CDL028
     C                   EVAL      #0OS2D = *BLANKS                                           CDL028
                                                                                              CDL028
     C                   ELSE                                                                 CDL028
     C                   EVAL      PZDayNo = FSTS2D                                           CDL028
     C                   EXSR      SrZDate2                                                   CDL028
                                                                                              CDL028
     C                   MOVE      PZDate        #0OS2D                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** End Date                                                                             CDL028
      ** Call ZDATE2 to convert date from Midas Dayno. format to DDMMYY format                CDL028
                                                                                              CDL028
     C                   IF        FSTEDT = *ZERO                                             CDL028
     C                   EVAL      #0OEDT = *BLANKS                                           CDL028
                                                                                              CDL028
     C                   ELSE                                                                 CDL028
     C                   EVAL      PZDayNo = FSTEDT                                           CDL028
     C                   EXSR      SrZDate2                                                   CDL028
                                                                                              CDL028
     C                   MOVE      PZDate        #0OEDT                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** End - 1st Term Base Rate Code                                                        CDL028
                                                                                              CDL028
     C                   IF        FSTE1B = *ZERO                                             CDL028
     C                   EVAL      #0OE1B = *BLANKS                                           CDL028
     C                   ELSE                                                                 CDL028
     C                   MOVE      FSTE1B        #0OE1B                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** End - 1st Term End Date                                                              CDL028
      ** Call ZDATE2 to convert date from Midas Dayno. format to DDMMYY format                CDL028
                                                                                              CDL028
     C                   IF        FSTE1D = *ZERO                                             CDL028
     C                   EVAL      #0OE1D = *BLANKS                                           CDL028
                                                                                              CDL028
     C                   ELSE                                                                 CDL028
     C                   EVAL      PZDayNo = FSTE1D                                           CDL028
     C                   EXSR      SrZDate2                                                   CDL028
                                                                                              CDL028
     C                   MOVE      PZDate        #0OE1D                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** End - 2nd Term Base Rate Code                                                        CDL028
                                                                                              CDL028
     C                   IF        FSTE2B = *ZERO                                             CDL028
     C                   EVAL      #0OE2B = *BLANKS                                           CDL028
     C                   ELSE                                                                 CDL028
     C                   MOVE      FSTE2B        #0OE2B                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** End - 2nd Term End Date                                                              CDL028
      ** Call ZDATE2 to convert date from Midas Dayno. format to DDMMYY format                CDL028
                                                                                              CDL028
     C                   IF        FSTE2D = *ZERO                                             CDL028
     C                   EVAL      #0OE2D = *BLANKS                                           CDL028
                                                                                              CDL028
     C                   ELSE                                                                 CDL028
     C                   EVAL      PZDayNo = FSTE2D                                           CDL028
     C                   EXSR      SrZDate2                                                   CDL028
                                                                                              CDL028
     C                   MOVE      PZDate        #0OE2D                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
     C                   ENDIF                                                                CDL028
 
      ** Else, Deal has been sold.
 
     C                   ELSE
 
      ** Our Base Rate Code/Type
 
     C                   MOVE      UBRTT         #0BRTT
 
      ** Our Spread/Rate.
      ** Scale the 'Our Spread Rate'.
 
     C                   IF        URTSP = *ZERO
     C                   EVAL      #0RTSP = *BLANKS
 
     C                   ELSE
 
     C                   EVAL      P1CcyScExp = A6SCEX
     C                   EVAL      P2CcyScExp = 0
     C                   EVAL      PRate = URTSP
     C                   EVAL      PMultDivInd = 'M'
     C                   EXSR      SrScalRat
 
      ** Format the rate, using 7 decimal places
 
     C                   IF        PScalRate <> 0
     C     PScalRate     MULT      10000000      PAmountIn
     C                   EVAL      PNbrDecPl = 7
     C                   EXSR      SrFmtAmt
     C                   MOVE      PAmountOut    #0RTSP
     C                   ENDIF
 
     C                   ENDIF
 
      ** Our Spread Indicator
 
     C                   EVAL      #0SPIN = USPIN
 
      ** Our Rate Fix Days.
 
     C                   TESTB     '3'           TDSTI                    01
 
     C                   IF        UFRFD=*ZERO AND *IN01 = *ON
     C                   EVAL      #0FRFD = *BLANKS
     C                   ELSE
     C                   MOVE      UFRFD         #0FRFD
     C                   ENDIF
 
      ** Our Rate Change Date.
      ** Call ZDATE2 to convert date from Midas Dayno. format to
      ** DDMMYY format.
 
     C                   IF        UNICD = *ZERO
     C                   EVAL      #0NICD = *BLANKS
 
     C                   ELSE
 
     C                   EVAL      PZDayNo = UNICD
     C                   EXSR      SrZDate2
     C                   MOVE      PZDate        #0NICD
     C                   ENDIF
 
      ** Our Rate Change Frequency
 
     C                   EVAL      #0ICFR = UICFR
 
      ** Our Rate Change Day in Month
 
     C                   IF        UICFD = *ZERO
     C                   EVAL      #0ICFD = *BLANKS
 
     C                   ELSE
 
     C                   MOVE      UICFD         #0ICFD
     C                   ENDIF
 
      **  Our Next Interest Payment Date.
      ** Call ZDATE2 to convert date from Midas Dayno. format to
      ** DDMMYY format.
 
     C                   IF        UNIPD = *ZERO
     C                   EVAL      #0NIPD = *BLANKS
 
     C                   ELSE
 
     C                   EVAL      PZDayNo = UNIPD
     C                   EXSR      SrZDate2
 
     C                   MOVE      PZDate        #0NIPD
     C                   ENDIF
 
      ** Our Interest Payment Frequency
 
     C                   EVAL      #0IPFR = UIPFR
 
      ** Our Interest Payment Day in Month
 
     C                   IF        UIPFD = *ZERO
     C                   EVAL      #0IPFD = *BLANKS
     C                   ELSE
     C                   MOVE      UIPFD         #0IPFD
     C                   ENDIF
 
      ** Our Short Term Rate.
      ** Scale the Rate
 
      ** If Average Rate method is 'Y', display current average from
      ** Actual Average Calc. Rate field
 
     C                   IF        #0AVRM = 'Y'
     C                   EVAL      WShtAve = AACRT
 
      ** Else, display short term rate from Effective Int. Rate field
 
     C                   ELSE
     C                   EVAL      WShtAve = UEINR
     C                   ENDIF
 
     C                   IF        WShtAve = *ZERO
     C                   EVAL      #0EINR = *BLANKS
 
     C                   ELSE
     C                   EVAL      P1CcyScExp = A6SCEX
     C                   EVAL      P2CcyScExp = 0
     C                   EVAL      PRate = WShtAve
     C                   EVAL      PMultDivInd = 'M'
     C                   EXSR      SrScalRat
 
      ** Format the rate, using 7 decimal places
 
     C                   IF        PScalRate <> 0
     C     PScalRate     MULT      10000000      PAmountIn
     C                   EVAL      PNbrDecPl = 7
     C     PAmountIn     IFLT      0                                                         BUG6472
     C                   MULT      -1            PAmountIn                                   BUG6472
     C                   ENDIF                                                               BUG6472
     C                   EXSR      SrFmtAmt
     C                   MOVE      PAmountOut    #0EINR
     C                   ELSE
     C                   EVAL      #0EINR = *BLANKS
     C                   ENDIF
     C                   ENDIF
      *                                                                                      BUG6472
      ** Output sign of our short term interest rate                                         BUG6472
      *                                                                                      BUG6472
     C     #0EINR        IFEQ      *BLANKS                                                   BUG6472
     C                   MOVE      ' '           #0SIGN                                      BUG6472
     C                   ELSE                                                                BUG6472
      *                                                                                      BUG6472
     C     UEINR         IFLT      0                                                         BUG6472
     C                   MOVE      '-'           #0SIGN                                      BUG6472
     C                   ELSE                                                                BUG6472
     C                   MOVE      '+'           #0SIGN                                      BUG6472
     C                   ENDIF                                                               BUG6472
      *                                                                                      BUG6472
     C                   ENDIF                                                               BUG6472
 
      ** If Automatic Rate Interpolations is ON                                               CDL028
                                                                                              CDL028
     C                   IF        CDL028 = 'Y'                                               CDL028
                                                                                              CDL028
      ** Start Date.                                                                          CDL028
      ** Call ZDATE2 to convert date from Midas Dayno. format to DDMMYY format                CDL028
                                                                                              CDL028
     C                   EVAL      PZDayNo = FSOSDT                                           CDL028
     C                   EXSR      SrZDate2                                                   CDL028
                                                                                              CDL028
     C                   MOVE      PZDate        #0OSDT                                       CDL028
                                                                                              CDL028
      ** Start - 1st Term Base Rate Code                                                      CDL028
                                                                                              CDL028
     C                   IF        FSOS1B = *ZERO                                             CDL028
     C                   EVAL      #0OS1B = *BLANKS                                           CDL028
     C                   ELSE                                                                 CDL028
     C                   MOVE      FSOS1B        #0OS1B                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** Start - 1st Term End Date                                                            CDL028
      ** Call ZDATE2 to convert date from Midas Dayno. format to DDMMYY format                CDL028
                                                                                              CDL028
     C                   EVAL      PZDayNo = FSOS1D                                           CDL028
     C                   EXSR      SrZDate2                                                   CDL028
                                                                                              CDL028
     C                   MOVE      PZDate        #0OS1D                                       CDL028
                                                                                              CDL028
      ** Start - 2nd Term Base Rate Code                                                      CDL028
                                                                                              CDL028
     C                   IF        FSOS2B = *ZERO                                             CDL028
     C                   EVAL      #0OS2B = *BLANKS                                           CDL028
     C                   ELSE                                                                 CDL028
     C                   MOVE      FSOS2B        #0OS2B                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** Start - 2nd Term End Date                                                            CDL028
      ** Call ZDATE2 to convert date from Midas Dayno. format to DDMMYY format                CDL028
                                                                                              CDL028
     C                   EVAL      PZDayNo = FSOS2D                                           CDL028
     C                   EXSR      SrZDate2                                                   CDL028
                                                                                              CDL028
     C                   MOVE      PZDate        #0OS2D                                       CDL028
                                                                                              CDL028
      ** End Date                                                                             CDL028
      ** Call ZDATE2 to convert date from Midas Dayno. format to DDMMYY format                CDL028
                                                                                              CDL028
     C                   EVAL      PZDayNo = FSOEDT                                           CDL028
     C                   EXSR      SrZDate2                                                   CDL028
                                                                                              CDL028
     C                   MOVE      PZDate        #0OEDT                                       CDL028
                                                                                              CDL028
      ** End - 1st Term Base Rate Code                                                        CDL028
                                                                                              CDL028
     C                   IF        FSOE1B = *ZERO                                             CDL028
     C                   EVAL      #0OE1B = *BLANKS                                           CDL028
     C                   ELSE                                                                 CDL028
     C                   MOVE      FSOE1B        #0OE1B                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** End - 1st Term End Date                                                              CDL028
      ** Call ZDATE2 to convert date from Midas Dayno. format to DDMMYY format                CDL028
                                                                                              CDL028
     C                   EVAL      PZDayNo = FSOE1D                                           CDL028
     C                   EXSR      SrZDate2                                                   CDL028
                                                                                              CDL028
     C                   MOVE      PZDate        #0OE1D                                       CDL028
                                                                                              CDL028
      ** End - 2nd Term Base Rate Code                                                        CDL028
                                                                                              CDL028
     C                   IF        FSOE2B = *ZERO                                             CDL028
     C                   EVAL      #0OE2B = *BLANKS                                           CDL028
     C                   ELSE                                                                 CDL028
     C                   MOVE      FSOE2B        #0OE2B                                       CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** End - 2nd Term End Date                                                              CDL028
      ** Call ZDATE2 to convert date from Midas Dayno. format to DDMMYY format                CDL028
                                                                                              CDL028
     C                   EVAL      PZDayNo = FSOE2D                                           CDL028
     C                   EXSR      SrZDate2                                                   CDL028
                                                                                              CDL028
     C                   MOVE      PZDate        #0OE2D                                       CDL028
                                                                                              CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
     C                   ENDIF
 
      ** If Deal is a floor, do not output ceiling rate.
      **  Scale the 'Ceiling Rate'.
 
     C                   IF        CLRAT <> *ZERO AND DTYP <> 'RF'
     C                   EVAL      P1CcyScExp = A6SCEX
     C                   EVAL      P2CcyScExp = 0
     C                   EVAL      PRate = CLRAT
     C                   EVAL      PMultDivInd = 'M'
     C                   EXSR      SrScalRat
 
      ** Format the rate, using 7 decimal places
 
     C                   IF        PScalRate <> 0
     C     PScalRate     MULT      10000000      PAmountIn
     C                   EVAL      PNbrDecPl = 7
     C                   EXSR      SrFmtAmt
     C                   MOVE      PAmountOut    #0CRAT
     C                   ENDIF
     C                   ENDIF
 
      ** If deal is a cap, do not output floor rate.
      ** Scale the 'Floor Rate'.
 
     C                   IF        FLRAT <> *ZERO AND DTYP <> 'RP'
     C                   EVAL      P1CcyScExp = A6SCEX
     C                   EVAL      P2CcyScExp = 0
     C                   EVAL      PRate = FLRAT
     C                   EVAL      PMultDivInd = 'M'
     C                   EXSR      SrScalRat
 
      ** Format the rate, using 7 decimal places
 
     C                   IF        PScalRate <> 0
     C     PScalRate     MULT      10000000      PAmountIn
     C                   EVAL      PNbrDecPl = 7
     C                   EXSR      SrFmtAmt
     C                   MOVE      PAmountOut    #0FRAT
     C                   ENDIF
     C                   ENDIF
 
      ** Set up Up-front premium Value date, if CIR006 is off
 
     C                   IF        CIR006 = 'N'
     C                   IF        UPVD <> 0
     C                   EVAL      PZDayNo = UPVD
     C                   EXSR      SrZDate2
     C                   MOVE      PZDate        #0PUPVD
     C                   ELSE
     C                   EVAL      #0PUPVD = *BLANKS
     C                   ENDIF
     C                   ENDIF
 
      ** Set up Up-front premium Fee amount, if CIR006 is off
 
     C                   IF        CIR006 = 'N'
     C                   IF        UPFE <> 0
     C                   EVAL      PAmountIn = UPFE
     C                   Z-ADD     A6NBDP        PNbrDecPl
     C                   EXSR      SrFmtAmt
     C                   EVAL      #0PUPFE = PAmountOut
     C                   ELSE
     C                   EVAL      #0PUPFE = *BLANKS
     C                   ENDIF
     C                   ENDIF
 
      ** Set up text for deal status.
 
     C                   IF        RECI = 'R'
     C                   EVAL      PDealStat = WDealStat(1)
     C                   ENDIF
 
     C                   IF        RECI = 'M'
     C                   EVAL      PDealStat = WDealStat(2)
     C                   ENDIF
                                                                                              CIR008
     C                   IF        CIR008 = 'Y' AND RECI = 'D'                                CIR008
     C                   SELECT                                                               CIR008
     C                   WHEN      FIDSTS = 'C'                                               CIR008
     C                   EVAL      PDealStat = WDealStat(3)                                   CIR008
     C                   WHEN      FIDSTS = 'A'                                               CIR008
     C                   EVAL      PDealStat = WDealStat(4)                                   CIR008
     C                   WHEN      FIDSTS = 'R'                                               CIR008
     C                   EVAL      PDealStat = WDealStat(5)                                   CIR008
     C                   ENDSL                                                                CIR008
     C                   ENDIF                                                                CIR008
 
      ** If Business Day Convention enhancement is installed, move BDC
      ** fields from file to screen
 
     C                   IF        CIR005 = 'Y'
     C                   EVAL      WBsDayScn = WBsDayFil
     C                   ENDIF
                                                                                              CAP043
     C                   IF        CIR001 = 'Y'                                               CAP043
                                                                                              CAP043
      ** Convert Up-Front details to screen format                                            CAP043
                                                                                              CAP043
     C                   Z-ADD     A6NBDP        WUNBDP                                       CAP084
     C                   Z-ADD     A6NBDP        WTNBDP                                       CAP084
                                                                                              CAP084
     C     UPVD          IFNE      *ZERO                                                      CAP043
     C                   CALLB     'ZDATE2'                                                   CAP043
     C                   PARM      UPVD          PZdayNo                                      CAP043
     C                   PARM                    PDatFmtInd                                   CAP043
     C                   PARM      *ZEROS        PZDate                                       CAP043
     C                   PARM      *BLANKS       PZADate                                      CAP043
     C                   MOVE      PZDate        #0UFVD                                       CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C     UPFE          IFNE      *ZERO                                                      CAP043
     C                   Z-ADD     UPFE          PAmountIn                                    CAP043
     C                   IF        UPPR = 'P'                                                 CAP043
     C                   Z-ADD     WUNBDP        PNbrDecPl                                    CAP043
     C                   ELSE                                                                 CAP043
     C                   Z-ADD     WTNBDP        PNbrDecPl                                    CAP043
     C                   ENDIF                                                                CAP043
     C                   EXSR      SRFmtAmt                                                   CAP043
     C                   MOVE      PAmountOut    #0UFEE                                       CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   MOVE      UPPR          #0UFPR                                       CAP043
                                                                                              CAP043
      ** Convert Buy-Out details to screen format                                             CAP043
                                                                                              CAP043
     C     BOVD          IFNE      *ZERO                                                      CAP043
     C                   CALLB     'ZDATE2'                                                   CAP043
     C                   PARM      BOVD          PZdayNo                                      CAP043
     C                   PARM                    PDatFmtInd                                   CAP043
     C                   PARM      *ZEROS        PZDate                                       CAP043
     C                   PARM      *BLANKS       PZADate                                      CAP043
     C                   MOVE      PZDate        #0BOVD                                       CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C*****BOVD*         IFNE      *ZERO                                               CAP043 CAP084
     C*****BOAM*         IFNE      *ZERO                                               CAP084 244404
      * Enable formatting of Buy Out amount even if it's zero, but only when entered          244404
      * i.e. when buy out date exists                                                         244404
     C     BOVD          IFNE      *ZERO                                                      244404
     C**********         Z-ADD     BOVD          PAmountIn                             CAP043 CAP084
     C                   Z-ADD     BOAM          PAmountIn                                    CAP084
     C                   IF        BAPR = 'P'                                                 CAP043
     C                   Z-ADD     WUNBDP        PNbrDecPl                                    CAP043
     C                   ELSE                                                                 CAP043
     C                   Z-ADD     WTNBDP        PNbrDecPl                                    CAP043
     C                   ENDIF                                                                CAP043
     C                   EXSR      SRFmtAmt                                                   CAP043
     C**********         MOVE      PAmountOut    #0BOPR                                CAP043 CAP084
     C                   MOVE      PAmountOut    #0BUYA                                       CAP084
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   MOVE      BAPR          #0BOPR                                       CAP043
                                                                                              CAP043
      ** Convert Principal Change details to screen format                                    CAP043
                                                                                              CAP043
     C     UNPCD         IFNE      *ZERO                                                      CAP043
     C                   CALLB     'ZDATE2'                                                   CAP043
     C                   PARM      UNPCD         PZdayNo                                      CAP043
     C                   PARM                    PDatFmtInd                                   CAP043
     C                   PARM      *ZEROS        PZDate                                       CAP043
     C                   PARM      *BLANKS       PZADate                                      CAP043
     C                   MOVE      PZDate        #0ONPCD                                      CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   MOVE      UINPM         #0OIPM                                       CAP043
                                                                                              CAP043
     C     TNPCD         IFNE      *ZERO                                                      CAP043
     C                   CALLB     'ZDATE2'                                                   CAP043
     C                   PARM      TNPCD         PZDayNo                                      CAP043
     C                   PARM                    PDatFmtInd                                   CAP043
     C                   PARM      *ZEROS        PZDate                                       CAP043
     C                   PARM      *BLANKS       PZADate                                      CAP043
     C                   MOVE      PZDate        #0TNPCD                                      CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   MOVE      TINPM         #0TIPM                                       CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      *                                                                                       CDL038
      ** Class                                                                                CDL038
      *                                                                                       CDL038
     C                   MOVE      CLAS          #0CLAS                                       CDL038
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrFmtAmt-Format Amount For Display                           *
      *****************************************************************
     C     SrFmtAmt      BEGSR
 
     C                   CALLB     'ZA0920'
     C                   PARM      *BLANK        PRtCd
     C                   PARM                    PAmountIn
     C                   PARM                    PNbrDecPl
     C                   PARM                    PDeciSep
     C                   PARM      *BLANK        PAmountOut
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrScalRat - Scale Rate                                       *
      *****************************************************************
     C     SrScalRat     BEGSR
 
     C                   CALLB     'ZA1150'
     C                   PARM                    P1CcyScExp
     C                   PARM                    P2CcyScExp
     C                   PARM                    PRate
     C                   PARM                    PMultDivInd
     C                   PARM      *ZEROS        PScalRate
     C                   PARM      *ZEROS        PInvScalRate
     C                   PARM      *ZEROS        PErrCode
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrZDate2 - Format a date for output                          *
      *****************************************************************
     C     SrZDate2      BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PZDayNo
     C                   PARM                    PDatFmtInd
     C                   PARM      *ZEROS        PZDate
     C                   PARM      *BLANKS       PZADate
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRInit - Initialization                                      *
      *****************************************************************
     C     SRInit        BEGSR
 
      ** Blank outputs
 
     C                   EVAL      CrIRScnFmt = *BLANKS
     C                   EVAL      PDealStat = *BLANK
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Initial Processing                                  *
      *****************************************************************
     C     *INZSR        BEGSR
 
      **  Program Parameters
 
     C     *ENTRY        PLIST
 
      ** Input Parameters:
 
      ** Return Code
 
     C                   PARM                    PRetCodeIn
 
      ** Action Code
 
     C                   PARM                    PActCode
 
      ** Deal in file format
 
     C                   PARM                    CrIRFilFmt
 
      ** Switchable Features:
 
      ** FRA/IRS Business Day Convention
 
     C                   PARM                    CIR005
 
      ** Amortisation of Caps, Collars, Floors and
      ** Individual Compounding Swaps
 
     C                   PARM                    CIR006
                                                                                              CIR008
      ** FRA/IRS Deals Authorisation                                                          CIR008
                                                                                              CIR008
     C                   PARM                    CIR008                                       CIR008
 
      ** Standing Data:
 
      ** Date Format Indicator from SDBANKPD
 
     C                   PARM                    PDatFmtInd
 
      ** Portfolio Management from SDMMODPD
 
     C                   PARM                    PPortMgmt
 
      ** Decimal Separator from SDDEALPD
 
     C                   PARM                    PDeciSep
 
      ** Output Parameters:
 
      ** Deal in Screen Format
 
     C                   PARM                    CrIRScnFmt
 
      ** Deal Status
 
     C                   PARM                    PDealStat
      ***Sign*of Short Term Rate                                                     BUG5707 BUG6472
     C**********         PARM                    #0SIGN            1                 BUG5707 BUG6472
                                                                                              CAP043
      ** Access SAR details for CIR001                                                        CAP043
                                                                                              CAP043
     C                   CALLB     'AOSARDR0'                                                 CAP043
     C                   PARM      *BLANKS       PRTCD                                        CAP043
     C                   PARM      '*VERIFY'     POPTN                                        CAP043
     C                   PARM      'CIR001'      PSARD                                        CAP043
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP043
      *                                                                                       CAP043
      ** Database error                                                                       CAP043
      *                                                                                       CAP043
     C                   IF        PRTCD <> *BLANKS AND                                       CAP043
     C                             PRTCD <> '*NRF   '                                         CAP043
     C     *LOCK         IN        LDA                                                        CAP043
     C                   MOVEL     'CIR001'      DBKEY                                        CAP043
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAP043
     C                   Z-ADD     909           DBASE                                        CAP043
     C                   OUT       LDA                                                        CAP043
     C                   EXSR      *PSSR                                                      CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   IF        PRTCD = *BLANK                                             CAP043
     C                   EVAL      CIR001 = 'Y'                                               CAP043
     C                   ELSE                                                                 CAP043
     C                   EVAL      CIR001 = 'N'                                               CAP043
     C                   ENDIF                                                                CAP043
      *                                                                                      BUG5443
      ** ACCESS SAR DETAILS FOR Customer Format                                              BUG5443
      *                                                                                      BUG5443
     C                   CALLB     'AOSARDR0'                                                BUG5443
     C                   PARM      *BLANKS       PRTCD                                       BUG5443
     C                   PARM      '*VERIFY'     POPTN                                       BUG5443
     C                   PARM      'CDL005'      PSARD                                       BUG5443
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG5443
      *                                                                                      BUG5443
      * DATABASE ERROR                                                                       BUG5443
      *                                                                                      BUG5443
     C     PRTCD         IFNE      *BLANKS                                                   BUG5443
     C     PRTCD         ANDNE     '*NRF   '                                                 BUG5443
     C                   MOVEL     'CDL005'      DBKEY                                       BUG5443
     C                   MOVEL     'SCSARDPD'    DBFILE                        ************* BUG5443
     C                   MOVEL     '906'         DBASE                         * DBERR 906 * BUG5443
     C                   EXSR      *PSSR                                       ************* BUG5443
     C                   END                                                                 BUG5443
     C*                                                                                      BUG5443
     C     PRTCD         IFEQ      *BLANK                                                    BUG5443
     C                   MOVEL     'S'           CustFormat        1                         BUG5443
     C                   ELSE                                                                BUG5443
     C                   MOVEL     'N'           CustFormat                                  BUG5443
     C                   END                                                                 BUG5443
                                                                                              CDL028
      ** Access SAR details for CDL028                                                        CDL028
                                                                                              CDL028
     C                   CALLB     'AOSARDR0'                                                 CDL028
     C                   PARM      *BLANKS       PRTCD                                        CDL028
     C                   PARM      '*VERIFY'     POPTN                                        CDL028
     C                   PARM      'CDL028'      PSARD                                        CDL028
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL028
                                                                                              CDL028
     C                   IF        PRTCD = *BLANK                                             CDL028
     C                   EVAL      CDL028 = 'Y'                                               CDL028
     C                   ELSE                                                                 CDL028
     C                   EVAL      CDL028 = 'N'                                               CDL028
     C                   ENDIF                                                                CDL028
 
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
** TEXT FOR DEAL STATUS
DELETED
MATURED
COMPLETED                                                                                     CIR008
AUTHORISED                                                                                    CIR008
REQUIRES REAUTHORISATION                                                                      CIR008
