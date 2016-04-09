     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing payments amend checking')            *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTOPAYAMD - Outgoing Payments Amend Checking                 *
      *                                                               *
      *  Function:  This module compares the fields of an             *
      *             amended payment against those currently on file.  *
      *             It checks whether all fields amended are          *
      *             amendable, and if not returns error messages to   *
      *             the calling process.                              *
      *             If can optionally reset fields wrongly amended.   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CFT157             Date 29Aug14               *
      *  Prev Amend No. AR402776           Date 20Dec12               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24776           Date 09Jul09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      *                 245881             Date 17Apr07               *
      *                 BUG12862R          Date 20Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CDL049             Date 06Jul06               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 01Aug03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 15Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 22May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 23Aug99               *
      *                 CAP031  *CREATE    Date 20Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *           (Recompile)                                         *
      *  AR402776 - Settlement method is not amendable.  Ensure that  *
      *             the settlement type is amendable as long as it    *
      *             has not been authorized yet.                      *
      *             (Child: AR402906)                                 *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  BUG24776 - Settlement type may not be amended                *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate.(Recompiled)    *
      *  245881 - Apply fix BUG12862R.                                *
      *  BUG12862R - BUG12862 reopened. Could not complete the out    *
      *              going payments generated by the incoming payments*
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CAP084 - MidasPlus Changes                                   *
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  175479 - FONTIS : dealer's reference field                   *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
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
 
      * New Payment in Screen Format
     D NewPmtScn1    E DS                  EXTNAME(FTOPY1PD)
     D NewPmtScn2    E DS                  EXTNAME(FTOPY2PD)
     D NewPmtScn3    E DS                  EXTNAME(FTOPY3PD)
     D NewPmtScn4    E DS                  EXTNAME(FTOPY4PD)
     D NewPmtSc1b    E DS                  EXTNAME(FTOPY1APD)                   CFT014
     D NewPmtScn5    E DS                  EXTNAME(FTOPY5PD)                    CFT014
     D NewPmtScn6    E DS                  EXTNAME(FTOPY6PD)                    CFT014
     D NewPmtScn7    E DS                  EXTNAME(FTOPY7PD)                    CFT014
 
      * (Current) Payment in Screen Format
     D PmtScnFmt1    E DS                  EXTNAME(FTOPY1PD)
     D                                     PREFIX(@)
     D PmtScnFmt2    E DS                  EXTNAME(FTOPY2PD)
     D                                     PREFIX(@)
     D PmtScnFmt3    E DS                  EXTNAME(FTOPY3PD)
     D                                     PREFIX(@)
     D PmtScnFmt4    E DS                  EXTNAME(FTOPY4PD)
     D                                     PREFIX(@)
     D PmtScnFm1b    E DS                  EXTNAME(FTOPY1APD)                   CFT014
     D                                     PREFIX(@)                            CFT014
     D PmtScnFmt5    E DS                  EXTNAME(FTOPY5PD)                    CFT014
     D                                     PREFIX(@)                            CFT014
     D PmtScnFmt6    E DS                  EXTNAME(FTOPY6PD)                    CFT014
     D                                     PREFIX(@)                            CFT014
     D PmtScnFmt7    E DS                  EXTNAME(FTOPY7PD)                    CFT014
     D                                     PREFIX(@)                            CFT014
 
      * (Current) Payment in File Format
     D PmntFilFmt    E DS                  EXTNAME(OTPAYDD)
     D PmntFilFmX    E DS                  EXTNAME(OTPAYXPD)                    CFT014
                                                                                CFT014
      ** Flags to indicate whether transaction fields are valid                 CFT014
     D OKFlag1DS     E DS                  EXTNAME(FTEOPY1PD)                   CFT014
     D OKFlag2DS     E DS                  EXTNAME(FTEOPY2PD)                   CFT014
     D OKFlag3DS     E DS                  EXTNAME(FTEOPY3PD)                   CFT014
     D OKFlag4DS     E DS                  EXTNAME(FTEOPY4PD)                   CFT014
     D OKFlag5DS     E DS                  EXTNAME(FTEOPY5PD)                   CFT014
 
     D RUNDAT          DS
     D  @MBIN                 13     13
 
     D                 DS
      **  Data structure for date in, to change format.
     D  DateIn                 1      8  0
     D  @@YY                   1      4  0
     D  @@MM                   5      6  0
     D  @@DD                   7      8  0
      **
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ***Flags*to*indicate*whether*transaction*fields*are*valid********         CFT014
     D*OKFlag1DS*      DS                                                       CFT014
      ***Screen*1*flags************************************************         CFT014
     D**SActionOK                     1A                                        CFT014
     D**SPrefOK**                     1A                                        CFT014
     D**SBrCAOK**                     1A                                        CFT014
     D**SOrBrOK**                     1A                                        CFT014
     D**SPyTpOK**                     1A                                        CFT014
     D**SPySTOK**                     1A                                        CFT014
     D**SStTpOK**                     1A                                        CFT014
     D**SSwPCOK**                     1A                                        CFT014
     D**SDst1OK**                     1A                                        CFT014
     D**SDst2OK**                     1A                                        CFT014
     D**SDst3OK**                     1A                                        CFT014
     D**SDst4OK**                     1A                                        CFT014
     D**SOdMTOK**                     1A                                        CFT014
     D**SOrC1OK**                     1A                                        CFT014
     D**SOrC2OK**                     1A                                        CFT014
     D**SOrC3OK**                     1A                                        CFT014
     D**SOrC4OK**                     1A                                        CFT014
     D**SOrBkOK**                     1A                                        CFT014
     D**SOrBBOK**                     1A                                        CFT014
     D**SSnCoOK**                     1A                                        CFT014
     D**SSnMTOK**                     1A                                        CFT014
     D**SNDCyOK**                     1A                                        CFT014
     D**SNDAmOK**                     1A                                        CFT014
     D**SSmCyOK**                     1A                                        CFT014
     D**SSmAmOK**                     1A                                        CFT014
     D**SPyDtOK**                     1A                                        CFT014
     D**SPCcyOK**                     1A                                        CFT014
     D**SPyAmOK**                     1A                                        CFT014
     D**SPyVDOK**                     1A                                        CFT014
     D**SPDCyOK**                     1A                                        CFT014
     D**SPDAmOK**                     1A                                        CFT014
     D**SRateOK**                     1A                                        CFT014
     D**SOvrdOK**                     1A                                        CFT014
     D**SAdDcOK**                     1A                                        CFT014
     D**SBokCOK**                     1A                                        CFT014
     D**SPrfCOK**                     1A                                        CFT014
     D**SRPayOK**                     1A                                        CFT014
     D**SPayFOK**                     1A                                        CFT014
     D**SDyiMOK**                     1A                                        CFT014
     D**SNDatOK**                     1A                                        CFT014
     D**SFinDOK**                     1A                                        CFT014
      ***********                                                               CFT014
     D*OKFlag2DS*      DS                                                       CFT014
      ***Screen*2*flags************************************************         CFT014
     D**SActn2OK*                     1A                                        CFT014
     D**SPref2OK*                     1A                                        CFT014
     D**STrCTOK**                     1A                                        CFT014
     D**SCDrOOK**                     1A                                        CFT014
     D**SCDBrOK**                     1A                                        CFT014
     D**SRCo1OK**                     1A                                        CFT014
     D**SRCo2OK**                     1A                                        CFT014
     D**SRCo3OK**                     1A                                        CFT014
     D**SRCo4OK**                     1A                                        CFT014
     D**SRCo5OK**                     1A                                        CFT014
     D**SAcB1OK**                     1A                                        CFT014
     D**SAcB2OK**                     1A                                        CFT014
     D**SAcB3OK**                     1A                                        CFT014
     D**SAcB4OK**                     1A                                        CFT014
     D**SAcB5OK**                     1A                                        CFT014
     D**SBnC1OK**                     1A                                        CFT014
     D**SBnC2OK**                     1A                                        CFT014
     D**SBnC3OK**                     1A                                        CFT014
     D**SBnC4OK**                     1A                                        CFT014
     D**SBnC5OK**                     1A                                        CFT014
     D**SDtP1OK**                     1A                                        CFT014
     D**SDtP2OK**                     1A                                        CFT014
     D**SDtP3OK**                     1A                                        CFT014
     D**SDtP4OK**                     1A                                        CFT014
     D**SBBI1OK**                     1A                                        CFT014
     D**SBBI2OK**                     1A                                        CFT014
     D**SBBI3OK**                     1A                                        CFT014
     D**SBBI4OK**                     1A                                        CFT014
     D**SBBI5OK**                     1A                                        CFT014
     D**SBBI6OK**                     1A                                        CFT014
      ***********                                                               CFT014
     D*OKFlag3DS*      DS                                                       CFT014
      ***Screen*3*flags************************************************         CFT014
     D**SActn3OK*                     1A                                        CFT014
     D**SPref3OK*                     1A                                        CFT014
     D**SInB1OK**                     1A                                        CFT014
     D**SInB2OK**                     1A                                        CFT014
     D**SInB3OK**                     1A                                        CFT014
     D**SInB4OK**                     1A                                        CFT014
     D**SInB5OK**                     1A                                        CFT014
     D**SDnbcOK**                     1A                                        CFT014
     D**SDtChOK**                     1A                                        CFT014
     D**STrCdOK**                     1A                                        CFT014
     D**SVAT1OK**                     1A                                        CFT014
     D**SChCdOK**                     1A                                        CFT014
     D**SVAT7OK**                     1A                                        CFT014
     D**STxCdOK**                     1A                                        CFT014
     D**SVAT2OK**                     1A                                        CFT014
     D**SCqCdOK**                     1A                                        CFT014
     D**SVAT3OK**                     1A                                        CFT014
     D**SCstdOK**                     1A                                        CFT014
     D**SVAT4OK**                     1A                                        CFT014
     D**SSpCdOK**                     1A                                        CFT014
     D**SVAT5OK**                     1A                                        CFT014
     D**SMsCdOK**                     1A                                        CFT014
     D**SVAT6OK**                     1A                                        CFT014
     D**SRlPROK**                     1A                                        CFT014
     D**SCHAPOK**                     1A                                        CFT014
     D**SFXMPOK**                     1A                                        CFT014
     D**SMBSIOK**                     1A                                        CFT014
     D**SMSIGOK**                     1A                                        CFT014
      ***Flag(s)*to*indicate*if*combinations*of*transaction*fields*are*valid    CFT014
     D**DDDltStpOK                    1A                                        CFT014
 
      ** Date out
     D DateOut         S              6P 0
 
      ** Transaction Date in Midas Dayno. format
     D TransDate       S              5P 0
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
      *
      **  Compare fields with amended values.
      *
     C                   EXSR      COMPFLDS
      *
      *  If any errors were found:
      *    Set Amendments OK Indicator to 'N'
      *
     C     Idx           IFGT      0
     C                   EVAL      AmendOK = 'N'
     C                   ELSE
     C                   EVAL      AmendOK = 'Y'
     C                   ENDIF
      *
      *  If any errors were found:
      *  - and reset of fields in error required, do this
      *
     C     Idx           IFGT      0
     C     ResetErrs     ANDEQ     'Y'
     C                   EXSR      RESETFLDS
     C                   ENDIF
      *
      * Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * COMPFLDS  - Compare certain fields on the current deal        *
      *             with those amended.                               *
      *****************************************************************
     C     COMPFLDS      BEGSR
     C*
     C*-----------------------------------------*
     C* Booking Branch Code                     *
     C*-----------------------------------------*
     C** This field is NOT AMENDABLE.
     C*
     C     SBRCA         IFNE      @SBRCA
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SBRCA'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0063'
     C***********        EVAL      sBRCAok         = 'N'                        CFT014
     C                   EVAL      OKBRCA          = 'N'                        CFT014
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Payment Type                            *
     C*-----------------------------------------*
     C** This field is NOT AMENDABLE.
     C*
     C     SPYTP         IFNE      @SPYTP
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SPYTP'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0570'
     C***********        EVAL      sPYTPok         = 'N'                        CFT014
     C                   EVAL      OKPYTP          = 'N'                        CFT014
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Settlement Type                         *
     C*-----------------------------------------*
     C** This field is NOT AMENDABLE.
     C*
      ** Should be amendable when the level 1 indicator is 'N' (not yet complete)           BUG12862
      *
     C     SSTTP         IFNE      @SSTTP
     C*****LVL1*         ANDEQ     'Y'                                             BUG12862 AR402776
     C*****@SSTTP        ANDEQ     '0'                                             BUG24776 AR402776
     C*****OPIN*         ANDNE     'Y'                                             BUG24776 AR402776
     C     AUIN          ANDEQ     'Y'                                                      AR402776
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SSTTP'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0571'
     C***********        EVAL      sSTTPok         = 'N'                        CFT014
     C                   EVAL      OKSTTP          = 'N'                        CFT014
     C                   ENDIF
     C*****SSTTP         IFNE      @SSTTP                                          BUG24776 AR402776
     C*****@SSTTP        ANDEQ     '0'                                             BUG24776 AR402776
     C*****OPIN*         ANDEQ     'Y'                                             BUG24776 AR402776
     C**********         MOVE      SSTTP         SPREF                             BUG24776 AR402776
     C**********         ENDIF                                                     BUG24776 AR402776
     C*
     C*-----------------------------------------*
     C* Profit Centre                           *
     C*-----------------------------------------*
     C** Only validate this field if Profit Centre ICD flag on.
     C*
     C     BKPRCU        IFEQ      'Y'
     C*
     C** This field is not amendable unless 'Profit Centre Amendable'
     C** ICD flag is on.
     C*
     C     SPRFC         IFNE      @SPRFC
     C     BKPRCA        ANDNE     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SPRFC'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM4002'
     C***********        EVAL      sPRFCok         = 'N'                        CFT014
     C                   EVAL      OKPRFC          = 'N'                        CFT014
     C                   ENDIF
     C*
     C                   ENDIF
     C*
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETFLDS - Reset fields in Error                             *
      *****************************************************************
     C     RESETFLDS     BEGSR
      *
      * Reset fields in error to 'current' values
      *
     C* Payment Type                            *
     C*****sPYTPOK       IFEQ      'N'                                          CFT014
     C     OKPYTP        IFEQ      'N'                                          CFT014
     C                   MOVEL     @SPYTP        SPYTP
     C                   END
      *
      * Settlement Type
     C*****sSTTPOK       IFEQ      'N'                                          CFT014
     C     OKSTTP        IFEQ      'N'                                          CFT014
     C                   MOVEL     @SSTTP        SSTTP
     C                   END
      *
      * Branch Code
     C*****sBRCAOK       IFEQ      'N'                                          CFT014
     C     OKBRCA        IFEQ      'N'                                          CFT014
     C                   MOVEL     @SBRCA        SBRCA
     C                   END
      *
      * Profit Centre
     C*****sPRFCOK       IFEQ      'N'                                          CFT014
     C     OKPRFC        IFEQ      'N'                                          CFT014
     C                   MOVEL     @SPRFC        SPRFC
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * New Payment in Screen Format
     C                   PARM                    NewPmtScn1
     C                   PARM                    NewPmtScn2
     C                   PARM                    NewPmtScn3
     C                   PARM                    NewPmtScn4
     C                   PARM                    NewPmtSc1b                     CFT014
     C                   PARM                    NewPmtScn5                     CFT014
     C                   PARM                    NewPmtScn6                     CFT014
     C                   PARM                    NewPmtScn7                     CFT014
      *
      * Current Payment in Screen Format
     C                   PARM                    PmtScnFmt1
     C                   PARM                    PmtScnFmt2
     C                   PARM                    PmtScnFmt3
     C                   PARM                    PmtScnFmt4
     C                   PARM                    PmtScnFm1b                     CFT014
     C                   PARM                    PmtScnFmt5                     CFT014
     C                   PARM                    PmtScnFmt6                     CFT014
     C                   PARM                    PmtScnFmt7                     CFT014
      *
      * Current Payment in file format
     C                   PARM                    PmntFilFmt
     C                   PARM                    PmntFilFmX                     CFT014
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlag1DS
     C                   PARM                    OKFlag2DS
     C                   PARM                    OKFlag3DS
     C                   PARM                    OKFlag4DS                      CFT014
     C                   PARM                    OKFlag5DS                      CFT014
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Amendments OK
     C                   PARM                    AmendOk           1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM                    ResetErrs         1
      *
      ** Initialize program name
      *
     C                   MOVEL     'FTOPAYAMD'   DBPGM
 
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
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C**  GET RUNDAT to access MULTI-BRANCHING flag.
     C**
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
