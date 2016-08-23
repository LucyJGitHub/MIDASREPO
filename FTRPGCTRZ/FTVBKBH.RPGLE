     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate booking and originating branch')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVBKBH   - Validate Booking and Originating Branch         *
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
      *                 CSD027             Date 09Dec05               *
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
      *                 CAP031  *CREATE    Date 07Apr99               *
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
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
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
 
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY1PD)
 
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
      * External DS for General Ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** External data structure for branch codes file
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
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
 
     D C#ACTN          S              7
     D C#BRCA          S              3
     D C#ERR           S              1  0
     D C#OPTN          S              7
     D C#ORBR          S              3
     D C#RTCD          S              7
 
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     D RespMode        S              1A
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
     C                   Eval      Idx = 0
 
      * Booking Branch Validation
     C                   Exsr      VBRCA
 
      * Originating Branch Validation
     C                   If        BKOBRU = 'Y'
     C                   Exsr      VORBR
     C                   End
 
      * If an error was found, set the return code appropriately
     C                   If        OKBrca = 'N' or
     C                             OKOrbr = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   End
 
      * RETURN
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VBRCA - BOOKING BRANCH VALIDATION
      *****************************************************************
     C     VBRCA         BEGSR
 
      * If branch is not yet defined set to default Booking Branch
     C                   If        SBRCA = *Blanks  and
     C                             @BRSEL <> 'NOSEL'
     C                   Eval      SBRCA = @DFBR
     C                   End
 
      * Read SDBRCHPD to validate screen branch code
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   Parm      *Blanks       C#RTCD
     C                   Parm      '*KEY   '     C#OPTN
     C                   Parm      SBRCA         C#BRCA
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
      * If return code is not blank - process for an error
     C                   If        C#RTCD <> *Blanks
     C                   Move      'N'           OKBrca
     C                   Add       1             Idx
     C                   Movel     'SBRCA'       FldNamXAr(Idx)
     C                   Movel     'MMA0907'     MsgIdXAr(Idx)
 
     C                   ELSE
     C                   Move      C#BRCA        SBRCA
      * Check user is authorised to perform action code on Booking branch
      * Only do the User/Branch/Action check if the program is running in
      * Synchronous mode.
 
     C     RespMode      IFEQ      'S'
 
     C                   CALL      'ZVACTBU'
     C                   Parm      SACTION       C#ACTN
     C                   Parm      SBRCA         C#BRCA
     C                   Parm      0             C#ERR
 
      * User not authorised to any action codes for this item and branch
     C                   If        C#ERR = 1
     C                   Move      'N'           OKBrca
     C                   Add       1             Idx
     C                   Movel     'SBRCA'       FldNamXAr(Idx)
     C                   Movel     'MMA0908'     MsgIdXAr(Idx)
     C                   End
 
      * User not authorised to action code for this item & branch
     C                   If        C#ERR = 2
     C                   Move      'N'           OKBrca
     C                   Add       1             Idx
     C                   Movel     'SBRCA'       FldNamXAr(Idx)
     C                   Movel     'MMA0910'     MsgIdXAr(Idx)
     C                   End
 
     C                   End
 
     C                   End
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * VORBR - ORIGINATING BRANCH VALIDATION
      *****************************************************************
     C     VORBR         BEGSR
 
      * Default originating branch to booking branch (if valid)
     C                   If        SORBR = *Blanks   and
     C                             @ORSEL <> 'NOSEL' and
     C                             OKBrca = 'Y'
     C                   Eval      SORBR = SBRCA
     C                   End
 
      * Validate SORBR entry is valid branch
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   Parm      *Blanks       C#RTCD
     C                   Parm      '*KEY   '     C#OPTN
     C                   Parm      SORBR         C#ORBR
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
     C                   If        C#RTCD <> *Blanks
      * Send error to screen
     C                   Move      'N'           OKOrbr
     C                   Add       1             Idx
     C                   Movel     'SORBR'       FldNamXAr(Idx)
     C                   Movel     'MMA0909'     MsgIdXAr(Idx)
     C                   Else
     C                   Move      C#ORBR        SORBR
     C                   End
 
      * Only do the User/Branch/Action check if the program is running in
      * Synchronous mode.
 
     C     RespMode      IFEQ      'S'
 
      *  If originating branch val. req'd and no error on Branch Code
     C                   If        BKOBUV = 'Y' and
     C                             OKOrbr = 'Y'
     C                   CALL      'ZVOBU'
     C                   Parm      SORBR         C#ORBR
     C                   Parm      0             C#ERR
 
      * User not authorised to any action codes for this Order Branch
     C                   If        C#ERR = 1
     C                   Move      'N'           OKOrbr
     C                   Add       1             Idx
     C                   Movel     'SORBR'       FldNamXAr(Idx)
     C                   Movel     'MMA0911'     MsgIdXAr(Idx)
     C                   End
 
      * User not authorised to action code for this Item and Branch
     C                   If        C#ERR = 2
     C                   Move      'N'           OKOrbr
     C                   Add       1             Idx
     C                   Movel     'SORBR'       FldNamXAr(Idx)
     C                   Movel     'MMA0912'     MsgIdXAr(Idx)
     C                   End
 
     C                   End
 
     C                   End
 
     C                   ENDSR
      *****************************************************************
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
 
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    RespMode
 
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
 
      ** OK Flags
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
