     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate pay date')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVPYDT  - Validate Pay Date                                 *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  Last Amend No. CFT120             Date 28Sep12               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 AR702741           Date 02Feb11               *
      *                 CRE067             Date 05Oct10               *
      *                 261593             Date 23Oct09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      *                 241301             Date 25Jul07               *
      *                 248631             Date 23Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 06Jul06               *
      *                 237436             Date 21Feb06               *
      *                 BUG7455            Date 03Jun05               *
      *                 BUG4039            Date 23Aug04               *
      *                 CGL014             Date 20Oct03
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
      *                 CAP031  *CREATE    Date 06Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  261593 - Default pay value date even if CFT009 is ON.        *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompile)    *
      *  241301 - Transition value date should be verified only when  *
      *           it has been reached since EMU rates are used from   *
      *           this period onwards.                                *
      *  248631 - No warning message for outbound FT on a holiday.    *
      *           Patterned after fix 223018 which added a new        *
      *           warning message when the date for payment currency  *
      *           falls on a holiday.                                 *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  237436 - Reverse BUG4039 to adhere to core processing.       *
      *  BUG7455 - Incorrect date format of :32A: in MT202 message as *
      *           fields PVDTD3/SLDTD3 are not updated properly with  *
      *           YYMMDD format if BJDFIN='M'. Pattern updating       *
      *           format of these fields from non-API program.        *
      *           Applied fix 219955.                                 *
      * BUG4039 - Applied Fix of GEMS 219810                          *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT. (Recompiled)            *
      *  175479 - Recompile over changes in outgoing payment file     *
      *  CFT007 - Recompiled for BIC Database Plus Integration        *
      *  CFT004 - Recompiled for IBAN (International Bank A/C No.)    *
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
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
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Array of Warning in error.
     D WFldNmXAr       S             10A   DIM(XArrayMax)
 
      ** Array of Warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of Warning message data.
     D WMsgDtaXAr      S                   DIM(XArrayMax) LIKE(#MsgData)
 
      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
 
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY1PD)
 
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for General Ledger ICD Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      * First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D WDATE           DS             6
     D  ODD                    1      2
     D  OMM                    3      4
     D  OYY                    5      6
 
     D                 DS
     D WZDATE                  1      6  0
     D  ZDD                    1      2
     D  ZMM                    3      4
     D  ZYY                    5      6
     D  ZYN                    5      6  0
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
 
      ** Index for arrays of warning message ids etc
     D WIx             S              3P 0
 
      * This prog only
     D WDATEL          S              7P 0
     D WDATES          S              6A
     D ZDATE           S              6P 0
     D ZDATIN          S              6
     D ZDATEA          S              7
     D ZFREQ           S              1A
     D ZMDAY           S              2P 0
     D ZDAYNO          S              5P 0
     D ZLOC            S              3
     D ZCCY            S              3
     D ZERR            S              1A
     D ZHIND           S              1A
     D DAYNO1          S                   LIKE(ZDAYNO)
     D DAYNO2          S                   LIKE(ZDAYNO)
     D*WOk******       S              1A                                              BUG4039 237436
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
 
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
 
     C                   Eval      RetCodeIn = *Blanks
     C                   Eval      FldNamXAr = *Blanks
     C                   Eval      MsgIDXAr  = *Blanks
     C                   Eval      MsgDtaXAr = *Blanks
     C                   Eval      WFldNmXAr = *Blanks
     C                   Eval      WMsgIDXAr  = *Blanks
     C                   Eval      WMsgDtaXAr = *Blanks
     C                   Eval      Idx = 0
     C                   Eval      WIx = 0
 
      * Validate Override Flag
     C                   Exsr      VPAYDAT
      *
      ** If an error was found, set the return code appropriately
      *
     C                   If        OKDst1 = 'N' or
     C                             OKSnco = 'N' or
     C                             OKPyvd = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   End
 
      * RETURN
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VPAYDAT - PAY DATE VALIDATION
      *****************************************************************
     C*
     C     VPAYDAT       BEGSR
 
     C**********         EVAL      WOk = '0'                                          BUG4039 237436
     C                   If        SPYVD = *Blanks
      **********                                                                      BUG4039 237436
      ****By*this*time*the*settle*value*date*was*already*validated.**If               BUG4039 237436
      ****Pay*Value*date*is*blanks*and*settle*value*date*is*valid,*move               BUG4039 237436
      ****Settle*Value*date*to*Pay*Value*date*and*skip*validation.*****               BUG4039 237436
      **********                                                                      BUG4039 237436
     C**********         IF        OKPydt <> 'N'                                      BUG4039 237436
     C**********         MOVE      SPYDT         SPYVD                                BUG4039 237436
     C**********         Z-ADD     @SLDT         @PVDT                                BUG4039 237436
     C**********         Z-ADD     @SLDTD1       @PVDTD1                              BUG4039 237436
     C**********         Z-ADD     @SLDTD2       @PVDTD2                              BUG4039 237436
     C**********         Z-ADD     @SLDTD3       @PVDTD3                              BUG4039 237436
     C**********         EVAL      WOk = '1'                                          BUG4039 237436
     C**********         END                                                          BUG4039 237436
     C**********         Eval      ZFREQ = 'D'                                               BUG4039
     C                   Eval      ZFREQ = 'D'                                                237436
 
     C**********         If        @NOWRK = 'N'                                              BUG4039
     C**********         Eval      ZCCY = SPCCY                                              BUG4039
     C**********         Else                                                                BUG4039
     C**********         Eval      ZCCY = BJLCCY                                             BUG4039
     C**********         End                                                                 BUG4039
     C                   If        @NOWRK = 'N'                                               237436
     C                   Eval      ZCCY = SPCCY                                               237436
     C                   Else                                                                 237436
     C                   Eval      ZCCY = BJLCCY                                              237436
     C                   End                                                                  237436
 
     C**********         Eval      ZDAYNO = BJRDNB                                           BUG4039
     C**********         Eval      ZLOC = @PLOC                                              BUG4039
     C                   Eval      ZDAYNO = BJRDNB                                            237436
     C                   Eval      ZLOC = @PLOC                                               237436
      * Find run date plus 1
     C**********         CALLB     'ZFREQB'                                                  BUG4039
     C**********         Parm      ' '           ZERR                                        BUG4039
     C**********         Parm                    ZFREQ                                       BUG4039
     C**********         Parm                    ZDAYNO                                      BUG4039
     C**********         Parm                    ZCCY                                        BUG4039
     C**********         Parm                    ZMDAY                                       BUG4039
     C**********         Parm                    BJDFIN                                      BUG4039
     C*****SDGELR        Parm                    SDGELR                                      BUG4039
     C                   CALLB     'ZFREQB'                                                   237436
     C                   Parm      ' '           ZERR                                         237436
     C                   Parm                    ZFREQ                                        237436
     C                   Parm                    ZDAYNO                                       237436
     C                   Parm                    ZCCY                                         237436
     C                   Parm                    ZLOC                                       AR702741
     C                   Parm                    ZMDAY                                        237436
     C                   Parm                    BJDFIN                                       237436
     C     SDGELR        Parm                    SDGELR                                       237436
 
     C**********         If        ZERR <> *Blanks                                           BUG4039
     C**********         Move      'FTVPYDT'     DBPGM                                       BUG4039
     C**********         Move      'ZFREQB'      DBFILE                                      BUG4039
     C**********         Eval      DBASE = 7                                                 BUG4039
     C**********         Movel     ZCCY          DBKEY                                       BUG4039
     C**********         Exsr      *PSSR                                                     BUG4039
     C**********         End                                                                 BUG4039
     C                   If        ZERR <> *Blanks                                            237436
     C                   Move      'FTVPYDT'     DBPGM                                        237436
     C                   Move      'ZFREQB'      DBFILE                                       237436
     C                   Eval      DBASE = 7                                                  237436
     C                   Movel     ZCCY          DBKEY                                        237436
     C                   Exsr      *PSSR                                                      237436
     C                   End                                                                  237436
 
      * If not base currency find run date plus 2
     C**********         If        SPCCY <> BJCYCD                                           BUG4039
     C                   If        SPCCY <> BJCYCD                                            237436
      * Find run date plus 2
     C**********         CALLB     'ZFREQB'                                                  BUG4039
     C**********         Parm      ' '           ZERR                                        BUG4039
     C**********         Parm                    ZFREQ                                       BUG4039
     C**********         Parm                    ZDAYNO                                      BUG4039
     C**********         Parm                    ZCCY                                        BUG4039
     C**********         Parm                    ZMDAY                                       BUG4039
     C**********         Parm                    BJDFIN                                      BUG4039
     C*****SDGELR        Parm                    SDGELR                                      BUG4039
     C                   CALLB     'ZFREQB'                                                   237436
     C                   Parm      ' '           ZERR                                         237436
     C                   Parm                    ZFREQ                                        237436
     C                   Parm                    ZDAYNO                                       237436
     C                   Parm                    ZCCY                                         237436
     C                   Parm                    ZLOC                                       AR702741
     C                   Parm                    ZMDAY                                        237436
     C                   Parm                    BJDFIN                                       237436
     C     SDGELR        Parm                    SDGELR                                       237436
 
     C**********         End                                                                 BUG4039
     C                   End                                                                  237436
 
     C                   Else
     C                   Eval      ZERR = 'N'
      * Check date is numeric
     C                   Movel     SPYVD         WDATEL
     C                   Movel     WDATEL        WDATES
 
     C                   If        SPYVD <> WDATES
     C                   Move      'N'           OKPyvd
     C                   Move      ' '           ZERR
 
     C                   Else
     C                   Eval      ZDATIN = SPYVD
 
     C                   Eval      @PYVD = SPYVD
 
     C                   CALLB     'ZDATE1'
     C                   Parm                    ZDATIN
     C                   Parm      0             ZDAYNO
     C                   Parm                    BJDFIN
     C                   Parm      'N'           ZERR
 
      * The date must not be a holiday in local currency
     C                   Eval      ZCCY = BJLCCY
     C                   CALLB     'ZCHKH'
     C                   Parm                    ZDAYNO
     C                   Parm                    ZCCY
     C                   Parm                    ZLOC
     C                   Parm      ' '           ZHIND
 
      ** if ZHIND = 'H' then the date is a holiday - send warning
     C                   If        ZHIND = 'H'
     C                   Move      'W'           OKPyvd
     C                   Add       1             WIx
     C                   Movel     'SPYVD'       WFldNmXAr(WIx)
     C**********         Movel     'MMA0982'     WMsgIdXAr(WIx)                               248631
     C                   MOVEL     'MMA3000'     WMsgIdXAr(WIx)                               248631
     C                   End
      *                                                                                       248631
      ** Warning error if date is a holiday in pay curency - nostro loc                       248631
      *                                                                                       248631
     C     @NOWRK        IFEQ      'N'                                                        248631
     C                   MOVE      SPCCY         ZCCY                                         248631
     C                   CALLB     'ZCHKH'                                                    248631
     C                   PARM                    ZDAYNO                                       248631
     C                   PARM                    ZCCY                                         248631
     C                   PARM                    ZLOC                                         248631
     C                   PARM      ' '           ZHIND                                        248631
      *                                                                                       248631
      ** if ZHIND = 'H' then the date is a holiday - send warning                             248631
      *                                                                                       248631
     C     ZHIND         IFEQ      'H'                                                        248631
     C                   MOVE      'W'           OKPyvd                                       248631
     C                   ADD       1             WIx                                          248631
     C                   MOVEL     'SPYVD'       WFldNmXAr(WIx)                               248631
     C                   MOVEL     'MMA3001'     WMsgIdXAr(WIx)                               248631
     C                   ENDIF                                                                248631
     C                   ENDIF                                                                248631
 
     C                   End
     C                   End
 
     C                   If        OKPyvd = 'N' or
     C                             ZERR = 'Y'
      * Send error to screen
     C                   Move      'N'           OKPyvd
     C                   Add       1             Idx
     C                   Movel     'SPYVD'       FldNamXAr(Idx)
     C                   Movel     'MMA0984'     MsgIdXAr(Idx)
     C**********         END                                                          BUG4039 237436
 
     C**********         Else                                                                BUG4039
     C                   Else                                                                 237436
      **********                                                                      BUG4039 237436
      ****Skip*if*Pay*Value*date*defaulted*to*Settle*date.*************               BUG4039 237436
      **********                                                                      BUG4039 237436
     C**********         IF         WOk <> '1'                                        BUG4039 237436
      **********                                                                      BUG4039 237436
      * If Type = 'RP' Cannot be less than Settle Date
     C                   If         ZDAYNO < @SLDT and
     C                              SPYTP = 'RP'
      * Send error to screen
     C                   Move      'N'           OKPyvd
     C                   Add       1             Idx
     C                   Movel     'SPYVD'       FldNamXAr(Idx)
     C                   Movel     'MMA0983'     MsgIdXAr(Idx)
     C                   End
     C**********         End                                                                 BUG4039
     C                   End                                                                  237436
 
     C                   If        OKPyvd <> 'N'
     C                   CALLB     'ZDATE2'
     C                   Parm                    ZDAYNO
     C                   Parm                    BJDFIN
     C     ZDATE         Parm      *Zeros        ZDATE
     C     ZDATEA        Parm      *Blanks       ZDATEA
 
     C                   Eval      @PVDTD1 = ZDATE
     C                   Eval      WZDATE = ZDATE
     C                   Eval      @PVDT = ZDAYNO
 
      * Format Date for D3
     C                   If        BJDFIN <> 'M'
     C                   Eval      OYY = ZDD
     C                   Eval      OMM = ZMM
     C                   Eval      ODD = ZYY
     C                   Else
     C**********         Eval      ODD = ZDD                                                 BUG7455
     C                   Eval      ODD = ZYY                                                 BUG7455
     C**********         Eval      OMM = ZMM                                                 BUG7455
     C                   Eval      OMM = ZDD                                                 BUG7455
     C**********         Eval      OYY = ZYY                                                 BUG7455
     C                   Eval      OYY = ZMM                                                 BUG7455
     C                   End
 
     C                   Move      WDATE         @PVDTD3
 
      * Find century
     C                   If             ZYN < 72
     C                   Eval           @PVDTD2 = 20
     C                   Else
     C                   Eval           @PVDTD2 = 19
     C                   End
 
     C                   End
 
 
     C                   If        OKPyvd <> 'N'
     C**********                   AND @CFT009 = 'N'                                   CFT009 261593
     C                   Move      ZDATE         SPYVD
     C                   End
 
     C* Find the number of days between Settle and Pay dates
     C* Only if both days are valid
     C                   If        OKPydt <> 'N' and
     C                             OKPyvd <> 'N' and
     C                             OKPccy = 'Y'
     C                   Eval      @PRBD = 0
     C                   Eval      ZFREQ = 'D'
     C                   Eval      ZCCY = SPCCY
 
     C                   If        @SLDT < @PVDT
     C                   Eval      DAYNO1 = @SLDT
     C                   Eval      DAYNO2 = @PVDT
     C                   Else
     C                   Eval      DAYNO1 = @PVDT
     C                   Eval      DAYNO2 = @SLDT
     C                   End
 
     C                   Eval      ZDAYNO = DAYNO1
     C                   Eval      ZLOC = @PLOC
1
     C                   DOW       ZDAYNO < DAYNO2
     C                   CALLB     'ZFREQB'
     C                   Parm      ' '           ZERR
     C                   Parm                    ZFREQ
     C                   Parm                    ZDAYNO
     C                   Parm                    ZCCY
     C                   Parm                    ZLOC                                       AR702741
     C                   Parm                    ZMDAY
     C                   Parm                    BJDFIN
     C     SDGELR        Parm                    SDGELR
 
     C                   Eval      @PRBD = @PRBD + 1
     C                   End
 
     C                   End
 
     C                   If        @SLDT > @PVDT
     C                   Eval      @PRBD = @PRBD * -1
     C                   End
 
 
      *  Check if pay date is in the future and if the account is
      *  closing today
 
     C                   If        @PVDT > BJRDNB and
     C                             @ACST1 = 'C'
      * Send error to screen
     C                   Move      'N'           OKDst1
     C                   Add       1             Idx
     C                   Movel     'SDST1'       FldNamXAr(Idx)
     C                   Movel     'MMA0985'     MsgIdXAr(Idx)
     C                   End
      *
     C                   If        @PVDT > BJRDNB and
     C                             @ACST2 = 'C'
      * Send error to screen
     C                   Move      'N'           OKSnco
     C                   Add       1             Idx
     C                   Movel     'DDSNCO'      FldNamXAr(Idx)
     C                   Movel     'MMA0986'     MsgIdXAr(Idx)
     C                   End
 
     C                   If        SPYTP <> 'RP'
 
      * For back value if retail open date will be non-zero
     C                   If        @SCOPN = 0
 
     C                   If        @DSOPN <> 0
 
     C                   If        @PVDT < @DSOPN
      * Send error to screen
     C                   Move      'N'           OKDst1
     C                   Add       1             Idx
     C                   Movel     'SDST1'       FldNamXAr(Idx)
     C                   Movel     'MMA0987'     MsgIdXAr(Idx)
     C                   End
 
     C                   If        @PVDT < @BVLD
      * Send error to screen
     C                   Move      'N'           OKDst1
     C                   Add       1             Idx
     C                   Movel     'SDST1'       FldNamXAr(Idx)
     C                   Movel     'MMA0988'     MsgIdXAr(Idx)
     C                   End
 
     C                   End
 
     C                   Else
     C                   If        @PVDT < @SCOPN
      * Send error to screen
     C                   Move      'N'           OKSnco
     C                   Add       1             Idx
     C                   Movel     'DDSnco'      FldNamXAr(Idx)
     C                   Movel     'MMA0989'     MsgIdXAr(Idx)
     C                   End
 
     C                   If        @PVDT < @BVLD
      * Send error to screen
     C                   Move      'N'           OKSnco
     C                   Add       1             Idx
     C                   Movel     'DDSNCO'      FldNamXAr(Idx)
     C                   Movel     'MMA0990'     MsgIdXAr(Idx)
     C                   End
 
     C                   End
     C                   End
 
      *                                                                                       241301
      ** If CEU006, validate payment value date against transition                            241301
      ** date only when the payment value date is backvalued. However,                        241301
      ** if the transition date is still in the future then do not                            241301
      ** proceed with the validation.                                                         241301
      *                                                                                       241301
     C                   If        @CEU006 = 'Y' and                                          241301
     C                             @PTPSD <= BJRDNB                                           241301
      *                                                                                       241301
     C                   If        SPDCY <> *Blanks and
     C                             @PTPSD > @PVDT
      * Send error to screen
     C                   Move      'N'           OKPyvd
     C                   Add       1             Idx
     C                   Movel     'SPYVD'       FldNamXAr(Idx)
     C                   Movel     'MMA0979'     MsgIdXAr(Idx)
     C                   End
      *                                                                                       241301
     C                   End                                                                  241301
      *                                                                                       241301
     C**********         END                                                          BUG4039 237436
 
     C                   ENDSR
     C*
     C************************************************************
     C* END OF PAY DATE VALIDATION
     C************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeIn
 
      *  Screen fields
     C                   Parm                    TranInPrim
 
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
 
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtaXAr
 
      *  OK Flags
     C                   Parm                    OKFlagsDS
 
      *  Validation Work Fields
     C                   Parm                    Val@Fields
 
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
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
(c) Misys International Banking Systems Ltd. 2001
