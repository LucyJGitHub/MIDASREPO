     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Validate Short Term Rate  (Caps/Collars)')
      *****************************************************************
      *                                                               *
      *  Midas - Short term rate for caps, collars and floors.        *
      *                                                               *
      *  IRVCCFSTR                                                    *
      *                                                               *
      *  Function:  This module accepts a parameter containing the    *
      *             Short term rate field and confirms whether it     *
      *             has a valid value.
      *             If it is valid the return code will be blank.     *
      *             If it is not it will contain 'Error'.             *
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
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Last Amend No. CAP003  *CREATE    Date 16Feb98               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
 
      ** base rate type indicator
     D STBRTTok        S              1A
 
      ** value date indicator
     D VDATXok         S              1A
 
      ** average rate method indicator
     D SAVRAMok        S              1A
 
      ** currency indicator
     D SuCucyOK        S              1A
 
      ** short term rate indicator
     D SWORKRok        S              1A
 
      ** floating rate fix days indicator
     D SCFRFDok        S              1A
 
      ** average rate method passed as parameter
     D SAVRAM          S              1A
 
      * run day number
     D BJRDNB          S              5  0
 
      * ref short term rate/current average
     D SWORKR          S             12A
 
      ** Valid value date for DLBACK
     D ZINDT           S              5  0                                      S01117
 
      ** Rate fix days used by DLBACK
     D ZRFDY           S              5  0                                      S01117
 
      ** Rate fix date used by DLBACK
     D ZRFDT           S              5  0                                      S01117
 
      ** Valid rate fix days
     D UFRFDX          S              2  0                                      S01117
 
      **Decimal data length passed as a parameter to ZALIGN
     D   ZADEC         S              1  0
 
      **Digital data length passed as a parameter to ZALIGN
     D   ZADIG         S              2  0
 
      **Field Passed to ZALIGN on which the work is done
     D   ZFIELD        S             16A
 
      **Indicator to show whether or not ZALIGN was successful
     D   ZALIGNok      S              1A
 
      **Error message passed back to calling programme
     D   Msgid1        S                   LIKE(#msgid)
 
      **'Currency for rate fix holiday' flag from FRA/IRS I.C.D. passed as parameter
     D   BQCRFH        S              1A
 
      **Currency field for DLBACK
     D   ZCCY          S              3A
 
      **Currency field passed as a parameter from calling program
     D   SUCUCY        S              3A
 
      **Local currency code passed to program as parameter
     D   BJLCCY        S              3A
 
      **System Location code passed as a parameter
     D   BJSLCD        S              3A
 
      **Currency code passed to program as parameter
     D   BLCYCD        S              3A
 
      *Day number for holiday passed as parameter
     D   ZDAYNO        S              5P 0
 
      **Holiday Check indicator passed from ZCHKH
     D   ZIND          S              1A
 
      **Valid Value date passed as a parameter
     D   VDATX         S              5  0
 
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
     C*
     C* SHORT TERM RATE
     C*
     C                   Z-ADD     0             WORK2X           11 7
     C     STBRTTok      IFEQ      'Y'
     C     VDATXok       ANDEQ     'Y'
     C     SAVRAMok      ANDEQ     'Y'
     C     SUCUCYok      ANDEQ     'Y'
     C     SWORKRok      ANDEQ     'Y'
     C*
     C     SAVRAM        IFEQ      'Y'
     C     VDATX         IFLT      BJRDNB
     C     SWORKR        IFEQ      *BLANKS
     C                   MOVE      'MMA0054'     Msgid1
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'N'           SWORKRok
     C                   END
     C                   END
      *
     C                   ELSE
      *
     C     SCFRFDok      IFEQ      'Y'
     C                   Z-ADD     VDATX         ZINDT
     C                   Z-ADD     UFRFDX        ZRFDY
      *
      ** If 'currency for rate fix holiday' flag from FRA/IRS I.C.D.
      ** is 'F', 'L' or 'D', set currency code to 'sterling code',
      ** 'local currency code' or 'screen currency code' respectively
      *
     C     BQCRFH        IFEQ      'F'
     C                   MOVE      BLCYCD        ZCCY
     C                   ENDIF
      *
     C     BQCRFH        IFEQ      'L'
     C                   MOVE      BJLCCY        ZCCY
     C                   ENDIF
      *
     C     BQCRFH        IFEQ      'D'
     C     BQCRFH        OREQ      ' '
     C                   MOVE      SUCUCY        ZCCY
     C                   ENDIF
     C                   EXSR      DLBACK
     C     ZRFDT         IFLT      BJRDNB
     C     SWORKR        ANDEQ     *BLANKS
     C                   MOVE      'MMA0055'     Msgid1
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'N'           SWORKRok
     C                   END
     C                   END
     C                   END
     C                   END
      *
     C     SWORKRok      IFEQ      'N'
     C     SWORKR        ANDNE     *BLANKS
     C                   Z-ADD     7             ZADEC
     C                   Z-ADD     4             ZADIG
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      SWORKR        ZFIELD
     C                   MOVE      'N'           ZAOPT             1
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        WORK2X
     C                   ELSE
     C                   MOVE      'MMA0034'     Msgid1
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'N'           SWORKRok
     C                   MOVE      'N'           ZALIGNok
     C                   END
     C                   END
 
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
     C                   RETURN
 
      *****************************************************************
     C*   SR: DLBACK - TO CALCULATE RATE FIX DATE FOR FRA/IRS         *
     C*****************************************************************
     C     DLBACK        BEGSR
     C*
     C* INPUT FIELD ZLOC CONTAINS THE RELEVANT BRANCH LOCATION
     C*
     C**  Initialise Work Field
     C                   Z-ADD     ZINDT         ZINDT             5 0
     C                   Z-ADD     ZRFDY         ZRFDY             5 0
     C                   MOVE      ZCCY          ZCCY              3
     C                   Z-ADD     0             ZWKFLD            5 0
     C                   MOVE      ZLOC          ZLOC              3
 
     C**  Set Rate Fix Date equal to Input Date
     C                   Z-ADD     ZINDT         ZRFDT             5 0
 
     C**  Perform the following processing until the work field is
     C**  greater than or equal to the Rate Fix Days
     C     ZWKFLD        DOUGE     ZRFDY
 
     C**  If the Rate Fix Days are not equal to zero subtract 1
     C**  from the Rate Fix Date
     C     ZRFDY         IFNE      0
     C                   SUB       1             ZRFDT
     C                   END
 
     C*   The following is repeated until the resultant date is
     C*   proved to be a working day in the relevant currency and
     C*   location.
     C*   Uses ZCHKH to check Rate Fix Date for a holiday
     C*
     C     ZIND          DOUEQ     'W'
     C                   Z-ADD     ZRFDT         ZDAYNO
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
     C                   PARM                    ZIND
 
     C* If date is a holiday (ZIND = 'H')
     C* subtract 1 from rate fix date
 
     C     ZIND          IFEQ      'H'
     C                   SUB       1             ZRFDT
     C                   END
     C                   END
     C*
     C**  When a working day has been found, add 1 to the Work Field
     C                   ADD       1             ZWKFLD
     C                   END
     C*
     C                   ENDSR
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
     C                   PARM                    STBRTTok
     C                   PARM                    VDATXok
     C                   PARM                    SAVRAMok
     C                   PARM                    SUCUCYok
     C                   PARM                    SWORKRok
     C                   PARM                    SCFRFDok
     C                   PARM                    SAVRAM
     C                   PARM                    SWORKR
     C                   PARM                    VDATX
     C                   PARM                    UFRFDX
     C                   PARM                    BJLCCY
     C                   PARM                    BLCYCD
     C                   PARM                    BQCRFH
     C                   PARM                    SUCUCY
     C                   PARM                    BJRDNB
     C                   PARM                    ZRFDT
 
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
