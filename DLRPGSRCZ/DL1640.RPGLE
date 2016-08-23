      *****************************************************************
/*STD *  RPGBASEBND                                                   *                       220859
/*EXI *  TEXT('Midas DL OIS Deals Compounding Interest Rate Rpt')     *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL1640 - OIS Deals Compounding Interest Rate Report          *
      *                                                               *
      *  Function:  This program reads through the file DLDOISPD      *
      *             and produces report to provide a hardcopy of the  *
      *             interest compounding history.                     *
      *                                                               *
      *  Called By: DLC1640 - OIS Printing Control                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 05Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 220859             Date 28Feb06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 BUG6460            Date 18Apr05               *
      *                 CSW037A            Date 02May05               *
      *                 CDL028             Date 07Feb05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG2493            Date 12May04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 204923             Date 29Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CIR007  *CREATE    Date 11May01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  220859 - Increase the size of Compounding Rate from          *
      *           7 to 15 decimal places. DL1640 was converted to ILE *
      *           due to the change in the number of decimal places.  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG6460 - OIS Compounding report error                       *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  BUG2493 - I/O operation applied to closed file DL1640P1      *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  204923 - Rate Fix Days Adjustment (OIS)                      *
      *  CIR007 - Overnight Index Swaps                               *
      *                                                               *
      *****************************************************************
     FDLDOISL0  IF   E           K DISK
     FDEALS     IF   E           K DISK
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDCF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDFF)
     FDL1640AU  O    E             PRINTER
     F                                     INFDS(SPOOLU)
     FDL1640P1  O    E             PRINTER USROPN
     F                                     INFDS(SPOOL1)
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         File access indicator for DLDOISPD              *
      *    37         Multibranching                                  *
      *    45         '*** BACK VALUED ***' on DL1640P1               *
      *    50         General file-access indicator                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRPROC - Process Report                                      *
      *  SRFMT1 - Set up P1 report fields.                            *
      *  SRPRT1 - Subroutine to decide what format needs to be printed*
      *  SRWRT1 - Write a detail record to the report                 *
      *  SRTRL1 - Write End of Report                                 *
      *  SRAUDT - Produce Audit Report and End Program                *
      *  SRRCFU - Subroutine to register AU report via RCF            *
      *  SRRCF1 - Subroutine to register P1 report via RCF            *
      *  *INZSR - Program Initialisation routine                      *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      /SPACE 3
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
     D PSDS           SDS
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D SPOOL1          DS
      ** File Information Data Structure for DL1640P1.
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
     D SPOOLU          DS
      ** File Information Data Structure for DL1640AU.
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data Structure for bank details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** Data structure for branch details
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Data structure for customer details
     D  #DFAC1       E                     EXTFLD(QQDFAC)                                     CGL029
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Data structure for currency details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First data structure for access programs, short ds
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second data structure for access programs, long ds
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Read record from File DLDOISPD via logical file DLDOISL0
      *
     C     P0BRCH        IFNE      *BLANKS
     C     P0BRCH        ANDNE     'ALL'
     C                   MOVE      P0BRCH        KBRCA
     C                   MOVE      *LOVAL        KDLNO
     C                   MOVE      *LOVAL        KOTCD
     C                   MOVE      *LOVAL        KBSDT
     C     KDOIS         SETLL     DLDOISL0
     C                   ENDIF
     C                   READ      DLDOISL0                               01
      *
      ** If end of file, do audit report
      *
     C     *IN01         IFEQ      *ON
     C     P0BRCH        ORNE      *BLANKS
     C     P0BRCH        ANDNE     'ALL'
     C     P0BRCH        ANDNE     L1BRCA
     C                   EXSR      SRAUDT
     C                   ENDIF
      *
      ** Do while a record is read
      *
     C     *IN01         DOWEQ     *OFF
      *
     C     P0BRCH        IFNE      *BLANKS
     C     P0BRCH        ANDNE     'ALL'
     C     P0BRCH        ANDNE     L1BRCA
     C                   LEAVE
     C                   ENDIF
      *
      ** Count records read
     C**********           ADD  1         RCOUNT                                              204923
      *
      ** Process Report
     C                   EXSR      SRPROC
      *                                                                                       220859
     C     WBYPAS        IFEQ      'N'                                                        220859
      *                                                                                       204923
     C     A6FXDY        IFEQ      0                                                          204923
     C     A6FXDY        ORNE      0                                                          204923
     C     L1BSDT        ANDNE     BJRDNB                                                     204923
      *                                                                                       204923
      ** Count records process                                                                204923
     C                   ADD       1             RCOUNT                                       204923
      *
     C*****WBYPAS        IFEQ      'N'                                                        220859
      *
      ** Set up output fields
     C                   EXSR      SRFMT1
      *
      ** Write to report
     C                   EXSR      SRPRT1
      *
      ** Fields used to check if new branch code, deal number or a new
      ** deal side is being processed.
     C                   MOVE      L1BRCA        WBRCAO
     C                   Z-ADD     L1DLNO        WDLNOO
     C                   MOVE      L1OTCD        WOTCDO
      *
     C                   ENDIF
      *                                                                                       204923
     C                   ENDIF                                                                204923
      *
      ** Read next record
     C                   READ      DLDOISL0                               01
      *
     C                   ENDDO
      *
      ** End of file so write trailer
      *
     C                   EXSR      SRTRL1
      *
      ** Output Audit Report and End Program.
      *
     C                   EXSR      SRAUDT
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPROC - Process report.                                     *
      *                                                               *
      *  Called By: Main processing                                   *
      *                                                               *
      *  Calls:     AOBRCHR0, *PSSR, AOCUSTR0                         *
      *                                                               *
      *****************************************************************
     C     SRPROC        BEGSR
      *
     C                   MOVE      'N'           WBYPAS            1
      *
      ** If there has been a change in branch, retrieve branch details
     C     L1BRCA        IFNE      WBRCAO
     C**********           CALL 'AOBRCHR0'                                                    CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      L1BRCA        PBRCD             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   MOVEL     PBRCD         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVE      A8BRCD        P1BRCD
     C                   MOVE      A8BRNM        P1BRNM
     C                   ENDIF
      *
      ** If change in deal, retrieve transaction details from DEALSDG
     C     L1DLNO        IFNE      WDLNOO
     C     L1DLNO        CHAIN     DEALSDGF                           50
      *
     C     *IN50         IFEQ      *OFF                                                       204923
      *                                                                                       204923
      ** Access Currency Details                                                              204923
      *                                                                                       204923
     C                   CALL      'AOCURRR0'                                                 204923
     C                   PARM      *BLANKS       PRTCD                                        204923
     C                   PARM      '*KEY    '    POPTN                                        204923
     C                   PARM      UCUCY         PCHR03                                       204923
     C     SDCURR        PARM      SDCURR        DSSDY                                        204923
     C     PRTCD         IFNE      *BLANK                                                     204923
     C     *LOCK         IN        LDA                                                        204923
     C                   Z-ADD     2             DBASE                                        204923
     C                   MOVEL     'SDCURRPD'    DBFILE                                       204923
     C                   MOVEL     PCHR03        DBKEY                                        204923
     C                   OUT       LDA                                                        204923
     C                   EXSR      *PSSR                                                      204923
     C                   ENDIF                                                                204923
      *                                                                                       204923
     C                   ENDIF                                                                204923
      *                                                                                       204923
     C     *IN50         IFEQ      *ON
     C     RECI          ORNE      'D'
      *
     C                   MOVE      'Y'           WBYPAS
      *
     C                   ELSE
      *
      ** Retrieve Customer details
     C                   MOVE      *BLANKS       PCUST
     C                   MOVEL     CNUM          PCUST
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCUST            10
     C                   PARM                    PKYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     PCUST         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVE      BBCRNM        P1CRNM
     C                   MOVE      BBCRTN        P1CRTN
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Switch of the Literal '*** BACK VALUED ***'
     C                   MOVE      *OFF          *IN45
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFMT1 - Set up P1 report fields.                            *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls:     ZDATE2, AOCURRR0, *PSSR, ZSEDIT                   *
      *                                                               *
      *****************************************************************
     C     SRFMT1        BEGSR
      *
      ** Deal number
      ** -----------
     C                   MOVE      L1DLNO        P1DLNO
      *
      ** Base date in DDMMYY format
      ** --------------------------
     C                   CALL      'ZDATE2'
     C                   PARM      L1BSDT        PZDAYN            5 0
     C                   PARM      BJDFIN        PZDFIN            1
     C                   PARM      *ZERO         PZDTE6            6 0
     C                   PARM      *BLANKS       PZDTE7            7
     C                   MOVEL     PZDTE6        P1BSDT
      *
      ** Deal date in DDMMYY format
      ** --------------------------
     C                   CALL      'ZDATE2'
     C                   PARM      DDAT          PDAYNO            5 0
     C                   PARM      BJDFIN        PDFIN             1
     C                   PARM      *ZERO         PDAY6             6 0
     C                   PARM      *BLANKS       PDAY7             7
     C                   MOVE      PDAY6         P1DDAT
      *
      ** Value date in DDMMYY format
      ** ---------------------------
     C                   CALL      'ZDATE2'
     C                   PARM      VDAT          PDAYNO
     C                   PARM      BJDFIN        PDFIN
     C                   PARM      *ZERO         PDAY6
     C                   PARM      *BLANKS       PDAY7
     C                   MOVE      PDAY6         P1VDAT
      *
      ** Maturity date in DDMMYY format
      ** ------------------------------
     C                   CALL      'ZDATE2'
     C                   PARM      MDAT          PDAYNO
     C                   PARM      BJDFIN        PDFIN
     C                   PARM      *ZERO         PDAY6
     C                   PARM      *BLANKS       PDAY7
     C                   MOVE      PDAY6         P1MDAT
      *
      ** '*** BACK VALUED ***'
      ** ---------------------
     C     VDAT          IFLT      ORED
     C                   MOVE      *ON           *IN45
     C                   ENDIF
      *
      ** Side
      ** ----
     C     L1OTCD        IFEQ      'O'
     C                   MOVEL(P)  'OUR'         P1SIDE
     C                   MOVE      UCUCY         P1SCUR
     C                   ELSE
     C                   MOVEL     'THEIR'       P1SIDE
     C                   MOVE      TCUCY         P1SCUR
     C                   ENDIF
      *
      ** Obtain number of decimals of currency
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM      P1SCUR        PCHR03            3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     PRTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   Z-ADD     5             DBASE
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     PCHR03        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Base rate
      ** ---------
     C                   MOVE      L1BSRT        PNU150
     C                   CALL      'ZSEDIT'
     C                   PARM                    PNU150
     C                   PARM      7             PDECS
     C                   PARM      'J'           PCODE
     C                   PARM      *BLANKS       PCHR21
     C                   MOVE      PCHR21        P1BSRT
      *
      ** Calculated rate
      ** ---------------
     C**********         MOVE      L1CLRT        PNU150                                      BUG6460
     C**********         CALL      'ZSEDIT'                                                  BUG6460
     C**********         PARM                    PNU150                                      BUG6460
     C**********         PARM      7             PDECS                                       BUG6460
     C**********         PARM      'J'           PCODE                                       BUG6460
     C**********         PARM      *BLANKS       PCHR21                                      BUG6460
     C**********         MOVE      PCHR21        P1CLRT                                      BUG6460
      *
      ** Compounding rate
      ** ----------------
     C**********         MOVE      L1CPRT        PNU150                                       220859
     C**********         CALL      'ZSEDIT'                                                   220859
     C**********         PARM                    PNU150                                       220859
     C**********         PARM      7             PDECS                                        220859
     C**********         PARM      'J'           PCODE                                        220859
     C**********         PARM      *BLANKS       PCHR21                                       220859
     C**********         MOVE      PCHR21        P1CPRT                                       220859
     C                   MOVE      L1CPRT        LNU190                                       220859
     C                   CALL      'ZSEDITL'                                                  220859
     C                   PARM                    LNU190           19 0                        220859
     C                   PARM      15            LDECS             2 0                        220859
     C                   PARM      'J'           LCODE             1                          220859
     C                   PARM      *BLANKS       LCHR22           22                          220859
     C                   MOVE      LCHR22        P1CPRT                                       220859
      *
      ** Interest rate
      ** -------------
      ** Perform rounding off of Interest Rate based on the
      ** OIS Interest Rate Decimals on SDCURRPD. Do this only if
      ** Amount on DLDOISPD is not zero.
     C     L1AMNT        IFNE      0
     C                   SELECT
     C     A6IRDP        WHENEQ    0
     C                   Z-ADD(H)  L1INRT        WNU110           11 0
     C                   Z-ADD     WNU110        WNU117
     C     A6IRDP        WHENEQ    1
     C                   Z-ADD(H)  L1INRT        WNU111           11 1
     C                   Z-ADD     WNU111        WNU117
     C     A6IRDP        WHENEQ    2
     C                   Z-ADD(H)  L1INRT        WNU112           11 2
     C                   Z-ADD     WNU112        WNU117
     C     A6IRDP        WHENEQ    3
     C                   Z-ADD(H)  L1INRT        WNU113           11 3
     C                   Z-ADD     WNU113        WNU117
     C     A6IRDP        WHENEQ    4
     C                   Z-ADD(H)  L1INRT        WNU114           11 4
     C                   Z-ADD     WNU114        WNU117
     C     A6IRDP        WHENEQ    5
     C                   Z-ADD(H)  L1INRT        WNU115           11 5
     C                   Z-ADD     WNU115        WNU117
     C     A6IRDP        WHENEQ    6
     C                   Z-ADD(H)  L1INRT        WNU116           11 6
     C                   Z-ADD     WNU116        WNU117
     C     A6IRDP        WHENEQ    7
     C                   Z-ADD(H)  L1INRT        WNU117           11 7
     C                   ENDSL
     C                   MOVE      WNU117        PNU150
     C                   ELSE
     C                   MOVE      L1INRT        PNU150
     C                   ENDIF
      *
     C                   CALL      'ZSEDIT'
     C                   PARM                    PNU150
     C                   PARM      7             PDECS
     C                   PARM      'J'           PCODE
     C                   PARM      *BLANKS       PCHR21
     C                   MOVE      PCHR21        P1INRT
      *
      ** Principal
      ** ---------
     C                   Z-ADD     L1PRIN        PNU150
     C                   Z-ADD     A6NBDP        PDECS
     C                   MOVE      'J'           PCODE
     C                   CALL      'ZSEDIT'
     C                   PARM                    PNU150           15 0
     C                   PARM                    PDECS             1 0
     C                   PARM                    PCODE             1
     C                   PARM      *BLANKS       PCHR21           21
     C                   MOVE      PCHR21        P1PRIN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPRT1 - Subroutine to decide what format needs to be printed*
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     SRWRT1, SRTRL1, SRRCF1                            *
      *                                                               *
      *****************************************************************
     C     SRPRT1        BEGSR
      *
     C                   SELECT
      *
      ** No change in any of the first 3 key fields
     C     L1BRCA        WHENEQ    WBRCAO
     C     L1DLNO        ANDEQ     WDLNOO
     C     L1OTCD        ANDEQ     WOTCDO
     C                   EXSR      SRWRT1
      *
      ** Change in branch (multi-branch)
     C     L1BRCA        WHENNE    WBRCAO
     C     AGMBIN        ANDEQ     'Y'
     C     WOPNP1        IFEQ      'Y'
     C                   EXSR      SRTRL1
     C                   CLOSE     DL1640P1
     C                   MOVE      'N'           WOPNP1
     C                   ENDIF
     C                   OPEN      DL1640P1
     C                   MOVE      'Y'           WOPNP1
      ** RCF Processing for P1 printer file
     C                   EXSR      SRRCF1
     C                   WRITE     HEADP1
     C                   WRITE     HDTLP1
     C                   EXSR      SRWRT1
      *
      ** Change in branch (single-branch),
      ** Change in deal number
     C     L1BRCA        WHENNE    WBRCAO
     C     AGMBIN        ANDNE     'Y'
     C     L1DLNO        ORNE      WDLNOO
     C                   WRITE     HEADP1
     C                   WRITE     HDTLP1
     C                   EXSR      SRWRT1
      *
      ** Change in side
     C     L1OTCD        WHENNE    WOTCDO
      *
     C     L1OTCD        IFEQ      'O'
     C                   MOVEL(P)  'OUR'         P1SIDE
     C                   MOVE      UCUCY         P1SCUR
     C                   ELSE
     C                   MOVEL     'THEIR'       P1SIDE
     C                   MOVE      TCUCY         P1SCUR
     C                   ENDIF
      *
      ** If the deal is back dated then print the literal
      ** '*** BACK VALUED ***' against the Value Date.
     C     VDAT          IFLT      ORED
     C                   MOVE      *ON           *IN45
     C                   ENDIF
      *
     C                   WRITE     HEADP1
     C                   WRITE     HDTLP1
     C                   EXSR      SRWRT1
      *
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWRT1 - Subroutine to Write a Detail record to the Report.  *
      *                                                               *
      *  Called By: SRPRT1                                            *
      *                                                               *
      *  Calls:     SRPRT1                                            *
      *                                                               *
      *****************************************************************
     C     SRWRT1        BEGSR
      *
      ** Check that sufficient lines remain for the format. If not,
      ** write out the main headings on a new page.
      *
     C                   Z-ADD     1             WRQDLN            3 0
     C     OFLLN1        SUB       PRTLN1        WDIFLN            3 0
     C     WDIFLN        IFLE      WRQDLN
     C                   WRITE     HEADP1
     C                   WRITE     HDTLP1
     C                   ENDIF
      *
      ** Write out detail record
      *
     C                   WRITE     DTLP1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTRL1- Subroutine to Write End of Report.                   *
      *                                                               *
      *  Called By: Main processing, SRPRT1                           *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
     C     SRTRL1        BEGSR
      *                                                                                      BUG2493
      ** If DL1640P1 is not yet open then open it.                                           BUG2493
      *                                                                                      BUG2493
     C     WOPNP1        IFNE      'Y'                                                       BUG2493
     C                   OPEN      DL1640P1                                                  BUG2493
     C                   ENDIF                                                               BUG2493
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     4             WRQDLN
     C     OFLLN1        SUB       PRTLN1        WDIFLN
     C     WDIFLN        IFLE      WRQDLN
     C                   WRITE     HEADP1
     C                   ENDIF
      *
      ** Write trailer
      *
     C                   WRITE     TRAILP1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAUDT - Subroutine to Output Audit report and End Program.  *
      *                                                               *
      *  Called By: Main Processing, *PSSR                            *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRAUDT        BEGSR
      *
      ** Output Report Header and File Controls.
      *
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
      *
      ** If there is a DB Error, Output the DB Error Information.
      *
     C     *INU7         IFEQ      *ON
     C                   WRITE     DBERROR
     C                   ELSE
      ** Or, if no records read, Output "No Details" message.
     C     RCOUNT        IFEQ      0
     C                   WRITE     NODTLS
     C                   ENDIF
     C                   ENDIF
      *
      ** End program and return
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCFU - Subroutine to register AU report via RCF.           *
      *                                                               *
      *  Called by: *INZSR                                            *
      *                                                               *
      *  Calls:     ZSFILE                                            *
      *                                                               *
      *****************************************************************
     C     SRRCFU        BEGSR
      *
      ** Ensure Audit spool file recorded by RCF
     C                   Z-ADD     SFNUMU        PSFNUM
     C                   CALL      'ZSFILE'
     C                   PARM      P0SEQ         PZSEQ             5
     C                   PARM      P0BRCH        PZNTT             3
     C                   PARM      SFILEU        PSFNAM           10
     C                   PARM                    PSFNUM            6 0
     C                   PARM      *BLANK        PZERR             1
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** calling Program.
     C     PZERR         IFEQ      'Y'
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCF1 - Subroutine to register P1 report via RCF.           *
      *                                                               *
      *  Called by: SRPRT1, *INZSR                                    *
      *                                                               *
      *  Calls:     ZSFILE                                            *
      *                                                               *
      *****************************************************************
     C     SRRCF1        BEGSR
      *
      ** Ensure Report spool file recorded by RCF
     C                   Z-ADD     SFNUM1        PSFNUM
     C                   CALL      'ZSFILE'
     C                   PARM      P0SEQ         PZSEQ
     C                   PARM      P0BRCH        PZNTT
     C                   PARM      SFILE1        PSFNAM
     C                   PARM                    PSFNUM
     C                   PARM      *BLANKS       PZERR
      *
      ** If error occurs during ZSFILE processing, then return to the
      ** calling Program.
     C     PZERR         IFEQ      'Y'
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR    - Program Initialisation routine                   *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls:     AOBANKR0, *PSSR, SRRCFU, SRRCF1                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Set up copyright parameter
     C                   MOVEA     CPY@          CPY2@            80
      *
     C     *ENTRY        PLIST
     C                   PARM                    TYPE              2
     C                   PARM                    P0SEQ             5
     C                   PARM                    P0BRCH            3
      *
     C     *DTAARA       DEFINE                  LDA
     C     *DTAARA       DEFINE                  RUNDAT
      *
     C     *LIKE         DEFINE    L1BRCA        KBRCA
     C     *LIKE         DEFINE    L1DLNO        KDLNO
     C     *LIKE         DEFINE    L1OTCD        KOTCD
     C     *LIKE         DEFINE    L1BSDT        KBSDT
      *
     C     KDOIS         KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KDLNO
     C                   KFLD                    KOTCD
     C                   KFLD                    KBSDT
      *
     C                   IN        RUNDAT
     C                   MOVE      *OFF          *IN37
     C     AGMBIN        IFEQ      'Y'
     C                   MOVE      *ON           *IN37
     C                   ENDIF
      *
      ** Initialise LDA fields
     C     *LOCK         IN        LDA
     C                   MOVEL(P)  'DL1640'      DBPGM
     C                   Z-ADD     0             DBASE
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   OUT       LDA
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     POPTN         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       WBRCAO            3
     C                   Z-ADD     *ZEROS        WDLNOO            6 0
     C                   MOVE      *BLANKS       WOTCDO            1
     C                   MOVE      'N'           WOPNP1            1
      *
      ** RCF Processing for Audit file
     C                   EXSR      SRRCFU
      *
      ** RCF Processing for P1 file
     C     AGMBIN        IFEQ      'N'
     C                   OPEN      DL1640P1
     C                   MOVE      'Y'           WOPNP1
     C                   EXSR      SRRCF1
     C                   ENDIF
      *
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
      *  Called by: Error processing routines                         *
      *                                                               *
      *  Calls:     SRAUDT                                            *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
     C                   DUMP
     C                   ENDIF
      *
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      SRAUDT
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2001
