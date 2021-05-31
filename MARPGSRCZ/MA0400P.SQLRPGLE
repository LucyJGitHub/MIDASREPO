     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055265
/*STD *  RPGSQLBND                                                    *                     MD055265
/*EXI *  TEXT('Midas MA Report archive contents')
     F*****************************************************************
     F*                                                               *
     F*  Midas - Microfiche/Optical Disk Archiving Module
     F*                                                               *
     F*  MA0400P - REPORT ARCHIVE CONTENTS                            *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD055265           Date 10Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 LN1093             Date 10Jan91               *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  MD055265 - Deliverable Data Split for Report Control Facility*
      *  MD046248 - Finastra Rebranding                               *
     F*      LN1093 - PRINT BANK TITLE, DESCRIPTIONS OF REPORT AND    *
     F*               PRINT SUFFIX                                    *
     F*                                                               *
     F*****************************************************************
      *  C R E A T I O N     P A R A M E T E R S                      *
      *                                                               *
      *                                                               *
      *****************************************************************
     F*Permanent Archives       Initialise Program F-Spec
     F/COPY WNCPYSRC,MA0400PFPG
     FMAARCDL1  IF   E           K DISK
      * RTV: Archive Contents(daily)   Retrieval index
      *
     F*FCREPTL1* IF   E           K DISK                                         LN1093     MD055265
      * RTV: Report Descriptions       Retrieval index                    LN1093
      *                                                                   LN1093
     F*FCRSFXL1* IF   E           K DISK                                         LN1093     MD055265
      * RTV: Report Suffixes           Retrieval index                    LN1093
      *                                                                   LN1093
     FMA0400PM  O    E             PRINTER OFLIND(*IN97)
     F                                     INFDS(INFDS$)
      * PRT: Report Archive Contents   Print file
      *
     FMA0400AU  O    E             PRINTER INFDS(SPOOLU)                        LN1093
     F                                     USROPN
      * PRT: Archive Contents Audit    Print file                         LN1093
     F*                                                                   LN1093
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*Permanent Archives       Initialise Program E-Spec
     D/COPY WNCPYSRC,MA0400PEPG
     D @CN             S             25    DIM(3) CTDATA PERRCD(1)              Long constants.
     D*Permanent Archives       Initialise Program I-Spec
     D/COPY WNCPYSRC,MA0400PIPG
      /EJECT
      * Data structures:-
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      * Program data structure.
     D JBDTTM          DS
      * Job date/time.
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
     D INFDS$        E DS                  EXTNAME(Y2I$DSP)
      * Printer file information data structure.
     D FCREPT        E DS                  EXTNAME(FCREPJW0)                                MD055265
     D FCRSFX        E DS                  EXTNAME(FCRSFJW0)                                MD055265
      *                                                                   LN1093
     D SPOOLU          DS                                                       LN1093
     D*                                                                   LN1093
     D** SPOOL INFORMATION DATA STRUCTURE FOR ZSFILE - AU REPORT          LN1093
     D*                                                                   LN1093
     D  SFILEU                83     92                                         LN1093
     D  SFNUMU               123    124B 0                                      LN1093
     D*                                                                   LN1093
     D RSFXDS          DS
     D  EBRNAM                 1     10
     D  EBRSFX                11     20
     D*
     D UUFDY         E DS                  EXTNAME(DSFDY)                       LN1093
     D*                                                                   LN1093
     D* 200 BYTE DATA STRUCTURE FOR INCOMING DATA ROM ACCESS PGM          LN1093
     D*                                                                   LN1093
     D D@BANK        E DS                  EXTNAME(SDBANKPD)                    LN1093
     D*                                                                   LN1093
     D* BANK DETAILS DATA STRUCTURE FOR ASSIGNING DATA FROM ACCESS PGM    LN1093
      *                                                                   LN1093
     D LDA             DS           256                                         LN1093
     D*                                                                   LN1093
     D** LOCAL DATA AREA FOR DATABASE ERROR REPORTING                     LN1093
     D*                                                                   LN1093
     D  DBFILE               134    141                                         LN1093
     D  DBKEY                142    170                                         LN1093
     D  DBPGM                171    180                                         LN1093
     D  DBASE                181    183  0                                      LN1093
     D RUNDAT          DS
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  MBIN                  13     13
      /EJECT
      * Parameter declarations.
     D P1PARM          DS
      * I:    Sequence Number
     D  P1RQSQ                 1      5
     D P2PARM          DS
      * I:    Level
     D  P2LVL                  1      1
     D P3PARM          DS
      * I:    Entity
     D  P3ETTY                 1      3
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST                                                  Entry parameter
     C                   PARM                    P0RTN             7            Return code
     C     P1RQSQ        PARM                    WP0001            5            Sequence Number
     C     P2LVL         PARM                    WP0002            1            Level
     C     P3ETTY        PARM                    WP0003            3            Entity
      *****************************************************************
      * Initialise
     C                   EXSR      ZZINIT
      *
      * Clear overflow indicator.
     C                   SETOFF                                       97
      * Establish starting position.
     C     *LOVAL        SETLL     @EBREJR                                      *
      * Read first record with user selection.
     C                   EXSR      GARDRC
      * Print null report headings.
     C     W0EOF         IFEQ      '1'
     C                   WRITE     $PAGHDR
      * USER: Null report processing
      * 00/Copy member XX0400PNRP - Archive Contents(daily)  *
     C*Permanent Archives       Null Report Processing
     C/COPY WNCPYSRC,MA0400PNRP
     C                   WRITE     $ENDRPT
     C                   ELSE
      * Request all headings.
     C                   MOVEL     'Y'           L0                1            Page headings
     C                   MOVEL     'Y'           L1                1            Archive ID
     C                   MOVEL     'Y'           L2                1            Sequence Number
     C                   MOVEL     'Y'           L3                1            Report name
      * Initialise final totals.
      * Print report body.
     C     W0EOF         DOWEQ     '0'
      * Print headings.
     C                   EXSR      BAPRHD
      * Print report detail line.
     C                   EXSR      CAPRDT
      * Hold current values.
     C     *LIKE         DEFINE    EBARID        WZARID                         Archive ID
     C                   MOVEL     EBARID        WZARID
     C     *LIKE         DEFINE    EBRQSQ        WZRQSQ                         Sequence Number
     C                   MOVEL     EBRQSQ        WZRQSQ
     C     *LIKE         DEFINE    EBRNAM        WZRNAM                         Report name
     C                   MOVEL     EBRNAM        WZRNAM
      * Read next record with user selection.
     C                   EXSR      GARDRC
      * Determine level changes.
     C                   EXSR      DALVCH
      * Print totals.
     C                   EXSR      EAPRTT
      * Process necessary heading requests
     C                   EXSR      FASGHD
     C                   END
     C                   WRITE     $ENDRPT
     C                   END
      * Exit program.
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *****************************************************************
      /EJECT
     CSR   BAPRHD        BEGSR
      *================================================================
      * Print report Headers.
      *================================================================
      * Clear column headings control flag.
     C                   MOVEL     *BLANK        BAPR              1
      *
     C     L0            IFEQ      'Y'
     C                   WRITE     $PAGHDR
     C                   MOVEL     'Y'           BAPR
     C                   END
      *
     C     L1            IFEQ      'Y'
      * Load format.
     C                   MOVEL     EBARID        $1ARID                         Archive ID
     C                   END
      *
     C     L1            IFNE      *BLANK
     C                   MOVEL     'Y'           W0PFM
      * User: Process Archive ID headings.
      * 00/Copy member XX0400PLH0 - Archive Contents(daily)  *
     C*Permanent Archives       Print Level Heading 0
     C/COPY WNCPYSRC,MA0400PLH0
     C     W0PFM         IFEQ      'Y'
      * Print format.
     C                   WRITE     $1KEYHDR
     C                   MOVEL     'Y'           BAPR
     C                   END
     C                   END
      *
     C     L2            IFEQ      'Y'
      * Load format.
     C                   MOVEL     EBARID        $2ARID                         Archive ID
     C                   MOVEL     EBRQSQ        $2RQSQ                         Sequence Number
     C                   END
      *
     C     L2            IFNE      *BLANK
     C                   MOVEL     'Y'           W0PFM
      * User: Process Sequence Number headings.
      * 00/Copy member XX0400PLH2 - Archive Contents(daily)  *
     C*Permanent Archives       Print Level Heading 2
     C/COPY WNCPYSRC,MA0400PLH2
     C     W0PFM         IFEQ      'Y'
      * Print format.
     C                   WRITE     $2KEYHDR
     C                   MOVEL     'Y'           BAPR
     C                   END
     C                   END
      *
     C     L3            IFEQ      'Y'
      * Load format.
     C                   MOVEL     EBARID        $3ARID                         Archive ID
     C                   MOVEL     EBRQSQ        $3RQSQ                         Sequence Number
     C                   MOVEL     EBRNAM        $3RNAM                         Report name
     C* chain to FCREPTL1 for report description                          LN1093
     C*****EBRNAM        CHAIN     @DXREIK                            90              LN109 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ SELECT *                                                                            MD055265
     C+ into :FCREPT                                                                        MD055265
     C+ from FCREPJW0                                                                       MD055265
     C+ where DXRNAM = :$3RNAM                                                              MD055265
     C/END-EXEC                                                                             MD055265
     C                   SETOFF                                       90                    MD055265
     C                   IF        SQLCODE = 100                                            MD055265
     C                   SETON                                        90                    MD055265
     C                   ENDIF                                                              MD055265
     C*                                                                   LN1093
      ** database error if not found                                      LN1093
     C*                                                                   LN1093
     C     *IN90         IFEQ      '1'                                                         LN109
     C     *LOCK         IN        LDA                                                         LN109
     C                   MOVEL     EBRNAM        DBKEY                                         LN109
     C                   MOVEL     'FCREPTL1'    DBFILE                         ***************LN109
     C                   Z-ADD     1             DBASE                          * DB ERROR 001*LN109
     C                   MOVEL     'MA0400P'     DBPGM                          ***************LN109
     C                   OUT       LDA                                                         LN109
     C                   EXSR      ZWDBER                                                      LN109
     C                   END                                                                   LN109
     C*                                                                   LN1093
     C* move report description to print line                             LN1093
     C                   MOVEL     DXRDSC        $3RDSC                                        LN109
     C                   END
      *
     C     L3            IFNE      *BLANK
     C                   MOVEL     'Y'           W0PFM
      * User: Process Report name headings.
      * 00/Copy member XX0400PLH1 - Archive Contents(daily)  *
     C*Permanent Archives       Print Level Heading 1
     C/COPY WNCPYSRC,MA0400PLH1
     C     W0PFM         IFEQ      'Y'
      * Print format.
     C                   WRITE     $3KEYHDR
     C                   MOVEL     'Y'           BAPR
     C                   END
     C                   END
      *
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT
     CSR   CAPRDT        BEGSR
      *================================================================
      * Print report detail line.
      *================================================================
      * Load detail line.
     C                   MOVEL     EBARID        $RARID                         Archive ID
     C                   MOVEL     EBRNAM        $RRNAM                         Report name
     C                   MOVEL     EBRQSQ        $RRQSQ                         Sequence Number
     C                   MOVEL     EBRSFX        $RRSFX                         Print File Name
     C                   MOVEL     EBCFLG        $RCFLG                         Collation Flag
     C                   MOVEL     EBACFL        $RACFL                         archive flag
     C                   MOVEL     'Y'           W0PFM
     C* chain to FCRSFXL1 for Print File Suffix description               LN1093
     C*                                                                   LN1093
     C*****RSFXKY        CHAIN     @DYREIO                            90               LN109MD055265
     C/EXEC SQL                                                                             MD055265
     C+ SELECT *                                                                            MD055265
     C+ into :FCRSFX                                                                        MD055265
     C+ from FCRSFJW0                                                                       MD055265
     C+ where DYRNAM = :EBRNAM and DYRSFX = :EBRSFX                                         MD055265
     C/END-EXEC                                                                             MD055265
     C*                                                                   LN1093
      ** database error if not found                                      LN1093
     C*                                                                   LN1093
     C******IN90         IFEQ      '1'                                                LN109 MD055265
     C                   IF        SQLCODE = 100                                            MD055265
     C     *LOCK         IN        LDA                                                         LN109
     C                   MOVEL     RSFXDS        DBKEY                                         LN109
     C                   MOVEL     'FCRSFXL1'    DBFILE                         ***************LN109
     C                   Z-ADD     2             DBASE                          * DB ERROR 002*LN109
     C                   MOVEL     'MA0400P'     DBPGM                          ***************LN109
     C                   OUT       LDA                                                         LN109
     C                   EXSR      ZWDBER                                                      LN109
     C                   END                                                                   LN109
     C*                                                                   LN1093
     C* move suffix description to print line                             LN1093
     C                   MOVEL     DYPFTX        $RPFTX                                        LN109
     C*                                                                   LN1093
      * USER: Process detail record
      * 00/Copy member XX0400PPDR - Archive Contents(daily)  *
     C*Permanent Archives       Process Detail Record
     C/COPY WNCPYSRC,MA0400PPDR
     C     W0PFM         IFEQ      'Y'
      * Print column headings if required.
     C     BAPR          IFEQ      'Y'
     C                   WRITE     $COLHDG
     C                   MOVEL     *BLANK        BAPR
     C                   END
      * Convert fields to external form.
      * Print detail line.
     C                   WRITE     $DTLRCD
     C                   END
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   DALVCH        BEGSR
      *================================================================
      * Detect level changes.
      *================================================================
      * Clear all level breaks.
     C                   MOVEL     *BLANK        L0                             Page headings
     C                   MOVEL     *BLANK        L1                             Archive ID
     C                   MOVEL     *BLANK        L2                             Sequence Number
     C                   MOVEL     *BLANK        L3                             Report name
      * Clear heading length to print.
     C                   Z-ADD     *ZERO         @$HDL
      *
      * End of file - Signal all level breaks.
     C     W0EOF         IFEQ      '1'
     C                   MOVEL     'Y'           L1
     C                   MOVEL     'Y'           L2
     C                   MOVEL     'Y'           L3
     C                   ELSE
     C     EBARID        IFNE      WZARID                                       Archive ID
      * Set on level break indicator.
     C                   MOVEL     'Y'           L1
     C                   ADD       2             @$HDL
     C                   END
     C     EBRQSQ        IFNE      WZRQSQ                                       Sequence Number
     C     L1            OREQ      'Y'
      * Set on level break indicator.
     C                   MOVEL     'Y'           L2
     C                   ADD       2             @$HDL
     C                   END
     C     EBRNAM        IFNE      WZRNAM                                       Report name
     C     L2            OREQ      'Y'
      * Set on level break indicator.
     C                   MOVEL     'Y'           L3
     C                   ADD       2             @$HDL
     C                   END
      * Adjust for column headings.
     C     @$HDL         IFGT      *ZERO
     C                   ADD       4             @$HDL
     C                   END
      *
     C                   END
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   EAPRTT        BEGSR
      *================================================================
      * Print report Totals.
      *================================================================
      * Print level break totals as required
     C     L3            IFEQ      'Y'
      * User: Process Report name totals.
      * 00/Copy member XX0400PLT1 - Archive Contents(daily)  *
     C*Permanent Archives       Print Level Total 1
     C/COPY WNCPYSRC,MA0400PLT1
     C                   END
      *
     C     L2            IFEQ      'Y'
      * User: Process Sequence Number totals.
      * 00/Copy member XX0400PLT0 - Archive Contents(daily)  *
     C*Permanent Archives       Print Level Total 0
     C/COPY WNCPYSRC,MA0400PLT0
     C                   END
      *
     C     L1            IFEQ      'Y'
      * User: Process Archive ID totals.
      * 00?Copy member XX0400PLT2 - Archive Contents(daily)  *
     C*Permanent Archives       Print Level Total 2
     C/COPY WNCPYSRC,MA0400PLT2
     C                   END
      *
      * End of file - Print final totals.
     C     W0EOF         IFEQ      '1'
      * USER: Process End of Report
      * 00/Copy member XX0400PPER - Archive Contents(daily)  *
     C*Permanent Archives       Process End Of Report
     C/COPY WNCPYSRC,MA0400PPER
     C                   END
      *
      *================================================================
     CSR   EAEXIT        ENDSR
      /EJECT
     CSR   FASGHD        BEGSR
      *================================================================
      * Signal required header formats.
      *================================================================
      * Cascade skip to new page requests upwards.
     C     L1            IFNE      *BLANK
      * Request page headings.
     C                   MOVEL     'Y'           L0
     C                   END
      *
     C     *IN97         IFNE      '1'
     C     L0            ANDNE     'Y'
      * Signal overflow if requested headings would cause
      * detail format to start past the overflow line.
     C     W0OFL         SUB       @$CLN         @$WRK
     C     @$WRK         IFLE      @$HDL
     C                   SETON                                        97
     C                   ELSE
      * Signal overflow if requested headings would cause
      * detail format to be printed past end of page
     C                   ADD       1             @$HDL
     C     W0PGL         SUB       @$CLN         @$WRK
     C     @$WRK         IFLE      @$HDL
     C                   SETON                                        97
     C                   END
     C                   END
     C                   END
      * Overflow detected.
     C     *IN97         IFEQ      '1'
      * Request page headings.
     C                   MOVEL     'Y'           L0
      * Request all formats which print on overflow.
     C                   SETOFF                                       97
     C                   END
      *================================================================
     CSR   FAEXIT        ENDSR
      /EJECT
     CSR   GARDRC        BEGSR
      *================================================================
      * Read next record with user selection.
      *================================================================
     C     W0RSL         DOUEQ     'Y'
     C                   READ      @EBREJR                                90    *
     C                   MOVEL     *IN90         W0EOF             1
      * Quit if no record read.
     C     W0EOF         CABEQ     '1'           GAEXIT
      * Select record unless user action states otherwise.
     C                   MOVEL     'Y'           W0RSL             1
      * USER: Record selection processing
      * 00/Copy member XX0400PRSP - Archive Contents(daily)  *
     C*Permanent Archives       Record Selection Proc.
     C/COPY WNCPYSRC,MA0400PRSP
     C                   END
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT                                                              LN1093
     CSR   ZWDBER        BEGSR                                                                 LN109
      *================================================================   LN1093
      * Database Error - Print Audit Report and Exit                      LN1093
      *================================================================   LN1093
     C                   OPEN      MA0400AU                                                    LN109
     C                   Z-ADD     SFNUMU        SFNUM1            6 0                         LN109
     C                   CALL      'ZSFILE'                                                    LN109
     C                   PARM                    P1RQSQ                                        LN109
     C                   PARM                    P3ETTY                                        LN109
     C                   PARM                    SFILEU                                        LN109
     C                   PARM      SFNUM1        ZSFNO             6 0                         LN109
     C                   PARM                    PERR              1                           LN109
     C                   WRITE     DBERR                                                       LN109
     C                   SETON                                        U7U8                     LN109
     C                   EXSR      ZXEXPG                                                      LN109
      *================================================================   LN1093
     CSR   ZWEXIT        ENDSR                                                                 LN109
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Exit program
      *================================================================
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct.
      *================================================================
      * Terminate program.
     C                   SETON                                        LR
      *
      * Exit program.
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      /EJECT
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation.
      *================================================================
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
      * Setup job date/time.
     C                   Z-ADD     UDATE         ##JDT                          Job date.
     C                   TIME                    ##JTM                          Job time.
     C                   TIME                    ##TME             6 0          Screen time.
     C* define LDA                                                        LN1093
     C     *DTAARA       DEFINE                  LDA                                           LN109
      * Define work field run day number
     C                   Z-ADD     *ZERO         WURUND            5 0
      * Define work field midas rundate
     C                   MOVEL     *BLANK        WURUNA            7
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSSF             1
      * Define work field date format flag
     C                   MOVEL     *BLANK        WUDATF            1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
      * Define work field Spool File No.(numeric)
     C                   Z-ADD     *ZERO         WUAWNB            6 0
      * Define work field ZSFILE error
     C                   MOVEL     *BLANK        WUAXST            1
     C                   MOVEL     *BLANK        W0PFM             1
     C                   Z-ADD     *ZERO         @$WRK             4 0
     C                   Z-ADD     *ZERO         @$HDL             4 0
      * Define key list for FCRSFXL1                                      LN1093
     C     RSFXKY        KLIST                                                                 LN109
     C                   KFLD                    EBRNAM                         report name    LN109
     C                   KFLD                    EBRSFX                         print file nameLN109
      * Adjust page length and overflow as necessary.
     C     @$PGL         SUB       2             W0PGL             4 0
     C     @$OFL         IFGE      W0PGL
     C     W0PGL         SUB       2             W0OFL             4 0
     C                   ELSE
     C                   Z-ADD     @$OFL         W0OFL
     C                   END
      * USER: Initialise program
      * Last Amd Hdr Box fc0400p - Archive Contents(daily)  *
      * get rundate - rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      RUNA          ##RUNA
     C                   MOVE      RUNA          WURUNA
     C                   MOVE      RUND          WURUND
     C                   MOVE      SSF           WUSSF
     C                   MOVE      DATF          WUDATF
     C                   MOVE      MBIN          WUMBIN
      * Copyright Statement - standard functions  *
     C                   MOVEA     CPY@          BIS@             80
      * Get Bank Title - standard functions  *                            LN1093
     C*                                                                   LN1093
     C** ACCESS BANK ICD FOR TITLE                                        LN1093
     C*                                                                   LN1093
     C                   CALL      'AOBANKR0'                                     <BANK ICD>   LN109
     C                   PARM      '*MSG'        P@APRC            7              B:Return codeLN109
     C                   PARM      '*FIRST'      P@APOP            7              I:Option     LN109
     C     D@BANK        PARM      D@BANK        UUFDY                            O:Rec.format LN109
      * Bank ICD Access Program record format data structure              LN1093
     C     P@APRC        IFNE      *BLANKS                                                     LN109
     C     *LOCK         IN        LDA                                                         LN109
     C                   MOVEL     P@APOP        DBKEY                                         LN109
     C                   MOVEL     'SDBANKL1'    DBFILE                         ***************LN109
     C                   Z-ADD     3             DBASE                          * DB ERROR 003*LN109
     C                   MOVEL     'MA0400P'     DBPGM                          ***************LN109
     C                   OUT       LDA                                                         LN109
     C                   EXSR      ZWDBER                                                      LN109
     C                   END                                                                   LN109
      *                                                                   LN1093
     C                   MOVE      BJURPT        ##TITL                                        LN109
      * Set Up Spool File Number - standard functions  *
     C                   Z-ADD     @$FNB         WUAWNB
      * ZSFILE(Write Rpt Rqsts) - standard functions  *
     C                   CALL      'ZSFILE'                             90      ZSFILE(Write Rp
     C                   PARM      P1RQSQ        WQ0001            5            Sequence Number
     C                   PARM      P3ETTY        WQ0002            3            Entity
     C                   PARM      @CN(01)       WQ0003           10            Spool File Name
     C                   PARM      WUAWNB        WQ0004            6 0          Spool File No.(
     C     WUAXST        PARM      *BLANK        WQ0005            1            ZSFILE error
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      *CASE:     WRK.ZSFILE error is Error occured
     C     WUAXST        IFEQ      @CN(02)                                      *IF
     C                   MOVEL     @CN(03)       P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
      * 00/Copy member XX0400PFPG - Archive Contents(daily)  *
      * 00/Copy member XX0400PEPG - Archive Contents(daily)  *
      * 00/Copy member XX0400PIPG - Archive Contents(daily)  *
      * 00/Copy member XX0400PCPG - Archive Contents(daily)  *
     C*Permanent Archives       Initialise Program C-Spec
     C/COPY WNCPYSRC,MA0400PCPG
      * 00/Copy member XX0400POPG - Archive Contents(daily)  *
      *================================================================
     CSR   ZZEXIT        ENDSR
     O*Permanent Archives       Initialise Program O-Spec
     O/COPY WNCPYSRC,MA0400POPG
** CPY@
(c) Finastra International Limited 2001
** @CN Long constants used in program.
MA0400PM
Y
Y2U0004
