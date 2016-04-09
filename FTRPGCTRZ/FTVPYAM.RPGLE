     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate pay currency and amount')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVPYAM  - Validate Pay Currency & Amount                    *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CFT120             Date 28Sep12               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 BUG8068            Date 31Aug05               *
      *                 CGL014             Date 20Oct03               *
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
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompile)    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  BUG8068 - Both settlement and pay amount should be           *
      *            acceptable if not equal to blank                   *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  175479 - Recompile over changes in outgoing payment file     *
      *  CFT007 - Recompiled for BIC Database Plus Integration        *
      *  CFT004 - Recompiled for IBAN (International Bank A/C No.)    *
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
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
 
      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
 
      * Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY1PD)
 
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
      * External DS for General Ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      * External DS Midas SD Trading ICD data
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
 
      * External data structure for currency codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      * First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * External data structure for access programs (short)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
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
 
     D C#CURR          S              3
     D C#OPTN          S              7
     D C#RTCD          S              7
 
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
     C                   Eval      RetCodeIn = *Blanks
     C                   Eval      FldNamXAr = *Blanks
     C                   Eval      MsgIDXAr  = *Blanks
     C                   Eval      MsgDtaXAr = *Blanks
     C                   Eval      Idx = 0
 
      * Settle currency validation
      *
     C                   EXSR      VPAYCUR
 
      * Settle amount validation
      *
     C                   If        OKPccy = 'Y'
     C                   If        @AmtVal = 'Y'
     C                   Exsr      VPAYAMT
     C                   Else
     C                   Move      *Blank        ZFIELD
     C                   Move      SPYAM         ZFIELD
     C                   Exsr      VZALIGN
 
     C                   If        ZalignOK = 'Y'
     C                   Move      ZFIELD        @PYAM
     C                   End
 
     C                   End
     C                   End
 
      ** If an error was found, set the return code appropriately
      *
     C                   If        OKPccy = 'N' or
     C                             OKPyam = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   End
 
      * RETURN
      *
     C                   RETURN
      ******************************************************************
      /EJECT                                                           *
     C******************************************************************
     C* VPAYCUR - VALIDATION OF PAY CURRENCY                           *
     C*           MANDATORY - MUST BE ON TABLE TABTG10                 *
     C******************************************************************
     C*
     C     VPAYCUR       BEGSR
 
     C                   If        SPCCY = *Blanks
     C                   If        @PINEU = 'I'
     C                   Eval      SPCCY = BKEURO
     C                   Else
     C                   Eval      SPCCY = SSMCY
     C                   End
     C                   End
 
      ** access currency file
     C                   CALL      'AOCURRR0'
     C                   Parm      *Blanks       C#RTCD
     C                   Parm      '*KEY   '     C#OPTN
     C                   Parm      SPCCY         C#CURR
     C     SDCURR        Parm      SDCURR        DSSDY
 
     C                   If        C#RTCD <> *Blanks
      * Send error to screen
     C                   Move      'N'           OKPccy
     C                   Add       1             Idx
     C                   Movel     'SPCCY'       FldNamXAr(Idx)
     C                   Movel     'MMA0925'     MsgIdXAr(Idx)
 
     C* If not on file must set up decimal places etc for
     C* validation of other field
     C                   Eval      @RCDP = 0
     C                   Eval      @RSPOT = 1
     C                   Eval      @RMDIN = 0
     C                   Else
 
     C                   Move      C#CURR        SPCCY
 
     C                   If        A6INCY = 'Y'
     C                   Eval      @PTPSD = A6TPSD
     C                   End
 
     C                   If        @PINEU = 'I' and
     C***********                  SPCCY <> BKEURO or                           CFT014
     C                             SPCCY <> BKEURO And @CFT014 <> 'Y' or        CFT014
     C                             @PINEU = 'E' and
     C                             A6INCY <> 'Y'
     C                             And @CFT014 <> 'Y'                           CFT014
      * Send error to screen
     C                   Move      'N'           OKPccy
     C                   Add       1             Idx
     C                   Movel     'SPCCY'       FldNamXAr(Idx)
     C***********        Movel     'MMA0926'     MsgIdXAr(Idx)                  CFT014
     C                   Movel     'FTM3249'     MsgIdXAr(Idx)                  CFT014
 
     C                   End
 
     C*
     C** Move new standing data field into field used in program
     C*
     C                   If        A6MDIN = 'M'
     C                   Eval      @RMDIN = 1
     C                   Else
     C                   Eval      @RMDIN = 0
     C                   End
 
     C* Store decimal places spot rate multiply/divide ind
     C                   Eval      @RCDP = A6NBDP
     C                   Eval      @RSPOT = A6SPRT
 
     C* Change spot rate by buy spread
     C                   If        A6BYSS = '+'
     C                   Eval      @RBRAT = A6SPRT + A6BYSR
     C                   Else
     C                   Eval      @RBRAT = A6SPRT - A6BYSR
     C                   End
 
     C* Change spot rate by sell spread
     C                   If        A6SLSS = '+'
     C                   Eval      @RSRAT = A6SPRT + A6SLSR
     C                   Else
     C                   Eval      @RSRAT = A6SPRT - A6SLSR
     C                   End
 
     C                   End
 
     C                   ENDSR
     C*****************************************************************
     C* END OF PAY CURRENCY VALIDATION                                *
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C* VPAYAMT - VALIDATION OF PAY AMOUNT                            *
     C*           MANDATORY IF SETTLE AMOUNT NOT ENTERED OTHERWISE    *
     C*           NOT PERMITTED                                       *
     C*****************************************************************
     C*
     C     VPAYAMT       BEGSR
     C*
     C                   If        SPYTP = 'RP'
 
     C                   If        SSMAM = *Blank  and
     C**********                   SPYAM = *Blank  or                                        BUG8068
     C                             SPYAM = *Blank                                            BUG8068
     C**********                   SSMAM <> *Blank and                                       BUG8068
     C**********                   SPYAM <> *Blank                                           BUG8068
      * Send error to screen
     C                   Move      'N'           OKPyam
     C                   Add       1             Idx
     C                   Movel     'DDPYAM'      FldNamXAr(Idx)
     C                   Movel     'MMA0927'     MsgIdXAr(Idx)
     C                   End
 
     C                   End
 
     C                   If        OKPyam = 'Y'
 
     C* If entered validate
     C                   If        SPYAM <> *Blank
     C                   Move      *Blank        ZFIELD
     C                   Move      SPYAM         ZFIELD
     C                   Exsr      VZALIGN
 
     C                   If        ZalignOK = 'Y'
     C                   Move      ZFIELD        @PYAM
     C                   Move      'R'           @FAIN
     C                   End
 
     C                   Else
     C                   Eval      @PYAM = 0
     C                   End
 
     C                   End
 
     C                   ENDSR
     C*
     C*****************************************************************
     C* END OF PAY AMOUNT VALIDATION                                  *
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C* VZALIGN - VALIDATION OF NUMERIC FIELD                         *
     C*****************************************************************
     C     VZALIGN       BEGSR
     C*
     C                   Eval      ZADIG = 13 - @RCDP
     C                   Eval      ZADEC = @RCDP
 
      * Validate amount as numeric with correct d.p.
     C                   CALLB     'ZALIGN'
     C                   Parm                    ZalignOK          1
     C                   Parm                    ZFIELD           16
     C                   Parm                    ZADEC             1 0
     C                   Parm                    ZADIG             2 0
      *
     C                   If        ZalignOK = 'N'
      * Send error to screen
     C                   Move      'N'           OKPyam
     C                   Add       1             Idx
     C                   Movel     'SPYAM'       FldNamXAr(Idx)
     C                   Movel     'MMA0927'     MsgIdXAr(Idx)
     C                   End
 
     C                   ENDSR
     C*****************************************************************
     C* END OF PAY AMOUNT VALIDATION                                  *
     C*****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeIn
 
      *  Screen fields
     C                   Parm                    TranInPrim
 
      * OUTPUTS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
 
      *  OK Flags
     C                   Parm                    OKFlagsDS
 
      *  Validation Work Fields
     C                   Parm                    Val@Fields
 
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
      * Read SDTRADPD for Trading Details
     C                   CALLB     'AOTRADR0'
     C                   Parm      '*DBERR'      @RTCD
     C                   Parm      '*FIRST'      @OPTN
     C     SDTRAD        Parm      SDTRAD        DSFDY
 
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
