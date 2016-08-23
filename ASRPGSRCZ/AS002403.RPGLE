     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas Zone Ave Spot Rates Take On Processing')
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standards Module                          *
      *                                                               *
      *  AS002403 - Midas Zone Average Spot Rates Take On Processing  *
      *                                                               *
      *  Function:  This program initialise/calculate zone currency   *
      *             average spot rates for the extracted periodic     *
      *             date details in GPEZPDPD.                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CAS014  *CREATE    Date 10Aug05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
      * SRInitASPZ - Zone Average Spot Rate Processing                *
      * SRAccum    - Accumulate Spot Rates and Spot Dates             *
      * SRWrtZASR  - Writes New Average Spot Rate period details for  *
      *              Zone Currencies                                  *
      * SRRptGARZ  - Report Zone Average Spot Rate Processed          *
      * SRAudit    - Audit Subroutine                                 *
      * SRWP1END   - Write End of Report                              *
      * *PSSR      - Error processing                                 *
      * *INZSR     - Initialise                                       *
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
      ** Midas Historic Spot Rates By CCY & Date
     FSDCUHSL2  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas Extract Zone Period Date Take On
     FGPEZPDL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas Average Spot Rates
     FGPAVSRL0  UF A E           K DISK    INFSR(*PSSR)
 
      ** Midas Average Spot Rates
     FGPAVSRL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GPAVSRD0:GPAVSRD1)
     F                                     PREFIX(AA_)
      ** Midas Average Spot Rates File - Audit
     FGPAVSRPA  UF A E           K DISK    INFSR(*PSSR)
 
      ** Midas Zone Average Spot Rates Take On Processing Report
     FAS002403P1O    E             PRINTER INFDS(SPOOL1) INFSR(*PSSR)
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
 
      ** Program Status Data Structure
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
      ** First DS for Access programs - short data structure
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External data structure for Bank Details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** File Information Data Structure for AS002403P1
 
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
 
      ** Calling parameters for ZDATE1 / ZDATE2
 
     D                 DS
     D PDATE                   1      6  0
     D  MMDD                   1      2  0
     D  DDMM                   3      4  0
     D  MYEAR                  5      6  0
 
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D @RUN            S              1
 
      ** Calling parameters for GOGETZONE
 
     D PTERMS          S             50
     D PFULFCHK        S              1
     D PZONE           S             10
     D PSHTC           S              4
     D PRDNB           S              5  0
     D PDNWD           S              5  0
     D PBCCY           S              3
     D PNJOB           S              1  0
 
      ** parameters for AOBANKRO
 
     D PRTCD           S              7A
     D POPTN           S              7A
 
      ** Calling parameters for ZDATE2
 
     D PDayNo          S              5  0 INZ(0)
     D PDtFmt          S              1    INZ(*BLANKS)
     D PDyMonYr        S              7    INZ(*BLANKS)
     D PError          S              1A   INZ(*BLANKS)
     D PMidasDt        S              6  0
 
      ** Variables for key list G1CRST
 
     D K1CYCD          S              3
     D K1HIDT          S              5  0
 
      ** Work variables
 
     D WSpotRte        S             14  8
     D WSumSpot        S             20  8
     D WSpotDys        S              3  0
     D WFromDte        S              5  0
     D WEndDte         S              5  0
     D WRecCtr         S             10  0
     D WDIFLN1         S              3  0
 
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
 
     C     *LOVAL        SETLL     GPEZPDL0
     C                   READ      GPEZPDL0
     C                   DOW       NOT %EOF(GPEZPDL0)
 
      ** Process Zone Average Spot Rate
 
     C                   EXSR      SRInitASPZ
 
     C                   IF        WFromDte <> *ZERO
 
      ** Write New Average Spot Rate period detail
 
     C                   EXSR      SRWrtZASR
 
      ** Repot Zone Average Spot Rate
 
     C                   EXSR      SRRptGARZ
     C                   ENDIF
 
     C                   READ      GPEZPDL0
     C                   ENDDO
 
     C                   IF        WRecCtr > 0
 
      ** Update trailer file
 
     C                   EXSR      SRAudit
 
      ** Write report footer
 
     C                   EXSR      SRWP1END
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRInitASPZ - Zone Average Spot Rate Processing                    *
      *             This subroutine will initialise/calculate average     *
      *             spot rate for the defined period dates for the        *
      *             currency using the existing history details SDCUHSL0. *
      *                                                                   *
      * Called by: Main Routine                                           *
      *                                                                   *
      * Calls: SRAccum                                                    *
      *                                                                   *
      *********************************************************************
     C     SRInitASPZ    BEGSR
 
      ** Initialise Spot Rate and Spot days accumulator
 
     C                   EVAL      WSpotRte = *ZERO
     C                   EVAL      WSumSpot = *ZERO
     C                   EVAL      WSpotDys = *ZERO
     C                   EVAL      WFromDte = *ZERO
 
     C                   EVAL      K1CYCD = EZCCYD
     C                   EVAL      K1HIDT = EZSTDT
 
      ** Retrieve the first valid spot rate and store in WSpotRte
      ** Retrieve from date and store in WFromDte
 
     C     G1CRST        SETGT     SDCUHSL2
     C     G1CRST        READPE    SDCUHSL2
     C                   IF        NOT %EOF(SDCUHSL2)
     C                   EVAL      WSpotRte = G2SPRT
     C                   EVAL      WFromDte = G2HIDT
     C                   ELSE
     C     EZCCYD        READE     SDCUHSL2
     C                   IF        NOT %EOF(SDCUHSL2)
     C                   EVAL      WSpotRte = G2SPRT
     C                   EVAL      WFromDte = EZSTDT
     C                   ELSE
     C                   EVAL      WSpotRte = *ZERO
     C                   EVAL      WFromDte = *ZERO
     C                   ENDIF
     C                   ENDIF
 
     ** Retrieve appropriate end date
 
     C                   IF        EZENDT >= BJRDNB
     C                   EVAL      WEndDte = BJRDNB - 1
     C                   ELSE
     C                   EVAL      WEndDte = EZENDT
     C                   ENDIF
 
      ** Accumulate Spot Rate and Number of Days for the period
 
     C                   EXSR      SRAccum
 
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRAccum  -  Accumulate Spot Rates and Spot Dates                  *
      *             This subroutine will accumulate total spot rate       *
      *             and spot days for the period                          *
      *                                                                   *
      * Called by: SRInitASPZ                                             *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     SRAccum       BEGSR
 
     C     EZCCYD        READPE    SDCUHSL2
     C                   DOW       NOT %EOF(SDCUHSL2) AND
     C                             G2HIDT <= WEndDte
 
     C                   IF        WFromDte <> *ZERO
     C                   EVAL      WSpotDys = WSpotDys + (G2HIDT - WFromDte)
     C                   EVAL      WSumSpot = WSumSpot + ((G2HIDT -
     C                                        WFromDte) * WSpotRte)
     C                   ENDIF
 
     C                   EVAL      WSpotRte = G2SPRT
     C                   EVAL      WFromDte = G2HIDT
     C     EZCCYD        READPE    SDCUHSL2
     C                   ENDDO
 
     C                   IF        WFromDte <> *ZERO
     C                   EVAL      WSpotDys = WSpotDys + ((WEndDte - WFromDte)
     c                                        + 1)
     C                   EVAL      WSumSpot = WSumSpot + (((WEndDte -
     C                                        WFromDte) + 1) * WSpotRte)
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRWrtZASR - Writes New Average Spot Rate period details for Zone  *
      *             Currencies                                            *
      *             This subroutine writes new record in GPAVSRPD for     *
      *             all period frequencies for zone currencies that were  *
      *             processed                                             *
      *                                                                   *
      * Called by: Main Routine                                           *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     SRWrtZASR     BEGSR
 
     C                   CLEAR                   GPAVSRD0
     C                   EVAL      ASCCYD = EZCCYD
     C                   EVAL      ASPDFQ = EZPDFQ
     C                   EVAL      ASZONE = PZONE
 
      ** If currend period, default current year and month to
      ** ASPDYN and ASPDMN else default end period year and month
 
 
     C                   IF        BJRDNB >= EZSTDT AND BJRDNB <= EZENDT
     C                   EVAL      PDayNo = BJRDNB
     C                   ELSE
     C                   EVAL      PDayNo = EZENDT
     C                   ENDIF
 
     C                   CALL      'ZDATE2'
     C                   PARM                    PDayNo
     C                   PARM      BJDFIN        PDtFmt
     C                   PARM                    PMidasDt
     C                   PARM      *BLANKS       PDyMonYr
     C                   EVAL      PDATE = PMidasDt
 
     C                   SELECT
     C                   WHEN      BJDFIN = 'M'
     C                   MOVE      MYEAR         ASPDYN
     C                   MOVE      MMDD          ASPDMN
     C                   WHEN      BJDFIN = 'D'
     C                   MOVE      MYEAR         ASPDYN
     C                   MOVE      DDMM          ASPDMN
     C                   ENDSL
 
     C                   EVAL      ASSTDT = EZSTDT
     C                   EVAL      ASENDT = EZENDT
     C                   EVAL      ASNPSD = EZNPSD
     C                   EVAL      ASTSRD = WSumSpot
     C                   EVAL      ASTSDD = WSpotDys
     C                   EVAL      ASASTD = ASTSRD/ASTSDD
     C                   EVAL      ASMDIN = G2MDIN
     C                   IF        EZENDT < BJRDNB
     C                   EVAL      ASOPPD = 'F'
     C                   ENDIF
     C                   EVAL      ASCHTP = 'I'
     C                   EVAL      ASLCDT = BJRDNB - 1
 
     C                   WRITE     GPAVSRD0
 
      ** Count record for trailer file updates
 
     C                   EVAL      WRecCtr = WRecCtr + 1
 
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRRptGARZ - Report Zone Average Spot Rate Processed               *
      *                                                                   *
      * Called by: Main Routine                                           *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     SRRptGARZ     BEGSR
 
     C     OFLLN1        SUB       PRTLN1        WDIFLN1
     C                   IF        WDIFLN1  <= 1 OR WRecCtr = 0
     C                   EVAL      RZONE = PZONE
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   EVAL      RCUR  = EZCCYD
     C                   EVAL      RAVE  = ASASTD
     C                   EVAL      RFREQ = EZPDFQ
 
     C                   CALL      'ZDATE2'
     C                   PARM      EZSTDT        PDayNo
     C                   PARM      BJDFIN        PDtFmt
     C                   PARM                    PMidasDt
     C                   PARM      *BLANKS       PDyMonYr
     C                   EVAL      RSTR  = PDyMonYr
 
     C                   CALL      'ZDATE2'
     C                   PARM      EZENDT        PDayNo
     C                   PARM      BJDFIN        PDtFmt
     C                   PARM                    PMidasDt
     C                   PARM      *BLANKS       PDyMonYr
     C                   EVAL      REND  = PDyMonYr
 
     C                   CALL      'ZDATE2'
     C                   PARM      EZNPSD        PDayNo
     C                   PARM      BJDFIN        PDtFmt
     C                   PARM                    PMidasDt
     C                   PARM      *BLANKS       PDyMonYr
     C                   EVAL      RNXT  = PDyMonYr
 
     C                   EVAL      RCHG  = 'I'
 
     C                   WRITE     DETAIL1
 
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRAudit  -  Audit Subroutine                                      *
      *                                                                   *
      * Called by: Main Routine                                           *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     SRAudit       BEGSR
 
     C                   Z-ADD     0             WRecCtr
     C     *LOVAL        SETLL     GPAVSRL3
     C                   READ      GPAVSRL3
     C                   DOW       NOT %EOF(GPAVSRL3)
     C                   ADD       1             WRecCtr
     C                   READ      GPAVSRL3
     C                   ENDDO
 
     C                   READ      GPAVSRPA
     C                   EVAL      GHNORE = WRecCtr
     C                   IF        NOT %EOF(GPAVSRPA)
     C                   UPDATE    GPAVSRA0
     C                   ELSE
     C                   WRITE     GPAVSRA0
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWP1END - Write End of Report                               *
      *                                                               *
      *  Called by: Main Routine                                      *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
     C     SRWP1END      BEGSR
 
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
 
     C                   IF        (OFLLN1 - PRTLN1) <= 4
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Write report footer
 
     C                   EVAL      RTOT = WRecCtr
     C                   WRITE     TRAILP1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOBANKR0, GOGETZONE                                    *
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
 
      ** Retrieve Zone
 
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
 
      ** Key list for SDCUHSL2
 
     C     G1CRST        KLIST
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
