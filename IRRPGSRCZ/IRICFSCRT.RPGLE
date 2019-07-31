     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Invalid Cash Flow Schedule Retrieval')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRICFSCRT - Invalid Cash Flow Schedule Retrieval             *
      *                                                               *
      *  Function:  This module will retrieve the Invalid Cash Flow   *
      *             Schedule from IRICFSCL0 and update DLCFSCPD. This *
      *             enables the dates/amounts to be worked upon in    *
      *             the Repair Function.                              *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CAP043  *CREATE    Date 02May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP043 - Additional APIs for IRS Schedules                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    99         READ indicator                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRUpdate      -  Update DLCFSC thru DLTCFSC file             *
      *  SRGetInDat    -  Get 'Invalid' Cash Flow Date Schedule       *
      *  SRUpdDtFil    -  Update Date Schedule Files                  *
      *  SRValInDat    -  Validate 'Invalid' Cash Flow Date Schedule  *
      *  SRWrtDtScr    -  Write Date Schedule Records                 *
      *  SRDelDtScr    -  Delete Date Schedule Records                *
      *  *PSSR         -  Error processing                            *
      *  *INZSR        -  Initialise                                  *
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
 
     FDLDETUL0  UF A E           K DISK    PREFIX(X)
     F                                     COMMIT
      ** Dealing IRS Details Update
 
     FDLTCFSCL0 IF   E           K DISK    PREFIX(T)
     F                                     RENAME(DLCFSCD0:DLTCFSCT0)
     FDLTCFSCPD UF A E           K DISK
     F                                     RENAME(DLCFSCD0:DLTCFSCD0)
     F                                     COMMIT
      ** Dealing Temporary Cash Flow Schedule
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area giving Installation Control Details
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
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
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
     D CFSCTemp      E DS                  EXTNAME(DLTCFSCPD)
 
     D CFSCUpd       E DS                  EXTNAME(DLCFSCPD) PREFIX(X)
 
      ** Cash Flow dates
     D ICFDates      E DS                  EXTNAME(IRICFSCPD)
     D DatesToVal             23    514
     D AmntsToVal            515   1662
 
      ** Cash Flow dates as day numbers
     D                 DS
     D  AlpDate                1    246A
     D  NumDate                1    246P 0 DIM(82)
 
      ** Cash Flow amounts
     D                 DS
     D  AlpAmnt                1    574A
     D  NumAmnt                1    574P 0 DIM(82)
 
      ** Our Cash Flow dates - invalid - as day numbers
     D                 DS
     D  UCADateI               1    246A
     D  UCNDateI               1    246P 0 DIM(82)
 
      ** Their Cash Flow dates - invalid - as day numbers
     D                 DS
     D  TCADateI               1    246A
     D  TCNDateI               1    246P 0 DIM(82)
 
      ** Our Cash Flow amounts - invalid
     D                 DS
     D  UCAAmntI               1    574A
     D  UCNAmntI               1    574P 0 DIM(82)
 
      ** Their Cash Flow amounts - invalid
     D                 DS
     D  TCAAmntI               1    574A
     D  TCNAmntI               1    574P 0 DIM(82)
 
      ** Confirmed Holiday indicators output field
  109D ConfHolDS       DS
     D  WConfHol                      1A   DIM(82)
 
     D PErrorFndCs     DS
     D   OurCashEr             1      1
     D   ThrCashEr             2      2
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work fields
     D D               S              3  0
     D Idx             S              3  0
     D WRun            S              1A
     D BJDFIN          S              1A
     D OKDates         S              1A
     D WCPY2           S             80A
     D SDLNO           S              6A
     D I#SDLNO         S              6A
     D RSVDAT          S              5  0
     D RSMDAT          S              5  0
     D PAction         S              1A
     D PDealNo         S              6A
     D PPrevDate       S              5P 0
     D POurTheir       S              1A
     D PValType        S              1A
     D PCurrency       S              3A
 
      ** IRC valid dates returned from IRVIRCVAL
     D ValidDates      S            246A   INZ(*BLANKS)
 
      ** Amounts to be validated (max 82)
     D PAmount1        S           1148A
 
      ** Amounts to be validated (max 82)
     D PAmount2        S           1312A
 
      ** Increase/Decrease indicator
     D PIncDecInd      S             82A
 
      ** Business Day Convention currencies
     D PBDConvtn       S             30A
 
      ** Confirmed Holiday Indicator
     D PConfHol        S             82A
 
      ** Output amounts
     D PValidAmnt      S            574A
     D PValidCAmt      S            656A
     D POverride       S             32A   INZ('OVRDBF FILE(DLDETUL0) +
     D                                            SHARE(*NO)')
     D POvrLen         S             15  5
     D PUpdate         S              1A
     D PCtlDate        S              5P 0
     D WDeletedU       S              1A
     D WDeletedT       S              1A
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** If update indicator is 'Y', update the db file thru temporary file
 
     C                   IF        (PUpdate = 'Y')
     C                   EXSR      SRUpdate
     C                   ELSE
 
      ** Use screen or automatic deal number
 
     C                   IF        SDLNO <> *BLANK
     C                   MOVEL     SDLNO         DLNO
     C                   ELSE
     C                   MOVEL     I#SDLNO       DLNO
     C                   ENDIF
 
      ** Get 'Invalid' Date Schedule
 
     C                   EXSR      SRGetInDat
 
      ** Update Date Schedule files
 
     C                   EXSR      SRUpdDtFil
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGetInDat - Get 'Invalid' Cash Flow Date Schedule            *
      *                                                               *
      *****************************************************************
 
     C     SRGetInDat    BEGSR
 
      ** Initialize Our/Their Cash Flow Dates
 
     C                   Z-ADD     *Zero         UCNDateI
     C                   Z-ADD     *Zero         TCNDateI
 
      ** Initialise Our/Their Cash Flow Amounts
 
     C                   Z-ADD     *Zero         UCNAmntI
     C                   Z-ADD     *Zero         TCNAmntI
 
     C                   EVAL      OTIN = SOURTHR
 
      ** If a date schedule is present, validate it and if valid, store
      ** the date in the appropriate date array
 
     C                   IF        DatesToVal <> *Blanks
     C                   EXSR      SRValInDat
     C                   IF        OKDates = 'Y'
 
     C                   SELECT
     C                   WHEN      OTIN = 'U'
     C                   MOVE      ValidDates    UCADateI
     C                   MOVE      PValidAmnt    UCAAmntI
 
     C                   WHEN      OTIN = 'T'
     C                   MOVE      ValidDates    TCADateI
     C                   MOVE      PValidAmnt    TCAAmntI
 
     C                   ENDSL
 
     C                   ENDIF
 
      ** If error found, set error found parameter to 'Y'
 
     C                   IF        OkDates = 'N'
     C                   SELECT
     C                   WHEN      OTIN = 'U'
     C                   EVAL      OurCashEr = 'Y'
     C                   WHEN      OTIN = 'T'
     C                   EVAL      ThrCashEr = 'Y'
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValInDat - Validate 'Invalid' Cash Flow Date Schedule       *
      *                                                               *
      *****************************************************************
      *****************************************************************
 
     C     SRValInDat    BEGSR
 
     C                   MOVE      DLNO          PDealNo
 
      ** Override DLDETUL0 to SHARE(*NO) to avoid unexpected error
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    POverride
     C                   PARM      32            POvrLen
 
     C                   CALLB     'IRVIRCVAL'
     C                   PARM                    ReturnCode
     C                   PARM                    RSVDAT
     C                   PARM                    RSMDAT
     C                   PARM      *ZERO         PCtlDate
     C                   PARM                    BJDFIN
     C                   PARM                    PAction
     C                   PARM                    PDealNo
     C                   PARM                    PPrevDate
     C                   PARM      'C'           PValType
     C                   PARM      SOURTHR       POurTheir
     C                   PARM                    PCurrency
     C                   PARM                    DatesToVal
     C                   PARM      AmntsToVal    PAmount1
     C                   PARM      *BLANK        PAmount2
     C                   PARM      *BLANK        PIncDecInd
     C                   PARM      *BLANK        PConfHol
     C                   PARM                    PBDConvtn
     C                   PARM      'Y'           OKDates
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM      *Zero         Idx
     C                   PARM                    ValidDates
     C                   PARM      *BLANK        PValidAmnt
     C                   PARM      *BLANK        PValidCAmt
 
     C                   MOVEL     PConfHol      ConfHolDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdDtFil - Update Date Schedule Files                       *
      *                                                               *
      *****************************************************************
 
     C     SRUpdDtFil    BEGSR
 
      ** Update Date Schedule Records - Our Cash Flow
 
     C                   IF        SOURTHR = 'U'
     C                   IF        UCADateI <> *Blank
     C                   MOVE      UCADateI      AlpDate
     C                   MOVE      UCAAmntI      AlpAmnt
     C                   EVAL      OTIN = 'U'
     C                   EXSR      SRWrtDtScr
     C                   ENDIF
     C                   ENDIF
 
      ** Update Date Schedule Records - Their Cash Flow
 
     C                   IF        SOURTHR = 'T'
     C                   IF        TCADateI <> *Blank
     C                   MOVE      TCADateI      AlpDate
     C                   MOVE      TCAAmntI      AlpAmnt
     C                   EVAL      OTIN = 'T'
     C                   EXSR      SRWrtDtScr
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelDtScr - Delete Date Schedule Records                     *
      *                                                               *
      *****************************************************************
 
     C     SRDelDtScr    BEGSR
 
     C     KDLCFSC       SETLL     DLCFSCD0
     C     KDLCFSC       READE     DLCFSCD0                               99
     C                   DOW       *IN99 = *OFF
 
      ** If date not processed
 
     C                   IF        DTPR <> 'Y'
     C                   DELETE    DLCFSCD0
     C                   ENDIF
 
     C     KDLCFSC       READE     DLCFSCD0                               99
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrtDtScr - Write Date Schedule Records                      *
      *                                                               *
      *****************************************************************
 
     C     SRWrtDtScr    BEGSR
 
      ** Output all (non-processed) dates to the date schedule work file
 
     C                   Z-ADD     1             D
     C                   DOW       (D <= 82) AND (NumDate(D) <> *Zero)
     C                   MOVE      NumDate(D)    PRDT
     C                   MOVE      NumAmnt(D)    CFLA
     C                   EVAL      COHO = WConfHol(D)
     C                   EVAL      DTPR = *Blanks
     C     KDLCFSC       CHAIN     DLTCFSCL0
     C                   IF        NOT %FOUND(DLTCFSCL0)
     C                   WRITE     DLTCFSCD0
     C                   ENDIF
     C                   EVAL      D = D + 1
     C                   ENDDO
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      * SRUpdate - Update DLCFSC thru DLTCFSC file                       *
      *                                                                  *
      ********************************************************************
 
     C     SRUpdate      BEGSR
 
     C                   EVAL      WDeletedU = 'N'
     C                   EVAL      WDeletedT = 'N'
 
      ** Write new records to DLCFSCPD
 
     C     *LOVAL        SETLL     DLTCFSCPD
     C                   READ      DLTCFSCPD
 
     C                   DOW       NOT %EOF(DLTCFSCPD)
 
      ** Delete old non-processed records from DLCFSCPD before writing new ones
 
     C                   IF        (OTIN = 'U') AND (WDeletedU = 'N') AND
     C                             (OurCashEr = 'N')
     C                   EXSR      SRDelDtScr
     C                   EVAL      WDeletedU = 'Y'
     C                   ENDIF
 
     C                   IF        (OTIN = 'T') AND (WDeletedT = 'N') AND
     C                             (ThrCashEr = 'N')
     C                   EXSR      SRDelDtScr
     C                   EVAL      WDeletedT = 'Y'
     C                   ENDIF
 
      ** Only write to db file if there is no error for our or their cash flow
 
     C                   IF        (OTIN = 'U') AND (OurCashEr = 'N') OR
     C                             (OTIN = 'T') AND (ThrCashEr = 'N')
     C                   EVAL      CFSCUpd = CFSCTemp
     C                   WRITE     DLCFSCD0
     C                   ENDIF
 
     C                   DELETE    DLTCFSCD0
     C                   READ      DLTCFSCPD
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    SDLNO
     C                   PARM                    I#SDLNO
     C                   PARM                    RSVDAT
     C                   PARM                    RSMDAT
     C                   PARM                    BJDFIN
     C                   PARM                    PAction
     C                   PARM                    PUpdate
     C                   PARM                    PErrorFndCs
     C                   PARM                    ICFDates
     C                   PARM                    PPrevDate
     C                   PARM                    PCurrency
     C                   PARM                    PBDConvtn
 
     C     KDLCFSC       KLIST
     C                   KFLD                    DLNO
     C                   KFLD                    OTIN
     C                   KFLD                    PRDT
 
      ** Define LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'IRICFSCRT'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
 
     C                   MOVEA     CPY@          WCPY2
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
