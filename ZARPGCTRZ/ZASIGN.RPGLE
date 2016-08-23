     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Validate & right align signed numeric fld')
      *****************************************************************
      *                                                               *
      *  Midas - ZASIGN ILE Module                                    *
      *                                                               *
      *  ZASIGN                                                       *
      *                                                               *
     C********************************************************************
     C**                                                                 *
     C** ZASIGN subroutine to validate and right-align signed numeric    *
     C** fields                                                          *
     C**     Input fields:   ZFLD17 17/                                  *
     C**                     ZSDIG  2/0                                  *
     C**                     ZSDEC  1/0                                  *
     C**                     ZSDCSP 1                                    *156689
     C**                                                                 *
     C**     Arrays:         ZS3    17/1/                                *
     C**                     ZS4    15/1/                                *
     C**                                                                 *
     C**     Output fields:  ZOUT15 15/                                  *
     C**                     ZFSIGN  1/                                  *
     C**                                                                 *
     C** ID F  C  H  L    FUNCTION OF INDICATORS
     C**
     C**       90         Decimal point found
     C**       91         Blank character found
     C**       92         After 1st time pass
     C**       93         Decimal point processed
     C**       95         No trailing blanks after decimal point position
     C**       96         Character 'M' found
     C**       97         Character 'T' found
     C**       99         SR ended abnormally - data invalid
     C**                                                                 *
     C********************************************************************
     C*                                                                  *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
     C*  LAST AMEND NO. 156689             DATE  08MAR99                 *
     C*  PREV AMEND NO. S01176             DATE 17/08/88                 *
     C*                                                                  *
     C*------------------------------------------------------------------*
     C*                                                                  *
     C*  156689 - ZASIGN TO RECOGNIZE '.' OR ',' AS DECIMAL SEPARATOR    *
     C*  S01176 - SECURITIES TRADING 3.1 (AUSTRALIA)                     *S01176
     C*                                                                  *
     C********************************************************************
      *  Function:                                                    *
 
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
 
      * ** +-------The converted ZASIGNZ1 starts here --------------+
     D*
     D ZS3             S              1    DIM(17)                              ZASIGN SR. ARRAY
     D ZS4             S              1    DIM(16)                              ZASIGN SR. ARRAY
     D ZS5             S              1    DIM(15)                              ZASIGN SR. ARRAY
     E*
      * ** +-------The converted ZASIGNZ1 ends here --------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      * ZASIGN sub-routine to validate and right-align signed numeric
      * fields; the following are the input fields:
     D ZFLD17          S             17A
     D ZSDIG           S              2P 0
     D ZSDEC           S              1P 0
 
      * output parameter passed back to calling program
     D ZOUT15          S             15A
      * positive/negative indicator
     D ZFSIGN          S              1A
      * returns 'Y' or 'N' depending on whether validation has been successful
     D ZASIGNok        S              1A
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
 
     C                   EVAL      ZASIGNok = 'Y'
 
     C                   EXSR      ZASIGN
     C                   IF        *in99 = *on
     C                   EVAL      ZASIGNok = 'N'
     C                   ELSE
     C                   EVAL      ZASIGNok = 'Y'
 
     C                   ENDIF
     C                   RETURN
      * ** +-------The converted ZASIGNZ2 starts here --------------+
     C********************************************************************
     CSR   ZASIGN        BEGSR                                                  *** ZASIGN ***
     C**
     C                   SETOFF                                       929399
     C**
     C**   SAVE INPUT FIELD IN ARRAY, ZS3.
     C**
     C                   MOVEA     ZFLD17        ZS3
     C**
     C**   CALCULATION TO DEFINE NUMBER STRUCTURE CONTROL FIELDS.
     C**
     C                   Z-ADD     ZSDIG         ZSDIG             2 0
     C                   Z-ADD     ZSDEC         ZSDEC             1 0
     C**                                                                                      156689
     C**   DECIMAL SEPARATOR                                                                  156689
     C     ZSDCSP        IFEQ      *BLANK                                                     156689
     C                   MOVEL     '.'           ZSDCSP            1                          156689
     C                   ENDIF                                                                156689
     C**
     C**   CALCULATIONS TO DEFINE/CLEAR FIELDS.
     C**
     C                   MOVE      ' '           ZS4
     C                   MOVEA     ZS4           ZFLD17           17
     C                   Z-ADD     0             ZX                2 0
     C                   Z-ADD     0             ZY                2 0
     C                   MOVE      ' '           ZFSIGN            1
     C**
     C**   ENSURE REQUIRED STRUCTURE OF FIELD IS VALID.
     C**
     C     ZSDIG         ADD       ZSDEC         ZSINT             2 0
     C     ZSINT         CABGT     15            ZSEND                99
     C**
     C**   LOOP TO FIND DECIMAL POINT, BLANKS AND CHARACTERS.
     C**
     C                   DO        17            ZX
     C**
     C**   CHECK FOR DECIMAL POINT. ERROR IF SECOND DECIMAL POINT.
     C**
     C***********ZS3,ZX    COMP '.'                      90               156689
     C     ZS3(ZX)       COMP      ZSDCSP                                 90                   15668
     C   90
     CAN 93              SETON                                        99
     C   99              GOTO      ZSEND
     C**
     C**   Check for 'M' constant. Error if not followed by '+', '-' or
     C**   blank.
     C**
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
     C**
     C**   CLEAR ALPHAMERIC CONSTANT FROM ZS3
     C**
     C                   MOVE      ' '           ZS3(ZX)
     C**
     C** Fetch next arry element to check for '+' or '-' and bypass
     C** embedded blank edit as 'M' now replaced by ' '
     C**
     C                   ADD       1             ZX
     C                   END
     C**
     C**   Check for 'T' constant. Error if not followed by '+', '-' or
     C**   blank.
     C**
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
     C**
     C**   CLEAR ALPHAMERIC CONSTANT FROM ZS3
     C**
     C                   MOVE      ' '           ZS3(ZX)
     C**
     C** Fetch next arry element to check for '+' or '-' and bypass
     C** embedded blank edit as 'T' now replaced by ' '
     C**
     C                   ADD       1             ZX
     C                   END
     C**
     C**   Check for '-' constant. Error if not followed by blank
     C**
     C     ZS3(ZX)       IFEQ      '-'
     C     ZX            IFLT      17
     C                   ADD       1             ZX
     C     ZS3(ZX)       CABNE     ' '           ZSEND                9999
     C                   SUB       1             ZX
     C                   END
     C**
     C** Place '-' in output sign field
     C**
     C                   MOVE      '-'           ZFSIGN
     C**
     C**   CLEAR ALPHAMERIC CONSTANT FROM ZS3
     C**
     C                   MOVE      ' '           ZS3(ZX)
     C**
     C                   END
     C**
     C**   Check for '+' constant. Error if not followed by blank
     C**
     C     ZS3(ZX)       IFEQ      '+'
     C                   ADD       1             ZX
     C     ZX            IFLE      17                                                          S0117
     C     ZS3(ZX)       CABNE     ' '           ZSEND                9999
     C                   END                                                                   S0117
     C                   SUB       1             ZX
     C**
     C**   CLEAR ALPHAMERIC CONSTANT FROM ZS3
     C**
     C                   MOVE      ' '           ZS3(ZX)
     C                   END
     C**
     C**   CHECK FOR BLANKS. BYPASS FOR FIRST BLANK AFTER A DIGIT.
     C**
     C   96
     COR 97              SUB       1             ZX
     C     ZS3(ZX)       COMP      ' '                                    91
     C   91
     CAN 92              GOTO      ZSTAG1
     C**
     C**   CHECK FOR NUMERIC, IF NOT '.' OR ' '.
     C**
     C  N90
     CANN91ZS3(ZX)       COMP      '0'                                  99
     C  N90
     CANN91
     CANN99ZS3(ZX)       COMP      '9'                                99
     C   99              GOTO      ZSEND
     C**
     C**   STORE DIGITS IN ARRAY AND HOW MANY.
     C**   ZY, TOTAL OF DIGITS IN THE INPUT FIELD.
     C**   ZSINT, TOTAL OF DIGITS TO THE LEFT OF DECIMAL POINT.
     C**
     C  N90
     CANN91              ADD       1             ZY                   92
     C     ZY            IFLE      15                                                          S0117
     C  N90
     CANN91              MOVE      ZS3(ZX)       ZS4(ZY)
     C                   END                                                                   S0117
     C   90              Z-ADD     ZY            ZSINT                93  93
     C**
     C** End of array read loop.
     C**
     C                   END
     C**
     C     ZSTAG1        TAG                                                    ** ZSTAG1 TAG *
     C**
     C**   IF 'M' SPECIFIED, MULTIPLY ZS3 BY 1 MILLION
     C**
     C     *IN96         IFEQ      '1'
     C                   ADD       6             ZSINT
     C                   ADD       6             ZSDIG
     C                   END
     C**
     C**   IF 'T' SPECIFIED, MULTIPLY ZS3 BY 1 THOUSAND
     C**
     C     *IN97         IFEQ      '1'
     C                   ADD       3             ZSINT
     C                   ADD       3             ZSDIG
     C                   END
     C**
     C**   IF CONSTANT SPECIFIED, MULTIPLY BY RESPECTIVE AMOUNT
     C**
     C   96              DO        6
     C                   ADD       1             ZY
     C                   MOVE      '0'           ZS4(ZY)
     C                   END
     C**
     C   97              DO        3
     C                   ADD       1             ZY
     C                   MOVE      '0'           ZS4(ZY)
     C                   END
     C**
     C**   IF NO DECIMAL POINT FOUND, SET TOTAL FIELD ZSINT
     C**
     C  N93              Z-ADD     ZY            ZSINT
     C**
     C**   CHECK FOR EMBEDDED BLANKS.
     C**
     C                   MOVE      *BLANKS       ZFLD17
     C   91
     CAN 92              MOVEA     ZS3(ZX)       ZFLD17
     C   91
     CAN 92ZFLD17        CABNE     ' '           ZSEND                9999
     C**
     C**   ENSURE THAT NUMBER OF DIGITS ENTERED EITHER SIDE
     C**   OF DECIMAL POINT ARE NOT MORE THAN ALLOWED.
     C**
     C     ZSINT         COMP      ZSDIG                              99
     C     ZY            SUB       ZSINT         ZX
     C  N99ZSDEC         SUB       ZX            ZX                     9995
     C   99              GOTO      ZSEND
     C   95              GOTO      ZSTAG2
     C**
     C**   FILL THE TRAILING BLANKS WITH ZEROS.
     C**
     C                   DO        ZX
     C                   ADD       1             ZY
     C                   MOVE      '0'           ZS4(ZY)
     C                   END
     C**
     C**   RIGHT-ALIGN THE VALUE BY MOVING TO ARRAY, ZS5.
     C**
     C     ZSTAG2        TAG                                                    ** ZSTAG2 TAG *
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
     C**
     C**   Replace leading blanks with zeros.
     C**
     C                   Z-ADD     1             ZX
     C                   DO        15
     C     ZS5(ZX)       IFEQ      ' '
     C                   MOVE      '0'           ZS5(ZX)
     C                   ADD       1             ZX
     C                   ELSE
     C                   GOTO      ZSTAG3
     C                   END
     C                   END
     C**
     C**   MOVE VALIDATED AND RIGHT-ALIGNED NUMBER BACK INTO ZFLD17.
     C**
     C     ZSTAG3        TAG                                                    ** ZSTAG3 TAG *
     C                   MOVEA     ZS5           ZOUT15           15
     C**
     C**   If output sign field is not -ive, make +ive.
     C**
     C     ZFSIGN        IFNE      '-'
     C                   MOVE      '+'           ZFSIGN
     C                   END
     C**
     C                   SETOFF                                       9697
     C**
     CSR   ZSEND         ENDSR                                                  * ZSEND ENDSR *
     C*****************************************************************
 
      * ** +-------The converted ZASIGNZ2 ends here --------------+
 
 
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
     C                   PARM                    ZASIGNok
     C                   PARM                    ZFLD17
     C                   PARM                    ZSDIG
     C                   PARM                    ZSDEC
     C                   PARM                    ZSDCSP                         156689
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
(c) Misys International Banking Systems Ltd. 2001
