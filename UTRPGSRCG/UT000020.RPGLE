     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Display results of CMPF')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UT000020 - Display results of CMPF                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. BUG27790 *CREATE    Date 24Jun10              *
      *  Prev Amend No. xxxxxx              Date ddMmmyy              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  BUG27790 - New utility                                       *
      *                                                               *
      *****************************************************************
     FUT000020DFCF   E             WORKSTN
     F                                     SFILE(SUBFLREC:RRN)
     FUTCMPFPD  IF   E           K DISK
      *
     D PFile           S             10
     D PKFile          S             10
     D PKFlds          S            120
     D PDspNoDiff      S              4
     D Cx              S              2  0
     D Ix              S              2  0
     D HI              S              1
     D Select          S              1
     D PMode           S              1
     D Type            S              2
     D PrvSearch       S             50
     D WSearch         S             50
     D W50             S             50
     D PrvMtch         S              1
     D WSeqn           S             10  0
     D WFil1           S             10
     D WFil2           S             10
     D WJob            S             26
     D X               S              3  0
     D Y               S              2  0
      *
      * QCLSCAN variables.
     D SearchStr       S            256
     D SearchLen       S              3  0 INZ(256)
     D StrPos          S              3  0 INZ(1)
     D FindStr         S             50
     D FindLen         S              3  0 INZ(50)
     D Transl          S              1    INZ('1')
     D Trim            S              1    INZ('1')
     D WildCard        S              1    INZ('?')
     D FindPos         S              3  0
      *
     D UBA             S              1    DIM(4400)
     D UPA             S              1    DIM(4400)
     D ERR             S             76    DIM(2) CTDATA PERRCD(1)
     D CHR             S              1    DIM(91) CTDATA PERRCD(70)
     D ZA1             S              1    DIM(16)                              ZALIGN SR. ARRAY
     D ZA2             S              1    DIM(16)                              ZALIGN SR. ARRAY
      *
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      *
     D                 DS
     D  XXJOB                  1     26
     D  JOJOB                  1     10
     D  JOUSER                11     20
     D  JONBR                 21     26  0
     D  JONBRA                21     26
      *
     D                 DS
     D  SSSEQA                 1     10
     D  JOS                    1     10
     D                                     DIM(10)
      *
     D                 DS
     D  SSSRCH                 1     50
     D  SEA                    1     50
     D                                     DIM(50)
      *
     D                 DS
     D  WKFld                  1    120
     D  SSKF01                 1     10
     D  SSKF02                11     20
     D  SSKF03                21     30
     D  SSKF04                31     40
     D  SSKF05                41     50
     D  SSKF06                51     60
     D  SSKF07                61     70
     D  SSKF08                71     80
     D  SSKF09                81     90
     D  SSKF10                91    100
     D  SSKF11               101    110
     D  SSKF12               111    120
      *
     C                   EVAL      Cx = 15
      * For Hi-intensity.
     C                   BITOFF    '01234567'    HI
     C                   BITON     '267'         HI
     C                   MOVEL     HI            ERR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PFile
     C                   PARM                    PKFile
     C                   PARM                    PKFlds
     C                   PARM                    PDspNoDiff
      *
     C                   EVAL      SSUSER = ##USR
     C                   EVAL      SSJOB  = ##JOB
     C                   EVAL      SSTFIL = PFile
     C                   EVAL      SSKEYF = PKFile
     C                   EVAL      WKFld  = PKFlds
      *
     C                   IF        PDSpNoDiff <> '*YES'
     C                   READ      UTCMPFPD                               LR
     C   LR              RETURN
     C                   ENDIF
      *
     C                   EVAL      CFSEQN = 0
     C                   DOW       *INKC = *OFF
     C                   EXSR      DisplayScreen
     C                   END
      *
     C                   MOVEL     WKFld         PKFlds
     C                   EVAL      *INLR = *ON
      *
      *****************************************************************
      *                                                               *
      * DisplayScreen - Display screen of CMPF results                *
      *                                                               *
      *****************************************************************
     C     DisplayScreen BEGSR
      *
      * Fill subfile.
     C                   EXSR      FillSubfile
      *
     C                   IF        CFSEQN <> 0
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      CFSEQN        ZFIELD
     C                   Z-ADD     10            ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SSSEQA
     C                   ELSE
     C                   EVAL      SSSEQA = *blanks
     C                   ENDIF
      *
     C                   WRITE     SUBFLCTL
     C                   WRITE     SUBMESS
     C                   READ      SUBFLCTL                               99
     C                   EVAL      SSERR = *blanks
      *
      * Convert input field.
     C                   EVAL      X = 1
     C     'B'           LOOKUP    JOS(X)                                 99
     C                   IF        *IN99 = *ON
     C                   EVAL      WSeqn  = *hival
     C                   EVAL      *IN05 = *ON
     C                   ELSE
     C     'T'           LOOKUP    JOS(X)                                 99
     C                   IF        *IN99 = *ON
     C                   EVAL      CFSEQN = 0
     C                   ELSE
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SSSEQA        ZFIELD
     C                   EVAL      ZADIG = 10
     C                   EVAL      ZADEC = 0
     C                   EXSR      ZALIGN
     C   99              EVAL      CFSEQN = 1
     C  N99              MOVE      ZFIELD        CFSEQN
     C                   ENDIF
     C                   ENDIF
      *
      * Change of view.
     C                   IF        SSSRCH <> PrvSearch
     C                   EVAL      CFSEQN = 0
     C                   ENDIF
     C                   EVAL      PrvSearch = SSSRCH
     C                   IF        SSMTCH <> PrvMtch
     C                   EVAL      CFSEQN = 0
     C                   ENDIF
     C                   EVAL      PrvMtch = SSMTCH
      * Rolldown.
     C                   IF        *IN05 = *ON
     C                   EXSR      Rolldown
     C                   ENDIF
      * Select.
     C                   IF        *IN(04) = '0'
      * Record changed.
     C                   READC     SUBFLREC                               99
     C                   DOW       *IN99 = *OFF
     C                   EVAL      PMode = *blanks
     C                   IF        SSACTN <> *blanks
     C     CFSEQN        CHAIN     UTCMPFPD                           99
     C                   EVAL      PMode = *blanks
     C                   MOVEA     CFDATA        UBA
     C                   MOVEA     *BLANK        UPA
     C                   EVAL      Type = CFTYPE
      *
     C                   IF        CFTYPE = 'U1' or
     C                             CFTYPE = 'M1'
     C                   EVAL      Type = 'U1'
     C                   EVAL      CFSEQN = CFSEQN + 1
     C     CFSEQN        CHAIN     UTCMPFPD                           99
     C                   MOVEA     CFDATA        UPA
     C                   ELSE
     C                   IF        CFTYPE = 'U2' or
     C                             CFTYPE = 'M2'
     C                   EVAL      Type = 'UP'
     C                   EVAL      CFSEQN = CFSEQN - 1
     C     CFSEQN        CHAIN     UTCMPFPD                           99
     C                   MOVEA     CFDATA        UPA
     C                   ENDIF
     C                   ENDIF
      *
     C                   CALL      'UT000021'
     C                   PARM                    PFile
     C                   PARM                    PMode
     C                   PARM                    UBA
     C                   PARM                    UPA
     C                   PARM                    Type
      *
     C                   ENDIF
     C                   EVAL      CFSEQN = WSeqn
     C                   IF        PMode <> 'X'
      * Record changed.
     C                   READC     SUBFLREC                               99
     C                   ELSE
     C                   EVAL      *IN99 = *ON
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   EVAL      PKFile = SSKEYF
      *
     C     DisplayScreenEENDSR
      *
      *****************************************************************
      *                                                               *
      * FillSubfile - Populate subfile records.                       *
      *                                                               *
      *****************************************************************
     C     FillSubfile   BEGSR
      *
     C                   MOVEA     '000'         *IN(1)
     C                   MOVEA     '1'           *IN(4)
     C                   EVAL      RRN = 0
     C                   WRITE     SUBFLCTL                                     *
     C     CFSEQN        SETLL     UTCMPFPD
     C                   EXSR      ReadFile
     C                   IF        *IN99 = *OFF
     C                   EVAL      WSeqn  = CFSEQN
     C                   EVAL      WFil1  = CFFIL1
     C                   EVAL      WFil2  = CFFIL2
     C*                  EVAL      WJob   = XXJOB
     C                   ELSE
     C                   EVAL      WSeqn  = 0
     C                   EVAL      WFil1  = *blanks
     C                   EVAL      WFil2  = *blanks
     C                   EVAL      WJob   = *blanks
     C                   EVAL      CFSEQN = 0
     C                   IF        SSERR = *blanks
      * End of file.
     C                   MOVEL     ERR(1)        SSERR
     C                   ENDIF
     C                   ENDIF
      *
     C                   DOW       *IN99 = *OFF
     C                   ADD       1             RRN               4 0    04
      *
     C                   IF        CFRRN1 <> 0
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      CFRRN1        ZFIELD
     C                   Z-ADD     10            ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SSRRN1
     C                   ELSE
     C                   EVAL      SSRRN1 = *blanks
     C                   ENDIF
      *
     C                   IF        CFRRN2 <> 0
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      CFRRN2        ZFIELD
     C                   Z-ADD     10            ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SSRRN2
     C                   ELSE
     C                   EVAL      SSRRN2 = *blanks
     C                   ENDIF
      *
     C                   IF        CFTYPE = 'U1'
     C                   EVAL      SSTYPE = 'Difference'
     C                   ELSE
     C                   IF        CFTYPE = 'M1'
     C                   EVAL      SSTYPE = 'Match     '
     C                   ELSE
     C                   IF        CFFIL1 <> *BLANK
     C                   EVAL      SSTYPE = 'File1 only'
     C                   ELSE
     C                   EVAL      SSTYPE = 'File2 only'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   MOVEA     CFDATA        UBA
      * Validate characters.
     C                   EVAL      X = 0
     C                   DOU       X = 60
     C                   EVAL      X = X + 1
     C                   EVAL      Y = 1
     C     UBA(X)        LOOKUP    CHR(Y)                                 99
     C                   IF        *IN99 = *OFF
     C                   EVAL      UBA(X) = *blanks
     C                   ENDIF
     C                   ENDDO
      *
     C                   MOVEA     UBA           SSDATA
      *
     C                   EVAL      *IN40 = *OFF
      *
     C                   WRITE     SUBFLREC
     C                   IF        RRN = Cx
     C                   EXSR      ReadFile
     C                   IF        *IN99 = *ON
     C                   EVAL      CFSEQN = 0
     C                   IF        SSERR = *blanks
      * End of File.
     C                   MOVEL     ERR(1)        SSERR
     C                   ENDIF
     C                   ELSE
     C                   EVAL      *IN99 = *ON
     C                   ENDIF
     C                   ELSE
     C                   EXSR      ReadFile
     C                   IF        *IN99 = *ON
     C                   EVAL      CFSEQN = 0
     C                   IF        SSERR = *blanks
      * End of file.
     C                   MOVEL     ERR(1)        SSERR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   IF        *IN(4) = '1'
     C                   MOVEA     '010'         *IN(1)
     C                   ELSE
     C                   MOVEA     '111'         *IN(1)
     C                   ENDIF
      *
     C     FillSubfileE  ENDSR
      *
      *****************************************************************
      *                                                               *
      * Rolldown - Subfile rolldown.                                  *
      *                                                               *
      *****************************************************************
     C     Rolldown      BEGSR
      *
     C                   EVAL      RRN = 0
     C                   EVAL      CFSEQN = WSeqn
     C     CFSEQN        SETGT     UTCMPFPD
     C                   EXSR      ReadPrev
      *
     C                   DOW       *IN99 = *OFF and
     C                             RRN < Cx
     C                   EXSR      ReadPrev
     C                   EVAL      RRN = RRN + 1
     C                   ENDDO
      *
     C                   IF        *IN99 = *ON
     C                   EVAL      CFSEQN = 0
      * Start of file.
     C                   MOVEL     ERR(2)        SSERR
     C                   ENDIF
      *
     C     RolldownE     ENDSR
      *****************************************************************
      *                                                               *
      * ReadFile - Read comparison data.                              *
      *                                                               *
      *****************************************************************
     C     ReadFile      BEGSR
      *
     C                   READ      UTCMPFPD                               99
     C                   EXSR      Selection
     C                   DOW       Select = 'N'
     C                   READ      UTCMPFPD                               99
     C                   EXSR      Selection
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * ReadPrev - Read comparison data, previous record.             *
      *                                                               *
      *****************************************************************
     C     ReadPrev      BEGSR
      *
     C                   READP     UTCMPFPD                               99
     C                   EXSR      Selection
     C                   DOW       Select = 'N'
     C                   READP     UTCMPFPD                               99
     C                   EXSR      Selection
     C                   ENDDO
      *
     C     ReadPrevE     ENDSR
      *
      *****************************************************************
      *                                                               *
      * Selection - Select records.                                   *
      *                                                               *
      *****************************************************************
     C     Selection     BEGSR
      *
     C                   IF        *IN99 = *ON
     C                   EVAL      Select = '*'
     C                   ELSE
     C                   IF        CFTYPE = 'U2' or
     C                             CFTYPE = 'M2'
     C                   EVAL      Select = 'N'
     C                   ELSE
     C                   EVAL      Select = 'Y'
     C                   IF        SSSRCH <> *blanks
     C                   MOVEA     CFDATA        UBA
      * Valid characters.
     C                   EVAL      X = 0
     C                   DOU       X = 256
     C                   EVAL      X = X + 1
     C                   EVAL      Y = 1
     C     UBA(X)        LOOKUP    CHR(Y)                                 98    *
     C     *IN98         IFEQ      '0'
     C                   EVAL      UBA(X) = *blanks
     C                   ENDIF
     C                   ENDDO
      *
     C                   EVAL      WSearch = SSSRCH
     C                   EVAL      FindStr = *blanks
     C                   EVAL      W50 = *blanks
      *
     C                   EVAL      Ix = 1
     C     '¦'           LOOKUP    SEA(Ix)                                98
     C   98              EVAL      Ix = Ix + 1
     C   98              MOVEA     SEA(Ix)       FindStr
     C   98              EVAL      Ix = Ix - 1
     C   98              MOVEA     W50           SEA(Ix)
     C   98              EXSR      FindIt
     C   98              IF        FindPos < 1
     C                   EVAL      Select = 'N'
     C                   ENDIF
      *
     C                   EVAL      FindStr = SSSRCH
     C                   EXSR      FindIt
     C                   IF        FindPos < 1
     C                   EVAL      Select = 'N'
     C                   ENDIF
      *
     C                   EVAL      SSSRCH = WSearch
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        Select = 'Y' and
     C                             SSMTCH <> *blanks
      *
     C                   IF        SSMTCH = 'M' and
     C                             CFTYPE <> 'M1'
     C                   EVAL      Select = 'N'
     C                   ENDIF
     C                   IF        SSMTCH = 'D' and
     C                             CFTYPE <> 'U1'
     C                   EVAL      Select = 'N'
     C                   ENDIF
     C                   IF        SSMTCH = '1' and
     C                             CFTYPE = 'U1' or
     C                             SSMTCH = '1' and
     C                             CFTYPE = 'M1' or
     C                             SSMTCH = '1' and
     C                             CFTYPE = 'EX' and
     C                             CFFIL1 = *blank
     C                   EVAL      Select = 'N'
     C                   ENDIF
     C                   IF        SSMTCH = '2' and
     C                             CFTYPE = 'U1' or
     C                             SSMTCH = '2' and
     C                             CFTYPE = 'M1' or
     C                             SSMTCH = '2' and
     C                             CFTYPE = 'EX' and
     C                             CFFIL2 = *blank
     C                   EVAL      Select = 'N'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     SelectionE    ENDSR
      *****************************************************************
      *                                                               *
      * FindIt - Find searched value.                                 *
      *                                                               *
      *****************************************************************
     C     FindIt        BEGSR
      *
     C                   MOVEA     UBA           SearchStr
      * Scan for search string.
     C                   CALL      'QCLSCAN'
     C                   PARM                    SearchStr
     C                   PARM                    SearchLen
     C                   PARM                    StrPos
     C                   PARM                    FindStr
     C                   PARM                    FindLen
     C                   PARM                    Transl
     C                   PARM                    Trim
     C                   PARM                    WildCard
     C                   PARM                    FindPos
      *
     C     FindItE       ENDSR
      *
     C********************************************************************
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
** CHR
 ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz|"$¢%&'()=~-¬@!;:
#,./{+*}<>?0123456789
