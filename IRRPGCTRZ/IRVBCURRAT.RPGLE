     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Validate Base Currency Rate')                 *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS module                                       *
      *                                                               *
      *  IRVBCURRAT - Validate Base Currency Rate                     *
      *                                                               *
      *  Function:  This module receives a parameter containg the     *
      *             Base Currency Rate field and confirms whether     *
      *             it has a valid value.                             *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain 'Error'              *
      *                                                               *
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
      *  Prev Amend No. 262587             Date 17Sep10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 02Feb98               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *  262587 - Applied fix 221963.                                 *
      *  221963 - Only validate the Base Currency Equivalent Rate     *
      *           during amend if the value of the field had changed. *
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
      **Base Currency rate passed as a parameter to ZALIGN
     D   SUBCXR        S             14A
 
      **Currency entered checked against currency code,
     D   SUCUCY        S              3A
 
      **Currency code used as a check
     D   BJCYCD        S              3A
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      **
 
      **Base currency rate validated and passed back by ZALIGN
     D   UBCXRX        S             13  8
                                                                                              221963
      ** Base Currency work field                                                             221963
     D   W#UBCRX       S             13  8                                                    221963
 
      **Spot base rate
     D    A6SPRT       S             13  8
 
      **Higher level of currency rate
     D   H25           S             13  8
 
      **Lower rate of currency rate
     D   L25           S             13  8
 
      **ZALIGN error code returned
     D   ZALIGNok      S              1A
 
      **Standard data containing field for ZALIGN
     D   ZFIELD        S             16A
 
      **Decimal paramater passed to ZALIGN
     D    ZADEC        S              1  0
 
      **Digit parameter passed to ZALIGN
     D   ZADIG         S              2  0
 
 
      **Option parameter passed to ZALIGN
     D  ZAOPT          S              1A
 
      **Error message passed back to calling programme.
     D  Msgid1         S                   LIKE(#Msgid)
 
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
     C                   Z-ADD     0             @@AMT                                        245692
     C                   Z-ADD     0             @@ERCD                                       245692
 
      **Check that the Currency code is valid and not blanks
     C     SUBCXR        IFNE      *BLANKS
     C**********         MOVE      *BLANKS       ZFIELD                                       245692
      **
      **If valid validate and right align numeric field subcxr using ZALIGN
      **
     C**********         MOVEL     SUBCXR        ZFIELD                                       245692
     C**********         Z-ADD     8             ZADEC                                        245692
     C**********         Z-ADD     5             ZADIG                                        245692
     C                   MOVE      *BLANKS       @@ALPH                                       245692
     C                   MOVEL     SUBCXR        @@ALPH                                       245692
     C                   Z-ADD     8             @@IDP                                        245692
     C                   Z-ADD     5             @@IINT                                       245692
     C                   MOVE      'N'           @@MTID                                       245692
     C                   MOVE      'N'           ZAOPT
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
      **
      **If ZALIGN valid check Base Rate against Spot rate
      **
     C*****ZALIGNok      IFEQ      'Y'                                                        245692
     C     @@ERCD        IFEQ      0                                                          245692
      *                                                                                       221963
      ** Keep the current value of the field for comparison.                                  221963
      *                                                                                       221963
     C                   MOVE      UBCXRX        W#UBCRX                                      221963
     C**********         MOVE      ZFIELD        UBCXRX                                       245692
     C                   MOVE      @@AMT         UBCXRX                                       245692
      *                                                                                       221963
      ** Validate the field if the value had changed.                                         221963
      *                                                                                       221963
     C     UBCXRX        IFNE      W#UBCRX                                                    221963
      *                                                                                       221963
     C     SUCUCY        IFEQ      BJCYCD
     C     UBCXRX        ANDNE     1
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'MMM0412'     Msgid1
     C                   ELSE
     C     UBCXRX        IFNE      0
     C     A6SPRT        MULT      1.25          h25
     C     A6SPRT        MULT      0.75          L25
     C     UBCXRX        IFGT      H25
     C     UBCXRX        ORLT      L25
     C                   MOVEL     'Y'           ErrorFound
     C                   MOVEL     'MMA0009'     Msgid1
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                221963
     C                   ELSE
     C                   MOVEL     'Y'           ErrorFound
     C                   MOVEL     'MMA0009'     Msgid1
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     0             UBCXRX
     C                   ENDIF
 
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
     C                   PARM                    SUBCXR
     C                   PARM                    A6SPRT
     **Constants passed in by calling programme.
     C                   PARM                    SUCUCY
     C                   PARM                    BJCYCD
     C                   PARM                    UBCXRX
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
