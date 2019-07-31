     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Convert File to Screen Function')                      *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLCOLACVT - GL Collateral Allocation Convert File to Screen  *
      *              Function Module                                  *
      *                                                               *
      *  Function:  This API module will serve as conversion of the   *
      *             file fields to screen fields for the whole API    *
      *             program and this will be made switchable under    *
      *             enhancement number CGL011.                        *
      *                                                               *
      *  Called By: GLCOLADSP                                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11623           Date 27Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 13Aug03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CGL011  *CREATE    Date 20Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  BUG11623 - Sequence No. column should be included (Recompile)*
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CAP084 - Recompiled over changed GLCOLAPD format.            *
      *  CGL011 - Collateral Processing for Midas.                    *
      *                                                               *
      *****************************************************************
 
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
 
      ** Include the standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      ** Collateral Allocation File Format
     D CrCAFilFmt    E DS                  EXTNAME(GLCOLAPD)
 
      ** Collateral Allocation Screen Format(Current)
     D GLCOLA        E DS                  EXTNAME(GLSCLAPD)
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Dealing ICD
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
 
      ** DS for Access Object Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for Access Object Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Data structure for account number
     D DSACNT          DS
     D  WSBRC                  1      3
     D  WSCNM                  4      9
     D  WSCCY                 10     12
     D**WSACD**               13     16                                                       CGL029
     D**WSSEQ**               17     18                                                       CGL029
     D  WSACD                 13     22                                                       CGL029
     D  WSSEQ                 23     24                                                       CGL029
 
 
      ** Data structure for Facility
     D DSFCTY          DS
     D  WFCTY1                 1      6
     D  WFCTY2                 7      9
     D  WFCTY3                10     11
 
      ** Workfield whether to access AOCURR0 or not
     D WAccess         S              1A   INZ('N')
 
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
 
      ** Initialise output data structure
 
     C                   Eval      GLCOLA = *Blanks
 
      ** Set output screen fields
 
     C                   ExSr      SrSetFld
     C                   Return
 
      *****************************************************************
      *                                                               *
      * SR/*InzSr: Initialisation Routine                             *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * AOBANKR0   Access Object                                      *
      *                                                               *
      *****************************************************************
 
     C     *InzSr        BegSr
 
      ** Entry Parameters
 
     C     *Entry        PList
     C                   Parm                    RetCodeOut
     C                   Parm                    CrCAFilFmt
     C                   Parm                    GLCOLA
     C                   Parm                    PColCur           3
 
      ** Format Program detail
 
     C                   Eval      DbPgm = 'GLCOLACVT'
 
      ** Access Bank Details via Access Object AOBANKR0
 
     C                   Call      'AOBANKR0'
     C                   Parm      '*DBERR '     @RtCd
     C                   Parm      '*FIRST '     @Optn
     C     SDBANK        Parm      SDBANK        DSFDY
 
     C     @RtCd         IfNe      *BLANKS
     C     *LOCK         In        LDA
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8                          ************
     C                   MoveL     'SDBANKPD'    DbFile                         * DBERR 01 *
     C                   Z-Add     001           Dbase                          ************
     C                   MoveL     @Optn         DbKey
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrSetFld: Set Output Fields                                *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * SrFrmt   - Subroutine to format numeric field to screen field *
      *                                                               *
      *****************************************************************
 
     C     SrSetFld      BegSr
 
      ** Branch
 
     C                   Eval      ADBRCA = CABRCA
 
      ** Customer
 
     C                   Movel     CACNUM        ADCUSN
 
      ** Module ID
 
     C                   Eval      ADMODI = CAMODS
 
      ** Priority sequence
 
     C                   If        CAPRTY <> 0
     C                   Movel     CAPRTY        ADPRSQ
     C                   Else
     C                   Movel     *Blank        ADPRSQ
     C                   EndIf
 
      ** Facility
 
     C**********         If        (CAFCUS <> 0) And (CAFTYP <> 0) And                        CSD027
     C                   If        (CAFCUS <> *BLANKS) And (CAFTYP <> 0) And                  CSD027
     C                             (CAFSEQ <> 0)
     C                   Movel     CAFCUS        WFcty1
     C                   Movel     CAFTYP        WFcty2
     C                   Movel     CAFSEQ        WFcty3
     C                   Else
     C                   Movel     *Blank        DSFCTY
     C                   EndIf
 
     C                   Eval      ADFCTY = DSFCTY
 
      ** Loan/Limit
 
     C**********         If        CALNLM <> 0                                                CLE148
     C                   If        CALNLM <> *BLANKS                                          CLE148
     C                   Movel     CALNLM        ADLNLM
     C                   Else
     C                   Movel     *Blank        ADLNLM
     C                   EndIf
 
      ** Account
 
 
     C**********         If        (CASCNM <> 0) And (CASACD <> 0) And                        CSD027
     C                   If        (CASCNM <> *BLANKS) And (CASACD <> 0) And                  CSD027
     C                             (CASSEQ <> 0)
     C                   Movel     CASBRC        WSBRC
     C                   Movel     CASCNM        WSCNM
     C                   Movel     CASCCY        WSCCY
     C                   Movel     CASACD        WSACD
     C                   Movel     CASSEQ        WSSEQ
     C                   Else
     C                   Movel     *Blank        DSACNT
     C                   EndIf
 
     C                   Eval      ADREAC = DSACNT
 
      ** Amount/Percent indicator
 
     C                   Eval      ADAMPC = CAAPCT
 
      ** Amount (Edit amount by calling standard ZA0921 module)
 
     C                   Eval      WAccess = 'Y'
     C                   ExSr      SrFrmt
     C                   Movel     WAMT16        ADAMNT
 
     C                   If        CAAMT = 0
     C                   Eval      ADAMNT = *Blank
     C                   EndIf
 
      ** Percentage (Edit by ZA0921 module)
 
     C                   Eval      WAccess = 'N'
     C                   ExSr      SrFrmt
     C                   Move      WAMT16        ADPRCT
 
     C                   If        CAPCNT = 0
     C                   Eval      ADPRCT = *Blank
     C                   EndIf
     C
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrFrmt: Format or setup ZA0921 fields                      *
      *                                                               *
      * Called By: SetFld subroutine                                  *
      *                                                               *
      * Calls:                                                        *
      * AOCURRR0   Access Object                                      *
      * ZA0921   - Edit numeric fields                                *
      *                                                               *
      *****************************************************************
 
     C     SrFrmt        BegSr
 
      ** Get Currency Decimal Places for Amount
 
     C                   If        WAccess = 'Y'
     C                   Call      'AOCURRR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm      PColCur       WAjcd             3
     C     SdCurr        Parm      SdCurr        Dssdy
 
     C     @Rtcd         IfNe      *BLANK
     C     *LOCK         In        LDA
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8
     C                   Z-Add     002           DBase                          ************
     C                   MoveL     'SDCURRPD'    DBFile                         * DBERR 02 *
     C                   MoveL     PCOlCur       DBKey                          ************
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
     C                   Z-Add     CAAMT         WAMT15           15 0
     C                   Z-Add     A6NBDP        WDECS             1 0
     C                   Else
 
      ** Format Percentage
 
     C     CAPCNT        Mult      100           WAMT15
     C                   Z-Add     2             WDECS
     C                   EndIf
 
      ** Access Dealing ICD
 
     C**********         Call      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   Parm      '*DBERR '     @Rtcd
     C                   Parm      '*FIRST '     @Optn
     C*****SDDEAL        Parm      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
     C     @Rtcd         IfNe      *BLANKS
     C     *LOCK         In        LDA
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8
     C                   Z-Add     003           DBase                          ************
     C                   MoveL     'SDDEALPD'    DBFile                         * DBERR 03 *
     C                   MoveL     '*FIRST'      DBKey                          ************
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** Call editor module
 
     C                   CallB     'ZA0921'
     C                   Parm                    RetCodeOut
     C                   Parm                    WAMT15
     C                   Parm                    WDECS
     C                   Parm                    BNDCSP
     C                   Parm                    WAMT16           16
     C                   Parm                    WAMT17           17
 
     C                   EndSr
 
      ****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
