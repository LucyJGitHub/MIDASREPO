     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate transaction type code (header)')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVTTCD02 - Validate Transaction Type Code (Header)          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01.01 ----------------------------------------*
      *                 CSW202             Date 20May02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184060  *CREATE    Date 22Sep00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes (Recompiled)                     *
      *  CSW202 - SWIFT 2002 Standards Update                         *
      *  CSW201 - SWIFT 2001 Standards Update (Recompiled)            *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen           *
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
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      ** Header record datastructure
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD)
      ** Detail record datastructure
     D DtlRcdIn      E DS                  EXTNAME(FT102DSPD) PREFIX(D)
      ** Alphabetical characters (upper case)
     D Alpha           S              1    DIM(26) CTDATA PERRCD(26)
      ** Work array
     D Code            S              1    DIM(3)
                                                                                              CSW202
      ** Alphanumeric characters (uppercase)                                                  CSW202
     D ALPHAN          S              1    DIM(36) CTDATA PERRCD(36)                          CSW202
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * OK Flags for first screen - Header
     D OKFlagHs1     E DS                  EXTNAME(FTE102H1PD)
 
     D GenOkFlag3      S              1    Import
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      ** Work index for work array CODE
     D Y               S              1  0
                                                                                              CSW202
     D CSW202          S              1                                                       CSW202
     D PRTCD           S              7                                                       CSW202
 
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
 
     C                   Eval      RetCodeIn  = *Blanks
     C                   Eval      Idx        = 0
     C                   Eval      GenOkFlag3 = 'Y'
     C                   Eval      Y          = 1
 
      ** Transaction Type Code must contain uppercase alphabetic letters and
      ** no blanks in between the letters
 
     C                   If        PTRNSTP <> *blanks
 
     C                   MoveA     PTRNSTP       Code
 
     C                   Dow       Y < 4
 
      ** If SWIFT 2002 is on, Transaction Type Code must contain uppercase                    CSW202
      ** alphanumeric characters only.                                                        CSW202
                                                                                              CSW202
     C                   IF        CSW202 = 'Y'                                               CSW202
     C     Code(Y)       LOOKUP    ALPHAN                                 01                  CSW202
     C                   ELSE                                                                 CSW202
     C     Code(Y)       LooKUp    Alpha                                  01
     C                   ENDIF                                                                CSW202
 
     C                   If        *IN01 = *OFF
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0901'                                  CSW202
     C                   ELSE                                                                 CSW202
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0385'
     C                   ENDIF                                                                CSW202
     C                   Eval      FldNamXAr(Idx) =   DDSName
     C                   Eval      GenOkFlag3 = 'N'
     C                   Leave
     C                   Endif
 
     C                   Eval      Y = Y + 1
 
     C                   Enddo
 
     C                   Endif
 
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
 
      * INPUTS
 
     C                   Parm                    RetCodeIn
     C                   Parm                    RespMode          1
     C                   Parm                    ActionCode        1
 
      *  Screen fields
     C                   Parm                    HdrRcdIn
 
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    DDSName          10
     C                   Parm                    OkFlagHs1
                                                                                              CSW202
      ** Check if SWIFT 2002 is installed                                                     CSW202
                                                                                              CSW202
     C                   CALL      'SWIF2002'                                                 CSW202
     C                   PARM      *BLANKS       PRTCD                                        CSW202
                                                                                              CSW202
     C                   IF        PRTCD = 'CSW2002'                                          CSW202
     C                   EVAL      CSW202 = 'Y'                                               CSW202
     C                   ELSE                                                                 CSW202
     C                   EVAL      CSW202 = 'N'                                               CSW202
     C                   ENDIF                                                                CSW202
 
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
**  Alpha - Array of alphabetic characters                                      CFT004
ABCDEFGHIJKLMNOPQRSTUVWXYZ
**  ALPHAN - Array of alphanumeric characters (uppercase)                                     CSW202
ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789                                                          CSW202
