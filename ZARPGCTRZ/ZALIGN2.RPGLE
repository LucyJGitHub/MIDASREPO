     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Validate decimal places')
      *****************************************************************
      *                                                               *
      *  Midas - ZA Module                                            *
      *                                                               *
      *  ZALIGN2 - Validate Decimal Places                            *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
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
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CAP070  *CREATE    Date 14Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP070 - Modelled on ZALIGN. ZADEC changed to 2,0 from 1,0   *
      *                                                               *
      *****************************************************************
      * Purpose:                                                      *
      * ~~~~~~~~                                                      *
      *  In certain cases, for example keyboard entry, a numeric      *
      *  field must be input as alpha in order to allow for the       *
      *  inclusion of a decimal point, '.', in the input field.       *
      *  The ZALIGN subroutine validates this alphameric input field  *
      *  as numeric with a specified number of positions before and   *
      *  after the decimal point, and right-aligns the value in the   *
      *  output field.                                                *
      *                                                               *
      *  Input:                                                       *
      *  ~~~~~                                                        *
      *  ZFIELD - A 16 character alphameric field to contain the      *
      *           numeric input. The field may contain leading and    *
      *           trailing blanks and a decimal point, and may have   *
      *           up to 15 digits. Note: 15 digits and one decimal    *
      *           point = 16 characters.                              *
      *                                                               *
      *  ZADEC  - A one-digit numeric field containing the required   *
      *           number of decimal positions as a constant in your   *
      *           program.                                            *
      *                                                               *
      *  ZADIG   -    A two-digit numeric field containing the req.   *
      *               number of digits before the decimal point as a  *
      *               constant in your program.                       *
      *                                                               *
      *  Procedure:                                                   *
      *  ~~~~~~~~~                                                    *
      *  1. The input fields, ZFIELD, is move to array ZA1.           *
      *                                                               *
      *  2. ZFIELD is filled with blanks ready for output to it.      *
      *                                                               *
      *  3. A check is made to ensure that the constants specified    *
      *     for number of digits before the decimal point and the     *
      *     number of digits after the decimal point do not together  *
      *     exceed 15.                                                *
      *                                                               *
      *  4. The elements of ZA1 are checked as follows:               *
      *     a) The decimal point, if any, is found and verified as    *
      *        unique.                                                *
      *     b) Leading blanks are ignored.                            *
      *     c) Any character which is not '.' or ' ' is validated as  *
      *        numeric.                                               *
      *                                                               *
      *  5. The numeric contents of ZA1 (i.e. not including '.' or    *
      *     ' ' is move to ZA2.                                       *
      *                                                               *
      *  6. A check is made to ensure there are no embedded blanks.   *
      *                                                               *
      *  7. Checks are made to ensure that the number of digits each  *
      *     side of the decimal point do not exceed the respective    *
      *     constant specified.                                       *
      *                                                               *
      *  8. Trailing blanks are zero-filled.                          *
      *                                                               *
      *  9. The validated value is right-aligned in array ZA1.        *
      *                                                               *
      * 10. The validated and right aligned value is moved back to    *
      *     ZFIELD.                                                   *
      *                                                               *
      * 11. If the input field fails any of the above validations,    *
      *     indicator 99 is set on and the rest of the subroutine is  *
      *     bypassed.                                                 *
      *                                                               *
      *  Output:                                                      *
      *  ~~~~~~                                                       *
      *  ZFIELD - the 16 character alphameric field containing the    *
      *           validated and right aligned value, with no decimal  *
      *           decimal point. Except in the case of embedded       *
      *           blanks, any failure in validation will leave ZFIELD *
      *           as blank field.                                     *
      *                                                               *
      *  Indicator 99 - set on if the input field is not a valid      *
      *                 numeric field or if the number of digits      *
      *                 before or after the decimal point exceeds the *
      *                 specified constants.                          *
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
 
      ** Include the standard declares
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
 
     D ZA1             S              1    DIM(16)                              ZALIGN SR. ARRAY
     D ZA2             S              1    DIM(16)                              ZALIGN SR. ARRAY
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      *  A 16 character alphanumeric field to contain numeric input
      *  The field may contain leading and trailing blanks and a
      *  decimal point,and may have up to 15 digits.
     D ZFIELD          S             16A
 
      *  contains the required number of digits before the decimal
      *  point as a constant.
     D ZADEC           S              2P 0
 
      * contains required number of digits before the decimal point as
      * a constant in program.
     D ZADIG           S              2P 0
 
      * returns 'Y' or 'N' depending on whether validation has been successful
     D ZALIGNok        S              1A
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
 
     C                   EVAL      ZALIGNok = 'Y'
 
     C                   EXSR      ZALIGN
     C                   IF        *in99 = *on
     C                   EVAL      ZALIGNok = 'N'
     C                   ELSE
     C                   EVAL      ZALIGNok = 'Y'
 
     C                   ENDIF
     C                   RETURN
      *
     C**
     C**   ZALIGN SR. TO VALIDATE AND RIGHT-ALIGN NUMERIC FIELDS.
     C**
     C     ZALIGN        BEGSR                                                  *** ZALIGN ***
      *
     C                   SETOFF                                       929399
      *
     C**   SAVE INPUT FIELD IN ARRAY, ZA1.
     C                   MOVEA     ZFIELD        ZA1
      *
     C**   CALCULATION TO DEFINE NUMBER STRUCTURE CONTROL FIELDS.
     C                   Z-ADD     ZADIG         ZADIG             2 0
     C                   Z-ADD     ZADEC         ZADEC             2 0
      *
     C**   CALCULATIONS TO DEFINE/CLEAR FIELDS.
     C                   MOVE      ' '           ZA2
     C                   MOVEA     ZA2           ZFIELD           16
     C                   Z-ADD     0             ZX                2 0
     C                   Z-ADD     0             ZY                2 0
      *
     C**   ENSURE REQUIRED STRUCTURE OF FIELD IS VALID.
     C     ZADIG         ADD       ZADEC         ZZ                2 0
     C     ZZ            COMP      15                                 99
     C   99              GOTO      ZAEND
      *
     C**   LOOP TO FIND DECIMAL POINT, BLANKS AND CHARACTERS.
     C     ZATAG1        TAG                                                    ** ZATAG1 TAG *
     C     ZX            ADD       1             ZX
      *
     C**   CHECK FOR DECIMAL POINT. ERROR IF SECOND DECIMAL POINT.
     C     ZA1(ZX)       COMP      '.'                                    90
     C   90
     CAN 93              SETON                                        99
     C   99              GOTO      ZAEND
      *
     C**   CHECK FOR 'M' CONSTANT. ERROR IF NOT LAST CHARACTER ENTERED
     C     ZA1(ZX)       COMP      'M'                                    96
     C   96              DO
     C     ZX            COMP      15                                 99  99
     C   99              GOTO      ZAEND
     C     ZX            ADD       1             ZX
     C     ZA1(ZX)       COMP      ' '                                9999
     C   99              GOTO      ZAEND
     C     ZX            SUB       1             ZX
     C     ZX            COMP      9                                  99
     C   99              GOTO      ZAEND
     C                   END
      *
     C**   CHECK FOR 'T' CONSTANT. ERROR IF NOT LAST CHARACTER ENTERED
     C     ZA1(ZX)       COMP      'T'                                    97
     C   97              DO
     C     ZX            COMP      15                                 99  99
     C   99              GOTO      ZAEND
     C     ZX            ADD       1             ZX
     C     ZA1(ZX)       COMP      ' '                                9999
     C   99              GOTO      ZAEND
     C     ZX            SUB       1             ZX
     C     ZX            COMP      12                                 99
     C   99              GOTO      ZAEND
     C                   END
      *
     C**   CLEAR ALPHAMERIC CONSTANT FROM ZA1
     C   96
     COR 97              MOVE      ' '           ZA1(ZX)
      *
     C**   CHECK FOR BLANKS. BYPASS FOR FIRST BLANK AFTER A DIGIT.
     C     ZA1(ZX)       COMP      ' '                                    91
     C   91
     CAN 92              GOTO      ZATAG2
      *
     C**   CHECK FOR NUMERIC, IF NOT '.' OR ' '.
     C  N90
     CANN91ZA1(ZX)       COMP      '0'                                  99
     C  N90
     CANN91
     CANN99ZA1(ZX)       COMP      '9'                                99
     C   99              GOTO      ZAEND                                        NOT NUMERIC
      *
     C**   STORE DIGITS IN ARRAY AND HOW MANY.
     C**   ZY, TOTAL OF DIGITS IN THE INPUT FIELD.
     C**   ZZ, TOTAL OF DIGITS TO THE LEFT OF DECIMAL POINT.
     C  N90
     CANN91ZY            ADD       1             ZY                   92
     C  N90
     CANN91              MOVE      ZA1(ZX)       ZA2(ZY)
     C   90              Z-ADD     ZY            ZZ                   93  93
      *
     C     ZX            COMP      16                                   94      CHECK IF ALL
     C   94              GOTO      ZATAG1
      *
     C     ZATAG2        TAG                                                    ** ZATAG2 TAG *
      *
     C**   IF 'M' SPECIFIED, MULTIPLY ZA1 BY 1 MILLION
     C   96ZZ            ADD       6             ZZ
      *
     C**   IF 'T' SPECIFIED, MULTIPLY ZA1 BY 1 THOUSAND
     C   97ZZ            ADD       3             ZZ
      *
     C**   FILL IN ZEROS IN ANY BLANKS LEFT OF DECIMAL POINT
     C   96
     CAN 93
     COR 97
     CAN 93ZZ            DOWGT     ZY
     C     ZY            ADD       1             ZY
     C                   MOVE      '0'           ZA2(ZY)
     C                   END
      *
     C**   IF CONSTANT SPECIFIED WITH NO DECIMAL POINT ZEROISE BLANKS
     C   96
     CANN93              DO        6
     C     ZY            ADD       1             ZY
     C                   MOVE      '0'           ZA2(ZY)
     C                   END
      *
     C   97
     CANN93              DO        3
     C     ZY            ADD       1             ZY
     C                   MOVE      '0'           ZA2(ZY)
     C                   END
      *
     C**   IF NO DECIMAL POINT FOUND, SET TOTAL FIELD ZZ.
     C  N93              Z-ADD     ZY            ZZ
      *
     C**   CHECK FOR EMBEDDED BLANKS.
     C   91
     CAN 92              MOVEA     ZA1(ZX)       ZFIELD
     C   91
     CAN 92ZFIELD        COMP      ' '                                9999
     C   99              GOTO      ZAEND                                        EMBEDDED BLANK
      *
     C**   ENSURE THAT NUMBER OF DIGITS ENTERED EITHER SIDE
     C**   OF DECIMAL POINT ARE NOT MORE THAN ALLOWED.
     C     ZZ            COMP      ZADIG                              99
     C     ZY            SUB       ZZ            ZX
     C  N99ZADEC         SUB       ZX            ZX                     9995
     C   99              GOTO      ZAEND
     C   95              GOTO      ZATAG4                                       NO TRAILING
      *
     C**   FILL THE TRAILING BLANKS WITH ZEROS.
     C     ZY            ADD       ZX            ZZ
     C     ZATAG3        TAG                                                    ** ZATAG3 TAG *
     C     ZY            ADD       1             ZY
     C                   MOVE      '0'           ZA2(ZY)
     C     ZY            COMP      ZZ                                   94
     C   94              GOTO      ZATAG3
      *
     C**   RIGHT-ALIGN THE VALUE BY MOVING BACK TO ARRAY, ZA1.
     C     ZATAG4        TAG                                                    ** ZATAG4 TAG *
     C                   MOVE      '0'           ZA1
     C                   Z-ADD     16            ZX
     C     ZATAG5        TAG                                                    ** ZATAG5 TAG *
     C     ZY            COMP      0                                      94
     C   94              GOTO      ZATAG6
     C                   MOVE      ZA2(ZY)       ZA1(ZX)
     C     ZY            SUB       1             ZY
     C     ZX            SUB       1             ZX
     C                   GOTO      ZATAG5
     C     ZATAG6        TAG                                                    ** ZATAG6 TAG *
      *
     C**   MOVE VALIDATED AND RIGHT-ALIGNED NUMBER BACK INTO ZFIELD.
     C                   MOVEA     ZA1           ZFIELD
      *
     C                   SETOFF                                       9697
      *
     C     ZAEND         ENDSR                                                  * ZAEND ENDSR *
      *
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
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
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
(c) Finastra International Limited 2002
