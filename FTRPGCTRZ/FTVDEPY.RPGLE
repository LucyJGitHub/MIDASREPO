     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate details of payment')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVDEPY  - Validate Details of Payment                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR924563           Date 05Nov14               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      *                 CSD089             Date 07Oct10               *
      *                 BUG26775           Date 23Nov09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 257144             Date 10Oct08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      *                 255286             Date 07Jul08               *
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
      *                 CAP031  *CREATE    Date 12Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR924563 - '-' should not be present in 1st character of     *
      *             outgoing payments fields 50, 57D, 59, 70 and 72.  *
      *             (SFTADDRCLE changed). Also, Details of payment    *
      *             should be allowed for non SWIFT payments.         *
      *             (Child: AR924564)                                 *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CSD089 - Overrideable Errors Phase 2                         *
      *  BUG26775 - Generation of MT103                               *
      *  257144 - Include lower case in ISO validation.               *
      *           Use new /COPY member SFTVALCSLL.                    *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompile)    *
      *  255286 - Allow lowercase characters on input.                *
      *           Recompile due to change in /copy SFTVALCSLE         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CGL014 - Collaterals Processing (Recompile)                  *
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
 
     **COPY*FTCPYSRC,SFTVALCSLE                                                               257144
      /COPY FTCPYSRC,SFTVALCSLL                                                               257144
 
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
     D WMsgDtaXAr      S                   DIM(XArrayMax) LIKE(#MsgData)                      CSD089
 
      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
     D*TranInSecB****E*DS***               EXTNAME(FTOPY3PD)                    CFT014
     D TranInPrmB    E DS                  EXTNAME(FTOPY1APD)                               BUG26775
     D TranInSecB    E DS                  EXTNAME(FTOPY3PD)                                BUG26775
     D TranInThiA    E DS                  EXTNAME(FTOPY4PD)                    CFT014
 
      * Flags to indicate whether transaction fields are valid
     D*OKFlagsDS*****E*DS***               EXTNAME(FTEOPY2PD)                   CFT014
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY3PD)                   CFT014
 
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
     D/COPY FTCPYSRC,SFTADDRILE
 
     D SDTPDS          DS           175
     D  DSDTP1                 1     35
     D  DSDTP2                36     70
     D  DSDTP3                71    105
     D  DSDTP4               106    140
 
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
                                                                                              CSD089
      ** Index for arrays of warning message ids etc                                          CSD089
     D WIx             S              3P 0                                                    CSD089
 
      * This prog only
     D ADLINE          S              1
     D ADSLON          S              1
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
     C                   Eval      Idx = 0
     C                   Eval      WFldNmXAr = *BlankS                                        CSD089
     C                   Eval      WMsgIDXAr  = *BlankS                                       CSD089
     C                   Eval      WMsgDtaXAr = *BlankS                                       CSD089
     C                   Eval      WIx = 0                                                    CSD089
     C                   Eval      DSDTP1 = SDTP1
     C                   Eval      DSDTP2 = SDTP2
     C                   Eval      DSDTP3 = SDTP3
     C                   Eval      DSDTP4 = SDTP4
 
      * Validate
      *
     C                   Exsr      VDETPAY
 
      ** If an error was found, set the return code appropriately
      *
     C                   If        OKDtp1 = 'N' or
     C                             OKDtp2 = 'N' or
     C                             OKDtp3 = 'N' or
     C                             OKDtp4 = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   Else                                                                 CSD089
     C                   If        OKDtp1 = 'W' or                                            CSD089
     C                             OKDtp2 = 'W' or                                            CSD089
     C                             OKDtp3 = 'W' or                                            CSD089
     C                             OKDtp4 = 'W'                                               CSD089
     C                   Eval      RetCodeIn = 'Warning'                                      CSD089
     C                   End                                                                  CSD089
     C                   End
 
      * RETURN
      *
     C                   RETURN
      ******************************************************************
      /EJECT
     C******************************************************************
     C* VDETPAY - VALIDATION DETAILS OF PAYMENT                        *
      ******************************************************************
     C*
     C     VDETPAY       BEGSR
 
      *                                                                                     BUG26775
      ** Check if Ordering Customer/Beneficiary ia s bank                                   BUG26775
      *                                                                                     BUG26775
     C                   CALL      'FT1020'                                                 BUG26775
     C                   PARM      @ORCT         CNTYP             1                        BUG26775
     C                   PARM      SSMCY         CNCCY             3                        BUG26775
     C                   PARM      SORC1         CNTR1            35                        BUG26775
     C                   PARM      SORC2         CNTR2            35                        BUG26775
     C                   PARM      SORC3         CNTR3            35                        BUG26775
     C                   PARM      SORC4         CNTR4            35                        BUG26775
     C                   PARM      SORC5         CNTR5            35                        BUG26775
     C                   PARM      @BNCT         BNTYP             1                        BUG26775
     C                   PARM      SPCCY         BNCCY             3                        BUG26775
     C                   PARM      SBNC1         BNTR1            35                        BUG26775
     C                   PARM      SBNC2         BNTR2            35                        BUG26775
     C                   PARM      SBNC3         BNTR3            35                        BUG26775
     C                   PARM      SBNC4         BNTR4            35                        BUG26775
     C                   PARM      SBNC5         BNTR5            35                        BUG26775
     C                   PARM      'C'           CTYP              1                        BUG26775
      *                                                                                     BUG26775
      * If MT202 in Ordering Customer then this field should be
      * blank as :70: not on MT200 series messages
     C                   If        SDTPDS <> *Blanks and
     C                             SORC1 = 'MT202'
     C                             OR SDTPDS <> *BLANKS                                     BUG26775
     C                             AND CTYP = 'B'                                           BUG26775
     C                             AND SSTTP = '08'                                         AR924563
      * Send error to screen
     C                   Move      'N'           OKDtp1
     C                   Add       1             Idx
     C                   Movel     'SDTP1'       FldNamXAr(Idx)
     C                   Movel     'MMA1060'     MsgIdXAr(Idx)
     C                   End
 
      * No errors
     C                   If        OKDtp1 = 'Y'
 
      * Validate details of payment
     C                   If        SDTPDS <> *Blanks
 
      * Prevent first check in ADCHK subroutine
      * Validate as an address
     C                   Eval      ADLINE = ' '
     C                   Movel(P)  SDTPDS        ADDRSS
     C                   Exsr      ADCHK
 
      *  Depending on the indicators, highlight the field in error
      *
     C                   If        *IN92 = *On
      * Send error to screen
     C                   Move      'N'           OKDtp1
     C                   Add       1             Idx
     C                   Movel     'SDTP1'       FldNamXAr(Idx)
     C                   Movel     'MMA1059'     MsgIdXAr(Idx)
     C                   End
 
     C                   If        AD#1 = 'Y'
     C**********         Move      'N'           OKDtp1                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SDTP1'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   Move      'W'           OKDtp1                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SDTP1'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIDXAr(WIx)                               CSD089
     C                   End
 
     C                   If        AD#2 = 'Y'
     C**********         Move      'N'           OKDtp2                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SDTP2'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   Move      'W'           OKDtp2                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SDTP2'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIDXAr(WIx)                               CSD089
     C                   End
 
     C                   If        AD#3 = 'Y'
     C**********         Move      'N'           OKDtp3                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SDTP3'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   Move      'W'           OKDtp3                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SDTP3'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIDXAr(WIx)                               CSD089
     C                   End
 
     C                   If        AD#4 = 'Y'
     C**********         Move      'N'           OKDtp4                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SDTP4'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   Move      'W'           OKDtp4                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SDTP4'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIDXAr(WIx)                               CSD089
     C                   End
 
     C                   End
     C                   End
 
     C                   ENDSR
     C*****************************************************************
     C* END OF DETAILS OF PAYMENT VALIDATION                          *
     C*****************************************************************
     C/EJECT
 
      * Subroutine ADCHK
     E/COPY FTCPYSRC,SFTADDRCLE
 
      * Subroutine SWSET
     E/COPY FTCPYSRC,SFTADDRSC1
 
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
     C***********        Parm                    TranInSecB                     CFT014
     C                   Parm                    TranInPrmB                                 BUG26775
     C                   Parm                    TranInSecB                                 BUG26775
     C                   Parm                    TranInThiA                     CFT014
 
      * OUTPUTS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      * Warning fields/message IDs/message data (arrays) from/to caller                       CSD089
     C                   Parm                    WFldNmXAr                                    CSD089
     C                   Parm                    WMsgIDXAr                                    CSD089
     C                   Parm                    WMsgDtaXAr                                   CSD089
 
      *  OK Flags
     C                   Parm                    OKFlagsDS
 
      *  Validation Work Fields
     C                   Parm                    Val@Fields
 
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
