     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Prn Addrs & Address Reference')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVPIAD    - Validate Print Address and Address Reference    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP035   *CREATE   Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP035 - Midas/ToF Interface                                 *
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
 
     D ARR             S              1    DIM(10)
     D ADR             S              1    DIM(10)
      ** External data structure for customer details file
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External data structure for alternate names & address
     D SDALTN        E DS                  EXTNAME(SDALTNPD)
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External data structure for access programs (long)
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
 
     D Idx1            S              2P 0
     D Idx2            S              2P 0
 
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
 
     C                   Movel     *Blanks       RetCodeIn
     C                   Movel     *Blanks       FldNamXAr
     C                   Movel     *Blanks       MsgIDXAr
     C                   Movel     *Blanks       MsgDtaXAr
     C                   Z-add     0             Idx
      *
     C                   ExSr      SrVPtAd
      *
     C                   ExSr      SrVARef
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDRefOK       IfEq      'N'
     C     DDPtAdOK      OrEq      'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   EndIf
      *
      ** RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrVPtAd - Validate Print Address Reference                   *
      *****************************************************************
     C     SrVPtAd       BEGSR
      *
      ** must be 'Y' or 'N'
     C     DDPTAD        IfNE      'Y'
     C     DDPTAD        ANDNE     'N'
     C                   Move      'N'           DDPTADOK
     C                   Add       1             Idx
     C                   Movel     'DDPtAd'      FldNamXAr(Idx)
     C                   Movel     'RE71113'     MsgIdXAr(Idx)
     C                   EndIf
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrVARef - Validate Address References                        *
      *****************************************************************
     C     SrVARef       BEGSR
      *
      ** DDRef must be a valid address
      ** If no entry, default to 'B'
     C     DDRef         IfEq      *BLANK
     C                   MoveL     'B'           DDRef
     C                   EndIf
      *
     C     DDRef         IfNE      *BLANK
     C                   Move      DDCUSN        AENB              6
     C                   MoveA     DDRef         ARR(1)
     C                   MoveA     *BLANK        ADR(1)
     C                   Move      *Off          *In84
     C                   Z-Add     1             Idx1
     C     Idx1          DOWLE     10
     C     DDRefOk       AndEq     'Y'
     C     ARR(Idx1)     IfEq      *BLANK
     C                   Add       1             Idx1
     C     Idx1          DOWLE     10
     C     DDRefOk       AndEq     'Y'
     C     ARR(Idx1)     IfNE      *BLANK
     C                   Move      'N'           DDRefOK
     C                   Add       1             Idx
     C                   Movel     'DDRef'       FldNamXAr(Idx)
     C                   Movel     'RE71114'     MsgIdXAr(Idx)
     C                   Else
     C                   Add       1             Idx1
     C                   EndIf
     C                   EndDo
      *
     C                   Else
      *
     C                   Move      ARR(Idx1)     AZCD              1
     C     ARR(Idx1)     IfEQ      'B'
     C                   CallB     'AOCUSTR0'
     C                   Parm      '*MSG   '     @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm      DDCUSN        @CNUM            10
     C                   Parm                    @CNST             7
     C     SDCUST        Parm      SDCUST        DSSDY
     C     @RTCD         IfNE      *BLANKS
     C                   Move      *ON           *In84
     C                   Else
     C                   Move      BBCUST        DDCUSN
     C                   EndIf
     C*
     C                   Else
     C*
     C                   CallB     'AOALTNR0'
     C                   Parm      '*MSG   '     @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm      AENB          @CNUA             6
     C                   Parm      AZCD          @ADDR             1
     C     SDALTN        Parm      SDALTN        DSFDY
      *
     C     @RTCD         IfNE      *BLANKS
     C     BCCUST        ORNE      AENB
     C                   Move      *ON           *In84
      *
     C                   Else
      *
      ** Move chosen alternate into array element.
      *
     C                   Move      BCADCD        ARR(Idx1)
     C                   EndIf
      *
     C                   EndIf
      *
     C     *In84         IfEq      '1'
     C                   Move      'N'           DDRefOK
     C                   Add       1             Idx
     C                   MoveL     'DDRef'       FldNamXAr(Idx)
     C                   MoveL     'RE71114'     MsgIdXAr(Idx)
     C                   Else
     C                   Z-Add     1             Idx2
     C*
     C* Array has the same character twice.
     C*
     C     ARR(Idx1)     LookUp    ADR(Idx2)                              84
     C     *In84         IfEq      '1'
     C                   Z-Add     1             Idx2
     C                   Move      'N'           DDRefOK
     C                   Add       1             Idx
     C                   MoveL     'DDRef'       FldNamXAr(Idx)
     C                   MoveL     'RE71114'     MsgIdXAr(Idx)
     C                   Else
     C                   Move      ARR(Idx1)     ADR(Idx1)
     C                   Add       1             Idx1
     C                   EndIf
     C                   EndIf
     C                   EndIf
      *
     C                   EndDo
      *
      ** Move Array to screen as details may have changed via AOALTNR0
      *
     C                   MoveA     ARR           DDRef
     C                   EndIf
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *Entry        Plist
      *
      ** INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeIn
      *
      ** Account Screen fields
     C                   Parm                    DDREF            10
     C                   Parm                    DDPTAD            1
     C                   Parm                    DDCUSN            6
      *
      ** OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *
      ** Address Reference - Ok
      ** Print Address Ref - Ok
     C                   Parm                    DDRefOk           1
     C                   Parm                    DDPtAdOk          1
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
(c) Finastra International Limited 2001
