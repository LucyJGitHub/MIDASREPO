     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Invalid Principal Change Sched Retrieval')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRIPCSCRT - Invalid Principal Change Schedule Retrieval      *
      *                                                               *
      *  Function:  This module will retrieve the Invalid Principal   *
      *             Change Schedule IRIPCSCL0 and update DLPCSCPD.    *
      *             This enables the dates/amounts to be worked upon  *
      *             in the Repair function.                           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 239491             Date 14Mar06               *
      *                 CAP043  *CREATE    Date 02May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  239491 - Decimal data error occurred when the principal      *
      *           change amount is blank.                             *
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
      *  SRUpdate      -  Update DLPCSC thru DLTPCSC file             *
      *  SRGetInDat    -  Get 'Invalid' Principal Change Schedule     *
      *  SRUpdDtFil    -  Update Date Schedule Files                  *
      *  SRValInDat    -  Validate 'Invalid' Principal Change Schedule*
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
 
     FDLTPCSCL0 IF   E           K DISK    PREFIX(T)
     F                                     RENAME(DLPCSCD0:DLTPCSCT0)
     FDLTPCSCPD UF A E           K DISK
     F                                     RENAME(DLPCSCD0:DLTPCSCD0)
     F                                     COMMIT
      ** Dealing Temporary Principal Change Date
 
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
 
     D PCSCTemp      E DS                  EXTNAME(DLTPCSCPD)
 
     D PCSCUpd       E DS                  EXTNAME(DLPCSCPD) PREFIX(X)
 
      ** Principal Change dates
     D IPCDates      E DS                  EXTNAME(IRIPCSCPD)
     D DatesToVal             23    514
     D AmntsToVal            515   1826
     D IndicToVal           1827   1908    DIM(82)
 
      ** Principal Change dates as day numbers
     D                 DS
     D  AlpDate                1    246A
     D  NumDate                1    246P 0 DIM(82)
 
      ** Principal Change Amounts
     D                 DS
     D  AlpAmnt                1    656A
     D  NumAmnt                1    656P 0 DIM(82)
     D  AlpAmntZ               1    656A   DIM(82)                                            239491
 
      ** Our Principal Change dates - invalid - as day numbers
     D                 DS
     D  UPADateI               1    246A
     D  UPNDateI               1    246P 0 DIM(82)
 
      ** Their Principal Change dates - invalid - as day numbers
     D                 DS
     D  TPADateI               1    246A
     D  TPNDateI               1    246P 0 DIM(82)
 
      ** Our Principal Change amounts - invalid
     D                 DS
     D  UPAAmntI               1    656A
     D  UPNAmntI               1    656P 0 DIM(82)
 
      ** Their Prinicpal Change amounts - invalid
     D                 DS
     D  TPAAmntI               1    656A
     D  TPNAmntI               1    656P 0 DIM(82)
 
      ** Confirmed Holiday indicators output field
     D ConfHolDS       DS
     D  WConfHol                      1A   DIM(82)
 
     D PErrorFndPr     DS
     D   OurPrinEr             1      1
     D   ThrPrinEr             2      2
 
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
     D WPAMT           S             15  0
     D WCTLDYN         S              5  0
     D PBGN2ST         S              1A
     D PPAmt           S             15  0
 
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
      * SRGetInDat - Get 'Invalid' Principal Change Schedule          *
      *                                                               *
      *****************************************************************
 
     C     SRGetInDat    BEGSR
 
      ** Initialize Our/Their Principal change dates
 
     C                   Z-ADD     *ZERO         UPNDateI
     C                   Z-ADD     *ZERO         TPNDateI
 
      ** Initialize Our/Their Principal change amounts
 
     C                   Z-ADD     *ZERO         UPNAmntI
     C                   Z-ADD     *ZERO         TPNAmntI
 
     C                   EVAL      OTIN = TOURTHR
 
      ** If a date schedule is present, validate it and if valid, store
      ** the date in the appropriate date array
 
     C                   IF        DatesToVal <> *Blanks
     C                   EXSR      SRValInDat
     C                   IF        OKDates = 'Y'
 
     C                   SELECT
     C                   WHEN      (OTIN = 'U') OR (OTIN = *BLANK)
     C                   MOVE      ValidDates    UPADateI
     C                   MOVE      PValidCAmt    UPAAmntI
 
     C                   WHEN      OTIN = 'T'
     C                   MOVE      ValidDates    TPADateI
     C                   MOVE      PValidCAmt    TPAAmntI
     C                   ENDSL
 
     C                   ENDIF
 
      ** If error found, set error found parameter to 'Y'
 
     C                   IF        OkDates = 'N'
     C                   SELECT
     C                   WHEN      (OTIN = 'U') OR (OTIN = *BLANK)
     C                   EVAL      OurPrinEr = 'Y'
     C                   WHEN      OTIN = 'T'
     C                   EVAL      ThrPrinEr = 'Y'
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValInDat - Validate 'Invalid' Principal Change Date Sched   *
      *                                                               *
      *****************************************************************
      *****************************************************************
 
     C     SRValInDat    BEGSR
 
     C                   MOVE      DLNO          PDealNo
 
      ** Override DLDETUL0 to SHARE(*NO) to avoid unexpected error
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    POverride
     C                   PARM      32            POvrLen
 
     C                   MOVEA     InDicToVal    PIncDecInd
 
     C                   CALLB     'IRVIRCVAL'
     C                   PARM                    ReturnCode
     C                   PARM                    RSVDAT
     C                   PARM                    RSMDAT
     C                   PARM                    PCtlDate
     C                   PARM                    BJDFIN
     C                   PARM                    PAction
     C                   PARM                    PDealNo
     C                   PARM                    PPrevDate
     C                   PARM      'P'           PValType
     C                   PARM      TOURTHR       POurTheir
     C                   PARM                    PCurrency
     C                   PARM                    DatesToVal
     C                   PARM      *BLANK        PAmount1
     C                   PARM      AmntsToVal    PAmount2
     C                   PARM                    PIncDecInd
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
 
      ** Update Date Schedule Records - Our Principal Change
 
     C                   IF        (OTIN = 'U') OR (OTIN = *BLANK)
     C                   IF        UPADateI <> *Blank
     C                   MOVE      UPADateI      AlpDate
     C                   MOVE      UPAAmntI      AlpAmnt
     C                   EXSR      SRWrtDtScr
     C                   ENDIF
     C                   ENDIF
 
      ** Update Date Schedule Records - Their Cash Flow
 
     C                   IF        OTIN = 'T'
     C                   IF        TPADateI <> *Blank
     C                   MOVE      TPADateI      AlpDate
     C                   MOVE      TPAAmntI      AlpAmnt
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
 
     C     KIRSDP        SETLL     DLPCSCD0
     C     KIRSDP        READE     DLPCSCD0                               99
     C                   DOW       *IN99 = *OFF
     C                   IF        DTPR <> 'Y'
     C                   DELETE    DLPCSCD0
     C                   ENDIF
 
     C     KIRSDP        READE     DLPCSCD0                               99
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrtDtSCr - Write Date Schedule Records                      *
      *                                                               *
      *****************************************************************
 
     C     SRWrtDtScr    BEGSR
 
      ** Get principal change control date
 
     C                   EXSR      SRGetCtlDate
 
      ** Output all (non-processed) dates to the date schedule work file
 
     C                   Z-ADD     1             D
     C                   DOW       (D <= 82) AND (NumDate(D) <> *Zero)
     C                   Z-ADD     NumDate(D)    PRDT
     C                   IF        AlpAmntZ(D) = ' '                                          239491
     C                   Z-ADD     *ZERO         NumAmnt(D)                                   239491
     C                   ENDIF                                                                239491
     C                   Z-ADD     NumAmnt(D)    PAMT
     C                   Z-ADD     *ZERO         CAMT
     C                   EVAL      COHO = WConfHol(D)
     C                   EVAL      DTPR = *Blanks
     C                   EVAL      PMTP = *Blanks
 
      ** Midas-Plato Interface is switched on
 
     C                   IF        PBGN2ST = 'Y'
 
      ** Move amount to workfield for computation
 
     C                   Z-ADD     PAMT          WPAMT
 
      ** Calculate for the new principal amount
 
     C                   IF        InDicToVal(D) = 'D'
     C                   Z-SUB     WPAMT         WPAMT
     C                   ENDIF
 
      ** If date entered is on or prior to the control date, add the change amount
      ** to original principal amount
 
     C                   IF        PRDT <= WCTLDYN
     C                   EVAL      PAMT = PPAmt  + WPAMT
     C                   ELSE
 
      ** If date entered is between existing records, access the previous record and add
      ** change amount to the principal amount on this record
 
     C     KDLPCSC       SETLL     DLTPCSCL0
     C                   READP     DLTPCSCL0
 
     C                   IF        NOT %EOF(DLTPCSCL0) AND (DLNO = TDLNO) AND
     C                             (OTIN = TOTIN)
     C                   EVAL      PAMT = TPAMT + WPAMT
     C                   ELSE
     C                   EVAL      PAMT = PPAmt  + WPAMT
     C                   ENDIF
     C                   ENDIF
     C                   Z-ADD     WPAMT         CAMT
     C                   ENDIF
 
     C     KDLPCSC       CHAIN     DLTPCSCL0
     C                   IF        NOT %FOUND(DLTPCSCL0)
     C                   WRITE     DLTPCSCD0
     C                   ENDIF
     C                   EVAL      D = D + 1
     C                   ENDDO
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      * SRGetCtlDate - Get Control Date                                  *
      *                                                                  *
      ********************************************************************
 
     C     SRGetCtlDate  BEGSR
 
      ** Get control date - the first non-processed date
 
     C                   EVAL      PRDT = *ZERO
     C                   EVAL      WCTLDYN = *ZERO
 
     C     KDLPCSC       SETLL     DLTPCSCL0
     C     KIRSDP        READE     DLTPCSCL0
 
     C                   DOW       NOT %EOF(DLTPCSCL0) AND
     C                             WCTLDYN = *ZERO
     C                   IF        TDTPR <> 'Y'
     C                   Z-ADD     TPRDT         WCTLDYN
     C                   ENDIF
     C     KIRSDP        READE     DLTPCSCL0
     C                   ENDDO
 
      ** If nothing was found, default control date to next principal
      ** change date
 
     C                   IF        (WCTLDYN = *ZERO)
     C                   IF        (PCtlDate <> *ZERO)
     C                   EVAL      WCTLDYN = PCtlDate
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      * SRUpdate - Update DLPCSC thru DLTPCSC file                       *
      *                                                                  *
      ********************************************************************
 
     C     SRUpdate      BEGSR
 
     C                   EVAL      WDeletedU = 'N'
     C                   EVAL      WDeletedT = 'N'
 
      ** Write new records to DLPCSCPD
 
     C     *LOVAL        SETLL     DLTPCSCPD
     C                   READ      DLTPCSCPD
 
     C                   DOW       NOT %EOF(DLTPCSCPD)
 
      ** Delete old non-processed records from DLPCSCPD before writing new ones
 
     C                   IF        (OTIN = 'U') AND (WDeletedU = 'N') AND
     C                             (OurPrinEr = 'N') OR
     C                             (OTIN = *BLANK) AND (WDeletedU = 'N') AND
     C                             (OurPrinEr = 'N')
     C                   EXSR      SRDelDtScr
     C                   EVAL      WDeletedU = 'Y'
     C                   ENDIF
 
     C                   IF        (OTIN = 'T') AND (WDeletedT = 'N') AND
     C                             (ThrPrinEr = 'N')
     C                   EXSR      SRDelDtScr
     C                   EVAL      WDeletedT = 'Y'
     C                   ENDIF
 
      ** Only write to db file if there is no error for our or their principal change
 
     C                   IF        (OTIN = 'U') AND (OurPrinEr = 'N') OR
     C                             (OTIN = ' ') AND (OurPrinEr = 'N') OR
     C                             (OTIN = 'T') AND (ThrPrinEr = 'N')
     C                   EVAL      PCSCUpd = PCSCTemp
     C                   WRITE     DLPCSCD0
     C                   ENDIF
 
     C                   DELETE    DLTPCSCD0
     C                   READ      DLTPCSCPD
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
     C                   PARM                    PBGN2ST
     C                   PARM                    PCtlDate
     C                   PARM                    PPAmt
     C                   PARM                    BJDFIN
     C                   PARM                    PAction
     C                   PARM                    PUpdate
     C                   PARM                    PErrorFndPr
     C                   PARM                    IPCDates
     C                   PARM                    PPrevDate
     C                   PARM                    PCurrency
     C                   PARM                    PBDConvtn
 
     C     KDLPCSC       KLIST
     C                   KFLD                    DLNO
     C                   KFLD                    OTIN
     C                   KFLD                    PRDT
 
 
     C     KIRSDP        KLIST
     C                   KFLD                    DLNO
     C                   KFLD                    OTIN
 
      ** Define LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'IRIPCSCRT'
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
