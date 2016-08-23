     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate secs account sequence')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Securities Details Validation *
      *                                                               *
      *  SDVCACSN - Validate Account Sequence                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *  Prev Amend No. CAP039  *CREATE    Date 15Sep99               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL029 - Increase account code to 10 digits                  *
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
 
     D WKACSN          S              2S 0
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
 
      ** Account Code Entry Parameter                                                         CGL029
     D DDACCD          S             10A                                                      CGL029
                                                                                              CGL029
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
     C                   EXSR      VACSN
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDACSNOK      IFEQ      'N'
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
     C     VACSN         BEGSR
 
     C                   SELECT
 
      ** When account code is blank and account sequence is entered
 b1  C                   WHEN      DDACCD = *BLANKS and DDACSN <> *BLANKS
 
      ** Err: 'Account sequence not allowed if account code is not entered'
     C                   Eval      DDACSNOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDACSN    '
     C                   Eval      MsgIdXAr(Idx) = 'USR0255'
 
 
      ** When account code is entered and account sequence is blank
 b2  C                   WHEN      DDACCD <> *BLANKS and DDACSN = *BLANKS
 
      ** Initialise account sequence fields
     C                   Eval      DDACSN = ' 1'
     C                   Eval      WKACSN = 1
 
      ** When account code is entered and account sequence is entered
 b2  C                   WHEN      DDACCD <> *BLANKS and DDACSN <> *BLANKS
 
      ** Check that account sequence is numeric
     C                   Eval      WCACSN = *BLANKS
     C                   Eval      WCACSN = DDACSN
     C                   CALL      'ZALIGN'
      ** Return Code (7A)
      ** Account Sequence Message Field (16A)
      ** Number of Decimals (1,0)
      ** Number of Digits (2,0)
      ** Account Sequence File Field (16A)
     C                   PARM                    @RTCD             7
     C                   PARM                    WCACSN           16
     C                   PARM      *ZERO         DECIMALS          1 0
     C                   PARM      2             DIGITS            2 0
     C                   PARM      *BLANK        WKASNN           16
 
 b3  C     @RTCD         IFNE      *BLANK
 
      ** Err: 'Value must be numeric'
     C                   Eval      DDACSNOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDACSN    '
     C                   Eval      MsgIdXAr(Idx) = 'USR0822'
 
 x3  C                   ELSE
 
      ** Is numeric, edit
     C                   CALL      'ZEDIT'
      ** Account Sequence Message Field (16A)
      ** Number of Decimals (1,0)
     C                   PARM                    WKASNN
     C                   PARM      *ZERO         DECIMALS
 
     C                   MOVE      WKASNN        WKACSN
 
 e3  C                   ENDIF
 
     C                   OTHER
 
      ** Ensure file field value is set to zero
     C                   Eval      WKACSN = 0
 
     C                   ENDSL
 
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
      ** Account Code
     C************       PARM                    DDACCD            4                          CGL029
     C                   PARM                    DDACCD                                       CGL029
      *
      ** Account Sequence - alpha
     C                   PARM                    DDACSN            2
      *
      *
      * OUTPUTS
      *
      ** Account Sequence - numeric
     C                   PARM                    WKACSN
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Account Sequence - OK
     C                   PARM                    DDACSNOK          1
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
(c) Misys International Banking Systems Ltd. 2001
