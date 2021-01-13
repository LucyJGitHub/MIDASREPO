     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Initialise CAS006 new fields on database')    *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standards Module                          *
      *                                                               *
      *  AS100006 - Initialise CAS006 new fields on database          *
      *                                                               *
      *  Function:  This program will initialise all new fields       *
      *             introduced by CAS006 enhancement on database      *
      *             files.                                            *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 234300             Date 28Sep06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 CDL038             Date 10May05               *
      *                 CAS008             Date 16Jun04               *
      *                 228104             Date 11Jun04               *
      *                 CDL028             Date 07Feb05               *
      *                 CAS006  *CREATE    Date 21Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  234300 - Recompiled over changed in PF/HSTTRD.               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CAS008 - IAS 39 Enhancements (Recompile)                     *
      *  228104 - Error on the computation of average price for       *
      *           back valued transaction. Need to initialise         *
      *           PF/BKPHHD.                                          *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CAS006 - Hedge Accounting Phase B                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
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
 
      ** Forecast Transactions Details file
     FASFHTRPD  UF   E           K DISK    INFSR(*PSSR)
 
      ** SE Book Positions Header file
     FBKPHDD    UF   E           K DISK    INFSR(*PSSR)
                                                                                              228104
      ** SE Historic Book Positions Header file                                               228104
     FBKPHHD    UF   E           K DISK    INFSR(*PSSR)                                       228104
     F                                     RENAME(BKPHDDF:BKPHHDF)                            228104
 
      ** SE Book Positions Detail file
     FBKPOSD    UF   E           K DISK    INFSR(*PSSR)
 
      ** Historic Book Posn Actions file
     FBPACHD    UF   E           K DISK    INFSR(*PSSR)
 
      ** SE Bulk Trades Detail file
     FBULKTD    UF   E           K DISK    INFSR(*PSSR)
 
      ** DL FRA/IRS Details file
     FDEALSDG   UF   E           K DISK    INFSR(*PSSR)
 
      ** SE Historic Trades Detail file
     FHSTTRD    UF   E           K DISK    INFSR(*PSSR)
 
      ** SD Hedge Strategy file
     FSDHGSTPD  UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX('SD_')
 
      ** SE Securities Detail file
     FSECTYD    UF   E           K DISK    INFSR(*PSSR)
 
      ** SE Securities Diary Events file
     FSEDEVD    UF   E           K DISK    INFSR(*PSSR)
 
      ** SE Security Non-Diary Events file
     FSNDEVD    UF   E           K DISK    INFSR(*PSSR)
 
      ** SE Trades Detail file
     FTRADSD    UF   E           K DISK    INFSR(*PSSR)
 
     FAS100006AUO    E             PRINTER
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    DTAARA(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PReturnCode     S              7
     D POption         S              7
     D WRun            S              1
 
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
 
      ** ASFHTRPD
 
     C                   EVAL      WCount =  0
     C                   EVAL      DBFILE = 'ASFHTRPD'
     C                   READ      ASFHTRPD
 
     C                   DOW       NOT %EOF(ASFHTRPD)
     C                   EVAL      FSMOD = 'GL'
     C                   EVAL      FSSDAT = FSINDT
     C                   EVAL      WCount = WCount + 1
     C                   UPDATE    ASFHTRD0
     C                   READ      ASFHTRPD
     C                   ENDDO
 
     C                   EVAL      WFILE= DBFILE
     C                   EVAL      WFILENar='Forecast Transactions Details file'
     C                   WRITE     CONTROL
 
      ** BKPHDD
 
     C                   EVAL      WCount =  0
     C                   EVAL      DBFILE = 'BKPHDD'
     C                   READ      BKPHDD
 
     C                   DOW       NOT %EOF(BKPHDD)
     C                   EVAL      LAVN = LAVP
     C                   EVAL      DPAN = DPAP
     C                   EVAL      BUDN = BUDU
     C                   EVAL      INDN = INDO
     C                   EVAL      WCount = WCount + 1
     C                   UPDATE    BKPHDDF
     C                   READ      BKPHDD
     C                   ENDDO
 
     C                   EVAL      WFILE= DBFILE
     C                   EVAL      WFILENar='SE Book Positions Header file'
     C                   WRITE     CONTROL
 
      ** BKPHHD                                                                               228104
                                                                                              228104
     C                   EVAL      WCount =  0                                                228104
     C                   EVAL      DBFILE = 'BKPHHD'                                          228104
     C                   READ      BKPHHD                                                     228104
                                                                                              228104
     C                   DOW       NOT %EOF(BKPHHD)                                           228104
     C                   EVAL      LAVN = LAVP                                                228104
     C                   EVAL      DPAN = DPAP                                                228104
     C                   EVAL      BUDN = BUDU                                                228104
     C                   EVAL      INDN = INDO                                                228104
     C                   EVAL      WCount = WCount + 1                                        228104
     C                   UPDATE    BKPHHDF                                                    228104
     C                   READ      BKPHHD                                                     228104
     C                   ENDDO                                                                228104
                                                                                              228104
     C                   EVAL      WFILE= DBFILE                                              228104
     C                   EVAL      WFILENar='SE Hist Book Positions Header file'              228104
     C                   WRITE     CONTROL                                                    228104
                                                                                              228104
      ** BKPOSD
 
     C                   EVAL      WCount =  0
     C                   EVAL      DBFILE = 'BKPOSD'
     C                   READ      BKPOSD
 
     C                   DOW       NOT %EOF(BKPOSD)
     C                   EVAL      APPN = APPB
     C                   EVAL      APNN = APNC
     C                   EVAL      PILN = PILP
     C                   EVAL      WCount = WCount + 1
     C                   UPDATE    BKPOSDF
     C                   READ      BKPOSD
     C                   ENDDO
 
     C                   EVAL      WFILE = DBFILE
     C                   EVAL      WFILENar='SE Book Positions Detail file'
     C                   WRITE     CONTROL
 
      ** BPACHD
 
     C                   EVAL      WCount =  0
     C                   EVAL      DBFILE = 'BPACHD'
     C                   READ      BPACHD
 
     C                   DOW       NOT %EOF(BPACHD)
     C                   EVAL      BCPN = BCPR
     C                   EVAL      CNTN = CNTP
     C                   EVAL      INAN = INAJ
     C                   EVAL      PCHN = PCHI
     C                   EVAL      WCount = WCount + 1
     C                   UPDATE    BPACHDF
     C                   READ      BPACHD
     C                   ENDDO
 
     C                   EVAL      WFILE = DBFILE
     C                   EVAL      WFILENar='Historic Book Posn Actions file'
     C                   WRITE     CONTROL
 
      ** BULKTD
 
     C                   EVAL      WCount =  0
     C                   EVAL      DBFILE = 'BULKTD'
     C                   READ      BULKTD
 
     C                   DOW       NOT %EOF(BULKTD)
     C                   EVAL      TINN = TINA
     C                   EVAL      ITRN = ITRA
     C                   EVAL      PRICN = PRIC
     C                   EVAL      WCount = WCount + 1
     C                   UPDATE    BULKTDF
     C                   READ      BULKTD
     C                   ENDDO
 
     C                   EVAL      WFILE = DBFILE
     C                   EVAL      WFILENar='SE Bulk Trades Detail file'
     C                   WRITE     CONTROL
 
      ** DEALSDG
 
     C                   EVAL      WCount =  0
     C                   EVAL      DBFILE = 'DEALSDG'
     C                   READ      DEALSDG
 
     C                   DOW       NOT %EOF(DEALSDG)
      *
     C                   IF        DTYP = 'FR'
     C                   Z-ADD     UAIPD         FSUIPB
     C                   Z-ADD     UIPRD         FSUPRB
     C                   Z-ADD     UAIAP         FSUIAB
     C                   Z-ADD     UIALC         FSUALB
     C                   Z-ADD     UAITC         FSUITB
     C                   Z-ADD     UAIAN         FSUINB
     C                   Z-ADD     UIPRM         FSUPMB
     C                   Z-ADD     UNSAM         FSUSAB
     C                   Z-ADD     UPAMT         FSUPAM
      *
     C                   Z-ADD     TAIPD         FSTIPB
     C                   Z-ADD     TIPRD         FSTPRB
     C                   Z-ADD     TAIAP         FSTIAB
     C                   Z-ADD     TIALC         FSTALB
     C                   Z-ADD     TAITC         FSTITB
     C                   Z-ADD     TAIAN         FSTINB
     C                   Z-ADD     TIPRM         FSTPMB
     C                   Z-ADD     TNSAM         FSTSAB
     C                   Z-ADD     TPAMT         FSTPAM
     C                   EVAL      WCount = WCount + 1
 
     C                   UPDATE    DEALSDGF
     C                   ENDIF
 
     C                   READ      DEALSDG
     C                   ENDDO
 
     C                   EVAL      WFILE = DBFILE
     C                   EVAL      WFILENar='DL FRA/IRS Details file'
     C                   WRITE     CONTROL
 
      ** HSTTRD
 
     C                   EVAL      WCount =  0
     C                   EVAL      DBFILE = 'HSTTRD'
     C                   READ      HSTTRD
 
     C                   DOW       NOT %EOF(HSTTRD)
     C                   EVAL      TINN = TINA
     C                   EVAL      ITRN = ITRA
     C                   EVAL      PRICN = PRIC
     C                   EVAL      WCount = WCount + 1
     C                   UPDATE    HSTTRDF
     C                   READ      HSTTRD
     C                   ENDDO
 
     C                   EVAL      WFILE = DBFILE
     C                   EVAL      WFILENar='SE Historic Trades Detail file'
     C                   WRITE     CONTROL
 
      ** SDHGSTPD
 
     C                   EVAL      WCount =  0
     C                   EVAL      DBFILE = 'SDHGSTPD'
     C                   READ      SDHGSTPD
 
     C                   DOW       NOT %EOF(SDHGSTPD)
     C                   EVAL      SD_FSMEFF = 'D'
     C                   EVAL      WCount = WCount + 1
     C                   UPDATE    SDHGSTD0
     C                   READ      SDHGSTPD
     C                   ENDDO
 
     C                   EVAL      WFILE = DBFILE
     C                   EVAL      WFILENar='SD Hedge Strategy file'
     C                   WRITE     CONTROL
 
      ** SECTYD
 
     C                   EVAL      WCount =  0
     C                   EVAL      DBFILE = 'SECTYD'
     C                   READ      SECTYD
 
     C                   DOW       NOT %EOF(SECTYD)
     C                   EVAL      CPNN = CPNR
     C                   EVAL      MKPN = MKPR
     C                   EVAL      WCount = WCount + 1
     C                   UPDATE    SECTYDF
     C                   READ      SECTYD
     C                   ENDDO
 
     C                   EVAL      WFILE = DBFILE
     C                   EVAL      WFILENar='SE Securities Detail file'
     C                   WRITE     CONTROL
 
      ** SEDEVD
 
     C                   EVAL      WCount =  0
     C                   EVAL      DBFILE = 'SEDEVD'
     C                   READ      SEDEVD
 
     C                   DOW       NOT %EOF(SEDEVD)
     C                   EVAL      SDNN = SDNC
     C                   EVAL      WCount = WCount + 1
     C                   UPDATE    SEDEVDF
     C                   READ      SEDEVD
     C                   ENDDO
 
     C                   EVAL      WFILE = DBFILE
     C                   EVAL      WFILENar='SE Securities Diary Events file'
     C                   WRITE     CONTROL
 
      ** SNDEVD
 
     C                   EVAL      WCount =  0
     C                   EVAL      DBFILE = 'SNDEVD'
     C                   READ      SNDEVD
 
     C                   DOW       NOT %EOF(SNDEVD)
     C                   EVAL      SNCN = SNCR
     C                   EVAL      WCount = WCount + 1
     C                   UPDATE    SNDEVDF
     C                   READ      SNDEVD
     C                   ENDDO
 
     C                   EVAL      WFILE = DBFILE
     C                   EVAL      WFILENar='SE Security Non-Diary Events file'
     C                   WRITE     CONTROL
 
      ** TRADSD
 
     C                   EVAL      WCount =  0
     C                   EVAL      DBFILE = 'TRADSD'
     C                   READ      TRADSD
 
     C                   DOW       NOT %EOF(TRADSD)
     C                   EVAL      TINN = TINA
     C                   EVAL      ITRN = ITRA
     C                   EVAL      PRICN = PRIC
     C                   EVAL      WCount = WCount + 1
     C                   UPDATE    TRADSDF
     C                   READ      TRADSD
     C                   ENDDO
 
     C                   EVAL      WFILE = DBFILE
     C                   EVAL      WFILENar='SE Trades Detail file'
     C                   WRITE     CONTROL
 
      ** Write End of Report
 
     C                   WRITE     ENDREPORT
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
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
 
     C                   EVAL      DBPGM  =  'AS10006'
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBKEY  =  *BLANKS
     C                   EVAL      DBFILE =  *BLANKS
     C                   EVAL      WCount =  0
 
      **  Use access program to read bank details file
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PReturnCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  '*CALL'
     C                   EVAL      DBASE  =  002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Write audit file header
 
     C                   WRITE     HEADAU
 
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program UPDATEion error routine                          *
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
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
      ** Write database error on audit report
 
     C                   WRITE     DBERROR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
