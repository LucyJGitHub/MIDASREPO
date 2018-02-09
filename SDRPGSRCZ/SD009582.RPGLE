     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD System Value Validity Checker')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009582 - System Value Validity Checker                     *
      *                                                               *
      *  Function:  This program will be called when the user         *
      *             attempts to change the condition of the system    *
      *             value CustAlphaAllow.                             *
      *                                                               *
      *  Called By: System Values Maintenance Screen                  *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027  *CREATE    Date 06Jan06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7+U8      Error                                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
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
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** LDA Layout
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Array of error message IDs
     D MsgIDXArr       S                   DIM(99) LIKE(ErrMsgId)
      *
      ** Array of Alpha Codes (0-9 A-Z)
     D WValArr         S              1A   CTDATA DIM(36) PERRCD(36)
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** Constant for System Value Prefix
     D WSysValPfx      C                   'CustAlphaAllow'
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D @RUN            S              1
      *
      ** Data structure for NewCurrVal string
     D NewCurrVal      S            200
      *
      ** Error message id in GBSDUSRMSG
     D ErrMsgId        S              7
      *
      ** System value to be processed
     D SystemValue     S             20
      *
      ** Processing mode
     D ProcMode        S            190
      *
      ** General error indicator
     D GenError        S              1
      *
      ** Index for arrays of error message ids etc
     D Idx             S              2P 0
      *
      ** Indexes for generating System Value Names
     D WIndex1         S              1S 0
     D WIndex2         S              2S 0
      *
     DWCustAlphaAllow  S            200A
      *
      ** Parameters for calling SD009510 (Change System Value Setting)
     D PSysValKey      S             20
     D PNewSysVal      S            200
     D PSuppUpd        S             20
      *
      ** Parameters for calling AOSVALR0 (Midas System Value Access Object)
     D PRetCode        S              7A
     D PSysValK1       S             20A
     D PSysVal1        S            200A
     D PSysValK2       S             20A
     D PSysVal2        S            200A
     D PSysValK3       S             20A
     D PSysVal3        S            200A
     D PSysValK4       S             20A
     D PSysVal4        S            200A
     D PSysValK5       S             20A
     D PSysVal5        S            200A
     D PSysValK6       S             20A
     D PSysVal6        S            200A
     D PSysValK7       S             20A
     D PSysVal7        S            200A
     D PSysValK8       S             20A
     D PSysVal8        S            200A
     D PSysValK9       S             20A
     D PSysVal9        S            200A
     D PSysValK10      S             20A
     D PSysVal10       S            200A
      *
      *********************************************************************
      /EJECT
      *********************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      *                  Check if passed SystemValue is valid
     C                   If        SystemValue <> 'CustAlphaAllow      '
     C                   Eval      GenError = 'Y'
     C                   Eval      Idx      =  1
     C                   Eval      MsgIDXArr(Idx) = 'S270001'
     C                   Eval      *INLR = *ON
     C                   Return
     C                   EndIf
      *
      * Retrieve System Value 'CustAlphaAllow'
     C                   Eval      PRetCode = *BLANKS
     C                   Eval      PSysValK1 = 'CustAlphaAllow'
     C                   Eval      PSysVal1 = *BLANKS
     C                   Call(E)   'AOSVALR0'    P_AOSVALR0
      *
      * If Error retrieving the System value
     C                   If        %Error Or PRetCode <> *BLANKS
     C                             Or (*INU7 = *ON And *INU8 = *ON)
     C                   Eval      GenError = 'Y'
     C                   Eval      Idx      =  1
     C                   Eval      MsgIDXArr(Idx) = 'S270013'
     C                   ExSr      *PSSR
     C                   EndIf
      *
     C                   Eval      WCustAlphaAllow = PSysVal1
      *
      * If CustAlphaAllow is being changed from 'Y' to 'N'
     C                   If        WCustAlphaAllow = 'Y' AND
     C                             %Trim(NewCurrVal) = 'N'
     C                   Eval      GenError = 'Y'
     C                   Eval      Idx      =  1
     C                   Eval      MsgIDXArr(Idx) = 'S270002'
     C                   Eval      *INLR = *ON
     C                   Return
     C                   EndIf
      *
      * If CustAlphaAllow is being changed from 'N' to 'Y'
     C                   If        WCustAlphaAllow = 'N' AND
     C                             NewCurrVal = 'Y'
      *
      * To enable CustAlpha fields
     C                   Eval      PSuppUpd   = 'BLANKOUT'
      *
     C                   Eval      PNewSysVal = 'N'
     C                   Eval      PSysValKey = 'CustAlphaChecksum'
     C                   Call(E)   'SD009510'    P_SD009510
      * If Error
     C                   If        %Error Or (*INU7 = *ON And *INU8 = *ON)
     C                   Eval      GenError = 'Y'
     C                   Eval      Idx      =  1
     C                   Eval      MsgIDXArr(Idx) = 'S270013'
     C                   ExSr      *PSSR
     C                   EndIf
      *
     C                   Eval      PNewSysVal = 'Y'
     C                   Eval      PSysValKey = 'CustAlphaSupNumeric'
     C                   Call(E)   'SD009510'    P_SD009510
      * If Error
     C                   If        %Error Or (*INU7 = *ON And *INU8 = *ON)
     C                   Eval      GenError = 'Y'
     C                   Eval      Idx      =  1
     C                   Eval      MsgIDXArr(Idx) = 'S270013'
     C                   ExSr      *PSSR
     C                   EndIf
      *
     C                   Eval      PNewSysVal = 'D'
      *
      * Generate System Value Names for passing to
     C                   For       WIndex1 = 1 to 6
     C                   For       WIndex2 = 1 to 36
     C                   Eval      PSysValKey = WSysValPfx +
     C                             WValArr(WIndex2) +
     C                             %Char(WIndex1)
     C                   Call(E)   'SD009510'    P_SD009510
      * If Error
     C                   If        %Error Or (*INU7 = *ON And *INU8 = *ON)
     C                   Eval      GenError = 'Y'
     C                   Eval      Idx      =  1
     C                   Eval      MsgIDXArr(Idx) = 'S270013'
     C                   ExSr      *PSSR
     C                   EndIf
     C                   EndFor
     C                   EndFor
      *
     C                   EndIf
      *
      ** Normal end processing
      *
     C                   Eval      GenError = *BLANKS
     C                   Eval      *INLR = *ON
      *
     C                   Return
      *
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
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PList
      *
      ** System value to be processed (Input)
     C                   Parm                    SystemValue
      ** Value entered by user (Input)
     C                   Parm                    NewCurrVal
      ** Processing Mode (Input)
     C                   Parm                    ProcMode
      ** General Error Indicator (Output)
     C                   Parm                    GenError
      ** Error message ID (number of entries) (Output)
     C                   Parm                    Idx
      ** Error message ID (array) (Output)
     C                   Parm                    MsgIDXArr
      *
      ** Parameter list for calling SD009510
     C     P_SD009510    PList
     C                   Parm                    PSysValKey
     C                   Parm                    PNewSysVal
     C                   Parm                    PSuppUpd
      *
      ** Parameter list for calling AOSVALR0
     C     P_AOSVALR0    PList
     C                   Parm                    PRetCode
     C                   Parm                    PSysValK1
     C                   Parm                    PSysVal1
     C                   Parm                    PSysValK2
     C                   Parm                    PSysVal2
     C                   Parm                    PSysValK3
     C                   Parm                    PSysVal3
     C                   Parm                    PSysValK4
     C                   Parm                    PSysVal4
     C                   Parm                    PSysValK5
     C                   Parm                    PSysVal5
     C                   Parm                    PSysValK6
     C                   Parm                    PSysVal6
     C                   Parm                    PSysValK7
     C                   Parm                    PSysVal7
     C                   Parm                    PSysValK8
     C                   Parm                    PSysVal8
     C                   Parm                    PSysValK9
     C                   Parm                    PSysVal9
     C                   Parm                    PSysValK10
     C                   Parm                    PSysVal10
      *
     C                   Eval      GenError = *BLANKS
     C                   Eval      Idx      = 0
     C                   Clear                   MsgIDXArr
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   Dump
      *
     C                   If        @RUN = *BLANK
     C                   Eval      @RUN = 'Y'
      *
     C                   Call      'DBERRCTL'
      *
     C                   EndIf
      *
     C                   Eval      GenError = 'Y'
     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Eval      *INLR = *ON
     C                   Return
      *
     C                   ENDSR
      *
 
** WValArr
0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ
