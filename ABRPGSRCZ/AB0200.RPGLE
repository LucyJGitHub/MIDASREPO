     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')                                   CAP084
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       CAP084
/*STD *  RPGBASEMOD                                                   *                       CAP084
/*EXI *  TEXT('Midas AB Update AB database for a deal')
     F*****************************************************************
     F*                                                               *
     F*  Midas  -  Internal Contracts & Arbitrage Dealing
     F*                                                               *
     F*     AB0200    - Update AB Database                            *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 06Sep03               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CPK015             Date 28Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004             Date 08Sep98               *
      *                 CAC001             Date 01Feb96               *
     F*                 E27371             Date 14Aug91               *
     F*                 S01319             Date 01Aug91               *
     F*                  S01280             Date 03APR91              *
     F*                  S01117             Date 31JAN90              *
     F*                  S01194             Date 31JAN90              *
     F*                  S01165             DATE 19/04/89             *
     F*                  E17089             DATE 06/01/89             *
     F*                  AB0329             DATE 16/06/88             *
     F*                  AB0318             DATE 15/06/88             *
     F*                  AB0220             DATE 04/05/88             *
     F*                  AB0201             DATE 27/04/88             *
     F*                  AB0119             DATE 11/03/88             *
     F*                  AB0118             DATE 11/03/88             *
     F*                  AB0054             DATE 06/01/88             *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Convert to ILE.                                     *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CPK015 - Release 4.01 Packaging:                             *
      *           - A default timestamp string is required for        *
      *             file ABDEAULL (ABDEALP0) write.                   *
     F*  CAP004 - API's Phase 3.  (RECOMPILED OVER CHANGED ABDEALPP)  *
     F*  CAC001 - Profit Centre Accounting Development:               *
     F*           Additional fields for Analytical Accounting module  *
     F* E27371 - AODEALR0 called with wrong parameter
     F* S01319   Removal of ABSTDDLL
     F* S01280 - PROGRAM LEAVES ABSTDDLL OPEN FOR OUTPUT ONLY CAUSING *
     F*          ERROR IN AB0230 WHEN SETLL - CLOSE FILE AT END OF    *
     F*          PROGRAM.                                             *
     F* S01194 - NEW STANDING DATA                                    *
     F* S01117 - MULTI-BRANCHING.                                     *
     F* S01165 - Three new fields (FX&MM Book Codes and Linked RefNo.)*   S01165
     F*          have been added to ABDEALPP and ABSTDDPP             *   S01165
     F* E17089 - USER ID FROM PGM.DATA STRUCTURE SPECIFIED IN         *
     F*          WRONG PLACE. CORRECTED BY JLB FOR INCORPORATION.     *
     F* AB0329 - FOR COMPLETED/DELETED DEALS ABDEALPP UPDATED         *
     F*          WITH JU SHOULD BE JP.                                *
     F* AB0318 - SHOULD COPE WITH BLANK BRANCH CODE                   *
     F* AB0220 - ABDEAULL SHOULD BE UNDER COMMITMENT CONTROL          *
     F* AB0201 - IF DBERR DUMP FOR EASIER FIXING                      *
     F* AB0119 - IF DB ERROR IN AB0200 #A NOT RUN AS DBPGM = AB0200   *
     F*          IN *LDA                                              *
     F*                                                               *
     F* AB0118 - MUST CRT IGNDECERR(*YES) BCOS OF FIELD JUMBCD        *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
     F* DUE TO PROCESSING OF FIELD JUMBCD MUST CRT IGNDECERR(*YES)    *
     F*  CREATION PARAMETERS                                          *
     F*                                                               *
     F*                                                               *
     F*****************************************************************
     F*
     F* ID F  C  H  L    FUNCTION OF INDICATORS
     F*
     F*       61         CHAIN AND DB ERROR INDICATOR
     F*       62         UPDATE OR WRITE INDICATOR
     F*       80         CHAIN AND DB ERROR INDICATOR
     F*          U6      PROGRAM ERROR - *PSSR EXECUTED
     F*          U7      DATA BASE ERROR
     F*          U8      DATA BASE ERROR
      /EJECT
     F*FDICDRLLIF*E***********K        DISK         KINFSR INFSR      UC  S01194
     F************TABTB11F*****                     KIGNORE               S01194
     F************TABTB20F*****                     KIGNORE               S01194
     F*FDBSNCLLIF*E***********K        DISK         KINFSR INFSR      UC  S01194
     F*ABDEALLLUF*E***********K        DISK         KINFSR INFSR A    UC  AB0054
     FABDEAULL  UF A E           K DISK    INFSR(INFSR)                         AB0054
     F                                     USROPN
     F                                     IGNORE(ABDEALP1)
     F                                     INFDS(FDS1)
     F                                     COMMIT                               AB0220
     F*FXTB40LLIF*E***********K        DISK         KINFSR INFSR      UC  S01194
     F*ABSTDDLLO**E***********K********DISK*********KINFSR*INFSR*A****UC**S01319
     F**********************************************KCOMIT****************S01319
      /EJECT
     D*
     D** Array to hold copyright statement
     D*
     D** Array for SR ZA0680 - cumulative days in year for 4 year period
     D @YD             S              5  0 DIM(4) CTDATA PERRCD(4) ASCEND
     D*
     D** Array for SR ZA0680 - cumulative days in year per month
     D @MD             S              5  0 DIM(13) CTDATA PERRCD(13) ASCEND
     D*STAMP****       S             26    DIM(1) CTDATA PERRCD(1)                            CAP084
     D STAMP           S               Z                                                      CAP084
      ** Array containing dummy timestamp                                                     CPK015
      /EJECT
     D*
     D** Rename fields
     D*TABLETRF********                                                   S01194
     D**************KEY                             TRKEY                 S01194
     D*                                                                   S01194
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                    S01194
     D** BRANCH DETAILS ACCESSED VIA ACCESS PROGRAM                       S01194
     D*                                                                   S01194
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                    S01194
     D** DEALING DETAILS ACCESSED VIA ACCESS PROGRAM                      S01194
     D DSFDY         E DS                  EXTNAME(DSFDY)                       S01194
     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                S01194
     D*                                                                   S01194
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
     D* Second DS for Access Programs, Long Data Structure                                    CGL029
     D*
     D @CPYRT          DS
     D** Data structure for compilation - copyright insertion
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
     D*
     D PSDS           SDS
     D** Program status DS to hold file name for file error
     D  @FILE                201    208
     D************************************* 244 253 @UID *****************E17089
     D  @UID                 254    263                                         E17089
     D*
     D FDS1            DS
     D** File status data structure - record format
     D  @FORM            *RECORD
     D*
     D @DTIDS          DS
     D** Data structure for SR ZA0680 - date input to subroutine
     D  @@DTIN                 1      8  0
     D  @@YYYY                 1      4  0
     D  @@YY                   3      4  0
     D  @@CC                   1      2  0
     D  @@MTH                  5      6  0
     D  @@DAY                  7      8  0
     D  @ALINT                 1     15  0
     D*                                                                   S01117
     D*ZMUSER******DS************************     17               S01117 CAP004
     D***************************************11  13 BRC            S01117 CAP004
     D*                                                                   S01117
     D*@RUNDS*****DS**************************                            S01194
     D** Run date
     D RUNDAT          DS                                                       S01194
     D  RUNA                   1      7
     D  @DLUP                  1      2  0
     D  @MLUP                  3      5
     D  @YLUP                  6      7  0
     D  RUND                   8     10P 0                                      S01194
     D  @MBIN                 13     13                                         S01194
     D*
     D @DDDDS          DS
     D** Deal done date
     D  @JUDDT                 1      8  0
     D  @JUDDY                 1      4  0
     D  @JUDDM                 5      6  0
     D  @JUDDD                 7      8  0
     D*
     D @NRDDS          DS
     D** Near date
     D  @JUNRD                 1      8  0
     D  @JUNDY                 1      4  0
     D  @JUNDM                 5      6  0
     D  @JUNDD                 7      8  0
     D*
     D @FRDDS          DS
     D** Far date
     D  @JUFRD                 1      8  0
     D  @JUFDY                 1      4  0
     D  @JUFDM                 5      6  0
     D  @JUFDD                 7      8  0
     D*
     D @LADDS          DS
     D** Last action date
     D  @JULDT                 1      8  0
     D  @JULAY                 1      4  0
     D  @JULAM                 5      6  0
     D  @JULAD                 7      8  0
     D*
     D @DEAL         E DS                  EXTNAME(ABDEALPP)
     D** Externally described data structure for deals format
     D  @DEAL1                 1    219
     D**************************************220 283 @DEAL2                S01165
     D**************************************220 300 @DEAL2         S01165 CAC001
     D  @DEAL2               220    306                                         CAC001
     D*
     D @STDL         E DS                  EXTNAME(ABSTDDPP)
     D** Externally described data structure for standard deals format
     D  @STDL1                 1    219
     D**************************************263 326 @STDL2                S01165
     D**************************************263 343 @STDL2         S01165 CAC001
     D  @STDL2               263    349                                         CAC001
     D*
     D                UDS           256
     D** Data structure to hold information on database error
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN     - Main Processing                                    *
     C*                                                               *
     C* CALLS    #A       - Initialisation                            *
     C*          #B       - Update Standard Deal                      *
     C*          #C       - Termination                               *
     C*                                                               *
     C* CALLED BY         -                                           *
     C*                                                               *
     C* FLDS USED         -                                           *
     C*                                                               *
     C*****************************************************************
     C*
     C** Initial processing
     C*****      DBPGM     CASNE'AB0200'  #A                              AB0119
     C     @FCYCL        CASNE     'Y'           #A                                            AB011
     C                   END
     C*
     C** Main processing
     C     @TERM         IFNE      'E'                                          B1
     C     @TERM         ANDNE     'T'                                          B1
     C                   EXSR      #B                                           *1
     C                   END                                                    E1
     C*
     C** Termination prcessing
     C                   EXSR      #C
     C*
     C     ENDPGM        TAG                                                    **ENDPGM**
     C*
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C* SUBROUTINES USED                                              *
     C*                                                               *
     C*  01  #B       - Update Standard Deal                          *
     C*  02  #BA      - Insert Processing                             *
     C*  03  #BB      - Delete Processing                             *
     C*  04  #ZA      - Supplementary Fields                          *
     C*  05  ZA0680   - Calculate MIDAS Day Number                    *
     C*  06  ZA0830   - Check for a Holiday                           *
     C*  07  #C       - Termination                                   *
     C*  08  #A       - Initialisation                                *
     C*  09  ZA0150   - Access TABTB10                                *
     C*  10  #Z       - Database Errors                              *
     C*  11  *PSSR    - Program Error Subroutine                      *
     C*  12  INFSR    - File Error Subroutine                         *
     C*                                                               *
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* #B       - Update Standard Deal                               *
     C*                                                               *
     C* CALLS    #Z       - Database Errors                           *
     C*          #BA      - Insert Processing                         *
     C*          #BB      - Delete Processing                         *
     C*                                                               *
     C* CALLED BY  MAIN   - Main Processing                           *
     C*                                                               *
     C* FLDS USED  @DLUP  - Day of last update                        *
     C*            @MLUP  - Month of last update                      *
     C*            @YLUP  - Year of last update                       *
     C*            @UID   - User ID                                   *
     C*                                                               *
     C*****************************************************************
     C     #B            BEGSR
     C*
     C                   MOVE      'JU'          JURCID
     C                   Z-ADD     @DLUP         JUDLUP
     C                   MOVEL     @MLUP         JUMLUP
     C                   Z-ADD     @YLUP         JUYLUP
     C                   TIME                    JUTLUP
     C                   MOVEL     JULACT        JUCHTP
     C                   Z-ADD     RUND          JULCD
     C                   MOVEL     @UID          JULUID
     C*
     C     JULACT        IFEQ      'I'                                          B1
     C                   EXSR      #BA                                          *1
     C                   ELSE                                                   X1
     C                   EXSR      #BB                                          *1
     C                   END                                                    E1
     C*
     C***Write*record*to*standard*deal************************************S01319
     C*********************WRITEABSTDDP0**********************************S01319
     C*
     C     #B9           ENDSR                                                  ****#B9****
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* #BA      - Insert Processing                                  *
     C*                                                               *
     C* CALLS    #ZA      - Supplementary Fields                      *
     C*                                                               *
     C* CALLED BY  #B     - Update Standard Deal                      *
     C*                                                               *
     C* FLDS USED  @STDL1 - STANDARD DEAL FORMAT FIRST 219 BYTES      *
     C*************@STDL2*-*STANDARD DEAL FORMAT BYTES 263 TO 326     *   S01165
     C*            @STDL2 - STANDARD DEAL FORMAT BYTES 263 TO 343     *   S01165
     C*            @DEAL1 - DS HOLDING FIELDS FOR OUTPUT TO ABDEALP0  *
     C*            @DEAL2 - DS HOLDING FIELDS FOR OUTPUT TO ABDEALP0  *
     C*                                                               *
     C*****************************************************************
     C     #BA           BEGSR
     C*
     C** Deals file processing
     C****       JUFD38    CHAINABDEALLL             61                   AB0054
     C****       JUFD38    CHAINABDEAULL             61                   AB0054
     C     JUFD38        CHAIN     ABDEAULL                           62                       AB005
     C*
     C** Set up supplementary fields
     C                   EXSR      #ZA
     C*
     C                   MOVEL     @STDL1        @DEAL1
     C                   MOVEL     @STDL2        @DEAL2
     C                   MOVEL     'JP'          JPRCID
     C*
     C** If record exists for this deal number, update record, else
     C** write a new record
     C****       *IN61     IFEQ '0'                        B1
     C     *IN62         IFEQ      '0'                                          B1
     C                   UPDATE    ABDEALP0                                     *1
     C                   ELSE                                                   X1
     C**********         MOVEA     STAMP(1)      JPTMST                     Default Timestamp CAP084
     C                   EVAL      JPTMST =      STAMP                                        CAP084
     C                   WRITE     ABDEALP0                                     *1
     C                   END                                                    E1
     C*
     C     #BA9          ENDSR                                                  ****#BA9****
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* #BB      - Non-Insert processing                              *
     C*                                                               *
     C* CALLS    #ZA      - Supplementary Fields                      *
     C*          #Z       - Data base errors                          *
     C*                                                               *
     C* CALLED BY  #B     - Update Standard Deal                      *
     C*                                                               *
     C* FLDS USED  @DEAL  - Deals file data structure                 *
     C*                                                               *
     C*****************************************************************
     C     #BB           BEGSR
     C*
     C** Update deals file
     C*****      JUFD38    CHAINABDEALLL             61                   AB0054
     C*****      JUFD38    CHAINABDEAULL             61                   AB0054
     C     JUFD38        CHAIN     ABDEAULL                           62                       AB005
     C*
     C** Set up supplementary fields
     C                   EXSR      #ZA
     C*
     C** Check for database error
     C*****      *IN61     IFEQ '1'                        B1
     C     *IN62         IFEQ      '1'                                          B1
     C                   MOVEL     JUFD38        DBKEY                          ***************
     C*                    MOVEL'ABDEALLL'DBFILE           * DBERROR 001 *AB0054
     C                   MOVEL     'ABDEAULL'    DBFILE                         * DBERROR 001 *AB005
     C                   MOVEL     '001'         DBASE                          ***************
     C                   EXSR      #Z                                           *1
     C                   END                                                    E1
     C*
     C                   MOVEL     @STDL1        @DEAL1
     C                   MOVEL     @STDL2        @DEAL2
     C* NEED TO RESET RCID                                                AB0329
     C                   MOVEL     'JP'          JPRCID                                        AB032
     C                   UPDATE    ABDEALP0
     C*
     C     #BB9          ENDSR                                                  ****#BAC9***
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* #ZA      - Supplementary Fields                               *
     C*                                                               *
     C* CALLS                                                         *
     C*                                                               *
     C* CALLED BY  #BA    - Insert Processing                         *
     c*            #BB    - Delete Processing                         *
     C*                                                               *
     C* FLDS USED  @DLUP  - Day of last update                        *
     C*            @MLUP  - Month of last update                      *
     C*            @YLUP  - Year of last update                       *
     C*            @UID   - User ID                                   *
     C*                                                               *
     C*****************************************************************
     C     #ZA           BEGSR
     C*
     C** Set up MIDAS branch code
     C***********JUMBCD****IFEQ 0                          B1             S01117
     C***********JUDBRC****ANDNE*BLANKS                    B1             S01117
      *                                                                   S01117
     C********** *IN61*****OREQ '1'                        *1             S01117
     C********** *IN61*****IFEQ '1'                        *1             S01117
     C***********JUDBRC****ANDNE*BLANKS                    B1             S01117
      *                                                                   S01117
     C********** *IN61*****OREQ '0'                        *1             S01117
     C***********JUDBRC****ANDNEJPDBRC                     *1             S01117
     C     JUDBRC        IFNE      JPDBRC                                       B1             S0111
     C     JUDBRC        ANDNE     *BLANKS                                      B1             S0111
     C*
     C***********JUDBRC****CHAINFDBSNCLL             61    *1             S01194
     C*********************                                               S01194
     C** Check for database error
     C********** *IN61*****IFEQ '1'                        B*2            S01194
     C**********         CALL      'AOBRCHR0'                                           S0119 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7                           S0119
     C                   PARM      '*KEY   '     @OPTN             7                           S0119
     C                   PARM      JUDBRC        @DSNB             3                           S0119
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                  S0119 CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
     C     @RTCD         IFNE      *BLANKS                                      IF             S0119
     C                   MOVEL     @OPTN         DBOPTN            7                           S0119
     C                   MOVEL     JUDBRC        DBKEY                          ***************
     C*********************MOVEL'FDBSNCLL'DBFILE           * DBERROR 002 *S01194
     C                   MOVEL     'SDBRCHPD'    DBFILE                                        S0119
     C                   MOVEL     '002'         DBASE                          ***************
     C                   EXSR      #Z                                           **2
     C                   END                                                    E*2
     C*
     C*********************MOVE TRKEY     JUMBCD           *1             S01117
     C                   MOVE      JUDBRC        JUMBCA                         *1             S0111
     C*
     C                   ELSE                                                   X1
     C*
     C*********************MOVE JPMBCD    JUMBCD           *1             S01117
     C                   MOVE      JPMBCA        JUMBCA                         *1             S0111
     C                   END                                                    E1
     C*
     C** Set up deal customer number
     C** If system is single branch, use position swap customer number
     C*****JUDCNO        IFEQ      0                                            B1            CSD027
     C     JUDCNO        IFEQ      *BLANKS                                      B1            CSD027
     C***********DFBR******IFNE 0                          B*2            S01117
     C     @MBIN         IFEQ      'Y'                                          B*2            S0111
     C*                                                                   S01194
     C***Set*up*key*to*access*LF/FXTB40LL                                 S01194
     C*********************MOVEL'01'      @TB40K 12        **2            S01194
     C*********************MOVE '40'      @TB40K           **2            S01194
     C***********@TB40K****CHAINFXTB40LL             61    **2            S01194
     C*********************                                               S01194
     C** Check for database error                                         S01194
     C********** *IN61*****IFEQ '1'                                       S01194
     C**********         CALL      'AODEALR0'                                           S0119 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD                                         S0119
     C                   PARM      '*FIRST '     @OPTN                                         S0119
     C***********SDBRCH****PARM SDBRCH    DSFDY                     S01194E27371
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                  E2737 CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
     C     @RTCD         IFNE      *BLANKS                                                     S0119
     C                   MOVEL     @OPTN         DBOPTN                                        S0119
     C*********************MOVEL@TB40K    DBKEY            ***************S01194
     C*********************MOVEL'FXTB40LL'DBFILE           *              S01194
     C                   MOVEL     'SDDEALPD'    DBFILE                                        S0119
     C                   MOVEL     '003'         DBASE                          ***************
     C                   EXSR      #Z                                           ***3
     C                   END                                                    E**3
     C*
     C*********************Z-ADDPSCN      JUDCNO           **2            S01194
     C                   MOVE      BNCUST        JUDCNO                         **2            S0119
     C                   ELSE                                                   X*2
     C*
     C** If FDBSNCLL not already accessed, access now
      **  as long as branch code is non blank
     C***********BICN******IFEQ 0                          B**3           S01194
     C     A8BICN        IFEQ      *BLANKS                                      B**3           S0119
     C     JUDBRC        ANDNE     *BLANKS                                      B**3           AB031
     C***********JUDBRC****CHAINFDBSNCLL             61    ***3           S01194
     C*
     C** Check for database error
     C********** *IN61*****IFEQ '1'                        B***4          S01194
     C**********         CALL      'AOBRCHR0'                                           S0119 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD                                         S0119
     C                   PARM      '*KEY   '     @OPTN                                         S0119
     C                   PARM      JUDBRC        @DSNB                                         S0119
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                  S0119 CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
     C     @RTCD         IFNE      *BLANKS                                                     S0119
     C                   MOVEL     @OPTN         DBOPTN                                        S0119
     C                   MOVEL     JUDBRC        DBKEY                          ***************
     C*********************MOVEL'FDBSNCLL'DBFILE           * DBERROR 004 *S01194
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   MOVEL     '004'         DBASE                          ***************
     C                   EXSR      #Z                                           ****4
     C                   END                                                    E***4
     C                   END                                                    E**3
     C*
     C*********************Z-ADDBICN      JUDCNO           **2            S01194
     C                   MOVE      A8BICN        JUDCNO                         **2            S0119
     C*
     C                   END                                                    E*2
     C                   END                                                    E1
     C*
     C** If FDBSNCLL not already accessed, access now
     C***********BICN******IFEQ 0                          B1             S01194
     C     A8BICN        IFEQ      *BLANKS                                      B1             S0119
     C     JUDBRC        ANDNE     *BLANKS                                      B1             AB031
     C***********JUDBRC****CHAINFDBSNCLL             61    *1             S01194
     C*
     C** Check for database error
     C********** *IN61*****IFEQ '1'                        B*2            S01194
     C**********         CALL      'AOBRCHR0'                                           S0119 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD                                         S0119
     C                   PARM      '*KEY   '     @OPTN                                         S0119
     C                   PARM      JUDBRC        @DSNB                                         S0119
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                  S0119 CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
     C     @RTCD         IFNE      *BLANKS                                                     S0119
     C                   MOVEL     @OPTN         DBOPTN                                        S0119
     C                   MOVEL     JUDBRC        DBKEY                          ***************
     C*********************MOVEL'FDBSNCLL'DBFILE           * DBERROR 005 *S01194
     C                   MOVEL     'SDBRCHPD'    DBFILE                                        S0119
     C                   MOVEL     '005'         DBASE                          ***************
     C                   EXSR      #Z                                           **2
     C                   END                                                    E*2
     C                   END                                                    E1
     C*
     C** Set up branch name
     C     JUBRNM        IFEQ      *BLANK                                       B1
     C*********************MOVE BRNM      JUBRNM           *1             S01194
     C                   MOVE      A8BRNM        JUBRNM                         *1             S0119
     C                   END                                                    E1
     C*
     C** Set up MIDAS deal done date
     C                   Z-ADD     JUDDYY        @JUDDY
     C                   Z-ADD     JUDDMM        @JUDDM
     C                   Z-ADD     JUDDDD        @JUDDD
     C*
     C     @JUDDT        IFNE      *ZERO                                        B1
     C                   Z-ADD     @JUDDT        @@DTIN                         *1
     C                   EXSR      ZA0680                                       *1
     C                   Z-ADD     @@MDNO        JUDDAT                         *1
     C                   END                                                    E1
     C*
     C** Set up deal near date
     C                   Z-ADD     JUNDYY        @JUNDY
     C                   Z-ADD     JUNDMM        @JUNDM
     C                   Z-ADD     JUNDDD        @JUNDD
     C*
     C     @JUNRD        IFNE      *ZERO                                        B1
     C                   Z-ADD     @JUNRD        @@DTIN                         *1
     C                   EXSR      ZA0680                                       *1
     C                   Z-ADD     @@MDNO        JUNDAT                         *1
     C                   END                                                    E1
     C*
     C** Set up deal far date
     C                   Z-ADD     JUFDYY        @JUFDY
     C                   Z-ADD     JUFDMM        @JUFDM
     C                   Z-ADD     JUFDDD        @JUFDD
     C*
     C     @JUFRD        IFNE      *ZERO                                        B1
     C                   Z-ADD     @JUFRD        @@DTIN                         *1
     C                   EXSR      ZA0680                                       *1
     C                   Z-ADD     @@MDNO        JUFDAT                         *1
     C                   END                                                    E1
     C*
     C** Set up deal last action date
     C                   Z-ADD     JULAYY        @JULAY
     C                   Z-ADD     JULAMM        @JULAM
     C                   Z-ADD     JULADD        @JULAD
     C*
     C     @JULDT        IFNE      *ZERO                                        B1
     C                   Z-ADD     @JULDT        @@DTIN                         *1
     C                   EXSR      ZA0680                                       *1
     C                   Z-ADD     @@MDNO        JUDLAD                         *1
     C                   END                                                    E1
     C*
     C     #ZA9          ENDSR                                                  ****#BB9****
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* ZA0680 - THIS SUBROUTINE CONVERTS YYYYMMDD FORMAT DATE TO     *
     C*          MIDAS DAY NUMBER FORMAT (NO. DAYS FROM 31/12/71)     *
     C*                                                               *
     C* CALLED BY :                                                   *
     C*                                                               *
     C* CALLS :                                                       *
     C*                                                               *
     C* INPUT : @@DTIN DATE (YYYYMMDD) - IN DATA STRUCTURE (SIZE: 8N) *
     C*                                                               *
     C* OUTPUT : @@MDNO MIDAS DAY NUMBER  (SIZE : 5N)                 *
     C*                                                               *
     C* USES :   @@CC   NUMBER OF CENTURIES IN DATE                   *
     C*          @@DAY  DAY NUMBER                                    *
     C*          @@REM  REMAINDER FROM DIVIDE                         *
     C*          @@MTH  MONTH NUMBER                                  *
     C*          @MD    COMPIGATION TIME ARRAY FOR CUMULATIVE DAYS IN *
     C*                 MONTH                                         *
     C*          @@WK2  WORK FIELD (2,0)                              *
     C*          @@WK5  WORK FIELD (5,0)                              *
     C*          @@YYYY YEAR (4 CHARACTER)                            *
     C*          @@YY   YEAR (2 CHARACTER)                            *
     C*          @YD    COMPILATION TIME ARRAY FOR CUMULATIVE DAYS IN *
     C*                 A FOUR YEAR PERIOD                            *
     C*                                                               *
     C*****************************************************************
     C*
     C     ZA0680        BEGSR
     C*
     C**  CLEAR OUT ANY 'OLD' DATA IN FIELD
     C                   Z-ADD     0             @@MDNO            5 0
     C*
     C     @@DTIN        CABEQ     0             ZA0689                                        ME125
     C*
     C**   IF DATE GREATER THAN 31/12/2071 NEED EXTRA PROCESSING
     C**   WORK OUT THE NUMBER OF CENTURIES PASSED SINCE 1971,
     C**   BY SUBTRACTING 1972 FROM THE YEAR FIELD.
     C     @@YYYY        IFGE      2072                                         B1
     C     @@YYYY        SUB       1972          @@YYYY                         *1
     C*
     C**   MULTIPLY BY NUMBER OF DAYS IN CENTURY (SINCE 1971)
     C**   THEN RESTORE THE YEAR WHICH WAS INPUT BACK TO THE
     C**   ORIGINAL VALUE BEFORE CONTINUING WITH NORMAL CALCULATIONS.
     C**
     C     @@CC          MULT      36524         @@MDNO                         *1
     C     @@YYYY        ADD       1972          @@YYYY                         *1
     C                   END                                                    E1
     C*
     C     @@YYYY        ADD       28            @@WK2             2 0
     C*
     C     @@WK2         DIV       4             @@WK2
     C                   MVR                     @@REM             1 0
     C*
     C**    MULTIPLY BY NUMBER OF DAYS IN FOUR YEAR PERIOD
     C     @@WK2         MULT      1461          @@WK5             5 0
     C                   ADD       @@WK5         @@MDNO
     C*
     C**  CHECK REMAINDER AND MONTH NUMBER
     C     @@REM         IFEQ      0                                            B1
     C     @@MTH         ANDGT     2                                            B1
     C                   ADD       1             @@MDNO                         *1
     C                   END                                                    E1
     C*
     C**  YEAR NOT LEAP YEAR,  ADD CUMULATIVE DAYS FOR YEAR
     C     @@REM         IFNE      0                                            B1
     C                   ADD       @YD(@@REM)    @@MDNO                         *1
     C                   END                                                    E1
     C*
     C**  ADD MONTHS THIS YEAR
     C                   ADD       @MD(@@MTH)    @@MDNO
     C*
     C**  ADD DAYS THIS MONTH
     C                   ADD       @@DAY         @@MDNO
     C*
     C     ZA0689        ENDSR                                                  **ZA0689 TAG**
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* #C       - Termination Processing                             *
     C*                                                               *
     C* CALLS             -                                           *
     C*                                                               *
     C* CALLED BY  MAIN   - Main Processing                           *
     C*                                                               *
     C* FLDS USED         -                                           *
     C*                                                               *
     C*****************************************************************
     C     #C            BEGSR
     C*                                                                   S01280
     C***CLOSE*STANDARD*DEALS*FILE**********************************S01280S01319
     C*********************CLOSEABSTDDLL****************************S01280S01319
     C**************************************************************S01280S01319
     C     @TERM         IFEQ      'E'
     C     @TERM         OREQ      'T'
     C                   MOVE      '1'           *INLR
     C                   END
     C                   RETURN
     C*
     C     #C9           ENDSR                                                  ***#C9***
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* #A       - Initialisation Processing                         *
     C*                                                              *
     C* CALLS    ZA0150   - Access TABTB10                           *
     C*          #Z       - Database Errors                         *
     C*                                                              *
     C* CALLED BY         - Main Processing                          *
     C*                                                              *
     C* FLDS USED  @TERM  - Termination input parameter              *
     C*            @STDL  - Standard deal data structure             *
     C*                                                              *
     C****************************************************************
     C     #A            BEGSR
     C*
     C** Receive input parameters
     C     *ENTRY        PLIST
     C                   PARM                    @TERM             1
     C                   PARM                    @STDL
     C*
     C** Move program name into status data structure field
     C                   MOVEL     'AB0200'      DBPGM
     C*
     C** Open all fields
     C*********************OPEN FDICDRLL                                  S01194
     C*********************OPEN FDBSNCLL                                  S01194
     C*********************OPEN*ABSTDDLL**********************************S01319
     C************         OPEN ABDEALLL                                  AB0054
     C                   OPEN      ABDEAULL                                                    AB005
     C*********************OPEN FXTB40LL                                  S01194
     C*
     C***Call*subroutine*to*access*ICD file                               S01194
     C*********************EXSR*ZA0150                                    S01194
     C*********************                                               S01194
     C***Check*for*database*error                                         S01194
     C********** *IN80*****CASEQ'1'       #Z                              S01194
     C*********************END                                            S01194
     C*********************                                               S01117
     C************NAMVAR   DEFN           ZMUSER                   S01117 CAP004
     C*********************IN   ZMUSER                             S01117 CAP004
     C**                                                                  S01117
     C**  GET RUNDAT to access MULTI-BRANCHING flag.                      S01117
     C**                                                                  S01117
     C     *DTAARA       DEFINE                  RUNDAT                                        S0111
     C                   IN        RUNDAT                                                      S0111
     C*                                                                   AB0119
     C                   MOVE      'Y'           @FCYCL            1                           AB011
     C*
     C     #A9           ENDSR                                                  ***#A9***
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C***                                                             *
     C***SUBROUTINE ZA0150 - THIS SUBROUTINE CHAINS TO FILE LF        *   S01194
     C***FDICDRLL TO GET THE INSTALLATION CONTROL DETAILS RECORD 1    *   S01194
     C***(HELD ON PF/TABTB10)                                         *   S01194
     C***INDICATOR 80 IS SET ON IF THE CHAIN FAILS OR THE RECORD IS   *   S01194
     C***FLAGGED FOR DELETION.                                        *   S01194
     C***IF INDICATOR 80 IS SET ON DETAIL                             *   S01194
     C***ARE PLACED IN THE LDA.                                       *   S01194
     C***                                                             *   S01194
     C***FIELDS USED : SS0150 - KEY USED TO ACCESS FDICDRLL           *   S01194
     C***                                                             *   S01194
     C*****************************************************************   S01194
     C***                                                                 S01194
     C***********ZA0150****BEGSR                                          S01194
     C***                                                                 S01194
     C***Set*up*key*to*obtain*format*TABTB10F*'01        10'              S01194
     C*********************MOVEL'01'******SS0150 12                       S01194
     C*********************MOVE '10'******SS0150                          S01194
     C************************************                                S01194
     C***CHAIN*TO*FILE*FDICDRLL                                           S01194
     C***********SS0150****CHAINFDICDRLL             80                   S01194
     C***********RECI******IFNE 'D'                        B1             S01194
     C*********************MOVE '1'       *IN80            *1             S01194
     C*********************END                             E1             S01194
     C***                                                                 S01194
     C***DEAL WITH DATA BASE ERROR                                        S01194
     C********** *IN80*****IFEQ '1'                        ***************S01194
     C*********************MOVEL'FDICDRLL'DBFILE           *             *S01194
     C*********************MOVEL'900'     DBASE            * DBERROR 900 *S01194
     C*********************MOVELSS0150    DBKEY            *             *S01194
     C*********************END                             ***************S01194
     C***                                                                 S01194
     C***********ZA0159****ENDSR                                          S01194
      /EJECT                                                              S01194
     C*****************************************************
     C*                                                   *
     C*   #Z - DATABASE  ERROR SUBROUTINE                 *
     C*                                                   *
     C*   SUBROUTINE CALLED: EXECUTES WHENEVER            *
     C*   A DATABASE FILE ERROR OCCURS                    *
     C*                                                   *
     C*   SUBROUTINE CALLS : NO OTHER SUBROUTINES         *
     C*                                                   *
     C*****************************************************
     C     #Z            BEGSR
     C*
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      'E'           @TERM
     C                   MOVEL     'AB0200'      DBPGM
     C     @DUMP         IFEQ      *BLANKS                                                     S0111
     C                   MOVE      'Y'           @DUMP             1                           S0111
     C                   DUMP                                                                  AB020
     C                   END                                                                   S0111
     C                   MOVE      '1'           *INLR
     C*
     C**  TERMINATE THE PROGRAM
     C                   RETURN
     C*
     C                   ENDSR                                                  ***#Z***
      /EJECT
     C*****************************************************
     C*                                                   *
     C*   EXCEPTION ERROR SUBROUTINE                      *
     C*                                                   *
     C*   SUBROUTINE CALLED: EXECUTES WHENEVER            *
     C*   A PROGRAM ERROR OCCURS                          *
     C*                                                   *
     C*   SUBROUTINE CALLS : NO OTHER SUBROUTINES         *
     C*                                                   *
     C*****************************************************
     C     *PSSR         BEGSR
     C*
     C**  SET @ERR1 TO 'Y' TO PREVENT LOOPING IF FURTHER ERRORS
     C     @ERR1         IFNE      'Y'                                          B1
     C                   MOVE      'Y'           @ERR1             1            *1
     C                   MOVE      '1'           *INU6                          *1
     C                   MOVE      'E'           @TERM                          *1
     C*
     C**  SET UP FIELDS IN LOCAL DATA AREA
     C                   MOVEL     'AB0200'      DBPGM                          ***************
     C                   MOVE      '991'         DBASE                          * DBERROR 991 *
     C*                                                    ***************
     C                   MOVE      '1'           *INLR
     C                   DUMP                                                   *1
     C                   END                                                    E1
     C*
     C**  TERMINATE THE PROGRAM
     C                   RETURN
     C*
     C                   ENDSR                                                  ****PSSR****
      /EJECT
     C*****************************************************
     C*                                                   *
     C*   EXCEPTION ERROR SUBROUTINE                      *
     C*                                                   *
     C*   SUBROUTINE CALLED: EXECUTES WHENEVER            *
     C*   A FILE ERROR OCCURS                             *
     C*                                                   *
     C*   SUBROUTINE CALLS : NO OTHER SUBROUTINES         *
     C*                                                   *
     C*****************************************************
     C     INFSR         BEGSR
     C*
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      'E'           @TERM
     C*
     C**  SET UP FIELDS IN LOCAL DATA AREA
     C                   MOVEL     'AB0200'      DBPGM                          ***************
     C                   MOVE      '992'         DBASE                          * DBERROR 992 *
     C                   MOVE      @FILE         DBFILE                         ***************
     C*
     C                   MOVE      '1'           *INLR
     C                   DUMP
     C*
     C**  TERMINATE THE PROGRAM
     C                   RETURN
     C*
     C                   ENDSR                                                  ***INFSR***
      /EJECT
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA @YD
00366007310109601461
**CTDATA @MD
00000000310005900090001200015100181002120024300273003040033400365
