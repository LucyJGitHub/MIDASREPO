     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities Details 3 LUX Validate')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading ILE Module                        *
      *                                                               *
      *  SESECS8VL - SE Securities Details 3 LUX Validate             *
      *                                                               *
      *  Function:  This function is the main validation process for  *
      *             Extended Securities Details                       *
      *                                                               *
      *  (c) Copyright Misys International Banking Systems Ltd. 2005  *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CER001  *Create    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                     error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
 
      *
      ** Program Status Data Structure
      ** The following /COPY line includes all the defined fields in
      ** the PSDS. They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
 
      *
      ** The following /COPY line includes definitions for the above
      ** fields as #ProcPgm, #ProcMod and #ProcName.  They are based on
      ** the corresponding fields in the PSDS /COPY member, so this
      ** later member must be included where this one is used.
      *
     D/COPY ZACPYSRC,PROCPARMS
 
      *
      ** The following /COPY line includes the definitions for error &
      ** warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      *
      ** Manually included D-specs
      ** =========================
      *
 
      *
      ** Named constants
      ** ---------------
      *
 
      *
      ** Arrays and Data Structures
      ** --------------------------
      *
 
      *
      ** DS for access programs, short Data
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      *
      ** New Extension in File Format (#LLXVV)
      *
     D NwExFilFmt    E DS                  EXTNAME(SEVSELX1PD)
 
      *
      ** New Extension in Screen Format (LnLX)
      *
     D NwExScnFmt    E DS                  EXTNAME(SESERXPD)
 
      *
      ** Error indicators (OK#LLX)
      *
     D OkFlags       E DS                  EXTNAME(SEESELX1PD)
 
      *
      ** Data passed from caller program
      *
     D/COPY QWINDSRC,SESECSDTA
     D DATALUX         DS          1024
     D  L1SESN                 1     10A                                                      CER001
     D  L1FOTR                11     30A                                                      CER001
     D  L1ISNO                31     42A                                                      CER001
 
      *
      ** Declared variables
      ** ------------------
      *
 
      *
      ** "Standard" *entry parameters
      *
     D ACTN            S              1
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      *
      ** Output parameters for call to individual validation modules
      *
     D WWISTP          S                   LIKE(#LLXVVISTP)
 
      *
      ** Error message fields received as parameters
      *
     D MsgId1          S                   LIKE(#MsgID)
     D MsgId2          S                   LIKE(#MsgID)
     D MsgId3          S                   LIKE(#MsgID)
     D MsgId4          S                   LIKE(#MsgID)
     D MsgId5          S                   LIKE(#MsgID)
     D MsgId6          S                   LIKE(#MsgID)
     D MsgId7          S                   LIKE(#MsgID)
 
      *
      ** Warning error message fields received as parameters
      *
     D WmsgId1         S                   LIKE(#MsgID)
     D WmsgId2         S                   LIKE(#MsgID)
     D WmsgId3         S                   LIKE(#MsgID)
     D WmsgId4         S                   LIKE(#MsgID)
     D WmsgId5         S                   LIKE(#MsgID)
     D WmsgId6         S                   LIKE(#MsgID)
     D WmsgId7         S                   LIKE(#MsgID)
 
      *
      ** Error message substitution data received as a parameter
      *
     D MsgData1        S                   LIKE(#MsgData)
     D MsgData2        S                   LIKE(#MsgData)
     D MsgData3        S                   LIKE(#MsgData)
     D MsgData4        S                   LIKE(#MsgData)
     D MsgData5        S                   LIKE(#MsgData)
     D MsgData6        S                   LIKE(#MsgData)
     D MsgData7        S                   LIKE(#MsgData)
 
      *****************************************************************
      *                M A I N  P R O C E S S I N G                   *
      *****************************************************************
      *
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      *
 
      *
      ** Validates screen fields
      *
     C                   EXSR      SRISTP
 
      *
      ** If no errors sets up valid file record
      *
     C                   IF        Idx = 0
     C                   EXSR      SRSETUP
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      * RESETERRS - Reset error information sent back by validation   *
      *             modules                                           *
      *****************************************************************
     C     RESETERRS     BEGSR
 
     C                   RESET                   MsgId1
     C                   RESET                   MsgId2
     C                   RESET                   MsgId3
     C                   RESET                   MsgId4
     C                   RESET                   MsgId5
     C                   RESET                   MsgId6
     C                   RESET                   MsgId7
 
     C                   RESET                   WMsgId1
     C                   RESET                   WMsgId2
     C                   RESET                   WMsgId3
     C                   RESET                   WMsgId4
     C                   RESET                   WMsgId5
     C                   RESET                   WMsgId6
     C                   RESET                   WMsgId7
 
     C                   RESET                   MsgData1
     C                   RESET                   MsgData2
     C                   RESET                   MsgData3
     C                   RESET                   MsgData4
     C                   RESET                   MsgData5
     C                   RESET                   MsgData6
     C                   RESET                   MsgData7
 
     C                   EVAL      ReturnCode = *Blanks
 
     C                   ENDSR
 
      *****************************************************************
      * SRISTP - Validates Issuer Type field                          *
      *****************************************************************
     C     SRISTP        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
 
      *
      ** Call the specific validation module
      *
     C                   CALLB     'SEVSEISTP'
     C                   PARM                    ReturnCode
     C                   PARM                    MsgId1
     C                   PARM                    MsgData1
     C                   PARM                    LLLXISTP
     C                   PARM                    WWISTP
 
      *
      ** If an error was found
      *
     C                   IF        MsgId1 <> *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'LLLXISTP'
     C                   EVAL      MsgIDArr(Idx) = MsgId1
     C                   EVAL      MsgDtaArr(Idx) = MsgData1
     C                   ENDIF
 
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXISTP
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
     C                   ENDSR
 
      *****************************************************************
      * SRSETUP - Sets up the fields needed in the valid file record  *
      *****************************************************************
     C     SRSETUP       BEGSR
 
     C                   MOVE      L1FOTR        #LLXVVTOPR
 
     C                   MOVE      L1SESN        #LLXVVSESN
     C                   MOVE      WWISTP        #LLXVVISTP
 
     C                   ENDSR
 
      *****************************************************************
      * *INZSR - Program initialisation                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    ACTN
     C                   PARM                    DATALUX
     C                   PARM                    NwExScnFmt
     C                   PARM                    OKFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwExFilFmt
 
      *
      ** Move program name into *LDA field
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     PSProcPgm     DBPGM
     C                   OUT       LDA
 
     C                   ENDSR
 
      *****************************************************************
      *  Program, module and procedure names for database error       *
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
**  CPY@
(c) Copyright Misys International Banking Systems Ltd. 2005
