     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate secs statement base date')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Security Customer Details Val.*
      *                                                               *
      *  SDVCSBDM - Validate Statement Base Date                      *
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
     C                   EXSR      VSBDM
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDSBDMOK      IFEQ      'N'
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
     C     VSBDM         BEGSR
 
     C                   SELECT
 
 
      ***When*base*date*not*blank*and*classification*is*C*X*E*or*K*****                       CSE022
      ** When base date not blank and classification is C X or E                              CSE022
 
     C                   When      DDSBDM <> *BLANKS and (DDCLAS = 'C' or
     C**********                   DDCLAS = 'X' or DDCLAS = 'E' or                            CSE022
     C**********                   DDCLAS = 'K')                                              CSE022
     C                             DDCLAS = 'X' or DDCLAS = 'E')                              CSE022
 
      ** Err: 'S. base date must be blank unless class. is S D I or M
     C                   Eval      DDCLASOK = 'N'
     C                   Eval      DDSBDMOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDSBDM    '
     C                   Eval      MsgIdXAr(Idx) = 'USR0625'
     C
 
      ** When base date blank and frequency L M Q R S T X or Y
     C                   When      DDSBDM = *BLANKS and (DDSTFQ = 'L' or
     C                             DDSTFQ = 'M' or DDSTFQ = 'Q' or
     C                             DDSTFQ = 'R' or DDSTFQ = 'S' or
     C                             DDSTFQ = 'T' or DDSTFQ = 'X' or
     C                             DDSTFQ = 'Y')
 
      ** Default screen and file values
     C                   Eval      DDSBDM = '31'
     C                   Eval      BFSBDM = 31
 
      ** When base date is blank and frequency not L M Q R S T X or Y
     C                   When      DDSBDM = *BLANKS
     C                   Eval      BFSBDM = 0
 
      ** When base date not blank and frequency L M Q R S T X or Y
     C                   When      DDSBDM <> *BLANKS and (DDSTFQ = 'L' or
     C                             DDSTFQ = 'M' or DDSTFQ = 'Q' or
     C                             DDSTFQ = 'R' or DDSTFQ = 'S' or
     C                             DDSTFQ = 'T' or DDSTFQ = 'X' or
     C                             DDSTFQ = 'Y')
 
      ** Check that base date is numeric
     C                   Eval      WKSBDM = *BLANKS
     C                   Eval      WKSBDM = DDSBDM
     C                   CALL      'ZALIGN'
      ** Return Code
      ** Statement base date Message Field
      ** Number of Decimals
      ** Number of Digits
      ** Statement base date File Field
     C                   PARM                    ZRetCode          7
     C                   PARM                    WKSBDM           16
     C                   PARM      *ZERO         Decimals          1 0
     C                   PARM      2             Digits            2 0
     C                   PARM      *BLANK        WKSBDN           16
 
      ** Err: 'Value must be numeric'
 b3  C                   IF        ZRetCode <> *BLANKS
     C                   Eval      DDSBDMOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDSBDM    '
     C                   Eval      MsgIdXAr(Idx) = 'USR0822'
 
 x3  C                   ELSE
 
      ** Edit field to remove leading zeros
     C                   CALL      'ZEDIT'
      ** Statement base date Message Field
      ** Number of Decimals
     C                   PARM                    WKSBDN
     C                   PARM      *ZERO         Decimals
     C
      ** Test that base date is in range 1 - 31, pass to file fld
     C                   Z-ADD     0             WKTEST            2 0
     C                   MOVE      WKSBDN        WKTEST
     C                   IF        WKTEST >= 1 and WKTEST <= 31
     C                   MOVE      WKSBDN        BFSBDM
 
      ** Err: 'Statement base date should be in range 1 - 31'
     C                   ELSE
     C                   Eval      DDSBDMOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDSBDM    '
     C                   Eval      MsgIdXAr(Idx) = 'USR1497'
     C                   ENDIF
 
 e3  C                   ENDIF
 
      ** When base date not blank and frequency D F B A Z H P K G W or blank
     C                   When      DDSBDM <> *BLANKS and (DDSTFQ = 'D' or
     C                             DDSTFQ = 'F' or DDSTFQ = 'B' or
     C                             DDSTFQ = 'A' or DDSTFQ = 'Z' or
     C                             DDSTFQ = 'H' or DDSTFQ = 'P' or
     C                             DDSTFQ = 'K' or DDSTFQ = 'G' or
     C                             DDSTFQ = 'W' or DDSTFQ = *BLANKS)
 
      ** Err: 'Statement base date not allowed'
     C                   Eval      DDSBDMOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDSBDM    '
     C                   Eval      MsgIdXAr(Idx) = 'USR0262'
 
 
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
      ** Classification
     C                   PARM                    DDCLAS            1
      *
      ** Statement Base Date - alpha
     C                   PARM                    DDSBDM            2
      *
      ** Statement Frequency
     C                   PARM                    DDSTFQ            1
      *
      *
      * OUTPUTS
      *
      ** Statement Base Date - numeric
     C                   PARM                    BFSBDM            2 0
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Classification - OK
     C                   PARM                    DDCLASOK          1
      *
      ** Statement Base Date - OK
     C                   PARM                    DDSBDMOK          1
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
