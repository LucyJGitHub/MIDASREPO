     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate FX margin information')              *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVMGMG    - Validate FX Margin Information                  *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 CGL014             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 202895             Date 22Jul02               *
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
      *                 CAP031  *CREATE    Date 21Jul99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompile)    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  202895 - Check module indicator to condition calling of      *
      *           Access Object programs.                             *
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
 
      ** Array of Warning in error.
     D WFldNmXAr       S             10A   DIM(XArrayMax)
 
      ** Array of Warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of Warning message data.
     D WMsgDtaXAr      S                   DIM(XArrayMax) LIKE(#MsgData)
 
      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
     D*TranInThir****E*DS***               EXTNAME(FTOPY4PD)                    CFT014
     D TranInFift    E DS                  EXTNAME(FTOPY7PD)                    CFT014
 
      * Flags to indicate whether transaction fields are valid
     D*OKFlagsDS*****E*DS***               EXTNAME(FTEOPY3PD)                   CFT014
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY5PD)                   CFT014
 
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D** Data Structure for Bank Details Access Program
     D*
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D** Data Structure for Currency Details Access Program
     D*
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D** Data Structure for Dealing ICD Details Access Program
     D*
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  202895
      ** External DS For MIDAS Module Details                                                 202895
     D*                                                                                       202895
     D SDPCAC        E DS                  EXTNAME(SDPCACPD)
     D** Data Structure for Profit Centre Accounting Access Program
     D*
      ** External data structure for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D AP              S             10  0 DIM(10) CTDATA PERRCD(1)
     D** Array - Powers of Ten.
     D*
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
 
     D WCSID           S             12
 
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
     C                   Eval      WFldNmXAr = *Blanks
     C                   Eval      WMsgIDXAr  = *Blanks
     C                   Eval      WMsgDtaXAr = *Blanks
     C                   Eval      Idx = 0
     C                   Eval      WIx = 0
     C                   Eval      DeftsUsed = 'N'
     C                   Eval      @FXMD = *zeros
     C                   Eval      @FXMP = *zeros
     C                   Eval      @MAMT = *zeros
 
      * Set up default fields
     C                   Exsr      SETUPDFTS
 
      * Validate Margin Points
      *
     C                   Exsr      VMGNPTS
 
      * Validate Margin P/S Indicator
      *
     C                   Exsr      VMGNPSI
 
      * Validate Margin Sign
      *
     C                   Exsr      VMGNSIGN
 
     C**  If no errors calculate Margin Amount.
     C*
     C     OKFXMP        IFNE      'N'
     C     OKMSIG        ANDNE     'N'
     C     OKMBSI        ANDNE     'N'
     C                   EXSR      SRMAMT
     C                   ELSE
     C                   MOVE      'N'           DeftsUsed         1
     C                   ENDIF
     C*
      ** If an error was found, set the return code appropriately
      *
     C                   If        OKMBSI = 'N' or
     C                             OKMSIG = 'N' or
     C                             OKFXMP = 'N'
     C                   Eval      RetCodeIn = 'Error'
 
     C                   Else
 
     C**  If data are all valid  update valid fields.
     C                   Z-ADD     @MDIN         @FXMD
     C                   Z-ADD     WMAMT         @MAMT
 
     C**  Format FX Margin Points.
     C**  - Execute FMTAMT to format the points, using 2 decimal places
     C**    and adjusting the file figure to have only implied decimal
     C**    places.
     C     @FXMP         IFEQ      0
     C                   MOVE      *BLANKS       SFXMP
     C                   ELSE
     C     @FXMP         MULT      100           @@AMTW
     C                   Z-ADD     2             @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        SFXMP
     C                   END
     C                   ENDIF
     C*
      * RETURN
      *
     C                   RETURN
      ******************************************************************
      /EJECT
     C****************************************************************
     C* SETUPDFTS - Setup default parameters                         *
     C****************************************************************
     C*
     C     SETUPDFTS     BEGSR
 
     C**  Get Settlement and Pay Currencies Details.
     C*
     C                   EXSR      SRCURR
     C*
     C**  Calculate Pay/Settle Amounts.
     C*
     C                   EXSR      SRMOVF
     C*
     C**  Get Default Cross-Currency Rate.
     C*
     C                   EXSR      SRDRAT
     C*
     C**  Get Normally-Quoted Decimal Places.
     C*
     C                   EXSR      SRNQDP
     C*
     C**  Calculate for Default FX Margin Points and Sign.
     C**  Deflt FX Marg Pts = (Xccy rate - Trans Rate) * 10**Quoted DP
     C*
     C     ZRATEX        IFGE      @RATE
     C     ZRATEX        SUB       @RATE         DeftFXMR         13 8
     C                   ELSE
     C     @RATE         SUB       ZRATEX        DeftFXMR
     C                   ENDIF
     C*
     C     ZRATEX        IFGE      @RATE
     C     ZRATEX        ANDGT     1
     C     WWPYAM        ANDGE     WWSMAM
     C     ZRATEX        ORGE      @RATE
     C     ZRATEX        ANDLT     1
     C     WWPYAM        ANDLE     WWSMAM
     C     ZRATEX        ORLE      @RATE
     C     ZRATEX        ANDGT     1
     C     WWPYAM        ANDLE     WWSMAM
     C     ZRATEX        ORLE      @RATE
     C     ZRATEX        ANDLT     1
     C     WWPYAM        ANDGE     WWSMAM
     C                   MOVE      '+'           DeftMSIG          1
     C                   ELSE
     C                   MOVE      '-'           DeftMSIG
     C                   ENDIF
     C*
     C*
     C     ZNQDPX        ADD       1             ZA                1 0
     C     DeftFXMR      MULT(H)   AP(ZA)        DeftFXMP          7 2
     C*
     C**  Compute the maximum margin points allowed.
     C**  Maximum Marg Pts = Xccy rate * Tolerance * 10**Quoted DP
     C*
     C     FTTMRT        DIV       100           W1                3 2
     C     W1            MULT(H)   @RATE         W2               13 8
     C     W2            MULT(H)   AP(ZA)        WMAXPT            7 2
     C*
     C**  If the Default FX Margin Points is greater than the maximum,
     C**  use the maximum as the default.
     C*
     C     DeftFXMP      IFGT      WMAXPT
     C                   Z-ADD     WMAXPT        DeftFXMP
     C                   ENDIF
     C*
     C**  Format Default FX Margin Points.
     C*
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DeftFXMP      ZFIELD
     C                   Z-ADD     2             ZADEC
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   MOVE      ZFIELD        SDFXMP            8
     C*
     C                   ENDSR
     C*
     C************************************************************
     C/EJECT
     C****************************************************************
     C* VMGNSIGN -  VALIDATION OF MARGIN SIGN                        *
     C****************************************************************
     C*
     C     VMGNSIGN      BEGSR
 
     C**       If the Margin Sign is not entered, default it.
     C*
     C     SMSIG         IFEQ      *BLANKS
     C                   MOVE      DeftMSIG      SMSIG
     C                   ELSE
     C*
     C**  If the FX Margin points field has not been entered, display
     C**  error message 'Margin Sign entry invalid if no FX Margin
     C**  Points have been defined."
     C*
     C     SFXMP         IFEQ      *BLANKS
     C                   Move      'N'           OKMSIG
     C                   Add       1             Idx
     C                   Movel     'SMSIG'       FldNamXAr(Idx)
     C                   Movel     'AAM0010'     MsgIdXAr(Idx)
     C*
     C                   ELSE
     C*
     C**  If the Margin Sign is not the same as the default, display
     C**  error message "Margin Sign should be '+'/'-'".
     C*
     C     SMSIG         IFNE      DeftMSIG
     C     DeftMSIG      IFEQ      '+'
     C                   Add       1             Idx
     C                   Movel     'AAM0016'     MsgIdXAr(Idx)
     C                   ELSE
     C                   Add       1             Idx
     C                   Movel     'AAM0017'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   Move      'N'           OKMSIG
     C                   Movel     'SMSIG'       FldNamXAr(Idx)
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C                   ENDSR
     C*
     C************************************************************
     C* END OF MARGIN SIGN VALIDATION
     C************************************************************
     C/EJECT
     C****************************************************************
     C* VMGNPTS -  VALIDATION OF MARGIN POINTS                       *
     C****************************************************************
     C*
     C     VMGNPTS       BEGSR
 
     C**  Validate FX Margin points.
     C*
     C**  If FX Margin Points is not entered, default it
     C*
     C     SFXMP         IFEQ      *BLANKS
     C*
     C                   Z-ADD     DeftFXMP      @FXMP
     C                   MOVE      SDFXMP        SFXMP
     C                   MOVE      DeftMSIG      SMSIG
     C                   MOVE      'Y'           DeftsUsed
     C*
     C                   ELSE
     C*
     C**  If FX Margin Points is not valid, display error message
     C**  "Invalid FX Margin Points entry. Must be entered with a
     C**   maximum of 5 integers and 2 decimals."
     C*
     C                   Z-ADD     0             @FXMP
     C*
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      SFXMP         ZFIELD
     C                   Z-ADD     5             ZADIG
     C                   Z-ADD     2             ZADEC
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   MOVE      ZFIELD        @FXMP
 
     C     ZALIGNok      IFEQ      'N'
      * Send error to screen
     C                   Move      'N'           OKFXMP
     C                   Add       1             Idx
     C                   Movel     'SFXMP'       FldNamXAr(Idx)
     C                   Movel     'AAM0009'     MsgIdXAr(Idx)
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C**  If FX Margin points is valid, check if equivalent exchange
     C**  rate is within the defined tolerance.
     C*
     C     OKFXMP        IFNE      'N'
     C     DeftsUsed     ANDEQ     'N'
     C*
     C**  If the entered margin points is greater than the maximum
     C**  allowed, display warning message "Warning - Effective deal
     C**  funding rate must be within tolerance level defined."
     C*
     C     @FXMP         IFGT      WMAXPT
     C                   Move      'W'           OKFXMP
     C                   Add       1             WIx
     C                   Movel     'SFXMP'       WFldNmXAr(WIx)
     C                   Movel     'AAM0014'     WMsgIdXAr(WIx)
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C                   ENDSR
     C*
     C************************************************************
     C* END OF MARGIN POINTS VALIDATION
     C************************************************************
     C/EJECT
     C****************************************************************
     C* VMGNPSI -  VALIDATION OF MARGIN P/S INDICATOR                *
     C****************************************************************
     C*
     C     VMGNPSI       BEGSR
 
     C**  Validate Margin P/S Indicator.
     C**       If the Margin P/S Indicator is not entered, default it.
     C*
     C     SMBSI         IFEQ      *BLANKS
     C                   EXSR      DFTPSI
     C                   MOVEL     PMBSD         SMBSI
     C                   ELSE
     C*
     C**  If the Margin P/S Indicator is not 'P' nor 'S', display error
     C**  message "Margin P/S Indicator should be 'P' or 'S'".
     C*
     C     SMBSI         IFNE      'P'
     C     SMBSI         ANDNE     'S'
     C                   Move      'N'           OKMBSI
     C                   Add       1             Idx
     C                   Movel     'SMBSI'       FldNamXAr(Idx)
     C                   Movel     'AAM0013'     MsgIdXAr(Idx)
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C                   ENDSR
     C*
     C************************************************************
     C* END OF MARGIN PLI VALIDATION
     C************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  SRCURR                                        *
     C*  Function    :  Get Settlement and Pay Currencies Details     *
     C*                                                               *
     C*  Called by   :  SETUPDFTS                                     *
     C*  Calls       :  AOCURRR0 - Currency Details Access Program    *
     C*                                                               *
     C*****************************************************************
     C*
     C     SRCURR        BEGSR                                                  ** SRCURR **
     C*
     C**  Get Settlement Currency Details.
     C*
     C                   MOVE      SSMCY         WCURR
     C                   CALL      'AOCURRR0'    PCURR
     C                   Z-ADD     A6NBDP        ZNBDP1            1 0
     C                   Z-ADD     A6NQDP        ZNQDP1            1 0
     C                   Z-ADD     A6SPRT        ZRATE1           13 8
     C                   MOVE      A6MDIN        ZMDI1             1
     C*
     C**  Get Pay Currency Details.
     C*
     C                   MOVE      SPCCY         WCURR
     C                   CALL      'AOCURRR0'    PCURR
     C                   Z-ADD     A6NBDP        ZNBDP2            1 0
     C                   Z-ADD     A6NQDP        ZNQDP2            1 0
     C                   Z-ADD     A6SPRT        ZRATE2           13 8
     C                   MOVE      A6MDIN        ZMDI2             1
     C*
     C     SRCUR9        ENDSR                                                  ** SRCUR9 **
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  SRMOVF                                        *
     C*  Function    :  Calculate Pay/Settle amounts                  *
     C*                                                               *
     C*  Called by   :  SETUPDFTS                                     *
     C*  Calls       :  ZEDIT  - Format a Numeric Field               *
     C*                                                               *
     C*****************************************************************
     C*
     C     SRMOVF        BEGSR                                                  ** SRMOVF **
     C*
     C     ZNBDP1        ADD       1             ZB
     C     @SMAM         DIV       AP(ZB)        WWSMAM           16 3
     C     ZNBDP2        ADD       1             ZB
     C     @PYAM         DIV       AP(ZB)        WWPYAM           16 3
     C*
     C     SRMOV9        ENDSR                                                  ** SRMOV9 **
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  SRDRAT                                        *
     C*  Function    :  Get Default Cross-Currency Rate               *
     C*                                                               *
     C*  Called by   :  SETUPDFTS                                     *
     C*  Calls       :  ZXRATE - Obtain Cross-Exchange Rate between   *
     C*                          2 Currencies                         *
     C*                                                               *
     C*****************************************************************
     C*
     C     SRDRAT        BEGSR                                                  ** SRDRAT **
     C*
     C**  Obtain cross-exchange rate between settlement and pay ccys.
     C*
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1           13 8
     C                   PARM                    ZMDI1             1
     C                   PARM                    ZRATE2           13 8
     C                   PARM                    ZMDI2             1
     C                   PARM                    ZRATEX           13 8
     C                   PARM                    ZMDIX             1
 
     C     @RATE         IFGT      1
     C     ZRATEX        ANDLT     1
     C     @RATE         ORLT      1
     C     ZRATEX        ANDGT     1
     C     1             DIV(H)    ZRATEX        ZRATEX
     C                   ENDIF
     C*
     C     SRDRA9        ENDSR                                                  ** SRDRA9 **
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  SRNQDP                                        *
     C*  Function    :  Get Normally-Quoted Decimal Places            *
     C*                                                               *
     C*  Called by   :  SETUPDFTS                                     *
     C*  Calls       :  -                                             *
     C*                                                               *
     C*****************************************************************
     C*
     C     SRNQDP        BEGSR                                                  ** SRNQDP **
     C*
     C** --------------------------------------------------------------
     C**  If either the settlement or pay currency is the base currency
     C**  obtain the number of normally-quoted decimal places for the
     C**  other currency. Otherwise:
     C**      A)  If ZNQDP1 =  ZNQDP2 =  5       :   ZNQDPX = 5
     C**      B)  If ZNQDP1 =  ZNQDP2 <> 5  or
     C**             ZNQDP1 <> ZNQDP2
     C**             1)  If Rate >= 100          :   ZNQDPX = 2
     C**             2)  If 100 > Rate >= 20     :   ZNQDPX = 3
     C**             3)  If 20  > Rate >= 1      :   ZNQDPX = 4
     C**             4)  If 1   > Rate           :   ZNQDPX = 5
     C**---------------------------------------------------------------
     C*
     C                   SELECT
     C*
     C     SSMCY         WHENEQ    BNCYDL
     C                   Z-ADD     ZNQDP2        ZNQDPX            1 0
     C*
     C     SPCCY         WHENEQ    BNCYDL
     C                   Z-ADD     ZNQDP1        ZNQDPX
     C*
     C     ZNQDP1        WHENEQ    ZNQDP2
     C     ZNQDP1        ANDEQ     5
     C                   Z-ADD     5             ZNQDPX
     C*
     C     @RATE         WHENEQ    100
     C                   Z-ADD     2             ZNQDPX
     C*
     C     @RATE         WHENLT    100
     C     @RATE         ANDGE     20
     C                   Z-ADD     3             ZNQDPX
     C*
     C     @RATE         WHENLT    20
     C     @RATE         ANDGE     1
     C                   Z-ADD     4             ZNQDPX
     C*
     C     @RATE         WHENLT    1
     C                   Z-ADD     5             ZNQDPX
     C*
     C                   ENDSL
     C*
     C     SRNQD9        ENDSR                                                  ** SRNQD9 **
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  SRMAMT                                        *
     C*  Function    :  Calculate Margin Amount                       *
     C*                                                               *
     C*  Called by   :  VMGNPTS- Validate Margin Points               *
     C*  Calls       :  SRCURR - Get ccy details                      *
     C*              :  SRMOVF - Calculate Pay/Settle amounts         *
     C*                                                               *
     C*****************************************************************
     C*
     C     SRMAMT        BEGSR                                                  ** SRMAMT **
     C*
     C     @FXMP         DIV(H)    AP(ZA)        WFXMR            13 8
     C*
     C** Set up factoring to adjust for decimal places.
     C*
     C     SMBSI         IFEQ      'P'
     C     ZNBDP1        SUB       ZNBDP2        ZNBDPX            1 0
     C                   ELSE
     C     ZNBDP2        SUB       ZNBDP1        ZNBDPX
     C                   ENDIF
     C*
     C     ZNBDPX        IFGE      0
     C     ZNBDPX        ADD       1             ZB                1 0
     C     1             MULT      AP(ZB)        ZFACTR            7 3
     C                   ELSE
     C                   Z-SUB     ZNBDPX        ZNBDPX
     C     ZNBDPX        ADD       1             ZB
     C     1             DIV       AP(ZB)        ZFACTR
     C                   ENDIF
     C*
     C*
     C** If the Margin P/S Indicator is 'P'...
     C**    If the Purchase amount is greater than the sale amount and
     C**            the exchage rate is greater than 1  OR
     C**    If the Purchase amount is less than the sale amount and
     C**            the exchage rate is less than 1  THEN
     C**    the Margin amount is calculated as:
     C**
     C**       IMAR (Margin Amt) = SAMT (Sale amt) x MRAT (Margin rate)
     C**
     C**    ELSE the Margin amount is calculated as:
     C**    If a profit (margin sign is '+') :
     C**                            SAMT (Sale Amt)
     C**       IMAR (Margin Amt) = ----------------- - PAMT (Purch Amt)
     C**                              XRAT - MRAT
     C**    If a loss (margin sign is '-') :
     C**                                               SAMT (Sale Amt)
     C**       IMAR (Margin Amt) = PAMT (Purch Amt) - -----------------
     C**                                                 XRAT + MRAT
     C*
     C     SMBSI         IFEQ      'P'
     C*
     C     WWPYAM        IFGT      WWSMAM
     C     @RATE         ANDGT     1
     C     WWPYAM        ORLT      WWSMAM
     C     @RATE         ANDLT     1
     C*
     C     @SMAM         MULT(H)   WFXMR         WMAMT            16 3
     C                   DIV(H)    ZFACTR        WMAMT
     C*
     C                   ELSE
     C*
     C     SMSIG         IFEQ      '+'
     C     @RATE         SUB       WFXMR         WRATE            13 8
     C                   ELSE
     C     @RATE         ADD       WFXMR         WRATE
     C                   ENDIF
     C*
     C     @SMAM         DIV(H)    WRATE         WCPYAM           16 3
     C                   DIV(H)    ZFACTR        WCPYAM
     C*
     C     SMSIG         IFEQ      '+'
     C     WCPYAM        SUB       @PYAM         WMAMT
     C                   ELSE
     C     @PYAM         SUB       WCPYAM        WMAMT
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C** If the Margin P/S Indicator is 'S'...
     C**    If the Sale amount is greater than the purchase amount and
     C**            the exchage rate is greater than 1  OR
     C**    If the Sale amount is less than the purchase amount and
     C**            the exchage rate is less than 1  THEN
     C**    the Margin amount is calculated as:
     C**
     C**       IMAR (Margin Amt) = PAMT (Purc amt) x MRAT (Margin rate)
     C**
     C**    ELSE the Margin amount is calculated as:
     C**    If a profit (margin sign is '+') :
     C**                                              PAMT (Purch Amt)
     C**       IMAR (Margin Amt) = SAMT (Sale Amt) - ------------------
     C**                                                XRAT + MRAT
     C**    If a loss (margin sign is '-') :
     C**                            PAMT (Purch Amt)
     C**       IMAR (Margin Amt) = ------------------ - SAMT (Sale Amt)
     C**                               XRAT - MRAT
     C*
     C     SMBSI         IFEQ      'S'
     C*
     C     WWSMAM        IFGT      WWPYAM
     C     @RATE         ANDGT     1
     C     WWSMAM        ORLT      WWPYAM
     C     @RATE         ANDLT     1
     C*
     C     @PYAM         MULT(H)   WFXMR         WMAMT
     C                   DIV(H)    ZFACTR        WMAMT
     C*
     C                   ELSE
     C*
     C     SMSIG         IFEQ      '+'
     C     @RATE         ADD       WFXMR         WRATE
     C                   ELSE
     C     @RATE         SUB       WFXMR         WRATE
     C                   ENDIF
     C*
     C     @PYAM         DIV(H)    WRATE         WCSMAM           16 3
     C                   DIV(H)    ZFACTR        WCSMAM
     C*
     C     SMSIG         IFEQ      '+'
     C     @SMAM         SUB       WCSMAM        WMAMT
     C                   ELSE
     C     WCSMAM        SUB       @SMAM         WMAMT
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C     SRMAM9        ENDSR                                                  ** SRMAM9 **
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  DFTPSI                                        *
     C*  Function    :  Default indicator if blank                    *
     C*                                                               *
     C*  Called by   :  VMGNPSI                                       *
     C*  Calls       :  ZEDIT  - Format a Numeric Field               *
     C*                                                               *
     C*****************************************************************
     C*
     C     DFTPSI        BEGSR                                                  ** SRMOVF **
     C*
     C**  Margin P/S Indicator.
     C*
     C     ZNBDP1        ADD       1             ZB                1 0
     C     @SMAM         DIV       AP(ZB)        WWSMAM           16 3
     C     ZNBDP2        ADD       1             ZB
     C     @PYAM         DIV       AP(ZB)        WWPYAM           16 3
     C*
     C     WWSMAM        IFGE      WWPYAM
     C                   MOVE      'S'           PMBSD             1
     C                   ELSE
     C                   MOVE      'P'           PMBSD             1
     C                   ENDIF
     C*
     C     DFTPSI9       ENDSR                                                  ** SRMOV9 **
     C*
     C*****************************************************************
     C/EJECT
      *****************************************************************
      * FMTAMT - FORMAT AMOUNT FOR DISPLAY                            *
      *****************************************************************
     C     FMTAMT        BEGSR
      *
     C                   CALLB     'ZA0920'
     C                   PARM      *BLANK        @@RETC           10
     C                   PARM                    @@AMTW           13 0
     C                   PARM                    @@QECN            1 0
     C                   PARM      '.'           BNDCSP            1
     C                   PARM      *BLANK        @@AMTD           14
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
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
     C***********        Parm                    TranInThir                     CFT014
     C                   Parm                    TranInFift                     CFT014
 
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
 
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtaXAr
 
      * OK Flags
     C                   Parm                    OKFlagsDS
 
      *  Validation Work Fields
     C                   Parm                    Val@Fields
 
      ** Access MIDAS Modules details via access program                                      202895
      *  (database error handling done in access program)                                     202895
     C                   CALLB     'AOMMODR0'                                                 202895
     C                   PARM      '*DBERR '     WRTCD             7                          202895
     C                   PARM      '*FIRST '     WOPTN             7                          202895
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        202895
      *                                                                                       202895
     C**  Parameter list for program 'AOBANKR0'.
     C*
     C     PBANK         PLIST
     C                   PARM      '*DBERR  '    WRTCD             7
     C                   PARM      '*FIRST  '    WOPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C*
     C**  Parameter list for program 'AOCURRR0'.
     C*
     C     PCURR         PLIST
     C                   PARM      '*DBERR '     WRTCD             7
     C                   PARM      '*KEY   '     WOPTN             7
     C                   PARM                    WCURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C*
     C**  Parameter list for program 'AODEALR0'.
     C*
     C     PDEAL         PLIST
     C                   PARM      '*DBERR  '    WRTCD
     C                   PARM      '*FIRST  '    WOPTN
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
     C*
     C**  Parameter list for program 'AOPCACR0'.
     C*
     C     PPCAC         PLIST
     C                   PARM      '*DBERR '     WRTCD
     C                   PARM      '*FIRST '     WOPTN
     C     SDPCAC        PARM      SDPCAC        DSFDY
     C*
     C**  Access Bank Details File.
     C*
     C                   CALL      'AOBANKR0'    PBANK
     C*
     C**  Access Dealing ICD Details File.
     C*
     C**********         CALL      'AODEALR0'    PDEAL                                        CGL029
     C                   CALL      'AODEALR1'    PDEAL                                        CGL029
     C*
     C**  Access Profit Centre Accounting details.
     C*
     C     BGN0ST        IFEQ      'Y'                                                        202895
     C                   CALL      'AOPCACR0'    PPCAC
     C                   END                                                                  202895
     C*
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
**  AP
0000000001
0000000010
0000000100
0000001000
0000010000
0000100000
0001000000
0010000000
0100000000
1000000000
