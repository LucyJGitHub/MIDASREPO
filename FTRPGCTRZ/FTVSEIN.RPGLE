     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate settle plus charges indicator')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVSEIN  - Validate Settle Plus Charges Indicator            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD024335           Date 19Aug14               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 06Jul06               *
      *                 CGL014             Date 20Oct03               *
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
      *                                                               *
      *---------------------------------------------------------------*
      *  MD046248 - Finastra Rebranding                               *
      *  MD024335 - FT IN/OP Charges Ind Defaulting                   *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompile)    *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CGL014 - Collaterals Processing (Recompile)                  *
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
 
      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
 
      * Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY1PD)
 
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
      * Funds Transfer Details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * Bank ICD Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      *                                                                                       CFT120
      ** Switchable Features File                                                             CFT120
      *                                                                                       CFT120
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFT120
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
      *                                                                                       CFT120
      ** Variable for switchable feature CFT120                                               CFT120
      *                                                                                       CFT120
     D CFT120          S              1A                                                      CFT120
                                                                                            MD024335
      ** Add-Deduct Indicator                                                               MD024335
     D DftADInd        S              1A   INZ                                              MD024335
                                                                                            MD024335
      ** Parameters for AOSVALR0                                                            MD024335
     D PRetCode        S              7A   INZ                                              MD024335
     D POPT            S             20A   INZ DIM( 10 )                                    MD024335
     D PVAL            S            200A   INZ DIM( 10 )                                    MD024335
                                                                                            MD024335
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
     C                   Eval      Idx = 0
 
      * Validate Settle Plus Charges indicator
     C                   EXSR      VPPLCHG
      *
      ** If an error was found, set the return code appropriately
      *
     C                   If        OKAddc = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   End
 
      * RETURN
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VPPLCHG - SETTLE PLUS CHARGES INDICATOR
      *****************************************************************
     C*
     C     VPPLCHG       BEGSR
 
     C*
     C                   If        SADDC = *Blanks
     C**********         Eval      SADDC = 'A'                                              MD024335
     C**********         End                                                                MD024335
     C                   EVAL      SADDC = DftADInd                                         MD024335
     C                   ENDIF                                                              MD024335
 
     C                   If        SADDC <> 'D' and
     C                             SADDC <> 'A'
      * Send error to screen
     C                   Move      'N'           OKAddc
     C                   Add       1             Idx
     C                   Movel     'SADDC'       FldNamXAr(Idx)
     C                   Movel     'MMA0980'     MsgIdXAr(Idx)
     C                   End
 
      * If ADDC valid set up Charge Currency work field.
     C     OkAddc        IFEQ      'Y'
 
      *                                                                                       CFT120
      ** If action code is amend, CFT009 if off and the "Charges to                           CFT120
      ** the Debit of A/C" field is not blank, charge currency for                            CFT120
      ** display should be the base currency or charges to the debit of currency              CFT120
      ** (Apply fix CFT120 and MFT001)                                                        CFT120
      *                                                                                       CFT120
     C                   IF        @CDRO <> *Blanks AND CFT120 = 'Y'                          CFT120
     C                   IF        @CDRC = *Blanks                                            CFT120
     C                   EVAL      @CCCY = BJCYCD                                             CFT120
     C                   ELSE                                                                 CFT120
     C                   EVAL      @CCCY = @CDRC                                              CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C                   ELSE                                                                 CFT120
      *                                                                                       CFT120
     C     BTCHCY        IFEQ      'C'
 
     C     SADDC         IFEQ      'A'
     C                   MOVEL     SSMCY         @CCCY
     C                   ELSE
     C                   MOVEL     SPCCY         @CCCY
     C                   END
     C*
     C                   ELSE
     C*
     C     BTCHCY        IFEQ      'L'
     C                   MOVE      BJLCCY        @CCCY
     C                   ELSE
     C                   IF        BTCHCY = 'F'                                 CFT009
     C                   EVAL      @CCCY = FCHCCY                               CFT009
     C                   ELSE                                                   CFT009
     C                   MOVE      BJCYCD        @CCCY
     C                   ENDIF                                                  CFT009
     C                   END
     C*
     C                   END
      *                                                                                       CFT120
     C                   ENDIF                                                                CFT120
     C*
     C                   END
 
     C                   ENDSR
      *****************************************************************
      * VOVRRDE - END OF OVERRIDE FLAG VALIDATION                     *
      *****************************************************************
      /EJECT
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
 
      *  Bank ICD Details
     C                   Parm                    SDBANK
 
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
 
      ** OK Flags
     C                   Parm                    OKFlagsDS
 
      *  Validation Work Fields
     C                   Parm                    Val@Fields
 
      *  Funds transfer Details
     C                   Parm                    SDFTFR
 
     C** Read SDFTFRPD
     C*
     C                   CALL      'AOFTFRR0'
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDFTFR        PARM      SDFTFR        DSFDY
      *                                                                                       CFT120
      ** Access SAR details file to determine if CFT120 enhancement is                        CFT120
      ** switched on.                                                                         CFT120
      *                                                                                       CFT120
     C                   CALL      'AOSARDR0'                                                 CFT120
     C                   PARM      '*BLANKS'     @RTCD                                        CFT120
     C                   PARM      '*VERIFY'     @OPTN                                        CFT120
     C                   PARM      'CFT120'      @SARD                                        CFT120
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT120
      *                                                                                       CFT120
     C                   IF        (@RTCD <> *Blanks) And (@RTCD <> '*NRF   ')                CFT120
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT120
     C                   EVAL      DBASE = 1                                                  CFT120
     C                   EVAL      DBKEY = 'CFT120'                                           CFT120
     C                   EXSR      *PSSR                                                      CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C                   IF        @RTCD = *BLANKS                                            CFT120
     C                   EVAL      CFT120 = 'Y'                                               CFT120
     C                   ELSE                                                                 CFT120
     C                   EVAL      CFT120 = 'N'                                               CFT120
     C                   ENDIF                                                                CFT120
                                                                                            MD024335
      ** Get Default for Charges Indicator                                                  MD024335
                                                                                            MD024335
     C                   EVAL      POPT( 1 ) = 'DefaultChargesInd'                          MD024335
                                                                                            MD024335
     C                   CALL      'AOSVALR0'                                               MD024335
     C                   PARM      *BLANKS       PRetCode                                   MD024335
     C                   PARM                    POPT( 1 )                                  MD024335
     C                   PARM      *BLANKS       PVAL( 1 )                                  MD024335
     C                   PARM      *BLANKS       POPT( 2 )                                  MD024335
     C                   PARM      *BLANKS       PVAL( 2 )                                  MD024335
     C                   PARM      *BLANKS       POPT( 3 )                                  MD024335
     C                   PARM      *BLANKS       PVAL( 3 )                                  MD024335
     C                   PARM      *BLANKS       POPT( 4 )                                  MD024335
     C                   PARM      *BLANKS       PVAL( 4 )                                  MD024335
     C                   PARM      *BLANKS       POPT( 5 )                                  MD024335
     C                   PARM      *BLANKS       PVAL( 5 )                                  MD024335
     C                   PARM      *BLANKS       POPT( 6 )                                  MD024335
     C                   PARM      *BLANKS       PVAL( 6 )                                  MD024335
     C                   PARM      *BLANKS       POPT( 7 )                                  MD024335
     C                   PARM      *BLANKS       PVAL( 7 )                                  MD024335
     C                   PARM      *BLANKS       POPT( 8 )                                  MD024335
     C                   PARM      *BLANKS       PVAL( 8 )                                  MD024335
     C                   PARM      *BLANKS       POPT( 9 )                                  MD024335
     C                   PARM      *BLANKS       PVAL( 9 )                                  MD024335
     C                   PARM      *BLANKS       POPT( 10 )                                 MD024335
     C                   PARM      *BLANKS       PVAL( 10 )                                 MD024335
                                                                                            MD024335
     C                   IF        PRetCode  <> *BLANKS                                     MD024335
     C                   EVAL      DBFile = 'SDSVALPD'                                      MD024335
     C                   EVAL      DBKEy = POPT( 1 )                                        MD024335
     C                   EVAL      DBase = 2                                                MD024335
     C                   EXSR      *PSSR                                                    MD024335
     C                   ENDIF                                                              MD024335
                                                                                            MD024335
     C                   EVAL      DftADInd = PVAL( 1 )                                     MD024335
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
(c) Finastra International Limited 2001
