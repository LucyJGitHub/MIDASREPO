     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Ccy for business day conv. validation')       *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEVBDYCL - Currencies for Business Day Conventions           *
      *             Validation                                        *
      *                                                               *
      *  Function:  This module validates the currency conventions    *
      *             fields                                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. CLE141  *CREATE    Date 08Feb16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE141 - Currency and Location Business Day Convention       *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS

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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D CCYArr          S              3    DIM(10)
     D LOCArr          S              3    DIM(10)

     D CCYArrV         S              3    DIM(10)
     D LOCArrV         S              3    DIM(10)

     D OKFlagDS1       S              1    DIM(10)
     D OKFlagDS2       S              1    DIM(10)

      ** Data structure containing currency details

     D SDCurr        E DS                  EXTNAME(SDCURRPD)
     D SDLoc         E DS                  EXTNAME(SDLOCNPD)

      ** External Data Structure for Access Programs (Long)

     D Dssdy         E DS                  EXTNAME(DSSDY)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D Idx             S              2P 0
     D WIdx            S              2P 0
     D Fidx            S              2P 0

     D ArrIdxC         S              2  0
     D ArrIdxL         S              2  0

     D LocCurr         S              3A
     D WCtr            S              2  0

     D FldError        S              3A
     D ArrLKPL         S              2  0
     D ArrLKPC         S              2  0

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Default the values for business day convention to the loan currency
      ** if left blank

     C                   IF        PCUR = *blanks and PLOC = *blanks
     C                   Eval      CCYArr(1) = LCUR
     C                   MOVEA     CCYArr        PCUR
     C                   Else

      ** Proceed with Validations

     C                   MOVEA     PCUR          CCYArr
     C                   MOVEA     PLOC          LOCArr

      ** Validate Currencies

     C                   Exsr      SRValCur

      ** Validate Location Codes

     C                   Exsr      SRValLoc

      ** Validate Currency/Location Combination

     C                   If        Idx = 0
     C                   Exsr      SRVlCrLc
     C                   Endif

     C                   If        Idx > 0
     C                   Eval      RetCodeIn = '*ERROR'
     C                   Endif

     C                   ENDIF

     C                   SETON                                        LR
      *****************************************************************
      *  SRValCur - Validate Currencies                               *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                 *
      *****************************************************************
     C     SRValCur      Begsr

     C                   Eval      WCtr = 1
     C                   Dow       WCtr <= 10

     C                   IF        CcyArr(Wctr) <> *blank

     C                   CallB     'ZAVCURCODE'
     C                   Parm      *Blanks       PRtcd             7
     C                   Parm                    PMsgId            7
     C                   Parm      CcyArr(WCtr)  PCurr             3
     C     SDCurr        Parm      SDCurr        Dssdy
     C                   Endif

      ** Issue Error Message Currency Invalid

     C                   if        PRtcd <> *blanks
     C                   Eval      Idx = Idx + 1
     C                   Eval      OKFlagDS1(WCtr) = 'N'
     C                   Eval      MsgIdArr(Idx) = '5048506'
     C                   Eval      FldError = 'CCY'
     C                   Eval      Fidx = Fidx + 1
     C                   Exsr      SrFldn

     C                   Endif

     C                   Eval      WCtr = Wctr + 1
     C                   Enddo

     C                   ENDSR
      *****************************************************************
      *  SRValLoc - Validate Location Codes                           *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *****************************************************************
     C     SRValLoc      Begsr

     C                   Eval      WCtr = 1
     C                   Dow       WCtr <= 10

     C                   If        LOCArr(Wctr) <> *blank
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN             7
     C                   PARM      LOCArr(Wctr)  PLCCD             3
     C     SDLoc         PARM      SDLoc         DSSDY

     C                   If        PRTCD = '*NRF'

      ** Issue Error Message Location Code Invalid

     C                   Eval      Idx = Idx + 1
     C                   Eval      OKFlagDS2(WCtr) = 'N'
     C                   Eval      MsgIdArr(Idx) = '5048507'
     C                   Eval      FldError = 'LOC'
     C                   Eval      Fidx = Fidx + 1
     C                   Exsr      SrFldn

     C                   Endif

     C                   Endif

     C                   Eval      WCtr = Wctr + 1
     C                   Enddo
     C
     C                   Endsr
      *****************************************************************
      *  SRVlCrLc - Validate Currency/Location Combinations           *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *****************************************************************
     C     SRVlCrLc      Begsr

     C                   Eval      WCtr = 1
     C                   Eval      CCYArrV = *blanks
     C                   Eval      LOCArrV = *blanks

      ** Load the first Currency and Location to the temporary Array after
      ** validation
      ** First Combination should atleast have a currency code defined

     C                   If        CCYArr(WCtr) = *blanks and
     C                             LOCArr(WCtr) <> *blanks
     C                   Eval      Idx = Idx + 1
     C                   Eval      OKFlagDS2(WCtr) = 'N'
     C                   Eval      MsgIdArr(Idx) = '5048505'
     C                   Eval      FldError = 'LOC'
     C                   Eval      Fidx = Fidx + 1
     C                   Exsr      SrFldn
     C                   Endif

     C                   Eval      CCYArrV(WCtr) = CCYArr(WCtr)
     C                   Eval      LOCArrV(WCtr) = LOCArr(WCtr)
     C                   Eval      WCtr = WCtr + 1

     C                   Dow       WCtr <= 10

     C                   Eval      ArrIdxC  = %LOOKUP(CCYArr(WCtr) :CCYArrV)
     C                   Eval      ArrIdxL  = %LOOKUP(LOCArr(WCtr) :LOCArrV)

     C                   If        ( CCYArr(WCtr) <> *blanks and
     C                               LOCArr(WCtr) <> *blanks) or
     C                               CCYArr(Wctr) <> *blanks

      ** If the Index Retrieved from Currency Array and Location Array is the same
      ** Current Combination is already existing.

     C                   If        (ArrIdxC <> 0 and ArrIdxL <> 0) or
     C                             (ArrIdxC <> 0)

     C                   Eval      ArrLKPC = WCtr

     C                   Dow       ArrIdxC <> 0 and
     C                             ArrLKPC <= WCtr

     C                   Eval      ArrLKPL = 1

     C                   Dow       ArrIdxL <> 0   and
     C                             ArrLKPL <= WCtr

     C                   IF        ArrIdxC = ArrIdxL

      ** Issue Error Message Currency/Location Combination not unique

     C                   Eval      Idx = Idx + 1
     C                   Eval      OKFlagDS1(WCtr) = 'N'
     C                   Eval      MsgIdArr(idx) = '5048504'
     C                   Eval      FldError = 'CCY'
     C                   Eval      Fidx = Fidx + 1
     C                   Exsr      SrFldn
     C                   Eval      Idx = Idx + 1
     C                   Eval      OKFlagDS2(WCtr) = 'N'
     C                   Eval      MsgIdArr(idx) = '5048504'
     C                   Eval      Fidx = Fidx + 1
     C                   Eval      FldError = 'LOC'
     C                   Exsr      SrFldn
     C                   Leave
     C                   Endif


     C                   Eval      ArrIdxL = %LOOKUP
     C                             (LOCArr(WCtr) : LOCArrV : ArrLKPL)
     C                   Eval      ArrLKPL = ArrLKPL + 1


     C                   Enddo


     C                   Eval      ArrIdxC = %LOOKUP
     C                             (CCYArr(WCtr) : CCYArrV : ArrLKPC)
     C                   Eval      ArrLKPC = ArrLKPC + 1

     C                   Enddo

     C                   Endif

      ** Location Code Cannot be specified without Currency Code

     C                   Elseif    CCYArr(Wctr) = *blanks and
     C                             LOCArr(Wctr) <> *blanks

     C                   Eval      Idx = Idx + 1
     C                   Eval      OKFlagDS2(WCtr) = 'N'
     C                   Eval      MsgIdArr(Idx) = '5048505'
     C                   Eval      FldError = 'LOC'
     C                   Eval      Fidx = Fidx + 1
     C                   Exsr      SrFldn

     C                   Endif

     C                   Eval      CCYArrV(WCtr) = CCYArr(WCtr)
     C                   Eval      LOCArrV(WCtr) = LOCArr(WCtr)
     C                   Eval      WCtr = WCtr + 1

     C                   Enddo

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFldN - Passes Appropriate Field Name                        *
      *                                                               *
      * Called by: SrVlCrLc,                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrFldn        Begsr

      **  Set Field Names to be passed when error is encountered

     C                   If        LoanITYPE = 'RARF'

     C                   If        FldError = 'CCY'
     C                   Select
     C                   When      WCtr = 1
     C                   Eval      FldNameArr(Fidx) = 'DDC1PR'
     C                   When      WCtr = 2
     C                   Eval      FldNameArr(Fidx) = 'DDC2PR'
     C                   When      WCtr = 3
     C                   Eval      FldNameArr(Fidx) = 'DDC3PR'
     C                   When      WCtr = 4
     C                   Eval      FldNameArr(Fidx) = 'DDC4PR'
     C                   When      WCtr = 5
     C                   Eval      FldNameArr(Fidx) = 'DDC5PR'
     C                   When      WCtr = 6
     C                   Eval      FldNameArr(Fidx) = 'DDC6PR'
     C                   When      WCtr = 7
     C                   Eval      FldNameArr(Fidx) = 'DDC7PR'
     C                   When      WCtr = 8
     C                   Eval      FldNameArr(Fidx) = 'DDC8PR'
     C                   When      WCtr = 9
     C                   Eval      FldNameArr(Fidx) = 'DDC9PR'
     C                   When      WCtr = 10
     C                   Eval      FldNameArr(Fidx) = 'DDC0PR'
     C                   Endsl
     C                   Endif

     C                   If        FldError = 'LOC'
     C                   Select
     C                   When      WCtr = 1
     C                   Eval      FldNameArr(Fidx) = 'DDL1PR'
     C                   When      WCtr = 2
     C                   Eval      FldNameArr(Fidx) = 'DDL2PR'
     C                   When      WCtr = 3
     C                   Eval      FldNameArr(Fidx) = 'DDL3PR'
     C                   When      WCtr = 4
     C                   Eval      FldNameArr(Fidx) = 'DDL4PR'
     C                   When      WCtr = 5
     C                   Eval      FldNameArr(Fidx) = 'DDL5PR'
     C                   When      WCtr = 6
     C                   Eval      FldNameArr(Fidx) = 'DDL6PR'
     C                   When      WCtr = 7
     C                   Eval      FldNameArr(Fidx) = 'DDL7PR'
     C                   When      WCtr = 8
     C                   Eval      FldNameArr(Fidx) = 'DDL8PR'
     C                   When      WCtr = 9
     C                   Eval      FldNameArr(Fidx) = 'DDL9PR'
     C                   When      WCtr = 10
     C                   Eval      FldNameArr(Fidx) = 'DDL0PR'

     C                   Endsl
     C                   Endif

     C                   Elseif    LoanITYPE = 'IPRI'

     C                   If        FldError = 'CCY'
     C                   Select
     C                   When      WCtr = 1
     C                   Eval      FldNameArr(Fidx) = 'DDC1PI'
     C                   When      WCtr = 2
     C                   Eval      FldNameArr(Fidx) = 'DDC2PI'
     C                   When      WCtr = 3
     C                   Eval      FldNameArr(Fidx) = 'DDC3PI'
     C                   When      WCtr = 4
     C                   Eval      FldNameArr(Fidx) = 'DDC4PI'
     C                   When      WCtr = 5
     C                   Eval      FldNameArr(Fidx) = 'DDC5PI'
     C                   When      WCtr = 6
     C                   Eval      FldNameArr(Fidx) = 'DDC6PI'
     C                   When      WCtr = 7
     C                   Eval      FldNameArr(Fidx) = 'DDC7PI'
     C                   When      WCtr = 8
     C                   Eval      FldNameArr(Fidx) = 'DDC8PI'
     C                   When      WCtr = 9
     C                   Eval      FldNameArr(Fidx) = 'DDC9PI'
     C                   When      WCtr = 10
     C                   Eval      FldNameArr(Fidx) = 'DDC0PI'
     C                   Endsl
     C                   Endif

     C                   If        FldError = 'LOC'
     C                   Select
     C                   When      WCtr = 1
     C                   Eval      FldNameArr(Fidx) = 'DDL1PI'
     C                   When      WCtr = 2
     C                   Eval      FldNameArr(Fidx) = 'DDL2PI'
     C                   When      WCtr = 3
     C                   Eval      FldNameArr(Fidx) = 'DDL3PI'
     C                   When      WCtr = 4
     C                   Eval      FldNameArr(Fidx) = 'DDL4PI'
     C                   When      WCtr = 5
     C                   Eval      FldNameArr(Fidx) = 'DDL5PI'
     C                   When      WCtr = 6
     C                   Eval      FldNameArr(Fidx) = 'DDL6PI'
     C                   When      WCtr = 7
     C                   Eval      FldNameArr(Fidx) = 'DDL7PI'
     C                   When      WCtr = 8
     C                   Eval      FldNameArr(Fidx) = 'DDL8PI'
     C                   When      WCtr = 9
     C                   Eval      FldNameArr(Fidx) = 'DDL9PI'
     C                   When      WCtr = 10
     C                   Eval      FldNameArr(Fidx) = 'DDL0PI'

     C                   Endsl

     C                   Endif

     C                   Endif

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        Begsr

     C     *Entry        Plist
     C                   Parm                    RetCodeIn
     C                   Parm                    LCUR              3
     C                   Parm                    PCUR             30
     C                   Parm                    PLOC             30
     C                   Parm                    LoanITYPE         4
     C                   Parm                    OKFlagDs1
     C                   Parm                    OKFlagDs2
     C                   Parm                    MsgIdArr
     C                   Parm                    FldNameArr
     C

      ** Initialize Work Variables

     C                   Eval      RetCodeIn = *blanks
     C                   Eval      OKFlagDs1 = *All'Y'
     C                   Eval      OKFlagDs2 = *All'Y'
     C                   Eval      Idx = 0

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
