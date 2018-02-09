     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate transaction type code (detail)')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVTTCD01 - Validate Transaction Type Code                   *
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
 
      ** Include the MM standard declares
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
 
      * Header record in screen format
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD) PREFIX(H)
 
      * Detail record in screen format
     D DtlRcdIn      E DS                  EXTNAME(FT102DSPD)
 
      * OK Flags for first screen
     D OKFlagDs1     E DS                  EXTNAME(FTE102S1PD)
 
      * OK Flags for Second screen
     D OKFlagDs2     E DS                  EXTNAME(FTE102S2PD)
 
      * OK Flags for first screen - Header
     D OKFlagHs1     E DS                  EXTNAME(FTE102H1PD)
 
      * OK Flags for Second screen - header
     D OKFlagHs2     E DS                  EXTNAME(FTE102H2PD)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      ** Alphabetical characters (upper case)
     D Alpha           S              1    DIM(26) CTDATA PERRCD(26)
      ** Work array
     D Code            S              1    DIM(3)
                                                                                              CSW202
      ** Alphanumeric characters (uppercase)                                                  CSW202
     D ALPHAN          S              1    DIM(36) CTDATA PERRCD(36)                          CSW202
 
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
 
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialise
     C                   EVAL      Idx       = 0
     C                   EVAL      OKCCTYC   = 'Y'
     C                   EVAL      Y          = 1
 
      ** Main processing
     C                   EXSR      VALIDATE
 
      ** Return
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * VALIDATE - Main validation processing                         *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     VALIDATE      BEGSR
      *
      ** If transaction type code is not blank, check if it exists in
      ** the header record, if it does, error
      *
     C                   IF        PCCTTYC <> *Blanks
      *
     C                   IF        HPTRNSTP <> *BLANKS
     C                   MOVE      'N'           OKCCTYC
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0384'     MsgIdXAr(Idx)
     C                   RETURN
     C                   ENDIF
 
      ** Transaction Type Code must contain uppercase alphabetic letters
      ** with no blanks in between the letters
 
     C                   MOVEA     PCCTTYC       Code
 
     C                   DOW       Y < 4
 
      ** If SWIFT 2002 is on, Transaction Type Code must contain uppercase                    CSW202
      ** alphanumeric characters only.                                                        CSW202
                                                                                              CSW202
     C                   IF        CSW202 = 'Y'                                               CSW202
     C     Code(Y)       LOOKUP    ALPHAN                                 01                  CSW202
     C                   ELSE                                                                 CSW202
     C     Code(Y)       LOOKUP    Alpha                                  01
     C                   ENDIF                                                                CSW202
 
     C                   IF        *IN01 = *OFF
     C                   MOVE      'N'           OKCCTYC
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0901'                                  CSW202
     C                   ELSE                                                                 CSW202
     C                   MOVEL     'RFV0385'     MsgIdXAr(Idx)
     C                   ENDIF                                                                CSW202
     C                   LEAVE
     C                   ENDIF
 
     C                   EVAL      Y = Y + 1
 
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
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
      *
     C     *INZSR        BEGSR
      *
     C     *Entry        PLIST
      *
      ** INPUTS
      *
     C                   PARM                    RetCodeIn
     C                   PARM                    RespMode          1
     C                   PARM                    ActionCode        1
      *  Screen fields
     C                   PARM                    HdrRcdIn
     C                   PARM                    DtlRcdIn
      *
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDSName          10
     C                   PARM                    OKFlagDs1
     C                   PARM                    OKFlagDs2
     C                   PARM                    OKFlagHs1
     C                   PARM                    OKFlagHs2
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
      *
      ** Program, module and procedure names for database error processing.*
      ** The following /COPY sets these values, and also defines LDA as    *
      ** an external data area                                             *
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR                                                  *** InzEnd ***
      *
      *****************************************************************
      /EJECT
      **********************************************************************
 
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  Alpha - Array of alphabetic characters                                      CFT004
ABCDEFGHIJKLMNOPQRSTUVWXYZ
**  ALPHAN - Array of alphanumeric characters (uppercase)                                     CSW202
ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789                                                          CSW202
