     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058079
/*STD *  RPGSQLBND                                                    *                     MD058079
/*EXI *  TEXT('Midas SE Euclid Transmission Prompt')
     F*****************************************************************
     F*                                                               *
     F*  Midas - Securities Trading Module
     F*                                                               *
     F*  SE1200 - EUCLID TRANSMISSION PROMPT                          *
     F*                                                               *
     F*  Function: To enable the user to activate transmissions over  *
     F*   (I/C)    the high speed link to EUCLID.  It is possible to: *
     F*            - transmit details of trades                       *
     F*            - receive reporting and settlement details from    *
     F*              Euroclear.                                       *
     F*            The program validates the details input and can    *
     F*            be run in three modes:                             *
     F*            - Transmit only                                    *
     F*            - Transmit and Receive                             *
     F*            - Receive only                                     *
     F*            The mode of processing is determined by the        *
     F*            combination of processing options entered via the  *
     F*            screen.                                            *
     F*                                                               *
     F*  Called by: SEC1201 - Euclid Interface CL Control Pgm         *
     F*                                                               *
     F*  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD058079           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 17May06               *
      *                 CAAA03             Date 06May04               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 S01502             Date 08Jul94               *
      *                 052254             Date 10Jan94               *
     F*                 S01117             DATE  03JUN91              *
     F*                 S01271             DATE  29JUN90              *
     F*                 E21146             DATE 13MAR90               *
     F*                 E19567             DATE 25SEP89               *
     F*                 S01199             DATE 15/09/89              *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD058079 - Deliverable Data Split for sundry files           *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027A- Conversion of cust. no. to alpha (post 103 build)   *
      *  CAAA03 - Webfacing Changes (recompile)                       *
      *  CSE022 - Depository Definition Enhancement                   *
     F*  S01502 - BLI Telekurs Processing.  Recompiled due to change  *
     F*           in length of SESTAT, 133 long.                      *
     F*  052254 - RECOMPILED as CURRENT FACTOR amended from 9,8       *
     F*           to 10,9                                             *
     F*  S01117 - Multibranching                                      *
     F*  S01271 - PAY/RECEIVE IN INPUT CYCLE - RECOMPILED FOR         *   S01271
     F*           DATABASE CHANGE TO SEEUR/SEEUZ                      *   S01271
     F*  E21146 - Replace QCAEXEC with QCMDEXC.                       *   E21146
     F*  E19567 - Program should not allow transmission of Trade data *   E19567
     F*           and change of Password at the same time.            *   E19567
     F*         - CMD/12 processing has been changed to use indicator *   E19567
     F*           02 instead of KB.                                   *   E19467
     F*  S01199 -  Help System + fix to AS/400 Cmd Key conversion. *   S01199
     F*                                                               *
     F*  THIS PROGRAM WAS COMPLETELY REWRITTEN BY S01190 - 17MAR89    *   S01190
     F*  S01190 - EUCLID FIX/ENHANCEMENT                              *   S01190
     F*                                                               *
     F*****************************************************************
     F*                                                               *
     F*  C R E A T I O N     P A R A M E T E R S                      *
     F*                                                               *
     F*                                                               *
     F*****************************************************************
      *
     FSE1200DF  CF   E             WORKSTN
     F                                     SFILE(SE1200S2:RRN)
     F                                     SFILE(SE1200S9:RRN)
     F                                     SFILE(SE120S10:RRN)
     F                                     SFILE(SE120S11:RRN)
     F                                     SFILE(SE120S12:RRN)
     FSEEUR     UF   E           K DISK
     FSNAME     IF   E           K DISK
     F*EUCRCV*** IF   E           K DISK                                                    MD058079
     FCLINT     IF   E           K DISK
     F                                     IGNORE(CLINTCAF)
     F                                     IGNORE(CLINTCCF)
     F                                     IGNORE(CLINTC1F)
     F                                     IGNORE(CLINTCBF)
     FTABSE     IF   E           K DISK
     F                                     IGNORE(TABLETAF)
     F* ICD 1     TABTB10F                          KIGNORE
     F                                     IGNORE(TABTB11F)
     F                                     IGNORE(TABTB36F)
     F                                     IGNORE(TABTB40F)
     F                                     IGNORE(TABTE10F)
     F                                     IGNORE(TABTE20F)
     F*           TABTG10F                          KIGNORE
     F                                     IGNORE(TABTG20F)
     F                                     IGNORE(TABLETHF)
     F*********** TABLETJF                          KIGNORE               S01117
     F                                     IGNORE(TABLETLF)
     F                                     IGNORE(TABLETRF)
     F                                     IGNORE(TABLETXF)
     F                                     IGNORE(TABLETKF)
     F                                     IGNORE(TABLETNF)
     F                                     IGNORE(TABLETPF)
     F                                     IGNORE(TABLET3F)
     F                                     IGNORE(TABLET2F)
     F                                     IGNORE(TABLET5F)
     FECTRF     O  A F   80        DISK    USROPN
     FSEEUZ     O  A E           K DISK
     F                                     RENAME(SEEUCHF:SEEUZHF)
     F                                     RENAME(SEEUCD0F:SEEUZD0F)
     F                                     RENAME(SEEUCD1F:SEEUZD1F)
     F                                     RENAME(SEEUCD2F:SEEUZD2F)
     F                                     RENAME(SEEUCD3F:SEEUZD3F)
     F                                     RENAME(SEEUCD4F:SEEUZD4F)
     F                                     RENAME(SEEUCD5F:SEEUZD5F)
     F                                     RENAME(SEEUCAF:SEEUZAF)
      /EJECT
     F*****************************************************************
     F*                                                               *
     F*  F U N C T I O N   O F   I N D I C A T O R S                  *
     F*                                                               *
     F*   03  - READ OF SEEUR FILE - FORMAT SEEUCHF                   *
     F*   04  -                    - FORMAT SEEUCD0F                  *
     F*   05  -                    - FORMAT SEEUCD1F                  *
     F*   06  -                    - FORMAT SEEUCD2F                  *
     F*   07  -                    - FORMAT SEEUCD9F                  *
     F*   08  - READ OF TABLE FILE - FORMAT TABTB10F                  *
     F*   09  -                    - FORMAT SEEUCD3F                  *
     F*   10  -                    - FORMAT SEEUCD4F                  *
     F*   11  -                    - FORMAT SEEUCD5F                  *
     F*                                                               *
     F*   12  - INITIAL CARDS HAVE BEEN WRITTEN TO PF/ECTRF           *
     F*   16  - STATUS PROMPT SCREEN DISPLAY INDICATOR                *
     F*   17  - STATUS PROMPT SCREEN DISPLAY INDICATOR                *
     F*   18  - STATUS PROMPT SCREEN DISPLAY INDICATOR                *
     F*   19  - ERROR ON REPORT TYPE IN SECUR,NUM                     *
     F*   20  - ROLLUP ERROR MESSAGE                                  *
     F*   21  - NUMERIC TEST IN CPART,NUM  & DATE                     *
     F****22  - HELP KEY                                              *   S01199
     F*   23  - CMD/12 HAS BEEN TAKEN ON A PROMPT SCREEN              *
     F*   24  - TRANSMIT OPTION SELECTED                              *
     F*   25  - RECEIVE OPTION SELECTED                               *
     F*   26  - BACKLOG FILE REQUESTED                                *
     F*   27  - INSTRUCTION TYPE IS 'I'                               *
     F*   28  - 500 INSTRUCTION MARK HAS BEEN REACHED                 *
     F*   29  - DATA CARD HAS BEEN WRITTEN                            *
     F*   30  - INSTRUCTION READ FOR SELECTED ACCOUNT                 *
     F*   32  - CANCEL INSTRUCTIONS EXTRACTED                         *
     F*   33  - 200 CANCELLATION MARK HAS BEEN REACHED                *
     F*   36  - USED IN ALPCHK                                        *
     F*   37  - ERROR INDICATOR IN SUBFILE PROMPT SCREENS             *
     F*   38  - POSITION SCREEN AT FIRST ERROR                        *
     F*   39  - SFLNXTCHG INDICATOR                                   *
     F*   40  - WORK INDICATOR                                        *
     F*   41  - ERROR ON SECURITY OR COUNTERPARTY NAME OR NO.         *
     F*   42  - ERROR ON SECURITY REPORT TYPE                         *
     F*   43  - SUBFILE CONTROL                                       *
     F*   44  - SCHEDULE PROMPT SCREEN DISPLAY INDICATOR              *
     F*   45  - CLIENT NUMBER/SHORTNAME VALIDATION                    *
     F*   46  - SCHEDULE PROMPT SCREEN DISPLAY INDICATOR              *
     F*   47  - PROTECT INDICATOR                                     *
     F*   48  - SCHEDULE PROMPT SCREEN DISPLAY INDICATOR              *
     F*   50  - PASSWORD VALIDATION WORK INDICATOR                    *
     F*   51  - PASSWORD VALIDATION WORK INDICATOR                    *
     F*   52  - ERROR FOUND IN PASSWORD VALIDATION                    *
     F*   53  - DISPLAY REPORT OPTION IN SCREEN HEADER                *
     F*   54  - DISPLAY 'CMD/12' ON SCREEN FOOTER                     *
     F*   55  - DISPLAY 'ROLLUP/DOWN' ON SCREEN FOOTER                *
     F*   56  - SFLEND INDICATOR ON PROMPT SCREENS                    *
     F*   57  - SFLEND INDICATOR ON SECOND SCREEN                     *
     F*   58  - AT LEAST ONE REPORT OPTION HAS BEEN SELECTED          *
     F*   59  - ERROR INPUT FIELD - EUROCLEAR ACCOUNT                 *
     F*                           - SCOPE OF REPORT                   *
     F*                           - MAT1                              *
     F*                           - ALL STATUSES                      *
     F*                           - REPORT FOR TODAY                  *
     F*                           - ALL POSITIONS                     *
     F*                           - CURRENT NETWORK PASSWORD          *
     F*                           - DATE                              *
     F*                           - E/C REFERENCE 1                   *
     F*                           - USER REFERENCE 1                  *
     F*   60  - ERROR INPUT FIELD - USER NUMBER                       *
     F*                           - LAYOUT OF REPORT                  *
     F*                           - MAT2                              *
     F*                           - REPORT FOR YESTERDAY              *
     F*                           - CHANGED POSITIONS                 *
     F*                           - NEW NETWORK PASSWORD              *
     F*                           - E/C UPPER RANGE REF. NO.          *
     F*                           - USER REFERENCE 2                  *
     F*   61  - ERROR INPUT FIELD - PASSWORD                          *
     F*                           - MAT3                              *
     F*                           - REPORT FOR DAY BEFORE YEST        *
     F*                           - SPECIFIC CURRENCY                 *
     F*                           - NEW NETWORK PASSWORD AGAIN        *
     F*                           - USER REFERENCE 3                  *
     F*   62  - ERROR INPUT FIELD - USER PASSWORD                     *
     F*                           - MAT4                              *
     F*                           - REPORT FOR ALL DAYS               *
     F*                           - SPECIFIC POSITION                 *
     F*                           - CURRENT EUCLID PASSWORD           *
     F*                           - USER REFERENCE 4                  *
     F*   63  - ERROR INPUT FIELD - TANSMIT DETAILS AVAILABLE?        *
     F*                           - SET1                              *
     F*                           - ALPHABETIC ORDER                  *
     F*                           - NEW EUCLID PASSWORD               *
     F*                           - USER REFERENCE 5                  *
     F*   64  - ERROR INPUT FIELD - TRANSMISSION OPTION               *
     F*                           - LATEST REPORT                     *
     F*                           - SECURITY CODE SEQUENCE            *
     F*                           - NEW EUCLID PASSWORD AGAIN         *
     F*   65  - ERROR INPUT FIELD - RECEIVE OPTIONS                   *
     F*   66  - VALIDATION COMPLETE                                   *
     F*   67  - SCOPE OF REPORT PROMPT SCREEN DISPLAY IND.            *
     F*   68  - LAYOUT OF REPORT PROMPT SCREEN DISPLAY IND.           *
     F*   69  - ERROR CODES FOR DISPLAY                               *
     F*   71  - ERROR INPUT FIELD - RECEIVE OPTION 1                  *
     F*                           - SEC. NO. ORDER WITHIN CURRENCY    *
     F*   72  - ERROR INPUT FIELD - RECEIVE OPTION 2                  *
     F*         R30 PROMPT SCREEN DISPLAY INDICATOR                   *
     F*   73  - ERROR INPUT FIELD - RECEIVE OPTION 3                  *
     F*                           - SPECIFIC CURRENCY/POSITION        *
     F*   74  - ERROR INPUT FIELD - RECEIVE OPTION 4                  *
     F*   75  - ERROR INPUT FIELD - RECEIVE OPTION 5                  *
     F*   76  - ERROR INPUT FIELD - RECEIVE OPTION 6                  *
     F*   77  - ERROR INPUT FIELD - RECEIVE OPTION 7                  *
     F*   78  - ROLLUP                                                *
     F*   80  - ERROR INDICATOR                                       *
     F*   81  - EXCPT OUTPUT - S/ECTRF                                *
     F*   82  - EXCPT OUTPUT - S/SEEUZ (DETAIL)                       *
     F*   83  - EXCPT OUTPUT - S/SEEUZ (TRAILER)                      *
     F*   85  - INPUT IS VALID AND COMPLETE                           *
     F*   86  - EOF ON TABTG10                                        *
     F*   88  - EOF ON SEEUR                                          *
     F*   89  - SECOND SCREEN PROCESSING COMPLETE                     *
     F*                                                               *
     F* 90-99 - Used in Standard Subroutines.                         *
     F*                                                               *
     F*   KE  - CMD/5 SELECTED                                        *
     F*   01  - CMD/3 SELECTED                                        *
     F****KB**-*CMD/12*SELECTED****************************************   S01199
     F*   KL  - CMD/12 SELECTED                                       *   S01199
     F*                                                               *
     F*   U1  - S/SEEUR HAS BEEN SELECTED FOR TRANSMISSION            *
     F*   U2  - RECEIVE OPTION(S) SELECTED                            *
     F*   U3  - BACKLOG FILE RECEPTION REQUESTED                      *
     F* U7+U8 - DATABASE ERROR                                        *
     F*                                                               *
     F*****************************************************************
      /EJECT
     D* ARRAY TO LOAD CURRENCIES FROM TABTG10
     D CCY             S              3    DIM(350)
     D*  DATA STRUCTURE FOR COMPILATION  - COPYRIGHT INSERTION
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
     D HEAD            S             48    DIM(7) CTDATA PERRCD(1)              RECEIVE OPTION
     D MSG             S             64    DIM(2) CTDATA PERRCD(1)              SCREEN MESSAGE
     D SIMP            S             10    DIM(18) CTDATA PERRCD(1)             SIMPLE OPTIONS
     D******************* CMD    80  80  1               QCAEXEC STRING   E21146
     D CMD             S              1    DIM(80) CTDATA PERRCD(80)            QCMDEXC STRING   E21
     D CARD            S             80    DIM(10) CTDATA PERRCD(1)             CARD SKELETONS
     D ALP             S              1    DIM(26) CTDATA PERRCD(26)            ALPHABETIC CHARS.
     D NUM             S              1    DIM(10) CTDATA PERRCD(10)            NUMBERS
     D WRK12           S              1    DIM(12)                              WORK ARRAY
     D ARR             S              1    DIM(8)                               8 LONG WORK
     D PASS            S              1    DIM(8)                               8 LONG WORK
     D CNM             S              1    DIM(33)                              CPART,NAME WORK
     D CRD             S              1    DIM(80)                              OUTPUT WORK
     D ERCD            S              4    DIM(38)                              ERROR CODES
     D NUM5            S              1    DIM(5)                               NUMERICS FIELD
     D*                                     DATA STRUCTURES
     D*
     D                 DS
     D*
     D**  DATA STRUCTURE FOR S/SEEUR,H
     D*
     D  EULNHH                 1      5  0
     D  EUBC                   7      8  0
     D  EUBN                  10     11  0
     D  EUNO                  13     15  0
     D  LOTHH                  1     80
     D*
     D**  DATA STRUCTURE FOR S/SEEUR,D0
     D*
     D                 DS
     D  EULNL0                 1      5  0
     D  EUIT                   7      8  0
     D  EURF                  10     14  0
     D  EUPC                  16     16
     D  ECCPL0                18     18
     D  EUCPL0                19     23
     D  EUCL                  25     25
     D  ENAM                  27     39  0
     D  EUSC                  41     52
     D  LOTLC                  1     52
     D  EUCA                  54     66  0
     D  EDP1                  67     67
     D  EUCD                  68     69  0
     D  LOTL0                  1     80
     D*
     D**  DATA STRUCTURE FOR S/SEEUR,D1
     D*
     D                 DS
     D  EULNL1                 1      5  0
     D  EUVY                   7      9
     D  EUSD                  11     16
     D  EUPR                  18     18
     D  EUCO                  20     24
     D  ECCPL1                26     26
     D  EUCPL1                27     31
     D  EUHA                  33     46  0
     D  EDP2                  47     47
     D  EUHD                  48     49  0
     D  ELAG                  51     52
     D  EUPA                  54     54
     D  ELRE                  56     57
     D  EREM                  59     59
     D  LOTL1                  1     80
     D*
     D**  DATA STRUCTURE FOR S/SEEUR,D2
     D*
     D                 DS
     D  EULNL2                 1      5  0
     D  EUL1                   7      8
     D  ETPS                  10     10
     D  ETDP                  11     19  0
     D  ETPN                  20     20
     D  ETPD                  21     26  0
     D  BKTR                  11     26
     D  ETDT                  28     33  0
     D  ESPI                  35     35
     D  ELTR                  51     52
     D  ETRF                  54     62
     D  ELMT                  64     65
     D  EMKT                  67     67
     D  LOTL2                  1     80
     D*
     D**  DATA STRUCTURE FOR S/SEEUR,D3
     D*
     D                 DS
     D  EULNL3                 1      5  0
     D  ELPA                   7      8
     D  EPRA                  10     22
     D  EDP3                  23     23
     D  EPRD                  24     25
     D  EPRC                  27     29
     D  EPRX                  31     35
     D  EDP4                  36     36
     D  EPXD                  37     42
     D  ELAI                  44     45
     D  EAIS                  47     47
     D  EAIA                  48     60
     D  EDP5                  61     61
     D  EAID                  62     63
     D  EAIC                  65     67
     D  LOTL3                  1     80
     D*
     D**  DATA STRUCTURE FOR S/SEEUR,D4
     D*
     D                 DS
     D  EULNL4                 1      5  0
     D  EAIX                   7     11
     D  EDP6                  12     12
     D  EAXD                  13     18
     D  ELRA                  20     21
     D  EDAC                  23     26
     D  EARA                  28     30
     D  EDP7                  31     31
     D  EARD                  32     37
     D  ECLB                  39     42
     D  ELFC                  44     45
     D  EFCA                  47     59
     D  EDP8                  60     60
     D  EFCD                  61     62
     D  EFCC                  64     66
     D  EFCX                  68     72
     D  EDP9                  73     73
     D  EFXD                  74     79
     D  LOTL4                  1     80
     D*
     D**  DATA STRUCTURE FOR S/SEEUR,D5
     D*
     D                 DS
     D  EULNL5                 1      5  0
     D  ELNA                   7      8
     D  EUNR                  10     42
     D  LOTL5                  1     80
     D*
     D**  DATA STRUCTURE FOR CONVERSION TO NUMERIC INPUT
     D*
     D                 DS
     D  SCNUM                  1     10
     D**********                              1   60KCNUM                                    CSD027A
     D  KCNUM                  1      6                                                            C
     D  SCNUME                 7     10
     D*
     D**  DATA STRUCTURE FOR CONVERSION TO NUMERIC OUTPUT
     D*
     D                 DS
     D**********                              1   6 C101                  CSE022
     D  C201                   1     20                                         CSE022
     D  SEURO                  1      5  0
     D*
     D**  DATA STRUCTURE FOR REPORT TYPE
     D*
     D                 DS
     D  EROC                   1     10
     D  #RPT                   1      8
     D*
     D**  DATA STRUCTURE FOR CPART,NUM
     D*
     D                 DS
     D  SCPNUM                 1      6
     D  CIND                   1      1
     D  BLKCHK                 6      6
     D  ECNUM                  1      5  0
     D  ECNUMA                 1      5
     D  CDNUMA                 2      6
     D  CDNUM                  2      6  0
     D*
     D**  DATA STRUCTURE FOR RUN DATE
     D*
     D                 DS
     D  RUNA                   1      7
     D  MTH                    3      5
     D*
     D**  SECURITIES TRADING DATA AREA
     D*
     D SESTAT        EUDS
     D  EEUCO        E                     EXTFLD(EUCO)
     D*
     D**  PROGRAM STATUS DATA STRUCTURE
     D*
     D PSDS           SDS
     D  WSID                 244    246
     D*
     D**  LOCAL DATA AREA
     D*
     D LDA             DS           256                                         S01117
     D  DBLOT                134    183                                         S01117
     D  DBFILE               134    141                                         S01117
     D  DBKEY                142    170                                         S01117
     D  DBPGM                171    180                                         S01117
     D  DBASE                181    183  0                                      S01117
     D*LDA******* UDS                            256                      S01117
     D***********                           134 177 DBLOT                 S01117
     D***********                           134 138 DBFILE                S01117
     D***********                           139 167 DBKEY                 S01117
     D***********                           168 175 DBPGM                 S01117
     D***********                           176 1770DBASE                 S01117
     D EUCRCV        E DS                  EXTNAME(SEEURJW0)                                MD058079
     D  XEROC        E                     EXTFLD(EROC)                                     MD058079
     I*COPY*ZSRSRC,ZDATE1Z1                                                                 MD058079
     I/COPY ZSRSRC,ZDATE2Z1LE                                                               MD058079
      /EJECT
     ISEEUCHF       03
     I*
     I*    S/SEEUC FILE
     I*
     I              EULN                        EULNHH
     ISEEUCD0F      04
     I              EULN                        EULNL0
     I              ECCP                        ECCPL0
     I              EUCP                        EUCPL0
     ISEEUCD1F      05
     I              EULN                        EULNL1
     I              ECCP                        ECCPL1
     I              EUCP                        EUCPL1
     ISEEUCD2F      06
     I              EULN                        EULNL2
     ISEEUCD3F      09
     I              EULN                        EULNL3
     ISEEUCD4F      10
     I              EULN                        EULNL4
     ISEEUCD5F      11
     I              EULN                        EULNL5
     ISEEUCAF       07
     I              EULN                        EULNL9
     ITABTB10F      08
     C/EJECT
     C*================================================================
     C*  P R O G R A M     S T A R T
     C*================================================================
     C*
     C**  KEY TO SETLL ON S/SEEUR
     C*
     C     SECKEY        KLIST
     C                   KFLD                    EURO00
     C                   KFLD                    KACTC
     C*
     C*  M A I N   P R O C E S S I N G
     C*
     C**  DO THE INITIAL PROCESSING AND PROMPT FOR INFORMATION FROM THE
     C**  USER
     C*
     C                   EXSR      FIRST
     C*
     C**  PROCESS SCREENS UNTIL SELECTION IS COMPLETE OR CMD/3 TAKEN
     C*
     C                   EXSR      SCREEN
     C*
     C**  IF NOT CMD/3 AND TRANSMIT IS SELECTED, WRITE INSTRUCTION
     C**  DETAILS
     C*
     C     *IN01         IFEQ      '0'
     C     *IN24         ANDEQ     '1'
     C*
     C**  IF CANCELLATIONS EXIST ON INSTRUCTION FILE WRITE 'C,KEY' TO
     C**  COMMAND FILE IN PF/ECTRF
     C*
     C     ACTC          IFEQ      'C'
     C                   MOVE      *BLANKS       CRD
     C                   MOVEA     'C,KEY'       CRD(1)
     C                   EXSR      OUTPUT
     C                   END
     C*
     C**  CARD 8 - TRANSMISSION OPTION
     C*
     C                   MOVEA     *BLANKS       CRD
     C                   MOVEA     STROP         CRD(1)
     C                   EXSR      OUTPUT
     C*
     C**  CARD 19 - END OF DATA
     C*
     C                   MOVEA     CARD(6)       CRD(1)
     C                   EXSR      OUTPUT
     C*
     C**  SET LOWER LIMITS ON S/SEEUR.
     C*
     C                   MOVE      SEURO         EURO00            5 0
     C     EURO00        SETLL     SEEUR
     C*
     C     MAIN02        TAG                                                    *** MAIN02 ***
     C*
     C**  READ RECORD FROM S/SEEUR.
     C**  ONLY PROCESS THOSE S/SEEUR RECORDS FOR THIS
     C**  EUROCLEAR ACCOUNT
     C*
     C                   MOVEA     '00000'       *IN(03)
     C                   MOVEA     '000'         *IN(09)
     C                   SETOFF                                           L1
     C                   READ      SEEUR                                  88
     C  N88EURO00        COMP      EURO                                   30
     C  N88
     CANN30              SETON                                        88
     C*
     C*
     C**  READ AND UPDATE THE S/SEEUR TRAILER AT END
     C*
     C     *IN88         IFEQ      '1'
     C     99999         CHAIN     SEEUCAF                            88
     C   07              SUB       COUNT         EUNU
     C   07              EXCEPT    ECTLXT
     C*
     C**  OUTPUT THE S/SEEUZ TRAILER.
     C*
     C   07              Z-ADD     COUNT         EUNU
     C   07              SETON                                        83
     C   07              EXCEPT
     C   07              SETOFF                                       83
     C                   SETON                                        LR
     C                   GOTO      MAIN03
     C                   END
     C*
     C**  KEEP COUNT OF NUMBER OF INSTRUCTIONS IN TRANSMISSION
     C*
     C   03BATTOT        ADD       EUNO          BATTOT
     C*
     C**  IF THIS LATEST BATCH TAKES TOTAL ABOVE 500, DISPLAY MESSAGE
     C**  & END
     C*
     C   03BATTOT        COMP      500                                28
     C     *IN03         IFEQ      '1'
     C     *IN28         ANDEQ     '1'
     C                   MOVE      'Y'           EUEX
     C                   WRITE     FOOTER
     C                   MOVE      *BLANKS       ERRMG1
     C                   MOVEA     MSG(1)        ERRMG1
     C                   SETON                                        69
     C                   EXFMT     SE1200F1
     C                   SETON                                        88LR
     C                   GOTO      MAIN03
     C                   END
     C*
     C**  IF THIS LATEST BATCH TAKES TOTAL ABOVE 200, DISPLAY MESSAGE
     C**  IF ENTER IS PRESSED CONTINUE TO OUTPUT INSERT INSTRUCTIONS
     C**  TO TRANSMISSION FILE
     C*
     C     *IN03         IFEQ      '1'
     C     ACTC          ANDEQ     'C'
     C     BATTOT        COMP      200                                33
     C     *IN33         IFEQ      '1'
     C                   MOVE      'Y'           EUEX
     C                   WRITE     FOOTER
     C                   MOVE      *BLANKS       ERRMG1
     C                   MOVEA     MSG(2)        ERRMG1
     C                   SETON                                        69
     C                   EXFMT     SE1200F1
     C     *IN01         IFEQ      '1'
     C                   SETON                                        88LR
     C                   GOTO      MAIN03
     C                   ELSE
     C                   SETOFF                                       33
     C     BATTOT        SUB       EUNO          BATTOT
     C                   MOVE      'I'           KACTC             1
     C     SECKEY        SETLL     SEEUR
     C                   GOTO      MAIN02
     C                   END
     C                   END
     C                   END
     C*
     C**  ON CHANGE OF ACTION TYPE
     C*
     C   03ACTC          COMP      SVACTC                             L1L1
     C   03              MOVE      ACTC          SVACTC
     C*
     C**  OUTPUT END OF DATA CARD (IF REQ'D)
     C*
     C   03
     CAN L1
     CAN 29              MOVEA     CARD(6)       LOTTLX
     C   03
     CAN L1
     CAN 29              SETON                                        81
     C   03
     CAN L1
     CAN 29              EXCEPT
     C   03
     CAN L1
     CAN 29              SETOFF                                       2981
     C*
     C**  OUTPUT NEW DATA CARD 4
     C*
     C   03
     CAN L1ACTC          COMP      'I'                                    27
     C   03
     CAN L1
     CANN32ACTC          COMP      'C'                                    32
     C   03
     CAN L1
     CAN 27              MOVEA     CARD(5)       CRD
     C   03
     CAN L1
     CANN27              MOVEA     CARD(9)       CRD
     C   03
     CAN L1              MOVE      SUSNO         SWRK              3
     C   03
     CAN L1              MOVEA     SWRK          CRD(8)
     C   03
     CAN L1              MOVEA     CRD           LOTTLX
     C   03
     CAN L1              SETON                                        8129
     C   03
     CAN L1              EXCEPT
     C   03
     CAN L1              SETOFF                                       81
     C*
     C**  MOVE DETAIL RECORD READ FROM S/SEEUR INTO OUTPUT FIELD
     C*
     C   03
     CAN 30              MOVE      LOTHH         LOTTLX
     C     ACTC          IFEQ      'C'
     C     EUCA          OREQ      *ZEROS
     C   04
     CAN 30              MOVE      *BLANKS       LOTTLX
     C   04
     CAN 30              MOVEL     LOTLC         LOTTLX
     C                   ELSE
     C   04
     CAN 30              MOVE      LOTL0         LOTTLX
     C                   END
     C   05
     CAN 30              MOVE      LOTL1         LOTTLX
     C     ETDP          IFEQ      *ZEROS
     C                   MOVE      *BLANKS       BKTR
     C                   END
     C   06
     CAN 30              MOVE      LOTL2         LOTTLX
     C   09
     CAN 30              MOVE      LOTL3         LOTTLX
     C   10
     CAN 30              MOVE      LOTL4         LOTTLX
     C   11
     CAN 30              MOVE      LOTL5         LOTTLX
     C*
     C**  OUTPUT FIELD TO S/ECTRF & RECORD TO S/SEEUZ
     C*
     C   03              Z-ADD     EULNHH        EULN
     C   04              Z-ADD     EULNL0        EULN
     C   04              MOVE      EUCPL0        EUCP
     C   05              Z-ADD     EULNL1        EULN
     C   05              MOVE      EUCPL1        EUCP
     C   06              Z-ADD     EULNL2        EULN
     C   09              Z-ADD     EULNL3        EULN
     C   10              Z-ADD     EULNL4        EULN
     C   11              Z-ADD     EULNL5        EULN
     C   07              Z-ADD     EULNL9        EULN
     C  N07
     CAN 30              SETON                                        8182
     C  N07
     CAN 30              EXCEPT
     C  N07
     CAN 30              SETOFF                                       8182
     C*
     C**  DELETE S/SEEUR RECORD
     C*
     C  N07
     CAN 30              EXCEPT    ECTDEL
     C*
     C**  KEEP A COUNT OF THE NO. OF RECORDS DELETED
     C*
     C  N07
     CAN 30              ADD       1             COUNT             5 0
     C*
     C  NLR              GOTO      MAIN02
     C*
     C     MAIN03        TAG                                                    *** MAIN03 ***
     C                   END
     C*
     C**  DO LAST RECORD PROCESSING
     C*
     C                   EXSR      LAST
     C*
     C*================================================================
     C*  P R O G R A M     E N D
     C*================================================================
     C*
     C                   SETON                                        LR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  FIRST SR. - TO DO THE INITIAL PROCESSING AND CALL THE SCREEN
     C*              SUBROUTINE
     C*  CALLED FROM: MAIN
     C*  CALLS:       ZSYSTM
     C*
     C********************************************************************
     C*
     C     FIRST         BEGSR                                                  ***  FIRST  ***
     C*
     C*
     C     *DTAARA       DEFINE                  LDA                                           S0111
     C     *LOCK         IN        LDA                                                         S0111
     C                   MOVEL     *BLANK        DBLOT                                         S0111
     C                   MOVE      'SE1200  '    DBPGM
     C                   OUT       LDA                                                         S0111
     C                   MOVE      ' '           BLK003            3
     C                   MOVE      ' '           BLK005            5
     C                   MOVE      ' '           EUEX
     C                   MOVE      ' '           SVACTC            1
     C                   Z-ADD     0             BATTOT            5 0
     C*
     C**  GET I.C.D.R. 1, DATABASE ERROR IF NOT FOUND
     C*
     C                   EXSR      ZSYSTM
     C   99              SETON                                        U7U8LR
     C  NU8              GOTO      FIRT01
     C     *LOCK         IN        LDA                                                         S0111
     C                   MOVE      'TABLE'       DBFILE                         ***************
     C                   MOVE      ZTABKY        DBKEY                          * DB ERROR 01 *
     C                   Z-ADD     01            DBASE                          ***************
     C                   OUT       LDA                                                         S0111
     C                   EXSR      *PSSR                                                       S0111
     C                   GOTO      FIRT02
     C     FIRT01        TAG                                                    *** FIRT01 ***
     C*
     C**  SET UP DATE CHECKING FIELDS
     C*
     C     RUND          SUB       15            RUND15            5 0
     C*
     C**  FILL ARRAY OF SWIFT CURRENCY CODES
     C*
     C                   Z-ADD     0             CC
     C     *IN86         DOUEQ     '1'
     C                   READ      TABTG10F                               86
     C     *IN86         IFEQ      '0'
     C                   ADD       1             CC                3 0
     C                   MOVE      CCYS          CCY(CC)
     C                   END
     C                   END
     C*
     C*
     C     FIRT02        ENDSR                                                  *** FIRT02 ***
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  LAST SR.  - TO DO THE LAST RECORD PROCESSING
     C*
     C*  CALLED FROM: MAIN PROCESSING
     C*  CALLS:       LSTCDS
     C*
     C********************************************************************
     C*
     C     LAST          BEGSR                                                  ***  LAST  ***
     C*
     C**  SET OFF THE EXTERNAL SWITCHES
     C*
     C                   SETOFF                                       U1U2U3
     C*
     C**  IF CMD/3 TAKEN, NO FURTHER PROCESSING
     C*
     C   01              GOTO      LSTT01
     C*
     C**  WRITE THE TRAILING CARDS TO S/ECTRF IF CMD/3 NOT TAKEN
     C*
     C                   EXSR      LSTCDS
     C*
     C**  U1 ON IF S/SEEUR HAS BEEN SELECTED FOR TRANSMISSION
     C*
     C   24              SETON                                        U1
     C*
     C**  U2 ON IF RECEIVE OPTIONS SELECTED
     C*
     C   25              SETON                                        U2
     C*
     C**  U3 ON IF BACKLOG FILE REQUESTED
     C*
     C   26              SETON                                        U3
     C*
     C     LSTT01        ENDSR                                                   *** LSTT01 ***
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  SCREEN  SR. - TO PROCESS SCREENS
     C*
     C*  CALLED FROM:  FIRST
     C*  CALLS:  SETSCR, SCWRIT, SCREAD, SCRVAL
     C*
     C********************************************************************
     C*
     C     SCREEN        BEGSR                                                  *** SCREEN ***
     C*
     C     *IN89         DOWEQ     '0'
     C     *IN01         ANDEQ     '0'
     C*
     C**  SET THE INDICATORS FOR THE SCREEN
     C*
     C     *IN69         IFEQ      '0'
     C     *IN66         ANDEQ     '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C     *INKE         OREQ      '1'
     C                   EXSR      SETSCR
     C                   END
     C*
     C**  WRITE THE SCREEN EITHER WITH HIGHLIGHTED ERRORS OR BLANKS
     C*
     C*
     C                   WRITE     HEADER
     C                   WRITE     FOOTER
     C                   MOVEA     ERCD(1)       ERRMG1
     C*
     C                   EXFMT     SE1200F1
     C*
     C**  PROCESS COMMAND KEYS
     C*
     C****HELP*KEY*
     C************IN22     IFEQ '1'                                       S01199
     C***********          MOVEAERCD      HERCD 160                       S01199
     C***********          MOVEL'SE1200'  HBPGM   6                       S01199
     C***********          CALL 'MHELP'                                   S01199
     C***********          PARM           HBPGM                           S01199
     C***********          PARM           HERCD                           S01199
     C***********          ELSE                                           S01199
     C*
     C**  CMD/5
     C*
     C     *INKE         IFEQ      '1'
     C                   CLOSE     ECTRF
     C                   Z-ADD     18            CMDLEN           15 5
     C******************** CALL 'QCAEXEC'                                 E21146
     C                   CALL      'QCMDEXC'                                                   E2114
     C                   PARM                    CMD
     C                   PARM                    CMDLEN
     C*
     C**  RESET BACKLOG REQUEST INDICATOR
     C*
     C                   SETOFF                                       265866
     C                   SETOFF                                       12
     C                   ELSE
     C*
     C**  IF ENTER VALIDATE THE SCREEN
     C*
     C     *IN66         IFEQ      '0'
     C     *IN01         ANDEQ     '0'
     C*
     C                   EXSR      SCRVAL
     C*
     C**  LOAD SECOND SCREEN IF RECEIVE OPTIONS HAVE BEEN SELECTED
     C**  AND FIRST SCREEN IS VALID
     C*
     C     *IN69         IFEQ      '0'
     C*
     C**  WRITE INITIAL CARDS TO TRANSMISSION FILE
     C*
     C     *IN12         IFEQ      '0'
     C                   EXSR      ISTCDS
     C                   END
     C*
     C     *IN25         IFEQ      '1'
     C                   SETON                                        12
     C                   EXSR      SCRTWO
     C*
     C**  IF NOT SELECTION MADE AND TRANSMIT OPTION NOT SELECTED IT
     C**  IS AN ERROR
     C*
     C     *IN58         IFEQ      '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C     *IN24         ANDEQ     '0'
     C                   SETOFF                                       25
     C                   MOVE      ' 411'        ECODE
     C                   EXSR      ERROR
     C                   END
     C                   END
     C                   END
     C*
     C                   ELSE
     C     *IN66         IFEQ      '1'
     C     *IN01         ANDEQ     '0'
     C                   SETON                                        89
     C                   END
     C                   END
     C                   END
     C***********          END                                            S01199
     C*
     C**  DISPLAY 'SELECTION COMPLETE' ON SCREEN IF ALL IS VALID
     C*
     C     *IN85         IFEQ      '1'
     C     *IN58         ANDEQ     '1'
     C     *IN24         OREQ      '1'
     C     *IN69         ANDEQ     '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C                   SETON                                        66
     C                   SETOFF                                       5455
     C                   END
     C*
     C                   END
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  SCRVAL SR. - TO VALIDATE THE ENTRIES READ FROM FIRST SCREEN   ON
     C*
     C*  CALLED FROM: SCREEN
     C*  CALLS:       ERROR TEST RCVOPT
     C*
     C********************************************************************
     C*
     C     SCRVAL        BEGSR                                                  *** SCRVAL ***
     C*
     C**  RESET ERROR INDICATORS AND ERROR ARRAY
     C*
     C                   MOVEA     '0000000'     *IN(59)
     C                   MOVEA     '0000000'     *IN(71)
     C                   SETOFF                                       69
     C                   Z-ADD     0             X                 2 0
     C                   MOVE      *BLANKS       ERCD
     C*
     C**  TEST FOR VALID CUSTOMER NUMBER
     C*
     C*
     C**  TEST FOR VALID SHORTNAME
     C*
     C     SCNUM         CHAIN     SNAME                              45
     C  N45RECI          COMP      'D'                                4545
     C*
     C**  SHORTNAME VALID - ACCESS CLINTSE
     C*
     C     *IN45         IFEQ      '0'
     C     CNUM          CHAIN     CLINTSEF                           45
     C  N45RECI          COMP      'D'                                4545
     C  N45C1DI          COMP      'E'                                4545
     C*
     C**  SHORTNAME INVALID - ACCESS CLINTSE (BUT ONLY IF LAST 4 BLANK)
     C*
     C                   ELSE
     C     SCNUME        IFEQ      *BLANKS
     C     KCNUM         CHAIN     CLINTSEF                           45
     C  N45RECI          COMP      'D'                                4545
     C  N45C1DI          COMP      'E'                                4545
     C                   ELSE
     C                   SETON                                        45
     C                   END
     C                   END
     C*
     C**  CUSTOMER NUMBER NOT FOUND
     C*
     C   45              SETON                                        59
     C   45              MOVE      ' 413'        ECODE             5
     C   45              EXSR      ERROR
     C*
     C**  IF TRANSMIT SELECTED ACCOUNT MUST BE FOUND ON LF/SEEUR
     C*
     C     STDAV         IFEQ      'Y'
     C                   MOVE      SEURO         EURO00            5 0
     C     EURO00        CHAIN     SEEUR                              45
     C     *IN45         IFEQ      '1'
     C                   SETON                                        59
     C                   MOVE      ' 414'        ECODE             5
     C                   EXSR      ERROR
     C                   END
     C                   END
     C*
     C**  USER NUMBER - MUST BE EIGHT CHARACTERS LONG WITH NO BLANKS
     C**                AND A NON-NUMERIC FIRST CHARACTER
     C*
     C                   MOVEA     SUSNO         ARR
     C*
     C     ARR(1)        COMP      '0'                                60  60
     C   60ARR(1)        COMP      '9'                                  6060
     C   60              MOVE      ' 401'        ECODE             5
     C   60              EXSR      ERROR
     C   60              GOTO      VSR105
     C*
     C                   Z-ADD     0             I1                1 0
     C*
     C     VSRT01        TAG                                                    *** VSRT01 ***
     C*
     C     I1            ADD       1             I1                       40    ** SETOF 40 **
     C     ARR(I1)       COMP      ' '                                    60
     C   60              MOVE      ' 400'        ECODE
     C   60              EXSR      ERROR
     C  N60I1            COMP      8                                    40
     C   40              GOTO      VSRT01
     C*
     C     VSR105        TAG                                                    *** VSR105 ***
     C*
     C**EUCLID PASSWORD - MUST BE ALPHANUMERIC WITH THE FIRST CHARACTER
     C**                  ALPHABETIC AND MUST BE AT LEAST 6 LONG
     C*
     C                   MOVEA     SPASS         ARR
     C*
     C                   EXSR      TEST
     C*
     C     *IN52         IFEQ      '1'
     C                   MOVE      ' 403'        ECODE
     C                   EXSR      ERROR
     C                   SETON                                        61
     C                   END
     C*
     C**  USER PASSWORD - MUST BE ALPHANUMERIC WITH THE FIRST CHARACTER
     C**                  ALPHABETIC AND MUST BE AT LEAST 6 LONG
     C*
     C                   MOVEA     SUSCO         ARR
     C                   EXSR      TEST
     C*
     C     *IN52         IFEQ      '1'
     C                   MOVE      ' 404'        ECODE
     C                   EXSR      ERROR
     C                   SETON                                        62
     C                   END
     C*
     C**  TRANSMIT DETAILS AVAILABLE - CAN ONLY BE 'Y' OR ' '
     C*
     C     STDAV         COMP      'Y'                                    24
     C  N24STDAV         COMP      ' '                                6363
     C   63              MOVE      ' 405'        ECODE
     C   63              EXSR      ERROR
     C*
     C**  TRANSMISSION OPTION - CAN ONLY BE ENTERED IF TRANSMIT DETAIL S
     C**                        IS 'Y', THEN IT CAN ONLY BE 'VD','VE'
     C**                        OR 'VN'
     C*
     C  N24STROP         COMP      '  '                               6464
     C  N24
     CAN 64              MOVE      ' 406'        ECODE
     C*
     C   24STROP         COMP      'VD'                               6464
     C   24
     CAN 64STROP         COMP      'VE'                               6464
     C   24
     CAN 64STROP         COMP      'VN'                               6464
     C   24
     CAN 64              MOVE      ' 407'        ECODE
     C*
     C   64              EXSR      ERROR
     C*
     C**  RECEIVE OPTIONS - MUST BE 'X' OR BLANK
     C*
     C     SRCP1         IFEQ      'X'
     C                   SETON                                            25
     C                   ELSE
     C     SRCP1         IFNE      ' '
     C                   SETON                                        65  71
     C                   END
     C                   END
     C     SRCP2         IFEQ      'X'
     C                   SETON                                            25
     C                   ELSE
     C     SRCP2         IFNE      ' '
     C                   SETON                                        65  72
     C                   END
     C                   END
     C     SRCP3         IFEQ      'X'
     C                   SETON                                            25
     C                   ELSE
     C     SRCP3         IFNE      ' '
     C                   SETON                                        65  73
     C                   END
     C                   END
     C     SRCP4         IFEQ      'X'
     C                   SETON                                            25
     C                   ELSE
     C     SRCP4         IFNE      ' '
     C                   SETON                                        65  74
     C                   END
     C                   END
     C     SRCP5         IFEQ      'X'
     C                   SETON                                            25
     C                   ELSE
     C     SRCP5         IFNE      ' '
     C                   SETON                                        65  75
     C                   END
     C                   END
     C     SRCP6         IFEQ      'X'
     C                   SETON                                            25
     C                   ELSE
     C     SRCP6         IFNE      ' '
     C                   SETON                                        65  76
     C                   END
     C                   END
     C     SRCP7         IFEQ      'X'
     C                   SETON                                            25
     C                   ELSE
     C     SRCP7         IFNE      ' '
     C                   SETON                                        65  77
     C                   END
     C                   END
     C     *IN65         IFEQ      '1'
     C                   MOVE      ' 409'        ECODE
     C                   EXSR      ERROR
     C                   END
     C*
     C**  CHECK THAT EITHER TRANSMIT OR RECEIVE OPTIONS HAVE BEEN
     C**  SELECTED
     C*
     C     *IN63         IFEQ      '0'
     C     *IN24         ANDEQ     '0'
     C     *IN65         ANDEQ     '0'
     C     *IN25         ANDEQ     '0'
     C                   MOVE      ' 411'        ECODE
     C                   EXSR      ERROR
     C                   END
     C*
     C                   ENDSR                                                              **
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  TEST SR. - TO TEST WHETHER PASSWORDS ARE IN CORRECT FORMAT    S
     C*
     C*  CALLED FROM: SCRVAL
     C*
     C********************************************************************
     C*
     C     TEST          BEGSR                                                  ***  TEST  ***
     C*
     C                   MOVEA     '000'         *IN(50)
     C*
     C**  MUST BE ALPHANUMERIC WITH THE FIRST CHARACTER
     C**  ALPHABETIC AND MUST BE AT LEAST 5 LONG
     C*
     C                   Z-ADD     9             I1
     C                   DO        8
     C                   SUB       1             I1
     C     ARR(I1)       IFEQ      *BLANKS
     C     *IN50         IFEQ      '1'
     C                   SETON                                        52
     C                   END
     C                   ELSE
     C     *IN50         IFEQ      '0'
     C                   SETON                                        50
     C     I1            IFLT      6
     C                   SETON                                        52
     C                   END
     C                   ELSE
     C     ARR(I1)       LOOKUP    ALP                                    51
     C     *IN51         IFEQ      '0'
     C     I1            IFEQ      1
     C                   SETON                                        52
     C                   ELSE
     C     ARR(I1)       LOOKUP    NUM                                    51
     C     *IN51         IFEQ      '0'
     C                   SETON                                        52
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C  N52              END
     C     *IN50         IFEQ      '0'
     C                   SETON                                        52
     C                   END
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  ERROR SR. - TO UPDATE THE ERROR INDICATOR ARRAY
     C*
     C*  CALLED FROM: SCRVAL TEST
     C*
     C********************************************************************
     C*
     C     ERROR         BEGSR                                                  *** ERROR  ***
     C*
     C     X             ADD       1             X                    69
     C                   MOVE      ECODE         ERCD(X)
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  SETSCR SR. - TO SET INDICATORS AND FIELDS FOR INITIAL OUTPUT
     C*
     C*  CALLED FROM: SCREEN
     C*
     C********************************************************************
     C*
     C     SETSCR        BEGSR                                                  *** SETSCR ***
     C*
     C**  BLANK OUT INPUT FIELDS
     C*
     C*
     C                   MOVE      *BLANKS       SCNUM
     C                   MOVE      *BLANKS       SUSNO
     C                   MOVE      *BLANKS       SPASS
     C                   MOVE      *BLANKS       SUSCO
     C                   MOVE      ' '           STDAV
     C                   MOVE      '  '          STROP
     C                   MOVE      *BLANKS       SRCP1
     C                   MOVE      *BLANKS       SRCP2
     C                   MOVE      *BLANKS       SRCP3
     C                   MOVE      *BLANKS       SRCP4
     C                   MOVE      *BLANKS       SRCP5
     C                   MOVE      *BLANKS       SRCP6
     C                   MOVE      *BLANKS       SRCP7
     C*
     C**  RESET PROTECT INDICATOR
     C*
     C                   SETOFF                                       6685
     C*
     C**  RESET INDICATORS FOR S/SEEUR PROCESSING
     C*
     C                   SETOFF                                       3088
     C*
     C**  RESET ERROR INDICATORS
     C*
     C                   MOVEA     '0000000'     *IN(59)
     C                   MOVEA     '0000000'     *IN(71)
     C                   SETOFF                                       69
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  SCRTWO SR. - TO PROCESS SECOND SCREEN OF REPORT OPTIONS
     C*
     C*  CALLED FROM:  SCREEN
     C*
     C********************************************************************
     C*
     C     SCRTWO        BEGSR                                                  *** SCRTWO ***
     C*
     C**  FOR EACH RECEIVE OPTION SELECTED
     C*
     C     *IN85         DOUEQ     '1'
     C     *IN01         OREQ      '1'
     C************INKB     OREQ '1'                                       S01199
     C     *INKL         OREQ      '1'                                                         S0119
     C*
     C                   WRITE     HEADER
     C     *IN23         IFEQ      '0'
     C*
     C**  LOAD CORRECT TITLE FOR SCREEN
     C*
     C     SRCP1         IFEQ      'X'
     C                   MOVE      HEAD(1)       STITL
     C                   ELSE
     C     SRCP2         IFEQ      'X'
     C                   MOVE      HEAD(2)       STITL
     C                   ELSE
     C     SRCP3         IFEQ      'X'
     C                   MOVE      HEAD(3)       STITL
     C                   ELSE
     C     SRCP4         IFEQ      'X'
     C                   MOVE      HEAD(4)       STITL
     C                   ELSE
     C     SRCP5         IFEQ      'X'
     C                   MOVE      HEAD(5)       STITL
     C                   ELSE
     C     SRCP6         IFEQ      'X'
     C                   MOVE      HEAD(6)       STITL
     C                   ELSE
     C     SRCP7         IFEQ      'X'
     C                   MOVE      HEAD(7)       STITL
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C*
     C                   SETON                                        85
     C                   END
     C*
     C**  FIND FIRST RECEIVE OPTION SELECTED AND NOT YET PROCESSED
     C**  AND DISPLAY APPROPRIATE SCREEN
     C*
     C     SRCP1         IFEQ      'X'
     C                   SETOFF                                       85
     C                   MOVE      *BLANKS       ERTY
     C     *IN23         IFEQ      '0'
     C                   EXSR      EUCCHN
     C                   END
     C                   EXSR      SBFIL1
     C                   ELSE
     C     SRCP2         IFEQ      'X'
     C     SRCP3         OREQ      'X'
     C     SRCP4         OREQ      'X'
     C                   SETOFF                                       85
     C                   MOVE      'SC'          ERTY
     C     *IN23         IFEQ      '0'
     C                   EXSR      EUCCHN
     C                   END
     C                   EXSR      SBFIL2
     C                   ELSE
     C     SRCP5         IFEQ      'X'
     C     SRCP6         OREQ      'X'
     C                   SETOFF                                       85
     C                   MOVE      'ST'          ERTY
     C     *IN23         IFEQ      '0'
     C                   EXSR      EUCCHN
     C                   END
     C                   EXSR      SBFIL2
     C                   ELSE
     C     SRCP7         IFEQ      'X'
     C                   SETOFF                                       85
     C                   MOVE      *BLANKS       ERTY
     C     *IN23         IFEQ      '0'
     C                   EXSR      EUCCHN
     C                   END
     C                   EXSR      SBFIL1
     C                   END
     C                   END
     C                   END
     C                   END
     C*
     C**  PROCESS COMMAND KEYS
     C*
     C     *IN85         IFEQ      '0'
     C*
     C**  IF ENTER PROCESS REPORT OPTIONS SELECTED
     C*
     C************INKB     IFEQ '0'                                       S01199
     C     *INKL         IFEQ      '0'                                                         S0119
     C     *IN01         ANDEQ     '0'
     C                   Z-ADD     RRN           #SVRRN            4 0
     C                   Z-ADD     SRECNO        #SRCNO            4 0
     C                   EXSR      RPTOPT
     C*
     C**  IF CMD/12 TAKEN ON A PROMPT SCREEN REDISPLAY SECOND SCREEN
     C*
     C************INKB     IFEQ '1'                                       S01199
     C     *INKL         IFEQ      '1'                                                         S0119
     C                   WRITE     CLRSCRN
     C                   SETON                                        3923
     C                   Z-ADD     SAVRRN        RRN
     C     RRN           CHAIN     SE1200S2                           99
     C     *IN99         DOWEQ     '0'
     C                   UPDATE    SE1200S2
     C                   ADD       1             RRN
     C     RRN           CHAIN     SE1200S2                           99
     C                   END
     C***********          SETOF                     3999KB               S01199
     C                   SETOFF                                       3999KL                   S0119
     C                   Z-ADD     #SVRRN        RRN
     C                   Z-ADD     #SRCNO        SRECNO
     C                   WRITE     HEADER
     C                   ELSE
     C*
     C** THIS RECEIVE OPTION IS FINISHED WITH SO BLANK OUT SCREEN FIELD
     C*
     C     *IN01         IFEQ      '0'
     C                   MOVE      *BLANKS       RPTSEL
     C     SRCP1         IFEQ      'X'
     C                   MOVE      ' '           SRCP1
     C                   ELSE
     C     SRCP2         IFEQ      'X'
     C                   MOVE      ' '           SRCP2
     C                   ELSE
     C     SRCP3         IFEQ      'X'
     C                   MOVE      ' '           SRCP3
     C                   ELSE
     C     SRCP4         IFEQ      'X'
     C                   MOVE      ' '           SRCP4
     C                   ELSE
     C     SRCP5         IFEQ      'X'
     C                   MOVE      ' '           SRCP5
     C                   ELSE
     C     SRCP6         IFEQ      'X'
     C                   MOVE      ' '           SRCP6
     C                   ELSE
     C     SRCP7         IFEQ      'X'
     C                   MOVE      ' '           SRCP7
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C*
     C                   END
     C*
     C                   MOVE      *BLANKS       RPTSEL
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  EUCCHN SR. - TO CHAIN TO LF/EUCRCV
     C*
     C*  CALLED FROM:  SCRTWO
     C*
     C********************************************************************
     C*
     C     EUCCHN        BEGSR                                                  *** EUCCHN ***
     C*
     C*****ERTY*         SETLL     EUCRCV                                                   MD058079
     C**********         READ      EUCRCV                                 99                MD058079
     C/EXEC SQL                                                                             MD058079
     C+ declare ACursor insensitive scroll cursor for                                       MD058079
     C+ select * from SEEURJW0                                                              MD058079
     C+ where ERTY >= :ERTY                                                                 MD058079
     C+ order by ERTY                                                                       MD058079
     C/END-EXEC                                                                             MD058079
                                                                                            MD058079
     C/EXEC SQL                                                                             MD058079
     C+ open ACursor                                                                        MD058079
     C/END-EXEC                                                                             MD058079
                                                                                            MD058079
     C/EXEC SQL                                                                             MD058079
     C+ fetch next from ACursor into :EUCRCV                                                MD058079
     C/END-EXEC                                                                             MD058079
                                                                                            MD058079
     C                   SETOFF                                       99                    MD058079
     C                   IF        SQLCODE = 100                                            MD058079
     C                   SETON                                        99                    MD058079
     C                   ELSE                                                               MD058079
     C                   EVAL      EROC = XEROC                                             MD058079
     C                   ENDIF                                                              MD058079
     C     *IN99         IFEQ      '1'
     C                   SETON                                        U7U8LR
     C     *LOCK         IN        LDA                                                         S0111
     C                   MOVE      'EUCRCV'      DBFILE                         ***************
     C                   MOVE      EROC          DBKEY                          * DB ERROR 02 *
     C                   Z-ADD     02            DBASE                          ***************
     C                   OUT       LDA                                                         S0111
     C                   EXSR      *PSSR                                                       S0111
     C                   SETON                                        LR
     C                   RETURN
     C                   END
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  SBFIL1 SR. - TO LOAD SCREEN 2 SUBFILE FOR RECEIVE OPTIONS
     C*               1 AND 7
     C*
     C*  CALLED FROM - SCRTWO
     C*
     C********************************************************************
     C*
     C     SBFIL1        BEGSR                                                  *** SBFIL1 ***
     C*
     C     *IN23         IFEQ      '0'
     C                   SETOFF                                         43
     C                   WRITE     SE1200F2
     C                   Z-ADD     1             RRN               4 0
     C                   SETOFF                                       57
     C                   END
     C                   MOVEA     '1'           *IN(43)
     C     *IN78         DOUEQ     '0'
     C     *IN23         IFEQ      '0'
     C     *IN57         IFEQ      '0'
     C                   Z-ADD     RRN           SRECNO
     C                   DO        15
     C                   WRITE     SE1200S2
     C                   ADD       1             RRN
     C**********         READ      EUCRCV                                 57                MD058079
     C/EXEC SQL                                                                             MD058079
     C+ fetch next from ACursor into :EUCRCV                                                MD058079
     C/END-EXEC                                                                             MD058079
                                                                                            MD058079
     C                   SETOFF                                       57                    MD058079
     C                   IF        SQLCODE = 100                                            MD058079
     C                   SETON                                        57                    MD058079
     C                   ELSE                                                               MD058079
     C                   EVAL      EROC = XEROC                                             MD058079
     C                   ENDIF                                                              MD058079
     C  N57              END
     C                   ELSE
     C                   SETON                                        20
     C                   END
     C                   SETON                                        5455
     C                   WRITE     FOOTER
     C                   END
     C                   EXFMT     SE1200F2
     C                   SETOFF                                       2023
     C                   END
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  SBFIL2 SR. - TO LOAD SCREEN 2 SUBFILE FOR RECEIVE OPTIONS
     C*               2, 3, 4, 5 & 6
     C*
     C*  CALLED FROM: SCRTWO
     C*
     C********************************************************************
     C*
     C     SBFIL2        BEGSR                                                  *** SBFIL2 ***
     C*
     C     *IN23         IFEQ      '0'
     C                   SETOFF                                         43
     C                   WRITE     SE1200F2
     C                   Z-ADD     1             RRN               4 0
     C                   SETOFF                                       57
     C                   END
     C                   MOVEA     '1'           *IN(43)
     C*
     C**  DISPLAY UNTIL ROLLUP, ROLLDOWN OR CMD 12 ENTERED
     C*
     C     *IN78         DOUEQ     '0'
     C     *IN23         IFEQ      '0'
     C     *IN57         IFEQ      '0'
     C                   Z-ADD     RRN           SRECNO
     C                   DO        15
     C                   WRITE     SE1200S2
     C                   ADD       1             RRN
     C*****ERTY*         READE     EUCRCV                                 57                MD058079
     C/EXEC SQL                                                                             MD058079
     C+ SELECT *                                                                            MD058079
     C+ into :EUCRCV                                                                        MD058079
     C+ from SEEURJW0                                                                       MD058079
     C+ where ERTY = :ERTY                                                                  MD058079
     C/END-EXEC                                                                             MD058079
     C                   SETOFF                                       57                    MD058079
     C                   IF        SQLCODE = 100                                            MD058079
     C                   SETON                                        57                    MD058079
     C                   ELSE                                                               MD058079
     C                   EVAL      EROC = XEROC                                             MD058079
     C                   ENDIF                                                              MD058079
     C  N57              END
     C                   ELSE
     C                   SETON                                        20
     C                   END
     C                   SETON                                        5455
     C                   WRITE     FOOTER
     C                   END
     C                   EXFMT     SE1200F2
     C                   SETOFF                                       2023
     C                   END
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  RPTOPT SR. - TO PROCESS SELECTED REPORT OPTIONS FROM SECOND
     C*               SCREEN
     C*
     C*  CALLED FROM:  SCRTWO
     C*
     C********************************************************************
     C*
     C     RPTOPT        BEGSR                                                  *** RPTOPT ***
     C*
     C                   Z-ADD     1             RRN
     C*
     C**  PROCESS EACH REPORT OPTION SELECTED AND LOAD PROMPT SCREEN IF
     C**  NEEDED
     C*
     C     *IN99         DOWEQ     '0'
     C     *IN01         ANDEQ     '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C*
     C                   READC     SE1200S2                               99
     C                   Z-ADD     RRN           SAVRRN            4 0
     C*
     C     *IN99         IFEQ      '0'
     C     RPTSEL        ANDNE     ' '
     C*
     C**  OPTION WHICH REQUIRE NO PROMPT SCREENS OR OTHER PROCESSING
     C**  CAN BE WRITTEN STRAIGHT TO TRANSMISSION FILE
     C*
     C     EROC          LOOKUP    SIMP                                   39
     C     *IN39         IFEQ      '1'
     C                   MOVE      *BLANKS       CRD
     C                   MOVEA     EROC          CRD
     C                   EXSR      OUTPUT
     C                   ELSE
     C*
     C**  OTHERWISE CALL SUBROUTINES TO FORMAT OPTIONS
     C*
     C     #RPT          IFEQ      'VRUP    '
     C     #RPT          OREQ      'VRYP    '
     C     #RPT          OREQ      'VRTP    '
     C                   MOVE      *BLANKS       CRD
     C*
     C**  SEE IF 'STAND' OPTIONS ARE NEEDED
     C*
     C                   EXSR      STAND
     C*
     C**  WRITE TO TRANSMISSION FILE
     C*
     C                   MOVEA     EROC          CRD(Y)
     C                   EXSR      OUTPUT
     C                   END
     C*
     C                   WRITE     CLRSCRN
     C                   MOVE      EROC          SRCD
     C                   SETON                                        53
     C*
     C     #RPT          IFEQ      'CPART,NU'
     C                   EXSR      CPTNUM
     C                   END
     C     #RPT          IFEQ      'CPART,NA'
     C                   EXSR      CPNAME
     C                   END
     C     #RPT          IFEQ      'SECUR,NU'
     C                   EXSR      SECNUM
     C                   END
     C     #RPT          IFEQ      'SECUR,NA'
     C                   EXSR      SECNAM
     C                   END
     C     #RPT          IFEQ      'P       '
     C                   EXSR      PASSWD
     C                   END
     C     #RPT          IFEQ      'LOGFAIL '
     C                   EXSR      LOGFL
     C                   END
     C     #RPT          IFEQ      'N       '
     C     #RPT          OREQ      'NA      '
     C     #RPT          OREQ      'NN      '
     C     #RPT          OREQ      'NISSP   '
     C                   EXSR      NDATE
     C                   END
     C     #RPT          IFEQ      'RP30    '
     C                   SETOFF                                       72
     C                   EXSR      R30
     C                   END
     C     #RPT          IFEQ      'RF30    '
     C                   SETON                                        72
     C                   EXSR      R30
     C                   END
     C     #RPT          IFEQ      'IREFC   '
     C                   EXSR      IREF
     C                   END
     C     #RPT          IFEQ      'RC10    '
     C     #RPT          OREQ      'RF11    '
     C     #RPT          OREQ      'RP11    '
     C     #RPT          OREQ      'RF12    '
     C     #RPT          OREQ      'RP12    '
     C     #RPT          OREQ      'RF13    '
     C     #RPT          OREQ      'RP13    '
     C     #RPT          OREQ      'RF15    '
     C*
     C**  DISPLAY PROMPT SCREEN FOR TYPE AND SCOPE OF REPORT
     C*
     C                   EXSR      PRMPT3
     C*
     C**  DISPLAY PROMPT SCREEN FOR SCHEDULE TIMES
     C*
     C     *IN01         IFEQ      '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C*
     C                   EXSR      SCHED
     C*
     C**  FORMAT OPTION AND WRITE TO TRANSMISSION FILE
     C*
     C     *IN01         IFEQ      '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C*
     C                   EXSR      FORMAT
     C*
     C                   Z-ADD     Y             #SVY              2 0
     C*
     C                   MOVEA     EROC          CRD(Y)
     C                   ADD       4             Y
     C*
     C                   EXSR      FORTYP
     C*
     C                   EXSR      FORTIM
     C*
     C                   EXSR      OUTPUT
     C*
     C     #RPT          IFEQ      'RC10    '
     C     STITL         IFEQ      HEAD(1)
     C     STITL         OREQ      HEAD(3)
     C     STITL         OREQ      HEAD(7)
     C                   SETON                                        26
     C                   END
     C                   END
     C*
     C                   END
     C                   END
     C                   END
     C*
     C     #RPT          IFEQ      'RF01    '
     C     #RPT          OREQ      'RP01    '
     C     #RPT          OREQ      'ISTA    '
     C*
     C**  DISPLAY PROMPT SCREEN FOR TYPE AND SCOPE OF REPORT
     C*
     C                   EXSR      PRMPT3
     C*
     C**  DISPLAY PROMPT SCREEN FOR STATUS SELECTION
     C*
     C     *IN01         IFEQ      '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C*
     C                   EXSR      STATUS
     C*
     C**  FORMAT OPTION AND WRITE TO TRANSMISSION FILE
     C*
     C     *IN01         IFEQ      '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C*
     C                   MOVE      *BLANKS       CRD
     C                   MOVEA     EROC          CRD(1)
     C                   Z-ADD     5             Y
     C*
     C                   EXSR      FORTYP
     C*
     C                   EXSR      FORSTS
     C*
     C                   EXSR      OUTPUT
     C*
     C                   END
     C                   END
     C                   END
     C*
     C     #RPT          IFEQ      'IKEY    '
     C*
     C**  DISPLAY PROMPT SCREEN FOR TYPE AND SCOPE OF REPORT
     C*
     C                   EXSR      PRMPT3
     C*
     C**  DISPLAY PROMPT SCREEN FOR USER REFERENCE DETAILS
     C*
     C     *IN01         IFEQ      '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C*
     C                   EXSR      USRREF
     C*
     C**  DISPLAY PROMPT SCREEN FOR STATUS SELECTION
     C*
     C     *IN01         IFEQ      '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C*
     C                   EXSR      STATUS
     C*
     C**  FORMAT OPTION AND WRITE TO TRANSMISSION FILE
     C*
     C     *IN01         IFEQ      '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C*
     C                   MOVE      *BLANKS       CRD
     C                   MOVEA     EROC          CRD(1)
     C                   Z-ADD     5             Y
     C*
     C                   EXSR      FORTYP
     C*
     C                   EXSR      FORURF
     C*
     C                   EXSR      FORSTS
     C*
     C                   EXSR      OUTPUT
     C*
     C                   END
     C                   END
     C                   END
     C                   END
     C*
     C     #RPT          IFEQ      'INOTE   '
     C*
     C**  DISPLAY PROMPT SCREEN FOR STATUS SELECTION
     C*
     C                   EXSR      STATUS
     C*
     C**  FORMAT OPTION AND WRITE TO TRANSMISSION FILE
     C*
     C     *IN01         IFEQ      '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C*
     C                   MOVE      *BLANKS       CRD
     C                   MOVEA     EROC          CRD(1)
     C                   Z-ADD     6             Y
     C*
     C                   EXSR      FORSTS
     C*
     C                   EXSR      OUTPUT
     C*
     C                   END
     C                   END
     C*
     C     #RPT          IFEQ      'RP14    '
     C*
     C**  DISPLAY PROMPT SCREEN FOR TYPE AND SCOPE OF REPORT
     C*
     C                   EXSR      PRMPT3
     C*
     C**  DISPLAY PROMPT SCREEN FOR CHOOSING DAY OF REPORT
     C*
     C     *IN01         IFEQ      '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C*
     C                   EXSR      SELDAY
     C*
     C**  DISPLAY PROMPT SCREEN FOR SCHEDULE TIMES
     C*
     C     *IN01         IFEQ      '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C*
     C                   EXSR      SCHED
     C*
     C**  FORMAT OPTION AND WRITE TO TRANSMISSION FILE
     C*
     C     *IN01         IFEQ      '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C*
     C                   EXSR      FORMAT
     C*
     C                   Z-ADD     Y             #SVY              2 0
     C*
     C                   MOVEA     EROC          CRD(Y)
     C                   ADD       4             Y
     C*
     C                   EXSR      FORTYP
     C*
     C                   EXSR      FORDAY
     C*
     C                   EXSR      FORTIM
     C*
     C                   EXSR      OUTPUT
     C*
     C                   END
     C                   END
     C                   END
     C                   END
     C*
     C     #RPT          IFEQ      'RF14AB  '
     C*
     C**  DISPLAY PROMPT SCREEN FOR CHOOSING DAY OF REPORT
     C*
     C                   EXSR      SELDAY
     C*
     C**  DISPLAY PROMPT SCREEN FOR SCHEDULE TIMES
     C*
     C     *IN01         IFEQ      '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C*
     C                   EXSR      SCHED
     C*
     C**  FORMAT OPTION AND WRITE TO TRANSMISSION FILE
     C*
     C     *IN01         IFEQ      '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C*
     C                   EXSR      FORMAT
     C*
     C                   Z-ADD     Y             #SVY              2 0
     C*
     C                   MOVEA     EROC          CRD(Y)
     C                   ADD       6             Y
     C*
     C                   EXSR      FORDAY
     C*
     C                   EXSR      FORTIM
     C*
     C                   EXSR      OUTPUT
     C*
     C                   END
     C                   END
     C                   END
     C*
     C     #RPT          IFEQ      'RC20AB  '
     C     #RPT          OREQ      'RF31    '
     C     #RPT          OREQ      'RP31    '
     C     #RPT          OREQ      'RF59    '
     C     #RPT          OREQ      'RP59    '
     C*
     C*
     C**  DISPLAY PROMPT SCREEN FOR CHOOSING DAY OF REPORT
     C*
     C                   EXSR      SELDAY
     C*
     C**  FORMAT OPTION AND WRITE TO TRANSMISSION FILE
     C*
     C     *IN01         IFEQ      '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C*
     C                   MOVE      *BLANKS       CRD
     C     #RPT          IFEQ      'RC20AB  '
     C     STITL         IFNE      HEAD(5)
     C     STITL         ANDNE     HEAD(6)
     C                   SETON                                        26
     C                   END
     C                   EXSR      STAND
     C                   MOVEA     EROC          CRD(Y)
     C                   ADD       6             Y
     C                   ELSE
     C                   MOVEA     EROC          CRD(1)
     C                   Z-ADD     5             Y
     C                   END
     C*
     C                   EXSR      FORDAY
     C*
     C                   EXSR      OUTPUT
     C*
     C                   END
     C                   END
     C*
     C                   END
     C*
     C**  IF EXIT NOT SELECTED REMOVE SELECTION MARK FROM SECOND SCREEN
     C**  FOR THIS REPORT OPTION
     C*
     C     *IN01         IFEQ      '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C                   WRITE     CLRSCRN
     C                   SETON                                        58
     C     SAVRRN        CHAIN     SE1200S2                           99
     C                   MOVE      *BLANKS       RPTSEL
     C                   UPDATE    SE1200S2
     C                   END
     C                   END
     C                   END
     C                   SETOFF                                       53
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*   CPTNUM SR. - TO PROCESS RECEIVE OPTION CPART,NUM
     C*
     C*              CALLED FROM - RPTOPT
     C*
     C********************************************************************
     C*
     C     CPTNUM        BEGSR                                                  *** CPTNUM ***
     C*
     C**  DISPLAY PROMPT SCREEN
     C*
     C                   WRITE     HEADER
     C                   Z-ADD     1             RRN
     C                   SETOFF                                         4369
     C                   WRITE     SE120F10
     C                   SETON                                          4356
     C                   Z-ADD     1             SRECNO
     C                   MOVE      *BLANKS       SCPNUM
     C                   WRITE     SE120S10
     C*
     C     *IN01         DOUEQ     '1'
     C************INKB     OREQ '1'                                       S01199
     C     *INKL         OREQ      '1'                                                         S0119
     C     *IN85         OREQ      '1'
     C*
     C                   EXFMT     SE120F10
     C*
     C**  PROCESS COMMAND KEYS
     C*
     C************IN22     IFEQ '1'                                       S01199
     C************         MOVEAERCD      HERCD 160                       S01199
     C***********          MOVEL'SE1200'  HBPGM   6                       S01199
     C***********          CALL 'MHELP'                                   S01199
     C***********          PARM           HBPGM                           S01199
     C***********          PARM           HERCD                           S01199
     C***********          ELSE                                           S01199
     C*
     C**  ENTER KEY
     C*
     C     *IN01         IFEQ      '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C*
     C**  READ AND VALIDATE SUBFILE SCREEN
     C*
     C                   SETOFF                                       41
     C                   SETON                                        37
     C                   Z-ADD     0             X
     C*
     C                   READC     SE120S10                               99
     C*
     C**  MUST BE A CEDEL NO. ('C' FOLLOWED BY 5 NUMBERS) OR EUROCLEAR
     C**  NO. (5 DIGIT NUMBER BEGINNING WITH '9' OR '6')
     C*
     C     *IN99         DOWEQ     '0'
     C     SCPNUM        IFNE      *BLANKS
     C                   SETOFF                                       37
     C     CIND          IFEQ      'C'
     C                   TESTN                   CDNUMA               21
     C     *IN21         IFEQ      '0'
     C     CDNUM         ORLT      10000
     C                   SETON                                        8041
     C                   END
     C                   ELSE
     C     BLKCHK        IFNE      ' '
     C                   SETON                                        8041
     C                   ELSE
     C                   TESTN                   ECNUMA               21
     C     *IN21         IFEQ      '0'
     C     CIND          OREQ      '6'
     C     ECNUM         ANDLT     60000
     C     CIND          OREQ      '9'
     C     ECNUM         ANDLT     90000
     C     CIND          ORNE      '6'
     C     CIND          ANDNE     '9'
     C                   SETON                                        4180
     C                   END
     C                   END
     C                   END
     C                   END
     C     *IN38         IFEQ      '0'
     C                   Z-ADD     RRN           SRECNO
     C                   SETON                                        38
     C                   END
     C                   UPDATE    SE120S10
     C                   SETOFF                                         41
     C                   READC     SE120S10                               99
     C                   END
     C*
     C**  AT LEAST ONE NUMBER MUST BE ENTERED
     C*
     C     *IN37         IFEQ      '1'
     C                   MOVE      ' 439'        ECODE
     C                   EXSR      ERROR
     C                   Z-ADD     1             SRECNO
     C     1             CHAIN     SE120S10                           99
     C                   SETON                                          41
     C                   UPDATE    SE120S10
     C                   SETOFF                                         41
     C                   END
     C     *IN80         IFEQ      '1'
     C                   MOVE      ' 440'        ECODE
     C                   EXSR      ERROR
     C                   SETOFF                                       9980
     C                   SETON                                        37
     C                   END
     C*
     C**  FORMAT OPTION IF NO ERRORS
     C*
     C     *IN37         IFEQ      '0'
     C*
     C**  START WITH REPORT OPTION
     C*
     C                   MOVE      *BLANKS       CRD
     C                   MOVEA     EROC          CRD
     C                   Z-ADD     10            Y                 2 0
     C*
     C**  ADD EACH ENTRY ON SCREEN
     C*
     C                   DO        35            RRN
     C     RRN           CHAIN     SE120S10                           99
     C     *IN99         IFEQ      '0'
     C     SCPNUM        ANDNE     *BLANKS
     C                   MOVEA     ';'           CRD(Y)
     C                   ADD       1             Y
     C     CIND          IFEQ      'C'
     C                   MOVEA     SCPNUM        CRD(Y)
     C                   ADD       6             Y
     C                   ELSE
     C                   MOVEA     ECNUMA        CRD(Y)
     C                   ADD       5             Y
     C                   END
     C*
     C**  IF TOO MANY ARE SELECTED WRITE TO TRANSMISSION FILE AND START
     C**  AGAIN WITH THE REST
     C*
     C     Y             IFGT      69
     C                   MOVEA     ';'           CRD(Y)
     C                   ADD       1             Y
     C                   MOVEA     'END'         CRD(Y)
     C                   MOVEA     CRD           LOTTLX           80
     C                   SETON                                        81
     C                   EXCEPT
     C                   MOVEA     *BLANKS       CRD(10)
     C                   Z-ADD     10            Y
     C                   END
     C                   END
     C                   END
     C*
     C**  WRITE TO TRANSMISSION FILE
     C*
     C     Y             IFGT      11
     C                   MOVEA     ';'           CRD(Y)
     C                   ADD       1             Y
     C                   MOVEA     'END'         CRD(Y)
     C                   MOVEA     CRD           LOTTLX
     C                   SETON                                        81
     C                   EXCEPT
     C                   END
     C                   SETON                                        85
     C                   SETOFF                                       81
     C*
     C**  SET UP ERROR CODES FOR SCREEN IF ANY ERRORS
     C*
     C                   ELSE
     C                   MOVEA     ERCD(1)       ERRMG1
     C                   WRITE     ERRFMT
     C                   SETOFF                                       37
     C                   END
     C                   END
     C***********          END                                            S01199
     C                   END
     C*
     C                   SETOFF                                       856956
     C                   WRITE     ERRFMT
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  CPNAME SR. - TO PROCESS RECEIVE OPTION CPART,NAME
     C*
     C*  CALLED FROM:  RPTOPT
     C*
     C********************************************************************
     C*
     C     CPNAME        BEGSR                                                  *** CPNAME ***
     C*
     C**  DISPLAY PROMPT SCREEN
     C*
     C                   WRITE     HEADER
     C                   Z-ADD     1             RRN
     C                   SETOFF                                         4369
     C                   SETOFF                                       41
     C                   WRITE     SE1200F9
     C                   SETON                                          4356
     C                   Z-ADD     1             SRECNO
     C                   MOVE      *BLANKS       SCNAME
     C                   WRITE     SE1200S9
     C*
     C     *IN01         DOUEQ     '1'
     C************INKB     OREQ '1'                                       S01199
     C     *INKL         OREQ      '1'                                                         S0119
     C     *IN85         OREQ      '1'
     C*
     C                   EXFMT     SE1200F9
     C*
     C**  PROCESS COMMAND KEYS
     C*
     C************IN22     IFEQ '1'                                       S01199
     C***********          MOVEAERCD      HERCD 160                       S01199
     C***********          MOVEL'SE1200'  HBPGM   6                       S01199
     C***********          CALL 'MHELP'                                   S01199
     C***********          PARM           HBPGM                           S01199
     C***********          PARM           HERCD                           S01199
     C***********          ELSE                                           S01199
     C*
     C**  ENTER KEY
     C*
     C     *IN01         IFEQ      '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C*
     C**  READ AND VALIDATE SUBFILE SCREEN
     C*
     C                   SETON                                        37
     C                   Z-ADD     0             X
     C*
     C                   READC     SE1200S9                               99
     C*
     C**  NAME MUST BE ALPHABETIC
     C*
     C     *IN99         DOWEQ     '0'
     C                   SETOFF                                       41
     C     SCNAME        IFNE      *BLANKS
     C*
     C                   SETOFF                                       37
     C*
     C                   MOVE      *BLANKS       CNM
     C                   MOVEA     SCNAME        CNM
     C                   Z-ADD     0             Y
     C                   DO        33            Y
     C     CNM(Y)        IFNE      ' '
     C     CNM(Y)        LOOKUP    ALP                                    99
     C                   END
     C   99              END
     C*
     C     *IN99         IFEQ      '0'
     C                   SETON                                        4180
     C     *IN38         IFEQ      '0'
     C                   Z-ADD     RRN           SRECNO
     C                   SETON                                        38
     C                   END
     C                   END
     C                   END
     C                   UPDATE    SE1200S9
     C                   READC     SE1200S9                               99
     C                   END
     C*
     C**  AT LEAST ONE NAME MUST BE ENTERED
     C*
     C     *IN37         IFEQ      '1'
     C                   MOVE      ' 442'        ECODE
     C                   EXSR      ERROR
     C                   Z-ADD     1             SRECNO
     C     1             CHAIN     SE1200S9                           99
     C                   SETON                                          41
     C                   UPDATE    SE1200S9
     C                   SETOFF                                         41
     C                   END
     C*
     C     *IN80         IFEQ      '1'
     C                   MOVE      ' 441'        ECODE
     C                   EXSR      ERROR
     C                   SETOFF                                       9980
     C                   SETON                                        37
     C                   END
     C*
     C**  FORMAT OPTION IF NO ERRORS
     C*
     C     *IN37         IFEQ      '0'
     C*
     C**  START WITH REPORT OPTION
     C*
     C                   MOVE      *BLANKS       CRD
     C                   MOVEA     EROC          CRD
     C                   Z-ADD     11            Y
     C*
     C**  ADD ALL NAMES ENTERED ON SCREEN
     C*
     C                   DO        35            RRN
     C     RRN           CHAIN     SE1200S9                           99
     C     *IN99         IFEQ      '0'
     C     SCNAME        ANDNE     *BLANKS
     C                   MOVEA     ';'           CRD(Y)
     C                   ADD       1             Y
     C*
     C**  REMOVE TRAILING BLANKS
     C*
     C                   MOVEA     SCNAME        CNM
     C                   Z-ADD     34            XX                2 0
     C                   DO        33
     C                   SUB       1             XX
     C     CNM(XX)       IFNE      ' '
     C                   SETON                                        99
     C                   END
     C  N99              END
     C                   SETOFF                                       99
     C                   MOVEA     SCNAME        CRD(Y)
     C                   ADD       XX            Y
     C*
     C**  IF TOO MANY ARE SELECTED WRITE TO TRANSMISSION FILE AND START
     C**  AGAIN WITH THE REST
     C*
     C     Y             IFGT      42
     C                   MOVEA     ';END'        CRD(Y)
     C                   MOVEA     CRD           LOTTLX
     C                   SETON                                        81
     C                   EXCEPT
     C                   MOVEA     *BLANKS       CRD(11)
     C                   Z-ADD     11            Y
     C                   END
     C                   END
     C                   END
     C*
     C**  WRITE TO TRANSMISSION FILE
     C*
     C     Y             IFGT      12
     C                   MOVEA     ';END'        CRD(Y)
     C                   MOVEA     CRD           LOTTLX
     C                   SETON                                        81
     C                   EXCEPT
     C                   END
     C                   SETON                                        85
     C                   SETOFF                                       81
     C*
     C**  SET UP ERROR CODES IF ANY ERRORS
     C*
     C                   ELSE
     C                   MOVEA     ERCD(1)       ERRMG1
     C                   WRITE     ERRFMT
     C                   SETOFF                                       37
     C                   END
     C                   END
     C                   END
     C***********          END                                            S01199
     C*
     C                   SETOFF                                       856956
     C                   WRITE     ERRFMT
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  SECNAM SR. - TO PROCESS RECEIVE OPTION SECUR,NAME
     C*
     C*  CALLED FROM:  RPTOPT
     C*
     C********************************************************************
     C*
     C     SECNAM        BEGSR                                                  *** SECNAM ***
     C*
     C**  DISPLAY PROMPT SCREEN
     C*
     C                   WRITE     HEADER
     C                   Z-ADD     1             RRN
     C                   SETOFF                                         4369
     C                   SETOFF                                       41
     C                   WRITE     SE120F12
     C                   SETON                                          4356
     C                   Z-ADD     1             SRECNO
     C                   MOVE      *BLANKS       SSNAME
     C                   WRITE     SE120S12
     C*
     C     *IN01         DOUEQ     '1'
     C************INKB     OREQ '1'                                       S01199
     C     *INKL         OREQ      '1'                                                         S0119
     C     *IN85         OREQ      '1'
     C*
     C                   EXFMT     SE120F12
     C*
     C*
     C**  PROCESS COMMAND KEYS
     C*
     C*
     C************IN22     IFEQ '1'                                       S01199
     C***********          MOVEAERCD      HERCD 160                       S01199
     C***********          MOVEL'SE1200'  HBPGM   6                       S01199
     C***********          CALL 'MHELP'                                   S01199
     C***********          PARM           HBPGM                           S01199
     C***********          PARM           HERCD                           S01199
     C***********          ELSE                                           S01199
     C*
     C**  ENTER KEY
     C*
     C     *IN01         IFEQ      '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C*
     C**  READ AND VALIDATE SUBFILE SCREEN
     C*
     C                   SETOFF                                       4180
     C                   SETON                                        37
     C                   Z-ADD     0             X
     C*
     C                   READC     SE120S12                               99
     C*
     C     *IN99         DOWEQ     '0'
     C*
     C     SSNAME        IFNE      *BLANKS
     C                   SETOFF                                       37
     C                   END
     C*
     C                   READC     SE120S12                               99
     C                   END
     C*
     C**  AT LEAST ONE NAME MUST BE ENTERED
     C*
     C     *IN37         IFEQ      '1'
     C                   MOVE      ' 444'        ECODE
     C                   EXSR      ERROR
     C                   Z-ADD     1             SRECNO
     C     1             CHAIN     SE120S12                           99
     C                   SETON                                          41
     C                   UPDATE    SE120S12
     C                   SETOFF                                         41
     C                   MOVEA     ERCD(1)       ERRMG1
     C                   WRITE     ERRFMT
     C                   SETOFF                                       37
     C*
     C**  FORMAT OPTION IF NO ERRORS
     C*
     C                   ELSE
     C*
     C**  START WITH REPORT OPTION
     C*
     C                   MOVE      *BLANKS       CRD
     C                   MOVEA     EROC          CRD
     C                   Z-ADD     11            Y
     C*
     C**  ADD ALL NAMES ENTERED ON SCREEN
     C*
     C                   DO        35            RRN
     C     RRN           CHAIN     SE120S12                           99
     C     *IN99         IFEQ      '0'
     C     SSNAME        ANDNE     *BLANKS
     C                   MOVEA     ';'           CRD(Y)
     C                   ADD       1             Y
     C*
     C**  REMOVE TRAILING BLANKS
     C*
     C                   MOVEA     SSNAME        CNM
     C                   Z-ADD     17            XX
     C                   DO        16
     C                   SUB       1             XX
     C     CNM(XX)       IFNE      ' '
     C                   SETON                                        99
     C                   END
     C  N99              END
     C                   SETOFF                                       99
     C                   MOVEA     SSNAME        CRD(Y)
     C                   ADD       XX            Y
     C                   MOVEA     ';ALL;ALL'    CRD(Y)
     C                   ADD       8             Y
     C                   MOVEA     ';ALL'        CRD(Y)
     C                   ADD       4             Y
     C*
     C**  IF TOO MANY ARE SELECTED WRITE TO TRANSMISSION FILE AND START
     C**  AGAIN WITH THE REST
     C*
     C     Y             IFGT      47
     C                   MOVEA     ';END'        CRD(Y)
     C                   MOVEA     CRD           LOTTLX
     C                   SETON                                        81
     C                   EXCEPT
     C                   MOVEA     *BLANKS       CRD(11)
     C                   Z-ADD     11            Y
     C                   END
     C                   END
     C                   END
     C*
     C**  WRITE TO TRANSMISSION FILE
     C*
     C     Y             IFGT      12
     C                   MOVEA     ';END'        CRD(Y)
     C                   MOVEA     CRD           LOTTLX
     C                   SETON                                        81
     C                   EXCEPT
     C                   END
     C                   SETON                                        85
     C                   SETOFF                                       81
     C                   END
     C                   END
     C                   END
     C***********          END                                            S01199
     C*
     C                   SETOFF                                       856956
     C                   WRITE     ERRFMT
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  SECNUM SR. - TO PROCESS RECEIVE OPTION SECUR,NUM
     C*
     C*  CALLED FROM:  RPTOPT
     C*
     C********************************************************************
     C*
     C     SECNUM        BEGSR                                                  *** SECNUM ***
     C*
     C**  DISPLAY PROMPT SCREEN
     C*
     C                   WRITE     HEADER
     C                   Z-ADD     1             RRN
     C                   SETOFF                                       69
     C                   MOVEA     '000'         *IN(41)
     C                   WRITE     SE120F11
     C                   SETON                                          4356
     C                   Z-ADD     1             SRECNO
     C                   MOVE      *BLANKS       SSNUM
     C                   MOVE      *BLANKS       SSTYPE
     C                   WRITE     SE120S11
     C*
     C     *IN01         DOUEQ     '1'
     C************INKB     OREQ '1'                                       S01199
     C     *INKL         OREQ      '1'                                                         S0119
     C     *IN85         OREQ      '1'
     C*
     C                   EXFMT     SE120F11
     C*
     C*
     C**  PROCESS COMMAND KEYS
     C*
     C*
     C************IN22     IFEQ '1'                                       S01199
     C***********          MOVEAERCD      HERCD 160                       S01199
     C***********          MOVEL'SE1200'  HBPGM   6                       S01199
     C***********          CALL 'MHELP'                                   S01199
     C***********          PARM           HBPGM                           S01199
     C***********          PARM           HERCD                           S01199
     C***********          ELSE                                           S01199
     C*
     C**  ENTER KEY
     C*
     C     *IN01         IFEQ      '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C*
     C**  READ AND VALIDATE SUBFILE SCREEN
     C*
     C                   SETON                                        37
     C                   Z-ADD     0             X
     C                   MOVEA     *BLANKS       ERCD
     C*
     C                   READC     SE120S11                               99
     C*
     C     *IN99         DOWEQ     '0'
     C                   SETOFF                                       4142
     C*
     C     SSNUM         IFNE      *BLANKS
     C                   SETOFF                                       37
     C                   END
     C*
     C**  REPORT TYPE ONLY ALLOWED IF SECURITY NUMBER ENTERED
     C*
     C     SSNUM         IFEQ      *BLANKS
     C     SSTYPE        ANDNE     *BLANKS
     C                   SETON                                        4219
     C                   END
     C*
     C**  REPORT TYPE IF ENTERED MUST BE 1, 2, OR 3
     C*
     C     SSTYPE        IFNE      *BLANKS
     C     SSTYPE        ANDNE     '1'
     C     SSTYPE        ANDNE     '2'
     C     SSTYPE        ANDNE     '3'
     C                   SETON                                        4280
     C                   END
     C*
     C     *IN38         IFEQ      '0'
     C                   Z-ADD     RRN           SRECNO
     C                   SETON                                        38
     C                   END
     C                   UPDATE    SE120S11
     C                   READC     SE120S11                               99
     C                   END
     C*
     C**  AT LEAST ONE NAME MUST BE ENTERED
     C*
     C     *IN37         IFEQ      '1'
     C                   MOVE      ' 443'        ECODE
     C                   EXSR      ERROR
     C                   Z-ADD     1             SRECNO
     C     1             CHAIN     SE120S11                           99
     C                   SETON                                          41
     C                   UPDATE    SE120S11
     C                   SETOFF                                         41
     C                   END
     C*
     C     *IN80         IFEQ      '1'
     C                   MOVE      ' 453'        ECODE
     C                   EXSR      ERROR
     C                   SETOFF                                         80
     C                   SETON                                        37
     C                   END
     C*
     C     *IN19         IFEQ      '1'
     C                   MOVE      ' 452'        ECODE
     C                   EXSR      ERROR
     C                   SETOFF                                         19
     C                   SETON                                        37
     C                   END
     C*
     C**  FORMAT OPTION IF NO ERRORS
     C*
     C     *IN37         IFEQ      '0'
     C*
     C**  START WITH REPORT OPTION
     C*
     C                   MOVE      *BLANKS       CRD
     C                   MOVEA     EROC          CRD
     C                   Z-ADD     10            Y
     C*
     C**  ADD ALL NUMBERS ENTERED ON SCREEN
     C*
     C                   DO        35            RRN
     C     RRN           CHAIN     SE120S11                           99
     C*
     C     *IN99         IFEQ      '0'
     C     SSNUM         ANDNE     *BLANKS
     C                   MOVEA     ';'           CRD(Y)
     C                   ADD       1             Y
     C*
     C**  REMOVE TRAILING BLANKS
     C*
     C                   MOVEA     SSNUM         WRK12
     C                   Z-ADD     13            XX
     C*
     C                   DO        12
     C                   SUB       1             XX
     C     WRK12(XX)     IFNE      ' '
     C                   SETON                                        99
     C                   END
     C  N99              END
     C*
     C                   SETOFF                                       99
     C                   MOVEA     SSNUM         CRD(Y)
     C                   ADD       XX            Y
     C*
     C     SSTYPE        IFNE      *BLANKS
     C                   MOVEA     ','           CRD(Y)
     C                   ADD       1             Y
     C                   MOVEA     SSTYPE        CRD(Y)
     C                   ADD       1             Y
     C                   END
     C*
     C**  IF TOO MANY ARE SELECTED WRITE TO TRANSMISSION FILE AND START
     C**  AGAIN WITH THE REST
     C*
     C     Y             IFGT      63
     C                   MOVEA     ';END'        CRD(Y)
     C                   MOVEA     CRD           LOTTLX
     C                   SETON                                        81
     C                   EXCEPT
     C                   MOVEA     *BLANKS       CRD(10)
     C                   Z-ADD     10            Y
     C                   END
     C                   END
     C                   END
     C*
     C**  WRITE TO TRANSMISSION FILE
     C*
     C     Y             IFGT      11
     C                   MOVEA     ';END'        CRD(Y)
     C                   MOVEA     CRD           LOTTLX
     C                   SETON                                        81
     C                   EXCEPT
     C                   END
     C*
     C                   SETON                                        85
     C                   SETOFF                                       81
     C*
     C**  SET UP ERROR CODES IF ANY ERRORS
     C*
     C                   ELSE
     C                   MOVEA     ERCD(1)       ERRMG1
     C                   WRITE     ERRFMT
     C                   SETOFF                                       37
     C                   END
     C                   END
     C                   END
     C***********          END                                            S01199
     C*
     C                   SETOFF                                       856956
     C                   WRITE     ERRFMT
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  PASSWD SR. - TO PROCESS OPTION 'P' - CHANGE PASSWORKDS
     C*
     C*  CALLED FROM - RPTOPT
     C*  CALLS       - BLANKS
     C*
     C********************************************************************
     C*
     C     PASSWD        BEGSR                                                  *** PASSWD ***
     C*
     C**  DISPLAY PROMPT SCREEN
     C*
     C                   MOVEA     '0'           *IN(55)
     C                   MOVEA     '000000'      *IN(59)
     C                   MOVE      *BLANKS       SCNTP
     C                   MOVE      *BLANKS       SNNTP
     C                   MOVE      *BLANKS       SNNTP2
     C                   MOVE      *BLANKS       SCECP
     C                   MOVE      *BLANKS       SNECP
     C                   MOVE      *BLANKS       SNECP2
     C                   WRITE     HEADER
     C                   WRITE     FOOTER
     C*                                                                   E19567
     C                   Z-ADD     0             X                                             E1956
     C                   MOVEA     *BLANKS       ERCD                                          E1956
     C                   SETOFF                                       69                       E1956
     C*                                                                   E19567
     C**  CANNOT CHANGE PASSWORD & TRANSMIT AT SAME TIME                  E19567
     C*                                                                   E19567
     C     STDAV         IFEQ      'Y'                                                         E1956
     C                   MOVE      ' 462'        ECODE                                         E1956
     C                   EXSR      ERROR                                                       E1956
     C                   MOVEA     ERCD(1)       ERRMG1                                        E1956
     C                   END                                                                   E1956
     C*
     C     *IN85         DOUEQ     '1'
     C     *IN01         OREQ      '1'
     C************INKB     OREQ '1'                                       S01199
     C     *INKL         OREQ      '1'                                                         S0119
     C*
     C                   EXFMT     SE1200F8
     C*
     C**  PROCESS COMMAND KEYS
     C*
     C************IN22     IFEQ '1'                                       S01199
     C***********          MOVEAERCD      HERCD 160                       S01199
     C***********          MOVEL'SE1200'  HBPGM   6                       S01199
     C***********          CALL 'MHELP'                                   S01199
     C***********          PARM           HBPGM                           S01199
     C***********          PARM           HERCD                           S01199
     C***********          ELSE                                           S01199
     C*
     C                   MOVEA     '000000'      *IN(59)
     C*
     C**  ENTER KEY
     C*
     C     *IN01         IFEQ      '0'
     C*
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C*
     C**  VALIDATE  SCREEN
     C*
     C                   Z-ADD     0             X
     C                   MOVEA     *BLANKS       ERCD
     C                   SETOFF                                       69
     C*
     C**  CANNOT CHANGE PASSWORD & TRANSMIT AT SAME TIME                  E19567
     C*                                                                   E19567
     C     STDAV         IFEQ      'Y'                                                         E1956
     C                   MOVE      ' 462'        ECODE                                         E1956
     C                   EXSR      ERROR                                                       E1956
     C                   END                                                                   E1956
     C*                                                                   E19567
     C**  CURRENT NETWORK PASSWORD MUST EQUAL USER NO. ON FIRST SCREEN
     C*
     C     SCNTP         IFNE      SUSCO
     C                   MOVE      ' 432'        ECODE
     C                   EXSR      ERROR
     C                   SETON                                        59
     C                   END
     C*
     C**  CURRENT EUCLID PASSWORD MUST EQUAL PASSWORD ON FIRST SCREEN
     C*
     C     SCECP         IFNE      SPASS
     C                   MOVE      ' 433'        ECODE
     C                   EXSR      ERROR
     C                   SETON                                        62
     C                   END
     C*
     C**  NEW NETWORK PASSWORD MUST BE AT LEAST 6 LONG AND ALPHANUMERIC
     C**  WITH THE FIRST CHARACTER ALPHABETIC
     C*
     C                   MOVEA     SNNTP         ARR
     C                   EXSR      TEST
     C*
     C     *IN52         IFEQ      '1'
     C                   MOVE      ' 434'        ECODE
     C                   EXSR      ERROR
     C                   SETON                                        60
     C                   END
     C*
     C**  NEW NETWORK PASSWORD MUST BE DIFFERENT FROM CURRENT NETWORK
     C**  PASSWORD
     C*
     C     SNNTP         IFEQ      SCNTP
     C                   MOVE      ' 459'        ECODE
     C                   EXSR      ERROR
     C                   SETON                                        60
     C                   END
     C*
     C**  NEW EUCLID PASSWORD MUST BE DIFFERENT FROM CURRENT EUCLID
     C**  PASSWORD
     C*
     C     SNECP         IFEQ      SCECP
     C                   MOVE      ' 455'        ECODE
     C                   EXSR      ERROR
     C                   SETON                                        63
     C                   END
     C*
     C**  NEW EUCLID PASSWORD MUST BE AT LEAST 6 LONG  AND ALPHANUMERIC
     C**  WITH THE FIRST CHARACTER ALPHABETIC
     C*
     C                   MOVEA     SNECP         ARR
     C                   EXSR      TEST
     C*
     C     *IN52         IFEQ      '1'
     C                   MOVE      ' 435'        ECODE
     C                   EXSR      ERROR
     C                   SETON                                        63
     C                   END
     C*
     C**  NEW EUCLID PASSWORD MUST BE DIFFERENT FROM NEW NETWORK
     C**  PASSWORD
     C*
     C     SNNTP         IFEQ      SNECP
     C                   MOVE      ' 456'        ECODE
     C                   EXSR      ERROR
     C                   SETON                                        6360
     C                   END
     C*
     C**  NEW NETWORK PASSWORD AGAIN MUST EQUAL NEW NETWORK PASSWORD
     C*
     C     SNNTP2        IFNE      SNNTP
     C                   MOVE      ' 437'        ECODE
     C                   EXSR      ERROR
     C                   SETON                                        61
     C                   END
     C*
     C**  NEW EUCLID PASSWORD AGAIN MUST EQUAL NEW EUCLID PASSWORD
     C*
     C     SNECP2        IFNE      SNECP
     C                   MOVE      ' 438'        ECODE
     C                   EXSR      ERROR
     C                   SETON                                        64
     C                   END
     C*
     C**  NEW NETWORK PASSWORD MUST CONTAIN AT LEAST 3 CHARACTERS THAT
     C**  ARE NOT IN CURRENT NETWORK PASSWORD
     C*
     C                   MOVEA     SNNTP         ARR
     C                   MOVEA     SCNTP         PASS
     C*
     C                   Z-ADD     0             DIFF
     C     1             DO        8             XX
     C     ARR(XX)       IFNE      ' '
     C     ARR(XX)       LOOKUP    PASS                                   99
     C     *IN99         IFEQ      '0'
     C                   ADD       1             DIFF              1 0
     C                   END
     C                   END
     C                   END
     C     DIFF          IFLT      3
     C                   MOVE      ' 457'        ECODE
     C                   EXSR      ERROR
     C                   SETON                                        60
     C                   END
     C*
     C**  NEW EUCLID PASSWORD MUST CONTAIN AT LEAST 3 CHARACTERS THAT
     C**  ARE NOT IN CURRENT EUCLID PASSWORD
     C*
     C                   MOVEA     SNECP         ARR
     C                   MOVEA     SCECP         PASS
     C*
     C                   Z-ADD     0             DIFF
     C     1             DO        8             XX
     C     ARR(XX)       IFNE      ' '
     C     ARR(XX)       LOOKUP    PASS                                   99
     C     *IN99         IFEQ      '0'
     C                   ADD       1             DIFF              1 0
     C                   END
     C                   END
     C                   END
     C     DIFF          IFLT      3
     C                   MOVE      ' 458'        ECODE
     C                   EXSR      ERROR
     C                   SETON                                        63
     C                   END
     C*
     C**  IF ANY ERROR SET ERROR CODES
     C*
     C     *IN69         IFEQ      '1'
     C                   MOVEA     ERCD(1)       ERRMG1
     C*
     C                   ELSE
     C*
     C**  FORMAT FOR TRANSMISSION FILE
     C*
     C                   SETON                                        85
     C                   MOVEA     *BLANKS       CRD(1)
     C                   MOVEA     'P;'          CRD(1)
     C*
     C**  REMOVE TRAILING BLANKS FROM EACH ENTRY
     C*
     C                   MOVEA     SCNTP         ARR
     C                   Z-ADD     3             Y
     C                   EXSR      BLANKS
     C*
     C                   MOVEA     SNNTP         ARR
     C                   EXSR      BLANKS
     C*
     C                   MOVEA     ARR           CRD(Y)
     C                   ADD       XX            Y
     C                   MOVEA     ';'           CRD(Y)
     C                   ADD       1             Y
     C*
     C                   MOVEA     SCECP         ARR
     C                   EXSR      BLANKS
     C*
     C                   MOVEA     SNECP         ARR
     C                   EXSR      BLANKS
     C*
     C                   MOVEA     ARR           CRD(Y)
     C*
     C                   EXSR      OUTPUT
     C                   END
     C*
     C                   END
     C                   END
     C***********          END                                            S01199
     C                   SETOFF                                       6985
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  BLANKS SR. - TO GET RID OF TRAILING BLANKS BEFORE WRITING TO
     C*               TRANSMISSION FILE
     C*
     C*  CALLED FROM - PASSWD
     C*
     C********************************************************************
     C*
     C     BLANKS        BEGSR                                                  *** BLANKS ***
     C*
     C                   Z-ADD     9             XX
     C                   DO        8
     C                   SUB       1             XX
     C     ARR(XX)       IFNE      ' '
     C                   SETON                                        99
     C                   END
     C  N99              END
     C                   MOVEA     ARR           CRD(Y)
     C                   ADD       XX            Y
     C                   MOVEA     ';'           CRD(Y)
     C                   ADD       1             Y
     C                   SETOFF                                       99
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  NDATE  SR. - TO PROCESS OPTIONS 'N' 'NA' 'NN' 'NISSP'  -
     C*               NEW ISSUES OF SECURITIES
     C*
     C*  CALLED FROM - RPTOPT
     C*
     C********************************************************************
     C*
     C     NDATE         BEGSR                                                  *** NDATE  ***
     C*
     C**  DISPLAY PROMPT SCREEN
     C*
     C                   MOVEA     '0'           *IN(55)
     C                   MOVEA     '0'           *IN(59)
     C                   MOVE      *BLANKS       SDATE
     C                   WRITE     HEADER
     C                   WRITE     FOOTER
     C*
     C     *IN85         DOUEQ     '1'
     C     *IN01         OREQ      '1'
     C************INKB     OREQ '1'                                       S01199
     C     *INKL         OREQ      '1'                                                         S0119
     C*
     C                   EXFMT     SE120F13
     C*
     C**  PROCESS COMMAND KEYS
     C*
     C************IN22     IFEQ '1'                                       S01199
     C***********          MOVEAERCD      HERCD 160                       S01199
     C***********          MOVEL'SE1200'  HBPGM   6                       S01199
     C***********          CALL 'MHELP'                                   S01199
     C***********          PARM           HBPGM                           S01199
     C***********          PARM           HERCD                           S01199
     C***********          ELSE                                           S01199
     C*
     C                   MOVEA     '0'           *IN(59)
     C*
     C**  ENTER KEY
     C*
     C     *IN01         IFEQ      '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C*
     C**  VALIDATE  SCREEN
     C*
     C                   Z-ADD     0             X
     C                   MOVEA     *BLANKS       ERCD
     C                   SETOFF                                       69
     C*
     C**  ENTRY IS MANDATORY
     C*
     C     SDATE         IFEQ      *BLANKS
     C                   MOVE      ' 445'        ECODE
     C                   EXSR      ERROR
     C*
     C**  ENTRY MUST BE EITHER 'ALL' OR A DATE IN DDMMYY FORMAT NOT
     C**  AFTER THE RUNDATE AND NOT MORE THAN 15 DAYS BEFORE IT.
     C*
     C                   ELSE
     C     SDATE         IFNE      'ALL'
     C                   TESTN                   SDATE                21
     C     *IN21         IFEQ      '0'
     C                   MOVE      ' 446'        ECODE
     C                   EXSR      ERROR
     C                   ELSE
     C                   MOVE      SDATE         ZDATE
     C                   EXSR      ZDATE1
     C     *IN99         IFEQ      '1'
     C                   MOVE      ' 446'        ECODE
     C                   EXSR      ERROR
     C                   ELSE
      *
      **  IF DATE VALID - MUST BE NOT MORE THAN 15 DAYS BEFORE RUN DATE
      **                AND NOT LATER THAN RUN DATE
      *
     C     ZDAYNO        IFLT      RUND15
     C     ZDAYNO        ORGT      RUND
     C                   MOVE      ' 446'        ECODE
     C                   EXSR      ERROR
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
      *
     C     *IN69         IFEQ      '1'
     C                   MOVE      '1'           *IN(59)
     C                   MOVEA     ERCD(1)       ERRMG1
     C*
     C                   ELSE
     C*
     C**  FORMAT FOR TRANSMISSION FILE
     C*
     C                   SETON                                        85
     C                   MOVEA     *BLANKS       CRD(1)
     C                   MOVEA     EROC          CRD(1)
     C*
     C     #RPT          IFEQ      'N       '
     C                   Z-ADD     2             Y
     C                   END
     C     #RPT          IFEQ      'NISSP   '
     C                   Z-ADD     6             Y
     C                   END
     C     #RPT          IFEQ      'NN      '
     C     #RPT          OREQ      'NA      '
     C                   Z-ADD     3             Y
     C                   END
     C*
     C                   MOVEA     ','           CRD(Y)
     C                   ADD       1             Y
     C                   MOVEA     SDATE         CRD(Y)
     C*
     C                   EXSR      OUTPUT
     C                   END
     C*
     C                   END
     C                   END
     C***********          END                                            S01199
     C                   SETOFF                                       6985
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  R30  SR. - TO PROCESS OPTIONS 'RF30' AND 'RP30' -  SECURITIES
     C*             BALANCES
     C*
     C*  CALLED FROM - RPTOPT
     C*
     C********************************************************************
     C*
     C     R30           BEGSR                                                  ***  R30   ***
     C*
     C**  DISPLAY PROMPT SCREEN
     C*
     C                   SETOFF                                       557173
     C                   MOVEA     '000000'      *IN(59)
     C                   MOVE      *BLANKS       SAPOS
     C                   MOVE      *BLANKS       SCPOS
     C                   MOVE      *BLANKS       SSCUR
     C                   MOVE      *BLANKS       SSPOS
     C                   MOVE      *BLANKS       SCUPS
     C                   MOVE      *BLANKS       SALSQ
     C                   MOVE      *BLANKS       SSESQ
     C                   MOVE      *BLANKS       SCUSQ
     C                   WRITE     HEADER
     C                   WRITE     FOOTER
     C*
     C     *IN85         DOUEQ     '1'
     C     *IN01         OREQ      '1'
     C************INKB     OREQ '1'                                       S01199
     C     *INKL         OREQ      '1'                                                         S0119
     C*
     C                   EXFMT     SE1200F7
     C*
     C*
     C**  PROCESS COMMAND KEYS
     C*
     C************IN22     IFEQ '1'                                       S01199
     C***********          MOVEAERCD      HERCD 160                       S01199
     C***********          MOVEL'SE1200'  HBPGM   6                       S01199
     C***********          CALL 'MHELP'                                   S01199
     C***********          PARM           HBPGM                           S01199
     C***********          PARM           HERCD                           S01199
     C***********          ELSE                                           S01199
     C*
     C**  ENTER KEY
     C*
     C     *IN01         IFEQ      '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C*
     C**  VALIDATE  SCREEN
     C*
     C                   Z-ADD     0             X
     C                   MOVEA     *BLANKS       ERCD
     C                   SETOFF                                       697173
     C                   MOVEA     '000000'      *IN(59)
     C*
     C**  ONE AND ONLY ONE  REPORT MUST BE SELECTED
     C*
     C     SAPOS         IFEQ      *BLANKS
     C     SCPOS         ANDEQ     *BLANKS
     C     SSCUR         ANDEQ     *BLANKS
     C     SSPOS         ANDEQ     *BLANKS
     C                   MOVE      ' 425'        ECODE
     C                   EXSR      ERROR
     C                   MOVEA     '1111'        *IN(59)
     C                   ELSE
     C     SAPOS         IFNE      *BLANKS
     C     SCPOS         IFNE      *BLANKS
     C     SSCUR         ORNE      *BLANKS
     C     SSPOS         ORNE      *BLANKS
     C                   MOVEA     '1'           *IN(59)
     C                   END
     C                   END
     C     SCPOS         IFNE      *BLANKS
     C     SAPOS         IFNE      *BLANKS
     C     SSCUR         ORNE      *BLANKS
     C     SSPOS         ORNE      *BLANKS
     C                   MOVEA     '1'           *IN(60)
     C                   END
     C                   END
     C     SSCUR         IFNE      *BLANKS
     C     SAPOS         IFNE      *BLANKS
     C     SCPOS         ORNE      *BLANKS
     C     SSPOS         ORNE      *BLANKS
     C                   MOVEA     '1'           *IN(61)
     C                   END
     C                   END
     C     SSPOS         IFNE      *BLANKS
     C     SAPOS         IFNE      *BLANKS
     C     SCPOS         ORNE      *BLANKS
     C     SSCUR         ORNE      *BLANKS
     C                   MOVEA     '1'           *IN(62)
     C                   END
     C                   END
     C     *IN59         IFEQ      '1'
     C     *IN60         OREQ      '1'
     C     *IN61         OREQ      '1'
     C     *IN62         OREQ      '1'
     C                   MOVE      ' 424'        ECODE
     C                   EXSR      ERROR
     C                   END
     C                   END
     C*
     C**  REST OF VALIDATION ONLY IF OPTION IS RF30
     C*
     C     *IN72         IFEQ      '1'
     C*
     C**  SPECIFIC CURRENCY/POSITION ENTERED BUT NEITHER SPECIFIC
     C**  CURRENCY NOR SPECIFIC REPORT REQUESTED
     C*
     C     SCUPS         IFNE      *BLANKS
     C     SSCUR         IFEQ      *BLANKS
     C     SSPOS         ANDEQ     *BLANKS
     C                   SETON                                        73
     C                   MOVE      ' 426'        ECODE
     C                   EXSR      ERROR
     C                   END
     C*
     C**  SPECIFIC CURRENCY/POSITION NOT ENTERED BUT EITHER SPECIFIC
     C**  CURRENCY OR SPECIFIC REPORT REQUESTED
     C*
     C                   ELSE
     C     SSCUR         IFNE      *BLANKS
     C     SSPOS         ORNE      *BLANKS
     C                   SETON                                        73
     C                   MOVE      ' 427'        ECODE
     C                   EXSR      ERROR
     C                   END
     C                   END
     C*
     C**  REPORT SEQUENCE :
     C*
     C**  NO SELECTION ALLOWED IF SPECIFIC POSITION REQUESTED
     C*
     C     SSPOS         IFNE      *BLANKS
     C     SALSQ         IFNE      *BLANKS
     C                   SETON                                        63
     C                   END
     C     SSESQ         IFNE      *BLANKS
     C                   SETON                                        64
     C                   END
     C     SCUSQ         IFNE      *BLANKS
     C                   SETON                                        71
     C                   END
     C     *IN63         IFEQ      '1'
     C     *IN64         OREQ      '1'
     C     *IN71         OREQ      '1'
     C                   MOVE      ' 430'        ECODE
     C                   EXSR      ERROR
     C                   END
     C                   ELSE
     C*
     C**  ONE AND ONLY ONE SEQUENCE MUST BE SELECTED
     C*
     C     SALSQ         IFEQ      *BLANKS
     C     SSESQ         ANDEQ     *BLANKS
     C     SCUSQ         ANDEQ     *BLANKS
     C                   MOVE      ' 428'        ECODE
     C                   EXSR      ERROR
     C                   MOVEA     '11'          *IN(63)
     C                   MOVEA     '1'           *IN(71)
     C                   ELSE
     C     SALSQ         IFNE      *BLANKS
     C     SSESQ         IFNE      *BLANKS
     C     SCUSQ         ORNE      *BLANKS
     C                   MOVEA     '1'           *IN(63)
     C                   END
     C                   END
     C     SSESQ         IFNE      *BLANKS
     C     SALSQ         IFNE      *BLANKS
     C     SCUSQ         ORNE      *BLANKS
     C                   MOVEA     '1'           *IN(64)
     C                   END
     C                   END
     C     SCUSQ         IFNE      *BLANKS
     C     SALSQ         IFNE      *BLANKS
     C     SSESQ         ORNE      *BLANKS
     C                   MOVEA     '1'           *IN(71)
     C                   END
     C                   END
     C     *IN63         IFEQ      '1'
     C     *IN64         OREQ      '1'
     C     *IN71         OREQ      '1'
     C                   MOVE      ' 429'        ECODE
     C                   EXSR      ERROR
     C                   END
     C     SSCUR         IFNE      *BLANKS
     C     SCUSQ         ANDNE     *BLANKS
     C                   MOVE      ' 431'        ECODE
     C                   EXSR      ERROR
     C                   MOVEA     '1'           *IN(71)
     C                   END
     C                   END
     C                   END
     C*
     C                   END
     C*
     C**  IF ANY ERROR SET UP ERROR CODES
     C*
     C     *IN69         IFEQ      '1'
     C                   MOVEA     ERCD(1)       ERRMG1
     C*
     C                   ELSE
     C*
     C**  FORMAT FOR TRANSMISSION FILE
     C*
     C                   SETON                                        85
     C                   MOVEA     *BLANKS       CRD(1)
     C                   MOVEA     EROC          CRD(1)
     C                   Z-ADD     5             Y
     C*
     C     SAPOS         IFNE      *BLANKS
     C                   MOVEA     'A'           CRD(Y)
     C                   END
     C     SCPOS         IFNE      *BLANKS
     C                   MOVEA     'N'           CRD(Y)
     C                   END
     C*
     C     *IN72         IFEQ      '1'
     C*
     C     SSCUR         IFNE      *BLANKS
     C                   MOVEA     'C'           CRD(Y)
     C                   END
     C     SSPOS         IFNE      *BLANKS
     C                   MOVEA     'O'           CRD(Y)
     C                   END
     C                   ADD       1             Y
     C*
     C     SCUPS         IFNE      *BLANKS
     C                   MOVEA     SCUPS         WRK12
     C                   Z-ADD     13            XX
     C                   DO        12
     C                   SUB       1             XX
     C     WRK12(XX)     IFNE      ' '
     C                   SETON                                        99
     C                   END
     C  N99              END
     C*
     C                   SETOFF                                       99
     C                   MOVEA     ';'           CRD(Y)
     C                   ADD       1             Y
     C                   MOVEA     SCUPS         CRD(Y)
     C                   ADD       XX            Y
     C                   END
     C*
     C     SALSQ         IFNE      *BLANKS
     C                   MOVEA     ';NAME'       CRD(Y)
     C                   ADD       5             Y
     C                   END
     C     SSESQ         IFNE      *BLANKS
     C                   MOVEA     ';NUM'        CRD(Y)
     C                   ADD       4             Y
     C                   END
     C     SCUSQ         IFNE      *BLANKS
     C                   MOVEA     ';CUR'        CRD(Y)
     C                   ADD       4             Y
     C                   END
     C*
     C                   MOVEA     ';END'        CRD(Y)
     C                   END
     C*
     C                   EXSR      OUTPUT
     C                   END
     C*
     C                   END
     C                   END
     C***********          END                                            S01199
     C                   SETOFF                                       6985
     C                   MOVEA     '000000'      *IN(59)
     C                   MOVEA     '000'         *IN(71)
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  IREF  SR. - TO PROCESS OPTION  'IREFC' -  REFERENCE ENQUIRY
     C*              OF UNEXECUTED INSTRUCTIONS
     C*
     C*  CALLED FROM - RPTOPT
     C*
     C********************************************************************
     C*
     C     IREF          BEGSR                                                  *** IREF   ***
     C*
     C                   SETOFF                                       55
     C                   MOVEA     '00'          *IN(59)
     C                   MOVE      *BLANKS       SEREF1
     C                   MOVE      *BLANKS       SEREF2
     C                   MOVE      *BLANKS       SEREF3
     C                   MOVE      *BLANKS       SEREF4
     C                   MOVE      *BLANKS       SEREF5
     C                   MOVE      *BLANKS       SERNGE
     C                   WRITE     HEADER
     C                   WRITE     FOOTER
     C*
     C     *IN85         DOUEQ     '1'
     C     *IN01         OREQ      '1'
     C************INKB     OREQ '1'                                       S01199
     C     *INKL         OREQ      '1'                                                         S0119
     C*
     C                   EXFMT     SE120F14
     C*
     C*
     C**  PROCESS COMMAND KEYS
     C*
     C************IN22     IFEQ '1'                                       S01199
     C***********          MOVEAERCD      HERCD 160                       S01199
     C***********          MOVEL'SE1200'  HBPGM   6                       S01199
     C***********          CALL 'MHELP'                                   S01199
     C***********          PARM           HBPGM                           S01199
     C***********          PARM           HERCD                           S01199
     C***********          ELSE                                           S01199
     C*
     C**  ENTER KEY
     C*
     C     *IN01         IFEQ      '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C*
     C**  VALIDATE  SCREEN
     C*
     C                   Z-ADD     0             X
     C                   MOVEA     *BLANKS       ERCD
     C                   SETOFF                                       69
     C                   MOVEA     '00'          *IN(59)
     C*
     C**  E/C REFERENCE NO. 1 -  ENTRY IS MANDATORY
     C*
     C     SEREF1        IFEQ      *BLANKS
     C                   MOVE      ' 447'        ECODE
     C                   EXSR      ERROR
     C                   SETON                                        59
     C                   END
     C*
     C**  E/C REFERENCE UPPER RANGE - ENTRY IS PROHIBITED UNLESS
     C**  ONLY THE FIRST E/C REFERENCE NO. IS ENTERED
     C*
     C     SERNGE        IFNE      *BLANKS
     C     SEREF2        IFNE      *BLANKS
     C     SEREF3        ORNE      *BLANKS
     C     SEREF4        ORNE      *BLANKS
     C     SEREF5        ORNE      *BLANKS
     C                   MOVE      ' 448'        ECODE
     C                   EXSR      ERROR
     C                   SETON                                        60
     C                   END
     C                   END
     C*
     C**  IF ANY ERROR SET UP ERROR CODES
     C*
     C     *IN69         IFEQ      '1'
     C                   MOVEA     ERCD(1)       ERRMG1
     C*
     C                   ELSE
     C*
     C**  FORMAT FOR TRANSMISSION FILE
     C*
     C                   SETON                                        85
     C                   MOVEA     *BLANKS       CRD(1)
     C                   MOVEA     EROC          CRD(1)
     C                   Z-ADD     6             Y
     C                   MOVEA     ';'           CRD(Y)
     C                   ADD       1             Y
     C                   MOVEA     SEREF1        CRD(Y)
     C                   ADD       7             Y
     C     SERNGE        IFNE      *BLANKS
     C                   MOVEA     ':'           CRD(Y)
     C                   ADD       1             Y
     C                   MOVEA     SERNGE        CRD(Y)
     C                   ADD       7             Y
     C                   END
     C     SEREF2        IFNE      *BLANKS
     C                   MOVEA     ','           CRD(Y)
     C                   ADD       1             Y
     C                   MOVEA     SEREF2        CRD(Y)
     C                   ADD       7             Y
     C                   END
     C     SEREF3        IFNE      *BLANKS
     C                   MOVEA     ','           CRD(Y)
     C                   ADD       1             Y
     C                   MOVEA     SEREF3        CRD(Y)
     C                   ADD       7             Y
     C                   END
     C     SEREF4        IFNE      *BLANKS
     C                   MOVEA     ','           CRD(Y)
     C                   ADD       1             Y
     C                   MOVEA     SEREF4        CRD(Y)
     C                   ADD       7             Y
     C                   END
     C     SEREF5        IFNE      *BLANKS
     C                   MOVEA     ','           CRD(Y)
     C                   ADD       1             Y
     C                   MOVEA     SEREF5        CRD(Y)
     C                   END
     C*
     C                   EXSR      OUTPUT
     C                   END
     C*
     C                   END
     C                   END
     C**********           END                                            S01199
     C                   SETOFF                                       6985
     C                   MOVEA     '00'          *IN(59)
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  LOGFL SR. - TO PROCESS OPTION  'LOGFAIL' -  FAILED ATTEMPT
     C*              TO LOG ON USING BANKS USER NUMBER
     C*
     C*  CALLED FROM - RPTOPT
     C*
     C********************************************************************
     C*
     C     LOGFL         BEGSR                                                  *** LOGFL  ***
     C*
     C                   SETOFF                                       55
     C                   MOVEA     '00'          *IN(59)
     C                   MOVE      *BLANKS       STDATE
     C                   MOVE      *BLANKS       ENDDT
     C                   WRITE     HEADER
     C                   WRITE     FOOTER
     C*
     C     *IN85         DOUEQ     '1'
     C     *IN01         OREQ      '1'
     C************INKB     OREQ '1'                                       S01199
     C     *INKL         OREQ      '1'                                                         S0119
     C*
     C                   EXFMT     SE120F16
     C*
     C*
     C**  PROCESS COMMAND KEYS
     C*
     C************IN22     IFEQ '1'                                       S01199
     C***********          MOVEAERCD      HERCD 160                       S01199
     C***********          MOVEL'SE1200'  HBPGM   6                       S01199
     C***********          CALL 'MHELP'                                   S01199
     C***********          PARM           HBPGM                           S01199
     C***********          PARM           HERCD                           S01199
     C***********          ELSE                                           S01199
     C*
     C**  ENTER KEY
     C*
     C     *IN01         IFEQ      '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C*
     C**  VALIDATE  SCREEN
     C*
     C                   Z-ADD     0             X
     C                   MOVEA     *BLANKS       ERCD
     C                   SETOFF                                       69
     C                   MOVEA     '00'          *IN(59)
     C*
     C**  START DATE  -  ENTRY MUST BE A DATE (DDMMYY) NOT MORE THAN
     C**  ONE MONTH BEFORE RUN DATE AND NOT AFTER RUN DATE
     C*
     C     STDATE        IFEQ      *BLANKS
     C                   SETON                                        59
     C                   ELSE
     C                   TESTN                   STDATE               21
     C     *IN21         IFEQ      '0'
     C                   SETON                                        59
     C                   ELSE
     C                   MOVE      STDATE        ZDATE
     C                   EXSR      ZDATE1
     C     *IN99         IFEQ      '1'
     C                   SETON                                        59
     C                   ELSE
      *
      **  IF DATE VALID - MUST BE NOT MORE THAN ONE CALENDAR MONTH
      **                  BEFORE AND NOT LATER THAN RUN DATE
      *
     C     ZDAYNO        IFGT      RUND
     C                   SETON                                        59
     C                   ELSE
     C     MTH           IFEQ      'MAR'
     C                   Z-ADD     28            DATCHK            2 0
     C*
     C**  IF IT IS A LEAP YEAR, ADD ONE FOR 29TH OF FEBRUARY
     C*
     C     ZLY           IFEQ      0
     C                   ADD       1             DATCHK
     C                   END
     C                   ELSE
     C     MTH           IFEQ      'OCT'
     C     MTH           OREQ      'MAY'
     C     MTH           OREQ      'JUL'
     C     MTH           OREQ      'DEC'
     C                   Z-ADD     30            DATCHK
     C                   ELSE
     C                   Z-ADD     31            DATCHK
     C                   END
     C                   END
     C     RUND          SUB       DATCHK        LMTH              5 0
     C     ZDAYNO        IFLT      LMTH
     C                   SETON                                        59
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C     *IN59         IFEQ      '1'
     C                   MOVE      ' 460'        ECODE
     C                   EXSR      ERROR
     C                   ELSE
     C                   Z-ADD     ZDAYNO        STDYNO            5 0
     C                   END
     C*
     C**  END DATE  -  ENTRY MUST BE A DATE (DDMMYY) NOT BEFORE THE
     C**  START DATE AND NOT AFTER RUN DATE
     C*
     C     ENDDT         IFEQ      *BLANKS
     C                   SETON                                        60
     C                   ELSE
     C                   TESTN                   ENDDT                21
     C     *IN21         IFEQ      '0'
     C                   SETON                                        60
     C                   ELSE
     C                   MOVE      ENDDT         ZDATE
     C                   EXSR      ZDATE1
     C     *IN99         IFEQ      '1'
     C                   SETON                                        60
     C                   ELSE
      *
      **  IF DATE VALID - MUST NOT BE BEFORE START DATE
      **                  AND NOT LATER THAN RUN DATE
      *
     C     ZDAYNO        IFGT      RUND
     C     ZDAYNO        ORLT      STDYNO
     C                   SETON                                        60
     C                   END
     C                   END
     C                   END
     C                   END
     C     *IN60         IFEQ      '1'
     C                   MOVE      ' 461'        ECODE
     C                   EXSR      ERROR
     C                   END
     C*
     C**  IF ANY ERROR SET UP ERROR CODES
     C*
     C     *IN69         IFEQ      '1'
     C                   MOVEA     ERCD(1)       ERRMG1
     C                   WRITE     ERRFMT
     C*
     C                   ELSE
     C*
     C**  FORMAT FOR TRANSMISSION FILE
     C*
     C                   SETON                                        85
     C                   MOVEA     *BLANKS       CRD(1)
     C                   MOVEA     EROC          CRD(1)
     C                   Z-ADD     8             Y
     C                   MOVEA     ';'           CRD(Y)
     C                   ADD       1             Y
     C                   MOVEA     STDATE        CRD(Y)
     C                   ADD       6             Y
     C                   MOVEA     ';'           CRD(Y)
     C                   ADD       1             Y
     C                   MOVEA     ENDDT         CRD(Y)
     C                   ADD       6             Y
     C                   MOVEA     ';END'        CRD(Y)
     C                   EXSR      OUTPUT
     C*
     C                   END
     C*
     C                   END
     C                   END
     C***********          END                                            S01199
     C                   SETOFF                                       6985
     C                   WRITE     ERRFMT
     C                   MOVEA     '00'          *IN(59)
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  FORMAT SR. - TO FORMAT REPORT COMMAND FOR
     C*               TRANSMISSION FILE
     C*
     C*  CALLED FROM -  RPTOPT
     C*
     C********************************************************************
     C*
     C     FORMAT        BEGSR                                                  *** FORMAT ***
     C*
     C*
     C                   MOVE      *BLANKS       CRD
     C*
     C     STITL         IFEQ      HEAD(1)
     C                   MOVEA     'PRODUCE,'    CRD(1)
     C                   Z-ADD     9             Y
     C                   END
     C*
     C     STITL         IFEQ      HEAD(2)
     C                   MOVEA     'SCHEDULE'    CRD(1)
     C                   MOVEA     ';A;'         CRD(9)
     C                   Z-ADD     12            Y
     C                   END
     C*
     C     STITL         IFEQ      HEAD(3)
     C     STITL         OREQ      HEAD(7)
     C                   MOVEA     'LIST,'       CRD(1)
     C                   Z-ADD     6             Y
     C                   END
     C*
     C     STITL         IFEQ      HEAD(4)
     C                   MOVEA     'SCHEDULE'    CRD(1)
     C                   MOVEA     ';R;'         CRD(9)
     C                   Z-ADD     12            Y
     C                   END
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  FORTYP SR. - TO FORMAT REPORT TYPE INFORMATION FOR
     C*               TRANSMISSION FILE
     C*
     C*  CALLED FROM -  RPTOPT
     C*
     C********************************************************************
     C*
     C     FORTYP        BEGSR                                                  *** FORTYP ***
     C*
     C     #RPT          IFEQ      'RP14    '
     C                   MOVEA     'A'           CRD(Y)
     C                   ADD       1             Y
     C                   ELSE
     C     #RPT          IFNE      'IKEY    '
     C     #RPT          ANDNE     'ISTA    '
     C                   MOVEA     SRPSC         CRD(Y)
     C                   ADD       1             Y
     C                   END
     C                   END
     C     #RPT          IFEQ      'RC10    '
     C     #RPT          OREQ      'RF13    '
     C                   MOVEA     'B'           CRD(Y)
     C                   ELSE
     C     #RPT          IFEQ      'RF15    '
     C     #RPT          OREQ      'RF01    '
     C                   MOVEA     'C'           CRD(Y)
     C                   ELSE
     C                   MOVEA     SRPLT         CRD(Y)
     C                   END
     C                   END
     C                   ADD       1             Y
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  FORTIM SR. - TO FORMAT SCHEDULE TIME INFORMATION FOR
     C*               TRANSMISSION FILE
     C*
     C*  CALLED FROM - RPTOPT
     C*
     C********************************************************************
     C*
     C     FORTIM        BEGSR                                                  *** FORTIM ***
     C*
     C                   Z-ADD     Y             XX
     C                   Z-ADD     0             YY                1 0
     C*
     C     SMAT1         IFNE      *BLANKS
     C                   MOVEA     ',MAT1'       CRD(Y)
     C                   ADD       5             Y
     C                   ADD       1             YY
     C                   END
     C*
     C     SMAT2         IFNE      *BLANKS
     C                   EXSR      FOROPT
     C                   MOVEA     ',MAT2'       CRD(Y)
     C                   ADD       5             Y
     C                   ADD       1             YY
     C                   END
     C*
     C     SMAT3         IFNE      *BLANKS
     C                   EXSR      FOROPT
     C                   MOVEA     ',MAT3'       CRD(Y)
     C                   ADD       5             Y
     C                   ADD       1             YY
     C                   END
     C*
     C     SMAT4         IFNE      *BLANKS
     C                   EXSR      FOROPT
     C                   MOVEA     ',MAT4'       CRD(Y)
     C                   ADD       5             Y
     C                   ADD       1             YY
     C                   END
     C*
     C     SSET1         IFNE      *BLANKS
     C                   EXSR      FOROPT
     C                   MOVEA     ',SET1'       CRD(Y)
     C                   ADD       5             Y
     C                   END
     C*
     C     SLAT          IFNE      *BLANKS
     C                   ADD       1             Y
     C                   MOVEA     ';'           CRD(Y)
     C                   END
     C*
     C     STITL         IFEQ      HEAD(1)
     C     STITL         OREQ      HEAD(3)
     C     STITL         OREQ      HEAD(7)
     C                   MOVEA     ';'           CRD(XX)
     C                   END
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  FOROPT SR. - TO FORMAT RECEIVE OPTIONS FOR ADDING OR REMOVING
     C*               SCHEDULING
     C*
     C*  CALLED FROM - SCHED
     C*
     C********************************************************************
     C*
     C     FOROPT        BEGSR                                                  *** FOROPT ***
     C*
     C     YY            IFGT      0
     C                   MOVEA     ';'           CRD(Y)
     C                   ADD       1             Y
     C                   MOVE      *BLANKS       ARR
     C     XX            SUB       #SVY          YX                1 0
     C                   ADD       1             YX
     C                   MOVEA     CRD(#SVY)     ARR
     C                   MOVEA     *BLANKS       ARR(YX)
     C                   MOVEA     ARR           CRD(Y)
     C                   ADD       YX            Y
     C                   SUB       1             Y
     C                   END
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  FORSTS SR. - TO FORMAT STATUS SELECTIONS FOR TRANSMISSION
     C*               FILE
     C*
     C*  CALLED FROM - RPTOPT
     C*
     C********************************************************************
     C*
     C     FORSTS        BEGSR                                                  *** FORSTS ***
     C*
     C                   Z-ADD     Y             X
     C*
     C     #RPT          IFEQ      'RP01    '
     C     #RPT          OREQ      'RF01    '
     C*
     C     SVAL          IFNE      *BLANKS
     C                   MOVEA     ' VAL'        CRD(Y)
     C                   ADD       4             Y
     C                   END
     C     SCAN          IFNE      *BLANKS
     C                   MOVEA     ',CAN'        CRD(Y)
     C                   ADD       4             Y
     C                   END
     C     SMOD          IFNE      *BLANKS
     C                   MOVEA     ',MOD'        CRD(Y)
     C                   ADD       4             Y
     C                   END
     C*
     C                   ELSE
     C*
     C     SMATC         IFNE      *BLANKS
     C                   MOVEA     ',MATC'       CRD(Y)
     C                   ADD       5             Y
     C                   END
     C     SFUT          IFNE      *BLANKS
     C                   MOVEA     ',FUT'        CRD(Y)
     C                   ADD       4             Y
     C                   END
     C     SADV1         IFNE      *BLANKS
     C                   MOVEA     ',ADV1'       CRD(Y)
     C                   ADD       5             Y
     C                   END
     C     SADV2         IFNE      *BLANKS
     C                   MOVEA     ',ADV2'       CRD(Y)
     C                   ADD       5             Y
     C                   END
     C     SADV          IFNE      *BLANKS
     C                   MOVEA     ',ADV'        CRD(Y)
     C                   ADD       4             Y
     C                   END
     C     SCXLC         IFNE      *BLANKS
     C                   MOVEA     ',CXLC'       CRD(Y)
     C                   ADD       5             Y
     C                   END
     C     SCXLB         IFNE      *BLANKS
     C                   MOVEA     ',CXLB'       CRD(Y)
     C                   ADD       5             Y
     C                   END
     C*
     C     #RPT          IFNE      'INOTE'
     C*
     C     SCXLP         IFNE      *BLANKS
     C                   MOVEA     ',CXLP'       CRD(Y)
     C                   ADD       5             Y
     C                   END
     C     SUNM          IFNE      *BLANKS
     C                   MOVEA     ',UNM'        CRD(Y)
     C                   ADD       4             Y
     C                   END
     C     SUNM1         IFNE      *BLANKS
     C                   MOVEA     ',UNM1'       CRD(Y)
     C                   ADD       5             Y
     C                   END
     C     SUNM2         IFNE      *BLANKS
     C                   MOVEA     ',UNM2'       CRD(Y)
     C                   ADD       5             Y
     C                   END
     C     SGLOB         IFNE      *BLANKS
     C                   MOVEA     ',GLOB'       CRD(Y)
     C                   ADD       5             Y
     C                   END
     C     SLIMB         IFNE      *BLANKS
     C                   MOVEA     ',LIMB'       CRD(Y)
     C                   ADD       5             Y
     C                   END
     C     SUSEC         IFNE      *BLANKS
     C                   MOVEA     ',USEC'       CRD(Y)
     C                   ADD       5             Y
     C                   END
     C     SCSEC         IFNE      *BLANKS
     C                   MOVEA     ',CSEC'       CRD(Y)
     C                   ADD       5             Y
     C                   END
     C     SNTEN         IFNE      *BLANKS
     C                   MOVEA     ',NTEN'       CRD(Y)
     C                   ADD       5             Y
     C                   END
     C     SPROV         IFNE      *BLANKS
     C                   MOVEA     ',PROV'       CRD(Y)
     C                   ADD       5             Y
     C                   END
     C     STRSH         IFNE      *BLANKS
     C                   MOVEA     ',TRSH'       CRD(Y)
     C                   ADD       5             Y
     C                   END
     C     SOTH          IFNE      *BLANKS
     C                   MOVEA     ',OTH'        CRD(Y)
     C                   ADD       4             Y
     C                   END
     C     STRDIF        IFNE      *BLANKS
     C                   MOVEA     ',TRDIF'      CRD(Y)
     C                   ADD       6             Y
     C                   END
     C     SBNRP         IFNE      *BLANKS
     C                   MOVEA     ',BNRP'       CRD(Y)
     C                   ADD       5             Y
     C                   END
     C     SBSEC         IFNE      *BLANKS
     C                   MOVEA     ',BSEC'       CRD(Y)
     C                   ADD       5             Y
     C                   END
     C     SBCXL         IFNE      *BLANKS
     C                   MOVEA     ',BCXL'       CRD(Y)
     C                   ADD       5             Y
     C                   END
     C     SBDEN         IFNE      *BLANKS
     C                   MOVEA     ',BDEN'       CRD(Y)
     C                   ADD       5             Y
     C                   END
     C*
     C                   END
     C                   END
     C*
     C     XX            IFGT      0
     C                   MOVEA     ';'           CRD(X)
     C                   END
     C*
     C     #RPT          IFEQ      'IKEY    '
     C     #RPT          OREQ      'INOTE   '
     C                   MOVEA     ';GO;;'       CRD(Y)
     C                   END
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  FORURF SR. - TO FORMAT USER REFERENCES FOR TRANSMISSION
     C*               FILE
     C*
     C*  CALLED FROM -  RPTOPT
     C*
     C********************************************************************
     C*
     C     FORURF        BEGSR                                                  *** FORURF ***
     C*
     C     SUREF1        IFEQ      'ALL  '
     C     XX            IFGT      0
     C                   MOVEA     ';;;;;;;'     CRD(Y)
     C                   ADD       7             Y
     C                   ELSE
     C                   MOVEA     ';ALL'        CRD(Y)
     C                   ADD       4             Y
     C                   END
     C                   ELSE
     C                   MOVEA     ';'           CRD(Y)
     C                   ADD       1             Y
     C                   MOVEA     SUREF1        CRD(Y)
     C                   ADD       5             Y
     C     SUREF2        IFNE      *BLANKS
     C                   MOVEA     ','           CRD(Y)
     C                   ADD       1             Y
     C                   MOVEA     SUREF2        CRD(Y)
     C                   ADD       5             Y
     C                   END
     C     SUREF3        IFNE      *BLANKS
     C                   MOVEA     ','           CRD(Y)
     C                   ADD       1             Y
     C                   MOVEA     SUREF3        CRD(Y)
     C                   ADD       5             Y
     C                   END
     C     SUREF4        IFNE      *BLANKS
     C                   MOVEA     ','           CRD(Y)
     C                   ADD       1             Y
     C                   MOVEA     SUREF4        CRD(Y)
     C                   ADD       5             Y
     C                   END
     C     SUREF5        IFNE      *BLANKS
     C                   MOVEA     ','           CRD(Y)
     C                   ADD       1             Y
     C                   MOVEA     SUREF5        CRD(Y)
     C                   ADD       5             Y
     C                   END
     C     XX            IFGT      0
     C                   MOVEA     ';;;;;;'      CRD(Y)
     C                   ADD       7             Y
     C                   END
     C                   END
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  FORDAY SR. - TO FORMAT DAY SELECTION FOR TRANSMISSION
     C*               FILE
     C*
     C*  CALLED FROM -  RPTOPT
     C*
     C********************************************************************
     C*
     C     FORDAY        BEGSR                                                  *** FORDAY ***
     C*
     C     STODAY        IFNE      *BLANKS
     C                   MOVEA     'T'           CRD(Y)
     C                   ADD       1             Y
     C                   END
     C     SYESTR        IFNE      *BLANKS
     C                   MOVEA     'Y'           CRD(Y)
     C                   ADD       1             Y
     C                   END
     C     SDBYES        IFNE      *BLANKS
     C                   MOVEA     'D'           CRD(Y)
     C                   ADD       1             Y
     C                   END
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  STAND  SR. - TO FORMAT STAND OPTIONS FOR TRANSMISSION FILE
     C*
     C*  CALLED FROM -  RPTOPT
     C*
     C********************************************************************
     C*
     C     STAND         BEGSR                                                  *** STAND  ***
     C*
     C     STITL         IFEQ      HEAD(5)
     C                   MOVEA     'STAND;A;'    CRD(1)
     C                   Z-ADD     9             Y
     C                   ELSE
     C     STITL         IFEQ      HEAD(6)
     C                   MOVEA     'STAND;R;'    CRD(1)
     C                   Z-ADD     9             Y
     C                   ELSE
     C                   Z-ADD     1             Y
     C                   END
     C                   END
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  OUTPUT SR. - TO WRITE TO TRANSMISSION FILE
     C*
     C********************************************************************
     C*
     C     OUTPUT        BEGSR                                                  *** OUTPUT ***
     C*
     C                   MOVEA     CRD           LOTTLX
     C                   SETON                                        81
     C                   EXCEPT
     C                   SETOFF                                       81
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  PRMPT3 SR. - TO DISPLAY AND VALIDATE PROMPT SCREEN 3
     C*
     C*
     C*  CALLED FROM - RPTOPT
     C*
     C********************************************************************
     C*
     C     PRMPT3        BEGSR                                                  *** PRMPT3 ***
     C*
     C                   SETOFF                                       5547
     C                   MOVEA     '00'          *IN(59)
     C                   MOVEA     '00'          *IN(67)
     C                   MOVE      *BLANKS       SRPSC
     C                   MOVE      *BLANKS       SRPLT
     C                   WRITE     HEADER
     C                   WRITE     FOOTER
     C     #RPT          IFEQ      'RF01    '
     C     #RPT          OREQ      'RC10    '
     C     #RPT          OREQ      'RF13    '
     C     #RPT          OREQ      'RF15    '
     C                   SETON                                        67
     C                   ELSE
     C     #RPT          IFEQ      'RP14    '
     C     #RPT          OREQ      'ISTA    '
     C     #RPT          OREQ      'IKEY    '
     C                   SETON                                        68
     C                   ELSE
     C                   SETON                                        6867
     C                   END
     C                   END
     C*
     C     *IN85         DOUEQ     '1'
     C     *IN01         OREQ      '1'
     C************INKB     OREQ '1'                                       S01199
     C     *INKL         OREQ      '1'                                                         S0119
     C*
     C                   EXFMT     SE1200F3
     C*
     C*
     C**  PROCESS COMMAND KEYS
     C*
     C************IN22     IFEQ '1'                                       S01199
     C***********          MOVEAERCD      HERCD 160                       S01199
     C***********          MOVEL'SE1200'  HBPGM   6                       S01199
     C***********          CALL 'MHELP'                                   S01199
     C***********          PARM           HBPGM                           S01199
     C***********          PARM           HERCD                           S01199
     C***********          ELSE                                           S01199
     C*
     C**  ENTER KEY
     C*
     C     *IN01         IFEQ      '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C*
     C**  VALIDATE  SCREEN
     C*
     C                   Z-ADD     0             X
     C                   MOVEA     *BLANKS       ERCD
     C                   SETOFF                                       69
     C                   MOVEA     '00'          *IN(59)
     C*
     C**  VALIDATE 'SCOPE OF REPORT'
     C*
     C     *IN67         IFEQ      '1'
     C     SRPSC         IFNE      'A'
     C     SRPSC         ANDNE     'U'
     C                   MOVE      ' 415'        ECODE
     C                   EXSR      ERROR
     C                   SETON                                        59
     C                   END
     C                   END
     C*
     C**  VALIDATE 'LAYOUT OF REPORT'
     C*
     C     *IN68         IFEQ      '1'
     C*
     C     #RPT          IFEQ      'RP11    '
     C     #RPT          OREQ      'RP12    '
     C*
     C     SRPLT         IFNE      'C'
     C     SRPLT         ANDNE     'B'
     C     SRPLT         ANDNE     'T'
     C     SRPLT         ANDNE     'S'
     C                   MOVE      ' 416'        ECODE
     C                   EXSR      ERROR
     C                   SETON                                        60
     C                   END
     C*
     C                   END
     C*
     C     #RPT          IFEQ      'RP01    '
     C*
     C     SRPLT         IFNE      'C'
     C     SRPLT         ANDNE     'S'
     C                   MOVE      ' 418'        ECODE
     C                   EXSR      ERROR
     C                   SETON                                        60
     C                   END
     C*
     C                   END
     C*
     C     #RPT          IFEQ      'RF11    '
     C     #RPT          OREQ      'RF12    '
     C     #RPT          OREQ      'ISTA    '
     C     #RPT          OREQ      'IKEY    '
     C*
     C     SRPLT         IFNE      'C'
     C     SRPLT         ANDNE     'B'
     C                   MOVE      ' 417'        ECODE
     C                   EXSR      ERROR
     C                   SETON                                        60
     C                   END
     C*
     C                   END
     C*
     C     #RPT          IFEQ      'RP13    '
     C     #RPT          OREQ      'RP14    '
     C*
     C     SRPLT         IFNE      'B'
     C     SRPLT         ANDNE     'S'
     C                   MOVE      ' 419'        ECODE
     C                   EXSR      ERROR
     C                   SETON                                        60
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C**  IF ANY ERROR SET UP ERROR CODES
     C*
     C     *IN69         IFEQ      '1'
     C                   MOVEA     ERCD(1)       ERRMG1
     C                   WRITE     ERRFMT
     C                   ELSE
     C                   SETON                                        8547
     C                   END
     C*
     C                   END
     C                   END
     C***********          END                                            S01199
     C                   SETOFF                                       6985
     C                   WRITE     ERRFMT
     C                   MOVEA     '00'          *IN(59)
     C                   WRITE     SE1200F3
     C*
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  SCHED  SR. - TO DISPLAY AND VALIDATE PROMPT SCREEN 4 -
     C*               SCHEDULING DETAILS
     C*
     C*  CALLED FROM - RPTOPT
     C*
     C********************************************************************
     C*
     C     SCHED         BEGSR                                                  *** SCHED  ***
     C*
     C                   SETOFF                                       55  44
     C                   MOVEA     '000'         *IN(46)
     C                   MOVEA     '000000'      *IN(59)
     C                   MOVE      *BLANKS       SMAT1
     C                   MOVE      *BLANKS       SMAT2
     C                   MOVE      *BLANKS       SMAT3
     C                   MOVE      *BLANKS       SMAT4
     C                   MOVE      *BLANKS       SSET1
     C                   MOVE      *BLANKS       SLAT
     C                   WRITE     HEADER
     C                   WRITE     FOOTER
     C     #RPT          IFEQ      'RC10    '
     C     #RPT          OREQ      'RF14AB  '
     C     #RPT          OREQ      'RP14    '
     C                   SETON                                        4446
     C                   ELSE
     C     #RPT          IFEQ      'RF13    '
     C     #RPT          OREQ      'RP13    '
     C                   SETON                                        46
     C                   ELSE
     C                   SETON                                        44
     C                   END
     C                   END
     C*
     C     STITL         IFEQ      HEAD(3)
     C     STITL         OREQ      HEAD(1)
     C     STITL         OREQ      HEAD(7)
     C                   SETON                                        48
     C                   END
     C*
     C     *IN85         DOUEQ     '1'
     C     *IN01         OREQ      '1'
     C************INKB     OREQ '1'                                       S01199
     C     *INKL         OREQ      '1'                                                         S0119
     C*
     C                   EXFMT     SE1200F4
     C*
     C*
     C**  PROCESS COMMAND KEYS
     C*
     C************IN22     IFEQ '1'                                       S01199
     C***********          MOVEAERCD      HERCD 160                       S01199
     C***********          MOVEL'SE1200'  HBPGM   6                       S01199
     C***********          CALL 'MHELP'                                   S01199
     C***********          PARM           HBPGM                           S01199
     C***********          PARM           HERCD                           S01199
     C***********          ELSE                                           S01199
     C*
     C**  ENTER KEY
     C*
     C     *IN01         IFEQ      '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C*
     C**  VALIDATE  SCREEN
     C*
     C                   Z-ADD     0             X
     C                   MOVEA     *BLANKS       ERCD
     C                   SETOFF                                       69
     C                   MOVEA     '000000'      *IN(59)
     C*
     C**  AT LEAST ONE TIME MUST BE SELECTED
     C*
     C     SMAT1         IFEQ      *BLANKS
     C     SMAT2         ANDEQ     *BLANKS
     C     SMAT3         ANDEQ     *BLANKS
     C     SMAT4         ANDEQ     *BLANKS
     C     SSET1         ANDEQ     *BLANKS
     C     SLAT          ANDEQ     *BLANKS
     C                   MOVE      ' 420'        ECODE
     C                   EXSR      ERROR
     C     *IN44         IFEQ      '0'
     C                   MOVEA     '111'         *IN(62)
     C                   ELSE
     C                   MOVEA     '111111'      *IN(59)
     C                   END
     C                   ELSE
     C*
     C**  IF RECEIVE OPTION IS 'LIST SCHEDULED REPORTS' OR 'PRODUCE ON
     C**  REQUEST REPORTS' THEN ONLY ONE OPTION MAY BE SELECTED
     C*
     C     STITL         IFEQ      HEAD(1)
     C     STITL         OREQ      HEAD(3)
     C     STITL         OREQ      HEAD(7)
     C*
     C     SMAT1         IFNE      *BLANKS
     C     SMAT2         IFNE      *BLANKS
     C     SMAT3         ORNE      *BLANKS
     C     SMAT4         ORNE      *BLANKS
     C     SSET1         ORNE      *BLANKS
     C     SLAT          ORNE      *BLANKS
     C                   SETON                                        59
     C                   END
     C                   END
     C*
     C     SMAT2         IFNE      *BLANKS
     C     SMAT1         IFNE      *BLANKS
     C     SMAT3         ORNE      *BLANKS
     C     SMAT4         ORNE      *BLANKS
     C     SSET1         ORNE      *BLANKS
     C     SLAT          ORNE      *BLANKS
     C                   SETON                                        60
     C                   END
     C                   END
     C*
     C*
     C     SMAT3         IFNE      *BLANKS
     C     SMAT1         IFNE      *BLANKS
     C     SMAT2         ORNE      *BLANKS
     C     SMAT4         ORNE      *BLANKS
     C     SSET1         ORNE      *BLANKS
     C     SLAT          ORNE      *BLANKS
     C                   SETON                                        61
     C                   END
     C                   END
     C*
     C     SMAT4         IFNE      *BLANKS
     C     SMAT1         IFNE      *BLANKS
     C     SMAT2         ORNE      *BLANKS
     C     SMAT3         ORNE      *BLANKS
     C     SSET1         ORNE      *BLANKS
     C     SLAT          ORNE      *BLANKS
     C                   SETON                                        62
     C                   END
     C                   END
     C*
     C     SSET1         IFNE      *BLANKS
     C     SMAT1         IFNE      *BLANKS
     C     SMAT2         ORNE      *BLANKS
     C     SMAT3         ORNE      *BLANKS
     C     SMAT4         ORNE      *BLANKS
     C     SLAT          ORNE      *BLANKS
     C                   SETON                                        63
     C                   END
     C                   END
     C*
     C     SLAT          IFNE      *BLANKS
     C     SMAT1         IFNE      *BLANKS
     C     SMAT2         ORNE      *BLANKS
     C     SMAT3         ORNE      *BLANKS
     C     SMAT4         ORNE      *BLANKS
     C     SSET1         ORNE      *BLANKS
     C                   SETON                                        64
     C                   END
     C                   END
     C*
     C     *IN59         IFEQ      '1'
     C     *IN60         OREQ      '1'
     C     *IN61         OREQ      '1'
     C     *IN62         OREQ      '1'
     C     *IN63         OREQ      '1'
     C     *IN64         OREQ      '1'
     C                   MOVE      ' 421'        ECODE
     C                   EXSR      ERROR
     C                   END
     C                   END
     C*
     C                   END
     C*
     C*
     C**  IF ANY ERROR SET UP ERROR CODES
     C*
     C     *IN69         IFEQ      '1'
     C                   MOVEA     ERCD(1)       ERRMG1
     C                   WRITE     ERRFMT
     C                   ELSE
     C                   SETON                                        8547
     C                   END
     C*
     C                   END
     C                   END
     C***********          END                                            S01199
     C                   SETOFF                                       6985
     C                   WRITE     ERRFMT
     C                   MOVEA     '000000'      *IN(59)
     C                   WRITE     SE1200F4
     C*
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  STATUS SR. - TO DISPLAY AND VALIDATE PROMPT SCREEN 5 -
     C*               STATUS SELECTION
     C*
     C********************************************************************
     C*
     C     STATUS        BEGSR                                                  *** STATUS ***
     C*
     C                   SETOFF                                       5547
     C                   MOVEA     '000'         *IN(16)
     C                   MOVEA     '0'           *IN(59)
     C                   MOVE      *BLANKS       SVAL
     C                   MOVE      *BLANKS       SCAN
     C                   MOVE      *BLANKS       SMOD
     C                   MOVE      *BLANKS       SMATC
     C                   MOVE      *BLANKS       SFUT
     C                   MOVE      *BLANKS       SADV1
     C                   MOVE      *BLANKS       SADV2
     C                   MOVE      *BLANKS       SADV
     C                   MOVE      *BLANKS       SUNM
     C                   MOVE      *BLANKS       SUNM1
     C                   MOVE      *BLANKS       SUNM2
     C                   MOVE      *BLANKS       SGLOB
     C                   MOVE      *BLANKS       SLIMB
     C                   MOVE      *BLANKS       SUSEC
     C                   MOVE      *BLANKS       SCSEC
     C                   MOVE      *BLANKS       SNTEN
     C                   MOVE      *BLANKS       SPROV
     C                   MOVE      *BLANKS       STRSH
     C                   MOVE      *BLANKS       SOTH
     C                   MOVE      *BLANKS       STRDIF
     C                   MOVE      *BLANKS       SBNRP
     C                   MOVE      *BLANKS       SBSEC
     C                   MOVE      *BLANKS       SBCXL
     C                   MOVE      *BLANKS       SBDEN
     C                   MOVE      *BLANKS       SCXLC
     C                   MOVE      *BLANKS       SCXLB
     C                   MOVE      *BLANKS       SCXLP
     C                   WRITE     HEADER
     C                   WRITE     FOOTER
     C     #RPT          IFEQ      'ISTA    '
     C                   SETON                                        161718
     C                   ELSE
     C     #RPT          IFEQ      'IKEY    '
     C                   SETON                                        1617
     C                   ELSE
     C     #RPT          IFEQ      'INOTE   '
     C                   SETON                                        16
     C                   END
     C                   END
     C                   END
     C*
     C     *IN85         DOUEQ     '1'
     C     *IN01         OREQ      '1'
     C************INKB     OREQ '1'                                       S01199
     C     *INKL         OREQ      '1'                                                         S0119
     C*
     C                   EXFMT     SE1200F5
     C*
     C*
     C**  PROCESS COMMAND KEYS
     C*
     C************IN22     IFEQ '1'                                       S01199
     C***********          MOVEAERCD      HERCD 160                       S01199
     C***********          MOVEL'SE1200'  HBPGM   6                       S01199
     C***********          CALL 'MHELP'                                   S01199
     C***********          PARM           HBPGM                           S01199
     C***********          PARM           HERCD                           S01199
     C***********          ELSE                                           S01199
     C*
     C**  ENTER KEY
     C*
     C     *IN01         IFEQ      '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C*
     C**  VALIDATE  SCREEN
     C*
     C                   Z-ADD     0             X
     C                   MOVEA     *BLANKS       ERCD
     C                   SETOFF                                       69
     C                   MOVEA     '0'           *IN(59)
     C*
     C**  AT LEAST ONE STATUS MUST BE SELECTED IF REPORT IS 'ISTA'
     C**  NO MORE THAN 5 MAY BE SELECTED
     C*
     C                   Z-ADD     0             XX
     C     SVAL          IFNE      *BLANKS
     C                   ADD       1             XX
     C                   END
     C     SCAN          IFNE      *BLANKS
     C                   ADD       1             XX
     C                   END
     C     SMOD          IFNE      *BLANKS
     C                   ADD       1             XX
     C                   END
     C     SMATC         IFNE      *BLANKS
     C                   ADD       1             XX
     C                   END
     C     SFUT          IFNE      *BLANKS
     C                   ADD       1             XX
     C                   END
     C     SADV1         IFNE      *BLANKS
     C                   ADD       1             XX
     C                   END
     C     SADV2         IFNE      *BLANKS
     C                   ADD       1             XX
     C                   END
     C     SADV          IFNE      *BLANKS
     C                   ADD       1             XX
     C                   END
     C     SCXLC         IFNE      *BLANKS
     C                   ADD       1             XX
     C                   END
     C     SCXLB         IFNE      *BLANKS
     C                   ADD       1             XX
     C                   END
     C     SCXLP         IFNE      *BLANKS
     C                   ADD       1             XX
     C                   END
     C     SUNM          IFNE      *BLANKS
     C                   ADD       1             XX
     C                   END
     C     SUNM1         IFNE      *BLANKS
     C                   ADD       1             XX
     C                   END
     C     SUNM2         IFNE      *BLANKS
     C                   ADD       1             XX
     C                   END
     C     SGLOB         IFNE      *BLANKS
     C                   ADD       1             XX
     C                   END
     C     SLIMB         IFNE      *BLANKS
     C                   ADD       1             XX
     C                   END
     C     SUSEC         IFNE      *BLANKS
     C                   ADD       1             XX
     C                   END
     C     SCSEC         IFNE      *BLANKS
     C                   ADD       1             XX
     C                   END
     C     SNTEN         IFNE      *BLANKS
     C                   ADD       1             XX
     C                   END
     C     SPROV         IFNE      *BLANKS
     C                   ADD       1             XX
     C                   END
     C     STRSH         IFNE      *BLANKS
     C                   ADD       1             XX
     C                   END
     C     SOTH          IFNE      *BLANKS
     C                   ADD       1             XX
     C                   END
     C     SBNRP         IFNE      *BLANKS
     C                   ADD       1             XX
     C                   END
     C     SBSEC         IFNE      *BLANKS
     C                   ADD       1             XX
     C                   END
     C     SBCXL         IFNE      *BLANKS
     C                   ADD       1             XX
     C                   END
     C     SBDEN         IFNE      *BLANKS
     C                   ADD       1             XX
     C                   END
     C     STRDIF        IFNE      *BLANKS
     C                   ADD       1             XX
     C                   END
     C*
     C**  AT LEAST ONE STATUS MUST BE SELECTED IF REPORT IS 'ISTA'
     C**  NO MORE THAN 5 MAY BE SELECTED
     C*
     C     #RPT          IFEQ      'ISTA    '
     C     XX            ANDEQ     0
     C                   MOVE      ' 422'        ECODE
     C                   EXSR      ERROR
     C                   SETON                                        59
     C                   END
     C*
     C     XX            IFGT      5
     C                   MOVE      ' 423'        ECODE
     C                   EXSR      ERROR
     C                   SETON                                        59
     C                   END
     C*
     C**  IF ANY ERROR SET UP ERROR CODES
     C*
     C     *IN69         IFEQ      '1'
     C                   MOVEA     ERCD(1)       ERRMG1
     C                   WRITE     ERRFMT
     C                   ELSE
     C                   SETON                                        8547
     C                   END
     C*
     C                   END
     C                   END
     C**********           END                                            S01199
     C                   SETOFF                                       6985
     C                   WRITE     ERRFMT
     C                   MOVEA     '0'           *IN(59)
     C                   WRITE     SE1200F5
     C*
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  USRREF SR. - TO DISPLAY AND VALIDATE PROMPT SCREEN 15 -
     C*               USER REFERENCES
     C*
     C*  CALLED FROM - RPTOPT
     C*
     C********************************************************************
     C*
     C     USRREF        BEGSR                                                  *** USRREF ***
     C*
     C                   SETOFF                                       5547
     C                   MOVEA     '00000'       *IN(59)
     C                   MOVE      *BLANKS       SUREF1
     C                   MOVE      *BLANKS       SUREF2
     C                   MOVE      *BLANKS       SUREF3
     C                   MOVE      *BLANKS       SUREF4
     C                   MOVE      *BLANKS       SUREF5
     C*
     C     *IN85         DOUEQ     '1'
     C     *IN01         OREQ      '1'
     C************INKB     OREQ '1'                                       S01199
     C     *INKL         OREQ      '1'                                                         S0119
     C*
     C                   EXFMT     SE120F15
     C*
     C*
     C**  PROCESS COMMAND KEYS
     C*
     C************IN22     IFEQ '1'                                       S01199
     C***********          MOVEAERCD      HERCD 160                       S01199
     C***********          MOVEL'SE1200'  HBPGM   6                       S01199
     C***********          CALL 'MHELP'                                   S01199
     C***********          PARM           HBPGM                           S01199
     C***********          PARM           HERCD                           S01199
     C***********          ELSE                                           S01199
     C*
     C**  ENTER KEY
     C*
     C     *IN01         IFEQ      '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C*
     C**  VALIDATE  SCREEN
     C*
     C                   Z-ADD     0             X
     C                   MOVEA     *BLANKS       ERCD
     C                   SETOFF                                       69
     C                   MOVEA     '00000'       *IN(59)
     C*
     C**  USER REFERENCE 1 MUST BE A NUMBER OR 'ALL'
     C*
     C     SUREF1        IFNE      'ALL  '
     C                   MOVEA     SUREF1        NUM5
     C                   EXSR      NUM5CK
     C     *IN36         IFEQ      '0'
     C                   MOVE      ' 449'        ECODE
     C                   EXSR      ERROR
     C                   SETON                                        59
     C                   END
     C                   ELSE
     C*
     C**  IF USER REFERENCE 1 IS 'ALL' REFERENCES 2 TO 5 MUST BE BLANK
     C*
     C     SUREF2        IFNE      *BLANKS
     C                   SETON                                        60
     C                   END
     C     SUREF3        IFNE      *BLANKS
     C                   SETON                                        61
     C                   END
     C     SUREF4        IFNE      *BLANKS
     C                   SETON                                        62
     C                   END
     C     SUREF5        IFNE      *BLANKS
     C                   SETON                                        63
     C                   END
     C     *IN60         IFEQ      '1'
     C     *IN61         OREQ      '1'
     C     *IN62         OREQ      '1'
     C     *IN63         OREQ      '1'
     C                   MOVE      ' 450'        ECODE
     C                   EXSR      ERROR
     C                   END
     C                   END
     C*
     C**  USER REFERENCE 2 TO 5 IF ENTERED MUST BE NUMERIC
     C*
     C     SUREF2        IFNE      *BLANKS
     C                   MOVEA     SUREF2        NUM5
     C                   EXSR      NUM5CK
     C     *IN36         IFEQ      '0'
     C                   SETON                                        60
     C                   END
     C                   END
     C     SUREF3        IFNE      *BLANKS
     C                   MOVEA     SUREF3        NUM5
     C                   EXSR      NUM5CK
     C     *IN36         IFEQ      '0'
     C                   SETON                                        61
     C                   END
     C                   END
     C     SUREF4        IFNE      *BLANKS
     C                   MOVEA     SUREF4        NUM5
     C                   EXSR      NUM5CK
     C     *IN36         IFEQ      '0'
     C                   SETON                                        62
     C                   END
     C                   END
     C     SUREF5        IFNE      *BLANKS
     C                   MOVEA     SUREF5        NUM5
     C                   EXSR      NUM5CK
     C     *IN36         IFEQ      '0'
     C                   SETON                                        63
     C                   END
     C                   END
     C     *IN60         IFEQ      '1'
     C     *IN61         OREQ      '1'
     C     *IN62         OREQ      '1'
     C     *IN63         OREQ      '1'
     C                   MOVE      ' 451'        ECODE
     C                   EXSR      ERROR
     C                   END
     C*
     C**  IF ANY ERROR SET UP ERROR CODES
     C*
     C     *IN69         IFEQ      '1'
     C                   MOVEA     ERCD(1)       ERRMG1
     C                   WRITE     ERRFMT
     C                   ELSE
     C                   SETON                                        8547
     C                   END
     C*
     C                   END
     C                   END
     C***********          END                                            S01199
     C                   SETOFF                                       6985
     C                   WRITE     ERRFMT
     C                   MOVEA     '00000'       *IN(59)
     C                   WRITE     SE120F15
     C*
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  SELDAY SR. - TO DISPLAY AND VALIDATE PROMPT SCREEN 6  -
     C*               DAY SELECTION
     C*
     C*  CALLED FROM - RPTOPT
     C*
     C********************************************************************
     C*
     C     SELDAY        BEGSR                                                  *** SELDAY ***
     C*
     C                   SETOFF                                       5547
     C                   MOVEA     '0000'        *IN(59)
     C                   MOVE      *BLANKS       STODAY
     C                   MOVE      *BLANKS       SYESTR
     C                   MOVE      *BLANKS       SDBYES
     C                   MOVE      *BLANKS       SALL
     C                   WRITE     HEADER
     C                   WRITE     FOOTER
     C*
     C     *IN85         DOUEQ     '1'
     C     *IN01         OREQ      '1'
     C************INKB     OREQ '1'                                       S01199
     C     *INKL         OREQ      '1'                                                         S0119
     C*
     C                   EXFMT     SE1200F6
     C*
     C**  PROCESS COMMAND KEYS
     C*
     C************IN22     IFEQ '1'                                       S01199
     C***********          MOVEAERCD      HERCD 160                       S01199
     C***********          MOVEL'SE1200'  HBPGM   6                       S01199
     C***********          CALL 'MHELP'                                   S01199
     C***********          PARM           HBPGM                           S01199
     C***********          PARM           HERCD                           S01199
     C***********          ELSE                                           S01199
     C*
     C**  ENTER KEY
     C*
     C     *IN01         IFEQ      '0'
     C************INKB     ANDEQ'0'                                       S01199
     C     *INKL         ANDEQ     '0'                                                         S0119
     C*
     C**  VALIDATE  SCREEN
     C*
     C                   Z-ADD     0             X
     C                   MOVEA     *BLANKS       ERCD
     C                   SETOFF                                       69
     C                   MOVEA     '0000'        *IN(59)
     C*
     C**  AT LEAST ONE OPTION MUST BE SELECTED
     C*
     C     STODAY        IFEQ      *BLANKS
     C     SYESTR        ANDEQ     *BLANKS
     C     SDBYES        ANDEQ     *BLANKS
     C     SALL          ANDEQ     *BLANKS
     C                   MOVE      ' 420'        ECODE
     C                   EXSR      ERROR
     C                   MOVEA     '1111'        *IN(59)
     C                   ELSE
     C*
     C**  NO MORE THAN ONE OPTION MUST BE SELECTED
     C*
     C     STODAY        IFNE      *BLANKS
     C     SYESTR        IFNE      *BLANKS
     C     SDBYES        ORNE      *BLANKS
     C     SALL          ORNE      *BLANKS
     C                   MOVEA     '1'           *IN(59)
     C                   END
     C                   END
     C     SYESTR        IFNE      *BLANKS
     C     STODAY        IFNE      *BLANKS
     C     SDBYES        ORNE      *BLANKS
     C     SALL          ORNE      *BLANKS
     C                   MOVEA     '1'           *IN(60)
     C                   END
     C                   END
     C     SDBYES        IFNE      *BLANKS
     C     STODAY        IFNE      *BLANKS
     C     SYESTR        ORNE      *BLANKS
     C     SALL          ORNE      *BLANKS
     C                   MOVEA     '1'           *IN(61)
     C                   END
     C                   END
     C     SALL          IFNE      *BLANKS
     C     STODAY        IFNE      *BLANKS
     C     SYESTR        ORNE      *BLANKS
     C     SDBYES        ORNE      *BLANKS
     C                   MOVEA     '1'           *IN(62)
     C                   END
     C                   END
     C     *IN59         IFEQ      '1'
     C     *IN60         OREQ      '1'
     C     *IN61         OREQ      '1'
     C     *IN62         OREQ      '1'
     C                   MOVE      ' 421'        ECODE
     C                   EXSR      ERROR
     C                   END
     C*
     C                   END
     C*
     C**  IF ANY ERROR SET UP ERROR CODES
     C*
     C     *IN69         IFEQ      '1'
     C                   MOVEA     ERCD(1)       ERRMG1
     C                   WRITE     ERRFMT
     C                   ELSE
     C                   SETON                                        8547
     C                   END
     C*
     C                   END
     C                   END
     C**********           END                                            S01199
     C                   SETOFF                                       6985
     C                   WRITE     ERRFMT
     C                   MOVEA     '0000'        *IN(59)
     C                   WRITE     SE1200F6
     C*
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  ISTCDS SR. - TO OUTPUT THE INITIAL CARDS TO RECEIVE/TRANSMIT
     C*               FILE
     C*
     C*  CALLED FROM - FIRST
     C*
     C********************************************************************
     C*
     C     ISTCDS        BEGSR                                                  *** ISTCDS ***
     C*
     C                   OPEN      ECTRF
     C*
     C                   SETON                                        81
     C*
     C**  CARD 1 - USER NUMBER AND PASSWORD
     C*
     C                   MOVEA     CARD(1)       CRD
     C                   MOVEA     SUSNO         CRD(1)
     C                   MOVEA     SUSCO         CRD(10)
     C                   MOVEA     CRD           LOTTLX
     C                   EXCEPT
     C*
     C**  CARD 2 - LOGICAL TERMINATION IDENTIFICATION
     C*
     C                   MOVE      CARD(3)       LOTTLX
     C                   EXCEPT
     C*
     C**  CARD 3 - MODE
     C*
     C                   MOVE      CARD(4)       LOTTLX
     C                   EXCEPT
     C*
     C**  CARD 6 - START OF RECEIVE PROCESSING OPTIONS
     C*
     C                   MOVEA     CARD(10)      CRD
     C                   MOVE      SUSNO         SWRK
     C                   MOVEA     SWRK          CRD(8)
     C*
     C                   MOVEA     CRD           LOTTLX
     C                   EXCEPT
     C*
     C**  CARD 7 - EUCLID PASSWORD
     C*
     C                   MOVEA     *BLANKS       CRD
     C                   MOVEA     SPASS         CRD(1)
     C*
     C                   MOVEA     CRD           LOTTLX
     C                   EXCEPT
     C                   SETOFF                                       81
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  LSTCDS SR. - TO OUTPUT THE FINAL CARDS TO RECEIVE/TRANSMIT
     C*               FILE
     C*
     C*  CALLED FROM - LAST
     C*
     C********************************************************************
     C*
     C     LSTCDS        BEGSR                                                  *** LSTCDS ***
     C*
     C                   SETON                                        81
     C*
     C**  CARD 5 - END OF FILE
     C*
     C                   MOVE      CARD(6)       LOTTLX
     C                   EXCEPT
     C*
     C**  CARD 20 - COMMAND
     C*
     C                   MOVEA     CARD(7)       LOTTLX
     C                   EXCEPT
     C*
     C**  CARD 21 - END OF SESSION
     C*
     C                   MOVE      CARD(8)       LOTTLX
     C                   EXCEPT
     C*
     C                   SETOFF                                       81
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C*  NUM5CH  - SUBROUTINE TO CHECK FOR NUMERIC ENTRY
     C*
     C*
     C********************************************************************
     C*
     C     NUM5CK        BEGSR
     C                   DO        5             A                 1 0
     C     NUM5(A)       LOOKUP    NUM                                    36
     C   36              END
     C                   ENDSR
     C**
      *****************************************************************   S01117
      /EJECT                                                              S01117
      *****************************************************************   S01117
      *                                                               *   S01117
      *  *PSSR  - Error control subroutine                            *   S01117
      *                                                               *   S01117
      *****************************************************************   S01117
      *                                                                   S01117
     C     *PSSR         BEGSR                                                  ** *PSSR **    S0111
     C**                                                                  S01117
     C     @RUN          IFEQ      *BLANKS                                                     S0111
     C                   MOVE      'Y'           @RUN              1                           S0111
     C                   DUMP                                                                  S0111
     C                   END                                                                   S0111
     C**                                                                  S01117
     C                   ENDSR                                                                 S0111
      *                                                                   S01117
     C********************************************************************
      /EJECT
     C*COPY*ZSRSRC,ZDATE1Z2                                                                 MD058079
     C/COPY ZSRSRC,ZDATE1Z2LE                                                               MD058079
      /EJECT
     C*COPY*ZSRSRC,ZSYSTMZ1                                                                 MD058079
     C/COPY ZSRSRC,ZSYSTMZ1LE                                                               MD058079
     O/EJECT
     O*
     OSEEUCAF   E            ECTLXT
     O                       EUNU
     OSEEUCHF   EDEL    03   ECTDEL
     OSEEUCD0F  EDEL    04   ECTDEL
     OSEEUCD1F  EDEL    05   ECTDEL
     OSEEUCD2F  EDEL    06   ECTDEL
     OSEEUCD3F  EDEL    09   ECTDEL
     OSEEUCD4F  EDEL    10   ECTDEL
     OSEEUCD5F  EDEL    11   ECTDEL
     O*
     O*    S/SEEUR FILE
     O*
     OECTRF     EADD 81
     O*
     O*    S/ECTRF FILE
     O*
     O                       LOTTLX              80
     OSEEUZHF   EADD 82 03
     O*
     O*    S/SEEUZ FILE
     O*
     O                       *ALL
     O*
     OSEEUZD0F  EADD 82 04
     O                       *ALL
     O*
     OSEEUZD1F  EADD 82 05
     O                       *ALL
     O*
     OSEEUZD2F  EADD 82 06
     O                       *ALL
     O*
     OSEEUZD3F  EADD 82 09
     O                       *ALL
     O*
     OSEEUZD4F  EADD 82 10
     O                       *ALL
     O*
     OSEEUZD5F  EADD 82 11
     O                       *ALL
     O*
     OSEEUZAF   EADD 83
     O                       *ALL
      /EJECT
      ***
**  CPY@
(c) Finastra International Limited 2001
**  HEAD
           PRODUCE ON REQUEST REPORTS
                SCHEDULE REPORTS
       LIST REPORTS PREVIOUSLY SCHEDULED
           END SCHEDULING OF REPORTS
                 STAND REPORTS
            END STANDING OF REPORTS
REQUEST ADDITIONAL COPY OF REPORTS JUST RECEIVED
**  MSG
          THERE ARE MORE THAN 500 INSTRUCTIONS FOR THIS ACCOUNT
          THERE ARE MORE THAN 200 CANCELLATIONS FOR THIS ACCOUNT
**  SIMP
RF02
RF03
RF39
RP39
LA
CPARTP
SECURP
SECREFP
S
SCHEDULE;L
STAND;L
NEWS1
NEWS2
NEWS3
NEWS4
NEWS5
NEWS6
HELP
**  CMD
CLRPFM FILE(ECTRF)
**    CARD - SKELETON CARDS FOR OUTPUT
        ,
*LTID MGTHSP
*LTID MGTHSP,CPUNCH
*MODE INPUT(OUTPUT(OUTHSS),PSU(1000),LIST),WAIT
*DATA E   INSH
*EOF
/TS010 COMMANDFILE
*EOS
*DATA E   CANH
*DATA E   COMF
**   ALP - LETTERS IN ALPHABET
ABCDEFGHIJKLMNOPQRSTUVWXYZ
**   NUM - NUMBERS
0123456789
**  ZYDY - YEARS IN DAYS CUMULATIVE IN FOUR YEAR SPAN
0366073110961461
**  ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
