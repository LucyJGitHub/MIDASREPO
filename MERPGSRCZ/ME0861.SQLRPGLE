     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD056560
/*STD *  RPGSQLBND                                                    *                     MD056560
/*EXI *  TEXT('Midas ME Format ISO mail')
      *****************************************************************
      *                                                               *
      *  Midas - MESSAGE MANAGEMENT                                   *
      *                                                               *
      *    ME0861 - Outgoing mail re-print ISO formatting program     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Last Amend No. MD056560           Date 31Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 219242             Date 01Jul03               *
      *                 219241             Date 01Jul03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 212173             Date 18Nov02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 186181             Date 10Nov00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 141572             DATE 21SEP98               *
     F*                 140629             Date 18Sep98               *
      *                 CSW098             DATE 24MAR98               *
      *                 113352             DATE 13FEB97               *
      *                 CSW097             DATE 26MAY97               *
      *                 086802             DATE 19JUN96               *
      *                 E38493             DATE 16APR92               *
      *                 E29588             DATE 17DEC91               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD056560 - Deliverable Data Split for SDMTAGPD               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  219242 - Not possible to create MT103+ payment msg from      *
      *           non-FT transaction (Recompile)                      *
      *  219241 - Defaulting of "Details of Charges" assign a         *
      *           system value (Recompile)                            *
      *  212173 - Process validation fields for MT103s                *
     F*  186181 - Format for currency and amounts needs to be able to *
     F*           cope with a sign in front                           *
      *  141572 - Recompile over changes in MGOREFPD                  *
     F*  140629 - Convert field 72 amount (, to .)                    *
      *  CSW098 - SWIFT 1998 changes.                                 *
      *           This program is changed to recognise MT515/518      *
      *           tags :98a: date/time format suffixed with a         *
      *           qualifier and/or type (:qual//type/yyymmddhhmmss).  *
      *           A new tag format 'DT' is introduced to format time  *
      *           to hh:mm:ss.  Also, :95P: (:qual//swiftid) should   *
      *           also be output with name and address as with :5nA:  *
      *           and :8nA: tags.                                     *
      *    113352 - Recompile over changes in MGOREFPD                *
      *  CSW097 - Swift changes 1997:                                 *
      *           The program was amended to recognise dates          *
      *           in CCYYMMDD format.                                 *
      *    086802 - Pgm is not correctly formatting dates in ISO      *
      *             Date Format.                                      *
      *    E38493 - SUPRESS ALL BRANCH INFO WHEN SINGLE BRANCHING     *  *
      *    E29588 - POST COLLECTION SWIFT RATIONALISATION AMENDMENTS  *
      *              o Use TRNF to access reference for mult. 210     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  C R E A T I O N     P A R A M E T E R S                      *
      *                                                               *
      *                                                               *
      *****************************************************************
     FMGOREFL0  IF   E           K DISK
     FMGOMSGPD  IF   E           K DISK
     F*SDMTAGL0* IF   E           K DISK                                                    MD056560
     FSDMTPYL0  IF   E           K DISK
     FSDBRCHL0  IF   E           K DISK
      * Customer and C/Party nostro files by network address
     FSDCUSTL7  IF   E           K DISK
     F                                     RENAME(@CUSTGE:SDCUSTSW)
     FSDCNSTL2  IF   E           K DISK
     F                                     RENAME(@CNSTLD:SDCNSTSW)
      *
      *
      *****************************************************************
      * ID C  F  H  L    Function of indicators                       *
      *    10            Check for multiple TRN tag. & check for      *
      *                  verification message type/field.             *
      *    81            USED IN SCAN FOR /OCMT/ AND /CHGS/           *   140629
      *    98 & 95       Chain to MGOREFL0 fails                      *
      *    97            Chain to MGOMSGPD fails                      *
      *   U7U8LR         DB error                                     *
      *****************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Copyright statement
      *
     D TG              S              1    DIM(5)
      **  Message field tag
      *
     D TXT             S             22    DIM(9) CTDATA PERRCD(1)
      **  Text to be printed on report
      *
     D/COPY WNCPYSRC,ME0861E001
     D************        VERFY   1   5  6                                                    212173
     D VERFY           S              6    DIM(6) CTDATA PERRCD(1)
      **  Message types/fields requiring verification
      *
     D/COPY WNCPYSRC,ME0861E002
     D TRNTG           S              7    DIM(2) CTDATA PERRCD(1)
      **  Message tag format
      *
     D AMAR            S              1    DIM(20)
      **  Array for formatting amounts
      *
     D DTE             S              1    DIM(8)
      **  Array for formatting dates
      *
     D FLD             S              1    DIM(50)
      **  Array for formatting fields
      *
     D                 DS
     D  SDTAQ                  1     90
      *
      ** Data structure to hold data queue contents
      *
     D  TX1                    4     16
     D  @MTPY                 17     19
     D  @MTPD                 22     56
     D  TX2                   66     81
     D  TX22                  70     81
      *
      **
      *
     D  TX3                    4     12
     D  @MTRN                 15     29
     D  TX4                   32     37
     D  @BRCA                 39     41
     D  @A8BRN                43     72
     D  @RDAT                 75     81
      *
      **
      *
     D  TX5                    4     33
     D  @MTAG                 35     39
     D  @MFLD                 41     90
     D                 DS
     D  DAT                    1      6
     D  YY                     1      2
     D  MM                     3      4
     D  DD                     5      6
      *
     D                 DS
     D  DAT2                   1      7
     D  DD2                    1      2
     D  MM2                    3      5
     D  YY2                    6      7
      *                                                                   CSW097
      ** Data structure to hold date in CCYYMMDD format.                  CSW097
      *                                                                   CSW097
     D                 DS                                                       CSW097
     D  DAT3                   1      8                                         CSW097
     D  YY3                    1      4                                         CSW097
     D  MM3                    5      6                                         CSW097
     D  DD3                    7      8                                         CSW097
      *                                                                   CSW097
      ** Data structure to hold defined constants.                        CSW097
      *                                                                   CSW097
     D DIGITS          C                   CONST('0123456789')                  CSW097
      *                                                                   CSW097
      ** Data structure MFLD2 to hold the first seven character of MFLD   CSW097
      *                                                                   CSW097
     D                 DS                                                       CSW097
     D  MFLD2                  1      7                                         CSW097
     D  CHAR7                  7      7                                         CSW097
     D  CHAR44                 4      4                                         186181
     D  CHAR24                 2      4                                         186181
      ** DS for splitting up date
      *
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      ** Data structure for DB error reporting
      *
     D SDMGME        E DS                  EXTNAME(SDMGMEPD)
     D** Message Management details.
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                    E38493
     D** Midas Module details.                                            E38493
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D SDMTAG        E DS                  EXTNAME(SDMTGJW0)                                MD056560
      **  Access object DS
      *
      *****************************************************************
      *               Index to subroutines                            *
      *               ~~~~~~~~~~~~~~~~~~~~                            *
      *  main process                                                 *
      *  REF     - Process message reference file                     *
      *  DETL    - Process message detail file                        *
      *  FLDPRC  - Process field                                      *
      *  MLTTRN  - Process multiple TRN field                         *
      *  SWADDR  - Access Name/Town for SWIFT address                 *
      *  CASR    - Format CCY/AMOUNT subfield                         *
      *  DCASR   - Format DATE/CCY/AMOUNT subfield                    *
      *  ASR     - Format AMOUNT subfield                             *
      *  DSR     - Format DATE subfield                               *
      *  CATCH   - Catchall format for non-blank but unrecognised     *
      *            format code                                        *
      *  *PSSR   - error handling                                     *
      *****************************************************************
      *
     C/EJECT
      *****************************************************************
      *   main processs                                               *
      *   Calls - REF & DETL                                          *
      *****************************************************************
      *
      ** Set up LDA for database errors
     C     *DTAARA       DEFINE                  LDA
      *
      *
     C     *ENTRY        PLIST
     C                   PARM                    PTRN             16
     C                   PARM                    PBCH              3
     C                   PARM                    RDAT              7
     C                   PARM                    PERR              1
      *
      ** Set up copyright statement
     C                   MOVEA     CPY@          BIS@             80
      *
      ** Set up key to MTAG file
     C     MGTAGK        KLIST
     C                   KFLD                    MTAGK             5
     C                   KFLD                    MTPYK             3
      *                                                                   CSW098
     C     KMTAG         KLIST                                                                 CSW09
     C                   KFLD                    MTAGK                                         CSW09
     C                   KFLD                    MTPYK                                         CSW09
     C                   KFLD                    MSEQN             3                           CSW09
      *                                                                   CSW098
      ** Check if (CSW098) SWIFT 1998 changes is on                       CSW098
      *                                                                   CSW098
     C                   CALL      'SWIFT98'                            7676                   CSW09
     C                   PARM      *BLANKS       CSW098            7                           CSW09
      *                                                                   CSW098
     C     *IN76         IFEQ      '1'                                                         CSW09
     C     *LOCK         IN        LDA                                                         CSW09
     C                   MOVE      '008'         DBASE                                         CSW09
     C                   MOVEL     'SWIFT98 '    KEY16                                         CSW09
     C                   MOVE      'ERROR   '    KEY16            16            * * * * * * * *CSW09
     C                   MOVEL     KEY16         DBKEY                          *  DBERR 008  *CSW09
     C                   MOVEL     *BLANKS       DBFILE                         * * * * * * * *CSW09
     C                   OUT       LDA                                                         CSW09
     C                   MOVEL     '1'           PERR                                          CSW09
     C                   EXSR      *PSSR                                                       CSW09
     C                   END                                                                   CSW09
      *                                                                   CSW003
      *
      ** Set up parameters for data queue
     C                   MOVEL     'MEISOPRT'    DTAQ             10
     C                   MOVEL     'QTEMP'       LIB              10
     C                   Z-ADD     90            LEN               5 0
     C     DATA          PLIST
     C                   PARM                    DTAQ
     C                   PARM                    LIB
     C                   PARM                    LEN
     C                   PARM                    SDTAQ
      *
      ** Process message reference
     C                   EXSR      REF
      *
      ** Process message detail
     C                   EXSR      DETL
      *
      ** End
     C                   SETON                                        LR
      *
     C/EJECT
      *****************************************************************
      *   REF - Process Message reference file                        *
      *   Called by - Main processing                                 *
      *   Calls - *PSSR                                               *
      *****************************************************************
      *
     C     REF           BEGSR
      *
      ** Access SDMGMEPD for verification flag via access program.
      *
     C                   CALL      'AOMGMER0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDMGME        PARM      SDMGME        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      'ME0861'      DBPGM
     C                   MOVE      '01'          DBASE                           ***************
     C                   MOVEL     'SDMGMEPD'    DBFILE                          * DB ERROR 01 *
     C                   MOVEL     @OPTN         DBKEY                           ***************
     C                   MOVE      '1'           PERR
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *                                                                   E38493
      ** Access SDMMODPD for multibranching indidcator                    E38493
      *                                                                   E38493
     C                   CALL      'AOMMODR0'                                                  E3849
     C                   PARM      '*MSG    '    @RTCD             7                           E3849
     C                   PARM      '*FIRST  '    @OPTN             7                           E3849
     C     SDMMOD        PARM      SDMMOD        DSFDY                                         E3849
      *                                                                   E38493
     C     @RTCD         IFNE      *BLANK                                                      E3849
     C     *LOCK         IN        LDA                                                         E3849
     C                   MOVE      'ME0861'      DBPGM                                         E3849
     C                   MOVE      '07'          DBASE                           **************E3849
     C                   MOVEL     'SDMMODPD'    DBFILE                          * DB ERROR 07 E3849
     C                   MOVEL     @OPTN         DBKEY                           **************E3849
     C                   MOVE      '1'           PERR                                          E3849
     C                   OUT       LDA                                                         E3849
     C                   EXSR      *PSSR                                                       E3849
     C                   END                                                                   E3849
      *
      ** Access message reference file for TRN passed in as parameter
     C     PTRN          CHAIN     MGOREFL0                           98
      *
     C     *IN98         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      'ME0861'      DBPGM
     C                   MOVE      '02'          DBASE                           ***************
     C                   MOVE      'MGOREF'      DBFILE                          * DB ERROR 02 *
     C                   MOVE      PTRN          DBKEY                           ***************
     C                   MOVE      '1'           PERR
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      ** If multiple message go to first part
     C     TRNF          IFNE      *BLANKS
      *
     C     TRNF          CHAIN     MGOREFL0                           98
      *
     C     *IN98         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      'ME0861'      DBPGM
     C                   MOVE      '03'          DBASE                           ***************
     C                   MOVE      'MGOREF'      DBFILE                          * DB ERROR 03 *
     C                   MOVE      TRNF          DBKEY                           ***************
     C                   MOVE      '1'           PERR
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
      ** Save status information for header
     C                   MOVEL     MGST          SAVSTS            4
     C                   MOVEL     MGSG          SAVGRP            1
      *
      ** Establish whether message is a multiple
     C     TRNM          IFNE      *BLANKS
     C                   MOVEL     'Y'           MULT              1
     C                   END
      *
      ** Format message headings & output to DATAQ/MEDTQPRT (R01)
      *
     C                   EXSR      FMTMH
      *
      ** Print a blank line
     C                   MOVE      *BLANKS       SDTAQ
     C                   CALL      'QSNDDTAQ'    DATA
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      *   DETL - Process message detail file                          *
      *   Called by - Main process                                    *
      *   Calls - *PSSR & FLDPRC                                      *
      *****************************************************************
      *
     C     DETL          BEGSR
      *
     C     TRNO          CHAIN     MGOMSGPD                           97
      *
      ** DBASE error if no matching record or EOF
     C     *IN97         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      'ME0861'      DBPGM
     C                   MOVE      '04'          DBASE                           ***************
     C                   MOVE      'MGOMSG'      DBFILE                          * DB ERROR 04 *
     C                   MOVE      TRNO          DBKEY                           ***************
     C                   MOVE      '1'           PERR
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
      ** Save TRN this message
     C                   ELSE
     C                   MOVEL     TRNO          TRNSAV           16
      *
      ** Read remaining records
     C     *IN97         DOWEQ     '0'
      *
      ** Perform detail processing
     C                   EXSR      FLDPRC
     C     TRNSAV        READE     MGOMSGPD                               97
      *
     C                   END
     C                   END
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   FMTMH  Format Msg type/Sender/Destination                   *
      *   Called by - HEADR SR                                        *
      *   Calls -  SWADDR, STADDR, TXADDR, PAPER, QSNDDTAQ            *
      *****************************************************************
      *
      *
     C     FMTMH         BEGSR
      *
     C                   MOVEL     *BLANKS       SDTAQ
     C                   MOVEL     TXT(1)        TX1
      *
      ** Original or copy
     C     MGST          IFEQ      'PRTD'
     C                   MOVEL     TXT(2)        TX22
     C                   ELSE
     C                   MOVEL     TXT(8)        TX2
     C                   END
      *
     C                   MOVEL     MTPY          MTPYK2            3
     C     MTPYK2        CHAIN     SDMTPYL0                           94
      *
      ** If not found move <MSG DESC NOT FOUND> INTO DATA QUEUE
      *
     C                   MOVE      *BLANKS       @MTPY
     C                   MOVEL     MTPY          @MTPY
      *
     C     *IN94         IFEQ      '1'
     C                   MOVE      *BLANKS       @MTPD
     C                   MOVEL     TXT(9)        @MTPD
     C                   ELSE
     C                   MOVE      *BLANKS       @MTPD
     C                   MOVEL     EEMTPD        @MTPD
     C                   END
     C                   CALL      'QSNDDTAQ'    DATA
      *
     C                   MOVEL     *BLANKS       SDTAQ
      *                                                                   E38493
      *   Set up Run Date field                                           E38493
     C                   MOVEL     RDAT          @RDAT                                         E3849
      *                                                                   E38493
      *   When multibranched                                              E38493
     C     BGMBIN        IFEQ      'Y'                                                         E3849
      *
      **  Access SDBRCHL0 for branch name
      *
     C     BRCA          CHAIN     SDBRCHL0                           93
      *
     C     *IN93         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      'ME0861  '    DBPGM
     C                   MOVE      '05'          DBASE                          ***************
     C                   MOVE      PBCH          DBKEY                          * DB ERROR 05 *
     C                   MOVE      'SDBRCHL0'    DBFILE                         ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C                   MOVE      *BLANKS       @A8BRN
     C                   MOVEL     A8BRNM        @A8BRN
      *
     C                   MOVE      *BLANKS       @BRCA
     C                   MOVEL     BRCA          @BRCA
     C**********           MOVE *BLANKS   @RDAT                           E38493
     C**********           MOVELRDAT      @RDAT                           E38493
     C                   MOVE      *BLANKS       TX4
     C                   MOVEL     TXT(4)        TX4
     C                   END                                                                   E3849
     C*                                                                   E38493
     C     MULT          IFNE      'Y'
     C*                                                                   E38493
      ** If single branch system, blank branch code field                 E38493
     C                   MOVE      *BLANKS       TX4                                           E3849
     C*                                                                   E38493
      ** If Midas message output Midas transaction number
     C     SYTM          IFEQ      *BLANKS
     C     MTRN          ANDNE     *BLANKS
     C     SYTM          OREQ      'MIDAS'
     C     MTRN          ANDNE     *BLANKS
     C                   MOVE      *BLANKS       TX3
     C                   MOVEL     TXT(3)        TX3
     C                   MOVE      *BLANKS       @MTRN
     C                   MOVEL     MTRN          @MTRN
     C                   END
     C                   END
     C                   CALL      'QSNDDTAQ'    DATA
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   FLDPRC - Process Field                                      *
      *   Called by - DETL                                            *
      *   Calls - MLTTRN & QSNDDTAQ                                   *
      *****************************************************************
      *
     C     FLDPRC        BEGSR
      *
      ** Initialise tag format field
     C                   MOVE      *BLANKS       EFTAGF
     C                   MOVE      *BLANKS       SAVTAG
     C                   MOVE      *BLANKS       TX5
     C                   MOVE      *BLANKS       @MTAG
     C                   MOVE      *BLANKS       @MFLD
      *
      ** If message tag is not blank
     C     MTAG          IFNE      *BLANKS
      *
      ** Save MTAG
     C                   MOVEL     MTAG          SAVTAG            5
      *
      ** If multiple message and tag is TRN of part
     C     MULT          IFEQ      'Y'
      *
     C                   MOVEL     MTPY          TRNTGK            7
     C                   MOVEL     MTAG          CHAR4             4
     C                   MOVE      CHAR4         TRNTGK
     C     TRNTGK        LOOKUP    TRNTG                                  10
      *
     C     *IN10         IFEQ      '1'
      *
      ** Process multiple TRN field tag
     C                   EXSR      MLTTRN
     C                   END
      *
     C                   END
      *
      ** Clear dataqueue DS
     C                   MOVE      *BLANKS       SDTAQ
      *
      ** Use message tag and message type to access field tag
      ** reference file
     C                   MOVEL     MTAG          MTAGK
     C                   MOVEL     MTPY          MTPYK
     C*                                                                   CSW098
     C** If SWIFT 1998 changes is installed, consider message sequence    CSW098
     C** as well                                                          CSW098
     C*                                                                   CSW098
     C     CSW098        IFEQ      'CSW098 '                                                   CSW09
     C     MSEQ          ANDNE     *BLANKS                                                     CSW09
     C*  Search 1: type specific, sequence specific                       CSW098
     C                   MOVEL     MSEQ          MSEQN                                         CSW09
     C*****KMTAG         CHAIN     SDMTAGL0                           96              CSW09 MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :MTAGK and EFMTPY = :MTPYK and EFMSEQ = :MSEQN                       MD056560
     C/END-EXEC                                                                             MD056560
     C*  Search 2: type specific, sequence generic (blank)                CSW098
     C******IN96         IFEQ      '1'                                                CSW09 MD056560
     C                   IF        SQLCODE = 100                                            MD056560
     C                   MOVEL     *BLANKS       MSEQN                                         CSW09
     C*****KMTAG         CHAIN     SDMTAGL0                           96              CSW09 MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :MTAGK and EFMTPY = :MTPYK and EFMSEQ = :MSEQN                       MD056560
     C/END-EXEC                                                                             MD056560
     C                   ENDIF                                                                 CSW09
     C*  Search 3: type generic ('ALL'), sequence specific                CSW098
     C******IN96         IFEQ      '1'                                                CSW09 MD056560
     C                   IF        SQLCODE = 100                                            MD056560
     C                   MOVEL     'ALL'         MTPYK                                         CSW09
     C                   MOVEL     MSEQ          MSEQN                                         CSW09
     C*****KMTAG         CHAIN     SDMTAGL0                           96              CSW09 MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :MTAGK and EFMTPY = :MTPYK and EFMSEQ = :MSEQN                       MD056560
     C/END-EXEC                                                                             MD056560
     C                   ENDIF                                                                 CSW09
     C*  Search 4: type generic ('ALL'), sequence generic (blank)         CSW098
     C******IN96         IFEQ      '1'                                                CSW09 MD056560
     C                   IF        SQLCODE = 100                                            MD056560
     C                   MOVEL     *BLANKS       MSEQN                                         CSW09
     C*****KMTAG         CHAIN     SDMTAGL0                           96              CSW09 MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :MTAGK and EFMTPY = :MTPYK and EFMSEQ = :MSEQN                       MD056560
     C/END-EXEC                                                                             MD056560
     C                   ENDIF                                                                 CSW09
     C*                                                                   CSW098
     C                   ELSE                                                                  CSW09
     C*                                                                   CSW098
     C*****MGTAGK        CHAIN     SDMTAGL0                           96                    MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :MTAGK and EFMTPY = :MTPYK                                           MD056560
     C/END-EXEC                                                                             MD056560
      *
      ** If no record found just use message tag to access field tag
      ** reference file
     C******IN96         IFEQ      '1'                                                      MD056560
     C                   IF        SQLCODE = 100                                            MD056560
     C                   MOVE      'ALL'         MTPYK
     C*****MGTAGK        CHAIN     SDMTAGL0                           96                    MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :MTAGK and EFMTPY = :MTPYK                                           MD056560
     C/END-EXEC                                                                             MD056560
     C                   ENDIF                                                                 CSW09
      *
     C                   ENDIF                                                                 CSW09
      *                                                                   CSW098
      ** If no record found put <TAG DESC NOT FOUND> into
      ** Message Tag Description part of data queue
     C******IN96         IFEQ      '1'                                                      MD056560
     C                   IF        SQLCODE = 100                                            MD056560
     C                   MOVE      *BLANK        TX5
     C                   MOVEL     TXT(5)        TX5
     C                   END
     C***********          END                                            CSW098
      *
      ** If record tag found move description into corresponding part
      ** of data queue
     C******IN96         IFEQ      '0'                                                      MD056560
     C                   IF        SQLCODE = 0                                              MD056560
     C                   MOVEL     EFISFD        TX5
     C                   END
      *
      **  Move MTAG into corresponding part of data queue
     C                   MOVEL     MTAG          @MTAG
      *
     C                   END
      *                                                                   140629
      ** If /OCMT/ or /CHGS/ then change comma in amount to decimal       140629
      ** point.                                                           140629
      *                                                                   140629
     C     '/OCMT/'      SCAN      MFLD:1                                 81                   14062
      *                                                                   140629
     C     *IN81         IFEQ      *OFF                                                        14062
     C     '/CHGS/'      SCAN      MFLD:1                                 81                   14062
     C                   ENDIF                                                                 14062
      *                                                                   140629
     C     *IN81         IFEQ      *ON                                                         14062
      *                                                                   140629
      ** If ',' in amount change to '.'                                   140629
      *                                                                   140629
     C     ',':'.'       XLATE     MFLD          MFLD                                          14062
     C                   ENDIF                                                                 14062
      *                                                                   140629
      *
      ** Check for verification field
     C/COPY WNCPYSRC,ME0861C001
     C                   MOVEL     MTPY          VERFYK            6
     C                   MOVEL     SAVTAG        CHAR3             3
     C                   MOVE      CHAR3         VERFYK
     C/COPY WNCPYSRC,ME0861C002
     C     VERFYK        LOOKUP    VERFY                                  10
      *
      ** If verification is on AND field is verification field AND
      ** messsage is not released
     C     ENVPM         IFEQ      'Y'
     C     *IN10         ANDEQ     '1'
     C     SAVGRP        ANDEQ     '1'
      *
      ** Move <NOT VERIFIED> into message data field part of data queue
     C                   MOVEL     TXT(6)        @MFLD
      *
      ** Otherwise print message data
     C                   ELSE
      *
     C     EFTAGF        IFNE      *BLANKS
      *
      ** Call appropriate formatting subroutine if required
     C     EFTAGF        CASEQ     'CA '         CASR
     C     EFTAGF        CASEQ     'DCA'         DCASR
     C     EFTAGF        CASEQ     'A'           ASR
     C     EFTAGF        CASEQ     'D'           DSR
     C     EFTAGF        CASEQ     'DT'          DTSR                                          CSW09
     C                   CAS                     CATCH
     C                   END
      *
     C                   ELSE
      *
      **  If saved field tag is an address and the first character
      **  is not a '/'
     C                   MOVEA     SAVTAG        TG
     C                   MOVEL     MFLD          CHAR1             1
     C     TG(2)         IFEQ      '5'
     C     TG(4)         ANDEQ     'A'
     C     CHAR1         ANDNE     '/'
     C     TG(2)         OREQ      '8'                                                         CSW09
     C     TG(4)         ANDEQ     'A'                                                         CSW09
     C     TG(2)         OREQ      '9'                                                         CSW09
     C     TG(4)         ANDEQ     'P'                                                         CSW09
      *
      ** Execute S/R SWADDR to pick up name/town for this SWIFT address
     C     TG(4)         IFEQ      'P'                                                         CSW09
     C     11            SUBST     MFLD:8        ZADDR                                         CSW09
     C                   ELSE                                                                  CSW09
     C                   MOVEL     MFLD          ZADDR
     C                   ENDIF                                                                 CSW09
     C                   EXSR      SWADDR
     C                   MOVEL     MFLD          F5NA             50
     C                   MOVE      ZNAME         F5NA
     C                   MOVE      *BLANKS       @MFLD
     C                   MOVEL     F5NA          @MFLD
      *
     C                   ELSE
      *
      ** If no formatting code and not an address move data to display
      ** field without further processing
     C                   MOVE      *BLANKS       @MFLD
     C                   MOVEL     MFLD          @MFLD
      *
     C                   END
      *
     C                   END
      *
     C                   END
      *
      ** Send report line to Data queue
     C                   CALL      'QSNDDTAQ'    DATA
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   MLTTRN - Process multiple TRN field                         *
      *   Called by - FLDPRC                                          *
      *   Calls - QSNDDTAQ, *PSSR                                     *
      *****************************************************************
      *
     C     MLTTRN        BEGSR
      *
      ***Access*MGOREF*using*field*data*(which*should*contain*TRN****     E29588
      ***of*this*part*when*this*S/R*is*called)***********************     E29588
      **  Access messsage reference file using transaction reference      E29588
      **  of next part (210) or contents of :20: (203)                    E29588
     C******************** MOVELMFLD      MTKEY  16                       E29588
     C     MTPY          IFEQ      '210'                                                       E2958
     C                   MOVEL     TRNM          MTKEY            16                           E2958
     C                   ELSE                                                                  E2958
     C                   MOVEL     MFLD          MTKEY                                         E2958
     C                   END                                                                   E2958
     C     MTKEY         CHAIN     MGOREFL0                           95
      *
     C     *IN95         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      'ME0861'      DBPGM
     C                   MOVE      '06'          DBASE                           ***************
     C                   MOVE      'MGOREF'      DBFILE                          * DB ERROR 06 *
     C                   MOVE      MTKEY         DBKEY                           ***************
     C                   MOVE      '1'           PERR
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      ** Initialise Dataqueue
     C                   MOVEL     *BLANKS       SDTAQ
      *
      ** Send one blank line
     C                   CALL      'QSNDDTAQ'    DATA
      *
      ** Check if part mult message is deleted
     C     PTST          IFEQ      'D'
     C                   MOVE      *BLANK        TX5
     C                   MOVEL     TXT(7)        TX5
     C                   END
      *
     C                   CALL      'QSNDDTAQ'    DATA
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   SWADDR - Format Name/Town from SWIFT address                *
      *   Called by - FLDPRC, FMTMH                                   *
      *   Standard input -  ZADDR, Address, 20A                       *
      *   Standard output - ZNAME, Customer/Countreparty name, 35A    *
      *                     ZTOWN, Customer/Counterparty town, 35A    *
      *                     *IN90 If ON implies no record found       *
      *****************************************************************
      *
     C     SWADDR        BEGSR
      *
      ** Define standard fields
     C                   MOVE      ZADDR         ZADDR            20
     C                   MOVE      *BLANKS       ZNAME            35
     C                   MOVE      *BLANKS       ZTOWN            20
      *
      ** Move standard address to SWIFT address key
     C                   MOVEL     ZADDR         SFWAD            12
      *
      ** First try customer file, SDCUST
     C     SFWAD         CHAIN     SDCUSTSW                           92
     C     *IN92         IFEQ      '0'
     C                   MOVEL     BBCRNM        ZNAME
     C                   MOVEL     BBCRTN        ZTOWN
     C                   ELSE
      *
      ** If not found on customer file, try C/Party Nostro file SDCNST
     C     SFWAD         CHAIN     SDCNSTSW                           92
     C     *IN92         IFEQ      '0'
     C                   MOVEL     AWCPNM        ZNAME
     C                   MOVEL     AWCNTN        ZTOWN
     C                   END
     C                   END
      *
     C                   ENDSR                                                  SWADDR
     C/EJECT
      *****************************************************************
      *   CASR  - Format CURRENCY/AMOUNT subfield                     *
      *   Called by - FLDPRC                                          *
      *****************************************************************
      *
     C     CASR          BEGSR
      *
     C                   MOVEA     *BLANKS       FLD
     C                   MOVEL     MFLD          WK1               1                           18618
     C                   MOVEL     MFLD          MFLD2                                         18618
     C     DIGITS        CHECK     CHAR44                                 47                   18618
     C     WK1           IFEQ      'N'                                                         18618
     C     *IN47         ANDEQ     '1'                                                         18618
     C                   MOVE      MFLD          WK46             46                           18618
     C                   MOVEA     WK46          AMAR                                          18618
     C                   ELSE                                                                  18618
     C                   MOVEL     MFLD          WK3               3
     C                   MOVE      MFLD          WK47             47
     C                   MOVEA     WK47          AMAR
     C                   END                                                                   18618
     C                   Z-ADD     1             A                 2 0
     C     ','           LOOKUP    AMAR(A)                                40
     C     *IN40         IFEQ      '1'
     C                   MOVE      '.'           AMAR(A)
     C                   END
     C     WK1           IFEQ      'N'                                                         18618
     C     *IN47         ANDEQ     '1'                                                         18618
     C                   MOVEA     WK1           FLD(1)                                        18618
     C                   MOVEA     CHAR24        FLD(3)                                        18618
     C                   MOVEA     AMAR          FLD(7)                                        18618
     C                   ELSE                                                                  18618
     C                   MOVEA     WK3           FLD(1)
     C                   MOVEA     AMAR          FLD(5)
     C                   END                                                                   18618
      *
     C                   MOVE      *BLANK        @MFLD
     C                   MOVEA     FLD           @MFLD
      *
     C                   ENDSR                                                  CASR
     C/EJECT
      *****************************************************************
      *   DCASR - DATE/CCY/AMOUNT subfield                            *
      *  nb. This program is for ISO print, so dates should remain in *
      *      ISO (ie YYMMDD) format, despite the fact that elsewhere  *
      *      they are formatted to MMDDYY or DDMMYY depending on ICD. *
      *   Called by - FLDPRC                                          *
      *****************************************************************
      *
     C     DCASR         BEGSR
      *
     C                   MOVEA     *BLANKS       AMAR
     C                   MOVEA     MFLD          FLD
     C                   MOVEL     MFLD          MFLD2                                         CSW09
     C     DIGITS        CHECK     CHAR7                                  47                   CSW09
     C     *IN47         IFEQ      '1'                                                         CSW09
     C                   MOVEA     FLD(10)       AMAR
     C                   ELSE                                                                  CSW09
     C                   MOVEA     FLD(12)       AMAR                                          CSW09
     C                   ENDIF                                                                 CSW09
     C                   Z-ADD     1             A
     C     ','           LOOKUP    AMAR(A)                                40
     C     *IN40         IFEQ      '1'
     C                   MOVE      '.'           AMAR(A)
     C                   END
     C     *IN47         IFEQ      '1'                                                         CSW09
     C                   MOVEA     FLD(7)        WK3
     C                   MOVEL     MFLD          DAT
      *
      ** By this stage, AMAR contains amount, WK3 contains currency
      ** and DAT (a DS - YY MM DD) contains date
     C                   MOVEA     *BLANKS       FLD
     C                   MOVEA     YY            FLD(1)
     C                   MOVEA     '/'           FLD(3)
     C                   MOVEA     MM            FLD(4)
     C                   MOVEA     '/'           FLD(6)
     C                   MOVEA     DD            FLD(7)
     C                   MOVEA     WK3           FLD(10)
     C                   MOVEA     AMAR          FLD(14)
     C                   ELSE                                                                  CSW09
     C                   MOVEA     FLD(9)        WK3                                           CSW09
     C                   MOVEL     MFLD          DAT3                                          CSW09
     C                   MOVEA     *BLANKS       FLD                                           CSW09
     C                   MOVEA     YY3           FLD(1)                                        CSW09
     C                   MOVEA     '/'           FLD(5)                                        CSW09
     C                   MOVEA     MM3           FLD(6)                                        CSW09
     C                   MOVEA     '/'           FLD(8)                                        CSW09
     C                   MOVEA     DD3           FLD(9)                                        CSW09
     C                   MOVEA     WK3           FLD(12)                                       CSW09
     C                   MOVEA     AMAR          FLD(16)                                       CSW09
     C                   ENDIF                                                                 CSW09
      *
     C                   MOVE      *BLANK        @MFLD
     C                   MOVEA     FLD           @MFLD
      *
     C                   ENDSR                                                  DCASR
     C/EJECT
      *****************************************************************
      *   ASR - AMOUNT subfield                                       *
      *   Called by - FLDPRC                                          *
      *****************************************************************
      *
     C     ASR           BEGSR
      *
     C                   MOVEA     MFLD          AMAR
     C                   Z-ADD     1             A                 2 0
     C     ','           LOOKUP    AMAR(A)                                40
     C     *IN40         IFEQ      '1'
     C                   MOVE      '.'           AMAR(A)
     C                   END
     C                   MOVE      *BLANK        @MFLD
     C                   MOVEA     AMAR          @MFLD
      *
     C                   ENDSR                                                  ASR
     C/EJECT
      *****************************************************************
      *   DSR - DATE subfield                                         *
      *  nb. This program is for ISO print, so dates should remain in *
      *      ISO (ie YYMMDD) format, despite the fact that elsewhere  *
      *      they are formatted to MMDDYY or DDMMYY depending on ICD. *
      *   Called by - FLDPRC                                          *
      *****************************************************************
      *
     C     DSR           BEGSR
      *
     C                   MOVEA     *BLANKS       FLD
      *
      ** Check for defined qualifiers, issuer codes or type in the form   CSW098
      **  MFLD = ':QUAL//TYPE/YYYYMMDD' whereby formatting should         CSW098
      ** only be done on the YYYYMMDD.                                    CSW098
      *                                                                   CSW098
     C                   MOVE      *BLANKS       WMFLD            50                           CSW09
     C                   MOVE      *BLANKS       WFLA             50                           CSW09
     C                   MOVE      *BLANKS       WFLD             50                           CSW09
      *                                                                   CSW098
     C     1             SUBST     MFLD:1        @WM1              1                           CSW09
     C     @WM1          IFEQ      ':'                                          Qualifier StartCSW09
     C     '/'           SCAN      MFLD:7        C                 2 0          Issuer Code EndCSW09
      *                                                                   CSW098
     C     C             IFNE      0                                                           CSW09
     C                   ADD       1             C                                             CSW09
     C     '/'           SCAN      MFLD:C        D                 2 0          Type End       CSW09
     C     D             IFNE      0                                                           CSW09
     C                   Z-ADD     D             C                                             CSW09
     C                   ELSE                                                                  CSW09
     C                   SUB       1             C                                             CSW09
     C                   ENDIF                                                                 CSW09
     C     C             SUBST     MFLD          WMFLD                                         CSW09
     C                   ADD       1             C                                             CSW09
     C                   SUBST     MFLD:C        WFLA                                          CSW09
     C                   ENDIF                                                                 CSW09
      *                                                                   CSW098
     C                   ELSE                                                                  CSW09
     C                   MOVEL     MFLD          WFLA                                          CSW09
     C                   ENDIF                                                                 CSW09
      *                                                                   CSW098
     C***********          MOVELMFLD      DAT                      CSW097 CSW098
     C***********          MOVELMFLD      MFLD2                    CSW097 CSW098
     C                   MOVEL     WFLA          DAT                                           CSW09
     C                   MOVEL     WFLA          MFLD2                                         CSW09
     C     DIGITS        CHECK     CHAR7                                  47                   CSW09
      *                                                                   CSW097
      ** The seventh character is not numeric.                            CSW097
      *                                                                   CSW097
     C     *IN47         IFEQ      '1'                                                         CSW09
     C***********          MOVEADD        FLD,1                           086802
     C                   MOVEA     YY            FLD(1)                                        08680
     C                   MOVEA     '/'           FLD(3)
     C                   MOVEA     MM            FLD(4)
     C                   MOVEA     '/'           FLD(6)
     C***********          MOVEAYY        FLD,7                           086802
     C                   MOVEA     DD            FLD(7)                                        08680
     C                   ELSE                                                                  CSW09
     C***********          MOVELMFLD      DAT3                     CSW097 CSW098
     C                   MOVEL     WFLA          DAT3                                          CSW09
     C                   MOVEA     YY3           FLD(1)                                        CSW09
     C                   MOVEA     '/'           FLD(5)                                        CSW09
     C                   MOVEA     MM3           FLD(6)                                        CSW09
     C                   MOVEA     '/'           FLD(8)                                        CSW09
     C                   MOVEA     DD3           FLD(9)                                        CSW09
     C                   ENDIF                                                                 CSW09
      *
     C                   MOVE      *BLANK        @MFLD
     C     WMFLD         IFNE      *BLANKS                                                     CSW09
     C                   MOVEL     WMFLD         @MFLD                                         CSW09
     C                   MOVEA     FLD           WFLD                                          CSW09
     C                   CAT       WFLD:0        @MFLD                                         CSW09
     C                   ELSE                                                                  CSW09
     C                   MOVEA     FLD           @MFLD
     C                   ENDIF                                                                 CSW09
      *
     C                   ENDSR                                                  DSR
     C/EJECT                                                              CSW098
      *****************************************************************   CSW098
      *   DTSR - DATE/TIME field                                      *   CSW098
      *   Called by - FLDPRC                                          *   CSW098
      *****************************************************************   CSW098
      *                                                                   CSW098
     C     DTSR          BEGSR                                                                 CSW09
      *                                                                   CSW098
      **  Output date part                                                CSW098
      *                                                                   CSW098
     C                   EXSR      DSR                                                         CSW09
      *                                                                   CSW098
     C                   MOVE      *BLANKS       WFLD                                          CSW09
      *                                                                   CSW098
     C     *IN47         IFEQ      '1'                                                         CSW09
     C     2             SUBST     WFLA:7        @WL2              2                           CSW09
     C                   MOVEL     @WL2          WFLD                                          CSW09
     C                   CAT       ':':0         WFLD                                          CSW09
     C     2             SUBST     WFLA:9        @WL2                                          CSW09
     C                   CAT       @WL2:0        WFLD                                          CSW09
     C                   CAT       ':':0         WFLD                                          CSW09
     C     2             SUBST     WFLA:11       @WL2                                          CSW09
     C                   CAT       @WL2:0        WFLD                                          CSW09
     C                   ELSE                                                                  CSW09
     C     2             SUBST     WFLA:9        @WL2                                          CSW09
     C                   MOVEL     @WL2          WFLD                                          CSW09
     C                   CAT       ':':0         WFLD                                          CSW09
     C     2             SUBST     WFLA:11       @WL2                                          CSW09
     C                   CAT       @WL2:0        WFLD                                          CSW09
     C                   CAT       ':':0         WFLD                                          CSW09
     C     2             SUBST     WFLA:13       @WL2                                          CSW09
     C                   CAT       @WL2:0        WFLD                                          CSW09
     C                   ENDIF                                                                 CSW09
      *                                                                   CSW098
     C                   CAT       WFLD:1        @MFLD                                         CSW09
      *                                                                   CSW098
     C                   ENDSR                                                                 CSW09
     C/EJECT
      *****************************************************************
      *   CATCH - CATCHALL subfield format                            *
      *   Called by - FLDPRC                                          *
      *****************************************************************
      *
     C     CATCH         BEGSR
      *
     C                   MOVE      *BLANK        @MFLD
     C                   MOVEL     MFLD          @MFLD
      *
     C                   ENDSR                                                  CATCH
     C/EJECT
      *****************************************************************
      *   *PSSR - Error handling                                      *
      *   Called by - REF, DETL, MLTTRN                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   MOVE      '1'           PERR
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN
      *
     C                   ENDSR
     C/COPY WNCPYSRC,ME0861C003
** CPY@   **      Object copyright
(c) Finastra International Limited 2001
** TEXT - Text for labels
Message type
*** COPY ***
Trans. no.
Branch
<TAG DESC NOT FOUND>
<NOT VERIFIED>
***DELETED***
*** ORIGINAL ***
<MSG DESC NOT FOUND>
** VERFY - Message types/fields requiring verification
100:32
202:32
203:19
203:30
203:32
103:32
** TRNTG - Multiple TRN Message types/fields
203:20:
210:21:
     X/COPY WNCPYSRC,ME0861X001
