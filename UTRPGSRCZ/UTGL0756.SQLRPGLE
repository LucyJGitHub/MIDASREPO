     H DEBUG
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Utility to convert CEXNO and update CUSXSEQ')          *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  UTGL0756 - Utility to convert CEXNO and update CUSXSEQ       *
      *                                                               *
      *  Function:  This program will convert the CEXNO data area     *
      *             which is a base-36 to base-10 and will update     *
      *             the sequence value to the equivalent base-10      *
      *             value of CEXNO.                                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2015            *
      *                                                               *
      *  Last Amend No. MD034680A          Date 04Aug15               *
      *  Last Amend No. MD034680  *CREATE  Date 04Jul15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD034680A - Amendment made in conversion of character to     *
      *              numeric equivalent                               *
      *  MD034680  - Created the utility                              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     D CEXNUM        E DS                  DTAARA(CEXNO)
     D                                     EXTNAME(CEXNO)
      **
     D CEXNUM1         DS             4
     D  CNO                    1      4A
     D  C1                     1      1A
     D  C2                     2      2A
     D  C3                     3      3A
     D  C4                     4      4A
      **
     D NUMCHAR         C                   CONST('0123456789')
      **
     DEXP              S              1  0
     DSUMTOT           S             10  0
     DCONNUM           S              2  0
     DPROD             S             10  0
     DCONSTR           S              1A
     DPOS              S              1  0
     D SEQVAL          DS
     D  CATCHSEQ                     10  0
     DCOUNT            S             10  0
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE Main Processing
      *****************************************************************

     C     *LOCK         IN        CEXNUM
     C                   EVAL      CNO = CEXNO
     C                   OUT       CEXNUM
      *
     C                   Z-ADD     0             SUMTOT
     C                   MOVE      C1            CONSTR
     C                   MOVE      3             EXP
     C                   EXSR      CONVERT
     C                   ADD       PROD          SUMTOT
      *
     C                   MOVE      C2            CONSTR
     C                   MOVE      2             EXP
     C                   EXSR      CONVERT
     C                   ADD       PROD          SUMTOT
      *
     C                   MOVE      C3            CONSTR
     C                   MOVE      1             EXP
     C                   EXSR      CONVERT
     C                   ADD       PROD          SUMTOT
      *
     C                   MOVE      C4            CONSTR
     C                   MOVE      0             EXP
     C                   EXSR      CONVERT
     C                   ADD       PROD          SUMTOT
      *
     C     SUMTOT        IFLE      200000
     C                   EVAL      COUNT = 0
     C                   ENDIF
      *
     C     SUMTOT        IFGT      200000
     C     SUMTOT        ANDLE     400000
     C                   EVAL      COUNT = 200000
     C/EXEC SQL
     C+ ALTER SEQUENCE CUSXSEQ RESTART WITH 200001
     C/END-EXEC
     C                   ENDIF
      *
     C     SUMTOT        IFGT      400000
     C     SUMTOT        ANDLE     600000
     C                   EVAL      COUNT = 400000
     C/EXEC SQL
     C+ ALTER SEQUENCE CUSXSEQ RESTART WITH 400001
     C/END-EXEC
     C                   ENDIF
      *
     C     SUMTOT        IFGT      600000
     C     SUMTOT        ANDLE     800000
     C                   EVAL      COUNT = 600000
     C/EXEC SQL
     C+ ALTER SEQUENCE CUSXSEQ RESTART WITH 600001
     C/END-EXEC
     C                   ENDIF
      *
     C     SUMTOT        IFGT      800000
     C     SUMTOT        ANDLE     1000000
     C                   EVAL      COUNT = 800000
     C/EXEC SQL
     C+ ALTER SEQUENCE CUSXSEQ RESTART WITH 800001
     C/END-EXEC
     C                   ENDIF
      *
     C     SUMTOT        IFGT      1000000
     C     SUMTOT        ANDLE     1200000
     C                   EVAL      COUNT = 1000000
     C/EXEC SQL
     C+ ALTER SEQUENCE CUSXSEQ RESTART WITH 1000001
     C/END-EXEC
     C                   ENDIF
      *
     C     SUMTOT        IFGT      1200000
     C     SUMTOT        ANDLE     1400000
     C                   EVAL      COUNT = 1200000
     C/EXEC SQL
     C+ ALTER SEQUENCE CUSXSEQ RESTART WITH 1200001
     C/END-EXEC
     C                   ENDIF
      *
     C     SUMTOT        IFGT      1400000
     C     SUMTOT        ANDLE     1600000
     C                   EVAL      COUNT = 1400000
     C/EXEC SQL
     C+ ALTER SEQUENCE CUSXSEQ RESTART WITH 1400001
     C/END-EXEC
     C                   ENDIF
      *
     C     SUMTOT        IFGT      1600000
     C                   EVAL      COUNT = 1600000
     C/EXEC SQL
     C+ ALTER SEQUENCE CUSXSEQ RESTART WITH 1600001
     C/END-EXEC
     C                   ENDIF
      *
      ** update the sequence number
      *
     C                   DOU       COUNT = SUMTOT
     C/EXEC SQL
     C+ SELECT (NEXT VALUE FOR CUSXSEQ) INTO :SEQVAL FROM SYSIBM/SYSDUMMY1
     C/END-EXEC
     C                   EVAL      COUNT = COUNT + 1
     C                   ENDDO
      *
     C                   SETON                                            LR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CONVERT - Convert each character to its equivalent            *
      *           numeric value                                       *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     CONVERT       BEGSR
     C                   Z-ADD     0             PROD
     C                   Z-ADD     0             CONNUM
      *
     C                   MOVE      CONSTR        CONNUM
      *
     C                   EVAL      POS = %CHECK(NUMCHAR : CONSTR)
     C     POS           IFEQ      1
     C**********         ADD       9             CONNUM                                    MD034680A
      *                                                                                    MD034680A
     C     CONSTR        IFEQ      'A'                                                     MD034680A
     C                   EVAL      CONNUM = 10                                             MD034680A
     C                   ENDIF                                                             MD034680A
      *                                                                                    MD034680A
     C     CONSTR        IFEQ      'B'                                                     MD034680A
     C                   EVAL      CONNUM = 11                                             MD034680A
     C                   ENDIF                                                             MD034680A
      *                                                                                    MD034680A
     C     CONSTR        IFEQ      'C'                                                     MD034680A
     C                   EVAL      CONNUM = 12                                             MD034680A
     C                   ENDIF                                                             MD034680A
      *                                                                                    MD034680A
     C     CONSTR        IFEQ      'D'                                                     MD034680A
     C                   EVAL      CONNUM = 13                                             MD034680A
     C                   ENDIF                                                             MD034680A
      *                                                                                    MD034680A
     C     CONSTR        IFEQ      'E'                                                     MD034680A
     C                   EVAL      CONNUM = 14                                             MD034680A
     C                   ENDIF                                                             MD034680A
      *                                                                                    MD034680A
     C     CONSTR        IFEQ      'F'                                                     MD034680A
     C                   EVAL      CONNUM = 15                                             MD034680A
     C                   ENDIF                                                             MD034680A
      *                                                                                    MD034680A
     C     CONSTR        IFEQ      'G'                                                     MD034680A
     C                   EVAL      CONNUM = 16                                             MD034680A
     C                   ENDIF                                                             MD034680A
      *                                                                                    MD034680A
     C     CONSTR        IFEQ      'H'                                                     MD034680A
     C                   EVAL      CONNUM = 17                                             MD034680A
     C                   ENDIF                                                             MD034680A
      *                                                                                    MD034680A
     C     CONSTR        IFEQ      'I'                                                     MD034680A
     C                   EVAL      CONNUM = 18                                             MD034680A
     C                   ENDIF                                                             MD034680A
      *                                                                                    MD034680A
     C     CONSTR        IFEQ      'J'                                                     MD034680A
     C                   EVAL      CONNUM = 19                                             MD034680A
     C                   ENDIF                                                             MD034680A
      *                                                                                    MD034680A
     C     CONSTR        IFEQ      'K'                                                     MD034680A
     C                   EVAL      CONNUM = 20                                             MD034680A
     C                   ENDIF                                                             MD034680A
      *                                                                                    MD034680A
     C     CONSTR        IFEQ      'L'                                                     MD034680A
     C                   EVAL      CONNUM = 21                                             MD034680A
     C                   ENDIF                                                             MD034680A
      *                                                                                    MD034680A
     C     CONSTR        IFEQ      'M'                                                     MD034680A
     C                   EVAL      CONNUM = 22                                             MD034680A
     C                   ENDIF                                                             MD034680A
      *                                                                                    MD034680A
     C     CONSTR        IFEQ      'N'                                                     MD034680A
     C                   EVAL      CONNUM = 23                                             MD034680A
     C                   ENDIF                                                             MD034680A
      *                                                                                    MD034680A
     C     CONSTR        IFEQ      'O'                                                     MD034680A
     C                   EVAL      CONNUM = 24                                             MD034680A
     C                   ENDIF                                                             MD034680A
      *                                                                                    MD034680A
     C     CONSTR        IFEQ      'P'                                                     MD034680A
     C                   EVAL      CONNUM = 25                                             MD034680A
     C                   ENDIF                                                             MD034680A
      *                                                                                    MD034680A
     C     CONSTR        IFEQ      'Q'                                                     MD034680A
     C                   EVAL      CONNUM = 26                                             MD034680A
     C                   ENDIF                                                             MD034680A
      *                                                                                    MD034680A
     C     CONSTR        IFEQ      'R'                                                     MD034680A
     C                   EVAL      CONNUM = 27                                             MD034680A
     C                   ENDIF                                                             MD034680A
      *                                                                                    MD034680A
     C     CONSTR        IFEQ      'S'                                                     MD034680A
     C                   EVAL      CONNUM = 28                                             MD034680A
     C                   ENDIF                                                             MD034680A
      *                                                                                    MD034680A
     C     CONSTR        IFEQ      'T'                                                     MD034680A
     C                   EVAL      CONNUM = 29                                             MD034680A
     C                   ENDIF                                                             MD034680A
      *                                                                                    MD034680A
     C     CONSTR        IFEQ      'U'                                                     MD034680A
     C                   EVAL      CONNUM = 30                                             MD034680A
     C                   ENDIF                                                             MD034680A
      *                                                                                    MD034680A
     C     CONSTR        IFEQ      'V'                                                     MD034680A
     C                   EVAL      CONNUM = 31                                             MD034680A
     C                   ENDIF                                                             MD034680A
      *                                                                                    MD034680A
     C     CONSTR        IFEQ      'W'                                                     MD034680A
     C                   EVAL      CONNUM = 32                                             MD034680A
     C                   ENDIF                                                             MD034680A
      *                                                                                    MD034680A
     C     CONSTR        IFEQ      'X'                                                     MD034680A
     C                   EVAL      CONNUM = 33                                             MD034680A
     C                   ENDIF                                                             MD034680A
      *                                                                                    MD034680A
     C     CONSTR        IFEQ      'Y'                                                     MD034680A
     C                   EVAL      CONNUM = 34                                             MD034680A
     C                   ENDIF                                                             MD034680A
      *                                                                                    MD034680A
     C     CONSTR        IFEQ      'Z'                                                     MD034680A
     C                   EVAL      CONNUM = 35                                             MD034680A
     C                   ENDIF                                                             MD034680A
      *                                                                                    MD034680A
     C                   ENDIF
      *
     C                   EVAL      PROD = CONNUM*(36**EXP)
     C                   ENDSR

      *****************************************************************
