     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate settlement type')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVSETY  - Validate Settlement Type                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      *                 260987             Date 06Jul09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 210863             Date 13Dec02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 205679             Date 22Aug02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *               . 175479             Date 23May00               *
      *                 CFT007             Date 23Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 01Dec99               *
      *                 CAP031  *CREATE    Date 09Apr99               *
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
      *  260987 - The presence of '1' in position 8 on Customer SWIFT *
      *           denotes that this is not a SWIFT address.           *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompile)    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  210863 - Higlight and validate field destination correctly.  *
      *  205679 - Prevent database error in AOCUSTR0                  *
      *         - correct SWIFT destination validation                *
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
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
 
     FACNUMA    IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACNUMAF)
 
 
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
 
      * Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY1PD)
 
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
      ** External data structure for Nostro customer number
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
 
      ** External data structure for Nostro customer number
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External data structure for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D                 DS
     D*WCNUM****               1      6  0                                                    CSD027
     D WCNUM                   1      6A                                                      CSD027
     D WCNUMA                  1      6
     D WACOD                   7     16  0                                                    CGL029
     D WACSQ                  17     18  0                                                    CGL029
     D WCURR                  19     23                                                       CGL029
     D WCURRN                 22     23                                                       CGL029
     D*WACOD****               7     10  0                                                    CGL029
     D*WACSQ****              11     12  0                                                    CGL029
     D*WCURR****              13     17                                                       CGL029
     D*WCURRN***              16     17                                                       CGL029
     D
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
 
     D*C#ACCD***       S              4                                                       CGL029
     D C#ACCD          S             10                                                       CGL029
     D C#ACSN          S              2
     D C#BRCD          S              3
     D C#CSSN          S             10
     D C#CUST          S              6
     D C#CYCD          S              3
     D C#KEY1          S             10
     D C#KYST          S              7
     D C#NONB          S              2
     D C#OPTN          S              7
     D C#PNOI          S              1
     D C#RTCD          S              7
 
     D K#ACNO          S                   LIKE(ACNO)
 
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
 
      * Settlement Type
      *
     C                   Exsr      VSETTYP
 
      ** If an error was found, set the return code appropriately
      *
     C                   If        OKSttp = 'N'
     C                   Eval      RetCodeIn = 'Error'
 
     C                   Else
      * Set Valid Fields
     C                   Move      SSTTP         @STMT
     C                   End
 
      * RETURN
      *
     C                   RETURN
      ******************************************************************
      /EJECT
     C****************************************************************
     C* VSETTYP -  VALIDATION OF SETTLEMENT TYPE                     *
     C****************************************************************
     C*
     C     VSETTYP       BEGSR
 
      * Mandatory entry
     C                   If        SSTTP = *Blanks
      * Send error to screen
     C                   Move      'N'           OKSttp
     C                   Add       1             Idx
     C                   Movel     'SSTTP'       FldNamXAr(Idx)
     C                   Movel     'MMA1010'     MsgIdXAr(Idx)
 
     C                   Else
      * Must be one of 01 02 08 10 12 13 (or 14 if CFT003 installed)
     C                   If        @CFT003 = 'N' and
     C                             SSTTP <> '01' and
     C                             SSTTP <> '02' and
     C                             SSTTP <> '08' and
     C                             SSTTP <> '10' and
     C                             SSTTP <> '12' and
     C                             SSTTP <> '13' or
 
     C                             @CFT003 = 'Y' and
     C                             SSTTP <> '01' and
     C                             SSTTP <> '02' and
     C                             SSTTP <> '08' and
     C                             SSTTP <> '10' and
     C                             SSTTP <> '12' and
     C                             SSTTP <> '13' and
     C                             SSTTP <> '14'
 
      * Send error to screen
     C                   Move      'N'           OKSttp
     C                   Add       1             Idx
     C                   Movel     'SSTTP'       FldNamXAr(Idx)
     C                   Movel     'MMA1011'     MsgIdXAr(Idx)
     C                   End
 
     C                   End
 
     C                   If        OKSttp = 'Y'
 
      * If settlement type 08 Destination must be Swift
     C                   If        SSTTP = '08'
 
      * If full or Swift address or blank or Destination invalid ignore
     C                   If        @DSTT = 'A' or
     C                             @DSTT = 'S' or
     C                             @DSTT = ' ' or
     C                             OKDst1 = 'N'
     C                   Eval      WCSID = *Blanks
     C                   Eval      WCSID8 = *Blanks                                           260987
 
     C                   Else
      * If full NOSTRO(F)
     C                   If        @DSTT = 'F'
     C                   Movel     SDST1         WCURR
 
      * Read SDNOSTPD for customer number
     C                   CALLB     'AONOSTR0'
     C                   Parm      '*DBERR'      C#RTCD
     C                   Parm      '*KEY   '     C#OPTN
     C                   Parm      *Blanks       C#CUST
     C                   Parm      WCURR         C#CYCD
     C                   Parm      *Blanks       C#ACCD
     C                   Parm      *Blanks       C#ACSN
     C                   Parm      WCURRN        C#NONB
     C                   Parm      *Blanks       C#BRCD
     C                   Parm      *Blanks       C#CSSN
     C                   Parm      *Blanks       C#PNOI
     C     SDNOST        Parm      SDNOST        DSFDY
 
      * Move new SYNON field names to old field names
     C                   Move      A7CUST        WCNUM
     C                   Move      A7ACCD        WACOD
     C                   Move      A7ACSN        WACSQ
     C                   Eval      BRCA = A7BRCD
 
     C                   Else
     C* If retail Number(R) read ACNUMA for customer number
     C                   If        @DSTT = 'R'
     C                   Movel     SDST1         K#ACNO
     C     K#ACNO        Chain     ACNUMAF                            90
 
      * Error if not found or RECI <> D
     C                   If        *IN90 = *ON or
     C                             RECI <> 'D'
     C                   Move      'FTVSETY'     DBPGM
     C                   Move      'ACNUM'       DBFILE
     C                   Eval      DBASE = 21
     C                   Movel     K#ACNO        DBKEY
     C                   Exsr      *PSSR
 
     C                   Else
     C                   Eval      @CCY = CCY
     C                   Movel     CNUM          WCNUM                                        205679
     C                   Movel     CNUM          WCNUMA                                       205679
     C                   End
 
     C                   Else
      * Customer Number is at start of INAD
     C                   Movel     SDST1         WCNUM
     C                   End
     C                   End
      * Read SDCUSTPD for swift address
     C                   CALLB     'AOCUSTR0'
     C                   Parm      '*DBERR '     C#RTCD
     C                   Parm      '*KEY   '     C#OPTN
     C                   Parm      WCNUMA        C#KEY1
     C                   Parm      *BLANKS       C#KYST
     C     SDCUST        Parm      SDCUST        DSSDY
 
      * Move new SYNON field names to old field names
     C                   If        C#RTCD = *Blanks
     C                   Move      BBCUST        WCNUM
     C                   Eval      WCSID = BBCSID
     C     1             SUBST     WCSID:8       WCSID8            1                          260987
     C                   End
 
     C                   End
 
     C**********         If        WCSID = *Blanks and                                        205679
     C**********                   @DSTT <> 'S'  or                                           205679
     C**********                   WCSID = *Blanks and                                        205679
     C**********                   @SWIIND <> '*NFND'                                         205679
 
     C**********         If        WCSID = *Blanks and                                 205679 260987
     C**********                   @DSTT <> 'S'  or                                    205679 260987
     C**********                   WCSID = *Blanks and                                 205679 260987
     C**********                   @SWIIND = '*NFND'                                   205679 260987
                                                                                              205679
     C                   If        WCSID = *Blanks and                                        260987
     C                             @DSTT <> 'S'  or                                           260987
     C                             WCSID = *Blanks and                                        260987
     C                             @SWIIND = '*NFND' or                                       260987
     C                             WCSID8 = '1'                                               260987
                                                                                              260987
     C                   Eval      @STTP = SSTTP
 
     C**********         Move      'W'           OKSttp                                       210863
     C                   Move      'N'           OKDst1                                       210863
     C                   Add       1             WIx
     C**********         Movel     'SSTTP'       WFldNmXAr(WIx)                               210863
     C                   Movel     'SDST1'       WFldNmXAr(WIx)                               210863
     C                   Movel     'MMA1012'     WMsgIdXAr(WIx)
 
     C                   End
     C                   End
     C                   End
     C*
     C                   ENDSR
     C*
     C************************************************************
     C* END OF MT202 VALIDATION
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
