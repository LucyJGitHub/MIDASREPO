     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')           CAP084
      *****************************************************************
/*XBIA*  OVRDBF MMDDUMLL MMFWUDLL                                     *
/*XBIB*  OVRDBF MMHDUMLL MMFWUHLL                                     *
/*XBIC*  OVRDBF MMTDUMLL MMFWUTLL                                     *
/*STD *  RPGBASEMOD                                                   *         CAP084
/*EXI *  TEXT('Midas AB Arbitrage - Update MM forward book')
/*S******RPGBASE*******************************************************         CAP084
     F*****************************************************************
     F*                                                               *
     F*  Midas  -  Internal Contracts & Arbitrage Dealing
     F*                                                               *
     F*    AB0270 - Update MM Forward Book enquiry file               *
     F*                                                               *
     F*     Function: This program updates the Money Market forward   *
     F*     (I/C)     book file (MMFWDDPP) for every AB transaction   *
     F*     (I/C INT) entered.                                        *
     F*                                                               *
     F*     Called by: AB0330  - AB Back office Internal Contracts    *
     F*                          maintenance                          *
     F*                                                               *
     F*     Calls    : none                                           *
     F*                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
     F*                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 13Jan06               *
      *  Prev Amend No. CDL038             Date 10May05               *
      *                 CAP084             Date 06Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
     F*                 100278             DATE 24MAR97               *
     F*                 CAC001             Date 01Feb96               *
     F*                 S01319             Date 03Dec91               *
     F*                 S01279             Date 23Jan91               *
     F*                  E20774             DATE 15MAR90              *
     F*                  E20209             DATE 06FEB90              *
     F*                  S01117             Date 31JAN90              *
     F*                  S01194             Date 31JAN90              *
     F*                  E17063             DATE 05/05/89             *
     F*                  S01179             DATE 21/10/88             *
     F*                  AB0352             DATE 27/06/88             *
     F*                  AB0323             DATE 16/06/88             *
     F*                  AB0321             DATE 13/06/88             *
     F*                  AB0150             DATE 12/04/88             *
     F*                  AB0149             DATE 12/04/88             *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  CSD027 - Recompiled due to PF changes.                       *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CAP084 - Convert to ILE.                                     *
     F*  100278 - Prev. fix. Program should check for zero for the    *
     F*           insert case as well when calculating average rate.  *
     F*           This error happen if the file has statistic value   *
     F*           negative (HSMAOT).                                  *
     F*  CAC001 - Profit Centre Accounting Development:               *
     F*           Recompiled only.                                    *
     F*  S01319 - Changes for Project Harry.  LF/ABSTDDLL redundant.  *
     F*  S01279 - Replace CTC with Average rate on TM Daily           *
     F*           Summary enquiry.                                    *
     F*               - IF ONLY FAR DATE UPDATING REQUIRED THE TRADE  *
     F*           TYPE FIELD IS LEFT AS BLANKS                        *
     F*                                                               *
     F*  E20774 - REPLACE QCAEXEC WITH QCMDEXC                        *   E20774
     F*                                                               *
     F*  E20209 - To include additional field in chain & update of    *
     F*           MMFWDDPP & MMFWDHPP files.                          *
     F*                                                               *
     F*  S01194 - NEW STANDING DATA                                   *
     F*                                                               *
     F*  S01117 - MULTI-BRANCHING.                                    *
     F*                                                               *
     F*  E17063 - Recompiled using IGNDECERR(*YES).                   *
     F*                                                               *
     F*  S01179 - AS400 CONVERSION                                *
     F*                                                               *
     F*  AB0352 - FAR DATE PROCESSING FOR TOTAL FUNDS LENT            *
     F*           IS NOT REQUIRED.                                    *
     F*                                                               *
     F*  AB0323 - INTEREST * BY 10 AS MM ENQ. EXPECT THIS GREATER     *
     F*           ACCURACY AS DIV BY 10.                              *
     F*                                                               *
     F*  AB0321 - CASH OUT & CASH IN FOR FAR DATE SHOULD NOT          *
     F*           INCLUDE INTEREST.                                   *
     F*                                                               *
     F*  AB0150 - NO KIGNORES SHOULD BE ISSUED FOR FDICDRLL           *
     F*                                                               *
     F*  AB0149 - PARM @TERM - 'T' NOT TESTED FOR                     *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
     F*  CREATION PARAMETERS                                          *
     F*                                                               *
*****F** SNPDUMP(*NONE) CODELIST(*NONE) IGNDECERR(*NO)              : *   E17063
     F*                                                               *
     F*****************************************************************
     F*
     F**  Indicator Function Summary
     F*
     F* ID F  C  H  L    FUNCTION OF INDICATORS
     F* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     F*
     F*       60         General purpose indicator
     F*       80         Chain fail on FDICDRLL
     F*
     F*          U7    Set on with U8 if a database error occurs
     F*          U8    File out of balance if on on its own
      /EJECT
     F*FDICDRLLIF*E           K        DISK         KINFSR INFSR      UC  S01194
     F**********  TABTB11F                          KIGNORE               AB0150
     F**********  TABTB20F                          KIGNORE               AB0150
     FMMFWUDLL  UF A E           K DISK    INFSR(INFSR)
     F                                     USROPN
     F                                     COMMIT
     FMMDDUMLL  UF A E           K DISK    INFSR(INFSR)
     F                                     USROPN
     F                                     RENAME(MMFWDDP0:MMDDUMP0)
     FMMFWUHLL  UF A E           K DISK    INFSR(INFSR)
     F                                     USROPN
     F                                     COMMIT
     FMMHDUMLL  UF A E           K DISK    INFSR(INFSR)
     F                                     USROPN
     F                                     RENAME(MMFWDHP0:MMHDUMP0)
     FMMFWUTLL  UF A E           K DISK    INFSR(INFSR)
     F                                     USROPN
     F                                     COMMIT
     FMMTDUMLL  UF A E           K DISK    INFSR(INFSR)
     F                                     USROPN
     F                                     RENAME(MMFWDTP0:MMTDUMP0)
      /EJECT
     D** Array to hold copyright statement
     D*
     D***Command*used*on*call*to*QCAEXEC***                               E20774
     D** Command used on call to QCMDEXC                                  E20774
     D @CMD            S             30    DIM(3) CTDATA PERRCD(1)
      /EJECT
     D @CPYRT          DS
     D** Data structure for compilation - copyright insertion
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
     D*
     D*@STDD*****E*DSABSTDDLL                                             S01319
     D @STDD         E DS                  EXTNAME(ABSTDDPP)                    S01319
     D** Data structure for standard deals format
     D*
     D RUNDAT          DS            13                                         S01117
     D  RUNA                   1      7                                         S01117
     D  RUND                   8     10P 0                                      S01117
      /EJECT
     D PSDS           SDS
     D  @NOPMS                37     39  0
     D  @FILE                201    208
     D  @JOB                 244    253
     D  @USER                254    263
     D*
     D                UDS
     D**  Local data area for data base errors.
     D**  Field containing name of database file in error
     D  DBFILE               134    141
     D**  Field containing key value causing database error
     D  DBKEY                142    170
     D**  Field containing name of program causing database error
     D  DBPGM                171    180
     D**  Field containing number of database error
     D  DBASE                181    183
     D*
     D @UPDT           DS             7
     D** Data structure to hold the time of update from MIDAS run date
     D  HSDLUP                 1      2  0
     D  HTDLUP                 1      2  0
     D  HVDLUP                 1      2  0
     D  HSMLUP                 3      5
     D  HTMLUP                 3      5
     D  HVMLUP                 3      5
     D  HSYLUP                 6      7  0
     D  HTYLUP                 6      7  0
     D  HVYLUP                 6      7  0
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN     - Main controlling routine                           *
     C*                                                               *
     C* CALLS    #A       - Initial processing                        *
     C*          #B       - Routine controlling update sequence       *
     C*          #C       - Termination processing                    *
     C*                                                               *
     C* CALLED BY         -                                           *
     C*                                                               *
     C* FLDS USED  @TERM  - Termination parameter                     *
     C*                                                               *
     C*****************************************************************
     C*
     C** Initial processing
     C** Perform initial process if RUNA is blank
     C     RUNA          IFEQ      *BLANK                                       B1
     C                   EXSR      #A                                           *1
     C                   END                                                    E1
     C*
     C** Main processing
     C     *INU7         IFEQ      '0'                                          B1
     C     @TERM         ANDNE     'T'                                          *1
     C                   EXSR      #B                                           *1
     C                   END                                                    E1
     C*
     C** Termination processing
     C                   EXSR      #C
     C*
     C     ENDPGM        TAG                                                    **ENDPGM**
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* SUBROUTINES USED                                              *
     C*                                                               *
     C*  01  #BA     - Route through near date update sequence        *
     C*  02  #BB     - Route through far date update sequence         *
     C*  03  #BAA    - Write/update near date records on LF/MMFWUDLL  *
     C*  04  #BAB    - Write/update near date records on LF/MMFWUHLL  *
     C*  05  #BAC    - Write/update near date records on LF/MMFWUTLL  *
     C*  06  #BAA    - Write/update far date records on LF/MMFWUDLL   *
     C*  07  #BAB    - Write/update far date records on LF/MMFWUHLL   *
     C*  08  #BAC    - Write/update far date records on LF/MMFWUTLL   *
     C*  09  #B      - Routine controlling updating sequence          *
     C*  10  #A      - Initial processing                             *
     C*  11  #C      - Termination processing                         *
     C*  12  ZA0150  - Access LF/FDICDRLL                             *
     C*  13  *PSSR   - Error routine performed on program error       *
     C*  14  INFSR   - Error routine performed on file error          *
     C*                                                               *
     C* EXTERNAL ROUTINE                                              *
     C*                                                               *
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* #BA     - Route through near date update sequence             *
     C*                                                               *
     C* CALLS    #BAA     - Write/update near date records on         *
     C*                     LF/MMFWUDLL                               *
     C*          #BAB     - Write/update near date records on         *
     C*                     LF/MMFWUHLL                               *
     C*          #BAC     - Write/update near date records on         *
     C*                     LF/MMFWUTLL                               *
     C*                                                               *
     C* CALLED BY  #B     - Routine controlling updating sequence     *
     C*                                                               *
     C* FLDS USED  @DTYY  - Date used to access forward book files    *
     C*            @DTMM  - Date used to access forward book files    *
     C*            @DTDD  - Date used to access forward book files    *
     C*                                                               *
     C*****************************************************************
     C     #BA           BEGSR
     C*
     C** Set up key to forward book MMFWUDLL and MMFWUHLL
     C                   Z-ADD     JUNDYY        @DTYY
     C                   Z-ADD     JUNDMM        @DTMM
     C                   Z-ADD     JUNDDD        @DTDD
     C                   MOVE      'LD'          @LDNA             2                           E2020
     C*
     C** Update forward book daily details for near date
     C                   EXSR      #BAA
     C*
     C** Update forward book half monthly details for near date
     C                   EXSR      #BAB
     C*
     C** Update forward book totals for near date
     C                   EXSR      #BAC
     C*
     C     #BA9          ENDSR                                                  **#BA9**
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* #BB     - Route through far date update sequence              *
     C*                                                               *
     C* CALLS    #BBA     - Write/update far date records on          *
     C*                     LF/MMFWUDLL                               *
     C*          #BBB     - Write/update far date records on          *
     C*                     LF/MMFWUHLL                               *
     C*          #BBC     - Write/update far date records on          *
     C*                     LF/MMFWUTLL                               *
     C*                                                               *
     C* CALLED BY  #B     - Routine controlling updating sequence     *
     C*                                                               *
     C* FLDS USED  @DTYY  - Date used to access forward book files    *
     C*            @DTMM  - Date used to access forward book files    *
     C*            @DTDD  - Date used to access forward book files    *
     C*                                                               *
     C*****************************************************************
     C     #BB           BEGSR
     C*
     C** Set up key to forward book MMFWUDLL and MMFWUHLL
     C                   Z-ADD     JUFDYY        @DTYY
     C                   Z-ADD     JUFDMM        @DTMM
     C                   Z-ADD     JUFDDD        @DTDD
     C                   MOVE      'LD'          @LDNA                                         S0127
     C*
     C** Update forward book daily details for far date
     C                   EXSR      #BBA
     C*
     C** Update forward book half monthly details for far date
     C                   EXSR      #BBB
     C*
     C** Update forward book totals for far date
     C                   EXSR      #BBC
     C*
     C     #BB9          ENDSR                                                  **#BB9**
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* #BAA    - Write/update near date records on LF/MMFWUDLL       *
     C*                                                               *
     C* CALLS             -                                           *
     C*                                                               *
     C* CALLED BY  #BA    - Route through near date update sequence   *
     C*                                                               *
     C* FLDS USED  @COFF2 - Commitment control indicator              *
     C*            @DKEY  - Key to file LF/MMFWUDLL                   *
     C*            @USER  - Job user                                  *
     C*            @CCY   - Deal currency                             *
     C*            @DTYY  - Date used to access forward book files    *
     C*            @DTMM  - Date used to access forward book files    *
     C*            @DTDD  - Date used to access forward book files    *
     C*            @AMT   - Deal amount                               *
     C*                                                               *
     C*****************************************************************
     C     #BAA          BEGSR
     C*
     C**  Chain to MMFWUDLL file
     C     @COFF2        IFEQ      'Y'                                          B1
     C     @DKEY         CHAIN     MMDDUMLL                           60        *1
     C                   ELSE                                                   X1
     C     @DKEY         CHAIN     MMFWUDLL                           60        *1
     C                   END                                                    E1
     C*
     C** If no record exists on file,
     C** create a blank/zero record - (ie. initialise fields)
     C     *IN60         IFEQ      '1'                                          B1
     C*
     C** Set up standard data
     C                   MOVE      'HS'          HSRCID                         *1
     C                   TIME                    HSTLUP                         *1
     C                   MOVE      'I'           HSCHTP                         *1
     C                   Z-ADD     RUND          HSLCD                          *1
     C                   MOVEL     @USER         HSLUID                         *1
     C                   MOVE      @CCY          HSCCY                          *1
     C                   MOVE      @DTYY         HSFBYY                         *1
     C                   MOVE      @DTMM         HSFBMM                         *1
     C                   MOVE      @DTDD         HSFBDD                         *1
     C                   MOVE      @LDNA         HSLDNA                         *1             E2020
     C*
     C** Initialise other fields
     C                   Z-ADD     0             HSDCIN                         *1
     C                   Z-ADD     0             HSDCOT                         *1
     C                   Z-ADD     0             HSDNMT                         *1
     C                   Z-ADD     0             HSDNIM                         *1
     C                   Z-ADD     0             HSFIXM                         *1
     C                   Z-ADD     0             HSMAIN                         *1             S0127
     C                   Z-ADD     0             HSMAOT                         *1             S0127
     C                   Z-ADD     0             HSAVIN                         *1             S0127
     C                   Z-ADD     0             HSAVOT                         *1             S0127
     C*
     C                   END                                                    E1
     C*
     C** Calculate the daily cash in and out
     C     JULACT        IFEQ      'I'                                          B1
     C     @AMT          IFGE      0                                            B*2
     C                   ADD       @AMT          HSDCOT                         **2
     C                   ELSE                                                   X*2
     C                   SUB       @AMT          HSDCIN                         **2
     C                   END                                                    E*2
     C*
     C                   ELSE                                                   X1
     C*
     C** Delete processing
     C     @AMT          IFGE      0                                            B*2
     C                   SUB       @AMT          HSDCOT                         **2
     C                   ELSE                                                   X*2
     C                   ADD       @AMT          HSDCIN                         **2
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
     C*
     C** Calculate the daily net movement
     C     HSDCIN        SUB       HSDCOT        HSDNMT
     C*
     C** If no record was found on file, write a new record
     C     *IN60         IFEQ      '1'                                          B1
     C*
     C     @COFF2        IFEQ      'Y'                                          B*2
     C                   WRITE     MMDDUMP0                                     **2
     C                   ELSE                                                   X*2
     C                   WRITE     MMFWDDP0                                     **2
     C                   END                                                    E*2
     C*
     C                   ELSE                                                   X1
     C*
     C** If record already on file, update it with new information
     C                   TIME                    HSTLUP                         *1
     C                   MOVE      'A'           HSCHTP                         *1
     C                   Z-ADD     RUND          HSLCD                          *1
     C                   MOVEL     @USER         HSLUID                         *1
     C*
     C     @COFF2        IFEQ      'Y'                                          B*2
     C                   UPDATE    MMDDUMP0                                     **2
     C                   ELSE                                                   X*2
     C                   UPDATE    MMFWDDP0                                     **2
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
     C*
     C     #BAA9         ENDSR                                                  **#BAA9**
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* #BAB    - Write/update near date records on LF/MMFWUHLL       *
     C*                                                               *
     C* CALLS             -                                           *
     C*                                                               *
     C* CALLED BY  #BA    - Route through near date update sequence   *
     C*                                                               *
     C* FLDS USED  @DTHM  - Half month indicator                      *
     C*            @COFF2 - Commitment control indicator              *
     C*            @HKEY  - Key to file LF/MMFWUHLL                   *
     C*            @USER  - Job user                                  *
     C*            @CCY   - Deal currency                             *
     C*            @DTYY  - Date used to access forward book files    *
     C*            @DTMM  - Date used to access forward book files    *
     C*            @DTDD  - Date used to access forward book files    *
     C*            @AMT   - Deal amount                               *
     C*                                                               *
     C*****************************************************************
     C     #BAB          BEGSR
     C*
     C** If days in near date are from 1 to 15 inclusive, set half
     C** period indicator to 01. Otherwise set to 02.
     C     @DTDD         IFLE      15                                           B1
     C                   Z-ADD     1             @DTHM                          *1
     C                   ELSE                                                   X1
     C                   Z-ADD     2             @DTHM                          *1
     C                   END                                                    E1
     C*
     C** Chain to MMFWUHLL file
     C     @COFF2        IFEQ      'Y'                                          B1
     C     @HKEY         CHAIN     MMHDUMLL                           60        *1
     C                   ELSE                                                   X1
     C     @HKEY         CHAIN     MMFWUHLL                           60        *1
     C                   END                                                    E1
     C*
     C** If no record exists on file,
     C** create a blank/zero record - (ie. initialise fields)
     C     *IN60         IFEQ      '1'                                          B1
     C*
     C** Set up standard data
     C                   MOVE      'HT'          HTRCID                         *1
     C                   TIME                    HTTLUP                         *1
     C                   MOVE      'I'           HTCHTP                         *1
     C                   Z-ADD     RUND          HTLCD                          *1
     C                   MOVEL     @USER         HTLUID                         *1
     C                   MOVE      @CCY          HTCCY                          *1
     C                   MOVE      @DTYY         HTFBYY                         *1
     C                   MOVE      @DTMM         HTFBMM                         *1
     C                   MOVE      @DTHM         HTFBHM                         *1
     C                   MOVE      @LDNA         HTLDNA                         *1             E2020
     C*
     C** Initialise other fields
     C                   Z-ADD     0             HTHMCI                         *1
     C                   Z-ADD     0             HTHMCO                         *1
     C                   Z-ADD     0             HTHMNM                         *1
     C                   Z-ADD     0             HTHNIM                         *1
     C                   Z-ADD     0             HTFIXM                         *1
     C*
     C                   END                                                    E1
     C*
     C** Calculate the half monthly cash in and out
     C     JULACT        IFEQ      'I'                                          B1
     C     @AMT          IFGE      0                                            B*2
     C                   ADD       @AMT          HTHMCO                         **2
     C                   ELSE                                                   X*2
     C                   SUB       @AMT          HTHMCI                         **2
     C                   END                                                    E*2
     C*
     C                   ELSE                                                   X1
     C*
     C** Delete processing
     C     @AMT          IFGE      0                                            B*2
     C                   SUB       @AMT          HTHMCO                         **2
     C                   ELSE                                                   X*2
     C                   ADD       @AMT          HTHMCI                         **2
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
     C*
     C** Calculate the half monthly net movement
     C     HTHMCI        SUB       HTHMCO        HTHMNM
     C*
     C** If no record was found on file, write a new record
     C     *IN60         IFEQ      '1'                                          B1
     C*
     C     @COFF2        IFEQ      'Y'                                          B*2
     C                   WRITE     MMHDUMP0                                     **2
     C                   ELSE                                                   X*2
     C                   WRITE     MMFWDHP0                                     **2
     C                   END                                                    E*2
     C*
     C                   ELSE                                                   X1
     C*
     C** If record already on file, update it with new information
     C                   TIME                    HTTLUP                         *1
     C                   MOVE      'A'           HTCHTP                         *1
     C                   Z-ADD     RUND          HTLCD                          *1
     C                   MOVEL     @USER         HTLUID                         *1
     C*
     C     @COFF2        IFEQ      'Y'                                          B*2
     C                   UPDATE    MMHDUMP0                                     **2
     C                   ELSE                                                   X*2
     C                   UPDATE    MMFWDHP0                                     **2
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
     C*
     C     #BAB9         ENDSR                                                  **#BAB9**
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* #BAC    - Write/update near date records on LF/MMFWUTLL       *
     C*                                                               *
     C* CALLS             -                                           *
     C*                                                               *
     C* CALLED BY  #BA    - Route through near date update sequence   *
     C*                                                               *
     C* FLDS USED  @COFF2 - Commitment control indicator              *
     C*            @CCY   - Deal currency                             *
     C*            @USER  - Job user                                  *
     C*            @AMT   - Deal amount                               *
     C*                                                               *
     C*****************************************************************
     C     #BAC          BEGSR
     C*
     C**  Chain to MMFWUTLL file
     C     @COFF2        IFEQ      'Y'                                          B1
     C     @CCY          CHAIN     MMTDUMLL                           60        *1
     C                   ELSE                                                   X1
     C     @CCY          CHAIN     MMFWUTLL                           60        *1
     C                   END                                                    E1
     C*
     C** If no record exists on file,
     C** create a blank/zero record - (ie. initialise fields)
     C     *IN60         IFEQ      '1'                                          B1
     C*
     C** Set up standard data
     C                   MOVE      'HV'          HVRCID                         *1
     C                   TIME                    HVTLUP                         *1
     C                   MOVE      'I'           HVCHTP                         *1
     C                   Z-ADD     RUND          HVLCD                          *1
     C                   MOVEL     @USER         HVLUID                         *1
     C                   MOVE      @CCY          HVCCY                          *1
     C*
     C** Initialise other fields
     C                   Z-ADD     0             HVNSNV                         *1
     C                   Z-ADD     0             HVTFDL                         *1
     C                   Z-ADD     0             HVTCIN                         *1
     C                   Z-ADD     0             HVTCOT                         *1
     C**********           Z-ADD0         HVNCMT           *1             S01179
     C                   Z-ADD     0             HVNCML                         *1             S0117
     C                   Z-ADD     0             HVNCMN                         *1             S0117
     C**********           Z-ADD0         HVNIMT           *1             S01179
     C                   Z-ADD     0             HVNIML                         *1             S0117
     C                   Z-ADD     0             HVNIMN                         *1             S0117
     C                   Z-ADD     0             HVMMFN                         *1
     C**********           Z-ADD0         HVCCPL           *1             S01179
     C                   Z-ADD     0             HVCPLL                         *1             S0117
     C                   Z-ADD     0             HVCPLN                         *1             S0117
     C*
     C                   END                                                    E1
     C*
     C** Calculate the total cash in and out
     C     JULACT        IFEQ      'I'                                          B1
     C     @AMT          IFGE      0                                            B*2
     C                   ADD       @AMT          HVTCOT                         **2
     C                   ELSE                                                   X*2
     C                   SUB       @AMT          HVTCIN                         **2
     C                   END                                                    E*2
     C*
     C                   ELSE                                                   X1
     C*
     C** Delete processing
     C     @AMT          IFGE      0                                            B*2
     C                   SUB       @AMT          HVTCOT                         **2
     C                   ELSE                                                   X*2
     C                   ADD       @AMT          HVTCIN                         **2
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
     C*
     C** Calculate the total funds lent
     C     @AMT          IFGE      0                                            B1
     C     JULACT        IFEQ      'I'                                          B*2
     C                   ADD       @AMT          HVTFDL                         **2
     C                   ELSE                                                   X*2
     C                   SUB       @AMT          HVTFDL                         **2
     C                   END                                                    E*2
     C                   END                                                    E1
     C*
     C** Calculate the net cashflow movement
     C********** HVTCIN    SUB  HVTCOT    HVNCMT                          S01179
     C     HVTCIN        SUB       HVTCOT        HVNCML                                        S0117
     C*
     C** If no record was found on file, write a new record
     C     *IN60         IFEQ      '1'                                          B1
     C*
     C     @COFF2        IFEQ      'Y'                                          B*2
     C                   WRITE     MMTDUMP0                                     **2
     C                   ELSE                                                   X*2
     C                   WRITE     MMFWDTP0                                     **2
     C                   END                                                    E*2
     C*
     C                   ELSE                                                   X1
     C*
     C** If record already on file, update it with new information
     C                   TIME                    HVTLUP                         *1
     C                   MOVE      'A'           HVCHTP                         *1
     C                   Z-ADD     RUND          HVLCD                          *1
     C                   MOVEL     @USER         HVLUID                         *1
     C*
     C     @COFF2        IFEQ      'Y'                                          B*2
     C                   UPDATE    MMTDUMP0                                     **2
     C                   ELSE                                                   X*2
     C                   UPDATE    MMFWDTP0                                     **2
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
     C*
     C     #BAC9         ENDSR                                                  **#BAC9**
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* #BBA    - Write/update far date records on LF/MMFWUDLL        *
     C*                                                               *
     C* CALLS             -                                           *
     C*                                                               *
     C* CALLED BY  #BB    - Route through far date update sequence    *
     C*                                                               *
     C* FLDS USED  @COFF2 - Commitment control indicator              *
     C*            @DKEY  - Key to file LF/MMFWUDLL                   *
     C*            @USER  - Job user                                  *
     C*            @CCY   - Deal currency                             *
     C*            @DTYY  - Date used to access forward book files    *
     C*            @DTMM  - Date used to access forward book files    *
     C*            @DTDD  - Date used to access forward book files    *
     C*            @AMT   - Deal amount                               *
     C*            @LIAM  - Loan interest amount                      *
     C*            @DIAM  - Deposit interest amount                   *
     C*                                                               *
     C*****************************************************************
     C*                                                                   S01279
     C** only set up the appropriate average rate, ie. cash in or cash outS01279
     C** note that average rate is only updated for maturity date.     or S01279
     C*  The calculation is:                                              S01279
     C*  New average rate, cash in  HSAVIN =                              S01279
     C*                                                                   S01279
     C*  (Current average * Current cash) + (Rate,   * cash      )        S01279
     C*   rate, cash in     in at mdate      cash in   in at mdate        S01279
     C*  ---------------------------------------------------------        S01279
     C*   (Current cash in at mdat, HSMAIN + cash in at mdate, @AMT)      S01279
     C*                                                                   S01279
     C*    ie. =  @WRK1 + @WRK2      in this coding.                      S01279
     C*           -------------                                           S01279
     C*               @WRK3                                               S01279
     C*                                                                   S01279
     C** calculation for average rate cash out is similiar.               S01279
     C*                                                                   S01279
     C     #BBA          BEGSR
     C*
     C**  Chain to MMFWUDLL file
     C     @COFF2        IFEQ      'Y'                                          B1
     C     @DKEY         CHAIN     MMDDUMLL                           60        *1
     C                   ELSE                                                   X1
     C     @DKEY         CHAIN     MMFWUDLL                           60        *1
     C                   END                                                    E1
     C*
     C** If no record exists on file,
     C** create a blank/zero record - (ie. initialise fields)
     C     *IN60         IFEQ      '1'                                          B1
     C*
     C** Set up standard data
     C                   MOVE      'HS'          HSRCID                         *1
     C                   TIME                    HSTLUP                         *1
     C                   MOVE      'I'           HSCHTP                         *1
     C                   Z-ADD     RUND          HSLCD                          *1
     C                   MOVEL     @USER         HSLUID                         *1
     C                   MOVE      @CCY          HSCCY                          *1
     C                   MOVE      @DTYY         HSFBYY                         *1
     C                   MOVE      @DTMM         HSFBMM                         *1
     C                   MOVE      @DTDD         HSFBDD                         *1
     C                   MOVE      @LDNA         HSLDNA                         *1             S0127
     C*
     C** Initialise other fields
     C                   Z-ADD     0             HSDCIN                         *1
     C                   Z-ADD     0             HSDCOT                         *1
     C                   Z-ADD     0             HSDNMT                         *1
     C                   Z-ADD     0             HSDNIM                         *1
     C                   Z-ADD     0             HSFIXM                         *1
     C                   Z-ADD     0             HSMAIN                         *1             S0127
     C                   Z-ADD     0             HSMAOT                         *1             S0127
     C                   Z-ADD     0             HSAVIN                         *1             S0127
     C                   Z-ADD     0             HSAVOT                         *1             S0127
     C*
     C                   END                                                    E1
     C*
     C** Calculate the daily cash in and out and interest movements
     C*
     C     @LIAM         MULT      10            @LI10            15 0                         AB032
     C     @DIAM         MULT      10            @DI10            15 0                         AB032
     C*                                                                   S01279
     C** clear work fields                                                S01279
     C                   Z-ADD     *ZERO         @WRK1            30 8                         S0127
     C                   Z-ADD     *ZERO         @WRK2            30 8                         S0127
     C                   Z-ADD     *ZERO         @WRK3            20 0                         S0127
     C*
     C     JULACT        IFEQ      'I'                                          B1
     C     @AMT          IFLT      0                                            B*2
     C*                                                                   S01279
     C** If record not found on forward book file no need to              S01279
     C** calculate a weighted average cash in, remember @AMT is -ve       S01279
     C     *IN60         IFEQ      '1'                                          B**3           S0127
     C                   Z-ADD     @RATE         HSAVIN                         ***3           S0127
     C                   ELSE                                                   X**3           S0127
     C*                                                                   S01279
     C** Could get divide by zero (File value/rate = input transaction)   100278
     C     HSMAIN        SUB       @AMT          @WRK3                                         10027
     C     @WRK3         IFNE      *ZERO                                                       10027
     C     @RATE         MULT      @AMT          @WRK1                          ***3           S0127
     C     HSAVIN        MULT      HSMAIN        @WRK2                          ***3           S0127
     C     @WRK2         SUB       @WRK1         @WRK1                          ***3           S0127
     C***********HSMAIN    SUB  @AMT      @WRK3            ***3     S01279100278
     C     @WRK1         DIV(H)    @WRK3         HSAVIN                         ***3           S0127
     C                   ELSE                                                                  10027
     C                   Z-ADD     *ZERO         HSAVIN                                        10027
     C                   END                                                                   10027
     C                   END                                                    E**3           S0127
     C*                                                                   S01279
     C                   SUB       @AMT          HSMAIN                         **2            S0127
     C**********           SUB  @AMT      HSDCIN           **2            S01279
     C*********            ADD  @LIAM     HSDNIM           **2            AB0323
     C                   ADD       @LI10         HSDNIM                         **2            AB032
     C*                                                                   S01279
     C** Else amount is +ve                                               S01279
     C                   ELSE                                                   X*2
     C*                                                                   S01279
     C** If record not found on forward book file no need to              S01279
     C** calculate a weighted average rate, cash out                      S01279
     C     *IN60         IFEQ      '1'                                          B**3           S0127
     C                   Z-ADD     @RATE         HSAVOT                         ***3           S0127
     C                   ELSE                                                   X**3           S0127
     C*                                                                   S01279
     C** Could get divide by zero (File value/rate = input transaction)   100278
     C     HSMAOT        ADD       @AMT          @WRK3                                         10027
     C     @WRK3         IFNE      *ZERO                                                       10027
     C     @RATE         MULT      @AMT          @WRK1                          ***3           S0127
     C     HSAVOT        MULT      HSMAOT        @WRK2                          ***3           S0127
     C     @WRK1         ADD       @WRK2         @WRK1                          ***3           S0127
     C***********HSMAOT    ADD  @AMT      @WRK3            ***3     S01279100278
     C     @WRK1         DIV(H)    @WRK3         HSAVOT                         ***3           S0127
     C                   ELSE                                                                  10027
     C                   Z-ADD     *ZERO         HSAVOT                                        10027
     C                   END                                                                   10027
     C                   END                                                    E**3           S0127
     C*                                                                   S01279
     C                   ADD       @AMT          HSMAOT                         **2            S0127
     C**********           ADD  @AMT      HSDCOT           **2            S01279
     C*********            SUB  @DIAM     HSDNIM           **2            AB0323
     C                   SUB       @DI10         HSDNIM                         **2            AB032
     C                   END                                                    E*2
     C*
     C** Else code for deal deletion                                      S01279
     C                   ELSE                                                   X1
     C*
     C     @AMT          IFLT      0                                            B*2
     C*                                                                   S01279
     C** If record not found on forward book file no need to              S01279
     C** calculate a weighted average cash in, remember @AMT is -ve       S01279
     C     *IN60         IFEQ      '1'                                          B**3           S0127
     C                   Z-ADD     @RATE         HSAVIN                         ***3           S0127
     C                   ELSE                                                   X**3           S0127
     C*                                                                   S01279
     C** Could get divide by zero with deletes so check for it            S01279
     C     HSMAIN        ADD       @AMT          @WRK3                          ***3           S0127
     C     @WRK3         IFNE      *ZERO                                        B***4          S0127
     C*                                                                   S01279
     C** remember @WRK1 will be -ve                                       S01279
     C     @RATE         MULT      @AMT          @WRK1                          ****4          S0127
     C     HSAVIN        MULT      HSMAIN        @WRK2                          ****4          S0127
     C     @WRK1         ADD       @WRK2         @WRK1                          ****4          S0127
     C     @WRK1         DIV(H)    @WRK3         HSAVIN                         ****4          S0127
     C                   ELSE                                                   X***4          S0127
     C                   Z-ADD     *ZERO         HSAVIN                         ****4          S0127
     C                   END                                                    E***4          S0127
     C                   END                                                    E**3           S0127
     C*                                                                   S01279
     C                   ADD       @AMT          HSMAIN                         **2            S0127
     C**********           ADD  @AMT      HSDCIN           **2            S01279
     C*********            SUB  @LIAM     HSDNIM           **2            AB0323
     C                   SUB       @LI10         HSDNIM                         **2            AB032
     C                   ELSE                                                   X*2
     C*                                                                   S01279
     C** If record not found on forward book file no need to              S01279
     C** calculate a weighted average cash out, remember @AMT is +ve      S01279
     C     *IN60         IFEQ      '1'                                          B**3           S0127
     C                   Z-ADD     @RATE         HSAVOT                         ***3           S0127
     C                   ELSE                                                   X**3           S0127
     C*                                                                   S01279
     C** Could get divide by zero with deletes so check for it            S01279
     C     HSMAOT        SUB       @AMT          @WRK3                          ***3           S0127
     C     @WRK3         IFNE      *ZERO                                        B***4          S0127
     C*                                                                   S01279
     C     @RATE         MULT      @AMT          @WRK1                          ****4          S0127
     C     HSAVOT        MULT      HSMAOT        @WRK2                          ****4          S0127
     C     @WRK2         SUB       @WRK1         @WRK1                          ****4          S0127
     C     @WRK1         DIV(H)    @WRK3         HSAVOT                         ****4          S0127
     C                   ELSE                                                   X***4          S0127
     C                   Z-ADD     *ZERO         HSAVOT                         ****4          S0127
     C                   END                                                    E***4          S0127
     C                   END                                                    E**3           S0127
     C*                                                                   S01279
     C                   SUB       @AMT          HSMAOT                         **2            S0127
     C**********           SUB  @AMT      HSDCOT           **2            S01279
     C*********            ADD  @DIAM     HSDNIM           **2            AB0323
     C                   ADD       @DI10         HSDNIM                         **2            AB032
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
     C**********                                                          S01279
     C***Calculate*the*daily*net*movement***                              S01279
     C********** HSDCIN    SUB  HSDCOT    HSDNMT                          S01279
     C*
     C** If no record was found on file, write a new record
     C     *IN60         IFEQ      '1'                                          B1
     C*
     C     @COFF2        IFEQ      'Y'                                          B*2
     C                   WRITE     MMDDUMP0                                     **2
     C                   ELSE                                                   X*2
     C                   WRITE     MMFWDDP0                                     **2
     C                   END                                                    E*2
     C*
     C                   ELSE                                                   X1
     C*
     C** If record already on file, update it with new information
     C                   TIME                    HSTLUP                         *1
     C                   MOVE      'A'           HSCHTP                         *1
     C                   Z-ADD     RUND          HSLCD                          *1
     C                   MOVEL     @USER         HSLUID                         *1
     C*
     C     @COFF2        IFEQ      'Y'                                          B*2
     C                   UPDATE    MMDDUMP0                                     **2
     C                   ELSE                                                   X*2
     C                   UPDATE    MMFWDDP0                                     **2
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
     C*
     C     #BBA9         ENDSR                                                  **#BBA9**
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* #BBB    - Write/update far date records on LF/MMFWUMLL        *
     C*                                                               *
     C* CALLS             -                                           *
     C*                                                               *
     C* CALLED BY  #BB    - Route through far date update sequence    *
     C*                                                               *
     C* FLDS USED  @DTHM  - Half month indicator                      *
     C*            @COFF2 - Commitment control indicator              *
     C*            @HKEY  - Key to file LF/MMFWUHLL                   *
     C*            @USER  - Job user                                  *
     C*            @CCY   - Deal currency                             *
     C*            @DTYY  - Date used to access forward book files    *
     C*            @DTMM  - Date used to access forward book files    *
     C*            @DTDD  - Date used to access forward book files    *
     C*            @AMT   - Deal amount                               *
     C*            @LIAM  - Loan interest amount                      *
     C*            @DIAM  - Deposit interest amount                   *
     C*                                                               *
     C*****************************************************************
     C     #BBB          BEGSR
     C*
     C** If days in far date are from 1 to 15 inclusive, set half
     C** period indicator to 01. Otherwise set to 02.
     C     @DTDD         IFLE      15                                           B1
     C                   Z-ADD     1             @DTHM                          *1
     C                   ELSE                                                   X1
     C                   Z-ADD     2             @DTHM                          *1
     C                   END                                                    E1
     C*
     C** Chain to MMFWUHLL file
     C     @COFF2        IFEQ      'Y'                                          B1
     C     @HKEY         CHAIN     MMHDUMLL                           60        *1
     C                   ELSE                                                   X1
     C     @HKEY         CHAIN     MMFWUHLL                           60        *1
     C                   END                                                    E1
     C*
     C** If no record exists on file,
     C** create a blank/zero record - (ie. initialise fields)
     C     *IN60         IFEQ      '1'                                          B1
     C*
     C** Set up standard data
     C                   MOVE      'HT'          HTRCID                         *1
     C                   TIME                    HTTLUP                         *1
     C                   MOVE      'I'           HTCHTP                         *1
     C                   Z-ADD     RUND          HTLCD                          *1
     C                   MOVEL     @USER         HTLUID                         *1
     C                   MOVE      @CCY          HTCCY                          *1
     C                   MOVE      @DTYY         HTFBYY                         *1
     C                   MOVE      @DTMM         HTFBMM                         *1
     C                   MOVE      @DTHM         HTFBHM                         *1
     C                   MOVE      @LDNA         HTLDNA                         *1             S0127
     C*
     C** Initialise other fields
     C                   Z-ADD     0             HTHMCI                         *1
     C                   Z-ADD     0             HTHMCO                         *1
     C                   Z-ADD     0             HTHMNM                         *1
     C                   Z-ADD     0             HTHNIM                         *1
     C                   Z-ADD     0             HTFIXM                         *1
     C*
     C                   END                                                    E1
     C*
     C** Calculate the half monthly
     C** cash in and out and interest movements
     C     JULACT        IFEQ      'I'                                          B1
     C     @AMT          IFLT      0                                            B*2
     C                   SUB       @AMT          HTHMCI                         **2
     C                   ADD       @LIAM         HTHNIM                         **2
     C                   ELSE                                                   X*2
     C                   ADD       @AMT          HTHMCO                         **2
     C                   SUB       @DIAM         HTHNIM                         **2
     C                   END                                                    E*2
     C*
     C                   ELSE                                                   X1
     C*
     C     @AMT          IFLT      0                                            B*2
     C                   ADD       @AMT          HTHMCI                         **2
     C                   SUB       @LIAM         HTHNIM                         **2
     C                   ELSE                                                   X*2
     C                   SUB       @AMT          HTHMCO                         **2
     C                   ADD       @DIAM         HTHNIM                         **2
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
     C*
     C** Calculate the half monthly net movement
     C     HTHMCI        SUB       HTHMCO        HTHMNM
     C*
     C** If no record was found on file, write a new record
     C     *IN60         IFEQ      '1'                                          B1
     C*
     C     @COFF2        IFEQ      'Y'                                          B*2
     C                   WRITE     MMHDUMP0                                     **2
     C                   ELSE                                                   X*2
     C                   WRITE     MMFWDHP0                                     **2
     C                   END                                                    E*2
     C*
     C                   ELSE                                                   X1
     C*
     C** If record already on file, update it with new information
     C                   TIME                    HTTLUP                         *1
     C                   MOVE      'A'           HTCHTP                         *1
     C                   Z-ADD     RUND          HTLCD                          *1
     C                   MOVEL     @USER         HTLUID                         *1
     C*
     C     @COFF2        IFEQ      'Y'                                          B*2
     C                   UPDATE    MMHDUMP0                                     **2
     C                   ELSE                                                   X*2
     C                   UPDATE    MMFWDHP0                                     **2
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
     C*
     C     #BBB9         ENDSR                                                  **#BBB9**
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* #BBC    - Write/update far date records on LF/MMFWUTLL        *
     C*                                                               *
     C* CALLS             -                                           *
     C*                                                               *
     C* CALLED BY  #BB    - Route through far date update sequence    *
     C*                                                               *
     C* FLDS USED  @COFF2 - Commitment control indicator              *
     C*            @CCY   - Deal currency                             *
     C*            @USER  - Job user                                  *
     C*            @AMT   - Deal amount                               *
     C*            @LIAM  - Loan interest amount                      *
     C*            @DIAM  - Deposit interest amount                   *
     C*                                                               *
     C*****************************************************************
     C     #BBC          BEGSR
     C*
     C**  Chain to MMFWUTLL file
     C     @COFF2        IFEQ      'Y'                                          B1
     C     @CCY          CHAIN     MMTDUMLL                           60        *1
     C                   ELSE                                                   X1
     C     @CCY          CHAIN     MMFWUTLL                           60        *1
     C                   END                                                    E1
     C*
     C** If no record exists on file,
     C** create a blank/zero record - (ie. initialise fields)
     C     *IN60         IFEQ      '1'                                          B1
     C*
     C** Set up standard data
     C                   MOVE      'HV'          HVRCID                         *1
     C                   TIME                    HVTLUP                         *1
     C                   MOVE      'I'           HVCHTP                         *1
     C                   Z-ADD     RUND          HVLCD                          *1
     C                   MOVEL     @USER         HVLUID                         *1
     C                   MOVE      @CCY          HVCCY                          *1
     C*
     C** Initialise other fields
     C                   Z-ADD     0             HVNSNV                         *1
     C                   Z-ADD     0             HVTFDL                         *1
     C                   Z-ADD     0             HVTCIN                         *1
     C                   Z-ADD     0             HVTCOT                         *1
     C**********           Z-ADD0         HVNCMT           *1             S01179
     C                   Z-ADD     0             HVNCML                         *1             S0117
     C                   Z-ADD     0             HVNCMN                         *1             S0117
     C**********           Z-ADD0         HVNIMT           *1             S01179
     C                   Z-ADD     0             HVNIML                         *1             S0117
     C                   Z-ADD     0             HVNIMN                         *1             S0117
     C                   Z-ADD     0             HVMMFN                         *1
     C**********           Z-ADD0         HVCCPL           *1             S01179
     C                   Z-ADD     0             HVCPLL                         *1             S0117
     C                   Z-ADD     0             HVCPLN                         *1             S0117
     C*
     C                   END                                                    E1
     C*
     C** Calculate the total cash in and out
     C     JULACT        IFEQ      'I'                                          B1
     C     @AMT          IFLT      0                                            B*2
     C                   SUB       @AMT          HVTCIN                         **2
     C**********           ADD  @LIAM     HVNIMT           **2            S01179
     C                   ADD       @LIAM         HVNIML                         **2            S0117
     C                   ELSE                                                   X*2
     C                   ADD       @AMT          HVTCOT                         **2
     C**********           SUB  @DIAM     HVNIMT           **2            S01179
     C                   SUB       @DIAM         HVNIML                         **2            S0117
     C                   END                                                    E*2
     C*
     C                   ELSE                                                   X1
     C*
     C     @AMT          IFLT      0                                            B*2
     C                   ADD       @AMT          HVTCIN                         **2
     C**********           SUB  @LIAM     HVNIMT           **2            S01179
     C                   SUB       @LIAM         HVNIML                         **2            S0117
     C                   ELSE                                                   X*2
     C                   SUB       @AMT          HVTCOT                         **2
     C**********           ADD  @DIAM     HVNIMT           **2            S01179
     C                   ADD       @DIAM         HVNIML                         **2            S0117
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
     C******                                                              AB0352
     C******culate the total funds lent                                   AB0352
     C******     @AMT      IFLT 0                          B1             AB0352
     C******     JULACT    IFEQ 'I'                        B*2            AB0352
     C******               ADD  @AMT      HVTFDL           **2            AB0352
     C******               ELSE                            X*2            AB0352
     C******               SUB  @AMT      HVTFDL           **2            AB0352
     C******               END                             E*2            AB0352
     C******               END                             E1             AB0352
     C*
     C** Calculate the net cashflow movement
     C********** HVTCIN    SUB  HVTCOT    HVNCMT                          S01179
     C     HVTCIN        SUB       HVTCOT        HVNCML                                        S0117
     C*
     C** If no record was found on file, write a new record
     C     *IN60         IFEQ      '1'                                          B1
     C*
     C     @COFF2        IFEQ      'Y'                                          B*2
     C                   WRITE     MMTDUMP0                                     **2
     C                   ELSE                                                   X*2
     C                   WRITE     MMFWDTP0                                     **2
     C                   END                                                    E*2
     C*
     C                   ELSE                                                   X1
     C*
     C** If record already on file, update it with new information
     C                   TIME                    HVTLUP                         *1
     C                   MOVE      'A'           HVCHTP                         *1
     C                   Z-ADD     RUND          HVLCD                          *1
     C                   MOVEL     @USER         HVLUID                         *1
     C*
     C     @COFF2        IFEQ      'Y'                                          B*2
     C                   UPDATE    MMTDUMP0                                     **2
     C                   ELSE                                                   X*2
     C                   UPDATE    MMFWDTP0                                     **2
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
     C*
     C     #BBC9         ENDSR                                                  **#BBC9**
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* #B      - Routine controlling updating sequence               *
     C*                                                               *
     C* CALLS    #BA      - Route through near date update sequence   *
     C* CALLS    #BB      - Route through far date update sequence    *
     C*                                                               *
     C* CALLED BY  MAIN   - Main controlling routine                  *
     C*                                                               *
     C* FLDS USED  @NBCY  - Near date buy / far date sell currency    *
     C*            @NSCY  - Near date sell / far date buy currency    *
     C*            @NDBA  - Near date buy amount                      *
     C*            @NDSA  - Near date sell amount                     *
     C*            @FDSA  - Far date sell amount                      *
     C*            @FDBA  - Far date buy amount                       *
     C*            @LIAM  - Loan interest amount                      *
     C*            @DIAM  - Deposit interest amount                   *
     C*            @CCY   - Deal currency                             *
     C*            @AMT   - Deal amount                               *
     C*                                                               *
     C*****************************************************************
     C     #B            BEGSR
     C*
     C** Determine buy/sell currencies
     C*
     C** If 1st currency near date amount is positive
     C     JUNDA1        IFGT      0                                            B1
     C                   MOVE      JUDFCY        @NBCY                          *1
     C                   MOVE      JUDSCY        @NSCY                          *1
     C                   MOVE      JUNDA1        @NDBA                          *1
     C                   MOVE      JUNDA2        @NDSA                          *1
     C*                                                                   AB0321
     C** Far date cash in & cash out should not include                   AB0321
     C** interest ie. they should be the near date amounts                AB0321
     C**********           MOVE JUFDA1    @FDSA            *1             AB0321
     C**********           MOVE JUFDA2    @FDBA            *1             AB0321
     C                   MOVE      JUNDA1        @FDSA                          *1             AB032
     C                   Z-SUB     @FDSA         @FDSA                          *1             AB032
     C                   MOVE      JUNDA2        @FDBA                          *1             AB032
     C                   Z-SUB     @FDBA         @FDBA                          *1             AB032
     C*                                                                   AB0321
     C                   MOVE      JUINA1        @LIAM                          *1
     C                   MOVE      JUINA2        @DIAM                          *1
     C*                                                                   S01279
     C                   Z-ADD     JUIRT1        @BRAT                          *1             S0127
     C                   Z-ADD     JUIRT2        @SRAT                          *1             S0127
     C*
     C                   ELSE                                                   X1
     C*
     C                   MOVE      JUDFCY        @NSCY                          *1
     C                   MOVE      JUDSCY        @NBCY                          *1
     C                   MOVE      JUNDA1        @NDSA                          *1
     C                   MOVE      JUNDA2        @NDBA                          *1
     C*                                                                   AB0321
     C** Far date cash in & cash out should not include                   AB0321
     C** interest ie. they should be the near date amounts                AB0321
     C                   MOVE      JUNDA1        @FDBA                          *1             AB032
     C                   Z-SUB     @FDBA         @FDBA                          *1             AB032
     C                   MOVE      JUNDA2        @FDSA                          *1             AB032
     C                   Z-SUB     @FDSA         @FDSA                          *1             AB032
     C**********           MOVE JUFDA1    @FDBA            *1             AB0321
     C**********           MOVE JUFDA2    @FDSA            *1             AB0321
     C*                                                                   AB0321
     C                   MOVE      JUINA1        @DIAM                          *1
     C                   MOVE      JUINA2        @LIAM                          *1
     C*                                                                   S01279
     C                   Z-ADD     JUIRT1        @BRAT                          *1             S0127
     C                   Z-ADD     JUIRT2        @SRAT                          *1             S0127
     C*
     C                   END                                                    E1
     C*
     C** If near date is greater than or equal to MIDAS run date
     C     JUNDAT        IFGE      RUND                                         B1
     C*
     C** Process for near date sell currency/amount
     C                   MOVE      @NSCY         @CCY                           *1
     C                   MOVE      @NDSA         @AMT                           *1
     C                   EXSR      #BA                                          *1
     C*
     C** Process for near date buy currency/amount
     C                   MOVE      @NBCY         @CCY                           *1
     C                   MOVE      @NDBA         @AMT                           *1
     C                   EXSR      #BA                                          *1
     C*
     C                   END                                                    E1
     C*
     C** If far date is greater than or equal to MIDAS run date
     C     JUFDAT        IFGE      RUND                                         B1
     C*
     C** Process for far date sell currency/amount
     C                   Z-ADD     @BRAT         @RATE                          *1             S0127
     C                   MOVE      @NBCY         @CCY                           *1
     C                   MOVE      @FDSA         @AMT                           *1
     C                   EXSR      #BB                                          *1
     C*
     C** Process for far date buy currency/amount
     C                   Z-ADD     @SRAT         @RATE                          *1             S0127
     C                   MOVE      @NSCY         @CCY                           *1
     C                   MOVE      @FDBA         @AMT                           *1
     C                   EXSR      #BB                                          *1
     C*
     C                   END                                                    E1
     C*
     C     #B9           ENDSR                                                  **#B9**
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* #A       - Initial processing                                 *
     C*                                                               *
     C* CALLS    ZA0150   - Acces LF/FDICDRll                         *
     C*                                                               *
     C* CALLED BY  MAIN   - Main controlling routine.                 *
     C*                                                               *
     C* FLDS USED  @NOPMS - Number of parameters passed to prgram     *
     C*            @COFF  - Commitment control off ?                  *
     C*            @COFF2 - Commitment control indicator              *
     C*************@LNTH**-*Length*of*command*to*be*sent*to*QCAEXEC****   E20774
     C*            @LNTH  - Length of command to be sent to QCMDEXC   *   E20774
     C*************@CMD***-*Array*of*commands*to*be*sent*to*QCAEXEC****   E20774
     C*            @CMD   - Array of commands to be sent to QCMDEXC   *   E20774
     C*            @TERM  - Termination parameter                     *
     C*            @STDD  - Standard deal details from PF/ABSTDDPP    *
     C*            @DKEY  - Key to file LF/MMFWUDLL                   *
     C*            @CCY   - Deal currency                             *
     C*            @DTYY  - Date used to access forward book files    *
     C*            @DTYY  - Date used to access forward book files    *
     C*            @DTYY  - Date used to access forward book files    *
     C*            @HKEY  - Key to LF/MMFWUHLL                        *
     C*            @DTHM  - Half month indicator for LF/MMFWUHLL key  *
     C*            @UPDT  - DS containing control details for file    *
     C*                      updating                                 *
     C*                                                               *
     C*****************************************************************
     C     #A            BEGSR
     C*
     C** Receive parameters from AB0190, AB8010 or AB8020
     C     *ENTRY        PLIST
     C                   PARM                    @TERM             1
     C                   PARM                    @STDD
     C                   PARM                    @COFF             1
     C*                                                                   AB0149
     C**  If termination parameter is 'T', no further processing.         AB0149
     C     @TERM         CABEQ     'T'           #A9                            *1             AB014
     C*
     C** If commit off parm was sent, store it in a testable field
     C     @NOPMS        IFGT      2                                            B1
     C                   MOVE      @COFF         @COFF2            1            *1
     C                   END                                                    E1
     C*
     C** Open files used in program
     C*********************OPEN FDICDRLL                                  S01194
     C*
     C     @COFF2        IFEQ      'Y'                                          B1
     C*
     C** Override dummy files to real files
     C                   Z-ADD     30            @LNTH            15 5           *1
     C**********           CALL 'QCAEXEC'                   *1            E20774
     C                   CALL      'QCMDEXC'                                     *1            E2077
     C                   PARM                    @CMD(1)                         *1
     C                   PARM                    @LNTH                           *1
     C**********           CALL 'QCAEXEC'                   *1            E20774
     C                   CALL      'QCMDEXC'                                     *1            E2077
     C                   PARM                    @CMD(2)                         *1
     C                   PARM                    @LNTH                           *1
     C**********           CALL 'QCAEXEC'                   *1            E20774
     C                   CALL      'QCMDEXC'                                     *1            E2077
     C                   PARM                    @CMD(3)                         *1
     C                   PARM                    @LNTH                           *1
     C                   OPEN      MMDDUMLL                                      *1
     C                   OPEN      MMHDUMLL                                      *1
     C                   OPEN      MMTDUMLL                                      *1
     C                   ELSE                                                    *1
     C                   OPEN      MMFWUDLL                                      *1
     C                   OPEN      MMFWUHLL                                      *1
     C                   OPEN      MMFWUTLL                                      *1
     C                   END                                                     E1
     C*
     C** Build key for MMFWUDLL file
     C     @DKEY         KLIST
     C                   KFLD                    @CCY
     C                   KFLD                    @DTYY
     C                   KFLD                    @DTMM
     C                   KFLD                    @DTDD
     C                   KFLD                    @LDNA                                         E2020
     C*
     C** Build key for MMFWUHLL file
     C     @HKEY         KLIST
     C                   KFLD                    @CCY
     C                   KFLD                    @DTYY
     C                   KFLD                    @DTMM
     C                   KFLD                    @DTHM
     C                   KFLD                    @LDNA                                         E2020
     C*
     C** Move program name into *LDA field
     C                   MOVEL     'AB0270'      DBPGM
     C*
     C***Call*subroutine*to*access*ICD file for MIDAS run date            S01194
     C*********************EXSR ZA0150                                    S01194
     C*********************                                               S01194
     C***Check*for*data*base error                                        S01194
     C********** *IN80*****IFEQ '1'                        B1             S01194
     C*********************MOVE '1'       *INU7            *1             S01194
     C*********************MOVE '1'       *INU8            *1             S01194
     C*********************GOTO #A9                        *1             S01194
     C*********************END                             E1             S01194
     C**                                                                  S01194
     C**  GET RUNDAT                                                      S01194
     C**                                                                  S01194
     C     *DTAARA       DEFINE                  RUNDAT                                        S0119
     C                   IN        RUNDAT                                                      S0119
     C*
     C** Move RUNA to data structure
     C                   MOVE      RUNA          @UPDT
     C*
     C** Define work fields with same
     C** attributes as similar fields in external files
     C     *LIKE         DEFINE    JUDFCY        @NBCY
     C     *LIKE         DEFINE    JUDFCY        @NSCY
     C     *LIKE         DEFINE    JUNDA1        @NDBA
     C     *LIKE         DEFINE    JUNDA1        @NDSA
     C     *LIKE         DEFINE    JUNDA1        @FDSA
     C     *LIKE         DEFINE    JUNDA1        @FDBA
     C     *LIKE         DEFINE    JUINA1        @LIAM
     C     *LIKE         DEFINE    JUINA1        @DIAM
     C     *LIKE         DEFINE    JUDFCY        @CCY
     C     *LIKE         DEFINE    JUNDA1        @AMT
     C     *LIKE         DEFINE    JUNDYY        @DTYY
     C     *LIKE         DEFINE    JUNDMM        @DTMM
     C     *LIKE         DEFINE    JUNDDD        @DTDD
     C     *LIKE         DEFINE    HTFBHM        @DTHM
     C     *LIKE         DEFINE    JUIRT1        @BRAT                                         S0127
     C     *LIKE         DEFINE    JUIRT1        @SRAT                                         S0127
     C     *LIKE         DEFINE    JUIRT1        @RATE                                         S0127
     C*
     C     #A9           ENDSR                                                  **#A9**
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* #C       - Termination processing                             *
     C*                                                               *
     C* CALLS             -                                           *
     C*                                                               *
     C* CALLED BY  MAIN   - Main controlling routine.                 *
     C*                                                               *
     C* FLDS USED  @TERM  - Termination parameter                     *
     C*                                                               *
     C*****************************************************************
     C     #C            BEGSR
     C*
     C** If termination parameter is 'T' or database error set on LR
     C** before returning control to calling program.
     C     *INU7         IFEQ      '1'                                          B1
     C                   MOVE      'E'           @TERM                          *1
     C                   MOVE      '1'           *INLR                          *1
     C                   END                                                    E1
     C*
     C     @TERM         IFEQ      'T'                                          B1
     C                   MOVE      '1'           *INLR                          *1
     C                   END                                                    E1
     C*
     C                   RETURN
     C*
     C     #C9           ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C********                                                        *   S01194
     C********SUBROUTINE ZA0150 - THIS SUBROUTINE CHAINS TO FILE LF/  *   S01194
     C********FDICDRLL TO GET THE INSTALLATION CONTROL DETAILS RECORD *   S01194
     C********1 (HELD ON PF/TABTB10)                                  *   S01194
     C********INDICATOR 80 IS SET ON IF THE CHAIN FAILS OR THE RECORD *   S01194
     C********IS FLAGGED FOR DELETION.                                *   S01194
     C********IF INDICATOR 80 IS SET ON DETAILS OF THE ATTEMPTED      *   S01194
     C********ACCESS ARE PLACED IN THE LDA.                           *   S01194
     C********                                                        *   S01194
     C********FIELDS USED : SS0150 - KEY USED TO ACCESS FDICDRLL      *   S01194
     C********                                                        *   S01194
     C*****************************************************************   S01194
     C***********ZA0150****BEGSR                                          S01194
     C*********************                                               S01194
     C***Set*up*key*to*obtain*format*TABTB10F*'01        10'              S01194
     C*********************MOVEL'01'      SS0150 12                       S01194
     C*********************MOVE '10'      SS0150                          S01194
     C*********************                                               S01194
     C***Chain*to*file*FDICDRLL                                           S01194
     C***********SS0150****CHAINFDICDRLL             80                   S01194
     C***********RECI******IFNE 'D'                        B1             S01194
     C*********************MOVE '1'       *IN80            *1             S01194
     C*********************END                             E1             S01194
     C*********************                                               S01194
     C***Deal*with*data*base*error                                        S01194
     C********** *IN80*****IFEQ '1'                        ***************S01194
     C*********************MOVEL'FDICDRLL'DBFILE           *             *S01194
     C*********************MOVEL'900'     DBASE            * DBERROR 900 *S01194
     C*********************MOVELSS0150    DBKEY            *             *S01194
     C*********************END                             ***************S01194
     C*********************                                               S01194
     C***********ZA0159****ENDSR                                          S01194
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* *PSSR    - Error routine performed on program error           *
     C*                                                               *
     C* CALLS             -                                           *
     C*                                                               *
     C* CALLED BY         -                                           *
     C*                                                               *
     C* FLDS USED  @ERR1  - Error field 1                             *
     C*            @TERM  - Termination parameter                     *
     C*                                                               *
     C*****************************************************************
     C     *PSSR         BEGSR
     C*
     C** SET @ERR1 TO 'Y' TO PREVENT LOOPING IF FURTHER ERRORS
     C     @ERR1         IFNE      'Y'                                          B1
     C                   MOVE      'Y'           @ERR1             1            *1
     C                   MOVE      '1'           *INU6                          *1
     C*
     C** SET UP FIELDS IN LOCAL DATA AREA
     C                   MOVEL     'AB0270'      DBPGM                          *1
     C                   MOVEL     '991'         DBASE                          *1
     C*
     C                   DUMP                                                   *1
     C                   END                                                    E1
     C*
     C** TERMINATE THE PROGRAM
     C                   MOVE      'E'           @TERM
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* INFSR    - Error routine performed on file error              *
     C*                                                               *
     C* CALLS             -                                           *
     C*                                                               *
     C* CALLED BY         -                                           *
     C*                                                               *
     C* FLDS USED  @ERR2  - Error field 2                             *
     C*            @FILE  - File in which file error occurred         *
     C*            @TERM  - Termination parameter                     *
     C*                                                               *
     C*****************************************************************
     C     INFSR         BEGSR
     C*
     C** SET @ERR1 TO 'Y' TO PREVENT LOOPING IF FURTHER ERRORS
     C     @ERR2         IFNE      'Y'                                          B1
     C                   MOVE      'Y'           @ERR2             1            *1
     C                   MOVE      '1'           *INU7                          *1
     C                   MOVE      '1'           *INU8                          *1
     C*
     C** SET UP FIELDS IN LOCAL DATA AREA
     C                   MOVE      @FILE         DBFILE                         *1
     C                   MOVEL     'AB0270'      DBPGM                          *1
     C                   MOVE      '992'         DBASE                          *1
     C*
     C                   DUMP                                                   *1
     C                   END                                                    E1
     C*
     C** TERMINATE THE PROGRAM
     C                   MOVE      '1'           *INLR
     C                   MOVE      'E'           @TERM
     C                   RETURN
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2001
**CTDATA @CMD
OVRDBF    MMDDUMLL    MMFWUDLL
OVRDBF    MMHDUMLL    MMFWUHLL
OVRDBF    MMTDUMLL    MMFWUTLL
