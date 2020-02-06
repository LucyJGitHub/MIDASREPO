     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Int Scale Enqry & Reprint - Details Enqry')   *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG007021 - Midas CG Int Scale Enquiry - Details Information  *
      *                                                               *
      *  Function:  This program displays the detail information of   *
      *             the selected item id.                             *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR797795 *CREATE   Date 19Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR797795 - Interest Scale Report Enquiry is missing in       *
      *             BFMidas                                           *
      *                                                               *
      *****************************************************************
     FCG007021DFCF   E             WORKSTN USROPN
     F                                     SFILE(CG007021S0:#0RLRN)
     F                                     INFDS(INFDS1)
     F                                     INFSR(*PSSR)
     FCGISDXL0  IF   E           K DISK
      ** CG Interest Scale Enquiry and Reprint - Detail extract
 
      *****************************************************************
     D GRP             S             25    DIM(57) CTDATA PERRCD(1)
     D DESC            S             30    DIM(57) ALT(GRP)
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      *
     D PGMDS         E DS                  EXTNAME(Y2PGDSP)
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      ** File information data structure
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
 
     D                 DS
      ** Message Data
     D  ZAMSDA                 1    132
     D  ZA0001                 1      1
     D  ZA0002                 1      1
     D  ZA0003                 1      1
     D  ZA0004                 1      1
     D  ZA0005                 1      1
     D  ZA0006                 1      1
 
     D CharLO          C                   'abcdefghijklmnopqrstuvwxyz'
     D CharUP          C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
 
     D DecFlg          S              1A
     D PDecs           S              1  0
     D PECode          S              1A
     D PFld15          S             15  0
     D PFld15C         S             15A
     D PITEM           S              8  0
     D PRTCD           S              7A
     D WCnt            S              3S 0
     D WLRCD           S              4S 0
     D WNODAT          S              1A
     D WOPTN           S              7A
     D WPOS            S              3S 0
     D WRCTR           S              5S 0
     D WRTCD           S              7A
     D W0RSF           S              1A
     D X1              S              2S 0
     D Y1              S              2S 0
     D W1              S              1S 0
 
     D ZAPGMQ          S             10A
     D ZAPGRL          S              5A
     D ZAMSID          S              7A
     D ZAMSGF          S             10A
     D ZAMSTP          S              7A
     D Zout21          S             21A
 
      ** Parameters for ZDATE11
     D DaynoOut        S              5P 0
     D ErrorFlag       S              1A
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long data structure for access objects
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External data structures for Bank Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** External DS for Access Programs
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      * External data structures for Currency Details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      **  External data structures for Switchable Features Details
 
     D WValArr1        S              1A   DIM(15)
     D WValArr2        S              1A   DIM(15)
     D WValArr3        S              1A   DIM(15)
      ** Array
     D PKEYI           DS           100
     D #LParm          DS            15
     D  LItem                  1      5P 0
     D  LDCor                  6     15
 
     C/TITLE Main Processing
 
      ** Perform Initialisation
     C                   EXSR      SRINIT
 
     C                   DO        *HIVAL
 
      ** Initialise and load subfile page
     C                   EXSR      SRIZSF
 
      ** Initialise reset field
     C                   MOVEL     'N'           W0RSF
     C                   Z-ADD     *ZEROS        WCnt
 
      ** Display screen
     C     W0RSF         DOWEQ     'N'
 
      ** Screen Display routine
     C                   EXSR      SRDSPS
 
      ** Process response
     C                   SELECT
      ** F12 is pressed
 
     C                   WHEN      *IN12 = *ON
     C                   EXSR      SRPREV
 
      ** Roll up is pressed
     C                   WHEN      *IN22 = *ON
     C                   EXSR      SRLOAD
 
     C                   ENDSL
 
     C                   ENDDO
 
     C                   ENDDO
      *****************************************************************
      *                                                               *
      *  SRINIT - Subroutine to do Program Initialisation             *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:                                                       *
      *  AOBANKR0   Access Object                                     *
      *  SRCLR    - Use to clear messages in program queue            *
      *                                                               *
      *****************************************************************
 
     C     SRINIT        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PITEM
 
     C                   MOVE      PITEM         H1ITEM
 
      ** Initialize LDA
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVE      *BLANKS       DBPGM
     C                   MOVE      'CG007021'    DBPGM
     C                   OUT       LDA
 
      ** Call Access Program for Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     WRTCD
     C                   PARM      '*FIRST '     WOPTN
     C     SDBANK        PARM      SDBANK        DSSDY
      ** Handle Database Error
     C     WRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      'SDBANKPD'    DBFILE
     C                   MOVEL     WOPTN         DBKEY
     C                   Z-ADD     001           DBASE
     C                   MOVEL     'CG007021'    DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialise Header Screen
     C                   OPEN      CG007021DF
     C                   Z-ADD     15            WSFPG             3 0
     C                   MOVEL     PSJobName     #0WSID
     C                   MOVEL     PSUser        #0USER
     C                   MOVEL     BJMRDT        #0RUNA
     C                   MOVEL     'CG007021'    #0PGMN
     C                   TIME                    #0TIME
     C                   MOVE      'N'           WNOAC             1
 
      ** Initialise screen message queue
     C                   MOVEL     *BLANKS       ZAMSDA
     C                   EXSR      SRCLR
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRIZSF - Subfile Initialisation and Load routine.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:                                                       *
      *  SRLOAD   - Load one page of subfile                          *
      *  SRCLR    - Clear messages in program queue                   *
      *****************************************************************
     C     SRIZSF        BEGSR
 
      ** Clear subfile
     C                   MOVE      *ON           *IN50
     C                   WRITE     CG007021C0
     C                   MOVE      *OFF          *IN50
 
      ** Reset no of records in subfile
     C                   Z-ADD     0             WLRCD
     C                   MOVE      *ON           *IN25
 
      ** Initialise No data work field
     C                   MOVE      'N'           WNODAT
     C                   MOVE      *OFF          *IN71
 
      ** Selection Mode
     C     PITEM         SETLL     CGISDXL0
     C     *IN34         IFEQ      *ON
     C                   EXSR      SRCLR
     C                   ENDIF
 
      ** Load subfile page
     C                   EXSR      SRLOAD
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRLOAD - Load one page of subfile.                           *
      *                                                               *
      *  Called By: SRIZSF and main processing                        *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRLOAD        BEGSR
 
      ** Reset SFLEND indicator and record counter
     C                   MOVE      *OFF          *IN51
     C                   Z-ADD     1             WRCTR
     C                   Z-ADD     WLRCD         #0RLRN
 
     C     PITEM         READE     CGISDXL0
     C                   EXSR      SRCLR
 
      *  CGISDXLO
      ** Load records until EOF
     C                   DOW       NOT %EOF(CGISDXL0) and WRCTR <= WSFPG
 
      ** Update the screen fields with CGISDXL0 field values
     C                   MOVEL     DXTAGN        DTAG             25
     C                   Z-ADD     1             Wx2               2 0
     C     DTAG          LOOKUP    GRP(Wx2)                               61
     C                   IF        *IN61 = *ON
     C                   MOVEL     DESC(Wx2)     D1TAGN
     C                   ELSE
     C                   MOVEL     DTAG          D1TAGN
     C                   ENDIF
 
     C                   EVAL      *IN72 = *OFF
     C                   IF        DXTAGH = DXTAGN
     C                   EVAL      *IN72 = *ON
     C                   ENDIF
 
     C                   MOVEL     DXTAGV        D1TAGV
     C                   IF        DXTAGN = 'IntScaleAccountBalance'
     C                             Or DXTAGN = 'IntScaleInterestAmount'
     C                             Or DXTAGN = 'IntScaleNetInterest'
     C                             Or DXTAGN = 'IntScaleTotalCRInterest'
     C                             Or DXTAGN = 'IntScaleTotalDRInterest'
     C                             Or DXTAGN = 'IntScaleInterestRate'
     C                             Or DXTAGN = 'IntScaleInterestDays'
     C                   EXSR      SrFmtAmt
     C                   ENDIF
 
      ** Write records to SFL
     C                   ADD       1             #0RLRN
     C                   ADD       1             WRCTR
     C                   WRITE     CG007021S0
 
      ** Read next record
     C     PITEM         READE     CGISDXL0
     C                   ENDDO
 
     C                   IF        #0RLRN = *ZEROS
     C                   MOVE      *ON           *IN34
     C                   MOVE      *OFF          *IN53
     C                   MOVEL     'USR7620'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN50
     C                   ELSE
 
      ** Seton SFLDSP
     C                   MOVE      *ON           *IN53
     C                   ENDIF
 
      ** Seton SFLEND indicator if EOF.
     C                   IF        %EOF(CGISDXL0)
     C                   MOVE      *ON           *IN51
     C                   ELSE
     C                   READP     CGISDXL0
     C                   ENDIF
 
      ** No records on subfile
     C     #0RLRN        IFEQ      0
     C                   MOVE      'Y'           WNODAT
     C                   ELSE
     C                   MOVE      'N'           WNODAT
     C                   ENDIF
 
      ** Save last relative record number to workfield
     C                   Z-ADD     #0RLRN        WLRCD
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrFmtAmt - Format Amount                                     *
      *****************************************************************
     C     SrFmtAmt      BEGSR
 
     C                   Z-ADD     15            Y1
     C                   Z-ADD     15            X1
     C                   Z-ADD     0             W1
     C                   Z-ADD     0             PDecs
     C                   MOVE      'N'           DecFlg
     C                   MOVEA     DXTAGV        WValArr1
     C                   MOVEA     *BLANKS       WValArr2
     C     X1            DOUEQ     0
     C                   IF        WValArr1(X1) <> ' '
     C                   IF        WvalArr1(X1) <> '.'
     C                   MOVE      WValArr1(X1)  WValArr2(Y1)
     C                   Sub       1             Y1
     C                   Add       1             W1
     C                   ELSE
     C                   IF        DecFlg  = 'N'
     C                   Z-ADD     W1            PDecs
     C                   MOVE      'Y'           DecFlg
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   Sub       1             X1
     C                   ENDDO
 
     C                   MOVEA     WValArr2      PFld15C
     C                   MOVE      PFld15C       PFld15
     C                   IF        WValArr1(1) = '-'
     C                   Z-SUB     PFld15        PFld15
     C                   ENDIF
 
     C                   CALL      'ZSEDIT'
     C                   PARM                    PFld15
     C                   PARM                    PDecs
     C                   PARM      'J'           PECode
     C                   PARM      *BLANKS       Zout21
     C                   MOVEL     Zout21        D1TAGV
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRDSPS - Display of initial screen                           *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *****************************************************************
 
     C     SRDSPS        BEGSR
 
      ** Update screen time
     C                   TIME                    #0TIME
 
      ** Display subfile page
     C                   IF        #0RLRN > 0
     C                   WRITE     CG007021H0
 
     C                   WRITE     CG007021F0
     C                   WRITE     CG007021C1
     C                   ENDIF
 
     C                   IF        #0RLRN > 0
     C                   EXFMT     CG007021C0
     C                   ELSE
     C                   EXFMT     CG007021D1
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SRPREV - Go to previous screen if F12 is pressed
      *
      * Called By : Main Processing
      * Calls     : SR/END
      *****************************************************************
      *
     C     SRPREV        BEGSR
 
      **   Set F12 return code and end program
     C                   MOVE      'USR0790'     PRTCD
     C                   EXSR      SRCLR
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCLR  - Use to clear messages in program queue.             *
      *                                                               *
      *  Called By: SRINIT, SRDSPS, SRPROC, SRVALI, subroutine        *
      *                                                               *
      *  Calls:                                                       *
      *  Y2CLMSC   - Clear messages from program queue                *
      *                                                               *
      *****************************************************************
 
     C     SRCLR         BEGSR
 
      ** Initialize error indicators
     C                   EVAL      *IN34 = *OFF
 
     C                   EVAL      ##PGM = 'CG007021'
      ** Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
     C                   WRITE     CG007021C1
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  ZASNMS - Use to send message to program queue. Used for      *
      *           sending messages or other information.              *
      *                                                               *
      *  Called By: SRLOAD, SRVALS, SRVALI subroutines                *
      *                                                               *
      *  Calls:                                                       *
      *  Y2SNMGC   - Send messages to program queue                   *
      *                                                               *
      *****************************************************************
 
     C     ZASNMS        BEGSR
 
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   ENDIF
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Standard DB Error processing                        *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   DUMP
     C                   MOVE      *ON           *INLR
     C                   CALL      'DBERRCTL'
 
     C                   ENDSR
      *****************************************************************
** GRP/DESC
BranchDetails             Branch
BranchCode                Branch Code
BranchName                Branch Name
ZBranchInternalCustomer   Branch Internal Customer
BranchInternalBOJ         Branch Internal BOJ
BranchInternalChapsSort   Branch Internal Chaps Sort
BranchInternalChipsABA    Branch Internal Chips ABA
BranchInternalChipsID     Branch Internal Chips ID
BranchInternalFedwire     Branch Internal Fedwire
BranchInternalCustNo      Branch Internal Customer No
ZBankleitzahl             Bankleitzahl
ZSwiftCode                SWIFT Code
ZTelephoneNumber          Telephone Number
ZFaxNumber                Fax Number
ZTelexNumber              Telex Number
CustomerData              Customer Data
CustBOJ                   Customer BOJ
CustChapsSortcode         Customer Chaps Sort Code
CustChipsABA              Customer Chips ABA
CustChips                 Customer Chips
CustFedwire               Customer Fedwire
CustAddrLine1             Customer Address Line 1
CustAddrLine2             Customer Address Line 2
CustAddrLine3             Customer Address Line 3
CustAddrLine4             Customer Address Line 4
CustBankleitzahl          Customer Bank Lietzahl
CustFax                   Customer Fax
CustName                  Customer Shortname
CustSwiftID               Customer Swift ID
CustTelephoneNo           Customer Telephone No
CustTown                  Customer Town
CustNo                    Customer Number
IntScaleFooterDetails     Int Scale Footer Details
IntScaleNetInterest       Int Scale Net Interest
IntScaleExtractDate       Int Scale Extract Date
IntScaleTotalCRInterest   Int Scale Total CR Interest
IntScaleTotalDRInterest   Int Scale Total DR Interest
InterestScaleType         Interest Scale Type
IntScaleHeaderDetails     Int Scale Header Details
AccountName               Account Name
Currency                  Currency
DealNo                    Deal No
IbanNo                    IBAN Number
RetailAccNo               Retail Account Number
TransactionClass          Transaction Class
IntScaleEndDate           Int Scale End Date
IntScaleMonthYear         Int Scale Month Year
IntScalePrintDate         Int Scale Print Date
IntScaleStartDate         Int Scale Start Date
IntScaleType              Int Scale Type
IntScalePostingsDetails   Int Scale Postings Details
IntScaleInterestDays      Int Scale Interest Days
IntScaleInterestRate      Int Scale Interest Rate
IntScaleAccountBalance    Int Scale Account Balance
IntScaleBalanceDate       Int Scale Balance Date
IntScaleInterestAmount    Int Scale Interest Amount
IntScaleManualAdjustment  Int Scale Manual Adjustment
