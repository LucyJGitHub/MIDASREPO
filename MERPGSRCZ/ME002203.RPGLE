     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME Network Accounts List - Report P.E.P.')       *
      *****************************************************************
      *                                                               *
      *  Midas - Messages Management Module                           *
      *                                                               *
      *  ME002203 - Network Accounts List                             *
      *                                                               *
      *  Function:  This module will replace ME0030 if CGL013 is      *
      *             installed.  It will print all the network account *
      *             details.                                          *
      *                                                               *
      *  Program Entry Point of: ME002203                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CRE075             Date 06Dec10               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 04Nov03               *
      *                 CGL013  *CREATE    Date 16Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  CGL013 - MT94x Message Generation                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *    01         A database error occurred                       *
      *    37         On if report requested for one given branch     *
      *    38         On if "audit" list mode                         *
      *    99         Multi-purpose indicator                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FGLNWACL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLNWACD0:GLNWACD1)
      ** GL Network Accounts - Retrieval
 
     FGLNW94L1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLNW94D0:GLNW94D1)
      ** GL Network Accounts MT94x - Retrieval
 
     FME002203AUO    E             PRINTER
     F                                     INFDS(SPOOLU)
      ** Printer file for Network Accounts List (Audit)
 
     FME002203P1O    E             PRINTER
     F                                     INFDS(SPOOL1)
      ** Printer file for Network Accounts List
 
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
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
 
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
 
      ** File Information Data Structure for ME002203P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
      ** File Information Data Structure for ME002203AU
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
     D DSBANK        E DS                  EXTNAME(SDBANKPD)
      ** External Data Structure for Bank Details
 
     D DSCURR        E DS                  EXTNAME(SDCURRPD)
      ** External Data Structure for Currency Details
 
     D DSBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** External Data Structure for Branch Details
 
     D DSACCNT       E DS                  EXTNAME(ACCNTAB) PREFIX(AC_)
      ** Account details record format data structure
 
      ** DS for access programs: Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **Entry parameters
     D @ListMode       S              1A
     D @Sequence       S              5A
     D @Level          S              1A
     D @Entity         S              3A
 
      ** Various work fields
     D WRUN            S              1A
     D WFIRST          S              1A
 
      ** Work fields for ZSFILE
     D PSeq            S              5A
     D PSenty          S              3A
     D PPrFile         S             10A
     D PSnum           S              6P 0
     D PSErr           S              1A
 
      ** Work fields for ZSDATE2
     D PDate           S              5P 0
     D ZDATE           S              6P 0
     D ZADATE          S              7A
 
      ** Work fields for ZSEDIT
     D ZADEC           S              1P 0
     D ZFLD15          S             15P 0
     D ZECODE          S              1A
     D ZOUT21          S             21A
     D ZOUT18          S             18A
 
      ** Work fields for Standard Access Object
     D PRtCd           S              7A
     D POption         S              7A
     D PRetl           S             10A
     D PCust           S              6A
     D PCurr           S              3A
     D***PAcCd*          S              4A                                                    CGL029
     D PAcCd           S             10A                                                      CGL029
     D PASeq           S              2A
     D PBrcd           S              3A
     D PCuCd           S              3A
 
      *****************************************************************
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Main loop on GLNWACL1. A record will be printed if:
      **    . a given branch is requested and it corresponds to that branch
      **    . no specific branch is requested
      **    . the list mode is "audit" and it was inserted/amended/deleted today
      **    . the list mode is "full" and it is not deleted
 
 B1  C                   DOU       *IN99
     C                   READ      GLNWACD1                               99
     C   99              LEAVE
      *
     C                   EXSR      $AudCount
      *
 B2  C   37              IF        NABRCH <> @Entity
     C                   ITER
 E2  C                   ENDIF
      *
 B2  C   38              IF        NALCDT <> BJRDNB
     C                   ITER
 E2  C                   ENDIF
      *
 B2  C  N38              IF        NARECI = '*'
     C                   ITER
 E2  C                   ENDIF
      *
      ** Here, there is something to print:
      **    . if it is the first time, record the report into RCF
      **    . Output the NETWORK record format
      **    . Eventually output the MT950DTL record format
      *
 B2  C                   IF        WFIRST <> 'N'
     C                   EXSR      $RCFP1
     C                   EVAL      WFIRST = 'N'
 E2  C                   ENDIF
      *
     C                   EXSR      $Network
      *
 B2  C                   IF        NAG950 = 'Y'
     C                   EXSR      $MT950Dtl
 E2  C                   ENDIF
      *
      ** Secondary loop on the network account's destinations.
      ** A record will be printed if:
      **    . the list mode is "audit" (the selection is done at network account level)
      **    . the list mode is "full" and it isn't deleted
      *
     C     KGLNW94L1     SETLL     GLNW94D1
      *
 B2  C                   DOU       *IN99
     C     KGLNW94L1     READE     GLNW94D1                               99
     C   99              LEAVE
      *
 B3  C  N38              IF        N4RECI = '*'
     C                   ITER
 E3  C                   ENDIF
      *
      ** Output the details of the destination:
      **    . DEST record format
      **    . Eventually the MT940/41/42DTL record formats
      *
     C                   EXSR      $Dest
      *
 B3  C                   IF        N4G940 = 'Y'
     C                   EXSR      $MT940Dtl
 E3  C                   ENDIF
      *
 B3  C                   IF        N4G941 = 'Y'
     C                   EXSR      $MT941Dtl
 E3  C                   ENDIF
      *
 B3  C                   IF        N4G942 = 'Y'
     C                   EXSR      $MT942Dtl
 E3  C                   ENDIF
      *
 E2  C                   ENDDO
      *
     C                   EVAL      *IN99 = *Off
 E1  C                   ENDDO
 
      ** Output the report trailer, the audit report and terminate the module
 
 B1  C                   IF        WFIRST = 'N'
     C                   WRITE     TRAILER
 E1  C                   ENDIF
      *
     C                   EXSR      $RCFAU
     C                   EXSR      $Audit
     C                   SETON                                        LR
 
      *****************************************************************
      * SUB-ROUTINES                                                  *
      *****************************************************************
 
      *****************************************************************
      * $AudCount - Set up of the counters for the audit report       *
      *****************************************************************
     C     $AudCount     BEGSR
 
     C                   SELECT
     C                   WHEN      NALCDT = BJRDNB AND NACHTP = 'I'
     C                   EVAL      RINSER = RINSER + 1
      *
     C                   WHEN      NALCDT = BJRDNB AND NACHTP = 'A'
     C                   EVAL      RAMEND = RAMEND + 1
      *
     C                   WHEN      NALCDT = BJRDNB AND NACHTP = 'D'
     C                   EVAL      RDELET = RDELET + 1
     C                   ENDSL
 
     C                   IF        NARECI <> '*'
     C                   EVAL      RCOUNT = RCOUNT + 1
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      * $Network - Print the NETWORK record format                    *
      *****************************************************************
     C     $Network      BEGSR
 
      ** As it is the first record format for a network account,
      ** always print the report page header
     C                   WRITE     HEADER
 
      ** Set up of the fields
     C                   CLEAR                   NETWORK
 
     C                   EVAL      PNWRK  = NANWRK
     C                   EVAL      PBRCH  = NABRCH
     C                   EVAL      PCNUM  = NACNUM
     C                   EVAL      PCCY   = NACCY
     C                   EVAL      PACOD  = NAACOD
     C                   EVAL      PACSQ  = NAACSQ
     C                   EVAL      PNATY  = NANATY
     C                   EVAL      PG950  = NAG950
     C                   EVAL      PACHTP = NACHTP
     C                   EVAL      PAUSER = NAUSER
 
     C                   EVAL      PDATE = NALCDT
     C                   EXSR      $CvtDate
     C                   EVAL      PALCDT = ZADATE
 
     C                   MOVEL     NACNUM        PCust
     C                   MOVEL     NAACOD        PAcCd
     C                   MOVEL     NAACSQ        PASeq
      *
     C                   CALLB     'AOACCTR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*KEY'        POption
     C                   PARM      *Blanks       PRetl
     C                   PARM                    PCust
     C                   PARM      NACCY         PCurr
     C                   PARM                    PAcCd
     C                   PARM                    PASeq
     C                   PARM      NABRCH        PBrcd
     C     DSACCNT       PARM                    DSSDY
      *
     C                   IF        PRtCd = *Blanks AND AC_ACNO <> 0
     C                   MOVEL     AC_ACNO       PRANO
     C                   ENDIF
 
     C                   IF        PRtCd = *Blanks
     C                   EVAL      PANAM = AC_ANAM
     C                   ENDIF
 
      ** Output the record format
     C                   WRITE     NETWORK
 
     C                   ENDSR
 
      *****************************************************************
      * $MT950Dtl - Print the MT950DTL record format                  *
      *****************************************************************
     C     $MT950Dtl     BEGSR
 
      ** No need to output the report page header here, as the only
      ** report format that has been printed yet on the current page
      ** is NETWORK, and a new page was started for it
 
      ** Set up of the fields
     C                   CLEAR                   MT950DTL
 
     C                   EVAL      P5SFQ = NA5SFQ
     C                   EVAL      P5SDY = NA5SDY
     C                   EVAL      P5DSI = NA5DSI
     C                   EVAL      P5LST = NA5LST
     C                   EVAL      P5LSN = NA5LSN
 
     C                   IF        NA5NSD <> 0
     C                   EVAL      PDATE = NA5NSD
     C                   EXSR      $CvtDate
     C                   EVAL      P5NSD = ZADATE
     C                   ENDIF
 
     C                   EVAL      ZFLD15 = NA5LCB
     C                   EXSR      $ZSEdit
     C                   EVAL      P5LCB  = ZOUT18
 
     C                   IF        NA5LSD <> 0
     C                   EVAL      PDATE = NA5LSD
     C                   EXSR      $CvtDate
     C                   EVAL      P5LSD = ZADATE
     C                   ENDIF
 
      ** Output the record format
     C                   WRITE     MT950DTL
 
     C                   ENDSR
 
      *****************************************************************
      * $Dest     - Print the DEST record format                      *
      *****************************************************************
     C     $Dest         BEGSR
 
      ** Eventually print a report page header, taking into account
      ** the place needed for the record format to be printed and an
      ** eventual report trailer
     C                   IF        (OFLLN1 - PRTLN1) < 8
     C                   WRITE     HEADER
     C                   ENDIF
 
      ** Set up of the fields
     C                   CLEAR                   DEST
 
     C                   EVAL      PDSTN  = N4DSTN
     C                   EVAL      PDSTD  = N4DSTD
     C                   EVAL      PG940  = N4G940
     C                   EVAL      PG941  = N4G941
     C                   EVAL      PG942  = N4G942
     C                   EVAL      P4CHTP = N4CHTP
     C                   EVAL      P4USER = N4USER
 
     C                   EVAL      PDATE = N4LCDT
     C                   EXSR      $CvtDate
     C                   EVAL      P4LCDT = ZADATE
 
      ** Output the record format
     C                   WRITE     DEST
 
     C                   ENDSR
 
      *****************************************************************
      * $MT940DTL - Print the MT940DTL record format                  *
      *****************************************************************
     C     $MT940DTL     BEGSR
 
      ** Eventually print a report page header, taking into account
      ** the place needed for the record format to be printed and an
      ** eventual report trailer
     C                   IF        (OFLLN1 - PRTLN1) < 15
     C                   WRITE     HEADER
     C                   ENDIF
 
      ** Set up of the fields
     C                   CLEAR                   MT940DTL
 
     C                   EVAL      P0SFR = N40SFR
     C                   EVAL      P0SDM = N40SDM
     C                   EVAL      P0DSI = N40DSI
     C                   EVAL      P0MI1 = N40MI1
     C                   EVAL      P0MI2 = N40MI2
     C                   EVAL      P0MI3 = N40MI3
     C                   EVAL      P0MI4 = N40MI4
     C                   EVAL      P0MI5 = N40MI5
     C                   EVAL      P0MI6 = N40MI6
     C                   EVAL      P0LST = N40LST
     C                   EVAL      P0LSN = N40LSN
 
     C                   IF        N40NSD <> 0
     C                   EVAL      PDATE = N40NSD
     C                   EXSR      $CvtDate
     C                   EVAL      P0NSD = ZADATE
     C                   ENDIF
 
     C                   EVAL      ZFLD15 = N40LCA
     C                   EXSR      $ZSEdit
     C                   EVAL      P0LCA  = ZOUT18
 
     C                   IF        N40LSD <> 0
     C                   EVAL      PDATE = N40LSD
     C                   EXSR      $CvtDate
     C                   EVAL      P0LSD = ZADATE
     C                   ENDIF
 
      ** Output the record format
     C                   WRITE     MT940DTL
 
     C                   ENDSR
 
      *****************************************************************
      * $MT941DTL - Print the MT941DTL record format                  *
      *****************************************************************
     C     $MT941DTL     BEGSR
 
      ** Eventually print a report page header, taking into account
      ** the place needed for the record format to be printed and an
      ** eventual report trailer
     C                   IF        (OFLLN1 - PRTLN1) < 19
     C                   WRITE     HEADER
     C                   ENDIF
 
      ** Set up of the fields
     C                   CLEAR                   MT941DTL
 
     C                   EVAL      P1DTI = N41DTI
     C                   EVAL      P1OBI = N41OBI
     C                   EVAL      P1LSF = N41LSF
     C                   EVAL      P1CAB = N41CAB
     C                   EVAL      P1FAB = N41FAB
     C                   EVAL      P1MI1 = N41MI1
     C                   EVAL      P1MI2 = N41MI2
     C                   EVAL      P1MI3 = N41MI3
     C                   EVAL      P1MI4 = N41MI4
     C                   EVAL      P1MI5 = N41MI5
     C                   EVAL      P1MI6 = N41MI6
     C                   EVAL      P1AER = N41AER
     C                   EVAL      P1AGS = N41AGS
     C                   EVAL      P1AMR = N41AMR
     C                   EVAL      P1GNM = N41GNM
     C                   EVAL      P1RPL = N41RPL
     C                   EVAL      P1RAS = N41RAS
     C                   EVAL      P1LST = N41LST
     C                   EVAL      P1LSP = N41LSP
     C                   EVAL      P1LDN = N41LDN
     C                   EVAL      P1LCN = N41LCN
 
     C                   EVAL      ZFLD15 = N41LCB
     C                   EXSR      $ZSEdit
     C                   EVAL      P1LCB  = ZOUT18
 
     C                   IF        N41LSD <> 0
     C                   EVAL      PDATE = N41LSD
     C                   EXSR      $CvtDate
     C                   EVAL      P1LSD = ZADATE
     C                   ENDIF
 
     C                   EVAL      ZFLD15 = N41LDA
     C                   EXSR      $ZSEdit
     C                   EVAL      P1LDA  = ZOUT18
 
     C                   EVAL      ZFLD15 = N41LCA
     C                   EXSR      $ZSEdit
     C                   EVAL      P1LCA  = ZOUT18
 
      ** Output the record format
     C                   WRITE     MT941DTL
 
     C                   ENDSR
 
      *****************************************************************
      * $MT942DTL - Print the MT942DTL record format                  *
      *****************************************************************
     C     $MT942DTL     BEGSR
 
      ** Eventually print a report page header, taking into account
      ** the place needed for the record format to be printed and an
      ** eventual report trailer
     C                   IF        (OFLLN1 - PRTLN1) < 18
     C                   WRITE     HEADER
     C                   ENDIF
 
      ** Set up of the fields
     C                   CLEAR                   MT942DTL
 
     C                   EVAL      P2LSF = N42LSF
     C                   EVAL      P2MI1 = N42MI1
     C                   EVAL      P2MI2 = N42MI2
     C                   EVAL      P2MI3 = N42MI3
     C                   EVAL      P2MI4 = N42MI4
     C                   EVAL      P2MI5 = N42MI5
     C                   EVAL      P2MI6 = N42MI6
     C                   EVAL      P2AER = N42AER
     C                   EVAL      P2AGS = N42AGS
     C                   EVAL      P2AMR = N42AMR
     C                   EVAL      P2GNM = N42GNM
     C                   EVAL      P2RPL = N42RPL
     C                   EVAL      P2RAS = N42RAS
     C                   EVAL      P2LST = N42LST
     C                   EVAL      P2LSP = N42LSP
     C                   EVAL      P2LDN = N42LDN
     C                   EVAL      P2LCN = N42LCN
 
     C                   EVAL      ZFLD15 = N42FLD
     C                   EXSR      $ZSEdit
     C                   MOVEL     ZOUT18        P2FLD
 
     C                   EVAL      ZFLD15 = N42FLC
     C                   EXSR      $ZSEdit
     C                   MOVEL     ZOUT18        P2FLC
 
     C                   IF        N42LSD <> 0
     C                   EVAL      PDATE = N42LSD
     C                   EXSR      $CvtDate
     C                   EVAL      P2LSD = ZADATE
     C                   ENDIF
 
     C                   EVAL      ZFLD15 = N42LDA
     C                   EXSR      $ZSEdit
     C                   EVAL      P2LDA  = ZOUT18
 
     C                   EVAL      ZFLD15 = N42LCA
     C                   EXSR      $ZSEdit
     C                   EVAL      P2LCA  = ZOUT18
 
      ** Output the record format
     C                   WRITE     MT942DTL
 
     C                   ENDSR
 
      *****************************************************************
      * $ZSEdit - Edit a numeric amount with the indicator CR/DB      *
      *****************************************************************
     C     $ZSEdit       BEGSR
 
     C                   EXSR      $RtvCurr
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM      A6NBDP        ZADEC
     C                   PARM      *Blank        ZECODE
     C                   PARM                    ZOUT21
 
     C                   EVAL      ZOUT18 = %Subst(ZOUT21:5:17) + ' '
 
     C                   IF        %Subst(ZOUT21:21:1) = '-'
     C                   MOVE      'CR'          ZOUT18
     C                   ELSE
     C                   MOVE      'DB'          ZOUT18
     C                   ENDIF
 
     C                   IF        ZFLD15 = 0
     C                   MOVE      '  '          ZOUT18
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      * $RtvCurr - Retrieve the nb of decimal places of the current   *
      *            currency (assume 2 if not found)                   *
      *****************************************************************
     C     $RtvCurr      BEGSR
 
     C                   IF        PCuCd <> NACCY
     C**********         CALLB     'AOACCTR0'                                                 222373
     C                   CALLB     'AOCURRR0'                                                 222373
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*KEY'        POption
     C                   PARM      NACCY         PCuCd
     C     DSCURR        PARM                    DSSDY
      *
     C                   IF        PRtCd <> *Blanks
     C                   EVAL      A6NBDP = 2
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      * $CvtDate - Convert a date to DDMMMYY/DDMMYY/MMDDYY format     *
      *****************************************************************
     C     $CvtDate      BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDate
     C                   PARM                    BJDFIN
     C                   PARM      *Zeros        ZDATE
     C                   PARM      *Blanks       ZADATE
 
     C                   ENDSR
 
      *****************************************************************
      * $RCFP1 - Record the ME002203P1 printer file into RCF          *
      *****************************************************************
     C     $RCFP1        BEGSR
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      @Entity       PSenty
     C                   PARM      SFILE1        PPrFile
     C                   PARM      SFNUM1        PSnum
     C                   PARM                    PSErr
 
     C                   IF        PSErr = 'Y'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = SFILE1
     C                   EVAL      DBFILE = 'ZSFILE'
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      * $RCFAU - Record the ME002203AU printer file into RCF          *
      *****************************************************************
     C     $RCFAU        BEGSR
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      @Entity       PSenty
     C                   PARM      SFILEU        PPrFile
     C                   PARM      SFNUMU        PSnum
     C                   PARM                    PSErr
 
     C                   IF        PSErr = 'Y'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = SFILEU
     C                   EVAL      DBFILE = 'ZSFILE'
     C                   EVAL      DBASE = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      * $Audit - Print the audit report                               *
      *****************************************************************
     C     $Audit        BEGSR
 
      ** Header
     C                   WRITE     HEADAU
 
      ** DB Error, no details ou counters
     C                   SELECT
     C                   WHEN      *IN01
     C                   WRITE     DBERROR
      *
     C                   WHEN      RCOUNT = 0
     C                   WRITE     NODTLS
      *
     C                   OTHER
     C                   WRITE     CONTROL
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    @ListMode
     C                   PARM                    @Sequence
     C                   PARM                    @Level
     C                   PARM                    @Entity
 
      ** Klist's
     C     KGLNW94L1     KLIST
     C                   KFLD                    NANWRK
     C                   KFLD                    NABRCH
     C                   KFLD                    NACNUM
     C                   KFLD                    NACCY
     C                   KFLD                    NAACOD
     C                   KFLD                    NAACSQ
     C                   KFLD                    NANATY
 
      ** Access Local Data Area (LDA) and initialize its values
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *Blanks
     C                   EVAL      DBKEY = *Blanks
     C                   EVAL      DBPGM = *Blanks
     C                   EVAL      DBPGM = PSProcPgm
     C                   EVAL      DBASE = 0
     C                   OUT       LDA
 
      ** Check if the report was requested for a given branch
      ** If yes, access the details of this branch
     C                   IF        @Level = 'B' AND @Entity <> 'ALL'
     C                   EVAL      *IN37 = *ON
      *
     C                   CALL      'AOBRCHR1'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*FIRST '     POption
     C                   PARM      @Entity       PBrcd
     C     DSBRCH        PARM                    DSSDY
      *
     C                   IF        PRtCd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PBrcd
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
 
      ** Call access program for Bank details - Title, Run Date and
      ** Run Day Number
     C                   CALLB     'AOBANKR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*FIRST '     POption
     C     DSBANK        PARM                    DSSDY
 
     C                   IF        PRtCd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = '*FIRST '
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialize the fields of the HEADER record format
     C   37              EVAL      PBRCH = @Entity
     C   37              EVAL      PBRNM = A8BRNM
 
      ** Sets on tthe indicator 38 if the list mode is "Audit"
     C     @ListMode     COMP      'A'                                    38
 
     C                   ENDSR
 
      *********************************************************************
      * *PSSR  - Program exception error routine                          *
      *********************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   EVAL      *IN01 = *ON
 
     C                   IF        WRUN <> 'Y'
     C                   EVAL      WRUN = 'Y'
     C                   EXSR      $Audit
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
