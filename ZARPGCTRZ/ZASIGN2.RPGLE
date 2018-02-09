     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Validate & right align signed numeric fld')
      *****************************************************************
      *                                                               *
      *  Midas - ZA Module                                            *
      *                                                               *
      *  ZASIGN2 - Validate and right-align signed numeric            *
      *            Modelled on ZASIGN. ZADEC changed to 2,0 from 1,0. *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
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
      *  Prev Amend No. CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Purpose: Validate decimal places and sign then right-aligns  *
      *           signed numeric fields                               *
      *                                                               *
      *  Input fields:   ZFLD17   17A     Signed numeric fields       *
      *                  ZSDIG     2P 0   Number of digits            *
      *                  ZSDEC     2P 0   Number of decimal places    *
      *                  ZSDCSP    1A     Decimal separator eg. '.'   *
      *                                                               *
      *  Output fields:  ZOUT15   15A                                 *
      *                  ZFSIGN    1A                                 *
      *                  ZASIGNok  1A                                 *
      *-------------------------------------------------------------- *
      *                                                               *
      *   FUNCTION OF INDICATORS                                      *
      *                                                               *
      *   90         Decimal point found                              *
      *   91         Blank character found                            *
      *   92         After 1st time pass                              *
      *   93         Decimal point processed                          *
      *   95         No trailing blanks after decimal point position  *
      *   96         Character 'M' found                              *
      *   97         Character 'T' found                              *
      *   99         SR ended abnormally - data invalid               *
      *                                                               *
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
 
     D ZS3             S              1    DIM(17)
     D ZS4             S              1    DIM(16)
     D ZS5             S              1    DIM(15)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input parameters
     D ZFLD17          S             17A
     D ZSDIG           S              2P 0
     D ZSDEC           S              2P 0
     D ZSDCSP          S              1A
 
      ** Output parameters
     D ZOUT15          S             15A
     D ZFSIGN          S              1A
     D ZASIGNok        S              1A
 
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
 
     C                   EVAL      ZASIGNok = 'Y'
 
     C                   EXSR      ZASIGN
 
     C                   IF        *IN99 = *ON
     C                   EVAL      ZASIGNok = 'N'
     C                   ELSE
     C                   EVAL      ZASIGNok = 'Y'
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
     CSR   ZASIGN        BEGSR
 
     C                   SETOFF                                       929399
 
      ** SAVE INPUT FIELD IN ARRAY, ZS3.
 
     C                   MOVEA     ZFLD17        ZS3
 
      ** CALCULATION TO DEFINE NUMBER STRUCTURE CONTROL FIELDS.
 
     C                   Z-ADD     ZSDIG         ZSDIG
     C                   Z-ADD     ZSDEC         ZSDEC
 
      ** DECIMAL SEPARATOR
     C     ZSDCSP        IFEQ      *BLANK
     C                   MOVEL     '.'           ZSDCSP
     C                   ENDIF
 
      ** CALCULATIONS TO DEFINE/CLEAR FIELDS.
 
     C                   MOVE      ' '           ZS4
     C                   MOVEA     ZS4           ZFLD17
     C                   Z-ADD     0             ZX                2 0
     C                   Z-ADD     0             ZY                2 0
     C                   MOVE      ' '           ZFSIGN
 
      ** ENSURE REQUIRED STRUCTURE OF FIELD IS VALID.
 
     C     ZSDIG         ADD       ZSDEC         ZSINT             2 0
     C     ZSINT         CABGT     15            ZSEND                99
 
      ** LOOP TO FIND DECIMAL POINT, BLANKS AND CHARACTERS.
 
     C                   DO        17            ZX
 
      ** CHECK FOR DECIMAL POINT. ERROR IF SECOND DECIMAL POINT.
 
     C     ZS3(ZX)       COMP      ZSDCSP                                 90
     C   90
     CAN 93              SETON                                        99
     C   99              GOTO      ZSEND
 
      ** Check for 'M' constant. Error if not followed by '+', '-' or
      ** blank.
 
     C     ZS3(ZX)       COMP      'M'                                    96
     C     *IN96         IFEQ      '1'
     C     ZX            CABGT     9             ZSEND                99
     C                   ADD       1             ZX
     C     ZS3(ZX)       IFNE      ' '
     C     ZS3(ZX)       ANDNE     '+'
     C     ZS3(ZX)       ANDNE     '-'
     C                   SETON                                        99
     C                   GOTO      ZSEND
     C                   END
     C                   SUB       1             ZX
 
      ** CLEAR ALPHAMERIC CONSTANT FROM ZS3
 
     C                   MOVE      ' '           ZS3(ZX)
 
      ** Fetch next arry element to check for '+' or '-' and bypass
      ** embedded blank edit as 'M' now replaced by ' '
 
     C                   ADD       1             ZX
     C                   END
 
      ** Check for 'T' constant. Error if not followed by '+', '-' or
      ** blank.
 
     C     ZS3(ZX)       COMP      'T'                                    97
     C     *IN97         IFEQ      '1'
     C     ZX            CABGT     12            ZSEND                99
     C                   ADD       1             ZX
     C     ZS3(ZX)       IFNE      ' '
     C     ZS3(ZX)       ANDNE     '+'
     C     ZS3(ZX)       ANDNE     '-'
     C                   SETON                                        99
     C                   GOTO      ZSEND
     C                   END
     C                   SUB       1             ZX
 
      ** CLEAR ALPHAMERIC CONSTANT FROM ZS3
 
     C                   MOVE      ' '           ZS3(ZX)
 
      ** Fetch next arry element to check for '+' or '-' and bypass
      ** embedded blank edit as 'T' now replaced by ' '
 
     C                   ADD       1             ZX
     C                   END
 
      ** Check for '-' constant. Error if not followed by blank
 
     C     ZS3(ZX)       IFEQ      '-'
     C     ZX            IFLT      17
     C                   ADD       1             ZX
     C     ZS3(ZX)       CABNE     ' '           ZSEND                9999
     C                   SUB       1             ZX
     C                   END
 
      ** Place '-' in output sign field
 
     C                   MOVE      '-'           ZFSIGN
 
      ** CLEAR ALPHAMERIC CONSTANT FROM ZS3
 
     C                   MOVE      ' '           ZS3(ZX)
 
     C                   END
 
      ** Check for '+' constant. Error if not followed by blank
 
     C     ZS3(ZX)       IFEQ      '+'
     C                   ADD       1             ZX
     C     ZX            IFLE      17
     C     ZS3(ZX)       CABNE     ' '           ZSEND                9999
     C                   END
     C                   SUB       1             ZX
 
      ** CLEAR ALPHAMERIC CONSTANT FROM ZS3
 
     C                   MOVE      ' '           ZS3(ZX)
     C                   END
 
      ** CHECK FOR BLANKS. BYPASS FOR FIRST BLANK AFTER A DIGIT.
 
     C   96
     COR 97              SUB       1             ZX
     C     ZS3(ZX)       COMP      ' '                                    91
     C   91
     CAN 92              GOTO      ZSTAG1
 
      ** CHECK FOR NUMERIC, IF NOT '.' OR ' '.
 
     C  N90
     CANN91ZS3(ZX)       COMP      '0'                                  99
     C  N90
     CANN91
     CANN99ZS3(ZX)       COMP      '9'                                99
     C   99              GOTO      ZSEND
 
      ** STORE DIGITS IN ARRAY AND HOW MANY.
      ** ZY, TOTAL OF DIGITS IN THE INPUT FIELD.
      ** ZSINT, TOTAL OF DIGITS TO THE LEFT OF DECIMAL POINT.
 
     C  N90
     CANN91              ADD       1             ZY                   92
     C     ZY            IFLE      15
     C  N90
     CANN91              MOVE      ZS3(ZX)       ZS4(ZY)
     C                   END
     C   90              Z-ADD     ZY            ZSINT                93  93
 
      ** End of array read loop.
 
     C                   END
 
     C     ZSTAG1        TAG
 
      ** IF 'M' SPECIFIED, MULTIPLY ZS3 BY 1 MILLION
 
     C     *IN96         IFEQ      '1'
     C                   ADD       6             ZSINT
     C                   ADD       6             ZSDIG
     C                   END
 
      ** IF 'T' SPECIFIED, MULTIPLY ZS3 BY 1 THOUSAND
 
     C     *IN97         IFEQ      '1'
     C                   ADD       3             ZSINT
     C                   ADD       3             ZSDIG
     C                   END
 
      ** IF CONSTANT SPECIFIED, MULTIPLY BY RESPECTIVE AMOUNT
 
     C   96              DO        6
     C                   ADD       1             ZY
     C                   MOVE      '0'           ZS4(ZY)
     C                   END
 
     C   97              DO        3
     C                   ADD       1             ZY
     C                   MOVE      '0'           ZS4(ZY)
     C                   END
 
      ** IF NO DECIMAL POINT FOUND, SET TOTAL FIELD ZSINT
 
     C  N93              Z-ADD     ZY            ZSINT
 
      ** CHECK FOR EMBEDDED BLANKS.
 
     C                   MOVE      *BLANKS       ZFLD17
     C   91
     CAN 92              MOVEA     ZS3(ZX)       ZFLD17
     C   91
     CAN 92ZFLD17        CABNE     ' '           ZSEND                9999
 
      ** ENSURE THAT NUMBER OF DIGITS ENTERED EITHER SIDE
      ** OF DECIMAL POINT ARE NOT MORE THAN ALLOWED.
 
     C     ZSINT         COMP      ZSDIG                              99
     C     ZY            SUB       ZSINT         ZX
     C  N99ZSDEC         SUB       ZX            ZX                     9995
     C   99              GOTO      ZSEND
     C   95              GOTO      ZSTAG2
 
      ** FILL THE TRAILING BLANKS WITH ZEROS.
 
     C                   DO        ZX
     C                   ADD       1             ZY
     C                   MOVE      '0'           ZS4(ZY)
     C                   END
 
      ** RIGHT-ALIGN THE VALUE BY MOVING TO ARRAY, ZS5.
 
     C     ZSTAG2        TAG
     C                   MOVE      '0'           ZS5
     C                   Z-ADD     15            ZX
     C                   Z-ADD     16            ZY
     C                   DO        16
     C     ZS4(ZY)       IFNE      ' '
     C                   MOVE      ZS4(ZY)       ZS5(ZX)
     C                   SUB       1             ZX
     C                   END
     C                   SUB       1             ZY
     C                   END
 
      ** Replace leading blanks with zeros.
 
     C                   Z-ADD     1             ZX
     C                   DO        15
     C     ZS5(ZX)       IFEQ      ' '
     C                   MOVE      '0'           ZS5(ZX)
     C                   ADD       1             ZX
     C                   ELSE
     C                   GOTO      ZSTAG3
     C                   END
     C                   END
 
      ** MOVE VALIDATED AND RIGHT-ALIGNED NUMBER BACK INTO ZFLD17.
 
     C     ZSTAG3        TAG
     C                   MOVEA     ZS5           ZOUT15
 
      ** If output sign field is not negative ('-'), make positive('+').
 
     C     ZFSIGN        IFNE      '-'
     C                   MOVE      '+'           ZFSIGN
     C                   END
 
     C                   SETOFF                                       9697
 
     CSR   ZSEND         ENDSR
 
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
     C                   PARM                    ZASIGNok
     C                   PARM                    ZFLD17
     C                   PARM                    ZSDIG
     C                   PARM                    ZSDEC
     C                   PARM                    ZSDCSP
     C                   PARM                    ZOUT15
     C                   PARM                    ZFSIGN
 
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
(c) Finastra International Limited 2004
