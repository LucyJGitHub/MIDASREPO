     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Standard subroutine FFYTOP as a module')
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFYTOP - Subroutine for calculating price from yield for     *
      *           Australian futures standard contracts,              *
      *           converted into a module                             *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the FFYTOP        *
      *  subroutine.  The subroutine consists of 2 /COPY members      *
      *  (though note that one of them, ZYLDZ1, does not have an      *
      *  FFYTOP* name.                                                *
      *  Each of these has been converted to ILE RPG and copied into  *
      *  this member.  Necessary code to make this compileable has    *
      *  been added (entry and exit points and some declares).  The   *
      *  existing code has not been changed except to remove dead     *
      *  lines, and the boundaries of the original /COPY members have *
      *  been marked, to facilitate future maintenance of both the    *
      *  old members and this one.  If this member has to change, the *
      *  change should ALMOST CERTAINLY be implemented by changing    *
      *  the old /COPY member, reconverting it using CVTRPGSRC, and   *
      *  copying it into this member, replacing the existing section. *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 222373             Date 28Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CPK015             Date 17Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 147775             Date 16Nov98               *
      *                 CAP004  *CREATE    Date 21Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  222373 - Correct parameters on program calls                 *
      *  CPK015 - Conversion of ZYIELD from PLI to RPG                *
      *  147775 - General FF API fixes - (Pre-release unnanotated)    *
      *  CAP004 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** +-----------------------------------------------------------------+
      ** Declares for variables that were defined externally for the
      ** original copy members
      ** +-----------------------------------------------------------------+
 
      ** Yield
     D FFYLD           S             15P 8
 
      ** Contract type
     D FFCNTT          S              1S 0
 
 
      ** +-----------------------------------------------------------------+
 
      ** +--- The converted ZYLDZ1 starts here ----------------------------+
 
     D ZPARMS          DS
     D  PRCYLD                 1      1
     D  METHOD                 2      3
     D  SEMANN                 4      4
     D  ERRIND                 5      5
     D  PRICEC                 6     13P 9                                      E15823
     D  YIELDC                14     21P 9                                      E15823
     D  CPRTE                 22     27P 7                                      E15823
     D  NMAT                  28     29P 0                                      E15823
     D  FMAT                  30     35P 9                                      E15823
     D  KPRICE                36     43P 9                                      E15823
     D  YISVAL                44     50P 9                                      E17303
     D  ACCRCY                51     51P 0                                      E15823
     D  CPYEAR                52     53P 0                                      E15823
     D  DYLSTC                54     55P 0                                      E15823
     D  PERIOD                56     57P 0                                      E15823
     D  PAYYRS                58     64P 9                                      E15823
     D  PAYDYS                65     67P 0                                      E15823
     D  VALDTE                68     70P 0                                      E15823
     D  NCPDTE                71     73P 0                                      E15823
     D  MATDTE                74     76P 0                                      E15823
     D  CPTOMT                77     78P 0                                      S01231
     D  PURINT                79     86P 9                                      S01231
     D  DSFCTM                87     88P 0                                      S01231
     D  DYSTNC                89     90P 0                                      S01231
     D  CUMEXF                91     91                                         S01231
     D  COMFRQ                92     93P 0                                      S01397
     D  DSCBSS                94     94                                         S01397
     D  DLCOUP                95     95                                         S01397
      *                                                                   S01397
      **  OBTAIN DATE IN YYYYMMDD FORMAT
     D                 DS                                                       E21034
     D  ZCENT                  1      2  0                                      E21034
     D  ZYEAR                  3      4  0                                      E21034
     D  ZMTH                   5      6  0                                      E21034
     D  ZDAY                   7      8  0                                      E21034
     D  WRKYMD                 1      8  0                                      E21034
 
      **  NEXT COUPON DATE AS MMDD
     D                 DS                                                       E20380
     D  NCMM                   1      2  0                                      E20380
     D  NCDD                   3      4  0                                      E20380
     D  NCMDD                  1      4  0                                      E20380
 
      *   MATURITY DATE AS MMDD
     D                 DS                                                       E20380
     D  MTMM                   1      2  0                                      E20380
     D  MTDD                   3      4  0                                      E20380
     D  MATMD                  1      4  0                                      E20380
 
      ** +--- The converted ZYLDZ1 ends here ------------------------------+
      ** Dummy Issue Date                                                                     222373
     D PIssDate        S              5P 0                                                    222373
      ** Dummy Would be Next Date                                                             222373
     D PWBeNxtDate     S              5P 0                                                    222373
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
 
      ** Execute the standard subroutine
     C                   EXSR      FFYTOP
 
     C                   RETURN
 
      /EJECT
 
      ** +--- The converted FFYTOPZ1 starts here --------------------------+
 
      ****************************************************************    AUS022
      *                                                                   AUS022
     C     FFYTOP        BEGSR                                                                 AUS02
      *                                                                   AUS022
     C     *LIKE         DEFINE    PRICEC        FFPRC                                         AUS02
      *                                                                   AUS022
      * Capture date (year) for calculations                              AUS022
      *                                                                   AUS022
     C                   TIME                    WTIME            12 0                         AUS02
     C                   MOVE      WTIME         WYEAR             2 0                         AUS02
      *                                                                   AUS022
      * Setup common ZYIELD parameters                                    AUS022
      *                                                                   AUS022
     C                   MOVE      'P'           PRCYLD                                        AUS02
     C                   MOVE      'AU'          METHOD                                        AUS02
     C                   MOVE      ' '           SEMANN                                        AUS02
     C                   MOVE      ' '           ERRIND                                        AUS02
     C                   Z-ADD     *ZERO         PRICEC                                        AUS02
     C                   Z-ADD     FFYLD         YIELDC                                        AUS02
     C                   Z-ADD     *ZERO         KPRICE                                        AUS02
     C                   Z-ADD     *ZERO         YISVAL                                        AUS02
     C                   Z-ADD     9             ACCRCY                                        AUS02
     C                   Z-ADD     2             CPYEAR                                        E4498
     C                   Z-ADD     1             VALDTE                                        AUS02
     C                   Z-ADD     *ZERO         FMAT                                          AUS02
     C                   Z-ADD     *ZERO         NMAT                                          AUS02
     C                   Z-ADD     *ZERO         DYLSTC                                        AUS02
     C                   Z-ADD     *ZERO         DSFCTM                                        AUS02
     C                   Z-ADD     *ZERO         DYSTNC                                        AUS02
     C                   Z-ADD     1             PAYYRS                                        AUS02
     C                   Z-ADD     *ZERO         PAYDYS                                        AUS02
     C                   Z-ADD     *ZERO         PURINT                                        AUS02
     C                   MOVE      'C'           CUMEXF                                        AUS02
      *                                                                   E44985
      ** Define compounding frequency, discount basis and discount        E44985
      ** indicator.                                                       E44985
      *                                                                   E44985
     C                   Z-ADD     2             COMFRQ                                        E4498
     C                   MOVE      2             DSCBSS                                        E4498
     C                   MOVE      'Y'           DLCOUP                                        E4498
      *                                                                   AUS022
      * Setup ZYIELD parameters according to contract type                AUS022
      *                                                                   AUS022
      * Contract type 1 (90 day bank bills)                               AUS022
      *                                                                   AUS022
     C     FFCNTT        IFEQ      1                                                           AUS02
     C                   Z-ADD     *ZERO         CPRTE                                         AUS02
     C                   Z-ADD     91            MATDTE                                        AUS02
     C                   Z-ADD     91            NCPDTE                                        AUS02
     C                   Z-ADD     180           PERIOD                                        E4498
     C                   Z-ADD     *ZERO         CPTOMT                                        AUS02
     C                   END                                                    IF FFCNTT=1    AUS02
      *                                                                   AUS022
      * Contract type 2 (3 year treasury bonds)                           AUS022
      *                                                                   AUS022
     C     FFCNTT        IFEQ      2                                                           AUS02
     C                   MOVE      'X'           CUMEXF                                        E3041
     C                   Z-ADD     12            CPRTE                                         AUS02
     C                   Z-ADD     1095          MATDTE                                        AUS02
     C                   Z-ADD     1             NCPDTE                                        E3041
     C                   Z-ADD     182           PERIOD                                        AUS02
     C                   Z-ADD     6             CPTOMT                                        AUS02
     C                   END                                                    IF FFCNTT=2    AUS02
      *                                                                   AUS022
      * Contract type 3 (10 year treasury bonds)                          AUS022
      *                                                                   AUS022
     C     FFCNTT        IFEQ      3                                                           AUS02
     C                   Z-ADD     12            CPRTE                                         AUS02
     C                   Z-ADD     3650          MATDTE                                        AUS02
     C                   Z-ADD     183           NCPDTE                                        AUS02
     C                   Z-ADD     182           PERIOD                                        AUS02
     C                   Z-ADD     20            CPTOMT                                        AUS02
     C                   END                                                    IF FFCNTT=3    AUS02
      *                                                                   AUS022
      * Call ZYIELD                                                       AUS022
      *                                                                   AUS022
     C*****ZPARM         PLIST                                                          AUS02 CPK015
     C**********         PARM                    ZPARMS                                 AUS02 CPK015
      *                                                                   AUS022
     C**********         CALL      'ZYIELD'      ZPARM                                  AUS02 CPK015
     C                   CALL      'ZYIELD'                                                   CPK015
     C                   PARM                    PRCYLD                                       CPK015
     C                   PARM                    METHOD                                       CPK015
     C                   PARM                    SEMANN                                       CPK015
     C                   PARM                    ERRIND                                       CPK015
     C                   PARM                    PRICEC                                       CPK015
     C                   PARM                    YIELDC                                       CPK015
     C                   PARM                    CPRTE                                        CPK015
     C                   PARM                    NMAT                                         CPK015
     C                   PARM                    FMAT                                         CPK015
     C                   PARM                    KPRICE                                       CPK015
     C                   PARM                    YISVAL                                       CPK015
     C                   PARM                    ACCRCY                                       CPK015
     C                   PARM                    CPYEAR                                       CPK015
     C                   PARM                    DYLSTC                                       CPK015
     C                   PARM                    PERIOD                                       CPK015
     C                   PARM                    PAYYRS                                       CPK015
     C                   PARM                    PAYDYS                                       CPK015
     C                   PARM                    VALDTE                                       CPK015
     C                   PARM                    NCPDTE                                       CPK015
     C                   PARM                    MATDTE                                       CPK015
     C                   PARM                    CPTOMT                                       CPK015
     C                   PARM                    PURINT                                       CPK015
     C                   PARM                    DSFCTM                                       CPK015
     C                   PARM                    DYSTNC                                       CPK015
     C                   PARM                    CUMEXF                                       CPK015
     C                   PARM                    COMFRQ                                       CPK015
     C                   PARM                    DSCBSS                                       CPK015
     C                   PARM                    DLCOUP                                       CPK015
     C                   PARM                    PIssDate                                     222373
     C                   PARM                    PWBeNxtDate                                  222373
                                                                                              CPK015
     C                   Z-ADD     PRICEC        FFPRC                                         AUS02
      *                                                                   AUS022
     C                   ENDSR                                                                 AUS02
 
      ** +--- The converted FFYTOPZ1 ends here ----------------------------+
 
      **********************************************************************
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
      ** Output
      ** ------
      **                              Price (15,9P)
     C                   PARM                    FFPRC
      **
      ** Inputs
      ** ------
      **                              Yield (15,8P)
     C                   PARM                    FFYLD
      **                              Contract type (1,0S, from INTYPD)
     C                   PARM                    FFCNTT
 
 
 
     C                   ENDSR
 
      *****************************************************************
 
 
      ** +--- From here to the end, apart from the copyright array, -------+
      ** +---  is the converted ???????4 ----------------------------------+
 
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
