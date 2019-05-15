     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR: Validate Floor and Ceiling rate (C/C/F)')    *
      *****************************************************************
      *                                                               *
      *  Midas - IRS Validation Module                                *
      *                                                               *
      *  IRVCLFLRAT - Validate ceiling and floor rates.               *
      *                                                               *
      *  Function:  This module accepts the floor and ceiling rate    *
      *             as parameters and confirms whether they are valid.*
      *             If they are not the 10A return code will contain  *
      *             'Error'. If they are it will contain blanks.      *
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
      *  Prev Amend No. AR1019919          Date 30Oct15               *
      *                 MD033488           Date 11Mar15               *
      *                 245692             Date 10Dec13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP055             Date 13Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 01Feb98               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1019919 - Negative Base Rate input. (Child: AR1019920)     *
      *              Applied for MD034478                             *
      *  MD033488 - Allow negative rates. Use program ZA0841 instead  *
      *             ZA0840. To accept a '-' sign to indicate input    *
      *             amount is negative.                               *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *  CAP055 - APIs for FRA/IRS Caps/Collars/Floors. Fix parameter *
      *           for ZALIGN: OK flag instead of Error flag.          *
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
 
      ** Ceiling rate passed from calling program as a parameter (SCLRAT)
     D  SCLRAT         S             12A
 
      **  Floor Rate passed from calling program as a parameter (SFLRAT)
     D   SFLRAT        S             12A
 
      ** New Deal type passed as a parameter from calling program
     D  NEWDT          S              2A
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Valid Ceiling rate passed back as a parameter to calling program
     D  CLRATX         S             11  7
 
      ** Valid Floor rate passed back as a parameter to calling program
     D  FLRATX         S             11  7
 
      ** 'Error found in ceiling rate validation' field used in module only
     D  ClRteError     S              1A
 
      ** 'Error found in floor rate validation' field used in module only.
     D  FlRteError     S              1A
 
      **  Work field pass to ZALIGN as a parameter
     D  ZFIELD         S             16A
 
      ** Decimal data length passed to ZALIGN as a parameter
     D  ZADEC          S              1  0
 
      ** Digital data length passed to ZALIGN as a parameter
     D  ZADIG          S              2  0
 
      ***Error*Flag*passed*back*from*ZALIGN*as*a*parameter                                    CAP055
     D**ErrorFlag******S              1A                                                      CAP055
                                                                                              CAP055
      ** OK Flag passed back from ZALIGN as a parameter                                       CAP055
     D  ZALIGNok       S              1A                                                      CAP055
 
      ** Error message passed back to calling program as a parameter
     D  Msgid1         S                   LIKE(#Msgid)
 
      ** Error message passed back to calling program as a parameter
     D  Msgid2         S                   LIKE(#Msgid)
                                                                                              245692
      ** Decimal separator                                                                    245692
     D BNDCSP          S              1A                                                      245692
                                                                                              245692
      ***Parameter*list*for*ZA0840*************************************              245692 MD033488
      ** Parameter list for ZA0841                                                          MD033488
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
      ***Error*return*code*for*ZA0840*module***************************              245692 MD033488
      ** Error return code for ZA0841 module                                                MD033488
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
 
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
     C                   MOVE      'N'           ClRteError
     C                   MOVE      'N'           FlRteError
 
      ** Validate Ceiling Rate.
     C                   Z-ADD     0             CLRATX           11 7
     C                   Z-ADD     0             @@AMT                                        245692
     C                   Z-ADD     0             @@ERCD                                       245692
     C     SCLRAT        IFNE      *BLANKS
     C**********         MOVE      *BLANKS       ZFIELD                                       245692
     C**********         MOVE      SCLRAT        ZFIELD                                       245692
     C**********         Z-ADD     7             ZADEC                                        245692
     C**********         Z-ADD     4             ZADIG                                        245692
     C                   MOVE      *BLANKS       @@ALPH                                       245692
     C                   MOVE      SCLRAT        @@ALPH                                       245692
     C                   Z-ADD     7             @@IDP                                        245692
     C                   Z-ADD     4             @@IINT                                       245692
     C                   MOVE      'N'           @@MTID                                       245692
     C                   MOVE      *BLANKS       @Rtcde                                    AR1019919
     C**********         CALLB     'ZALIGN'                                                   245692
     C**********         PARM                    ErrorFlag                                    CAP055
     C**********         PARM                    ZALIGNok                              CAP055 245692
     C**********         PARM                    ZFIELD                                       245692
     C**********         PARM                    ZADEC                                        245692
     C**********         PARM                    ZADIG                                        245692
     C**********         CALLB     'ZA0840'                                          245692 MD033488
     C                   CALLB     'ZA0841'                                                 MD033488
     C                   PARM                    @Rtcde                                       245692
     C                   PARM                    @@ALPH                                       245692
     C                   PARM                    @@IDP                                        245692
     C                   PARM                    @@IINT                                       245692
     C                   PARM                    @@MTID                                       245692
     C                   PARM                    @@ERCD                                       245692
     C                   PARM                    @@AMT                                        245692
     C                   PARM                    BNDCSP                                       245692
      *
     C*****ErrorFlag     IFEQ      'N'                                                        CAP055
     C*****ZALIGNok      IFEQ      'Y'                                                 CAP055 245692
     C     @@ERCD        IFEQ      0                                                          245692
     C**********         MOVE      ZFIELD        CLRATX                                       245692
     C                   MOVE      @@AMT         CLRATX                                       245692
     C                   END
      *
     C                   END
      *
     C* ONLY VALIDATE CEILING RATE IF DEAL IS NOT A FLOOR
     C*
     C     NEWDT         IFNE      'RF'
     C*
     C*****ErrorFlag     IFEQ      'Y'                                                        CAP055
     C*****ZALIGNok      IFEQ      'N'                                                 CAP055 245692
     C     @@ERCD        IFNE      0                                                          245692
     C     CLRATX        OREQ      0
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMA0052'     Msgid1
     C                   MOVE      'Y'           ClRteError
     C                   END
     C*
     C                   END
     C*
      *
      ** Validate Floor Rate.
     C                   Z-ADD     0             FLRATX           11 7
     C     SFLRAT        IFNE      *BLANKS
     C**********         MOVE      *BLANKS       ZFIELD                                       245692
     C**********         MOVE      SFLRAT        ZFIELD                                       245692
     C**********         Z-ADD     7             ZADEC                                        245692
     C**********         Z-ADD     4             ZADIG                                        245692
     C                   MOVE      *BLANKS       @@ALPH                                       245692
     C                   MOVE      SFLRAT        @@ALPH                                       245692
     C                   Z-ADD     7             @@IDP                                        245692
     C                   Z-ADD     4             @@IINT                                       245692
     C                   MOVE      'N'           @@MTID                                       245692
     C                   MOVE      *BLANKS       @Rtcde                                    AR1019919
     C**********         CALLB     'ZALIGN'                                                   245692
     C**********         PARM                    ErrorFlag                                    CAP055
     C**********         PARM                    ZALIGNok                              CAP055 245692
     C**********         PARM                    ZFIELD                                       245692
     C**********         PARM                    ZADEC                                        245692
     C**********         PARM                    ZADIG                                        245692
     C**********         CALLB     'ZA0840'                                          245692 MD033488
     C                   CALLB     'ZA0841'                                                 MD033488
     C                   PARM                    @Rtcde                                       245692
     C                   PARM                    @@ALPH                                       245692
     C                   PARM                    @@IDP                                        245692
     C                   PARM                    @@IINT                                       245692
     C                   PARM                    @@MTID                                       245692
     C                   PARM                    @@ERCD                                       245692
     C                   PARM                    @@AMT                                        245692
     C                   PARM                    BNDCSP                                       245692
      *
     C*****ErrorFlag     IFEQ      'N'                                                        CAP055
     C*****ZALIGNok      IFEQ      'Y'                                                 CAP055 245692
     C     @@ERCD        IFEQ      0                                                          245692
     C**********         MOVE      ZFIELD        FLRATX                                       245692
     C                   MOVE      @@AMT         FLRATX                                       245692
     C                   END
     C                   END
     C*
     C* ONLY VALIDATE FLOOR IF DEAL IS NOT A CAP
     C*
     C     NEWDT         IFNE      'RP'
     C*
     C*****ErrorFlag     IFEQ      'Y'                                                        CAP055
     C*****ZALIGNok      IFEQ      'N'                                                 CAP055 245692
     C     @@ERCD        IFNE      0                                                          245692
     C     FLRATX        OREQ      0
     C**********         MOVE      'Y'           ErrorFlag                                    CAP055
     C                   EVAL      ErrorFound = 'Y'                                           CAP055
     C                   MOVEL     'MMA0052'     MsgId2
     C                   MOVE      'Y'           FlRteError
     C                   ELSE
     C**********         MOVE      ZFIELD        FLRATX                                       245692
     C                   MOVE      @@AMT         FLRATX                                       245692
     C                   END
     C*
     C                   END
      *
     C* CROSS VALIDATE FLOOR & CEILING RATE ONLY IF DEAL IS A COLLAR
     C*
     C     NEWDT         IFEQ      'RR'
     C*
     C******IN30*********IFEQ******'0'*** Negative interest indicator
     C     ClRteError    ANDEQ     'N'
     C     FlRteError    ANDEQ     'N'
     C     SFLRAT        ANDNE     *BLANKS
      *
      *
     C*
     C     FLRATX        IFGE      CLRATX
     C*
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'MMA0053'     Msgid1
     C                   MOVE      'Y'           ClRteError
     C                   ELSE
     C**********         MOVE      ZFIELD        FLRATX                                       245692
     C                   MOVE      @@AMT         FLRATX                                       245692
     C                   END
      ****
     C                   END
     C*
 
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
     C                   PARM                    Msgid2
     C                   PARM                    SCLRAT
     C                   PARM                    SFLRAT
     C                   PARM                    NEWDT
     C                   PARM                    FLRATX
     C                   PARM                    CLRATX
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
(c) Finastra International Limited 2001
