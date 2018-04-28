     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR: Validate Contract Rate')                     *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Validation Module                            *
      *                                                               *
      *  IRVCNTRATE - Valdiate contract rate                          *
      *                                                               *
      *  Function:  This module accepts the contract rate as a 12A    *
      *             field and validates it using ZALIGN.              *
      *             If it is valid the 10A character field will be    *
      *             blank. If it is not the return field will contain *
      *             'Error'                                           *
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
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CAP003  *CREATE    Date 01Feb98               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
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
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **Contract rate passed as a parameter
     D   SCRTE         S             12A
 
      **Message ID returned to calling programme.
     D   Msgid1        S                   LIKE(#Msgid)
 
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
      **Field passed to ZALIGN for validation
     D   ZFIELD        S             16A
 
      **ZALIGN validation indicator
     D   ZALIGNok      S              1A
 
      **Decimal places field passed to ZALIGN
     D   ZADEC         S              1  0
 
      **Digital places field passed to ZALIGN
     D   ZADIG         S              2  0
 
      **Validated Contract Rate
     D   URTSPX        S             11  7
 
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
     C                   Z-ADD     0             @@AMT                                        245692
     C                   Z-ADD     0             @@ERCD                                       245692
     C*
     C* Validate contract rate
     C*
     C     SCRTE         IFEQ      *BLANK
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMA0017'     Msgid1
     C*
     C                   ELSE
     C*
     C**********         MOVE      *BLANKS       ZFIELD                                       245692
     C**********         Z-ADD     7             ZADEC                                        245692
     C**********         Z-ADD     4             ZADIG                                        245692
     C**********         MOVE      SCRTE         ZFIELD                                       245692
     C                   MOVE      *BLANKS       @@ALPH                                       245692
     C                   Z-ADD     7             @@IDP                                        245692
     C                   Z-ADD     4             @@IINT                                       245692
     C                   MOVE      SCRTE         @@ALPH                                       245692
     C                   MOVE      'N'           @@MTID                                       245692
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
     C**********         MOVE      ZFIELD        URTSPX                                       245692
     C                   MOVE      @@AMT         URTSPX                                       245692
     C                   ELSE
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMA0018'     Msgid1
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
     C                   PARM                    SCRTE
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
