     H DEBUG
     H COPYRIGHT('(C) Copyright Misys International Banking Systems Ltd. 2021')
      *========================================================================*
/*STD *  RPGBASEMOD                                                            *
      *========================================================================*
      *                                                                        *
      *  Midas - Securities Trading Module                                     *
      *                                                                        *
      *  RPGLE/SE4655 - Midas SE Pending Transactions Extract                  *
      *                                                                        *
      *  Function:  This module extracts the details of Pending Transactions   *
      *                                                                        *
      *  Called By   : SEC4651 - SE Statement Processing                       *
      *  Component of: SP9SE0001                                               *
      *                                                                        *
      *  (C) Copyright Finastra International Banking Systems Ltd. 2021        *
      *                                                                        *
      *  Last Amend No. 252259             Date 10Mar21                        *
      *  Prev Amend No. CSW207             Date 10Mar21                        *
      *                 CSE040   *Create   Date 10Mar21                        *
      *                                                                        *
      *   ------------------------------------------------------------------   *
      *                                                                        *
      *  252259 - MT537 are Nacked,                                            *
      *           For DVP/RVP, load pay amount in all cases                    *
      *           For Contractual transaction, report transaction to client    *
      *           only between trade date and value date.                      *
      *  CSW207 - SWIFT 2007 Standard Changes                                  *
      *  CSE040 - Securities Statement Processing                              *
      *           Applied for MD-55740                                         *
      *                                                                        *
      **************************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSESDRVL8  UF   E           K DISK    COMMIT       INFSR(*PSSR)
      ** Midas SE Holding - Driver file by Request

     FTRADCL1   IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Ccy and history trades by cust/sec/brch
     F                                     INFDS(INFDS1)
     F                                     IGNORE(POSETDF)
     F                                     RENAME(SEDVPRD0:ClDVPRD0)

     FTRADCL2   IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Ccy and history trades by depot/sec/brch
     F                                     INFDS(INFDS2)
     F                                     IGNORE(POSETDF)

     FTRADCL3   IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Ccy and history trades by cust/portfolio/sec/brch
     F                                     INFDS(INFDS3)
     F                                     IGNORE(POSETDF)
     F                                     RENAME(TRADSDF :CPTRADSD)
     F                                     RENAME(HSTTRDF :CPHSTTRD)
     F                                     RENAME(DPTMVDF :CPDPTMVD)
     F                                     RENAME(SEDVPRD0:CPSEDVPR)

     FTRADS     IF   E           K DISK    INFSR(*PSSR) PREFIX(Rtv_)
      ** Midas SE Trades
     F                                     RENAME(TRADSDF:Rtv_TRADS)

     FSETRADL5  IF   E           K DISK    INFSR(*PSSR) PREFIX(RL4_)
      ** Midas SE Trades by Bulk Reference
     F                                     RENAME(TRADSDF:RL4_TRADS)
     F                                     RENAME(HSTTRDF:RL4_HSTTR)

     FTRADSDL9  IF   E           K DISK    INFSR(*PSSR) PREFIX(RL9_)
      ** Midas SE Trade details by order number

     FSDSECSL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Securities clients retrieval

     FSECTY     IF   E           K DISK    INFSR(*PSSR) PREFIX(Se_)
      ** Midas Security Details

     FSETLE     IF   E           K DISK    INFSR(*PSSR) PREFIX(Ts_)
      ** Midas SE Trades Settlement

     F*SEDVSTL6  IF   E           K DISK    INFSR(*PSSR) PREFIX(Ds_)
      ** Midas SE DVP/RVP Settlements by Reference/Sequence

     FSEMVTSL2  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Movements Status - Main Key

     FPMPORTLL  IF   E           K DISK    INFSR(*PSSR)
      ** Midas PM Live portfolio definition details
      *
     FSEPPRTPD  O    E             DISK    COMMIT       INFSR(*PSSR)
      ** Midas SE Pending Trans - Transaction Party
      *
     FSEPINDPD  O    E             DISK    COMMIT       INFSR(*PSSR)
      ** Midas SE Pending Trans - Transaction Indicator
      *
     FSEPSTAPD  O    E             DISK    COMMIT       INFSR(*PSSR)
      ** Midas SE Pending Trans - Status Details
      *
     FSEPTRAPD  O    E             DISK    COMMIT       INFSR(*PSSR)
      ** Midas SE Pending Trans - Transaction Details
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
?    D/COPY ZACPYSRC,STD_D_SPEC

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

      ** Array for Portfolio processed
     D ArrPTFR         S              4    DIM(999)

      ** Decision Table
     D TbArgmt         S             18    DIM(157) CTDATA PERRCD(1)
     D TbResult        S             11    DIM(157) ALT(TbArgmt)

      ** SWIFT Status Qualifier
     D*SWStsQu******   S              4    DIM(3) CTDATA PERRCD(3)                       CSW207
     D SWStsQu         S              4    DIM(4) CTDATA PERRCD(4)                       CSW207

     D DSBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details

     D*DSGELR        E DS                  EXTNAME(SDGELRPD)
      ** General Ledger Details

     D DSSTRD        E DS                  EXTNAME(SDSTRDPD)
      ** Securities trading ICD data

     D DSCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details

     D DSCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Customer Details

     D DSBOOK        E DS                  EXTNAME(SDBOOKPD)
      ** Book Details

     D INFDS1          DS
      ** File information data structure.
     D   RcdFmt1         *RECORD

     D INFDS2          DS
      ** File information data structure.
     D   RcdFmt2         *RECORD

     D INFDS3          DS
      ** File information data structure.
     D   RcdFmt3         *RECORD

     D TrStatus        DS                  OCCURS(999)
      ** Transaction Status
     D   WkMvmDat                     5  0                                      Movement Date
     D   WkSWIFTQual                  4                                         SWIFT Qualifier
     D   WkSWIFTCod                   4                                         SWIFT Code
     D   WkReasQual                   4                                         Reason Qualifier
     D   WkReasCod                    4                                         Reason Code
     D   WkReasNar                  210                                         Reason Narrative

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS (short) used as output parameter for Access Objects

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS (long) used as output parameter for Access Objects

     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** DS (longest) used as output parameter for Access Objects

     D DsArgmt         DS
      ** DS to define the argument to search in decision table
      *
      ** Customer Class (Client/Market)
     D   WkCnumClass                  1
     D   WkA1                         1    INZ(' ')                             Filler
      *
      ** Transaction type
     D   WkTransType                  2
     D   WkA2                         1    INZ(' ')                             Filler
      *
      ** Counterparty Class or Beneficiary Class (Client/Market)
     D   WkCountClass                 1
     D   WkA3                         1    INZ(' ')                             Filler
      *
      ** Deliver To or In Depot (X/ )
     D   WkInCust                     1
     D   WkA4                         1    INZ(' ')                             Filler
      *
      ** Deliver From or Out Depot (X/ )
     D   WkOutCust                    1
     D   WkA5                         1    INZ(' ')                             Filler
      *
      ** Relation between Deliver From/To or In/Out Depot (=/<>/ )
     D   WkRelation                   2
     D   WkA6                         1    INZ(' ')                             Filler
      *
      ** Leg of depot (IN/OUT/  )
     D   WkLeg                        3
     D   WkA7                         1    INZ(' ')                             Filler

     D DsResult        DS
      ** DS to define the result of the search in decision table
      *
      ** Report (Y/N)
     D   WkReport                     1
     D   WkR1                         1    INZ(' ')                             Filler
      *
      ** Decrease/Increase indicator (D/I/ )
     D   WkDeInInd                    1
     D   WkR2                         1    INZ(' ')                             Filler
      *
      ** Position type (Customer/User/Our/ )
     D   WkPositType                  1
     D   WkR3                         1    INZ(' ')                             Filler
      *
      ** Transaction (Trade/Depot/    )
     D   WkTrans                      5

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D WkRcdFmt        S              8                                         Record Format

     D WTran2Rpt       S              1                                         Transact. to report

     D WkActy          S              1                                         Activity Flag
     D WPrPTFR         S                   LIKE(TR_PTFR)                        Portfolio
     D SvPTFR          S                   LIKE(TR_PTFR)                        Portfolio
     D*WPrSfSafe       S                   LIKE(SfSafeAccnt)                    Prv Safekeep
     D WkSubSeq        S              3  0                                      Subsafe Seq.
     D WTrnBySub       S              5U 0                                      Trans. Seq by Subsaf

     D WkCust          S              6                                         Customer Number
     D WkCustClass     S              1                                         Customer Class
     D WkCountCust     S              6                                         Count/Benef. Custome
     D WkBBCSID        S                   LIKE(BBCSID)                         Save 1 address

     D WkNMCY          S              3                                         Nominal Currency
     D WkNMDP          S              1  0                                      Nominal Decimal Pos.
     D WkSTCY          S              3                                         Settlement Currency
     D WkSTDP          S              1  0                                      Settl. Decimal Pos.

     D WkCONM          S             11  0                                      Client Outst. Nom.
     D WkPONM          S             11  0                                      CParty Outst. Nom.
     D WkCOVL          S             15  0                                      Client Outst. Value
     D WkPOVL          S             15  0                                      CParty Outst. Value

     D IdS             S              5U 0                                      Status index
     D Idx             S              5U 0
     D Idy             S              5U 0
     D IdxPTFR         S              5U 0                                      PTFR Index

     D @RUN            S              1

     ITRADSDF
     I              RECI                        TR_RECI                         Record ID
     I              TDRF                        TR_REF                          Trade Reference
     I              TDSS                        TR_SESN                         Security
     I              TDTP                        TR_TYPE                         Transaction Type
     I              TCNR                        TR_COBE                         CounterPart/Benefic.
     I              LCD                         TR_LCD                          Last change date
     I              TDBA                        TR_BRCA                         Branch
     I              PTFR                        TR_PTFR                         Portfolio ref

     IHSTTRDF
     I              RECI                        TR_RECI                         Record ID
     I              TDRF                        TR_REF                          Trade Reference
     I              TDSS                        TR_SESN                         Security
     I              TDTP                        TR_TYPE                         Transaction Type
     I              TCNR                        TR_COBE                         CounterPart/Benefic.
     I              LCD                         TR_LCD                          Last change date
     I              TDBA                        TR_BRCA                         Branch
     I              PTFR                        TR_PTFR                         Portfolio ref

     IDPTMVDF
     I              RECI                        TR_RECI                         Record ID
     I              DPRN                        TR_REF                          Reference
     I              DPSS                        TR_SESN                         Security
     I              DPMV                        TR_TYPE                         Transaction Type
     I              DPBN                        TR_COBE                         CounterPart/Benefic.
     I              LCD                         TR_LCD                          Last change date
     I              DPBA                        TR_BRCA                         Branch
     I              PTFR                        TR_PTFR                         Portfolio ref

     IClDVPRD0
     I              DVRECI                      TR_RECI                         Record ID
     I              DVREF                       TR_REF                          Movement Reference
     I              DVSESN                      TR_SESN                         Security
     I              DVTYPE                      TR_TYPE                         Transaction Type
     I              DVCNUM                      TR_COBE                         CounterPart/Benefic.
     I              DVLCD                       TR_LCD                          Last change date
     I              DVBRCA                      TR_BRCA                         Branch
     I              DVPTFR                      TR_PTFR                         Portfolio ref

     ITRADTO
     I              RECI                        TR_RECI                         Record ID
     I              TDRF                        TR_REF                          Trade Reference
     I              TDSS                        TR_SESN                         Security
     I              TDTP                        TR_TYPE                         Transaction Type
     I              TCNR                        TR_COBE                         CounterPart/Benefic.
     I              LCD                         TR_LCD                          Last change date
     I              TDBA                        TR_BRCA                         Branch
     I              PTFR                        TR_PTFR                         Portfolio ref

     ITRADFR
     I              RECI                        TR_RECI                         Record ID
     I              TDRF                        TR_REF                          Trade Reference
     I              TDSS                        TR_SESN                         Security
     I              TDTP                        TR_TYPE                         Transaction Type
     I              TCNR                        TR_COBE                         CounterPart/Benefic.
     I              LCD                         TR_LCD                          Last change date
     I              TDBA                        TR_BRCA                         Branch
     I              PTFR                        TR_PTFR                         Portfolio ref

     IHSTTRTO
     I              RECI                        TR_RECI                         Record ID
     I              TDRF                        TR_REF                          Trade Reference
     I              TDSS                        TR_SESN                         Security
     I              TDTP                        TR_TYPE                         Transaction Type
     I              TCNR                        TR_COBE                         CounterPart/Benefic.
     I              LCD                         TR_LCD                          Last change date
     I              TDBA                        TR_BRCA                         Branch
     I              PTFR                        TR_PTFR                         Portfolio ref

     IHSTTRFR
     I              RECI                        TR_RECI                         Record ID
     I              TDRF                        TR_REF                          Trade Reference
     I              TDSS                        TR_SESN                         Security
     I              TDTP                        TR_TYPE                         Transaction Type
     I              TCNR                        TR_COBE                         CounterPart/Benefic.
     I              LCD                         TR_LCD                          Last change date
     I              TDBA                        TR_BRCA                         Branch
     I              PTFR                        TR_PTFR                         Portfolio ref

     IDPTMVIN
     I              RECI                        TR_RECI                         Record ID
     I              DPRN                        TR_REF                          Reference
     I              DPSS                        TR_SESN                         Security
     I              DPMV                        TR_TYPE                         Transaction Type
     I              DPBN                        TR_COBE                         CounterPart/Benefic.
     I              LCD                         TR_LCD                          Last change date
     I              DPBA                        TR_BRCA                         Branch
     I              PTFR                        TR_PTFR                         Portfolio ref

     IDPTMVOU
     I              RECI                        TR_RECI                         Record ID
     I              DPRN                        TR_REF                          Reference
     I              DPSS                        TR_SESN                         Security
     I              DPMV                        TR_TYPE                         Transaction Type
     I              DPBN                        TR_COBE                         CounterPart/Benefic.
     I              LCD                         TR_LCD                          Last change date
     I              DPBA                        TR_BRCA                         Branch
     I              PTFR                        TR_PTFR                         Portfolio ref

     ISEDVPRD0
     I              DVRECI                      TR_RECI                         Record ID
     I              DVREF                       TR_REF                          Movement Reference
     I              DVSESN                      TR_SESN                         Security
     I              DVTYPE                      TR_TYPE                         Transaction Type
     I              DVCNUM                      TR_COBE                         CounterPart/Benefic.
     I              DVLCD                       TR_LCD                          Last change date
     I              DVBRCA                      TR_BRCA                         Branch
     I              DVPTFR                      TR_PTFR                         Portfolio ref

     ICPTRADSD
     I              RECI                        TR_RECI                         Record ID
     I              TDRF                        TR_REF                          Trade Reference
     I              TDSS                        TR_SESN                         Security
     I              TDTP                        TR_TYPE                         Transaction Ty
     I              TCNR                        TR_COBE                         CounterPart/Be
     I              LCD                         TR_LCD                          Last change da
     I              TDBA                        TR_BRCA                         Branch
     I              PTFR                        TR_PTFR                         Portfolio ref

     ICPHSTTRD
     I              RECI                        TR_RECI                         Record ID
     I              TDRF                        TR_REF                          Trade Reference
     I              TDSS                        TR_SESN                         Security
     I              TDTP                        TR_TYPE                         Transaction Ty
     I              TCNR                        TR_COBE                         CounterPart/Be
     I              LCD                         TR_LCD                          Last change da
     I              TDBA                        TR_BRCA                         Branch
     I              PTFR                        TR_PTFR                         Portfolio ref

     ICPDPTMVD
     I              RECI                        TR_RECI                         Record ID
     I              DPRN                        TR_REF                          Reference
     I              DPSS                        TR_SESN                         Security
     I              DPMV                        TR_TYPE                         Transaction Ty
     I              DPBN                        TR_COBE                         CounterPart/Be
     I              LCD                         TR_LCD                          Last change da
     I              DPBA                        TR_BRCA                         Branch
     I              PTFR                        TR_PTFR                         Portfolio ref

     ICPSEDVPR
     I              DVRECI                      TR_RECI                         Record ID
     I              DVREF                       TR_REF                          Movement Reference
     I              DVSESN                      TR_SESN                         Security
     I              DVTYPE                      TR_TYPE                         Transaction Ty
     I              DVCNUM                      TR_COBE                         CounterPart/Be
     I              DVLCD                       TR_LCD                          Last change da
     I              DVBRCA                      TR_BRCA                         Branch
     I              DVPTFR                      TR_PTFR                         Portfolio ref

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
      *  ----------------

     C     *LOVAL        SETLL     SESDRVL8
     C                   READ      SESDRVL8
     C                   DOW       NOT %EOF(SESDRVL8)

     C                   EVAL      WkRcdFmt = *Blanks                           Current format Read
     C                   EVAL      WPrPTFR  = *Blanks                           Prv Portfolio
     C                   MOVE      SPCUST        WkCust                         Customer

     C                   EVAL      WkSubSeq    = 1                              SubSafe Seq
      *
     C                   CLEAR                   ArrPTFR
     C                   EVAL      IdxPTFR = *Zeros

      ** If cancellation, do not extract the holding

     C                   IF        SPCANC <> *Blanks
     C                   GOTO      EndExtract
     C                   ENDIF

      ** Retrieve the Customer Class of the Safekeeping Customer.
      *  --------------------------------------------------------

     C     SPCUST        CHAIN     SDSECSL1
     C                   IF        NOT %FOUND(SDSECSL1)
     C                   GOTO      NextRequest
     C                   ENDIF

     C                   IF        BFCLAS = 'S'                                 Safe Custody
     C                             OR BFCLAS = 'D'                              Discretionary
     C                   EVAL      WkCustClass = 'C'                            Client
     C                   ELSE
     C                   EVAL      WkCustClass = 'M'                            Market
     C                   ENDIF

      ** Position in transactions files

     C                   EXSR      $PosTrns

      ** Read transaction files

     C                   EXSR      $ReadTrns

      ** Main Loop

     C                   DOW       NOT *IN30

      ** Check if the transaction has to be reported.

     C                   CLEAR                   DsArgmt
     C                   CLEAR                   DsResult

     C     1             DO        2

     C                   EXSR      $CheckTrns

     C                   SELECT

      **   If transaction has not be reported due to exclusion details

     C                   WHEN      WTran2Rpt = 'N'
     C                             AND DsArgmt = *Blanks
     C                   LEAVE

      **   If transaction has not be reported due to Conditional details

     C                   WHEN      WTran2Rpt = 'N'
     C                   ITER
     C                   ENDSL

      ** Load SubSafe Details
      *
     C                   EVAL      WkActy = 'Y'
     C                   EVAL      SvPTFR = TR_PTFR                             Portfolio

      ** Load transaction details

     C                   EXSR      $LdTransact

     C                   ENDDO

      ** Read next transaction according the Safekeeping Customer Classe.

     C                   EXSR      $ReadTrns

     C                   ENDDO

     C     EndExtract    TAG

      ** Update Drive file

     C                   EVAL      SPEXTF = 'Y'
     C                   UPDATE    SESDRVD0
     C                   COMMIT

      ** Read next request (Driver file).

     C     NextRequest   TAG

     C                   READ      SESDRVL8

     C                   ENDDO

     C                   EXSR      $ExitMod

      **********************************************************************
      /EJECT
      **********************************************************************
      * $PosTrns  - Position in transactions files                         *
      **********************************************************************

     C     $PosTrns      BEGSR
      *    --------      -----
      *
      ** According the request details, position in transaction files.
      *
     C                   SELECT
      *
      ** No specific selection
      *
     C                   WHEN          SPSESN =  *Blanks
      *
     C                   IF        WkCustClass = 'C'
     C     WkCust        SETLL     TRADCL1                                      Client
     C                   ELSE
     C     WkCust        SETLL     TRADCL2                                      Market
     C                   ENDIF
      *
      ** No Portfolio / Security
      *
     C                   WHEN          SPSESN <> *Blanks
      *
     C                   IF        WkCustClass = 'C'
     C     KCustSec      SETLL     TRADCL1                                      Client
     C                   ELSE
     C     KCustSec      SETLL     TRADCL2                                      Market
     C                   ENDIF
      *
     C                   ENDSL
      *
      *                  -----
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      * $ReadTrns - Read transaction files                                 *
      **********************************************************************

     C     $ReadTrns     BEGSR
      *    ---------     -----
      *
      ** According the request details, read transaction files.
      *
     C                   SELECT
      *
      ** No specific selection
      *
     C                   WHEN          SPSESN =  *Blanks
      *
     C                   IF        WkCustClass = 'C'
     C     WkCust        READE     TRADCL1                                30    Client
     C                   EVAL      WkRcdFmt = RcdFmt1
     C                   ELSE
     C     WkCust        READE     TRADCL2                                30    Market
     C                   EVAL      WkRcdFmt = RcdFmt2
     C                   ENDIF
      *
      ** No Portfolio / Security
      *
     C                   WHEN          SPSESN <> *Blanks
      *
     C                   IF        WkCustClass = 'C'
     C     KCustSec      READE     TRADCL1                                30    Client
     C                   EVAL      WkRcdFmt = RcdFmt1
     C                   ELSE
     C     KCustSec      READE     TRADCL2                                30    Market
     C                   EVAL      WkRcdFmt = RcdFmt2
     C                   ENDIF
      *
      ** All Portfolios
      *
      *
     C                   ENDSL
      *
      *                  -----
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      * $CheckTrns - Check if the transaction has to be reported.          *
      **********************************************************************

     C     $CheckTrns    BEGSR
      *    ----------    -----

      ** Default result of transaction check

     C                   EVAL      WTran2Rpt = 'N'

      ** First call
      *  ==========

     C                   IF        DsArgmt = *Blanks

      ** Exclusion transastion details
      *  -----------------------------

      ** If Security is specified,
      ** process only this one.

     C                   IF        SPSESN <> *BLANKS
     C                             AND SPSESN <> TR_SESN

      ** Process only authorized transactions

     C                             OR TR_RECI = 'L'
     C                             OR TR_RECI = 'P'
     C                             OR TR_RECI = '*'

     C                   EVAL      WTran2Rpt = 'N'
     C                   LEAVESR
     C                   ENDIF


      ** Conditional transastion details
      *  -------------------------------

      ** Retrieve the Customer Class

     C                   EVAL      WkCnumClass = WkCustClass

      ** Retrieve the transaction type

     C                   EVAL      WkTransType = TR_TYPE

      ** Retrieve the Class of the Counterparty trade or the Beneficiary Depot

      **   If the customer of the request has a class 'S' ro 'D', the processing considers
      **   only the transactions where the customer is the Counterparty of the trade or the
      **   Beneficiary of the depot.
      **   Thus, the class of the Counterparty/Beneficiary is already known.

     C                   IF        WkCustClass = 'C'                            Client
     C                   EVAL      WkCountClass = WkCustClass
     C                   ELSE

      **   Otherwise, the processing considers only the transactions where the customer is
      **   the Deliver To/From of trade, or In Depot/Out Depot of depot

     C                   MOVE      TR_COBE       WkCountCust                    Count/Benef. Cust.
     C     WkCountCust   CHAIN     SDSECSL1
     C                   IF        NOT %FOUND(SDSECSL1)
     C                   CLEAR                   DsArgmt
     C                   LEAVESR
     C                   ENDIF

     C                   SELECT
     C                   WHEN      BFCLAS = 'S'                                 Safe Custody
     C                             OR BFCLAS = 'D'                              Discretionary
     C                   EVAL      WkCountClass = 'C'                           Client
     C                   WHEN      BFCLAS = 'I'                                 Internal Cust.
     C                   EVAL      WkCountClass = 'I'                           Market
     C                   OTHER
     C                   EVAL      WkCountClass = 'M'                           Market
     C                   ENDSL
     C                   ENDIF

      ** Retrieve if the Customer is the Deliver To or In Depot
      **   For customer with a Class 'S' or 'D', the Deliver To and In Depot are not considered.

     C                   EVAL      WkInCust     = *Blanks
     C                   IF        WkCustClass  = 'M'                           Market
     C                   IF            WkRcdFmt = 'TRADTO'                      Deliver To
     C                             OR  WkRcdFmt = 'HSTTRTO'                     Deliver To
     C                             OR  WkRcdFmt = 'DPTMVIN'                     In Depot
     C                   EVAL      WkInCust     = 'X'
     C                   ENDIF
     C                   ENDIF

      ** Retrieve if the Customer is the Deliver From or Out Depot
      **   For customer with a Class 'S' or 'D', the Deliver From and Out Depot are not considered.

     C                   EVAL      WkOutCust    = *Blanks
     C                   IF        WkCustClass  = 'M'                           Market
     C                   IF            WkRcdFmt = 'TRADFR'                      Deliver From
     C                             OR  WkRcdFmt = 'HSTTRFR'                     Deliver From
     C                             OR  WkRcdFmt = 'DPTMVOU'                     Out Depot
     C                   EVAL      WkOutCust    = 'X'
     C                   ENDIF
     C                   ENDIF

      ** Retrieve the relation between the Deliver To and From, OR In and Out Depot
      **   For customer with a Class 'S' or 'D', this relation is not considered.

     C                   EVAL      WkRelation   = *Blanks
     C                   IF        WkCustClass  = 'M'                           Market
     C                   SELECT
     C                   WHEN          WkRcdFmt = 'TRADFR'                      Deliver From
     C                             OR  WkRcdFmt = 'TRADTO'                      Deliver To
     C                             OR  WkRcdFmt = 'HSTTRFR'                     Deliver From
     C                             OR  WkRcdFmt = 'HSTTRTO'                     Deliver To
     C                   IF        DELF = DELT
     C                   EVAL      WkRelation   = '='
     C                   ELSE
     C                   EVAL      WkRelation   = '<>'
     C                   ENDIF
     C                   WHEN          WkRcdFmt = 'DPTMVIN'                     In Depot
     C                             OR  WkRcdFmt = 'DPTMVOU'                     Out Depot
     C                   IF        DPID = DPOD
     C                   EVAL      WkRelation   = '='
     C                   ELSE
     C                   EVAL      WkRelation   = '<>'
     C                   ENDIF
     C                   ENDSL
     C                   ENDIF

      ** Retrieve the leg of Depot.

     C                   EVAL      WkLeg = *Blanks
     C                   IF           WkRcdFmt = 'DPTMVDF'
     C                             OR WkRcdFmt = 'DPTMVIN'
     C                             OR WkRcdFmt = 'DPTMVOU'
     C                             OR WkRcdFmt = 'CPDPTMVD'
     C                   IF        TR_TYPE = 'WO'
     C                   EVAL      WkLeg = 'OUT'
     C                   ELSE
     C                   EVAL      WkLeg = 'IN'
     C                   ENDIF
     C                   ENDIF

      ** Second call
      *  ===========

     C                   ELSE

      ** Check if the second leg of depot has to be reported

     C                   IF        WkTrans     = 'DEPOT'                        Depot
     C                             AND TR_TYPE <> 'WI'                          Not Walk In
     C                             AND WkLeg   = 'IN'                           First leg
     C                   EVAL      WkLeg       = 'OUT'                          Second Leg
     C                   ELSE
     C                   EVAL      WTran2Rpt = 'N'
     C                   LEAVESR
     C                   ENDIF

     C                   ENDIF

      ** Check in decision table if the movement has to be reported and how it
      ** updates the position.

     C                   EVAL      Idx = 1
     C     DsArgmt       LOOKUP    TbArgmt(Idx)                           99
     C   99              EVAL      DsResult = TbResult(Idx)
     C                   IF        NOT *IN99
     C                             OR WkReport <> 'Y'
     C                   EVAL      WTran2Rpt = 'N'
     C                   LEAVESR
     C                   ENDIF

      ** Check if the transaction is pending at the transaction date
      ** ie trade date <= Statement date < fully settled date

     C                   SELECT

      ** Trade

     C                   WHEN      WkTrans = 'TRADE'                            Trade

     C                   IF        TR_RECI = 'C'                                Cancel
     C                             OR
     C                             SPMSTD >= TDFS AND TDFS <> *ZEROS            Date Fully Settled
     C                             OR
     C                             SPMSTD < TDDT                                Trade Date
     C                             OR
     C                             AUTS = 'Y'     AND                           Auto-settle Indicato
     C                             TDVD <= SPMSTD                               Value date
     C                   EVAL      WTran2Rpt = 'N'
     C                   LEAVESR
     C                   ENDIF

      ** In Depot

     C                   WHEN      WkTrans = 'DEPOT'                            In Depot
     C                             AND WkLeg = 'IN'

     C                   IF        TR_RECI = 'R'                                Cancel
     C                             OR
     C                             SPMSTD >= DPMD AND TR_TYPE <> 'WI'
     C                             OR
     C                             TR_TYPE = 'WI' AND CSE015 =  'Y'             Walk in
     C                             AND SPMSTD < DMTD                            Trade Date
     C                             OR
     C                             TR_TYPE = 'WI' AND CSE015 <> 'Y'             Walk in
     C                             AND SPMSTD < DPMD                            Movement Date In
     C                             OR
     C                             TR_TYPE <> 'WI'                              Other Depot Type
     C                             AND SPMSTD < ORED                            Original Entry Date
     C                   EVAL      WTran2Rpt = 'N'
     C                   LEAVESR
     C                   ENDIF

      ** Out Depot

     C                   WHEN      WkTrans = 'DEPOT'                            Out Depot
     C                             AND WkLeg = 'OUT'

     C                   IF        TR_RECI = 'R'                                Cancel
     C                             OR
     C                             SPMSTD >= DPMD AND TR_TYPE =  'DT'           Movement Date In
     C                             OR
     C                             SPMSTD >= DPDO AND TR_TYPE <> 'DT'           Movement Date Out
     C                             AND TR_TYPE <> 'WO'
     C                             OR
     C                             TR_TYPE = 'WO' AND CSE015 =  'Y'             Walk Out
     C                             AND SPMSTD < DMTD                            Trade Date
     C                             OR
     C                             TR_TYPE = 'WO' AND CSE015 <> 'Y'             Walk in
     C                             AND SPMSTD < DPDO                            Movement Date Out
     C                             OR
     C                             TR_TYPE <> 'WO'                              Other Depot Type
     C                             AND SPMSTD < ORED                            Original Entry Date
     C                   EVAL      WTran2Rpt = 'N'
     C                   LEAVESR
     C                   ENDIF

      ** DVP/RVP

     C                   WHEN      WkTrans = 'DVP'                              DVP/RVP

     C                   IF        TR_RECI = 'C'                                Cancel
     C                             OR
     C                             SPMSTD >= DVDFST AND DVDFST <> *ZEROS        Date Fully Settled
     C                             OR
     C                             SPMSTD < DVTDAT                              Trade Date
     C                             OR
     C                             DVAUTS = 'Y'     AND                         Auto-settle Indicat
     C                             DVVDAT <= SPMSTD                             Value date
      **  For Contractual transaction, report transaction to client only                      252259
      **  between trade date and value date.                                                  252259
     C                             OR                                                         25225
     C                             WkCustClass = 'C' AND                        Client        25225
     C                             DVCNSI = 'Y'      AND                        Contractual   25225
     C                             DVVDAT <= SPMSTD                             Value Date    25225

     C                   EVAL      WTran2Rpt = 'N'
     C                   LEAVESR
     C                   ENDIF

     C                   ENDSL

      ** Set the transaction as to be reported.

     C                   EVAL      WTran2Rpt = 'Y'

      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdTransact - Load Transaction details                             *
      **********************************************************************

     C     $LdTransact   BEGSR
      *    -----------   -----

      ** Update the transaction sequence by subsafe

     C                   EVAL      WTrnBySub = WTrnBySub + 1

      ** Initiate transaction details

     C                   CLEAR                   SEPTRAD0

      ** Load security details

     C                   EXSR      $LdSecurity

      ** Retrieve Transaction Details

     C                   EXSR      $RtTradeDtl

      ** Load Trade Details

     C                   EXSR      $LdTradeDtl

      ** Load Reference

     C                   EXSR      $LdRef

      ** Load Place of Trade

     C                   EXSR      $LdPlcTrad

      ** Load Place of Safekeeping

     C                   EXSR      $LdPlcSafe

      ** Load Posting Quantity

     C                   EXSR      $LdPostQua

      ** Load Posting Amount

     C                   EXSR      $LdPostAmt

      ** Load Original Amount

     C                   EXSR      $LdOrigAmt

      ** Load Dates

     C                   EXSR      $LdDates

      ** Load Transaction Details Narrative

     C                   EXSR      $LdTrsNarr

      ** Load Payment Indicator

     C                   EXSR      $LdPayInd

      ** Load Receive/Deliver Indicator

     C                   EXSR      $LdReCeInd

      ** Load Type of Settlement Transaction Indicator

     C                   EXSR      $LdSETRInd

      ** Load Transaction Indicator

     C                   EXSR      $LdTranInd

      ** Load Party Details

     C                   EXSR      $LdPrtyDtl

      ** Increase the transaction size with the lengths for blocks TRAN & TRANSDET
      **   Remark:
      **   For Pending transaction by transaction,
      **       the STATUS length should be included in the TRANSACTION length.
      **   In opposite,
      **   For Pending transaction by status,
      **       the TRANSACTION length should be included in the STATUS length.

     C                   EVAL      PTSIZE = PTSIZE + 22                         Block TRAN
     C                                             + 30                         Block TRANSDET

      ** Retrieve Transaction Status

     C                   EXSR      $RtvTraSts

      ** Load Transaction Status

     C                   EXSR      $LdTradStat

     C                   EVAL      PTEXTR =  *ZEROS                             Extract Reference
     C                   EVAL      PTDATE =  SPDATE                             Request Date
     C                   EVAL      PTRSEQ =  SPRSEQ                             Request Sequence
     C                   EVAL      PTSSEQ =  WTrnBySub                             Subsafe Seq.
     C                   EVAL      PTTSEQ =  WTrnBySub                          Transaction Sequence

     C                   WRITE     SEPTRAD0
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdSecurity - Load security details                                *
      **********************************************************************

     C     $LdSecurity   BEGSR
      *    -----------   -----

      ** Retrieve the security details

     C     TR_SESN       CHAIN     SECTY

     C                   IF        %FOUND(SECTY)
     C                   EVAL      PTSESN = Se_SESN                             Security shortname
     C                   EVAL      PTSRPN = Se_SRPN                             Security Report Name
     C                   EVAL      PTSFN1 = Se_SFN1                             Security Full Name 1
     C                   EVAL      PTSFN2 = Se_SFN2                             Security Full Name 2
     C                   EVAL      PTNMCY = Se_NMCY                             Nominal Currency
     C                   EVAL      PTNMDP = Se_NMDP                             Nominal decimal plac
     C                   EVAL      PTSCOR = Se_SCOR                             Country of risk
     C                   EVAL      PTSREF = Se_SREF                             Sedol (Extel) Ref
     C                   EVAL      PTT2RF = Se_T2RF                             Telekurs (Valoren) R
     C                   EVAL      PTCSPN = Se_CSPN                             Cusip Number
     C                   EVAL      PTISIN = Se_ISIN                             ISIN
     C                   ELSE
     C                   EVAL      PTSESN = TR_SESN                             Security shortname
     C                   EVAL      PTSRPN = TR_SESN                             Security shortname
     C                   ENDIF

      ** Evaluate the SWIFT message length
      *  ---------------------------------

     C                   EVAL      PTSIZE = PTSIZE + 13                         Static fields
     C                                             + %LEN(%TRIM(PTSRPN))        Security Report Name
     C                                             + %LEN(%TRIM(PTSFN1))        Security Full Name 1
     C                                             + %LEN(%TRIM(PTSFN2))        Security Full Name 2
     C                                             + %LEN(%TRIM(PTSCOR))        Country of risk
     C                                             + 17                         ISIN

      *                  -----
     C                   ENDSR
      **********************************************************************
      * $RtTradeDtl - Retrieve Transaction Details                         *
      **********************************************************************
     C     $RtTradeDtl   BEGSR
      *    -----------   -----

      ** Retrieve Nominal and Settlement Currency Details.

     C                   EVAL      WkNMCY = *BLANKS                             Nominal Currency
     C                   EVAL      WkNMDP = *ZEROS                              Nominal Decimal Pos.
     C                   EVAL      WkSTCY = *BLANKS                             Settlement Currency
     C                   EVAL      WkSTDP = *ZEROS                              Settl. Decimal Pos.

     C                   SELECT

     C                   WHEN      WkTrans = 'TRADE'                            Trade
     C                   EVAL      WkNMCY = TNMC                                Nominal Currency
     C                   EVAL      WkSTCY = SETC                                Settlement Currency

     C                   WHEN      WkTrans = 'DVP  '                            DVP/RVP
     C                   EVAL      WkNMCY = DVNMCY                              Nominal Currency
     C                   EVAL      WkSTCY = DVSETC                              Settlement Currency
     C                   ENDSL

      **   Retrieve the number of decimal position of nominal currency

     C                   IF        WkNMCY <> *BLANKS

     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WkNMCY        @CURR             4
     C     DSCURR        PARM      DSCURR        DSSDY

     C                   EVAL      WkNMDP = A6NBDP                              Nominal Decimal Pos.

     C                   ENDIF

      **   Retrieve the number of decimal position of settlement currency

     C                   IF        WkSTCY <> *BLANKS

     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WkSTCY        @CURR
     C     DSCURR        PARM      DSCURR        DSSDY

     C                   EVAL      WkSTDP = A6NBDP                              Nominal Decimal Pos.

     C                   ENDIF

      ** Retrieve the outstanding nominal and value at the request statement date.

     C                   Z-ADD     1             KSettSeq                       Settlement Sequence
     C                   Z-ADD     *ZEROS        WkCONM                         Client Outst. Nom.
     C                   Z-ADD     *ZEROS        WkPONM                         CParty Outst. Nom.
     C                   Z-ADD     *ZEROS        WkCOVL                         Client Outst. Value
     C                   Z-ADD     *ZEROS        WkPOVL                         CParty Outst. Value

      ** Trade

     C                   SELECT
     C                   WHEN      WkTrans = 'TRADE'                            Trade

      ** Retrieve the contervalue in settlement currency

     C                   IF        TNMC = SETC

     C                   Z-ADD     TCTR          ZAMTCO                         Amount Out

     C                   ELSE

      **   Convert the Countervalue in nominal currency into settlement currency.

     C                   CALLB     'ZCONV'
     C                   PARM      TCTR          ZAMTCI           15 0          Amount In
     C                   PARM      TDER          ZEXCH            13 8          Cross Exchange Rate
     C                   PARM      TMDI          ZMD               1            Cross Mult/Div Ind.
     C                   PARM      TNMC          ZCCYI             3            Currency In
     C                   PARM      SETC          ZCCYO             3            Currency Out
     C                   PARM      WkNMDP        ZCDPI             1 0          Nb. Decimal In
     C                   PARM      WkSTDP        ZCDPO             1 0          Nb. Decimal Out
     C                   PARM      *ZEROS        ZAMTCO           15 0          Amount Out

     C                   ENDIF

      ** Load initial entries

     C                   Z-ADD     NOML          WkCONM                         Nominal
     C                   Z-ADD     NOML          WkPONM                         Nominal
     C                   Z-ADD     ZAMTCO        WkCOVL                         Countervalue
     C                   Z-ADD     ZAMTCO        WkPOVL                         Countervalue

      ** Retrieve settlements less or equal to request start date.

     C     KeyTradSetSeq SETLL     SETLE
     C     KeyTradSet    READE     SETLE

     C                   DOW       Not %EOF(SETLE)

     C                   IF        Ts_SEDE <= SPMSTD

     C                   SELECT

      ** Fully Settled
      **   If the movement is fully settled, no outstanding nominals and values.

     C                   WHEN      Ts_SFSI =  'Y'
     C                   Z-ADD     *ZEROS        WkCONM                         Client Outst. Nom.
     C                   Z-ADD     *ZEROS        WkPONM                         CParty Outst. Nom.
     C                   Z-ADD     *ZEROS        WkCOVL                         Client Outst. Value
     C                   Z-ADD     *ZEROS        WkPOVL                         CParty Outst. Value

      ** Partial Settlement

     C                   WHEN      Ts_SRIN <> 'Y'
     C                   SUB       Ts_SNMS       WkCONM                         Nominal Settled
     C                   SUB       Ts_SNMS       WkPONM                         Nominal Settled
     C                   SUB       Ts_SVLS       WkCOVL                         Value Settled
     C                   SUB       Ts_SVLS       WkPOVL                         Value Settled

      ** Reverse Settlement

     C                   WHEN      Ts_SRIN =  'Y'
     C                   ADD       Ts_SNMS       WkCONM                         Nominal Settled
     C                   ADD       Ts_SNMS       WkPONM                         Nominal Settled
     C                   ADD       Ts_SVLS       WkCOVL                         Value Settled
     C                   ADD       Ts_SVLS       WkPOVL                         Value Settled
     C                   ENDSL

     C                   ENDIF

     C     KeyTradSet    READE     SETLE
     C                   ENDDO

      ** DVP/RVP

     C                   WHEN      WkTrans = 'DVP  '                            DVP/RVP

      ** Load initial entries

     C                   Z-ADD     DVNOML        WkCONM                         Nominal
     C                   Z-ADD     DVNOML        WkPONM                         Nominal
     C                   Z-ADD     DVSCVL        WkCOVL                         Countervalue
     C                   Z-ADD     DVSCVL        WkPOVL                         Countervalue

     C                   ENDSL

      ** The outstanding reported could not less than zeros.          > < =

     C     WkCONM        COMP      *ZEROS                               99      Client Outst. Nom.
     C   99              Z-ADD     *ZEROS        WkCONM

     C     WkPONM        COMP      *ZEROS                               99      CParty Outst. Nom.
     C   99              Z-ADD     *ZEROS        WkPONM

     C     WkCOVL        COMP      *ZEROS                               99      Client Outst. Value
     C   99              Z-ADD     *ZEROS        WkCOVL

     C     WkPOVL        COMP      *ZEROS                               99      CParty Outst. Value
     C   99              Z-ADD     *ZEROS        WkPOVL
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdTradeDtl - Load Trade Details                                   *
      **********************************************************************
     C     $LdTradeDtl   BEGSR
      *    -----------   -----

     C                   EVAL      PTTYPE = TR_TYPE                             Type of transaction
     C                   EVAL      PTPTFR = TR_PTFR                             Portfolio

      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdRef    - Load References                                        *
      **********************************************************************

     C     $LdRef        BEGSR
      *    ------        -----

      **   Trade

     C                   SELECT
     C                   WHEN      WkTrans = 'TRADE'                            Trade
     C******             EVAL      PTRFPO = *BLANKS                             Pool Reference
     C******             EVAL      PTLKPR = *BLANKS                             Link Prev. Ref. Type
     C******             EVAL      PTRFPR = *BLANKS                             Previous Reference
     C******             EVAL      PTLKRE = *BLANKS                             Link Rel. Ref. Type
     C******             EVAL      PTRFRE = *BLANKS                             Related Reference
     C                   EVAL      PTRFTR = TR_REF                              Deal Reference
     C******             EVAL      PTRFCO = *BLANKS                             Common Reference
     C******             EVAL      PTRFAS = *BLANKS                             Account Servicer Ref

      **   Depot

     C                   WHEN      WkTrans = 'DEPOT'                            Depot
     C******             EVAL      PTRFPO = *BLANKS                             Pool Reference
     C******             EVAL      PTLKPR = *BLANKS                             Link Prev. Ref. Type
     C******             EVAL      PTRFPR = *BLANKS                             Previous Reference
     C******             EVAL      PTLKRE = *BLANKS                             Link Rel. Ref. Type
     C******             EVAL      PTRFRE = *BLANKS                             Related Reference
     C                   EVAL      PTRFTR = TR_REF                              Deal Reference
     C******             EVAL      PTRFCO = *BLANKS                             Common Reference
     C******             EVAL      PTRFAS = *BLANKS                             Account Servicer Ref

      **   DVP/RVP

     C                   WHEN      WkTrans = 'DVP  '                            DVP/RVP
     C******             EVAL      PTRFPO = *BLANKS                             Pool Reference
     C******             EVAL      PTLKPR = *BLANKS                             Link Prev. Ref. Type
     C******             EVAL      PTRFPR = *BLANKS                             Previous Reference
     C******             EVAL      PTLKRE = *BLANKS                             Link Rel. Ref. Type
     C******             EVAL      PTRFRE = *BLANKS                             Related Reference
     C                   EVAL      PTRFTR = TR_REF                              Deal Reference
     C******             EVAL      PTRFAS = *BLANKS                             Account Servicer Ref

     C                   ENDSL


      ** Evaluate the SWIFT message length
      *  ---------------------------------

     C                   EVAL      PTSIZE = PTSIZE + %LEN(%TRIM(PTRFPO))        Pool Reference
     C                                             + %LEN(%TRIM(PTLKPR))        Link Prev. Ref. Type
     C                                             + %LEN(%TRIM(PTRFPR))        Previous Reference
     C                                             + %LEN(%TRIM(PTLKRE))        Link Rel. Ref. Type
     C                                             + %LEN(%TRIM(PTRFRE))        Related Reference
     C                                             + %LEN(%TRIM(PTRFTR))        Depot Reference
     C                                             + %LEN(%TRIM(PTRFCO))        Front Office Ref.
     C                                             + %LEN(%TRIM(PTRFAS))        Account Servicer Ref

     C                   IF        PTRFPO <> *Blanks                            Pool Reference
     C                   EVAL      PTSIZE = PTSIZE + 14 + 22                    Static fields
     C                   ENDIF
     C                   IF        PTLKPR <> *Blanks                            Link Prev. Ref. Type
     C                   EVAL      PTSIZE = PTSIZE + 14                         Static fields
     C                   ENDIF
     C                   IF        PTRFPR <> *Blanks                            Previous Reference
     C                   EVAL      PTSIZE = PTSIZE + 14 + 22                    Static fields
     C                   ENDIF
     C                   IF        PTLKRE <> *Blanks                            Link Rel. Ref. Type
     C                   EVAL      PTSIZE = PTSIZE + 14                         Static fields
     C                   ENDIF
     C                   IF        PTRFRE <> *Blanks                            Related Reference
     C                   EVAL      PTSIZE = PTSIZE + 14 + 22                    Static fields
     C                   ENDIF
     C                   IF        PTRFTR <> *Blanks                            Deal Reference
     C                   EVAL      PTSIZE = PTSIZE + 14 + 22                    Static fields
     C                   ENDIF
     C                   IF        PTRFCO <> *Blanks                            Common Reference
     C                   EVAL      PTSIZE = PTSIZE + 14 + 22                    Static fields
     C                   ENDIF
     C                   IF        PTRFAS <> *Blanks                            Account Servicer Ref
     C                   EVAL      PTSIZE = PTSIZE + 14 + 22                    Static fields
     C                   ENDIF

      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdPlcTrad - Load Place of Trade                                   *
      **********************************************************************

     C     $LdPlcTrad    BEGSR
      *    ----------    -----

     C                   EVAL      PTPLTC = *BLANKS                             Trade Code
     C                   EVAL      PTPLTN = *BLANKS                             Trade Narrative

      ** Evaluate the SWIFT message length
      *  ---------------------------------

     C                   IF        PTPLTC <> *BLANKS
     C                   EVAL      PTSIZE = PTSIZE + 15                         Static fields
     C                                             + %LEN(PTPLTC)               Trade Code
     C                                             + %LEN(%TRIM(PTPLTN))        Trade Narrative
     C                   ENDIF

      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdPlcSafe - Load Place of Safekeeping                             *
      **********************************************************************

     C     $LdPlcSafe    BEGSR
      *    ----------    -----

     C                   EVAL      PTPLSC = *BLANKS                             Safekeeping Code
     C                   EVAL      PTPLSN = *BLANKS                             Safekeeping Narrativ

      ** Evaluate the SWIFT message length
      *  ---------------------------------

     C                   IF        PTPLSC <> *BLANKS
     C                   EVAL      PTSIZE = PTSIZE + 15                         Static fields
     C                                             + %LEN(PTPLSC)               Safekeeping Code
     C                                             + %LEN(%TRIM(PTPLSN))        Safekeeping Narrativ
     C                   ENDIF

      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdPostQua - Load Posting Quantity                                 *
      **********************************************************************

     C     $LdPostQua    BEGSR
      *    ----------    -----

      * Quantity Type
      * -------------

      ** Load the Code according the Price Basis

     C                   IF        Se_SPBS = 'P'                                Percentage
     C                   EVAL      PTPQCD = 'FAMT'                              Face Value
     C                   ELSE
     C                   EVAL      PTPQCD = 'UNIT'                              Unit
     C                   ENDIF

      ** Quantity
      *  --------

     C                   SELECT
     C                   WHEN      WkTrans = 'TRADE' OR                         Trade
     C                             WkTrans = 'DVP  '                            DVP/RVP

     C                   IF        WkCustClass = 'C'
     C                   Z-ADD     WkCONM        PTPQUA                         Nominal
     C                   ELSE
     C                   Z-ADD     WkPONM        PTPQUA                         Nominal
     C                   ENDIF

     C                   WHEN      WkTrans = 'DEPOT'                            Depot
     C                   Z-ADD     DPNA          PTPQUA

     C                   ENDSL

      ** Number of Decimal Position
      *  --------------------------

     C                   Z-ADD     Se_NMDP       PTPQDP

      ** Evaluate the SWIFT message length
      *  ---------------------------------

     C                   EVAL      PTSIZE = PTSIZE + 15                         Static fields
     C                                             + %LEN(PTPQCD)               Quantity Code
     C                                             + %LEN(%CHAR(PTPQUA)) + 1    Quantity + Comma

      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdPostAmt - Load Posting Amount                                   *
      **********************************************************************

     C     $LdPostAmt    BEGSR
      *    ----------    -----

     C                   SELECT
     C                   WHEN      WkTrans = 'TRADE'                            Trade

      ** Posting Currency
      *  ----------------

     C                   EVAL      PTPACY = WkSTCY                              Settlement Currency

      ** Posting Amount
      *  --------------

     C                   SELECT
     C                   WHEN      WkCustClass = 'C'
     C                   Z-ADD     WkCOVL        PTPAMT                         Client Outst. Value
      *
     C                   WHEN      WkCustClass  = 'M' AND
     C                             WkCountClass = 'C'
      ** Rmk: For MT537 to depot for a client trade, do not report the client
      **      outstanding value.
     C                   Z-ADD     *Zeros        PTPAMT                         CParty Outst. Value
      *
     C                   OTHER
     C                   Z-ADD     WkPOVL        PTPAMT                         CParty Outst. Value
     C                   ENDSL

      ** Posting Amount Decimal Position
      *  -------------------------------

     C                   Z-ADD     WkSTDP        PTPADP

     C                   WHEN      WkTrans = 'DVP  '                            DVP/RVP

      ** Posting Currency
      *  ----------------

     C                   EVAL      PTPACY = WkSTCY                              Settlement Currency

      ** Posting Amount
      *  --------------

     C                   IF        WkCustClass = 'C'

      ***Do*not*load*the*posting*amount*if*contractual*indicator*is*'Y'*and*the*              252259
      ***value*date*is*less*than*or*equal*to*the*statement*request*date.********              252259

     C*********          IF        DVCNSI = 'N' OR                                            252259
     C*********                    SPMSTD > DVVDAT                                            252259
     C                   Z-ADD     WkCOVL        PTPAMT                         Client Outst. Value
     C*********          ENDIF                                                                252259

     C                   ELSE
     C                   Z-ADD     WkPOVL        PTPAMT                         CParty Outst. Value
     C                   ENDIF

      ** Posting Amount Decimal Position
      *  -------------------------------

     C                   Z-ADD     WkSTDP        PTPADP

     C                   ENDSL

      ** Evaluate the SWIFT message length
      *  ---------------------------------

     C                   IF        PTPACY <> *Blanks
     C                   EVAL      PTSIZE = PTSIZE + 14                         Static fields
     C                                             + %LEN(PTPACY)               Posting Amount Ccy
     C                                             + %LEN(%CHAR(PTPAMT)) + 2    Posting Amount+Comma
     C                   ENDIF

      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdOrigAmt - Load Original Amount                                  *
      **********************************************************************

     C     $LdOrigAmt    BEGSR
      *    ----------    -----

      ** Original Currency
      *  -----------------

     C                   EVAL      PTOCCY = *Blanks

      ** Original Amount
      *  ---------------

     C                   Z-ADD     *ZEROS        PTOAMT

      ** Original Amount Decimal Position
      *  --------------------------------

     C                   Z-ADD     *ZEROS        PTOADP

      ** Evaluate the SWIFT message length
      *  ---------------------------------

     C                   IF        PTOCCY <> *Blanks
     C                   EVAL      PTSIZE = PTSIZE + 14                         Static fields
     C                                             + %LEN(PTOCCY)               Original Amount Ccy
     C                                             + %LEN(%CHAR(PTOAMT)) + 2    Original Amount+Comm
     C                   ENDIF

      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdDates  - Load Dates                                             *
      **********************************************************************

     C     $LdDates      BEGSR
      *    --------      -----

      ** Trade
      *  -----

     C                   SELECT

     C                   WHEN      WkTrans = 'TRADE'                            Trade

      ** Expected Settlement Date
     C******             EVAL      PTEXDT = TDVD                                Value Date
      ** Expected Settlement Time
     C******             EVAL      PTEXTM =
      ** Expected Settlement Code
     C******             EVAL      PTEXCD =
      ** Settlement Date
     C******             EVAL      PTSEDT = TDFS                                Date Fully Settled
     C                   EVAL      PTSEDT = TDVD                                Value Date
      ** Settlement Time
     C******             EVAL      PTSETM =
      ** Settlement Code
     C******             EVAL      PTSECD =
      ** Late Delivery Date
     C******             EVAL      PTADDT =
      ** Late Delivery Time
     C******             EVAL      PTADTM =
      ** Late Delivery Code
     C******             EVAL      PTADCD =
      ** Trade Date
     C                   EVAL      PTTRDT = TDDT                                Trade Date
      ** Trade Time
     C******             EVAL      PTTRTM =                                     Transaction Time
      ** Trade Code
     C******             EVAL      PTTRCD =

      ** In Depot
      *  --------

     C                   WHEN      WkTrans = 'DEPOT'                            In Depot
     C                             AND WkLeg = 'IN'

      ** Expected Settlement Date
     C                   EVAL      PTEXDT = DPMD                                Movement Date In
      ** Expected Settlement Time
     C******             EVAL      PTEXTM =
      ** Expected Settlement Code
     C******             EVAL      PTEXCD =
      ** Settlement Date
     C                   EVAL      PTSEDT = DPMD                                Movement Date In d
      ** Settlement Time
     C******             EVAL      PTSETM =
      ** Settlement Code
     C******             EVAL      PTSECD =
      ** Late Delivery Date
     C******             EVAL      PTADDT =
      ** Late Delivery Time
     C******             EVAL      PTADTM =
      ** Late Delivery Code
     C******             EVAL      PTADCD =
      ** Trade Date
     C                   SELECT
     C                   WHEN      TR_TYPE = 'WI'                               Walk In
     C                   IF        CSE015 = 'Y'
     C                   EVAL      PTTRDT = DMTD                                Trade date
     C                   ELSE
     C                   EVAL      PTTRDT = DPMD                                Movement Date In
     C                   ENDIF
      *
     C                   OTHER                                                  Other Depot Type
     C                   EVAL      PTTRDT = ORED                                Original Entry Date
     C                   ENDSL
      ** Trade Time
     C******             EVAL      PTTRTM =                                     Transaction Time
      ** Trade Code
     C******             EVAL      PTTRCD =

      ** Out Depot
      *  ---------

     C                   WHEN      WkTrans = 'DEPOT'                            Out Depot
     C                             AND WkLeg = 'OUT'

      ** Expected Settlement Date
     C                   IF        TR_TYPE = 'DT'
     C                   EVAL      PTEXDT = DPMD                                Movement Date In
     C                   ELSE
     C                   EVAL      PTEXDT = DPDO                                Movement Date Out
     C                   ENDIF
      ** Expected Settlement Time
     C******             EVAL      PTEXTM =
      ** Expected Settlement Code
     C******             EVAL      PTEXCD =
      ** Settlement Date
     C                   IF        TR_TYPE = 'DT'
     C                   EVAL      PTSEDT = DPMD                                Movement Date In
     C                   ELSE
     C                   EVAL      PTSEDT = DPDO                                Movement Date Out
     C                   ENDIF
      ** Settlement Time
     C******             EVAL      PTSETM =
      ** Settlement Code
     C******             EVAL      PTSECD =
      ** Late Delivery Date
     C******             EVAL      PTADDT =
      ** Late Delivery Time
     C******             EVAL      PTADTM =
      ** Late Delivery Code
     C******             EVAL      PTADCD =
      ** Trade Date
     C                   SELECT
     C                   WHEN      TR_TYPE = 'WO'                               Walk Out
     C                   IF        CSE015 = 'Y'
     C                   EVAL      PTTRDT = DMTD                                Trade date
     C                   ELSE
     C                   EVAL      PTTRDT = DPMD                                Movement Date In
     C                   ENDIF
      *
     C                   OTHER                                                  Other Depot Type
     C                   EVAL      PTTRDT = ORED                                Original Entry Date
     C                   ENDSL
      ** Trade Time
     C******             EVAL      PTTRTM =                                     Transaction Time
      ** Trade Code
     C******             EVAL      PTTRCD =

      ** DVP/RVP
      *  -------

     C                   WHEN      WkTrans = 'DVP'                              DVP/RVP

      ** Expected Settlement Date
     C******             EVAL      PTEXDT = DVVDAT                              Value Date
      ** Expected Settlement Time
     C******             EVAL      PTEXTM =
      ** Expected Settlement Code
     C******             EVAL      PTEXCD =
      ** Settlement Date
     C******             EVAL      PTSEDT = DVDFST                              Date Fully Settled
     C                   EVAL      PTSEDT = DVVDAT                              Value Date
      ** Settlement Time
     C******             EVAL      PTSETM =
      ** Settlement Code
     C******             EVAL      PTSECD =
      ** Late Delivery Date
     C******             EVAL      PTADDT =
      ** Late Delivery Time
     C******             EVAL      PTADTM =
      ** Late Delivery Code
     C******             EVAL      PTADCD =
      ** Trade Date
     C                   EVAL      PTTRDT = DVTDAT                              Trade Date
      ** Trade Time
     C******             EVAL      TTTRTM =                                     Transaction Time
      ** Trade Code
     C******             EVAL      TTTRCD =

     C                   ENDSL

      ** Evaluate the SWIFT message length
      *  ---------------------------------

      ** Expected Settlement

     C                   SELECT
     C                   WHEN      PTEXDT <> *Zeros                             Expected Settl Date
     C                   EVAL      PTSIZE = PTSIZE + 14                         Static fields
     C                                             + 8                          Date
     C                   IF        PTEXTM <> *Zeros                             Expected Settl Time
     C                   EVAL      PTSIZE = PTSIZE + 6                          Time
     C                   ENDIF
     C                   WHEN      PTEXCD <> *Blanks                            Expected Settl Code
     C                   EVAL      PTSIZE = PTSIZE + 14                         Static fields
     C                                             + %LEN(PTEXCD)               Code
     C                   ENDSL

      ** Settlement

     C                   SELECT
     C                   WHEN      PTSEDT <> *Zeros                             Settlement Date
     C                   EVAL      PTSIZE = PTSIZE + 14                         Static fields
     C                                             + 8                          Date
     C                   IF        PTSETM <> *Zeros                             Settlement Time
     C                   EVAL      PTSIZE = PTSIZE + 6                          Time
     C                   ENDIF
     C                   WHEN      PTSECD <> *Blanks                            Settlement Code
     C                   EVAL      PTSIZE = PTSIZE + 14                         Static fields
     C                                             + %LEN(PTSECD)               Code
     C                   ENDSL

      ** Late Delivery

     C                   SELECT
     C                   WHEN      PTADDT <> *Zeros                             Late Del. Date
     C                   EVAL      PTSIZE = PTSIZE + 14                         Static fields
     C                                             + 8                          Date
     C                   IF        PTADTM <> *Zeros                             Late Del. Time
     C                   EVAL      PTSIZE = PTSIZE + 6                          Time
     C                   ENDIF
     C                   WHEN      PTADCD <> *blanks                            Late Del. Code
     C                   EVAL      PTSIZE = PTSIZE + 14                         Static fields
     C                                             + %LEN(PTADCD)               Code
     C                   ENDSL

      ** Trade

     C                   SELECT
     C                   WHEN      PTTRDT <> *Zeros                             Trade Date
     C                   EVAL      PTSIZE = PTSIZE + 14                         Static fields
     C                                             + 8                          Date
     C                   IF        PTTRTM <> *Zeros                             Trade Time
     C                   EVAL      PTSIZE = PTSIZE + 6                          Time
     C                   ENDIF
     C                   WHEN      PTTRCD <> *blanks                            Trade Code
     C                   EVAL      PTSIZE = PTSIZE + 14                         Static fields
     C                                             + %LEN(PTTRCD)               Code
     C                   ENDSL

      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdTrsNarr - Load Transaction Details Narrative                    *
      **********************************************************************

     C     $LdTrsNarr    BEGSR
      *    ----------    -----

     C******             EVAL      PTNAR1 = *BLANKS                             Narrative 1
     C******             EVAL      PTNAR2 = *BLANKS                             Narrative 2
     C******             EVAL      PTNAR3 = *BLANKS                             Narrative 3
     C******             EVAL      PTNAR4 = *BLANKS                             Narrative 4
     C******             EVAL      PTNAR5 = *BLANKS                             Narrative 5
     C******             EVAL      PTNAR6 = *BLANKS                             Narrative 6
     C******             EVAL      PTNAR7 = *BLANKS                             Narrative 7
     C******             EVAL      PTNAR8 = *BLANKS                             Narrative 8
     C******             EVAL      PTNAR9 = *BLANKS                             Narrative 9
     C******             EVAL      PTNA10 = *BLANKS                             Narrative 10

      ** Evaluate the SWIFT message length
      *  ---------------------------------

     C                   IF        PTNAR1 <> *BLANKS                            Narrative 1
     C                   EVAL      PTSIZE = PTSIZE + 32                         Static fields
     C                                             + %LEN(%TRIM(PTNAR1))        Narrative 1
     C                                             + %LEN(%TRIM(PTNAR2))        Narrative 2
     C                                             + %LEN(%TRIM(PTNAR3))        Narrative 3
     C                                             + %LEN(%TRIM(PTNAR4))        Narrative 4
     C                                             + %LEN(%TRIM(PTNAR5))        Narrative 5
     C                                             + %LEN(%TRIM(PTNAR6))        Narrative 6
     C                                             + %LEN(%TRIM(PTNAR7))        Narrative 7
     C                                             + %LEN(%TRIM(PTNAR8))        Narrative 8
     C                                             + %LEN(%TRIM(PTNAR9))        Narrative 9
     C                                             + %LEN(%TRIM(PTNA10))        Narrative 10
     C                   ENDIF

      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdPayInd  - Load Payment Indicator                                *
      **********************************************************************

     C     $LdPayInd     BEGSR
      *    ---------     -----

     C                   CLEAR                   SEPINDD0

      ** Qualifier

     C                   EVAL      PIQUAL = 'PAYM'

      ** Indicator

     C                   SELECT
     C                   WHEN      WkTrans = 'TRADE'                            Trade

     C                   SELECT
     C                   WHEN      PCOD = '1' OR PCOD = '5'
     C                   EVAL      PIINDC = 'APMT'                              Against Payment
     C                   WHEN      PCOD = '3'
     C                   EVAL      PIINDC = 'FREE'                              Free of Payment
     C                   WHEN      PCOD = '2' OR PCOD = '4'
     C                   EVAL      PIINDC = '    '
     C                   ENDSL

     C                   WHEN      WkTrans = 'DVP'                              DVP/RVP
     C                   EVAL      PIINDC = 'APMT'                              Against Payment

     C                   WHEN      WkTrans = 'DEPOT'                            Depot
     C                   EVAL      PIINDC = 'FREE'                              Free of Payment
     C                   ENDSL


      ** Evaluate the SWIFT message length
      *  ---------------------------------

     C                   EVAL      PISIZE = PISIZE + 10                         Static fields
     C                                             + %LEN(PIQUAL)               Qualifier
     C                                             + %LEN(PIINDC)               Indicator
     C                   EVAL      PTSIZE = PTSIZE + PISIZE                     Transaction length


      ** Add record to extract file
      *  ---------------------------

     C                   EVAL      PIEXTR =  *ZEROS                             Extract Reference
     C                   EVAL      PIDATE =  SPDATE                             Request Date
     C                   EVAL      PIRSEQ =  SPRSEQ                             Request Sequence
     C                   EVAL      PITSEQ =  WTrnBySub                          Transaction Sequence

     C                   WRITE     SEPINDD0
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdRECEInd - Load Receive/Deliver Indicator                        *
      **********************************************************************

     C     $LdReCeInd    BEGSR
      *    ----------    -----

     C                   CLEAR                   SEPINDD0

      ** Qualifier

     C                   EVAL      PIQUAL = 'REDE'

      ** Indicator

     C                   SELECT
     C                   WHEN      WkDeInInd = 'I'                              Increase Position
     C                   EVAL      pIINDC = 'RECE'                              Receive
     C                   WHEN      WkDeInInd = 'D'                              Decrease Position
     C                   EVAL      PIINDC = 'DELI'                              Deliver
     C                   ENDSL

      ** Evaluate the SWIFT message length
      *  ---------------------------------

     C                   EVAL      PISIZE = PISIZE + 10                         Static fields
     C                                             + %LEN(PIQUAL)               Qualifier
     C                                             + %LEN(PIINDC)               Indicator
     C                   EVAL      PTSIZE = PTSIZE + PISIZE                     Transaction length

      ** Add record to extract file
      *  ---------------------------

     C                   EVAL      PIEXTR =  *ZEROS                             Extract Reference
     C                   EVAL      PIDATE =  SPDATE                             Request Date
     C                   EVAL      PIRSEQ =  SPRSEQ                             Request Sequence
     C                   EVAL      PITSEQ =  WTrnBySub                          Transaction Sequence

     C                   WRITE     SEPINDD0
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdSETRInd - Load Type of Settlement Transaction Indicator         *
      **********************************************************************

     C     $LdSETRInd    BEGSR
      *    ----------    -----

     C                   CLEAR                   SEPINDD0

      ** Qualifier

     C                   EVAL      PIQUAL = 'SETR'

      ** Indicator

     C                   SELECT

      ** Trade
      *  -----

     C                   WHEN      WkTrans = 'TRADE'                            Trade
      *
      ** If Corporate action or Early Redemption, the type of settlement transaction is not reported
      *
     C                   IF        %SUBST(TDNR:1:16) = 'CORPORATE ACTION'       Corporate Action
     C                             OR %SUBST(TDNR:34:2) = 'ER'                  Early Redemption
     C                   LEAVESR
     C                   ENDIF
      *
      ** According the book, the transaction is a trade or a buy/sell
      *
     C                   CALL      'AOBOOKR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      TDBK          @BKCD             2
     C     DSBOOK        PARM      *Blanks       DSFDY
      *
     C                   IF        @RTCD = *Blanks
     C                   SELECT
      *
     C                   WHEN      BDBYSL <> 'Y'                                Not Buy-Sell Book
     C                   EVAL      PIINDC = 'TRAD'                              Trade
      *
     C                   WHEN      BDBYSL =  'Y'                                 Buy-Sell Book
     C     LKRF          CHAIN     TRADS
     C                   IF        %FOUND(TRADS)
     C                   SELECT
     C                   WHEN      TDVD < Rtv_TDVD
     C                   EVAL      PIINDC = 'BSBO'                              Buy Sell Back Open
     C                   WHEN      TDVD > Rtv_TDVD
     C                   EVAL      PIINDC = 'BSBC'                              Buy Sell Back Close
     C                   WHEN      TR_REF < LKRF
     C                   EVAL      PIINDC = 'BSBO'                              Buy Sell Back Open
     C                   WHEN      TR_REF > LKRF
     C                   EVAL      PIINDC = 'BSBC'                              Buy Sell Back Close
     C                   ENDSL
      ** If open leg and TP (= Client sell) => Sell Buy transaction                           CSW207
      ** If open leg and TS (= Client purchase) => Buy Sell trandaction                       CSW207
      ** If Close leg and TP (= Client sell) => Buy Sell trandaction                          CSW207
      ** If Close leg and TS (= Client purchase) => Sell Buy trandaction                      CSW207
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   IF        PIINDC = 'BSBO' AND TR_TYPE = 'TP' OR        Open Leg      CSW207
     C                             PIINDC = 'BSBC' AND TR_TYPE = 'TS'           Close Leg     CSW207
     C                   EVAL      PIINDC = 'SBBK'                              Sell Buy      CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      PIINDC = 'BSBK'                              Buy Sell      CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF
     C                   ENDSL
     C                   ENDIF

      ** DVP/RVP
      *  -------

     C                   WHEN      WkTrans = 'DVP'                              DVP/RVP
     C                   EVAL      PIINDC = 'TRAD'                              Trade

      ** Depot
      *  -----

     C                   WHEN      WkTrans = 'DEPOT'                            Depot
      *
      ** If Corporate action or Early Redemption, the type of settlement transaction is not reported
      *
     C                   IF        %SUBST(DPNR:1:16) = 'CORPORATE ACTION'       Corporate Action
     C                             OR %SUBST(DPNR:34:2) = 'ER'                  Early Redemption
     C                   LEAVESR
     C                   ENDIF
      *
     C                   SELECT
     C                   WHEN      TR_TYPE = 'RP' AND CSW207 = 'Y'              Repo          CSW207
     C                   EVAL      PIINDC = 'REPU'                              Repo          CSW207
      *                                                                                       CSW207
     C                   WHEN      TR_TYPE = 'RR' AND CSW207 = 'Y'              Reverse Repo  CSW207
     C                   EVAL      PIINDC = 'RVPO'                              Reverse Repo  CSW207
      *                                                                                       CSW207
     C                   WHEN      TR_TYPE = 'RR' OR TR_TYPE = 'RP'             Repo/Reverse Repo
     C                   EVAL      PIINDC = 'REPU'                              Repo
      *
     C                   WHEN      TR_TYPE = 'PD' OR TR_TYPE = 'PL'             Pledged Loan/Deposit
     C                   EVAL      PIINDC = 'COLL'                              Collateral

     C                   WHEN      TR_TYPE = 'BB' OR TR_TYPE = 'BL'             Bond Borrowing/Lend.
     C                   EVAL      PIINDC = 'SECL'                              Securities Lending

     C                   WHEN      TR_TYPE = 'WI' OR TR_TYPE = 'WO'             Walk In / Out
     C                   EVAL      PIINDC = 'OWNE'                              Ext. Own Acc. Transf

     C                   WHEN      TR_TYPE = 'DT'                               Depot transfer
      *
      ** According the SWIFT address of the both depots, it is a internal or
      ** external own account transfer.
      *
     C                   MOVEL     DPID          @KEY1                          In Depot
     C                   CALL      'AOCUSTR0'
     C                   PARM      *Blanks       @RTCD                          B:Return code
     C                   PARM      '*KEY'        @OPTN                          I:Option
     C                   PARM                    @KEY1            10            I:Key field
     C                   PARM                    @KYST             7            O:Key status
     C     DSCUST        PARM      *BLANKS       DSSDY                          O:Format
      *
     C                   IF        @RTCD = *Blanks
      *
     C                   MOVE      BBCSID        WkBBCSID                       Save 1 address
      *
     C                   MOVEL     DPOD          @KEY1            10            Out Depot
     C                   CALL      'AOCUSTR0'
     C                   PARM      *Blanks       @RTCD                          B:Return code
     C                   PARM      '*KEY'        @OPTN                          I:Option
     C                   PARM                    @KEY1            10            I:Key field
     C                   PARM                    @KYST             7            O:Key status
     C     DSCUST        PARM      *Blanks       DSSDY                          O:Format
      *
     C                   IF        @RTCD = *Blanks
      *
     C                   SELECT
     C                   WHEN      BBCSID = WkBBCSID                            Same SWIFT address
     C                   EVAL      PIINDC = 'OWNI'                              Int. Own Acc. Transf
     C                   OTHER
     C                   EVAL      PIINDC = 'OWNE'                              Ext. Own Acc. Transf
     C                   ENDSL
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDSL
     C                   ENDSL

      ** If no detail to extract, do not add details

     C                   IF        PIINDC = *Blanks
     C                   LEAVESR
     C                   ENDIF

      ** Evaluate the SWIFT message length
      *  ---------------------------------

     C                   EVAL      PISIZE = PISIZE + 10                         Static fields
     C                                             + %LEN(PIQUAL)               Qualifier
     C                                             + %LEN(PIINDC)               Indicator
     C                   EVAL      PTSIZE = PTSIZE + PISIZE                     Transaction length

      ** Add record to extract file
      *  ---------------------------

     C                   EVAL      PIEXTR =  *ZEROS                             Extract Reference
     C                   EVAL      PIDATE =  SPDATE                             Request Date
     C                   EVAL      PIRSEQ =  SPRSEQ                             Request Sequence
     C                   EVAL      PITSEQ =  WTrnBySub                          Transaction Sequence

     C                   WRITE     SEPINDD0

      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdTranInd - Load Transaction Indicator                            *
      **********************************************************************

     C     $LdTranInd    BEGSR
      *    ----------    -----

     C                   CLEAR                   SEPINDD0

      ** Qualifier

     C                   EVAL      PIQUAL = 'TRAN'

      ** Indicator

     C                   SELECT
     C                   WHEN      WkTrans = 'TRADE'                            Trade
     C                   IF        %SUBST(TDNR:1:16) = 'CORPORATE ACTION'
     C                   EVAL      PIINDC = 'CORP'                              Corporate Action Act
     C                   ELSE
     C                   EVAL      PIINDC = 'SETT'                              Settlement/Clearing
     C                   ENDIF
      *
     C                   WHEN      WkTrans = 'DVP'                              DVP/RVP
     C                   EVAL      PIINDC = 'SETT'                              Settlement/Clearing
      *
     C                   WHEN      WkTrans = 'DEPOT'                            Depot
     C                   IF        %SUBST(DPNR:1:16) = 'CORPORATE ACTION'
     C                   EVAL      PIINDC = 'CORP'                              Corporate Action Act
     C                   ELSE
     C                   EVAL      PIINDC = 'SETT'                              Settlement/Clearing
     C                   ENDIF

     C                   WHEN      WkTrans = 'POSET'                            Position settlement
     C                   EVAL      PIINDC = 'CORP'                              Corporate Action Act
     C                   ENDSL

      ** Evaluate the SWIFT message length
      *  ---------------------------------

     C                   EVAL      PISIZE = PISIZE + 10                         Static fields
     C                                             + %LEN(PIQUAL)               Qualifier
     C                                             + %LEN(PIINDC)               Indicator
     C                   EVAL      PTSIZE = PTSIZE + PISIZE                     Transaction length

      ** Add record to extract file
      *  ---------------------------

     C                   EVAL      PIEXTR =  *ZEROS                             Extract Reference
     C                   EVAL      PIDATE =  SPDATE                             Request Date
     C                   EVAL      PIRSEQ =  SPRSEQ                             Request Sequence
     C                   EVAL      PITSEQ =  WTrnBySub                          Transaction Sequence

     C                   WRITE     SEPINDD0
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdPrtyDtl - Load Party Details                                    *
      **********************************************************************

     C     $LdPrtyDtl    BEGSR
      *    ----------    -----

      ** The party details will be extracted later for DVP/RVP transactions

     C                   CLEAR                   SEPPRTD0

      ** Load Party (Mandatory)

     C                   EXSR      $LdParty

      ** Load Safekeeping Account (Optional)

     C                   EXSR      $LdSafe

      ** If no detail to extract, do not add details

     C                   IF        PPQUAL = *Blanks
     C                   LEAVESR
     C                   ENDIF

      ** Add record to extract file
      *  ---------------------------

     C                   EVAL      PPEXTR =  *ZEROS                             Extract Reference
     C                   EVAL      PPDATE =  SPDATE                             Request Date
     C                   EVAL      PPRSEQ =  SPRSEQ                             Request Sequence
     C                   EVAL      PPTSEQ =  WTrnBySub                          Transaction Sequence

     C                   WRITE     SEPPRTD0
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdParty   - Load Party                                            *
      **********************************************************************

     C     $LdParty      BEGSR
      *    --------      -----

     C                   SELECT

     C                   WHEN      WkTrans = 'DVP'                              DVP/RVP

      ** Qualifier

     C                   IF        TR_TYPE = 'DP'                               Deliver / Paiement
     C                   EVAL      PPQUAL =  'BUYR'                             Buyer
     C                   ELSE                                                   Recieve / Paiement
     C                   EVAL      PPQUAL =  'SELL'                             Seller
     C                   ENDIF

      ** Indicator

     C                   MOVE      DVCTYN        PPPRTC                         Counterparty Cust Nb
     C                   EVAL      PPPRT1 = DVCPTY                              Counterparty
     C                   EVAL      PPPRT2 = DVCPT1                              CParty Address 1
     C                   EVAL      PPPRT3 = DVCPT2                              CParty Address 2
     C                   EVAL      PPPRT4 = DVCPT3                              CParty Address 3

     C                   ENDSL

      ** If no detail to extract, do not add details

     C                   IF        PPQUAL = *Blanks
     C                   LEAVESR
     C                   ENDIF

      ** Evaluate the SWIFT message length
      *  ---------------------------------

     C                   EVAL      PPSIZE = PPSIZE + 10 + 28                    Static fields
     C                                             + %LEN(PPQUAL)               Qualifier
     C                                             + 140                        Name & Address
     C                   EVAL      PTSIZE = PTSIZE + PPSIZE                     Transaction length

      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdSafekeeping Account                                             *
      **********************************************************************

     C     $LdSafe       BEGSR
      *    -------       -----

     C                   EVAL      PPSAFC = *BLANKS                             Safekeeping Acc Code
     C                   EVAL      PPSAFA = *BLANKS                             Safekeeping Acc 1

      ** Evaluate the SWIFT message length
      *  ---------------------------------

      ** If no detail to extract, do not add details

     C                   IF        PPSAFA = *Blanks
     C                   LEAVESR
     C                   ENDIF

     C                   EVAL      PPSIZE = PPSIZE + 15                         Static fields
     C                                             + %LEN(%TRIM(PPSAFC))        Safekeeping Acc Code
     C                                             + %LEN(%TRIM(PPSAFA))        Safekeeping Acc 1
     C                   EVAL      PTSIZE = PTSIZE + PPSIZE                     Transaction length

      *                  -----
     C                   ENDSR
      **********************************************************************
      * $RtvTraSts - Retrieve Transaction Status                           *
      **********************************************************************

     C     $RtvTraSts    BEGSR
      *    ----------    -----

      ** Clear transaction status

     C     1             Do        999           Ids
     C     Ids           OCCUR     TrStatus
     C                   IF        WkSWIFTQual = *Blanks
     C                   LEAVE
     C                   ENDIF
     C                   CLEAR                   TrStatus
     C                   ENDDO

      ** Load default

     C                   Z-ADD     1             IdS
     C     Ids           OCCUR     TrStatus

      ** Load key fields

     C                   EVAL      KMvmRef = TR_REF                             Movement Reference
     C                   SELECT
     C                   WHEN      WkTrans = 'TRADE'                            Trade
     C                   EVAL      KMvnTyp = 'T'
     C                   WHEN      WkTrans = 'DEPOT'                            Depot
     C                   EVAL      KMvnTyp = 'W'
     C                   WHEN      WkTrans = 'DVP'                              DVP/RVP
     C                   EVAL      KMvnTyp = 'D'
     C                   OTHER
     C                   EVAL      KMvnTyp = *Blanks
     C                   ENDSL
     C                   Z-ADD     SPMSTD        KMvmDat                        Midas Start Date

      ** Retrieve the last movement status

     C                   EXSR      $RtvMvmStat

      ** Specific processing for client trade.
      ** -------------------------------------

B1   C                   IF        WKCountClass = 'C' AND WkTrans = 'TRADE'

      ** Normally, there is no automatic update of the client transaction status,
      ** in opposite of market transaction (MT548). But, if a client transaction
      ** is associated to a market transaction, we assume that the both
      ** transactions have the same status. Except,
      ** - When the status of the client trade is more "up today" (manual input)
      ** - When the market trade is fully settled, in opposite of client one.

      ** Check client trade associated to market trades via Bulk Reference.

B2   C                   If        BLKR <> *Blanks AND
     C                             ATRD = 'C'

     C                   MOVE      'N'           WkFound           1

     C     BLKR          SETLL     SETRADL5
     C     BLKR          READE     SETRADL5

B3   C                   DOW       NOT %EOF(SETRADL5)

      ** Check if market trade

B4   C                   IF        RL4_ATRD = 'M'

      ** If the market trade is not fully settled at the Requested start date.

B5   C                   IF        RL4_TDFS = *Zeros OR
     C                             RL4_TDFS > SPMSTD

      ** Retrieve the status of the market trade.

     C                   MOVE      'Y'           WkFound

     C                   Z-ADD     1             IdS
     C     Ids           OCCUR     TrStatus

     C                   EVAL      KMvmRef = RL4_TDRF                           Movement Reference
     C                   Z-ADD     SPMSTD        KMvmDat                        Midas Start Date

      ** Retrieve the last movement status

     C                   EXSR      $RtvMvmStat

E5   C                   ENDIF
E4   C                   ENDIF

     C     BLKR          READE     SETRADL5

E3   C                   ENDDO

E2   C                   ENDIF

      ** Check client trade associated to market trades via PB order number.

B2   C                   If        ORDE <> *Zeros   AND
B2   C                             ORDE <> 999999   AND
     C                             %Subst(WkRcdFmt:1:4) = 'TRAD'

     C                   MOVE      'N'           WkFound           1

     C     ORDE          SETLL     TRADSDL9
     C     ORDE          READE     TRADSDL9

B3   C                   DOW       NOT %EOF(TRADSDL9)

      ** Check if market trade

     C                   MOVE      RL9_TCNR      WkCustAlph        6            Count/Benef. Cust.
     C     WkCustAlph    CHAIN     SDSECSL1
B4   C                   IF        %FOUND(SDSECSL1)
     C                             AND BFCLAS <> 'S' AND BFCLAS <> 'D'

      ** If the market trade is not fully settled at the Requested start date.

B5   C                   IF        RL9_TDFS = *Zeros OR
     C                             RL9_TDFS > SPMSTD

      ** Retrieve the status of the market trade.

     C                   MOVE      'Y'           WkFound

     C                   Z-ADD     1             IdS
     C     Ids           OCCUR     TrStatus

     C                   EVAL      KMvmRef = RL9_TDRF                           Movement Reference
     C                   Z-ADD     SPMSTD        KMvmDat                        Midas Start Date

      ** Retrieve the last movement status

     C                   EXSR      $RtvMvmStat

E5   C                   ENDIF
E4   C                   ENDIF

     C     ORDE          READE     TRADSDL9

E3   C                   ENDDO

E2   C                   ENDIF
E1   C                   ENDIF

      *                  -----
     C                   ENDSR
      **********************************************************************
      * $RtvMvmStat - Retrieve the last movement status                    *
      **********************************************************************

     C     $RtvMvmStat   BEGSR
      *    -----------   -----

      ** Access the SWIFT status code for the transaction.

     C     KeyMvmDat     SETLL     SEMVTSL2
     C     KeyMvm        READE     SEMVTSL2

     C                   IF        NOT %EOF(SEMVTSL2)

      ** Retrieve the SWIFT status qualifier corresponding to the SWIFT Code
      ** The SWIFT qualifiers for MT537 are:
      **  - MTCH Matching Status
      **  - INMH Inferred Matching Status (allegement)                                   CSW207
      **  - SETT Settlement Status
      **  - IPRC Instruction Processing Status
      ** The valid SWIFT status qualifier/SWIFT status code are maintenained
      ** in file PF/Y2VLLSP 'Midas Y2 Condition value list' key 1215003.
      *
     C*****1             DO        3             Idx                                     CSW207
     C     1             DO        4             Idx                                     CSW207
      *
     C                   EVAL      @INVL = SWStsQu(Idx) + ' ' + TMSWSC
      *
     C                   CALL      'Y2RVCNR'                                    Text of Frequency
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      1215006       @Y2LS             7 0
     C                   PARM                    @INVL            20
     C                   PARM      *BLANK        @VLMP             1
     C                   PARM                    @TEXT            25

      ** If the qualifier corresponding to the code is found,
      *
     C                   IF        @RTCD = *Blanks

      ** Check if the status found has to override the previous one; the default
      ** or the client trade status if the market trade associated.

     C                   Z-ADD     1             Idy
     C     WkSWIFTQual   Lookup    SWStsQu(Idy)                           99

      ** If the SWIFT qualifier position (Idx) of the current trade status is
      ** less than the SWIFT qualifier position (Idy) of previous one (default or
      ** market trade), keep the previous status.
      *
     C                   IF        *IN99 AND
     C                             Idx < Idy
     C                   LEAVESR
     C                   ENDIF

      ** Otherwise, override the status.

      ** Clear current status
      *
     C     1             Do        999           Ids
     C     Ids           OCCUR     TrStatus
     C                   IF        WkSWIFTQual = *Blanks
     C                   LEAVE
     C                   ENDIF
     C                   CLEAR                   TrStatus
     C                   ENDDO

     C                   Z-ADD     1             IdS
     C     Ids           OCCUR     TrStatus

      ** If the qualifier corresponding to the code is found, load the status details

     C                   EVAL      WkMvmDat    = TMNTDT                         Notification Date
     C                   EVAL      WkSWIFTQual = SWStsQu(Idx)                   SWIFT Qualifier
     C                   EVAL      WkSWIFTCod  = TMSWSC                         SWIFT Status Code
     C                   EVAL      WkReasQual  = TMSWSC                         Reason Qualifier
     C                   EVAL      WkReasCod   = TMSWRC                         Reason Code
     C                   IF        TMNARR <> *Blanks
     C                   EVAL      WkReasNar   = %Subst(TMNARR:1:210)           Reason Narrative
     C                   ENDIF

      ** Retrieve the other reason codes if exist for the same date and the same
      ** SWIFT Code.

      ** ##########################################################################################
      ** ## Retrieve only the last one ##
      ** ################################

     C                   GOTO      ONLYONE

      ** ##########################################################################################

     C                   Z-ADD     TMNTDT        KMvmDat                        Notification Date
     C     KeyMvmDat     READE     SEMVTSL2

     C                   DOW       NOT %EOF(SEMVTSL2)

     C                   IF        WkSWIFTCod  = TMSWSC

     C                   ADD       1             IdS
     C     Ids           OCCUR     TrStatus

     C                   EVAL      WkMvmDat    = TMNTDT                         Notification Date
     C                   EVAL      WkSWIFTQual = SWStsQu(Idx)                   SWIFT Qualifier
     C                   EVAL      WkSWIFTCod  = TMSWSC                         SWIFT Status Code
     C                   EVAL      WkReasQual  = TMSWSC                         Reason Qualifier
     C                   EVAL      WkReasCod   = TMSWRC                         Reason Code
     C                   IF        TMNARR <> *Blanks
     C                   EVAL      WkReasNar   = %Subst(TMNARR:1:210)           Reason Narrative
     C                   ENDIF
     C                   ENDIF
     C     KeyMvmDat     READE     SEMVTSL2

     C                   ENDDO

      ** ##########################################################################################
      ** ## Retrieve only the last one ##
      ** ################################

     C     ONLYONE       TAG

      ** ##########################################################################################

      ** If the qualifier corresponding to the code is found and all details loaded, leave the
      ** status research.

     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF

     C                   ENDSR
      **********************************************************************
      * $LdTradStat - Load Transaction Status                              *
      **********************************************************************

     C     $LdTradStat   BEGSR
      *    -----------   -----

      ** Load the SWIFT Status

     C     1             DO        999           Ids

     C     Ids           OCCUR     TrStatus

     C                   IF        WkSWIFTQual = *Blanks
     C                   LEAVE
     C                   ENDIF

     C                   CLEAR                   SEPSTAD0

     C                   EVAL      PRSTAT =  WkSWIFTQual                        Transaction Status
     C                   EVAL      PRSTCD =  WkSWIFTCod                         Status Code
     C                   IF        WkReasCod <> *Blanks
     C                   EVAL      PRREAS =  WkReasQual                         Reason
     C                   EVAL      PRRECD =  WkReasCod                          Reason Code
     C                   ENDIF
     C                   IF        WkReasNar <> *Blanks
     C                   EVAL      PRNAR1 =  %SUBST(WkReasNar:  1:35)           Reason Narrative 1
     C                   EVAL      PRNAR2 =  %SUBST(WkReasNar: 36:35)           Reason Narrative 2
     C                   EVAL      PRNAR3 =  %SUBST(WkReasNar: 71:35)           Reason Narrative 3
     C                   EVAL      PRNAR4 =  %SUBST(WkReasNar:106:35)           Reason Narrative 4
     C                   EVAL      PRNAR5 =  %SUBST(WkReasNar:141:35)           Reason Narrative 5
     C                   EVAL      PRNAR6 =  %SUBST(WkReasNar:176:35)           Reason Narrative 6
     C                   ENDIF

      ** Evaluate the SWIFT message length
      *  ---------------------------------

     C                   EVAL      PRSIZE =   88                                Static fields
     C                                      + %LEN(PRSTAT)                      Transaction Status
     C                                      + %LEN(PRSTCD)                      Status Code
     C                                      + %LEN(PRREAS)                      Reason
     C                                      + %LEN(PRRECD)                      Reason Code
     C                                      + %LEN(%TRIM(PRNAR1))               Reason Narrative 1
     C                                      + %LEN(%TRIM(PRNAR2))               Reason Narrative 2
     C                                      + %LEN(%TRIM(PRNAR3))               Reason Narrative 3
     C                                      + %LEN(%TRIM(PRNAR4))               Reason Narrative 4
     C                                      + %LEN(%TRIM(PRNAR5))               Reason Narrative 5
     C                                      + %LEN(%TRIM(PRNAR6))               Reason Narrative 6

      **   For Pending transaction by transaction,
      **       the STATUS length should be included in the TRANSACTION length.

     C                   EVAL      PTSIZE = PTSIZE + PRSIZE                     Transaction length

      ** Add record to extract file
      *  ---------------------------

     C                   EVAL      PREXTR =  *ZEROS                             Extract Reference
     C                   EVAL      PRDATE =  SPDATE                             Request Date
     C                   EVAL      PRRSEQ =  SPRSEQ                             Request Sequence
     C                   EVAL      PRTSEQ =  WTrnBySub                          Transaction Sequence

     C                   WRITE     SEPSTAD0

     C                   ENDDO
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
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     DSBANK        PARM      DSBANK        DSFDY

      ** Access General Ledger details                                                        FIXPA

     C*                  CALL      'AOGELRR0'                                                 FIXPA
     C*                  PARM      '*DBERR '     @RTCD                                        FIXPA
     C*                  PARM      '*FIRST '     @OPTN                                        FIXPA
     C*    DSGELR        PARM      DSGELR        DSFDY                                        FIXPA

      ** Access Securities Trading ICD data                                                   FIXPA

     C                   CALL      'AOSTRDR0'                                                 FIXPA
     C                   PARM      '*DBERR '     @RTCD                                        FIXPA
     C                   PARM      '*FIRST '     @OPTN                                        FIXPA
     C     DSSTRD        PARM      DSSTRD        DSSDY                                        FIXPA

      ** Access Switchable features

      **  CSE015 - Forward Valued Depot Movements

     C                   MOVEL     'N'           CSE015            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSE015'      @SARD             6

     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CSE015
     C                   ENDIF

      ** Initialize LDA

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  PSProcName
     C                   OUT       LDA

      ** Key lists to access the settlements

     C     KeyTradSetSeq KLIST
     C                   KFLD                    TR_BRCA                        Branch Code
     C                   KFLD                    TR_REF                         Trade Reference
     C                   KFLD                    KSettSeq          3 0          Settlement Sequence

     C     KeyTradSet    KLIST
     C                   KFLD                    TR_BRCA                        Branch Code
     C                   KFLD                    TR_REF                         Trade Reference

      ** Key lists to access the Movement Details

     C     KeyMvmDat     KLIST
     C                   KFLD                    KMvmRef           6            Movement Reference
     C                   KFLD                    KMvnTyp           1            Transaction Type
     C                   KFLD                    KMvmDat           5 0          Midas Start Date

     C     KeyMvm        KLIST
     C                   KFLD                    KMvmRef                        Movement Reference
     C                   KFLD                    KMvnTyp                        Transaction Type

     C     KCustSec      KLIST
     C                   KFLD                    WkCUST                         Customer
     C                   KFLD                    SPSESN                         Security
      *                                                                                       CSW207
      ** Check for SWIFT 2007 is intalled                                                     CSW207
      *                                                                                       CSW207
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   PARM      *BLANKS       P@RTCD            7                          CSW207
     C     P@RTCD        IFEQ      'CSW2007'                                                  CSW207
     C                   MOVE      'Y'           CSW207            1                          CSW207
     C                   ELSE                                                                 CSW207
     C                   MOVE      'N'           CSW207                                       CSW207
     C                   ENDIF                                                                CSW207
      *                                                                                       CSW207
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
**CTDATA TbArgmt
C TP C            Y D C TRADE
C TS C            Y I C TRADE
C DP C            Y D C DVP
C RV C            Y I C DVP
C MT C            Y   C POSET
C WI C        IN  Y I C DEPOT
C WO C        OUT Y D C DEPOT
C BB C        IN  Y D C DEPOT
C BB C        OUT Y I C DEPOT
C BL C        IN  Y I C DEPOT
C BL C        OUT Y D C DEPOT
C PD C        IN  Y I C DEPOT
C PD C        OUT Y D C DEPOT
C PL C        IN  Y D C DEPOT
C PL C        OUT Y I C DEPOT
C RP C        IN  Y I C DEPOT
C RP C        OUT Y D C DEPOT
C RR C        IN  Y D C DEPOT
C RR C        OUT Y I C DEPOT
M TP M X   =      Y I U TRADE
M TP M X   <>     Y I U TRADE
M TP M   X =      N I C TRADE
M TP M   X <>     N I C TRADE
M TP C X   =      N     TRADE
M TP C X   <>     Y I U TRADE
M TP C   X =      N     TRADE
M TP C   X <>     Y D U TRADE
M TS M X   =      N I C TRADE
M TS M X   <>     N I C TRADE
M TS M   X =      Y D U TRADE
M TS M   X <>     Y D U TRADE
M TS C X   =      N     TRADE
M TS C X   <>     Y I U TRADE
M TS C   X =      N     TRADE
M TS C   X <>     Y D U TRADE
M DP C            Y D C DVP
M RV C            Y I C DVP
M MT C            Y   U POSET
M DP M            N     DVP
M RV M            N     DVP
M MT M            Y   U POSET
M WI M X   <> IN  Y I O DEPOT
M WI C X   <> IN  Y I O DEPOT
M WO M   X <> OUT Y D O DEPOT
M WO C   X <> OUT Y D O DEPOT
M DT C X   =  IN  Y I O DEPOT
M DT C X   =  OUT N     DEPOT
M DT C X   <> IN  Y I O DEPOT
M DT C X   <> OUT N     DEPOT
M DT C   X =  IN  N     DEPOT
M DT C   X =  OUT Y D O DEPOT
M DT C   X <> IN  N     DEPOT
M DT C   X <> OUT Y D O DEPOT
M DT M X   =  IN  Y I O DEPOT
M DT M X   =  OUT N     DEPOT
M DT M X   <> IN  Y I O DEPOT
M DT M X   <> OUT N     DEPOT
M DT M   X =  IN  N     DEPOT
M DT M   X =  OUT Y D O DEPOT
M DT M   X <> IN  N     DEPOT
M DT M   X <> OUT Y D O DEPOT
M BB C X   =  IN  N     DEPOT
M BB C X   =  OUT N     DEPOT
M BB C X   <> IN  Y I O DEPOT
M BB C X   <> OUT Y D O DEPOT
M BB C   X =  IN  N     DEPOT
M BB C   X =  OUT N     DEPOT
M BB C   X <> IN  Y D O DEPOT
M BB C   X <> OUT Y I O DEPOT
M BB M X   =  IN  Y I O DEPOT
M BB M X   =  OUT Y D O DEPOT
M BB M X   <> IN  Y I O DEPOT
M BB M X   <> OUT Y D O DEPOT
M BB M   X =  IN  N     DEPOT
M BB M   X =  OUT N     DEPOT
M BB M   X <> IN  N     DEPOT
M BB M   X <> OUT N     DEPOT
M BL C X   =  IN  N     DEPOT
M BL C X   =  OUT N     DEPOT
M BL C X   <> IN  Y D O DEPOT
M BL C X   <> OUT Y I O DEPOT
M BL C   X =  IN  N     DEPOT
M BL C   X =  OUT N     DEPOT
M BL C   X <> IN  Y I O DEPOT
M BL C   X <> OUT Y D O DEPOT
M BL M X   =  IN  Y D O DEPOT
M BL M X   =  OUT Y I O DEPOT
M BL M X   <> IN  Y D O DEPOT
M BL M X   <> OUT Y I O DEPOT
M BL M   X =  IN  N     DEPOT
M BL M   X =  OUT N     DEPOT
M BL M   X <> IN  N     DEPOT
M BL M   X <> OUT N     DEPOT
M PD C X   =  IN  N     DEPOT
M PD C X   =  OUT N     DEPOT
M PD C X   <> IN  Y D O DEPOT
M PD C X   <> OUT Y I O DEPOT
M PD C   X =  IN  N     DEPOT
M PD C   X =  OUT N     DEPOT
M PD C   X <> IN  Y I O DEPOT
M PD C   X <> OUT Y D O DEPOT
M PD M X   =  IN  Y D O DEPOT
M PD M X   =  OUT Y I O DEPOT
M PD M X   <> IN  Y D O DEPOT
M PD M X   <> OUT Y I O DEPOT
M PD M   X =  IN  N     DEPOT
M PD M   X =  OUT N     DEPOT
M PD M   X <> IN  N     DEPOT
M PD M   X <> OUT N     DEPOT
M PL C X   =  IN  N     DEPOT
M PL C X   =  OUT N     DEPOT
M PL C X   <> IN  Y I O DEPOT
M PL C X   <> OUT Y D O DEPOT
M PL C   X =  IN  N     DEPOT
M PL C   X =  OUT N     DEPOT
M PL C   X <> IN  Y D O DEPOT
M PL C   X <> OUT Y I O DEPOT
M PL M X   =  IN  Y I O DEPOT
M PL M X   =  OUT Y D O DEPOT
M PL M X   <> IN  Y I O DEPOT
M PL M X   <> OUT Y D O DEPOT
M PL M   X =  IN  N     DEPOT
M PL M   X =  OUT N     DEPOT
M PL M   X <> IN  N     DEPOT
M PL M   X <> OUT N     DEPOT
M RP C X   =  IN  N     DEPOT
M RP C X   =  OUT N     DEPOT
M RP C X   <> IN  Y D O DEPOT
M RP C X   <> OUT Y I O DEPOT
M RP C   X =  IN  N     DEPOT
M RP C   X =  OUT N     DEPOT
M RP C   X <> IN  Y I O DEPOT
M RP C   X <> OUT Y D O DEPOT
M RP M X   =  IN  Y D O DEPOT
M RP M X   =  OUT Y I O DEPOT
M RP M X   <> IN  Y D O DEPOT
M RP M X   <> OUT Y I O DEPOT
M RP M   X =  IN  N     DEPOT
M RP M   X =  OUT N     DEPOT
M RP M   X <> IN  N     DEPOT
M RP M   X <> OUT N     DEPOT
M RR C X   =  IN  N     DEPOT
M RR C X   =  OUT N     DEPOT
M RR C X   <> IN  Y I O DEPOT
M RR C X   <> OUT Y D O DEPOT
M RR C   X =  IN  N     DEPOT
M RR C   X =  OUT N     DEPOT
M RR C   X <> IN  Y D O DEPOT
M RR C   X <> OUT Y I O DEPOT
M RR M X   =  IN  Y I O DEPOT
M RR M X   =  OUT Y D O DEPOT
M RR M X   <> IN  Y I O DEPOT
M RR M X   <> OUT Y D O DEPOT
M RR M   X =  IN  N     DEPOT
M RR M   X =  OUT N     DEPOT
M RR M   X <> IN  N     DEPOT
M RR M   X <> OUT N     DEPOT
**CTDATA SWStsQu
MTCHINMHSETTIPRC
**CTDATA CPY@
(C) Copyright Misys International Banking Systems Ltd. 2004
