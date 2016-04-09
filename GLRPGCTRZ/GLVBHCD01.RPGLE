     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Branch Code - Alpha')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVBHCD01 - Validate Branch Code - Alpha                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP035 - Midas/ToF Interface                                 *
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
 
     C                   Movel     *Blanks       RetCodeIn
     C                   Movel     *Blanks       FldNamXAr
     C                   Movel     *Blanks       MsgIDXAr
     C                   Movel     *Blanks       MsgDtaXAr
     C                   Z-add     0             Idx
      *
      ** If branch is not yet defined
      ** Default branch from ZMUSER
      *
     C                   If        DDBrca=*Blanks
     C                   Move      DBRN          DDBrca
     C                   EndIf
      *
      ** Branch code if entered must exist on SDBRCHPD file
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm                    DDBRCA
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      * error
     C     @RTCD         IfNe      *Blanks
     C                   Move      'N'           DDBrcaOk
     C                   Add       1             Idx
     C                   Movel     'DDBRCA'      FldNamXAr(Idx)
     C                   Movel     'RE71040'     MsgIDXAr(Idx)
     C                   Else
      *
      ** IF MULTIBRANCHING DO VALIDATION ON BRANCH INPUT                    7616
     C     BJSBRC        IFEQ      *BLANKS                                                     09761
     C     RESPMODE      ANDEQ     'S'
     C                   MOVEL     DDACTN        @ZACTN                                        09761
     C                   MOVEL     DDBRCA        @BRCA                                         09761
     C                   EXSR      #AUTH                                                       09761
     C     @ERR          IFNE      0                                                           09761
     C     DDACTN        IFEQ      'I'                                                         12482
     C                   Move      'N'           DDBrcaOk
     C                   Add       1             Idx
     C                   Movel     'RE7102B'     MsgIDXAr(Idx)
     C                   Movel     'DDBRCA'      FldNamXAr(Idx)
     C                   ENDIF                                                                 12482
     C     DDACTN        IFEQ      'D'                                                         12482
     C                   Move      'N'           DDBrcaOk
     C                   Add       1             Idx
     C                   Movel     'RE7104B'     MsgIDXAr(Idx)
     C                   Movel     'DDBRCA'      FldNamXAr(Idx)
     C                   ENDIF                                                                 12482
     C                   ENDIF                                                                 09761
     C                   ENDIF                                                                 09761
     C                   Movel     A8BRCD        DDBRCA
     C                   EndIf
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDBrcaOK      IfEq      'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   EndIf
      *
      ** RETURN
      *
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *  #AUTH - CHECK ACTION CODE AND BRANCH AUTHORITY
      *****************************************************************
     C     #AUTH         BEGSR
      *
      ** Multi-branch system, user must be authorised to action on
      ** branch.
      *
     C     AGMBIN        IFEQ      'Y'
     C                   CALL      'ZVACTBU'
     C                   PARM                    @ZACTN            1
     C                   PARM                    @BRCA             3
     C                   PARM                    @ERR              1 0
      *
     C                   ELSE
      *
      ** Single branch system, check user is authorised to action code
      *
     C                   CALL      'ZVACTU'
     C                   PARM                    @ZACTN
     C                   PARM                    @ERR
      *
     C                   ENDIF
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
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeIn
      *
      ** Response mode (1A), from source system common header
     C                   PARM                    RespMode          1
      *
      ** Account Screen fields
     C                   Parm                    DDBRCA            3
     C                   Parm                    DDACTN            1
      *
      ** ICD
     C                   Parm                    BJSBRC            3
     C                   Parm                    DBRN              3
     C                   Parm                    AGMBIN            1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *
      ** Branch Internal Customer
     C                   Parm      A8BICN        BICN              6
      *
      ** Branch code - OK
     C                   Parm                    DDBrcaOK          1
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
