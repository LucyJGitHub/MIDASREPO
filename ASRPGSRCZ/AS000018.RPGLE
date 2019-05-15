     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Historic Market Data Maint (Screen 2)')       *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standard Module                           *
      *                                                               *
      *  AS000018 - Historic Market Data (Maint Screen 2)             *
      *                                                               *
      *  Function:  Maintenance screen for Historic Market Data       *
      *             collection which uses regression method of        *
      *             assessment.                                       *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CSE071             Date 19Jul05               *
      *                 CDL038             Date 10May05               *
      *                 226525             Date 19Apr04               *
      *                 225340             Date 10Mar04               *
      *                 225201             Date 22Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS006  *CREATE    Date 21Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  226525 - Historic collected data on I/C should be amendable. *
      *  225340 - Historic Market Data, some fields not populated     *
      *           during I/C.                                         *
      *  225201 - System dumps when 2000. is entered                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS006 - Hedge Accounting Phase B                            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FAS000018DFCF   E             WORKSTN
     F                                     SFILE(AS000018S1:WRRN)
 
      ** Hedge Transaction Details File
     FASHTRNL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Historic Market Data Files for Update
     FASDLHML2  UF A E           K DISK    INFSR(*PSSR)
     FASLEHML2  UF A E           K DISK    INFSR(*PSSR)
     FASSEHML0  UF A E           K DISK    INFSR(*PSSR)
 
      ** Historic Market Data Files for Chain Operation
     FASDLHML3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ASDLHMD0:ASDLHMD3)
 
     ** Midas DL Deals file                                                                   225340
     FDEALSL    IF   E           K DISK    IGNORE(DEALSDFF) INFSR(*PSSR)                      225340
     F                                     PREFIX(D_)                                         225340
                                                                                              225340
     ** Midas LE Loans File by Loan Number and Record Type                                    225340
     FCLOAN     IF   E           K DISK    IGNORE(CLOANZ1F) INFSR(*PSSR)                      225340
     F                                     PREFIX(L_)                                         225340
                                                                                              225340
      ** Midas SE Book Position - Trade                                                       225340
     FSECTY     IF   E           K DISK    INFSR(*PSSR)                                       225340
     F                                     PREFIX(S_)                                         225340
                                                                                              225340
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
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
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
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
 
      ** Array for manipulation of subfile
     D                 DS
     D ScreenArray                   58    DIM(1000) DESCEND
     D    ValDat                      5P 0 OVERLAY(ScreenArray:1) INZ(*ALL'0')
     D    RecId                       1A   OVERLAY(ScreenArray:4)
     D    DAmt                       23S 8 OVERLAY(ScreenArray:5)
     D    DSign                       1A   OVERLAY(ScreenArray:28)
     D    HAmt                       23S 8 OVERLAY(ScreenArray:29)
     D    HSign                       1A   OVERLAY(ScreenArray:52)
     D    DInpT                       1A   OVERLAY(ScreenArray:53)
     D    WOrigVdat                   5S 0 OVERLAY(ScreenArray:54)
 
      ** Array holding the deleted collection date not using action code 'D'
     D DelDate         S              5S 0 DIM(1000)
 
      ** Array holding the currently changed collection data record
     D DspDate         S              5S 0 DIM(1000)
 
      ** Array holding shortnames of each month
     D SSA             S              3A   DIM(12) CTDATA PERRCD(12)
 
      ** Array of Powers for Decimals Conversion
     D POWER           S             10  0 DIM(10) CTDATA PERRCD(1)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for General Ledger Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** Data Structure for Hedge Linkage File
     D ASHGLK        E DS                  EXTNAME(ASHGLKPD)
 
      ** Short Data Structure for Access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Data Structure for Access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Value Date DS
     D#1VALD           DS
     D WDay                    1      2A
     D WMonth                  3      5A
     D WYear                   6      7A
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameter
     D PReturn         S              7A
 
      ** Access Object Parameter List
     D PReturnCode     S              7A
     D POption         S              7A
     D PKey            S              3A
 
      ** ZA0840 Parameter List
     D PRetCode        S             10A
     D PAmount         S             16A
     D PNoDecimal      S              3P 0
     D PIntegers       S              3P 0
     D PMilThouID      S              1A
     D PErrCode        S              1P 0
     D PCalAmount      S             15P 0
     D PDecSeptr       S              1A
 
      ** ZA1020 Parameter List
     D PAmountIn       S             15P 0
     D PLenght         S              2P 0
     D PNoDecPl        S              1P 0
     D PThouSeptr      S              1A
     D PAmountOut      S             21A
 
      ** ZDATE1 Parameter List
     D PDDMMYY         S              6A
     D PMDayNo         S              5P 0
     D PMDayFmt        S              1A
     D PErrorFlag      S              1A
 
      ** ZDATE2 Parameter List
     D POutDate        S              5P 0
     D PValueDate      S              6P 0
     D PDDMMMYY        S              7A
 
      ** ZFREQC Parameter List
     D PFrequency      S              1A
     D PStartDate      S              5P 0
     D PCurrency       S              3A
     D PDayMonth       S              2P 0
     D PDayWeek        S              3A
     D PNxtColDay      S              4A
     D PIncldTday      S              1A
     D  PBaseDate      S              5  0
 
      ** Work Variables
     D WStartDate      S              5A
     D WRecFound       S              1A
     D WValDate        S              5P 0
     D WDtaReqd        S              4S 0
     D WNegative       S              1A
     D***WDLNO**         S              6S 0                                                  CLE148
     D WDLNO           S              6A                                                      CLE148
     D WMnth           S              2A
     D WDHIN           S              1
     D Pos             S              2S 0 INZ(1)
     D Loc             S              2S 0
     D WERRMS          S              7
     D PINKC           S              1
     D WError          S              1
     D WWithErr        S              1
     D WRRN            S              4P 0
     D W@CNT           S              4S 0
     D WArrLoc         S              4S 0
     D WSFRN           S              4P 0
     D WSESN           S             10A
     D WBRCA           S              3A
     D WBOOK           S              2A
     D WMKTI           S              1A
     D WBHTV           S              1A
     D WHSESN          S             10A
     D WHBKCD          S              2A
     D WHMKIN          S              1A
     D WHTVIN          S              1A
     D WHBRCA          S              3A
     D WHCYCD          S              3A
     D WDBRCA          S              3A
     D WDCYCD          S              3A
     D WDBKCD          S              2A
     D WModule         S              2A
     D WDMOD           S              2A
     D WHMOD           S              2A
     D WMaxRec         S              4P 0
     D WRec            S              4S 0
     D WAmount         S             21A
     D WAmountFld      S             23S 8
     D WAmtFld         S             21A
     D WAmtFld2        S             21A
     D WOutFld         S             21A
     D WPosn           S              4S 0
     D A               S              4S 0
     D B               S              4S 0
     D i               S              4S 0
     D Q               S              4S 0
     D E               S              4S 0
     D WNegPref        S              1A
     D WNegSuff        S              1A
     D WAftNeg         S             21A
     D WBefNeg         S             21A
     D WPrevAmt        S             15P 0
     D WUpdRec         S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
 
      ** Initialization
 
     C                   EXSR      SRINIT
 
      ** Get Hedge Derivative Details
 
     C                   EXSR      SRGetDervativ
 
      ** Get Hedged Item Details
 
     C                   EXSR      SRGetHedgeItm
 
      ** Load all records to array
 
     C                   EXSR      SRLoadFlToArr
 
      ** Loop until no errors encountered and F10 press.
 
     C                   DOU       WWithErr = 'N' AND
     C                             *INKJ = *ON
 
      ** Sort Array ascendingly
 
     C                   SORTA     ValDat
 
      ** Set array pointer
 
     C                   EVAL      WArrLoc = 1
 
      ** Clear program message queue
 
     C                   CALL      'ZA0250'
 
     C                   EVAL      WDtaReqd = FSDPTS
 
      ** For data type 'C' add 1 to data points required to be able
      ** to enter complete change collection data
 
     C                   IF        FSDTTP = 'C'
     C                   EVAL      WDtaReqd = WDtaReqd + 1
     C                   ENDIF
 
     C                   EVAL      POutDate = *Zeros
 
      ** Build Subfile
 
     C                   EXSR      SRBuildSF
 
      ** Update Array from records on Subfile
 
     C                   IF        *INKE = *OFF
     C                   EXSR      SRLoadSFToArr
     C                   ENDIF
 
     C                   ENDDO
 
      ** If F10 press, update file with corresponding records from array
 
     C                   IF        *INKJ = *ON
     C                   EXSR      SRUpdateFiles
 
      ** Update market value change for data type 'V' or 'C'
 
     C                   IF        FSDTTP = 'V' OR FSDTTP = 'C'
     C                   EXSR      SRUpdMktChg
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdMktChg - Update Market Value Change                     *
      *                                                               *
      *****************************************************************
 
     C     SRUpdMktChg   BEGSR
 
      ** DL module (Derivative)
 
     C                   IF        WDMOD = 'DL'
 
     C                   EVAL      WUpdRec = 'N'
     C                   EVAL      WValDate = *LOVAL
 
     C                   MOVE      #1HDNO        WDLNO
     C     DealKey       SETLL     ASDLHML2
     C                   READP     ASDLHML2
 
     C                   EVAL      i = 1
     C                   DOW       NOT %EOF(ASDLHML2) AND
     C                             WDLNO = XXDLNO  AND
     C                             FSHEDI = XXHEDI
     C                   IF        WUpdRec = 'Y'
     C                   EVAL      XXMVCA = XXMVAL - WPrevAmt
     C                   UPDATE    ASDLHMD0
     C                   ENDIF
 
     C                   EVAL      WPrevAmt = XXMVAL
 
     C                   EVAL      i = i + 1
 
     C                   READP     ASDLHML2
     C                   EVAL      WUpdRec = 'Y'
     C                   ENDDO
     C                   ENDIF
 
      ** Item
 
     C                   SELECT
 
     C                   WHEN      WHMOD = 'DL'
 
     C                   EVAL      WUpdRec = 'N'
     C                   EVAL      WValDate = *LOVAL
 
     C                   MOVE      #1HINO        WDLNO
     C     DealKey       SETLL     ASDLHML2
     C                   READP     ASDLHML2
 
     C                   EVAL      i = 1
     C                   DOW       NOT %EOF(ASDLHML2) AND
     C                             WDLNO = XXDLNO  AND
     C                             FSHEDI = XXHEDI
     C                   IF        WUpdRec = 'Y'
     C                   EVAL      XXMVCA = XXMVAL - WPrevAmt
     C                   UPDATE    ASDLHMD0
     C                   ENDIF
 
     C                   EVAL      WPrevAmt = XXMVAL
 
     C                   EVAL      i = i + 1
 
     C                   READP     ASDLHML2
     C                   EVAL      WUpdRec = 'Y'
     C                   ENDDO
 
      ** LE module
 
     C                   WHEN      WHMOD = 'LE'
 
     C                   EVAL      WUpdRec = 'N'
     C                   EVAL      WValDate = *LOVAL
 
     C                   MOVE      #1HINO        WDLNO
     C     DealKey       SETLL     ASLEHML2
     C                   READP     ASLEHML2
 
     C                   EVAL      i = 1
     C                   DOW       NOT %EOF(ASLEHML2) AND
     C                             WDLNO = XXDLNO  AND
     C                             FSHEDI = XXHEDI
     C                   IF        WUpdRec = 'Y'
     C                   EVAL      XXMVCA = XXMVAL - WPrevAmt
     C                   UPDATE    ASLEHMD0
     C                   ENDIF
 
     C                   EVAL      WPrevAmt = XXMVAL
 
     C                   EVAL      i = i + 1
 
     C                   READP     ASLEHML2
     C                   EVAL      WUpdRec = 'Y'
     C                   ENDDO
 
      ** SE module
 
     C                   WHEN      WHMOD = 'SE'
 
     C                   EVAL      WUpdRec = 'N'
     C                   EVAL      WValDate = *LOVAL
     C                   EVAL      WSESN = #1FPSE
     C                   EVAL      WBRCA = #1BRCA
     C                   EVAL      WBOOK = #1BKCD
     C                   EVAL      WMKTI = #1MKIN
     C                   EVAL      WBHTV = #1BHTV
 
     C     SecKey        SETLL     ASSEHML0
     C                   READP     ASSEHML0
 
     C                   EVAL      i = 1
     C                   DOW       NOT %EOF(ASSEHML0) AND
     C                             WSESN = XXSESN  AND
     C                             WBRCA = XXBRCA  AND
     C                             WBOOK = XXBKCD  AND
     C                             WMKTI = XXMKTI  AND
     C                             WBHTV = XXBHTV  AND
     C                             FSHEDI = XXHEDI
     C                   IF        WUpdRec = 'Y'
     C                   EVAL      XXMVCA = XXMVAL - WPrevAmt
     C                   UPDATE    ASSEHMD0
     C                   ENDIF
 
     C                   EVAL      WPrevAmt = XXMVAL
 
     C                   EVAL      i = i + 1
 
     C                   READP     ASSEHML0
     C                   EVAL      WUpdRec = 'Y'
     C                   ENDDO
 
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLoadFlToArr - Load all record from file to Array           *
      *                                                               *
      *****************************************************************
 
     C     SRLoadFlToArr BEGSR
 
     C                   CLEAR                   ScreenArray
     C                   EVAL      ValDat = *ALL'0'
     C                   EVAL      WRecFound = 'Y'
 
      ** Load Hedge Derivative Details
 
     C                   SELECT
 
      ** DL module
 
     C                   WHEN      WDMOD = 'DL'
     C                   EVAL      WValDate = *HIVAL
 
     C                   MOVE      #1HDNO        WDLNO
     C     DealKey       SETLL     ASDLHML2
     C                   READ      ASDLHML2                             0102
 
     C                   EVAL      i = 1
     C                   DOW       NOT %EOF(ASDLHML2) AND
     C                             WDLNO = XXDLNO  AND
     C                             FSHEDI = XXHEDI
 
     C                   EVAL      ValDat(i) = XXVDAT
     C                   EVAL      RecId(i) = XXRECI
     C                   EVAL      DInpT(i) = XXDTAT
 
      ** Load Hedge Derivative Amount
 
     C                   EXSR      SRSelectAmt
     C                   EVAL      DSign(i) = WNegative
     C                   EVAL      DAmt(i) = WAmountFld
 
      ** Load Hedged Item Amount
 
     C                   EXSR      SRLoadHdgItem
 
     C                   EVAL      i = i + 1
     C                   MOVE      #1HDNO        WDLNO
 
     C                   READ      ASDLHML2
     C                   ENDDO
 
     C                   ENDSL
     C                   EVAL      WRecFound = 'N'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLoadHdgItem - Load Hedge Item Details                      *
      *                                                               *
      *****************************************************************
 
     C     SRLoadHdgItem BEGSR
 
     C                   SELECT
 
      ** DL module
 
     C                   WHEN      WHMOD = 'DL'
     C                   EVAL      WValDate = XXVDAT
     C                   MOVE      #1HINO        WDLNO
 
     C     DealKey       CHAIN     ASDLHML3
     C                   IF        %FOUND(ASDLHML3)
     C                   EXSR      SRSelectAmt
     C                   EVAL      HSign(i) = WNegative
     C                   EVAL      HAmt(i) = WAmountFld
     C                   ENDIF
 
      ** LE module
 
     C                   WHEN      WHMOD = 'LE'
     C                   EVAL      WValDate = XXVDAT
     C                   MOVE      #1HINO        WDLNO
 
     C     DealKey       CHAIN     ASLEHML2
     C                   IF        %FOUND(ASLEHML2)
     C                   EXSR      SRSelectAmt
     C                   EVAL      HSign(i) = WNegative
     C                   EVAL      HAmt(i) = WAmountFld
     C                   ENDIF
 
      ** SE module
 
     C                   WHEN      WHMOD = 'SE'
     C                   EVAL      WValDate = XXVDAT
     C                   EVAL      WSESN = #1FPSE
     C                   EVAL      WBRCA = #1BRCA
     C                   EVAL      WBOOK = #1BKCD
     C                   EVAL      WMKTI = #1MKIN
     C                   EVAL      WBHTV = #1BHTV
 
     C     SecKey        CHAIN     ASSEHML0
     C                   IF        %FOUND(ASSEHML0)
     C                   EXSR      SRSelectAmt
     C                   EVAL      HSign(i) = WNegative
     C                   EVAL      HAmt(i) = WAmountFld
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdateFiles - Update Files from details in Array           *
      *                                                               *
      *****************************************************************
 
     C     SRUpdateFiles BEGSR
 
      ** Update those deleted not using action code 'D'
 
     C                   EVAL      i = 1
     C                   DOW       i < 1001 AND
     C                             DelDate(i) <> *Zeros
 
     C                   EVAL      WValDate = DelDate(i)
 
     C                   MOVE      #1HDNO        WDLNO
     C     DealKey       CHAIN     ASDLHML2
 
     C                   IF        %FOUND(ASDLHML2)
     C                   EVAL      XXRECI = '*'
     C                   EVAL      XXCHTP = 'D'
     C                   EVAL      XXLCD = BJRDNB
     C                   UPDATE    ASDLHMD0
     C                   ENDIF
 
     C                   SELECT
 
     C                   WHEN      WHMOD = 'DL'
 
     C                   MOVE      #1HINO        WDLNO
     C     DealKey       CHAIN     ASDLHML2
 
     C                   IF        %FOUND(ASDLHML2)
     C                   EVAL      XXRECI = '*'
     C                   EVAL      XXCHTP = 'D'
     C                   EVAL      XXLCD = BJRDNB
     C                   UPDATE    ASDLHMD0
     C                   ENDIF
 
     C                   WHEN      WHMOD = 'LE'
 
     C                   MOVE      #1HINO        WDLNO
     C     DealKey       CHAIN     ASLEHML2
 
     C                   IF        %FOUND(ASLEHML2)
     C                   EVAL      XXRECI = '*'
     C                   EVAL      XXCHTP = 'D'
     C                   EVAL      XXLCD = BJRDNB
     C                   UPDATE    ASLEHMD0
     C                   ENDIF
 
     C                   WHEN      WHMOD = 'SE'
     C                   EVAL      WSESN = #1FPSE
     C                   EVAL      WBRCA = #1BRCA
     C                   EVAL      WBOOK = #1BKCD
     C                   EVAL      WMKTI = #1MKIN
     C                   EVAL      WBHTV = #1BHTV
 
     C     SecKey        CHAIN     ASSEHML0
 
     C                   IF        %FOUND(ASSEHML0)
     C                   EVAL      XXRECI = '*'
     C                   EVAL      XXCHTP = 'D'
     C                   EVAL      XXLCD = BJRDNB
     C                   UPDATE    ASSEHMD0
     C                   ENDIF
 
     C                   ENDSL
 
     C                   EVAL      i = i + 1
     C                   ENDDO
 
     C                   EVAL      i = 1
     C                   DOW       i < 1001 AND
     C                             ValDat(i) <> *Zeros
 
      ** Load Hedge Derivative
 
     C                   MOVE      #1HDNO        WDLNO
     C                   EVAL      WModule = WDMOD
     C                   EVAL      WAmountFld = DAmt(i)
     C                   IF        DSign(i) = 'Y'
     C                   EVAL      WAmountFld = WAmountFld * -1
     C                   ENDIF
 
     C                   EVAL      XXBRCA = WDBRCA
     C                   EVAL      XXCCY = WDCYCD
     C                   EVAL      XXBKCD = WDBKCD
     C                   EXSR      SRLoadToFile
 
      ** Load Hedged Item
 
     C                   EVAL      XXBRCA = WHBRCA
     C                   EVAL      XXCCY = WHCYCD
     C                   EVAL      XXBKCD = WHBKCD
 
     C                   SELECT
     C                   WHEN      WHMOD = 'DL' OR WHMOD = 'LE'
     C                   MOVE      #1HINO        WDLNO
 
     C                   WHEN      WHMOD = 'SE'
     C                   EVAL      WValDate = XXVDAT
     C                   EVAL      WSESN = WHSESN
     C                   EVAL      WBRCA = WHBRCA
     C                   EVAL      WBOOK = WHBKCD
     C                   EVAL      WMKTI = WHMKIN
     C                   EVAL      WBHTV = WHTVIN
 
     C                   ENDSL
 
     C                   EVAL      WAmountFld = HAmt(i)
     C                   IF        HSign(i) = 'Y'
     C                   EVAL      WAmountFld = WAmountFld * -1
     C                   ENDIF
     C                   EVAL      WModule = WHMOD
     C                   EXSR      SRLoadToFile
 
     C                   EVAL      i = i + 1
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPopulate - Populate Market Data Historic Files             *
      *                                                               *
      *****************************************************************
 
     C     SRPopulate    BEGSR
 
      ** Record ID, Data Type, Value Date
 
     C                   EVAL      XXRECI = RecId(i)
     C                   EVAL      XXHEDI = FSHEDI
     C                   EVAL      XXCHTP = 'I'
     C                   EVAL      XXLCD = BJRDNB
     C                   EVAL      XXVDAT = WValDate
 
     C                   IF        DInpt(i) = *Blanks
     C                   EVAL      XXDTAT = 'P'
     C                   ELSE
     C                   EVAL      XXDTAT = DInpt(i)
     C                   ENDIF
 
      ** Remove commas from Amount fields
 
     C                   EXSR      SRRemoveCom
     C                   EVAL      XXMVAL = *ZEROS
     C                   EVAL      XXMVCA = *ZEROS
     C                   EVAL      XXMRAT = *ZEROS
 
      ** Amount
 
     C                   SELECT
     C                   WHEN      FSDTTP = 'V'
     C                   EVAL      XXMVAL = WAmountFld
     C                   WHEN      FSDTTP = 'C'
     C                   EVAL      XXMVAL = WAmountFld
     C                   EVAL      XXMVCA = *ZERO
     C                   WHEN      FSDTTP = 'R'
     C                   EVAL      XXMRAT = WAmountFld
     C                   ENDSL
 
      ** For SE, move Security Shortname, Market Indicator, Trade/Value Basis
 
     C                   IF        WModule = 'SE'
     C                   EVAL      XXSESN = WHSESN
     C                   EVAL      XXMKTI = WHMKIN
     C                   EVAL      XXBHTV = WHTVIN
     C     WSESN         CHAIN     SECTY                                                      225340
     C                   IF        %FOUND(SECTY)                                              225340
     C                   EVAL      XXCCY = S_NMCY                                             225340
     C                   ENDIF                                                                225340
 
      ** For DL or SE, move deal number
 
     C                   ELSE
     C                   EVAL      XXDLNO = WDLNO
     C                   IF        WModule = 'LE'                                             225340
     C     WDLNO         CHAIN     CLOAN                                                      225340
     C                   IF        %FOUND(CLOAN)                                              225340
     C                   EVAL      XXCCY = L_CCY                                              225340
     C                   EVAL      XXBRCA = L_BRCA                                            225340
     C                   EVAL      XXBKCD = L_BOKC                                            225340
     C                   ENDIF                                                                225340
     C                   ELSE                                                                 225340
     C                   IF        WModule = 'DL'                                             225340
     C*****WDLNO         CHAIN     DEALSL                                              225340 CLE148
     C                   MOVEL     WDLNO         WDLNO2            6 0                        CLE148
     C     WDLNO2        CHAIN     DEALSL                                                     CLE148
     C                   IF        %FOUND(DEALSL)                                             225340
     C                   SELECT                                                               225340
     C                   WHEN      D_RCDT = 'G'                                               225340
     C                   IF        FSHSID = 'T'                                               225340
     C                   EVAL      XXCCY = D_TCUCY                                            225340
     C                   ELSE                                                                 225340
     C                   EVAL      XXCCY = D_UCUCY                                            225340
     C                   ENDIF                                                                225340
     C                   OTHER                                                                225340
     C                   EVAL      XXCCY = D_CCY                                              225340
     C                   ENDSL                                                                225340
                                                                                              225340
     C                   EVAL      XXBRCA = D_BRCA                                            225340
     C                   EVAL      XXBKCD = D_BOKC                                            225340
     C                   ENDIF                                                                225340
     C                   ENDIF                                                                225340
     C                   ENDIF                                                                225340
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLoadToFile - Load Array to File                            *
      *                                                               *
      *****************************************************************
 
     C     SRLoadToFile  BEGSR
 
     C                   EVAL      WValDate = ValDat(i)
 
     C                   SELECT
 
      ** Dealing Transaction
 
     C                   WHEN      WModule = 'DL'
 
     C     DealKey       CHAIN     ASDLHML2
     C                   IF        %FOUND(ASDLHML2)
 
     C                   IF        RecId(i) = '*'
     C                   EVAL      XXRECI = '*'
     C                   EVAL      XXCHTP = 'D'
     C                   EVAL      XXLCD = BJRDNB
     C                   ELSE
 
     C                   EVAL      XXMVAL = *ZEROS
     C                   EVAL      XXMVCA = *ZEROS
     C                   EVAL      XXMRAT = *ZEROS
     C                   SELECT
     C                   WHEN      FSDTTP = 'V'
     C                   EVAL      XXMVAL = WAmountFld
     C                   WHEN      FSDTTP = 'C'
     C                   EVAL      XXMVAL = WAmountFld
     C                   EVAL      XXMVCA = *ZERO
     C                   WHEN      FSDTTP = 'R'
     C                   EVAL      XXMRAT = WAmountFld
     C                   ENDSL
 
     C                   ENDIF
     C                   UPDATE    ASDLHMD0
 
     C                   ELSE
     C                   EXSR      SRPopulate
     C                   WRITE     ASDLHMD0
     C                   ENDIF
 
      ** Lending Transaction
 
     C                   WHEN      WModule = 'LE'
 
     C     DealKey       CHAIN     ASLEHML2
     C                   IF        %FOUND(ASLEHML2)
 
     C                   IF        RecId(i) = '*'
     C                   EVAL      XXRECI = '*'
     C                   EVAL      XXCHTP = 'D'
     C                   EVAL      XXLCD = BJRDNB
     C                   ELSE
 
     C                   EVAL      XXMVAL = *ZEROS
     C                   EVAL      XXMVCA = *ZEROS
     C                   EVAL      XXMRAT = *ZEROS
     C                   SELECT
     C                   WHEN      FSDTTP = 'V'
     C                   EVAL      XXMVAL = WAmountFld
     C                   WHEN      FSDTTP = 'C'
     C                   EVAL      XXMVAL = WAmountFld
     C                   EVAL      XXMVCA = *ZERO
     C                   WHEN      FSDTTP = 'R'
     C                   EVAL      XXMRAT = WAmountFld
     C                   ENDSL
 
     C                   ENDIF
     C                   UPDATE    ASLEHMD0
 
     C                   ELSE
     C                   EXSR      SRPopulate
     C                   WRITE     ASLEHMD0
     C                   ENDIF
 
      ** Securities Transaction
 
     C                   WHEN      WModule = 'SE'
 
     C     SecKey        CHAIN     ASSEHML0
     C                   IF        %FOUND(ASSEHML0)
 
     C                   IF        RecId(i) = '*'
     C                   EVAL      XXRECI = '*'
     C                   EVAL      XXCHTP = 'D'
     C                   EVAL      XXLCD = BJRDNB
     C                   ELSE
 
     C                   EVAL      XXMVAL = *ZEROS
     C                   EVAL      XXMVCA = *ZEROS
     C                   EVAL      XXMRAT = *ZEROS
     C                   SELECT
     C                   WHEN      FSDTTP = 'V'
     C                   EVAL      XXMVAL = WAmountFld
     C                   WHEN      FSDTTP = 'C'
     C                   EVAL      XXMVAL = WAmountFld
     C                   EVAL      XXMVCA = *ZERO
     C                   WHEN      FSDTTP = 'R'
     C                   EVAL      XXMRAT = WAmountFld
     C                   ENDSL
 
     C                   ENDIF
     C                   UPDATE    ASSEHMD0
 
     C                   ELSE
     C                   EXSR      SRPopulate
     C                   WRITE     ASSEHMD0
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBuildSF - Build subfile details                            *
      *                                                               *
      *****************************************************************
 
     C     SRBuildSF     BEGSR
 
      **  Initialise subfile relative record number.
 
     C                   IF        WWithErr = 'N'
     C                   Z-ADD     0             WRRN
     C                   Z-ADD     0             WMaxRec
 
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
 
     C                   EVAL      *IN97 = *ON
     C                   WRITE     AS000018C1
     C                   EVAL      *IN97 = *OFF
     C                   ENDIF
 
      **  Set on ROLLUP indicator to drive initial loop.
 
     C                   EVAL      *IN98 = *ON
 
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Stay on screen while error exist
 
     C                   DOW       *IN98 = *ON OR
     C                             WWithErr = 'Y'
 
      **  Initialise count of records written to subfile page.
 
     C                   EVAL      *IN96 = *OFF
     C                   EVAL      W@CNT = 0
     C                   EVAL      WRRN = WMaxRec
 
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
 
     C                   DOW       WDtaReqd > 0
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             WRRN
     C                   ADD       1             W@CNT
     C                   ADD       1             WMaxRec
 
      ** Move Array to Screen fields
 
     C                   EXSR      SRLoadArrScr
 
     C                   IF        WWithErr = 'N'
     C                   EVAL      #1SFRN = 1
     C                   ENDIF
 
     C                   WRITE     AS000018S1
 
     C                   EVAL      WDtaReqd = WDtaReqd - 1
     C                   ENDDO
 
      ** Write footer and message subfile
 
     C                   EXSR      SRWriteEndSF
 
      **  If there is no data to display, set on SFLCLR condition and
      **  write the subfile control record.  Dont do this if error exist.
 
     C                   IF        W@CNT = 0 AND
     C                             WWithErr = 'N'
     C                   EVAL      *IN97 = *ON
     C                   WRITE     AS000018C1
     C                   EVAL      *IN97 = *OFF
     C                   EVAL      WRRN  = 1
     C                   EVAL      #1SFRN = 1
 
      **  write to the subfile with non-display set on
 
     C                   EVAL      *IN93 = *ON
     C                   EVAL      *IN87 = *ON
     C                   EVAL      *IN88 = *ON
     C                   WRITE     AS000018S1
     C                   WRITE     AS000018C1
     C                   EVAL      *IN93 = *OFF
     C                   EVAL      *IN87 = *OFF
     C                   EVAL      *IN88 = *OFF
     C                   ELSE
 
      ** If Data Points required reach its maximum,
      ** then prevent futher scroll down
 
     C                   IF        WDtaReqd = 0
     C                   EVAL      *IN96 = *ON
     C                   ENDIF
 
      **  Write the subfile control record to the screen to display
      **  the subfile is not error exist.
 
     C                   WRITE     AS000018C1
     C                   ENDIF
 
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
 
     C                   READ      AS000018C1
 
      ** Clear any messages before processing user input
 
     C                   EVAL      FldNameArr = *BLANK
     C                   EVAL      MsgIdArr   = *BLANK
     C                   EVAL      MsgDtaArr  = *BLANK
     C                   EVAL      WERRMS     = *BLANKS
 
      **  If F3, bypass further processing.
 
     C                   IF        *INKC = *ON
     C                   EVAL      PINKC = '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** If F12, end program to return to first screen
 
     C                   IF        *INKL = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** If F5 has been press, refresh records
 
     C                   IF        *INKE = *ON
     C                   EXSR      SRINIT
     C                   EXSR      SRLoadFlToArr
     C                   GOTO      EBuildSF
     C                   ENDIF
 
      ** Read Subfile Record
 
     C                   EXSR      SRReadSF
 
      ** If error exist, position subfile to error record
 
     C                   IF        WWithErr = 'Y'
     C                   EVAL      #1SFRN = WSFRN
     C                   ENDIF
 
     C                   ENDDO
 
     C     EBuildSF      ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLoadSFToArr - Load records from Subfile to Array           *
      *                                                               *
      *****************************************************************
 
     C     SRLoadSFToArr BEGSR
 
      ** Clear Array
 
     C                   CLEAR                   ScreenArray
     C                   EVAL      ValDat = *ALL'0'
 
      ** Read all subfile record
 
     C                   EVAL      WRec = WRRN
     C                   EVAL      WRRN = 1
     C                   DOU       WRRN > WMaxRec
 
     C     WRRN          CHAIN     AS000018S1
 
      ** Write new array screen base on subfile
 
     C                   IF        #1VALD <> *Blanks  AND
     C                             #1DAMT <> *Blanks
 
      ** Record ID
 
     C                   IF        #1DELT = 'D'
     C                   EVAL      RecId(WRRN) = '*'
     C                   ELSE
     C                   EVAL      RecId(WRRN) = 'D'
     C                   ENDIF
 
      ** Value Date
 
     C                   EXSR      SRConvertDate
 
     C                   IF        PErrorFlag = 'Y'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'ScreenArray'
     C                   EVAL      DBASE = 6
     C                   EVAL      DBKEY = POption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      ValDat(WRRN) = PMDayNo
     C                   ENDIF
 
      ** Hedge Derivative Amount
 
     C                   IF        #1DAMT <> *Blanks
     C                   EVAL      WAMount = #1DAMT
     C                   EXSR      SRZA0840
     C                   EVAL      DSign(WRRN) = WNegative
     C                   EVAL      DAmt(WRRN) = PCalAmount
     C                   IF        FSDTTP = 'R'
     C                   EVAL      DAmt(WRRN) = DAmt(WRRN) / POWER(9)
     C                   ENDIF
     C                   ENDIF
 
      ** Hedged Item Amount
 
     C                   IF        #1IAMT <> *Blanks
     C                   EVAL      WAMount = #1IAMT
     C                   EXSR      SRZA0840
     C                   EVAL      HSign(WRRN) = WNegative
     C                   EVAL      HAmt(WRRN) = PCalAmount
     C                   IF        FSDTTP = 'R'
     C                   EVAL      HAmt(WRRN) = HAmt(WRRN) / POWER(9)
     C                   ENDIF
     C                   ENDIF
 
      ** Data Type - (A)ctual or (P)ast
 
     C                   EVAL      DInpT(WRRN) = #1DTAT
     C                   ENDIF
 
     C                   EVAL      WRRN = WRRN + 1
     C                   ENDDO
 
     C                   EVAL      WRRN = WRec
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLoadArrScr - Load Array to Screen                          *
      *                                                               *
      *****************************************************************
 
     C     SRLoadArrScr  BEGSR
 
      ** Check if record exist, if blank value date then no record
 
     C                   IF        ValDat(WArrLoc) = *Zeros
     C                   EVAL      WRecFound = 'N'
     C                   ELSE
     C                   EVAL      WRecFound = 'Y'
     C                   ENDIF
      ** Value Date
 
     C                   EXSR      SRFmtValDat
     C                   EVAL      #1VALD = PDDMMMYY
 
      ** Hedge Derivative Amount
 
     C                   IF        WRecFound = 'Y'
     C                   IF        FSDTTP = 'R'
     C                   EVAL      DAmt(WArrLoc) = DAmt(WArrLoc) * POWER(9)
     C                   ENDIF
     C                   EVAL      PAmountIn = DAmt(WArrLoc)
     C                   EXSR      SRZA1020
     C                   EVAL      #1DAMT = PAmountOut
 
     C                   IF        DSign(WArrLoc) = 'Y'
     C                   EVALR     #1DAMT = %TRIMR('-' + %TRIML(#1DAMT))
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      #1DAMT = *Blanks
     C                   ENDIF
 
      ** Hedged Item Amount
 
     C                   IF        WRecFound = 'Y'
     C                   IF        FSDTTP = 'R'
     C                   EVAL      HAmt(WArrLoc) = HAmt(WArrLoc) * POWER(9)
     C                   ENDIF
     C                   EVAL      PAmountIn = HAmt(WArrLoc)
     C                   EXSR      SRZA1020
     C                   EVAL      #1IAMT = PAmountOut
 
     C                   IF        HSign(WArrLoc) = 'Y'
     C                   EVALR     #1IAMT = %TRIMR('-' + %TRIML(#1IAMT))
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      #1IAMT = *Blanks
     C                   ENDIF
 
      ** Load original value date
 
     C                   IF        WOrigVdat(WArrLoc) <> 0
     C                   EVAL      #1FRFL = WOrigVdat(WArrLoc)
     C                   ENDIF
 
      ** Action Code Delete
 
     C                   IF        RecId(WArrLoc) = '*'
     C                   EVAL      *IN93 = *ON
     C                   EVAL      *IN87 = *ON
     C                   EVAL      *IN88 = *ON
     C                   EVAL      #1DELT = 'D'
     C                   ELSE
 
     C                   EVAL      #1DELT = *Blanks
     C                   EVAL      *IN87 = *OFF
 
      ** Data Type
 
     C                   IF        WRecFound = 'N'
     C                   EVAL      #1DTAT = ' '
     C                   EVAL      *IN93 = *OFF
     C                   EVAL      *IN88 = *OFF
     C                   ELSE
 
     C                   EVAL      #1DTAT = DInpT(WArrLoc)
     C**********         SELECT                                                               226525
     C**********         WHEN      #1DTAT = 'A'                                               226525
     C**********         EVAL      *IN93 = *ON                                                226525
     C**********         EVAL      *IN88 = *ON                                                226525
     C**********         WHEN      #1DTAT = 'P'                                               226525
     C**********         EVAL      *IN88 = *OFF                                               226525
     C**********         EVAL      *IN93 = *OFF                                               226525
     C**********         OTHER                                                                226525
     C                   EVAL      *IN93 = *OFF
     C                   EVAL      *IN88 = *OFF
     C**********         ENDSL                                                                226525
     C                   ENDIF
 
     C                   ENDIF
 
      ** Increment Array position
 
     C                   EVAL      WArrLoc = WArrLoc + 1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReadSF - Read subfile record                               *
      *                                                               *
      *****************************************************************
 
     C     SRReadSF      BEGSR
 
      **  Read the subfile for selected records
      **  Only process those which changes in screen record
 
     C                   EVAL      WWithErr = 'N'
     C                   EVAL      *IN20 = *ON
     C                   EVAL      #1SFRN = WMaxRec
 
     C                   EVAL      DspDate = *ZEROS
     C                   EVAL      B = 0
 
     C                   DOU       *IN85 = *ON
 
     C                   READC     AS000018S1                             85
 
      ** If Change in record found, validate
 
     C                   IF        *IN85 = '0'
     C                   EXSR      SRValidate
 
      ** If Error exist, store subfile relative record number
 
     C                   IF        WError = 'Y'  AND
     C                             *IN20 = *ON
     C                   EVAL      WSFRN = WRRN
     C                   EVAL      *IN20 = *OFF
     C                   ENDIF
 
     C                   IF        WError = 'Y'
     C                   EVAL      WWithErr = 'Y'
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDDO
 
     C     EReadSF       ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtValDat - Format Value Date to Screen format             *
      *                                                               *
      *****************************************************************
 
     C     SRFmtValDat   BEGSR
 
      ** Format value date
 
     C                   IF        WRecFound = 'N'
 
     C                   EVAL      PStartDate = *Zeros
 
     C                   IF        WArrLoc > 1
     C                   EVAL      PStartDate = ValDat(WArrLoc-1)
     C                   ENDIF
 
     C                   IF        PStartDate = *Zeros
     C                   IF        PBaseDate < POutDate
     C                   EVAL      PStartDate = PBaseDate
     C                   ELSE
     C                   EVAL      PStartDate = POutDate
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        PStartDate = *Zeros
     C                   EVAL      PStartDate = BJRDNB
     C                   ENDIF
 
     C                   CALLB     'ZFREQC'
     C                   PARM      *Blanks       PRetCode
     C                   PARM      'PREV'        PNxtColDay
     C                   PARM      'N'           PIncldTday
     C                   PARM      FSDFRQ        PFrequency
     C     POutDate      PARM                    PStartDate
     C                   PARM      BJCYCD        PCurrency
     C                   PARM      FSWDAY        PDayWeek
     C                   PARM      FSMNTH        PDayMonth
     C                   PARM                    BJDFIN
     C                   PARM                    PBaseDate
 
     C                   IF        PReturnCode <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'ZFREQC'
     C                   EVAL      DBASE = 5
     C                   MOVE      PStartDate    WStartDate
     C                   EVAL      DBKEY = PFrequency+' from '+WStartDate
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      POutDate = ValDat(WArrLoc)
     C                   ENDIF
 
      ** Convert day no to DDMMMYY
 
     C                   CALL      'ZDATE2'
     C                   PARM                    POutDate
     C                   PARM                    BJDFIN
     C                   PARM                    PValueDate
     C                   PARM                    PDDMMMYY
 
     C                   EVAL      WOrigVdat(WArrLoc) = POutDate
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSelectAmt - Select Amount based Data Type                  *
      *                                                               *
      *****************************************************************
 
     C     SRSelectAmt   BEGSR
 
     C                   IF        WRecFound = 'Y'
 
     C                   SELECT
     C                   WHEN      FSDTTP = 'V' OR FSDTTP = 'C'
     C                   EVAL      WAmountFld = XXMVAL
     C                   WHEN      FSDTTP = 'R'
     C                   EVAL      WAmountFld = XXMRAT
     C                   ENDSL
 
     C                   IF        WAmountFld < 0
     C                   EVAL      WAmountFld = WAmountFld * -1
     C                   EVAL      WNegative = 'Y'
     C                   ELSE
     C                   EVAL      WNegative = ' '
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidate - Validate screen fields                           *
      *                                                               *
      *****************************************************************
 
     C     SRValidate    BEGSR
 
     C                   EVAL      WError = 'N'
     C                   EVAL      *IN87 = *OFF
     C                   EVAL      *IN89 = *OFF
     C                   EVAL      *IN90 = *OFF
     C                   EVAL      *IN91 = *OFF
     C                   EVAL      *IN92 = *OFF
     C                   EVAL      *IN93 = *OFF
 
      ** Validate delete code
 
     C                   IF        #1DELT <> 'D' AND #1DELT <> *Blanks
     C                   EVAL      WERRMS = 'ASM0058'
     C                   EVAL      *IN90 = *ON
     C                   EXSR      SRSNDM@P
     C                   EVAL      WError = 'Y'
     C                   ENDIF
 
      ** Validate Value Date
 
     C                   IF        #1VALD <> *Blanks
 
     C                   EXSR      SRConvertDate
 
     C                   IF        PErrorFlag = 'Y'
     C                   EVAL      WERRMS = 'SEW1021'
     C                   EVAL      *IN92 = *ON
     C                   EXSR      SRSNDM@P
     C                   EVAL      WError = 'Y'
     C                   ENDIF
 
     C                   IF        PMDayNo >= BJRDNB
     C                   EVAL      WERRMS = 'USR4325'
     C                   EVAL      *IN92 = *ON
     C                   EXSR      SRSNDM@P
     C                   EVAL      WError = 'Y'
     C                   ENDIF
 
     C                   ELSE
     C                   IF        #1DAMT <> *Blanks
     C                   EVAL      WERRMS = 'USR4326'
     C                   EVAL      *IN92 = *ON
     C                   EXSR      SRSNDM@P
     C                   EVAL      WError = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
      ** Write collection date that has been deleted thru clearing
      ** of date and amounts to an array. This will be deleted
      ** from file when F10 is pressed.
 
     C                   IF        WError = 'N'
     C                   IF        #1DELT = *BLANK AND #1DAMT = *BLANK AND
     C                             #1IAMT = *BLANK OR PMDayNo <> #1FRFL AND
     C                             #1FRFL <> *ZERO
     C                   EVAL      A = A + 1
     C                   EVAL      DelDate(A) = #1FRFL
     C                   ENDIF
 
     C                   IF        PMDayNo <> 0 AND PMDayNo <> #1FRFL
     C     PMDayNo       LOOKUP    ValDat(1)                              30
     C     PMDayNo       LOOKUP    DspDate(1)                             31
     C     PMDayNo       LOOKUP    DelDate(1)                             32
     C                   IF        *IN30 = *ON AND *IN32 = *OFF OR
     C                             *IN31 = *ON AND *IN32 = *OFF
     C                   EVAL      WERRMS = 'USR4324'
     C                   EVAL      *IN92 = *ON
     C                   EXSR      SRSNDM@P
     C                   EVAL      WError = 'Y'
     C                   ELSE
     C                   EVAL      B = B + 1
     C                   EVAL      DspDate(B) = PMDayNo
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Hedge Derivative Amount
 
     C                   IF        #1DAMT <> *Blanks
 
     C                   EVAL      WAmount = #1DAMT
     C                   EXSR      SRValAmount
 
     C                   IF        PRetCode <> *Blanks
     C                   EVAL      *IN91 = *ON
     C                   ELSE
     C                   EVAL      #1DAMT = *Blanks
     C                   MOVE      PAmountOut    #1DAMT
 
     C                   IF        WNegative = 'Y'
     C                   EVALR     #1DAMT = %TRIMR('-' + %TRIML(#1DAMT))
     C                   EVAL      WNegative = ' '
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Hedged Item Amount
 
     C                   IF        #1IAMT <> *Blanks
 
     C                   EVAL      WAmount = #1IAMT
     C                   EXSR      SRValAmount
 
     C                   IF        PRetCode <> *Blanks
     C                   EVAL      *IN89 = *ON
     C                   ELSE
     C                   EVAL      #1IAMT = *Blanks
     C                   MOVE      PAmountOut    #1IAMT
 
     C                   IF        WNegative = 'Y'
     C                   EVALR     #1IAMT = %TRIMR('-' + %TRIML(#1IAMT))
     C                   EVAL      WNegative = ' '
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** Hedged Item and Derivative should be inserted together
 
     C                   IF        #1DAMT <> *Blanks AND #1IAMT = *Blanks  OR
     C                             #1DAMT = *Blanks AND #1IAMT <> *Blanks
     C                   EVAL      WERRMS = 'USR4321'
     C                   EVAL      *IN89 = *ON
     C                   EVAL      *IN91 = *ON
     C                   EXSR      SRSNDM@P
     C                   EVAL      WError = 'Y'
     C                   ENDIF
 
      ** Perform Action Code 'D'elete if no error
     C                   IF        WError = 'N'  AND
     C                             #1DELT = 'D'
     C                   EVAL      *IN93 = *ON
     C                   EVAL      *IN87 = *ON
     C                   EVAL      *IN88 = *ON
     C                   ENDIF
 
      ** Update Subfile Control
 
     C                   EVAL      *IN04 = *ON
     C                   UPDATE    AS000018S1
     C                   EVAL      *IN04 = *OFF
     C                   EVAL      *IN87 = *OFF
     C                   EVAL      *IN88 = *OFF
     C                   EVAL      *IN89 = *OFF
     C                   EVAL      *IN90 = *OFF
     C                   EVAL      *IN91 = *OFF
     C                   EVAL      *IN92 = *OFF
     C                   EVAL      *IN93 = *OFF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValAmount - Validate Amounts                               *
      *                                                               *
      *****************************************************************
 
     C     SRValAmount   BEGSR
 
     C                   EXSR      SRZA0840
 
     C                   IF        PErrCode = 1
     C                   EVAL      WERRMS = 'USR4322'
     C                   EVAL      WError = 'Y'
     C                   EXSR      SRSNDM@P
     C                   ELSE
     C                   IF        PErrCode = 2
     C                   EVAL      WERRMS = 'USR4323'
     C                   EVAL      WError = 'Y'
     C                   EXSR      SRSNDM@P
     C                   ELSE
     C                   IF        PCalAmount > 999999999999
     C                   EVAL      WERRMS = 'USR4323'
     C                   EVAL      WError = 'Y'
     C                   EVAL      PRetCode = '*ERROR'
     C                   EXSR      SRSNDM@P
     C                   ELSE
 
     C                   EVAL      PAmountIn = PCalAmount
     C                   EXSR      SRZA1020
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetDervativ - Get Hedge Derivative Details                 *
      *                                                               *
      *****************************************************************
 
     C     SRGetDervativ BEGSR
 
     C                   EVAL      WDHIN  = 'D'
     C     HTRNKey       CHAIN     ASHTRNL1
 
      ** If not found, database error
 
     C                   IF        NOT %FOUND(ASHTRNL1)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'ASHTRNL1'
     C                   EVAL      DBASE = 4
     C                   EVAL      DBKEY = #1HDNO+' '+WDHIN
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   MOVE      FSDLNO        #1HDNO
     C                   EVAL      WDMOD = FSMOD
     C                   EVAL      WDBRCA = FSBRCA
     C                   EVAL      WDCYCD = FSCYCD
     C                   EVAL      WDBKCD = FSBKCD
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetHedgeItm - Get Hedged Item Details                      *
      *                                                               *
      *****************************************************************
 
     C     SRGetHedgeItm BEGSR
 
     C                   EVAL      WDHIN  = 'H'
     C     HTRNKey       CHAIN     ASHTRNL1
 
      ** If not found, database error
 
     C                   IF        NOT %FOUND(ASHTRNL1)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'ASHTRNL1'
     C                   EVAL      DBASE = 7
     C                   EVAL      DBKEY = #1HDNO+' '+WDHIN
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WHMOD = FSMOD
     C                   EVAL      WHBRCA = FSBRCA
     C                   EVAL      WHCYCD = FSCYCD
     C                   EVAL      WHBKCD = FSBKCD
     C                   ENDIF
 
     C                   IF        WHMOD = 'DL' or WHMOD = 'LE'
     C                   EVAL      *IN22 = *OFF
     C                   MOVE      FSDLNO        #1HINO
 
     C                   ELSE
     C                   IF        WHMOD = 'SE'
     C                   EVAL      #1FPSE = FSFPSE
     C                   EVAL      WHSESN = FSFPSE
     C                   EVAL      #1BRCA = FSBRCA
     C                   EVAL      #1BKCD = FSBKCD
     C                   EVAL      #1MKIN = FSMKTI
     C                   EVAL      WHMKIN = FSMKTI
     C                   EVAL      #1BHTV = FSBHTV
     C                   EVAL      WHTVIN = FSBHTV
     C                   EVAL      *IN22 = *ON
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRConvertDate - Convert DDMMYY to Midas Day No                *
      *                                                               *
      *****************************************************************
 
     C     SRConvertDate BEGSR
 
      **  Look up array SSA to determine which month 'WMonth' occurs in.
 
     C                   EVAL      Pos = 1
     C     WMonth        LOOKUP    SSA(Pos)                               26
     C                   IF        %FOUND
     C                   MOVE      Pos           WMnth
     C                   EVAL      PDDMMYY = WDay + WMnth + WYear
 
     C                   ELSE
     C                   EVAL      WERRMS = 'SEW1021'
     C                   EVAL      *IN92 = *ON
     C                   EXSR      SRSNDM@P
     C                   EVAL      WError = 'Y'
     C                   ENDIF
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDDMMYY
     C                   PARM                    PMDayNo
     C                   PARM      'D'           PMDayFmt
     C                   PARM      *Blanks       PErrorFlag
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRemoveCom - Remove commas (,) on amount field              *
      *                                                               *
      *****************************************************************
 
     C     SRRemoveCom   BEGSR
 
     C                   CLEAR                   WAmtFld
     C                   CLEAR                   WOutFld
     C                   EVAL      WAmount = %TRIMR(WAmount)
     C     '.'           SCAN      WAmount       Loc                      21
 
      ** If found, check if with two decimals
 
     C                   IF        *IN21 = *ON
     C                   EVAL      Q = Loc + 1
     C                   IF        Loc < 21                                                   225201
     C     '.'           SCAN      WAmount:Q                              21
 
     C                   IF        *IN21 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      WOutFld = WAmount
     C                   GOTO      ESRRemove
     C                   ENDIF
     C                   ENDIF                                                                225201
 
     C                   ELSE
     C     WAmount       CAT       '.':0         WAmount
     C                   EVAL      Loc = %LEN(%TRIM(WAmount))
     C                   ENDIF
 
     C                   EVAL      WAmtFld2 = WAmount
 
 
     C                   DOU       %SUBST(WAmount:Loc:1) = ' '  OR
     C                             Loc < 1
 
      ** Move 3 position to the left to check if comma was use
 
     C                   EVAL      Loc = Loc - 4
 
      ** If not found, comma not use
 
     C                   IF        Loc > 0 AND
     C                             %SUBST(WAmount:Loc:1) = ','
 
     C                   EVAL      WAmtFld = %SUBST(WAmtFld2:Loc+1:21-Loc)
     C                   EVAL      WAmtFld2 = %SUBST(WAmtFld2:1:Loc-1)
     C     WAmtFld       CAT       WOutFld:0     WOutFld
 
     C                   ELSE
     C     WAmtFld2      CAT       WOutFld:0     WOutFld
     C                   GOTO      ESRRemove
     C                   ENDIF
 
     C                   ENDDO
 
     C     ESRRemove     ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZA1020 - Call ZA1020 to convert amount to screen format    *
      *                                                               *
      *****************************************************************
 
     C     SRZA1020      BEGSR
 
     C                   CALLB     'ZA1020'
     C                   PARM                    PAmountIn
     C                   PARM      21            PLenght
     C                   PARM                    PNoDecPl
     C                   PARM      '.'           PDecSeptr
     C                   PARM      ','           PThouSeptr
     C                   PARM                    PAmountOut
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZA0840 - Call ZA0840 to validate and correct decimal posn  *
      *                                                               *
      *****************************************************************
 
     C     SRZA0840      BEGSR
 
     C                   EVAL      WPosn = %SCAN('-':WAmount)
     C                   EVAL      WNegPref = 'N'
     C                   EVAL      WNegSuff = 'N'
     C                   IF        WPosn = 1
     C                   EVAL      WNegPref = 'Y'
     C                   ENDIF
     C                   IF        WPosn = 21
     C                   EVAL      WNegSuff = 'Y'
     C                   ENDIF
 
     C                   IF        WPosn > 1 AND WPosn < 21
     C                   EVAL      WBefNeg = %SUBST(WAmount:1:WPosn-1)
     C                   EVAL      WAftNeg = %SUBST(WAmount:WPosn+1:21 - WPosn)
     C                   IF        WBefNeg = *BLANKS
     C                   EVAL      WNegPref = 'Y'
     C                   ELSE
     C                   IF        WAftNeg = *BLANKS
     C                   EVAL      WNegSuff = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      WNegative = ' '
     C                   IF        WPosn <> 0
     C                   EVAL      WNegative = 'Y'
     C                   IF        WNegPref = 'Y'
     C                   EVAL      WAmount = %SUBST(WAmount:WPosn+1:21-WPosn)
     C                   ELSE
     C                   IF        WNegSuff = 'Y'
     C                   EVAL      WAmount = %SUBST(WAmount:1:WPosn - 1)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   EXSR      SRRemoveCom
 
     C                   EVAL      PAmount = %TRIML(WOutFld)
     C                   EVAL      PIntegers = 15 - PNoDecPl
     C                   EVAL      PMilThouID = 'N'
 
     C                   CALLB     'ZA0840'
     C                   PARM      *Blanks       PRetCode
     C                   PARM                    PAmount
     C                   PARM      PNoDecPl      PNoDecimal
     C                   PARM                    PIntegers
     C                   PARM                    PMilThouID
     C                   PARM      *Zeros        PErrCode
     C                   PARM                    PCalAmount
     C                   PARM      '.'           PDecSeptr
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWriteMsgSF - Write Footer and Message Subfile              *
      *                                                               *
      *****************************************************************
 
     C     SRWriteEndSF  BEGSR
 
      **  Set up footer toggle text and write the footer
 
     C                   WRITE     AS000018F0
 
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     C/COPY ZACPYSRC,MSGHNDDSP1
 
      **  Write the message subfile
 
     C                   WRITE     AS000018C0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSNDM@P - Send a message to detail screen                    *
      *                                                               *
      *****************************************************************
 
     C     SRSNDM@P      BEGSR
 
      ** Add error message to array passed to detail screen
 
     C                   Z-ADD     1             E
     C     *BLANK        LOOKUP    FldNameArr(E)                          99
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     WERRMS        MsgIdArr(E)
 
     C     EndSNDM@P     ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initialisation                                      *
      *                                                               *
      *****************************************************************
 
     C     SRINIT        BEGSR
 
      ** Clear outputs
 
     C                   EVAL      WError = 'N'
     C                   EVAL      WValDate = *HIVAL
     C                   EVAL      PINKC  = '0'
     C                   EVAL      *INKC  = '0'
     C                   EVAL      *IN10  = '0'
     C                   EVAL      *IN11  = '0'
     C                   EVAL      *IN12  = '0'
     C                   EVAL      FldNameArr = *BLANK
     C                   EVAL      MsgIdArr   = *BLANK
     C                   EVAL      MsgDtaArr  = *BLANK
     C                   EVAL      WERRMS     = *BLANKS
     C                   EVAL      WWithErr   = 'N'
     C                   EVAL      DelDate = *ZEROS
     C                   EVAL      A = 0
 
     C                   SELECT
     C                   When      FSDTTP = 'V' OR FSDTTP = 'C'
     C                   EVAL      *IN10 = '1'
     C                   EVAL      PNoDecPl = A6NBDP
     C                   Other
     C                   EVAL      *IN12 = '1'
     C                   EVAL      PNoDecPl = 8
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial processing                                  *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     HTRNKey       KLIST
     C                   KFLD                    FSHEDI
     C                   KFLD                    WDHIN
 
     C     DealKey       KLIST
     C                   KFLD                    FSHEDI
     C                   KFLD                    WDLNO
     C                   KFLD                    WValDate
 
     C     SecKey        KLIST
     C                   KFLD                    FSHEDI
     C                   KFLD                    WSESN
     C                   KFLD                    WBRCA
     C                   KFLD                    WBOOK
     C                   KFLD                    WMKTI
     C                   KFLD                    WBHTV
     C                   KFLD                    WValDate
 
     C     *ENTRY        PLIST
     C                   PARM                    PReturn
     C                   PARM                    ASHGLK
     C                   PARM                    PINKC
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'AS000018'
 
      ** Move workstation ID to screen field.
 
     C                   EVAL      #1WID = PsJobName
     C                   EVAL      #1USER = PsUser
 
     C                   EVAL      *IN94 = *ON
     C                   EVAL      #0PGMQ = '*'
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *Blanks       PReturnCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = POption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Currency details of Base currency
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR '     PReturnCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      BJCYCD        PKey
     C     SDCURR        PARM      SDCURR        DSFDY
 
      ** Database Error
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 2
     C                   EVAL      DBKEY = PKey
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access General Ledger Details
 
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       PReturnCode
     C                   PARM      '*FIRST '     POption
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      ** Database Error
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBASE = 3
     C                   EVAL      DBKEY = POption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SDCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      *
      /EJECT
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
 
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**CTDATA SSA - MONTH SHORTNAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
**CTDATA POWER - ARRAY OF POWERS FOR DECIMAL CONVERSION
0000000001
0000000010
0000000100
0000001000
0000010000
0000100000
0001000000
0010000000
0100000000
1000000000
