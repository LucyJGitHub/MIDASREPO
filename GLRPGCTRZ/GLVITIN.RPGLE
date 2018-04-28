     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Interest Taxable Flag')              *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVITIN    - Validate Interest Taxable Flag                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CER069             Date 03Jul14               *
      *  Prev Amend No. AR762349A          Date 08Jun11               *
      *                 AR762349           Date 03Jun11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24488           Date 22Jun09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL013             Date 09Jun06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER069 - German Tax Enhancement                              *
      *  AR762349A - Self-Report Customer validation issues Reopen    *
      *  AR762349 - Self-Report Customer validation issues            *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24488 - Cannot insert a taxable RE account (Applied fix   *
      *             BUG23886A)                                        *
      *  BUG23886A - Options Y/N should be valid if customer details  *
      *             taxable indicator is Y and threshold method is N  *
      *  CER048 - German Features - Taxes                             *
      *  CDL013 - Tiered Withholding Tax                              *
      *  CAP035 - Midas/ToF Interface                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      *                                                                                       CER048
      ** External DS for SAR Details                                                          CER048
      *                                                                                       CER048
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER048
                                                                                              CER048
      *                                                                                       CER048
      ** First DS for Access Programs, Short Data Structure                                   CER048
      *                                                                                       CER048
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER048
      *                                                                                       CER048
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
      *                                                                                       CER048
      ** Array of Fields with warnings.                                                       CER048
      *                                                                                       CER048
     D WFldNmXAr       S             10A   DIM(XArrayMax)                                     CER048
      *                                                                                       CER048
      ** Array of warning message IDs                                                         CER048
      *                                                                                       CER048
     D WMsgIdXAr       S                   DIM(XArrayMax)                                     CER048
     D                                     LIKE(#MsgId)                                       CER048
      *                                                                                       CER048
      ** Array of warning message data.                                                       CER048
      *                                                                                       CER048
     D WMsgDtXAr       S                   DIM(XArrayMax)                                     CER048
     D                                     LIKE(#MsgData)                                     CER048
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0                                                    CER048
      *                                                                                       CER048
     D CER048          S              1A                                                      CER048
     D PRtCd           S              7A                                                      CER048
     D POptn           S              7A                                                      CER048
     D PSard           S              6A                                                      CER048
     D PAcHlF          S              1A                                                      CER048
     D WThrMtd         S              1A                                                    AR762349
     D CER069          S              1A                                                      CER069
 
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
 
      ** Initialization
 
     C                   MoveL     *Blanks       RetCodeIn
     C                   MoveL     *Blanks       FldNamXAr
     C                   MoveL     *Blanks       MsgIDXAr
     C                   MoveL     *Blanks       MsgDtaXAr
     C                   MOVEL     *BLANKS       WFldNmXAr                                    CER048
     C                   MOVEL     *BLANKS       WMsgIdXAr                                    CER048
     C                   MOVEL     *BLANKS       WMsgDtXAr                                    CER048
      *                                                                                       CER048
     C                   Z-Add     0             Idx
      *                                                                                       CER048
     C                   EVAL      WIdx = 0                                                   CER048
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
      *                                                                                       CER048
     C                   IF        CER069 = 'Y'                                               CER069
     C                   IF        DDITAX <>'T' AND DDITAX <> 'Y' AND                         CER069
     C                             DDITAX <> 'N' AND DDITAX <> 'A'                            CER069
     C                   EVAL      Idx = Idx + 1                                              CER069
     C                   EVAL      MsgIdXAr(Idx) = '5046496'                                  CER069
     C                   EVAL      FldNamXAr(Idx) = 'DDITAX'                                  CER069
     C                   EVAL      DDITAXOk = 'N'                                             CER069
     C                   ENDIF                                                                CER069
                                                                                              CER069
     C                   ELSE                                                                 CER069
     C                   IF        DDITAX <>'T' AND DDITAX <> 'Y' AND                         CER048
     C                             DDITAX <> 'N'                                              CER048
     C                   EVAL      Idx = Idx + 1                                              CER048
     C                   EVAL      MsgIdXAr(Idx) = 'TAM4802'                                  CER048
     C                   EVAL      FldNamXAr(Idx) = 'DDITAX'                                  CER048
     C                   EVAL      DDITAXOk = 'N'                                             CER048
     C                   ENDIF                                                                CER048
     C                   ENDIF                                                                CER069
      *                                                                                       CER048
     C**********         IF        (DDITAX = 'Y' OR DDITAX = 'T') AND               CER048 BUG23886A
     C                   IF        DDITAX = 'T' and                                        BUG23886A
     C**********                   (PAcHlF = 'N')                                    CER048 AR762349
     C**********                   (PAcHlF = 'N' and WThrMtd = 'Y' )              AR762349 AR762349A
     C                             (PAcHlF = 'N' AND WThrMtd <> 'Y' )                      AR762349A
     C                   EVAL      Idx = Idx + 1                                              CER048
     C**********         EVAL      MsgIdXAr(Idx) = 'TAM4803'                        CER048 BUG23886A
     C                   EVAL      MsgIdXAr(Idx) = 'TAM4801'                               BUG23886A
     C                   EVAL      FldNamXAr(Idx) = 'DDITAX'                                  CER048
     C                   EVAL      DDITAXOk = 'N'                                             CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        (DDITAX = 'Y' OR DDITAX = 'T') AND                       AR762349
     C**********                   (PAcHlF = 'N' and WThrMtd <> 'Y' )             AR762349 AR762349A
     C                             (PAcHlF = 'N' AND WThrMtd = 'Y' )                       AR762349A
     C                   EVAL      Idx = Idx + 1                                            AR762349
     C                   EVAL      MsgIdXAr(Idx) = 'TAM4803'                                AR762349
     C                   EVAL      FldNamXAr(Idx) = 'DDITAX'                                AR762349
     C                   EVAL      DDITAXOk = 'N'                                           AR762349
     C                   ENDIF                                                              AR762349
      *                                                                                     AR762349
     C                   IF        PAcHlF = 'Y' AND DDITAX = 'N'                              CER048
     C                   EVAL      WIdx = WIdx + 1                                            CER048
     C                   EVAL      WMsgIdXAr(WIdx) = 'TAM4804'                                CER048
     C                   EVAL      WFldNmXAr(WIdx) = 'DDITAX'                                 CER048
     C                   EVAL      DDITAXOk = 'W'                                             CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        PAcHlF = 'X' AND (DDITAX = 'N' OR                          CER048
     C                             DDITAX = 'Y' OR DDITAX = 'T')                              CER048
     C                   EVAL      WIdx = WIdx + 1                                            CER048
     C                   EVAL      WMsgIdXAr(WIdx) = 'TAM4805'                                CER048
     C                   EVAL      WFldNmXAr(WIdx) = 'DDITAX'                                 CER048
     C                   EVAL      DDITAXOk = 'W'                                             CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        PAcHlF = 'X' AND DDITAX = 'A'                              CER069
     C                             AND CER069 = 'Y'                                           CER069
     C                   EVAL      Idx = Idx + 1                                              CER069
     C                   EVAL      MsgIdXAr(Idx) = '5046498'                                  CER069
     C                   EVAL      FldNamXAr(Idx) = 'DDITAX'                                  CER069
     C                   EVAL      DDITAXOk = 'N'                                             CER069
     C                   ENDIF                                                                CER069
      *                                                                                       CER069
     C                   ELSE                                                                 CER048
      *                                                                                       CDL013
     C     CDL013        Ifeq      'Y'                                                        CDL013
     C     BBCSTY        IFEQ      'N'                                                        CDL013
     C*                                                                                       CDL013
     C     DDITAX        IFNE      '0'                                                        CDL013
     C                   Move      'N'           DDITAXOk                                     CDL013
     C                   Add       1             Idx                                          CDL013
     C                   MoveL     'DDITAX'      FldNamXAr(Idx)                               CDL013
     C                   MoveL     'XXW0100'     MsgIDXAr(Idx)                                CDL013
     C                   EndIf                                                                CDL013
     C*                                                                                       CDL013
     C*** Customer type is not N                                                              CDL013
     C*                                                                                       CDL013
     C                   Else                                                                 CDL013
     C*                                                                                       CDL013
     C     DDITAX        IFNE      '0'                                                        CDL013
     C     DDITAX        ANDNE     '1'                                                        CDL013
     C     DDITAX        ANDNE     '2'                                                        CDL013
     C     DDITAX        ANDNE     '3'                                                        CDL013
     C     DDITAX        ANDNE     '4'                                                        CDL013
     C     DDITAX        ANDNE     '5'                                                        CDL013
     C     DDITAX        ANDNE     '6'                                                        CDL013
     C     DDITAX        ANDNE     '7'                                                        CDL013
     C     DDITAX        ANDNE     '8'                                                        CDL013
     C     DDITAX        ANDNE     '9'                                                        CDL013
     C                   Move      'N'           DDITAXOk                                     CDL013
     C                   Add       1             Idx                                          CDL013
     C                   MoveL     'DDITAX'      FldNamXAr(Idx)                               CDL013
     C                   MoveL     'XXW0101'     MsgIDXAr(Idx)                                CDL013
     C                   EndIf                                                                CDL013
     C                   EndIf                                                                CDL013
      *                                                                                       CDL013
     C                   Else                                                                 CDL013
      *
      ** Must be 'Y' or 'N'
     C     DDITAX        IfNE      'Y'
     C     DDITAX        AndNE     'N'
     C                   Move      'N'           DDITAXOk
     C                   Add       1             Idx
     C                   MoveL     'DDITAX'      FldNamXAr(Idx)
     C                   MoveL     'TAM4801'     MsgIDXAr(Idx)
     C                   EndIf
     C                   Endif                                                                CDL013
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDITAXOk      IfEq      'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   EndIf
      *
      ** RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *Entry        Plist
      *
      ** INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeIn
      *
      ** Account Screen fields
     C                   Parm                    DDITAX            1
      *                                                                                       CDL013
      ** Customer type                                                                        CDL013
     C                   Parm                    BBCSTY            1                          CDL013
      *                                                                                       CDL013
      ** CDL013 switchable feature                                                            CDL013
     C                   Parm                    CDL013            1                          CDL013
     C                   PARM                    PAcHlF                                       CER048
     C                   PARM                    WThrMtd                                    AR762349
      *
      ** OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   PARM                    WFldNmXAr                                    CER048
     C                   PARM                    WMsgIdXAr                                    CER048
     C                   PARM                    WMsgDtXAr                                    CER048
      *
      ** Interest Taxable - OK
     C                   Parm                    DDITAXOk          1
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
      *                                                                                       CER048
      ** Access SAR file to determine if CER048 is present.                                   CER048
      *                                                                                       CER048
     C                   EVAL      CER048 = 'N'                                               CER048
      *                                                                                       CER048
     C                   CALLB     'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRtCd                                        CER048
     C                   PARM      '*VERIFY'     POptn                                        CER048
     C                   PARM      'CER048'      PSard                                        CER048
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER048
      *                                                                                       CER048
     C                   IF        PRtCd <> *BLANKS AND                                       CER048
     C                             PRtCd <> '*NRF'                                            CER048
     C     *LOCK         IN        LDA                                                        CER048
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER048
     C                   EVAL      DBASE = 3                                                  CER048
     C                   EVAL      DBKEY = 'CER048'                                           CER048
     C                   OUT       LDA                                                        CER048
     C                   EXSR      *PSSR                                                      CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        PRtCd = *BLANKS                                            CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
                                                                                              CER069
      ** Access SAR file to determine if CER069 is present.                                   CER069
                                                                                              CER069
     C                   EVAL      CER069 = 'N'                                               CER069
      *                                                                                       CER069
     C                   CALLB     'AOSARDR0'                                                 CER069
     C                   PARM      *BLANKS       PRtCd                                        CER069
     C                   PARM      '*VERIFY'     POptn                                        CER069
     C                   PARM      'CER069'      PSard                                        CER069
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER069
      *                                                                                       CER069
     C                   IF        PRtCd <> *BLANKS AND                                       CER069
     C                             PRtCd <> '*NRF'                                            CER069
     C     *LOCK         IN        LDA                                                        CER069
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER069
     C                   EVAL      DBASE = 4                                                  CER069
     C                   EVAL      DBKEY = 'CER069'                                           CER069
     C                   OUT       LDA                                                        CER069
     C                   EXSR      *PSSR                                                      CER069
     C                   ENDIF                                                                CER069
      *                                                                                       CER069
     C                   IF        PRtCd = *BLANKS                                            CER069
     C                   EVAL      CER069 = 'Y'                                               CER069
     C                   ENDIF                                                                CER069
      *                                                                                       CER069
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
