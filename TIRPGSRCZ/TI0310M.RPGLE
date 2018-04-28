     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas TI Receive TI postings to Midas API')            *
      *****************************************************************
      *                                                               *
      *  Midas - Trade Inovation (TI) Module                          *
      *                                                               *
      *  TI0310M - Receive TI Postings to Midas API                   *
      *                                                               *
      *  Function: This Postings API will add new records to the TI   *
      ************Postings*file*LF/TIPOSTL0*and*update*existing*ones.**                      BUG3836
      *            Postings file LF/TIPOSTLC and update existing ones.*                      BUG3836
      *  Phase(s): Input cycle                                        *
      *                                                               *
      *  Called By: TIC0300                                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CRE090             Date 14Feb14               *
      *  Prev Amend No. AR1095876          Date 30Sep13               *
      *                 AR899028           Date 25Jan12               *
      *                 AR847269           Date 09Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 04Jan10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244557             Date 20Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 241385             Date 03Aug06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6008            Date 25Feb05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4840            Date 28Oct04               *
      *                 BUG4200            Date 09Sep04               *
      *                 BUG3955            Date 18Aug04               *
      *                 BUG3836            Date 02Aug04               *
      *                 BUG3837            Date 02Aug04               *
      *                 CTI005  *REWRITE   Date 06Jul04               *
      *                 BUG2677            Date 25Jun04               *
      *                 CTI005             Date 12Apr04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CDE005             Date 20Aug02               *
      *                 212558             Date 31Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 207601             Date 29Oct02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 189111             Date 11Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CTI003             Date 06Feb01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 176322             Date 10Nov00               *
      *                 175869             Date 10Nov00               *
      *                 166006             Date 08Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001             Date 13Apr00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 162155             Date 11Jan00               *
      *                 161458             Date 02Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 145040             Date 24Dec98               *
      *                 144702             Date 02Nov98               *
      *                 144700             Date 20Oct98               *
      *                 140071             Date  4Aug98               *
      *                 CEU029             Date 01Sep98               *
      *                 CAP002             Date 27May98               *
      *                 CTI001   *CREATE   Date 16JUL97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE090 - Delay Capitalisation of Interest                    *
      *  AR1095876- ABC - Forward Days 1 should = DNWD-1, not just    *
      *             RUND (Child: AR1095877) (Recompile)               *
      *  AR899028 - NOSTRO AMAD System errors occured; applied        *
      *             fix AR847269                                      *
      *  AR847269 - Column F1DACN not in specified tables (Recompile) *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *           (Recompile)                                         *
      *  244557 - No records are written to file GLACNTQD for A/Cs    *
      *           created by TI when CLE025 is switched off.          *
      *  241385 - Make sure correct account code passed to AONOSTR0.  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6008- Leave date validation to TI0341M.                   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4840 - Include A/c balance check not set on GLACNTQD.     *
      *  BUG4200 - System not generating spot trade equivalents.      *
      *            Applied fix 222857.                                *
      *          - SP101 entries generated with wrong a/c code        *
      *          - Ignore SP101 account error.                        *
      *  BUG3955 - Key for KTIP4 is now TRDATE not DRCV. Changed      *
      *            second TIM0006 to TIM0011 to tell them apart.      *
      *            Added dumps for troubleshooting.                   *
      *  BUG3836 - Projections not maintained - caused by 212558      *
      *  BUG3837 - Account code & sequence corrupted on TIPOSTPD      *
      *  CTI005 - Midas Plus-TI Integration Enhancements              *
      *           Automatic Account Opening                           *
      *           COMPLETE RE-WRITE OF EARLIER CTI005 CODE IN TI0310M *
      *           LOGGED UNDER BUG3100                                *
      *  BUG2677 - Increase length of error message field to          *
      *            accommodate changes in CGL029.                     *
      *  CTI005 - Midas Plus-TI Integration Enhancements              *
      *           Automatic Account Opening                           *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDE005 - Data Export - Reservation ID                        *
      *  212558 - Retrieve the TI Transaction Date into the           *
      *           postings file.                                      *
      *  207601 - Ensure PSTIN starts as 'N' at the entry to this     *
      *           program so it can only be 'Y' if set as such.       *
      *  189111 - Account Opening date is not checked.  If the Value  *
      *           date of a posting is earlier than the account       *
      *           opening date, the posting is rejected.              *
      *  CTI003 - Transaction Postings Total Enhancements             *
      *  176322 - Prevent the system on generating incorrect base     *
      *           currency equivalent postings if the transaction     *
      *           had more than 2 spot trade postings.                *
      *  175869 - Change 140071 if one of the 2 CCY is the base CCY   *
      *  166006 - Associated customer corrupted causing dberr in      *
      *           MC0310.                                             *
      *  CDE001 - Data Export - CCRM Limits                           *
      *  162155 - Future Dated SP101 entries to be created correctly. *
      *  161458 - Associated customer number is passed from the       *
      *           interface input parameter                           *
      *  145040 - Postings attempting to go to incorrect branch       *
      *  144702 - Don't default TRANID to blank to stop repeat batches*
      *  144700 - No associated customer for non-income or expense    *
      *           accounts                                            *
      *  140071 - Handle errors writing base currency equivalent      *
      *           postings to TI postings file.                       *
      *  CEU029 - EMU Midas/Trade Innovation Interface Enhancements:  *
      *           include Original Currency and Amount on TI Postings.*
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *           Parm. on call to ZDATE10 changed to zoned to match  *
      *           new ZDATE10 delivered by APIs.                      *
      *  CTI001 - Midas / Trade Innovation Interface Phase 1          *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      *  TI Postings physical file
     FTIPOSTPD  O    E             DISK    INFSR(*PSSR)
      *
      ** TI Postings File by Projection ID
     F*****TIPOSTL0  UF A E           K DISK    INFSR(*PSSR)
     F*TIPOSTL0*UF  E           K DISK    INFSR(*PSSR)                                       BUG3836
     FTIPOSTLC  UF   E           K DISK    INFSR(*PSSR)                                      BUG3836
     F                                     RENAME(TIPOSTD0:@TIPOST0)
      *
     FTIPOSTL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(TIPOSTD0:TIPOSTD4)
      *
     F*****TIPOSTL7**IF   E           K DISK    INFSR(*PSSR)                                  162155
     F***************                           RENAME(TIPOSTD0:TIPOSTD7)                     162155
      *                                                                                       162155
     FTIPOSTLS  IF   E           K DISK    INFSR(*PSSR)                                       162155
     F                                     RENAME(TIPOSTD0:TIPOSTDS)                          162155
      *
      ** Midas GL Accounts by Branch, TI A/c No. and TI A/c Suffix
     FACCNTTI   IF   E           K DISK    INFSR(*PSSR)
      *                                                                                       CTI005
     FACCBR     UF A E           K DISK    INFSR(*PSSR)                                       CTI005
     F                                     RENAME(ACCNTABF:ACNTABF2)                          CTI005
     F                                     PREFIX(AB_)                                        CTI005
     FACCNTAC   UF A E           K DISK    INFSR(*PSSR)                                       CTI005
     F                                     PREFIX(AC_)                                        CTI005
     FSDTIACL0  IF   E           K DISK    INFSR(*PSSR)                                       CTI005
     FGLACNTL4  IF A E           K DISK    INFSR(*PSSR)                                       CTI005
      *
     F/COPY WNCPYSRC,TI0310MF01
      *****************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
     D PJRDT           DS          2000
      ** DS for Journal Details
     D  DSDLBR                18     21
     D  DSDLTP                22     24
     D  DSDLRF                25     37
     D  DSSEQN                38     39P 0
     D  DSVALD                40     46S 0
     D  TIERR                 18     46
     D  DSACBR                47     50
     D  DSACBN                51     56
     D  DSACSF                57     59
     D  DSCCYM                66     68
     D  DSAMNT                69     76P 0
     D  DSNAR1                88    122
     D/COPY WNCPYSRC,TIH00002
     D  DSCUST               228    233
     D  DSCUSL               234    236
     D  DSPRIN               237    237
     D  GZACT                251    252                                                       CTI005
     D  DSACMN               253    258
     D  DSDCIN               259    259
     D  DSCCY2               316    318
     D**GZCUS1RP*************367****372*                                               161458 166006
     D  GZCUS1               347    366                                                       CTI005
     D  GZCUS1RP             367    376                                                       166006
     D  DSEXAC               260    284
     D  DSEVRF               319    335                                                       162155
     D  DSOCCY               336    338                                         CEU029
     D  DSOAMT               339    346P 0                                      CEU029
     D  DSDATE               427    433S 0                                                    212558
     D  DSTOT                434    440                                                       CTI003
     D  DSTOT1               434    440S 0                                                    CTI003
     D  DSEXT                 18    440                                                       CTI003
     D/COPY WNCPYSRC,TI0310MD01
      ** External Account Id
     D  DSXBRA                        3    overlay(DSEXAC)
     D  DSXCUS                        6    overlay(DSEXAC:4)
     D  DSXCCY                        3    overlay(DSEXAC:10)
     D***DSXACC*                       4    overlay(DSEXAC:13)                                CGL029
     D***DSXACS*                       2    overlay(DSEXAC:17)                                CGL029
     D  DSXACC                       10    overlay(DSEXAC:13)                                 CGL029
     D  DSXACS                        2    overlay(DSEXAC:23)                                 CGL029
     D*
     D***MidasAcc        DS            18                                                     CGL029
     D MidasAcc        DS            24                                                       CGL029
     D*  Midas Account
     D  BRCA                   1      3
     D  CNUM_text              4      9
     D  CCY                   10     12
     D***ACOD_text             13     16                                                      CGL029
     D***ACSQ_text             17     18                                                      CGL029
     D  ACOD_text             13     22                                                       CGL029
     D  ACSQ_text             23     24                                                       CGL029
     D*
     D DSTIVD          DS
      ** DS for TI Value Date
     D  DSTIVC                 1      1  0
     D  DSTIVY                 2      3  0
      *
     D DSYYMD          DS
      ** DS for YYYYMMDD Date
     D  DSYEAR                 1      4  0
     D  DSMONT                 5      6  0
     D  DSDAYS                 7      8  0
      *
     D DSTI4           DS
      ** DS for keys of TIPOSTL4
     D**DRCV****               1      5  0                                                    212558
     D**TRANID**               6      9                                                       212558
     D**TRSEQ***              10     16  0                                                    212558
     D  TRDATE                 1      7  0                                                    212558
     D  TRANID                 8     11                                                       212558
     D  TRSEQ                 12     18  0                                                    212558
      *
     D                 DS                                                       CDE001
     D W#ACID                  1     18                                         CDE001
     D**W#CNUM**               1      6S 0                                             CDE001 CSD027
     D  W#CNUM                 1      6A                                                      CSD027
     D  W#CCY                  7      9A                                        CDE001
     D  W#ACCD                10     13S 0                                      CDE001
     D  W#ACSQ                14     15S 0                                      CDE001
     D  W#BRCA                16     18A                                        CDE001
                                                                                CDE001
     D TIDTA         E DS           128    EXTNAME(TIDTA)                                     CTI003
      *  External DS for TRTOT flag                                                           CTI003
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      ** Data Area giving Installation Control Details
      *
     D PSDS           SDS
      ** Program Status Data Structure
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** External DS for Access Objects
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  CustDFAC     E                     EXTFLD(QQDFAC)                                     CTI005
      ** External DS for Customer Bank Details
      *
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      ** External DS for Nostro Details
      *
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  TradACCD     E                     EXTFLD(QQACCD)                                     CGL029
      ** Midas SD Trading ICD data
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *  External DS for Currency Details
      *                                                                                       144700
     D SDACOD        E DS                  EXTNAME(SDACODPD)                                  144700
     D  AcodACCD     E                     EXTFLD(QQACCD)                                     CGL029
      *  External DS for Account Code details                                                 144700
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                  CTI005
      ** External DS for Branch Code Details                                                  CTI005
      *                                                                                       CTI005
     D SDTIIN        E DS                  EXTNAME(SDTIINPD)                                  CTI005
      ** External DS for Midas/TI interface ICD                                               CTI005
      *                                                                                       CTI005
     D AB_ACCNT      E DS                  EXTNAME(ACCNTAB)  PREFIX(AB_)                      CTI005
      ** External DS for Account details                                                      CTI005
      *                                                                                       CTI005
     D CONT13          C                   CONST('9999999999999')
      *
                                                                                CAP002
      * Date (as an 8,0 zoned field) to be converetd to a Midas Day Number      CAP002
     D DateToCvt                      8S 0                                      CAP002
                                                                                              CGL029
     D W#ACOD          S             10A                                                      CGL029
     D WWKEY4          S             10A                                                      CGL029
                                                                                              CGL029
      ** Timestamp for the transaction                                                        CTI005
      *                                                                                       CTI005
     D TimeStamp       S               Z                                                      CTI005
      *****************************************************************
     ITIPOSTD4
     I              PSTERR                      PSTERRL4
     I*
     I*****TIPOSTD7                                                                           162155
     ITIPOSTDS                                                                                162155
     I              TIDLBR                      TIDLBRL7
     I              TIDLTP                      TIDLTPL7
     I              TIDLRF                      TIDLRFL7
     I              TISEQN                      TISEQNL7
     I              TIVALD                      TIVALDL7
     I              TIACBR                      TIACBRL7
     I              TIACBN                      TIACBNL7
     I              TIACSF                      TIACSFL7
     I              TICCYM                      TICCYML7
     I              TIAMNT                      TIAMNTL7
     I              TINAR1                      TINAR1L7
     I              TICUST                      TICUSTL7
     I              TICUSL                      TICUSLL7
     I              TIPRIN                      TIPRINL7
     I              TIDCIN                      TIDCINL7
     I              TIACMN                      TIACMNL7
     I              TIEXAC                      TIEXACL7
     I              TICCY2                      TICCY2L7
     I              BRCA                        BRCAL7
     I              CNUM                        CNUML7
     I              CCY                         CCYL7
     I              ACOD                        ACODL7
     I              ACSQ                        ACSQL7
     I              ASOC                        ASOCL7
     I              NONB                        NONBL7
     I              DRCV                        DRCVL7
     I              PSTS                        PSTSL7
     I              TRANID                      TRANIDL7
     I              TRSEQ                       TRSEQL7
     I              MTIVD                       MTIVDL7
     I              MIDGEN                      MIDGENL7
     I              PSTERR                      PSTERRL7
     I              TRDATE                      TRDATEL7                                      212558
      *
      *================================================================
      *  P R O G R A M     S T A R T                                  *
      *================================================================
      *
     C                   MOVE      'N'           PSTERR
     C                   MOVE      'N'           PSTIN                          207601
      *
     C* Check if this posting has been already written
      ** Set up Date Received
     C                   Z-ADD     AGRDNB        DRCV
     C                   Z-ADD     AGRDNB        TRDATE                                      BUG3955
      ** Set up Transaction Key
     C                   MOVEL     PETKY         TRANID
      ** Set up Transaction No./Seq.
     C                   Z-ADD     PETNB         TRSEQ
     C*
     C     KTIP4         CHAIN     TIPOSTD4                           8991
     C* Error on access to TIPOSTL4 file
     C     *IN91         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   MOVEL     'TI0310'      DBPGM
     C                   Z-ADD     5             DBASE                          ***************
     C                   MOVEL     'TIPOSTL4'    DBFILE                         *DB ERROR 005 *
     C                   MOVEL     DSTI4         DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C*
     C*  Ignore this posting if record is found
     C     *IN89         IFEQ      *OFF
     C     PSTERRL4      IFEQ      'Y'
     C                   CALL      'Y2SNMGC'
     C                   PARM      'TIC0300'     ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM      'TIM0006'     ZAMSID            7            Message Id.
     C                   PARM      'TIUSRMSG'    ZAMSGF           10            Message file.
     C                   PARM      DSTI4         ZAMSDA          132            Message data.
     C                   PARM      '*INFO'       ZAMSTP            7            Message type.
     C                   MOVE      'Y'           PSTERR
     C                   DUMP                                                                BUG3955
     C                   ELSE
     C                   MOVE      'N'           PSTERR
     C                   ENDIF
     C                   ELSE
     C     CTI005        IFEQ      'Y'                                                        CTI005
     C                   EXSR      AMPOST_ACOP                                                CTI005
     C                   ELSE                                                                 CTI005
     C                   EXSR      AMPOST
     C                   ENDIF                                                                CTI005
     C                   ENDIF
      *
      *================================================================
      *  P R O G R A M     E N D                                      *
      *================================================================
      *
     C     PSTERR        IFEQ      'N'
     C                   MOVE      'Y'           PSTIN
     C                   ELSE
     C                   MOVE      'N'           PSTIN
     C                   ENDIF
     C*
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
      *================================================================
      /EJECT                                                                                  CTI005
      *****************************************************************                       CTI005
      **AMPOST*ACOP*-*Add/Maintain*Postings*file*-*LF/TIPOSTL0*-*******               CTI005 BUG3836
      * AMPOST_ACOP - Add/Maintain Postings file - LF/TIPOSTLC -      *                      BUG3836
      *               with account opening allowed                    *                       CTI005
      *****************************************************************                       CTI005
     C     AMPOST_ACOP   BEGSR                                                                CTI005
                                                                                              CTI005
      * Validate account branch                                                               CTI005
      * Validate account customer                                                             CTI005
      * Validate account currency                                                             CTI005
      * Validate account account code                                                         CTI005
                                                                                              CTI005
     C                   EXSR      VAL_AC_BRCH                                                CTI005
     C                   EXSR      VAL_AC_CUST                                                CTI005
     C                   EXSR      VAL_AC_CCY                                                 CTI005
     C                   EXSR      VAL_AC_ACOD                                                CTI005
                                                                                              CTI005
      * Validate accounts (Midas account id and TI account id)                                CTI005
                                                                                              CTI005
     C                   IF        PSTERR <> 'Y'                                              CTI005
     C                   EXSR      VAL_ACCOUNTS                                               CTI005
     C                   ENDIF                                                                CTI005
                                                                                              CTI005
      * IF NO POSTING ERRORS                                                                  CTI005
      *  Open account (when account is MISSING)                                               CTI005
      *  Reopen account (when account is CLOSED)                                              CTI005
      *  Set TI account id on Midas account (When account is OPEN and TI account id is ' ')   CTI005
                                                                                              CTI005
     C                   IF        PSTERR <> 'Y'                                              CTI005
     C                   SELECT                                                               CTI005
     C     Midas_Ac_STAT WHENEQ    'M'                                                        CTI005
     C                   EXSR      OPEN_AC                                                    CTI005
     C     Midas_Ac_STAT WHENEQ    'C'                                                        CTI005
     C                   EXSR      REOPEN_AC                                                  CTI005
     C     Midas_Ac_STAT WHENEQ    'O'                                                        CTI005
     C                   IF        AB_A5TIAN = *BLANK and AB_A5TIAS = *BLANK                  CTI005
     C                   EXSR      UPDAT_AC                                                   CTI005
     C                   ENDIF                                                                CTI005
     C                   ENDSL                                                                CTI005
     C                   ENDIF                                                                CTI005
                                                                                              CTI005
      ** Set up TI posting data/key.                                                          CTI005
     C                   MOVEL     DSDLBR        TIDLBR                                       CTI005
     C                   MOVEL     DSDLTP        TIDLTP                                       CTI005
     C                   MOVEL     DSDLRF        TIDLRF                                       CTI005
     C                   Z-ADD     DSSEQN        TISEQN                                       CTI005
     C                   Z-ADD     DSVALD        TIVALD                                       CTI005
     C                   Z-ADD     DSDATE        TRDATE                                       CTI005
     C                   MOVE      DSEVRF        TIEVRF                                      BUG3836
     C                   IF        DSACMN = 'SP101'                                          BUG4200
     C                   MOVE      ST_ACOD       ACOD                                        BUG4200
     C                   MOVE      ST_ACSQ       ACSQ                                        BUG4200
     C                   ENDIF                                                               BUG4200
      *                                                                                       CTI005
      ** Journal Transaction Type if 'A' - Add new record, if 'M' (Maintain)                  CTI005
      ** update existing record.                                                              CTI005
     C                   SELECT                                                               CTI005
     C     PJTTY         WHENEQ    'A'                                                        CTI005
     C                   EXSR      LOADDT                                                     CTI005
     C                   WRITE     TIPOSTD0                             88                    CTI005
     C     *IN88         IFEQ      *ON                                                        CTI005
     C     *LOCK         IN        LDA                                                        CTI005
     C                   SETON                                          U7U8                  CTI005
     C                   MOVEL     'TI0310'      DBPGM                                        CTI005
     C                   Z-ADD     3             DBASE                          **************CTI005
     C                   MOVEL     'TIPOSTPD'    DBFILE                         *DB ERROR 003 CTI005
     C                   MOVEL     TIERR         DBKEY                          **************CTI005
     C                   OUT       LDA                                                        CTI005
     C                   EXSR      *PSSR                                                      CTI005
     C                   ENDIF                                                                CTI005
     C/COPY WNCPYSRC,TI0310MC01                                                               CTI005
      * Base Currency Equivalent Postings                                                     CTI005
     C                   IF        DSACMN = 'SP101'                                           CTI005
     C     DSCCYM        IFNE      BJCYCD                                                     CTI005
     C     DSCCY2        ANDNE     BJCYCD                                                     CTI005
     C     SpotTradEq    ORNE      *BLANKS                                                    CTI005
     C                   EXSR      BaseCurr                                                   CTI005
     C                   ENDIF                                                                CTI005
     C                   ENDIF                                                                CTI005
     C*                                                                                       CTI005
     C     PJTTY         WHENEQ    'M'                                                        CTI005
     C*****KTIPST        CHAIN     TIPOSTL0                           89              CTI005 BUG3836
     C     KTIPST        CHAIN     TIPOSTLC                           89                     BUG3836
      *                                                                                       CTI005
     C     *IN89         IFEQ      *OFF                                                       CTI005
     C                   EXSR      LOADDT                                                     CTI005
     C                   UPDATE    @TIPOST0                                                   CTI005
     C/COPY WNCPYSRC,TIH00003
      *                                                                                       CTI005
     C                   ELSE                                                                 CTI005
     C     *LOCK         IN        LDA                                                        CTI005
     C                   SETON                                          U7U8                  CTI005
     C                   MOVEL     'TI0310'      DBPGM                                        CTI005
     C                   Z-ADD     4             DBASE                          **************CTI005
     C**********         MOVEL     'TIPOSTL0'    DBFILE                         *DB E CTI005 BUG3836
     C                   MOVEL     'TIPOSTLC'    DBFILE                         *DB ERROR004 BUG3836
     C                   MOVEL     TIERR         DBKEY                          **************CTI005
     C                   OUT       LDA                                                        CTI005
     C                   EXSR      *PSSR                                                      CTI005
     C                   ENDIF                                                                CTI005
      *                                                                                       CTI005
     C                   ENDSL                                                                CTI005
      *                                                                                       CTI005
     C                   ENDSR                                                                CTI005
      *****************************************************************                       CTI005
      /EJECT                                                                                  CTI005
      *****************************************************************                       CTI005
      * VAL_AC_BRCH - Validate account branch                         *                       CTI005
      *****************************************************************                       CTI005
     C     VAL_AC_BRCH   BEGSR                                                                CTI005
     C                   CALL      'AOBRCHR1'                                                 CTI005
     C                   PARM      *BLANKS       @RTCD                                        CTI005
     C                   PARM      '*KEY    '    @OPTN                                        CTI005
     C                   PARM      DSXBRA        @KEY3             3                          CTI005
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CTI005
      * 'Branch xxx is invalid'                                                               CTI005
     C     @RTCD         IFNE      *BLANKS                                                    CTI005
     C                   CALL      'Y2SNMGC'                                                  CTI005
     C                   PARM      'TIC0300'     ZAPGMQ           10            Program queue CTI005
     C                   PARM                    ZAPGRL            5            Rel queue     CTI005
     C                   PARM      'TIM0101'     ZAMSID            7            Message Id.   CTI005
     C                   PARM      'TIUSRMSG'    ZAMSGF           10            Message file. CTI005
     C                   PARM      DSXBRA        ZAMSDA          132            Message data. CTI005
     C                   PARM      '*INFO'       ZAMSTP            7            Message type. CTI005
     C                   MOVE      'Y'           PSTERR                                       CTI005
     C                   ENDIF                                                                CTI005
     C                   ENDSR                                                                CTI005
      *****************************************************************                       CTI005
      /EJECT                                                                                  CTI005
      *****************************************************************                       CTI005
      * VAL_AC_CUST - Validate account customer                       *                       CTI005
      *****************************************************************                       CTI005
     C     VAL_AC_CUST   BEGSR                                                                CTI005
     C                   MOVE      *BLANKS       @KEY                                         CTI005
     C                   MOVEL     DSXCUS        @KEY                                         CTI005
     C                   CALL      'AOCUSTR0'                                                 CTI005
     C                   PARM      '       '     @RTCD                                        CTI005
     C                   PARM      '*KEY   '     @OPTN                                        CTI005
     C                   PARM                    @KEY                                         CTI005
     C                   PARM      *BLANKS       @KYST                                        CTI005
     C     SDCUST        PARM      SDCUST        DSSDY                                        CTI005
      * 'Customer xxxxxx is invalid'                                                          CTI005
     C     @RTCD         IFNE      *BLANKS                                                    CTI005
     C                   CALL      'Y2SNMGC'                                                  CTI005
     C                   PARM      'TIC0300'     ZAPGMQ           10            Program queue CTI005
     C                   PARM                    ZAPGRL            5            Rel queue     CTI005
     C                   PARM      'TIM0102'     ZAMSID            7            Message Id.   CTI005
     C                   PARM      'TIUSRMSG'    ZAMSGF           10            Message file. CTI005
     C                   PARM      DSXCUS        ZAMSDA          132            Message data. CTI005
     C                   PARM      '*INFO'       ZAMSTP            7            Message type. CTI005
     C                   MOVE      'Y'           PSTERR                                       CTI005
     C                   ENDIF                                                                CTI005
     C                   ENDSR                                                                CTI005
      *****************************************************************                       CTI005
      /EJECT                                                                                  CTI005
      *****************************************************************                       CTI005
      * VAL_AC_CCY - Validate account currency                        *                       CTI005
      *****************************************************************                       CTI005
     C     VAL_AC_CCY    BEGSR                                                                CTI005
     C                   CALL      'AOCURRR0'                                                 CTI005
     C                   PARM      *BLANKS       @RTCD                                        CTI005
     C                   PARM      '*KEY    '    @OPTN                                        CTI005
     C                   PARM      DSXCCY        @KEY3                                        CTI005
     C     SDCURR        PARM      SDCURR        DSSDY                                        CTI005
      * 'Currency xxx is invalid'                                                             CTI005
     C     @RTCD         IFNE      *BLANKS                                                    CTI005
     C                   CALL      'Y2SNMGC'                                                  CTI005
     C                   PARM      'TIC0300'     ZAPGMQ           10            Program queue CTI005
     C                   PARM                    ZAPGRL            5            Rel queue     CTI005
     C                   PARM      'TIM0103'     ZAMSID            7            Message Id.   CTI005
     C                   PARM      'TIUSRMSG'    ZAMSGF           10            Message file. CTI005
     C                   PARM      DSXCCY        ZAMSDA          132            Message data. CTI005
     C                   PARM      '*INFO'       ZAMSTP            7            Message type. CTI005
     C                   MOVE      'Y'           PSTERR                                       CTI005
     C                   ENDIF                                                                CTI005
     C                   ENDSR                                                                CTI005
      *****************************************************************                       CTI005
      /EJECT                                                                                  CTI005
      *****************************************************************                       CTI005
      * VAL_AC_ACOD - Validate account account code                   *                       CTI005
      *****************************************************************                       CTI005
     C     VAL_AC_ACOD   BEGSR                                                                CTI005
     C                   CALL      'AOACODR0'                                                 CTI005
     C                   PARM      '        '    @RTCD                                        CTI005
     C                   PARM      '*KEY    '    @OPTN                                        CTI005
     C                   PARM      DSXACC        @KEY10           10                          CTI005
     C     SDACOD        PARM      SDACOD        DSSDY                                        CTI005
      * 'A/c code xxxx is invalid'                                                            CTI005
     C     @RTCD         IFNE      *BLANKS                                                    CTI005
     C                   CALL      'Y2SNMGC'                                                  CTI005
     C                   PARM      'TIC0300'     ZAPGMQ           10            Program queue CTI005
     C                   PARM                    ZAPGRL            5            Rel queue     CTI005
     C                   PARM      'TIM0104'     ZAMSID            7            Message Id.   CTI005
     C                   PARM      'TIUSRMSG'    ZAMSGF           10            Message file. CTI005
     C                   PARM      DSXACC        ZAMSDA          132            Message data. CTI005
     C                   PARM      '*INFO'       ZAMSTP            7            Message type. CTI005
     C                   MOVE      'Y'           PSTERR                                       CTI005
     C                   ENDIF                                                                CTI005
     C                   ENDSR                                                                CTI005
      *****************************************************************                       CTI005
      /EJECT                                                                                  CTI005
      *****************************************************************                       CTI005
      * VAL_ACCOUNTS - Validate accounts (Midas a/c id and TI a/c id) *                       CTI005
      *****************************************************************                       CTI005
     C     VAL_ACCOUNTS  BEGSR                                                                CTI005
                                                                                              CTI005
      * ACCESS MIDAS ACCOUNT ID                                                               CTI005
      * =======================                                                               CTI005
     C                   CLEAR                   AB_ACCNT                                     CTI005
     C                   MOVEL     *BLANK        MidasAccount     28                          CTI005
     C                   EVAL      MidasAccount =  DSXBRA + '/' + DSXCUS +                    CTI005
     C                               '/' + DSXCCY + '/' + DSXACC + '/' + DSXACS               CTI005
                                                                                              CTI005
      ** Access a/c from ACCBR using branch, customer, ccy, a/c code and a/c seq.             CTI005
                                                                                              CTI005
     C                   MOVE      DSXBRA        BRCA                                         CTI005
     C                   MOVE      DSXCUS        CNUM                                         CTI005
     C                   MOVE      DSXCCY        CCY                                          CTI005
     C                   MOVE      DSXACC        ACOD                                         CTI005
     C                   MOVE      DSXACS        ACSQ                                         CTI005
     C                   IF           DSXACS = *BLANK or DSXACS = '00'                        CTI005
     C                   MOVEL     'I'           Midas_Ac_STAT     1            INVALID       CTI005
     C                   ELSE                                                                 CTI005
     C     ACCNTK        CHAIN     ACNTABF2                           99                      CTI005
     C     *IN99         IFEQ      *ON                                                        CTI005
     C                   MOVEL     'M'           Midas_Ac_STAT                  MISSING       CTI005
     C                   ELSE                                                                 CTI005
     C                   UPDATE    ACNTABF2                                     (Release)     CTI005
     C     AB_RECI       IFNE      'D'                                                        CTI005
     C                   MOVEL     'C'           Midas_Ac_STAT                  CLOSED        CTI005
     C                   ELSE                                                                 CTI005
     C                   MOVEL     'O'           Midas_Ac_STAT                  OPEN          CTI005
     C                   ENDIF                                                                CTI005
     C                   ENDIF                                                                CTI005
     C                   ENDIF                                                                CTI005
                                                                                              CTI005
      * ACCESS TI ACCOUNT ID ON MIDAS A/C JUST ACCESSED                                       CTI005
      * ===============================================                                       CTI005
     C                   MOVEL     *BLANK        TIAccount        14                          CTI005
     C                   MOVEL     *BLANK        TI_Ac_STAT        1                          CTI005
     C     Midas_Ac_STAT IFEQ      'O'                                                        CTI005
     C                   EVAL      TIAccount = AB_BRCA   + '/' + AB_A5TIAN                    CTI005
     C                             + '/' + AB_A5TIAS                                          CTI005
     C                   IF        AB_A5TIAN <> *BLANK or AB_A5TIAS <> *BLANK                 CTI005
     C                   IF        AB_A5TIAN =  *BLANK or AB_A5TIAS =  *BLANK                 CTI005
     C                   MOVEL     'I'           TI_Ac_STAT                     INVALID       CTI005
     C                   ELSE                                                                 CTI005
                                                                                              CTI005
      ** Access a/c from ACCNTTI using branch, a/c number and a/c suffix from ACCNTAB         CTI005
                                                                                              CTI005
     C     TIACCNTK      CHAIN     ACCNTTI                            89                      CTI005
     C     *IN89         IFEQ      *OFF                                                       CTI005
     C                   MOVEL     CNUM          CNUM_text                                    CTI005
     C                   MOVEL     ACOD          ACOD_text                                    CTI005
     C                   MOVEL     ACSQ          ACSQ_text                                    CTI005
     C                   IF        DSXBRA <> BRCA or DSXCUS <> CNUM_text                      CTI005
     C                             or DSXCCY <> CCY or DSXACC <> ACOD_text                    CTI005
     C                             or DSXACS <> ACSQ_text                                     CTI005
     C                   MOVEL     'D'           TI_Ac_STAT                     DUPLICATE     CTI005
     C                   MOVE      DSXBRA        BRCA                                         CTI005
     C                   MOVE      DSXCUS        CNUM                                         CTI005
     C                   MOVE      DSXCCY        CCY                                          CTI005
     C                   MOVE      DSXACC        ACOD                                         CTI005
     C                   MOVE      DSXACS        ACSQ                                         CTI005
     C                   ENDIF                                                                CTI005
     C                   ENDIF                                                                CTI005
     C                   ENDIF                                                                CTI005
     C                   ENDIF                                                                CTI005
     C                   ENDIF                                                                CTI005
                                                                                              CTI005
      *  If this is a 'SP101' posting, A/c Code of posting = Spot Trade Account Code          CTI005
      *  or Base Ccy Equiv A/c Code of second currency (if posting ccy = base currency)       CTI005
                                                                                              CTI005
     C     DSACMN        IFEQ      'SP101'                                                    CTI005
     C                   MOVE      BLSPTA        ST_ACOD          10                          CTI005
     C                   MOVE      '01'          ST_ACSQ           2                          CTI005
     C     DSCCYM        IFEQ      BJCYCD                                                     CTI005
     C     SpotTradEq    ANDEQ     *BLANKS                                                    CTI005
     C                   CALL      'AOCURRR0'                                                 CTI005
     C                   PARM      '*MSG    '    WWRTCD                                       CTI005
     C                   PARM      '*KEY    '    WWOPTN                                       CTI005
     C                   PARM      DSCCY2        WWKEY3                                       CTI005
     C     SDCURR        PARM      SDCURR        DSSDY                                        CTI005
     C     WWRTCD        IFNE      *BLANKS                                                    CTI005
     C     *LOCK         IN        LDA                                                        CTI005
     C                   SETON                                          U7U8                  CTI005
     C                   MOVEL     'TI0310'      DBPGM                                        CTI005
     C                   Z-ADD     10            DBASE                      ***************   CTI005
     C                   MOVEL     'SDCURRPD'    DBFILE                     *DB ERROR 010 *   CTI005
     C                   MOVEL     TICCYML7      DBKEY                      ***************   CTI005
     C                   OUT       LDA                                                        CTI005
     C                   EXSR      *PSSR                                                      CTI005
     C                   ENDIF                                                                CTI005
     C                   MOVE      A6SPAE        ST_ACOD                                      CTI005
     C                   MOVE      '01'          ST_ACSQ                                      CTI005
     C                   ENDIF                                                                CTI005
     C                   ENDIF                                                                CTI005
                                                                                              CTI005
      ** E R R O R S                                                                          CTI005
                                                                                              CTI005
      * 'Midas account xxxxxxxxxxx is invalid'                                                CTI005
                                                                                              CTI005
     C     Midas_Ac_STAT IFEQ      'I'                                                        CTI005
     C                   CALL      'Y2SNMGC'                                                  CTI005
     C                   PARM      'TIC0300'     ZAPGMQ           10            Program queue CTI005
     C                   PARM                    ZAPGRL            5            Rel queue     CTI005
     C                   PARM      'TIM0111'     ZAMSID            7            Message Id.   CTI005
     C                   PARM      'TIUSRMSG'    ZAMSGF           10            Message file. CTI005
     C                   PARM      MidasAccount  ZAMSDA          132            Message data. CTI005
     C                   PARM      '*INFO'       ZAMSTP            7            Message type. CTI005
     C                   MOVE      'Y'           PSTERR                                       CTI005
     C                   ENDIF                                                                CTI005
                                                                                              CTI005
      * 'TI account xxxxxxx on Midas a/c xxxxxxxxxx is invalid                                CTI005
                                                                                              CTI005
     C     TI_Ac_STAT    IFEQ      'I'                                                        CTI005
     C                   MOVEL     TIAccount     MSG42            42                          CTI005
     C                   MOVE      MidasAccount  MSG42                                        CTI005
     C                   CALL      'Y2SNMGC'                                                  CTI005
     C                   PARM      'TIC0300'     ZAPGMQ           10            Program queue CTI005
     C                   PARM                    ZAPGRL            5            Rel queue     CTI005
     C                   PARM      'TIM0112'     ZAMSID            7            Message Id.   CTI005
     C                   PARM      'TIUSRMSG'    ZAMSGF           10            Message file. CTI005
     C                   PARM      MSG42         ZAMSDA          132            Message data. CTI005
     C                   PARM      '*INFO'       ZAMSTP            7            Message type. CTI005
     C                   MOVE      'Y'           PSTERR                                       CTI005
     C                   ENDIF                                                                CTI005
                                                                                              CTI005
      * 'TI account xxxxxxx on Midas a/c xxxxxxxxxx is also present on another Midas a/c      CTI005
                                                                                              CTI005
     C     TI_Ac_STAT    IFEQ      'D'                                                        CTI005
     C                   MOVEL     TIAccount     MSG42            42                          CTI005
     C                   MOVE      MidasAccount  MSG42                                        CTI005
     C                   CALL      'Y2SNMGC'                                                  CTI005
     C                   PARM      'TIC0300'     ZAPGMQ           10            Program queue CTI005
     C                   PARM                    ZAPGRL            5            Rel queue     CTI005
     C                   PARM      'TIM0113'     ZAMSID            7            Message Id.   CTI005
     C                   PARM      'TIUSRMSG'    ZAMSGF           10            Message file. CTI005
     C                   PARM      MSG42         ZAMSDA          132            Message data. CTI005
     C                   PARM      '*INFO'       ZAMSTP            7            Message type. CTI005
     C                   MOVE      'Y'           PSTERR                                       CTI005
     C                   ENDIF                                                                CTI005
                                                                                              CTI005
      *  'Account xxxxxxxxx on SP101 posting does not contain the correct a/c code or seq'    CTI005
                                                                                              CTI005
     C     DSACMN        IFEQ      'SP101'                                                    CTI005
     C     DSACMN        ANDEQ     '?????'                                                   BUG4200
     C     DSXACC        IFNE      ST_ACOD                                                    CTI005
     C     DSXACS        ORNE      ST_ACSQ                                                    CTI005
     C                   CALL      'Y2SNMGC'                                                  CTI005
     C                   PARM      'TIC0300'     ZAPGMQ           10            Program queue CTI005
     C                   PARM                    ZAPGRL            5            Rel queue     CTI005
     C                   PARM      'TIM0114'     ZAMSID            7            Message Id.   CTI005
     C                   PARM      'TIUSRMSG'    ZAMSGF           10            Message file. CTI005
     C                   PARM      MidasAccount  ZAMSDA          132            Message data. CTI005
     C                   PARM      '*INFO'       ZAMSTP            7            Message type. CTI005
     C                   MOVE      'Y'           PSTERR                                       CTI005
     C                   ENDIF                                                                CTI005
     C                   ENDIF                                                                CTI005
                                                                                              CTI005
      *  'Account xxxxxxxxx cannot be opened as it is a retail account'                       CTI005
                                                                                              CTI005
     C     Midas_Ac_STAT IFEQ      'M'                                                        CTI005
     C     A5ACTY        ANDEQ     'R'                                                        CTI005
     C     Midas_Ac_STAT OREQ      'C'                                                        CTI005
     C     A5ACTY        ANDEQ     'R'                                                        CTI005
     C                   CALL      'Y2SNMGC'                                                  CTI005
     C                   PARM      'TIC0300'     ZAPGMQ           10            Program queue CTI005
     C                   PARM                    ZAPGRL            5            Rel queue     CTI005
     C                   PARM      'TIM0115'     ZAMSID            7            Message Id.   CTI005
     C                   PARM      'TIUSRMSG'    ZAMSGF           10            Message file. CTI005
     C                   PARM      MidasAccount  ZAMSDA          132            Message data. CTI005
     C                   PARM      '*INFO'       ZAMSTP            7            Message type. CTI005
     C                   MOVE      'Y'           PSTERR                                       CTI005
     C                   ENDIF                                                                CTI005
                                                                                              CTI005
      *  'TI currency is xxx; Midas currency is xxx'                                          CTI005
                                                                                              CTI005
     C     DSCCYM        IFNE      CCY                                                        CTI005
     C                   MOVEL     DSCCYM        MSG6              6                          CTI005
     C                   MOVE      CCY           MSG6                                         CTI005
     C                   CALL      'Y2SNMGC'                                                  CTI005
     C                   PARM      'TIC0300'     ZAPGMQ           10            Program queue CTI005
     C                   PARM                    ZAPGRL            5            Rel queue     CTI005
     C                   PARM      'TIM0003'     ZAMSID            7            Message Id.   CTI005
     C                   PARM      'TIUSRMSG'    ZAMSGF           10            Message file. CTI005
     C                   PARM      MSG6          ZAMSDA          132            Message data. CTI005
     C                   PARM      '*INFO'       ZAMSTP            7            Message type. CTI005
     C                   MOVE      'Y'           PSTERR                                       CTI005
     C                   ENDIF                                                                CTI005
                                                                                              CTI005
      **  If Posting Amount > 13,0  send a message                                            CTI005
     C     DSAMNT        IFGT      SIZE13                                                     CTI005
     C                   CALL      'Y2SNMGC'                                                  CTI005
     C                   PARM      'TIC0300'     ZAPGMQ           10            Program queue CTI005
     C                   PARM                    ZAPGRL            5            Rel queue     CTI005
     C                   PARM      'TIM0002'     ZAMSID            7            Message Id.   CTI005
     C                   PARM      'TIUSRMSG'    ZAMSGF           10            Message file. CTI005
     C                   PARM      *BLANK        ZAMSDA          132            Message data. CTI005
     C                   PARM      '*INFO'       ZAMSTP            7            Message type. CTI005
     C                   MOVE      'Y'           PSTERR                                       CTI005
     C                   ENDIF                                                                CTI005
                                                                                              CTI005
     C                   ENDSR                                                                CTI005
      *****************************************************************                       CTI005
      /EJECT                                                                                  CTI005
      *****************************************************************                       CTI005
      * OPEN_AC - Open account                                        *                       CTI005
      *****************************************************************                       CTI005
     C     OPEN_AC       BEGSR                                                                CTI005
      *                                                                                       CTI005
     C                   MOVE      'D'           AB_RECI                                      CTI005
     C                   MOVE      DSXCUS        AB_CNUM                                      CTI005
     C                   MOVE      DSXCCY        AB_CCY                                       CTI005
     C                   MOVE      DSXACC        AB_ACOD                                      CTI005
     C                   MOVE      DSXACS        AB_ACSQ                                      CTI005
     C                   MOVE      *BLANKS       AB_ZZ006                                     CTI005
     C                   MOVE      DSXBRA        AB_BRCA                                      CTI005
     C                   MOVE      A5ACTY        AB_ATYP                                      CTI005
     C                   MOVE      ' '           AB_STYP                                      CTI005
     C                   MOVE      ' '           AB_MFFQ                                      CTI005
     C                   MOVE      ' '           AB_ACST                                      CTI005
     C                   Z-ADD     BJRDNB        AB_DACO                                      CTI005
     C                   Z-ADD     0             AB_DACC                                      CTI005
     C                   MOVEL     BBCNA1        AB_ANAM                                      CTI005
     C                   Z-ADD     0             AB_LDBL                                      CTI005
     C                   Z-ADD     0             AB_CLBL                                      CTI005
     C                   MOVE      'Q'           AB_STFQ                                      CTI005
     C                   Z-ADD     31            AB_STDY                                      CTI005
     C                   Z-ADD     BJRDNB        AB_LSTD                                      CTI005
                                                                                              CTI005
      ** Get last working day of the month from rundate                                       CTI005
                                                                                              CTI005
     C                   CallB     'ZFRQB3'                                                   CTI005
     C                   PARM      'Q'           ZFREQ             1                          CTI005
     C                   PARM      BJRDNB        ZDAYNO            5 0                        CTI005
     C                   PARM                    ZMDAY             2 0                        CTI005
     C                   PARM      DSXCCY        ZCCY              3                          CTI005
     C                   PARM                    ZLOC              3                          CTI005
     C                   PARM                    ZZERR@            7                          CTI005
     C                   Z-ADD     ZDAYNO        AB_NSTD                                      CTI005
                                                                                              CTI005
     C                   Z-ADD     0             AB_LSTP                                      CTI005
     C                   Z-ADD     0             AB_CFSB                                      CTI005
     C                   Z-ADD     0             AB_LMVD                                      CTI005
     C                   Z-ADD     0             AB_EPLB                                      CTI005
     C                   Z-ADD     0             AB_EPCB                                      CTI005
     C                   Z-ADD     0             AB_YTDB                                      CTI005
     C                   BITOFF    '01234567'    AB_GLBT                                      CTI005
     C                   BITON     '2'           AB_GLBT                                      CTI005
     C                   MOVE      'B       '    AB_ADREF1                                    CTI005
     C                   MOVE      TIPRFC        AB_PRFC                                      CTI005
     C                   MOVE      *ZEROS        AB_ZZ004                                     CTI005
     C                   Z-ADD     BJRDNB        AB_ORED                                      CTI005
     C                   Z-ADD     0             AB_DLIM                                      CTI005
     C                   Z-ADD     0             AB_LRCR                                      CTI005
     C                   Z-ADD     0             AB_RTCB                                      CTI005
     C                   Z-ADD     0             AB_RTLB                                      CTI005
     C                   Z-ADD     0             AB_DITM                                      CTI005
     C                   Z-ADD     0             AB_CITM                                      CTI005
     C                   MOVE      *BLANKS       AB_ADREF2                                    CTI005
     C                   MOVE      *BLANKS       AB_ZZ002                                     CTI005
     C                   Z-ADD     0             AB_CDIR                                      CTI005
     C                   Z-ADD     0             AB_CCIR                                      CTI005
     C                   Z-ADD     0             AB_ACNO                                      CTI005
     C                   BITOFF    '01234567'    AB_RETB                                      CTI005
     C                   MOVE      ' '           AB_ODSC                                      CTI005
     C                   Z-ADD     0             AB_ODLN                                      CTI005
     C                   Z-ADD     0             AB_ODED                                      CTI005
     C                   Z-ADD     0             AB_DIOD                                      CTI005
     C                   Z-ADD     0             AB_FACT                                      CTI005
     C                   Z-ADD     0             AB_FCNO                                      CTI005
     C                   Z-ADD     0             AB_EFAC                                      CTI005
     C                   Z-ADD     0             AB_HELD                                      CTI005
     C                   Z-ADD     0             AB_MINB                                      CTI005
     C                   Z-ADD     BJRDNB        AB_LACD                                      CTI005
     C                   Z-ADD     0             AB_LISP                                      CTI005
     C                   Z-ADD     0             AB_RRNM                                      CTI005
     C                   Z-ADD     0             AB_DRIB                                      CTI005
     C                   Z-ADD     0             AB_DRIS                                      CTI005
     C                   Z-ADD     BJRDNB        AB_DRCD                                      CTI005
     C                   Z-ADD     0             AB_DRIC                                      CTI005
     C                   MOVE      ' '           AB_DRIF                                      CTI005
     C                   Z-ADD     0             AB_DRDY                                      CTI005
     C                   Z-ADD     0             AB_NDID                                      CTI005
     C                   Z-ADD     BJRDNB        AB_LDID                                      CTI005
     C                   Z-ADD     0             AB_LDIA                                      CTI005
     C                   MOVE      ' '           AB_SDAP                                      CTI005
     C                   Z-ADD     0             AB_LPAR                                      CTI005
     C                   Z-ADD     0             AB_DIIE                                      CTI005
     C                   Z-ADD     0             AB_DAIC                                      CTI005
     C                   Z-ADD     0             AB_MADI                                      CTI005
     C                   Z-ADD     0             AB_GADI                                      CTI005
     C                   MOVE      ' '           AB_DDIS                                      CTI005
     C                   Z-ADD     BJRDNB        AB_DDIA                                      CTI005
     C                   Z-ADD     BJRDNB        AB_OLDR                                      CTI005
     C                   Z-ADD     0             AB_OLDB                                      CTI005
     C                   Z-ADD     0             AB_OLDS                                      CTI005
     C                   Z-ADD     0             AB_CRIB                                      CTI005
     C                   Z-ADD     0             AB_CRIS                                      CTI005
     C                   Z-ADD     BJRDNB        AB_CRCD                                      CTI005
     C                   Z-ADD     0             AB_CRIC                                      CTI005
     C                   MOVE      ' '           AB_CRIF                                      CTI005
     C                   Z-ADD     0             AB_CRDY                                      CTI005
     C                   Z-ADD     0             AB_NCID                                      CTI005
     C                   Z-ADD     BJRDNB        AB_LCID                                      CTI005
     C                   Z-ADD     0             AB_LCIA                                      CTI005
     C                   MOVE      ' '           AB_SCAP                                      CTI005
     C                   Z-ADD     BJRDNB        AB_LPAP                                      CTI005
     C                   Z-ADD     0             AB_CIIE                                      CTI005
     C                   Z-ADD     0             AB_CAIC                                      CTI005
     C                   Z-ADD     0             AB_MACI                                      CTI005
     C                   Z-ADD     0             AB_GACI                                      CTI005
     C                   MOVE      ' '           AB_CDIS                                      CTI005
     C                   Z-ADD     BJRDNB        AB_DCIA                                      CTI005
     C                   Z-ADD     BJRDNB        AB_OLCR                                      CTI005
     C                   Z-ADD     0             AB_OLCB                                      CTI005
     C                   Z-ADD     0             AB_OLCS                                      CTI005
     C                   Z-ADD     BJRDNB        AB_LCD                                       CTI005
     C                   MOVE      'I'           AB_CHTP                                      CTI005
     C                   Z-ADD     1             AB_TNLU                                      CTI005
     C                   MOVE      ' '           AB_BRTCA                                     CTI005
     C                   MOVE      'T'           AB_NACSG                                     CTI005
     C                   MOVE      ' '           AB_R4ACNT                                    CTI005
     C                   Z-ADD     0             AB_ENOC                                      CTI005
     C                   Z-ADD     0             AB_EPNO                                      CTI005
     C                   Z-ADD     0             AB_ECFB                                      CTI005
     C                   MOVE      ' '           AB_LTAB                                      CTI005
     C                   Z-ADD     0             AB_LTAC                                      CTI005
     C                   Z-ADD     0             AB_LTAS                                      CTI005
     C                   Z-ADD     0             AB_HCFB                                      CTI005
     C                   MOVE      *ZEROS        AB_PTFR                                      CTI005
     C                   MOVE      ' '           AB_HLEX                                      CTI005
                                                                                              CTI005
      * Set TI Account ID (DSACBN and DSACSF)                                                 CTI005
                                                                                              CTI005
     C                   EXSR      SET_TIACID                                                 CTI005
     C     PSTERR        CABEQ     'Y'           E_OPEN_AC                                    CTI005
                                                                                              CTI005
     C                   MOVE      'Y'           AB_A5TIAC                                    CTI005
     C                   MOVE      DSACBN        AB_A5TIAN                                    CTI005
      *                                                                                       CTI005
      ** If DCACSF is blank, get next available sequence for TI account                       CTI005
      *                                                                                       CTI005
     C     DSACSF        IFEQ      *BLANK                                                     CTI005
     C                   EXSR      GET_NXTSUFFIX                                              CTI005
     C                   MOVE      WA_SUFFIX     AB_A5TIAS                                    CTI005
     C                   ELSE                                                                 CTI005
     C                   MOVEL     DSACSF        AB_A5TIAS                                    CTI005
     C                   ENDIF                                                                CTI005
      *                                                                                       CTI005
     C                   MOVE      ' '           AB_EUSB                                      CTI005
     C                   MOVE      *BLANKS       AB_IBAN                                      CTI005
     C                   MOVE      *BLANKS       AB_IBSEQN                                    CTI005
     C                   MOVE      *BLANKS       AB_FRNT                                      CTI005
     C                   MOVE      *BLANKS       AB_AFRT                                      CTI005
     C                   MOVE      ' '           AB_REPA                                      CTI005
      *                                                                                       CTI005
      ** Generate a timestamp for this transaction                                            CTI005
      *                                                                                       CTI005
     C                   CALLB     'ZAGENTMSTM'                                               CTI005
     C                   PARM                    TimeStamp                                    CTI005
                                                                                              CTI005
     C                   MOVE      TimeStamp     AB_TMST                                      CTI005
     C                   MOVE      ' '           AB_REPI                                      CTI005
                                                                                              CTI005
     C                   MOVEL     AB_BRCA       BRCA                                         CTI005
     C                   MOVEL     AB_CNUM       CNUM_text                                    CTI005
     C                   MOVEL     AB_CCY        CCY                                          CTI005
     C                   MOVEL     AB_ACOD       ACOD_text                                    CTI005
     C                   MOVEL     AB_ACSQ       ACSQ_text                                    CTI005
     C                   EVAL      AB_A5ACKY = MidasAcc + '          '                        CTI005
     C                   MOVEL     AB_CNUM       CNUM                                        BUG3837
     C                   MOVEL     AB_ACOD       ACOD                                        BUG3837
     C                   MOVEL     AB_ACSQ       ACSQ                                        BUG3837
                                                                                              CTI005
      ** If customer number is an internal customer                                           CTI005
                                                                                              CTI005
     C     DSXCUS        IFEQ      A8BICN                                                     CTI005
     C                   MOVE      'Y'           AB_A5INTL                                    CTI005
     C                   ELSE                                                                 CTI005
     C                   MOVE      'N'           AB_A5INTL                                    CTI005
     C                   ENDIF                                                                CTI005
                                                                                              CTI005
     C                   MOVE      A8TIBR        AB_A5TIAB                                    CTI005
                                                                                              CTI005
      * Write account record                                                                  CTI005
                                                                                              CTI005
     C                   WRITE     ACNTABF2                                                   CTI005
                                                                                              CTI005
      * Write account extension record for Collateralized Lending                             CTI005
                                                                                              CTI005
     C*****CLE025        IFEQ      'Y'                                                 CTI005 244557
     C**********         Z-ADD     AB_CNUM       F1CNUM                                CTI005 CSD027
     C                   EVAL      F1CNUM = AB_CNUM                                           CSD027
     C                   MOVE      AB_CCY        F1CCY                                        CTI005
     C                   Z-ADD     AB_ACOD       F1ACOD                                       CTI005
     C                   Z-ADD     AB_ACSQ       F1ACSQ                                       CTI005
     C                   MOVE      AB_BRCA       F1BRCA                                       CTI005
     C                   MOVE      'N'           F1IABC                                      BUG4840
     C                   EVAL      F1DECD = 0                                                 CRE090
     C     GLACNTK       CHAIN     GLACNTD0                           99                      CTI005
     C     *IN99         IFEQ      *ON                                                        CTI005
     C                   WRITE     GLACNTD0                                                   CTI005
     C                   ENDIF                                                                CTI005
     C**********         ENDIF                                                         CTI005 244557
                                                                                              CTI005
      * Update trailer                                                                        CTI005
                                                                                              CTI005
     C                   READ      ACCNTACF                               99                  CTI005
     C     *IN99         IFEQ      *OFF                                                       CTI005
     C                   ADD       1             AC_NINU                                      CTI005
     C                   ADD       1             AC_NOAU                                      CTI005
     C                   Z-ADD     BJRDNB        AC_LCD                                       CTI005
     C                   ADD       1             AC_TNLU                                      CTI005
     C                   UPDATE    ACCNTACF                                                   CTI005
     C                   ENDIF                                                                CTI005
      *                                                                                       CTI005
     C     E_OPEN_AC     ENDSR                                                                CTI005
      *****************************************************************                       CTI005
      /EJECT                                                                                  CTI005
      *****************************************************************                       CTI005
      * REOPEN_AC - Reopen account (when account is CLOSED)           *                       CTI005
      *****************************************************************                       CTI005
     C     REOPEN_AC     BEGSR                                                                CTI005
                                                                                              CTI005
     C     ACCNTK        CHAIN     ACNTABF2                           99                      CTI005
                                                                                              CTI005
     C     *IN99         IFEQ      *OFF                                                       CTI005
     C     AB_RECI       ANDNE     'D'                                                        CTI005
                                                                                              CTI005
     C                   MOVE      'D'           AB_RECI                                      CTI005
     C                   MOVE      ' '           AB_ACST                                      CTI005
     C                   Z-ADD     0             AB_DACC                                      CTI005
      *                                                                                       CTI005
     C                   Z-ADD     BJRDNB        AB_LCD                                       CTI005
     C                   MOVE      'A'           AB_CHTP                                      CTI005
                                                                                              CTI005
      * Set TI Account ID (DSACBN and DSACSF)                                                 CTI005
                                                                                              CTI005
     C                   EXSR      SET_TIACID                                                 CTI005
     C     PSTERR        CABEQ     'Y'           E_REOPEN_AC                                  CTI005
                                                                                              CTI005
     C                   MOVE      'Y'           AB_A5TIAC                                    CTI005
     C                   MOVE      DSACBN        AB_A5TIAN                                    CTI005
      *                                                                                       CTI005
      ** If DCACSF is blank, get next available sequence for TI account                       CTI005
      *                                                                                       CTI005
     C     DSACSF        IFEQ      *BLANK                                                     CTI005
     C                   EXSR      GET_NXTSUFFIX                                              CTI005
     C                   MOVE      WA_SUFFIX     AB_A5TIAS                                    CTI005
     C                   ELSE                                                                 CTI005
     C                   MOVEL     DSACSF        AB_A5TIAS                                    CTI005
     C                   ENDIF                                                                CTI005
                                                                                              CTI005
     C                   MOVEL     AB_BRCA       BRCA                                         CTI005
     C                   MOVEL     AB_CNUM       CNUM_text                                    CTI005
     C                   MOVEL     AB_CCY        CCY                                          CTI005
     C                   MOVEL     AB_ACOD       ACOD_text                                    CTI005
     C                   MOVEL     AB_ACSQ       ACSQ_text                                    CTI005
     C                   EVAL      AB_A5ACKY = MidasAcc + '          '                        CTI005
     C                   MOVEL     AB_CNUM       CNUM                                        BUG3837
     C                   MOVEL     AB_ACOD       ACOD                                        BUG3837
     C                   MOVEL     AB_ACSQ       ACSQ                                        BUG3837
                                                                                              CTI005
      ** If customer number is an internal customer                                           CTI005
                                                                                              CTI005
     C     DSXCUS        IFEQ      A8BICN                                                     CTI005
     C                   MOVE      'Y'           AB_A5INTL                                    CTI005
     C                   ELSE                                                                 CTI005
     C                   MOVE      'N'           AB_A5INTL                                    CTI005
     C                   ENDIF                                                                CTI005
                                                                                              CTI005
     C                   MOVE      A8TIBR        AB_A5TIAB                                    CTI005
                                                                                              CTI005
      * Update account record                                                                 CTI005
                                                                                              CTI005
     C                   UPDATE    ACNTABF2                                                   CTI005
                                                                                              CTI005
      * Write account extension record for Collateralized Lending                             CTI005
                                                                                              CTI005
     C*****CLE025        IFEQ      'Y'                                                 CTI005 244557
     C**********         Z-ADD     AB_CNUM       F1CNUM                                CTI005 CSD027
     C                   EVAL      F1CNUM = AB_CNUM                                           CSD027
     C                   MOVE      AB_CCY        F1CCY                                        CTI005
     C                   Z-ADD     AB_ACOD       F1ACOD                                       CTI005
     C                   Z-ADD     AB_ACSQ       F1ACSQ                                       CTI005
     C                   MOVE      AB_BRCA       F1BRCA                                       CTI005
     C                   MOVE      'N'           F1IABC                                      BUG4840
     C                   EVAL      F1DECD = 0                                                 CRE090
     C     GLACNTK       CHAIN     GLACNTD0                           99                      CTI005
     C     *IN99         IFEQ      *ON                                                        CTI005
     C                   WRITE     GLACNTD0                                                   CTI005
     C                   ENDIF                                                                CTI005
     C**********         ENDIF                                                         CTI005 244557
                                                                                              CTI005
      * Update trailer                                                                        CTI005
                                                                                              CTI005
     C                   READ      ACCNTACF                               99                  CTI005
     C     *IN99         IFEQ      *OFF                                                       CTI005
     C                   ADD       1             AC_NOAM                                      CTI005
     C                   Z-ADD     BJRDNB        AC_LCD                                       CTI005
     C                   ADD       1             AC_TNLU                                      CTI005
     C                   UPDATE    ACCNTACF                                                   CTI005
     C                   ENDIF                                                                CTI005
                                                                                              CTI005
     C                   ENDIF                                                                CTI005
                                                                                              CTI005
     C     E_REOPEN_AC   ENDSR                                                                CTI005
      *****************************************************************                       CTI005
      /EJECT                                                                                  CTI005
      *****************************************************************                       CTI005
      * UPDAT_AC - Set TI account id on Midas account                 *                       CTI005
      *****************************************************************                       CTI005
     C     UPDAT_AC      BEGSR                                                                CTI005
                                                                                              CTI005
     C     ACCNTK        CHAIN     ACNTABF2                           99                      CTI005
                                                                                              CTI005
     C     *IN99         IFEQ      *OFF                                                       CTI005
     C     AB_RECI       ANDEQ     'D'                                                        CTI005
                                                                                              CTI005
      * Set TI Account ID (DSACBN and DSACSF)                                                 CTI005
                                                                                              CTI005
     C                   EXSR      SET_TIACID                                                 CTI005
     C     PSTERR        CABEQ     'Y'           E_UPDAT_AC                                   CTI005
                                                                                              CTI005
     C                   MOVE      'Y'           AB_A5TIAC                                    CTI005
     C                   MOVE      DSACBN        AB_A5TIAN                                    CTI005
      *                                                                                       CTI005
      ** If DCACSF is blank, get next available sequence for TI account                       CTI005
      *                                                                                       CTI005
     C     DSACSF        IFEQ      *BLANK                                                     CTI005
     C                   EXSR      GET_NXTSUFFIX                                              CTI005
     C                   MOVE      WA_SUFFIX     AB_A5TIAS                                    CTI005
     C                   ELSE                                                                 CTI005
     C                   MOVEL     DSACSF        AB_A5TIAS                                    CTI005
     C                   ENDIF                                                                CTI005
                                                                                              CTI005
     C                   MOVEL     AB_BRCA       BRCA                                         CTI005
     C                   MOVEL     AB_CNUM       CNUM_text                                    CTI005
     C                   MOVEL     AB_CCY        CCY                                          CTI005
     C                   MOVEL     AB_ACOD       ACOD_text                                    CTI005
     C                   MOVEL     AB_ACSQ       ACSQ_text                                    CTI005
     C                   EVAL      AB_A5ACKY = MidasAcc + '          '                        CTI005
     C                   MOVEL     AB_CNUM       CNUM                                        BUG3837
     C                   MOVEL     AB_ACOD       ACOD                                        BUG3837
     C                   MOVEL     AB_ACSQ       ACSQ                                        BUG3837
                                                                                              CTI005
      ** If customer number is an internal customer                                           CTI005
                                                                                              CTI005
     C     DSXCUS        IFEQ      A8BICN                                                     CTI005
     C                   MOVE      'Y'           AB_A5INTL                                    CTI005
     C                   ELSE                                                                 CTI005
     C                   MOVE      'N'           AB_A5INTL                                    CTI005
     C                   ENDIF                                                                CTI005
                                                                                              CTI005
     C                   MOVE      A8TIBR        AB_A5TIAB                                    CTI005
                                                                                              CTI005
      * Update account record                                                                 CTI005
                                                                                              CTI005
     C                   UPDATE    ACNTABF2                                                   CTI005
                                                                                              CTI005
     C                   ENDIF                                                                CTI005
                                                                                              CTI005
     C     E_UPDAT_AC    ENDSR                                                                CTI005
      *****************************************************************                       CTI005
      /EJECT                                                                                  CTI005
      *****************************************************************                       CTI005
      * SET_TIACID - Set TI Account ID (DSACBN and DSACSF)            *                       CTI005
      *****************************************************************                       CTI005
     C     SET_TIACID    BEGSR                                                                CTI005
     C                   MOVE      *BLANK        DSACBN                                       CTI005
     C                   MOVE      *BLANK        DSACSF                                       CTI005
      * TI a/c                                                                                CTI005
     C     GZACT         CHAIN     SDTIACL0                           99                      CTI005
     C     *IN99         IFEQ      *ON                                                        CTI005
     C                   EXSR      INV_TIATYP                                                 CTI005
     C                   ENDIF                                                                CTI005
                                                                                              CTI005
     C                   SELECT                                                               CTI005
                                                                                              CTI005
     C     GZCUS1        WHENNE    *BLANK                                                     CTI005
     C                   EVAL      DSACBN = DSXCUS                                            CTI005
                                                                                              CTI005
     C     DSACMN        WHENNE    *BLANK                                                     CTI005
     C     DSACMN        ANDNE     'SP101 '                                                   CTI005
     C     DSXCUS        ANDEQ     A8BICN                                                     CTI005
     C     GDBCNO        IFEQ      *BLANK                                                     CTI005
     C                   EXSR      INV_TIATYP                                                 CTI005
     C                   ENDIF                                                                CTI005
     C                   EVAL      DSACBN = GDBCNO                                            CTI005
     C                   MOVEL     A6ISON        DSACSF                                       CTI005
                                                                                              CTI005
     C     DSACMN        WHENNE    *BLANK                                                     CTI005
     C     DSACMN        ANDNE     'SP101 '                                                   CTI005
     C     DSXCUS        ANDNE     A8BICN                                                     CTI005
     C                   EVAL      DSACBN = DSXCUS                                            CTI005
      * SP101                                                                                 CTI005
     C                   OTHER                                                                CTI005
     C     GDBCNO        IFEQ      *BLANK                                                     CTI005
     C                   EXSR      INV_TIATYP                                                 CTI005
     C                   ENDIF                                                                CTI005
     C                   MOVEL     GDBCNO        DSACBN                                       CTI005
     C                   CALL      'AOCURRR0'                                                 CTI005
     C                   PARM      '*MSG    '    WWRTCD                                       CTI005
     C                   PARM      '*KEY    '    WWOPTN                                       CTI005
     C                   PARM      DSCCY2        WWKEY3                                       CTI005
     C     SDCURR        PARM      SDCURR        DSSDY                                        CTI005
     C                   MOVE      A6ISON        DSACBN                                       CTI005
     C                   CALL      'AOCURRR0'                                                 CTI005
     C                   PARM      '*MSG    '    WWRTCD                                       CTI005
     C                   PARM      '*KEY    '    WWOPTN                                       CTI005
     C                   PARM      DSCCYM        WWKEY3                                       CTI005
     C     SDCURR        PARM      SDCURR        DSSDY                                        CTI005
     C                   MOVEL     A6ISON        DSACSF                                       CTI005
     C                   ENDSL                                                                CTI005
                                                                                              CTI005
     C                   ENDSR                                                                CTI005
      *****************************************************************                       CTI005
      /EJECT                                                                                  CTI005
      *****************************************************************                       CTI005
      * INV_TIATYP - Invalid TI Account Type                          *                       CTI005
      *****************************************************************                       CTI005
     C     INV_TIATYP    BEGSR                                                                CTI005
      * 'TI Account type xx is invalid'                                                       CTI005
     C                   CALL      'Y2SNMGC'                                                  CTI005
     C                   PARM      'TIC0300'     ZAPGMQ           10            Program queue CTI005
     C                   PARM                    ZAPGRL            5            Rel queue     CTI005
     C                   PARM      'TIM0116'     ZAMSID            7            Message Id.   CTI005
     C                   PARM      'TIUSRMSG'    ZAMSGF           10            Message file. CTI005
     C                   PARM      GZACT         ZAMSDA          132            Message data. CTI005
     C                   PARM      '*INFO'       ZAMSTP            7            Message type. CTI005
     C                   MOVE      'Y'           PSTERR                                       CTI005
     C                   ENDSR                                                                CTI005
      *****************************************************************                       CTI005
      /EJECT                                                                                  CTI005
      *****************************************************************                       CTI005
      * GET_NXTSUFFIX - Get next available sequence for TI account    *                       CTI005
      *****************************************************************                       CTI005
     C     GET_NXTSUFFIX BEGSR                                                                CTI005
     C                   Z-ADD     1             WN_SUFFIX         3 0                        CTI005
     C                   MOVE      WN_SUFFIX     WA_SUFFIX         3                          CTI005
     C     TIACCNTKX     CHAIN     ACCNTTI                            99                      CTI005
     C     *IN99         DOWEQ     *OFF                                                       CTI005
     C     WN_SUFFIX     ANDLT     999                                                        CTI005
     C                   ADD       1             WN_SUFFIX                                    CTI005
     C                   MOVE      WN_SUFFIX     WA_SUFFIX         3                          CTI005
     C     TIACCNTKX     CHAIN     ACCNTTI                            99                      CTI005
     C                   ENDDO                                                                CTI005
     C                   ENDSR                                                                CTI005
      *****************************************************************                       CTI005
      /EJECT
      *****************************************************************
      /TITLE SR/AMPOST
      *****************************************************************
      *                                                               *
      **AMPOST*-*Add/Maintain*Postings*file*-*LF/TIPOSTL0**************                      BUG3836
      * AMPOST - Add/Maintain Postings file - LF/TIPOSTLC             *                      BUG3836
      *                                                               *
      * Called By: Main                                               *
      *                                                               *
      * Calls: LOADDT                                                 *
      *                                                               *
      *****************************************************************
      *
     C     AMPOST        BEGSR
      *
      ** Retrieve details from ACCNTTI - GL details by TI key
     C*****              MOVEL     DSDLBR        W#BRCA                   145040
     C                   MOVEL     DSXBRA        W#BRCA                   145040
     C                   MOVEL     *BLANK        TIAccount        14
     C                   EVAL      TIAccount = W#BRCA + '/' + DSACBN
     C                             + '/' + DSACSF
     C                   IF        W#BRCA = *BLANK OR DSACBN = *BLANK
     C                             OR DSACSF = *BLANK
     C                   EVAL      *IN89 = '1'
     C                   ELSE
     C     KACCNT        CHAIN     ACCNTTI                            8991
     C* Error on access to ACCNTTI file
     C     *IN91         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   MOVEL     'TI0310'      DBPGM
     C                   Z-ADD     2             DBASE                          ***************
     C                   MOVEL     'ACCNTTI '    DBFILE                         *DB ERROR 002 *
     C                   MOVEL     TIAccount     DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C*
     C*  Account is not found
     C     *IN89         IFEQ      *ON
     C                   CALL      'Y2SNMGC'
     C                   PARM      'TIC0300'     ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM      'TIM0004'     ZAMSID            7            Message Id.
     C                   PARM      'TIUSRMSG'    ZAMSGF           10            Message file.
     C                   PARM      TIAccount     ZAMSDA          132            Message data.
     C                   PARM      '*INFO'       ZAMSTP            7            Message type.
     C                   MOVE      'Y'           PSTERR
     C                   ENDIF
      *
     C*  If Midas Account field is blank set it
     C     DSEXAC        IFEQ      *BLANK
     C                   MOVEL     BRCA          DSXBRA
     C                   MOVEL     CNUM          DSXCUS
     C                   MOVEL     CCY           DSXCCY
     C                   MOVEL     ACOD          DSXACC
     C                   MOVEL     ACSQ          DSXACS
     C                   ELSE
     C*  Check that external account number is the same as Midas Account
     C                   MOVEL     CNUM          CNUM_text
     C                   MOVEL     ACOD          ACOD_text
     C                   MOVEL     ACSQ          ACSQ_text
     C                   IF        DSXBRA <> BRCA or DSXCUS <> CNUM_text
     C                             or DSXCCY <> CCY or DSXACC <> ACOD_text
     C                             or DSXACS <> ACSQ_text
     C**********         MOVEL     DSEXAC        MSG36            36                         BUG2677
     C                   MOVEL     DSEXAC        MSG48            48                         BUG2677
     C**********         MOVE      MidasAcc      MSG36                                       BUG2677
     C                   MOVE      MidasAcc      MSG48                                       BUG2677
     C                   CALL      'Y2SNMGC'
     C                   PARM      'TIC0300'     ZAPGMQ
     C                   PARM                    ZAPGRL
     C                   PARM      'TIM0018'     ZAMSID
     C                   PARM      'TIUSRMSG'    ZAMSGF
     C**********         PARM      MSG36         ZAMSDA                                      BUG2677
     C                   PARM      MSG48         ZAMSDA                                      BUG2677
     C                   PARM      '*INFO'       ZAMSTP
     C                   MOVE      'Y'           PSTERR
     C                   ENDIF
     C                   ENDIF
      *
      *  If this is a 'SP101' posting use Spot Trade Account
     C     DSACMN        IFEQ      'SP101'
     C                   MOVE      BLSPTA        ACOD
     C                   Z-ADD     1             ACSQ
      * If currency is base currency then get second currency details                         140071
     C     DSCCYM        IFEQ      BJCYCD                                                     140071
     C     SpotTradEq    ANDEQ     *BLANKS                                                    175869
     C                   CALL      'AOCURRR0'                                                 140071
     C                   PARM      '*MSG    '    WWRTCD                                       140071
     C                   PARM      '*KEY    '    WWOPTN                                       140071
     C                   PARM      DSCCY2        WWKEY3                                       140071
     C     SDCURR        PARM      SDCURR        DSSDY                                        140071
     C     WWRTCD        IFNE      *BLANKS                                                    140071
     C     *LOCK         IN        LDA                                                        140071
     C                   SETON                                          U7U8                  140071
     C                   MOVEL     'TI0310'      DBPGM                                        140071
     C                   Z-ADD     10            DBASE                      ***************   140071
     C                   MOVEL     'SDCURRPD'    DBFILE                     *DB ERROR 010 *   140071
     C                   MOVEL     TICCYML7      DBKEY                      ***************   140071
     C                   OUT       LDA                                                        140071
     C                   EXSR      *PSSR                                                      140071
     C                   ENDIF                                                                140071
      *                                                                                       140071
      * A/c code for base currency SP101 entry is base currency equiv.                        140071
      *  for second currency                                                                  140071
     C                   MOVE      A6SPAE        ACOD                                         140071
     C                   Z-ADD     1             ACSQ                                         140071
     C                   ENDIF                                                                140071
      *                                                                                       140071
     C                   ENDIF
      *
      ** Set up TI posting data/key.
     C                   MOVEL     DSDLBR        TIDLBR
     C                   MOVEL     DSDLTP        TIDLTP
     C                   MOVEL     DSDLRF        TIDLRF
     C                   Z-ADD     DSSEQN        TISEQN
     C                   Z-ADD     DSVALD        TIVALD
     C                   Z-ADD     DSDATE        TRDATE                                       212558
     C                   MOVE      DSEVRF        TIEVRF                                      BUG3836
     C*
     C*  If Account currency is different fr TI Currency send msg
     C     DSCCYM        IFNE      CCY
     C     *IN89         ANDEQ     *OFF
     C                   MOVEL     DSCCYM        MSG6              6
     C                   MOVE      CCY           MSG6
     C                   CALL      'Y2SNMGC'
     C                   PARM      'TIC0300'     ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM      'TIM0003'     ZAMSID            7            Message Id.
     C                   PARM      'TIUSRMSG'    ZAMSGF           10            Message file.
     C                   PARM      MSG6          ZAMSDA          132            Message data.
     C                   PARM      '*INFO'       ZAMSTP            7            Message type.
     C                   MOVE      'Y'           PSTERR
     C                   ENDIF
     C*
     C     DSAMNT        IFGT      SIZE13
      **  If Posting Amount > 13,0  send a message
     C                   CALL      'Y2SNMGC'
     C                   PARM      'TIC0300'     ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM      'TIM0002'     ZAMSID            7            Message Id.
     C                   PARM      'TIUSRMSG'    ZAMSGF           10            Message file.
     C                   PARM      *BLANK        ZAMSDA          132            Message data.
     C                   PARM      '*INFO'       ZAMSTP            7            Message type.
     C                   MOVE      'Y'           PSTERR
     C                   ENDIF
      *
      ** Journal Transaction Type if 'A' - Add new record, if 'M' (Maintain)
      ** update existing record.
     C                   SELECT
     C     PJTTY         WHENEQ    'A'
     C                   EXSR      LOADDT
     C                   WRITE     TIPOSTD0                             88
     C     *IN88         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   MOVEL     'TI0310'      DBPGM
     C                   Z-ADD     3             DBASE                          ***************
     C                   MOVEL     'TIPOSTPD'    DBFILE                         *DB ERROR 003 *
     C                   MOVEL     TIERR         DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C/COPY WNCPYSRC,TI0310MC01
      * Base Currency Equivalent Postings
     C                   IF        DSACMN = 'SP101'
     C     DSCCYM        IFNE      BJCYCD                                                     140071
     C     DSCCY2        ANDNE     BJCYCD                                                     140071
     C     SpotTradEq    ORNE      *BLANKS                                                    175869
     C                   EXSR      BaseCurr
     C                   ENDIF                                                                140071
     C                   ENDIF
     C*
     C     PJTTY         WHENEQ    'M'
     C*****KTIPST        CHAIN     TIPOSTL0                           89                     BUG3836
     C     KTIPST        CHAIN     TIPOSTLC                           89                     BUG3836
      *
     C     *IN89         IFEQ      *OFF
     C                   EXSR      LOADDT
     C******             UPDATE    TIPOSTD0
     C                   UPDATE    @TIPOST0
     C/COPY WNCPYSRC,TIH00004
      *
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   MOVEL     'TI0310'      DBPGM
     C                   Z-ADD     4             DBASE                          ***************
     C**********         MOVEL     'TIPOSTL0'    DBFILE                         *DB ERROR004 BUG3836
     C                   MOVEL     'TIPOSTLC'    DBFILE                         *DB ERROR004 BUG3836
     C                   MOVEL     TIERR         DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSL
      *                                                                         CDE001
      ** Data export for CCRM - Limits                                          CDE001
     C                   IF        CDE001 = 'Y'                                 CDE001
     C                   EVAL      W#CNUM = CNUM                                CDE001
     C                   EVAL      W#CCY  = CCY                                 CDE001
     C                   EVAL      W#ACCD = ACOD                                CDE001
     C                   EVAL      W#ACSQ = ACSQ                                CDE001
     C                   EVAL      W#BRCA = BRCA                                CDE001
     C                   MOVEL     W#ACID        T#TREF                         CDE001
     C     PJTTY         IFEQ      'A'                                          CDE001
     C     PJTTY         OREQ      'M'                                          CDE001
     C                   CALLB     'DEWRTTRIG'                                  CDE001
     C                   PARM                    T#TREF           20            CDE001
     C                   PARM      'ACCT'        T#TCAT            4            CDE001
     C                   PARM      *BLANKS       T#RSRV           10            CDE005
     C                   ENDIF                                                  CDE001
     C                   ENDIF                                                  CDE001
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      /TITLE SR/LOADDT
      *****************************************************************
      *                                                               *
      **LOADDT*-*Load*LF/TIPOSTL0*details******************************                      BUG3836
      * LOADDT - Load LF/TIPOSTLC details                             *                      BUG3836
      *                                                               *
      * Called By: AMPOST                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     LOADDT        BEGSR
      *
     C                   MOVEL     DSACBR        TIACBR
     C                   MOVEL     DSACBN        TIACBN
     C                   MOVEL     DSACSF        TIACSF
     C                   MOVEL     DSCCYM        TICCYM
     C                   MOVEL     DSAMNT        TIAMNT
     C                   MOVEL     DSNAR1        TINAR1
     C                   MOVEL     DSCUST        TICUST
     C                   MOVEL     DSCUSL        TICUSL
     C                   MOVEL     DSPRIN        TIPRIN
     C                   MOVEL     DSDCIN        TIDCIN
     C                   MOVEL     DSACMN        TIACMN
     C                   MOVEL     DSEXAC        TIEXAC
     C                   MOVEL     DSCCY2        TICCY2
     C                   MOVEL     'N'           MIDGEN
      *                                                                                       162155
     C                   MOVE      DSEVRF        TIEVRF                                       162155
      *                                                                                       CTI003
      ** Check TRTOT is not blank or non-numeric                                              CTI003
      *                                                                                       CTI003
     C                   TESTN                   DSTOT                55                      CTI003
     C     *IN55         IFNE      *ON                                                        CTI003
     C                   Z-ADD     *ZERO         TRTOT                                        CTI003
     C                   ELSE                                                                 CTI003
     C                   EVAL      TRTOT=DSTOT1                                               CTI003
     C                   END                                                                  CTI003
      *                                                                                       CTI003
      ** Check Extention Field Marker does not occur before DSTOT                             CTI003
      ** position in Journal Details DS                                                       CTI003
      *                                                                                       CTI003
     C     ':EXT:'       SCAN      DSEXT                                  70                  CTI003
     C     *IN70         IFEQ      *ON                                                        CTI003
     C                   Z-ADD     *ZERO         TRTOT                                        CTI003
     C                   END                                                                  CTI003
      *                                                                                       CTI003
      ** Change flag on TIDTA data area if Transaction Totals                                 CTI003
      ** field has been populated                                                             CTI003
      *                                                                                       CTI003
     C     *DTAARA       DEFINE                  TIDTA                                        CTI003
     C     TRTOT         IFNE      *ZERO                                                      CTI003
     C     *LOCK         IN        TIDTA                                                      CTI003
     C                   MOVEL     'Y'           TRFLAG                                       CTI003
     C                   OUT       TIDTA                                                      CTI003
     C                   ELSE                                                                 CTI003
      *                                                                                       CTI003
      ** Change flag on TIDTA data area to default to 'old'                                   CTI003
      ** processing                                                                           CTI003
      *                                                                                       CTI003
     C     *LOCK         IN        TIDTA                                                      CTI003
     C                   MOVEL     'N'           TRFLAG                                       CTI003
     C                   OUT       TIDTA                                                      CTI003
     C                   ENDIF                                                                CTI003
      *                                                                                       CTI003
     C     CEU029        IFEQ      'Y'                                          CEU029
     C                   MOVEL     DSOCCY        TIOCCY                         CEU029
     C                   MOVEL     DSOAMT        TIOAMT                         CEU029
     C                   ELSE                                                   CEU029
     C                   eval      TIOCCY = *BLANKS                             CEU029
     C                   eval      TIOAMT = 0                                   CEU029
     C                   ENDIF                                                  CEU029
      *
      ** Get Customer Details by access object
      *
     C                   MOVEL     DSCUST        @KEY
     C                   MOVE      DSCUSL        @KEY
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY             10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** Set up Associated Customer No.
     C     @RTCD         IFNE      *BLANKS
     C**********         MOVE      DSXACC        W#ACOD            4                   144700 CGL029
     C                   MOVE      DSXACC        W#ACOD                                       CGL029
      *                                                                                       144700
      * Check if account code is expense or income                                            144700
      *                                                                                       144700
     C                   CALL      'AOACODR0'                                                 144700
     C                   PARM      '*MSG    '    WWRTCD                                       144700
     C                   PARM      '*KEY    '    WWOPTN                                       144700
     C**********         PARM      W#ACOD        WWKEY4            4                   144700 CGL029
     C                   PARM      W#ACOD        WWKEY4                                       CGL029
     C     SDACOD        PARM      SDACOD        DSSDY                                        144700
      *  Error?                                                                               144700
     C     WWRTCD        IFNE      *BLANKS                                                    144700
     C**********         MOVE      *ZERO         ASOC                                  144700 CSD027
     C                   MOVE      *BLANKS       ASOC                                         CSD027
     C                   ELSE                                                                 144700
     C     A5ACSC        IFEQ      'EX'                                                       144700
     C     A5ACSC        OREQ      'IN'                                                       144700
     C*******************Z-ADD     CNUM          ASOC                                         144700
     C*******************ELSE                                                                 144700
     C*******************MOVEL     BBCUST        ASOC                                         161458
     C***********        MOVEL     GZCUS1RP      ASOC                                  161458 166006
      *                                                                                       166006
      ** Get Customer Number by access object                                                 166006
      *                                                                                       166006
     C**********         MOVE      *ZERO         ASOC                                  166006 CSD027
     C                   MOVE      *BLANKS       ASOC                                         CSD027
     C                   MOVEL     GZCUS1RP      @KEY                                         166006
      *                                                                                       166006
     C                   CALL      'AOCUSTR0'                                                 166006
     C                   PARM      '       '     @RTCD                                        166006
     C                   PARM      '*KEY   '     @OPTN                                        166006
     C                   PARM                    @KEY             10                          166006
     C                   PARM      *BLANKS       @KYST             7                          166006
     C     SDCUST        PARM      SDCUST        DSSDY                                        166006
      *                                                                                       166006
      ** Set up Associated Customer No.                                                       166006
      *                                                                                       166006
     C     @RTCD         IFEQ      *BLANKS                                                    166006
     C                   MOVE      BBCUST        ASOC                                         166006
     C                   ENDIF                                                                166006
      *                                                                                       166006
     C                   ELSE                                                                 144700
     C**********         MOVE      *ZERO         ASOC                                  144700 CSD027
     C                   MOVE      *BLANKS       ASOC                                         CSD027
     C                   ENDIF                                                                144700
     C                   ENDIF                                                                144700
     C                   ENDIF
      *
      ** Set up Nostro No. using External Account Id.
      *
     C                   CALL      'AONOSTR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DSXCUS        @CUST             6            I:Customer No
     C                   PARM      DSXCCY        @CYCD             3            I:Currency
     C**********         PARM      DSXACC        @ACCD             4            I:A/c Code    241385
     C                   PARM      DSXACC        @ACCD            10                          241385
     C                   PARM      DSXACS        @ACSN             2            I:A/c Seq
     C                   PARM                    @NONB             2            O:Nostro No
     C                   PARM      DSXBRA        @BRCD             3            I:Branch Code
     C                   PARM                    @CSSN            10            O:Cust ShortN
     C                   PARM                    @PNOI             1            O:Prime Nost In
     C     SDNOST        PARM      SDNOST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   Z-ADD     0             NONB
     C                   ELSE
     C                   MOVEL     A7NONB        NONB
     C                   ENDIF
      *
      *
      ** Convert TIVALD (7,0) to Midas Day No.
     C                   MOVE      TIVALD        DSYYMD
     C                   MOVEL     TIVALD        DSTIVD
     C     DSTIVC        IFEQ      0
     C                   Z-ADD     1900          DSYEAR
     C                   ELSE
     C                   Z-ADD     2000          DSYEAR
     C                   ENDIF
     C                   ADD       DSTIVY        DSYEAR
      *
      *
      ** Convert YYYYMMDD Date into Midas Date
      * The date to be converted has to be in a zoned field for ZDATE10, so     CAP002
      *  it is moved into one before the call and back after the call.          CAP002
     C                   MOVEL     DSYYMD        DtYYYYMMDD        8 0
     C                   Z-ADD     DtYYYYMMDD    DateToCvt                      CAP002
     C                   CALLB     'ZDATE10'
     C*******************PARM                    DtYYYYMMDD                     CAP002
     C                   PARM                    DateToCvt                      CAP002
     C     MTIVD         PARM      *ZERO         MidasDay          5 0
      *
     C                   Z-ADD     DateToCvt     DtYYYYMMDD                     CAP002
      **********                                                                      189111 BUG6008
      ***If*Posting*Date*earlier*than*account*opening*date,*send*a*message.           189111 BUG6008
      **********                                                                      189111 BUG6008
     C*****MTIVD         IFLT      DACO                                               189111 BUG6008
     C**********         CALL      'Y2SNMGC'                                          189111 BUG6008
     C**********         PARM      'TIC0300'     ZAPGMQ           10    Program queue 189111 BUG6008
     C**********         PARM                    ZAPGRL            5    Rel queue     189111 BUG6008
     C**********         PARM      'TIM0006'     ZAMSID            7            Messag189111 BUG3955
     C**********         PARM      'TIM0011'     ZAMSID            7    Message Id.  BUG3955 BUG6008
     C**********         PARM      'TIUSRMSG'    ZAMSGF           10    Message file. 189111 BUG6008
     C**********         PARM      DSTI4         ZAMSDA          132    Message data. 189111 BUG6008
     C**********         PARM      '*INFO'       ZAMSTP            7    Message type. 189111 BUG6008
     C**********         MOVE      'Y'           PSTERR                               189111 BUG6008
     C**********         DUMP                                                        BUG3955 BUG6008
     C**********         ENDIF                                                        189111 BUG6008
      *
      ** Set up Posting Status
      ** 'PSH' - Pending Shadow Posting.
      ** 'PJS' - Pending Journal Entry Generation with Shadow Posting
      ** 'PJN' - Pending Journal Entry Generation with NO Shadow Posting
     C                   SELECT
     C     PJTTY         WHENEQ    'A'
     C     MTIVD         IFGE      BJDNWD
     C                   MOVEL     'PSH'         PSTS
     C                   ELSE
     C                   MOVEL     'PJS'         PSTS
     C                   ENDIF
     C     PJTTY         WHENEQ    'M'
     C                   MOVEL     'PJN'         PSTS
     C                   ENDSL
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      /TITLE SR/*INZSR
      *****************************************************************
      *                                                               *
      * BaseCurr - This subroutine generates base currency            *
      *            equivalent postings                                *
      *                                                               *
      * Calledby: AMPOST                                              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     BaseCurr      BEGSR
      *
     C*****K#BaseCur*    klist                                                                162155
     C***************    kfld                    DRCV                                         162155
     C***************    kfld                    TRANID                                       162155
     C***************    kfld                    DSCCY2                                       162155
     C***************    kfld                    DSCCYM                                       162155
      *
     C     K#BaseCur     klist                                                                162155
     C**********         kfld                    DRCV                                  162155 212558
     C                   kfld                    TRDATE                                       212558
     C                   kfld                    TIEVRF                                       162155
     C                   kfld                    DSCCY2                                       162155
     C                   kfld                    DSCCYM                                       162155
      *                                                                                       162155
     C                   if        PSTERR = 'N'
     C*****K#BaseCur*    chain     TIPOSTL7                           8991                    162155
     C     K#BaseCur     chain     TIPOSTLS                           8991                    162155
      *****************************************************************               176322 BUG4200
      ***Loop*until*end*of*file*or*the*correct*pair*is*found***********               176322 BUG4200
      *****************************************************************               176322 BUG4200
     C**********         DOW       *IN89 = '0'                                        176322 BUG4200
      *                                                                               176322 BUG4200
      *  The first posting from the pair is found and is valid
     C                   if        *in89 = '0'  and PSTERRL7 = 'N'
      *
      *  Convert Amount from the first posting and find account code
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG    '    WWRTCD            7
     C                   PARM      '*KEY    '    WWOPTN            7
     C                   PARM      TICCYML7      WWKEY3            3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     WWRTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   MOVEL     'TI0310'      DBPGM
     C                   Z-ADD     9             DBASE                          ***************
     C                   MOVEL     'SDCURRPD'    DBFILE                         *DB ERROR 001 *
     C                   MOVEL     TICCYML7      DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *  Convert the amount to base currency
     C                   CALLB     'ZCONVZ1'
     C                   PARM      TIAMNTL7      InputAmnt        15 0
     C                   PARM      A6SPRT        ExchRate         13 8
     C                   PARM      A6MDIN        MultDivInd        1
     C                   PARM      TICCYML7      FromCurr          3
     C                   PARM      BJCYCD        ToCurr            3
     C                   PARM      A6NBDP        FrDecPlace        1 0
     C                   PARM      BaseCurDec    ToDecPlace        1 0
     C     Amount1       PARM      0             OutputAmnt       15 0
      *
      *  Get account code for base currency equivalent posting
     C                   MOVE      A6SPAE        ACODL7
      *
      *  Convert Amount from the second posting and find account code
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG    '    WWRTCD
     C                   PARM      '*KEY    '    WWOPTN
     C                   PARM      TICCYM        WWKEY3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     WWRTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   MOVEL     'TI0310'      DBPGM
     C                   Z-ADD     9             DBASE                          ***************
     C                   MOVEL     'SDCURRPD'    DBFILE                         *DB ERROR 001 *
     C                   MOVEL     TICCYM        DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *  Convert the amount to base currency
     C                   CALLB     'ZCONVZ1'
     C                   PARM      TIAMNT        InputAmnt
     C                   PARM      A6SPRT        ExchRate
     C                   PARM      A6MDIN        MultDivInd
     C                   PARM      TICCYM        FromCurr
     C                   PARM      BJCYCD        ToCurr
     C                   PARM      A6NBDP        FrDecPlace
     C                   PARM      BaseCurDec    ToDecPlace
     C     Amount2       PARM      0             OutputAmnt
      *
      *  Get account code for base currency equivalent posting
     C                   MOVE      A6SPAE        ACOD
      *****************************************************************               176322 BUG4200
     C**********         IF        Amount1 = Amount2                                  176322 BUG4200
      *
      *  Calculate the average amount
     C                   z-add     0             AvrgAmount       15 0
      *                                                                                      BUG4200
     C                   IF        TICCYML7 = BJCYCD                                         BUG4200
     C                   EVAL      AvrgAmount = TIAMNTL7                                     BUG4200
     C                   ELSE                                                                BUG4200
     C                   IF        TICCYM = BJCYCD                                           BUG4200
     C                   EVAL      AvrgAmount = TIAMNT                                       BUG4200
     C                   ELSE                                                                BUG4200
     C                   eval      AvrgAmount = (Amount1 + Amount2)/2
     C                   ENDIF                                                               BUG4200
     C                   ENDIF                                                               BUG4200
      *
      *  Set up the fields for Base Currency Equivalent Postings
      *  Second Posting:
     C                   eval      TICCY2 = TICCYM
     C                   eval      TICCYM = BJCYCD
     C                   eval      TIAMNT = AvrgAmount
     C                   if        TIDCIN = 'C'
     C                   eval      TIDCIN = 'D'
     C                   else
     C                   eval      TIDCIN = 'C'
     C                   endif
     C                   eval      CCY = BJCYCD
     C                   eval      ACSQ = 1
     C                   eval      PSTS = 'PJS'
     C**********         eval      TRANID = *BLANK                              144702
     C                   eval      TRSEQ = 0
     C                   eval      MIDGEN = 'Y'
     C                   eval      TIOCCY = *BLANKS                             CEU029
     C                   eval      TIOAMT = 0                                   CEU029
     C                   WRITE     TIPOSTD0                             88
     C     *IN88         IFEQ      *ON                                          140071
     C     *LOCK         IN        LDA                                          140071
     C                   SETON                                          U7U8    140071
     C                   MOVEL     'TI0310'      DBPGM                          140071
     C                   Z-ADD     10            DBASE                          140071*********
     C                   MOVEL     'TIPOSTPD'    DBFILE                         140071ERR 010 *
     C                   MOVEL     TIERR         DBKEY                          140071*********
     C                   OUT       LDA                                          140071
     C                   EXSR      *PSSR                                        140071
     C                   ENDIF                                                  140071
      *
      *  First Posting:
     C                   eval      TIDLBR = TIDLBRL7
     C                   eval      TIDLTP = TIDLTPL7
     C                   eval      TIDLRF = TIDLRFL7
     C                   eval      TISEQN = TISEQNL7
     C                   eval      TIVALD = TIVALDL7
     C                   eval      TIACBR = TIACBRL7
     C                   eval      TIACBN = TIACBNL7
     C                   eval      TIACSF = TIACSFL7
     C                   eval      TINAR1 = TINAR1L7
     C                   eval      TICUST = TICUSTL7
     C                   eval      TICUSL = TICUSLL7
     C                   eval      TIPRIN = TIPRINL7
     C                   if        TIDCINL7 = 'C'
     C                   eval      TIDCIN = 'D'
     C                   else
     C                   eval      TIDCIN = 'C'
     C                   endif
     C                   eval      TICCY2 = TICCYML7
     C                   eval      TIEXAC = TIEXACL7
     C                   eval      BRCA = BRCAL7
     C                   eval      CNUM = CNUML7
     C                   eval      ACOD = ACODL7
     C                   eval      ASOC = ASOCL7
     C                   eval      DRCV = DRCVL7
     C                   eval      TRDATE = TRDATEL7                                          212558
     C                   eval      MTIVD = MTIVDL7
     C                   WRITE     TIPOSTD0                             88
     C     *IN88         IFEQ      *ON                                          140071
     C     *LOCK         IN        LDA                                          140071
     C                   SETON                                          U7U8    140071
     C                   MOVEL     'TI0310'      DBPGM                          140071
     C                   Z-ADD     11            DBASE                          140071*********
     C                   MOVEL     'TIPOSTPD'    DBFILE                         140071ERR 011 *
     C                   MOVEL     TIERR         DBKEY                          140071*********
     C                   OUT       LDA                                          140071
     C                   EXSR      *PSSR                                        140071
     C                   ENDIF                                                  140071
     C**********         EVAL      *IN89 = '1'                                        176322 BUG4200
     C**********         ELSE                                                         176322 BUG4200
     C**********         DUMP                                                                BUG4200
     C*****K#BaseCur     READE     TIPOSTLS                               89          176322 BUG4200
     C**********         ENDIF                                                        176322 BUG4200
      *****************************************************************               176322 BUG4200
      *
     C                   endif
      *****************************************************************               176322 BUG4200
     C**********         ENDDO                                                        176322 BUG4200
     C                   endif
     C
     C                   ENDSR
      /EJECT
     C/COPY WNCPYSRC,TI0310MC02
      *****************************************************************
      /TITLE SR/*INZSR
      *****************************************************************
      *                                                               *
      * *INZSR  - Intialisation routine                               *
      *                                                               *
      * Called: Automatically                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Set up copyright parameter
     C                   MOVEA     CPY@          CPY2@            80
      *
      ***  Initialise LDA field.
     C                   MOVEL     'TI0310'      DBPGM
      *
      ** Read in Installation Data
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
     C     AGDFF         IFEQ      'M'
     C                   SETON                                        98
     C                   ENDIF
      *
     C     *ENTRY        PLIST
     C                   PARM                    PJTTY             1            Trans subtype
     C                   PARM                    PWSID             4            Workst ID
     C                   PARM                    PUSID             4            User ID
     C                   PARM                    PETKY             4            Trans key
     C                   PARM                    PETNB             7 0          Trans seq
     C                   PARM                    PBRNM             4            Dft Branch
     C                   PARM                    PJRDT_trun     1983            Trans detail
     C                   PARM                    PSTIN             1            Success flag
      *
     C                   MOVE      *BLANK        CH17             17
     C                   EVAL      PJRDT = CH17 + PJRDT_trun
      **  Set PSTIN to N so only this program can return it as a 'Y'            207601
     C                   MOVE      'N'           PSTIN                          207601
      *
      **  Key list for ACCNTTI - A/c Branch, A/c No. and A/c Suffix.
     C     KACCNT        KLIST
     C                   KFLD                    W#BRCA            3
     C                   KFLD                    DSACBN
     C                   KFLD                    DSACSF
      *
      ****Key*list*for*TIPOSTL0*-*TI*Branch*Branch*Mnemonic,*TI*Deal*Type,                   BUG3836
      **  Key list for TIPOSTLC - TI Branch Branch Mnemonic, TI Deal Type,                   BUG3836
      **  TI Deal Reference, TI Sequence Number and TI Value Date.
     C     KTIPST        KLIST
     C**********         KFLD                    TRANID                               212558 BUG3836
     C                   KFLD                    TIDLBR
     C**********         KFLD                    TIDLTP                                       212558
     C**********         KFLD                    TIDLRF                                       212558
     C                   KFLD                    TIEVRF                                       212558
     C                   KFLD                    TISEQN
     C                   KFLD                    TIVALD
      *
      ****Key*list*for*TIPOSTL4*-*Date*Received/*Transaction Key/******pe,                    212558
      **  Key list for TIPOSTL4 - Date Sent by TI/ Transaction Key/                           212558
      **  Transaction Sequence
     C     KTIP4         KLIST
     C**********         KFLD                    DRCV                                         212558
     C                   KFLD                    TRDATE                                       212558
     C                   KFLD                    TRANID
     C                   KFLD                    TRSEQ
      *                                                                                       CTI005
      **  Key list for ACCBR                                                                  CTI005
      *                                                                                       CTI005
     C     ACCNTK        KLIST                                                                CTI005
     C                   KFLD                    BRCA                                         CTI005
     C                   KFLD                    CNUM                                         CTI005
     C                   KFLD                    CCY                                          CTI005
     C                   KFLD                    ACOD                                         CTI005
     C                   KFLD                    ACSQ                                         CTI005
      *                                                                                       CTI005
      **  Key list for ACCNTTI                                                                CTI005
      *                                                                                       CTI005
     C     TIACCNTK      KLIST                                                                CTI005
     C                   KFLD                    AB_BRCA                                      CTI005
     C                   KFLD                    AB_A5TIAN                                    CTI005
     C                   KFLD                    AB_A5TIAS                                    CTI005
     C     TIACCNTKX     KLIST                                                                CTI005
     C                   KFLD                    AB_BRCA                                      CTI005
     C                   KFLD                    AB_A5TIAN                                    CTI005
     C                   KFLD                    WA_SUFFIX                                    CTI005
      *                                                                                       CTI005
      **  Key list for GLACNTL6                                                               CTI005
      *                                                                                       CTI005
     C     GLACNTK       KLIST                                                                CTI005
     C                   KFLD                    F1CNUM                                       CTI005
     C                   KFLD                    F1CCY                                        CTI005
     C                   KFLD                    F1ACOD                                       CTI005
     C                   KFLD                    F1ACSQ                                       CTI005
     C                   KFLD                    F1BRCA                                       CTI005
      *
      ** Get Bank Details by access object
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   MOVEL     'TI0310'      DBPGM
     C                   Z-ADD     1             DBASE                          ***************
     C                   MOVEL     'SDBANKPD'    DBFILE                         *DB ERROR 001 *
     C                   MOVEL     '*FIRST'      DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *  Get details for the base currency
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG    '    WWRTCD
     C                   PARM      '*KEY    '    WWOPTN
     C                   PARM      BJCYCD        WWKEY3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     WWRTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   MOVEL     'TI0310'      DBPGM
     C                   Z-ADD     9             DBASE                          *********
     C                   MOVEL     'SDCURRPD'    DBFILE                         *DB ERRO*
     C                   MOVEL     BJCYCD        DBKEY                          *********
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   Z-ADD     A6NBDP        BaseCurDec        1 0
     C*******************MOVEL     A6SPAE        SpotTradEq        4            175869        CTI005
     C                   MOVEL     A6SPAE        SpotTradEq       10                          CTI005
     C                   ENDIF
      *
      *  Get Spot Trade Account
     C                   CALL      'AOTRADR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDTRAD        PARM      SDTRAD        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   MOVEL     'TI0310'      DBPGM
     C                   Z-ADD     6             DBASE                          ************
     C                   MOVEL     'SDTRADPD'    DBFILE                         *DB ERROR 06
     C                   MOVEL     '*FIRST'      DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     CONT13        SIZE13           13 0
     C                   Z-ADD     0             Amount1          15 0
     C                   Z-ADD     0             Amount2          15 0
      *
      ** Access SAR details file to determine if CEU029 is installed.           CEU029
      *                                                                         CEU029
     C                   CALL      'AOSARDR0'                                   CEU029
     C                   PARM      '       '     ##RTCD            7            CEU029
     C                   PARM      '*VERIFY'     ##OPTN            7            CEU029
     C                   PARM      'CEU029'      ##SARD            6            CEU029
      *                                                                         CEU029
      ** Database Error                                                         CEU029
      *                                                                         CEU029
     C     ##RTCD        IFNE      *BLANK                                       CEU029
     C     ##RTCD        ANDNE     '*NRF   '                                    CEU029
     C     *LOCK         IN        LDA                                          CEU029
     C                   SETON                                          U7U8    CEU029
     C                   MOVEL     'TI0310'      DBPGM                          CEU029
     C                   Z-ADD     12            DBASE                          CEU029*********
     C                   MOVEL     'SCSARDPD'    DBFILE                         CEU029RROR 12 *
     C                   MOVEL     '*CALL'       DBKEY                          CEU029*********
     C                   OUT       LDA                                          CEU029
     C                   EXSR      *PSSR                                        CEU029
     C                   ENDIF                                                  CEU029
     C*                                                                         CEU029
     C     ##RTCD        IFEQ      *BLANK                                       CEU029
     C                   MOVEL     'Y'           CEU029            1            CEU029
     C                   ELSE                                                   CEU029
     C                   MOVEL     'N'           CEU029                         CEU029
     C                   ENDIF                                                  CEU029
     C/COPY WNCPYSRC,TI0310MC04
     C*                                                                         CEU029
      ** Determine if Data Export for CCRM Limits is active                     CDE001
     C                   CALL      'AOSARDR0'                                   CDE001
     C                   PARM      *BLANKS       ##RTCD                         CDE001
     C                   PARM      '*VERIFY'     ##OPTN                         CDE001
     C                   PARM      'CDE001'      ##SARD                         CDE001
      *                                                                         CDE001
     C     ##RTCD        IFEQ      *BLANK                                       CDE001
     C                   MOVEL     'Y'           CDE001            1            CDE001
     C                   ENDIF                                                  CDE001
      *                                                                         CDE001
      *                                                                                       CTI005
      ** Get Midas/TI interface ICD details                                                   CTI005
      *                                                                                       CTI005
     C                   CALL      'AOTIINR0'                                                 CTI005
     C                   PARM      '*DBERR '     WWRTCD                                       CTI005
     C                   PARM      '*FIRST '     WWOPTN                                       CTI005
     C     SDTIIN        PARM      SDTIIN        DSSDY                                        CTI005
      *                                                                                       CTI005
     C     WWRTCD        IFNE      *BLANKS                                                    CTI005
     C     *LOCK         IN        LDA                                                        CTI005
     C                   SETON                                          U7U8                  CTI005
     C                   MOVEL     'TI0310'      DBPGM                                        CTI005
     C                   Z-ADD     14            DBASE                                        CTI005
     C                   MOVEL     'SDTIINPD'    DBFILE                                       CTI005
     C                   MOVEL     '*FIRST'      DBKEY                                        CTI005
     C                   OUT       LDA                                                        CTI005
     C                   EXSR      *PSSR                                                      CTI005
     C                   ENDIF                                                                CTI005
      *                                                                                       CTI005
      ** Access SAR details file to determine if CTI005 is installed.                         CTI005
      *                                                                                       CTI005
     C                   CALL      'AOSARDR0'                                                 CTI005
     C                   PARM      '       '     ##RTCD                                       CTI005
     C                   PARM      '*VERIFY'     ##OPTN                                       CTI005
     C                   PARM      'CTI005'      ##SARD                                       CTI005
      *                                                                                       CTI005
     C     ##RTCD        IFEQ      *BLANK                                                     CTI005
     C                   MOVEL     'Y'           CTI005            1                          CTI005
     C                   ENDIF                                                                CTI005
     C                   MOVEL     'Y'           CTI005                                      BUG3837
      *                                                                                       CTI005
      ** Determine if CLE025 (Credit Lines) is installed                                      CTI005
      *                                                                                       CTI005
     C                   CALL      'AOSARDR0'                                                 CTI005
     C                   PARM      *BLANKS       ##RTCD                                       CTI005
     C                   PARM      '*VERIFY'     ##OPTN                                       CTI005
     C                   PARM      'CLE025'      ##SARD                                       CTI005
      *                                                                                       CTI005
     C     ##RTCD        IFEQ      *BLANKS                                                    CTI005
     C                   MOVEL     'Y'           CLE025            1                          CTI005
     C                   ENDIF                                                                CTI005
      *                                                                                       CTI005
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: Various                                            *
      *                                                               *
      * Calls: DBERRCTL                                               *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   MOVE      'N'           PSTIN
     C                   DUMP
     C                   ENDIF
      *
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C/COPY WNCPYSRC,TI0310MC03
     C                   ENDSR
      *
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
