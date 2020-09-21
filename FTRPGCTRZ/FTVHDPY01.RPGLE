     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
 
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Header Instructing Party')
 
 
      *  Midas - Standard subprograms                                 *
 
      *  FTVHDPY01  - Validate Header Instructing Party               *
 
      *  (c) Finastra International Limited 2001                      *
 
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
 
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 224336             Date 02Apr04               *
      *                 221761             Date 01Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 15Jul99               *
      *                                    Date ddmmmyy               *
 
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  224336 - Remove nuisance warning messages                    *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  CFT006 - Funds Transfer addition of MT101 messages           *
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
      * Header record datastructure
     D HdrRcdIn      E DS                  EXTNAME(FT101HSPD)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D GenOkFlag       S              1    Import
 
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
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
     D RespMode        S              1
     D DDSName         S             10
     D CustNo          S              6
     D ShortN          S             10
 
     DWrkDs            DS
     D WHINPTY                 1     35
     D WCUSTNO                 7     35
     D WSHORTN                11     35
 
     D  ErrNum         S              1  0
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
 
     C                   Eval      RetCodeIn  = *BlankS
     C                   Eval      Idx        = 0
     C                   Eval      WIdx       = 0
 
     C                   Eval      GenOkFlag = 'Y'
     C                   Eval      WHINPTY = PHINPTY
     C                   Eval      ErrNum = 0
 
      *  May be free format text, customer number or shortname
 
      *
      *  If 1st 6 characters numeric AND remainder of field blank, check
      *   for customer number.  Warning message only.
      *  If 1st 10 characters alphabetic AND remainder of field blank, check
      *   for customer shortname.  Warning message only.
      *  If neither of above, do not validate.
      *
      * Blank : OK
     C                   If        PHINPTY = *Blank
     C                   Return
     C                   Endif
 
     C                   CallB     'AOACCTV1'
     C                   Parm                    @Rtcd
     C                   Parm                    P@TYPE            7
     C                   Parm                    PHINPTY
     C                   Parm                    DSSDY
 
      * Check customer number.
     C                   Eval      CustNo = PHINPTY
 
     C                   TESTN                   CustNo               22
     C                   If        *In22               AND
     C                             P@TYPE  = '*CUSTNO' AND
     C                             WCUSTNO = *Blank
     C                   Return
     C*******************Else                                                                 224336
     C*******************Eval      ErrNum = 1                                                 224336
     C                   Endif
 
      * Check Shortname
     C                   Eval      ShortN = PHINPTY
     C                   If        P@Type   = '*SHNAME' AND
     C                             WSHORTN  =  *Blank
     C                   Return
     C*******************Else                                                                 224336
     C*******************Eval      ErrNum = 2                                                 224336
     C                   Endif
 
     C* There should be no need to issue a warning message as it is then regarded as a        224336
     C* free format text                                                                      224336
     C*******************Select                                                               224336
     C*******************When      ErrNum = 1                                                 224336
     C*******************Eval      WIdx            =   Idx+1                                  224336
     C*******************Eval      RetCodeIn       =   'Error'                                224336
     C*******************Eval      WMsgIdXAr(WIdx) =   'RFV0291'                              224336
     C*******************Eval      WFldNmXAr(WIdx) =   DDSName                                224336
     C*******************Eval      GenOkFlag = 'W'                                            224336
     C*******************When      ErrNum = 2                                                 224336
     C*******************Eval      WIdx            =   Idx+1                                  224336
     C*******************Eval      RetCodeIn       =   'Error'                                224336
     C*******************Eval      WMsgIdXAr(WIdx) =   'RFV0292'                              224336
     C*******************Eval      WFldNmXAr(WIdx) =   DDSName                                224336
     C*******************Eval      GenOkFlag = 'W'                                            224336
     C*******************Endsl                                                                224336
 
      * Now validate that all data entered is OK for SWIFT
 
     C                   If        PHINPTY <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PHINPTY       Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C                   Eval      FldNamXAr(Idx) =  DDSName
     C                   Eval      GenOkFlag = 'N'
     C                   Endif
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
     C                   Parm                    RespMode
     C                   Parm                    ActionCode
 
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
     C                   Parm                    DDSName
 
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
