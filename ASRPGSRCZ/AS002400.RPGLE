     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas Average Spot Rates Daily Update')                *
      *****************************************************************
      *  Midas - IAS21 Module                                         *
      *                                                               *
      *  AS002400 - Midas Average Spot Rates Daily Update             *
      *                                                               *
      *  Function:  This module will run in each close of business    *
      *             and will compute average spot rates for zones     *
      *             and global currencies for predefined periods.     *
      *                                                               *
      *  Component of: ASC002400 - Midas Average Spot Rates Daily     *
      *                            Processing                         *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAS014  *CREATE    Date 10Aug05               *
      *                                                               *
      *---------------------------------------------------------------*
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *  CAS014 - IAS21 The Effects of Changes in Foreign Exchange    *
      *           Rates                                               *
      *****************************************************************
      *  Use of indicators.                                           *
      *    U7+U8      Database Error                                  *
      *****************************************************************
      *  S U B R O U T I N E  I N D E X                               *
      *  SRCalAsrG - Global Average Spot Rate Processing              *
      *  SRCalAsrZ - Global Average Spot Rate Processing              *
      *  SRUpdAsr  - Updates average spot rate for frequency periods  *
      *  SRAcsRte  - Access Global and Zonal Rates file               *
      *  SRWrtAsr  - Writes new average spot rate periods             *
      *  SRCaleEndP - Calculates Calendar End Periods                 *
      *  SRFisEndP - Calculates Fiscal End Periods                    *
      *  SRCalPerD - Calculate Next Frequency Period Dates            *
      *  SRRptAsrG - Report Global Average Spot Rates Processed       *
      *  SRRptAsrZ - Report Zone Average Spot Rates Processed         *
      *  SRZDate1  - Changes the date MMDDYY to Midas No.             *
      *  SRZDate2  - Changes the Midas Date No. to  MMDDYY            *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *****************************************************************
     FGPCURRL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas Global Currencies File
     FGPAVSRL3  UF A E           K DISK    INFSR(*PSSR)
      ** Midas Global Average Spot Rate Report
     FGPCUHSL0  IF   E           K DISK    INFSR(*pssr)
      ** Midas GP Global Daily Historic Spot Rates
     FSDCURRL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas Zonal Currencies File
     FSDCUHSL3  IF   E           K DISK    INFSR(*pssr)
      ** Midas Zonal Daily Historic Spot Rates
     FGPAVSRPA  UF   E           K DISK    INFSR(*pssr)
      ** Midas Average Spot Rates - Audit
     FAS002400P1O    E             PRINTER INFDS(SPOOL1) USROPN
      ** Midas Zone Average Spot Rate Report
     FAS002400P2O    E             PRINTER INFDS(SPOOL2) USROPN
      ** Midas Average Spot Rates Report - Audit
     FAS002400AUO    E             PRINTER INFDS(SPOOLA)
      *****************************************************************
      /EJECT
      *****************************************************************
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      ** Data Area giving Installation Control Details
 
     D/COPY ZACPYSRC,PSDS
      ** First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** INFDS for AS002400P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
      ** INFDS for AS002400P2
     D SPOOL2          DS
     D  SFILE2                83     92
     D  SFNUM2               123    124B 0
     D  OFLLN2               188    189B 0
     D  PRTLN2               367    368B 0
 
      ** INFDS for AS002400AU
     D SPOOLA          DS
     D  SFILEA                83     92
     D  SFNUMA               123    124B 0
     D  OFLLNA               188    189B 0
     D  PRTLNA               367    368B 0
 
      ** Converted Rundate to MMDDYY format
     D pMMDDYY                 1      6  0
     D  pMonth                 1      2  0
     D  pDay                   3      4  0
     D  pYear                  5      6  0
 
      ** Work variable for Frequency End Period Date Variable
     D                 DS
     D wMMDDYY                 1      6
     D  wMonth                 1      2
     D  wDay                   3      4
     D  wYear                  5      6
 
      ** Array containing copyright statement
     D @CPY            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Array containing Period Frequency
     D aPrdFreq        S              2A   DIM(7) CTDATA PERRCD(7)
      ** Monthend day no. Array
     D aMthEnd         S              2A   DIM(13) CTDATA PERRCD(13)
 
      ** Variables used as key
     D kASZONE         S                   LIKE(ASZONE)
     D kASCCYD         S                   LIKE(ASCCYD)
     D kASPDFQ         S                   LIKE(ASPDFQ)
     D kASENDT         S                   LIKE(ASENDT)
     D kPROCDT         S                   LIKE(ASLPDT)
 
      ** Array indexs
     D X               S              1  0
 
      ** Parameters variables for access objects
     D pRtCd           S              7
     D pOption         S              7A
 
      ** Parameter variables for access object GPAOSVAL
     D pSysVal01       S             20    INZ(*BLANKS)
     D pSysValCurS01   S            200    INZ(*BLANKS)
     D pSysVal02       S             20    INZ(*BLANKS)
     D pSysValCurS02   S            200    INZ(*BLANKS)
     D pSysVal03       S             20    INZ(*BLANKS)
     D pSysValCurS03   S            200    INZ(*BLANKS)
     D pSysVal04       S             20    INZ(*BLANKS)
     D pSysValCurS04   S            200    INZ(*BLANKS)
     D pSysVal05       S             20    INZ(*BLANKS)
     D pSysValCurS05   S            200    INZ(*BLANKS)
     D pSysVal06       S             20    INZ(*BLANKS)
     D pSysValCurS06   S            200    INZ(*BLANKS)
     D pSysVal07       S             20    INZ(*BLANKS)
     D pSysValCurS07   S            200    INZ(*BLANKS)
     D pSysVal08       S             20    INZ(*BLANKS)
     D pSysValCurS08   S            200    INZ(*BLANKS)
     D pSysVal09       S             20    INZ(*BLANKS)
     D pSysValCurS09   S            200    INZ(*BLANKS)
     D pSysVal10       S             20    INZ(*BLANKS)
     D pSysValCurS10   S            200    INZ(*BLANKS)
 
      ** Parameter variables for access object GOGETZONE
     D pErMs           S             50    INZ(*BLANKS)
     D pFullCk         S              1    INZ('Y')
     D pZone           S             10    INZ(*BLANKS)
     D pSHTC           S              4    INZ(*BLANKS)
     D pRDNB           S              5  0 INZ(0)
     D pDNWD           S              5  0 INZ(0)
     D pBCCY           S              3    INZ(*BLANKS)
     D pNJOB           S              1  0 INZ(0)
 
      ** Parameter variables for SRZDATE1/ZDATE2
     D pMidasDA        S              6A   INZ(*BLANKS)
     D pDayNo          S              5  0 INZ(0)
     D pDtFmt          S              1    INZ(*BLANKS)
     D pDDMMMYY        S              7    INZ(*BLANKS)
     D pError          S              1A   INZ(*BLANKS)
     D pFmt            S              1    INZ('M')
     D pDate           S              6  0
 
      ** Parameter variables for ZCPD
     D pAddYY          S              2  0 INZ(0)
     D pAddMM          S              2  0 INZ(0)
     D pAddDD          S              2  0 INZ(0)
     D pZPDNO          S              5  0 INZ(0)
     D pZPDTE          S              7    INZ(*BLANKS)
 
      **  Work Variables
     D wStrFisc        S              2S 0 INZ(0)
     D wLYear          S              2S 0 INZ(0)
     D wLYRmdr         S              2S 0 INZ(0)
     D wP1Open         S              1A   INZ('N')
     D wP2Open         S              1A   INZ('N')
     D wRQDLN1         S              3S 0 INZ(0)
     D wDIFLN1         S              3S 0 INZ(0)
     D wRQDLN2         S              3S 0 INZ(0)
     D wDIFLN2         S              3S 0 INZ(0)
     D wRQDLNA         S              3S 0 INZ(0)
     D wDIFLNA         S              3S 0 INZ(0)
     D wDays           S              5S 0 INZ(0)
     D wSprt           S                   LIKE(GHSPRT)
     D wAcumRte1       S                   LIKE(ASTSRD)
     D wAcumRte2       S                   LIKE(ASTSRD)
     D @RUN            S              1
     D wRecWrG         S              6  0 INZ(0)
     D wRecUpG         S              6  0 INZ(0)
     D wRecWrZ         S              6  0 INZ(0)
     D wRecUpZ         S              6  0 INZ(0)
     D wDbErr          S              1    INZ('N')
      *
      ** Calling parameters for ZSFILE
      *
     D ZSEQ            S              5A
     D ZSENTY          S              3A
     D ZSNUM           S              6S 0
     D ZSERR           S              1A
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      **   Global Average Spot Rate Processing Routine
     C                   EXSR      SRCalAsrG
 
      **   Zonal Average Spot Rate Processing Routine
     C                   EXSR      SRCalAsrZ
 
      **   Audit  routine
     C                   EXSR      SRAudit
 
     C                   EVAL      *INLR       = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCalAsrG - Global Average Spot Rate Processing               *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls:  SRUpdAsr SRWrtAsr                                     *
      *****************************************************************
     C     SRCalAsrG     BEGSR
 
      ** Retrieve records from the Global Currency  file
     C     *LOVAL        SETLL     GPCURRL0
 
     C                   READ      GPCURRL0
     C                   DOW       NOT %EOF(GPCURRL0)
 
     C                   EVAL      kASZONE     = *BLANKS
     C                   EVAL      kASCCYD     = GCCYCD
 
      ** Process average spot rate for calendar and Fiscal Frequencies
      ** access array for the frequencies 'M','CQ', 'CX', 'CY','FQ','FX' and 'FY'.
     C                   Z-Add     1             X
     C                   DOW       X < 8
 
      ** Read recent records from the file that needs updating if record exist.  If not then
      ** period record would be written and updated
     C                   EVAL      kASPDFQ     = aPrdFreq(X)
     C     kAveSpot      SETGT     GPAVSRL3
     C     kAveSpot      READPE    GPAVSRL3
     C
      **  Only process next frequency if all periods are created upto rundate for the
      **  frequency.
     C                   IF        ASENDT > BJRDNB
     C                   ADD       1             X
     C                   ENDIF
      ** Updates accumulated values from start date to end period date or rundate.
     C                   IF        NOT %EOF(GPAVSRL3)
     C                   EXSR      SRUpdAsr
     C                   ENDIF
      ** Write initial record for the periods upto rundate.
     C                   IF        %EOF(GPAVSRL3)
     C                             OR NOT %EOF(GPAVSRL3) AND ASENDT <= BJRDNB
     C                   EXSR      SRWrtAsr
     C                   ENDIF
 
     C                   CLEAR                   GPAVSRD0
     C                   ENDDO
 
     C                   READ      GPCURRL0
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCalAsrZ - Zone Average Spot Rate Processing                 *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls:  SRUpdAsr SRWrtAsr                                     *
      *****************************************************************
     C     SRCalAsrZ     BEGSR
 
      ** Retrieve records from the Global Currency  file
     C     *LOVAL        SETLL     SDCURRL0
 
     C                   READ      SDCURRL0
     C                   DOW       NOT %EOF(SDCURRL0)
 
     C                   EVAL      kASZONE     = PZONE
     C                   EVAL      kASCCYD     = A6CYCD
 
      ** Process average spot rate for calendar and Fiscal Frequencies
      ** access array for the frequencies 'M','CQ', 'CX', 'CY','FQ','FX' and 'FY'.
     C                   Z-Add     1             X
     C                   DOW       X < 8
 
      ** Read recent records from the file that needs updating if record exist.  If not then
      ** period record would be written and updated accordingly.
     C                   EVAL      kASPDFQ     = aPrdFreq(X)
     C     kAveSpot      SETGT     GPAVSRL3
     C     kAveSpot      READPE    GPAVSRL3
     C
      **  Only process next frequency if all periods are created upto rundate for the
      **  frequency.
     C                   IF        ASENDT > BJRDNB
     C                   ADD       1             X
     C                   ENDIF
      ** Updates accumulated values from start date to end period date or rundate.
     C                   IF        NOT %EOF(GPAVSRL3)
     C                   EXSR      SRUpdAsr
     C                   ENDIF
      ** Write initial record for the periods upto rundate.
     C                   IF        %EOF(GPAVSRL3)
     C                             OR NOT %EOF(GPAVSRL3) AND ASENDT <= BJRDNB
     C                   EXSR      SRWrtAsr
     C                   ENDIF
 
     C                   CLEAR                   GPAVSRD0
     C                   ENDDO
 
     C                   READ      SDCURRL0
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRUpdAsr  - Updates average spot rate upto period end or     *
      *              rundate for zone and global rates                *
      *                                                               *
      * Called by:  SRCalAsrG  SRCAlAsrZ                              *
      *                                                               *
      * Calls:  SRAcsRte SRZdate2 SRRptAsrG SRRptAsrZ                 *
      *****************************************************************
     C     SRUpdAsr      BEGSR
 
     C                   Z-Add     0             wDays
     C                   Z-Add     0             wAcumRte1
     C                   Z-Add     0             wAcumRte2
      ** Calculation of accumulated values would be done upto corresponding
      ** end period dates only else upto rundate.
 
      ** For global processing multiple zone updates, make sure to use last process
      ** date and previous accumulated values from last run else upto last change date.
     C                   IF        ASENDT < BJRDNB
     C                   EVAL      KProCDT = ASENDT
 
     C                   IF        BJRDNB = ASLCDT
     C                   EVAL      wDays  = ASENDT - ASLPDT
     C                   ELSE
     C                   EVAL      wDays  = ASENDT - ASLCDT
     C                   ENDIF
 
      ** Accumulate total rate upto end period date
     C                   EXSR      SRAcsRte
     C                   EVAL      wAcumRte1 = wDays  * wSprt
 
     C                   ELSE
 
      ** For global processing multiple zone updates, make sure to use last process
      ** date and previous accumulated values from last run else use last change date.
     C                   IF        BJRDNB = ASLCDT
     C                   EVAL      wDays  = BJRDNB - ASLPDT
     C                   ELSE
     C                   EVAL      wDays  = BJRDNB - ASLCDT
     C                   ENDIF
 
      **  Initilise one to no. of days for newly created records.
     C                   IF        wDays = 0
     C                             AND ASSTDT <= BJRDNB
     C                   Z-ADD     1             wDays
     C                   ENDIF
 
      ** Accumulate total rate upto rundat -1
     C                   IF        wDays >= 1
     C                             AND ASSTDT <= BJRDNB
     C                   EVAL      KProCDT = BJRDNB - 1
     C                   EXSR      SRAcsRte
     C                   EVAL      wAcumRte1 = (wDays - 1) * wSprt
 
      ** Accumulate rate on rundate
     C                   EVAL      KProCDT = BJRDNB
     C                   EXSR      SRAcsRte
     C                   EVAL      wAcumRte2 = 1 * wSprt
     C                   ENDIF
 
     C                   ENDIF
 
      ** For global processing multiple zone updates, make sure to use last process
      ** date and previous accumulated values from last run.
     C                   IF        ASLCDT = BJRDNB
     C                   EVAL      ASTSRD      = ASPSRD + wAcumRte1 + wAcumRte2
     C                   EVAL      ASTSDD      = ASPSDD + wDays
 
     C                   ELSE
     C                   EVAL      ASPSRD      = ASTSRD
     C                   EVAL      ASPSDD      = ASTSDD
     C                   EVAL      ASLPDT      = ASLCDT
     C                   EVAL      ASTSRD      = ASTSRD + wAcumRte1 + wAcumRte2
     C                   EVAL      ASTSDD      = ASTSDD + wDays
     C                   ENDIF
 
      ** Initilise average spot rate to zero for next period that is initially opened.
     C                   IF        ASTSRD = 0 OR  ASTSDD = 0
     C                   EVAL      ASASTD = 0
     C                   ELSE
     C                   EVAL      ASASTD      = ASTSRD / ASTSDD
     C                   ENDIF
 
     C                   EVAL      ASCHTP      = 'A'
     C                   EVAL      ASLCDT      = BJRDNB
 
      **  If End period date is less than rundate period should be left open
     C                   IF        ASENDT > BJRDNB
     C                   EVAL      ASOPPD      = *BLANKS
     C                   EVAL      PDAYNO  = BJRDNB
     C                   ELSE
 
      **  Close the period
     C                   EVAL      ASOPPD      = 'F'
     C                   EVAL      PDAYNO  = ASENDT
     C                   ENDIF
 
      **  Get MMDDYY format and update perriod year and month
      **  accordingly.
     C                   EXSR      SRZDate2
     C                   MOVE      pDate         wMMDDYY
     C                   EVAL      ASPDYN      = wYear
     C                   EVAL      ASPDMN      = wMonth
 
     C                   Update    GPAVSRD0
 
      ** Update trailer counters
     C                   IF        ASZONE = *BLANKS
     C                   ADD       1             wRecUpG
     C                   ELSE
     C                   ADD       1             wRecUpZ
     C                   ENDIF
 
      ** Report updated values for global and zonal average spot rates
      ** for the current period only.
     C                   IF        ASSTDT <= BJRDNB
     C                   IF        kASZONE = *BLANKS
     C                   EXSR      SrRptAsrG
     C                   ELSE
     C                   EXSR      SrRptAsrZ
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRAcsRte  - Access currencies spot rates for global and      *
      *              zone currencies in the history file              *
      *                                                               *
      * Called by:  SRUpdAsr                                          *
      *                                                               *
      * Calls:  None                                                  *
      *****************************************************************
     C     SRAcsRte      BEGSR
      **  If records processed are global currencies then access Global
      **  historic spot rates for averaging
     C                   IF        kASZONE = *BLANK
     C     kGHstSpt      SETGT     GPCUHSL0
     C     kASCCYD       READPE    GPCUHSL0
     C                   EVAL      wSprt       = GHSPRT
     C                   EVAL      ASMDIN      = GHMDIN
 
     C                   ELSE
 
      **  If records processed are zonal currencies then access Global
      **  historic spot rates for averaging
     C     kGHstSpt      SETGT     SDCUHSL3
     C     kASCCYD       READPE    SDCUHSL3
     C                   EVAL      wSprt       = G2SPRT
     C                   EVAL      ASMDIN      = G2MDIN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRWrtAsr  - Writes new average spot rate period details for  *
      *              global and zone currencies                       *
      *                                                               *
      * Called by:  SRCalAsrG  SRCalAsrZ                              *
      *                                                               *
      * Calls:  SRZdate2  SRCalEndP  SRFiscEndP                       *
      *****************************************************************
     C     SRWrtAsr      BEGSR
 
     C                   EVAL      ASCCYD      = kASCCYD
     C                   EVAL      ASPDFQ      = kASPDFQ
 
      **  Move blanks if record processed is for Global average spot rate
     C                   IF        kASZONE = *BLANK
     C                   EVAL      ASZONE      = *BLANKS
     C                   ELSE
     C                   EVAL      ASZONE      = PZONE
     C                   ENDIF
 
      ** If next period start date is available use the value of this field to determine
      ** the end period date and next period date for the next period.
     C                   IF        ASNPSD <> 0
     C                   MOVE      ASNPSD        pDayNo
     C                   EVAL      ASSTDT      = ASNPSD
     C                   EVAL      ASLPDT      = ASSTDT -1
     C                   ELSE
 
     C                   MOVE      BJRDNB        pDayNo
     C                   EVAL      ASSTDT      = BJRDNB
     C                   EVAL      ASLPDT      = BJRDNB
     C                   ENDIF
 
      ** Convert date for end period caculation to MMDDYY format
      ** Input date is rundate or next period start date
     C                   EXSR      SRZDate2
     C                   MOVE      pDate         pMMDDYY
     C                   MOVE      pDate         wMMDDYY
 
     C                   EVAL      ASPDYN      = wYear
     C                   EVAL      ASPDMN      = wMonth
 
      ** Calculate Calendar end period date for the frequency
     C                   IF        (ASPDFQ = 'M ')  OR
     C                             (ASPDFQ = 'CQ')  OR
     C                             (ASPDFQ = 'CX')  OR
     C                             (ASPDFQ = 'CY')
     C                   EXSR      SRCaleEndP
     C                   ELSE
 
      ** Calculate Fiscal end period date for the frequency
     C                   EXSR      SRFiscEndP
     C                   ENDIF
 
     C                   EVAL      ASENDT      = pDayNo
     C                   EVAL      ASNPSD      = pDayNo + 1
 
     C                   EVAL      ASTSRD      = 0
     C                   EVAL      ASTSDD      = 0
     C                   EVAL      ASASTD      = 0
     C                   EVAL      ASMDIN      = *BLANKS
     C                   EVAL      ASCHTP      = 'I'
     C                   EVAL      ASLCDT      = BJRDNB
     C                   EVAL      ASOPPD      = *BLANKS
 
     C                   EVAL      ASPSRD      = 0
     C                   EVAL      ASPSDD      = 0
 
     C                   WRITE     GPAVSRD0
 
      ** Update trailer counters
     C                   IF        ASZONE = *BLANKS
     C                   ADD       1             wRecWrG
     C                   ELSE
     C                   ADD       1             wRecWrZ
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCaleEndP - Calculates Calendar End Periods                  *
      *                                                               *
      * Call by: SRWrtAsr                                             *
      *                                                               *
      * Calls: SRZdate1                                               *
      *****************************************************************
     C     SRCaleEndP    BEGSR
 
     C                   MOVE      pYear         wYear
 
      **  Select Calendar End period date using format MMDDYY from Rundate
     C                   SELECT
     C                   WHEN      (ASPDFQ = 'M')
     C                   MOVE      pMonth        wMonth
     C                   EVAL      wDay = aMthEnd(pMonth)
 
      ** Move  Feb 29th as End Period Day if Year falls on a leap year
     C     wMonth        IFEQ      '02'
     C                   MOVE      pYear         wLYear
     C                   DIV       4             wLYear
     C                   MVR                     wLYRmdr
 
     C     wLYRmdr       IFEQ      0
     C                   EVAL      wDay = aMthEnd(13)
     C                   ENDIF
     C                   ENDIF
     C
      ** Directly assign period end dates for calendar frequencies
     C                   WHEN      (ASPDFQ = 'CQ' AND pMonth <4)
     C                   EVAL      wMonth = '03'
     C                   EVAL      wDay   = aMthEnd(03)
 
     C                   WHEN      (ASPDFQ = 'CQ' AND pMonth >3 AND pMonth <7)
     C                             OR (ASPDFQ = 'CX' AND pMonth <7)
     C                   EVAL      wMonth = '06'
     C                   EVAL      wDay   = aMthEnd(06)
 
     C                   WHEN      (ASPDFQ = 'CQ' AND pMonth>6 AND pMonth<10)
     C                   EVAL      wMonth = '09'
     C                   EVAL      wDay   = aMthEnd(09)
 
     C                   OTHER
     C                   EVAL      wMonth = '12'
     C                   EVAL      wDay   = aMthEnd(12)
     C                   ENDSL
 
      ** Convert Calendar end period date (MMDDYY) to Midas No.
     C                   EXSR      SRZDate1
     C                   EVAL      pZPDNO = pDayNo
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRFisEndP - Calculates Fiscal End Periods                     *
      *                                                               *
      * Call by: SRWrtAsr                                             *
      *                                                               *
      * Calls: SRZdate1  SRCalPerd                                    *
      *****************************************************************
     C     SRFiscEndP    BEGSR
 
      ** Get Fiscal start period month and Year for newly created period records.
      ** If no next period start date details is available.
     C                   IF        ASNPSD = 0
 
     C                   IF        wStrFisc > pMonth
     C                   EVAL      pYear = pYear - 1
     C                   ENDIF
     C                   Move      Pyear         Wyear
 
      ** Initialise start period date defined in system values maintenance
     C                   MOVE      wStrFisc      wMonth
     C                   MOVE      '01'          wDay
     C                   ENDIF
 
      ** Convert start period date (MMDDYY) to Midas No.
     C                   EXSR      SRZDate1
 
      ** Get start end period date, loop until current end period is reached for the record.
     C                   DOW       pDayno <= BJRDNB  AND ASNPSD = 0
     C                             OR  ASNPSD <> 0 AND pDayno <= ASNPSD
     C
 
     C                   SELECT
      ** Fiscal Quarterly
     C                   WHEN      ASPDFQ = 'FQ'
     C                   EVAL      pAddMM  = 3
      ** Fiscal Semi Annual
     C                   WHEN      ASPDFQ = 'FX'
     C                   EVAL      pAddMM  = 6
      ** Fiscal Annual
     C                   WHEN      ASPDFQ = 'FY'
     C                   EVAL      pAddMM  = 12
     C                   ENDSL
 
      ** Calculate end period date
     C                   EXSR      SRCalPerd
 
     C                   EVAL      pDayNo = pZPDNO
     C                   ENDDO
 
      ** Get period end day
     C                   EVAL      pDayno = pDayno - 1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCalPerD - Calculates Next End period date                   *
      *                                                               *
      * Called by:  SRFisEndP                                         *
      *                                                               *
      * Calls: ZCPD                                                   *
      *****************************************************************
 
     C     SRCalPerD     BEGSR
 
      ** Get the End Period Date
     C                   CALLB     'ZCPD'
     C                   PARM                    pDayNo
     C                   PARM                    pAddYY
     C                   PARM                    pAddMM
     C                   PARM                    pAddDD
     C                   PARM                    pDtFmt
     C                   PARM                    pZPDNO
     C                   PARM                    pZPDTE
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRptAsrG - Report Global Average Spot Rates Processed        *
      *                                                               *
      * Called by:  SRUpdAsr                                          *
      *                                                               *
      * Calls:  ZDATE2                                                *
      *****************************************************************
     C     SRRptAsrG     BEGSR
 
     C                   IF        wP1Open     = 'N'
     C                   OPEN      AS002400P1
     C                   EVAL      wP1Open     = 'Y'
      *
      ** Ensure Report Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUM1        ZSNUM
 
     C                   CALL      'ZSFILE'
     C                   PARM                    ZSEQ
     C                   PARM                    ZSENTY
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR
 
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVE      ASASTD        RAVE1
 
      ** Move the other fields to the report detail line
     C                   EVAL      RCUR1       = ASCCYD
     C                   EVAL      RFRQ1       = ASPDFQ
 
     C                   MOVE      ASSTDT        pDayNo
     C                   EXSR      SRZDate2
     C                   MOVE      pDDMMMYY      RSTR1
 
     C                   MOVE      ASENDT        pDayNo
     C                   EXSR      SRZDate2
     C                   MOVE      pDDMMMYY      REND1
 
     C                   MOVE      ASNPSD        pDayNo
     C                   EXSR      SRZDate2
     C                   MOVE      pDDMMMYY      RNXT1
 
     C                   EVAL      RTSPT1      = ASTSDD
 
     C                   Z-ADD     10            wRQDLN1
     C     OFLLN1        SUB       PRTLN1        wDIFLN1
     C                   IF        wDIFLN1    <= wRQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   WRITE     DETAIL1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRptAsrZ - Report Zone Average Spot Rates Processed          *
      *                                                               *
      * Called by:  SRUpdAsr                                          *
      *                                                               *
      * Calls:  ZDATE2                                                *
      *****************************************************************
     C     SRRptAsrZ     BEGSR
 
     C                   IF        wP2Open     = 'N'
     C                   OPEN      AS002400P2
     C                   EVAL      wP2Open     = 'Y'
      *
      ** Ensure Report Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUM2        ZSNUM
 
     C                   CALL      'ZSFILE'
     C                   PARM                    ZSEQ
     C                   PARM                    ZSENTY
     C                   PARM                    SFILE2
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR
 
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
 
     C                   ENDIF
 
     C                   MOVE      ASASTD        RAVE2
     C                   EVAL      RCUR2       = ASCCYD
     C                   EVAL      RFRQ2       = ASPDFQ
 
     C                   MOVE      ASSTDT        pDayno
     C                   EXSR      SRZDATE2
     C                   MOVE      pDDMMMYY      RSTR2
 
     C                   MOVE      ASENDT        pDayno
     C                   EXSR      SRZDATE2
     C                   MOVE      pDDMMMYY      REND2
 
     C                   MOVE      ASNPSD        pDayno
     C                   EXSR      SRZDATE2
     C                   MOVE      pDDMMMYY      RNXT2
 
     C                   EVAL      RTSPT2      = ASTSDD
     C                   EVAL      RZONE       = ASZONE
 
     C                   Z-ADD     10            wRQDLN2
     C     OFLLN2        SUB       PRTLN2        wDIFLN2
     C                   IF        wDIFLN2    <= wRQDLN2
     C                   WRITE     HEADP2
     C                   ENDIF
 
     C                   WRITE     DETAIL2
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRAudit - Audit Report                                        *
      *                                                               *
      * Called by: Main  *PSSR                                        *
      *                                                               *
      * Calls: *PSSR                                                  *
      *****************************************************************
 
     C     SRAudit       BEGSR
 
      ** Close P1 and P2 report endings
      *
     C                   IF        wP1Open     = 'Y'
     C                   Z-ADD     10            wRQDLN1
     C     OFLLN1        SUB       PRTLN1        wDIFLN1
     C                   IF        wDIFLN1    <= wRQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   WRITE     ENDREP1
     C                   CLOSE     AS002400P1
     C                   EVAL      wP1Open     = 'N'
     C                   ENDIF
 
     C                   IF        wP2Open     = 'Y'
     C                   Z-ADD     10            wRQDLN2
     C     OFLLN2        SUB       PRTLN2        wDIFLN2
     C                   IF        wDIFLN2    <= wRQDLN2
     C                   WRITE     HEADP2
     C                   ENDIF
     C                   WRITE     ENDREP2
     C                   CLOSE     AS002400P2
     C                   EVAL      wP2Open     = 'N'
     C                   ENDIF
 
     C                   WRITE     HEADAU
 
      ** If Database Error has ocurred (from *PSSR)
     C                   IF        wDbErr = 'Y'
     C                   WRITE     DBERROR
 
     C                   ELSE
 
      ** Get Beginning No. of Records in Trailer file
     C                   READ      GPAVSRPA
     C                   IF        %EOF(GPAVSRPA)
 
      ** Data base error in file GPAVSRPA
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE     =  'GPAVSRPA'
     C                   MOVEL     *BLANKS       DBKEY
     C                   EVAL      DBASE      =  004
     C                   OUT       LDA
 
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      RNRBU       = GHNORE
     C                   EVAL      RNRWG       = wRecWrG
     C                   EVAL      RNRWZ       = wRecWrZ
     C                   EVAL      RNRUG       = wRecUpG
     C                   EVAL      RNRUZ       = wRecUpZ
     C                   EVAL      RNRFC       = RNRBU + RNRWG + RNRWZ
 
     C                   Z-ADD     10            wRQDLNA
     C     OFLLNA        SUB       PRTLNA        wDIFLNA
     C                   IF        wDIFLNA    <= wRQDLNA
     C                   ENDIF
 
     C                   IF        (RNRWG + RNRWZ +
     C                             RNRUG + RNRUZ) = 0
     C                   WRITE     NODTLS
     C                   ELSE
     C                   WRITE     CONTROL
     C                   ENDIF
 
      ** Update Trailer Record
     C                   EVAL      GHNORE      = RNRFC
     C                   UPDATE    GPAVSRA0
 
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: *PSSR, AOBANKR0, GPAOSVALR0, ZDATE2, GOGETZONE         *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *DTAARA       DEFINE                  LDA
 
      *
      ** Ensure Report Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUMA        ZSNUM
 
     C                   CALL      'ZSFILE'
     C                   PARM                    ZSEQ
     C                   PARM                    ZSENTY
     C                   PARM                    SFILEA
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR
 
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
 
      ** Access current zone bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blank        pRtCd
     C                   PARM      '*FIRST '     pOption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Data base error in file SDBANKPD
     C                   IF        pRtCd      <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE      = 'SDBANKPD'
     C                   EVAL      DBKEY       = '*FIRST'
     C                   EVAL      DBASE       = 001
     C                   EVAL      DBPGM       = 'AS002400'
     C                   OUT       LDA
 
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Get Fiscal End Month
     C                   EVAL      pSysVal01     = 'GlobFinancialYEMonth'
 
     C                   CALL      'GPAOSVALR0'
     C                   PARM      *Blank        pRtCd
     C                   PARM                    pSysVal01
     C                   PARM                    pSysValCurS01
     C                   PARM                    pSysVal02
     C                   PARM                    pSysValCurS02
     C                   PARM                    pSysVal03
     C                   PARM                    pSysValCurS03
     C                   PARM                    pSysVal04
     C                   PARM                    pSysValCurS04
     C                   PARM                    pSysVal05
     C                   PARM                    pSysValCurS05
     C                   PARM                    pSysVal06
     C                   PARM                    pSysValCurS06
     C                   PARM                    pSysVal07
     C                   PARM                    pSysValCurS07
     C                   PARM                    pSysVal08
     C                   PARM                    pSysValCurS08
     C                   PARM                    pSysVal09
     C                   PARM                    pSysValCurS09
     C                   PARM                    pSysVal10
     C                   PARM                    pSysValCurS10
 
      ** Error routine - Retrieval of SysVal failed
     C                   IF        pRtCd      <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE     =  'GPAOSVALPD'
     C                   EVAL      DBKEY      =  pSysVal01
     C                   EVAL      DBASE      =  002
     C                   EVAL      DBPGM      = 'AS002400'
     C                   OUT       LDA
 
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **  Get current start fiscal month by adding one month period from
      **  system values end fiscal month period.
     C                   MOVEL     pSysValCurS01 wStrFisc
     C                   EVAL      wStrFisc    = wStrFisc + 1
 
      **  If Fiscal end is December move start period to January
     C                   IF        wStrFisc    > 12
     C                   EVAL      wStrFisc    = 01
     C                   ENDIF
 
      ** Retrieve current zone details
     C                   CALL      'GOGETZONE'
     C                   PARM      *Blanks       pRtCd
     C                   PARM      *Blanks       pErMs
     C                   PARM      'Y'           pFullCk
     C                   PARM                    pZone
     C                   PARM                    pSHTC
     C                   PARM                    pRDNB
     C                   PARM                    pDNWD
     C                   PARM                    pBCCY
     C                   PARM                    pNJOB
 
      ** If no zone details were retrieved then issue database error.
     C                   IF        pZone = *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE     =  'SDBRCHPD'
     C                   EVAL      DBKEY      =  pErMs
     C                   EVAL      DBASE      =  003
     C                   EVAL      DBPGM      = 'AS002400'
     C                   OUT       LDA
 
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Key list for retrieving average spot rate for the period frequency.
     C     kAveSpot1     KLIST
     C                   KFLD                    kASZONE
     C                   KFLD                    kASCCYD
     C                   KFLD                    kASPDFQ
     C                   KFLD                    kASENDT
 
     C     kAveSpot      KLIST
     C                   KFLD                    kASZONE
     C                   KFLD                    kASCCYD
     C                   KFLD                    kASPDFQ
 
     C     kGHstSpt      KLIST
     C                   KFLD                    kASCCYD
     C                   KFLD                    kPROCDT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRZDate1  - Subroutine that changes date MMDDYY to Midas No.  *
      *                                                               *
      * Called by: SRCalEndP SRFisEndP                                *
      *                                                               *
      * Calls: None                                                   *
      *****************************************************************
     C     SRZDate1      BEGSR
 
      ** Parameter for ZDATE1
     C                   Move      wMMDDYY       pMMDDYY
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    pMMDDYY
     C                   PARM                    pDayNo
     C                   PARM      'M'           pDtFmt
     C                   PARM      *Blanks       pError
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRZDate2  - This subroutine changes the Midas Date No. to     *
      *             DDMMMYY Format                                    *
      *                                                               *
      * Called by: SRUpdAsr SRWrtAsr SRRptAsrG SRRptAsrZ              *
      *                                                               *
      * Calls: None                                                   *
      *****************************************************************
     C     SRZDate2      BEGSR
 
     C                   CALL      'ZDATE2'
     C                   PARM                    pDAYNO
     C                   PARM      'M'           pDtFmt
     C                   PARM                    pDate
     C                   PARM                    pDDMMMYY
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls: None                                                   *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   EVAL      wDbErr  = 'Y'
     C                   EXSR      SRAudit
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
** CPY@  ** Copyright
(c) Finastra International Limited 2005
** aPrdFreq ** Period Frequency
M CQCXCYFQFXFY
** aMthEnd - Monthe End Day no.
31283130313031313031303129
