     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas Drop Off Expired Global Historic Spot Rates')    *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GO002439 - Midas Drop Off Expired Global Historic Spot Rates *
      *                                                               *
      *  Function:  This program will run every month end to drop     *
      *             spot rate records whose process is less than that *
      *             of retention period defined in the global system  *
      *             values maintenance                                *
      *                                                               *
      *  Component of: GOC002439                                      *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD056838           Date 01Oct20               *
      *  Prev Amend No. MD054605           Date 17Oct19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAS014  *CREATE    Date 10Aug05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056838 - Amend SFNUM type to packed decimal                *
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
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
      * SRPRocess - Identify and update records to be dropped         *
      * SRAudit - Writes trailer record                               *
      * SRReport - Prints details of records to be dropped            *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
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
      ** Midas GP Global Daily Historic Spot Rates
      *
     FGPCUHSL0  UF   E             DISK    INFSR(*PSSR)
      *
      ** Midas Global Daily Historic Spot Rates File-Audit
      *
     FGPCUHSPA  UF   E             DISK    INFSR(*PSSR)
      *
      ** Print File for Midas Global Historic Spot Rates Report
      *
     FGO002439P1O    E             PRINTER INFDS(SPOOL1) USROPN
      *
      ** Print File for Midas Global Historic Spot Rates Report - Audit
      *
     FGO002439AUO    E             PRINTER INFDS(SPOOLA)

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
      ** External data structure for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** First DS for Access programs - short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** INFDS for GO002439P1
      *
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0

      ** INFDS for AS002410AU
     D SPOOLA          DS
     D  SFILEA                83     92
     D  SFNUMA               123    124B 0
     D  OFLLNA               188    189B 0
     D  PRTLNA               367    368B 0
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D @RUN            S              1
      *
      ** Retention period variables
      *
     D wRetDate        S                   LIKE(BJRDNB)
     D                                     INZ(0)
     D wRtnPeriod      S              2  0 INZ(0)
      *
      ** Counter for audit file
      *
     D wCounter        S                   LIKE(GHNORE)
     D                                     INZ(0)
      *
      ** parameters for AOBANKRO
      *
     D pOption         S              7A
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
      ** variables if no details for printing for GO002439P1
      *
     D wP1Open         S              1A   INZ('N')
      *
      ** variables for handing printing overflows
      *
     D wRQDLN1         S              3S 0 INZ(0)
     D wDIFLN1         S              3S 0 INZ(0)
      *
      ** Calling parameters for ZDATE2
      *
     D pMidasDt        S              6  0
     D pDayNo          S              5  0 INZ(0)
     D pDtFmt          S              1    INZ(*BLANKS)
     D pDDMMMYY        S              7    INZ(*BLANKS)
     D pError          S              1A   INZ(*BLANKS)
      *
      ** Calling parameters for ZSFILE
      *
     D ZSEQ            S              5A
     D ZSENTY          S              3A
     D**ZSNUM***        S              6S 0                                                 MD056838
     D ZSNUM           S              6  0                                                  MD056838
     D ZSERR           S              1A
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
     C                   EXSR      SRProcess
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
      * Calls: AOBANKR0,GPAOSVALR0                                    *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** LDA Data area
      *
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

      *
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *blanks       pRtCd
     C                   PARM      '*FIRST '     pOption
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        pRtCd <> *BLANKS
      *
      ** Data base error in file SDBANKPD
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  '*FIRST'
     C                   EVAL      DBPGM  =  'GO002439'
     C                   EVAL      DBASE  =  001
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      ** Call Access program for Global System Value and retrieve
      ** current setting for 'Global Historic Spot Rate Retention'
      *
     C                   EVAL      pRtCd         = *BLANKS
     C                   EVAL      pSysVal01     = 'GPHstSpotRetention'
     C                   EVAL      pSysValCurS01 = *BLANKS

     C                   CALL      'GPAOSVALR0'
     C                   PARM                    pRtCd
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
     C**********         EVAL      DBFile     =  'GPSVALPD'                                 MD054605
     C                   EVAL      DBFile = 'GPSVLJW0'                                      MD054605
     C                   EVAL      DBPGM      =  'GO002439'
     C                   EVAL      DBKEY      =  pSysVal01
     C                   EVAL      DBASE      =  002
      *
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      ** Calculates Retention Period
      *
     C                   MOVEL     pSysValCurS01 wRtnPeriod
     C                   EVAL      wRetDate = wRtnPeriod * 31
     C                   EVAL      wRetDate = BJRDNB - wRetDate
      *
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcess - This program will identify and update all records *
      *             in global historic spot rates file whose process  *
      *             date is less than the computed retention date     *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: SRReport                                               *
      *                                                               *
      *****************************************************************
      *
     C     SRProcess     BEGSR
      *
      ** Read history file
      *
     C                   READ      GPCUHSL0
     C                   DOW       NOT %EOF(GPCUHSL0)
      *
     C                   IF        GHPRDT < wRetDate
      *
      ** Mark record for drop
      *
     C                   EVAL      GHCHTP = '*'
      *
      ** Update file
      *
     C                   UPDATE    GPCUHSD0
      *
      ** Update Counter for audit file
      *
     C                   EVAL      wCounter = wCounter + 1
      *
      ** Print report of records for dropping
      *
     C                   EXSR      SRReport
      *
     C                   ENDIF
      *
     C                   READ      GPCUHSL0
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
     C                   CLOSE     GO002439P1
     C                   EVAL      wP1Open     = 'N'
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReport  - This subroutine will report all records in the    *
      *             printer file that were dropped by the system.     *
      *             If no records due for dropping this report is not *
      *             printed.                                          *
      *                                                               *
      * Called by:  SRProcess                                         *
      *                                                               *
      * Calls: ZDate2                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRReport      BEGSR
      *
      ** Write report GO002439P1
      *
     C                   IF        wP1Open     = 'N'
     C                   OPEN      GO002439P1
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
      *
      ** Set report fields
      *
     C                   EVAL      RCUR = GHCYCD
     C                   EVAL      RRTE = GHSPRT
     C                   EVAL      RDEC = GHNBDP
     C                   EVAL      RIND = GHMDIN
      *
      ** Convert last change date to DDMMMYY format
      *
     C                   EVAL      pDayNo = GHLCD
     C                   CALL      'ZDATE2'
     C                   PARM                    pDAYNO
     C                   PARM      BJDFIN        pDtFmt
     C                   PARM                    pMidasDt
     C                   PARM                    pDDMMMYY
      *
     C                   MOVE      pDDMMMYY      RCHG
      *
      ** Convert process date to DDMMMYY format
      *
     C                   EVAL      pDayNo = GHPRDT
     C                   CALL      'ZDATE2'
     C                   PARM                    pDAYNO
     C                   PARM      BJDFIN        pDtFmt
     C                   PARM                    pMidasDt
     C                   PARM                    pDDMMMYY
      *
     C                   MOVE      pDDMMMYY      RPRC
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
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAudit   - Detail Report                                     *
      *                                                               *
      * Called by:  Main                                              *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRAudit       BEGSR
      *
      ** Check Counter
      *
     C                   IF        wCOUNTER = 0
      *
      ** Write audit report heading
      *
     C                   WRITE     HEADAU
      *
      ** Write 'NO DETAILS' updated
      *
     C                   WRITE     DTAILA2
     C                   ELSE
      *
      ** Read audit file
      *
     C                   READ      GPCUHSPA
     C                   EVAL      RRNO   = GHNORE
     C                   EVAL      GHNORE = GHNORE - wCounter
      *
      ** Check if record exist. Returns error if no record exist.
      *
     C                   IF        %EOF(GPCUHSPA)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'GPCUHSPA'
     C                   EVAL      DBKEY  =  'READ'
     C                   EVAL      DBASE  =  003
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
      ** Update trailer file
      *
     C                   ELSE
     C                   UPDATE    GPCUHSA0
     C                   ENDIF
      *
      ** Write audit report heading
      *
     C                   WRITE     HEADAU
      *
      ** Set report fields
      *
     C                   EVAL      RDLT = wCOUNTER
     C                   EVAL      RTOT = RRNO - RDLT
      *
      ** Write no. of records updated
      *
     C                   WRITE     DTAILA1
      *
     C                   ENDIF
      *
      ** Write end of report
      *
     C                   WRITE     ENDREAU
      *
     C                   ENDSR
      *
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
      ** Write audit report heading
      *
     C                   WRITE     HEADAU
      *
      ** Write audit report details
      *
     C                   WRITE     DTAILA3
      *
      ** Write end of report
      *
     C                   WRITE     ENDREAU
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   ENDIF
      *
      ** End of Program
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      ************************************************************
