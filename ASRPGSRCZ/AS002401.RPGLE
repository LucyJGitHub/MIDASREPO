     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas Global Average Spot Rates Take On Processing')
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standards Module                          *
      *                                                               *
      *  AS002401 - Midas Global Average Spot Rate Take On Processing *
      *                                                               *
      *  Function:  This module initialise global average spot rates  *
      *             for existing global currencies for the period     *
      *             frequencies below using run date as start date    *
      *                                                               *
      *  Component of: AS002401                                       *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CAS014  *CREATE    Date 10Aug05               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAS014 - IAS21 The Effects of Changes in Foreign Exchange    *
      *           Rates                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7+U8      Database Error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Program Initialisation routine                       *
      * SRInitASPG - Global Average Spot Rate Processing              *
      * SRWrtGASR - Subroutine writes new record in GPAVSRPD          *
      * SRCalPerD - Selects End Period Frequency Processing           *
      * SRCalEndP - Calculate End Period date for Calendar Frequencies*
      * SRFisEndP - Calculate End Period date for Fiscal Frequencies  *
      * SRRptGASR - Reports Global Average Spot Rates recorded        *
      * SRCalcEndP- End Period Date Calculator                        *
      * SRAudit   - Audit subroutine                                  *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas Global currency file
      *
     FGPCURRL0  IF   E             DISK    INFSR(*PSSR)
      *
      ** Midas Average Spot Rates File
      *
     FGPAVSRL1  UF A E           K DISK    INFSR(*PSSR)
      *
      ** Midas Average Spot Rates Trailer File
      *
     FGPAVSRPA  UF A E             DISK    INFSR(*PSSR)
      *
      ** Print File for Global Average Spot Rates Take On Processing
      *
     FAS002401P1O    E             PRINTER INFDS(SPOOL1) USROPN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA)
      *
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
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** INFDS for AS002401P1
      *
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
      ** Converted Rundate to MMDDYY format
      *
     D                 DS
     D pMidasdt                1      6  0
     D  pMMDD                  1      4  0
     D  pMM                    1      2  0
     D  pDD                    3      4  0
     D  pYY                    5      6  0
      *
      ** Work variable for Frequency End Period Date Variable
      *
     D                 DS
     D wMMDDYY                 1      6
     D  wMMDD                  1      4
     D  wMM                    1      2
     D  wDD                    3      4
     D  wYY                    5      6
      *
      ** Used to get the last day of the end period month
      *
     D pDDMMMYY1       DS
     D  pMMM1                  3      5
     D  pYY1                   6      7
      *
      ** External data structure for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Arrays
      *
     D aMTHE           S              2A   DIM(12) CTDATA PERRCD(12)
      *
      ** Calling parameters for ZDATE1 / ZDATE2
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D @RUN            S              1
      *
      ** Working variables
      *
     D wX              S              2P 0 INZ(0)
     D wYear           S              2P 0 INZ(0)
     D wMthEndP        S              5  0 INZ(0)
     D pDate           S              6  0
      *
      ** variables for start period
      *
     D wStrMth         S              2P 0 INZ(0)
     D pStrDte         S              2P 0 INZ(0)
      *
      ** Counter for the audit trail file
      *
     D wCounter        S                   LIKE(GHNORE)
      *
      ** Calling parameters for ZDATE1 / ZDATE2
      *
     D pMMDDYY         S              6
     D pDayNo          S              5  0 INZ(0)
     D pDtFmt          S              1    INZ(*BLANKS)
     D pDDMMMYY        S              7    INZ(*BLANKS)
     D pError          S              1A   INZ(*BLANKS)
      *
      ** Calling parameters for ZCPD
      *
     D pAddYear        S              2  0 INZ(0)
     D pAddMonth       S              2  0 INZ(0)
     D pAddDays        S              2  0 INZ(0)
     D pZPDNO          S              5  0 INZ(0)
     D pZPDTE          S              7    INZ(*BLANKS)
      *
      ** parameters for AOBANKRO
      *
     D pReturnCode     S              7A
     D pOption         S              7A
      *
      ** variables if no details for printing
      *
     D wP1Open         S              1A   INZ('N')
      *
      ** Parameters for GPAOSVALR0
      *
     D pRtCd           S              7    INZ(*BLANKS)
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
      *
      ** variables for handing printing overflows
      *
     D wRQDLN1         S              3S 0 INZ(0)
     D wDIFLN1         S              3S 0 INZ(0)
 
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
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Access Subroutines
      *
     C                   EXSR      SRInitASPG
     C                   EXSR      SRAudit
      *
      ** End of Program
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOBANKR0, GPAOSVALR0                                   *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Key Lists
      *
     C     kAVRS         KLIST
     C                   KFLD                    ASCCYD
     C                   KFLD                    ASPDFQ
      *
      ** LDA Data area
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       pReturnCode
     C                   PARM      '*FIRST '     pOption
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        (pReturnCode <> *BLANKS)
      *
      ** Data base error in file SDBANKPD
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  '*FIRST'
     C                   EVAL      DBPGM  = 'AS002401'
     C                   EVAL      DBASE  =  001
      /COPY ZACPYSRC,DBFIELDS
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      ** Call Access program for Global System Value and retrieve
      ** current setting for 'Global Financial Year End Month Number'
      ** for fiscal average spot rates processing
      *
     C                   EVAL      pRtCd         = *BLANKS
     C                   EVAL      pSysVal01     = 'GlobFinancialYEMonth'
     C                   EVAL      pSysValCurS01 = *BLANKS
 
     C                   CALL      'GPAOSVALR0'
     C                   PARM      *Blanks       pRtCd
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
      *
      ** Error routine - Retrieval of SysVal failed
      *
     C     pRTCD         IFEQ      '*NRF    '
     C     pRTCD         OREQ      '*ERROR '
      *
      ** Data base error in file GPAOSVALPD
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE     =  'GPAOSVALPD'
     C                   EVAL      DBPGM      =  'AS002401'
     C                   EVAL      DBKEY      =  pSysVal01
     C                   EVAL      DBASE      =  002
      /COPY ZACPYSRC,DBFIELDS
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      ** Get fiscal date
      *
     C                   MOVEL     pSysValCurS01 pStrDte
      *
      ** Convert Run date to MMDDYY format
      *
     C                   MOVE      BJRDNB        pDayNo
     C                   EXSR      SRZDate2
     C                   MOVE      pDate         pMidasdt
     C                   MOVE      pMidasDt      wMMDDYY
      *
      ** Calculate End Period Date for Monthly Frequency
      *
     C                   EXSR      SRCalMthE
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRInitASPG - Global Average Spot Rate Processing                  *
      *          This subroutine would initialise global currency file    *
      *          to use currency spot rates as the average spot rate for  *
      *          the periods.                                             *
      *                                                                   *
      * Called by: *INZSR                                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     SRInitASPG    BEGSR
      *
      ** Read all currency for initialisation
      *
     C                   READ      GPCURRL0
     C                   DOW       NOT %EOF(GPCURRL0)
      *
     C                   EVAL      ASCCYD = GCCYCD
      *
      ** Iterate to initialise all period frequencies
      *
     C                   EVAL      wX = 1
      *
     C                   DO        7             wX
     C                   SELECT
     C                   WHEN      wX = 1
     C                   EVAL      ASPDFQ = 'M '
     C                   WHEN      wX = 2
     C                   EVAL      ASPDFQ = 'CQ'
     C                   WHEN      wX = 3
     C                   EVAL      ASPDFQ = 'CX'
     C                   WHEN      wX = 4
     C                   EVAL      ASPDFQ = 'CY'
     C                   WHEN      wX = 5
     C                   EVAL      ASPDFQ = 'FQ'
     C                   WHEN      wX = 6
     C                   EVAL      ASPDFQ = 'FX'
     C                   WHEN      wX = 7
     C                   EVAL      ASPDFQ = 'FY'
     C                   ENDSL
      *
      ** Check file if period spot rates already initialise
      *
     C     kAVRS         CHAIN     GPAVSRL1
     C                   IF        NOT %FOUND(GPAVSRL1)
      *
      ** Period spot rate processing and record transactions to file
      *
     C                   EXSR      SRWrtGASR
      *
      ** Report generation of initialised period spot rates
      *
     C                   EXSR      SRRptGASR
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   READ      GPCURRL0
     C                   ENDDO
      *
      ** write report endings
      *
     C                   IF        wP1Open     = 'Y'
     C                   Z-ADD     10            wRQDLN1
     C     OFLLN1        SUB       PRTLN1        wDIFLN1
     C                   IF        wDIFLN1 <= wRQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
     C                   WRITE     ENDREP1
     C                   CLOSE     AS002401P1
     C                   EVAL      wP1Open     = 'N'
     C                   ENDIF
      *
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRWrtGASR - This subroutine writes new record in GPAVSRPD for     *
      *             all the period frequencies for Global currencies      *
      *                                                                   *
      * Called by: *INZSR                                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     SRWrtGASR     BEGSR
      *
      ** Period Calculation
      *
     C                   EXSR      SRCalPerD
      *
      ** Set fields value
      *
     C                   MOVE      pYY           ASPDYN
     C                   MOVE      pMM           ASPDMN
     C                   EVAL      ASSTDT   = BJRDNB
     C                   EVAL      ASENDT  = pZPDNO
     C                   EVAL      ASNPSD  = pZPDNO + 1
     C                   EVAL      ASTSRD  = GCSPRT
     C                   EVAL      ASTSDD  = 1
     C                   EVAL      ASASTD  = ASTSRD
     C                   EVAL      ASZONE  = *BLANKS
     C                   EVAL      ASCHTP  = 'I'
     C                   EVAL      ASLCDT  = BJRDNB
     C                   EVAL      ASOPPD  = *BLANKS
     C                   EVAL      ASMDIN  = GCMDIN
     C                   EVAL      ASPSRD  = 0
     C                   EVAL      ASPSDD  = 0
     C                   EVAL      ASLPDT  = BJRDNB
      *
      ** Write data to GPAVSRPD
      *
     C                   WRITE     GPAVSRD0
      *
      ** Counter for trailer file update
      *
     C                   EVAL      wCounter = wCounter + 1
      *
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRRptGASR - Report Global Average Spot Rates Processed            *
      *             This subroutine will report all records written/      *
      *             updated in global average spot rate file              *
      *             (PF/GPAVSRPD) for Global Currencies.                  *
      *                                                                   *
      * Called by: SRInitASPG                                             *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     SRRptGASR     BEGSR
      *
      ** Write report AS00210P1 (valid transactions register)
      *
     C                   IF        wP1Open     = 'N'
     C                   OPEN      AS002401P1
     C                   EVAL      wP1Open     = 'Y'
     C                   ENDIF
      *
      ** Set report fields
      *
     C                   EVAL      RCUR = ASCCYD
     C                   EVAL      RAVE = ASASTD
     C                   EVAL      RFRQ = ASPDFQ
     C                   EVAL      RTYP = ASCHTP
      *
      ** Convert start date from Midas No. to DDMMMYY format
      *
     C                   EVAL      pDayNo = ASSTDT
     C                   EXSR      SRZDate2
     C                   MOVE      pDDMMMYY      RSTR
      *
      ** Convert end period date from Midas No. to DDMMMYY format
      *
     C                   EVAL      pDayNo = ASENDT
     C                   EXSR      SRZDate2
     C                   MOVE      pDDMMMYY      REND
      *
      ** Convert next period date from Midas No. to DDMMMYY format
      *
     C                   EVAL      pDayNo = ASNPSD
     C                   EXSR      SRZDate2
     C                   MOVE      pDDMMMYY      RNXT
      *
      ** File overflow checking
      *
     C                   Z-ADD     10            wRQDLN1
     C     OFLLN1        SUB       PRTLN1        wDIFLN1
     C                   IF        wDIFLN1 <= wRQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
      *
      ** Write report details
      *
     C                   WRITE     DETAIL1
 
     C                   ENDSR
      *
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRCalPerD - Report Global Average Spot Rates Processed            *
      *             This subroutine calculates the period end date of the *
      *             currency and the next start date                      *
      *                                                                   *
      * Called by: SRWrtGASR                                              *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     SRCalPerD     BEGSR
      *
      ** End date calculation selection
      *
     C                   SELECT
      *
      ** Calculate end period date for month frequencies
      *
     C                   WHEN      ASPDFQ  = 'M'
     C                   EVAL      pZPDNO  = wMthEndP
      *
      ** Calculate calendar end date period for Qurately, Semi Annual and Yearly Frequencies
      *
     C                   WHEN      ASPDFQ = 'CQ' OR ASPDFQ = 'CX'
     C                             OR ASPDFQ = 'CY'
     C                   EXSR      SRCalEndP
      *
      ** Calculate fiscal end period date
      *
     C                   WHEN      ASPDFQ = 'FQ' OR ASPDFQ = 'FX'
     C                             OR ASPDFQ = 'FY'
     C                   EXSR      SRFisEndP
     C                   ENDSL
      *
     C                   ENDSR
      *
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRCalMthE - This subroutine calculate the end period date for     *
      *             monthly calendar frequencies.                         *
      *                                                                   *
      * Called by: *INZSR                                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     SRCalMthE     BEGSR
 
      *
      ** Get run date month end no. of days from the array
      *
     C                   MOVE      aMTHE(pMM)    wDD
      *
      ** Move  FEB 29th as End Period Day if Year falls as a leap year
      *
     C     wMM           IFEQ      '02'
     C                   MOVE      pYY           Z@YR              2 0
     C     Z@YR          DIV       4             Z@WK1             2 0
     C                   MVR                     Z@WK2             2 0
     C*
     C     Z@WK2         IFEQ      0
     C                   EVAL      wDD  = '29'
     C                   ENDIF
     C                   ENDIF
 
      *
      ** Convert End Period Date constructed for monthly frequency to Midas Day No.
      *
     C                   EXSR      SRZDate1
     C                   EVAL      wMthEndP = pDayNo
      *
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRCalEndP - This subroutine calculate the end period for          *
      *             calendar frequencies                                  *
      *                                                                   *
      * Called by: SRCalPerD                                              *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     SRCalEndP     BEGSR
 
     C                   MOVE      pYY           wYY
      *
      **  Select Calendar End period date using format MMDDYY from Rundate
      *
     C                   SELECT
     C                   WHEN      (ASPDFQ = 'CQ' AND pMM <4)
     C                   EVAL      wMM    = '03'
     C                   EVAL      wDD    = aMTHE(03)
 
     C                   WHEN      (ASPDFQ = 'CQ' AND pMM >3 AND pMM <7)
     C                             OR (ASPDFQ = 'CX' AND pMM <7)
     C                   EVAL      wMM    = '06'
     C                   EVAL      wDD    = aMTHE(06)
 
     C                   WHEN      (ASPDFQ = 'CQ' AND pMM>6 AND pMM<10)
     C                   EVAL      wMM    = '09'
     C                   EVAL      wDD    = aMTHE(09)
 
     C                   OTHER
     C                   EVAL      wMM    = '12'
     C                   EVAL      wDD    = aMTHE(12)
     C                   ENDSL
      *
      ** Convert Calendar end period date (MMDDYY) to Midas No.
      *
     C                   EXSR      SRZDate1
     C                   EVAL      pZPDNO = pDayNo
      *
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRFisEndP - This subroutine calculate the end perior for          *
      *             the fiscal frequencies                                *
      *                                                                   *
      * Called by: SRCalPerD                                              *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     SRFisEndP     BEGSR
      *
      ** Get Fiscal start period month and Year
      *
     C                   EVAL      wStrMth = pStrDte + 1
     C                   EVAL      wYear = pYY
 
     C                   IF        wStrMth > pMM
     C                   EVAL      wYear = pYY - 1
     C                   ENDIF
      *
      ** Initialise start period date defined in system values maintenance
      *
     C                   MOVE      wYear         wYY
     C                   MOVE      wStrMth       wMM
     C                   MOVE      '01'          wDD
      *
      ** Convert start period date (MMDDYY) to Midas No.
      *
     C                   EXSR      SRZDate1
      *
      ** Get start end period date, loop until current end period is reached for the year.
      *
     C                   DOW       pDayno <= BJRDNB
     C
 
     C                   SELECT
     C                   WHEN      ASPDFQ = 'FQ'
     C                   EVAL      pAddMonth  = 3
     C                   WHEN      ASPDFQ = 'FX'
     C                   EVAL      pAddMonth  = 6
     C                   WHEN      ASPDFQ = 'FY'
     C                   EVAL      pAddMonth  = 12
     C                   ENDSL
      *
      ** Calculate end period date
      *
     C                   EXSR      SRCalcEndP
 
     C                   EVAL      pDayNo = pZPDNO
     C                   ENDDO
      *
      ** Get period end day
      *
     C                   EVAL      pZPDNO = pZPDNO - 1
      *
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRCalEndP - Calculate end period date                             *
      *                                                                   *
      * Called by: SRFisEndP                                              *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     SRCalcEndP    BEGSR
      *
      ** ZCDP parameter
      *
     C                   EVAL      pAddYear    = 0
     C                   EVAL      pAddDays    = 0
      *
      ** Get end period date  - ZCPD
      *
     C                   CALLB     'ZCPD'
     C                   PARM                    pDayNo
     C                   PARM                    pAddYear
     C                   PARM                    pAddMonth
     C                   PARM                    pAddDays
     C                   PARM                    pDtFmt
     C                   PARM                    pZPDNO
     C                   PARM                    pZPDTE
      *
     C                   EVAL      pDDMMMYY1 = pZPDTE
      *
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRAudit   - Audit subroutine                                      *
      *                                                                   *
      * Called by: *INZSR                                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     SRAudit       BEGSR
      *
     C                   READ      GPAVSRPA
     C                   EVAL      GHNORE = GHNORE + wCounter
     C                   IF        %EOF(GPAVSRPA)
     C                   WRITE     GPAVSRA0
     C                   ELSE
     C                   UPDATE    GPAVSRA0
     C                   ENDIF
      *
     C                   ENDSR
      *
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRZDate1  - This subroutine changes the date MMDDYY to Midas No.  *
      *                                                                   *
      * Called by: SRCalPerD,SRFisEndP,SRCalEndP                          *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     SRZDate1      BEGSR
      *
      ** Parameter for ZDATE1
      *
     C                   Move      wMMDDYY       pMMDDYY
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    pMMDDYY
     C                   PARM                    pDayNo
     C                   PARM      'M'           pDtFmt
     C                   PARM      *Blanks       pError
      *
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRZDate2  - This subroutine changes the Midas Date No. to         *
      *             DDMMMYY Format                                        *
      *                                                                   *
      * Called by: *INZSR, SRRptGASR                                      *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     SRZDate2      BEGSR
      *
     C                   CALL      'ZDATE2'
     C                   PARM                    pDAYNO
     C                   PARM      'M'           pDtFmt
     C                   PARM                    pDate
     C                   PARM                    pDDMMMYY
      *
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
      *
     C                   DUMP
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
      *
     C                   CALLB     'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      ************************************************************
** aMTHE - No. of days in a month
312831303130313130313031
