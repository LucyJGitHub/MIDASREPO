     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Hedge file drop/maintenance')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standards Module                          *
      *                                                               *
      *  AS000007 - File Drop/Maintenance of Hedge Files              *
      *                                                               *
      *  Function:  This module will drop deleted hedge strategies    *
      *             and expired/deleted/discontinued hedge linkages   *
      *             and their related hedged transactions once the    *
      *             retention period as set in the Hedging ICD is     *
      *             met.                                              *
      *                                                               *
      *  Component of: ASC000007                                      *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 228948             Date 27Sep04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 216358             Date 27Mar03               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS002  *CREATE    Date 14Jan02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  228948 - Add 'Exclude Accrued Interest in Unrealized Profit  *
      *           or Loss' (Recompile).                               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  216358 - SDFCTLPA is not updated. This will cause FOOB.      *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  CAS002 - Hedge Strategy/Linkage                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    26         No Details to Report Indicator                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRStrategy - Delete Hedge Strategy records which are flagged  *
      *              for deletion or beyond history retention date    *
      * SRLinkage - Delete Hedge Linkage Records which are expired,   *
      *             flagged for deletion, discontinued or beyond      *
      *             retention date.                                   *
      * SRTransact - Delete Hedge Transaction records related to the  *
      *              Hedge Linkage Records which are being dropped    *
      *              today.                                           *
      * SRForecast - Delete Forecast Transactions Records which are   *
      *              either matured or flagged for deletion, and      *
      *              beyond history retention date                    *
      * *PSSR - Program Exception Error Routine                       *
      * *INZSR - Program Initialisation Routine                       *
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
 
     FSDHGSTL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(F)                                          CAS006
      ** Hedge Strategy by Shortname Master File Update Index
 
     FASHGLKL0  UF   E           K DISK    INFSR(*PSSR)
      ** Hedge Linkage File Update by Hedge Id
 
     F***ASHTRNL0  UF   E           K DISK    INFSR(*PSSR)                                    CAS004
      ***Hedge*Transaction*File*RTV*by*Hedge*Id/Indicator                                     CAS004
                                                                                              CAS004
     FASHTRNLB  UF   E           K DISK    INFSR(*PSSR)                                       CAS004
      ** Hedge Transaction File RTV                                                           CAS004
 
     FASFHTRL0  UF   E           K DISK    INFSR(*PSSR)
      ** Forecast Transaction Details Master File Retrieval Index
 
     FSDHEDGL1  IF   E           K DISK    INFSR(*PSSR)
      ** Hedging ICD File Retrieval
 
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)                                       216358
      ** Standing Data Controls Update index                                                  216358
                                                                                              216358
     FAS000007AUO    E             PRINTER INFSR(*PSSR)
      ** Audit File
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
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
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                              CAS004
      ** External data structure for Switchable Features Details                              CAS004
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS004
                                                                                              CAS004
      ** External data structure for General Ledger ICD Details                               CAS004
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                                  CAS004
 
      ** Parameters for Standard Access Objects
     D PRtCd           S              7A
     D POption         S              7A
     D PSard           S              6A                                                      CAS004
 
      ** Work Fields for SDBANKPD fields
     D WRunDay         S              5  0
 
      ** Counters
     D WCounter1       S              9  0
     D WCounter2       S              9  0
     D WCounter3       S              9  0
     D WCounter4       S              9  0
     D WCounter5       S              9  0
     D WCounter6       S              9  0
     D WCounter7       S              9  0
 
      ** Work Fields
     D WTarget         S              5  0
     D WRetention      S             15  0
     D WRun            S              1A
     D CAS004          S              1                                                       CAS004
     D WEvCDat         S              5P 0                                                    CAS004
                                                                                              216358
     D KFLNM           S             10                                                       216358
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *****************************************************************
 
      ** Read Hedge Strategy File and Delete Records if required
 
     C                   EXSR      SRStrategy
 
      ** Read Hedge Linkage File and Delete Records if required
 
     C                   EXSR      SRLinkage
 
      ** Read Forecast Transactions File and Delete Records if required.
 
     C                   EXSR      SRForecast
 
      ** Write File Controls Report.
 
     C                   WRITE     FILCON
 
 B1  C                   IF        WCounter1 = 0
     C                   EVAL      *IN26 = *ON                                  NO DETAILS
 E1  C                   ENDIF
 
     C                   WRITE     EOREPT
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRStrategy - Delete Hedge Strategy records which are flagged *
      *               for deletion or beyond history retention date   *
      *                                                               *
      *  Called By:  Main Processing                                  *
      *                                                               *
      *  Calls    :  None                                             *
      *                                                               *
      ****************************************************************
 
     C     SRStrategy    BEGSR
 
      ** Read all hedge strategy records
 
     C     *LOVAL        SETLL     SDHGSTL0
 
     C                   DOU       %EOF(SDHGSTL0)
     C                   READ      SDHGSTL0
 
     C                   IF        NOT %EOF(SDHGSTL0)
     C                   ADD       1             WCounter1
 
      ** Delete Record
 
     C**********         IF        FSCHTP = 'D' AND FSLCD <= WTarget
     C                   IF        FFSCHTP = 'D' AND FFSLCD <= WTarget                        CAS006
     C                   DELETE    SDHGSTD0
     C                   ADD       1             WCounter2
                                                                                              216358
      ** Update Trailer                                                                       216358
     C                   EVAL      KFLNM = 'SDHGSTPD'                                         216358
     C     KFLNM         CHAIN     SDFCTLL0                                                   216358
     C                   IF        %FOUND(SDFCTLL0)                                           216358
     C                   SUB       1             AHNODL                                       216358
     C                   UPDATE    @AHREAU                                                    216358
     C                   ENDIF                                                                216358
                                                                                              216358
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLinkage - Delete Hedge Linkage Records which are expired,  *
      *              flagged for deletion, discontinued or beyond     *
      *              retention date.                                  *
      *                                                               *
      *  Called By:  Main Processing                                  *
      *                                                               *
      *  Calls    :  None                                             *
      *                                                               *
      ****************************************************************
 
     C     SRLinkage     BEGSR
 
      ** Read all hedge strategy records
 
     C     *LOVAL        SETLL     ASHGLKL0
 
     C                   DOU       %EOF(ASHGLKL0)
     C                   READ      ASHGLKL0
 
     C                   IF        NOT %EOF(ASHGLKL0)
     C                   ADD       1             WCounter3
 
      ** Delete Record
 
     C                   IF        FSRECI = '*' OR FSRECI = 'E' OR
                                                                                              CAS004
      ** Do not drop discontinued/ineffective hedge linkages when CAS004 is on                CAS004
                                                                                              CAS004
     C**********                   FSRECI = 'X'                                               CAS004
     C                             FSRECI = 'X' AND CAS004 = 'N'                              CAS004
     C                   IF        FSLCD <= WTarget
     C                   DELETE    ASHGLKD0
     C                   ADD       1             WCounter4
                                                                                              216358
      ** Update Trailer                                                                       216358
     C                   EVAL      KFLNM = 'ASHGLKPD'                                         216358
     C     KFLNM         CHAIN     SDFCTLL0                                                   216358
     C                   IF        %FOUND(SDFCTLL0)                                           216358
     C                   SUB       1             AHNODL                                       216358
     C                   SUB       1             AHNORC                                       216358
     C                   UPDATE    @AHREAU                                                    216358
     C                   ENDIF                                                                216358
 
      ** Read through the Hedge Transactions file, deleting all records
      ** for this Hedge ID
 
     C                   EXSR      SRTransact
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTransact - Delete Hedge Transaction records related to the *
      *               Hedge Linkage Records which are being dropped   *
      *               today.                                          *
      *                                                               *
      *  Called By:  Main Processing                                  *
      *                                                               *
      *  Calls    :  None                                             *
      *                                                               *
      ****************************************************************
 
     C     SRTransact    BEGSR
 
      ** Read all records for the specific Linkage Hedge ID
 
     C*****FSHEDI        SETLL     ASHTRNL0                                                   CAS004
     C     FSHEDI        SETLL     ASHTRNLB                                                   CAS004
 
     C**********         DOU       %EOF(ASHTRNL0)                                             CAS004
     C*****FSHEDI        READE     ASHTRNL0                                                   CAS004
 
     C                   DOU       %EOF(ASHTRNLB)                                             CAS004
     C     FSHEDI        READE     ASHTRNLB                                                   CAS004
                                                                                              CAS004
     C**********         IF        NOT %EOF(ASHTRNL0)                                         CAS004
     C                   IF        NOT %EOF(ASHTRNLB)                                         CAS004
     C                   DELETE    ASHTRND0
     C                   ADD       1             WCounter5
                                                                                              216358
      ** Update Trailer                                                                       216358
     C                   EVAL      KFLNM = 'ASHTRNPD'                                         216358
     C     KFLNM         CHAIN     SDFCTLL0                                                   216358
     C                   IF        %FOUND(SDFCTLL0)                                           216358
     C                   SUB       1             AHNODL                                       216358
     C                   SUB       1             AHNORC                                       216358
     C                   UPDATE    @AHREAU                                                    216358
     C                   ENDIF                                                                216358
                                                                                              216358
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      ****************************************************************
      *                                                               *
      *  SRForecast - Delete Forecast Transactions Records which are  *
      *               either matured or flagged for deletion, and     *
      *               beyond history retention date                   *
      *                                                               *
      *  Called By:  Main Processing                                  *
      *                                                               *
      *  Calls    :  None                                             *
      *                                                               *
      ****************************************************************
 
     C     SRForecast    BEGSR
 
     C     *LOVAL        SETLL     ASFHTRL0
 
     C                   DOU       %EOF(ASFHTRL0)
     C                   READ      ASFHTRL0
 
      ** Process Live Forecast Transactions details
 
 
     C                   IF        NOT %EOF(ASFHTRL0)
     C                   ADD       1             WCounter6
 
     C                   IF        FSRECI = '*' OR FSRECI = 'M'
     C                   IF        FSLCD <= WTarget
     C                   DELETE    ASFHTRD0
     C                   ADD       1             WCounter7
                                                                                              216358
      ** Update Trailer                                                                       216358
     C                   EVAL      KFLNM = 'ASFHTRPD'                                         216358
     C     KFLNM         CHAIN     SDFCTLL0                                                   216358
     C                   IF        %FOUND(SDFCTLL0)                                           216358
     C                   SUB       1             AHNODL                                       216358
     C                   SUB       1             AHNORC                                       216358
     C                   UPDATE    @AHREAU                                                    216358
     C                   ENDIF                                                                216358
                                                                                              216358
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      ****************************************************************
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
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSSDY
 
      ** Database error
 
     C     PRtCd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'AS000007'    DBPGM
     C                   EVAL      DBASE = 1
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CAS004
      ** Check if enhancement CAS004 is switched on.                                          CAS004
                                                                                              CAS004
     C                   CALLB     'AOSARDR0'                                                 CAS004
     C                   PARM      *BLANKS       PRtCd                                        CAS004
     C                   PARM      '*VERIFY'     POption                                      CAS004
     C                   PARM      'CAS004'      PSard                                        CAS004
     C     SCSARD        PARM      SCSARD        DSSDY                                        CAS004
                                                                                              CAS004
     C                   IF        PRtCd = *BLANKS                                            CAS004
     C                   EVAL      CAS004 = 'Y'                                               CAS004
                                                                                              CAS004
     C                   ELSE                                                                 CAS004
     C                   EVAL      CAS004 = 'N'                                               CAS004
                                                                                              CAS004
     C                   IF        PRtCd <> '*NRF   '                                         CAS004
     C     *LOCK         IN        LDA                                                        CAS004
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS004
     C                   EVAL      DBKEY = 'CAS004'                                           CAS004
     C                   EVAL      DBASE = 4                                                  CAS004
     C                   EVAL      DBPROC =  'SR/*INZSR'                                      CAS004
     C                   OUT       LDA                                                        CAS004
     C                   EXSR      *PSSR                                                      CAS004
     C                   ENDIF                                                                CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
      ** Call access program for General Ledger details.                                      CAS004
                                                                                              CAS004
     C**********         CALL      'AOGELRR0'                                          CAS004 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     PRtcd                                        CAS004
     C                   PARM      '*FIRST '     POption                                      CAS004
     C     SDGELR        PARM      SDGELR        DSSDY                                        CAS004
                                                                                              CAS004
      ** Database Error                                                                       CAS004
                                                                                              CAS004
     C     PRtcd         IFNE      *BLANK                                                     CAS004
     C                   EVAL      DBFILE = 'SDGELRPD'                                        CAS004
     C                   EVAL      DBASE = 5                                                  CAS004
     C                   EVAL      DBKEY = POption                                            CAS004
     C                   EXSR      *PSSR                                                      CAS004
     C                   ENDIF                                                                CAS004
 
     C                   EVAL      WRunDay = BJRDNB
 
      ** Initialise Counters
 
     C                   EVAL      WCounter1 = *ZEROS
     C                   EVAL      WCounter2 = *ZEROS
     C                   EVAL      WCounter3 = *ZEROS
     C                   EVAL      WCounter4 = *ZEROS
     C                   EVAL      WCounter5 = *ZEROS
     C                   EVAL      WCounter6 = *ZEROS
     C                   EVAL      WCounter7 = *ZEROS
     C                   EVAL      *IN26 = *OFF
 
      ** Write File Control Report Heading
 
     C                   WRITE     HEADER
 
      ** Access Hedging ICD File
 
     C                   EVAL      FSHEDG = 'HEDG'
 
     C     FSHEDG        CHAIN     SDHEDGL1
 
 B1  C                   IF        NOT %FOUND(SDHEDGL1)
     C     *LOCK         IN        LDA
     C                   MOVEL     'AS000007'    DBPGM
     C                   EVAL      DBFILE = 'SDHEDGL1'                          ************
     C                   EVAL      DBASE = 2                                    * DBERR 02 *
     C                   EVAL      DBKEY = FSHEDG                               ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
 E1  C                   ENDIF
 
      ** Multiply Hedging Retention Months by 31 to get Retention Days
 
     C     FSDROP        MULT      31            WRetention       15 0
 
      ** If WRetention is 0, set it to so today's records are not dropped
 
 B1  C                   IF        WRetention = 0
     C                   Z-ADD     1             WRetention
 E1  C                   ENDIF
                                                                                              CAS004
      ** Determine Event Control Date for checking if a record is to be dropped               CAS004
                                                                                              CAS004
     C                   IF        CAS004 = 'Y'                                               CAS004
     C                   EVAL      WEvCDat = BJDNWD - 1                                       CAS004
     C                   IF        BKAPDT < WEvCDat                                           CAS004
     C                   EVAL      WEvCDat = BKAPDT                                           CAS004
     C                   ENDIF                                                                CAS004
     C                   ENDIF                                                                CAS004
 
      ***Subtract*Retention*Days*from*Run*Day*Number*to*obtain*the**************              CAS004
      ***Target*Date************************************************************              CAS004
 
      ** Subtract Retention Days from Event Control Date Day Number to obtain the             CAS004
      ** Target Date                                                                          CAS004
                                                                                              CAS004
     C                   IF        CAS004 = 'Y'                                               CAS004
     C                   EVAL      WTarget = WEvCDat - WRetention                             CAS004
     C                   ELSE                                                                 CAS004
     C     WRunDay       SUB       WRetention    WTarget           5 0
     C                   ENDIF                                                                CAS004
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   WRITE     DBERROR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
