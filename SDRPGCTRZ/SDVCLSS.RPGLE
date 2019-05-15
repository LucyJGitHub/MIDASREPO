     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate CLS settlement & effective date')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Customer Details Validation   *
      *                                                               *
      *  SDVCLSS  - Validate CLS Settlement and Effective Date        *
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
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. 189507             Date 02Feb01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008  *CREATE    Date 02May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  189507 - Change setup of CLS fields in Customer details      *
      *           and FX deals input                                  *
      *  CDL008 - Continuous Linked Settlement                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the
      ** size of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **---------------------------------------------------------------
 
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message IDs, etc.
     D Idx             S              3P 0
 
      ** Index for arrays of warning message IDs, etc.
     D WIx             S              3P 0
 
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
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Initialise parameters
 
     C                   MOVE      *BLANKS       RetCodeIn
     C                   MOVE      *BLANKS       FldNamXAr
     C                   MOVE      *BLANKS       MsgIDXAr
     C                   MOVE      *BLANKS       MsgDtaXAr
     C                   MOVE      *BLANKS       WFldNmXAr
     C                   MOVE      *BLANKS       WMsgIDXAr
     C                   MOVE      *BLANKS       WMsgDtXAr
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIx
 
      ** Validate 'CLS Settlement'
 
     C                   EXSR      SR_CLSS
 
      ** If an error has occurred, set the Return Code.
 
     C     DDCLSSOK      IFEQ      'N'
     C                   EVAL      RetCodeIn  = 'Error'
     C                   ENDIF
 
      ** Validate 'Effective Date'
 
     C                   EXSR      SR_EFDT
 
      ** If an error has occurred, set the Return Code.
 
     C     DDEFDTOK      IFEQ      'N'
     C                   EVAL      RetCodeIn  = 'Error'
     C                   ENDIF
 
      ** Return to calling program
 
     C                   RETURN
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR_CLSS - Validate CLS Settlement                             *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SR_CLSS       BEGSR
 
      ***If*Default*CLS*by*Customer*=*'Y'*validate*CLS*Settlement,***                         189507
      ***must*be*'Y',*'N'*or*blank.***                                                        189507
      ***********                                                                             189507
     C*****DefaultCLS    IFEQ      'Y'                                                        189507
     C     DDCLSS        IFNE      'Y'
     C     DDCLSS        ANDNE     'N'
     C     DDCLSS        ANDNE     *BLANK
     C                   MOVE      'N'           DDCLSSOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCLSS'      FldNamXAr(Idx)
     C                   MOVEL     'USR4577'     MsgIdXAr(Idx)
     C                   ENDIF
 
      ***Else,*if*Default*CLS*by*Customer*<>*'Y',*issue*warning*message                       189507
      ***if*user*has*entered*a*value*for*CLS*Settlement***                                    189507
      ***********                                                                             189507
     C***********        ELSE                                                                 189507
     C*****DDCLSS        IFNE      'N'                                                        189507
     C*****DDCLSS        ANDNE     *BLANK                                                     189507
     C***********        MOVE      'W'           DDCLSSOK                                     189507
     C***********        ADD       1             WIx                                          189507
     C***********        MOVEL     'DDCLSS'      WFldNmXAr(WIx)                               189507
     C***********        MOVEL     'USR4587'     WMsgIdXAr(WIx)                               189507
     C***********        ENDIF                                                                189507
     C***********        ENDIF                                                                189507
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR_EFDT - Validate Effective Date                             *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SR_EFDT       BEGSR
 
      ***If*Default*CLS*by*Customer*=*'Y'*validate*Effective*Date***                          189507
      ***********                                                                             189507
     C*****DefaultCLS    IFEQ      'Y'                                                        189507
 
     C     DDCLSS        IFEQ      'Y'
 
     C     DDEFDT        IFEQ      *BLANKS
     C                   MOVE      'N'           DDEFDTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDEFDT'      FldNamXAr(Idx)
     C                   MOVEL     'USR4588'     MsgIdXAr(Idx)
     C                   ELSE
     C                   CALLB     'ZDATE1'
     C                   PARM      DDEFDT        ZDATIN            6
     C                   PARM      *ZEROS        ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1
     C     ErrorFlag     IFEQ      'Y'
     C                   MOVE      'N'           DDEFDTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDEFDT'      FldNamXAr(Idx)
     C                   MOVEL     'USR4578'     MsgIdXAr(Idx)
     C                   ELSE
     C                   Z-ADD     ZDAYNO        CUEFDT
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C     DDEFDT        IFEQ      *BLANK
     C                   Z-ADD     *ZERO         CUEFDT
     C                   ELSE
     C                   MOVE      'N'           DDEFDTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDEFDT'      FldNamXAr(Idx)
     C                   MOVEL     'USR4589'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
      ***Else,*if Default*CLS*by*Customer*<>*'Y',*issue*warning*message                       189507
      ***if*user*has*entered*a*value*for*Effective Date***                                    189507
      ***********                                                                             189507
     C***********        ELSE                                                                 189507
     C*****DDEFDT        IFNE      *BLANKS                                                    189507
     C***********        MOVE      'W'           DDEFDTOK                                     189507
     C***********        ADD       1             WIx                                          189507
     C***********        MOVEL     'DDEFDT'      WFldNmXAr(WIx)                               189507
     C***********        MOVEL     'USR4587'     WMsgIdXAr(WIx)                               189507
     C***********        ENDIF                                                                189507
     C***********        ENDIF                                                                189507
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR  - Program Initialisation routine                      *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
 
      ** Received Parameters
      ** -------------------
 
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** CLS Settlement Screen field (1A)
      ** Effective Date Screen field (6A)
 
     C                   PARM                    DDCLSS            1
     C                   PARM                    DDEFDT            6
 
      ***Default*CLS*by*Customer*(1A)***                                                      189507
      ***********                                                                             189507
     C***********        PARM                    DefaultCLS        1                          189507
 
      ** Date Format Indicator (1A)
 
     C                   PARM                    BJDFIN            1
 
      ** Returned Parameters
      ** -------------------
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
      ** CLS Settlement - OK
      ** Effective Date - OK
 
     C                   PARM                    DDCLSSOK          1
     C                   PARM                    DDEFDTOK          1
 
      ** Effective Date in Midas day number format (5,0)
 
     C                   PARM                    CUEFDT            5 0
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      **-------------------------------------------------------------------+
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **-------------------------------------------------------------------+
      ********************************************************************
 
**  CPY@
(c) Finastra International Limited 2001
