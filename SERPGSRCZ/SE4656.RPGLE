     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Statement - General details extract')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE4656 - Midas SE Statement - General details Extract        *
      *                                                               *
      *  Function:  This module extracts the general details.         *
      *                                                               *
      *  Called By   : SEC4651 - SE Statement Processing              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. 218078             Date 23May03               *
      *                 CSE040   *CREATE   Date 10Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  218078 - Remove Transalaction table                          *
      *  CSE040 - Securities Statement Processing                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSESDRVL3  UF A E           K DISK    COMMIT       INFSR(*PSSR)
      ** Midas SE Statement - Driver file - Setup FlagRtv
 
     FSESDRVL0  IF   E           K DISK    PREFIX(Ix_)  INFSR(*PSSR)
      ** Midas SE Statement - Driver file by Extract Reference
     F                                     RENAME(SESDRVD0:SESDRVIX)
 
     FCPOSNL2   IF   E           K DISK                 INFSR(*PSSR)
      ** Midas SE Customer Positions by CUST/SESN/BRCA/DATE
 
     FDPOSNL2   IF   E           K DISK                 INFSR(*PSSR)
      ** Midas SE Depot Positions by DEPOT/SESN/BRCA/DATE
 
     FSDSECSL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Securities clients retrieval
 
     FSESTHSL0  IF   E           K DISK    PREFIX(R0_)  INFSR(*PSSR)
      ** Midas SE Statement History by Message Reference
     F                                     RENAME(SESTHSD0:SESTHSR0)
 
     FSESTNXPD  UF A E           K DISK    COMMIT       INFSR(*PSSR)
      ** Midas SE Statement Details for Next Statement
 
     FSETFIHPD  UF A E           K DISK    COMMIT       INFSR(*PSSR)
      ** Midas SE Transaction - Financial Inst Historic
 
     FSEHFINL1  UF   E           K DISK    COMMIT       INFSR(*PSSR)
      ** Midas SE Holding - Financial Instruments
 
     FSEHSBLL1  UF   E           K DISK    COMMIT       INFSR(*PSSR)
      ** Midas SE Holding - Sub-balance
 
     FSETFINL1  UF A E           K DISK    COMMIT       INFSR(*PSSR)
      ** Midas SE Transaction - Financial Instruments
 
     FSETINDL1  UF   E           K DISK    COMMIT       INFSR(*PSSR)
      ** Midas SE Transaction - Transaction Indicator
 
     FSETPRTL1  UF   E           K DISK    COMMIT       INFSR(*PSSR)
      ** Midas SE Transaction - Transaction Party
 
     FSETTRAL1  UF   E           K DISK    COMMIT       INFSR(*PSSR)
      ** Midas SE Transaction - Transaction Details
 
     FSESGENPD  O    E             DISK    COMMIT       INFSR(*PSSR)
      ** Midas SE Statement - General Information
 
     FSESTHSPD  O    E             DISK    PREFIX(HG:2) COMMIT   INFSR(*PSSR)
      ** Midas SE Statement History
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D DSBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS (short) used as output parameter for Access Objects
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS (long) used as output parameter for Access Objects
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** DS (longest) used as output parameter for Access Objects
 
     D WkMsgRef        DS
      ** DS used to retrieve the message reference
     D**WkModId****                   2    INZ('SE')                            Module Id
     D  WkModId                       1    INZ('S')                             Module Id
     D  SPCUST                                                                  SafeKeeping Customer
     D  CurSWIFTDt                    6                                         Current Swift Date
     D**WkMsgSeq***                   2S 0                                      Message Sequence
     D  WkMsgSeq                      3S 0                                      Message Sequence
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D*MaxSwiftLength**S***           5U 0 INZ(10000)                           Max SWIFT Length
     D MaxSwiftLength  S              5U 0 INZ(08000)                           Max SWIFT Length
 
     D @RUN            S              1
     D WkLastRef       S                   LIKE(SPEXTR)                         Extract Reference
     D WkSav1Message   S                   LIKE(HGMREF)                         First Message Refere
     D WkSavMsgSize    S                   LIKE(HGSIZE)                         Save Message Length
 
     D StartDate       S               D   DATFMT(*ISO) INZ(D'1971-12-31')      Start Date
     D WkDate          S               D   DATFMT(*ISO)                         Working Date
 
     D WkFin2Msg       S              1                                         Fin Inst on few msg
     D*WkCust***       S              6S 0                                    Customer Number CSD027
     D WkCust          S              6                                         Customer Numb CSD027
     D WkBrch          S              3                                         Branch Code
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Read Driver file
 
     C     *LOVAL        SETLL     SESDRVL3
     C                   READ      SESDRVL3
     C                   DOW       NOT %EOF(SESDRVL3)
 
     C                   CLEAR                   SESGEND0
 
      ** Increase Extract Reference
 
     C                   EVAL      WkLastRef = WkLastRef + 1
 
      ** Load Request Details
 
     C                   EXSR      $LdReqDtls
 
      ** Specific Processing for Holding
 
     C                   SELECT
     C                   WHEN         SPTYPE = 'TC'                             Trade Date Change
     C                             OR SPTYPE = 'VC'                             Value Date Change
     C                             OR SPTYPE = 'SC'                             Settle Date Change
     C                             OR SPTYPE = 'TF'                             Trade Date Complete
     C                             OR SPTYPE = 'VF'                             Value Date Complete
     C                             OR SPTYPE = 'SF'                             Settle Date Complete
 
     C                   EXSR      $Holding
 
      ** Specific Processing for Transaction
 
     C                   WHEN         SPTYPE = 'MF'                             Movement Full
     C                   EXSR      $Transact
 
     C                   ENDSL
 
      ** Create Last Message
 
     C                   EXSR      $LstMessage
 
     C                   COMMIT
 
      ** Read next request (Driver file).
 
     C     NextRequest   TAG
 
     C                   READ      SESDRVL3
 
     C                   ENDDO
 
     C                   EXSR      $ExitMod
 
      **********************************************************************
      /EJECT
      **********************************************************************
      ** Load Request Details                                              *
      **********************************************************************
     C     $LdReqDtls    BEGSR
 
     C                   EVAL      HGDATE = SPDATE                              Request Date
     C                   EVAL      HGRSEQ = SPRSEQ                              Request Sequence
 
     C                   EVAL      HGMREF = *BLANKS                             Message Reference
     C                   EVAL      HG1MRF = *BLANKS                             First Message Refere
 
     C                   EVAL      HGNWRK = SPNWRK                              Network
     C                   EVAL      HGSNDR = SPSNDR                              Sending Branch
     C                   EVAL      HGORIG = SPORIG                              Originating Branch
     C                   EVAL      HGCUST = SPCUST                              Safekeeping Customer
     C                   EVAL      HGRECP = SPRECP                              Recipient
 
     C                   IF        SPCANC = *BLANKS
     C                   EVAL      HGFCTC = 'NEWM'                              Function Code
     C                   ELSE
     C                   EVAL      HGFCTC = 'CANC'                              Function Code
     C                   ENDIF
 
     C                   EVAL      HGPRTY = SPPRTY                              Priority
     C                   EVAL      HGNOTF = SPNOTF                              Delivery Notificatio
 
     C                   IF        SPR549 <> *BLANKS
     C                   EVAL      HGRLMT = '549'                               Related Message Type
     C                   ENDIF
     C                   EVAL      HGRMSG = SPR549                              Related Message
     C                   EVAL      HGPMCC = SPCANC                              Previous Message Can
 
     C                   EXSR      $RtvStatNb                                   Statement Number
 
     C                   EVAL      HGPGNB = 1                                   Page Number
     C                   EVAL      HGPGIN = 'ONLY'                              Page Indicator
 
     C                   EVAL      HGPRDT = BJRDNB                              Preparation Date
     C                   TIME                    HGPRTM                         Preparation Time
 
     C                   EVAL      HGSAFE = SPCUST                              Safekeeping Account
     C                   EVAL      HGSACT = *BLANKS                             Safekeeping Type
     C                   EVAL      HGTYPE = SPTYPE                              Statement Prod. Type
 
     C                   SELECT                                                 Statement Frequency
     C                   WHEN      SPFREQ = 'Z'
     C                   EVAL      HGSFRE = 'ADHO'                              Ad-Hoc
     C                   WHEN      SPFREQ = 'D'
     C                   EVAL      HGSFRE = 'DAIL'                              Daily
     C                   WHEN      SPFREQ = 'I'
     C                   EVAL      HGSFRE = 'INDA'                              Intra-Day
     C                   WHEN      SPFREQ = 'M'
     C                   EVAL      HGSFRE = 'MNTH'                              Monthly
     C                   WHEN      SPFREQ = 'W'
     C                   EVAL      HGSFRE = 'WEEK'                              Weekly
     C                   WHEN      SPFREQ = 'Y'
     C                   EVAL      HGSFRE = 'YEAR'                              Yearly
     C                   ENDSL
 
     C                   IF           SPTYPE = 'TF'                             Code
     C                             OR SPTYPE = 'VF'
     C                             OR SPTYPE = 'SF'
     C                             OR SPTYPE = 'MF'
     C                   EVAL      HGCODE = 'COMP'                              Complete
     C                   ELSE
     C                   EVAL      HGCODE = 'DELT'                              Delta
     C                   ENDIF
 
     C                   IF        SPTYPE <> 'MF'                               Not MT536 field
     C                   EVAL      HGSTTY = 'CUST'                              Statement Type
     C                   ENDIF
 
     C                   SELECT                                                 Statement Basis
     C                   WHEN      SPTYPE = 'TF' OR SPTYPE = 'TC'
     C                   EVAL      HGSTBA = 'TRAD'                              Trade Date
     C                   WHEN      SPTYPE = 'VF' OR SPTYPE = 'VC'
     C                   EVAL      HGSTBA = 'CONT'                              Value Date
     C                   WHEN      SPTYPE = 'SF' OR SPTYPE = 'SC'
     C                   EVAL      HGSTBA = 'SETT'                              Settle Date
     C                   ENDSL
 
     C                   EVAL      HGMSTD = SPMSTD                              Midas Start Date
     C                   EVAL      HGSTRM = SPSTTM                              Start Time
     C                   IF        SPTYPE = 'MF'                                Only MT536 field
     C                   EVAL      HGMETD = SPMETD                              Midas End Date
     C                   EVAL      HGENTM = SPENTM                              End Time
     C                   ENDIF
 
     C                   EVAL      HGACTI = 'N'                                 Activity Flag
     C                   IF        SPTYPE <> 'MF'                               Not MT536 field
     C                   EVAL      HGAUDT = 'N'                                 Audited Statement
     C                   ENDIF
     C                   EVAL      HGCONS = 'N'                                 Sub-safekeeping Stat
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   EVAL      HGSIZE = HGSIZE                              Static fields
     C                                             + 200                        Block 1/2/5/S
     C                                             + 300                        Static fields
     C                                             + 3 + 15 + 2                 Ccy + Tot Hold Amnt
     C                                             + 16                         Message Reference
     C                                             + %LEN(%TRIM(HG1MRF))        First Message Refere
     C                                             + 4                          Function Code
     C                                             + %LEN(HGSTNB)               Statement Number
     C                                             + %LEN(%CHAR(HGPGNB))        Page Number
     C                                             + 4                          Page Indicator
     C                                             + 8 + 6                      Prep Date/Time
     C                                             + 8 + 6                      Stat Date/Time
     C                                             + %LEN(%TRIM(HGSAFE))        Safekeeping Account
     C                                             + %LEN(%TRIM(HGSACT))        Safekeeping Type
     C                                             + %LEN(HGSFRE)               Statement Frequency
     C                                             + %LEN(HGCODE)               Complete/Delta
     C                                             + %LEN(HGSTTY)               Statement Type
     C                                             + %LEN(HGSTBA)               Statement Basis
     C                                             + %LEN(%TRIM(HGACTI))        Activity Flag
     C                                             + %LEN(%TRIM(HGAUDT))        Audited Statement
     C                                             + %LEN(%TRIM(HGCONS))        Sub-safekeeping Stat
     C                                             + 140                        Sending Branch
 
      ** If related message.
 
     C                   IF        HGRMSG <> *BLANKS
     C                   EVAL      HGSIZE = HGSIZE + 50                         Static fields
     C                                             + %LEN(%TRIM(HGRLMT))        Related Message Type
     C                                             + %LEN(%TRIM(HGRMSG))        Related Message
     C                   ENDIF
 
      ** If Cancellation message.
 
     C                   IF        HGRMSG <> *BLANKS
     C                   EVAL      HGSIZE = HGSIZE + 67                         Static fields
     C                                             + %LEN(%TRIM(HGPMCC))        Previous Message Can
     C                   ENDIF
 
      ** If the Originator is different than the sender,
      ** the originator of the message could have 140 characters long.
 
     C                   IF        HGSNDR <> HGORIG
     C                   EVAL      HGSIZE = HGSIZE + 20                         Static fields
     C                                             + 140                        Originating Branch
     C                   ENDIF
 
      ** Save First Message Reference
 
     C                   EVAL      WkSav1Message = *BLANKS                      First Message Refere
 
      ** Save the current message length
 
     C                   EVAL      WkSavMsgSize = HGSIZE                        Save Message Length
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $Holding   - Specific Processing for Holding                       *
      **********************************************************************
 
     C     $Holding      BEGSR
      *    --------      -----
 
      ** Read holding - Financial Instrument
 
     C     KReqFin       SETLL     SEHFINL1
     C     KReqFin       READE     SEHFINL1
 
     C                   DOW       NOT %EOF(SEHFINL1)
 
     C                   EVAL      HGACTI = 'Y'                                 Activity Flag
 
      ** Verify if the current message details + the new one does not exceed
      ** the maximum length.
 
     C                   IF        HGSIZE + HFSIZE > MaxSwiftLength
     C                   EXSR      $CrtMessage
     C                   ENDIF
 
     C                   EVAL      HGSIZE = HGSIZE + HFSIZE                     Increase Msg Length
 
      ** Update General Information according the holdings
 
     C                   EXSR      $UpdDtlHol
 
      ** Update Extract reference on Financial record
 
     C                   EVAL      HFEXTR = WkLastRef
     C                   UPDATE    SEHFIND0
 
      ** Read SubBalance
 
     C     KReqSbl       SETLL     SEHSBLL1
     C     KReqSbl       READE     SEHSBLL1
 
     C                   DOW       NOT %EOF(SEHSBLL1)
 
      ** Verify if the current message details + the new one does not exceed
      ** the maximum length.
 
     C                   IF        HGSIZE + HSSIZE > MaxSwiftLength
     C                   EXSR      $CrtMessage
     C                   ENDIF
 
     C                   EVAL      HGSIZE = HGSIZE + HSSIZE                     Increase Msg Length
 
      ** Update Extract reference on SubBalance record
 
     C                   EVAL      HSEXTR = WkLastRef
     C                   UPDATE    SEHSBLD0
 
      ** Read next SubBalance
 
     C     KReqSbl       READE     SEHSBLL1
 
     C                   ENDDO
 
      ** Read next holding - Financial Instrument
 
     C     KReqFin       READE     SEHFINL1
 
     C                   ENDDO
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $Transact  - Specific Processing for Transaction                   *
      **********************************************************************
 
     C     $Transact     BEGSR
      *    ---------     -----
 
      ** Read Transaction - Financial Instrument
      *  ---------------------------------------
 
     C     KReqFin       SETLL     SETFINL1
     C     KReqFin       READE     SETFINL1
 
     C                   DOW       NOT %EOF(SETFINL1)
 
     C                   EVAL      WkFin2Msg = 'N'                              Fin Inst on few msg
 
     C                   EVAL      HGACTI = 'Y'                                 Activity Flag
 
      ** Read Transaction Details
      *  ------------------------
 
     C     KReqTran      SETLL     SETTRAL1
     C     KReqTran      READE     SETTRAL1
 
     C                   IF        NOT %EOF(SETTRAL1)
 
      ***Verify*if*the*current*message*details*+*the*new*one*does*not*exceed****
      ***the*maximum*length.*******
      ** Verify if the current message details + the new instrument + the first transaction
      ** do not exceed the maximum length.
 
     C                   IF        HGSIZE + TFSIZE + TTSIZE > MaxSwiftLength
     C                   EXSR      $CrtMessage
     C                   ENDIF
 
     C                   EVAL      HGSIZE = HGSIZE + TFSIZE                     Increase Msg Length
 
      ** Retrieve Last Closing Balance
 
     C                   EXSR      $RtvClosing
 
     C                   DOW       NOT %EOF(SETTRAL1)
 
      ** Verify if the current message details + the new one does not exceed
      ** the maximum length.
 
     C                   IF        HGSIZE + TTSIZE > MaxSwiftLength
 
      ** Update Financial Instrument record
 
     C                   EXSR      $UpdFinInst
 
      ** Create new message
 
     C                   EXSR      $CrtMessage
     C                   ENDIF
 
     C                   EVAL      HGSIZE = HGSIZE + TTSIZE                     Increase Msg Length
 
      ** Calculate Closing Balance
 
     C                   EXSR      $CalClosing
 
      ** Read Transaction Indicators
      *  ---------------------------
 
     C     KReqTrId      SETLL     SETINDL1
     C     KReqTrId      READE     SETINDL1
 
     C                   DOW       NOT %EOF(SETINDL1)
 
      ** The Indicator data length is included in transaction length (see SE4654)
 
      ** Update transaction indicator records
 
     C                   EVAL      TIEXTR = WkLastRef
     C                   UPDATE    SETINDD0
 
      ** Read next transaction indicators
 
     C     KReqTrId      READE     SETINDL1
 
     C                   ENDDO
 
      ** Read Transaction Party
      *  ----------------------
 
     C     KReqTrPr      SETLL     SETPRTL1
     C     KReqTrPr      READE     SETPRTL1
 
     C                   DOW       NOT %EOF(SETPRTL1)
 
      ** The Party data length is included in transaction length (see SE4654)
 
      ** Update transaction indicator records
 
     C                   EVAL      TPEXTR = WkLastRef
     C                   UPDATE    SETPRTD0
 
      ** Read next transaction party
 
     C     KReqTrPr      READE     SETPRTL1
 
     C                   ENDDO
 
      ** Update transaction record
 
     C                   EVAL      TTEXTR = WkLastRef
     C                   UPDATE    SETTRAD0
 
      ** Read Next Transaction Details
 
     C     KReqTran      READE     SETTRAL1
 
     C                   ENDDO
 
     C                   ENDIF
 
      ** Update Financial Instrument record
 
     C                   EVAL      TFCBLC = 'FICL'                              Closing Balance Code
 
     C                   EXSR      $UpdFinInst
 
      ** Update Closing Balance by Financial instrument
 
     C                   EXSR      $UpdClosing
 
      ** Read Transaction - Financial Instrument
 
     C     KReqFin       READE     SETFINL1
 
     C                   ENDDO
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $UpdDtlHol - Update General Information according the holdings     *
      **********************************************************************
     C     $UpdDtlHol    BEGSR
      *    ----------    -----
 
     C                   IF        HFHPCY <> *Blanks
     C                   EVAL      HGCURR = HFHPCY                              Portfolio Currency
     C                   EVAL      HGHSDP = HFHPDP                              Total Hold. Dec. Pos
     C                   EVAL      HGHOLP = HGHOLP + HFHPAM                     Total Holdings Page
     C                   EVAL      HGHOLS = HGHOLS + HFHPAM                     Total Holdings State
     C                   ENDIF
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $RtvClosing  - Retrieve Last Closing Balance by Financial Inst.    *
      **********************************************************************
     C     $RtvClosing   BEGSR
      *    -----------   -----
 
      **   - Network
      **   - Safekeeping Customer number
      **   - Recipient
      **   - Message Type
      **   - Financial Instrument
 
     C     KRtvClosBl    CHAIN(E)  SETFIHPD
 
      ** If no detail exists
 
     C                   IF        NOT %FOUND(SETFIHPD)
 
     C                   EVAL      TFOBAL = *ZEROS                              Opening Balance
     C                   EVAL      TFCBAL = *ZEROS                              Closing Balance
 
      ** Retrieve the total of customer positions the day before the start date.
 
     C                   MOVE      SPCUST        WkCust
 
     C     SPCUST        CHAIN     SDSECSL1
     C                   IF        %FOUND(SDSECSL1)
 
     C                   IF        BFCLAS = 'S'                                 Safe Custody
     C                             OR BFCLAS = 'D'                              Discretionary
 
     C     KRtvPos       SETLL     CPOSNL2
     C                   DOU       %EOF(CPOSNL2)
     C     KRtvPos       READE     CPOSNL2
     C                   IF        NOT %EOF(CPOSNL2)
     C                   IF        CSDA < SPMSTD
     C                   EVAL      TFOBAL = TFOBAL + CSNT                       Nominal - Trade Date
     C                   EVAL      TFCBAL = TFCBAL + CSNT                       Nominal - Trade Date
     C                   EVAL      WkBrch = CSBA                                Branch
     C     KrtvNxPos     SETGT     CPOSNL2
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
     C                   ELSE                                                   Market
 
     C     KRtvPos       SETLL     DPOSNL2
     C                   DOU       %EOF(DPOSNL2)
     C     KRtvPos       READE     DPOSNL2
     C                   IF        NOT %EOF(DPOSNL2)
     C                   IF        DDTE < SPMSTD
     C                   EVAL      TFOBAL = TFOBAL + DSNT                       Nominal - Trade Date
     C                   EVAL      TFCBAL = TFCBAL + DSNT                       Nominal - Trade Date
     C                   EVAL      WkBrch = DSBA                                Branch
     C     KrtvNxPos     SETGT     DPOSNL2
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDIF
     C                   ENDIF
      ** Otherwise,
 
     C                   ELSE
 
     C                   EVAL      TFOBAL = THCBAL                              Opening Balance
     C                   EVAL      TFCBAL = THCBAL                              Closing Balance
 
     C                   ENDIF
 
     C                   EVAL      TFOBLC = 'FIOP'                              Opening Balance Code
     C                   EVAL      TFCBLC = 'INCL'                              Closing Balance Code
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $CalClosing  - Calculate Closing Balance by Financial Inst.        *
      **********************************************************************
     C     $CalClosing   BEGSR
      *    -----------   -----
 
     C                   SELECT
     C                   WHEN      TTINDE = 'D'                                 Decrease
     C                   IF        TTMOVS <> 'REVE'
     C                   EVAL      TFCBAL = TFCBAL - TTPQUA
     C                   ELSE
     C                   EVAL      TFCBAL = TFCBAL + TTPQUA
     C                   ENDIF
     C                   WHEN      TTINDE = 'I'                                 Increase
     C                   IF        TTMOVS <> 'REVE'
     C                   EVAL      TFCBAL = TFCBAL + TTPQUA
     C                   ELSE
     C                   EVAL      TFCBAL = TFCBAL - TTPQUA
     C                   ENDIF
     C                   ENDSL
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $UpdClosing  - Update Last Closing Balance by Financial Inst.      *
      **********************************************************************
     C     $UpdClosing   BEGSR
      *    -----------   -----
 
      **   - Network
      **   - Safekeeping Customer number
      **   - Recipient
      **   - Message Type
      **   - Financial Instrument
 
     C     KRtvClosBl    CHAIN     SETFIHPD
 
      ** If no detail exists
 
     C                   IF        NOT %FOUND(SETFIHPD)
 
     C                   EVAL      THCUST = SPCUST                              Opening Balance
     C                   EVAL      THRECP = SPRECP                              Opening Balance
     C                   EVAL      THTYPE = SPTYPE                              Opening Balance
     C                   EVAL      THSESN = TFSESN                              Opening Balance
     C                   EVAL      THCBAL = TFCBAL                              Opening Balance
     C                   WRITE     SETFIHD0
 
     C                   ELSE
 
      ** Otherwise,
 
     C                   EVAL      THCBAL = TFCBAL                              Opening Balance
     C                   UPDATE    SETFIHD0
 
     C                   ENDIF
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $UpdFinInst - Update Financial Instrument                          *
      **********************************************************************
     C     $UpdFinInst   BEGSR
      *    -----------   -----
 
     C                   EVAL      TFEXTR = WkLastRef
 
      ** Financial Instrument details not reported on previous message
 
     C                   IF        WkFin2Msg = 'N'
     C                   UPDATE    SETFIND0
     C                   EVAL      WkFin2Msg = 'Y'
 
      ** Financial Instrument details reported on previous message
 
     C                   ELSE
     C                   WRITE     SETFIND0
     C                   ENDIF
 
      ** Update Opening Balance
 
     C                   EVAL      TFOBLC = 'INOP'                              Opening Balance Code
     C                   EVAL      TFOBAL = TFCBAL
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $CrtMessage - Create Message                                       *
      **********************************************************************
     C     $CrtMessage   BEGSR
      *    -----------   -----
 
      ** Write General Detail for previous message
 
     C                   EXSR      $RtvMREF                                     Message Reference
     C                   EVAL      HGMREF = WkMsgRef
     C                   EVAL      HGPGIN = 'MORE'                              Page Indicator
     C                   EVAL      HGEXTR = WkLastRef                           Extract Reference
     C                   WRITE     SESGEND0
 
      ** Update Statement History
 
     C                   SELECT
     C                   WHEN         SPTYPE = 'TC'                             Trade Date Change
     C                             OR SPTYPE = 'VC'                             Value Date Change
     C                             OR SPTYPE = 'SC'                             Settle Date Change
     C                             OR SPTYPE = 'TF'                             Trade Date Complete
     C                             OR SPTYPE = 'VF'                             Value Date Complete
     C                             OR SPTYPE = 'SF'                             Settle Date Complete
     C                   EVAL      HGMTYP = '535'
     C                   WHEN         SPTYPE = 'MF'                             Movement Full
     C                   EVAL      HGMTYP = '536'
     C                   ENDSL
     C                   EVAL      HGSTAT = 'PEND'                              Pending
     C                   WRITE     SESTHSD0
 
      ** Update or Write a record in driver file
 
     C                   EVAL      SPEXTR = WkLastRef                           Extract Reference
     C                   EVAL      SPMREF = WkMsgRef                            Message Reference
     C                   EVAL      SPSETF = 'Y'
     C                   IF        HGPGNB = 1                                   Page Number
     C                   UPDATE    SESDRVD0
     C                   ELSE
     C                   WRITE     SESDRVD0
     C                   ENDIF
 
      **Save the first message reference of the statement
 
     C                   IF        WkSav1Message = *BLANKS
     C                   EVAL      WkSav1Message = HGMREF                       Message Reference
     C                   ENDIF
 
      ** Prepare next message
 
     C                   EVAL      HGPGIN = 'LAST'                              Page Indicator
     C                   EVAL      HGPGNB = HGPGNB + 1                          Page Number
     C                   EVAL      WkLastRef = WkLastRef + 1                    Extract Reference
     C                   EVAL      HGMREF = *BLANKS                             Message Reference
     C                   EVAL      HG1MRF = WkSav1Message                       First Message Refere
     C                   EVAL      HGHOLP = *ZEROS                              Total Holdings Page
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   EVAL      HGSIZE = WkSavMsgSize                        Save Message Length
     C                                             + %LEN(%TRIM(HG1MRF))        First Message Ref
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LstMessage - Create Last Message                                  *
      **********************************************************************
     C     $LstMessage   BEGSR
      *    -----------   -----
 
      ** Write General Detail for previous message
 
     C                   EXSR      $RtvMREF                                     Message Reference
     C                   EVAL      HGMREF = WkMsgRef
     C                   EVAL      HGEXTR = WkLastRef                           Extract Reference
     C                   WRITE     SESGEND0
 
      ** Update Statement History
 
     C                   SELECT
     C                   WHEN         SPTYPE = 'TC'                             Trade Date Change
     C                             OR SPTYPE = 'VC'                             Value Date Change
     C                             OR SPTYPE = 'SC'                             Settle Date Change
     C                             OR SPTYPE = 'TF'                             Trade Date Complete
     C                             OR SPTYPE = 'VF'                             Value Date Complete
     C                             OR SPTYPE = 'SF'                             Settle Date Complete
     C                   EVAL      HGMTYP = '535'
     C                   WHEN         SPTYPE = 'MF'                             Movement Full
     C                   EVAL      HGMTYP = '536'
     C                   ENDSL
     C                   EVAL      HGSTAT = 'PEND'                              Pending
     C                   WRITE     SESTHSD0
 
      ** Update or Write a record in driver file
 
     C                   EVAL      SPEXTR = WkLastRef                           Extract Reference
     C                   EVAL      SPMREF = WkMsgRef                            Message Reference
     C                   EVAL      SPSETF = 'Y'
     C                   IF        HGPGNB = 1                                   Page Number
     C                   UPDATE    SESDRVD0
     C                   ELSE
     C                   WRITE     SESDRVD0
     C                   ENDIF
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $RtvMREF  - Retrieve Message Reference                             *
      **********************************************************************
 
     C     $RtvMREF      BEGSR
      *    ---------     -----
 
      ** The message reference is:
      **    - Module Id 'SE'                 -> WkModId
      **    - Safekeeping Customer Number    -> SPCUST
      **    - System Rundate in SWIFT format -> CurSWIFTDt
      **    - Sequence                       -> WkMsgSeq
 
      ** To retrieve the new number, retrieve the last one of the day
      ** and add 1 to the sequence.
 
      ** Retrieve the last message for the Customer
 
     C                   EVAL      WkMsgSeq = 999
     C     WkMsgRef      SETGT     SESTHSL0
     C                   READP     SESTHSL0
 
      ** No message
 
     C                   IF        %EOF(SESTHSL0)
     C                   EVAL      WkMsgSeq = 001
     C                   ELSE
 
      ** No message for the Customer today
 
     C                   IF        %SUBST(R0_SHMREF:2:6) <> SPCUST
     C                             OR %SUBST(R0_SHMREF:8:6) <> CurSWIFTDt
     C                   EVAL      WkMsgSeq = 001
     C                   ELSE
 
      ** Message for the Customer
 
     C                   MOVE      R0_SHMREF     WkMsgSeq
     C                   IF        WkMsgSeq = 999
     C                   EVAL      WkMsgSeq = 001
     C                   ELSE
     C                   EVAL      WkMsgSeq = WkMsgSeq + 1
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $RtvStatNb - Retrieve Statement Number                             *
      **********************************************************************
 
     C     $RtvStatNb    BEGSR
      *    ----------    -----
 
      ** The statement number is unique by:
      **   - Safekeeping Customer number
      **   - Recipient
      **   - Message Type
 
     C     KRtvStatNb    CHAIN     SESTNXPD                                     Statement Number
 
      ** If first message.
 
     C                   IF        NOT %FOUND(SESTNXPD)
 
      ** Statement Number
 
     C                   EVAL      HGSTNB = 1
 
      ** Write details for next processing
 
     C                   EVAL      NXCUST = SPCUST                              Safekeeping Customer
     C                   EVAL      NXRECP = SPRECP                              Recipient
     C                   EVAL      NXTYPE = SPTYPE                              Statement Production
     C                   EVAL      NXSTNB = HGSTNB                              Last Statement Numb.
     C                   WRITE     SESTNXD0
 
     C                   ELSE
 
      ** For message 'Complete', the statement number has only 3 digits
 
     C                   IF           SPTYPE = 'TF'                             Code
     C                             OR SPTYPE = 'VF'
     C                             OR SPTYPE = 'SF'
     C                             OR SPTYPE = 'MF'
     C                   IF        NXSTNB = 999
     C                   EVAL      HGSTNB = 1
     C                   ELSE
     C                   EVAL      HGSTNB = NXSTNB + 1
     C                   ENDIF
 
      ** Otherwise,
 
     C                   ELSE
     C                   IF        NXSTNB = 99999
     C                   EVAL      HGSTNB = 1
     C                   ELSE
     C                   EVAL      HGSTNB = NXSTNB + 1
     C                   ENDIF
     C                   ENDIF
 
      ** Update details for next processing
 
     C                   EVAL      NXSTNB = HGSTNB                              Last Statement Numb.
     C                   UPDATE    SESTNXD0
 
     C                   ENDIF
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $ExitMod  - Exit from the module                                   *
      **********************************************************************
 
     C     $ExitMod      BEGSR
      *    ---------     -----
 
     C                   MOVE      *On           *INLR
     C                   RETURN
 
      *                  -----
     C                   ENDSR
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
      *    ------        -----
 
     C     *entry        PLIST
     C                   PARM                    ReturnCode
 
      ** Access Bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     DSBANK        PARM      DSBANK        DSFDY
 
      ** Current Date in SWIFT format
      *
     C     StartDate     ADDDUR    BJRDNB:*D     WkDate                         Current Date
     C     *YMD0         MOVE      WkDate        CurSWIFTDt                     Curr. Date YYMMDD
 
      ** Initialize LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  PSProcName
     C                   OUT       LDA
 
      ** Retrieve the last Extract Reference used
 
     C     *HIVAL        SETGT     SESDRVL0
     C                   READP     SESDRVL0
     C                   IF        %EOF(SESDRVL0)
     C                   EVAL      WkLastRef = *ZEROS
     C                   ELSE
     C                   EVAL      WkLastRef = Ix_SPEXTR
     C                   ENDIF
 
      ** Key to access Holding - Financial Instrument
 
     C     KReqFin       KLIST
     C                   KFLD                    SPDATE
     C                   KFLD                    SPRSEQ
 
      ** Key to access holding - Sub-balance
 
     C     KReqSbl       KLIST
     C                   KFLD                    SPDATE
     C                   KFLD                    SPRSEQ
     C                   KFLD                    HFSESN
 
      ** Key to access Transaction - Transaction
 
     C     KReqTran      KLIST
     C                   KFLD                    SPDATE
     C                   KFLD                    SPRSEQ
     C                   KFLD                    TFSESN
 
      ** Key to access Transaction - Transaction Indicator
 
     C     KReqTrId      KLIST
     C                   KFLD                    SPDATE
     C                   KFLD                    SPRSEQ
     C                   KFLD                    TFSESN
     C                   KFLD                    TTTSEQ
 
      ** Key to access Transaction - Transaction Party
 
     C     KReqTrPr      KLIST
     C                   KFLD                    SPDATE
     C                   KFLD                    SPRSEQ
     C                   KFLD                    TFSESN
     C                   KFLD                    TTTSEQ
 
      ** Key to retrieve Last Statement Number
 
     C     KRtvStatNb    KLIST
     C                   KFLD                    SPCUST                         Safekeeping Customer
     C                   KFLD                    SPRECP                         Recipient
     C                   KFLD                    SPTYPE                         Type of Statement
 
      ** Key to retrieve Last Closing Balance
 
     C     KRtvClosBl    KLIST
     C                   KFLD                    SPCUST                         Safekeeping Customer
     C                   KFLD                    SPRECP                         Recipient
     C                   KFLD                    SPTYPE                         Type of Statement
     C                   KFLD                    TFSESN                         Financial Instrument
 
      ** Keys to retrieve Opening Balance
 
     C     KRtvPos       KLIST
     C                   KFLD                    WkCust                         Safekeeping Customer
     C                   KFLD                    TFSESN                         Financial Instrument
 
     C     KRtvNxPos     KLIST
     C                   KFLD                    WkCust                         Safekeeping Customer
     C                   KFLD                    TFSESN                         Financial Instrument
     C                   KFLD                    WkBrch                         Branch
 
      *                  -----
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
      *    -----         -----
 
     C                   DUMP
 
     C                   EVAL      ReturnCode = '*ERROR*'
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *                  -----
     C                   ENDSR
 
      ********************************************************************
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2003
