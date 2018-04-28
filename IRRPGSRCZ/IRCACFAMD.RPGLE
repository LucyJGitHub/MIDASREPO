     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Caps/collars/floors amend')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Module                                       *
      *                                                               *
      *  IRCACFAMD - Caps/Collars/Floors Amend Checking               *
      *                                                               *
      *  Function:  This module compares the fields of an amended deal*
      *             against those currently on file.  It checks       *
      *             whether all fields changed are amendable, and if  *
      *             not returns error messages to the calling process.*
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CDL039             Date 22Aug05               *
      *                 CDL038             Date 10May05               *
      *                 BUG6472            Date 23Apr05               *
      *                 CDL028             Date 07Feb05               *
      *                 BG1829             Date 14Apr04               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      *                 CAP043             Date 02May02               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209379             Date 09Sep02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP055  *CREATE    Date 13Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL039 - Amendable Deal Sub Types & Classes                  *
      *  CDL038 - Extended Deal Sub Type                              *
      *  BUG6472- Added a sign field for short term rate (Recompile)  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  BG1829 - Non-amendable field Spread/Rate appears in error    *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  CAP043 - Additional APIs for IRS Schedules (Recompile)       *
      *         - Format numeric fields                               *
      *  209379 - Format rates (base currency, floor and ceiling rates*
      *  CAP055 - APIs for FRA/IRS Caps/Collars/Floors                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Test Bit Result Indicator                       *
      *                                                               *
      *    LR         Last Record Indicator (program termination)     *
      *    U7 and U8  DB Error Processing Indicator                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrCmpFld  - Compare Certain Fields on the Current Deal with  *
      *              those Amended                                    *
      *  SrRstFlds - Reset Fields in Error                            *
      *  SrFrmt - Subroutine the Format Rates                         *                       209379
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
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
      ** New Deal in Screen Format
     D NwIRScnFmt    E DS                  EXTNAME(IRCACFPD)
 
      ** Current Deal in Screen Format
     D CrIRScnFmt    E DS                  EXTNAME(IRCACFPD)
     D                                     PREFIX(Cr:2)
 
      ** Current Deal in File Format
     D CrIRFilFmt    E DS                  EXTNAME(DEALSDG)
 
      ** IR Error Indicators for Caps/Collars/Floors
     D OkFlagsDS     E DS                  EXTNAME(IRECACFPD)
 
      ** Data structure for Portfolio Management ICD File
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CDL039
     D R_LCD         E                     EXTFLD(LCD)                                        CDL039
      ** EXTERNAL DS FOR SAR DETAILS                                                          CDL039
                                                                                              CDL039
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input Parameters
     D PRetCodeIn      S             10A
     D PResetErrs      S              1A
 
      ** Standing Data Entry Parameters
     D PRunDayNo       S              5P 0
     D PPortMgmt       S              1A
     D PPrfCtrUsd      S              1A
     D PPrfCtrAmd      S              1A
     D PMultBrnch      S              1A
     D POrigBrUsd      S              1A
 
      ** Switchable Features Entry Parameters
     D CIR001          S              1A
     D CIR006          S              1A
 
      ** Output Parameters
     D PIdx            S              3P 0
     D PAmendOK        S              1A
 
      ** Parameters for AOPORTR0
     D PRetrnCde       S              7A
     D POption         S              7A
 
     D WIdx            S              3P 0
     D WSide           S              1A
 
      ** ZALIGN parameters                                                                    209379
     D  ZFIELD         S             16A                                                      209379
     D  ZADEC          S              1  0                                                    209379
     D  ZADIG          S              2  0                                                    209379
     D  ZALIGNok       S              1                                                       209379
                                                                                              209379
     D  WkFld          S             11  7                                                    209379
     D  WkFld1         S             11  7                                                    209379
     D  WkFld2         S             11  7                                                    209379
                                                                                              209379
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
 
      ** Initialize
 
     C                   EVAL      WIdx = 0
 
      ** Compare fields with amended values
 
     C                   EXSR      SRCmpFld
 
      ** If any errors were found, set Amendments OK Indicator to 'N'
 
     C                   IF        WIdx > 0
     C                   EVAL      PAmendOK = 'N'
     C                   ELSE
     C                   EVAL      PAmendOK = 'Y'
     C                   ENDIF
 
      ** If any errors were found, reset fields in error, if required
 
     C                   IF        WIdx > 0
     C                             AND PResetErrs = 'Y'
     C                   EXSR      SRRstFlds
     C                   ENDIF
 
     C                   EVAL      PIdx = WIdx
 
      ** Return to the calling program
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCmpFld  - Compare certain fields on the current deal with   *
      *             those amended                                     *
      *****************************************************************
     C     SRCmpFld      BEGSR
 
      ** Deal Type. This field is not amendable.
 
     C                   IF        #0DTYP <> CrDTYP
     C                   ADD       1             WIdx
     C                   EVAL      FldNameArr(WIdx) = '#0DTYP'
     C                   EVAL      MsgIDArr(WIdx)   = 'MMM0398'
     C                   EVAL      OKDTYP = 'N'
     C                   ENDIF
 
      ** Deal SubType. This field is not amendable.
      ** unless CDL039 is ON                                                                  CDL039
 
     C                   IF        #0DLST <> CrDLST
     C                             AND CDL039  = 'N'                                          CDL039
     C                   ADD       1             WIdx
     C                   EVAL      FldNameArr(WIdx) = '#0DLST'
     C                   EVAL      MsgIDArr(WIdx)   = 'MMA0062'
     C                   EVAL      OKDLST = 'N'
     C                   ENDIF
 
      ** Deal Date. This field is not amendable.
 
     C                   IF        #0DDAT <> CrDDAT
     C                   ADD       1             WIdx
     C                   EVAL      FldNameArr(WIdx) = '#0DDAT'
     C                   EVAL      MsgIDArr(WIdx)   = 'MMM0382'
     C                   EVAL      OKDDAT = 'N'
     C                   ENDIF
 
      ** Branch Code. This field is not amendable.
 
     C                   IF        #0BRCA <> CrBRCA
     C                   ADD       1             WIdx
     C                   EVAL      FldNameArr(WIdx) = '#0BRCA'
     C                   EVAL      MsgIDArr(WIdx)   = 'MMA0063'
     C                   EVAL      OKBRCA = 'N'
     C                   ENDIF
 
      ** Broker Code. This field is not amendable.
 
     C                   IF        #0BRKC <> CrBRKC
     C                   ADD       1             WIdx
     C                   EVAL      FldNameArr(WIdx) = '#0BRKC'
     C                   EVAL      MsgIDArr(WIdx)   = 'FDM0147'
     C                   EVAL      OKBRKC = 'N'
     C                   ENDIF
 
      ** Brokerage. This field is not amendable.
 
     C                   IF        #0BAGE <> CrBAGE
     C                   ADD       1             WIdx
     C                   EVAL      FldNameArr(WIdx) = '#0BAGE'
     C                   EVAL      MsgIDArr(WIdx)   = 'MMA0064'
     C                   EVAL      OKBAGE = 'N'
     C                   ENDIF
 
      ** Customer. This field is not amendable.
 
     C                   IF        #0CNUM <> CrCNUM
     C                   ADD       1             WIdx
     C                   EVAL      FldNameArr(WIdx) = '#0CNUM'
     C                   EVAL      MsgIDArr(WIdx)   = 'MMM0387'
     C                   EVAL      OKCNUM = 'N'
     C                   ENDIF
 
      ** Value Date. This is not amendable.
 
     C                   IF        #0VDAT <> CrVDAT
     C                   ADD       1             WIdx
     C                   EVAL      FldNameArr(WIdx) = '#0VDAT'
     C                   EVAL      MsgIDArr(WIdx)   = 'MMM0386'
     C                   EVAL      OKVDAT = 'N'
     C                   ENDIF
 
      ** Account Sequence Number. This field is not amendable.
 
     C                   IF        #0CDAS <> CrCDAS
     C                   ADD       1             WIdx
     C                   EVAL      FldNameArr(WIdx) = '#0CDAS'
     C                   EVAL      MsgIDArr(WIdx)   = 'MMM0490'
     C                   EVAL      OKCDAS = 'N'
     C                   ENDIF
 
      ** Currency. This field is not amendable.
 
     C                   IF        #0CUCY <> CrCUCY
     C                   ADD       1             WIdx
     C                   EVAL      FldNameArr(WIdx) = '#0CUCY'
     C                   EVAL      MsgIDArr(WIdx)   = 'MMM0370'
     C                   EVAL      OKCUCY = 'N'
     C                   ENDIF
 
      ** Deal Amount. This field is not amendable.
 
     C                   IF        #0PAMT <> CrPAMT
     C                   ADD       1             WIdx
     C                   EVAL      FldNameArr(WIdx) = '#0PAMT'
     C                   EVAL      MsgIDArr(WIdx)   = 'MMM0372'
     C                   EVAL      OKPAMT = 'N'
     C                   ENDIF
 
      ** Federal Funds Indicator. This field is not amendable.
 
     C                   IF        #0FEFI <> CrFEFI
     C                   ADD       1             WIdx
     C                   EVAL      FldNameArr(WIdx) = '#0FEFI'
     C                   EVAL      MsgIDArr(WIdx)   = 'MMM0396'
     C                   EVAL      OKFEFI = 'N'
     C                   ENDIF
                                                                                              209379
      **  This field was not amendable in DL1604, however for APIs                            209379
      ** this presents a problem because if not entered the value                             209379
      ** defaults to base currency equivalent. A subsequent amend                             209379
      ** would be invalid if front office user did not know                                   209379
      ** the calculated value of original insert and left the field                           209379
      ** blank. If blank field is allowed here the update program                             209379
      ** will re-calculate the value based on current BCE which                               209379
      ** may have changed, effectively allowing the field to be                               209379
      ** amended anyway.                                                                      209379
      ** Make field AMENDABLE for now until a better solution can be                          209379
      ** found.                                                                               209379
 
      ***Base*Currency*Rate.*This*field*is*not*amendable.****************************         209379
      **********                                                                              209379
     C**********         IF        #0BCXR <> CrBCXR                                           209379
     C**********         ADD       1             WIdx                                         209379
     C**********         EVAL      FldNameArr(WIdx) = '#0BCXR'                                209379
     C**********         EVAL      MsgIDArr(WIdx)   = 'MMM0392'                               209379
     C**********         EVAL      OKBCXR = 'N'                                               209379
     C**********         ENDIF                                                                209379
 
      ** Book Code. This field is not amendable.
 
     C                   IF        #0BOKC <> CrBOKC
     C                   ADD       1             WIdx
     C                   EVAL      FldNameArr(WIdx) = '#0BOKC'
     C                   EVAL      MsgIDArr(WIdx)   = 'MMA0060'
     C                   EVAL      OKBOKC = 'N'
     C                   ENDIF
 
      ** Interest Calculation Basis. This field is not amendable.
 
     C                   IF        #0ICBS <> CrICBS
     C                   ADD       1             WIdx
     C                   EVAL      FldNameArr(WIdx) = '#0ICBS'
     C                   EVAL      MsgIDArr(WIdx)   = 'MMM0485'
     C                   EVAL      OKICBS = 'N'
     C                   ENDIF
 
      ** Taxable Indicator. This field is only amendable if
      ** Value date >= Rundate.
 
     C                   IF        #0TAXI <> CrTAXI
     C                             AND VDAT < PRunDayNo
     C                   ADD       1             WIdx
     C                   EVAL      FldNameArr(WIdx) = '#0TAXI'
     C                   EVAL      MsgIDArr(WIdx)   = 'MMM0596'
     C                   EVAL      OKTAXI = 'N'
     C                   ENDIF
 
      ** Profit Centre.  Only validate if 'Profit Centre Used' is 'Y'.
      ** This field is not amendable if 'Profit Centre Amendable' <> 'Y'.
 
     C                   IF        #0PRFC <> CrPRFC AND
     C                             (PPrfCtrUsd <> 'Y' OR
     C                              PPrfCtrAmd <> 'Y')
     C                   ADD       1             WIdx
     C                   EVAL      FldNameArr(WIdx) = '#0PRFC'
     C                   EVAL      MsgIDArr(WIdx)   = 'FXM4002'
     C                   EVAL      OKPRFC = 'N'
     C                   ENDIF
 
      ** Originating Branch. Only validate if 'Multi Branching
      ** Indicator' and 'Originating Branch Used' are 'Y'. This field
      ** is not amendable.
 
     C                   IF        #0ORBR <> CrORBR AND
     C                             (PMultBrnch <> 'Y' OR
     C                              POrigBrUsd <> 'Y')
     C                   ADD       1             WIdx
     C                   EVAL      FldNameArr(WIdx) = '#0ORBR'
     C                   EVAL      MsgIDArr(WIdx)   = 'MMM0597'
     C                   EVAL      OKORBR = 'N'
     C                   ENDIF
 
      ** Buy/Sell Indicator. This field is not amendable.
 
     C                   IF        #0BYSL <> CrBYSL
     C                   ADD       1             WIdx
     C                   EVAL      FldNameArr(WIdx) = '#0BYSL'
     C                   EVAL      MsgIDArr(WIdx)   = 'MMA0061'
     C                   EVAL      OKBYSL = 'N'
     C                   ENDIF
 
      ** Determine Our/Their side
 
     C                   IF        CrDTYP = 'RP' AND CrBYSL = 'B' OR
     C                             CrDTYP = 'RR' AND CrBYSL = 'B' OR
     C                             CrDTYP = 'RF' AND CrBYSL = 'S'
     C                   EVAL      WSide = 'T'
     C                   ELSE
     C                   EVAL      WSide = 'U'
     C                   ENDIF
 
      ** Our Base Rate Code. This field is only amendable if:
      ** Value date >= Rundate AND
      **   Base Rate Code > 0     AND
      **   Interest Fix Date > 0  AND
      **   Interest Fix Date <= Value Date
 
     C                   IF        #0BRTT <> CrBRTT
     C                   IF        VDAT < PRunDayNo OR
     C                             (WSide = 'U' AND
     C                             (UBRTT <> *ZERO OR UINFD > VDAT)) OR
     C                             (WSide = 'T' AND
     C                             (TBRTT <> *ZERO OR TINFD > VDAT))
     C                   ADD       1             WIdx
     C                   EVAL      FldNameArr(WIdx) = '#0BRTT'
     C                   EVAL      MsgIDArr(WIdx)   = 'MMM0376'
     C                   EVAL      OKBRTT = 'N'
     C                   ENDIF
     C                   ENDIF
 
      ** Spread/Rate. This field is only amendable if the Interest
      ** Fix Date > zero.
 
     C                   Z-ADD     0             WkFld1                                       BG1829
     C                   Z-ADD     0             WkFld2                                       BG1829
     C                   IF        #0RTSP <> *BLANKS                                          BG1829
     C                   MOVE      *BLANKS       ZFIELD                                       BG1829
     C                   MOVE      #0RTSP        ZFIELD                                       BG1829
     C                   Z-ADD     7             ZADEC                                        BG1829
     C                   Z-ADD     4             ZADIG                                        BG1829
     C                   EXSR      SrFrmt                                                     BG1829
     C                   MOVE      WkFld         WkFld1                                       BG1829
     C                   ENDIF                                                                BG1829
                                                                                              BG1829
     C                   IF        CrRTSP <> *BLANKS                                          BG1829
     C                   MOVE      *BLANKS       ZFIELD                                       BG1829
     C                   MOVE      CrRTSP        ZFIELD                                       BG1829
     C                   Z-ADD     7             ZADEC                                        BG1829
     C                   Z-ADD     4             ZADIG                                        BG1829
     C                   EXSR      SrFrmt                                                     BG1829
     C                   MOVE      WkFld         WkFld2                                       BG1829
     C                   ENDIF                                                                BG1829
                                                                                              BG1829
     C**********         IF        #0RTSP <> CrRTSP AND                                       BG1829
     C**********                   (WSide = 'U' AND UINFD = *ZERO OR                          BG1829
     C**********                    WSide = 'T' AND TINFD = *ZERO)                            BG1829
     C                   IF        WkFld1 <> WkFld2 AND                                       BG1829
     C                             (WSide = 'U' AND UINFD = *ZERO OR                          BG1829
     C                              WSide = 'T' AND TINFD = *ZERO)                            BG1829
     C                   ADD       1             WIdx
     C                   EVAL      FldNameArr(WIdx) = '#0RTSP'
     C                   EVAL      MsgIDArr(WIdx)   = 'MMM0374'
     C                   EVAL      OKRTSP = 'N'
     C                   ENDIF
 
      ** Spread Indicator. Similarly, this field is only amendable if
      ** the Interest Fix Date > zero.
 
     C                   IF        #0SPIN <> CrSPIN AND
     C                             (WSide = 'U' AND UINFD = *ZERO OR
     C                              WSide = 'T' AND TINFD = *ZERO)
     C                   ADD       1             WIdx
     C                   EVAL      FldNameArr(WIdx) = '#0SPIN'
     C                   EVAL      MsgIDArr(WIdx)   = 'MMM0598'
     C                   EVAL      OKSPIN = 'N'
     C                   ENDIF
 
     C                   TESTB     '3'           TDSTI                    01
 
      ** Rate Fix Days. This field is not amendable if Average Rate
      ** Method is 'Y'.
 
     C                   IF        #0FRFD <> CrFRFD AND *IN01 = *ON
     C                   ADD       1             WIdx
     C                   EVAL      FldNameArr(WIdx) = '#0FRFD'
     C                   EVAL      MsgIDArr(WIdx)   = 'MMA0107'
     C                   EVAL      OKFRFD = 'N'
     C                   ENDIF
 
      ** Short Term Rate/Current Average. This field is not amendable
      ** if Average Rate Method is 'Y' and Value date >= Rundate.
 
      ** If not blank, format the rate                                                        209379
                                                                                              209379
     C                   Z-ADD     0             WkFld1                                       209379
     C                   Z-ADD     0             WkFld2                                       209379
     C                   IF        #0EINR <> *BLANKS                                          209379
     C                   MOVE      *BLANKS       ZFIELD                                       209379
     C                   MOVE      #0EINR        ZFIELD                                       209379
     C                   Z-ADD     7             ZADEC                                        209379
     C                   Z-ADD     4             ZADIG                                        209379
     C                   EXSR      SrFrmt                                                     209379
     C                   MOVE      WkFld         WkFld1                                       209379
     C                   ENDIF                                                                209379
                                                                                              209379
     C                   IF        CrEINR <> *BLANKS                                          209379
     C                   MOVE      *BLANKS       ZFIELD                                       209379
     C                   MOVE      CrEINR        ZFIELD                                       209379
     C                   Z-ADD     7             ZADEC                                        209379
     C                   Z-ADD     4             ZADIG                                        209379
     C                   EXSR      SrFrmt                                                     209379
     C                   MOVE      WkFld         WkFld2                                       209379
     C                   ENDIF                                                                209379
                                                                                              209379
     C**********         IF        #0EINR <> CrEINR AND *IN01 = *ON AND                       209379
     C                   IF        WkFld1 <> WkFld2 AND *IN01 = *ON AND                       209379
     C                             VDAT >= PRunDayNo
     C                   ADD       1             WIdx
     C                   EVAL      FldNameArr(WIdx) = '#0EINR'
     C                   EVAL      MsgIDArr(WIdx)   = 'MMA0111'
     C                   EVAL      OKEINR = 'N'
     C                   ENDIF
 
      ** Ceiling Rate. This field is not amendable.
 
      ** If not blank, format the rate                                                        209379
                                                                                              209379
     C                   Z-ADD     0             WkFld1                                       209379
     C                   Z-ADD     0             WkFld2                                       209379
     C                   IF        #0CRAT <> *BLANKS                                          209379
     C                   MOVE      *BLANKS       ZFIELD                                       209379
     C                   MOVE      #0CRAT        ZFIELD                                       209379
     C                   Z-ADD     7             ZADEC                                        209379
     C                   Z-ADD     4             ZADIG                                        209379
     C                   EXSR      SrFrmt                                                     209379
     C                   MOVE      WkFld         WkFld1                                       209379
     C                   ENDIF                                                                209379
                                                                                              209379
     C                   IF        CrCRAT <> *BLANKS                                          209379
     C                   MOVE      *BLANKS       ZFIELD                                       209379
     C                   MOVE      CrCRAT        ZFIELD                                       209379
     C                   Z-ADD     7             ZADEC                                        209379
     C                   Z-ADD     4             ZADIG                                        209379
     C                   EXSR      SrFrmt                                                     209379
     C                   MOVE      WkFld         WkFld2                                       209379
     C                   ENDIF                                                                209379
                                                                                              209379
     C**********         IF        #0CRAT <> CrCRAT                                           209379
     C                   IF        WkFld1 <> WkFld2                                           209379
     C                   ADD       1             WIdx
     C                   EVAL      FldNameArr(WIdx) = '#0CRAT'
     C                   EVAL      MsgIDArr(WIdx)   = 'MMM0599'
     C                   EVAL      OKCRAT = 'N'
     C                   ENDIF
 
      ** Floor Rate. This field is not amendable.
 
      ** If not blank, format the rate                                                        209379
                                                                                              209379
     C                   Z-ADD     0             WkFld1                                       209379
     C                   Z-ADD     0             WkFld2                                       209379
     C                   IF        #0FRAT <> *BLANKS                                          209379
     C                   MOVE      *BLANKS       ZFIELD                                       209379
     C                   MOVE      #0FRAT        ZFIELD                                       209379
     C                   Z-ADD     7             ZADEC                                        209379
     C                   Z-ADD     4             ZADIG                                        209379
     C                   EXSR      SrFrmt                                                     209379
     C                   MOVE      WkFld         WkFld1                                       209379
     C                   ENDIF                                                                209379
                                                                                              209379
     C                   IF        CrFRAT <> *BLANKS                                          209379
     C                   MOVE      *BLANKS       ZFIELD                                       209379
     C                   MOVE      CrFRAT        ZFIELD                                       209379
     C                   Z-ADD     7             ZADEC                                        209379
     C                   Z-ADD     4             ZADIG                                        209379
     C                   EXSR      SrFrmt                                                     209379
     C                   MOVE      WkFld         WkFld2                                       209379
     C                   ENDIF                                                                209379
                                                                                              209379
     C**********         IF        #0FRAT <> CrFRAT                                           209379
     C                   IF        WkFld1 <> WkFld2                                           209379
     C                   ADD       1             WIdx
     C                   EVAL      FldNameArr(WIdx) = '#0FRAT'
     C                   EVAL      MsgIDArr(WIdx)   = 'MMM0600'
     C                   EVAL      OKFRAT = 'N'
     C                   ENDIF
 
      ** Average Rate Method. This field is not amendable.
 
     C                   IF        #0AVRM <> CrAVRM
     C                   ADD       1             WIdx
     C                   EVAL      FldNameArr(WIdx) = '#0AVRM'
     C                   EVAL      MsgIDArr(WIdx)   = 'MMM0696'
     C                   EVAL      OKAVRM = 'N'
     C                   ENDIF
 
      ** Premium Value Date. This field is non-amendable if CIR001 is
      ** off, or CIR006 is on, or Original Entry Date <> Rundate.
 
     C                   IF        #0PUPVD <> CrPUPVD AND
     C                             (CIR001 <> 'Y' OR CIR006 = 'Y' OR
     C                              ORED <> PRunDayNo)
     C                   ADD       1             WIdx
     C                   EVAL      FldNameArr(WIdx) = '#0PUPVD'
     C                   EVAL      MsgIDArr(WIdx)   = 'MMM0697'
     C                   EVAL      OKPUPVD = 'N'
     C                   ENDIF
 
      ** Premium Amount. Similarly, this field is non-amendable if
      ** CIR001 is off, or CIR006 is on, or Orig.Entry Date <> Rundate.
 
     C                   IF        #0PUPFE <> CrPUPFE AND
     C                             (CIR001 <> 'Y' OR CIR006 = 'Y' OR
     C                              ORED <> PRunDayNo)
     C                   ADD       1             WIdx
     C                   EVAL      FldNameArr(WIdx) = '#0PUPFE'
     C                   EVAL      MsgIDArr(WIdx)   = 'MMM0698'
     C                   EVAL      OKPUPFE = 'N'
     C                   ENDIF
                                                                                              CDL038
      * Class                                                                                 CDL038
      ** This field is amendable only if the deal is complete                                 CDL038
      ** and if CDL039 is ON                                                                  CDL039
                                                                                              CDL038
     C     FIDSTS        IFNE      'C'                                                        CDL038
     C     #0CLAS        ANDNE     CrCLAS                                                     CDL038
     C     CDL039        ANDEQ     'N'                                                        CDL039
     C                   ADD       1             WIdx                                         CDL038
     C                   EVAL      FldNameArr(WIdx) = '#0CLAS'                                CDL038
     C                   EVAL      MsgIDArr(WIdx)  = 'MMM0258'                                CDL038
     C                   EVAL      OKCLAS = 'N'                                               CDL038
     C                   ENDIF                                                                CDL038
 
      ** ---------------------------------------------------------------*
      ** The following fields are currently UNCONDITIONALLY AMENDABLE   *
      ** so no checking is done here.                                   *
      ** ---------------------------------------------------------------*
      ** #0LNKD - Linked Reference Number
      ** #0MDAT - Maturity Date
      ** #0NIPD - Our Interest Payment Date
      ** #0IPFR - Our Interest Payment Frequency
      ** #0IPFD - Our Interest Payment Day in Month
      ** #0NICD - Rate Change Date
      ** #0ICFR - Rate Change Frequency
      ** #0ICFD - Our Rate Change Day in Month
      ** Business Day Convention Fields
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRstFlds - Reset fields in Error                             *
      *****************************************************************
     C     SRRstFlds     BEGSR
 
      ** Reset fields in error to 'current' values
 
      ** Deal Type
 
     C                   IF        OKDTYP = 'N'
     C                   EVAL      #0DTYP = CrDTYP
     C                   ENDIF
 
      ** Deal SubType
 
     C                   IF        OKDLST = 'N'
     C                   EVAL      #0DLST = CrDLST
     C                   ENDIF
 
      ** Deal Date
 
     C                   IF        OKDDAT = 'N'
     C                   EVAL      #0DDAT = CrDDAT
     C                   ENDIF
 
      ** Branch Code
 
     C                   IF        OKBRCA = 'N'
     C                   EVAL      #0BRCA = CrBRCA
     C                   ENDIF
 
      ** Broker Code
 
     C                   IF        OKBRKC = 'N'
     C                   EVAL      #0BRKC = CrBRKC
     C                   ENDIF
 
      ** Brokerage
 
     C                   IF        OKBAGE = 'N'
     C                   EVAL      #0BAGE = CrBAGE
     C                   ENDIF
 
      ** Customer
 
     C                   IF        OKCNUM = 'N'
     C                   EVAL      #0CNUM = CrCNUM
     C                   ENDIF
 
      ** Value Date
 
     C                   IF        OKVDAT = 'N'
     C                   EVAL      #0VDAT = CrVDAT
     C                   ENDIF
 
      ** Account Sequence Number
 
     C                   IF        OKCDAS = 'N'
     C                   EVAL      #0CDAS = CrCDAS
     C                   ENDIF
 
      ** Currency
 
     C                   IF        OKCUCY = 'N'
     C                   EVAL      #0CUCY = CrCUCY
     C                   ENDIF
 
      ** Deal Amount
 
     C                   IF        OKPAMT = 'N'
     C                   EVAL      #0PAMT = CrPAMT
     C                   ENDIF
 
      ** Federal Funds Indicator
 
     C                   IF        OKFEFI = 'N'
     C                   EVAL      #0FEFI = CrFEFI
     C                   ENDIF
 
      ** Base Currency Rate
 
     C                   IF        OKBCXR = 'N'
     C                   EVAL      #0BCXR = CrBCXR
     C                   ENDIF
 
      ** Book Code
 
     C                   IF        OKBOKC = 'N'
     C                   EVAL      #0BOKC = CrBOKC
     C                   ENDIF
 
      ** Interest Calculation Basis
 
     C                   IF        OKICBS = 'N'
     C                   EVAL      #0ICBS = CrICBS
     C                   ENDIF
 
      ** Taxable Indicator
 
     C                   IF        OKTAXI = 'N'
     C                   EVAL      #0TAXI = CrTAXI
     C                   ENDIF
 
      ** Profit Centre
 
     C                   IF        OKPRFC = 'N'
     C                   EVAL      #0PRFC = CrPRFC
     C                   ENDIF
 
      ** Originating Branch
 
     C                   IF        OKORBR = 'N'
     C                   EVAL      #0ORBR = CrORBR
     C                   ENDIF
 
      ** Buy/Sell Indicator
 
     C                   IF        OKBYSL = 'N'
     C                   EVAL      #0BYSL = CrBYSL
     C                   ENDIF
 
      ** Our Base Rate Code
 
     C                   IF        OKBRTT = 'N'
     C                   EVAL      #0BRTT = CrBRTT
     C                   ENDIF
 
      ** Spread/Rate
 
     C                   IF        OKRTSP = 'N'
     C                   EVAL      #0RTSP = CrRTSP
     C                   ENDIF
 
      ** Spread Indicator
 
     C                   IF        OKSPIN = 'N'
     C                   EVAL      #0SPIN = CrSPIN
     C                   ENDIF
 
      ** Rate Fix Days
 
     C                   IF        OKFRFD = 'N'
     C                   EVAL      #0FRFD = CrFRFD
     C                   ENDIF
 
      ** Short Term Rate/Current Average
 
     C                   IF        OKEINR = 'N'
     C                   EVAL      #0EINR = CrEINR
     C                   ENDIF
 
      ** Ceiling Rate
 
     C                   IF        OKCRAT = 'N'
     C                   EVAL      #0CRAT = CrCRAT
     C                   ENDIF
 
      ** Floor Rate
 
     C                   IF        OKFRAT = 'N'
     C                   EVAL      #0FRAT = CrFRAT
     C                   ENDIF
 
      ** Average Rate Method
 
     C                   IF        OKAVRM = 'N'
     C                   EVAL      #0AVRM = CrAVRM
     C                   ENDIF
 
      ** Premium Value Date
 
     C                   IF        OKPUPVD = 'N'
     C                   EVAL      #0PUPVD = CrPUPVD
     C                   ENDIF
 
      ** Premium Amount
 
     C                   IF        OKPUPFE = 'N'
     C                   EVAL      #0PUPFE = CrPUPFE
     C                   ENDIF
      *                                                                                       CDL038
      * Class                                                                                 CDL038
     C                   IF        OKCLAS  = 'N'                                              CDL038
     C                   EVAL      #0CLAS = CrCLAS                                            CDL038
     C                   END                                                                  CDL038
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  209379
      *****************************************************************                       209379
      * SrFrmt - Subroutine the Format Rates                          *                       209379
      *****************************************************************                       209379
     C     SrFrmt        BEGSR                                                                209379
                                                                                              209379
     C                   Z-ADD     0             WkFld                                        209379
                                                                                              209379
     C                   CALLB     'ZALIGN'                                                   209379
     C                   PARM                    ZALIGNok                                     209379
     C                   PARM                    ZFIELD                                       209379
     C                   PARM                    ZADEC                                        209379
     C                   PARM                    ZADIG                                        209379
                                                                                              209379
     C                   IF        ZALIGNok = 'Y'                                             209379
     C                   MOVE      ZFIELD        WkFld                                        209379
     C                   ENDIF                                                                209379
                                                                                              209379
     C                   ENDSR                                                                209379
      *****************************************************************                       209379
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Input Parameters:
 
      ** Return Code
 
     C                   PARM                    PRetCodeIn
 
      ** New Deal in Screen Format
 
     C                   PARM                    NwIRScnFmt
 
      ** Current Deal in Screen Format
 
     C                   PARM                    CrIRScnFmt
 
      ** Current Deal in file format
 
     C                   PARM                    CrIRFilFmt
 
      ** Reset of Fields in Error Required (Y/N)
 
     C                   PARM                    PResetErrs
 
      ** Standing Data:
 
      ** Runday Number from SDBANKPD
 
     C                   PARM                    PRunDayNo
 
      ** Portfolio Management from SDMMODPD
 
     C                   PARM                    PPortMgmt
 
      ** Multi Branching Indicator From SDMMODPD
 
     C                   PARM                    PMultBrnch
 
      ** Profic Centres Used from SDGELRPD
 
     C                   PARM                    PPrfCtrUsd
 
      ** Profic Centres Amendable from SDGELRPD
 
     C                   PARM                    PPrfCtrAmd
 
      ** Originating Branch Used from SDGELRPD
 
     C                   PARM                    POrigBrUsd
 
      ** Switchable Features:
 
      ** Interest Rate Calendars
 
     C                   PARM                    CIR001
 
      ** Amortisation of Caps, Collars, Floors and
      ** Individual Compounding Swaps
 
     C                   PARM                    CIR006
 
      ** Output Parameters:
 
      ** Field OK flags (DS) from/to caller
 
     C                   PARM                    OKFlagsDS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    PIdx
 
      ** Amendments OK
 
     C                   PARM                    PAmendOk
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      ** Access Portfolio Management ICD details if PM swithed on
 
     C                   IF        PPortMgmt = 'Y'
     C                   CALLB     'AOPORTR0'
     C                   PARM      '*DBERR '     PRetrnCde
     C                   PARM      '*FIRST'      POption
     C     SDPORT        PARM      SDPORT        DSFDY
 
     C                   IF        PRetrnCde <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'SDPORTPD'
     C                   EVAL      DBKEY  =  '*CALL'
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBPROC =  'SR/*INZSR'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
      *                                                                                       CDL039
      ** ACCESS SAR DETAILS FILE TO DETERMINE IF CDL039 IS INSTALLED                          CDL039
      *                                                                                       CDL039
     C                   CALL      'AOSARDR0'                                                 CDL039
     C                   PARM      *BLANKS       @RTCD             7                          CDL039
     C                   PARM      '*VERIFY'     @OPTN             7                          CDL039
     C                   PARM      'CDL039'      @SARD             6                          CDL039
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL039
      *                                                                                       CDL039
     C     @RTCD         IFEQ      *BLANK                                                     CDL039
     C                   MOVEL     'Y'           CDL039            1                          CDL039
     C                   ELSE                                                                 CDL039
     C                   MOVEL     'N'           CDL039                                       CDL039
     C                   END                                                                  CDL039
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
