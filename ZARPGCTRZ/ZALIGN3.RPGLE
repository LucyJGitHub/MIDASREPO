     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Validate decimal places 3')                   *
      *****************************************************************
      *                                                               *
      *  Midas - ZA Module                                            *
      *                                                               *
      *  ZALIGN3 - Validate Decimal Places                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2015            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD034090 *CREATE   Date 10Mar15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD034090 - Extend field length of ZALIGN, ZEDIT & ZSEDIT     *
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
      *  ZFIELD - A 130 character alphameric field to contain the     *
      *           numeric input. The field may contain leading and    *
      *           trailing blanks and a decimal point, and may have   *
      *           up to 129 digits. Note: 129 digits and one decimal  *
      *           point = 130 characters.                             *
      *                                                               *
      *  ZADEC  - A two-digit numeric field containing the required   *
      *           number of decimal positions as a constant in your   *
      *           program.                                            *
      *                                                               *
      *  ZADIG  - A three-digit numeric field containing the req.     *
      *           number of digits before the decimal point as a      *
      *           constant in your program.                           *
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
      *     exceed 129.                                               *
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
      *  ZFIELD - the 130 character alphameric field containing the   *
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

     D ZA1             S              1    DIM(130)
     D ZA2             S              1    DIM(130)

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** A 130 character alphanumeric field to contain numeric input
      ** The field may contain leading and trailing blanks and a
      ** decimal point,and may have up to 129 digits.
     D ZFIELD          S            130A

      ** Contains the required number of digits before the decimal
      ** point as a constant.
     D ZADEC           S              2P 0

      ** Contains required number of digits before the decimal
      ** point as a constant in program.
     D ZADIG           S              3P 0

      ** Returns 'Y' or 'N' depending on whether validation
      ** has been successful
     D ZALIGNok        S              1A

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

     C                   EVAL      ZALIGNok = 'Y'

     C                   EXSR      ZALIGN

     C                   IF        *IN99 = *ON
     C                   EVAL      ZALIGNok = 'N'
     C                   ELSE
     C                   EVAL      ZALIGNok = 'Y'
     C                   ENDIF

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/ZALIGN - To validate and right align numeric fields        *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     ZALIGN        BEGSR

     C                   SETOFF                                       929399

      ** Save Input fiedl in Arraym ZA1

     C                   MOVEA     ZFIELD        ZA1

      ** Calculation to define number structure control fields

     C                   Z-ADD     ZADIG         ZADIG             3 0
     C                   Z-ADD     ZADEC         ZADEC             2 0

      ** Calculations to define/clear fields

     C                   MOVE      ' '           ZA2
     C                   MOVEA     ZA2           ZFIELD
     C                   Z-ADD     0             ZX                3 0
     C                   Z-ADD     0             ZY                3 0

      ** Ensure required structure of field is valid

     C     ZADIG         ADD       ZADEC         ZZ                3 0
     C     ZZ            COMP      129                                99
     C   99              GOTO      ZAEND

      ** ZATAG1 Tag

     C     ZATAG1        TAG

      ** Loop to find decimal point, blanks and characters

     C     ZX            ADD       1             ZX

      ** Check for decimal point. Error if it has 2 decimal point

     C     ZA1(ZX)       COMP      '.'                                    90
     C   90
     CAN 93              SETON                                        99
     C   99              GOTO      ZAEND

      ** Check for 'M' constant. Error if not last character entered

     C     ZA1(ZX)       COMP      'M'                                    96
     C   96              DO
     C     ZX            COMP      129                                99  99
     C   99              GOTO      ZAEND
     C     ZX            ADD       1             ZX
     C     ZA1(ZX)       COMP      ' '                                9999
     C   99              GOTO      ZAEND
     C     ZX            SUB       1             ZX
     C     ZX            COMP      123                                99
     C   99              GOTO      ZAEND
     C                   END

      ** Check for 'T' constant. Error if not last chacarter entered

     C     ZA1(ZX)       COMP      'T'                                    97
     C   97              DO
     C     ZX            COMP      129                                99  99
     C   99              GOTO      ZAEND
     C     ZX            ADD       1             ZX
     C     ZA1(ZX)       COMP      ' '                                9999
     C   99              GOTO      ZAEND
     C     ZX            SUB       1             ZX
     C     ZX            COMP      126                                99
     C   99              GOTO      ZAEND
     C                   END

      ** Clear Alphanumeric constant from ZA1

     C   96
     COR 97              MOVE      ' '           ZA1(ZX)

      ** Check for blanks. Bypass for first blank after a digit

     C     ZA1(ZX)       COMP      ' '                                    91
     C   91
     CAN 92              GOTO      ZATAG2

      ** Check for numeric, If not '.' or ' '

     C  N90
     CANN91ZA1(ZX)       COMP      '0'                                  99
     C  N90
     CANN91
     CANN99ZA1(ZX)       COMP      '9'                                99
     C   99              GOTO      ZAEND

      ** Store digits in Array and how many
      ** ZY, total of digits in th einput field
      ** ZZ, total of digits to the left od the decimal point

     C  N90
     CANN91ZY            ADD       1             ZY                   92
     C  N90
     CANN91              MOVE      ZA1(ZX)       ZA2(ZY)
     C   90              Z-ADD     ZY            ZZ                   93  93

     C     ZX            COMP      130                                  94
     C   94              GOTO      ZATAG1

      ** ZATAG2 Tag

     C     ZATAG2        TAG

      ** If 'M' specified, multiply ZA1 by 1 million

     C   96ZZ            ADD       6             ZZ

      ** If 'T' specified, multiply ZA1 by 1 thousand

     C   97ZZ            ADD       3             ZZ

      ** Fill in zeros in any blanks left of decimal point

     C   96
     CAN 93
     COR 97
     CAN 93ZZ            DOWGT     ZY
     C     ZY            ADD       1             ZY
     C                   MOVE      '0'           ZA2(ZY)
     C                   END

      ** If constant specified with no decimal point zeroise blanks

     C   96
     CANN93              DO        6
     C     ZY            ADD       1             ZY
     C                   MOVE      '0'           ZA2(ZY)
     C                   END

     C   97
     CANN93              DO        3
     C     ZY            ADD       1             ZY
     C                   MOVE      '0'           ZA2(ZY)
     C                   END

      ** If no decimal point found, set total field ZZ

     C  N93              Z-ADD     ZY            ZZ

      ** Check for embedded blanks

     C   91
     CAN 92              MOVEA     ZA1(ZX)       ZFIELD
     C   91
     CAN 92ZFIELD        COMP      ' '                                9999
     C   99              GOTO      ZAEND

      ** Ensure that number of digits entered either side
      ** of decimal point are not more than allowed

     C     ZZ            COMP      ZADIG                              99
     C     ZY            SUB       ZZ            ZX
     C  N99ZADEC         SUB       ZX            ZX                     9995
     C   99              GOTO      ZAEND
     C   95              GOTO      ZATAG4

      ** Fill the trainling blanks with zeros

     C     ZY            ADD       ZX            ZZ

      ** ZATAG3 Tag

     C     ZATAG3        TAG
     C     ZY            ADD       1             ZY
     C                   MOVE      '0'           ZA2(ZY)
     C     ZY            COMP      ZZ                                   94
     C   94              GOTO      ZATAG3

      ** ZATAG4 Tag

     C     ZATAG4        TAG

      ** Right-align the value by moving back to array, ZA1

     C                   MOVE      '0'           ZA1
     C                   Z-ADD     130           ZX

      ** ZATAG5 Tag

     C     ZATAG5        TAG
     C     ZY            COMP      0                                      94
     C   94              GOTO      ZATAG6
     C                   MOVE      ZA2(ZY)       ZA1(ZX)
     C     ZY            SUB       1             ZY
     C     ZX            SUB       1             ZX
     C                   GOTO      ZATAG5

      ** ZATAG6 Tag

     C     ZATAG6        TAG

      ** Move validated and right aligned number back into ZFIELD

     C                   MOVEA     ZA1           ZFIELD

     C                   SETOFF                                       9697

     C     ZAEND         ENDSR
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

     C     *ENTRY        PLIST
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
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2015
