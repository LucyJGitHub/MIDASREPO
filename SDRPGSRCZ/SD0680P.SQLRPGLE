     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058085
/*STD *  RPGSQLBND                                                    *                     MD058085
/*EXI *  TEXT('Midas SD Function codes aud/req report')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                             *
      *                                                               *
      *  SD0680P -   RTS Function Codes Listing.                      *
      *                                                               *
      *  Function:  This program prints the records on the RTS        *
      *             Function Codes File.                              *
      *                                                               *
      *  Called By:-                                                  *
      *              FCC0202 Input Cycle On Request                   *
      *              FCC0204 COB On Request                           *
      *              SD0541X COB Audit                                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD061008           Date 31Dec21               *
      *  Prev Amend No. MD058085           Date 11May21               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 095626             Date 8NOv95                *
      *                 CRT001             Date 31Mar95               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061008 - Deliverable Data Split for SDFCTLPA and GPFCTLPA  *
      *  MD058085 - Deliverable Data Split for Standing Data          *
      *  MD046248 - Finastra Rebranding                               *
      *  095626 - RCF will not work as the spool file number was      *
      *           initialised before the spool file was opened.       *
      *  CRT001 - New program for Retail Teller System.               *
      *                                                               *
      *****************************************************************
      *
     F/COPY WNCPYSRC,SD0680PFPG
      *
     F*SDFNCDL1* IF   E           K DISK                                                    MD058085
      ** Function Codes by sort seq number
      *
     FSDBANKL1  IF   E           K DISK
      ** Bank Details              Retrieval index
      *
     F*SDFCTLL0* UF   E           K DISK                                                    MD061008
      ** Standing Data Controls    Update index
      *
     F*SDFCTLL1* IF   E           K DISK                                                    MD061008
      ** Standing Data Controls    Retrieval Index
      *
     FSD0680PM  O    E             PRINTER USROPN
     F                                     INFDS(INFDS$)
      * Function Codes Aud/Req Print file
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      * 70-72 - Governs Printing of Window Function Fields            *
      *    85 - Updat Lo Indicator - No Record Held For Update        *
      *    90 - Call Lo Indicator - Called Program Terminates In Error*
      *         Chain Hi Indicator - Record Not Found                 *
      *    99 - Lokup Indicator                                       *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  ZZINIT - Define Work Fields, gets Rundate, report titles and *
      *           checks for DB Error on SDBANKL1                     *
      *  WTRERR - DB Error handling routine. Calls SDC540P using parm *
      *           WUWFLG containing 'E' to indicate Error             *
      *  WRTDTL - Print Header and Details                            *
      *  SBCHRC - Retrieves Audit Details from SDFCTLL1 and checks    *
      *           for DB Errors whilst Chaining and Updating.         *
      *  WTRERR - Program database error routine                      *
      *  *PSSR  - Program exception error routine                     *
      *                                                               *
      *****************************************************************
     D/EJECT
     D UAR             S              1    DIM(53)                              Audit/Request Tit
     D ULN             S              1    DIM(53)                              Underline
     D UARRAY          S             26    DIM(2) CTDATA PERRCD(1)              Report Title
      *
     D/COPY WNCPYSRC,SD0680PEPG
      *
     D @CN             S             25    DIM(10) CTDATA PERRCD(1)             Long constants.
      *
     D/COPY WNCPYSRC,SD0680PIPG
      *
      /EJECT
      ** Data structures:-
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      ** Program data structure.
     D JBDTTM          DS
      ** Job date/time.
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
     D INFDS$        E DS                  EXTNAME(Y2I$DSP)
      ** Printer file information data structure.
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area holding Some Instalation Control Details.
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  DFF                   12     12
      /EJECT
      *
      ** Parameter declarations.
     D P1PARM          DS
      ** I:    Audit/Request Status Ind
     D  P1ARSI                 1      1
      *
     D P2PARM          DS
      ** I:    Sequence number
     D  P2RSQN                 1      5
      *
     D P3PARM          DS
      ** I:    Entity
     D  P3ENTY                 1      3
      *
     D                 DS
      *                                       1 132 ZAMSDA
      ** Message data for 'Database Error (ICD)'
      ** Filename
     D  ZA0001                 1     10
      *
      ** Local data area for database error details
      *
     D LDA           E DS                  EXTNAME(LDA)
      *
      ** Data structure to redefine override indicators
     D**FQVWIN*                1     25                                                     MD058085
     D  #QVWIN                 1     25                                                     MD058085
     D  #DBLDB                 1      1
     D  #DBLCR                 2      2
     D  #DRFDR                 3      3
     D  #DRFCR                 4      4
     D  #DINAC                 5      5
     D  #DBRLQ                 6      6
     D  #DBDDT                 7      7
     D  #DINFD                 8      8
     D  #DEXOD                 9      9
     D  #DMNBL                10     10
     D  #DSTCQ                11     11
     D  #DCQOR                12     12
     D  #DCQPR                13     13
     D  #DTLLM                14     14
     D  #DERAT                15     15
     D  #DBRDF                16     16
     D  #DACCL                17     17
     D  #DNWKD                18     18
     D  #DINBV                19     19
     D  #DNAGL                20     20
      *
     D SDFNCD        E DS                  EXTNAME(SDFNCJW0)                                MD058085
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      *****************************************************************
     C     *ENTRY        PLIST                                                  Entry parameter
     C                   PARM                    P0RTN             7            Return code
     C     P1ARSI        PARM                    WP0001            1            Audit/Request S
     C     P2RSQN        PARM                    WP0002            5            Sequence number
     C                   PARM                    @@PARM            1            Dummy Parm
     C     P3ENTY        PARM                    WP0003            3            Entity
      *****************************************************************
      ** Initialise
     C                   EXSR      ZZINIT
      *
      ** Establish starting position.
     C******LOVAL        SETLL     @FNCDL1                                                  MD058085
      *
      ** Read first record
     C**********         READ      @FNCDL1                                80                MD058085
     C/EXEC SQL                                                                             MD058085
     C+ declare ACursor insensitive scroll cursor for                                       MD058085
     C+ select * from SDFNCJW0                                                              MD058085
     C+ order by FQFNCD                                                                     MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
     C/EXEC SQL                                                                             MD058085
     C+ open ACursor                                                                        MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
     C/EXEC SQL                                                                             MD058085
     C+ fetch next from ACursor into :SDFNCD                                                MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
     C                   setoff                                       80                    MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   seton                                        80                    MD058085
     C                   Endif                                                              MD058085
                                                                                            MD058085
      *
     C/COPY WNCPYSRC,SD0680PRSP
      *
      ** Initialise no of Calculated Records
     C                   Z-ADD     *ZERO         ZTNCRC
      *
      * Print report body.
     C     *IN80         DOWEQ     '0'
      ** Print report detail line.
     C                   EXSR      WRTDTL
      *
      ** Read next record
     C**********         READ      @FNCDL1                                80                MD058085
     C/EXEC SQL                                                                             MD058085
     C+ fetch next from ACursor into :SDFNCD                                                MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
     C                   setoff                                       80                    MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   seton                                        80                    MD058085
     C                   Endif                                                              MD058085
                                                                                            MD058085
      *
     C/COPY WNCPYSRC,SD0680PRSP
      *
     C                   ENDDO
      *
      ** If Audit/Request Status Ind is Audit Mode (Parm = A)
      ** or if No Details to Report on SD0680PM
     C     P1ARSI        IFEQ      @CN(01)
     C     ZTNCRC        OREQ      *ZERO
      *
      ** Retrieve Audit Details from  Standing Data Controls
     C     KRSSA         KLIST
     C                   KFLD                    AHFLNM                         Filename
      ** Move fields to key list.
     C                   MOVEL     @CN(05)       AHFLNM                         Filename
     C*****KRSSA         CHAIN     @AHREAV                            90                    MD061008
     C                   CALL      'SD000119'                                               MD061008
     C                   PARM      '*RTV'        ZMODE             4                        MD061008
     C                   PARM                    AHFLNM           10                        MD061008
     C                   PARM      0             AHNORC            5 0                      MD061008
     C                   PARM      0             AHNOIN            5 0                      MD061008
     C                   PARM      0             AHNOAM            5 0                      MD061008
     C                   PARM      0             AHNODL            5 0                      MD061008
     C                   PARM      *BLANKS       ZRETRN           10                        MD061008
      *                                                                                     MD061008
     C                   SETOFF                                       90                    MD061008
     C     ZRETRN        IFNE      *BLANKS                                                  MD061008
     C                   SETON                                        90                    MD061008
     C                   ENDIF                                                              MD061008
      *                                                                                     MD061008
      *
      ** If SD control file record not found
     C     *IN90         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVEL     'SD0680P'     DBPGM
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     @CN(05)       DBKEY
     C                   Z-ADD     002           DBASE                          ***************
     C                   MOVEL     'SDFCTLL1'    DBFILE                         *  DBERR 002  *
     C                   OUT       LDA                                          ***************
      *
      ** Write header(s).
     C                   MOVE      WUMRDT        ##MRDT
     C                   MOVEL     'SD0680P'     ##PGM
      *
     C                   EXSR      WRTERR
     C                   EXSR      *PSSR
      *
      ** Else SD control file record found
     C                   ELSE
      *
      ** Load No. of Records On File, No Inserts, Amends & Deletes
     C                   Z-ADD     AHNORC        WUNORF
     C                   Z-ADD     AHNOIN        WUNOIN
     C                   Z-ADD     AHNOAM        WUNOAM
     C                   Z-ADD     AHNODL        WUNODL
     C                   ENDIF
      *
      ** Check whether Calculated of Records equal to No of Records on file
     C     WUWKNB        IFNE      WUNORF
     C                   MOVEL     @CN(02)       WUWFLG
     C                   ELSE
      ** Check whether Number of Records Printed is zero ( No details on AU)
     C     ZTNCRC        IFEQ      0
     C                   MOVE      'Z'           WUWFLG
     C                   ENDIF
     C                   ENDIF
      *
      ** Audit printfile override - Standing Data Controls
     C                   CALL      'SDC540P'                            90      Audit printfile
     C                   PARM      @CN(07)       WQ0009           10            *PROGRAM
     C                   PARM      WUWFLG        WQ0010            1            Work flag
     C                   PARM      WUNOIN        WQ0011            5 0          No of Records I
     C                   PARM      WUNOAM        WQ0012            5 0          No of Records A
     C                   PARM      WUNODL        WQ0013            5 0          No of records D
     C                   PARM      WUWKNB        WQ0014            5 0          work number
     C                   PARM      WUNORF        WQ0015            5 0          No of Records o
     C                   PARM      WUARTL        WQ0016           53            Audit/Request T
     C                   PARM      WUUNDL        WQ0017           53            Underline
      *
     C     *IN90         IFEQ      '1'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Work flag is Incorrect
     C     WUWFLG        IFEQ      @CN(02)
      *
      * File Control Error U8 - Standing Data Controls  *
     C                   MOVE      *ON           *INU8
      *
     C                   ELSE
      *
     C                   EXSR      SBCHRC
      *
     C                   ENDIF
     C                   ENDIF
      *
     C/COPY WNCPYSRC,SD0680PPER
      *
      ** Print Page Header, Final Totals & 'End of Report'
      ** if details to report on SD0680P
     C     FLAGP1        IFEQ      'Y'
     C                   WRITE     ZZFINTTL
     C                   WRITE     ZZENDRPT
     C                   ENDIF
      *
      ** Exit program & Return
     C                   MOVEL     *BLANK        P0RTN
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
      /EJECT
      *****************************************************************
      */TITLE SR/WRTDTL                                               *
      *****************************************************************
      *                                                               *
      *  WRTDTL - Print Header and Details                            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Pgm Calls: ZDATE2 - Check File Date                          *
      *             Y2RVCNR- Retrieve Alpha of Last Change            *
      *   SR Calls: *PSSR  - Program Exception Error Routine          *
      *                                                               *
      *****************************************************************
      *
     C     WRTDTL        BEGSR
      *
      ** Load detail line.
     C                   Z-ADD     FQLCD         XRLCD                          Last Change Dat
     C                   MOVE      FQTYLC        XRTYLC                         Type of Last Ch
     C                   MOVE      FQFNCD        XRFNCD                         Function Code
     C                   MOVEL     FQRNNR        XRRNNR                         FuncCode Narra
     C                   MOVE      FQDRC1        XRDRC1                         Debit Tran 1
     C                   MOVE      FQDRC2        XRDRC2                         Debit Tran 2
     C                   MOVE      FQCRC1        XRCRC1                         Credt Tran 1
     C                   MOVE      FQCRC2        XRCRC2                         Credt Tran 2
      *
     C                   eval      #QVWIN = FQVWIN                                          MD058085
     C                   MOVE      #DBLDB        XRBLDB                         Block Debit Ind
     C                   MOVE      #DBLCR        XRBLCR                         Block Credit In
     C                   MOVE      #DRFDR        XRRFDR                         Refer Debit Ind
     C                   MOVE      #DRFCR        XRRFCR                         Refer Credit
     C                   MOVE      #DINAC        XRINAC                         Inactive A/c
     C                   MOVE      #DBRLQ        XRBRLQ                         Bankrupt/Liq'n
     C                   MOVE      #DBDDT        XRBDDT                         Bad Debt
     C                   MOVE      #DINFD        XRINFD                         Insuff. Fund
     C                   MOVE      #DEXOD        XREXOD                         Exceeding OD
     C                   MOVE      #DMNBL        XRMNBL                         Min Balance
     C                   MOVE      #DSTCQ        XRSTCQ                         Stopped Cheque
     C                   MOVE      #DCQOR        XRCQOR                         Chq outof range
     C                   MOVE      #DCQPR        XRCQPR                         Chq Presented
     C                   MOVE      #DTLLM        XRTLLM                         Teller Limit
     C                   MOVE      #DERAT        XRERAT                         Exchange Rate
     C                   MOVE      #DBRDF        XRBRDF                         BranchDifferent
     C                   MOVE      #DACCL        XRACCL                         A/c Closing
     C                   MOVE      #DNWKD        XRNWKD                         Non-Working Day
     C                   MOVE      #DINBV        XRINBV                         Invalid BackVal
     C                   MOVE      #DNAGL        XRNAGL                         No Assoc GL cod
     C                   MOVEL     *BLANK        XRACDT                         Alpha change da
     C                   MOVEL     *BLANK        XRALCH                         Alpha of last c
     C                   MOVEL     *BLANK        XRWFFR                         Window Function
     C                   MOVEL     *BLANK        XRWF1R                         Window Function
     C                   MOVEL     *BLANK        XRWF2R                         Window Function
      *
      ** Set Print Record flag To 'Y'
     C                   MOVEL     'Y'           PRTFLG
      *
      ** Count Detail Records
     C                   ADD       1             WUWKNB                         Work number
      *
      ** If Audit/Request Status Ind is Audit Mode (Parm = 'A')
      ** AND Last Change Date *NE run day number
     C     WUARSI        IFEQ      @CN(01)
     C     XRLCD         ANDNE     WURDNB
      *
      ** Set print record flag  = 'N'
     C                   MOVEL     'N'           PRTFLG
     C                   ENDIF
      *
      ** If record is to be printed add 1 to No Of Calculated Records
     C     PRTFLG        IFEQ      'Y'
     C                   ADD       1             ZTNCRC
      *
      ** Set FLAGP1 Details Print File Flag (SD0680PM)
     C                   MOVEL     'Y'           FLAGP1
     C                   ENDIF
      *
      ** Check File Date - Rundate
     C                   CALL      'ZDATE2'                             90      Check File Date
     C                   PARM      XRLCD         WQ0005            5 0          Work Midas Date
     C                   PARM      WUDFF         WQ0006            1            date format fla
     C     WUWCDT        PARM      *ZERO         WQ0007            6 0          Work Converted
     C     XRACDT        PARM      *BLANK        WQ0008            7            Work Alpha Date
      *
     C     *IN90         IFEQ      '1'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** PAR.alpha of last change = Condition name of PAR.Type of Last Change
     C                   CALL      'Y2RVCNR'                            90
     C                   PARM                    W0RTN             7            Return code
     C                   PARM      1100584       Y2LSNO            7 0          List number
     C                   PARM      XRTYLC        W0INVL           20            Type of Last Ch
     C                   PARM      ' '           W0VLMP            1            Value mapped?
     C     XRALCH        PARM                    W0CNNM           25            Alpha of last c
      *
     C     *IN90         IFEQ      '1'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C/COPY WNCPYSRC,SD0680PPDR
      *
     C     PRTFLG        IFEQ      'Y'
      *
      ** Convert fields to external form.
     C                   MOVEL     '0'           *IN72
     C     XRWFFR        IFEQ      *BLANK
     C                   MOVEL     '1'           *IN72
     C                   ENDIF
      *
     C                   MOVEL     '0'           *IN71
     C     XRWF1R        IFEQ      *BLANK
     C                   MOVEL     '1'           *IN71
     C                   ENDIF
      *
     C                   MOVEL     '0'           *IN70
     C     XRWF2R        IFEQ      *BLANK
     C                   MOVEL     '1'           *IN70
     C                   ENDIF
      *
      * For First Record that is to be written to the details printer file.
     C     FLAGP1        IFEQ      'Y'
     C     ZTNCRC        ANDEQ     1
     C                   OPEN      SD0680PM
      *
      ** ZSFILE - write report rqs - Standard functions *
      *
     C                   Z-ADD     @$FNB         WUSFNB            6 0                         09562
      *                                                                   095626
     C                   CALL      'ZSFILE'                             90
     C                   PARM      P2RSQN        UURSQN            5            RCF seq no.
     C                   PARM      P3ENTY        UUENTY            3            Entity
     C                   PARM      @$FVN         UUSFNM           10            Spool file name
     C                   PARM      WUSFNB        UUSFNB            6 0          Spool file no.
     C     WUZSER        PARM      *BLANK        UUZSER            1            ZSFILE error
      *
      ** Call to program ended in error
     C     *IN90         IFEQ      '1'
     C     WUZSER        OREQ      'Y'
      *
     C                   EXSR      *PSSR
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Print page header.
     C                   WRITE     ZZPAGHDR
      *
      ** Print detail.
     C                   WRITE     ZZDTLRCD
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      */TITLE SR/SBCHRC                                               *
      *****************************************************************
      *                                                               *
      *  SBCHRC - Retrieves Audit Details from SDFCTLL1 and checks    *
      *           for DB Errors whilst Chaining and Updating.         *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Pgm Calls: None                                              *
      *   SR Calls: *PSSR  - Program Exception Error Routine          *
      *             WRTERR - Program Database Error Routine           *
      *                                                               *
      *****************************************************************
      *
     C     SBCHRC        BEGSR
      *
      ** If Audit/Request Status Ind is Audit Mode
     C     WUARSI        IFEQ      @CN(01)
      * Define Keylist.
     C     KLCHSB        KLIST
     C                   KFLD                    AHFLNM                         Filename
      ** Move fields to key list.
     C                   MOVEL     @CN(05)       AHFLNM                         Filename
      ** Check that a record for SDFNCDPD exists on the standing data
      ** controls file.
     C*****KLCHSB        CHAIN     @AHREAU                            90                    MD061008
     C                   CALL      'SD000119'                                               MD061008
     C                   PARM      '*RTV'        ZMODE                                      MD061008
     C                   PARM                    AHFLNM                                     MD061008
     C                   PARM      0             AHNORC                                     MD061008
     C                   PARM      0             AHNOIN                                     MD061008
     C                   PARM      0             AHNOAM                                     MD061008
     C                   PARM      0             AHNODL                                     MD061008
     C                   PARM      *BLANKS       ZRETRN                                     MD061008
      *                                                                                     MD061008
     C                   SETOFF                                       90                    MD061008
     C     ZRETRN        IFNE      *BLANKS                                                  MD061008
     C                   SETON                                        90                    MD061008
     C                   ENDIF                                                              MD061008
      *                                                                                     MD061008
      *
     C     *IN90         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVEL     'SD0680P'     DBPGM
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     @CN(05)       DBKEY
     C                   Z-ADD     003           DBASE                          ***************
     C                   MOVEL     'SDFCTLL1'    DBFILE                         *  DBERR 003  *
     C                   OUT       LDA                                          ***************
      *
      ** Write header(s).
      *
     C                   MOVE      WUMRDT        ##MRDT
     C                   MOVEL     'SD0680P'     ##PGM
      *
     C                   EXSR      WRTERR
     C                   EXSR      *PSSR
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Processing after DBF read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      *
      ** If Audit/Request Status Ind is Audit Mode (Parm = A)
     C     P1ARSI        IFEQ      @CN(01)
      *
      ** Move Non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     *ZERO         AHNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         AHNOAM                         No. of Amends
     C                   Z-ADD     *ZERO         AHNODL                         No. of Deletes
      *
     C**********         UPDATE    @AHREAU                              85                  MD061008
     C                   CALL      'SD000119'                                               MD061008
     C                   PARM      '*UPD'        ZMODE                                      MD061008
     C                   PARM                    AHFLNM                                     MD061008
     C                   PARM                    AHNORC                                     MD061008
     C                   PARM                    AHNOIN                                     MD061008
     C                   PARM                    AHNOAM                                     MD061008
     C                   PARM                    AHNODL                                     MD061008
     C                   PARM      *BLANKS       ZRETRN                                     MD061008
                                                                                            MD061008
     C                   SETOFF                                       85                    MD061008
     C     ZRETRN        IFNE      *BLANKS                                                  MD061008
     C                   SETON                                        85                    MD061008
     C                   ENDIF                                                              MD061008
                                                                                            MD061008
      *
      ** If SD control file record update not successful
     C     *IN85         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVEL     'SD0680P'     DBPGM
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     @CN(05)       DBKEY
     C                   Z-ADD     004           DBASE                          ***************
     C                   MOVEL     'SDFCTLL0'    DBFILE                         *  DBERR 004  *
     C                   OUT       LDA                                          ***************
      *
      ** Write header(s).
      *
     C                   MOVE      WUMRDT        ##MRDT
     C                   MOVEL     'SD0680P'     ##PGM
      *
     C                   EXSR      WRTERR
     C                   EXSR      *PSSR
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      */TITLE SR/ZZINIT                                               *
      *****************************************************************
      *                                                               *
      *  ZZINIT - Define Work Fields. Gets Rundate, report titles and *
      *           Bank details (checks for DB Error).                 *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Pgm Calls: ZSFILE - Spool File Numbers File                  *
      *   SR Calls: *PSSR  - Program Exception Error Routine          *
      *             WRTERR - Program Database Error Routine           *
      *                                                               *
      *****************************************************************
      *
     C     ZZINIT        BEGSR
      *
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
      ** Setup job date/time.
     C                   Z-ADD     UDATE         ##JDT                          Job date.
     C                   TIME                    ##JTM                          Job time.
     C                   TIME                    ##TME             6 0          Screen time.
      ** Define Audit/Request Status Ind
     C                   MOVEL     *BLANK        WUARSI            1
      ** Move Audit/Request Status Ind to Work Field
     C                   MOVEL     P1ARSI        WUARSI                         Audit/Request S
      ** Define work number
     C                   Z-ADD     *ZERO         WUWKNB            5 0
      ** Define run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      ** Define date format flag
     C                   MOVEL     *BLANK        WUDFF             1
      ** Define Work Converted Date
     C                   Z-ADD     *ZERO         WUWCDT            6 0
      ** Define No of Records on file
     C                   Z-ADD     *ZERO         WUNORF            5 0
      ** Define No. of Inserts
     C                   Z-ADD     *ZERO         WUNOIN            5 0
      ** Define No. of Amends
     C                   Z-ADD     *ZERO         WUNOAM            5 0
      ** Define No. of Deletes
     C                   Z-ADD     *ZERO         WUNODL            5 0
      ** Define Field Work Flag
     C                   MOVEL     *BLANK        WUWFLG            1
      ** Define Audit/Request Title
     C                   MOVEL     *BLANK        WUARTL           53
      ** Define Underline
     C                   MOVEL     *BLANK        WUUNDL           53
      ** Define No. of Records
     C                   Z-ADD     *ZERO         WUNORC            5 0
      ** Define Midas Rundate
     C                   MOVEL     *BLANK        WUMRDT            7
      ** Define ZSFILE error
     C                   MOVEL     *BLANK        WUZSER            1
      ** Define PRTFLG Print Record Flag
     C                   MOVEL     *BLANK        PRTFLG            1
      ** Define FLAGP1 Details Print File Flag (SD0680PM)
     C                   MOVEL     'N'           FLAGP1            1
      *
      ** Obtain default message file
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
      *
      ** Define SD Local Data Area
     C     *DTAARA       DEFINE                  LDA
      *
      ** Obtain Midas Rundate
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB
     C                   MOVE      DFF           WUDFF
      *
      ** Calculate End of Text Point
     C                   Z-ADD     1             U                 2 0
     C                   MOVEA     @CN(10)       UAR(U)
      *
     C     *IN99         DOWEQ     '0'
     C     ' '           LOOKUP    UAR(U)                                 99
     C                   ADD       1             U
     C     UAR(U)        COMP      ' '                                    99
     C                   ENDDO
      *
     C     P1ARSI        IFEQ      'A'
     C                   MOVEL     UARRAY(1)     UTEMP            26
     C                   MOVEA     UTEMP         UAR(U)
     C                   ADD       26            U
     C                   ELSE
      *
     C                   MOVEA     UARRAY(2)     UAR(U)                         * IF A THIRD
     C                   ADD       7             U                              OPTION TO ARRAY
     C                   ENDIF                                                  IS ADDED A
      *                                                    TEMP STORAGE
      *                                                    * IS REQUIRED.
      **  Store Text in USTORE Field
      *
     C                   MOVEA     UAR           USTORE           53
     C                   MOVE      *BLANKS       UAR
      *
     C     53            SUB       U             UB                2 0
     C     UB            DIV       2             UB
     C                   MVR                     UR                1 0
     C     UB            ADD       U             U
     C     U             SUB       1             U
      *
      **  Insert Underline to Array
      **
     C                   MOVEA     *ALL'-'       ULN(UB)
     C                   MOVEA     *BLANKS       ULN(U)
      *
     C     UB            IFGT      0
     C                   MOVEA     USTORE        UAR(UB)
     C                   ELSE
     C                   MOVEA     USTORE        UAR
     C                   ENDIF
      *
      **  Move Array VAlue To Printfile Text Field
      *
     C                   MOVEA     UAR           ##ARTL           53
     C                   MOVEA     UAR           WUARTL
     C                   MOVEA     ULN           ##UNDL           53
     C                   MOVEA     ULN           WUUNDL
      *
      ** Get Bank Title - Bank Details
     C     KRSSC         KLIST
     C                   KFLD                    BJBANK                         Bank
      *
     C                   MOVEL     @CN(09)       BJBANK                         Bank
      *
     C     KRSSC         CHAIN     @BJREEF                            90
      *
      ** Chain To SDBANKPD Unsuccesful
     C     *IN90         IFEQ      '1'
      *
     C     *LOCK         IN        LDA
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVEL     'SD0680P'     DBPGM
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     @CN(09)       DBKEY
     C                   Z-ADD     001           DBASE                          ***************
     C                   MOVEL     'SDBANKPD'    DBFILE                         *  DBERR 001  *
     C                   OUT       LDA                                          ***************
      *
      ** Write header(s).
     C                   MOVE      WUMRDT        ##MRDT
     C                   MOVEL     'SD0680P'     ##PGM
      *
     C                   EXSR      WRTERR
     C                   EXSR      *PSSR
      *
      ** Chain To SDBANKPD Succesful
     C                   ELSE
      *
      ** Load User Report Title
     C                   MOVEL     BJURPT        ##URPT                         User Report Tit
     C                   ENDIF
      *
      ** Set up spool file number - Standard functions *
      *
     C***********          Z-ADD@$FNB     WUSFNB  60                      095626
      *
     C/COPY WNCPYSRC,SD0680PCPG
      *
     C     ZZEXIT        ENDSR
      *
      *****************************************************************
     C/TITLE SR/WTRERR
      *****************************************************************
      *                                                               *
      * WTRERR - Program database error routine.                      *
      *                                                               *
      * Called by: Main Processing, SBCHRC and ZZINIT.                *
      *                                                               *
      *  Pgm Calls:*SDC540P- Audit Print File Override                *
      *   SR Calls: *PSSR  - Program Exception Error Routine          *
      *                                                               *
      *****************************************************************
      *
     C     WRTERR        BEGSR
      *
      ** Audit printfile override - Standing Data Controls
     C                   CALL      'SDC540P'                            90      Audit printfile
     C                   PARM      @CN(07)       WQ0009           10            *PROGRAM
     C                   PARM      'E'           WQ0010            1            Error Flag
     C                   PARM      *ZERO         WQ0011            5 0          Dummy Parm.
     C                   PARM      *ZERO         WQ0012            5 0          Dummy Parm.
     C                   PARM      *ZERO         WQ0013            5 0          Dummy Parm.
     C                   PARM      *ZERO         WQ0014            5 0          Dummy Parm.
     C                   PARM      *ZERO         WQ0015            5 0          Dummy Parm.
     C                   PARM      WUARTL        WQ0016           53            Audit/Request T
     C                   PARM      WUUNDL        WQ0017           53            Underline
      *
     C     *IN90         IFEQ      '1'
      ** Call to program ended in error.
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: Main Processing, WRTDTL, SBCHRC and ZZINIT.        *
      *                                                               *
      *  Pgm Calls: None                                              *
      *   SR Calls: None                                              *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   ENDIF
      *
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
     O*
     O/COPY WNCPYSRC,SD0680POPG
     O*
**   Array Entries For Report Title
MAINTENANCE - AUDIT REPORT
LISTING
** @CN Long constants used in program.
A
N
Y
0
SDFNCDPD
Y2U0005
SD0680AU
Y2U0021
BANK
FUNCTION CODES
