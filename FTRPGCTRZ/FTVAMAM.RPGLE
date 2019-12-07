     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate entered amounts agree')              *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVAMAM  - Validate Entered Amounts agree                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD021318           Date 26Jul13               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR898167           Date 07Nov14               *
      *                 AR905067           Date 05Nov14               *
      *                 CSW213             Date 03Jun13               *
      *                 AR895223           Date 19Nov12               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      *                 CSD089             Date 07Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 06Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 210871             Date 26Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG5057            Date 06Dec04               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3644            Date 12Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 23May00               *
      *                 CFT007             Date 23Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 01Dec99               *
      *                 CAP031  *CREATE    Date 08Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD021318 - OPAY allowed input of account with block debit    *
      *           - Fix is to condition CSD089 overridable error      *
      *             changes when input is from HATS screen            *
      *  MD046248 - Finastra Rebranding                               *
      *  AR898167 - Outgoing payment has inconsistent rate in fld 36  *
      *             (Child: AR898168)                                 *
      *  AR905067 - Regular payment receives NegativelyAcked message. *
      *             Allow instructed currency/amount for RP.          *
      *             (Child: AR905068)                                 *
      *  CSW213 - SWIFT Changes 2013 (Recompile)                      *
      *  AR895223 - Exchange rates should allow 5 digits. Fix is to   *
      *             increase the number of digits to five. Applied    *
      *             fix 257663. (Child: AR895224)                     *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CSD089 - Overrideable Errors Phase 2                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompile)    *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG5057- Divide by zero error caused by work field too small *
      *  210871 - If instructed ccy is equal to pay ccy, set original *
      *           rate to 1.                                          *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  175479 - Recompile over changes in outgoing payment file     *
      *  CFT007 - Recompiled for BIC Database Plus Integration        *
      *  CFT004 - Recompiled for IBAN (International Bank A/C No.)    *
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
     FMEISOCL1  IF   E           K DISK                                         CFT014
      ** ISO Country Codes file                                                 CFT014
                                                                                CFT014
     FACNUMA    IF   E           K DISK    RENAME(ACCNTABF:ACNUMAF)             CFT014
      ** Retail Accounts file                                                   CFT014
 
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
 
      **********************************************************************
      /EJECT                                                               *
      **********************************************************************
 
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
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
                                                                                              CSD089
      ** Array of Fields in warning.                                                          CSD089
     D WFldNmXAr       S             10A   DIM(XArrayMax)                                     CSD089
                                                                                              CSD089
      ** Array of warning message IDs                                                         CSD089
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)                        CSD089
                                                                                              CSD089
      ** Array of warning message data.                                                       CSD089
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)                      CSD089
                                                                                CFT014
      ** Array for charges conversion routines                                  CFT014
     D Power           S              7  3 DIM(7) CTDATA PERRCD(1)              CFT014
 
      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
                                                                                CFT014
      * Incoming Transaction                                                    CFT014
     D TranInPrmX    E DS                  EXTNAME(FTOPY1APD)                   CFT014
 
      * Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY1PD)
 
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
      ** External data structure for currency codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
                                                                                CFT014
      ** Country codes file format data structure                               CFT014
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)                    CFT014
                                                                                CFT014
      ** Location codes file format data structure                              CFT014
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)                    CFT014
                                                                                CFT014
      ** Branch codes file format data structure                                CFT014
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                    CFT014
                                                                                CFT014
      ** Nostro file format data structure                                      CFT014
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                    CFT014
                                                                                CFT014
      ** Customer detail file format data structure                             CFT014
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    CFT014
     D  QQDFAC1      E                     EXTFLD(QQDFAC)                                     CGL029
 
      ** External data structure for access programs (short)
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                CFT014
      ** External data structure for access programs (short)                    CFT014
     D DSFDY         E DS                  EXTNAME(DSFDY)                       CFT014
 
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
      ** Index for arrays of warning message ids etc                                          CSD089
     D WIx             S              3P 0                                                    CSD089
 
     D C#K101          S              3
     D C#OPTN          S              7
     D C#RTCD          S              7
     D C#MSGID         S              7
 
     D ZalignOK        S              1
     D ZFIELD          S             16
     D ZADIG           S              2  0
     D ZADEC1          S              1  0
     D ZADEC2          S              2  0
     D ZMDIX           S              1
     D ZMDI1           S              1
     D ZMDI2           S              1
 
     D WRATE0          S             13  0
     D PMode           S              6A                                                    MD021318
 
      **  Data Structure for input/output parameters
     D/COPY FTCPYSRC,FT0010D001
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *********************************************************************
      /EJECT                                                              *
      *********************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
      *
     C                   Eval      RetCodeIn = *BlankS
     C                   Eval      FldNamXAr = *BlankS
     C                   Eval      MsgIDXAr  = *BlankS
     C                   Eval      MsgDtaXAr = *BlankS
     C                   Eval      WFldNmXAr = *BlankS                                        CSD089
     C                   Eval      WMsgIDXAr = *BlankS                                        CSD089
     C                   Eval      WMsgDtXAr = *BlankS                                        CSD089
     C                   Eval      Idx = 0
     C                   Eval      WIx = 0                                                    CSD089
 
      * Entered amounts agree validation
      *
     C                   Exsr      VEUXCHK
 
 
      ** If an error was found, set the return code appropriately
      *
     C                   If        OKNdam = 'N' or
     C                             OKSmam = 'N' or
     C                             OKPyam = 'N' or
     C                             OKPdam = 'N' or
     C                             OKRate = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   Else                                                                 CSD089
     C                   If        OKRate = 'W'                                               CSD089
     C                   Eval      RetCodeIn = 'Warning'                                      CSD089
     C                   End                                                                  CSD089
     C                   End
 
      * RETURN
      *
     C                   RETURN
      ******************************************************************
      /EJECT                                                           *
     C******************************************************************
     C* VEUXCHK - VALIDATION OF ENTERED AMOUNTS                        *
     C******************************************************************
      * Currencies and amounts should br valid before calling this routine.
      * Checks entered amounts agree and also calculates an amount which
      * has been left blank.
 
     C     VEUXCHK       BEGSR
 
      ** Set paramaters for call to FT0010
 
     C                   Clear                   P#0010
 
     C                   Movel     'FTVAMAM'     P#PMSQ
 
     C                   Eval      P#NDCY = SNDCY
     C                   Eval      P#NDAM = @NDAM
     C                   Eval      P#DBCY = SSMCY
     C                   Eval      P#DBAM = @SMAM
     C                   Eval      P#DBDT = @SLDT
     C                   Eval      P#CRCY = SPCCY
     C                   Eval      P#CRAM = @PYAM
     C                   If        @CFT014 = 'N'                                CFT014
     C                   Eval      P#PDCY = SPDCY
     C                   Eval      P#PDAM = @PDAM
     C                   EndIf                                                  CFT014
     C                   Eval      P#CRDT = @PVDT
 
     C                   Move      SRATE         ZFIELD
     C**********         Eval      ZADIG = 4                                                AR895223
     C                   EVAL      ZADIG = 5                                                AR895223
     C                   Eval      ZADEC1 = 8
     C                   CALLB     'ZALIGN'
     C                   Parm                    ZalignOK
     C                   Parm                    ZFIELD
     C                   Parm                    ZADEC1
     C                   Parm                    ZADIG
 
     C                   If        ZalignOK = 'N'
      * Send error to screen
     C                   Move      'N'           OKRate
     C                   Add       1             Idx
     C                   Movel     'SRATE'       FldNamXAr(Idx)
     C                   Movel     'MMA1014'     MsgIdXAr(Idx)
 
     C                   Else
     C                   Move      ZFIELD        @RATE
     C                   Eval      P#RATE = @RATE
     C                   Eval      P#OVRT = SOVRD
     C                   Eval      P#SDIN = 'Y'
     C                   Eval      P#RTDS = @RATDIS
 
     C                   Call      'FT0010'
     C                   Parm                    P#0010
 
     C                   If        P#RTCD <> *Blanks
     C                   Movel     'AOCURRR0'    DBFILE
     C                   Movel     '*CALL'       DBKEY
     C                   Eval       DBASE = 41
     C                   Exsr      *PSSR
     C                   End
 
     C                   Eval      @MDIN = P#MDIN
      * Set Notified delivery amount (Formatted for screen)
     C                   If        SNDCY <> *Blanks
     C                   Eval      C#K101 = SNDCY
     C                   Exsr      CURRED
 
 
     C                   Eval      @NDAM = P#NDAM
     C                   Move(P)   P#NDAM        ZFIELD
     C                   Eval      ZADEC2 = A6NBDP
     C                   CALLB     'ZAEDITM'
     C                   Parm                    ZFIELD
     C                   Parm                    ZADEC2
 
     C                   Move      ZFIELD        SNDAM
     C                   Else
     C                   Move      *Blanks       SNDAM
     C                   End
 
      * Set Settle amount (Formatted for screen)
     C                   If        SSMCY <> *Blanks
     C                   Eval      C#K101 = SSMCY
     C                   Exsr      CURRED
 
 
     C                   Eval      @SMAM = P#DBAM
     C                   Move(P)   P#DBAM        ZFIELD
     C                   Eval      ZADEC2 = A6NBDP
     C                   CALLB     'ZAEDITM'
     C                   Parm                    ZFIELD
     C                   Parm                    ZADEC2
 
     C                   IF        @CFT009 = 'N'                                CFT009
     C                             OR @CFT009 = 'Y' AND SSMAM <> *BLANK         CFT009
     C                             OR @CFT009 = 'Y' AND SSMAM = *BLANK          CFT009
     C                             AND SRATE <> *BLANKS                         CFT009
     C                   Move      ZFIELD        SSMAM
     C                   ENDIF                                                  CFT009
     C                   Else
     C                   Move      *Blanks       SSMAM
     C                   End
 
      * Set Pay amount (Formatted for screen)
     C                   If        SPCCY <> *Blanks
     C                   Eval      C#K101 = SPCCY
     C                   Exsr      CURRED
 
     C                   Eval      @PYAM = P#CRAM
     C                   Move(P)   P#CRAM        ZFIELD
     C                   Eval      ZADEC2 = A6NBDP
     C                   CALLB     'ZAEDITM'
     C                   Parm                    ZFIELD
     C                   Parm                    ZADEC2
 
     C                   IF        @CFT009 = 'N'                                CFT009
     C                             OR @CFT009 = 'Y' AND SPYAM <> *BLANK         CFT009
     C                             OR @CFT009 = 'Y' AND SPYAM = *BLANK          CFT009
     C                             AND SRATE <> *BLANKS                         CFT009
     C                   Move      ZFIELD        SPYAM
     C                   ENDIF                                                  CFT009
     C                   Else
     C                   Move      *Blanks       SPYAM
     C                   End
 
      * Set Pay delivery amount (Formatted for screen)
     C                   If        (@CFT014 <> 'Y')                             CFT014
     C                   If        SPDCY <> *Blanks
     C                   Eval      C#K101 = SPDCY
     C                   Exsr      CURRED
 
 
     C                   Eval      @PDAM = P#PDAM
     C                   Move      P#PDAM        ZFIELD
     C                   Eval      ZADEC2 = A6NBDP
     C                   CALLB     'ZAEDITM'
     C                   Parm                    ZFIELD
     C                   Parm                    ZADEC2
 
     C                   Move      ZFIELD        SPDAM
     C                   Else
     C                   Move      *Blanks       SPDAM
     C                   End
     C                   EndIf                                                  CFT014
 
      * Set Rate (Formatted for screen)
     C                   Eval      @RATE = P#RATE
     C                   Move      P#RATE        WRATE0
     C                   Move(P)   WRATE0        ZFIELD
     C                   Eval      ZADEC2 = 8
     C                   CALLB     'ZAEDITM'
     C                   Parm                    ZFIELD
     C                   Parm                    ZADEC2
 
     C                   IF        @CFT009 = 'N'                                CFT009
     C                             OR @CFT009 = 'Y' AND SRATE <> *BLANK         CFT009
     C                   Move      ZFIELD        SRATE
     C                   ENDIF                                                  CFT009
 
      * Error processing for erros from FT0010
     C                   If        P#INDC <> '00000'
 
      * Set screen error indicators from  FT0010
      * Notified Delivery amount
     C                   If        %subst(P#INDC:1:1) = '1'
     C                   Move      'N'           OKNdam
     C                   End
 
      * Settlement amount
     C                   If        %subst(P#INDC:2:1) = '1'
     C                   Move      'N'           OKSmam
     C                   End
 
      * Pay amount
     C                   If        %subst(P#INDC:3:1) = '1'
     C                   Move      'N'           OKPyam
     C                   End
 
      * Pay Delivery amount
     C                   If        %subst(P#INDC:4:1) = '1'
     C                   Move      'N'           OKPdam
     C                   End
 
      * Rate
     C                   If        %subst(P#INDC:5:1) = '1'
     C                   If        P#PMSQ = 'FTM2577' or P#PMSQ = 'FTM2578'                   CSD089
     C                   Move      'W'           OKRate                                       CSD089
     C                   Else                                                                 CSD089
     C                   Move      'N'           OKRate
     C                   End                                                                  CSD089
     C                   End
 
      * Set error message Ids from  FT0010
     C                   If        P#PMSQ = 'FTM2572   '
     C                   Add       1             Idx
     C                   Movel     'SSMAM'       FldNamXAr(Idx)
     C                   Movel     'MMA1015'     MsgIdXAr(Idx)
     C                   End
 
     C                   If        P#PMSQ = 'FTM2573   '
     C                   Add       1             Idx
     C                   Movel     'SRATE'       FldNamXAr(Idx)
     C                   Movel     'MMA1016'     MsgIdXAr(Idx)
     C                   End
 
     C                   If        P#PMSQ = 'FTM2574   '
     C                   Add       1             Idx
     C                   Movel     'SRATE'       FldNamXAr(Idx)
     C                   Movel     'MMA1017'     MsgIdXAr(Idx)
     C                   End
 
     C                   If        P#PMSQ = 'FTM2575   '
     C                   Add       1             Idx
     C                   Movel     'SRATE'       FldNamXAr(Idx)
     C                   Movel     'MMA1018'     MsgIdXAr(Idx)
     C                   End
 
     C                   If        P#PMSQ = 'FTM2577   '
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SRATE'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1019'     MsgIdXAr(Idx)                                CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C                   Add       1             Idx                                        MD021318
     C                   Movel     'SRATE'       FldNamXAr(Idx)                             MD021318
     C                   Movel     'MMA1019'     MsgIdXAr(Idx)                              MD021318
     C                   ELSE                                                               MD021318
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SRATE'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1019'     WMsgIdXAr(WIx)                               CSD089
     C                   ENDIF                                                              MD021318
     C                   End
 
     C                   If        P#PMSQ = 'FTM2578   '
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SRATE'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1020'     MsgIdXAr(Idx)                                CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C                   Add       1             Idx                                        MD021318
     C                   Movel     'SRATE'       FldNamXAr(Idx)                             MD021318
     C                   Movel     'MMA1020'     MsgIdXAr(Idx)                              MD021318
     C                   ELSE                                                               MD021318
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SRATE'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1020'     WMsgIdXAr(WIx)                               CSD089
     C                   ENDIF                                                              MD021318
     C                   End
 
     C                   If        P#PMSQ = 'FTM2579   '
     C                   Add       1             Idx
     C                   Movel     'SSMAM'       FldNamXAr(Idx)
     C                   Movel     'MMA1021'     MsgIdXAr(Idx)
     C                   End
 
     C                   If        P#PMSQ = 'FTM2580   '
     C                   Add       1             Idx
     C                   Movel     'SSMAM'       FldNamXAr(Idx)
     C***********        Movel     'MMA1022'     MsgIdXAr(Idx)                  CFT014
     C                   Movel     'FTM3257'     MsgIdXAr(Idx)                  CFT014
     C                   End
 
     C                   If        P#PMSQ = 'FTM2581   '
     C                   Add       1             Idx
     C                   Movel     'SPYAM'       FldNamXAr(Idx)
     C***********        Movel     'MMA1023'     MsgIdXAr(Idx)                  CFT014
     C                   Movel     'FTM3258'     MsgIdXAr(Idx)                  CFT014
     C                   End
 
     C                   If        P#PMSQ = 'FTM2582   '
     C                   Add       1             Idx
     C                   Movel     'SPYAM'       FldNamXAr(Idx)
     C                   Movel     'MMA1023'     MsgIdXAr(Idx)
     C                   End
 
     C                   If        P#PMSQ = 'FTM2583   '
     C                   Add       1             Idx
     C                   Movel     'SPYAM'       FldNamXAr(Idx)
     C                   Movel     'MMA1024'     MsgIdXAr(Idx)
     C                   End
 
     C                   If        P#PMSQ = 'FTM2587   '
     C                   Add       1             Idx
     C                   Movel     'SRATE'       FldNamXAr(Idx)
     C                   Movel     'MMA1100'     MsgIdXAr(Idx)
     C                   End
 
     C                   End
 
      ** Default Instructed Amount                                              CFT014
                                                                                CFT014
     C                   If        @CFT014 = 'Y'                                CFT014
                                                                                CFT014
      ** Setup FT0010 parameters to calculate instructed amount when            CFT014
      ** currency is entered while the amount is not.                           CFT014
                                                                                CFT014
     C                   If        (SPDCY <> *Blank) And (SPDAM = *Blank)       CFT014
     C                             Or (SPDCY <> *Blank) And (@PDAM = 0)         CFT014
     C                   Clear                   P#0010                         CFT014
     C                   Eval      P#FRCY = SPCCY                               CFT014
     C                   Eval      P#FRAM = @PYAM                               CFT014
     C                   Eval      P#TOCY = SPDCY                               CFT014
                                                                                CFT014
      ** Calculate Instructed amount via FT0010                                 CFT014
                                                                                CFT014
     C                   Call      'FT0010'                                     CFT014
     C                   Parm                    P#0010                         CFT014
                                                                                CFT014
      ** Error calling FT0010                                                   CFT014
                                                                                CFT014
     C                   If        P#RTCD = '*ERROR*'                           CFT014
     C                   Eval      DBFILE = 'FT0010'                            CFT014
     C                   Eval      DBASE = 42                                   CFT014
     C                   Eval      DBKEY = '*CALL'                              CFT014
     C                   ExSr      *PSSR                                        CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Set Instructed amount (Formatted for screen)                           CFT014
                                                                                CFT014
     C                   If        (SPDCY <> *Blank)                            CFT014
     C                   Eval      C#K101 = SPDCY                               CFT014
     C                   Exsr      CURRED                                       CFT014
     C                   Eval      ZFIELD = *Blank                              CFT014
     C                   Eval      ZADEC2 = A6NBDP                              CFT014
                                                                                CFT014
     C                   If        (SPDAM = *Blank) Or                          CFT014
     C                             (@PDAM = 0)                                  CFT014
     C                   Move      P#TOAM        ZFIELD                         CFT014
     C                   Z-Add     P#TOAM        @PDAM                          CFT014
     C                   Else                                                   CFT014
     C                   Move      @PDAM         ZFIELD                         CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   CALLB     'ZAEDITM'                                    CFT014
     C                   Parm                    ZFIELD                         CFT014
     C                   Parm                    ZADEC2                         CFT014
     C                   Move      ZFIELD        SPDAM                          CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** When Instructed currency/amount is blank, must be defaulted to         CFT014
      ** be the same as Pay currency and amount given that the  sender          CFT014
      ** and the receiver both support charge transparency                      CFT014
                                                                                CFT014
     C**********         If        (SPDCY = *Blank) And (SPDAM = *Blank) And         CFT014 AR905067
     C**********                   (SPYTP <> 'RP')                                   CFT014 AR905067
     C                   If        (SPDCY = *Blank) And (SPDAM = *Blank)                    AR905067
                                                                                CFT014
      ** Find out first the sender/receiver ISO Country Code to be              CFT014
      ** use in getting charge transparency indicator                           CFT014
                                                                                CFT014
     C                   ExSr      SrRISO                                       CFT014
     C                   ExSr      SrSISO                                       CFT014
                                                                                CFT014
      ** Access ISO country codes via LF/MEISOCL1 to get receiver               CFT014
      ** charge transparency flag                                               CFT014
                                                                                CFT014
     C                   Movel     WRISOC        WISOC             2            CFT014
     C                   ExSr      SrISOC                                       CFT014
                                                                                CFT014
      ** Receiver charge transparency flag is 'Y', set 'Y' to receiver          CFT014
      ** transparency work field, otherwise 'N'                                 CFT014
                                                                                CFT014
     C                   If        WTRANS = 'Y'                                 CFT014
     C                   Move      'Y'           WRTRAN            1            CFT014
     C                   Else                                                   CFT014
     C                   Move      'N'           WRTRAN                         CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Access ISO country codes via LF/MEISOCL1 to get sender                 CFT014
      ** charge transparency flag                                               CFT014
                                                                                CFT014
     C                   Movel     WSISOC        WISOC                          CFT014
     C                   ExSr      SrISOC                                       CFT014
                                                                                CFT014
      ** Sender charge transparency flag is 'Y', set 'Y' to sender              CFT014
      ** transparency work field, otherwise 'N'                                 CFT014
                                                                                CFT014
     C                   If        WTRANS = 'Y'                                 CFT014
     C                   Move      'Y'           WSTRAN            1            CFT014
     C                   Else                                                   CFT014
     C                   Move      'N'           WSTRAN                         CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   If        (WRTRAN = 'Y') And (WSTRAN = 'Y')            CFT014
     C                   Eval      SPDCY = SPCCY                                CFT014
     C                   Eval      SPDAM = SPYAM                                CFT014
     C                   Eval      @PDAM = @PYAM                                CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Validate original rate against instructed ccy/amount                   CFT014
                                                                                CFT014
     C                   If        (SOEXR <> *Blank) And (@OEXR <> 0)           CFT014
                                                                                              210871
      * If currencies are the same then rate is 1                                             210871
                                                                                              210871
     C                   If        SPCCY = SPDCY                                              210871
     C                   Eval      @OEXR = 1                                                  210871
     C                   Endif                                                                210871
                                                                                CFT014
      ** Original Rate entry not allowed if Instructed Amount not               CFT014
      ** entered.                                                               CFT014
                                                                                CFT014
     C                   If        (SPDAM = *Blank) And (@OEXR <> 0) Or         CFT014
     C                             (@PDAM = 0) And (@OEXR <> 0)                 CFT014
     C                   Move      'N'           OKOEXR                         CFT014
     C                   Add       1             Idx                            CFT014
     C                   Movel     'SOEXR'       FldNamXAr(Idx)                 CFT014
     C                   Movel     'FTM3103'     MsgIdXAr(Idx)                  CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Original Rate not entered.                                             CFT014
                                                                                CFT014
     C                   Else                                                   CFT014
                                                                                CFT014
     C                   Eval      @OEXR = 0                                    CFT014
                                                                                CFT014
     C                   If        (SPDCY <> *Blank) And (OKPDCY = 'Y') And     CFT014
     C                             (@PDAM <> 0) And (OKPDAM = 'Y') And          CFT014
     C                             (SPCCY <> *Blank) And (OKPCCY = 'Y') And     CFT014
     C                             (@PYAM <> 0) And (OKPYAM = 'Y')              CFT014
     C                   Clear                   P#0010                         CFT014
     C                   Eval      P#FRCY = SPCCY                               CFT014
     C                   Z-Add     @PYAM         P#FRAM                         CFT014
     C                   Eval      P#TOCY = SPDCY                               CFT014
     C                   Z-Add     @PDAM         P#TOAM                         CFT014
                                                                                CFT014
      ** Get multiply/divide indicator via FT0010                               CFT014
                                                                                CFT014
     C                   Call      'FT0010'                                     CFT014
     C                   Parm                    P#0010                         CFT014
                                                                                CFT014
      ** Error calling FT0010                                                   CFT014
                                                                                CFT014
     C                   If        P#RTCD = '*ERROR*'                           CFT014
     C                   Eval      DBFILE = 'FT0010'                            CFT014
     C                   Eval      DBASE = 43                                   CFT014
     C                   Eval      DBKEY = '*CALL'                              CFT014
     C                   ExSr      *PSSR                                        CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Get instructed amount decimal places                                   CFT014
                                                                                CFT014
     C                   Eval      C#K101 = SPDCY                               CFT014
     C                   Exsr      CURRED                                       CFT014
     C                   Z-Add     A6NBDP        WPDDEC            1 0          CFT014
                                                                                CFT014
      ** Get payment currency decimal places                                    CFT014
                                                                                CFT014
     C                   Eval      C#K101 = SPCCY                               CFT014
     C                   Exsr      CURRED                                       CFT014
     C                   Z-Add     A6NBDP        WPYDEC            1 0          CFT014
                                                                                CFT014
     C                   Z-Add     *Zero         Ndc               1 0          CFT014
     C                   Eval      Ndc = WPDDEC - WPYDEC                        CFT014
     C                   Select                                                 CFT014
                                                                                CFT014
      ** Same number of decimal places, set workfield same as amounts           CFT014
                                                                                CFT014
     C                   When      Ndc = 0                                      CFT014
     C*************      Z-Add     @PDAM         WPDAMT           11 0                CFT014 BUG5057
     C*************      Z-Add     @PYAM         WPYAMT           11 0                CFT014 BUG5057
     C                   Z-Add     @PDAM         WPDAMT           15 0                       BUG5057
     C                   Z-Add     @PYAM         WPYAMT           15 0                       BUG5057
                                                                                CFT014
      ** Instructed amount dec. greater than the payment amount dec.,           CFT014
      ** align payment amount to instructed amount.                             CFT014
                                                                                CFT014
     C                   When      Ndc > 0                                      CFT014
     C                   Eval      WPYAMT = @PYAM/Power(Ndc)                    CFT014
     C                   Eval      WPDAMT = @PDAM                               CFT014
                                                                                CFT014
      ** Instructed amount dec. less than the payment amount dec.,              CFT014
      ** align instructed amount to payment amount.                             CFT014
                                                                                CFT014
     C                   When      Ndc < 0                                      CFT014
     C                   Z-Sub     Ndc           Ndc                            CFT014
     C                   Eval      WPDAMT = @PDAM/Power(Ndc)                    CFT014
     C                   Eval      WPYAMT = @PYAM                               CFT014
     C                   EndSl                                                  CFT014
                                                                                              210871
     C                   If        SPCCY = SPDCY                                              210871
     C                   Eval      @OEXR = 1                                                  210871
     C                   Else                                                                 210871
                                                                                CFT014
      ** Calculate original rate depending on mult/div indicator                CFT014
      ** (1 = Multiply otherwise, Divide) and set result as default             CFT014
                                                                                CFT014
     C                   If        P#MDIN = 1                                   CFT014
     C                   Eval      @OEXR = WPDAMT/WPYAMT                        CFT014
     C                   Else                                                   CFT014
     C                   Eval      @OEXR = WPYAMT/WPDAMT                        CFT014
     C                   EndIf                                                  CFT014
                                                                                            AR898167
      ** If instructed currency is the same as settlement currency                          AR898167
      ** and instructed amount is the same as settlement amount                             AR898167
      ** then set original exchange rate to transaction rate                                AR898167
                                                                                            AR898167
     C                   If        SPDCY = SSMCY and                                        AR898167
     C                             @PDAM = @SMAM and                                        AR898167
     C                             @RATE <> 0                                               AR898167
     C                   EVAL      @OEXR = @RATE                                            AR898167
     C                   Endif                                                              AR898167
     C                   EndIf                                                                210871
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Set original rate screen field                                         CFT014
                                                                                CFT014
     C                   If        (SOEXR <> *Blank) Or                         CFT014
     C                             (SOEXR = *Blank) And (@OEXR <> 0)            CFT014
     C                   Eval      ZADEC2 = 8                                   CFT014
     C                   Move      @OEXR         ZFIELD                         CFT014
     C                   CALLB     'ZAEDITM'                                    CFT014
     C                   Parm                    ZFIELD                         CFT014
     C                   Parm                    ZADEC2                         CFT014
                                                                                CFT014
     C                   Move      ZFIELD        SOEXR                          CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
 
     C                   End
 
     C                   ENDSR
      *****************************************************************         CFT014
      /Title Sr/SrRISO                                                          CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/SrRISO    - Find out Receiver ISO Country Code             *         CFT014
      *                                                               *         CFT014
      * Called By: VEUXCHK subroutine                                 *         CFT014
      *                                                               *         CFT014
      * Calls:                                                        *         CFT014
      * SrAccs      - Access standing data detail file                *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     SrRISO        BegSr                                                  CFT014
                                                                                CFT014
     C                   Move      *Blank        WRISOC            2            CFT014
     C                   Eval      WCNUM = *Blanks                              CFT014
     C                   Eval      WCNCD = *Blanks                              CFT014
     C                   Eval      WSWIFT = *Blanks                             CFT014
     C                   Eval      WCYCD = *Blanks                              CFT014
     C                   Eval      WNONB = *Blanks                              CFT014
     C                   Eval      WCUSN = *Blanks                              CFT014
     C                   Eval      WACCS = *Blanks                              CFT014
     C                   Eval      WACSN = *Blanks                              CFT014
     C                   Eval      WBRCD = *Blanks                              CFT014
     C                   Eval      WCSSN = *Blanks                              CFT014
     C                   Eval      WPNOI = *Blanks                              CFT014
     C                   Select                                                 CFT014
                                                                                CFT014
      ** Destination type is SWIFT                                              CFT014
                                                                                CFT014
     C                   When      @DSTT = 'S'                                  CFT014
     C                   Eval      WRISOC = (%Subst(SDST1:5:2))                 CFT014
                                                                                CFT014
      ** Destination type is Customer, Full Nostro, Retail and GL               CFT014
                                                                                CFT014
     C                   When      (@DSTT = 'C') Or (@DSTT = 'F') Or            CFT014
     C                             (@DSTT = 'R') Or (@DSTT = 'G')               CFT014
     C                   Select                                                 CFT014
                                                                                CFT014
      ** Full nostro, access nostro file to get customer number                 CFT014
                                                                                CFT014
     C                   When      (@DSTT = 'F')                                CFT014
     C                   Eval      WCYCD = (%Subst(SDST1:1:3))                  CFT014
     C                   Eval      WNONB = (%Subst(SDST1:4:2))                  CFT014
                                                                                CFT014
     C                   Move      'N'           WACCS             1            CFT014
     C                   ExSr      SrAccs                                       CFT014
                                                                                CFT014
      ** No error accessing Nostro file                                         CFT014
                                                                                CFT014
     C                   If        WACOK = 'Y'                                  CFT014
     C                   Movel     A7CUST        WCNUM            10            CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Customer, might be a customer name or a customer number.               CFT014
                                                                                CFT014
     C                   When      @DSTT = 'C'                                  CFT014
     C                   Eval      WCNUM = (%Subst(SDST1:1:10))                 CFT014
                                                                                CFT014
      ** Retail, or GL, get customer number.                                    CFT014
                                                                                CFT014
     C                   When      (@DSTT = 'R')                                CFT014
     C                   Move      *Blank        WALN10           10            CFT014
     C                   Eval      WALN10 = (%Subst(SDST1:1:10))                CFT014
     C                   Move      WALN10        WACNO            10 0          CFT014
     C     WACNO         Chain     ACNUMAF                            60        CFT014
     C                   If        (*IN60 = False) And (RECI = 'D')             CFT014
     C                   Move      CNUM          WCNUM6            6            CFT014
     C                   Movel     WCNUM6        WCNUM                          CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   When      (@DSTT = 'G')                                CFT014
     C                   Eval      WCNUM = (%Subst(SDST1:1:6))                  CFT014
     C                   EndSl                                                  CFT014
                                                                                CFT014
      ** Access customer's file to get SWIFT id                                 CFT014
                                                                                CFT014
     C                   Move      'C'           WACCS                          CFT014
     C                   ExSr      SrAccs                                       CFT014
                                                                                CFT014
      ** No error accessing Customer's file                                     CFT014
                                                                                CFT014
     C                   If        WACOK = 'Y'                                  CFT014
     C                   If        BBCSID <> *Blank                             CFT014
     C                   Movel     BBCSID        WSWIFT           12            CFT014
     C                   Eval      WRISOC = (%Subst(WSWIFT:5:2))                CFT014
     C                   Else                                                   CFT014
                                                                                CFT014
      ** No SWIFT id, get country code                                          CFT014
                                                                                CFT014
     C                   Movel     BBCOLC        WCNCD             2            CFT014
                                                                                CFT014
      ** Get ISO Country Code via access object AOCTRYR0                        CFT014
                                                                                CFT014
     C                   Move      'O'           WACCS                          CFT014
     C                   ExSr      SrAccs                                       CFT014
                                                                                CFT014
      ** No error accessing country code's file                                 CFT014
                                                                                CFT014
     C                   If        WACOK = 'Y'                                  CFT014
     C                   Movel     A4ISOC        WRISOC                         CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   EndSl                                                  CFT014
                                                                                CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************         CFT014
      /Title Sr/SrSISO                                                          CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/SrSISO    - Find out Sender ISO Country Code               *         CFT014
      *                                                               *         CFT014
      * Called By: VEUXCHK subroutine                                 *         CFT014
      *                                                               *         CFT014
      * Calls:                                                        *         CFT014
      * SrAccs      - Access standing data detail file                *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     SrSISO        BegSr                                                  CFT014
                                                                                CFT014
     C                   Move      *Blank        WSISOC            2            CFT014
     C                   Eval      WMBRCA = *Blanks                             CFT014
     C                   Eval      WLCCD = *Blanks                              CFT014
     C                   Eval      WCNCD = *Blanks                              CFT014
     C                   Eval      WCNUM = *Blanks                              CFT014
     C                   Eval      WSWIFT = *Blanks                             CFT014
                                                                                CFT014
      ** If multi-branching environment access branch file thru                 CFT014
      ** booking branch, otherwise thru single branch code                      CFT014
                                                                                CFT014
     C                   If        @MBIN = 'Y'                                  CFT014
     C                   Movel     SBRCA         WMBRCA            3            CFT014
     C                   Else                                                   CFT014
     C                   Movel     @BJSBRC       WMBRCA                         CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Get SWIFT Id via access object AOBRCHR0                                CFT014
                                                                                CFT014
     C                   Move      'B'           WACCS                          CFT014
     C                   ExSr      SrAccs                                       CFT014
                                                                                CFT014
      ** No error accessing branch's file                                       CFT014
                                                                                CFT014
     C                   If        WACOK = 'Y'                                  CFT014
                                                                                CFT014
      ** Get ISO Country code via SWIFT Id.                                     CFT014
                                                                                CFT014
     C                   Select                                                 CFT014
     C                   When      A8BTID <> *Blank                             CFT014
     C                   Eval      WSISOC = (%Subst(A8BTID:5:2))                CFT014
                                                                                CFT014
      ** No SWIFT Id., get ISO Country code via location code.                  CFT014
                                                                                CFT014
     C                   When      A8LCCD <> *Blank                             CFT014
     C                   Movel     A8LCCD        WLCCD             3            CFT014
                                                                                CFT014
      ** Get country code via access object AOLOCNR0                            CFT014
                                                                                CFT014
     C                   Move      'L'           WACCS                          CFT014
     C                   ExSr      SrAccs                                       CFT014
                                                                                CFT014
      ** No error accessing Location Code's file                                CFT014
                                                                                CFT014
     C                   If        WACOK = 'Y'                                  CFT014
     C                   Movel     DVCNCD        WCNCD                          CFT014
                                                                                CFT014
      ** Get ISO Country Code via access object AOCTRYR0                        CFT014
                                                                                CFT014
     C                   Move      'O'           WACCS                          CFT014
     C                   ExSr      SrAccs                                       CFT014
                                                                                CFT014
      ** No error accessing Country Code's file                                 CFT014
                                                                                CFT014
     C                   If        WACOK = 'Y'                                  CFT014
     C                   Movel     A4ISOC        WSISOC                         CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Otherwise, use customer number to derive the ISO Country Code.         CFT014
                                                                                CFT014
     C                   Other                                                  CFT014
     C                   Movel     A8BICN        WCNUM                          CFT014
                                                                                CFT014
      ** Access customer's file to get SWIFT id                                 CFT014
                                                                                CFT014
     C                   Move      'C'           WACCS                          CFT014
     C                   ExSr      SrAccs                                       CFT014
                                                                                CFT014
      ** No error accessing customer's file                                     CFT014
                                                                                CFT014
     C                   If        WACOK = 'Y'                                  CFT014
     C                   If        BBCSID <> *Blank                             CFT014
     C                   Movel     BBCSID        WSWIFT                         CFT014
     C                   Eval      WSISOC = (%Subst(WSWIFT:5:2))                CFT014
     C                   Else                                                   CFT014
                                                                                CFT014
      ** No SWIFT id, get country code                                          CFT014
                                                                                CFT014
     C                   Movel     BBCOLC        WCNCD                          CFT014
                                                                                CFT014
      ** Get ISO Country Code via access object AOCTRYR0                        CFT014
                                                                                CFT014
     C                   Move      'O'           WACCS                          CFT014
     C                   ExSr      SrAccs                                       CFT014
                                                                                CFT014
      ** No error accessing country code's file                                 CFT014
                                                                                CFT014
     C                   If        WACOK = 'Y'                                  CFT014
     C                   Movel     A4ISOC        WSISOC                         CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   EndSl                                                  CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************         CFT014
      /Title Sr/SrAccs                                                          CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/SrAccs    - Accesses Customer, Nostro, Location, Country   *         CFT014
      *                Code and Branch code detail file.              *         CFT014
      *                                                               *         CFT014
      * Called By: SrRISO and SrSISO subroutines                      *         CFT014
      *                                                               *         CFT014
      * Calls:                                                        *         CFT014
      * AOCUSTR0 - Access to customer's file                          *         CFT014
      * AOLOCNR0 - Access to location code's file                     *         CFT014
      * AONOSTR0 - Access to Nostro file                              *         CFT014
      * AOCTRYR0 - Access to country code's file                      *         CFT014
      * AOBRCHR0 - Access to Branch code                              *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     SrAccs        BegSr                                                  CFT014
                                                                                CFT014
      ** Initialise access OK indicator                                         CFT014
                                                                                CFT014
     C                   Move      'N'           WACOK             1            CFT014
                                                                                CFT014
      ** Access detail file according to access indicator                       CFT014
                                                                                CFT014
     C                   Select                                                 CFT014
                                                                                CFT014
      ** Customer                                                               CFT014
                                                                                CFT014
     C                   When      WACCS = 'C'                                  CFT014
     C                   Call      'AOCUSTR0'                           9090    CFT014
     C                   Parm      *Blanks       WRTRN             7            CFT014
     C                   Parm      '*KEY   '     WOPTN             7            CFT014
     C                   Parm      WCNUM         WKEY1            10            CFT014
     C                   Parm      *Blanks       WKYST             7            CFT014
     C     SDCUST        Parm      SDCUST        DSSDY                          CFT014
                                                                                CFT014
     C                   If        (WRTRN = *Blank) And (*IN90 = False)         CFT014
     C                   Eval      WACOK = 'Y'                                  CFT014
     C                   Else                                                   CFT014
     C                   Eval      DBPGM  = 'FTVAMAM'                           CFT014
     C                   Eval      DBFILE = 'SDCUSTPD'                          CFT014
     C                   Eval      DBASE = 44                                   CFT014
     C                   Eval      DBKEY = WCNUM                                CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Nostro                                                                 CFT014
                                                                                CFT014
     C                   When      WACCS = 'N'                                  CFT014
     C                   Call      'AONOSTR0'                           9090    CFT014
     C                   Parm      *Blanks       WRTRN                          CFT014
     C                   Parm      '*KEY   '     WOPTN                          CFT014
     C                   Parm                    WCUSN             6            CFT014
     C                   Parm                    WCYCD             3            CFT014
     C                   Parm                    WACCN             4            CFT014
     C                   Parm                    WACSN             2            CFT014
     C                   Parm                    WNONB             2            CFT014
     C                   Parm                    WBRCD             3            CFT014
     C                   Parm                    WCSSN            10            CFT014
     C                   Parm                    WPNOI             1            CFT014
     C     SDNOST        Parm      SDNOST        DSFDY                          CFT014
                                                                                CFT014
     C                   If        (WRTRN = *Blank) And (*IN90 = False)         CFT014
     C                   Eval      WACOK = 'Y'                                  CFT014
     C                   Else                                                   CFT014
     C                   Eval      DBPGM  = 'FTVAMAM'                           CFT014
     C                   Eval      DBFILE = 'SDNOSTPD'                          CFT014
     C                   Eval      DBASE = 45                                   CFT014
     C                   Eval      DBKEY = WOPTN                                CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Location                                                               CFT014
                                                                                CFT014
     C                   When      WACCS = 'L'                                  CFT014
     C                   Call      'AOLOCNR0'                           9090    CFT014
     C                   Parm      *Blanks       WRTRN                          CFT014
     C                   Parm      '*KEY   '     WOPTN                          CFT014
     C                   Parm      WLCCD         WLOCN             3            CFT014
     C     SDLOCN        Parm      SDLOCN        DSFDY                          CFT014
                                                                                CFT014
     C                   If        (WRTRN = *Blank) And (*IN90 = False)         CFT014
     C                   Eval      WACOK = 'Y'                                  CFT014
     C                   Else                                                   CFT014
     C                   Eval      DBPGM  = 'FTVAMAM'                           CFT014
     C                   Eval      DBFILE = 'SDLOCNPD'                          CFT014
     C                   Eval      DBASE = 46                                   CFT014
     C                   Eval      DBKEY = WLCCD                                CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Country Code                                                           CFT014
                                                                                CFT014
     C                   When      WACCS = 'O'                                  CFT014
     C                   Call      'AOCTRYR0'                           9090    CFT014
     C                   Parm      *Blanks       WRTRN                          CFT014
     C                   Parm      '*KEY   '     WOPTN                          CFT014
     C                   Parm      WCNCD         WCTCD             2            CFT014
     C     SDCTRY        Parm      SDCTRY        DSFDY                          CFT014
                                                                                CFT014
     C                   If        (WRTRN = *Blank) And (*IN90 = False)         CFT014
     C                   Eval      WACOK = 'Y'                                  CFT014
     C                   Else                                                   CFT014
     C                   Eval      DBPGM  = 'FTVAMAM'                           CFT014
     C                   Eval      DBFILE = 'SDCTRYPD'                          CFT014
     C                   Eval      DBASE = 47                                   CFT014
     C                   Eval      DBKEY = WCNCD                                CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Branch                                                                 CFT014
                                                                                CFT014
     C                   When      WACCS = 'B'                                  CFT014
     C**********         CALL      'AOBRCHR0'                           9090    CFT014        CGL029
     C                   CALL      'AOBRCHR1'                           9090                  CGL029
     C                   Parm      *Blanks       WRTRN                          CFT014
     C                   Parm      '*KEY   '     WOPTN                          CFT014
     C                   Parm      WMBRCA        WBRCD             3            CFT014
     C*****SDBRCH        PARM      SDBRCH        DSFDY                          CFT014        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
                                                                                CFT014
     C                   If        (WRTRN = *Blank) And (*IN90 = False)         CFT014
     C                   Eval      WACOK = 'Y'                                  CFT014
     C                   Else                                                   CFT014
     C                   Eval      DBPGM  = 'FTVAMAM'                           CFT014
     C                   Eval      DBFILE = 'SDBRCHPD'                          CFT014
     C                   Eval      DBASE = 48                                   CFT014
     C                   Eval      DBKEY = WMBRCA                               CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   EndSl                                                  CFT014
                                                                                CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************         CFT014
      /Title Sr/SrISOC                                                          CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/SrISOC    - Access to ISO Country Codes file               *         CFT014
      *                                                               *         CFT014
      * Called By: VEUXCHK Subroutine                                 *         CFT014
      *                                                               *         CFT014
      * Calls: None                                                   *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     SrISOC        BegSr                                                  CFT014
                                                                                CFT014
     C                   Move      *Off          *IN60                          CFT014
     C                   Move      *Blank        WTRANS            1            CFT014
     C     WISOC         Chain     MEISOCL1                           60        CFT014
     C                   If        *IN60 = False                                CFT014
     C                   Movel     M3SCHT        WTRANS                         CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
     C*****************************************************************
     C* END OF ENTERED AMOUNTS VALIDATION                             *
     C*****************************************************************
     C/EJECT
      *****************************************************************
      * CURRED - READ CURRENCY FILE                                   *
      *****************************************************************
     C*
     C     CURRED        BEGSR
 
     C                   CALLB     'AOCURRR0'
     C                   Parm      '*DBERR '     C#RTCD
     C                   Parm      '*KEY   '     C#OPTN
     C                   Parm                    C#K101
     C     SDCURR        Parm      SDCURR        DSSDY
 
     C                   ENDSR
     C*
     C************************************************************
     C* END OF CURRENCY READ
     C************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeIn
      *  Screen fields
     C                   Parm                    TranInPrim
     C                   Parm                    TranInPrmX                     CFT014
 
      * OUTPUTS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      * Warning fields/message IDs/message data (arrays) from/to caller                       CSD089
     C                   Parm                    WFldNmXAr                                    CSD089
     C                   Parm                    WMsgIDXAr                                    CSD089
     C                   Parm                    WMsgDtXAr                                    CSD089
 
      *  OK Flags
     C                   Parm                    OKFlagsDS
 
      *  Validation Work Fields
     C                   Parm                    Val@Fields
      ** Screen Input Function                                                              MD021318
     C                   PARM                    PMode                                      MD021318
 
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  POWER - Array of powers of 10 for currency conversions                      CFT014
0000001                                                                         CFT014
0000010                                                                         CFT014
0000100                                                                         CFT014
0001000                                                                         CFT014
0010000                                                                         CFT014
0100000                                                                         CFT014
1000000                                                                         CFT014
