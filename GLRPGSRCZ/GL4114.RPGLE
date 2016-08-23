     H DEBUG
      *****************************************************************
/*S*D ***RPGBASE*******************************************************                       CGL120
/*STD *  RPGBASEBNC                                                   *                       CGL120
/*EXI *  TEXT('Midas GL Daily Journal Summary Extract')               *
     F*****************************************************************
     F*                                                               *
     F*    Midas - General Ledger Module                          *
     F*                                                               *
     F*    GL4114 - Daily Journal Summary Extract                     *
     F*                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD024065           Date 11Dec13               *
      *  Prev Amend No. CGL127AQ           Date 06Aug12               *
      *                 CGL120             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP204             Date 03Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 243067             Date 18OCt06               *
      *                 BUG9310 (Reopen)   Date 16Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9310            Date 24Nov05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CGL007             Date 26Mar99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CRT001 *Create     Date 28Feb95               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD024065 - Series of logs with decimal data error were       *
      *             produced by GLC4114 component                     *
      *  CGL127AQ - COB Restructure - GL COB Optimisation Phase 1     *
      *  CGL120 - GL COB Components Task Split                        *
      *  CAP204  - Retail Account Transfer                            *
      *            Replace ACPO1 processing by GLACPML0 to include    *
      *            GLACPOL0 postings                                  *
      *  243067 - Foob in GL4114 (GLC30). Field Nore of trailer file  *
      *           GEFPZZ contains number of records of file GEFEPD    *
      *           and never NORE plus 2 like other GExxxx files       *
      *  BUG9310- Reopen.  Remove code unnecessary subtracting 2      *
      *           from PCOUNT.                                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9310- Ensure NORE is accumulated properly.                *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL007 - Account Postings Enquiry                            *
     F*    CRT001 - Retail Teller System                              *
     F*                                                               *
     F*****************************************************************
     F*
     F***ACPO1***IP  F     316  1AI     1 DISK                            CGL007
     F***ACPO1** IP  F     331  1AI     1 DISK                                         CGL007 CGL029
     F***ACPO1   IP  F     620  1AI     1 DISK                                         CGL029 CAP204
     F***GLACPML0IP  F     620  1AI     1 DISK                                       CAP204 CGL127AQ
     FACPO1     IP   F  620     1AIDISK    KEYLOC(1)                                        CGL127AQ
     FGETXPD    IS   F  620     1AIDISK    KEYLOC(1)                                        CGL127AQ
     FACPO1Z    IS   F  160     1AIDISK    KEYLOC(1)
     FACJXH     O    E             DISK
     FACJXD     O    E             DISK
     FACJXT     O    E             DISK
     FGL4114AU  O    E             PRINTER
     F*
     F*****************************************************************
     F*                                                               *
     F*   F U N C T I O N   O F   I N D I C A T O R S                 *
     F*                                                               *
     F*   01  -   HEADER RECORD                                       *
     F*   02  -   POSTING RECORD                                      *
     F*   04  -   TRAILER                                             *
     F*   05  -   CATCHALL                                            *
     F*                                                               *
     F*   20  -   FIRST CYCLE INDICATOR                               *
     F*   30  -   SOURCE OF POSTING = GE-TT                           *
     F*   35  -   ORIGINATING BRANCH CODE IS BLANK                    *
     F*   40  -   HASH TOTALS DISAGREE                                *
     F*   41  -   NUMBER OF RECORDS DISAGREE                          *
     F*                                                               *
     F*   75  -   CHAIN FAIL INDICATOR                                *
     F*                                                               *
     F*   U1  -   FT MODULE IN USE                                    *
     F*   U7  -   DATABASE IN ERROR                                   *
     F*   U8  -   DATABASE IN ERROR/FILES OUT OF BALANCE              *
     F*****************************************************************
     F**
     D*****************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D**
     D**   T A B L E   F I L E
     D**
     D**   INSTALLATION CONTROL DATA RECORD 1.
     D**
     D*
     D LDA             DS           256
     D  DBLOT                134    183
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D*
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details
     D DSFDY         E DS                  EXTNAME(DSFDY)
     I*****************************************************************
     I*
     I** ACCOUNT POSTINGS FILES
     I*
     I***ACPO1   NS  02   1 CP                                                                CAP204
     I***GLACPML0  NS  02    1 CP                                                    CAP204 CGL127AQ
     IACPO1     NS  02    1 CP                                                              CGL127AQ
     I*********OR         1 CR                                                              MD024065
     I                                  1    1  RECIA
     I**********                              2   70CNUM                                      CSD027
     I                                  2    7  CNUM                                          CSD027
     I                                  8   10  CCY
     I**********                             11  140ACOD                                      CGL029
     I                                 11   14 0ACODQQ                                        CGL029
     I                                 15   16 0ACSQ
     I                                 23   32 0ACNO
     I                             P   33   35 0PSTD
     I                             P   36   38 0VALD
     I                                 39   43 0TRAT
     I                                 44   73  PNAR
     I                             P   74   80 0PSTA
     I                                 81   81 0DRCR
     I**********                             82  870ASOC                                      CSD027
     I                                 82   87  ASOC                                          CSD027
     I                                 88   95 0CHQN
     I                                 96  102  SPOS
     I                                103  105  BRCA
     I                                106  106 0RIND
     I                             P  107  108 0REJC
     I                                109  111  DPMT
     I                             P  112  114 0RRNM
     I                                124  124  ATYP
     I                                128  128  PRIN
     I                                129  129  GETP
     I                                130  130 0ACUM
     I                                305  306  PBTT
     I                                307  309  ORBR                    35
     I                                590  599 0ACOD                                          CGL029
     I          NS  02    1 CR                                                              MD024065
     I                                  1    1  RECIA                                       MD024065
     I          NS  05
     I*
     IGETXPD    NS  03    1 CP                                                              CGL127AQ
     I         OR         1 CR                                                              CGL127AQ
     I                                  1    1  RECIA                                       CGL127AQ
     I                                  2    7  CNUM                                        CGL127AQ
     I                                  8   10  CCY                                         CGL127AQ
     I                                 11   14 0ACODQQ                                      CGL127AQ
     I                                 15   16 0ACSQ                                        CGL127AQ
     I                                 23   32 0ACNO                                        CGL127AQ
     I                             P   33   35 0PSTD                                        CGL127AQ
     I                             P   36   38 0VALD                                        CGL127AQ
     I                                 39   43 0TRAT                                        CGL127AQ
     I                                 44   73  PNAR                                        CGL127AQ
     I                             P   74   80 0PSTA                                        CGL127AQ
     I                                 81   81 0DRCR                                        CGL127AQ
     I                                 82   87  ASOC                                        CGL127AQ
     I                                 88   95 0CHQN                                        CGL127AQ
     I                                 96  102  SPOS                                        CGL127AQ
     I                                103  105  BRCA                                        CGL127AQ
     I                                106  106 0RIND                                        CGL127AQ
     I                             P  107  108 0REJC                                        CGL127AQ
     I                                109  111  DPMT                                        CGL127AQ
     I                             P  112  114 0RRNM                                        CGL127AQ
     I                                124  124  ATYP                                        CGL127AQ
     I                                128  128  PRIN                                        CGL127AQ
     I                                129  129  GETP                                        CGL127AQ
     I                                130  130 0ACUM                                        CGL127AQ
     I                                305  306  PBTT                                        CGL127AQ
     I                                307  309  ORBR                    35                  CGL127AQ
     I                                590  599 0ACOD                                        CGL127AQ
     I          NS  05                                                                      CGL127AQ
     I*                                                                                     CGL127AQ
     IACPO1Z    NS  04    1 CT
     I         OR         1 CZ
     I                                  2    6 0NORE
     I                             P    7   14 0ZZINT
     I                             P   15   16 0ZZDEC
     I          NS  05
      ** Short data structure for access programs (200 long)
     C*******************************************************************
     C*                                                                  *
     C**          F I R S T   C Y C L E   P R O C E S S I N G           **
     C*                                                                  *
     C*******************************************************************
     C*
     C                   MOVEA     CPY@          BIS@             80
     C*
     C   20              GOTO      START
     C                   SETON                                        20
     C                   MOVEL     'GL4114'      DBPGM
     C*
     C**   ACCESS INSTALLATION CONTROL DATA RECORD 1
     C                   EXSR      FIRST
     C   99              SETON                                        U7U8LR
     C   99              Z-ADD     1             DBASE                          **DB ERROR 01**
     C   99              MOVEL     'SDBANKPD'    DBFILE
     C   99              MOVEL     'GL4114'      DBPGM
     C   99              GOTO      END
     C                   MOVE      'H'           RECI
     C                   WRITE     ACJXPHF
     C                   MOVE      'D'           RECI
     C*
     C********************************************************************
     C*                                                                  *
     C**         D E T A I L   C Y C L E   P R O C E S S I N G          **
     C*                                                                  *
     C********************************************************************
     C*
     C     START         TAG                                                    ** START TAG **
     C**
     C                   SETOFF                                       50
     C                   MOVE      ' '           SSIN
      *                                                                                       243067
     C     SPOS          IFEQ      '  GE-FT'                                                  243067
     C                   MOVE      '1'           *IN06                                        243067
     C                   ENDIF                                                                243067
     C**
     C**   ALL FURTHER CALCULATIONS ONLY FOR 'P' OR 'R' TYPE RECORDS
     C     *IN02         IFNE      '1'
     C     *IN03         ANDNE     '1'                                                      CGL127AQ
     C                   GOTO      END
     C                   END
     C**
     C**   MAINTAIN COUNT OF RECORDS READ FROM POSTINGS FILE.
     C     PCOUNT        ADD       1             PCOUNT            5 0
     C**
     C     RECIA         IFNE      'P'
     C                   GOTO      END
     C                   END
     C**
     C**   ACCRUE HASH TOTALS FOR POSTINGS READ
     C                   MOVE      PSTA          ZZAMT
     C                   Z-ADD     PTOTI         ZZTOTI
     C                   Z-ADD     PTOTD         ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        PTOTI            15 0
     C                   Z-ADD     ZZTOTD        PTOTD             3 0
     C**
     C**   SKIP IF ALREADY POSTED
     C**
     C                   TESTB     '4'           PRIN                 50
     C  N50              GOTO      END                                          ALREADY POSTED
     C**
     C**   DETERMINE SOURCE OF POSTING
     C     SPOS          COMP      '  GE-TT'                              30
     C   30              MOVE      'P'           SSIN
     C  N30              MOVE      'R'           SSIN
     C   35              MOVE      BRCA          ORBR
     C**
     C**   MAINTAIN COUNT OF ALL RECORDS TO BE OUTPUT TO S/ACJX
     C     OCOUNT        ADD       1             OCOUNT            5 0
     C**
     C**   ACCRUE HASH TOTALS FOR EACH POSTING TO BE OUTPUT TO S/ACJX
     C                   MOVE      PSTA          ZZAMT
     C                   Z-ADD     OTOTI         ZZTOTI
     C                   Z-ADD     OTOTD         ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        OTOTI            15 0
     C                   Z-ADD     ZZTOTD        OTOTD             3 0
     C                   WRITE     ACJXPDF
     C**
     C     END           TAG                                                    ** END TAG **
      *
      ** ACCUMULATE HASH TOTALS FROM ALL THE TRAILER RECORDS
     C     *IN04         IFEQ      '1'
     C     NORE          SUB       2             @NORE             5 0
     C     @NORE         IFGT      0                                                         BUG9310
     C                   ADD       @NORE         TNORE             5 0
     C                   ENDIF                                                               BUG9310
     C                   ADD       ZZINT         TTOTI            15 0
     C                   ADD       ZZDEC         @TOTD             6 0
     C                   END
     C**
     C********************************************************************
     C*                                                                  *
     C**          L A S T   C Y C L E   P R O C E S S I N G             **
     C*                                                                  *
     C********************************************************************
     C**   SUB 2 FROM GEFPPD COUNT IF FT MODULE USED
     C***LR*U1**    PCOUNT    SUB  2         PCOUNT                                          BUG9310
     C**                                                                                      243067
     C**   ADD 2 IN GEFPPD COUNT IF FT MODULE USED                                            243067
     CLR U1
     CAN 06TNORE         ADD       2             TNORE                                        243067
     C**
     C**   ADD 2 TO S/ACJX COUNT TO INCLUDE HEADER AND TRAILER
     CLR   OCOUNT        ADD       2             OCOUNT
     C**
     C**   ADD DECIMAL OVERFLOW TO INTEGER
     CLR   @TOTD         DIV       1000          @QOT              3 0
     CLR                 ADD       @QOT          TTOTI
     CLR                 Z-ADD     @TOTD         TTOTD
     C**
     C**   COMPARE PROGRAM HASH TOTALS TO TRAILER VALUES
     CLR   PTOTI         COMP      TTOTI                              4040
     CLRN40PTOTD         COMP      TTOTD                              4040
     CLR 40              SETON                                        U8
     C**
     C**   COMPARE NUMBER OF RECORDS READ TO TRAILER VALUE.
     CLR   PCOUNT        COMP      TNORE                              4141
     CLR 41              SETON                                        U8
     CLR                 WRITE     CONTROL
     CLR                 MOVE      'T'           RECI
     CLR                 Z-ADD     OCOUNT        NORE
     CLR                 Z-ADD     OTOTI         HRWN
     CLR                 Z-ADD     OTOTD         HRDC
     CLR                 WRITE     ACJXPTF
     CLR U7
     CAN U8              WRITE     ERROR
     C**
     C********************************************************************
     C* ZSYSTM SR. TO CHAIN TO THE INSTALLATION CONTROL DATA RECORD.
     C*
     CSR   FIRST         BEGSR                                                  *** FIRST  ***
     C*
     C** Access bank details for midas-run-date
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C*
     C                   MOVEL     BJDFIN        DATF              1
     C                   MOVEL     BJMRDT        RUNA              7
     C                   MOVEL     BJURPT        TITL             53
     C*
     C     @RTCD         IFNE      *BLANKS
     C                   SETON                                        99
     C                   END
     C*
     C*    CHECK SYSTEM DATE FORMAT, DDMMYY OR MMDDYY.
     C     DATF          COMP      'M'                                    98    -MMDDYY
     C*                                                                   RTSR10
     CSR                 ENDSR
     C*
     C********************************************************************
     C* GLZADD SR. TO ADD AN AMOUNT (ZZAMT) TO THE TOTAL (ZZTOTI,ZZTOTD).
     C*             IND '99' IS SET BY AN OVERFLOW ERROR.
     C*
     CSR   GLZADD        BEGSR                                                  *** GLZADD ***
     C*
     CSR                 Z-ADD     ZZAMT         ZZAMT            15 3    91    -DEFINE ZZAMT
     CSR 91              GOTO      ZZAEND                                       AMT = 0.BYPASS
     C*
     C* SPLIT ZZAMT INTO INTEGER AND DECIMAL FIELDS.
     CSR                 Z-ADD     ZZAMT         ZZAMTI           15 0          INTEGER FIELD
     CSR                 MOVE      ZZAMT         ZZAMTD            3 0          DECIMAL FIELD
     C* BOTH ZZAMTI AND ZZAMTD CONTAIN A 'SIGN' ZONE NOW.
     C*
     CSR                 EXSR      GLZSUM
     C*
     CSR   ZZAEND        ENDSR                                                  ** ZZAEND TAG *
     C*
     C********************************************************************
     C* GLZSUM SR. TO CARRY OUT THE ADDITION FOR SUBROUTINES -
     C*                                            GLZADD, GLZSUB, GLZCMP.
     C*      PARAMETERS. I/P - ZZAMTI,ZZAMTD
     C*                  O/P - ZZTOTI,ZZTOTD,ZZNEGD,IND 96,IND 99.
     C*
     CSR   GLZSUM        BEGSR                                                  *** GLZSUM ***
     CSR                 Z-ADD     ZZTOTI        ZZTOTI           15 0          DEFINE ZZTOTI
     CSR                 Z-ADD     ZZTOTD        ZZTOTD            3 0          DEFINE ZZTOTD
     CSR                 SETOFF                                       919293
     CSR                 SETOFF                                       949599
     C*
     C*    DETERMINE SIGN OF ZZAMTI & D, 92 IF NEGATIVE.
     CSR   ZZAMTI        COMP      0                                    9293
     CSR 93ZZAMTD        COMP      0                                    9293
     CSR 93              GOTO      ZZSEND                                       ZERO BYPASS
     C*
     C*    DETERMINE SIGN OF ZZTOTI & D, 91 IF NEGATIVE.
     CSR   ZZTOTI        COMP      0                                    9193
     CSR 93ZZTOTD        COMP      0                                    9193
     C*
     C*    IF ZZTOTAL IS ZERO, RETURN ZZAMOUNT.
     CSR 93              Z-ADD     ZZAMTI        ZZTOTI
     CSR 93              Z-ADD     ZZAMTD        ZZTOTD
     CSR 93              GOTO      ZZSEND                                       ZERO BYPASS
     C*
     C*    IF SIGNS DIFFER BYPASS OVERFLOW CHECKS.
     CSR 91
     CANN92
     CORN91
     CAN 92              GOTO      ZZOFPS
     C*
     CSR   ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0
     CSR   ZZWK2         COMP      999                                93        '93' = CARRY
     CSRN93ZZWK2         COMP      -999                                 93             INTO INTEGER.
     C*
     CSR 93
     CANN92ZZAMTI        ADD       1             ZZWK3            15 0          ADD 'CARRY' +VE
     CSR 93
     CAN 92ZZAMTI        SUB       1             ZZWK3                          SUB 'CARRY' -VE
     CSR 93ZZTOTI        ADD       ZZWK3         ZZWK3
     CSRN93ZZTOTI        ADD       ZZAMTI        ZZWK3
     C*
     C* IF THE MODULUS OF ZZWK3 IS LT MOD. ZZTOTI THEN O/F HAS OCCURED.
     CSRN92ZZWK3         COMP      ZZTOTI                               99      -92 MEANS ZZAMT
     CSR 92ZZWK3         COMP      ZZTOTI                             99                IS NEGATIVE.
     CSRN99              Z-ADD     ZZWK2         ZZTOTD
     CSRN99              Z-ADD     ZZWK3         ZZTOTI
     C*
     C* IF O/F ZEROIZE ZZAMT , IND '99' SET AND ZZTOT FIELDS LEFT INTACT.
     CSR 99              Z-ADD     0             ZZAMT            15 3
     CSR                 GOTO      ZZSEND
     C*
     C*    THE 'SIGNS' ARE DIFFERENT.
     CSR   ZZOFPS        TAG                                                    ** ZZOFPS TAG**
     C*
     C*    IF ZZAMT WAS NEGATIVE, MAKE IT POS. TO COMP WITH ZZTOT.
     CSR 92              Z-SUB     ZZAMTI        ZZAMTI           15 0
     CSR 92              Z-SUB     ZZAMTD        ZZAMTD            3 0
     C*
     C*    IF ZZTOT WAS NEGATIVE, MAKE IT POS. TO COMP WITH ZZAMT.
     CSR 91              Z-SUB     ZZTOTI        ZZTOTI
     CSR 91              Z-SUB     ZZTOTD        ZZTOTD
     C*    BOTH ZZAMT AND ZZTOT ARE NOW POSITIVE.
     C*
     CSR   ZZTOTI        COMP      ZZAMTI                             93  95
     CSR 95ZZTOTD        COMP      ZZAMTD                             93  95
     C*
     C*    IF ZZTOT EQ. ZZAMT RETURN ZERO.
     CSR 95              Z-ADD     0             ZZTOTI
     CSR 95              Z-ADD     0             ZZTOTD
     CSR 95              GOTO      ZZSEND
     C*
     C*    IF ZZTOT GT. ZZAMT.
     CSR 93ZZAMTD        COMP      ZZTOTD                             94
     CSR 93
     CAN 94ZZTOTI        SUB       1             ZZTOTI
     CSR 93
     CAN 94ZZTOTD        ADD       1000          ZZWK2
     CSR 93ZZTOTI        SUB       ZZAMTI        ZZTOTI
     CSR 93
     CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD
     CSR 93
     CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD
     C*
     C*    IF ZZAMT GT. ZZTOT.
     CSRN93ZZTOTD        COMP      ZZAMTD                             94
     CSRN93
     CAN 94ZZAMTI        SUB       1             ZZWK3            15 0
     CSRN93
     CAN 94ZZAMTD        ADD       1000          ZZWK2
     CSRN93
     CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI
     CSRN93
     CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI
     CSRN93
     CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD
     CSRN93
     CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD
     C*
     C*    REVERSE SIGN OF ZZTOT IF LARGER I/P FIELDS WERE NEGATIVE.
     CSR                 SETOFF                                       94
     CSR 93
     CAN 91
     CORN93
     CAN 92              SETON                                        94
     CSR 94              Z-SUB     ZZTOTI        ZZTOTI
     CSR 94              Z-SUB     ZZTOTD        ZZTOTD
     C*
     C*    RESTORE SIGN OF ZZAMTI & ZZAMTD IF IT WAS REVERSED.
     CSR 92              Z-SUB     ZZAMTI        ZZAMTI
     CSR 92              Z-SUB     ZZAMTD        ZZAMTD
     C*
     C*    IF ZZTOTD IS ZERO, AND ZZTOTI IS NEG. SET UP ZZNEGD.
     CSR   ZZSEND        TAG                                                    ** ZZSEND TAG *
     CSR                 SETOFF                                       96
     CSR   ZZTOTD        COMP      0                                      91
     CSR 91ZZTOTI        COMP      0                                    96
     CSR 96              MOVE      '.000-'       ZZNEGD            5
     CSR                 ENDSR                                                           ** ENDSR **
     C*
     C********************************************************************
     C**
** CPY@   **      OBJECT COPYRIGHT
(c) Misys International Banking Systems Ltd. 2001
