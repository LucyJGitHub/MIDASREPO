     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate secs next statement date')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Security Customer Details Val.*
      *                                                               *
      *  SDVCSNSD - Validate Next Statement Date                      *
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
      *  Prev Amend No. BUG21078           Date 17Sep08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01.03 ----------------------------------------*
      *                 210462             Date 14Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP039  *CREATE    Date 15Sep99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG21078 - Apply fix BUG14245                                *
      *  BUG14245 - Frequency Statement Validation should be done     *
      *             when clicking complete/confirm complete button    *
      *  210462 - Not possible to update customer security if next    *
      *           statement date is equal to rundat.                  *
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
 
     D DaysArr         S              2    DIM(12) CTDATA PERRCD(12)
 
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
     C                   EXSR      VSNSD
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDSNSDOK      IFEQ      'N'
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
     C     VSNSD         BEGSR
 
      ***If*classification*is*C*X*E*K*and*statement*date*is*not*blank**                       CSE022
      ** If classification is C X E and statement date is not blank                           CSE022
 
     C                   IF        (DDCLAS = 'C' or DDCLAS = 'X' or
     C**********                   DDCLAS = 'E' or DDCLAS = 'K') and                          CSE022
     C                             DDCLAS = 'E') and                                          CSE022
     C                             DDSNSD <> *BLANKS
 
      ** Err: 'Next statement date must be blank unless classification is
      ** S D I or M'
     C                   Eval      DDSNSDOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDSNSD    '
     C                   Eval      MsgIdXAr(Idx) = 'USR0600'
     C                   ENDIF
 
      ** If classification is S D I. Statement Frequency should not be blank                BUG14245
                                                                                            BUG14245
     C                   IF        (DDCLAS = 'S' or DDCLAS = 'D' or                         BUG14245
     C                              DDCLAS = 'I') and                                       BUG14245
     C                              DDSTFQ = *BLANKS                                        BUG14245
                                                                                            BUG14245
      ** Err: 'Statement Frequency Required if classification is                            BUG14245
      ** I D or S'                                                                          BUG14245
     C                   Eval      DDSTFQOK = 'N'                                           BUG14245
     C                   Eval      Idx = Idx + 1                                            BUG14245
     C                   Eval      FldNamXAr(Idx) = 'DDSTFQ    '                            BUG14245
     C                   Eval      MsgIdXAr(Idx) = 'USR0267'                                BUG14245
     C                   ENDIF                                                              BUG14245
 
      ** If next statement date is not blank and statement frequency is *B
     C                   IF        DDSNSD <> *BLANK and DDSTFQ = *BLANK
 
      ** Err: 'Next statment date not allowed if statment freq. is blank'
     C                   Eval      DDSNSDOK = 'N'
     C                   Eval      DDSTFQOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDSNSD    '
     C                   Eval      MsgIdXAr(Idx) = 'USR0258'
     C                   ENDIF
 
      ** If next statement date is not blank and statement freq not blank
     C                   IF        DDSNSD <> *BLANK and DDSTFQ <> *BLANK
 
     C                   Eval      ZDATEA = DDSNSD
     C                   EXSR      ZDATE1
 
      ** If next statement date is not a valid date
     C                   IF        ErrorFlag = 'Y'
 
      ** Err: 'The date entered is invalid'
     C                   Eval      DDSNSDOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDSNSD    '
     C                   Eval      MsgIdXAr(Idx) = 'USR1040'
     C                   ELSE
 
      ***If*next*statement*date*is*less*than*or*equal*to*the*run*date*******                  210462
      *                                                                                       210462
      ** If next statement date is less than run date                                         210462
      *                                                                                       210462
     C**********         IF        ZDAYNO <= BJRDNB                                           210462
     C                   IF        ZDAYNO <  BJRDNB                                           210462
 
      ** Err: 'Invalid next statement date, must be greater than run date'
     C                   Eval      DDSNSDOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDSNSD    '
     C                   Eval      MsgIdXAr(Idx) = 'USR0259'
 
     C                   ELSE
 
     C                   Eval      BFSNSD = ZDAYNO
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** If (classification is D or S) and next statment date is blank
     C                   IF        (DDCLAS = 'D' or DDCLAS = 'S') and
     C                             DDSNSD = *BLANKS
     C
      ** Default next statment date
      ** Ensure default date fits date format and leap year requirements
 
      ** Convert Midas day number to 6 alpha date field
     C                   MOVE      BJRDNB        ZDAYNO
     C                   EXSR      ZDATE2
 
      ** Break date into 2 char day, month and year fields
     C                   IF        BJDFIN = 'D'
     C                   MOVEL     ZDATE         DDMM              4
     C                   MOVEL     DDMM          Day               2
     C                   MOVE      DDMM          Month             2
     C                   MOVE      ZDATE         Year              2
     C                   ELSE
     C                   MOVEL     ZDATE         MMDD              4
     C                   MOVEL     MMDD          Month
     C                   MOVE      MMDD          Day
     C                   MOVE      ZDATE         Year
     C                   ENDIF
 
      ** Set day field to last day of the month
     C                   MOVE      Month         I                 2 0
     C                   Eval      Day = DaysArr(I)
 
      ** If month is February
     C                   IF        Month = '02'
 
      ** Set day to 29 if leap year
     C                   MOVE      Year          YearN             2 0
     C     YearN         DIV       4             Result            1 0
     C                   MVR                     Remainder         1 0
     C                   IF        Remainder = 0
     C                   Eval      Day = '29'
     C                   ENDIF
 
     C                   ENDIF
 
 
      ** Rebuild default date from 2 char day, month and year fields
     C                   MOVE      *ZEROS        LastDay           6
     C                   IF        BJDFIN = 'D'
     C                   MOVEL     Day           DDMM
     C                   MOVE      Month         DDMM
     C                   MOVE      Year          LastDay
     C                   MOVEL     DDMM          LastDay
     C                   ELSE
     C                   MOVEL     Month         MMDD
     C                   MOVE      Day           MMDD
     C                   MOVE      Year          LastDay
     C                   MOVEL     MMDD          LastDay
     C                   ENDIF
 
      ** Get day number of defaulted last statement date
     C                   Eval      ZDATEA = LastDay
     C                   EXSR      ZDATE1
 
      ** Set file and screen fields
     C                   Z-ADD     ZDAYNO        BFSNSD
     C                   Eval      DDSNSD = LastDay
 
     C                   ENDIF
 
      ** If (classification is not D or S) and next statment date is blank
     C                   IF        (DDCLAS <> 'D' and DDCLAS <> 'S') and
     C                             DDSNSD = *BLANKS
      ** Set file field
     C                   Z-ADD     0             BFSNSD
     C                   ENDIF
 
     C     ENDVAL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZDATE1 - Validate & convert date to a day number             *
      *                                                               *
      *****************************************************************
     C     ZDATE1        BEGSR
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEA            6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZDATE2 - Validate & convert day number to a date             *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    DATEB             7
 
     C                   ENDSR
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
      ** Next Statement Date - alpha
     C                   PARM                    DDSNSD            6
      *
      ** Classification
     C                   PARM                    DDCLAS            1
      *
      ** Statement Frequency
     C                   PARM                    DDSTFQ            1
      *
      ** Date Format Indicator
     C                   PARM                    BJDFIN            1
      *
      ** Run Day Number
     C                   PARM                    BJRDNB            5 0
      *
      *
      * OUTPUTS
      *
      *
      ** Next Statement Date - day number
     C                   PARM                    BFSNSD            5 0
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Next Statement Date - OK
     C                   PARM                    DDSNSDOK          1
      *
      ** Statement Frequency - OK
     C                   PARM                    DDSTFQOK          1
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
** DaysArr
312831303130313130313031
