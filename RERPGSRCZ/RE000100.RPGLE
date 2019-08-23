     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Account Balance Check Calculation')           *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE000100 - Account Balance Check Calculation                 *
      *                                                               *
      *  Function:  This will recalculate the base available balance  *
      *  (COB)      for every account that requires Account Balance   *
      *             Check.                                            *
      *                                                               *
      *  Called By: REC000100 - Midas RE Account Balance Check        *
      *                         Calculation                           *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD032170           Date 19Jul19               *
      *  Prev Amend No. MD022132C          Date 09Mar18               *
      *                 MD022132           Date 09Mar18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD034451C          Date 02Mar16               *
      *                 MD030959           Date 17Jun15               *
      *                 CRE095             Date 25Apr14               *
      *                 CRE090             Date 14Feb14               *
      *                 AR1075388          Date 12Nov13               *
      *                 MD023547           Date 18Nov13               *
      *                 AR1095876A         Date 30Sep13               *
      *                 AR1095876          Date 30Sep13               *
      *                 AR1039172          Date 31Jan13               *
      *                 AR1055588          Date 08Feb13               *
      *                 AR1039177          Date 11Jan13               *
      *                 AR1039174          Date 11Jan13               *
      *                 AR1022006          Date 01Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR966775           Date 11May12               *
      *                 AR958145           Date 26Apr12               *
      *                 AR899028           Date 25Jan12               *
      *                 AR847269           Date 09Nov11               *
      *                 CER042             Date 11May11               *
      *                 CRE067             Date 05Oct10               *
      *                 BUG27719A          Date 07Jul10               *
      *                 BUG27625           Date 13May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27566           Date 07May10               *
      *                 BUG27346           Date 31Mar10               *
      *                 CAP205  *CREATE    Date 18Feb10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD032170 - Ensure that GLACNTQD will be updated with the     *
      *             correct balance.                                  *
      *           - Applied for MD053827.                             *
      *  MD022132C- Process all retail accounts.                      *
      *           - Applied for MD-35969.                             *
      *  MD022132 - Triggers don't pick up Rollback deletes of ABC    *
      *             files.                                            *
      *           - Applied for MD-35969.                             *
      *  MD046248 - Finastra Rebranding                               *
      *  MD034451C - API: Repeated Held Item reversals are allowed.   *
      *              Recompiled due to changed PF/HELDIHB.            *
      *  MD030959 - Recompiled due to changed PF/HELDIHC.             *
      *  CRE095 - Rate Fixing for RE Accounts (Recompile)             *
      *  CRE090 - Delay Capitalisation of Interest (Recompile)        *
      *  AR1075388 - Account transfer fees - net (Child:AR1075389)    *
      *              Applied for MD-23536 (Recompile)                 *
      *  MD023547 - W#overline too small to hold the result           *
      *  AR1095876A-Additional requirement for Processing Type 3: If  *
      *             the transaction Value Date is greater than System *
      *             Date, no balances should be updated. Regardless   *
      *             of ANWD indicator in GL ICD. (Child: AR1095877)   *
      *  AR1095876- ABC - Forward Days 1 should = DNWD-1, not just    *
      *             RUND (Child: AR1095877)                           *
      *  AR1039172 - Calculation of the forward available balances    *
      *              does not seem to be using the processing types   *
      *              correctly                                        *
      *  AR1055588 - Available Balances in TOF (Child:AR1055591)      *
      *  AR1039177 - Treatment of expiry of Held Items                *
      *  AR1039174 - Treatment of expiry of Overdraft Lines           *
      *  AR1022006 - COB Performance Optimisation                     *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  AR966775 - Expiry Dates for Held Items and Overdraft Limits  *
      *           - Applied fix for AR975927                          *
      *  AR958145 - ABC First day processing enhancement              *
      *           - Applied fix for AR975746                          *
      *  AR899028 - NOSTRO AMAD System errors occured; applied        *
      *             fix AR847269                                      *
      *  AR847269 - Column F1DACN not in specified tables (Recompile) *
      *  CER042 - Interest Scale Report Correspondence                *
      *           (Upgrade of FGE178/179) (Recompile)                 *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  BUG27719A- Retail Account Balance Check change control       *
      *             RetailAPI050 (Use of Account Balance fields for   *
      *             minimum balance check).                           *
      *  BUG27625 - PABE_Today's Available does not include forward   *
      *             dated transaction even if ABC Processing is       *
      *             set to "1"                                        *
      *  BUG27566- Account balance appearing in the ABC header is     *
      *            incorrect                                          *
      *  BUG27346- Currency decimal places not considered in          *
      *            overdraft amount                                   *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    90         General Indicator Used For CHAIN                *
      *                                                               *
      *****************************************************************
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *INZSR      - Initialise                                      *
      * *PSSR       - Error processing                                *
      * SRWorkDay   - Set working dates for today and next n working  *
      *               days                                            *
      * SRBaseAvail - Calculate Base Available Balance                *
      * SRAvaBalance- Calculate Available Balance                     *
      * SROverDraft - Retrieve OverDraft line                         *
      * SRGetProcess- Assign processing type to use                   *
      * SRStorSysVal- Retrieve and store system values                *
      * SrSysValues - Get System values                               *
      *                                                               *
      *****************************************************************
     FACCNT     IF   E           K DISK
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
      ** Midas GL Accounts master

     FRSACMTL8  IF   E           K DISK
      ** Midas GL Account Movements in Value Date Seq

     FGLCOLLLG  IF   E           K DISK
      ** Midas GL Live Collateral Details by Account

     FGLCOLLQ0  IF   E           K DISK
      ** Midas GL Collateral Details Extension File

     FHELDIL1   IF   E           K DISK
     F                                     IGNORE(HELDIHAF)
     F                                     IGNORE(HELDIHCF)
      ** Midas RE Held Item File -  By Branch

     FREODHSL0  IF   E           K DISK
      ** Midas RE Overdraft hist by account and hist date

     F/COPY WNCPYSRC,REH00064
     FGLACNTL3  UF   E           K DISK    COMMIT
      ** Midas GL Account Extension File
                                                                                            BUG27625
     FCLEAR     IF   E           K DISK                                                     BUG27625
     F                                     IGNORE(APOSTHHF)                                 BUG27625
     F                                     RENAME(APOSTPDF:CLEARPDF)                        BUG27625
     F                                     IGNORE(APOSTZZF)                                 BUG27625
      ** Items in Clearing                                                                  BUG27625
                                                                                            BUG27625
     FGLHATML2  IF   E           K DISK                                                     BUG27625
      ** Midas GL Account Transfer Input file                                               BUG27625
                                                                                           AR1055588
     FRPACNTQD  O    E             DISK    COMMIT                                          AR1055588
     F                                     RENAME(GLACNTD0:RPACNTD0)                       AR1055588
      *                                                                                    AR1055588
      ** Midas RP Account Extension File                                                   AR1055588
      *                                                                                    AR1055588

      *****************************************************************
      /EJECT
      *****************************************************************
      /SPACE 3
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      *

     D JNSTAT        E DS                  EXTNAME(JNSTAT)
      ** Data Area giving Installation Control Details

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External data structures for Bank Details

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** Switchable Features file

     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                BUG27346
      ***  External data structures for Currency Details                                    BUG27346
                                                                                            BUG27346
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  Short data structures for Access Objects

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long data structure for access objects
                                                                                           AR1055588
     D DSLDY         E DS                  EXTNAME(DSLDY)                                  AR1055588
      *                                                                                    AR1055588
      ** Very long data structure for access objects                                       AR1055588
      *                                                                                    AR1055588
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                               AR1055588
      *                                                                                    AR1055588
      ** External data structures for Midas Modules                                        AR1055588
      *                                                                                    AR1055588
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                               AR1055588
      *                                                                                    AR1055588
      ** External data structures for Customer Details                                     AR1055588
      *                                                                                    AR1055588

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D                 DS
      *** Data structure of workdates
     D  F1DAT0                 1      3P 0
     D  F1DAT1                 4      6P 0
     D  F1DAT2                 7      9P 0
     D  F1DAT3                10     12P 0
     D  F1DAT4                13     15P 0
     D  F1DAT5                16     18P 0
     D  F1DAT6                19     21P 0
     D  F1DAT7                22     24P 0
     D  F1DAT8                25     27P 0
     D  F1DAT9                28     30P 0
     D  F1DATS                 1     30P 0
     D                                     DIM(10) ASCEND

     D                 DS
      *** Data structure of Base Available Balance
     D  F1BAB0                 1      8P 0                                                 BUG27719A
     D  F1BAB1                 9     16P 0                                                 BUG27719A
     D  F1BAB2                17     24P 0                                                 BUG27719A
     D  F1BAB3                25     32P 0                                                 BUG27719A
     D  F1BAB4                33     40P 0                                                 BUG27719A
     D  F1BAB5                41     48P 0                                                 BUG27719A
     D  F1BAB6                49     56P 0                                                 BUG27719A
     D  F1BAB7                57     64P 0                                                 BUG27719A
     D  F1BAB8                65     72P 0                                                 BUG27719A
     D  F1BAB9                73     80P 0                                                 BUG27719A
     D  F1BAVS                 1     80P 0                                                 BUG27719A
     D                                     DIM(10) ASCEND                                  BUG27719A
                                                                                           BUG27719A
     D                 DS                                                                  BUG27719A
      **  Data structure of Account Balance                                                BUG27719A
     D  F1BAV0                 1      8P 0
     D  F1BAV1                 9     16P 0
     D  F1BAV2                17     24P 0
     D  F1BAV3                25     32P 0
     D  F1BAV4                33     40P 0
     D  F1BAV5                41     48P 0
     D  F1BAV6                49     56P 0
     D  F1BAV7                57     64P 0
     D  F1BAV8                65     72P 0
     D  F1BAV9                73     80P 0
     D**F1BAVS**               1     80P 0                                                 BUG27719A
     D  F1ACBS                 1     80P 0                                                 BUG27719A
     D                                     DIM(10) ASCEND

     D                 DS
      *** Data structure of Available Balance
     D  F1AVA0                 1      8P 0
     D  F1AVA1                 9     16P 0
     D  F1AVA2                17     24P 0
     D  F1AVA3                25     32P 0
     D  F1AVA4                33     40P 0
     D  F1AVA5                41     48P 0
     D  F1AVA6                49     56P 0
     D  F1AVA7                57     64P 0
     D  F1AVA8                65     72P 0
     D  F1AVA9                73     80P 0
     D  F1AVAS                 1     80P 0
     D                                     DIM(10) ASCEND

     D                 DS
      *** Data structure of Blocked Collateral
     D  F1CBC0                 1      8P 0
     D  F1CBC1                 9     16P 0
     D  F1CBC2                17     24P 0
     D  F1CBC3                25     32P 0
     D  F1CBC4                33     40P 0
     D  F1CBC5                41     48P 0
     D  F1CBC6                49     56P 0
     D  F1CBC7                57     64P 0
     D  F1CBC8                65     72P 0
     D  F1CBC9                73     80P 0
     D  F1CBCS                 1     80P 0
     D                                     DIM(10) ASCEND

     D                 DS
      *** Data structure of Held Items
     D  F1HIT0                 1      8P 0
     D  F1HIT1                 9     16P 0
     D  F1HIT2                17     24P 0
     D  F1HIT3                25     32P 0
     D  F1HIT4                33     40P 0
     D  F1HIT5                41     48P 0
     D  F1HIT6                49     56P 0
     D  F1HIT7                57     64P 0
     D  F1HIT8                65     72P 0
     D  F1HIT9                73     80P 0
     D  F1HITS                 1     80P 0
     D                                     DIM(10) ASCEND
     D                 DS                                                                  AR1055588
      *                                                                                    AR1055588
      ** Data structure of Previous Available Balance's values                             AR1055588
      *                                                                                    AR1055588
     D  P_F1AVA0               1      8P 0                                                 AR1055588
     D  P_F1AVA1               9     16P 0                                                 AR1055588
     D  P_F1AVA2              17     24P 0                                                 AR1055588
     D  P_F1AVA3              25     32P 0                                                 AR1055588
     D  P_F1AVA4              33     40P 0                                                 AR1055588
     D  P_F1AVA5              41     48P 0                                                 AR1055588
     D  P_F1AVA6              49     56P 0                                                 AR1055588
     D  P_F1AVA7              57     64P 0                                                 AR1055588
     D  P_F1AVA8              65     72P 0                                                 AR1055588
     D  P_F1AVA9              73     80P 0                                                 AR1055588
     D  P_F1AVAS               1     80P 0                                                 AR1055588
     D                                     DIM(10) ASCEND                                  AR1055588
     D/COPY WNCPYSRC,REH00065
      *** Data structure of Held Items
     D  HELDS          S              1    DIM(10)

      *** Work variables
     D WDATEIN         S              5  0
     D WCNUM           S              6
     D WKCNUM          S              6                                                    AR1055588
     D WCCY            S              3
     D WACOD           S             10  0
     D WACSQ           S              2  0
     D WBRCA           S              3
     D WBRC1           S              3
     D WXREF           S             10
     D*W#OverLine***   S             11  0                                                  MD023547
     D W#OverLine      S             15  0                                                  MD023547
     D WHISD           S              5  0
     D WProcessType    S              1
     D NoDays          S              3  0
     D CLE134          S              1                                                       CLE134
     D WNWD            S              3  0                                                 AR1095876

     D FieldsDS        DS
      ** Module is FT
     D WKSysFTDR                      1
     D WKSysFTCR                      1
      ** Module is GL Transaction Type is ME
     D WKSysGLMEDR                    1
     D WKSysGLMECR                    1
      ** Module is SE
     D WKSysSEDR                      1
     D WKSysSECR                      1
      ** Module is GL Transaction Type is ZT and Movement Type is S
     D WKSysGLMESDR                   1
     D WKSysGLMESCR                   1
      ** Module is GL Transaction Type is ZT and Movement Type is F
     D WKSysGLMEFDR                   1
     D WKSysGLMEFCR                   1
      ** Other modules Movetype is S
     D WKSysOTSDR                     1
     D WKSysOTSCR                     1
      ** Other modules Movetype is F
     D WKSysOTFDR                     1
     D WKSysOTFCR                     1
     ** System value for number of days
     D WKSysNoDays                    1
     ** System value for Overdraft Processing Type                                         AR1039174
     D WKOvrdPtype                    1                                                    AR1039174
     ** System value for Held Items Processing Type                                        AR1039177
     D WKHeldPtype                    1                                                    AR1039177
     D***FieldsArr                      1    DIM(15)                                       AR1039174
     D***FieldsArr                      1    DIM(16)                             AR1039174 AR1039177
     D FieldsArr                      1    DIM(17)                                         AR1039177
     D                                     OVERLAY(FieldsDS)

      ** AOSVALR0 parameters

     D PSysVal         S             20    DIM(10)
     D PCurSet         S            200    DIM(10)

      ** AOCURRR0 parameters                                                                BUG27346
     D PCcy            S              3                                                     BUG27346
                                                                                            BUG27346
      ** Fields for SRGetProcess                                                            BUG27625
     D WkCMOD          S                   LIKE(CMOD)                                       BUG27625
     D WkDORC          S                   LIKE(DORC)                                       BUG27625
     D WkTRYP          S                   LIKE(TRYP)                                       BUG27625
     D WkMTYP          S                   LIKE(MTYP)                                       BUG27625
                                                                                            BUG27625
     D WkTREF          S                   LIKE(R1TREF)                                     BUG27625
                                                                                            BUG27625
      ** Array Indices

     D X               S              3P 0

      *** Other variables
     D/COPY ZSRSRC,ZHOLILE
     D/COPY ZSRSRC,ZHOLELE

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

     IGLCOLQD0
     I              CDXREF                      CDXREF10

     IRSACMTPO
     I              NRTC                        NRTCX

     IREODHSD0
     I              ODED                        ODEDX
     I              ODLN                        ODLNX
      *****************************************************************
      /SPACE 3
      *****************************************************************
      /EJECT
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================

      ** Start of processing
      *
     C     *LOVAL        SETLL     GLACNTL3
     C                   READ      GLACNTL3
     C                   DOW       NOT %EOF(GLACNTL3)
      *                                                                                    AR1055588
      ** Keep backup of values from current available balances 0-9                         AR1055588
      *                                                                                    AR1055588
     C                   MOVEA     F1AVAS        P_F1AVAS                                  AR1055588
                                                                                            AR958145
      ** Retrieve account details                                                           AR958145
                                                                                            AR958145
     C                   MOVE      F1CNUM        WCNUM                                      AR958145
     C                   MOVE      F1CCY         WCCY                                       AR958145
     C                   MOVE      F1ACOD        WACOD                                      AR958145
     C                   MOVE      F1ACSQ        WACSQ                                      AR958145
     C                   MOVE      F1BRCA        WBRCA                                      AR958145
                                                                                            AR958145
     C     KACCNT        CHAIN     ACCNT                                                    AR958145
      *
     C**********         IF        F1IABC = 'Y'                                             AR958145
     C*****              IF        F1IABC = 'Y' OR                                 AR958145 MD022132
     C*****                        ATYP = 'R'                                      AR958145 MD022132
     C**********         IF        F1IABC = 'Y'                                   MD022132 MD022132C
     C                   IF        F1IABC = 'Y' OR                                         MD022132C
     C                             ATYP = 'R'                                              MD022132C
      *****************************************************************                     AR958145
      ***Retrieve*account*details**************************************                     AR958145
      *****************************************************************                     AR958145
     C**********         MOVE      F1CNUM        WCNUM                                      AR958145
     C**********         MOVE      F1CCY         WCCY                                       AR958145
     C**********         MOVE      F1ACOD        WACOD                                      AR958145
     C**********         MOVE      F1ACSQ        WACSQ                                      AR958145
     C**********         MOVE      F1BRCA        WBRCA                                      AR958145
      *
      ** Account should not be attached to a facility
      *
     C*****KACCNT        CHAIN     ACCNT                                                    AR958145
     C**********         IF        %FOUND(ACCNT)                                            MD032170
     C**********                   AND FCCU = *BLANKS AND                                   MD032170
     C**********                   FACT = *ZERO AND FCNO = *ZERO                            MD032170
      *
     C/COPY WNCPYSRC,REH00066
      ** set working date for today and the next 9 working days
     C                   EXSR      SRWorkDay
      ** compute base available balance
     C                   EXSR      SRBaseAvail
      ** compute available balance
     C                   EXSR      SRAvaBalance
                                                                                            BUG27625
      ** compute available balance using CLEARPD                                            BUG27625
                                                                                            BUG27625
     C                   EXSR      SRAvaBalance2                                            BUG27625
      *
     C                   UPDATE    GLACNTD0
     C/COPY WNCPYSRC,REH00067
      *                                                                                    AR1055588
      ** If Private Banking Module switched ON and for all opened Retail Accounts,         AR1055588
      ** extract records into a separate file which will be replicated to TOF              AR1055588
      ** at the end of the COB by component RPC1400 sequence '00002' (RPC1423)             AR1055588
      *                                                                                    AR1055588
                                                                                           AR1055588
     C                   IF        BGN4ST = 'Y' AND ATYP = 'R' AND DACC = 0                AR1055588
                                                                                           AR1055588
      ** Send ONLY records to TOF which have effectively changes of available balances     AR1055588
                                                                                           AR1055588
     C                   IF        F1AVA0 <> P_F1AVA0 OR                                   AR1055588
     C                             F1AVA1 <> P_F1AVA1 OR                                   AR1055588
     C                             F1AVA2 <> P_F1AVA2 OR                                   AR1055588
     C                             F1AVA3 <> P_F1AVA3 OR                                   AR1055588
     C                             F1AVA4 <> P_F1AVA4 OR                                   AR1055588
     C                             F1AVA5 <> P_F1AVA5 OR                                   AR1055588
     C                             F1AVA6 <> P_F1AVA6 OR                                   AR1055588
     C                             F1AVA7 <> P_F1AVA7 OR                                   AR1055588
     C                             F1AVA8 <> P_F1AVA8 OR                                   AR1055588
     C                             F1AVA9 <> P_F1AVA9                                      AR1055588
                                                                                           AR1055588
     C                   IF        F1CNUM <> WKCNUM                                        AR1055588
     C                   EXSR      SRGetPBInd                                              AR1055588
     C                   MOVE      F1CNUM        WKCNUM                                    AR1055588
     C                   ENDIF                                                             AR1055588
                                                                                           AR1055588
      ** Do it only for customers defined as Private Banking customers                     AR1055588
                                                                                           AR1055588
     C                   IF        BBPRBA = 'Y'                                            AR1055588
     C                   WRITE     RPACNTD0                                                AR1055588
     C                   ENDIF                                                             AR1055588
                                                                                           AR1055588
     C                   ENDIF                                                             AR1055588
                                                                                           AR1055588
     C                   ENDIF                                                             AR1055588
                                                                                           AR1055588
     C**********         ENDIF                                                              MD032170
      *
     C                   ENDIF
      *
     C                   READ      GLACNTL3
     C                   ENDDO

     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWorkDay - Subroutine to set working date for today and the *
      *              next 9 working days                              *
      *                                                               *
      *****************************************************************
     C     SRWorkDay     BEGSR

     C                   EVAL      NoDays = %INT(%TRIM(WKSysNoDays)) + 1
      *
      ** Initialize variables
      *
     C                   MOVEA     *ZERO         F1DATS
     C/COPY WNCPYSRC,REH00068
      *
      ** current rundate has already been changed so we will set this as F1DAT1
      *  and F1DAT0 as previous day
      *
     C                   IF        NoDays >= 1
     C                   Z-ADD     PRUN          F1DAT0
     C                   EndIf

     C                   IF        NoDays >= 2
     C                   Z-ADD     BJRDNB        F1DAT1
     C                   ENDIF
      *
      ** get the third day to tenth day
      *
     C                   IF        NoDays >= 3
     C                   Z-ADD     3             WCTR              2 0
     C     BJRDNB        ADD       1             WDATEIN
      *
     C                   DOW       WCTR <= NoDays
      *
      ** Location currency
      *
     C                   Z-ADD     WDATEIN       ZDAYNO
     C                   MOVE      BJLCCY        ZCCY
     C                   MOVE      *BLANKS       ZLOC
     C                   MOVE      *BLANKS       ZIND
      *
     C                   EXSR      ZCHKH
      *
     C                   MOVE      ZIND          LOCIND            1
      *****************************************************************                    AR1095876
      ***Account*currency**********************************************                    AR1095876
      *****************************************************************                    AR1095876
     C**********         Z-ADD     WDATEIN       ZDAYNO                                    AR1095876
     C**********         MOVE      CCY           ZCCY                                      AR1095876
     C**********         MOVE      *BLANKS       ZLOC                                      AR1095876
     C**********         MOVE      *BLANKS       ZIND                                      AR1095876
      *
     C**********         EXSR      ZCHKH                                                   AR1095876
      *
     C**********         MOVE      ZIND          ACTIND            1                       AR1095876
      *
     C**********         IF        LOCIND = 'W' OR ACTIND = 'W'                            AR1095876
     C                   IF        LOCIND = 'W'                                            AR1095876
     C                   EVAL      F1DATS(WCTR) = WDATEIN
     C                   ADD       1             WCTR
     C                   ENDIF
     C
     C                   ADD       1             WDATEIN
      *
     C                   ENDDO
     C                   ENDIF
      *                                                                                    AR1095876
      ** Get the next working day after the last ABC availability date and                 AR1095876
      ** put it in F1OAD field                                                             AR1095876
      *                                                                                    AR1095876
     C                   EVAL      WDATEIN = F1DATS(NoDays) + 1                            AR1095876
     C                   EVAL      LOCIND = *BLANK                                         AR1095876
      *                                                                                    AR1095876
     C                   DOW       LOCIND <> 'W'                                           AR1095876
      *                                                                                    AR1095876
      ** Location currency                                                                 AR1095876
      *                                                                                    AR1095876
     C                   Z-ADD     WDATEIN       ZDAYNO                                    AR1095876
     C                   MOVE      BJLCCY        ZCCY                                      AR1095876
     C                   MOVE      *BLANKS       ZLOC                                      AR1095876
     C                   MOVE      *BLANKS       ZIND                                      AR1095876
      *                                                                                    AR1095876
     C                   EXSR      ZCHKH                                                   AR1095876
      *                                                                                    AR1095876
     C                   MOVE      ZIND          LOCIND                                    AR1095876
     C                   IF        LOCIND = 'W'                                            AR1095876
     C                   EVAL      F1OAD = WDATEIN                                         AR1095876
     C                   ENDIF                                                             AR1095876
     C                   ADD       1             WDATEIN                                   AR1095876
     C                   ENDDO                                                             AR1095876
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBaseAvail - Subroutine to calculate Base Available Balance *
      *                                                               *
      *****************************************************************
     C     SRBaseAvail   BEGSR
      *
      ** Initialize variables
      *
     C                   MOVEA     *BLANKS       HELDS
     C                   MOVEA     *ZERO         F1BAVS
     C                   MOVEA     *ZERO         F1AVAS
     C                   MOVEA     *ZERO         F1HITS
     C                   MOVEA     *ZERO         F1CBCS
     C                   MOVEA     *ZERO         F1ACBS                                    BUG27719A
     C/COPY WNCPYSRC,REH00069
      *
     C                   Z-ADD     1             WCTR
      *
      ***Initialize*account*balance*array*with*cleared*balance*********                    BUG27719A
      ** Initialize account balance and base available balance arrays                      BUG27719A
      ** with cleared balance for the next N days where N is the ABC                       BUG27719A
      ** Number of Days Forward + 1 in SDSVALPD.                                           BUG27719A
      *
     C                   DOW       WCTR <= NoDays
     C                   EVAL      F1ACBS(WCTR) = CLBL                                     BUG27719A
     C                   EVAL      F1BAVS(WCTR) = CLBL
     C/COPY WNCPYSRC,REH00070
     C                   ADD       1             WCTR
     C                   ENDDO
      *
      ** Check if Blocked Collateral Exists
      *
     C     KGCOLG        CHAIN     GLCOLLLG                           50
      *
     C                   DOW       *IN50 = *OFF
      *
     C                   IF        CDBCOL = 'Y'
     C                             AND CDCOPT = 'A'
      *
     C                   Z-ADD     1             WCTR
     C                   DOW       WCTR <= NoDays
      *
     C                   IF        CDEDAT >= F1DATS(WCTR) AND
     C                             CDVDAT <= F1DATS(WCTR)
      *
     C                   MOVE      CDCBRC        WBRC1
     C                   MOVE      CDCREF        WXREF
      *
     C     KGCOQ0        CHAIN     GLCOLLQ0
     C                   IF        %FOUND(GLCOLLQ0)
      *
     C                   IF        CDXCBC > 0
     C                   EVAL      F1CBCS(WCTR) = F1CBCS(WCTR) + CDXCBC
     C/COPY WNCPYSRC,REH00071
     C                   ENDIF
      *
     C                   ELSE
      *
      ** account should always have corresponding record on GLCOLLQ0
      ** when the preceding conditions are satisfied
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'GLCOLLQD'
     C                   EVAL      DBKEY = WXREF
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ADD       1             WCTR
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C     KGCOLG        READE     GLCOLLLG                               50
     C                   ENDDO
      *
      ** Check if Held Items Exists
      *
     C     KHLDL1        CHAIN     HELDIL1                            50
      *
     C                   DOW       *IN50 = *OFF
      *
     C                   IF        RECI = 'D'
      *
     C                   Z-ADD     1             WCTR
     C                   DOW       WCTR <= NoDays
     C**********         IF        HEXP >= F1DATS(WCTR)                                     AR966775
     C                   IF        HEXP > F1DATS(WCTR)                                      AR966775
     C                             AND WKHeldPtype = '2'                                   AR1039177
     C                             OR HEXP > BJRDNB                                        AR1039177
     C                             AND WKHeldPtype = '3'                                   AR1039177
     C                             OR HEXP >= BJRDNB                                       AR1039177
     C                             AND WKHeldPtype = '4'                                   AR1039177
      *
     C                   EVAL      F1HITS(WCTR) = F1HITS(WCTR) + HLDA
     C/COPY WNCPYSRC,REH00072
     C                   IF        HHIT = 'Y'
     C                   EVAL      HELDS(WCTR) = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
     C                   ADD       1             WCTR
     C                   ENDDO
      *
     C                   ENDIF
      *
     C     KHLDL1        READE     HELDIL1                                50
     C                   ENDDO
      *
      ** Calculate for the Base Available Balance
      *
     C                   Z-ADD     1             WCTR
                                                                                            BUG27346
      ** Get currency detail                                                                BUG27346
                                                                                            BUG27346
     C                   EVAL      PCcy = WCCY                                              BUG27346
     C                   EXSR      SRGetCurrD                                               BUG27346
                                                                                            BUG27346
     C                   DOW       WCTR <= NoDays
      *
      * If there is a blocked collateral amount
     C                   IF        F1CBCS(WCTR) <> *ZERO
      *
      ** Base Available Balance
      **  = Cleared Account Balance debit all Held Items debit all Blocked Collateral
      **  = Cleared Account Balance + all Held Items + all Blocked Collateral
      *
     C                   EVAL      F1BAVS(WCTR) = F1BAVS(WCTR) + F1HITS(WCTR)
     C                   EVAL      F1BAVS(WCTR) = F1BAVS(WCTR) + F1CBCS(WCTR)
     C/COPY WNCPYSRC,REH00073
     C                   ELSE
      *
      ** Base Available Balance
      **  = Cleared Account Balance debit all Held Items
      **  = Cleared Account Balance + all Held Items
      *
     C                   EVAL      F1BAVS(WCTR) = F1BAVS(WCTR) + F1HITS(WCTR)
     C/COPY WNCPYSRC,REH00074
      *
      ** If there are no hard held items
      *
     C                   IF        HELDS(WCTR) <> 'Y'
      *
      ** Base Available Balance
      **  = Cleared Account Balance debit all Held Items credit Overdraft Line
      **  = Cleared Account Balance + all Held Items - Overdraft Line
      *
     C                   EXSR      SROverDraft
     C                   EVAL      F1BAVS(WCTR) = F1BAVS(WCTR) - W#OverLine
     C/COPY WNCPYSRC,REH00075
     C                   ENDIF
     C                   ENDIF
      *
     C                   ADD       1             WCTR
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAvaBalance - Subroutine to calculate Available Balance     *
      *                 and Account Balances                          *                    BUG27719A
      *                                                               *
      *****************************************************************
     C     SRAvaBalance  BEGSR
      *
      ** Initialize variables
      *
     C                   MOVEA     F1BAVS        F1AVAS
     C/COPY WNCPYSRC,REH00076
      *
     C     KRSCL6        SETLL     RSACMTL8
     C     KRSCL6        READE     RSACMTL8
      *
     C                   DOW       NOT %EOF(RSACMTL8)
      *
     C                   Z-ADD     1             WCTR
     C                   EVAL      WNWD = WCTR + 1                                         AR1095876
                                                                                              CLE134
      ** Process auto-settle = 'C' the same way as 'N', therefore movement in shadow          CLE134
      ** posting with auto-settle ='C' are to be excluded in available balance calc.          CLE134
      ** When XRFI and XRFN are empty proceed processing otherwise read next record           CLE134
                                                                                              CLE134
     C**********         IF        XRFI <> *BLANKS AND                              CLE134 AR1022006
     C**********                   XRFN <> 0 AND CLE134 = 'Y'                       CLE134 AR1022006
     C                   IF        CLE134 = 'Y'                                            AR1022006
     C                             AND (XRFI <> 'CLI'                                      AR1022006
     C                             AND  XRFI <> 'CL?'                                      AR1022006
     C                             AND  XRFI <> 'FEE'                                      AR1022006
     C                             AND  XRFI <> 'FE?')                                     AR1022006
     C     KRSCL6        READE     RSACMTL8                                                   CLE134
     C                   ITER                                                                 CLE134
     C                   ENDIF                                                                CLE134
      *
      ** Retrieve processing type to be used
      *
     C                   EVAL      WkCMOD = CMOD                                            BUG27625
     C                   EVAL      WkDORC = DORC                                            BUG27625
     C                   EVAL      WkTRYP = TRYP                                            BUG27625
     C                   EVAL      WkMTYP = MTYP                                            BUG27625
     C                   EXSR      SRGetProcess
      *
     C                   DOW       WCTR <= NoDays
     C                   SELECT
     C                   WHEN      WProcessType = '1'
      *
      ** No Additional Condition
      *
     C                   IF        DORC = 0
      ** Add Movement Amount, MVAM and Base Available Balance
     C                   ADD       MVAM          F1AVAS(WCTR)
     C/COPY WNCPYSRC,REH00077
      ** Add Movement Amount MVAM to Account Balance                                       BUG27719A
     C                   ADD       MVAM          F1ACBS(WCTR)                              BUG27719A
     C                   ELSE
      ** Subtract Movement Amount, MVAM and Base Available Balance
     C                   SUB       MVAM          F1AVAS(WCTR)
      ** Subtract Movement Amount MVAM from Account Balance                                BUG27719A
     C                   SUB       MVAM          F1ACBS(WCTR)                              BUG27719A
     C/COPY WNCPYSRC,REH00078
     C                   ENDIF
      *
     C                   WHEN      WProcessType = '2'
      *
      ** If Movement Date, VUDT is less than or equal to date being processed
      ** Or if Value Date is not an availability date (i.e. movements with a               AR1095876
      ** value date that is a holiday in system currency), update the                      AR1095876
      ** balance of the preceding availability date. This processing is                    AR1095876
      ** 'in advance'                                                                      AR1095876
      *
     C                   IF        VUDT <= F1DATS(WCTR)
     C                             OR VUDT > F1DATS(WCTR)                                  AR1095876
     C                             AND VUDT < F1DATS(WNWD)                                 AR1095876
     C                             OR VUDT > F1DATS(WCTR)                                  AR1095876
     C                             AND VUDT < F1OAD                                        AR1095876
     C                             AND WCTR = NoDays                                       AR1095876
     C                   IF        DORC = 0
      ** Add Movement Amount, MVAM and Base Available Balance
     C                   ADD       MVAM          F1AVAS(WCTR)
      ** Add Movement Amount MVAM to Account Balance                                       BUG27719A
     C                   ADD       MVAM          F1ACBS(WCTR)                              BUG27719A
     C/COPY WNCPYSRC,REH00079
     C                   ELSE
      ** Subtract Movement Amount, MVAM and Base Available Balance
     C                   SUB       MVAM          F1AVAS(WCTR)
      ** Subtract Movement Amount MVAM from Account Balance                                BUG27719A
     C                   SUB       MVAM          F1ACBS(WCTR)                              BUG27719A
     C/COPY WNCPYSRC,REH00080
     C                   ENDIF
     C                   ENDIF
      *
     C                   WHEN      WProcessType = '3'
      *
      ***If*Movement*Date,*PTDT*is*less*than*or*equal*to*F1DAT0********                   AR1095876A
      ** If Value Date, VUDT is less than or equal to today's date                        AR1095876A
      ** and Movement Date, VUDT is less than or equal to date being processed
      *
     C**********         IF        PTDT <= F1DAT0                                          AR1039172
     C                   IF        VUDT <= BJRDNB                                          AR1039172
     C                             AND VUDT <= F1DATS(WCTR)
     C                   IF        DORC = 0
      ** Add Movement Amount, MVAM and Base Available Balance
     C                   ADD       MVAM          F1AVAS(WCTR)
      ** Add Movement Amount MVAM to Account Balance                                       BUG27719A
     C                   ADD       MVAM          F1ACBS(WCTR)                              BUG27719A
     C/COPY WNCPYSRC,REH00081
     C                   ELSE
      ** Subtract Movement Amount, MVAM and Base Available Balance
     C                   SUB       MVAM          F1AVAS(WCTR)
      ** Subtract Movement Amount MVAM from Account Balance                                BUG27719A
     C                   SUB       MVAM          F1ACBS(WCTR)                              BUG27719A
     C/COPY WNCPYSRC,REH00082
     C                   ENDIF
     C                   ENDIF
      *
     C                   WHEN      WProcessType = '4'
      ** Movement is not included hence do nothing
     C                   ENDSL
     C                   ADD       1             WCTR
     C                   IF        WCTR >= NoDays                                          AR1095876
     C                   EVAL      WNWD = WCTR                                             AR1095876
     C                   ELSEIF    WCTR < NoDays                                           AR1095876
     C                   EVAL      WNWD = WCTR + 1                                         AR1095876
     C                   ENDIF                                                             AR1095876
     C                   ENDDO
      *
     C     KRSCL6        READE     RSACMTL8
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************                     BUG27625
      /EJECT                                                                                BUG27625
      *****************************************************************                     BUG27625
      *                                                               *                     BUG27625
      *  SRAvaBalance2 - Subroutine to calculate Available Balance    *                     BUG27625
      *                  with CLEARPD                                 *                     BUG27625
      *                                                               *                     BUG27625
      *****************************************************************                     BUG27625
     C     SRAvaBalance2 BEGSR                                                              BUG27625
                                                                                            BUG27625
     C     KRSCL6        SETLL     CLEARPDF                                                 BUG27625
     C     KRSCL6        READE     CLEARPDF                                                 BUG27625
                                                                                            BUG27625
     C                   DOW       NOT %EOF(CLEAR)                                          BUG27625
     C                   Z-ADD     1             WCTR                                       BUG27625
     C                   EVAL      WNWD = WCTR + 1                                         AR1095876
                                                                                            BUG27625
      ** Retrieve processing type to be used                                                BUG27625
                                                                                            BUG27625
     C                   EVAL      WkTRYP = *BLANK                                          BUG27625
     C                   EVAL      WkDORC = DRCR                                            BUG27625
     C                   SELECT                                                             BUG27625
     C                   WHEN      SPOS = '  GE-IC'                                         BUG27625
     C                   EVAL      WkCMOD = 'RE'                                            BUG27625
     C                   EVAL      WkMTYP = 'S'                                             BUG27625
                                                                                            BUG27625
     C                   WHEN      SPOS = '  GE-CE'                                         BUG27625
     C                   EVAL      WkCMOD = 'RE'                                            BUG27625
     C                   EVAL      WkMTYP = 'S'                                             BUG27625
                                                                                            BUG27625
     C                   WHEN      SPOS = '  GE-TX'                                         BUG27625
     C                   EVAL      WkCMOD = 'GL'                                            BUG27625
     C                   EVAL      WkTRYP = 'ZT'                                            BUG27625
     C                   MOVEL     OTRF          WkTREF                                     BUG27625
     C     KeyHATM       CHAIN     GLHATML2                                                 BUG27625
     C                   IF        %FOUND(GLHATML2)                                         BUG27625
                                                                                            BUG27625
      ** Expiry date for GLHATMPD is always <= current rundate,                             BUG27625
      ** hence, same day processing, "S"                                                    BUG27625
                                                                                            BUG27625
     C                   EVAL      WkMTYP = 'S'                                             BUG27625
     C                   ELSE                                                               BUG27625
     C     *LOCK         IN        LDA                                                      BUG27625
     C                   EVAL      DBFILE = 'GLHATMPD'                                      BUG27625
     C                   EVAL      DBKEY = WkTREF                                           BUG27625
     C                   EVAL      DBASE = 6                                                BUG27625
     C                   OUT       LDA                                                      BUG27625
     C                   EXSR      *PSSR                                                    BUG27625
     C                   ENDIF                                                              BUG27625
                                                                                            BUG27625
     C                   OTHER                                                              BUG27625
     C                   EVAL      WkCMOD = 'GL'                                            BUG27625
     C                   EVAL      WkTRYP = 'ME'                                            BUG27625
     C                   EVAL      WkMTYP = 'S'                                             BUG27625
                                                                                            BUG27625
     C                   ENDSL                                                              BUG27625
                                                                                            BUG27625
     C                   EXSR      SRGetProcess                                             BUG27625
                                                                                            BUG27625
     C                   DOW       WCTR <= NoDays                                           BUG27625
     C                   SELECT                                                             BUG27625
     C                   WHEN      WProcessType = '1'                                       BUG27625
                                                                                            BUG27625
      ** No Additional Condition                                                            BUG27625
                                                                                            BUG27625
     C                   IF        DRCR = 0                                                 BUG27625
                                                                                            BUG27625
      ** Add Posting Amount, PSTA and Base Available Balance                                BUG27625
                                                                                            BUG27625
     C                   ADD       PSTA          F1AVAS(WCTR)                               BUG27625
      ** Add Posting Amount PSTA to Account Balance                                        BUG27719A
     C                   ADD       PSTA          F1ACBS(WCTR)                              BUG27719A
     C/COPY WNCPYSRC,REH00083
     C                   ELSE                                                               BUG27625
                                                                                            BUG27625
      ** Subtract Posting Amount, PSTA and Base Available Balance                           BUG27625
                                                                                            BUG27625
     C                   SUB       PSTA          F1AVAS(WCTR)                               BUG27625
      ** Subtract Posting Amount PSTA from Account Balance                                 BUG27719A
     C                   SUB       PSTA          F1ACBS(WCTR)                              BUG27719A
     C/COPY WNCPYSRC,REH00084
     C                   ENDIF                                                              BUG27625
                                                                                            BUG27625
     C                   WHEN      WProcessType = '2'                                       BUG27625
                                                                                            BUG27625
      ** If Movement Date, VALD is less than or equal to date being processed               BUG27625
      ** Or if Value Date is not an availability date (i.e. movements with a               AR1095876
      ** value date that is a holiday in system currency), update the                      AR1095876
      ** balance of the preceding availability date. This processing is                    AR1095876
      ** 'in advance'                                                                      AR1095876
                                                                                            BUG27625
     C                   IF        VALD <= F1DATS(WCTR)                                     BUG27625
     C                             OR VALD > F1DATS(WCTR)                                  AR1095876
     C                             AND VALD < F1DATS(WNWD)                                 AR1095876
     C                             OR VALD > F1DATS(WCTR)                                  AR1095876
     C                             AND VALD < F1OAD                                        AR1095876
     C                             AND WCTR = NoDays                                       AR1095876
     C                   IF        DRCR = 0                                                 BUG27625
                                                                                            BUG27625
      ** Add Posting Amount, PSTA and Base Available Balance                                BUG27625
                                                                                            BUG27625
     C                   ADD       PSTA          F1AVAS(WCTR)                               BUG27625
      ** Add Posting Amount PSTA to Account Balance                                        BUG27719A
     C                   ADD       PSTA          F1ACBS(WCTR)                              BUG27719A
     C/COPY WNCPYSRC,REH00085
     C                   ELSE                                                               BUG27625
                                                                                            BUG27625
      ** Subtract Posting Amount, PSTA and Base Available Balance                           BUG27625
                                                                                            BUG27625
     C                   SUB       PSTA          F1AVAS(WCTR)                               BUG27625
      ** Subtract Posting Amount PSTA from Account Balance                                 BUG27719A
     C                   SUB       PSTA          F1ACBS(WCTR)                              BUG27719A
     C/COPY WNCPYSRC,REH00086
     C                   ENDIF                                                              BUG27625
     C                   ENDIF                                                              BUG27625
                                                                                            BUG27625
     C                   WHEN      WProcessType = '3'                                       BUG27625
                                                                                            BUG27625
      ***If*Movement Date,*PSTD*is*less*than*or*equal*to*F1DAT0********          BUG27625 AR1095876A
      ** If Movement Date, VALD is less than or equal to Today's date                     AR1095876A
      ** and Movement Date, VALD is less than or equal to date being processed              BUG27625
                                                                                            BUG27625
     C**********         IF        PSTD <= F1DAT0                                 BUG27625 AR1039172
     C                   IF        VALD <= BJRDNB                                          AR1039172
     C                             AND VALD <= F1DATS(WCTR)                                 BUG27625
     C                   IF        DRCR = 0                                                 BUG27625
                                                                                            BUG27625
      ** Add Posting Amount, PSTA and Base Available Balance                                BUG27625
                                                                                            BUG27625
     C                   ADD       PSTA          F1AVAS(WCTR)                               BUG27625
      ** Add Posting Amount PSTA to Account Balance                                        BUG27719A
     C                   ADD       PSTA          F1ACBS(WCTR)                              BUG27719A
     C/COPY WNCPYSRC,REH00087
     C                   ELSE                                                               BUG27625
                                                                                            BUG27625
      ** Subtract Posting Amount, PSTA and Base Available Balance                           BUG27625
                                                                                            BUG27625
     C                   SUB       PSTA          F1AVAS(WCTR)                               BUG27625
      ** Subtract Posting Amount PSTA from Account Balance                                 BUG27719A
     C                   SUB       PSTA          F1ACBS(WCTR)                              BUG27719A
     C/COPY WNCPYSRC,REH00088
     C                   ENDIF                                                              BUG27625
     C                   ENDIF                                                              BUG27625
                                                                                            BUG27625
     C                   WHEN      WProcessType = '4'                                       BUG27625
                                                                                            BUG27625
      ** Movement is not included hence do nothing                                          BUG27625
                                                                                            BUG27625
     C                   ENDSL                                                              BUG27625
                                                                                            BUG27625
     C                   ADD       1             WCTR                                       BUG27625
     C                   IF        WCTR >= NoDays                                          AR1095876
     C                   EVAL      WNWD = WCTR                                             AR1095876
     C                   ELSEIF    WCTR < NoDays                                           AR1095876
     C                   EVAL      WNWD = WCTR + 1                                         AR1095876
     C                   ENDIF                                                             AR1095876
     C                   ENDDO                                                              BUG27625
                                                                                            BUG27625
     C     KRSCL6        READE     CLEARPDF                                                 BUG27625
     C                   ENDDO                                                              BUG27625
                                                                                            BUG27625
     C                   ENDSR                                                              BUG27625
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROverDraft - Subroutine to retrieve OverDraft line          *
      *                                                               *
      *****************************************************************
     C     SROverDraft   BEGSR
      *
      ** Initialize variables
      *
     C                   Z-ADD     *ZERO         W#OverLine
      *
     C                   IF        CRE001 = 'N'
      *
     C**********         IF        ODED >= F1DATS(WCTR)                                     AR966775
     C                   IF        ODED > F1DATS(WCTR)                                      AR966775
     C                             AND WKOvrdPtype = '2'                                   AR1039174
     C                             OR ODED > BJRDNB                                        AR1039174
     C                             AND WKOvrdPtype = '3'                                   AR1039174
     C                             OR ODED >= BJRDNB                                       AR1039174
     C                             AND WKOvrdPtype = '4'                                   AR1039174
     C**********         EVAL      W#OverLine = ODLN                                        BUG27346
     C                   EVAL      W#OverLine = ODLN * (10**A6NBDP)                         BUG27346
     C                   ENDIF
      *
     C                   ELSE
      *
      ** CRE001 is switched on
      *
     C                   EVAL      WHISD = F1DATS(WCTR)
     C     KROHL0        SETGT     REODHSL0
     C     KHLDL1        READPE    REODHSL0
     C                   IF        NOT %EOF(REODHSL0)                                       BUG27566
                                                                                            BUG27566
     C                   IF        F1DATS(WCTR) >= HISD AND
     C**********                   F1DATS(WCTR) <= ODEDX                                    AR966775
     C                             F1DATS(WCTR) < ODEDX                                     AR966775
     C                             AND WKOvrdPtype = '2'                                   AR1039174
     C                             OR ODEDX > BJRDNB                                       AR1039174
     C                             AND WKOvrdPtype = '3'                                   AR1039174
     C                             OR ODEDX >= BJRDNB                                      AR1039174
     C                             AND WKOvrdPtype = '4'                                   AR1039174
     C**********         EVAL      W#OverLine = ODLNX                                       BUG27346
     C                   EVAL      W#OverLine = ODLNX * (10**A6NBDP)                        BUG27346
     C                   ENDIF                                                              BUG27566
                                                                                            BUG27566
     C                   ELSE
     C                   EVAL      W#OverLine = *ZERO
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************                     BUG27346
      /EJECT                                                                                BUG27346
      *****************************************************************                     BUG27346
      *                                                               *                     BUG27346
      *  SRGetCurrD - Subroutine that Retrieves Currency Details      *                     BUG27346
      *                                                               *                     BUG27346
      *****************************************************************                     BUG27346
     C     SRGetCurrD    BEGSR                                                              BUG27346
                                                                                            BUG27346
     C                   CALL      'AOCURRR0'                                               BUG27346
     C                   PARM      *BLANKS       @RTCD                                      BUG27346
     C                   PARM      '*KEY   '     @OPTN                                      BUG27346
     C                   PARM                    PCcy                                       BUG27346
     C     SDCURR        PARM      SDCURR        DSSDY                                      BUG27346
                                                                                            BUG27346
     C                   IF        @RTCD <> *BLANKS                                         BUG27346
     C     *LOCK         IN        LDA                                                      BUG27346
     C                   EVAL      DBFILE = 'SDCURRPD'                                      BUG27346
     C                   EVAL      DBKEY = PCcy                                             BUG27346
     C                   EVAL      DBASE = 5                                                BUG27346
     C                   OUT       LDA                                                      BUG27346
     C                   EXSR      *PSSR                                                    BUG27346
     C                   ENDIF                                                              BUG27346
                                                                                            BUG27346
     C                   ENDSR                                                              BUG27346
                                                                                            BUG27346
                                                                                            BUG27346
      *****************************************************************                    AR1055588
      /EJECT                                                                               AR1055588
      *****************************************************************                    AR1055588
      *                                                               *                    AR1055588
      *  SRGetPBInd - Subroutine that Retrieves Private Banking Flag  *                    AR1055588
      *                                                               *                    AR1055588
      *****************************************************************                    AR1055588
     C     SRGetPBInd    BEGSR                                                             AR1055588
                                                                                           AR1055588
     C                   MOVE(P)   F1CNUM        @KEY10           10                       AR1055588
                                                                                           AR1055588
     C                   CALL      'AOCUSTR1'                                              AR1055588
     C                   PARM      *BLANKS       @RTCD                                     AR1055588
     C                   PARM      '*KEY   '     @OPTN                                     AR1055588
     C                   PARM                    @KEY10                                    AR1055588
     C                   PARM                    @KYST             7                       AR1055588
     C     SDCUST        PARM      SDCUST        DSLDY                                     AR1055588
                                                                                           AR1055588
     C                   IF        @RTCD <> *BLANKS                                        AR1055588
     C     *LOCK         IN        LDA                                                     AR1055588
     C                   EVAL      DBFILE = 'SDCUSTPD'                                     AR1055588
     C                   EVAL      DBKEY = F1CNUM                                          AR1055588
     C                   EVAL      DBASE = 8                                               AR1055588
     C                   OUT       LDA                                                     AR1055588
     C                   EXSR      *PSSR                                                   AR1055588
     C                   ENDIF                                                             AR1055588
                                                                                           AR1055588
     C                   ENDSR                                                             AR1055588
                                                                                           AR1055588
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetProcess - Subroutine to assign processing type to use   *
      *                                                               *
      *****************************************************************
     C     SRGetProcess  BEGSR
      *
      ** These fields came from RSACMTL6
      *
     C                   SELECT
     C**********         WHEN      CMOD = 'FT'                                              BUG27625
     C**********         IF        DORC = 0                                                 BUG27625
     C                   WHEN      WkCMOD = 'FT'                                            BUG27625
     C                   IF        WkDORC = 0                                               BUG27625
     C                   EVAL      WProcessType = WKSysFTDR
     C                   ELSE
     C                   EVAL      WProcessType = WKSysFTCR
     C                   ENDIF
     C**********         WHEN      CMOD = 'GL'                                              BUG27625
     C**********                   AND TRYP = 'ME'                                          BUG27625
     C**********         IF        DORC = 0                                                 BUG27625
     C                   WHEN      WkCMOD = 'GL'                                            BUG27625
     C                             AND WkTRYP = 'ME'                                        BUG27625
     C                   IF        WkDORC = 0                                               BUG27625
     C                   EVAL      WProcessType = WKSysGLMEDR
     C                   ELSE
     C                   EVAL      WProcessType = WKSysGLMECR
     C                   ENDIF
     C**********         WHEN      CMOD = 'GL'                                              BUG27625
     C**********                   AND TRYP = 'ZT' AND MTYP = 'S'                           BUG27625
     C**********         IF        DORC = 0                                                 BUG27625
     C                   WHEN      WkCMOD = 'GL'                                            BUG27625
     C                             AND WkTRYP = 'ZT' AND WkMTYP = 'S'                       BUG27625
     C                   IF        WkDORC = 0                                               BUG27625
     C                   EVAL      WProcessType = WKSysGLMESDR
     C                   ELSE
     C                   EVAL      WProcessType = WKSysGLMESCR
     C                   ENDIF
     C**********         WHEN      CMOD = 'GL'                                              BUG27625
     C**********                   AND TRYP = 'ZT' AND MTYP = 'F'                           BUG27625
     C**********         IF        DORC = 0                                                 BUG27625
     C                   WHEN      WkCMOD = 'GL'                                            BUG27625
     C                             AND WkTRYP = 'ZT' AND WkMTYP = 'F'                       BUG27625
     C                   IF        WkDORC = 0                                               BUG27625
     C                   EVAL      WProcessType = WKSysGLMEFDR
     C                   ELSE
     C                   EVAL      WProcessType = WKSysGLMEFCR
     C                   ENDIF
     C**********         WHEN      CMOD = 'SE'                                              BUG27625
     C**********         IF        DORC = 0                                                 BUG27625
     C                   WHEN      WkCMOD = 'SE'                                            BUG27625
     C                   IF        WkDORC = 0                                               BUG27625
     C                   EVAL      WProcessType = WKSysSEDR
     C                   ELSE
     C                   EVAL      WProcessType = WKSysSECR
     C                   ENDIF
     C                   OTHER
     C**********         IF        MTYP = 'S'                                               BUG27625
     C**********         IF        DORC = 0                                                 BUG27625
     C                   IF        WkMTYP = 'S'                                             BUG27625
     C                   IF        WkDORC = 0                                               BUG27625
     C                   EVAL      WProcessType = WKSysOTSDR
     C                   ELSE
     C                   EVAL      WProcessType = WKSysOTSCR
     C                   ENDIF
     C                   ELSE
     C**********         IF        MTYP = 'F'                                               BUG27625
     C**********         IF        DORC = 0                                                 BUG27625
     C                   IF        WkMTYP = 'F'                                             BUG27625
     C                   IF        WkDORC = 0                                               BUG27625
     C                   EVAL      WProcessType = WKSysOTFDR
     C                   ELSE
     C                   EVAL      WProcessType = WKSysOTFCR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRStorSysVal - Subroutine to retrieve and store system values*
      *                                                               *
      *****************************************************************
     C     SRStorSysVal  BEGSR

     C                   CLEAR                   PSysVal
     C                   CLEAR                   PCurSet
      *
     C                   EVAL      PSysVal(1)  = 'ABCFTPaymentsDR'
     C                   EVAL      PSysVal(2)  = 'ABCFTPaymentsCR'
     C                   EVAL      PSysVal(3)  = 'ABCJournalEntryDR'
     C                   EVAL      PSysVal(4)  = 'ABCJournalEntryCR'
     C                   EVAL      PSysVal(5)  = 'ABCSEEventsDR'
     C                   EVAL      PSysVal(6)  = 'ABCSEEventsCR'
     C                   EVAL      PSysVal(7)  = 'ABCAcctfrsameDR'
     C                   EVAL      PSysVal(8)  = 'ABCAcctfrsameCR'
     C                   EVAL      PSysVal(9)  = 'ABCAcctfrfrwdDR'
     C                   EVAL      PSysVal(10) = 'ABCAcctfrfrwdCR'
      *
     C                   EXSR      SrSysValues

      ** Populate Fields array elements 1 to 10

     C                   FOR       X = 1 TO 10
     C                   IF        PCurSet(X) <> *BLANKS
     C                   EVAL      FieldsArr(X) = %TRIM(PCurSet(X))
     C                   ENDIF
     C                   ENDFOR

      ** Set up calling parameters for AOSVALR0
      *
     C                   CLEAR                   PSysVal
     C                   CLEAR                   PCurSet

     C                   EVAL      PSysVal(1)  = 'ABCTransValueDR'
     C                   EVAL      PSysVal(2)  = 'ABCTransValueCR'
     C                   EVAL      PSysVal(3)  = 'ABCTransForwardDR'
     C                   EVAL      PSysVal(4)  = 'ABCTransForwardCR'
     C                   EVAL      PSysVal(5)  = 'ABCNoDaysForward'
     C                   EVAL      PSysVal(6)  = 'ABCOvrdrftPtype'                         AR1039174
     C                   EVAL      PSysVal(7)  = 'ABCHeldItemPtype'                        AR1039177

      ** Get System Values

     C                   ExSr      SrSysValues

      ** Populate Fields array elements 11 to 15

     C                   FOR       X = 1 TO 5
     C                   IF        PCurSet(X) <> *BLANKS
     C                   EVAL      FieldsArr(X+10) = %TRIM(PCurSet(X))
     C                   ENDIF
     C                   ENDFOR
                                                                                           AR1039174
      ** Populate Fields array for Overdraft Line Processing                               AR1039174
                                                                                           AR1039174
     C                   IF        PCurSet(6) <> *BLANKS                                   AR1039174
     C                   EVAL      FieldsArr(16) = %TRIM(PCurSet(6))                       AR1039174
     C                   ENDIF                                                             AR1039174
                                                                                           AR1039177
      ** Populate Fields array for Held Items Processing                                   AR1039177
                                                                                           AR1039177
     C                   IF        PCurSet(7) <> *BLANKS                                   AR1039177
     C                   EVAL      FieldsArr(17) = %TRIM(PCurSet(7))                       AR1039177
     C                   ENDIF                                                             AR1039177
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SrSysValues -  Subroutine to Get System Values                *
      *                                                               *
      *****************************************************************

     C     SrSysValues   BEGSR

     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    PSysVal(1)
     C                   PARM                    PCurSet(1)
     C                   PARM                    PSysVal(2)
     C                   PARM                    PCurSet(2)
     C                   PARM                    PSysVal(3)
     C                   PARM                    PCurSet(3)
     C                   PARM                    PSysVal(4)
     C                   PARM                    PCurSet(4)
     C                   PARM                    PSysVal(5)
     C                   PARM                    PCurSet(5)
     C                   PARM                    PSysVal(6)
     C                   PARM                    PCurSet(6)
     C                   PARM                    PSysVal(7)
     C                   PARM                    PCurSet(7)
     C                   PARM                    PSysVal(8)
     C                   PARM                    PCurSet(8)
     C                   PARM                    PSysVal(9)
     C                   PARM                    PCurSet(9)
     C                   PARM                    PSysVal(10)
     C                   PARM                    PCurSet(10)

      ** Check if database error occured

     C                   FOR       X = 1 TO 10

     C                   IF        PCurSet(X) = '*NRF'
     C                                      OR
     C                             @RTCD <> *BLANKS
     C                               AND @RTCD <> '*NRF'

     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY   = PSysVal(X)
     C                   EVAL      DBFILE  = 'SDSVALPD'
     C                   EVAL      DBASE   = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDFOR

     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY WNCPYSRC,REH00089
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Initialise LDA field.
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     'RE000100'    DBPGM
     C                   OUT       LDA
      *
      ** Key List for ACCNT
      *
     C     KACCNT        KLIST
     C                   KFLD                    WCNUM
     C                   KFLD                    WCCY
     C                   KFLD                    WACOD
     C                   KFLD                    WACSQ
     C                   KFLD                    WBRCA
      *
      ** Key List for GLCOLLLG
      *
     C     KGCOLG        KLIST
     C                   KFLD                    WBRCA
     C                   KFLD                    WCNUM
     C                   KFLD                    WCCY
     C                   KFLD                    WACOD
     C                   KFLD                    WACSQ
      *
      ** Key List for GLCOLLQ0
      *
     C     KGCOQ0        KLIST
     C                   KFLD                    WBRC1
     C                   KFLD                    WXREF
      *
      ** Key List for HELDIL1
      *
     C     KHLDL1        KLIST
     C                   KFLD                    WBRCA
     C                   KFLD                    WCNUM
     C                   KFLD                    WCCY
     C                   KFLD                    WACOD
     C                   KFLD                    WACSQ
      *
      ** Key List for REODHSL0
      *
     C     KROHL0        KLIST
     C                   KFLD                    WBRCA
     C                   KFLD                    WCNUM
     C                   KFLD                    WCCY
     C                   KFLD                    WACOD
     C                   KFLD                    WACSQ
     C                   KFLD                    WHISD
      *
      ** Key List for RSACMTL6
      *
     C     KRSCL6        KLIST
     C                   KFLD                    WBRCA
     C                   KFLD                    WCNUM
     C                   KFLD                    WCCY
     C                   KFLD                    WACOD
     C                   KFLD                    WACSQ
                                                                                            BUG27625
      ** Key List for GLHATML2                                                              BUG27625
                                                                                            BUG27625
     C     KeyHATM       KLIST                                                              BUG27625
     C                   KFLD                    WkTREF                                     BUG27625

     C
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Handle Database Error.
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR details file to determine if Retail Account
      ** Transfer is switched on
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CRE001'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   MOVEL     'N'           CRE001            1
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CRE001
     C                   ELSE
     C     @RTCD         IFNE      '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY = 'CRE001'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
                                                                                              CLE134
      ** Check if CLE134 is ON                                                                CLE134
                                                                                              CLE134
     C                   CALL      'AOSARDR0'                                                 CLE134
     C                   PARM      *BLANK        @RTCD                                        CLE134
     C                   PARM      '*VERIFY'     @OPTN                                        CLE134
     C                   PARM      'CLE134'      @SARD                                        CLE134
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE134
                                                                                              CLE134
     C                   IF        @RTCD = *BLANK                                             CLE134
     C                   EVAL      CLE134 = 'Y'                                               CLE134
     C                   ELSE                                                                 CLE134
     C                   EVAL      CLE134 = 'N'                                               CLE134
     C                   ENDIF                                                                CLE134
      *                                                                                    AR1055588
      ** Call Access Program for Midas Modules                                             AR1055588
      *                                                                                    AR1055588
     C                   CALL      'AOMMODR0'                                              AR1055588
     C                   PARM      *BLANKS       @RTCD                                     AR1055588
     C                   PARM      '*FIRST '     @OPTN                                     AR1055588
     C     SDMMOD        PARM      SDMMOD        DSFDY                                     AR1055588
                                                                                           AR1055588
      ** Handle Database Error.                                                            AR1055588
     C                   IF        @RTCD <> *BLANKS                                        AR1055588
     C     *LOCK         IN        LDA                                                     AR1055588
     C                   EVAL      DBFILE = 'SDMMODPD'                                     AR1055588
     C                   EVAL      DBKEY = @OPTN                                           AR1055588
     C                   EVAL      DBASE = 7                                               AR1055588
     C                   OUT       LDA                                                     AR1055588
     C                   EXSR      *PSSR                                                   AR1055588
     C                   ENDIF                                                             AR1055588
      *
     C/COPY WNCPYSRC,REH00090
      ** Retrieve and Store System Values
     C                   EXSR      SRStorSysVal

      ** Access RUNDAT for multibranching indicator
     C     *DTAARA       DEFINE                  JNSTAT
     C                   IN        JNSTAT

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZSRSRC,ZCHKHLE
     C/COPY ZSRSRC,ZACCHLE
