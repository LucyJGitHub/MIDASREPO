     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Validate int pay frequency day in month')
      *****************************************************************
      *                                                               *
      *  Midas - IRS Validation Module                                *
      *                                                               *
      *  IRVINTPYDY - Validate our/their interest payment frequency   *
      *               day in month.                                   *
      *                                                               *
      *  Function:  This module validates their interest payment      *
      *             frequency day in month and returns an indicator   *
      *             which contains 'Error' if an error is found or    *
      *             is blank otherwise.                               *
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
      * Midas DBA 3.02 -----------------------------------------------*
      *  Last Amend No. 163863             Date 08Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CAP003  *CREATE    Date 01Feb98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  163863 - Correct Month Day Number defaulting                 *
      *  CAP003 - Conversion of MM inputs into modular structure to   *
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
 
      **ZALIGN indicator passed back from ZALIGN as parameter
     D   ZALIGNok      S              1A
 
      **Rate fix days passed as a parameter
     D   ZFIELD        S             16A
 
      **Length of Decimal field passed to ZALIGN as parameter
     D ZADEC           S              1  0
 
      **Length of digital field passed as a parameter to ZALIGN
     D ZADIG           S              2  0
 
      * interest payment frequency
     D SUIPFR          S              1A
 
      * interest payment day in month
     D SUIPFD          S              2A
 
      ** Average rate method indicator passed as a parameter from calling program. Default 'N'
     D  SAVRAM         S              1A
 
      ** Date day no                                                        ogram. Default 'N'
     D  ZDAYX          S              2  0
 
      * valid rate change date passed as parameter.
     D UNICDX          S              5  0
 
      * valid Interest Payment date passed as parameter.
     D UIPFDX          S              2S 0
 
      * work field for rate change day.
     D UICFDX          S              2S 0
 
      ** Valid Interest Payment date passed back to calling program
     D  UNIPDX         S              5  0
 
      **Message Field passed back as parameter to calling program
     D Msgid1          S                   LIKE(#Msgid)
 
      ** Error message passed back to calling program
     D  Msgid2         S                   LIKE(#Msgid)
                                                                                163863
      * date passed as a parameter to ZDATE2                                    163863
     D   ZDATE         S              6P 0                                      163863
                                                                                163863
      * date passed as a parameter to ZDATE2                                    163863
     D   ZDAYNO        S              5P 0                                      163863
 
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
     C                   RESET                   Msgid2
 
      *
      ** Validate Our Interest Payment Frequency Day in Month.
      ** Use ZALIGN
     C                   Z-ADD     0             UIPFDX
     C     SUIPFD        IFNE      *BLANKS
     C     SUIPFR        IFEQ      *BLANKS
     C                   MOVE      'MMA0043'     Msgid1
     C                   MOVE      'Y'           ErrorFound
     C                   ELSE
      *
      *
     C     ErrorFound    IFEQ      'N'
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     2             ZADIG
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      SUIPFD        ZFIELD
     C                   MOVE      'N'           ZAOPT             1
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        UIPFDX
     C                   END
      *
     C     ZALIGNok      IFEQ      'N'
     C     UIPFDX        ORLT      1
     C     UIPFDX        ORGT      31
     C                   MOVE      'MMA0426'     Msgid1
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'N'           ZALIGNok
     C                   END
 
     C                   END
     C                   END
     C                   END
 
      **
      * The section of code below is relevant to interest rate caps, collars and
      * and floors only. The code can be omitted by passing a blank field in SAVRAM.
      **
 
      *                                                                   S01157
      * If not entered, but allowed - default                             S01157
      *                                                                   S01157
     C     SUIPFD        IFEQ      *BLANKS                                                     S0115
     C     SUIPFR        ANDNE     *BLANKS                                                     S0115
     C     UNIPDX        ANDNE     0                                                           S0115
     C                   CALLB     'ZDATE2'                                     163863
     C                   PARM      UNIPDX        ZDAYNO                         163863
     C                   PARM      'D'           DATFMT            1            163863
     C                   PARM      *ZEROS        ZDATE                          163863
     C                   PARM      *BLANKS       ZADATE            7            163863
     C                   MOVEL     ZDATE         ZDAYX                          163863
     C                   Z-ADD     ZDAYX         UIPFDX                                        S0115
     C                   END                                                                   S0115
      /SPACE 1                                                            S01157
      *                                                                   S01157
      * Cross validate, if Rate Chg & Next Payments details valid         S01157
      *                                                                   S01157
     C     SAVRAM        IFEQ      'Y'                                                         S0115
     C     UICFDX        ANDNE     UIPFDX                                                      S0115
     C     UNICDX        ANDNE     0                                                           S0115
     C     UNIPDX        ANDNE     0                                                           S0115
      *                                                                   S01157
     C     SUIPFD        IFNE      *BLANKS                                                     S0115
      * Avoid exceeding size of error code array.                         S01157
     C                   MOVE      'MMA0058'     Msgid2                                        S0115
     C                   MOVE      'Y'           ErrorFound
      *                                                                   S01157
     C                   ELSE                                                                  S0115
      * Avoid exceeding size of error code array.                         S01157
     C                   MOVE      'MMA0059'     Msgid2                                        S0115
     C                   MOVE      'Y'           ErrorFound
     C                   END                                                                   S0115
      *                                                                   S01157
     C                   END                                                                   S0115
     C*                                                                   S01408
     C/COPY WNCPYSRC,DL1604IC29                                           S01408
     C*                                                                   S01408
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
     C                   PARM                    SAVRAM
     C                   PARM                    SUIPFD
     C                   PARM                    SUIPFR
     C                   PARM                    UIPFDX
     C                   PARM                    UNICDX
     C                   PARM                    UNIPDX
     C                   PARM                    UICFDX
 
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
