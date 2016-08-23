     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas Zone Ave Spot Rates Periodic Dates Extract')     *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standards Module                          *
      *                                                               *
      *  AS002402 - Midas Zone Average Spot Rates Periodic Dates      *
      *             Extract                                           *
      *                                                               *
      *  Function:  This program extracts currency period dates       *
      *             records start history date to run date - 1        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAS014  *CREATE    Date 10Aug05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
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
      * SRExZnPD  - Extract Zone Periodic Dates Subroutine            *
      * SRCalFreq - Calendar Frequency Periodic Dates Processing      *
      * SRFisFreq - Fiscal Frequency Periodic Dates Processing        *
      * SRWrtZPPD - Writes Zone Average Spot Rates Periodic Date      *
      *             details                                           *
      * SRCalPerd - Report Global Average Spot Rates Processed        *
      * *PSSR     - Error processing                                  *
      * *INZSR    - Initialise                                        *
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
 
      ** Midas Historic Spot Rates By Date & CCY
     FSDCUHSL2  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Currency codes update
     FSDCURRL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas Extract Zone Period Dates for Take On Proc.
     FGPEZPDL0  UF A E           K DISK    INFSR(*PSSR)
 
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
      ** Calendar Periodic Frequency Array
     D ACPFA           S              2A   DIM(4) CTDATA PERRCD(1)
 
      ** Fiscal Periodic Frequency Array
     D AFPFA           S              2A   DIM(3) CTDATA PERRCD(1)
 
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
 
      ** Program Status Data Structure
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
      ** First DS for Access programs - short data structure
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External data structure for Bank Details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Calling parameters for ZDATE1 / ZDATE2
 
     D                 DS
     D PDATE                   1      6  0
     D  MM                     1      2  0
     D  DD                     3      4  0
     D  MYEAR                  5      6  0
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D @RUN            S              1
 
      ** Calling parameters for ZDATE1 / ZDATE2
 
     D PDayNo          S              5  0 INZ(0)
     D PDtFmt          S              1    INZ(*BLANKS)
     D PDDMMMYY        S              7    INZ(*BLANKS)
     D PError          S              1A   INZ(*BLANKS)
     D PMidasDt        S              6  0
 
      ** Calling parameters for GOGETZONE
 
     D PTERMS          S             50
     D PFULFCHK        S              1
     D PZONE           S             10
     D PSHTC           S              4
     D PRDNB           S              5  0
     D PDNWD           S              5  0
     D PBCCY           S              3
     D PNJOB           S              1  0
 
      ** Calling parameters for ZCPD
 
     D PAddYr          S              2  0
     D PAddMonth       S              2  0
     D PAddDays        S              2  0
     D PZPDNO          S              5  0 INZ(0)
     D PZPDTE          S              7    INZ(*BLANKS)
 
      ** parameters for AOBANKRO
 
     D PRTCD           S              7A
     D POPTN           S              7A
 
      ** Parameters for GPAOSVALR0
 
     D P@OP01          S             20    INZ(*BLANKS)
     D P@VL01          S            200    INZ(*BLANKS)
     D P@OP02          S             20    INZ(*BLANKS)
     D P@VL02          S            200    INZ(*BLANKS)
     D P@OP03          S             20    INZ(*BLANKS)
     D P@VL03          S            200    INZ(*BLANKS)
     D P@OP04          S             20    INZ(*BLANKS)
     D P@VL04          S            200    INZ(*BLANKS)
     D P@OP05          S             20    INZ(*BLANKS)
     D P@VL05          S            200    INZ(*BLANKS)
     D P@OP06          S             20    INZ(*BLANKS)
     D P@VL06          S            200    INZ(*BLANKS)
     D P@OP07          S             20    INZ(*BLANKS)
     D P@VL07          S            200    INZ(*BLANKS)
     D P@OP08          S             20    INZ(*BLANKS)
     D P@VL08          S            200    INZ(*BLANKS)
     D P@OP09          S             20    INZ(*BLANKS)
     D P@VL09          S            200    INZ(*BLANKS)
     D P@OP10          S             20    INZ(*BLANKS)
     D P@VL10          S            200    INZ(*BLANKS)
 
      ** Variables for key list G2CRST
 
     D K1CYCD          S              3
     D K1HIDT          S              5  0
 
      ** Work variables
 
     D WCTR            S              3S 0 INZ(0)
     D WFREQ           S              2
     D WFirstPeriod    S              1
     D WFStrMo         S              2S 0
 
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
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
      ** Extract periodate dates
 
     C                   EXSR      SRExZnPD
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRExZnPD  - Extract Zone Periodic Dates Subroutine                *
      *             This subroutine will extract frequency periodic       *
      *             dates for all currency defined in zone using the      *
      *             available history.                                    *
      *                                                                   *
      * Called by: Main Routine                                           *
      *                                                                   *
      * Calls: SRCalFreq, SRFisFreq                                       *
      *                                                                   *
      *********************************************************************
     C     SRExZnPD      BEGSR
 
     C     *LOVAL        SETLL     SDCURRL0
     C                   READ      SDCURRL0
     C                   DOW       NOT %EOF(SDCURRL0)
 
     C                   EVAL      K1CYCD = A6CYCD
     C                   EVAL      K1HIDT = *LOVAL
     C     G2CRST        SETLL     SDCUHSL2
     C     A6CYCD        READPE    SDCUHSL2
     C                   IF        NOT %EOF(SDCUHSL2)
 
      **  Process calendar frequency periodic dates
 
     C                   EXSR      SRCalFreq
 
      ** Process Fiscal Frequency Periodic dates
 
     C                   EXSR      SRFisFreq
 
     C                   ENDIF
     C                   READ      SDCURRL0
     C                   ENDDO
 
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRCalFreq - Calendar Frequency Periodic Dates Processing          *
      *             This subroutine writes calendar frequency periodic    *
      *             dates for the currency from history calendar start    *
      *             date up to run date - 1                               *
      *                                                                   *
      *                                                                   *
      * Called by: SRExZnPD                                               *
      *                                                                   *
      * Calls: SRCaLPerd, SRWrtZPPD                                       *
      *                                                                   *
      *********************************************************************
     C     SRCalFreq     BEGSR
 
     C                   EVAL      WCTR = 1
 
      ** WCTR: 1 = MONTHLY; 2 = QUARTERLY; 3 = SEMI ANNUAL; 4 = ANNUAL
 
     C                   DOW       WCTR <= 4
 
      ** Retrieve Frequency for GPEZPDPD
 
     C                   MOVE(P)   ACPFA(WCTR)   WFREQ
 
      ** Period start date
 
     C                   EVAL      PDayNo = G2HIDT
 
      ** Determine start date
      ** Convert to Midas day number to MMDDYY
 
     C                   CALL      'ZDATE2'
     C                   PARM                    PDayNo
     C                   PARM      'M'           PDtFmt
     C                   PARM                    PMidasDt
     C                   PARM      *BLANKS       PDDMMMYY
 
     C                   MOVE      PMidasDt      PDATE
 
      ** Retrieve from-month for the first period
 
     C                   SELECT
     C                   WHEN      ACPFA(WCTR) = 'CQ' AND MM >= 1
     C                             AND MM <= 3
     C                   EVAL      MM = 1
     C                   WHEN      ACPFA(WCTR) = 'CQ' AND MM >= 4
     C                             AND MM <= 6
     C                   EVAL      MM = 4
     C                   WHEN      ACPFA(WCTR) = 'CQ' AND MM >= 7
     C                             AND MM <= 9
     C                   EVAL      MM = 7
     C                   WHEN      ACPFA(WCTR) = 'CQ' AND MM >= 10
     C                             AND MM <= 12
     C                   EVAL      MM = 10
     C                   WHEN      ACPFA(WCTR) = 'CX' AND MM >= 1
     C                             AND MM <= 6
     C                   EVAL      MM = 1
     C                   WHEN      ACPFA(WCTR) = 'CX' AND MM >= 7
     C                             AND MM <= 12
     C                   EVAL      MM = 7
     C                   WHEN      ACPFA(WCTR) = 'CY'
     C                   EVAL      MM = 1
     C                   ENDSL
 
      ** Default from-day for the first period
 
     C                   EVAL      DD = 1
 
      ** Convert MMDDYY to Midas day number
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDATE
     C                   PARM                    PDayNo
     C                   PARM      'M'           PDtFmt
     C                   PARM                    PError
 
     C                   EVAL      WFirstPeriod = 'Y'
 
      ** Loop while valid start date
 
     C                   DOU       PDayNo >= BJRDNB
 
     C                   SELECT
     C                   WHEN      ACPFA(WCTR) = 'M '
     C                   EVAL      PAddMonth = 1
     C                   WHEN      ACPFA(WCTR) = 'CQ'
     C                   EVAL      PAddMonth = 3
     C                   WHEN      ACPFA(WCTR) = 'CX'
     C                   EVAL      PAddMonth = 6
     C                   WHEN      ACPFA(WCTR) = 'CY'
     C                   EVAL      PAddMonth = 12
     C                   ENDSL
 
      ** Compute for the End Period Date and Next Start Date
 
     C                   EXSR      SRCaLPerd
 
      ** Write to File
 
     C                   EXSR      SRWrtZPPD
 
     C                   EVAL      PDayNo = PZPDNO
 
     C                   EVAL      WFirstPeriod = 'N'
 
     C                   ENDDO
 
     C                   EVAL      WCTR = WCTR + 1
     C                   ENDDO
 
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRFisFreq - Fiscal Frequency Periodic Dates Processing            *
      *             This subroutine writes fiscal frequency periodic      *
      *             dates for the currency from history fiscal start      *
      *             date up to run date - 1                               *
      *                                                                   *
      *                                                                   *
      * Called by: SRExZnPD                                               *
      *                                                                   *
      * Calls: SRCaLPerd, SRWrtZPPD                                       *
      *                                                                   *
      *********************************************************************
     C     SRFisFreq     BEGSR
 
     C                   EVAL      WCTR = 1
 
      ** WCTR: 1 = Fiscal Quarterly; 2 = Fiscal Semi Annual; 3 = Fiscal Annual
 
     C                   DOW       WCTR <= 3
 
      ** Retrieve Frequency for GPEZPDPD
 
     C                   MOVE(P)   AFPFA(WCTR)   WFREQ
 
      ** Retrieve period start date
 
     C                   EVAL       PDayNo = G2HIDT
 
      ** Convert to Midas day number to MMDDYY
 
     C                   CALL      'ZDATE2'
     C                   PARM                    PDayNo
     C                   PARM      'M'           PDtFmt
     C                   PARM                    PMidasDt
     C                   PARM      *BLANKS       PDDMMMYY
 
     C                   MOVE      PMidasDt      PDATE
 
      ** Default start month and day
 
     C                   MOVEL     P@VL01        WFStrMo
     C                   ADD       1             WFStrMo
     C                   IF        WFStrMo > 12
     C                   EVAL      WFStrMo = 1
     C                   ENDIF
 
      ** Set start year
 
     C                   IF        WFStrMo > MM
     C                   IF        MYEAR > 0
     C                   EVAL      MYEAR = MYEAR - 1
     C                   ELSE
     C                   EVAL      MYEAR = 99
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      MM = WFStrMo
     C                   EVAL      DD = 1
 
      ** Convert MMDDYY to Midas day number
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDATE
     C                   PARM                    PDayNo
     C                   PARM      'M'           PDtFmt
     C                   PARM                    PError
 
     C                   EVAL      WFirstPeriod = 'Y'
 
     C                   DOU       PDayNo >= BJRDNB
 
     C                   SELECT
     C                   WHEN      AFPFA(WCTR) = 'FQ'
     C                   EVAL      PAddMonth = 3
     C                   WHEN      AFPFA(WCTR) = 'FX'
     C                   EVAL      PAddMonth = 6
     C                   WHEN      AFPFA(WCTR) = 'FY'
     C                   EVAL      PAddMonth = 12
     C                   ENDSL
 
      ** Compute for the End Period Date and Next Start Date
 
     C                   EXSR      SRCaLPerd
 
     C                   IF        (WFirstPeriod= 'Y' AND G2HIDT >= PDayNo
     C                             AND G2HIDT <= (PZPDNO - 1)) OR
     C                             (WFirstPeriod = 'N')
 
      ** Write to File
 
     C                   EXSR      SRWrtZPPD
 
     C                   EVAL      WFirstPeriod = 'N'
 
     C                   ENDIF
 
     C                   EVAL      PDayNo = PZPDNO
 
     C                   ENDDO
 
     C                   EVAL      WCTR = WCTR + 1
     C                   ENDDO
 
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRWrtZPPD - Writes Zone Average Spot Rates Periodic Date details  *
      *             for Zone currencies                                   *
      *             This subroutine writes new record in GPEZPDPD for     *
      *             all period frequencies for zone currencies            *
      *                                                                   *
      * Called by: SRCalFreq, SRFisFreq                                   *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     SRWrtZPPD     BEGSR
 
     C                   CLEAR                   GPEZDPD0
     C                   EVAL      EZCCYD = A6CYCD
     C                   EVAL      EZPDFQ = WFREQ
     C                   EVAL      EZZONE = PZONE
     C                   IF        WFirstPeriod = 'Y'
     C                   EVAL      EZSTDT = G2HIDT
     C                   ELSE
     C                   EVAL      EZSTDT = PDayNo
     C                   ENDIF
     C                   EVAL      EZENDT = PZPDNO - 1
     C                   EVAL      EZNPSD = PZPDNO
     C                   EVAL      EZLCDT = BJRDNB
 
     C                   WRITE     GPEZDPD0
 
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRCalPerd - Report Global Average Spot Rates Processed            *
      *             This subroutine calculates the period end date of the *
      *             currency and the next start date                      *
      *                                                                   *
      * Called by: SRCalFreq, SRFisFreq                                   *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     SRCalPerd     BEGSR
 
      ** Calculate a period date
 
     C                   CALLB     'ZCPD'
     C                   PARM                    PDayNo
     C                   PARM      *ZERO         PAddYr
     C                   PARM                    PAddMonth
     C                   PARM      *ZERO         PAddDays
     C                   PARM      'M'           PDtFmt
     C                   PARM                    PZPDNO
     C                   PARM                    PZPDTE
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOBANKR0, GOGETZONE, GPAOSVALR0                        *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** LDA Data area
 
     C     *DTAARA       DEFINE                  LDA
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  POPTN
     C                   EVAL      DBASE  =  001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   CALLB     'GOGETZONE'
 
     C                   PARM      *BLANK        PRTCD
     C                   PARM      *BLANK        PTERMS
      ** Inputs
     C                   PARM      'N'           PFULFCHK
      ** Outputs
     C                   PARM                    PZONE
     C                   PARM                    PSHTC
     C                   PARM                    PRDNB
     C                   PARM                    PDNWD
     C                   PARM                    PBCCY
     C                   PARM                    PNJOB
 
      ** Error detected  (*PSSR will end the program)
 
     C                   IF        PRTCD = '*ERROR'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBRCHPD'
     C                   EVAL      DBKEY  =  PTERMS
     C                   EVAL      DBASE  =  002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Retrieve Global Financial Year-End Month
 
     C                   EVAL      P@OP01 = 'GlobFinancialYEMonth'
     C                   CALL      'GPAOSVALR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM                    P@OP01
     C                   PARM                    P@VL01
     C                   PARM                    P@OP02
     C                   PARM                    P@VL02
     C                   PARM                    P@OP03
     C                   PARM                    P@VL03
     C                   PARM                    P@OP04
     C                   PARM                    P@VL04
     C                   PARM                    P@OP05
     C                   PARM                    P@VL05
     C                   PARM                    P@OP06
     C                   PARM                    P@VL06
     C                   PARM                    P@OP07
     C                   PARM                    P@VL07
     C                   PARM                    P@OP08
     C                   PARM                    P@VL08
     C                   PARM                    P@OP09
     C                   PARM                    P@VL09
     C                   PARM                    P@OP10
     C                   PARM                    P@VL10
 
      ** Error
 
     C                   IF        PRTCD <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'GPAOSVALPD'
     C                   EVAL      DBKEY  =  P@OP01
     C                   EVAL      DBASE  =  003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Key list for SDCUHSL2
 
     C     G2CRST        KLIST
     C                   KFLD                    K1CYCD
     C                   KFLD                    K1HIDT
 
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
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      ************************************************************
** ACPFA - Calendar Frequency Periodic Dates
M
CQ
CX
CY
** AFPFA - Fiscal Frequency Periodic Dates
FQ
FX
FY
