     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas Drop Off Expired Average Spot Rates')
      *****************************************************************
      *                                                               *
      *  Midas - Account Standards Module                             *
      *                                                               *
      *  AS002410 - Midas Drop Off Expired Average Spot Rates         *
      *                                                               *
      *  Function:  This module runs every month end to drop average  *
      *             spot rate records whose process date is less than *
      *             that of the retention period defined in global    *
      *             system values.                                    *
      *                                                               *
      *                                                               *
      *  Called by: ASC002410 - Midas Drop Off Expired Average        *
      *                            Spot Rates                         *
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
      *  SRProcess - Identify records subject for dropping            *
      *  SRReport - Report Average Spot Rates Purged                  *
      *  SRAudit - Detail Report                                      *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
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
 
      ** Midas Average Spot Rate File
     FGPAVSRPD  UF   E             DISK    INFSR(*pssr)
 
      ** Midas Average Spot Rates - Audit
     FGPAVSRPA  UF   E           K DISK    INFSR(*pssr)
 
      ** Midas Expired Average Spot Rate Report
     FAS002410P1O    E             PRINTER INFDS(SPOOL1) USROPN
 
      ** Midas Expired Average Spot Rates Report - Audit
     FAS002410AUO    E             PRINTER INFDS(SPOOLA)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
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
 
      ** First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Array containing copyright statement
     D @CPY            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Array containing error messages
     D aERR            S             28    DIM(2) CTDATA PERRCD(1)
 
      ** INFDS for AS002410P1
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      *
      ** Whether or not *PSSR has been run previously
      *
     D @RUN            S              1
 
      ** variables to condition opening of print files
     D wP1Open         S              1A   INZ('N')
 
      *
      ** variables for handing printing overflows
      *
     D wRQDLN1         S              3S 0 INZ(0)
     D wDIFLN1         S              3S 0 INZ(0)
     D wRQDLNA         S              3S 0 INZ(0)
     D wDIFLNA         S              3S 0 INZ(0)
 
      *
      ** work fields
      *
     D wRetPdMM        S              2  0 INZ(0)
     D wRetPdDD        S              5  0 INZ(0)
     D wRecDel         S              6  0 INZ(0)
     D wRecBeg         S              6  0 INZ(0)
     D wTotRec         S              6  0 INZ(0)
 
      *
      ** parameters for AOBANKR0
      *
     D pReturnCode     S              7A
     D pOption         S              7A
 
      *
      ** Calling parameters for GPAOSVALR0
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
      ** Calling parameters for ZDATE2
      *
     D pMidasDt        S              6  0 INZ(0)
     D pDayNo          S              5  0 INZ(0)
     D pDtFmt          S              1    INZ(*BLANKS)
     D pDDMMMYY        S              7    INZ(*BLANKS)
 
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
 
     C                   EXSR      SRProcess
     C                   EXSR      SRAudit
 
 
     C                   EVAL      *INLR       = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcess - Identify records subject for dropping             *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: SRReport                                               *
      *                                                               *
      *****************************************************************
 
     C     SRProcess     BEGSR
 
      *
      ** Retrieve records from the Global Spot Rate file
      *
     C                   READ      GPAVSRPD
     C                   DOW       NOT %EOF
 
     C                   EVAL      wTotRec     = wTotRec + 1
      *
      ** select only closed periods
      *
     C                   IF        ASOPPD      = 'F'
 
      *
      ** Compare if process date is less than the computed retention.
      ** If so, tag delete the record.
      *
     C                   IF        ASENDT < wRetPDDD
     C                   EVAL      ASCHTP      = '*'
     C                   UPDATE    GPAVSRD0
     C                   EVAL      wRecDel     = wRecDel + 1
     C                   EXSR      SRReport
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      GPAVSRPD
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReport - Report Average Spot Rates Purged                   *
      *                                                               *
      * Called by: SRProcess                                          *
      *                                                               *
      * Calls: ZDATE2                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRReport      BEGSR
 
     C                   IF        wP1Open     = 'N'
     C                   OPEN      AS002410P1
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
      ** Move the record fields to the report detail line
      *
     C                   EVAL      RCUR        = ASCCYD
     C                   MOVE      ASASTD        RAVE
     C                   EVAL      RFRQ        = ASPDFQ
 
     C                   MOVE      ASSTDT        pDayNo
     C                   EXSR      SRZDATE2
     C                   MOVE      pDDMMMYY      RSTR
 
     C                   MOVE      ASENDT        pDayNo
     C                   EXSR      SRZDATE2
     C                   MOVE      pDDMMMYY      REND
 
     C                   MOVE      ASTSDD        RTSPT
     C                   EVAL      RZONE       = ASZONE
 
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
      *                                                               *
      * SRAudit - Detail Report                                       *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRAudit       BEGSR
 
      *
      ** write report endings
      *
     C                   IF        wP1Open     = 'Y'
     C                   Z-ADD     10            wRQDLN1
     C     OFLLN1        SUB       PRTLN1        wDIFLN1
     C                   IF        wDIFLN1    <= wRQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
     C                   EVAL      RTREC       = wRecDel
     C                   WRITE     ENDREP1
     C                   CLOSE     AS002410P1
     C                   EVAL      wP1Open     = 'N'
     C                   ENDIF
      *
      ** Get Beginning No. of Records in Trailer file
      *
     C                   READ      GPAVSRPA
     C                   IF        %EOF
      *
      ** Data base error in file GPAVSRPA
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE      = 'GPAVSRPA'
     C                   EVAL      DBPGM       = 'AS002410'
     C                   MOVEL     aErr(1)       DBKEY
     C                   EVAL      DBASE       = 003
     C                   OUT       LDA
 
 
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   EVAL      wRecBeg     = GHNORE
     C                   ENDIF
 
      *
      ** Check if File Control is out of balance
      *
     C                   IF        wRecBeg    <> wTotRec
      *
      ** Data base error in file GPAVSRPA
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE      = 'GPAVSRPA'
     C                   MOVEL     aErr(2)       DBKEY
     C                   EVAL      DBASE      =  003
     C                   EVAL      DBPGM      = 'AS002410'
     C                   OUT       LDA
 
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
 
     C                   EVAL      RNRUP       = wRecDel
     C                   EVAL      RNRFC       = wRecBeg - wRecDel
     C                   EVAL      GHNORE      = wTotRec - wRecDel
     C                   EVAL      RNRFF       = GHNORE
 
     C                   Z-ADD     10            wRQDLNA
     C     OFLLNA        SUB       PRTLNA        wDIFLNA
     C                   IF        wDIFLNA    <= wRQDLNA
     C                   WRITE     HEADAU
     C                   ENDIF
 
     C                   IF        wRecDel     = 0
     C                   WRITE     NODTLS
     C                   ELSE
     C                   WRITE     CONTROL
     C                   ENDIF
 
      *
      ** Update Trailer Record
      *
     C                   UPDATE    GPAVSRA0
 
     C                   ENDSR
 
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
 
      *
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *blanks       pReturnCode
     C                   PARM      '*FIRST '     pOption
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        (pReturnCode <> *BLANKS)
 
      *
      ** Data base error in file SDBANKPD
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBPGM  =  'AS002410'
     C                   EVAL      DBKEY  =  '*FIRST'
     C                   EVAL      DBASE  =  001
     C                   OUT       LDA
 
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
      *
      ** Get Spot Rate Retention
      *
     C                   EVAL      pRtCd         = *BLANKS
     C                   EVAL      pSysVal01     = 'AveSpotRateRetention'
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
     C                   EVAL      DBFILE     =  'GPAOSVALPD'
     C                   EVAL      DBKEY      =  pSysVal01
     C                   EVAL      DBPGM      =  'AS002410'
     C                   EVAL      DBASE      =  002
     C                   OUT       LDA
 
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
      *
      ** calculate retention period in days
      *
     C                   MOVEL     pSysValCurS01 wRetPdMM
     C                   EVAL      wRetPdDD = BJRDNB - (wRetPdMM * 31)
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRZDATE2 - Converts date to required format                       *
      *                                                                   *
      * Called by: SRREport                                               *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     SRZDATE2      BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    pDayNo
     C                   PARM      BJDFIN        pDtFmt
     C                   PARM                    pMidasDt
     C                   PARM                    pDDMMMYY
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: *INZSR, SRAudit                                        *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BEGSR
 
     C                   WRITE     HEADAU
     C                   WRITE     DBERROR
 
     C                   DUMP
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
** CPY@  ** Copyright
(c) Misys International Banking Systems Ltd. 2005
** aERR  ** Error messages
No records found in GPAVSRPA
File Control out of balance
