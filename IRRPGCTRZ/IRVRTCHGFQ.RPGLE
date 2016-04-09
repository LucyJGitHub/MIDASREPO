     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR: Validate Rate Change Frequency')             *
      *****************************************************************
      *                                                               *
      *  Midas - Validate rate change frequency                       *
      *                                                               *
      *  IRVRTCHGFQ                                                   *
      *                                                               *
      *  Function:  This module validates the rate change frequency.  *
      *             If it is valid, the return indicator contains     *
      *             'Error', else it is blank.                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CIR018             Date 06Aug14               *
      *                 CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 07Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 222240             Date 21Jan05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP055             Date 13Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CIR007             Date 11May01               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 01Feb98               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CIR018 - Daily Rate Change Frequency for SIRS                *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  222240 - If CIR008 is on, IRS deal requires authorization.   *
      *           Therefore, include action X in the validation for   *
      *           Freq (err msg MMA0029) when CIR007 is on.           *
      *  CAP055 - APIs for FRA/IRS Caps/Collars/Floors                *
      *  CIR007 - Overnight Index Swaps                               *
      *  CAP003 - Conversion of IR inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** Logical file built over DEALSDG                                                      CIR007
     FDEALS     IF   E           K DISK                                                       CIR007
     F                                     INCLUDE(DEALSDGF)                                  CIR007
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
 
      ** Include the MM standard declares
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
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                 CIR018
      ** External DS for SAR details                                                         CIR018
                                                                                             CIR018
     D DSFDY         E DS                  EXTNAME(DSFDY)                                    CIR018
      ** External data structure for access programs (short)                                 CIR018
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * rate change date
     D SUNICD          S              6A
 
      * rate change frequency
     D SUICFR          S              1A
 
      * interest rate calendars.
     D CIR001          S              1A
 
      *  Error message code 1 received as a parameter
     D Msgid1          S                   LIKE(#MsgID)
 
      ** OVERNIGHT INDEX SWAPS                                                                CIR007
     DCIR007           S              1A                                                      CIR007
                                                                                              CIR007
      ** Action Code                                                                          CIR007
     DPActnCde         S              1A                                                      CIR007
                                                                                              CIR007
      ** Deal Number                                                                          CIR007
     DPDealNo          S              6A                                                      CIR007
                                                                                              CIR007
      ** Ourside/Theirside Indicator                                                          CIR007
     DPOTInd           S              1A                                                      CIR007
                                                                                              CIR007
      ** Deal Type used as Parameter                                                          CIR007
     DPDealTyp         S              2A                                                      CIR007
                                                                                              CIR007
      ** Deal No. Working Field                                                               CIR007
     DWDealNo          S              6  0                                                    CIR007
                                                                                              CIR007
      ** Deal is Caps/Collars/Floors                                                          CAP055
     D WDealCACF       S              1A                                                      CAP055
                                                                                              CAP055
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
 
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
     C                   MOVE      *OFF          *IN49
                                                                                              CAP055
     C                   IF        PDealTyp = 'RP' OR PDealTyp = 'RR'                         CAP055
     C                             OR PDealTyp = 'RF'                                         CAP055
     C                   EVAL      WDealCACF = 'Y'                                            CAP055
     C                   ELSE                                                                 CAP055
     C                   EVAL      WDealCACF = 'N'                                            CAP055
     C                   ENDIF                                                                CAP055
 
      ** Validate Our Rate Change Frequency.
                                                                                              CIR007
      ** If the Action Code is 'A', CIR007 is on and Deal Type is 'RS',                       CIR007
      ** check that the Rate Change Frequency Code has not been changed                       CIR007
      ** from 'O' or to 'O'.                                                                  CIR007
                                                                                              CIR007
     C                   IF        PActnCde = 'A' AND CIR007 = 'Y'                            CIR007
     C                             AND PDealTyp = 'RS'                                        CIR007
                                                                                              CIR007
     C                   MOVE      PDealNo       WDealNo                                      CIR007
     C     WDealNo       CHAIN     DEALSDGF                           89                      CIR007
                                                                                              CIR007
     C                   IF        POTInd = 'O'                                               CIR007
                                                                                              CIR007
     C                   IF        SUICFR = 'O' AND SUICFR <> UICFR                           CIR007
     C                   EVAL      Msgid1 = 'MMA1173'                                         CIR007
     C                   EVAL      ErrorFound = 'Y'                                           CIR007
     C                   ENDIF                                                                CIR007
                                                                                              CIR007
     C                   IF        UICFR = 'O' AND SUICFR <> 'O'                              CIR007
     C                   EVAL      Msgid1 = 'MMA1174'                                         CIR007
     C                   EVAL      ErrorFound = 'Y'                                           CIR007
     C                   ENDIF                                                                CIR007
                                                                                              CIR007
     C                   ENDIF                                                                CIR007
                                                                                              CIR007
     C                   IF        POTInd = 'T'                                               CIR007
                                                                                              CIR007
     C                   IF        SUICFR = 'O' AND SUICFR <> TICFR                           CIR007
     C                   EVAL      Msgid1 = 'MMA1173'                                         CIR007
     C                   EVAL      ErrorFound = 'Y'                                           CIR007
     C                   ENDIF                                                                CIR007
                                                                                              CIR007
     C                   IF        TICFR = 'O' AND SUICFR <> 'O'                              CIR007
     C                   EVAL      Msgid1 = 'MMA1174'                                         CIR007
     C                   EVAL      ErrorFound = 'Y'                                           CIR007
     C                   ENDIF                                                                CIR007
                                                                                              CIR007
     C                   ENDIF                                                                CIR007
                                                                                              CIR007
     C                   ENDIF                                                                CIR007
 
     C     SUICFR        IFNE      *BLANK
     C     ErrorFound    ANDNE     'Y'                                                        CIR007
     C     SUNICD        IFEQ      *BLANKS
     C     CIR007        ANDEQ     'N'                                                        CIR007
     C     CIR018        ANDEQ     'N'                                                        CIR018
     C     SUNICD        OREQ      *BLANKS                                                    CIR007
     C     CIR007        ANDEQ     'Y'                                                        CIR007
     C     PDealTyp      ANDEQ     'RX'                                                       CIR007
     C     SUNICD        OREQ      *BLANKS                                                    CIR007
     C     CIR007        ANDEQ     'Y'                                                        CIR007
     C     PDealTyp      ANDEQ     'RS'                                                       CIR007
     C     SUICFR        ANDNE     'O'                                                        CIR007
     C     CIR018        ANDEQ     'N'                                                        CIR018
     C     SUNICD        Oreq      *BLANKS                                                    CIR018
     C     CIR007        andeq     'Y'                                                        CIR018
     C     PDealTyp      andeq     'RS'                                                       CIR018
     C     SUICFR        andne     'O'                                                        CIR018
     C     SUICFR        andne     'D'                                                        CIR018
     C     CIR018        andeq     'Y'                                                        CIR018
     C     SUNICD        OREQ      *BLANKS                                                    CAP055
     C     WDealCACF     ANDEQ     'Y'                                                        CAP055
                                                                                              CIR007
     C                   IF        CIR007 = 'N' OR CIR007 = 'Y'                               CIR007
     C                             AND PDealTyp = 'RX'                                        CIR007
     C                             OR WDealCACF = 'Y'                                         CAP055
     C                   MOVE      'MMA0028'     Msgid1
     C                   MOVE      'Y'           ErrorFound
     C                   ELSE                                                                 CIR007
     C     CIR018        Ifeq      'Y'                                                        CIR018
     C                   MOVE      '5047294'     Msgid1                                       CIR018
     C                   MOVE      'Y'           ErrorFound                                   CIR018
     C                   else                                                                 CIR018
     C                   MOVE      'MMA1175'     Msgid1                                       CIR007
     C                   MOVE      'Y'           ErrorFound                                   CIR007
     C                   Endif                                                                CIR018
     C                   ENDIF                                                                CIR007
                                                                                              CIR007
     C                   ELSE
                                                                                              CIR007
      ** If the Action Code is 'I', CIR007 is on and Deal Type is 'RS',                       CIR007
      ** ensure that the Rate Change Frequency Code can be set to 'O'.                        CIR007
                                                                                              CIR007
     C                   IF        (PActnCde = 'I' AND CIR007 = 'Y'                           CIR007
     C                             AND PDealTyp = 'RS')                                       CIR007
     C                             OR (PActnCde = 'A' AND CIR007 = 'Y'                        CIR007
     C                             AND PDealTyp = 'RS')                                       CIR007
     C                             OR (PActnCde = 'X' AND CIR007 = 'Y'                        222240
     C                             AND PDealTyp = 'RS')                                       222240
                                                                                              CIR007
     C                   IF        (SUICFR <> 'M') AND (SUICFR <> 'Q')                        CIR007
     C                             AND (SUICFR<>'X') AND (SUICFR <>'Y')                       CIR007
     C                             AND (SUICFR <> 'O')                                        CIR007
     C                             and (CIR018 = 'N')                                         CIR018
     C                             OR (SUICFR <> 'M') and (SUICFR <> 'Q')                     CIR018
     C                             and (SUICFR<>'X') AND (SUICFR <>'Y')                       CIR018
     C                             and (SUICFR <> 'O') and (SUICFR <>'D')                     CIR018
     C                             and (CIR018 = 'Y')                                         CIR018
                                                                                              CIR007
      **  If switchable feature CIR001 is ON, 'Z' must be a valid                             CIR007
      **    rate change frequency.                                                            CIR007
     C                   IF        (CIR001 = 'Y') AND (SUICFR <> 'Z')                         CIR007
     C                             OR (CIR001 <> 'Y')                                         CIR007
     C     CIR018        Ifeq      'Y'                                                        CIR018
     C     PDealTyp      andeq     'RS'                                                       CIR018
     C                   EVAL      Msgid1 = '5047295'                                         CIR018
     C                   EVAL      ErrorFound = 'Y'                                           CIR018
     C                   else                                                                 CIR018
     C                   EVAL      Msgid1 = 'MMA0029'                                         CIR007
     C                   EVAL      ErrorFound = 'Y'                                           CIR007
     C                   Endif                                                                CIR018
     C                   ENDIF                                                                CIR007
                                                                                              CIR007
     C                   ENDIF                                                                CIR007
                                                                                              CIR007
     C                   ELSE                                                                 CIR007
                                                                                              CIR007
     C     SUICFR        IFNE      'M'
     C     SUICFR        ANDNE     'Q'
     C     SUICFR        ANDNE     'X'
     C     SUICFR        ANDNE     'Y'
     C     CIR018        ANDEQ     'N'                                                        CIR018
     C     SUICFR        Orne      'M'                                                        CIR018
     C     SUICFR        andne     'Q'                                                        CIR018
     C     SUICFR        andne     'X'                                                        CIR018
     C     SUICFR        andne     'Y'                                                        CIR018
     C     SUICFR        andne     'D'                                                        CIR018
     C     CIR018        andeq     'Y'                                                        CIR018
 
      **  If switchable feature is ON, 'Z' must be a valid
      **    rate change frequency
      **  But for Caps/Collars/Floors, 'Z' is invalid.                                        CAP055
 
     C     CIR001        IFEQ      'Y'
     C     SUICFR        ANDNE     'Z'
     C     CIR001        ORNE      'Y'
     C     SUICFR        OREQ      'Z'                                                        CAP055
     C     WDealCACF     ANDEQ     'Y'                                                        CAP055
     C     CIR018        Ifeq      'Y'                                                        CIR018
     C     PDealTyp      andeq     'RS'                                                       CIR018
     C                   MOVE      '5047295'     Msgid1                                       CIR018
     C                   MOVE      'Y'           ErrorFound                                   CIR018
     C                   else                                                                 CIR018
     C                   MOVE      'MMA0029'     Msgid1
     C                   MOVE      'Y'           ErrorFound
     C                   Endif                                                                CIR018
     C                   END
     C                   END
     C                   ENDIF                                                                CIR007
     C                   END
     C                   END
 
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
     C                   RETURN
 
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
 
      * For interest rate caps, collars and floors pass a parameter for CIR001
      * which is NOT 'Y'.
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    CIR001
     C                   PARM                    SUICFR
     C                   PARM                    SUNICD
     C                   PARM                    PActnCde                                     CIR007
     C                   PARM                    PDealNo                                      CIR007
     C                   PARM                    POTInd                                       CIR007
     C                   PARM                    PDealTyp                                     CIR007
     C                   PARM                    CIR007                                       CIR007
                                                                                              CIR018
      ** Access SAR details file to determine if CIR018 is switched on                        CIR018
                                                                                              CIR018
     C                   CALL      'AOSARDR0'                                                 CIR018
     C                   PARM      *BLANKS       @RTCD                                        CIR018
     C                   PARM      '*VERIFY'     @OPTN                                        CIR018
     C                   PARM      'CIR018'      @SARD                                        CIR018
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR018
                                                                                              CIR018
     C                   IF        (@RTCD <> *BLANKS) And (@RTCD <> '*NRF   ')                CIR018
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CIR018
     C                   MOVEL     '001'         DBASE                                        CIR018
     C                   MOVEL     'CIR018'      DBKEY                                        CIR018
     C                   EXSR      *PSSR                                                      CIR018
     C                   ENDIF                                                                CIR018
                                                                                              CIR018
     C                   IF        @RTCD = *BLANKS                                            CIR018
     C                   MOVEL     'Y'           CIR018            1                          CIR018
     C                   ELSE                                                                 CIR018
     C                   MOVEL     'N'           CIR018                                       CIR018
     C                   ENDIF                                                                CIR018
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
