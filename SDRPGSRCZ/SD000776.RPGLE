     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer Status Upd at Effective Date 2')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000776 - Customer Status Update at Effective Date 2        *
      *                                                               *
      *  Function:  This daily program must run when CGL032           *
      *             feature is implemented before the halt of         *
      *             TOF Replication process during Input Cycle        *
      *             Termination.                                      *
      *             This program will change the customer status      *
      *             when country tax code's effective date 2 is       *
      *             later than or same as previous working date       *
      *             and earlier or same as current run date.          *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER069             Date 03Jul14               *
      *                 AR750273A          Date 20May11               *
      *  Prev Amend No. AR750273           Date 13May11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23797A          Date 16Jun09               *
      *                 BUG23797           Date 23Apr09               *
      *                 BUG23456           Date 24Mar09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER069 - German Tax Enhancement                              *
      *  AR750273A - SDC000776 00001 failed (Child: AR750274)         *
      *  AR750273 - SDC000776 00001 failed (Child: AR750274)          *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23797A - Do not fail the component when the customer is   *
      *             deleted or closed                                 *
      *  BUG23797 - Replace AOCUSTR0 with AOCUSTR1                    *
      *  BUG23456 - Tax Status has change after COB in the Customer   *
      *             Details Country of Tax Maintenance                *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CGL032 - Automatic Exchange of Information                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** SD Country of Tax Codes
     FSDCTTXL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** SD Customer Details by Country of Tax
     FSDACTXL5  UF   E           K DISK    INFSR(*PSSR)
 
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      ** External DS for Bank Details
     D SDBANK        E DS                  Extname(SDBANKPD)
 
      ** External DS for SAR Details
     D SCSARD        E DS                  Extname(SCSARDPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  Extname(DSFDY)
      *                                                                                     BUG23456
      ** Long DS for access programs                                                        BUG23456
      *                                                                                     BUG23456
     D DSSDY         E DS                  EXTNAME(DSSDY)                                   BUG23456
      *                                                                                     BUG23456
      ** DS for access objects - short data structure                                       BUG23797
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   BUG23797
      *                                                                                     BUG23797
      ** External DS for Customer Details                                                   BUG23456
      *                                                                                     BUG23456
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                BUG23456
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
      ** Parameters for access object programs
     D PRtCd           S              7    Inz
     D POptn           S              7    Inz
     D PSARD           S              6    Inz
 
      ** Other fields used
     D WRun            S              1    Inz
     D WCurr_RunDay    S              5  0 Inz
     D WPrev_WrkDay    S              5  0 Inz
     D WDayNo          S              5  0 Inz
     D WCcy            S              3    Inz
     D WLoc            S              3    Inz
     D WDays           S              2  0 Inz
     D WFlag           S              1                                                     BUG23456
     D PKeySt          S              7A                                                    BUG23456
     D PCust           S             10A                                                    BUG23456
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *InzSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Set file pointer to first record and do initial read.
 
     C     *Loval        SETLL     SDCTTXL1
 
     C                   READ      SDCTTXL1
 
      ** Read Country of Tax Codes until end of file
 
     C                   DOW       Not %EOF(SDCTTXL1)
 
      ** Change the Customer Status if:
      **   Country's Effective Date 2 >= Previous Working Day AND
      **                              <= Current Run Day
 
     C                   IF        EWEDT2 >= WPrev_WrkDay and
     C                             EWEDT2 <= WCurr_RunDay
     C                   EXSR      SRChgSts
     C                   ENDIF
 
     C                   READ      SDCTTXL1
 
     C                   ENDDO
 
     C                   EVAL      *InLR = *On
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChgSts - Change Customer Status Routine                    *
      *                                                               *
      *****************************************************************
     C     SRChgSts      BEGSR
 
     C     EWCTRT        SETLL     SDACTXL5
     C     EWCTRT        READE     SDACTXL5                               88
 
     C                   DOW       *In88 = *Off
 
     C                   EVAL      WFlag = *BLANKS                                          BUG23456
      *                                                                                     BUG23456
      ** Extact country of Residence                                                        BUG23456
      *                                                                                     BUG23456
     C**********         CALL      'AOCUSTR0'                                      BUG23456 BUG23797
     C**********         CALL      'AOCUSTR1'                                     BUG23797 AR750273A
     C                   CALL      'AOCUSTR0'                                              AR750273A
     C                   PARM      *BLANKS       PRtcd                                      BUG23456
     C                   PARM      '*KEY'        POptn                                      BUG23456
     C                   PARM      AXCUST        PCust                                      BUG23456
     C                   PARM      *BLANKS       PKeySt                                     BUG23456
     C*****SDCUST        PARM      SDCUST        DSSDY                             BUG23456 BUG23797
     C*****SDCUST        PARM      SDCUST        DSLDY                            BUG23797 AR750273A
     C     SDCUST        PARM      SDCUST        DSSDY                                     AR750273A
      *                                                                                     BUG23456
     C                   IF        PRtcd = *BLANKS                                          BUG23456
      *                                                                                     BUG23456
     C                   IF        BBCOLC = EWCTRR                                          BUG23456
     C                   EVAL      WFlag = 'Y'                                              BUG23456
     C                   ENDIF                                                              BUG23456
      *                                                                                     BUG23456
     C                   ENDIF                                                              BUG23456
      *                                                                                     BUG23456
     C                   IF        (PRtcd <> *BLANKS)                                       BUG23456
     C                             AND PRtcd <> '*CUSDEL'                                  AR750273A
     C                             AND PRtcd <> '*CUSCLS'                                  AR750273A
     C**********                   AND BBCLST <> 'Y'                              BUG23797 BUG23797A
     C**********                   AND PRtcd <> '*CUSCLO'                        BUG23797A AR750273A
     C**********                   AND BBDTDL = 0                                 AR750273 AR750273A
      *                                                                                     BUG23456
     C     *LOCK         IN        LDA                                                      BUG23456
     C                   EVAL      DBase = 002                                              BUG23456
     C                   EVAL      DBKEY = AXCUST                                           BUG23456
     C                   EVAL      DBFILE = 'SDCUSTPD'                                      BUG23456
     C                   EVAL      DBPGM = 'SD000776'                                       BUG23456
     C                   OUT       LDA                                                      BUG23456
     C                   EXSR      *PSSR                                                    BUG23456
     C                   ENDIF                                                              BUG23456
      *                                                                                     BUG23456
     C                   SELECT
 
      ** for Country w/ Disclosed Status
      ** Change customer status: From Withhold/Exempted to Disclosed
 
     C**********         WHEN      EWTXS2 = 'D'                                             BUG23456
     C                   WHEN      EWTXS2 = 'D' AND WFlag = 'Y'                             BUG23456
     C                   IF        AXETXS = 'T' or
     C                             AXETXS = 'Y' or                                            CER069
     C                             AXETXS = 'E'
     C                   EVAL      AXETXS = 'D'
     C                   ENDIF
 
      ** for Country w/ Withhold Status
      ** Change customer status: From Exempted to Disclosed
 
     C**********         WHEN      EWTXS2 = 'T'                                             BUG23456
     C                   WHEN      EWTXS2 = 'T' AND WFlag = 'Y'                             BUG23456
     C                   IF        AXETXS = 'E'
     C                   EVAL      AXETXS = 'T'
     C                   ENDIF
 
     C                   ENDSL
 
      ** Update customer record
 
     C                   UPDATE    SDACTXD0
 
     C     EWCTRT        READE     SDACTXL5                               88
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *InzSr - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *InzSr        BEGSR
 
     C     *DTAARA       DEFINE                  LDA
 
      ** Initialize variables
 
     C                   EVAL      WCurr_RunDay = 0
     C                   EVAL      WPrev_WrkDay = 0
 
      ** Access Bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCd <> *Blanks
     C     *Lock         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WCurr_RunDay = BJRDNB
     C                   ENDIF
 
      ** Retrieve Previous Working Day
 
     C                   CALL      'ZBKDT'
     C                   PARM      WCurr_RunDay  WDayNo
     C                   PARM      BJLCCY        WCcy
     C                   PARM      BJSLCD        WLoc
     C                   PARM      BJBVPD        WDays
     C                   PARM      *Zero         WPrev_WrkDay
 
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
      *  Called by:                                                   *
      *                                                               *
      *  Calls:          None                                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *Blanks
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *InU7 = *On
     C                   EVAL      *InU8 = *On
     C                   EVAL      *InLR = *On
 
     C                   RETURN
 
     C                   ENDSR
