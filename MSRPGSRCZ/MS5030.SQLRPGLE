     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058081
/*STD *  RPGSQLBND                                                    *                     MD058081
/*EXI *  TEXT('Midas MS Incoming Messages Index Gen.')                *
      *****************************************************************
      *                                                               *
      *  Midas - SWIFT DIRECT LINK                                    *
      *                                                               *
      *   MS5030 - INCOMING MESSAGES INDEX GENERATION                 *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058081           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR978486           Date 25May12               *
      *                 CSW212             Date 03May12               *
      *                 220400             Date 07Aug03               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 240749             Date 06Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CRE008             Date 23May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 186951             Date 09Oct01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                  184427            DATE 02Oct00               *
      *                  184013            DATE 20Sep00               *
      * Midas DBA 3.02 -----------------------------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                  149261            Date 15Jun99               *
      *                  141572            DATE 21SEP98               *
      *                  140532            Date 11Aug98               *
      *                  124673            DATE 04Jun98               *
      *                  113352            DATE 13FEB97               *
      *                  123750            DATE 03JUL97               *
      *                  101218            DATE 21JUN96               *
      *                  088608            DATE 10OCT95               *
      *                  088226            DATE  6OCT95               *
      *                  CSW095            DATE 10APR95               *
      *                  068107            DATE 16JAN94               *
      *                  S01435            DATE 09SEP93               *
      *                  S01449            DATE 19NOV93               *
      *                  061806            DATE 09NOV93               *
      *                  059254            DATE 09NOV93               *
      *                  E33897            DATE 22OCT91               *
      *                  S01310            DATE 06DEC90               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058081 - Deliverable Data Split for ME and MS              *
      *  MD046248 - Finastra Rebranding                               *
      *  AR978486 - Error in message format generation in MT370 using *
      *              SWIFT Messages Index Generation Protocol         *
      *  CSW212 - SWIFT 2012 Changes                                  *
      *  220400 - Field :22B: should only be processed for message    *
      *           MT320 (Maturity Conf.) Addendum to 186951.          *
      *  240749 - Fix 186951 causes index error if field 22B is not   *
      *            present as it cannot exit from the DO loop.        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *   CRE008 - Cash Management                                    *
      *            Here, add type 103 in TABTYP to extract            *
      *            date and amount in MSIXI2PD                        *
      *   186951 - If a maturity MT320 flag for TRAM as processed     *
      *   184427 - Add MT340s and MT360s                              *
      *   184013 - Swift 2000 get correct date format from 30V        *
      *   149261 - Initialise century field for MSIXI2PD.             *
      *   141572 - Recompile over MGOREFPD                            *
      *   140532 - SWIFT98 fix                                        *
      *            Crashes if incoming message contains :20C: instead *
      *            of :20:. Format of :20C: is :20C::CCCC//TRN...     *
      *   124673 - Add Century field to key list.                     *
      *   113352 - Recompile over changes in MGOREFPD                 *
      *   123750 - SWIFT 1997 changes (CSW097)                        *
      *             o change to format of MT300                       *
      *   101218 - Correct the read through SDBRCHPD - use  SETLL     *
      *            rather than CHAIN to position Branch Codes file.   *
      *   088608 - The pgm does not remove the LT ID from the         *
      *            incoming SWIFT msgs and this causes inconsistency  *
      *            between the MSDL and IMM enquirys.                 *
      *            For MSDL enq by sender, the pgm expects BIC+LT ID  *
      *            For IMM enq, the pgm expects BIC only.             *
      *            For MSDL, even if the Sender customer record exists*
      *            in Midas, it cannot be chained to due to LT added  *
      *   088226 - If the client is not running True Multibranching,  *
      *            (no way to specify whether or not in existing sys) *
      *            the branch code assigned to the SWIFT Incoming     *
      *            Message file is based on the destination SWIFT adr *
      *            from the msg.  However, all SWIFT msgs with        *
      *            same PBOCCNBJAXXX and all TIDs defined in the      *
      *            branch code the same.  Therefore the existing      *
      *            logic will pick up the lowest branch code and      *
      *            assigned to the SWIFT msg.                         *
      *            Therefore the fix will try to access MEINMVPD      *
      *            for the default branch code.  If the IMM feature   *
      *            is not used or the default branch code not defined *
      *            in the IMM routing table, the existing pgm logic   *
      *            will be followed.                                  *
      *   CSW095 - S.W.I.F.T 1995 Message Changes.                    *
      *            Increase arrays to handle a 10,000 character       *
      *            message.                                           *
      *   068107 - Add check of MIR and if found then mark as         *
      *            processed by IMM                                   *
      *            This check is performed irrespective of msg status *
      *   S01435 - Incoming Message Management                        *
      *            Recompile for MSMSI2LH change.                     *
      *            Allow processing of messages with no :20 i.e. 094. *
      *   S01449 - Autorecs II module                                 *
      *   061806 - Use destination address instead of sender address  *
      *   059254 - Set up branch code in MSIXI2PD based on the first  *
      *            8 characters of the destination address instead    *
      *            of the last 3 char on the destination address.     *
      *   E33897 - USE A NEW LOGICAL TO OMIT ALL PROCESSED RECORDS    *
      *            RATHER THAN CHECKING FOR THIS IN THE PROGRAM, TO   *
      *            SPEED UP PROCESSING SINCE PROGRAM WILL NOT HAVE TO *
      *            READ THROUGH ALL RECORDS ON MSMSI2PD.              *
      *   S01310 - SWIFT RATIONALISATION                              *
      *                                                               *
      *****************************************************************
     F*MSMSI2L3UF**E           K        DISK                              E33897
     FMSMSI2LX  UF   E           K DISK                                         E33897
     F                                     COMMIT
     F                                     RENAME(MSMSI2D0:MSMSI23F)            S01310
     FMSMSI2LH  UF   E           K DISK                                         S01310
     F                                     COMMIT                               S01310
     F                                     RENAME(MSMSI2D0:MSMSI2HF)            S01310
     FMSIXI2PD  O    E             DISK
     F                                     COMMIT
     FSDBRCHL0  IF   E           K DISK                                         S01310
     FSDCUSTL7  IF   E           K DISK                                         S01310
     F*SADR***IF**E********   K        DISK                               S01310
     FMGOREFL0  IF   E           K DISK                                         S01310
     F*MEINMVL1* IF   E           K DISK                                         088226     MD058081
     F/COPY WNCPYSRC,MS5030F001
      *
      **  ID F  C  H  L    FUNCTION OF INDICATORS
      **********10*********EOF MSMSI2L3                                   E33897
      *         10         EOF MSMSI2LX                                   E33897
      *         11         Chain fail on SDCUSTL7                         S01310
      **********11*********Chain fail on MSADR                            S01310
      *         12         EOF SDBRCHL0                                   S01310
      *         13         EOF MGOREFL0                                   S01310
      *         14         Chain fail on MEINMVL1                         088226
      *         20         Message type not on table
      *         U7,U8,LR   DB error
      *
     D********************TABTYP  1  13  3   TABCAS  1   Message type     S01310
     D***********         TABTYP  1  14  3   TABCAS  1   Message typS01310184427
     D***********         TABTYP  1  19  3   TABCAS  1   Message ty 184427CRE008
     D**********          TABTYP  1  20  3   TABCAS  1   Message type                  CRE008 CSW212
     D TABTYP          S              3    DIM(22) CTDATA PERRCD(1)
     D TABCAS          S              1    DIM(22) ALT(TABTYP)
     D TABTY2          S              3    DIM(1) CTDATA PERRCD(1)
     D TABAMC          S             10    DIM(1) ALT(TABTY2)
     D TABTY3          S              3    DIM(1) CTDATA PERRCD(1)
     D TABDAT          S             10    DIM(1) ALT(TABTY3)
     D***********         IMSG     3072  1               Incoming message CSW095
     D INT             S              1    DIM(36)                              Date, amount or ccy
     D/COPY WNCPYSRC,MS5030E001
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)                               S01
      *
     D*LINTCBF*************                                               S01310
     D**************CNUM***                         CNUMI                 S01310
      *                                                                   S01449
     D/COPY WNCPYSRC,MS5030I002
     D PSDS           SDS                                                       S01449
     D  PGMJOB               244    253                                         S01449
     D  PGMUSR               254    263                                         S01449
     D  PGMJNO               264    269                                         S01449
      *
     D MDTA            DS           256
     D  DDID                   7     18                                         061806
     D  DDDR                   7     14                                         061806
     D  DERM                  15     15                                         061806
     D  DRAN                  16     18                                         061806
     D  SDID                  47     58
     D  ADDR                  47     54
     D  TERM                  55     55
     D  BRAN                  56     58
      **  Sender's TID
      *
     D A8BTID          DS            12                                         059254
     D*                                                                   059254
     D** Branch's TID address                                             059254
     D*                                                                   059254
     D  ADDR1                  1      8                                         059254
     D  BRAN1                 10     12                                         059254
     D MSKEY           DS            38
     D  MODE                   1      6  0
     D  MOTM                   7     10  0
     D  MOR                   11     38
      **  Key for database errors
      *
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      **  Local data area
      *
     D D@IMSG          DS          9999                                         123750
     D  IMSG                   1   9999                                         123750
     D                                     DIM(9999)                            Incoming message CSW
      ** String representation of incoming message for scan operation     123750
      *                                                                   123750
     D DSRUN           DS            13
     D  RUNA                   1      7
     D  MRDT                   8     10P 0                                      S01449
     D  MBIN                  13     13
      **  RUNDAT data area
      *                                                                   S01449
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                    S01449
      *                                                                   S01449
     D DSFDY         E DS                  EXTNAME(DSFDY)                       S01449
     D/COPY WNCPYSRC,MS5030I001
      *                                                                                       CSW212
     D MEINMV        E DS                  EXTNAME(MEIVMJW0)                                MD058081
     D DIGITS          C                   CONST('0123456789')
      *                                                                   S01449
      **  First data structure for access program, Short data structure   S01449
      *                                                                   S01449
      **  MMOD details                                                    S01449
      *                                                                   S01449
      **  Parameters passed to AOMMODR0                                   S01449
      *                                                                   S01449
     C     PLIST1        PLIST                                                                 S0144
     C                   PARM      '*DBMSG  '    @RTCD             7                           S0144
     C                   PARM      '*FIRST  '    @OPTN             7                           S0144
     C     SDMMOD        PARM      SDMMOD        DSFDY                                         S0144
      *
     C     IMKEY         KLIST
     C                   KFLD                    MODEC                                         12467
     C                   KFLD                    MODE
     C                   KFLD                    MOTM
     C                   KFLD                    MOR
      *                                                                   088226
     C     IVKEY         KLIST                                                                 08822
     C                   KFLD                    P0NWRK                                        08822
     C                   KFLD                    P0MTPY                                        08822
      *
      *****************************************************************
      *                   Index to subroutines                        *
      *   main process                                                *
      *   INIT  - initial process                                     *
      *   TYPA  - process 100/200/202/300/320/324/330/900/910         *
      *           600                                                 *                       CSW212
      *   TYPB  - process 201/203                                     *
      *   TYPC  - process 950/203                                     *
      *   TYPD  - process 350                                         *
      *   TYPE  - process 370                                         *                       CSW212
      *   SRCH  - search for field tag ':99'                          *
      *   *PSSR - error handling                                      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *   main process                                                *
      *   Calls - INIT initial process                                *
      *           TYPA process 100/200/202/300/320/324/330/900/910    *
      *                        600                                    *                       CSW212
      *           TYPB process 201/203                                *
      *           TYPC process 950/203                                *
      *           TYPD process 350                                    *
      *           TYPE process 370                                    *                       CSW212
      *****************************************************************
      *
     C                   EXSR      INIT
      *
      **  Repeat until end of file reached
     C***********          READ MSMSI2L3                 10               E33897
     C                   READ      MSMSI2LX                               10                   E3389
     C     *IN10         DOWEQ     '0'
      *
      ****If*message has already been processed, go to next message       E33897
     C***********MSPF      IFEQ 'Y'                                       E33897
     C************IN10     DOWEQ'0'                                       E33897
     C***********IMKEY     READEMSMSI2L3                 10               E33897
     C***********          END                                            E33897
      *
      **  Format TID for chain to Client file
     C***********          ELSE                                           E33897
     C                   MOVE      *BLANKS       @WK12            12
     C***********TERM      IFEQ 'X'                                       088608
     C***********BRAN      IFEQ 'XXX'                                     088608
     C***********          MOVELADDR      @WK12                           088608
     C***********          ELSE                                           088608
     C***********          MOVE BRAN      @WK11  11                       088608
     C***********          MOVELADDR      @WK11                           088608
     C***********          MOVEL@WK11     @WK12                           088608
     C***********          END                                            088608
     C***********          ELSE                                           088608
     C***********BRAN      IFEQ 'XXX'                                     088608
     C***********          MOVE TERM      @WK9    9                       088608
     C***********          MOVELADDR      @WK9                            088608
     C***********          MOVEL@WK9      @WK12                           088608
     C***********          ELSE                                           088608
     C***********          MOVE SDID      @WK12                           088608
     C***********          END                                            088608
     C***********          END                                            088608
      *                                                                   088608
      ** The Sender SWIFT address should be formatted as follows:         088608
      ** pick up the Sender Address + Branch Code (not = XXX).            088608
      ** As standard SWIFT address is either 8 chars or 11 chars and      088608
      ** this will match with MIDAS customer details SWIFT address        088608
      ** format.  Otherwsie there is no meaning in chaining back to       088608
      ** customer details file.                                           088608
      *                                                                   088608
     C     BRAN          IFEQ      'XXX'                                                       08860
     C                   MOVEL     ADDR          @WK12                                         08860
     C                   ELSE                                                                  08860
     C                   MOVEL     ADDR          @WK11                                         08860
     C                   MOVE      BRAN          @WK11            11                           08860
     C                   MOVEL     @WK11         @WK12                                         08860
     C                   END                                                                   08860
      *
      **  If MIDAS branch
     C                   MOVE      *BLANKS       @BRCA                                         S0131
     C     MBIN          IFEQ      'Y'                                                         S0131
     C     *LOVAL        SETLL     SDBRCHL0                           12                       10121
     C                   READ      SDBRCHL0                               12                   05925
     C*                                                                   059254
     C** Search SDBRCHPD for branch code by comparing the first 8 and     059254
     C** the last 3 chars of the destination address with the branch      059254
     C** TID address in SDBRCHPD.                                         059254
     C*                                                                   059254
     C********** *LOVAL****CHAINSDBRCHL0             12            S01449 101218
     C     *IN12         DOWNE     '1'                                                         05925
     C     @BRCA         ANDEQ     *BLANKS                                                     05925
     C***********ADDR      IFEQ ADDR1                              059254 061806
     C     DDDR          IFEQ      ADDR1                                                       06180
     C***********BRAN      ANDEQBRAN1                              059254 061806
     C     DRAN          ANDEQ     BRAN1                                                       06180
     C                   MOVE      A8BRCD        @BRCA             3                           05925
     C                   END                                                                   05925
     C                   READ      SDBRCHL0                               12                   05925
     C                   END                                                                   05925
     C*                                                                   059254
     C** If no match was found, search SDBRCHPD again but this time,      059254
     C** use the first 8 chars only in the compare.                       059254
     C*                                                                   059254
     C     @BRCA         IFEQ      *BLANKS                                                     05925
     C     *BLANKS       SETLL     SDBRCHL0                                                    05925
     C                   READ      SDBRCHL0                               12                   05925
     C     *IN12         DOWNE     '1'                                                         05925
     C     @BRCA         ANDEQ     *BLANKS                                                     05925
     C***********ADDR      IFEQ ADDR1                              059254 061806
     C     DDDR          IFEQ      ADDR1                                                       06180
     C                   MOVE      A8BRCD        @BRCA                                         05925
     C                   END                                                                   05925
     C                   READ      SDBRCHL0                               12                   05925
     C                   END                                                                   05925
     C                   END                                                                   05925
     C***********BRAN      CHAINSDBRCHL0             12            S01310 059254
     C************IN12     IFEQ '0'                                S01310 059254
     C***********          MOVE BRCA      @BRCA   3                S01310 059254
     C***********          END                                     S01310 059254
     C                   END                                                                   S0131
      *                                                                   088226
      ** If the client is not a True Multi-branching environment, the     088226
      ** SWIFT BIC of the destination address will be the same among      088226
      ** all branch codes so the above process will pick up the lowest    088226
      ** sequence one.  This will cause problem in incoming SWIFT         088226
      ** enquiry.                                                         088226
      ** Try another approach to default the branch code for all          088226
      ** incoming SWIFT messages using the IMM Message Routing Table.     088226
      ** However, if no default branch code defined in IMM, this fix      088226
      ** will not set the default as well. i.e. use existing logic.       088226
      ** If this way is not satisfied, DO NOT SET W0TMBI TO 'Y'.          088226
      *                                                                   088226
     C     W0TMBI        IFEQ      'N'                                                         08822
     C                   MOVEL     *BLANK        P0NWRK            6                           08822
     C                   MOVEL     *BLANK        P0MTPY            3                           08822
     C                   MOVEL     'SWIFT'       P0NWRK                                        08822
     C                   MOVEL     'ALL'         P0MTPY                                        08822
     C*****IVKEY         CHAIN     @INMVL1                            14              08822 MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEINMV                                                                        MD058081
     C+ from MEIVMJW0                                                                       MD058081
     C+ where MVNWRK = :P0NWRK and MVMTPY = :P0MTPY                                         MD058081
     C+   and MVRECI = 'D'                                                                  MD058081
     C/END-EXEC                                                                             MD058081
     C******IN14         IFEQ      '0'                                                08822 MD058081
     C     SQLCODE       IFEQ      0                                                  08822 MD058081
     C/COPY WNCPYSRC,MS5030C002
     C     MVBRCA        IFNE      *BLANK                                                      08822
     C                   MOVEL     MVBRCA        @BRCA                                         08822
     C                   END                                                                   08822
     C/COPY WNCPYSRC,MS5030C003
     C                   END                                                                   08822
     C                   END                                                                   08822
      *                                                                   S01310
     C     @WK12         CHAIN     SDCUSTL7                           11                       S0131
     C***********@WK12*****CHAINMSADR                11                   S01310
     C     *IN11         IFEQ      '0'
     C                   MOVE      BBCUST        CNUM                                          S0131
     C*********************MOVE CNUMI     CNUM                            S01310
     C                   ELSE
     C                   MOVE      *BLANK        CNUM
     C                   END
     C                   MOVE      @WK12         STID
      *
      **  Move all records which match key into array
     C***********          Z-ADD1         X       40                      CSW095
     C                   Z-ADD     1             X                 5 0                         CSW09
     C     *IN10         DOWEQ     '0'
     C                   MOVEA     MDTA          IMSG(X)
     C***********IMKEY     READEMSMSI2L3                 10               E33897
     C     IMKEY         READE     MSMSI2LX                               10                   E3389
     C                   ADD       256           X
     C                   END
     C                   SETOFF                                       10
      *
      **  Search MDTA for field tag 20
     C                   MOVE      ':20'         @TAG
     C                   EXSR      SRCH
      *
      **  Move TRN into array
     C     TGNF          IFEQ      'N'                                                         S0143
     C                   Z-ADD     1             A
     C                   MOVEA     *BLANKS       INT
      *                                                                   140532
     C     @WK5          IFEQ      ':20C:'                                                     14053
     C                   ADD       7             X                                             14053
     C                   ENDIF                                                                 14053
      *                                                                   140532
     C     IMSG(X)       DOUEQ     CR
     C                   MOVE      IMSG(X)       INT(A)
     C                   ADD       1             X
     C                   ADD       1             A
     C                   END
     C                   MOVEA     INT           @TRNO            16
      *
      **  Determine message type
     C     MTPY          LOOKUP    TABTYP        TABCAS                   20
     C     *IN20         IFEQ      '1'
     C     TABCAS        CASEQ     'A'           TYPA
     C     TABCAS        CASEQ     'B'           TYPB
     C     TABCAS        CASEQ     'C'           TYPC
     C     TABCAS        CASEQ     'D'           TYPD
     C     TABCAS        CASEQ     'E'           TYPE
     C                   END
     C                   ELSE
     C                   MOVE      *BLANK        SVDT
     C                   MOVE      *BLANK        AMTS
     C                   MOVE      *BLANK        CCY
     C                   MOVE      *BLANK        FD25
     C                   END
     C                   ELSE                                                                  S0143
     C                   MOVEL     *BLANK        SVDT                                          S0143
     C                   MOVEL     *BLANK        AMTS                                          S0143
     C                   MOVEL     *BLANK        CCY                                           S0143
     C                   MOVEL     *BLANK        FD25                                          S0143
     C                   END                                                                   S0143
      *                                                                   068107
      * Check for duplicate messages and set IMPF accordingly             068107
      *                                                                   068107
     C                   EXSR      SRSPD                                                       06810
      *                                                                   S01449
      **  Download Autorec fields to MSIXI2PD file                        S01449
     C**********           MOVE CNUM      #CNUM   60                                   S01449 CSD027
     C                   MOVE      CNUM          #CNUM             6
     C                   MOVE      *BLANK        R3RPTS                                        S0144
     C                   Z-ADD     *ZEROS        R3SDAT                                        S0144
     C                   Z-ADD     *ZEROS        R3STIM                                        S0144
     C                   MOVE      *BLANKS       R3LJOB                                        S0144
     C                   MOVE      *BLANKS       R3LUSR                                        S0144
     C                   MOVE      *BLANKS       R3LJNO                                        S0144
      *                                                                   S01449
      ** Autorecs installed ?                                             S01449
     C     MTPY          IFEQ      '940'                                                       S0144
     C     BGAURC        ANDEQ     'Y'                                                         S0144
     C     MTPY          OREQ      '950'                                                       S0144
     C     BGAURC        ANDEQ     'Y'                                                         S0144
     C*                                                                   S01449
     C** If no customer record - download autorec information or          S01449
     C** If customer record found, check suppress download flag           S01449
     C     BBSSDL        IFNE      'Y'                                                         S0144
     C********** #CNUM     OREQ *ZEROS                                                 S01449 CSD027
     C     #CNUM         OREQ      *BLANKS
     C                   MOVE      'A'           R3RPTS                                        S0144
     C                   Z-ADD     MRDT          R3SDAT                                        S0144
     C                   MOVE      #TIME         R3STIM                                        S0144
     C                   MOVE      PGMJOB        R3LJOB                                        S0144
     C                   MOVE      PGMUSR        R3LUSR                                        S0144
     C                   MOVE      PGMJNO        R3LJNO                                        S0144
     C                   END                                                                   S0144
     C                   END                                                                   S0144
      *
      **  Output record to MSIXI2PD and update rest of records for this
      **  message
     C                   MOVE      @BRCA         BRCA                                          S0131
     C                   MOVE      @TRNO         TRNO
     C/COPY WNCPYSRC,MS5030C001
     C                   WRITE     MSIXI2D0
      *
     C***********IMKEY     CHAINMSMSI2L3             10                   E33897
     C     IMKEY         CHAIN     MSMSI2LX                           10                       E3389
     C     *IN10         DOWEQ     '0'
     C                   MOVE      'Y'           MSPF
     C                   MOVE      @BRCA         BRCA                                          S0131
     C                   MOVE      @TRNO         TRNO
     C                   UPDATE    MSMSI23F                                                    S0131
     C*********************UPDATMSMSI2D0                                  S01310
     C***********IMKEY     READEMSMSI2L3                 10               E33897
     C     IMKEY         READE     MSMSI2LX                               10                   E3389
     C                   END
      *
     C                   COMMIT
      *
     C***********          END                                            E33897
     C***********IMKEY     SETGTMSMSI2L3                                  E33897
     C***********          READ MSMSI2L3                 10               E33897
     C     IMKEY         SETGT     MSMSI2LX                                                    E3389
     C                   READ      MSMSI2LX                               10                   E3389
     C                   END
      *
      **  Obtain branch for acknowledgements & update MSMSI2LH
     C                   READ      MSMSI2LH                               10                   S0131
     C     *IN10         DOWEQ     '0'                                                         S0131
      *                                                                   S01310
     C     MSPF          IFNE      'Y'                                                         S0131
     C     TRNO          CHAIN     MGOREFL0                           13                       S0131
     C     *IN13         IFEQ      '0'                                                         S0131
     C                   MOVE      'Y'           MSPF                                          S0131
     C                   EXCEPT                                                                S0131
     C                   END                                                                   S0131
     C                   END                                                                   S0131
      *                                                                   S01310
     C                   COMMIT                                                                S0131
     C                   READ      MSMSI2LH                               10                   S0131
     C                   END                                                                   S0131
      *
     C                   SETON                                        LR
     C/EJECT                                                              068107
      *****************************************************************   068107
      *                                                               *   068107
      *  SRSPD    : Search MSIXI2PD for existing message              *   068107
      *                                                               *   068107
      *  CALLED BY: Main processing                                   *   068107
      *                                                               *   068107
      *****************************************************************   068107
     CSR   SRSPD         BEGSR                                                                 06810
      *                                                                   068107
      * Call MS3560 to check for duplicate message                        068107
      *                                                                   068107
     C     *LIKE         DEFINE    MIR           W0MIR                                         06810
      *                                                                   068107
     C                   CALL      'MS3560'                                                    06810
     C                   PARM      *BLANKS       W0RTN             7                           06810
     C                   PARM      MIR           W0MIR                                         06810
      *                                                                   068107
      * If return code blank then set on IMPF to D'uplicate'              068107
      *                                                                   068107
     C                   MOVEL     *BLANKS       IMPF                                          06810
     C     W0RTN         IFEQ      *BLANKS                                                     06810
     C                   MOVEL     'D'           IMPF                                          06810
     C                   END                                                                   06810
      *                                                                   068107
     C     EXSPD         TAG                                                                   06810
      *                                                                   068107
     CSR                 ENDSR                                                                 06810
     C/EJECT
      *****************************************************************
      *   INIT - inital process                                       *
      *   Called by - main process                                    *
      *****************************************************************
      *
     C     INIT          BEGSR
      *
     C                   MOVEA     CPY@          BIS@             80                           S0131
     C                   TIME                    #TIME             6 0                         S0144
      *
      **  Set up LDA
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     'MS5030'      DBPGM
     C                   OUT       LDA
      *                                                                   S01449
      **  Access sdmmodpd (via aommodr0)                                  S01449
      *                                                                   S01449
     C                   CALL      'AOMMODR0'    PLIST1                                        S0144
      *                                                                   S01449
      **  Error handling for access object                                S01449
      *                                                                   S01449
     C     @RTCD         IFNE      *BLANKS                                                     S0144
     C     *LOCK         IN        LDA                                                         S0144
     C                   MOVEL     'MS5030  '    DBPGM                                         S0144
     C                   MOVE      '01'          DBASE                          ***************S0144
     C                   MOVE      'AOMMODR0'    DBFILE                         * DB ERROR 01 *S0144
     C                   OUT       LDA                                          ***************S0144
     C                   EXSR      *PSSR                                                       S0144
     C                   END                                                                   S0144
      *
      **  Access RUNDAT to find multibranching indicator
     C     *DTAARA       DEFINE    RUNDAT        DSRUN
     C                   IN        DSRUN
      *
      **  Initialise 'CR' and 'LF' fields
     C                   MOVE      *LOVAL        CR                1
     C                   BITON     '457'         CR
     C                   MOVE      *LOVAL        LF                1
     C                   BITON     '257'         LF
     C                   MOVEL     LF            @TAG              4
      *                                                                   088226
      **  Initialise True Multi-Branching Indicator                       088226
      **  =========================================                       088226
      **  -  Set 'Y' to W0TMBI will follow the existing logic, i.e. try   088226
      **     to locate the appropriate branch code based on the destin    088226
      **     SWIFT address (first 11 char, if not found, then 8 chars)    088226
      **  -  Set 'N' to W0TMBI will have a new way to find the default    088226
      **     branch code for all incoming SWIFT messages.  A new record   088226
      **     needs to be setup in PF/MEINMVPD which is inserted thru      088226
      **     Message Management Standing Standing Message Routing Table   088226
      **     A hardcode network SWIFT and message type ALL is required,   088226
      **     the branch code will be used to update all incoming SWIFT    088226
      **     messages index and details.                                  088226
      *                                                                   088226
     C                   MOVEL     'N'           W0TMBI            1                           08822
     C/COPY WNCPYSRC,MS5030C004
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   TYPA - Process MT100/200/202/300/320/324/330/900/910        *
      *          600                                                  *                       CSW212
      *   Calls - SRCH search for fiekd tag ':99'                     *
      *   Called by - Main processing                                 *
      *****************************************************************
      *
     C     TYPA          BEGSR
      *                                                                   123750
      ** SWIFT 1997 for MT300s check for field :30V: for value date       123750
      ** SWIFT 2000 for MT320s and MT330s                                 184013
      ** SWIFT 2000 for MT360s, MT361s and MT362s                         184427
     C     MTPY          IFEQ      '300'                                                       12375
     C     MTPY          OREQ      '320'                                                       18401
     C     MTPY          OREQ      '330'                                                       18401
     C     MTPY          OREQ      '360'                                                       18442
     C     MTPY          OREQ      '361'                                                       18442
     C     MTPY          OREQ      '362'                                                       18442
     C     ':30V:'       SCAN      D@IMSG        X                        88                   12375
     C                   ENDIF                                                                 12375
      *                                                                   184427
      ** If message is MT340 or MT341 extract value date from field :30F: 184427
     C     MTPY          IFEQ      '340'                                                       18442
     C     MTPY          OREQ      '341'                                                       18442
     C     ':30F:'       SCAN      D@IMSG        X                        88                   18442
     C                   ENDIF                                                                 18442
      *                                                                   123750
     C     MTPY          IFEQ      '300'                                                       12375
     C     *IN88         ANDEQ     *ON                                                         12375
     C     MTPY          OREQ      '320'                                                       18401
     C     *IN88         ANDEQ     *ON                                                         18401
     C     MTPY          OREQ      '330'                                                       18401
     C     *IN88         ANDEQ     *ON                                                         18401
     C     MTPY          OREQ      '340'                                                       18442
     C     *IN88         ANDEQ     *ON                                                         18442
     C     MTPY          OREQ      '341'                                                       18442
     C     *IN88         ANDEQ     *ON                                                         18442
     C     MTPY          OREQ      '360'                                                       18442
     C     *IN88         ANDEQ     *ON                                                         18442
     C     MTPY          OREQ      '361'                                                       18442
     C     *IN88         ANDEQ     *ON                                                         18442
     C     MTPY          OREQ      '362'                                                       18442
     C     *IN88         ANDEQ     *ON                                                         18442
     C                   ADD       7             X                                             12375
     C                   MOVEA     IMSG(X)       SVDT                                          12375
     C     MTPY          IFEQ      '362'                                                       18442
     C     ':32M:'       SCAN      D@IMSG        X                                             18442
     C                   ELSE                                                                  18442
     C     ':32B:'       SCAN      D@IMSG        X                                             12375
     C                   END                                                                   18442
     C                   ADD       5             X                                             12375
     C                   ELSE                                                                  12375
      *                                                                                       CSW212
     C     MTPY          IFEQ      '600'
     C                   MOVE      ':34'         @TAG
     C                   ELSE
      *
      **  Search MDTA for field tag 32
     C                   MOVE      ':32'         @TAG
     C                   ENDIF
     C                   EXSR      SRCH
      *
      **  Move date into array
     C                   MOVEA     IMSG(X)       SVDT
     C                   ADD       6             X
     C                   ENDIF                                                                 12375
      *                                                                   149261
      ** Initialisation of SWIFT Value Date Century field                 149261
      *                                                                   149261
     C     SVDT          IFNE      *BLANKS                                                     14926
     C                   MOVEL     SVDT          SVDTC                                         14926
     C     SVDTC         IFLT      '72'                                                        14926
     C                   MOVE      '20'          SVDTC                                         14926
     C                   ELSE                                                                  14926
     C                   MOVE      '19'          SVDTC                                         14926
     C                   ENDIF                                                                 14926
     C                   ENDIF                                                                 14926
      *
      **  Move currency into array
     C                   MOVEA     IMSG(X)       CCY
     C                   ADD       3             X
      *
      **  Move amount into array (amount can be up to 15 characters)
     C                   Z-ADD     1             A                 2 0
     C                   MOVEA     *BLANKS       INT
     C     IMSG(X)       DOWGE     '0'
     C     IMSG(X)       ANDLE     '9'
     C     IMSG(X)       OREQ      ','
     C                   MOVE      IMSG(X)       INT(A)
     C                   ADD       1             X
     C                   ADD       1             A
     C                   END
     C                   MOVEA     INT           AMTS
      *
     C                   MOVE      *BLANK        FD25
      *
      ** Search MDTA for field tag 22B                                                        186951
     C     MTPY          IFEQ      '320'
     C                   Z-ADD     1             X
     C                   MOVE      ':22B'        @22B              4
     C     WORK          DOUEQ     @22B
     C     X             ANDLT     9999
     C     X             OREQ      9999
     C                   ADD       1             X
     C                   MOVEA     IMSG(X)       WORK              4
     C                   ENDDO
      * If found and 'MATU' flag message as processed by TRAM                                 186951
     C     WORK          IFEQ      @22B
     C                   ADD       5             X
     C                   MOVEA     IMSG(X)       WORK
     C     WORK          IFEQ      'MATU'
     C                   MOVE      'Y'           CFPF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       186951
     C                   ENDIF
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   TYPB - Process MT201/203                                    *
      *   Calls - SRCH search for fiekd tag ':99'                     *
      *   Called by - Main processing                                 *
      *****************************************************************
      *
     C     TYPB          BEGSR
      *
      **  Search MDTA for field tag 19
     C                   MOVE      ':19'         @TAG
     C                   EXSR      SRCH
      *
      **  Move amount into array (amount can be up to 17 characters)
     C                   Z-ADD     1             A
     C                   MOVEA     *BLANKS       INT
     C     IMSG(X)       DOWGE     '0'
     C     IMSG(X)       ANDLE     '9'
     C     IMSG(X)       OREQ      ','
     C                   MOVE      IMSG(X)       INT(A)
     C                   ADD       1             X
     C                   ADD       1             A
     C                   END
     C                   MOVEA     INT           AMTS
      *
      **  Search MDTA for field tag 30
     C                   MOVE      ':30'         @TAG
     C                   EXSR      SRCH
      *
      **  Move date into array
     C                   MOVEA     IMSG(X)       SVDT
     C                   ADD       6             X
      *
      *                                                                   149261
      ** Initialisation of SWIFT Value Date Century field                 149261
      *                                                                   149261
     C     SVDT          IFNE      *BLANKS                                                     14926
     C                   MOVEL     SVDT          SVDTC                                         14926
     C     SVDTC         IFLT      '72'                                                        14926
     C                   MOVE      '20'          SVDTC                                         14926
     C                   ELSE                                                                  14926
     C                   MOVE      '19'          SVDTC                                         14926
     C                   ENDIF                                                                 14926
     C                   ENDIF                                                                 14926
      **  Search MDTA for field tag 32
     C                   MOVE      ':32'         @TAG
     C                   EXSR      SRCH
      *
      **  Move currency into array
     C                   MOVEA     IMSG(X)       CCY
     C                   ADD       3             X
      *
     C                   MOVE      *BLANK        FD25
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   TYPC - Process MT950/203                                    *
      *   Calls - SRCH search for fiekd tag ':99'                     *
      *   Called by - Main processing                                 *
      *****************************************************************
      *
     C     TYPC          BEGSR
      *
      **  Search MDTA for field tag 25
     C                   MOVE      ':25'         @TAG
     C                   EXSR      SRCH
      *
      **  Move field 25 into array (can be up to 35 characters)
     C                   Z-ADD     1             A
     C                   MOVEA     *BLANKS       INT
     C     IMSG(X)       DOWNE     CR
     C                   MOVE      IMSG(X)       INT(A)
     C                   ADD       1             X
     C                   ADD       1             A
     C                   END
     C                   MOVEA     INT           FD25
      *
     C                   MOVE      *BLANK        SVDT
     C                   MOVE      *BLANK        AMTS
     C                   MOVE      *BLANK        CCY
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   TYPD - Process MT350                                        *
      *   Calls - SRCH search for fiekd tag ':99'                     *
      *   Called by - Main processing                                 *
      *****************************************************************
      *
     C     TYPD          BEGSR
      *                                                                   184013
      ** Check for field :30V: for value date                             184013
     C     ':30V:'       SCAN      D@IMSG        X                        88                   18401
      *                                                                   184013
     C     *IN88         IFEQ      *ON                                                         18401
     C                   ADD       7             X                                             18401
     C                   MOVEA     IMSG(X)       SVDT                                          18401
     C     ':34B:'       SCAN      D@IMSG        X                                             18401
     C                   ADD       5             X                                             18401
     C                   ELSE                                                                  18401
      *
      **  Search MDTA for field tag 34
     C                   MOVE      ':34'         @TAG
     C                   EXSR      SRCH
      *
      **  Move date into array
     C                   MOVEA     IMSG(X)       SVDT
     C                   ADD       6             X
     C                   ENDIF                                                                 18401
      *                                                                   149261
      ** Initialisation of SWIFT Value Date Century field                 149261
      *                                                                   149261
     C     SVDT          IFNE      *BLANKS                                                     14926
     C                   MOVEL     SVDT          SVDTC                                         14926
     C     SVDTC         IFLT      '72'                                                        14926
     C                   MOVE      '20'          SVDTC                                         14926
     C                   ELSE                                                                  14926
     C                   MOVE      '19'          SVDTC                                         14926
     C                   ENDIF                                                                 14926
     C                   ENDIF                                                                 14926
      *
      **  Move currency into array
     C                   MOVEA     IMSG(X)       CCY
     C                   ADD       3             X
      *
      **  Move amount into array (amount can be up to 15 characters)
     C                   Z-ADD     1             A
     C                   MOVEA     *BLANKS       INT
     C     IMSG(X)       DOWGE     '0'
     C     IMSG(X)       ANDLE     '9'
     C     IMSG(X)       OREQ      ','
     C                   MOVE      IMSG(X)       INT(A)
     C                   ADD       1             X
     C                   ADD       1             A
     C                   END
     C                   MOVEA     INT           AMTS
      *
     C                   MOVE      *BLANK        FD25
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   SRCH - Search for fiekd tag ':99'                           *
      *   Called by - TYPA process 100/200/202/300/320/324/330/900/910*
      *               TYPB process 201/203                            *
      *               TYPC process 950/203                            *
      *               TYPD process 350                                *
     C*****************************************************************
      *
     C     SRCH          BEGSR
      *
      **  Find ':99'
     C                   Z-ADD     1             X
     C                   MOVEL     'N'           TGNF                                          S0143
     C     @WK4          DOUEQ     @TAG
     C                   ADD       1             X
     C                   MOVEA     IMSG(X)       @WK4              4
     C***********X         IFGE 3072                               S01435 CSW095
     C     X             IFGE      9999                                                        CSW09
     C                   MOVEL     'Y'           TGNF              1                           S0143
     C                   GOTO      EXSRCH                                                      S0143
     C                   END                                                                   S0143
     C                   END
     C                   ADD       1             X
     C                   MOVE      *BLANKS       @WK5              5
     C                   MOVEA     IMSG(X)       @WK5
      *
     C     IMSG(X)       DOUEQ     ':'
     C                   ADD       1             X
     C                   END
      *                                                                   140532
     C**********           MOVE *BLANKS   @WK5    5                                  140532 AR978486
     C**********           MOVEAIMSG,X    @WK5                                       140532 AR978486
      *                                                                   140532
     C                   ADD       1             X
      *
     C     EXSRCH        TAG                                                                   S0143
      *                                                                   S01435
     C                   ENDSR
     C/EJECT
      *****************************************************************                       CSW212
      *   TYPE - Process MT370                                        *                       CSW212
      *   Called by - Main processing                                 *                       CSW212
      *****************************************************************                       CSW212
      *                                                                                       CSW212
     C     TYPE          BEGSR
      *                                                                                       CSW212
      ** Check for field :19A:                                                                CSW212
      *                                                                                       CSW212
     C     MTPY          LOOKUP    TABTY2        TABAMC                   20
     C     *IN20         IFEQ      '1'
     C     TABAMC        SCAN      D@IMSG        X                        88
     C                   ELSE
     C     ':19A:'       SCAN      D@IMSG        X                        88
     C                   ENDIF
      *                                                                                       CSW212
      ** Extract Currency and Amount                                                          CSW212
      *                                                                                       CSW212
     C     *IN88         IFEQ      *ON
     C                   ADD       12            X
     C                   Z-ADD     0             T                 7 0
     C     X             ADD       3             T
     C                   MOVEL     *BLANKS       XTESTN            1
     C                   SUBST     D@IMSG:T      XTESTN
     C     DIGITS        CHECK     XTESTN                                 84
     C     *IN84         IFEQ      '1'
     C                   ADD       1             X
     C                   ENDIF
      *                                                                                       CSW212
     C                   MOVEA     IMSG(X)       CCY
     C                   ADD       3             X
      *                                                                                       CSW212
     C                   Z-ADD     1             A
     C                   MOVEA     *BLANKS       INT
     C     IMSG(X)       DOWGE     '0'
     C     IMSG(X)       ANDLE     '9'
     C     IMSG(X)       OREQ      ','
     C                   MOVE      IMSG(X)       INT(A)
     C                   ADD       1             X
     C                   ADD       1             A
     C                   END
     C                   MOVEA     INT           AMTS
     C                   ENDIF
      *                                                                                       CSW212
      ** Check for field :98a:                                                                CSW212
      *                                                                                       CSW212
     C     MTPY          LOOKUP    TABTY3        TABDAT                   20
     C     *IN20         IFEQ      '1'
     C     TABDAT        SCAN      D@IMSG        X                        88
     C                   ELSE
     C     ':98A:'       SCAN      D@IMSG        X                        88
     C                   ENDIF
      *                                                                                       CSW212
      ** Extract Value Date                                                                   CSW212
      *                                                                                       CSW212
     C     *IN88         IFEQ      *ON
     C                   ADD       12            X
     C                   MOVEA     IMSG(X)       SVDTC
     C                   ADD       2             X
     C                   MOVEA     IMSG(X)       SVDT
     C                   ENDIF
      *                                                                                       CSW212
     C                   MOVE      *BLANK        FD25
      *                                                                                       CSW212
     C                   ENDSR
      *****************************************************************
      *   *PSSR - error handling                                      *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN
      *
     C                   ENDSR
     C/EJECT                                                              S01310
      *****************************************************************   S01310
      *   Update processed flag & branch on MSMSI2LH                  *   S01310
      *****************************************************************   S01310
     OMSMSI2HF  E                                                               S01310
     O                       MSPF                                               S01310
     O                       BRCA                                               S01310
      *                                                                         184427
      ** tabtyp add MT340, MT341, MT360, MT361 and MT362.                       184427
      ** tabtyp add MT103                                                       CRE008
      ** tabtyp add MT370 and MT600                                                           CSW212
**
100A
103A
200A
201B
202A
203B
300A
320A
324A
330A
335A
350D
900A
910A
950C
340A
341A
360A
361A
362A
370E                                                                                          CSW212
600A                                                                                          CSW212
** TABTY2                                                                                     CSW212
370:19A::NETT                                                                                 CSW212
** TABTY3                                                                                     CSW212
370:98A::VALU                                                                                 CSW212
** CPY@   **      OBJECT COPYRIGHT
(c) Finastra International Limited 2001
