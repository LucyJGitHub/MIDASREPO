     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Internal Funding Deals Amend Checking')       *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Funding Module                              *
      *                                                               *
      *  ABFUNDAMD - Internal Funding Deals Amend Checking            *
      *                                                               *
      *  Function:  This module will compare the fields of an amended *
      *             Internal Funding Deal against those currently on  *
      *             file.  This module will also check whether all    *
      *             fields amended are amendable, and if not, an      *
      *             error message will be sent to calling module      *
      *                                                               *
      *  Component of: ABFUNDSIN                                      *
      *                ABFUNECTL                                      *
      *                ABFUNDRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR1083027          Date 31Jan13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BUG24231           Date 18Jun09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL039             Date 22Aug05               *
      *                 CDL038             Date 10May05               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP042  *CREATE    Date 08Jan01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1083027 - Fix Base Rate error appeared when another field  *
      *              is being amended                                 *
      *  BUG24231 - Format the actual interest rate to avoid getting  *
      *             the error message during amendment                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL039 - Amendable Deal Sub Types & Classes                  *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CDL020 - Apply Base Rate at Value Date                       *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *  CAP042 - Conversion of Internal Funding Deal inputs into     *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRResetFlds - Reset fields in Error                           *
      * SRCompFlds  - Compare whether all fields amended are amendable*
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
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
      **    False      logical = *off (for indicator processing)
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
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** The following /COPY includes the MM standard declares:
 
     D/COPY ZACPYSRC,STDDECLARE
 
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
 
      ** New Deal Screen Format
     D NewDealScnFmt E DS                  EXTNAME(ABFUNDPD)
     D                                     PREFIX(DD:2)
 
      ** Current Deal Screen Format
     D CurDealScnFmt E DS                  EXTNAME(ABFUNDPD)
     D                                     PREFIX(Cr:2)
 
      ** Externally described DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CDL039
      ** EXTERNAL DS FOR SAR DETAILS                                                          CDL039
                                                                                              CDL039
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CDL039
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                                   CDL039
                                                                                              CDL039
      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Internal Funding Deals Error Indicators File
     D OkFlags       E DS                  EXTNAME(ABEFUNDPD)
 
      **                                                                                    BUG24231
     D                 DS                                                                   BUG24231
     D XAIR                    1     12                                                     BUG24231
     D YAIR                    2     12                                                     BUG24231
                                                                                            BUG24231
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRTCD           S              7
     D POPTN           S              7
     D PKey            S              3A
     D AmendOk         S              1
     D ResetErrs       S              1
 
      ** Index for arrays of error message ids
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids
     D WIdx            S              3P 0
 
      ** Originating Branch fiels from SDGELRPD
     D BKOBRU          S              1
 
      ** Data Area giving Installation Control Details
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
     D  MBIN                  13     13
 
      ** Parameters for ZA0921
     D WAmountIn       S             15  0
     D WDecPlcIn       S              1  0
     D BNDCSP          S              1
     D WAmountOS       S             16A
     D WAmountOU       S             17A
 
      ** Parameters for ZA0840
     D PRetCode        S                   LIKE(ReturnCode)
     D PAlpha          S             16A
     D PIDP            S              3  0
     D PIINT           S              3  0
     D PIMTID          S              1A
     D POErrCde        S              1  0
     D POAmount        S             15  0
 
     D PValFlg         S              1A
 
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
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
     C                   EXSR      SRCompFlds
 
      ** If any errors were found:
      **   Set Amendments OK Indicator to 'N'
 
     C                   IF        Idx > 0
     C                   EVAL      AmendOK = 'N'
     C                   ELSE
     C                   EVAL      AmendOK = 'Y'
     C                   ENDIF
 
      ** If any errors were found:
      ** - and reset of fields in error required, do this
 
     C                   IF        Idx > 0 and ResetErrs = 'Y'
     C                   EXSR      SRResetFld
     C                   ENDIF
 
      ** Return to calling program
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCompFlds - Compare whether all fields amended are amendable *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRCompFlds    BEGSR
 
      ** Branch Code #1
      ** Booking branch code validation only when Multi-branching
      ** indicator is on.
 
     C                   IF        MBIN = 'Y' and DDBRC1 <> CrBRC1
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1BRC1'
     C                   EVAL      MsgIDArr(Idx)   = 'ABM0551'
     C                   EVAL      OkBRC1          = 'N'
     C                   ENDIF
 
      ** Deal sub-type #1
      ** Amendable if CDL039 is ON                                                            CDL039
 
     C                   IF        DDSTP1 <> CrSTP1
     C                             AND CDL039  = 'N'                                          CDL039
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1STP1'
     C                   EVAL      MsgIDArr(Idx)   = 'ABM0552'
     C                   EVAL      OkSTP1          = 'N'
     C                   ENDIF
 
      ** Associated Deal Number
 
     C                   IF        DDDADN <> CrDADN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1DADN'
     C                   EVAL      MsgIDArr(Idx)   = 'ABM0566'
     C                   EVAL      OkDADN          = 'N'
     C                   ENDIF
 
      ** Branch Code #2
 
     C                   IF        DDBRC2 <> CrBRC2
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1BRC2'
     C                   EVAL      MsgIDArr(Idx)   = 'ABM0553'
     C                   EVAL      OkBRC2          = 'N'
     C                   ENDIF
 
      ** Deal sub-type #2
      ** Amendable if CDL039 is ON                                                            CDL039
 
     C                   IF        DDSTP2 <> CrSTP2
     C                             AND CDL039  = 'N'                                          CDL039
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1STP2'
     C                   EVAL      MsgIDArr(Idx)   = 'ABM0554'
     C                   EVAL      OkSTP2          = 'N'
     C                   ENDIF
 
      ** Deal Date
 
     C                   IF        DDDDAT <> CrDDAT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1DDAT'
     C                   EVAL      MsgIDArr(Idx)   = 'ABM0555'
     C                   EVAL      OkDDAT          = 'N'
     C                   ENDIF
 
      ** Value Date
 
     C                   IF        DDVDAT <> CrVDAT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1VDAT'
     C                   EVAL      MsgIDArr(Idx)   = 'ABM0556'
     C                   EVAL      OkVDAT          = 'N'
     C                   ENDIF
 
      ** Notice Days
 
     C                   IF        DDNTCE <> CrNTCE AND
     C                             PValFlg <>  'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1NTCE'
     C                   EVAL      MsgIDArr(Idx)   = 'ABM0557'
     C                   EVAL      OkNTCE          = 'N'
     C                   ENDIF
 
      ** Currency Code
 
     C                   IF        DDCCY <> CrCCY
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1CCY'
     C                   EVAL      MsgIDArr(Idx)   = 'ABM0558'
     C                   EVAL      OkCCY           = 'N'
     C                   ENDIF
 
      ** Principal Amount
 
     C                   EXSR      SRFmtAmnp
 
     C                   IF        DDAMNP <> CrAMNP
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1AMNP'
     C                   EVAL      MsgIDArr(Idx)   = 'ABM0559'
     C                   EVAL      OkAMNP          = 'N'
     C                   ENDIF
 
      ** Rate/Spread
 
     C                   EXSR      SRFmtRTSP
 
     C                   IF        DDRTSP <> CrRTSP
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1RTSP'
     C                   EVAL      MsgIDArr(Idx)   = 'ABM0560'
     C                   EVAL      OkRTSP          = 'N'
     C                   ENDIF
 
      ** Interest Calculation Basis
 
     C                   IF        DDICBS <> CrICBS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1ICBS'
     C                   EVAL      MsgIDArr(Idx)   = 'ABM0561'
     C                   EVAL      OkICBS          = 'N'
     C                   ENDIF
 
      ** Total Interest
 
     C                   EXSR      SRFmtTOTI
 
     C                   IF        DDTOTI <> CrTOTI  and
     C                             DDMDAT =  CrMDAT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1TOTI'
     C                   EVAL      MsgIDArr(Idx)   = 'ABM0562'
     C                   EVAL      OkTOTI          = 'N'
     C                   ENDIF
 
      ** Capitalise Interest Indicator
 
     C                   IF        DDCPTI <> CrCPTI
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1CPTI'
     C                   EVAL      MsgIDArr(Idx)   = 'ABM0563'
     C                   EVAL      OkCPTI          = 'N'
     C                   ENDIF
 
      ** Originating Branch Code
 
     C                   IF        MBIN = 'Y' and BKOBRU = 'Y' and
     C                             DDORBR <>  CRORBR
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1ORBR'
     C                   EVAL      MsgIDArr(Idx)   = 'ABM0564'
     C                   EVAL      OkORBR          = 'N'
     C                   ENDIF
                                                                                              CDL019
      ** Fix Base Rate                                                                        CDL019
                                                                                              CDL019
     C                   IF        CDL019 = 'Y'                                               CDL019
     C                   IF        CrFBRT = *BLANKS                                        AR1083027
     C                   EVAL      CrFBRT = 'N'                                            AR1083027
     C                   ENDIF                                                             AR1083027
     C                   IF        DDFBRT <> CrFBRT                                           CDL019
     C                   ADD       1             Idx                                          CDL019
     C                   EVAL      FldNameArr(Idx) = '#1FBRT'                                 CDL019
     C                   EVAL      MsgIDArr(Idx)   = 'ABM0569'                                CDL019
     C                   EVAL      OkFBRT          = 'N'                                      CDL019
     C                   ENDIF                                                                CDL019
     C                   ENDIF                                                                CDL019
                                                                                              CDL020
      ** Actual Interest Rate                                                                 CDL020
                                                                                              CDL020
     C                   IF        CDL020 = 'Y'                                               CDL020
     C                   MOVE      DDAIR         XAIR                                       BUG24231
     C**********         IF        DDAIR <> CrAIR                                    CDL020 BUG24231
     C                   IF        YAIR  <> CrAIR                                           BUG24231
     C                   ADD       1             Idx                                          CDL020
     C                   EVAL      FldNameArr(Idx) = '#1AIR'                                  CDL020
     C                   EVAL      MsgIDArr(Idx)   = 'ABM0570'                                CDL020
     C                   EVAL      OkAIR           = 'N'                                      CDL020
     C                   ENDIF                                                                CDL020
     C                   ENDIF                                                                CDL020
                                                                                              CDL038
      ** Deal class #1                                                                        CDL038
      ** Amendable if CDL039 is ON                                                            CDL039
                                                                                              CDL038
     C                   IF        DDCLS1 <> CrCLS1                                           CDL038
     C                             AND CDL039  = 'N'                                          CDL039
     C                   ADD       1             Idx                                          CDL038
     C                   EVAL      FldNameArr(Idx) = '#1CLS1'                                 CDL038
     C                   EVAL      MsgIDArr(Idx)   = 'ABM0571'                                CDL038
     C                   EVAL      OkCLS1          = 'N'                                      CDL038
     C                   ENDIF                                                                CDL038
                                                                                              CDL038
      ** Deal class #2                                                                        CDL038
      ** Amendable if CDL039 is ON                                                            CDL039
                                                                                              CDL038
     C                   IF        DDCLS2 <> CrCLS2                                           CDL038
     C                             AND CDL039  = 'N'                                          CDL039
     C                   ADD       1             Idx                                          CDL038
     C                   EVAL      FldNameArr(Idx) = '#1CLS2'                                 CDL038
     C                   EVAL      MsgIDArr(Idx)   = 'ABM0572'                                CDL038
     C                   EVAL      OkCLS2          = 'N'                                      CDL038
     C                   ENDIF                                                                CDL038
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRResetFld - Reset fields in Error                            *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRResetFld    BEGSR
 
      ** Branch Code #1
 
     C                   IF        OkBRC1 = 'N'
     C                   EVAL      DDBRC1 = CrBRC1
     C                   ENDIF
 
      ** Deal sub-type #1
 
     C                   IF        OkSTP1 = 'N'
     C                   EVAL      DDSTP1 = CrSTP1
     C                   ENDIF
 
      ** Associated Deal Number
 
     C                   IF        OkDADN = 'N'
     C                   EVAL      DDDADN = CrDADN
     C                   ENDIF
 
      ** Branch Code #2
 
     C                   IF        OkBRC2 = 'N'
     C                   EVAL      DDBRC2 = CrBRC2
     C                   ENDIF
 
      ** Deal sub-type #2
 
     C                   IF        OkSTP2 = 'N'
     C                   EVAL      DDSTP2 = CrSTP2
     C                   ENDIF
 
      ** Deal Date
 
     C                   IF        OkDDAT = 'N'
     C                   EVAL      DDDDAT = CrDDAT
     C                   ENDIF
 
      ** Value Date
 
     C                   IF        OkVDAT = 'N'
     C                   EVAL      DDVDAT = CrVDAT
     C                   ENDIF
 
      ** Notice Days
 
     C                   IF        OkNTCE = 'N'
     C                   EVAL      DDNTCE = CrNTCE
     C                   ENDIF
 
      ** Currency Code
 
     C                   IF        OkCCY  = 'N'
     C                   EVAL      DDCCY = CrCCY
     C                   ENDIF
 
      ** Principal Amount
 
     C                   IF        OkAMNP = 'N'
     C                   EVAL      DDAMNP = CrAMNP
     C                   ENDIF
 
      ** Rate/Spread
 
     C                   IF        OkRTSP = 'N'
     C                   EVAL      DDRTSP = CrRTSP
     C                   ENDIF
 
      ** Interst Calculation Basis
 
     C                   IF        OkICBS = 'N'
     C                   EVAL      DDICBS = CrICBS
     C                   ENDIF
 
      ** Total Interest
 
     C                   IF        OkTOTI = 'N'
     C                   EVAL      DDTOTI = CrTOTI
     C                   ENDIF
 
      ** Capitalise Interest Indicator
 
     C                   IF        OkCPTI = 'N'
     C                   EVAL      DDCPTI = CrCPTI
     C                   ENDIF
 
      ** Originating Branch Code
 
     C                   IF        OkORBR = 'N'
     C                   EVAL      DDORBR = CrORBR
     C                   ENDIF
                                                                                              CDL019
      ** Fix Base Rate                                                                        CDL019
                                                                                              CDL019
     C                   IF        CDL019 = 'Y'                                               CDL019
     C                   IF        OkFBRT = 'N'                                               CDL019
     C                   EVAL      DDFBRT = CrFBRT                                            CDL019
     C                   ENDIF                                                                CDL019
     C                   ENDIF                                                                CDL019
                                                                                              CDL020
      ** Actual Interest Rate                                                                 CDL020
                                                                                              CDL020
     C                   IF        CDL020 = 'Y'                                               CDL020
     C                   IF        OkAIR = 'N'                                                CDL020
     C                   EVAL      DDAIR = CrAIR                                              CDL020
     C                   ENDIF                                                                CDL020
     C                   ENDIF                                                                CDL020
                                                                                              CDL038
      ** Deal class #1                                                                        CDL038
                                                                                              CDL038
     C                   IF        OkCLS1 = 'N'                                               CDL038
     C                   EVAL      DDCLS1 = CrCLS1                                            CDL038
     C                   ENDIF                                                                CDL038
                                                                                              CDL038
      ** Deal class #2                                                                        CDL038
                                                                                              CDL038
     C                   IF        OkCLS2 = 'N'                                               CDL038
     C                   EVAL      DDCLS2 = CrCLS2                                            CDL038
     C                   ENDIF                                                                CDL038
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFmtAmnp - Format Amount for compare                         *
      *                                                               *
      * Called by: SRCompFlds                                         *
      *                                                               *
      * Calls:     SRZA0840, SRZA0921                                 *
      *                                                               *
      *****************************************************************
     C     SRFmtAmnp     BEGSR
 
      ** Get the no. of Decimal place
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      CrCCY         PKey
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Format Principal Amount
 
     C                   Z-ADD     A6NBDP        PIDP
     C     13            Sub       PIDP          PIINT
     C                   MOVE      *Blanks       PAlpha
     C                   MOVE      DDAMNP        PAlpha
     C                   Z-ADD     *Zero         POAmount
     C                   MOVE      'Y'           PIMTID
 
     C                   EXSR      SRZA0840
 
     C                   Z-ADD     POAmount      WAmountIn
     C                   Z-ADD     A6NBDP        WDecPlcIn
 
     C                   EXSR      SRZA0921
 
     C                   MOVE      WAmountOS     DDAMNP
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFmtRTSP - Format Rate/Spread for compare                    *
      *                                                               *
      * Called by: SRCompFlds                                         *
      *                                                               *
      * Calls:     SRZA0840, SRZA0921                                 *
      *                                                               *
      *****************************************************************
     C     SRFmtRTSP     BEGSR
 
     C                   Z-ADD     7             PIDP
     C                   Z-ADD     4             PIINT
     C                   MOVE      *Blanks       PAlpha
     C                   MOVE      DDRTSP        PAlpha
     C                   Z-ADD     *Zero         POAmount
     C                   MOVE      'N'           PIMTID
 
     C                   EXSR      SRZA0840
 
     C                   Z-ADD     POAMount      WAmountIn
     C                   Z-ADD     7             WDecPlcIn
 
     C                   EXSR      SRZA0921
 
     C                   MOVE      WAmountOS     DDRTSP
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFmtTOTI - Format Total Interest for compare                 *
      *                                                               *
      * Called by: SRCompFlds                                         *
      *                                                               *
      * Calls:     SRZA0840, SRZA0921                                 *
      *                                                               *
      *****************************************************************
     C     SRFmtTOTI     BEGSR
 
     C                   Z-ADD     A6NBDP        PIDP
     C     13            Sub       PIDP          PIINT
     C                   MOVE      *Blanks       PAlpha
     C                   MOVE      DDTOTI        PAlpha
     C                   Z-ADD     *Zero         POAmount
     C                   MOVE      'N'           PIMTID
 
     C                   EXSR      SRZA0840
 
     C                   Z-ADD     POAmount      WAmountIn
     C                   Z-ADD     A6NBDP        WDecPlcIn
 
     C                   EXSR      SRZA0921
 
     C                   MOVE      WAmountOS     DDTOTI
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZA0840 - Validate field is numeric                          *
      *                                                               *
      * Called by: SRCompFlds                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRZA0840      BEGSR
 
     C                   CALLB     'ZA0840'
     C                   PARM                    PRetCode
     C                   PARM                    PAlpha
     C                   PARM                    PIDP
     C                   PARM                    PIINT
     C                   PARM                    PIMTID
     C                   PARM                    POErrCde
     C                   PARM                    POAmount
     C                   PARM                    BNDCSP
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZA0921 - Format amount for output                           *
      *                                                               *
      * Called by: SRCompFlds                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRZA0921      BEGSR
 
     C                   CALLB     'ZA0921'
     C                   PARM                    PRTCD
     C                   PARM                    WAmountIn
     C                   PARM                    WDecPlcIn
     C                   PARM                    BNDCSP
     C                   PARM                    WAmountOS
     C                   PARM                    WAmountOU
 
     C                   ENDSR
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
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Inputs
      ** Return Code
      ** New Deal in Screen Format
      ** Current Deal in Screen Format
      ** Reset of Fields in Error Required (Y/N)
 
     C                   PARM                    RetCodeIn
     C                   PARM                    NewDealScnFmt
     C                   PARM                    CurDealScnFmt
     C                   PARM                    ResetErrs
 
      ** Originating Branch Used
 
     C                   PARM                    BKOBRU
 
      ** SDDEALPD: Decimal Separator
 
     C                   PARM                    BNDCSP
                                                                                              CDL019
      ** Allow Base Rate Changes on Fixed Deposits/Loans                                      CDL019
     C                   PARM                    CDL019            1                          CDL019
                                                                                              CDL020
      ** Apply Base Rate at Value Date                                                        CDL020
     C                   PARM                    CDL020            1                          CDL020
 
      ** Output
      ** Field Ok Flags from/to caller
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
 
     C                   PARM                    OkFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
 
      ** Amendments Ok
 
     C                   PARM                    AmendOk
 
      ** Amended by validation module flag
 
     C                   PARM                    PValFlg
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
 
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
     C/COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
