     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')                         CAP084
     F*****************************************************************
/*S*D****RPGBASE*******************************************************                       CAP084
/*STD *  RPGBASEMOD                                                   *                       CAP084
/*EXI *  TEXT('Midas AB MM Midas upd control & sundry upds')          *
     F*****************************************************************
     F*                                                               *
     F*  Midas  -  Internal Contracts & Arbitrage Dealing
     F*                                                               *
     F*     AB0230    - Update MIDAS Database                         *
     F*                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
     F*                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. CDL094             Date 01Sep14               *
      *                 MD027531           Date 30Jun14               *
      *                 CSW212             Date 03May12               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CAP084             Date 06Sep03               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
     F*                 CAC001             Date 01Feb96               *
     F*                 S01453             Date 13Dec93               *
     F*                 S01319             Date 01Aug91               *
     F*                 E24178             Date 29Jul91               *
     F*                  E23869             Date 03JUL91              *
     F*                  S01117             Date 30JAN90              *
     F*                  S01194             Date 30JAN90              *
     F*                  E19709             DATE 05/10/89             *
     F*                  E19012             DATE 10/08/89             *
     F*                  E17607             DATE 15/03/89             *
     F*                  AB0226             DATE 05/05/88             *
     F*                  AB0201             DATE 27/04/88             *
     F*                  AB0110             DATE 29/02/88             *
     F*                  AB0102             DATE 29/02/88             *
     F*                  AB0076             DATE 03/02/88             *
     F*                  AB0075             DATE 03/02/88             *
     F*                  AB0065             DATE 26/01/88             *
     F*                                                              *
     F*****************************************************************
     F*                                                               *
      *  CDL099 - Split Value Date                                    *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  MD027531 - Locking in OLPOS file                             *
      *  CSW212 - SWIFT 2012 Changes (Recompile)                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CAP084 - Convert to ILE.                                     *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CDL008 - Continuous Linked Settlement (Recompiled ABDELULL)  *
     F*  CAC001 - Profit Centre Accounting Development:               *
     F*           Recompiled only.                                    *
     F* S01453 - Margin and FX Positions/Points and Base currency     *
     F*          Positions/Points added to FX input (Recompiled)      *
     F*                                                               *
     F* S01319   Removal of ABSTDDLL
     F*                                                               *
     F* E24178 - Free PGM/AB0240 after it is called, to prevent       *
     F*          from deleted records being picked up incorrectly.    *
     F*                                                               *
     F* E23869 - When an internal contract is back valued, the FX
     F*          on-line position (OLPOS) for today should be updated.
     F*          This will reflect entries which will be genetrated
     F*          in tonight's COB.
     F* S01194 - NEW STANDING DATA                                    *
     F* S01117 - MULTI-BRANCHING.                                     *
     F*                                                               *
     F*  E19709 - THE DEALS FILE SHOULD ONLY BE OPENED AS INPUT,      *
     F*           ARBRITRAGE SHOULD HAVE A LOGICIAL FOR UPDATE        *
     F*           (ABDELULL) AS IN MM AND FX.                         *
     F*                                                               *
     F*  E19012 - DECIMAL POINTS FOR EVENT #TOTAL CALCULATED          *
     F*           INCORRECTLY FOR REVERSAL. BACKDATED DEALS DELETED   *
     F*           DON'T UPDATE DEALSDF FOR BOTH LEGS.                 *
     F*                                                               *   AB0065
     F*  E17607 - CORRECT DEAL REVERSAL LOGIC                         *   AB0065
     F*                                                               *   AB0065
     F*  AB0226 - IF DEAL INCOMPLETE SHOULD NOT UPDATE DTRIXHH        *   AB0065
     F*                                                               *   AB0065
     F*  AB0201 - IF DBERR DUMP FOR EASY FIXING                       *   AB0065
     F*                                                               *   AB0065
     F*  AB0110 - REVERSAL PROCESSING INCORRECT. IT DOES NOT TAKE     *   AB0110
     F*           INTO ACCOUNT FAR DATE AMOUNTS.                      *   AB0110
     F*                                                               *   AB0065
     F*  AB0102 - UPDATE OF PF/DEALSDF MUST BE DONE AS 2ND TO LAST    *   AB0102
     F*           UPDATE. THIS AVOIDS RECORD LOCKING.                 *   AB0102
     F*                                                               *   AB0065
     F* AB0076 - KIGNORE ON SDTIX NOT USED, OPENED BY AB0240          *   AB0065
     F*                                                               *   AB0065
     F*  AB0075 - IF AB0240 IS RETURNED WITH ERROR MUST SKIP          *   AB0065
     F*                REST OF UPDATES                                *   AB0065
     F*                                                               *   AB0065
     F*  AB0065 -      SUBMISSION OF BATCH JOB DLC0210A               *   AB0065
     F*                REMOVED FROM PROGRAM.                          *   AB0065
     F*****************************************************************
     F/EJECT
     F****************************************************************
     F*
     F* ID F  C  H  L    FUNCTION OF INDICATORS
     F*
     F*       60         DATE FOUND ON LOKUP
     F*       61         DATE NOT FOUND ON LOKUP - USE 16TH DATE
     F*
     F*       76         READ/CHAIN FAIL
     F*
     F*       U6         PROGRAM ERROR
     F*       U7         DATA BASE OR EXCEPTION ERROR
     F*       U8         DATA BASE OR EXCEPTION ERROR
     F*
     F*****************************************************************
     F/EJECT
     F*ABSTDDLLUF**E*******************DISK*********KINFSR*INFSR******UC**S01319
     F**********************************************KCOMIT****************S01319
     F***OLPOS**   UF   E           K DISK    INFSR(INFSR)                                  MD027531
     FOLPOS     IF   E           K DISK    INFSR(INFSR)                                     MD027531
     F                                     USROPN
     F                                     COMMIT
     F                                     IGNORE(OLPOSHHF)
     F                                     IGNORE(OLPOSOBF)
     FSDTIX     UF   E           K DISK    INFSR(INFSR)
     F                                     USROPN
     F                                     COMMIT
     F************DTRIXDF                           KIGNORE               AB0076
     F                                     INFDS(@SDOP)
     F*DEALS   UF  E           K        DISK KINFSR INFSR A    UC AB0102  E19709
     F**********  DEALSDAF                          KIGNORE       AB0102  E19709
     F**********  DEALSDCF                          KIGNORE       AB0102  E19709
     F**********  DEALSDDF                          KIGNORE       AB0102  E19709
     F**********  DEALSDEF                          KIGNORE       AB0102  E19709
     F**********  DEALSDGF                          KIGNORE       AB0102  E19709
     FABDELULL  UF A E           K DISK    INFSR(INFSR)                         E19709
     F                                     USROPN
     F                                     COMMIT                               AB0102
     F*FDICDRLLIF*E***********K        DISK         KINFSR INFSR      UC  S01194
     F************TABTB20F*****                     KIGNORE               S01194
     F/COPY WNCPYSRC,AB0230F001
     D*
     D**  ARRAY TO HOLD COPYRIGHT STATEMENT
      *****                                                               AB0065
      ***** SBMJOB command.                                               AB0065
     D*****               @CMD    1   1 80                                AB0065
      *
      ** Array containing next sixteen working days MIDAS day numbers.
      *
      ** Array of income by day.
      *
      ** Array of outgoings by day.
     D @CPYRT          DS
     D*
     D**  DATA STRUCTURE FOR COMPILATION - COPYRIGHT INSERTION
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
      *
      ** Data structure of OLPOS record.
     D @OLPOS          DS           400
     D  RECI                   1      1
     D  CCY                    2      4
     D  RECN                   5      6  0
     D  PCOB                   7     14P 0
     D  ODT                   15     62
     D  @WD                   15     62P 0
     D                                     DIM(16) ASCEND
     D  OFI                   63    190
     D  @IN                   63    190P 0
     D                                     DIM(16)
     D  OFO                  191    318
     D  @OT                  191    318P 0
     D                                     DIM(16)
     D  ZZ0319               319    397
     D  TNLU                 398    400P 0
      *
      **  Program status data structure.
     D PSDS           SDS
     D  @FILE                201    208
     D  @JOB                 244    253
     D  @USER                254    263
      *
      **  Local data area for data base error.
     D                UDS
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183
      *
      *****************************************************************
      *  Data Structures for the parm. passed.                        *
      *****************************************************************
      *
     D*
     D @SDOP           DS
     D  @SDOPN                 9      9
     D DSSTD         E DS                  EXTNAME(ABSTDDPP)
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                    S01194
      ** BANK DETAILS ACCESSED VIA ACCESS PROGRAM                         S01194
     D  RUND                  34     36P 0                                      S01194
      *                                                                   S01194
     D DSFDY         E DS                  EXTNAME(DSFDY)                       S01194
     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                S01194
      *
      *   Data Structure for aligning integer/decimal purchase amount     AB0102
     D @SPLIT          DS            15                                         AB0102
     D  @INT                   1     12  0                                      AB0102
     D  @DEC                  13     15  0                                      AB0102
     D  @ID                    1     15                                         AB0102
                                                                                            MD027531
      ** Parameters for AOOLPSU0                                                            MD027531
                                                                                            MD027531
     D pRtnCode        S              7A                                                    MD027531
     D pOlposKey       S              8A                                                    MD027531
     D pValDate        S              5P 0                                                  MD027531
     D pAmount         S             15P 0                                                  MD027531
     D pIncOut         S              1A                                                    MD027531
                                                                                            MD027531
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN     - Control processing                                 *
      *                                                               *
      * CALLS    #A       - Initial processing                        *
      *          #B       - Control main processing                   *
      *          #C       - Final processing                          *
      *                                                               *
      * CALLED BY         -                                           *
      *                                                               *
      * FLDS USED  @FCYC  - First cycle flag                          *
      *                                                               *
      *****************************************************************
      *
      **  Initial processing.
     C     @FCYC         IFNE      'Y'                                          B1
     C                   EXSR      #A                                           *1
      *                                                                   AB0120
     C                   END                                                    E1
      *                                                                   AB0102
     C     *INU7         IFNE      '1'                                          B1             AB010
      *                                                                   AB0102
      **  Main processing.                                                AB0102
     C                   EXSR      #B                                           *1             AB010
      *                                                                   AB0102
      **  Final processing.                                               AB0102
     C                   EXSR      #C                                                          AB010
      *                                                                   AB0102
     C                   END                                                    E1             AB010
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SUBROUTINES USED                                              *
      *                                                               *
      *  01  #ZC      - Accumulate currency balances for OLPOS        *
      *  02  #ZA      - Access OLPOS record via currency,'02'         *
      *  03  #ZB      - Access OLPOS record via currency,'03'         *
      *  04  #B       - Control main processing                       *
      *  05  #BA      - Process loans/deposits                        *
      *  06  #BAA     - Process FX ins/dels                    ( 01 ) *
      *  07  #BAB     - Process LOANS/DEPOSITS ins/dels        ( 03 ) *
      *  08  #BAC     - Process INTEREST ins/dels              ( 02 ) *
      *  09  #BB    -   Updates trailer to DEALSDF for INSERT         *   AB0102
      *  10  #BC    -   Updates trailer to DEALSDF for REVERSALS      *   AB0102
      *  11  #ZE   -    Add amount to hash trailer                    *   AB0102
      *  12  #ZF   -    Subtract amount from hash trailer             *   AB0102
      *  13  #A       - Initial processing                            *   AB0102
      *  14  #C       - Final processing                              *   AB0102
      *  15  *PSSR    -                                               *   AB0102
      *  16  INFSR    -                                               *   AB0102
      *                                                               *
      * EXTERNAL ROUTINE                                              *
      *  17  AB0240   - MIDAS deals update                            *   AB0102
      *  18  QCAEXEC  - Submit MIDAS confirmation                     *   AB0102
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * #ZC      - Accumulate currency balances for OLPOS             *
      *                                                               *
      * CALLED BY  #BAA   - Process FX Ins/dels             ( 01 )    *
      *            #BAB   - Process LOAN/DEPOSITS ins/dels  ( 02 )    *
      *            #BAC   - Process INTEREST ins/dels       ( 03 )    *
      *                                                               *
      * FLDS USED  @DATE  - Date to which to be accumulated           *
      *            @@DTIN - Date                                      *
      *            @I     - Counter                                   *
      *            @MDNO  - MIDAS day number                          *
      *            @WD    - Array of working days for currency        *
      *            @INOUT - Accumulate to income or outgoings         *
      *            @ADSUB - Add or subtract to accumulators           *
      *            @AMNT  - Amount to accumulate                      *
      *            @IN    - Array of income accumulators              *
      *            @OT    - Array of outgoings accumulators           *
      *                                                               *
      *****************************************************************
     C*****#ZC           BEGSR                                                              MD027531
      **********************************************************************                MD027531
      ****Determine*date*bucket*into*which*amount*is*to*be*accumulated.*****                MD027531
     C**********         Z-ADD     1             @I                2 0                      MD027531
     C*****@MDNO         LOOKUP    @WD(@I)                              6061    *           MD027531
      **********                                                                            MD027531
      ****If*requested*date*before*start*of*array,*ignore*request.*****   E23869            MD027531
      ****If*requested*date*before*start*of*array,*update*todays*posn.****E23869            MD027531
     C******IN60         IFEQ      '0'                                          B1          MD027531
     C******IN61         ANDEQ     '0'                                          *1          MD027531
     C*********************GOTO #ZC9                       *1             E23869            MD027531
     C**********         Z-ADD     1             @I                             *1    E2386 MD027531
     C**********         END                                                    E1          MD027531
     C**********                                                                            MD027531
      ****Accumulate*amount*by*date.****************************************                MD027531
     C*****@INOUT        IFEQ      'I'                                          B1          MD027531
      **********                                                                            MD027531
     C*****@ADSUB        IFEQ      '+'                                          B*2         MD027531
     C**********         ADD       @AMNT         @IN(@I)                        **2         MD027531
     C**********         ELSE                                                   X*2         MD027531
     C**********         SUB       @AMNT         @IN(@I)                        **2         MD027531
     C**********         END                                                    E*2         MD027531
      **********                                                                            MD027531
     C**********         ELSE                                                   X1          MD027531
      **********                                                                            MD027531
     C*****@ADSUB        IFEQ      '+'                                          B*2         MD027531
     C**********         ADD       @AMNT         @OT(@I)                        **2         MD027531
     C**********         ELSE                                                   X*2         MD027531
     C**********         SUB       @AMNT         @OT(@I)                        **2         MD027531
     C**********         END                                                    E*2         MD027531
      **********                                                                            MD027531
     C**********         END                                                    E1          MD027531
      **********                                                                            MD027531
     C*****#ZC9          ENDSR                                                              MD027531
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * #ZA      - Access OLPOS record via currency,'02'              *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  #BAB   - Process LOAN/DEPOSITS ins/dels  ( 02 )    *
      *                                                               *
      * FLDS USED  @OLKY2 - Key to OLPOS record 02                    *
      *            @BRCA  - Branch                                    *   S01117
      *            @CCY   - Currency                                  *
      *            @2     - '02'                                      *
      *            @OLPSK - Key to OLPOS used in DB error reporting   *
      *            @OLPK2 - Multibranched version of @OLPSK           *   S01117
      *                                                               *
      *****************************************************************
     C     #ZA           BEGSR
      *
      **  Define key list.
     C     @OLKY2        KLIST
     C                   KFLD                    @BRCA                                         S0111
     C                   KFLD                    @CCY
     C                   KFLD                    @2
      *
     C     @OLKY2        CHAIN     OLPOS                              7676
      *
     C     *IN76         IFEQ      '1'                                          B1
     C                   MOVEL     @CCY          @OLPSK            5            *1
     C                   MOVE      '02'          @OLPSK                         *1
     C                   MOVE      '004'         DBASE                          ***************
     C                   MOVEL     'OLPOS'       DBFILE                         *             *
     C*********************MOVEL@OLPSK    DBKEY            * DBERROR 004 *S01117
     C                   MOVEL     @BRCA         @OLPK2            8            *              S0111
     C                   MOVE      @OLPSK        @OLPK2                         *              S0111
     C                   MOVEL     @OLPK2        DBKEY                          *              S0111
     C                   MOVE      '1'           *INU7                          *             *
     C                   MOVE      '1'           *INU8                          ***************
     C                   DUMP                                                                  AB020
     C                   END                                                    E1
      *
     C     #ZA9          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * #ZB      - Access OLPOS record via currency,'03'              *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  #BAC   - Process INTEREST ins/dels       ( 03 )    *
      *                                                               *
      * FLDS USED  @OLKY3 - Key to OLPOS record 03                    *
      *            @BRCA  - Branch                                    *   S01117
      *            @CCY   - Currency                                  *
      *            @3     - '03'                                      *
      *            @OLPSK - Key to OLPOS used in DB error reporting   *
      *            @OLPK2 - Multibranched version of @OLPSK           *   S01117
      *                                                               *
      *****************************************************************
     C     #ZB           BEGSR
      *
      **  Define key list.
     C     @OLKY3        KLIST
     C                   KFLD                    @BRCA                                         S0111
     C                   KFLD                    @CCY
     C                   KFLD                    @3
      *
     C     @OLKY3        CHAIN     OLPOS                              7676
      *
     C     *IN76         IFEQ      '1'                                          B1
     C                   MOVEL     @CCY          @OLPSK            5            *1
     C                   MOVE      '03'          @OLPSK                         *1
     C                   MOVE      '003'         DBASE                          ***************
     C                   MOVEL     'OLPOS'       DBFILE                         *             *
     C*********************MOVEL@OLPSK    DBKEY            * DBERROR 003 *S01117
     C                   MOVEL     @BRCA         @OLPK2            8            *              S0111
     C                   MOVE      @OLPSK        @OLPK2                         *              S0111
     C                   MOVEL     @OLPK2        DBKEY                          *              S0111
     C                   MOVE      '1'           *INU7                          *             *
     C                   MOVE      '1'           *INU8                          ***************
     C                   DUMP                                                                  AB020
     C                   END                                                    E1
      *
     C     #ZB9          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * #ZD      - Access OLPOS record via currency,'01'              *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  #BAA   - Process INTEREST ins/dels       ( 01 )    *
      *                                                               *
      * FLDS USED  @OLKY1 - Key to OLPOS record 01                    *
      *            @BRCA  - Branch                                    *   S01117
      *            @CCY   - Currency                                  *
      *            @1     - '01'                                      *
      *            @OLPSK - Key to OLPOS used in DB error reporting   *
      *            @OLPK2 - Multibranched version of @OLPSK           *   S01117
      *                                                               *
      *****************************************************************
     C     #ZD           BEGSR
      *
      **  Define key list.
     C     @OLKY1        KLIST
     C                   KFLD                    @BRCA                                         S0111
     C                   KFLD                    @CCY
     C                   KFLD                    @1
     C     @OLKY1        CHAIN     OLPOS                              7676
      *
     C     *IN76         IFEQ      '1'                                          B1
     C                   MOVEL     @CCY          @OLPSK            5            *1
     C                   MOVE      '01'          @OLPSK                         *1
     C                   MOVE      '002'         DBASE                          ***************
     C                   MOVEL     'OLPOS'       DBFILE                         *             *
     C*********************MOVEL@OLPSK    DBKEY            * DBERROR 002 *S01117
     C                   MOVEL     @BRCA         @OLPK2            8            *              S0111
     C                   MOVE      @OLPSK        @OLPK2                         *              S0111
     C                   MOVEL     @OLPK2        DBKEY                          *              S0111
     C                   MOVE      '1'           *INU7                          *             *
     C                   MOVE      '1'           *INU8                          ***************
     C                   DUMP                                                                  AB020
     C                   END                                                    E1
      *
     C     #ZD9          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * #B       - Control main processing                            *
      *                                                               *
      * CALLS    AB0240   - MIDAS deals update                        *
      *          #BA      - Update MIDAS on-line positions file       *
      *          #BB    -   UPDATES TRAILER TO DEALSDF FOR INSERT     *   AB0102
      *          #BC    -   UPDATES TRAILER TO DEALSDF FOR REVERSALS  *   AB0102
      *          QCAEXEC  - Submit MIDAS confirmation                 *
      *                                                               *
      * CALLED BY  MAIN   - Control processing                        *
      *                                                               *
      * FLDS USED  @TERM  - Termination parameter                     *
      *****        @CMD   - SBMJOB command array                      *   AB0065
      *****        @LEN   - Length of SBMJOB command                  *   AB0065
      *            @TFKEY - Key for transaction file header - DTRIXHH *
      *            @SUM   - Sum of 1ST/2ND AMOUNTS                    *   AB0102
      *            @AMT   - Store NEAR DATE Amount                    *   AB0102
      *                                                               *
      *****************************************************************
     C     #B            BEGSR
      *
      **  If termination parameter set to 'T', no further processing.
     C     @TERM         CABEQ     'T'           #B9
      *
      ****Read*only*record*on*ABSTDDLL.***********************************S01319
     C***********1*********SETLLABSTDDLL**********************************S01319
     C*********************READ*ABSTDDLL***************7676***************S01319
      ********************************************************************S01319
     C************IN76*****IFEQ*'1'************************B1*************S01319
     C*********************MOVE*'001'*****DBASE***************************S01319
     C*********************MOVEL'ABSTDDLL'DBFILE**************************S01319
     C*********************MOVEL'1'*******DBKEY**************DBERROR*001**S01319
     C*********************MOVE*'1'********INU7***************************S01319
     C*********************MOVE*'1'********INU8***************************S01319
     C*********************DUMP*************************************AB0201S01319
     C*********************GOTO*#B9*************************1*************S01319
     C*********************END*****************************E1*************S01319
      *
      **  If deal has been authorised, update MIDAS deal files.
     C     JUDSTS        IFNE      'I'                                          B1
      *
     C                   CALL      'AB0240'                                     *1
     C                   PARM                    @TERM                          *1
     C                   PARM                    DSSTD                          *1
     C**********         FREE      'AB0240'                                             E2417 CAP084
      *
     C     @TERM         CABEQ     'E'           #B9                            *1             AB007
      *                                                                   AB0075
     C                   END                                                    E1
      *
     C                   EXSR      #BA
      *
     C     *INU7         CABEQ     '1'           #B9
      *
      ****Delete*standard*deal*record.************************************S01319
     C*********************DELETABSTDDLL**********************************S01319
      *
      *                                                                   AB0102
      **  If deal has been authorised, update MIDAS deal Trailer record   AB0102
     C     JUDSTS        IFNE      'I'                                          B1             AB010
      *                                                                   AB0102
      **  Ascertain MIDAS action code AND PROCESS ACCORDINGLY             AB0102
      *                                                                   AB0102
      ** 1/ Insertions.                                                   AB0102
      *  --------------                                                   AB0102
     C     JUMACT        IFEQ      'I'                                           B*2           AB010
      *                                                                   AB0102
      *                                                                   AB0102
      ** IF 1ST CURRENCY NEAR DATE AMOUNT IS POSITIVE THEN                AB0102
      ** SET VARIABLE HOLDING THE PURCHASE VALUES FROM THE FIRST AND      AB0102
      ** SECOND LEGS.                                                     AB0102
      *                                                                   AB0102
     C     JUNDA1        IFGT      0                                            B**3           AB010
     C                   Z-ADD     JUNDA1        @SUM             15 0          ***3           AB010
     C                   ELSE                                                   X**3           AB010
     C                   Z-ADD     JUNDA2        @SUM                           ***3           AB010
     C                   END                                                    E**3           AB010
      *                                                                   AB0102
      ** IF 1ST CURRENCY FAR DATE AMOUNT IS POSITIVE THEN                 AB0102
      ** SET SUM OF PURCHASE VALUES WITH THE SECOND LEG                   AB0102
      *                                                                   AB0102
      *                                                                   AB0102
     C     JUFDA1        IFGT      0                                            B**3           AB010
     C                   ADD       JUFDA1        @SUM                           ***3           AB010
     C                   ELSE                                                   X**3           AB010
     C                   ADD       JUFDA2        @SUM                           ***3           AB010
     C                   END                                                    E**3           AB010
      *                                                                   AB0102
     C                   EXSR      #BB                                          **2            AB010
      *                                                                   AB0102
     C                   ELSE                                                   X*2            AB010
      *                                                                   AB0102
      ** 2/ REVERSALS .                                                   AB0102
      *  --------------                                                   AB0102
      *                                                                   AB0102
      **         JUMACT    WILL EQUAL 'R' AT THIS POINT                   AB0102
      *                                                                   AB0102
     C     JUNDA1        IFGT      0                                            B**3           AB011
     C                   Z-ADD     JUNDA1        @SUM                           ***3           AB011
     C                   ELSE                                                   X**3           AB011
     C                   Z-ADD     JUNDA2        @SUM                           ***3           AB011
     C                   END                                                    E**3           AB011
      *                                                                   AB0110
     C     JUFDA1        IFGT      0                                            B**3           AB011
     C                   Z-ADD     JUFDA1        @AMT             15 0          ***3           AB011
     C                   ADD       JUFDA1        @SUM                           ***3           AB011
     C                   ELSE                                                   X**3           AB011
     C                   Z-ADD     JUFDA2        @AMT                           ***3           AB011
     C                   ADD       JUFDA2        @SUM                           ***3           AB011
     C                   END                                                    E**3           AB011
      *                                                                   AB0102
     C                   EXSR      #BC                                          **2            AB010
      *                                                                   AB0102
     C                   END                                                    E*2            AB010
      *                                                                   AB0102
     C                   MOVE      *ZEROS        @TFKEY            6 0          *1             AB022
      *                                                                   AB0226
      **  Open and read the transaction file header.                      AB0266
     C*                                                                   AB0226
     C**  OPEN ANY FILES NOT ALREADY OPEN                                 AB0226
     C*****@SDOPN        IFEQ      ' '                                          B*2     AB022 CAP084
     C     @SDOPN        IFEQ      '0'                                                        CAP084
     C                   OPEN      SDTIX                                        **2            AB022
     C                   END                                                    E*2            AB022
     C     @TFKEY        CHAIN     SDTIX                              7676      *1             AB022
      *                                                                   AB0226
     C     *IN76         IFEQ      '1'                                          B*2            AB022
     C                   MOVE      '005'         DBASE                          ***************AB022
     C                   MOVEL     'SDTIX'       DBFILE                         *             *AB022
     C                   MOVEL     @TFKEY        DBKEY                          * DBERROR 005 *AB022
     C                   MOVE      '1'           *INU7                          *             *AB022
     C                   MOVE      '1'           *INU8                          ***************AB022
     C                   DUMP                                                                  AB022
     C                   GOTO      #B9                                                         AB022
     C                   END                                                    E*2            AB022
      *                                                                   AB0226
      **  Update the transaction file header.                             AB0226
     C                   ADD       2             NDLR                           *1             AB022
     C                   UPDATE    DTRIXHF                                      *1             AB022
      *                                                                   AB0226
     C                   END                                                    E1             AB022
      *                                                                   AB0226
     C*****                MOVE *ZEROS    @TFKEY  60                      AB0226
      *****                                                               BA0226
      *****pen and read the transaction file header.                      AB0226
     C*****                                                               AB0226
     C*****PEN ANY FILES NOT ALREADY OPEN                                 AB0226
     C*****      @SDOPN    IFEQ ' '                        B1             AB0226
     C*****                OPEN SDTIX                      *1             AB0226
     C*****                END                             E1             AB0226
     C*****      @TFKEY    CHAINSDTIX                7676                 AB0226
      *****                                                               AB0226
     C*****      *IN76     IFEQ '1'                        B1             AB0226
     C*****                MOVE '005'     DBASE            ***************AB0226
     C*****                MOVEL'SDTIX'   DBFILE           *             *AB0226
     C*****                MOVEL@TFKEY    DBKEY            * DBERROR 005 *AB0226
     C*****                MOVE '1'       *INU7            *             *AB0226
     C*****                MOVE '1'       *INU8            ***************AB0226
     C*****                DUMP                                           AB0226
     C*****                GOTO #B9                                       BA0226
     C*****                END                             E1             AB0226
      *****                                                               AB0226
      *****pdate the transaction file header.                             AB0226
     C*****                ADD  2         NDLR                            AB0226
     C*****                UPDATDTRIXHF                                   AB0226
      *****                                                               AB0226
      *****                                                               AB0065
      *****f deal has been authorised, initiate MIDAS confirmation        AB0065
      *****rocessing.                                                     AB0065
     C*****      JUDSTS    IFNE 'I'                        B1             AB0065
     C*****                CALL 'QCAEXEC'                  *1             AB0065
     C*****                PARM           @CMD             *1             AB0065
     C*****                PARM 80        @LEN   155       *1             AB0065
     C*****                END                             E1             AB0065
      *
     C     #B9           ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * #BA      - Update MIDAS On-line positions file.               *
      *                                                               *
      * CALLS    #BAA     - Process FX ins/dels                ( 01 ) *
      *          #BAB     - Process LOANS/DEPOSITS ins/dels    ( 03 ) *
      *          #BAC     - Process INTEREST ins/dels          ( 02 ) *
      *                                                               *
      * FLDS USED  @PCCY  - +ve currency on standard deal record.     *
      *            @NCCY  - -ve currency on standard deal record.     *
      *            @NRPOS - Near date +ve ccy amount.                 *
      *            @NRNEG - Near date -ve ccy amount.                 *
      *            @FRPOS - Far date +ve ccy amount.                  *
      *            @FRNEG - Far date -ve ccy amount.                  *
      *                                                               *
      *****************************************************************
     C     #BA           BEGSR
      *
     C                   MOVE      JUDBRC        @BRCA             3                           S0111
      *
      **  Determine the +ve and -ve ccys & amts for NEAR processing
     C     JUNDA1        IFGE      0                                            B1
     C                   MOVE      JUDFCY        @PCCY             3            *1
     C                   MOVE      JUDSCY        @NCCY             3            *1
     C                   Z-ADD     JUNDA1        @NRPOS           15 0          *1
     C                   Z-ADD     JUNDA2        @NRNEG           15 0          *1
     C                   Z-ADD     JUINA1        @LOAN            15 0          *1
     C                   Z-ADD     JUINA2        @DEP             15 0          *1
     C                   ELSE                                                   X1
     C                   MOVE      JUDSCY        @PCCY                          *1
     C                   MOVE      JUDFCY        @NCCY                          *1
     C                   Z-ADD     JUNDA1        @NRNEG                         *1
     C                   Z-ADD     JUNDA2        @NRPOS                         *1
     C                   Z-ADD     JUINA1        @DEP                           *1
     C                   Z-ADD     JUINA2        @LOAN                          *1
     C                   END                                                    E1
     C*
      *
      **  Determine the +ve and -ve amts for FAR processing
     C     JUFDA1        IFLT      0                                            B1
     C                   Z-ADD     JUFDA1        @FRNEG           15 0          *1
     C                   Z-ADD     JUFDA2        @FRPOS           15 0          *1
     C                   ELSE                                                   X1
     C                   Z-ADD     JUFDA2        @FRNEG                         *1
     C                   Z-ADD     JUFDA1        @FRPOS                         *1
     C                   END                                                    E1
      *                                                                                       CDL099
     C                   IF        CDL099 = 'Y'                                               CDL099
     C                   Z-ADD     0             ULNDAT            5 0                        CDL099
     C                   Z-ADD     0             ULFDAT            5 0                        CDL099
     C                   Z-ADD     JUNDAT        ULNDAT                                       CDL099
     C                   Z-ADD     JUFDAT        ULFDAT                                       CDL099
     C                   ENDIF                                                                CDL099
     C/COPY WNCPYSRC,AB0230C001
      *
      **  Process FX insertions & deletions.
     C                   EXSR      #BAA
      *
      **  Process LOAN/DEPOSIT insertions & deletions.
     C                   EXSR      #BAB
      *
      **  Process INTEREST insertions & deletions.
     C                   EXSR      #BAC
      *
     C     #BA9          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * #BAA     - Process FX insertions & deletions ( OLPOS - 01 )   *
      *                                                               *
      * CALLS    #ZC      - Accumulate currency balances for OLPOS    *
      *                                                               *
      * FLDS USED  @ADSUB - Add or subtract to accumulators           *
      *            @AMNT  - Amount to accumulate                      *
      *            @DATE  - Date to which to be accumulated           *
      *            @INOUT - Accumulate to income or outgoings         *
      *            @OLPOS - Current OLPOS record                      *
      *            @PCCY  - +ve currency on standard deal record.     *
      *            @NCCY  - -ve currency on standard deal record.     *
      *            @NRPOS - Near date +ve ccy amount.                 *
      *            @NRNEG - Near date -ve ccy amount.                 *
      *            @FRPOS - Far date +ve ccy amount.                  *
      *            @FRNEG - Far date -ve ccy amount.                  *
      *            @FDATE - Far date.                                 *
      *            @NDATE - Near date.                                *
      *            @MDNO  - Holds MIDAS day NO.
      *                                                               *
      *****************************************************************
     C     #BAA          BEGSR
     C                   MOVE      @PCCY         @CCY              3
      *
      ****Chain*MIDAS*online*position*file*(01)*using*NEAR*DATE*+ve*ccy*****                MD027531
     C**********         EXSR      #ZD                                                      MD027531
     C******INU7         CABEQ     '1'           #BAA9                                      MD027531
     C*
     C                   MOVE      @NRPOS        @AMNT            15 0
     C                   Z-ADD     JUNDAT        @MDNO             5 0
     C                   MOVE      'I'           @INOUT            1
      *                                                                                     MD027531
      ** Write record to GLOLPSTD                                                           MD027531
     C                   EVAL      pOLposKey = @BRCA + @CCY + %EDITC(@1:'X')                MD027531
     C                   EXSR      WrtOLPOS                                                 MD027531
      **********************************************************************                MD027531
      ****If*INS*amount*to*be*added*,if*DEL*amount*to*be*subtracted*********                MD027531
     C*****JULACT        IFEQ      'I'                                          B1          MD027531
     C**********         MOVE      '+'           @ADSUB            1            *1          MD027531
     C**********         ELSE                                                   X1          MD027531
     C**********         MOVE      '-'           @ADSUB            1            *1          MD027531
     C**********         END                                                    E1          MD027531
     C**********         EXSR      #ZC                                                      MD027531
     C*
     C                   MOVE      @FRNEG        @AMNT
     C                   MOVE      'O'           @INOUT
     C                   Z-ADD     JUFDAT        @MDNO
      *                                                                                     MD027531
      ** Write record to GLOLPSTD                                                           MD027531
     C                   EVAL      pOLposKey = @BRCA + @CCY + %EDITC(@1:'X')                MD027531
     C                   EXSR      WrtOLPOS                                                 MD027531
     C                   IF        CDL099 = 'Y'                                               CDL099
     C     ULFDAT        IFNE      0                                                          CDL099
     C                   Z-ADD     ULFDAT        @MDNO                                        CDL099
     C                   ENDIF                                                                CDL099
     C                   ENDIF                                                                CDL099
     C/COPY WNCPYSRC,AB0230C002
      **********************************************************************                MD027531
      ****If*INS*amount*to*be*subtracted*,if*DEL*amount*to*be*added*********                MD027531
     C*****JULACT        IFEQ      'I'                                          B1          MD027531
     C**********         MOVE      '-'           @ADSUB                         *1          MD027531
     C**********         ELSE                                                   X1          MD027531
     C**********         MOVE      '+'           @ADSUB                         *1          MD027531
     C**********         END                                                    E1          MD027531
     C**********         EXSR      #ZC                                                      MD027531
     C*
     C**********         UPDATE    OLPOSOAF                                                 MD027531
     C*
     C                   MOVE      @NCCY         @CCY
      **********************************************************************                MD027531
      ****Chain*MIDAS*online*position*file*(01)*using*NEAR*DATE*-ve*ccy*****                MD027531
     C**********         EXSR      #ZD                                                      MD027531
     C******INU7         CABEQ     '1'           #BAA9                                      MD027531
     C*
      **  @ADSUB & @INOUT use same values as set in previous update.
     C                   MOVE      @NRNEG        @AMNT
     C                   Z-ADD     JUNDAT        @MDNO
      *                                                                                     MD027531
      ** Write record to GLOLPSTD                                                           MD027531
     C                   EVAL      pOLposKey = @BRCA + @CCY + %EDITC(@1:'X')                MD027531
     C                   EXSR      WrtOLPOS                                                 MD027531
     C                   IF        CDL099 = 'Y'                                               CDL099
     C     ULNDAT        IFNE      0                                                          CDL099
     C                   Z-ADD     ULNDAT        @MDNO                                        CDL099
     C                   ENDIF                                                                CDL099
     C                   ENDIF                                                                CDL099
     C/COPY WNCPYSRC,AB0230C003
     C**********         EXSR      #ZC                                                      MD027531
     C*
     C                   MOVE      @FRPOS        @AMNT
     C                   Z-ADD     JUFDAT        @MDNO
     C                   MOVE      'I'           @INOUT
      *                                                                                     MD027531
      ** Write record to GLOLPSTD                                                           MD027531
     C                   EVAL      pOLposKey = @BRCA + @CCY + %EDITC(@1:'X')                MD027531
     C                   EXSR      WrtOLPOS                                                 MD027531
      **********************************************************************                MD027531
      ****If*INS*amount*to*be*added*,if*DEL*amount*to*be*subtracted*********                MD027531
     C*****JULACT        IFEQ      'I'                                          B1          MD027531
     C**********         MOVE      '+'           @ADSUB                         *1          MD027531
     C**********         ELSE                                                   X1          MD027531
     C**********         MOVE      '-'           @ADSUB                         *1          MD027531
     C**********         END                                                    E1          MD027531
     C**********         EXSR      #ZC                                                      MD027531
     C*
     C**********         UPDATE    OLPOSOAF                                                 MD027531
     C*
     C     #BAA9         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * #BAB     - Process LOANS/DEPOSITS ins & dels ( OLPOS - 03 )   *
      *                                                               *
      * CALLS    #ZC      - Accumulate currency balances for OLPOS    *
      *          #ZB      - Access OLPOS record via currency,'03'     *
      *                                                               *
      * FLDS USED  @ADSUB - Add or subtract to accumulators           *
      *            @AMNT  - Amount to accumulate                      *
      *            @DATE  - Date to which to be accumulated           *
      *            @INOUT - Accumulate to income or outgoings         *
      *            @OLPOS - Current OLPOS record                      *
      *            @PCCY  - +ve currency on standard deal record.     *
      *            @NCCY  - -ve currency on standard deal record.     *
      *            @NRPOS - Near date +ve ccy amount.                 *
      *            @NRNEG - Near date -ve ccy amount.                 *
      *            @FDATE - Far date.                                 *
      *            @NDATE - Near date.                                *
      *            @MDNO  - Holds MIDAS day NO.
      *                                                               *
      *****************************************************************
     C     #BAB          BEGSR
     C                   MOVE      @PCCY         @CCY
      **********************************************************************                MD027531
      ****Chain*MIDAS*online*position*file*(03)*using*NEAR*DATE*+ve*ccy*****                MD027531
     C**********         EXSR      #ZB                                                      MD027531
     C******INU7         CABEQ     '1'           #BAB9                                      MD027531
     C*
     C                   MOVE      @NRPOS        @AMNT
     C                   Z-ADD     JUNDAT        @MDNO
     C                   MOVE      'O'           @INOUT
      *                                                                                     MD027531
      ** Write record to GLOLPSTD                                                           MD027531
     C                   EVAL      pOLposKey = @BRCA + @CCY + %EDITC(@3:'X')                MD027531
     C                   EXSR      WrtOLPOS                                                 MD027531
      **********************************************************************                MD027531
      ****If*INS*amount*to*be*added*,if*DEL*amount*to*be*subtracted*********                MD027531
     C*****JULACT        IFEQ      'I'                                          B1          MD027531
     C**********         MOVE      '+'           @ADSUB                         *1          MD027531
     C**********         ELSE                                                   X1          MD027531
     C**********         MOVE      '-'           @ADSUB                         *1          MD027531
     C**********         END                                                    E1          MD027531
     C**********         EXSR      #ZC                                                      MD027531
     C*
     C                   MOVE      @NRPOS        @AMNT
     C                   MOVE      'I'           @INOUT
     C                   Z-ADD     JUFDAT        @MDNO
      *                                                                                     MD027531
      ** Write record to GLOLPSTD                                                           MD027531
     C                   EVAL      pOLposKey = @BRCA + @CCY + %EDITC(@3:'X')                MD027531
     C                   EXSR      WrtOLPOS                                                 MD027531
     C                   IF        CDL099 = 'Y'                                               CDL099
     C     ULFDAT        IFNE      0                                                          CDL099
     C                   Z-ADD     ULFDAT        @MDNO                                        CDL099
     C                   ENDIF                                                                CDL099
     C                   ENDIF                                                                CDL099
     C/COPY WNCPYSRC,AB0230C004
      ****@ADSUB*use*same*value*as*set*in*previous*update.*************                     MD027531
     C**********         EXSR      #ZC                                                      MD027531
     C*
     C**********         UPDATE    OLPOSOAF                                                 MD027531
     C*
     C                   MOVE      @NCCY         @CCY
      *****************************************************************                     MD027531
      ****Chain*MIDAS*online*position*file*(03)*using*NEAR*DATE*-ve*ccy                     MD027531
     C**********         EXSR      #ZB                                                      MD027531
     C******INU7         CABEQ     '1'           #BAB9                                      MD027531
     C*
     C                   MOVE      @NRNEG        @AMNT
     C                   MOVE      'I'           @INOUT
     C                   Z-ADD     JUNDAT        @MDNO
      *                                                                                     MD027531
      ** Write record to GLOLPSTD                                                           MD027531
     C                   EVAL      pOLposKey = @BRCA + @CCY + %EDITC(@3:'X')                MD027531
     C                   EXSR      WrtOLPOS                                                 MD027531
     C                   IF        CDL099 = 'Y'                                               CDL099
     C     ULNDAT        IFNE      0                                                          CDL099
     C                   Z-ADD     ULNDAT        @MDNO                                        CDL099
     C                   ENDIF                                                                CDL099
     C                   ENDIF                                                                CDL099
     C/COPY WNCPYSRC,AB0230C005
      *****************************************************************                     MD027531
      ****If*INS*amount*to*be*subtracted*,if*DEL*amount*to*be*added****                     MD027531
     C*****JULACT        IFEQ      'I'                                          B1          MD027531
     C**********         MOVE      '-'           @ADSUB                         *1          MD027531
     C**********         ELSE                                                   X1          MD027531
     C**********         MOVE      '+'           @ADSUB                         *1          MD027531
     C**********         END                                                    E1          MD027531
     C**********         EXSR      #ZC                                                      MD027531
     C*
     C                   MOVE      @NRNEG        @AMNT
     C                   MOVE      'O'           @INOUT
     C                   Z-ADD     JUFDAT        @MDNO
      *                                                                                     MD027531
      ** Write record to GLOLPSTD                                                           MD027531
     C                   EVAL      pOLposKey = @BRCA + @CCY + %EDITC(@3:'X')                MD027531
     C                   EXSR      WrtOLPOS                                                 MD027531
      ****@ADSUB*use*same*value*as*set*in*previous*update.*************                     MD027531
     C**********         EXSR      #ZC                                                      MD027531
     C*
     C**********         UPDATE    OLPOSOAF                                                 MD027531
     C*
     C     #BAB9         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * #BAC     - Process INTEREST ins & dels       ( OLPOS - 02 )   *
      *                                                               *
      * CALLS    #ZC      - Accumulate currency balances for OLPOS    *
      *          #ZA      - Access OLPOS record via currency,'02'     *
      *                                                               *
      * FLDS USED  @ADSUB - Add or subtract to accumulators           *
      *            @AMNT  - Amount to accumulate                      *
      *            @DATE  - Date to which to be accumulated           *
      *            @INOUT - Accumulate to income or outgoings         *
      *            @OLPOS - Current OLPOS record                      *
      *            @PCCY  - +ve currency on standard deal record.     *
      *            @NCCY  - -ve currency on standard deal record.     *
      *            @DEP   - Deposit interest amount.                  *
      *            @LOAN  - Loan Interest amount.                     *
      *            @FDATE - Far date.                                 *
      *            @MDNO  - Holds MIDAS day NO.
      *                                                               *
      *****************************************************************
     C     #BAC          BEGSR
     C                   MOVE      @PCCY         @CCY
      ******************************************************************                    MD027531
      ****Chain*MIDAS*online*position*file*(02)*using*NEAR*DATE*+ve*ccy*                    MD027531
     C**********         EXSR      #ZA                                                      MD027531
     C******INU7         CABEQ     '1'           #BAC9                                      MD027531
     C*
     C                   MOVE      @LOAN         @AMNT
     C                   MOVE      'I'           @INOUT
     C                   Z-ADD     JUFDAT        @MDNO
      *                                                                                     MD027531
      ** Write record to GLOLPSTD                                                           MD027531
     C                   EVAL      pOLposKey = @BRCA + @CCY + %EDITC(@2:'X')                MD027531
     C                   EXSR      WrtOLPOS                                                 MD027531
     C                   IF        CDL099 = 'Y'                                               CDL099
     C     ULFDAT        IFNE      0                                                          CDL099
     C                   Z-ADD     ULFDAT        @MDNO                                        CDL099
     C                   ENDIF                                                                CDL099
     C                   ENDIF                                                                CDL099
     C/COPY WNCPYSRC,AB0230C006
      *****************************************************************                     MD027531
      ****If*INS*amount*to*be*added*,if*DEL*amount*to*be*subtracted****                     MD027531
     C*****JULACT        IFEQ      'I'                                          B1          MD027531
     C**********         MOVE      '+'           @ADSUB                         *1          MD027531
     C**********         ELSE                                                   X1          MD027531
     C**********         MOVE      '-'           @ADSUB                         *1          MD027531
     C**********         END                                                    E1          MD027531
     C**********         EXSR      #ZC                                                      MD027531
     C*
     C*
     C**********         UPDATE    OLPOSOAF                                                 MD027531
     C*
     C                   MOVE      @NCCY         @CCY
      *****************************************************************                     MD027531
      ****Chain*MIDAS*online*position*file*(02)*using*NEAR*DATE*-ve*ccy                     MD027531
     C**********         EXSR      #ZA                                                      MD027531
     C******INU7         CABEQ     '1'           #BAC9                                      MD027531
     C*
     C                   MOVE      @DEP          @AMNT
     C                   MOVE      'O'           @INOUT
     C                   Z-ADD     JUFDAT        @MDNO
      *                                                                                     MD027531
      ** Write record to GLOLPSTD                                                           MD027531
     C                   EVAL      pOLposKey = @BRCA + @CCY + %EDITC(@2:'X')                MD027531
     C                   EXSR      WrtOLPOS                                                 MD027531
      ****@ADSUB*use*same*value*as*set*in*previous*update.*************                     MD027531
     C**********         EXSR      #ZC                                                      MD027531
     C*
     C**********         UPDATE    OLPOSOAF                                                 MD027531
     C*
     C     #BAC9         ENDSR
      /EJECT
      *****************************************************************   AB0102
      *                                                               *   AB0102
      *  SUBROUTINE: #BB    -     WRITE A TRAILER RECORD TO THE       *   AB0102
      *                           PF/DEALSDF, RECORD FORMAT DEALSDFF  *   AB0102
      *                           FOR AN INSERT                           AB0102
      *                                                                   AB0102
      *                                                               *   AB0102
      *  FIELDS USED:                                                 *   AB0102
      *                      NORE   -  NO OF RECORDS                  *   AB0102
      *                      NINS   -  NO OF INSERTIONS               *   AB0102
      *                      NLRA   -  NO OF LIVE RECS AFTER CYCLE    *   AB0102
      *                      WSAMNP -  }                              *   AB0102
      *                      @HINT  -  } WORK FIELDS TO SEPARATE      *   AB0102
      *                      @HDEC  -  } INTEGER AND DECIMAL          *   AB0102
      *                      VRIF   -  VAL REC INSERTED - INT        *    AB0102
      *                      VRIL   -  VAL REC INSERTED - DEC         *   AB0102
      *                      VLAF   -  VAL REC AFTER CYCLE -INT      *    AB0102
      *                      VLAL   -  VAL REC AFTER CYCLE -DEC       *   AB0102
      *                      LCD    -  LAST CHANGE DATE              *    AB0102
      *                      CHTP   -  LAST CHANGE TYPE               *   AB0102
      *                                                               *   AB0102
      *                                                               *   AB0102
      *  CALLED BY :  #B                                                  AB0102
      *  CALLS     :  #ZE                                                 AB0102
      *               #ZF                                             *   AB0102
      *                                                               *   AB0102
      *****************************************************************   AB0102
      *                                                                   AB0102
     C     #BB           BEGSR                                                                 AB010
      *                                                                   AB0102
      ** ACCESS TRAILER RECORD                                            AB0102
      *                                                                   AB0102
     C     999999        CHAIN     DEALSDFF                           76                       AB010
      *                                                                   AB0102
     C     *IN76         IFEQ      '1'                                          B1             AB010
     C                   MOVE      '006'         DBASE                          *1             AB010
     C                   MOVE      'DEALSDF'     DBFILE                         *1             AB010
     C                   MOVE      '1'           *INU7                          *1             AB010
     C                   MOVE      '1'           *INU8                          *1             AB010
     C                   DUMP                                                                  AB020
     C                   GOTO      #BB9                                         *1             AB010
     C                   END                                                    E1             AB010
      *                                                                   AB0102
      ** INCREMENT NUMBER OF RECORDS BY 2                                 AB0102
      *                                                                   AB0102
     C                   ADD       2             NORE                                          AB010
      *                                                                   AB0102
      ** INCREMENT NUMBER OF INSERTIONS BY 2                              AB0102
      *                                                                   AB0102
     C                   ADD       2             NINS                                          AB010
      *                                                                   AB0102
      ** INCREMENT NO OF LIVE RECORDS AFTER INPUT CYCLE BY 2              AB0102
      *                                                                   AB0102
     C                   ADD       2             NLRA                                          AB010
      *                                                                   AB0102
      ** INCREMENT VALUE OF RECORD INSERTED (INTEGER AND DECIMAL) BY      AB0102
      ** THE SUM OF PURCHASE AMOUNTS FROM THE FIRST AND SECOND LEGS       AB0102
      ** STORED IN @SUM, SEPARATE DECIMAL POINTS AND CALL SUBROUTINE      AB0102
      ** #ZA                                                              AB0102
      ** SIMULTANEOUSLY INCREMENT VALUE OF RECORDS AFTER INPUT CYCLE      AB0102
      ** (INTEGER AND DECIMAL) WITH THE SAME PURCHASE AMOUNTS             AB0102
      *                                                                   AB0102
     C                   MOVE      @SUM          @SPLIT                                        AB010
     C     @DEC          IFLT      0                                            B1             AB010
     C                   Z-SUB     @INT          @INT                           *1             AB010
     C                   END                                                    E1             AB010
      *                                                                   AB0102
     C                   Z-ADD     VRIF          @HINT                                         AB010
     C                   Z-ADD     VRIL          @HDEC                                         AB010
     C                   EXSR      #ZE                                                         AB010
     C                   Z-ADD     @HINT         VRIF                                          AB010
     C                   Z-ADD     @HDEC         VRIL                                          AB010
      *                                                                   AB0102
     C                   Z-ADD     VLAF          @HINT                                         AB010
     C                   Z-ADD     VLAL          @HDEC                                         AB010
     C                   EXSR      #ZE                                                         AB010
     C                   Z-ADD     @HINT         VLAF                                          AB010
     C                   Z-ADD     @HDEC         VLAL                                          AB010
      *                                                                   AB0102
      ** SET LAST CHANGE DATE TO MIDAS RUN DATE FROM TABTB10              AB0102
      *                                                                   AB0102
     C                   Z-ADD     RUND          LCD                                           AB010
      *                                                                   AB0102
      ** LAST CHANGE TYPE                                                 AB0102
      *                                                                   AB0102
     C                   MOVE      'I'           CHTP                                          AB010
      *                                                                   AB0102
      ** REWRITE RECORD                                                   AB0102
      *                                                                   AB0102
     C                   UPDATE    DEALSDFF                             76                     AB010
      *                                                                   AB0102
     C     *IN76         IFEQ      '1'                                          B1             AB010
     C                   MOVE      '011'         DBASE                          *1             AB010
     C                   MOVE      'DEALSDF'     DBFILE                         *|             AB010
     C                   MOVE      '1'           *INU7                          *1             AB010
     C                   MOVE      '1'           *INU8                          *1             AB010
     C                   DUMP                                                                  AB020
     C                   END                                                    E1             AB010
      *                                                                   AB0102
      *                                                                   AB0102
     C     #BB9          ENDSR                                                  **#BB9**       AB010
      *****************************************************************
      /EJECT                                                              AB0102
      *****************************************************************   AB0102
      *                                                               *   AB0102
      *  SUBROUTINE: #BC    -     WRITE A TRAILER RECORD TO THE       *   AB0102
      *                           PF/DEALSDF, RECORD FORMAT DEALSDFF  *   AB0102
      *                           FOR A REVERSAL                          AB0102
      *                                                                   AB0102
      *                                                               *   AB0102
      *  FIELDS USED:                                                 *   AB0102
      *                      #ZB  - DATABASE NAME                   *     AB0102
      *                      NDEL   - NO OF DELETED RECORDS           *   AB0102
      *                      NLRA   - NO OF RECS AFTER CYCLE          *   AB0102
      *                      RUND   - MIDAS RUN DATE                  *   AB0102
      *                      JUNDAT - NEAR DATE                       *   AB0102
      *                      @AMT   - PURCHASE AMOUNTS                *   AB0102
      *                      WSAMNP - }                               *   AB0102
      *                      @HINT  - } WORK FIELDS TO SEPARATE       *   AB0102
      *                      @HDEC  - } DECIMAL / INTEGERS            *   AB0102
      *                      VRDF   - VAL REC DELETED INT             *   AB0102
      *                      VRDL   - VAL REC DELETED DEC             *   AB0102
      *                      VLAF   - VAL REC AFTER CYCLE INT         *   AB0102
      *                      VLAL   - VAL REC AFTER CYCLE DEC         *   AB0102
      *                      LCD    - LAST CHANGE DATE                *   AB0102
      *                      CHTP   - LAST CHANGE TYPE                *   AB0102
      *                                                               *   AB0102
      *                                                               *   AB0102
      *  CALLED BY :  #B                                                  AB0102
      *  CALLS     :  #ZE #ZF                                             AB0102
      *                                                               *   AB0102
      *                                                               *   AB0102
      *****************************************************************   AB0102
      *                                                                   AB0102
     C     #BC           BEGSR                                                                 AB010
      *                                                                   AB0102
      ** ACCESS TRAILER RECORD                                            AB0102
      *                                                                   AB0102
     C     999999        CHAIN     DEALSDFF                           76                       AB010
      *                                                                   AB0102
     C     *IN76         IFEQ      '1'                                          B1             AB010
     C                   MOVE      '007'         DBASE                          *1             AB010
     C                   MOVE      'DEALSDF'     DBFILE                         *1             AB010
     C                   MOVE      '1'           *INU7                          *1             AB010
     C                   MOVE      '1'           *INU8                          *1             AB010
     C                   DUMP                                                                  AB020
     C                   GOTO      #BC9                                         *1             AB010
     C                   END                                                    E1             AB010
      *                                                                   E19012
      ** INCREMENT NO OF DELETIONS BY 2                                   E19012
     C                   ADD       2             NDEL                                          E1901
      *                                                                   E19012
      ** DECREMENT NO OF LIVE RECORDS BY 2                                E19012
     C                   SUB       2             NLRA                                          E1901
      *                                                                   E19012
      ***INCREMENT*NO*OF*DELETIONS*BY*2*IF*NEAR*DATE*IS*>=*MIDAS*RUNAB0102E19012
      ***DATE*OTHERWISE*INCREMENT*NO*OF*DELETIONS*BY*1**************AB0102E19012
      ***********                                                   AB0102E19012
     C***********RUND******IFLT*JUNDAT************************************E17607
     C********** JUNDAT    IFGE RUND                       B1       E17607E19012
     C**********           ADD  2         NDEL             *1       AB0102E19012
     C**********           ELSE                            X1       AB0102E19012
     C**********           ADD  1         NDEL             *1       AB0102E19012
     C**********           END                             E1       AB0102E19012
      ***********                                                   AB0102E19012
      ***DECREMENT*NO*OF*LIVE*RECORDS*BY*2*IF*NEAR*DATE*IS*>=*MIDAS*RUN   E19012
      ***DATE*OTHERWISE*DECREMENT*NO*OF*LIVE*RECORDS*BY*1**************   E19012
      ***********                                                   AB0102E19012
     C***********RUND******IFLT*JUNDAT************************************E17607
     C********** JUNDAT    IFGE RUND                       B1       E17607E19012
     C**********           SUB  2         NLRA             *1       AB0102E19012
     C**********           ELSE                            X1       AB0102E19012
     C**********           SUB  1         NLRA             *1       AB0102E19012
     C**********           END                             E1       AB0102E19012
      ***********                                                   AB0102E19012
      ***IF*NEAR*DATE*IS*>=*MIDAS*RUN*******************************AB0102E19012
      *                                                             AB0102E19012
      **  INCREMENT VALUE OF RECORD DELETED (INTEGER AND DECIMAL) BY      AB0102
      **  THE SUM OF PURCHASE AMOUNTS FROM THE FIRST AND SECOND LEGS      AB0102
      **  STORED IN @SUM,SEPARATE DECIMAL POINTS AND CALL SUBROUTINE      AB0102
      **  #ZA                                                             AB0102
      *                                                             AB0102E19012
      ***ELSE*INCREMENT*VALUE*OF*RECORD*DELETED*(INTEGER*AND*DECIMALAB0102E19012
      ****BY*THE*PURCHASE*AMOUNT*OF*THE*SECOND*LEG*ONLY*************AB0102E19012
      ***********                                                   AB0102E19012
     C***********RUND******IFLT*JUNDAT************************************E17607
     C********** JUNDAT    IFGE RUND                                E17067E19012
      *                                                                   AB0102
     C                   MOVE      @SUM          @SPLIT                                        AB010
     C     @DEC          IFLT      0                                            B1             AB010
     C                   Z-SUB     @INT          @INT                           *1             AB010
     C                   END                                                    E1             AB010
      *                                                                   AB0102
     C                   Z-ADD     VRDF          @HINT                                         AB010
     C                   Z-ADD     VRDL          @HDEC                                         AB010
     C                   EXSR      #ZE                                                         AB010
     C                   Z-ADD     @HINT         VRDF                                          AB010
     C                   Z-ADD     @HDEC         VRDL                                          AB010
      *                                                                   AB0102
     C**********           ELSE                            X1       AB0102E19012
      **********                                                    AB0102E19012
      **********                                                    AB0102E19012
     C**********           MOVE @AMT      @SPLIT                    AB0102E19012
     C********** @DEC      IFLT 0                          B*2      AB0102E19012
     C**********           Z-SUB@INT      @INT             **2      AB0102E19012
     C**********           END                             E*2      AB0102E19012
      ***********                                                   AB0102E19012
     C**********           Z-ADDVRDF      @HINT            *1       AB0102E19012
     C**********           Z-ADDVRDL      @HDEC            *1       AB0102E19012
     C**********           EXSR #ZE                        *1       AB0102E19012
     C**********           Z-ADD@HINT     VRDF             *1       AB0102E19012
     C**********           Z-ADD@HDEC     VRDL             *1       AB0102E19012
      **********                                                    AB0102E19012
     C**********           END                                      AB0102E19012
      ***********                                                   AB0102E19012
      ***IF*NEAR*DATE*IS*>=*MIDAS*RUN*******************************AB0102E19012
      *                                                             AB0102E19012
      **  DECREMENT VALUE OF RECORD AFTER I/C (INTEGER AND DECIMAL) BY    AB0102
      **  THE SUM OF PURCHASE AMOUNTS FROM THE FIRST AND SECOND LEGS      AB0102
      **  STORED IN @SUM,SEPARATE DECIMAL POINTS AND CALL SUBROUTINE      AB0102
      **  #ZA                                                             AB0102
      *                                                                   E19012
      ***ELSE*DECREMENT*VALUE*OF*RECORD*AFTER*I/C*(INTEGER*AND*DECIMAL)   E19012
      ****BY*THE*PURCHASE*AMOUNT*OF*THE*SECOND*LEG*ONLY*************AB0102E19012
      ***********                                                         E19012
     C***********RUND******IFLT*JUNDAT************************************E17607
     C********** JUNDAT    IFGE RUND                                E17607E19012
      *                                                                   AB0102
     C                   MOVE      @SUM          @SPLIT                                        AB010
     C     @DEC          IFLT      0                                            B1             AB010
     C                   Z-SUB     @INT          @INT                           *1             AB010
     C                   END                                                    E1             AB010
      *                                                                   AB0102
     C                   Z-ADD     VLAF          @HINT                                         AB010
     C                   Z-ADD     VLAL          @HDEC                                         AB010
     C                   EXSR      #ZF                                                         AB010
     C*****                SUB  @HINT     VLAF                            AB0110
     C*****                SUB  @HDEC     VLAL                            AB0110
     C                   Z-ADD     @HINT         VLAF                                          AB011
     C                   Z-ADD     @HDEC         VLAL                                          AB011
      *                                                                   AB0102
     C**********           ELSE                            X1       AB0102E19012
      **********                                                    AB0102E19012
      **********                                                    AB0102E19012
     C**********           MOVE @AMT      @SPLIT                    AB0102E19012
     C********** @DEC      IFLT 0                          B*2      AB0102E19012
     C**********           Z-SUB@INT      @INT             **2      AB0102E19012
     C**********           END                             E*2      AB0102E19012
      **********                                                    AB0102E19012
     C**********           Z-ADDVLAF      @HINT            *1       AB0102E19012
     C**********           Z-ADDVLAL      @HDEC            *1       AB0102E19012
     C**********           EXSR #ZF                        *1       AB0102E19012
     C*****                SUB  @HINT     VLAF             *1             AB0110
     C*****                SUB  @HDEC     VLAL             *1             AB0110
     C**********           Z-ADD@HINT     VLAF             *1       AB0102E19012
     C**********           Z-ADD@HDEC     VLAL             *1       AB0102E19012
      **********                                                    AB0102E19012
     C**********           END                             E1       AB0102E19012
      *                                                                   AB0102
      ** SET LAST CHANGE DATE TO MIDAS RUN DATE FROM TABTB10              AB0102
      *                                                                   AB0102
     C                   Z-ADD     RUND          LCD                                           AB010
      *                                                                   AB0102
      ** LAST CHANGE TYPE                                                 AB0102
      *                                                                   AB0102
     C                   MOVE      'R'           CHTP                                          AB010
      *                                                                   AB0102
      ** REWRITE RECORD                                                   AB0102
      *                                                                   AB0102
     C                   UPDATE    DEALSDFF                             76                     AB010
      *                                                                   AB0102
     C     *IN76         IFEQ      '1'                                          B1             AB010
     C                   MOVE      '012'         DBASE                          *1             AB010
     C                   MOVE      'DEALSDF'     DBFILE                         *1             AB010
     C                   MOVE      '1'           *INU7                          *1             AB010
     C                   MOVE      '1'           *INU8                          *1             AB010
     C                   DUMP                                                                  AB020
     C                   END                                                    E1             AB010
      *                                                                   AB0102
      *                                                                   AB0102
     C     #BC9          ENDSR                                                  **#BC9**       AB010
      *****************************************************************   AB0102
      /EJECT                                                              AB0102
      *****************************************************************   AB0102
      *                                                               *   AB0102
      *        SR.#ZE - ADD AMOUNT TO HASH TRAILER                    *   AB0102
      *                                                               *   AB0102
      *        @HINT - CURRENT HASH INTEGER (15,0)                    *   AB0102
      *        @HDEC - CURRENT HASH DECIMAL (3,0)                     *   AB0102
      *        @INT  - INTEGER AMOUNT                                 *   AB0102
      *        @DEC  - DECIMAL AMOUNT                                 *   AB0102
      *                                                               *   AB0102
      *  CALLED BY :  #BB #BC                                         *   AB0102
      *                                                                   AB0102
      *****************************************************************   AB0102
      *                                                                   AB0102
     C     #ZE           BEGSR                                                                 AB010
      *                                                                   AB0102
     C                   ADD       @INT          @HINT            15 0                         AB010
      *                                                                   AB0102
     C                   Z-ADD     @HDEC         @WK4N             4 0                         AB010
     C                   ADD       @DEC          @WK4N                                         AB010
      *                                                                   AB0102
     C     @WK4N         IFGT      999                                                         AB010
     C                   ADD       1             @HINT                                         AB010
     C                   END                                                                   AB010
      *                                                                   AB0102
     C                   Z-ADD     @WK4N         @HDEC             3 0                         AB010
      *                                                                   AB0102
     C                   ENDSR                                                                 AB010
      *****************************************************************   AB0102
      /EJECT                                                              AB0102
      *****************************************************************   AB0102
      *                                                               *   AB0102
      *        SR.#ZF - SUB AMOUNT FROM HASH TRAILER                 *    AB0102
      *                                                               *   AB0102
      *        @HINT - CURRENT HASH INTEGER (15,0)                    *   AB0102
      *        @HDEC - CURRENT HASH DECIMAL (3,0)                     *   AB0102
      *        @INT  - INTEGER AMOUNT                                 *   AB0102
      *        @DEC  - DECIMAL AMOUNT                                 *   AB0102
      *                                                               *   AB0102
      *                                                               *   AB0102
      *  CALLED BY :  #BC                                             *   AB0102
      *                                                                   AB0102
      *****************************************************************   AB0102
      *                                                                   AB0102
     C     #ZF           BEGSR                                                                 AB010
      *                                                                   AB0102
     C                   SUB       @INT          @HINT                                         AB010
      *                                                                   AB0102
     C                   Z-ADD     @HDEC         @WK3N             3 0                         AB010
     C******************** ADD  @DEC      @WK3N                     AB0102E19012
     C                   SUB       @DEC          @WK3N                                         E1901
      *                                                                   AB0102
     C     @WK3N         IFLT      0                                                           AB010
     C                   SUB       1             @HINT                                         AB010
     C     @WK3N         ADD       1000          @WK4N                                         AB010
     C                   Z-ADD     @WK4N         @HDEC                                         AB010
     C                   ELSE                                                                  AB010
     C******************** Z-ADD@WK4N     @HDEC                     AB0102E19012
     C                   Z-ADD     @WK3N         @HDEC                                         E1901
     C                   END                                                                   AB010
      *                                                                   AB0102
      *                                                                   AB0102
     C                   ENDSR                                                                 AB010
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * #A       - Initial processing                                 *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  MAIN   - Control processing                        *
      *                                                               *
      * FLDS USED  @TERM  - Termination parameter                     *
      *            @DSSTD - Standard deal parameter                   *
      *            @1     - '01'                                      *
      *            @2     - '02'                                      *
      *            @3     - '03'                                      *
      *                                                               *
      *****************************************************************
     C     #A            BEGSR
      *
      ****Receive*input*parameter.****************************************S01319
      **  Receive input parameters.                                       S01319
     C     *ENTRY        PLIST
     C                   PARM                    @TERM             1
     C                   PARM                    DSSTD                                         S0131
      *                                                                   AB0102
      **  This WRITE will never be executed.  It is included so that      AB0102
      **  AB0230 can compile with the DEALS file allowing ADD, as         AB0102
      **  although this is not required here AB0240 which it calls        AB0102
      **  does require it and the file has to be opened allowing ADD.     AB0102
     C     1             IFEQ      2                                                           AB010
     C                   WRITE     DEALSDBF                                                    AB010
     C                   END                                                                   AB010
      *
      **  If termination parameter is 'T', no further processing.
     C     @TERM         CABEQ     'T'           #A9
      *
      **  Set up program name in *LDA in case of database error.
     C                   MOVEL     'AB0230'      DBPGM
      *
      **  Open files.
     C                   OPEN      OLPOS
     C*********************OPEN*ABSTDDLL**********************************S01319
      *                                                                   AB0102
     C**********           OPEN DEALS                  76          AB0102 E19709
     C                   OPEN      ABDELULL                             76                     E1970
     C     *IN76         IFEQ      '1'                                          B1             AB010
     C                   MOVE      '008'         DBASE                          *1             AB010
     C**********           MOVE 'DEALS'   DBFILE           *1      AB0102 E19709
     C                   MOVE      'ABDELULL'    DBFILE                         *1             E1970
     C                   MOVE      '1'           *INU7                          *1             AB010
     C                   MOVE      '1'           *INU8                          *1             AB010
     C                   DUMP                                                                  AB020
     C                   GOTO      #A9                                          *1             AB010
     C                   END                                                    E1             AB010
      *                                                                   S01194
     C*********************OPEN FDICDRLL               76                 S01194
     C********** *IN76*****IFEQ '1'                        B1             S01194
     C*********************MOVE '009'     DBASE            *1             S01194
     C*********************MOVE 'FDICDRLL'DBFILE           *1             S01194
     C*********************MOVE '1'       *INU7            *1             S01194
     C*********************MOVE '1'       *INU8            *1             S01194
     C*********************DUMP                                           S01194
     C*********************GOTO #A9                        *1             S01194
     C*********************END                             E1             S01194
      *********************                                               S01194
      ****Read*the*TABTB10*record                                         S01194
      *********************                                               S01194
     C*********************MOVEL'01'      @KEY2  12                       S01194
     C*********************MOVE '10'      @KEY2                           S01194
     C***********@KEY2*****CHAINFDICDRLL             76                   S01194
      *********************                                               S01194
     C********** *IN76*****IFEQ '1'                        B1             S01194
     C                   CALL      'AOBANKR0'                                                  S0119
     C                   PARM      *BLANKS       @RTCD             7                           S0119
     C                   PARM      '*FIRST '     @OPTN             7                           S0119
     C     SDBANK        PARM      SDBANK        DSFDY                                         S0119
     C     @RTCD         IFNE      *BLANKS                                                     S0119
     C                   MOVEL     @OPTN         DBOPTN            7                           S0119
     C*********************MOVE @KEY2     DBKEY            *1             S01194
     C*********************MOVE 'FDICDRLL'DBFILE           *1             S01194
     C                   MOVEL     'SDBANKPD'    DBFILE                                        S0119
     C                   MOVE      '010'         DBASE                          *1             AB010
     C                   MOVE      '1'           *INU7                          *1             AB010
     C                   MOVE      '1'           *INU8                          *1             AB010
     C                   DUMP                                                                  AB020
     C                   GOTO      #A9                                          *1             AB010
     C                   END                                                    E1             AB010
      *                                                                   AB0102
      ** Call AOSARDR0 to check if CDL099 is switched on                                      CDL099
      *                                                                                       CDL099
     C                   EVAL      CDL099 = 'N'                                               CDL099
     C                   CALLB     'AOSARDR0'                                                 CDL099
     C                   PARM      *BLANKS       PRTCD             7                          CDL099
     C                   PARM      '*VERIFY'     POPTN             7                          CDL099
     C                   PARM      'CDL099'      PSARD             6                          CDL099
     C                   PARM                    DSFDY                                        CDL099
      *                                                                                       CDL099
     C                   IF        PRTCD = *BLANKS                                            CDL099
     C                   MOVE      'Y'           CDL099            1                          CDL099
     C                   ENDIF                                                                CDL099
     C                   IF        PRTCD <> *BLANKS AND                                       CDL099
     C                             PRTCD <> '*NRF   '                                         CDL099
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL099
     C                   EVAL      DBASE = '011'                                              CDL099
     C                   EVAL      DBKEY = 'CDL099'                                           CDL099
     C                   EXSR      *PSSR                                                      CDL099
     C                   ENDIF                                                                CDL099
      *                                                                                       CDL099
     C                   Z-ADD     1             @1                2 0
     C                   Z-ADD     2             @2                2 0
     C                   Z-ADD     3             @3                2 0
      *
     C                   MOVE      'Y'           @FCYC             1
     C     #A9           ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * #C       - Final processing                                   *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  MAIN   - Control processing                        *
      *                                                               *
      * FLDS USED  @TERM  - Termination parameter                     *
      *                                                               *
      *****************************************************************
     C     #C            BEGSR
      *
      **  If termination parameter set to 'T', terminate program.
     C     @TERM         IFEQ      'T'                                          B1
     C                   MOVE      '1'           *INLR                          *1
     C                   GOTO      #C9                                          *1
     C                   END                                                    E1
      *
      **  If database error, terminate program.
     C     *INU7         IFEQ      '1'                                          B1
     C                   MOVE      'E'           @TERM                          *1
     C                   MOVE      '1'           *INLR                          *1
     C                   DUMP                                                                  AB020
     C                   GOTO      #C9                                          *1
     C                   END                                                    E1
      *
      **  Return to calling program.
     C                   RETURN
      *
     C     #C9           ENDSR
      *****************************************************************
      /EJECT                                                                                MD027531
      *****************************************************************                     MD027531
      *                                                               *                     MD027531
      * WrtOLPOS - Write GLOLPOSTD file ( queued to GO_ONL_OLP )      *                     MD027531
      *                                                               *                     MD027531
      *****************************************************************                     MD027531
     C     WrtOLPOS      BEGSR                                                              MD027531
                                                                                            MD027531
     C                   CALL      'AOOLPSU0'                                               MD027531
     C                   PARM      *BLANKS       pRtnCode                                   MD027531
     C                   PARM                    pOlposKey                                  MD027531
     C                   PARM      @MDNO         pValdate                                   MD027531
     C                   PARM      @AMNT         pAmount                                    MD027531
     C                   PARM      @INOUT        pIncOut                                    MD027531
                                                                                            MD027531
     C                   ENDSR                                                              MD027531
      *****************************************************************                     MD027531
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR - PROGRAM ERROR SUBROUTINE                              *
      *                                                               *
      * CALLED BY:   EXECUTES WHENEVER PROGRAM ERROR OCCURS           *
      *                                                               *
      * CALLS:                                                        *
      *                                                               *
      * USES :  @ERR1  - FLAG TO PREVENT LOOPING IF FURTHER ERRORS    *
      *         @TERM  - TERMINATION PARAMETER                        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
      ** SET @ERR1 TO 'Y' TO PREVENT LOOPING IF FURTHER ERRORS
     C     @ERR1         IFNE      'Y'                                          B1
     C                   MOVE      'Y'           @ERR1             1            *1
     C                   MOVE      '1'           *INU6                          *1
      *                                                    *1
      ** SET UP FIELDS IN LOCAL DATA AREA                  *1
     C                   MOVEL     'AB0230'      DBPGM                          *1
     C                   MOVE      '991'         DBASE                          *1
      *                                                    *1
      ** DUMP THE PROGRAM                                  *1
     C                   DUMP                                                   *1
     C                   MOVE      'E'           @TERM
     C                   END                                                    E1
      *
      ** TERMINATE THE PROGRAM
     C                   MOVE      '1'           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * INFSR - FILE EXCEPTION/ERROR SUBROUTINE                       *
      *                                                               *
      * CALLED BY:   EXECUTES WHENEVER FILE EXCEPTION/ERROR OCCURS    *
      *                                                               *
      * CALLS:                                                        *
      *                                                               *
      * USES :  @ERR2  - FLAG TO PREVENT LOOPING IF FURTHER ERRORS    *
      *         @TERM  - TERMINATION PARAMETER                        *
      *         @FILE  - FILENAME FOR WHICH EXCEPTION/ERROR           *
      *                  OCCURRED (POSNS 201-208 OF PSDS)             *
      *                                                               *
      *****************************************************************
     C     INFSR         BEGSR
      *
      ** SET @ERR2 TO 'Y' TO PREVENT LOOPING IF FURTHER ERRORS
     C     @ERR2         IFNE      'Y'                                          B1
     C                   MOVE      'Y'           @ERR2             1            *1
     C                   MOVE      '1'           *INU7                          *1
     C                   MOVE      '1'           *INU8                          *1
      *                                                    *1
      ** SET UP FIELDS IN LOCAL DATA AREA                  *1
     C                   MOVEL     @FILE         DBFILE                         *1
     C                   MOVE      '992'         DBASE                          *1
      *                                                    *1
      ** DUMP THE PROGRAM                                  *1
     C                   DUMP                                                   *1
     C                   MOVE      'E'           @TERM
     C                   END                                                    E1
      *
      ** TERMINATE THE PROGRAM
     C                   MOVE      '1'           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
******* @CMD - Submit deal confirmations.                                 AB0065
******* SBMJOB DLC0210A MBATCH *JOBD RQSDTA('CALL DLC0210A') MSGQ(MOPERQ) AB0065
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2001
