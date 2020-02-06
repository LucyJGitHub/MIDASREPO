     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate secs position sett't charge grp')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Security Customer Details Val.*
      *                                                               *
      *  SDVCPSCG - Validate Position Settlement Charge Group         *
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
      *  Prev Amend No. CSE022             Date 29Mar01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP039  *CREATE    Date 15Sep99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSE022 - Depository Definition Enhancement                   *
      *  CAP039 - Conversion of SD inputs to modular structure        *
      *           to use as APIs                                      *
      *****************************************************************
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SECUGR        E DS                  EXTNAME(SECUGRPD)
      ** External DS for SE customer charge groups
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS for access program
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
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
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
 
      *
      ** VALIDATION
      *
     C                   EXSR      VPSCG
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDPSCGOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION
      *****************************************************************
     C     VPSCG         BEGSR
 
      ** Query processing
     C                   MOVEL     DDPSCG        QueryFld          1
     C     QueryFld      IFEQ      '?'
     C                   CALL      'AOCUGRR0'
     C                   PARM                    RetCode           7
     C                   PARM      '*KEY'        Option            7
     C                   PARM                    DDPSCG
     C     SECUGR        PARM      SECUGR        DSSDY
     C                   ENDIF
 
      ** If Private Banking Securities Trading Enhancement is on
     C                   IF        S01496 = 'Y'
 
     C                   SELECT
 
      ***When*PSC*Group*is*entered*and*classification*is*C*X*E*I*or*K**                       CSE022
      ** When PSC Group is entered and classification is C X E or I                           CSE022
 
     C                   WHEN      DDPSCG <> *BLANKS and (DDCLAS = 'C' or
     C                             DDCLAS = 'X' or DDCLAS = 'E' or
     C**********                   DDCLAS = 'I' or DDCLAS = 'K')                              CSE022
     C                             DDCLAS = 'I')                                              CSE022
 
      ** Err: 'Postion settlement charge group must be left blank'
     C                   Eval      DDPSCGOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDPSCG    '
     C                   Eval      MsgIdXAr(Idx) = 'USR2593'
 
      ** Check that position settlement charge group is on file
     C                   WHEN      DDPSCG <> *BLANKS
     C                   CALL      'AOCUGRR0'
     C                   PARM                    ARetCode          7
     C                   PARM      '*VERIFY'     OPTION            7
     C                   PARM                    DDPSCG
     C     SECUGR        PARM      SECUGR        DSSDY
 
      ** Err: 'Position settlement charge group does not exist'
     C                   IF        ARetcode <> *BLANKS
     C                   Eval      DDPSCGOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDPSCG    '
     C                   Eval      MsgIdXAr(Idx) = 'USR2595'
     C                   ENDIF
      ** When PSC group is blank and classification is D M or S
     C                   WHEN      DDPSCG = *BLANKS and (DDCLAS = 'D' or
     C                             DDCLAS = 'M' or DDCLAS = 'S')
 
      ** Err: 'Position settlement charge group must be entered'
     C                   Eval      DDPSCGOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDPSCG    '
     C                   Eval      MsgIdXAr(Idx) = 'USR2596'
 
     C                   ENDSL
 
     C                   ENDIF
     C
     C     ENDVAL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Private Banking Securities Trading Enhancement
     C                   PARM                    S01496            1
      *
      ** Classification
     C                   PARM                    DDCLAS            1
      *
      ** Position Settlement Charge Group
     C                   PARM                    DDPSCG            2
      *
      *
      * OUTPUTS
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Position Settlement Charge Group - OK
     C                   PARM                    DDPSCGOK          1
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
