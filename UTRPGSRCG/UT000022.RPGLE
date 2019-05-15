     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*XBIA*  OVRDBF FILE(UT000022F) TOFILE(UPFFDSTPD)                     *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Display field description for CMPF')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UT000022 - Display field description for CMPF                *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. BUG27790 *CREATE   Date 02Jul10               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG27790 - New utility                                       *
      *                                                               *
      *****************************************************************
     FUT000022DFCF   E             WORKSTN
     F                                     SFILE(SUBFLREC:RRN)
     FUT000022F IF   E             DISK    USROPN
     FUTFLDDPD  UF A E           K DISK
     FUTFLDDL2  IF   E           K DISK    RENAME(UTFLDDD0:FLDDF)
      *
     D MODE            S              1
     D COMA            S              1
     D HI              S              1
     D #C              S              2  0
     D #SEQN           S              3  0
     D #FLDN           S              3  0
     D RRN             S              4  0
     D Z               S              4  0
     D Library         S             10    INZ('*LIBL     ')
     D Outfile         S             10    INZ('UT000022F ')
     D OutFMbr         S             10    INZ('*FIRST    ')
     D OutFMbrOpt      S              8    INZ('*REPLACE')
      *
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      *
     D ERR             S             76    DIM(3) CTDATA PERRCD(1)
     D COM             S              1    DIM(1) CTDATA PERRCD(1)
     D ZA1             S              1    DIM(16)                              ZALIGN SR. ARRAY
     D ZA2             S              1    DIM(16)                              ZALIGN SR. ARRAY
     D BLK             S              1    DIM(17)
     D DSH             S              1    DIM(17)
     D                 DS
     D  CL1                    1     17
     D                                     DIM(17)
     D  COL1                   1     17
     D                 DS
     D  CL2                    1     17
     D                                     DIM(17)
     D  COL2                   1     17
      *
     C                   Z-ADD     17            #C
     C                   MOVE      '-'           DSH
     C                   MOVE      COM(1)        COMA
     C                   BITOFF    '01234567'    HI
     C                   BITON     '267'         HI
     C                   MOVEL     HI            ERR
     C                   EVAL      SSUSER = ##USR
     C                   EVAL      SSJOB  = ##JOB
      *
     C     FLDDXK        KLIST
     C                   KFLD                    FDFILE
     C                   KFLD                    FDSEQN
     C                   KFLD                    FDFLDN
      *
     C     FLDDXP        KLIST
     C                   KFLD                    FDFILE
      *
     C     FLDDTK        KLIST
     C                   KFLD                    FDFILE
     C                   KFLD                    FDFLDN
      *
     C     FLDDTP        KLIST
     C                   KFLD                    FDFILE
      *
     C     *ENTRY        PLIST
     C                   PARM                    FDFILE
     C                   PARM                    MODE
      *
     C     FLDDXP        CHAIN     FLDDF                              99
     C     *IN99         IFEQ      '1'
     C                   EXSR      DETMSK
     C                   END
      *
     C                   Z-ADD     *ZERO         FDSEQN
     C                   Z-ADD     *ZERO         FDFLDN
     C     *INKC         DOWEQ     '0'
     C     MODE          ANDEQ     ' '
     C                   EXSR      DSPLAY
     C                   END
      *
     C                   SETON                                        LR
      *****************************************************************
     C     DSPLAY        BEGSR
      *
     C                   EXSR      FILLSB
      *
     C                   WRITE     SUBFLCTL
     C                   WRITE     SUBMESS
     C                   READ      SUBFLCTL                               99
     C                   MOVEL     *BLANK        SSERR
      * F10
     C     *INKJ         IFEQ      '1'
     C                   EXSR      DELFIL
     C                   MOVE      'X'           MODE
     C                   END
      * F12
     C     *INKL         IFEQ      '1'
     C                   MOVE      'X'           MODE
     C                   END
      * F16
     C     *INKQ         IFEQ      '1'
     C                   EXSR      BLKFIL
     C                   END
      * Rolldown
     C     *IN05         IFEQ      '1'
     C                   EXSR      Rolldown
     C                   END
      * Updated?
     C     *IN(04)       IFEQ      '0'
     C                   READC     SUBFLREC                               99
     C     *IN99         DOWEQ     '0'
     C                   EXSR      UPDFIL
     C                   Z-ADD     #SEQN         FDSEQN
     C                   Z-ADD     #FLDN         FDFLDN
     C                   READC     SUBFLREC                               99
     C                   END
     C                   END
      *
     C                   ENDSR
      ********************************************************************
     C     FILLSB        BEGSR
     C                   MOVEA     '000'         *IN(1)
     C                   MOVEA     '1'           *IN(4)
     C                   Z-ADD     *ZERO         RRN
     C                   WRITE     SUBFLCTL
     C     FLDDXK        SETLL     FLDDF
     C     FLDDXP        READE     FLDDF                                  99
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     FDSEQN        #SEQN
     C                   Z-ADD     FDFLDN        #FLDN
     C                   ELSE
     C                   Z-ADD     *ZERO         #SEQN
     C                   Z-ADD     *ZERO         #FLDN
     C                   Z-ADD     *ZERO         FDSEQN
     C                   Z-ADD     *ZERO         FDFLDN
     C     SSERR         IFEQ      *BLANK
     C                   MOVEL     ERR(1)        SSERR
     C                   END
     C                   END
      *
     C     *IN99         DOWEQ     '0'
     C                   ADD       1             RRN                      04
      *
     C     FDTYPE        IFEQ      'A'
     C     FDLENG        ADD       1             Z
     C                   ELSE
     C     FDDIGI        ADD       1             Z
     C                   END
     C     Z             IFLE      17
     C                   MOVEA     DSH           CL1(Z)
     C                   MOVEA     DSH           CL2(Z)
     C                   END
      *
     C     FDSEQN        IFNE      *ZEROS
     C     FDSEQN        ANDLT     999
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      FDSEQN        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SSSEQN
     C                   ELSE
     C                   MOVE      *BLANKS       SSSEQN
     C                   END
     C                   MOVEL     FDDESC        SSDESC
     C                   MOVEL     FDCOL1        SSCOL1
     C                   MOVEL     FDCOL2        SSCOL2
     C                   WRITE     SUBFLREC
     C     RRN           IFEQ      #C
     C     FLDDXP        READE     FLDDF                                  99
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     *ZERO         FDSEQN
     C                   Z-ADD     *ZERO         FDFLDN
     C     SSERR         IFEQ      *BLANK
     C                   MOVEL     ERR(1)        SSERR
     C                   END
     C                   ELSE
     C                   SETON                                            99
     C                   END
     C                   ELSE
     C     FLDDXP        READE     FLDDF                                  99
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     *ZERO         FDSEQN
     C                   Z-ADD     *ZERO         FDFLDN
     C     SSERR         IFEQ      *BLANK
     C                   MOVEL     ERR(1)        SSERR
     C                   END
     C                   END
     C                   END
     C                   END
      *
     C     *IN(4)        IFEQ      '1'
     C                   MOVEA     '010'         *IN(1)
     C                   ELSE
     C                   MOVEA     '111'         *IN(1)
     C                   END
     C                   ENDSR
      ********************************************************************
     C     Rolldown      BEGSR
     C                   Z-ADD     *ZERO         RRN
     C                   Z-ADD     #SEQN         FDSEQN
     C                   Z-ADD     #FLDN         FDFLDN
     C     FLDDXK        SETGT     FLDDF
     C     FLDDXP        READPE    FLDDF                                  99
      *
     C     *IN99         DOWEQ     '0'
     C     RRN           ANDLT     #C
     C     FLDDXP        READPE    FLDDF                                  99
     C                   ADD       1             RRN
     C                   END
      *
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     *ZERO         FDSEQN
     C                   Z-ADD     *ZERO         FDFLDN
     C                   MOVEL     ERR(2)        SSERR
     C                   END
      *
     C     RolldownE     ENDSR
      *****************************************************************
     C     UPDFIL        BEGSR
      *
     C     FLDDTK        CHAIN     UTFLDDD0                           99
     C                   EXSR      VALID
     C                   UPDATE    UTFLDDD0
      *
     C                   ENDSR
      *****************************************************************
     C     DELFIL        BEGSR
      *
     C                   Z-ADD     *ZERO         FDFLDN
     C     FLDDTK        SETLL     UTFLDDD0
     C     FLDDTP        READE     UTFLDDD0                               99
     C     *IN99         DOWEQ     '0'
     C                   DELETE    UTFLDDD0
     C     FLDDTP        READE     UTFLDDD0                               99
     C                   END
     C                   Z-ADD     *ZERO         FDSEQN
     C                   Z-ADD     *ZERO         FDFLDN
      *
     C                   ENDSR
      *****************************************************************
     C     BLKFIL        BEGSR
      *
     C                   Z-ADD     *ZERO         FDFLDN
     C     FLDDTK        SETLL     UTFLDDD0
     C     FLDDTP        READE     UTFLDDD0                               99
     C     *IN99         DOWEQ     '0'
     C                   Z-ADD     999           FDSEQN
     C                   UPDATE    UTFLDDD0
     C     FLDDTP        READE     UTFLDDD0                               99
     C                   END
     C                   Z-ADD     *ZERO         FDSEQN
     C                   Z-ADD     *ZERO         FDFLDN
      *
     C                   ENDSR
     C*****************************************************************
     C     VALID         BEGSR
      *
     C     SSSEQN        IFNE      *BLANK
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVEL     SSSEQN        ZFIELD
     C                   Z-ADD     3             ZADIG
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZALIGN
     C   99              Z-ADD     999           FDSEQN
     C  N99              MOVE      ZFIELD        FDSEQN
     C     FDSEQN        IFEQ      *ZERO
     C                   Z-ADD     999           FDSEQN
     C                   END
     C                   ELSE
     C                   Z-ADD     999           FDSEQN
     C                   END
     C                   MOVEL     SSDESC        FDDESC
     C                   MOVEL     SSCOL1        FDCOL1
     C                   MOVEL     SSCOL2        FDCOL2
     C*
     C     FDTYPE        IFEQ      'A'
     C     FDLENG        ADD       1             Z
     C                   ELSE
     C     FDDIGI        ADD       1             Z
     C                   END
     C     Z             IFLE      17
     C                   MOVEA     BLK           CL1(Z)
     C                   MOVEA     BLK           CL2(Z)
     C                   END
     C*
     C                   Z-ADD     1             Z
     C     *IN99         DOUEQ     '0'
     C     '-'           LOOKUP    CL1(Z)                                 99    *
     C   99              MOVEL     ' '           CL1(Z)
     C                   END
     C*
     C                   Z-ADD     1             Z
     C     *IN99         DOUEQ     '0'
     C     '-'           LOOKUP    CL2(Z)                                 99
     C   99              MOVEL     ' '           CL2(Z)
     C                   END
      *
     C     FDDESC        IFEQ      *BLANK
     C                   MOVEL     '*'           FDDESC
     C                   END
     C     FDCOL1        IFEQ      *BLANK
     C                   MOVEL     '*'           FDCOL1
     C                   END
      *
     C                   ENDSR
      *****************************************************************
     C     DETMSK        BEGSR
      *
     C                   CALL      'UTC000004'
     C                   PARM                    FDFILE
     C                   PARM                    Library
     C                   PARM                    Outfile
     C                   PARM                    OutFMbr
     C                   PARM                    OutFMbrOpt
     C                   IF        *INU7 = *ON and
     C                             *INU8 = *ON
     C                   EVAL      SSERR  = ERR(3)
     C                   EVAL      *INU7 = *OFF
     C                   EVAL      *INU8 = *OFF
     C                   GOTO      ENDFD
     C                   ENDIF
     C                   OPEN      UT000022F
      *
     C                   Z-ADD     1             FDFLDN
     C     1             SETLL     UT000022F
     C                   READ      UT000022F                              99
     C     *IN99         DOWEQ     '0'
     C                   MOVEL     WHFLDI        FDRPGN
     C                   Z-ADD     WHIBO         FDBUFF
     C                   Z-ADD     WHFLDB        FDLENG
     C                   Z-ADD     WHFLDD        FDDIGI
     C                   Z-ADD     WHFLDP        FDDECP
     C                   MOVEL     WHFTXT        FDDESC
     C                   MOVEL     WHCHD1        FDCOL1
     C                   MOVEL     WHCHD2        FDCOL2
     C                   MOVEL     WHFLDT        FDTYPE
     C                   Z-ADD     FDFLDN        FDSEQN
     C                   WRITE     UTFLDDD0
     C                   ADD       1             FDFLDN
      *
     C                   READ      UT000022F                              99
     C                   END
      *
     C                   CLOSE     UT000022F
      *
     C     ENDFD         ENDSR
      *****************************************************************
     C**
     C**   ZALIGN SR. TO VALIDATE AND RIGHT-ALIGN NUMERIC FIELDS.
     C**
     C     ZALIGN        BEGSR                                                  *** ZALIGN ***
     C**
     C                   SETOFF                                       929399
     C**
     C**   SAVE INPUT FIELD IN ARRAY, ZA1.
     C                   MOVEA     ZFIELD        ZA1
     C**
     C**   CALCULATION TO DEFINE NUMBER STRUCTURE CONTROL FIELDS.
     C                   Z-ADD     ZADIG         ZADIG             2 0
     C                   Z-ADD     ZADEC         ZADEC             1 0
     C**
     C**   CALCULATIONS TO DEFINE/CLEAR FIELDS.
     C                   MOVE      ' '           ZA2
     C                   MOVEA     ZA2           ZFIELD           16
     C                   Z-ADD     0             ZX                2 0
     C                   Z-ADD     0             ZY                2 0
     C**
     C**   ENSURE REQUIRED STRUCTURE OF FIELD IS VALID.
     C     ZADIG         ADD       ZADEC         ZZ                2 0
     C     ZZ            COMP      15                                 99
     C   99              GOTO      ZAEND
     C**
     C**   LOOP TO FIND DECIMAL POINT, BLANKS AND CHARACTERS.
     C     ZATAG1        TAG                                                    ** ZATAG1 TAG *
     C     ZX            ADD       1             ZX
     C**
     C**   CHECK FOR DECIMAL POINT. ERROR IF SECOND DECIMAL POINT.
     C     ZA1(ZX)       COMP      '.'                                    90
     C   90
     CAN 93              SETON                                        99
     C   99              GOTO      ZAEND
     C**
     C**
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
     C**
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
     C**
     C**   CLEAR ALPHAMERIC CONSTANT FROM ZA1
     C   96
     COR 97              MOVE      ' '           ZA1(ZX)
     C**
     C**   CHECK FOR BLANKS. BYPASS FOR FIRST BLANK AFTER A DIGIT.
     C     ZA1(ZX)       COMP      ' '                                    91
     C   91
     CAN 92              GOTO      ZATAG2
     C**
     C**   CHECK FOR NUMERIC, IF NOT '.' OR ' '.
     C  N90
     CANN91ZA1(ZX)       COMP      '0'                                  99
     C  N90
     CANN91
     CANN99ZA1(ZX)       COMP      '9'                                99
     C   99              GOTO      ZAEND                                        NOT NUMERIC
     C**
     C**   STORE DIGITS IN ARRAY AND HOW MANY.
     C**   ZY, TOTAL OF DIGITS IN THE INPUT FIELD.
     C**   ZZ, TOTAL OF DIGITS TO THE LEFT OF DECIMAL POINT.
     C  N90
     CANN91ZY            ADD       1             ZY                   92
     C  N90
     CANN91              MOVE      ZA1(ZX)       ZA2(ZY)
     C   90              Z-ADD     ZY            ZZ                   93  93
     C**
     C     ZX            COMP      16                                   94      CHECK IF ALL
     C   94              GOTO      ZATAG1
     C**
     C     ZATAG2        TAG                                                    ** ZATAG2 TAG *
     C**
     C**   IF 'M' SPECIFIED, MULTIPLY ZA1 BY 1 MILLION
     C   96ZZ            ADD       6             ZZ
     C**
     C**   IF 'T' SPECIFIED, MULTIPLY ZA1 BY 1 THOUSAND
     C   97ZZ            ADD       3             ZZ
     C**
     C**   FILL IN ZEROS IN ANY BLANKS LEFT OF DECIMAL POINT
     C   96
     CAN 93
     COR 97
     CAN 93ZZ            DOWGT     ZY
     C     ZY            ADD       1             ZY
     C                   MOVE      '0'           ZA2(ZY)
     C                   END
     C**
     C**   IF CONSTANT SPECIFIED WITH NO DECIMAL POINT ZEROISE BLANKS
     C   96
     CANN93              DO        6
     C     ZY            ADD       1             ZY
     C                   MOVE      '0'           ZA2(ZY)
     C                   END
     C**
     C   97
     CANN93              DO        3
     C     ZY            ADD       1             ZY
     C                   MOVE      '0'           ZA2(ZY)
     C                   END
     C**
     C**   IF NO DECIMAL POINT FOUND, SET TOTAL FIELD ZZ.
     C  N93              Z-ADD     ZY            ZZ
     C**
     C**   CHECK FOR EMBEDDED BLANKS.
     C   91
     CAN 92              MOVEA     ZA1(ZX)       ZFIELD
     C   91
     CAN 92ZFIELD        COMP      ' '                                9999
     C   99              GOTO      ZAEND                                        EMBEDDED BLANK
     C**
     C**   ENSURE THAT NUMBER OF DIGITS ENTERED EITHER SIDE
     C**   OF DECIMAL POINT ARE NOT MORE THAN ALLOWED.
     C     ZZ            COMP      ZADIG                              99
     C     ZY            SUB       ZZ            ZX
     C  N99ZADEC         SUB       ZX            ZX                     9995
     C   99              GOTO      ZAEND
     C   95              GOTO      ZATAG4                                       NO TRAILING
     C**                                                   BLANKS.
     C**   FILL THE TRAILING BLANKS WITH ZEROS.
     C     ZY            ADD       ZX            ZZ
     C     ZATAG3        TAG                                                    ** ZATAG3 TAG *
     C     ZY            ADD       1             ZY
     C                   MOVE      '0'           ZA2(ZY)
     C     ZY            COMP      ZZ                                   94
     C   94              GOTO      ZATAG3
     C**
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
     C**
     C**   MOVE VALIDATED AND RIGHT-ALIGNED NUMBER BACK INTO ZFIELD.
     C                   MOVEA     ZA1           ZFIELD
     C**
     C                   SETOFF                                       9697
     C**
     C     ZAEND         ENDSR                                                  * ZAEND ENDSR *
     C**
     C**
     C********************************************************************
     C**                                                                 *
     C**  ZEDIT SUBROUTINE TO INSERT A DECIMAL POINT INTO A NUMERIC FIELD*
     C**  AND TO BLANK OUT LEADING ZEROES.                               *
     C**      INPUT FIELDS:   ZFIELD 16/                                 *
     C*                       ZADEC                                      *
     C*                       ZADIG - NOT ACTUALLY USED                  *
     C*                                                                  *
     C*       ARRAYS    ZA1 ,ZA2   BOTH 16 ELEMENTS, EACH ONE BYTE LONG. *
     C*                                                                  *
     C*       OUTPUT FIELD   ZFIELD                                      *
     C*                                                                  *
     C     ZEDIT         BEGSR                                                  ***  ZEDIT  ***
     C**
     C**   CALCULATION TO DEFINE NUMBER STRUCTURE CONTROL FIELDS.
     C                   Z-ADD     ZADIG         ZADIG             2 0
     C                   Z-ADD     ZADEC         ZADEC             1 0
     C**                                                                 *
     C*       SET UP WORK FIELDS                                         *
     C*                                                                  *
     C                   MOVEA     ' '           ZA1                                          *
     C                   MOVEA     ' '           ZA2                                          *
     C*                                                                  *
     C                   Z-ADD     16            Z1                2 0                        *
     C                   Z-ADD     16            Z2                2 0                        *
     C*                                                                  *
     C     16            SUB       ZADEC         ZADEC2            2 0                        *
     C*                                                                  *
     C*
     C                   MOVEA     ZFIELD        ZA1                                          *
     C*                                                                  *
     C*       CHECK TO SEE IF THERE ARE ANY DECIMAL PLACES               *
     C*                                                                  *
     C     ZADEC         COMP      0                                      91                  *
     C   91              GOTO      ZT20                                                       *
     C**                                                                 *
     C     ZT10          TAG                                                    ** ZT10 TAG ***
     C**                                                                 *
     C*                                                                  *
     C*       SET UP DECIMALS                                            *
     C*                                                                  *
     C                   MOVE      ZA1(Z1)       ZA2(Z2)                                      *
     C     Z1            SUB       1             Z1                                           *
     C     Z2            SUB       1             Z2                                           *
     C*                                                                  *
     C     Z2            COMP      0                                      90                  *
     C   90              GOTO      ZT30                                                       *
     C*                                                                  *
     C*       CHECK IF END OF DECIMALS                                   *
     C**                                                                 *
     C     Z2            COMP      ZADEC2                             90                      *
     C   90              GOTO      ZT10                                                       *
     C*                                                                  *
     C**                                                                 *
     C*       PUT IN DECIMAL PLACE                                       *
     C*                                                                  *
     C                   MOVE      '.'           ZA2(Z2)                                      *
     C     Z2            SUB       1             Z2                                           *
     C*                                                                  *
     C     ZT20          TAG                                                    ** ZT20 TAG ***
     C*                                                                  *
     C*       SET UP INTEGERS                                            *
     C*                                                                  *
     C                   MOVE      ZA1(Z1)       ZA2(Z2)                                      *
     C     Z1            SUB       1             Z1                                           *
     C     Z2            SUB       1             Z2                                           *
     C**                                                                 *
     C     Z2            COMP      0                                  90                      *
     C   90              GOTO      ZT20                                                       *
     C*                                                                  *
     C*       PUT IN LEADING BLANKS                                      *
     C*                                                                  *
     C     ZT30          TAG                                                    ** ZT30 TAG ***
     C**                                                                 *
     C                   Z-ADD     1             Z2                                           *
     C**                                                                 *
     C     ZT40          TAG                                                    ** ZT40 TAG ***
     C*                                                                  *
     C     ZA2(Z2)       COMP      '0'                                9090                    *
     C   90ZA2(Z2)       COMP      ' '                                9090                    *
     C*                                                                  *
     C   90              GOTO      ZT50                                                       *
     C*                                                                  *
     C                   MOVE      ' '           ZA2(Z2)                                      *
     C     Z2            ADD       1             Z2                                           *
     C*                                                                  *
     C     Z2            COMP      16                                   90                    *
     C   90              GOTO      ZT40                                                       *
     C*                                                                  *
     C*       IF NO INTEGERS PUT IN LEADING ZERO                         *
     C*                                                                  *
     C     ZT50          TAG                                                    ** ZT50 TAG ***
     C*                                                                  *
     C                   Z-ADD     ZADEC2        Z2                                           *
     C  N91Z2            SUB       1             Z2                                           *
     C     ZA2(Z2)       COMP      ' '                                    90                  *
     C   90              MOVE      '0'           ZA2(Z2)                                      *
     C*                                                                  *
     C*       SET UP OUTPUT FIELD                                        *
     C*                                                                  *
     C     ZT60          TAG                                                    ** ZT60 TAG ***
     C*                                                                  *
     C                   MOVEA     ZA2           ZFIELD           16                          *
     C**                                                                 *
     CSR   ZEND          ENDSR                                                  ** ZEND **    *
     C*****************************************************************
** ERR
 End of file
 Start of file
 Error - unable to display fields of file.
** COM
'
