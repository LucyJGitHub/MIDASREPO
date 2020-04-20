000100150701     H DEBUG
000101150701      *****************************************************************
000102150703/*STD *  RPGSQLMOD                                                    *
000103150703/*EXI *  TEXT('Utility to convert CEXNO and update CUSXSEQ')          *
000104150701      *****************************************************************
000105150701      *                                                               *
000106150701      *  Midas - Retail Module                                        *
000107150701      *                                                               *
000108150703      *  UTGL0756 - Utility to convert CEXNO and update CUSXSEQ       *
000110150701      *                                                               *
000111150703      *  Function:  This program will convert the CEXNO data area     *
000112150703      *             which is a base-36 to base-10 and will update     *
000113150703      *             the sequence value to the equivalent base-10      *
000114150703      *             value of CEXNO.                                   *
000115150701      *                                                               *
000116150701      *  (c) Misys International Banking Systems Ltd. 2015            *
000117150701      *                                                               *
000118150823      *  Last Amend No. MD034680A          Date 04Aug15               *
000122150703      *  Last Amend No. MD034680  *CREATE  Date 04Jul15               *
000124150701      *                                                               *
000125150701      *---------------------------------------------------------------*
000126150701      *                                                               *
000127150823      *  MD034680A - Amendment made in conversion of character to     *
000128150823      *              numeric equivalent                               *
000129150703      *  MD034680  - Created the utility                              *
000130150701      *                                                               *
000131150701      *****************************************************************
000132150701      ** +--------------------------------------+
000133150701      ** ¦ D-specs                              ¦
000134150701      ** ¦ =======                              ¦
000135150701      ** +--------------------------------------+
000136150701
000145150701     D CEXNUM        E DS                  DTAARA(CEXNO)
000146150701     D                                     EXTNAME(CEXNO)
000148150701      **
000149150701     D CEXNUM1         DS             4
000150150701     D  CNO                    1      4A
000151150701     D  C1                     1      1A
000152150701     D  C2                     2      2A
000153150701     D  C3                     3      3A
000154150701     D  C4                     4      4A
000156150701      **
000158150703     D NUMCHAR         C                   CONST('0123456789')
000159150701      **
000161150701     DEXP              S              1  0
000162150705     DSUMTOT           S             10  0
000163150701     DCONNUM           S              2  0
000164150705     DPROD             S             10  0
000165150701     DCONSTR           S              1A
000166150701     DPOS              S              1  0
000168150703     D SEQVAL          DS
000169150705     D  CATCHSEQ                     10  0
000170150705     DCOUNT            S             10  0
000172150701      *****************************************************************
000173150701      /EJECT
000174150701      *****************************************************************
000175150701      /TITLE Main Processing
000176150701      *****************************************************************
000177150701
000178150701     C     *LOCK         IN        CEXNUM
000179150701     C                   EVAL      CNO = CEXNO
000180150701     C                   OUT       CEXNUM
000185150701      *
000186150701     C                   Z-ADD     0             SUMTOT
000187150701     C                   MOVE      C1            CONSTR
000188150701     C                   MOVE      3             EXP
000189150701     C                   EXSR      CONVERT
000190150701     C                   ADD       PROD          SUMTOT
000191150701      *
000192150701     C                   MOVE      C2            CONSTR
000193150701     C                   MOVE      2             EXP
000194150701     C                   EXSR      CONVERT
000195150701     C                   ADD       PROD          SUMTOT
000196150701      *
000197150701     C                   MOVE      C3            CONSTR
000198150701     C                   MOVE      1             EXP
000199150701     C                   EXSR      CONVERT
000200150701     C                   ADD       PROD          SUMTOT
000201150701      *
000202150701     C                   MOVE      C4            CONSTR
000203150701     C                   MOVE      0             EXP
000204150701     C                   EXSR      CONVERT
000205150701     C                   ADD       PROD          SUMTOT
000269150705      *
000270150705     C     SUMTOT        IFLE      200000
000271150705     C                   EVAL      COUNT = 0
000272150705     C                   ENDIF
000273150705      *
000274150705     C     SUMTOT        IFGT      200000
000275150705     C     SUMTOT        ANDLE     400000
000276150705     C                   EVAL      COUNT = 200000
000277150705     C/EXEC SQL
000278150705     C+ ALTER SEQUENCE CUSXSEQ RESTART WITH 200001
000279150705     C/END-EXEC
000280150705     C                   ENDIF
000281150705      *
000282150705     C     SUMTOT        IFGT      400000
000283150705     C     SUMTOT        ANDLE     600000
000284150705     C                   EVAL      COUNT = 400000
000285150705     C/EXEC SQL
000286150705     C+ ALTER SEQUENCE CUSXSEQ RESTART WITH 400001
000287150705     C/END-EXEC
000288150705     C                   ENDIF
000289150705      *
000290150705     C     SUMTOT        IFGT      600000
000291150705     C     SUMTOT        ANDLE     800000
000292150705     C                   EVAL      COUNT = 600000
000293150705     C/EXEC SQL
000294150705     C+ ALTER SEQUENCE CUSXSEQ RESTART WITH 600001
000295150705     C/END-EXEC
000296150705     C                   ENDIF
000297150705      *
000298150705     C     SUMTOT        IFGT      800000
000299150705     C     SUMTOT        ANDLE     1000000
000301150705     C                   EVAL      COUNT = 800000
000302150705     C/EXEC SQL
000303150705     C+ ALTER SEQUENCE CUSXSEQ RESTART WITH 800001
000304150705     C/END-EXEC
000305150705     C                   ENDIF
000306150705      *
000307150705     C     SUMTOT        IFGT      1000000
000308150705     C     SUMTOT        ANDLE     1200000
000310150705     C                   EVAL      COUNT = 1000000
000311150705     C/EXEC SQL
000312150705     C+ ALTER SEQUENCE CUSXSEQ RESTART WITH 1000001
000313150705     C/END-EXEC
000314150705     C                   ENDIF
000315150705      *
000316150705     C     SUMTOT        IFGT      1200000
000317150705     C     SUMTOT        ANDLE     1400000
000318150705     C                   EVAL      COUNT = 1200000
000319150705     C/EXEC SQL
000320150705     C+ ALTER SEQUENCE CUSXSEQ RESTART WITH 1200001
000321150705     C/END-EXEC
000322150705     C                   ENDIF
000323150705      *
000324150705     C     SUMTOT        IFGT      1400000
000325150705     C     SUMTOT        ANDLE     1600000
000326150705     C                   EVAL      COUNT = 1400000
000327150705     C/EXEC SQL
000328150705     C+ ALTER SEQUENCE CUSXSEQ RESTART WITH 1400001
000329150705     C/END-EXEC
000330150705     C                   ENDIF
000331150705      *
000332150705     C     SUMTOT        IFGT      1600000
000333150705     C                   EVAL      COUNT = 1600000
000334150705     C/EXEC SQL
000335150705     C+ ALTER SEQUENCE CUSXSEQ RESTART WITH 1600001
000336150705     C/END-EXEC
000337150705     C                   ENDIF
000338150705      *
000404150705      ** update the sequence number
000405150705      *
000437150705     C                   DOU       COUNT = SUMTOT
000438150705     C/EXEC SQL
000439150705     C+ SELECT (NEXT VALUE FOR CUSXSEQ) INTO :SEQVAL FROM SYSIBM/SYSDUMMY1
000440150705     C/END-EXEC
000441150705     C                   EVAL      COUNT = COUNT + 1
000442150705     C                   ENDDO
000443150705      *
000444150701     C                   SETON                                            LR
000445150701      *****************************************************************
000446150701      /EJECT
000447150701      *****************************************************************
000448150701      *                                                               *
000449150703      * CONVERT - Convert each character to its equivalent            *
000450150703      *           numeric value                                       *
000451150701      *                                                               *
000452150703      * Called by: Main Processing                                    *
000453150701      *                                                               *
000454150701      * Calls: None                                                   *
000455150701      *                                                               *
000456150701      *****************************************************************
000457150701     C     CONVERT       BEGSR
000458150701     C                   Z-ADD     0             PROD
000459150701     C                   Z-ADD     0             CONNUM
000460150701      *
000461150701     C                   MOVE      CONSTR        CONNUM
000462150701      *
000463150701     C                   EVAL      POS = %CHECK(NUMCHAR : CONSTR)
000464150701     C     POS           IFEQ      1
000465150823     C**********         ADD       9             CONNUM                                    MD034680A
000466150823      *                                                                                    MD034680A
000467150823     C     CONSTR        IFEQ      'A'                                                     MD034680A
000570150823     C                   EVAL      CONNUM = 10                                             MD034680A
000571150823     C                   ENDIF                                                             MD034680A
000572150823      *                                                                                    MD034680A
000573150823     C     CONSTR        IFEQ      'B'                                                     MD034680A
000574150823     C                   EVAL      CONNUM = 11                                             MD034680A
000575150823     C                   ENDIF                                                             MD034680A
000576150823      *                                                                                    MD034680A
000577150823     C     CONSTR        IFEQ      'C'                                                     MD034680A
000578150823     C                   EVAL      CONNUM = 12                                             MD034680A
000579150823     C                   ENDIF                                                             MD034680A
000580150823      *                                                                                    MD034680A
000581150823     C     CONSTR        IFEQ      'D'                                                     MD034680A
000582150823     C                   EVAL      CONNUM = 13                                             MD034680A
000583150823     C                   ENDIF                                                             MD034680A
000584150823      *                                                                                    MD034680A
000585150823     C     CONSTR        IFEQ      'E'                                                     MD034680A
000586150823     C                   EVAL      CONNUM = 14                                             MD034680A
000587150823     C                   ENDIF                                                             MD034680A
000588150823      *                                                                                    MD034680A
000589150823     C     CONSTR        IFEQ      'F'                                                     MD034680A
000590150823     C                   EVAL      CONNUM = 15                                             MD034680A
000591150823     C                   ENDIF                                                             MD034680A
000592150823      *                                                                                    MD034680A
000593150823     C     CONSTR        IFEQ      'G'                                                     MD034680A
000594150823     C                   EVAL      CONNUM = 16                                             MD034680A
000595150823     C                   ENDIF                                                             MD034680A
000596150823      *                                                                                    MD034680A
000597150823     C     CONSTR        IFEQ      'H'                                                     MD034680A
000598150823     C                   EVAL      CONNUM = 17                                             MD034680A
000599150823     C                   ENDIF                                                             MD034680A
000600150823      *                                                                                    MD034680A
000601150823     C     CONSTR        IFEQ      'I'                                                     MD034680A
000602150823     C                   EVAL      CONNUM = 18                                             MD034680A
000603150823     C                   ENDIF                                                             MD034680A
000604150823      *                                                                                    MD034680A
000605150823     C     CONSTR        IFEQ      'J'                                                     MD034680A
000606150823     C                   EVAL      CONNUM = 19                                             MD034680A
000607150823     C                   ENDIF                                                             MD034680A
000608150823      *                                                                                    MD034680A
000609150823     C     CONSTR        IFEQ      'K'                                                     MD034680A
000610150823     C                   EVAL      CONNUM = 20                                             MD034680A
000611150823     C                   ENDIF                                                             MD034680A
000612150823      *                                                                                    MD034680A
000613150823     C     CONSTR        IFEQ      'L'                                                     MD034680A
000614150823     C                   EVAL      CONNUM = 21                                             MD034680A
000615150823     C                   ENDIF                                                             MD034680A
000616150823      *                                                                                    MD034680A
000617150823     C     CONSTR        IFEQ      'M'                                                     MD034680A
000618150823     C                   EVAL      CONNUM = 22                                             MD034680A
000619150823     C                   ENDIF                                                             MD034680A
000620150823      *                                                                                    MD034680A
000621150823     C     CONSTR        IFEQ      'N'                                                     MD034680A
000622150823     C                   EVAL      CONNUM = 23                                             MD034680A
000623150823     C                   ENDIF                                                             MD034680A
000624150823      *                                                                                    MD034680A
000625150823     C     CONSTR        IFEQ      'O'                                                     MD034680A
000626150823     C                   EVAL      CONNUM = 24                                             MD034680A
000627150823     C                   ENDIF                                                             MD034680A
000628150823      *                                                                                    MD034680A
000629150823     C     CONSTR        IFEQ      'P'                                                     MD034680A
000630150823     C                   EVAL      CONNUM = 25                                             MD034680A
000631150823     C                   ENDIF                                                             MD034680A
000632150823      *                                                                                    MD034680A
000633150823     C     CONSTR        IFEQ      'Q'                                                     MD034680A
000634150823     C                   EVAL      CONNUM = 26                                             MD034680A
000635150823     C                   ENDIF                                                             MD034680A
000636150823      *                                                                                    MD034680A
000637150823     C     CONSTR        IFEQ      'R'                                                     MD034680A
000638150823     C                   EVAL      CONNUM = 27                                             MD034680A
000639150823     C                   ENDIF                                                             MD034680A
000640150823      *                                                                                    MD034680A
000641150823     C     CONSTR        IFEQ      'S'                                                     MD034680A
000642150823     C                   EVAL      CONNUM = 28                                             MD034680A
000643150823     C                   ENDIF                                                             MD034680A
000644150823      *                                                                                    MD034680A
000645150823     C     CONSTR        IFEQ      'T'                                                     MD034680A
000646150823     C                   EVAL      CONNUM = 29                                             MD034680A
000647150823     C                   ENDIF                                                             MD034680A
000648150823      *                                                                                    MD034680A
000649150823     C     CONSTR        IFEQ      'U'                                                     MD034680A
000650150823     C                   EVAL      CONNUM = 30                                             MD034680A
000651150823     C                   ENDIF                                                             MD034680A
000652150823      *                                                                                    MD034680A
000653150823     C     CONSTR        IFEQ      'V'                                                     MD034680A
000654150823     C                   EVAL      CONNUM = 31                                             MD034680A
000655150823     C                   ENDIF                                                             MD034680A
000656150823      *                                                                                    MD034680A
000657150823     C     CONSTR        IFEQ      'W'                                                     MD034680A
000658150823     C                   EVAL      CONNUM = 32                                             MD034680A
000659150823     C                   ENDIF                                                             MD034680A
000660150823      *                                                                                    MD034680A
000661150823     C     CONSTR        IFEQ      'X'                                                     MD034680A
000662150823     C                   EVAL      CONNUM = 33                                             MD034680A
000663150823     C                   ENDIF                                                             MD034680A
000664150823      *                                                                                    MD034680A
000665150823     C     CONSTR        IFEQ      'Y'                                                     MD034680A
000666150823     C                   EVAL      CONNUM = 34                                             MD034680A
000667150823     C                   ENDIF                                                             MD034680A
000668150823      *                                                                                    MD034680A
000669150823     C     CONSTR        IFEQ      'Z'                                                     MD034680A
000670150823     C                   EVAL      CONNUM = 35                                             MD034680A
000671150823     C                   ENDIF                                                             MD034680A
000672150823      *                                                                                    MD034680A
000673150701     C                   ENDIF
000674150701      *
000675150701     C                   EVAL      PROD = CONNUM*(36**EXP)
000676150701     C                   ENDSR
000677150701
000678150701      *****************************************************************
