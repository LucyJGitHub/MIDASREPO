     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR: Validate Spread rate')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Our/their spread rate validation routine             *
      *                                                               *
      *  IRVSPRRATE                                                   *
      *                                                               *
      *  Function:  This module validates the spread rate using       *
      *             ZALIGN and returns an error message in the        *
      *             return indicator or blank if there is no error.   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. 245692             Date 10Dec13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CAP055             Date 13Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 01Feb98               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *  CAP055 - APIs for FRA/IRS Caps/Collars/Floors                *
      *  CAP003 - Conversion of IR inputs into modular structure to   *
      *           use as APIs.                                        *
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * spread rate
     D SURTSP          S             12A
 
      * interest payment frequency
     D SUIPFR          S              1A
 
      * base rate code
     D SUBRTT          S              1A
 
      * returns 'Y' or 'N' depending on whether validation has been successful
     D ZALIGNok        S              1A
 
      * interst rate calendars.
     D CIR001          S              1A
 
      *  Error message code 1 received as a parameter
     D Msgid1          S                   LIKE(#MsgID)
 
      *  A 16 character alphanumeric field to contain numeric input
      *  The field may contain leading and trailing blanks and a
      *  decimal point,and may have up to 15 digits.
     D ZFIELD          S             16A
 
      *  contains the required number of digits before the decimal
      *  point as a constant.
     D ZADEC           S              1P 0
 
      * contains required number of digits before the decimal point as
      * a constant in program.
     D ZADIG           S              2P 0
 
     D PDealType       S              2                                                       CAP055
                                                                                              CAP055
                                                                                              245692
      ** Decimal separator                                                                    245692
     D BNDCSP          S              1A                                                      245692
                                                                                              245692
      ** Parameter list for ZA0840                                                            245692
      ** =========================                                                            245692
      ** Return code for numeric validation module call                                       245692
     D @Rtcde          S             10A                                                      245692
      ** Alpha field for numeric validation                                                   245692
     D @@ALPH          S             16A                                                      245692
      ** Number of decimal places field for numeric validation                                245692
     D @@IDP           S              2  0                                                    245692
      ** Number of integers field for numeric validation                                      245692
     D @@IINT          S              2  0                                                    245692
      ** Millions/Thousands id (Y=function on)                                                245692
     D @@MTID          S              1A                                                      245692
      ** Amount calculation field                                                             245692
     D @@AMT           S             15  0                                                    245692
      ** Error return code for ZA0840 module                                                  245692
     D @@ERCD          S              1  0                                                    245692
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
      ** Reset the error flag to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
 
      ** Validate Spread/Rate using ZALIGN.
 
     C                   Z-ADD     0             URTSPX           11 7
     C                   Z-ADD     0             @@AMT                                        245692
     C                   Z-ADD     0             @@ERCD                                       245692
     C     SURTSP        IFNE      *BLANKS
     C**********         MOVE      *BLANKS       ZFIELD                                       245692
     C**********         Z-ADD     7             ZADEC                                        245692
     C**********         Z-ADD     4             ZADIG                                        245692
     C**********         MOVEL     SURTSP        ZFIELD                                       245692
     C                   MOVE      *BLANKS       @@ALPH                                       245692
     C                   MOVEL     SURTSP        @@ALPH                                       245692
     C                   Z-ADD     7             @@IDP                                        245692
     C                   Z-ADD     4             @@IINT                                       245692
     C                   MOVE      'N'           @@MTID                                       245692
     C                   MOVE      'N'           ZAOPT             1
     C**********         CALLB     'ZALIGN'                                                   245692
     C**********         PARM                    ZALIGNok                                     245692
     C**********         PARM                    ZFIELD                                       245692
     C**********         PARM                    ZADEC                                        245692
     C**********         PARM                    ZADIG                                        245692
     C                   CALLB     'ZA0840'                                                   245692
     C                   PARM                    @Rtcde                                       245692
     C                   PARM                    @@ALPH                                       245692
     C                   PARM                    @@IDP                                        245692
     C                   PARM                    @@IINT                                       245692
     C                   PARM                    @@MTID                                       245692
     C                   PARM                    @@ERCD                                       245692
     C                   PARM                    @@AMT                                        245692
     C                   PARM                    BNDCSP                                       245692
     C*****ZALIGNok      IFEQ      'Y'                                                        245692
     C     @@ERCD        IFEQ      0                                                          245692
 
      **  Send error message if user entered a zero spread.
 
     C                   Z-ADD     0             SRNUMB           12 0
     C**********         MOVE      ZFIELD        SRNUMB                                       245692
     C                   MOVE      @@AMT         SRNUMB                                       245692
     C     SRNUMB        IFEQ      0
 
     C** spread/rate must not be equal to zero if switchable
     C**   feature is OFF OR interest payment frequency <> 'C'
      ** If entered, spread rate cannot be '0' for Caps/Collars/Floors                        CAP055
      ** regardless of the interest payment frequency                                         CAP055
 
     C     CIR001        ANDEQ     'N'
     C     SRNUMB        OREQ      0
     C     CIR001        ANDEQ     'Y'
     C     SUIPFR        ANDNE     'C'
     C     SRNUMB        OREQ      *ZERO                                                      CAP055
     C     PDealType     ANDEQ     'RP'                                                       CAP055
     C     SRNUMB        OREQ      *ZERO                                                      CAP055
     C     PDealType     ANDNE     'RR'                                                       CAP055
     C     SRNUMB        OREQ      *ZERO                                                      CAP055
     C     PDealType     ANDNE     'RF'                                                       CAP055
     C                   MOVE      'MMA0021'     Msgid1
     C                   MOVE      'Y'           ErrorFound
     C                   ELSE
     C**********         MOVE      ZFIELD        URTSPX                                       245692
     C                   MOVE      @@AMT         URTSPX                                       245692
 
     C** spread/rate must be zero if int payment frequency is 'C'
      ** Except for Caps/Collars/Floors, this is not applicable                               CAP055
 
     C     CIR001        IFEQ      'Y'
     C     URTSPX        ANDNE     *ZERO
     C     SUIPFR        ANDEQ     'C'
     C     PDealType     ANDNE     'RP'                                                       CAP055
     C     PDealType     ANDNE     'RR'                                                       CAP055
     C     PDealType     ANDNE     'RF'                                                       CAP055
     C                   MOVE      'MMA0022'     Msgid1
     C                   MOVE      'Y'           ErrorFound
     C                   END
     C                   ENDIF
 
     C                   ELSE
     C                   MOVE      'MMA0023'     Msgid1
     C                   MOVE      'Y'           ErrorFound
     C                   END
     C                   END
 
      **  base rate code and spread/rate must not be blank
      **     if CIR001 is OFF or CIR001 is ON and payment frequency
      **     is not 'C'
      ** For Caps/Collars/Floors, Spread rate may be blank/is optional                        CAP055
 
     C     CIR001        IFEQ      'N'
     C     CIR001        OREQ      'Y'
     C     SUIPFR        ANDNE     'C'
     C     ErrorFound    IFEQ      'N'
     C     SUBRTT        ANDEQ     *BLANKS
     C     SURTSP        ANDEQ     *BLANKS
     C     PDealType     ANDNE     'RP'                                                       CAP055
     C     PDealType     ANDNE     'RR'                                                       CAP055
     C     PDealType     ANDNE     'RF'                                                       CAP055
     C                   MOVE      'MMA0020'     Msgid1
     C                   MOVE      'Y'           ErrorFound
     C                   END
     C                   END
 
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    SURTSP
     C                   PARM                    CIR001
     C                   PARM                    SUIPFR
     C                   PARM                    SUBRTT
     C                   PARM                    PDealType                                    CAP055
     C                   PARM                    URTSPX
     C                   PARM                    BNDCSP                                       245692
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
