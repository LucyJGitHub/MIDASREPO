     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Authority Holders Link Report for KWG @24')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000110 - Midas SD Customers Details Display                *
      *                                                               *
      *  Function - This program reports Customer-Authority Holders   *
      *             Link from the DB Customer to Authority Holder Link*
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD053634           Date 21Oct19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL132             Date 01May13               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24229           Date 05Jun09               *
      *                 BUG24073           Date 25May09               *
      *                 BUG22210           Date 14Jan09               *
      *                 CER047  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD053634 - Requested Customer “Authority Holders Link Report *
      *             for KWG$24c” not generated.                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24229 - LE Product Group is not being captureed in Report *
      *  BUG24073 - Duplicate Lines showing in Customer Authority     *
      *             Holders Report                                    *
      *  BUG22210 - Authority Holder Number should be of 10 digits    *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    31         Print File - Print No. of A/C or print Const.   *
      *    34         Print File - Consolidated/Detail                *
      *    35         Print File - sort by Customer/Authority Holder  *
      *    60         EOF SDCUAHL1/SDCUAHL2                           *
      *    61         EOF SDCUAHL1/SDCUAHL2                           *
      *    63         EOF ACCNTL0                                     *
      *    71         Overflow Indicator                              *
      *                                                               *
      *    U7+U8 - Database error occurs                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRNonRAC - Output records for Product Group OT/LO/TD         *
      *  SRConsol - output records for Product Group AL/RE - consol.  *
      *  SRDetailC - Output details report - select by customer       *
      *  SRDetailA - Output details report - select by                *
      *              Authority Holder                                 *
      *  SRAcHld - Output records from the file Midas Authority Holder*
      *  SRNoOfAC - Calculate number of A/Cs of a customer            *
      *  SRInitFld - Initialisation of Output fields                  *
      *  SRFill - Fill the fileds                                     *
      *  SRWrite - Write record in Printer file                       *
      *  *PSSR - Program exception error routine                      *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas Customer/Authority Holder Link Retrieval Ind
      *
     FSDCUAHL1  UF   E           K DISK
      *
      ** Midas Customer/Authority Holder by Authority hld
      *
     FSDCUAHL2  UF   E           K DISK    RENAME(SDCUAHD0:SDCUAHx1)
      *
      ** Midas SD Customer details retrieval
      *
     FSDCUSTL1  IF   E           K DISK
      *
      ** Midas GL Account details - full a/c number
      *
     FACCNTL0   IF   E           K DISK    RENAME(ACCNTABF:ACCNTAx1)
     F                                     PREFIX(R1)
      *
      ** Midas Authority Holders Report
      *
     FSD000110P1O    E             PRINTER OFLIND(*IN71)
     F                                     INFDS(SPOOL1)
      *                                                                                     BUG24073
      ** Midas Authority holder/Retail Account Link                                         BUG24073
      *                                                                                     BUG24073
     FSDACAHL2  IF   E           K DISK                                                     BUG24073
      *                                                                                     BUG24073
      ** Midas Authority holder/Retail Account Link                                         BUG24073
      *                                                                                     BUG24073
     FSDACAHL3  IF   E           K DISK    RENAME(SDACAHD0:SDACAHD3)                        BUG24073
      *                                                                                     BUG24073
      ** Midas GL Account details - retail key                                              BUG24073
      *                                                                                     BUG24073
     FACCNTL1   IF   E           K DISK    RENAME(ACCNTABF:ACCNTAx2)                        BUG24073
     F                                     PREFIX(R2:0)                                     BUG24073
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                    error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the standard declares
      *
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields in
      ** the PSDS. They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** File Information Data Structure for SD000110P1
      *
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** First DS for access programs, short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** External data structures for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for Non-Account Holder details
      *
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
      *                                                                                     BUG22210
      ** Externally described DS for Customer details                                       BUG22210
      *                                                                                     BUG22210
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                BUG22210
      *
      ** DS for access objects - very long data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *                                                                                     BUG22210
      ** DS for access objects - very long data structure                                   BUG22210
      *                                                                                     BUG22210
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   BUG22210
      *
      ** Definition of indicators
      *
     D IndicatorPtr    S               *   INZ(%ADDR(*IN))
     D                 DS                  BASED(IndicatorPtr)
      *
      ** Ind 31 = Print constant '*** A/C Link ***' instead of No. of
      ** A/C
      *
     D  WPrtConst             31     31
      *
      ** Ind 71 = New page
      *
     D  WNewPageHdr           71     71
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Print End of Report
      *
     D WSeparLin       S               N
      *
      ** Print End of Report
      *
     D WEndOfRep       S               N
      *
     D WRun            S              1A
      *
      ** ENTRY Parameters
      *
     D PRSeq           S              5A
     D PRLev           S              1A
     D PREnt           S              3A
     D PRAct           S              1A
     D PRCmd           S              1A
      *
      ** Parameter Variables
      *
     D PRtCd           S              7A
     D POptn           S              7A
     D PCustNo         S             10A                                                    BUG22210
     D PKyst           S              7A                                                    BUG22210
      *
      ** Working DS to setup PParm
      *
     D PParm           DS           100
      *
      ** Select by Customer/Authority holder
      *
     D WCustAuth               1      1A
      *
      ** Type of report - Consolidated/Details
      *
     D WRepTyp                 2      2A
      *
      ** Parameters for ZSFILE
      *
     D PEnty           S              3A
     D PFile           S             10A
     D PSNum           S              6  0
     D PSErr           S              1A
      *
      ** Customer number
      *
     D WCnum           S              6A
     D*WCnumN***       S              6S 0                                                    CER059
     D WCnumN          S              6A                                                      CER059
      *
      ** Print variable of Customer
      *
     D WCnumP          S              6
      *
      ** Counter for the number of Retail A/C
      *
     D WCount          S              5S 0
      *
      ** Product group
      *
     D WnAC            S              2
     D WPdg            S              2
      *
      ** Authority Holder
      *
     D WAuth           S             10A
      *
      ** Print variable of Authority holder
      *
     D*WAuthP***       S              6A                                                    BUG22210
     D WAuthP          S             10A                                                    BUG22210
      *
     D PNaho           S             10A
      *
      ** Retail A/C Number
      *
     D WAcno           S             10
     D WAnam           S             20
      *
      ** Link type
      *
     D WLTyp           S              2
                                                                                              CGL132
      ** Controlling Interest                                                                 CGL132
     D WCInt           S              1                                                       CGL132
                                                                                              CGL132
      ** Controlling Interest Percentage                                                      CGL132
     D WPcnt           S              3                                                       CGL132
                                                                                            MD053634
     D WTylc           S              1                                                     MD053634
      *
      ** Customer Shortname
      *
     D WCcSsn          S             10
      *
      ** Authority holder Shortname
      *
     D WAcSsn          S             10
      *
      ** No record found
      *
     D WNoRecord       S              1
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Read Customer/Authority Holder Link file according
      ** the passed parameters
      *
     C   35              READ      SDCUAHL1                               60
     C  N35              READ      SDCUAHL2                               60
      *
      ** No record found
      *
     C   60              EVAL      WNoRecord = 'Y'
      *
      ** Read untill EOF
      *
     C                   DOW       *IN60 = *OFF
      *
      ** Fill the key-customer for the next subroutines
      ** If Select by customer - move customer, else move Authority
      ** Holder
      *
     C                   IF        WCustAuth = 'C'
      *
     C                   EVAL      WCnum = CACUST
      *
      ** Convert Customer to the numeric value
      *
     C                   MOVE      CACUST        WCnumN
     C                   EVAL      WCnumP = CACUST
     C                   ELSE
      *
      ** Move Authority Holder to the output field
      *
     C                   EVAL      WAuth = CAAUTH
     C                   EVAL      WAuthP = CAAUTH
      *
     C                   ENDIF
      *
      ** Process Product Group 'OT'
      *
     C                   EVAL      WnAC = 'OT'
     C                   EXSR      SRNonRAC
      *
      ***Process*Product*Group*'LO'                                                         BUG24229
      ** Process Product Group 'LE'                                                         BUG24229
      *
     C**********         EVAL      WnAC = 'LO'                                              BUG24229
     C                   EVAL      WnAC = 'LE'                                              BUG24229
     C                   EXSR      SRNonRAC
      *
      ***Process*Product*Group*'TD'                                                         BUG24229
      ** Process Product Group 'MM'                                                         BUG24229
      *
     C**********         EVAL      WnAC = 'TD'                                              BUG24229
     C                   EVAL      WnAC = 'MM'                                              BUG24229
     C                   EXSR      SRNonRAC
      *
      ** Process Product Group 'AL'
      *
     C                   EVAL      WnAC = 'AL'
      *
      ** Process Type of report : 'C' - Conslidated / 'D' - Details;
      ** Select by Customer/Authority H.
      *
     C                   SELECT
     C                   WHEN      WRepTyp = 'C'
     C                   EXSR      SRConsol
     C                   WHEN      WRepTyp = 'D' AND WCustAuth = 'C'
     C                   EXSR      SRDetailC
     C                   WHEN      WRepTyp = 'D' AND WCustAuth = 'A'
     C                   EXSR      SRDetailA
     C                   ENDSL
      *
      ** Process Product Group 'RE'
      *
     C                   EVAL      WnAC = 'RE'
      *
      ** Process Type of report : 'C' - Conslidated / 'D' - Details;
      ** Select by Customer/Authority H.
      *
     C                   SELECT
     C                   WHEN      WRepTyp = 'C'
     C                   EXSR      SRConsol
     C                   WHEN      WRepTyp = 'D' AND WCustAuth = 'C'
     C                   EXSR      SRDetailC
     C                   WHEN      WRepTyp = 'D' AND WCustAuth = 'A'
     C                   EXSR      SRDetailA
     C                   ENDSL
      *
      ** Process records from the file Midas Account/Authority Holder
      *
     C                   EXSR      SRAcHld
      *
      ** Read the next customer
      *
     C   35WCnum         SETGT     SDCUAHL1
     C   35              READ      SDCUAHL1                               60
     C  N35WAuth         SETGT     SDCUAHL2
     C  N35              READ      SDCUAHL2                               60
     C                   ENDDO
      *
      ** Print End of Report
      *
     C                   EVAL      WEndOfRep = *ON
     C                   EXSR      SRWrite
      *
     C                   EVAL      *INLR = *ON
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNonRAC - Output records for Product Group OT/LO/TD         *
      *                                                               *
      *  Called by: MAIN processing                                   *
      *                                                               *
      *  Calls: SRInitFld, SRFill, SRWrite                            *
      *                                                               *
      *****************************************************************
      *
     C     SRNonRAC      BEGSR
      *
      ** Prepare  Product Group for output
      *
     C                   EVAL      WPdg = WnAC
      *
      ** Do not output A/C info for the processed Product Group
      *
     C                   EVAL      WAcno = *BLANKS
     C                   EVAL      WAnam = *BLANKS
      *
      ** Read Customer/Authority Holder Link file by customer,
      ** according the passed parameters
      *
     C   35WCnum         CHAIN     SDCUAHL1                           60
     C  N35WAuth         CHAIN     SDCUAHL2                           60
      *
      ** Read untill EOF
      *
     C                   DOW       *IN60 = *OFF
      *
      ** Fill the key-Authority Holder if select by customer, else
      ** opposite
      *
     C                   IF        WCustAuth = 'C'
     C                   EVAL      WAuthP = CAAUTH
     C                   ELSE
     C                   EVAL      WCnumP = CACUST
     C                   ENDIF
      *
      ** Prepare Link Type for output
      *
     C                   EVAL      WLTyp = CALTYP
     C                   EVAL      WCInt = CACINT                                             CGL132
     C                   EVAL      WPcnt = CAPCNT                                             CGL132
                                                                                            MD053634
     C                   EVAL      WTYLC = CATYLC                                           MD053634
      *
      ***If*Product*Group*=*procesed*Product*Goup*OT/LO/TD                                  BUG24229
      ** If Product Group = procesed Product Goup LE/RE/OT/MM/AL                            BUG24229
      *
     C                   IF        CAPRG1 = WnAC OR CAPRG2 = WnAC OR
     C                             CAPRG3 = WnAC OR CAPRG4 = WnAC
      *
      ** Init, fill and output fields
      *
     C                   EXSR      SRInitFld
     C                   EXSR      SRFill
     C                   EXSR      SRWrite
      *
      ** Reset Customer/Authority Holder to print them only one time
      *
     C                   IF        WCustAuth = 'C'
     C                   EVAL      WCnumP = *BLANKS
     C                   ELSE
     C                   EVAL      WAuthP = *BLANKS
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Read the next record for the processed customer
      *
     C   35WCnum         READE     SDCUAHL1                               60
     C  N35WAuth         READE     SDCUAHL2                               60
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRConsol - output records for Product Group AL/RE - consol.  *
      *                                                               *
      *  Called by: MAIN processing                                   *
      *                                                               *
      *  Calls: SRInitFld, SRFill, SRWrite, SRNoOfAC                  *
      *                                                               *
      *****************************************************************
      *
     C     SRConsol      BEGSR
      *
      ** Prepare Product Group for output
      *
     C                   EVAL      WPdg = WnAC
      *
      ** Do not output A/C info for the Consolidated report
      *
     C                   EVAL      WAcno = *BLANKS
     C                   EVAL      WAnam = *BLANKS
      *
      ** Get number of A/C of Cusotmer, if select by customer (it is
      ** necessary display only one time
      ** A/C and all Authority Holder to its
      *
     C                   IF        WCustAuth = 'C'
     C                   EXSR      SRNoOfAC
     C                   ENDIF
      *
      ** Read Customer/Authority Holder Link file according the passed
      ** parameters
      *
     C   35WCnum         CHAIN     SDCUAHL1                           60
     C  N35WAuth         CHAIN     SDCUAHL2                           60
      *
      ** Read untill EOF
      *
     C                   DOW       *IN60 = *OFF
      *
      ** Write record only if Product Group of Customer/Authority
      ** Holder = Just now processed
      ** Product Group
      *
     C                   IF        CAPRG1 = WnAC OR CAPRG2 = WnAC OR
     C                             CAPRG3 = WnAC OR CAPRG4 = WnAC
      *
      ** Fill the key-Authority Holder
      ** If Select by Customer - move Authority Holder, else fill
      ** Customer
      *
     C                   IF        WCustAuth = 'C'
     C                   EVAL      WAuthP = CAAUTH
     C                   ELSE
      *
      ** Move Authority holder to the output field
      *
     C                   EVAL      WCnumP = CACUST
     C                   ENDIF
      *
      ** Get number of A/C of Cusotmer of Authority Holder, if select
      ** by Authority Holder
      *
     C                   IF        WCustAuth = 'A'
     C                   EXSR      SRNoOfAC
     C                   ENDIF
      *
      ** Prepare Link Type for output
      *
     C                   EVAL      WLTyp = CALTYP
     C                   EVAL      WCInt = CACINT                                             CGL132
     C                   EVAL      WPcnt = CAPCNT                                             CGL132
                                                                                            MD053634
     C                   EVAL      WTYLC = CATYLC                                           MD053634
      *
      ** Init, fill and output fileds
      *
     C                   EXSR      SRInitFld
     C                   EXSR      SRFill
     C                   EXSR      SRWrite
      *
      ** Reset Customer/Authority Holder to print them only one time
      *
     C                   IF        WCustAuth = 'C'
     C                   EVAL      WCnumP = *BLANKS
     C                   ELSE
      *
      ** Move Authority holder to the output field
      *
     C                   EVAL      WAuthP = *BLANKS
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Reset counter, if select by Customer
      *
     C                   IF        WCustAuth = 'C'
     C                   EVAL      WCount = 0
     C                   ENDIF
      *
      ** Read the next record for the processed customer
      *
     C   35WCnum         READE     SDCUAHL1                               60
     C  N35WAuth         READE     SDCUAHL2                               60
      *
     C                   ENDDO
      *
      ** Reset counter
      *
     C                   EVAL      WCount = 0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDetailC - Output details report - select by customer       *
      *                                                               *
      *  Called by: MAIN processing                                   *
      *                                                               *
      *  Calls: SRInitFld, SRFill, SRWrite                            *
      *                                                               *
      *****************************************************************
      *
     C     SRDetailC     BEGSR
      *
      ** Prepare  Product Group for output
      *
     C                   EVAL      WPdg = WnAC
      *
      ** Read Account Details file according the passed parameters
      *
     C     WCnumN        CHAIN     ACCNTL0
      *
      ** Read untill EOF
      *
     C                   DOW       NOT %EOF(ACCNTL0)
      *
      ** Prepare A/C info for output
      *
     C                   MOVE      R1ACNO        WAcno
     C                   EVAL      WAnam = R1ANAM
      *
      ** Do only if retail A/C
      *
     C                   IF        R1ATYP = 'R'
      *
      ** Read CustomerAuthority Holder Link file according the
      ** passed parameters
      *
     C     WCnum         CHAIN     SDCUAHL1
      *
      ** Read untill EOF
      *
     C                   DOW       NOT %EOF(SDCUAHL1)
      *
      ** Fill the key-Authority Holder
      *
     C                   EVAL      WAuthP = CAAUTH
      *
      ** Prepare Link Type for output
      *
     C                   EVAL      WLTyp = CALTYP
     C                   EVAL      WCInt = CACINT                                             CGL132
     C                   EVAL      WPcnt = CAPCNT                                             CGL132
      *
      ** Write record only if Product Group of Customer =
      ** Just now processed Product Group
      *
     C                   IF        CAPRG1 = WnAC OR CAPRG2 = WnAC OR
     C                             CAPRG3 = WnAC OR CAPRG4 = WnAC
      *
      ** Init, fill and output fileds
      *
     C                   EXSR      SRInitFld
     C                   EXSR      SRFill
     C                   EXSR      SRWrite
      *
      ** Reset Customer
      *
     C                   EVAL      WCnumP = *BLANKS
     C                   ENDIF
      *
      ** Reset A/C info - not necessary output for every Customer
      ** authorised for this A/C
      *
     C                   EVAL      WAcno = *BLANKS
     C                   EVAL      WAnam = *BLANKS
      *
      ** Read the next record for the processed customer
      *
     C     WCnum         READE     SDCUAHL1
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Read the next record for the processed customer
      *
     C     WCnumN        READE     ACCNTL0
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDetailA - Output details report - select by                *
      *              Authority Holder                                 *
      *                                                               *
      *  Called by: MAIN processing                                   *
      *                                                               *
      *  Calls: SRInitFld, SRFill, SRWrite                            *
      *                                                               *
      *****************************************************************
      *
     C     SRDetailA     BEGSR
      *
      ** Prepare  Product Group for output
      *
     C                   EVAL      WPdg = WnAC
      *
      ** Read Customer/Authority Holder Link file according the
      ** passed parameters
      *
     C     WAuth         CHAIN     SDCUAHL2
      *
      ** Read untill EOF
      *
     C                   DOW       NOT %EOF(SDCUAHL2)
      *
      ** write record only if Product Group of Authority Holder =
      ** Just now processed Product Group
      *
     C                   IF        CAPRG1 = WnAC OR CAPRG2 = WnAC OR
     C                             CAPRG3 = WnAC OR CAPRG4 = WnAC
      *
      ** Prepare Link Type for output
      *
     C                   EVAL      WLTyp = CALTYP
     C                   EVAL      WCInt = CACINT                                             CGL132
     C                   EVAL      WPcnt = CAPCNT                                             CGL132
      *
      ** Convert Customer to the numeric value
      *
     C                   MOVE      CACUST        WCnumN
      *
      ** Get all A/C of Customer to which is Authority Holder
      ** authorised
      *
     C     WCnumN        CHAIN     ACCNTL0
      *
      ** Read untill EOF
      *
     C                   DOW       NOT %EOF(ACCNTL0)
      *
      ** Count only retail A/Cs
      *
     C                   IF        R1ATYP = 'R'
      *
      ** Prepare A/C info for output
      *
     C                   MOVE      R1ACNO        WAcno
     C                   EVAL      WAnam = R1ANAM
      *
      ** Move Authorita holder to the output field
      *
     C                   MOVE      R1CNUM        WCnumP
      *
      ** Init, fill and output fileds
      *
     C                   EXSR      SRInitFld
     C                   EXSR      SRFill
     C                   EXSR      SRWrite
      *
      ** Reset Auhority Holder
      *
     C                   EVAL      WAuthP = *BLANKS
      *
     C                   ENDIF
      *
      ** Read the next A/C for the processed customer
      *
     C     WCnumN        READE     ACCNTL0
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Read the next record for the processed customer
      *
     C     WAuth         READE     SDCUAHL2
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAcHld - Output records from the file Midas Authority Holder*
      *                                                               *
      *  Called by: MAIN processing                                   *
      *                                                               *
      *  Calls: SRInitFld, SRFill, SRWrite                            *
      *                                                               *
      *****************************************************************
      *
     C     SRAcHld       BEGSR
      *
      ** Do not output Product Group during the process Account/
      ** Authority Holder file to found all
      ** Authority Holder for the processed customer
      *
     C                   EVAL      WPdg = *BLANKS
      *
      ** Read Account/Authority Holder Link file according the
      ** passed parameters
      *
     C***35WCnum         CHAIN     SDCUAHL1                           61                    BUG24073
     C**N35WAuth         CHAIN     SDCUAHL2                           61                    BUG24073
     C   35WCnumN        CHAIN     SDACAHL3                           61                    BUG24073
     C  N35WAuth         CHAIN     SDACAHL2                           61                    BUG24073
      *
      ** For Account/Authority holder file output '*** A/C Link ***'
      *
     C                   EVAL      WPrtConst = *ON
      *
      ** Read untill EOF
      *
     C                   DOW       *IN61 = *OFF
      *                                                                                     BUG22210
     C**********         MOVE      CACUST        WCnumN                            BUG22210 BUG24073
      *
      ** Chain the Account Details file to get A/C info
      *
     C*****WCnumN        CHAIN     ACCNTL0                            63                    BUG24073
     C     AAACNO        CHAIN     ACCNTL1                            63                    BUG24073
      *
      ** Prepare for output A/C number, A/C name and Link Type
      *
     C**********         MOVE      R1ACOD        WAcno                                      BUG24073
     C                   MOVE      AAACNO        WAcno                                      BUG24073
     C**********         EVAL      WAnam = R1ANAM                                           BUG24073
     C                   EVAL      WAnam = R2ANAM                                           BUG24073
     C**********         EVAL      WLTyp = CALTYP                                           BUG24073
     C                   EVAL      WLTyp = AALTYP                                           BUG24073
     C                   EVAL      WCInt = CACINT                                             CGL132
     C                   EVAL      WPcnt = CAPCNT                                             CGL132
     C                   EVAL      WTYLC = AATYLC                                           MD053634
      *
      ** Fill the key-Authority Holder
      ** If Select by Customer - move Authority Holder, else fill
      ** Customer
      *
     C                   IF        WCustAuth = 'C'
     C**********         EVAL      WAuthP = CAAUTH                                          BUG24073
     C                   EVAL      WAuthP = AAAUTH                                          BUG24073
     C                   ELSE
     C**********         MOVE      R1CNUM        WCnumP                                     BUG22210
     C**********         EVAL      WCnumP = CACUST                                 BUG22210 BUG24073
     C                   MOVE      R2CNUM        WCnumP                                     BUG24073
     C                   ENDIF
      *
      ** Init, fill and output fileds
      *
     C                   EXSR      SRInitFld
     C                   EXSR      SRFill
     C                   EXSR      SRWrite
      *
      ** Reset Customer/Authority Holder to print them only one time
      *
     C                   IF        WCustAuth = 'C'
     C                   EVAL      WCnumP = *BLANKS
     C                   ELSE
     C                   EVAL      WAuthP = *BLANKS
     C                   ENDIF
      *
      ** Read the next record for the processed customer
      *
     C***35WCnumN        READE     SDCUAHL1                               61                BUG24073
     C**N35WAuth         READE     SDCUAHL2                               61                BUG24073
     C   35WCnumN        READE     SDACAHL3                               61                BUG24073
     C  N35WAuth         READE     SDACAHL2                               61                BUG24073
     C                   ENDDO
      *
      ** End of printing A/C Authority Holders details
      *
     C                   EVAL      WPrtConst = *OFF
      *
      ** Print Separator line, because the new customer will be processed
      *
     C                   EVAL      WSeparLin = *ON
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNoOfAC - Calculate number of A/Cs of a customer            *
      *                                                               *
      *  Called by: SRConsol                                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRNoOfAC      BEGSR
      *
      ** Move Customer/Authority Holder to the numeric field for the
      ** founding A/C in Account file
      *
     C                   MOVE      CACUST        WCnumN
      *
      ** Reset counter
      *
     C                   EVAL      WCount = *ZEROS
      *
      ** Get number of A/C
      *
     C     WCnumN        CHAIN     ACCNTL0
      *
      ** Read untill EOF
      *
     C                   DOW       NOT %EOF(ACCNTL0)
      *
      ** Count only retail A/Cs
      *
     C                   IF        R1ATYP = 'R'
     C                   EVAL      WCount = WCount + 1
     C                   ENDIF
      *
      ** Read the next A/C for the processed customer
      *
     C     WCnumN        READE     ACCNTL0
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInitFld - Initialisation of Output fields                  *
      *                                                               *
      *  Called by: SRNonRAC, SRConsol, SRDetailC, SRDetailA, SRAcHld *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRInitFld     BEGSR
      *
     C                   EVAL      RNBR1 = *BLANKS
     C                   EVAL      RNAME1 = *BLANKS
     C                   EVAL      RACNO = *BLANKS
     C                   EVAL      RNBR2 = *BLANKS
     C                   EVAL      RNAME2 = *BLANKS
     C                   EVAL      RLINK = *BLANKS
     C                   EVAL      RCINT = *BLANKS                                            CGL132
     C                   EVAL      RPCNT = *BLANKS                                            CGL132
     C                   EVAL      RPDG = *BLANKS
     C                   MOVE      *BLANKS       RNOAC
     C                   EVAL      RACNO = *BLANKS
     C                   EVAL      RANAM = *BLANKS
     C                   EVAL      WCcSsn = *BLANKS
     C                   EVAL      WAcSsn = *BLANKS
     C                   EVAL      RTYLC  = *BLANKS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFill - Fill the fileds                                     *
      *                                                               *
      *  Called by: SRNonRAC, SRConsol, SRDetailC, SRDetailA, SRAcHld *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRFill        BEGSR
      *
      ** Get a Customer and Authority holder name
      *
     C                   IF        WCnumP <> *BLANKS
      *
      ***Chain*the*Customer*details*file*to*get*a*details*of*Customer                       BUG22210
      ** Access the Customer Details                                                        BUG22210
      *
     C*****WCnumP        Chain     SDCUSTL1                                                 BUG22210
     C**********         IF        %FOUND(SDCUSTL1)                                         BUG22210
     C**********         EVAL      WCcSsn = BBCSSN                                          BUG22210
     C**********         ENDIF                                                              BUG22210
     C                   EVAL      PCustNo = WCnumP                                         BUG22210
      *                                                                                     BUG22210
     C                   CALL      'AOCUSTR0'                                               BUG22210
     C                   PARM      *BLANKS       PRtcd                                      BUG22210
     C                   PARM      '*KEY   '     POptn                                      BUG22210
     C                   PARM                    PCustNo                                    BUG22210
     C                   PARM      *BLANKS       PKyst                                      BUG22210
     C     SDCUST        PARM      SDCUST        DSLDY                                      BUG22210
      *
     C                   IF        PRtcd = *BLANKS                                          BUG22210
     C                   EVAL      WCcSsn = BBCSSN                                          BUG22210
     C                   ENDIF                                                              BUG22210
      *                                                                                     BUG22210
     C                   ENDIF
      *
      ** Get Shortname of Authority holder/Customer
      *
     C                   IF        WAuthP <> *BLANKS
      *
      ***Chain*the*Customer*details*file*to*get*a*details*of                                BUG22210
      ***Authority*Holder                                                                   BUG22210
      ** Access the Customer Details                                                        BUG22210
      *
     C*****WAuthP        CHAIN     SDCUSTL1                                                 BUG22210
     C**********         IF        %FOUND(SDCUSTL1)                                         BUG22210
     C                   EVAL      PCustNo = WAuthP                                         BUG22210
      *                                                                                     BUG22210
     C                   CALL      'AOCUSTR0'                                               BUG22210
     C                   PARM      *BLANKS       PRtcd                                      BUG22210
     C                   PARM      '*KEY   '     POptn                                      BUG22210
     C                   PARM                    PCustNo                                    BUG22210
     C                   PARM      *BLANKS       PKyst                                      BUG22210
     C     SDCUST        PARM      SDCUST        DSLDY                                      BUG22210
      *                                                                                     BUG22210
     C                   IF        PRtcd = *BLANKS                                          BUG22210
     C                   MOVEL     BBCSSN        WAcSsn
     C                   ELSE
      *
      ** Get Surname of Authority holder/Customer, if Authority
      ** holder is not a Customer
      *
     C                   CALL      'AONAHOR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      WAuthP        PNaho
     C     SDNAHO        PARM      SDNAHO        DSSDY
      *
      ** If found write a Surname of Authority Holder
      *
     C                   IF        PRtCd = *BLANKS
     C                   MOVEL     NHIDE1        WAcSsn
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Fill the Variables from the Printer file
      *
      *
      ** If select by customer: output Customer info to the left part
      ** of the report and Authority Holder info to the right part of
      ** the report;
      *
     C                   IF        WCustAuth = 'C'
      *
     C                   EVAL      RNBR1 = WCnumP
     C                   EVAL      RNAME1 = WCcSsn
     C                   EVAL      RNBR2 = WAuthP
     C                   EVAL      RNAME2 = WAcSsn
      *
      ** If select by Authority Holder: output Authority Holder info to
      ** the left part of the report and Customer info to the right
      ** part of the report;
      *
     C                   ELSE
      *
     C                   EVAL      RNBR1 = WAuthP
     C                   EVAL      RNAME1 = WAcSsn
     C                   EVAL      RNBR2 = WCnumP
     C                   EVAL      RNAME2 = WCcSsn
      *
     C                   ENDIF
      *
     C                   EVAL      RPDG = WPdg
     C                   EVAL      RNOAC = WCount
     C                   EVAL      RACNO = WAcno
     C                   EVAL      RANAM = WAnam
     C                   EVAL      RLINK = WLTyp
     C                   EVAL      RCInt = WCInt                                              CGL132
     C                   EVAL      RPcnt = WPcnt                                              CGL132
                                                                                            MD053634
     C                   SELECT                                                             MD053634
     C                   WHEN      WTYLC = 'I'                                              MD053634
     C                   EVAL      RTYLC = 'Insert'                                         MD053634
     C                   WHEN      WTYLC = 'A'                                              MD053634
     C                   EVAL      RTYLC = 'Amend '                                         MD053634
     C                   WHEN      WTYLC = 'D'                                              MD053634
     C                   EVAL      RTYLC = 'Delete'                                         MD053634
     C                   ENDSL                                                              MD053634
      *
      ** Reset following variables as there are not need for
      ** the next output
      *
     C                   EVAL      WCnumP = *BLANKS
     C                   EVAL      WPdg = *BLANKS
     C                   EVAL      WCount = *ZEROS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrite - Write record in Printer file                       *
      *                                                               *
      *  Called by: SRNonRAC, SRConsol, SRDetailC, SRDetailA, SRAcHld *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRWrite       BEGSR
      *
      ** Write Header
      *
     C                   IF        (WNewPageHdr = *ON AND
     C                             WEndOfRep = *OFF) OR
     C                             WNoRecord  = 'Y'
     C                   WRITE     SD000110R0
      *
      ** Reset indicator for writing a Header
      *
     C                   EVAL      WNewPageHdr = *OFF
     C                   ENDIF
      *
      ** Print Separator line
      *
     C                   IF        WSeparLin = *ON AND
     C                             WNewPageHdr <> *ON
     C                   WRITE     SD000110R1
      *
      ** Reset indicator for writing a Separator line
      *
     C                   EVAL      WSeparLin = *OFF
     C                   ENDIF
      *
      ** Print Detail or End of Report
      *
     C                   IF        WEndOfRep = *ON
     C                   WRITE     SD000110R3
      *
      ** Reset indicator for writing a End of Report
      *
     C                   EVAL      WEndOfRep = *OFF
     C                   ELSE
     C                   WRITE     SD000110R2
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Entry Parameter List
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRSeq
     C                   PARM                    PRLev
     C                   PARM                    PEnty
     C                   PARM                    PParm
     C                   PARM                    PRAct
     C                   PARM                    PRCmd
      *
      ** If Select by Customer seton *in35. If Select by Authority
      ** holder setoff *in35.
      *
     C                   IF        WCustAuth = 'C' OR WCustAuth = 'c'
      *
      ** Make sure, that only big letters will be use
      *
     C                   EVAL      WCustAuth = 'C'
     C                   EVAL      *IN35 = *ON
     C                   ELSE
      *
      ** Make sure, that only big letters will be use
      *
     C                   EVAL      WCustAuth = 'A'
     C                   EVAL      *IN35 = *OFF
     C                   ENDIF
      *
     C                   IF        WRepTyp = 'C' OR WRepTyp = 'c'
      *
      ** Make sure, that only big letters will be use
      *
     C                   EVAL      WRepTyp = 'C'
     C                   EVAL      *IN34 = *ON
     C                   ELSE
      *
      ** Make sure, that only big letters will be use
      *
     C                   EVAL      WRepTyp = 'D'
     C                   EVAL      *IN34 = *OFF
     C                   ENDIF
      *
      ** Reset no record found
      *
     C                   EVAL      WNoRecord = ' '
      *
      ** Get info from the SDBANKPD
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*BLANKS'     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** If error, then do
      *
     C                   IF        PRtCd <> *BLANKS
      *
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   MOVEL     '001'         DBASE
     C                   EVAL      DBKEY  = POptn
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      ** Setup indicators for printing header of the report
      *
     C                   EVAL      WNewPageHdr = *ON
      *
      ** Ensure Report Spool File recorded by RCF.
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PRSeq
     C                   PARM      *BLANKS       PEnty
     C                   PARM      SFILE1        PFile
     C                   PARM      SFNUM1        PSNum
     C                   PARM      *BLANKS       PSErr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C                   IF        PSErr = 'Y'
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: *INZSR                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2008
