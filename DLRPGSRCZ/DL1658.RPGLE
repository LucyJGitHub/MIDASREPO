     H DEBUG
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       220859
/*STD *  RPGBASEBND                                                   *                       220859
/*EXI *  TEXT('Midas DL OIS compounding int. rate amendment audit')   *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL1658 - OIS Compounding Interest Rate Amendment Audit       *
      *                                                               *
      *  Function:  This program produces an audit report if the Base *
      *             Rate of an OIS deal has been changed via program  *
      *             DL1652.                                           *
      *                                                               *
      *  Called By: DL1641 - OIS Compounding Interest Rate Enquiry    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 MD030364           Date 10Sep14               *
      *                 CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 05Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 226723             Date 01Mar06               *
      *                 220859             Date 01Mar06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209171             Date 06Sep02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 204923             Date 29Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CIR007  *CREATE    Date 11May01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  MD030364 - Compilation issue for BFM 2.1 SP6 Drop2           *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  226723 - Recompiled due to changes in printer file DL1658P1. *
      *  220859 - Increase the size of Compounding Rate from          *
      *           7 to 15 decimal places. DL1658 was converted to ILE *
      *           due to the change in the number of decimal places.  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  209171 - Error fix for 204923                                *
      *  204923 - Rate Fix Days Adjustment (OIS)                      *
      *  CIR007 - Overnight Index Swaps                               *
      *                                                               *
      *****************************************************************
     FDLDOISL2  IF   E           K DISK
     FDLOISSL3  IF   E           K DISK
     FDEALS     IF   E           K DISK
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDCF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDFF)
     FDL1658P1  O    E             PRINTER
     F                                     INFDS(SPOOL1)
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   37  - End of Report for Branch                              *
      *  N37  - End of Report                                         *
      *   79  - CHAIN on DEALSDG via logical file DEALS               *
      *   89  - End of OIS Compounding Interest Rate File DLDOISPD    *
      * 90-99 - Used by Standard Subroutines                          *
      *   98  - Date Format: DDMMYY (off); MMDDYY (on)                *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRINIT   - Program Initialisation                            *
      *  SRPROC   - Detail Processing                                 *
      *  SRTERM   - Terminate Program                                 *
      *  SRREPT   - Process Report                                    *
      *                                                               *
      *  SRRECD - Format and Write a Detail Record to the Report      *
      *  SREND  - Write End of Report                                 *
      *  SRBRCH - Process data base file SDBRCHPD                     *
      *  SRDEAL - Process data base file DEALSDG                      *
      *  SRCUST - Process data base file SDCUSTPD                     *
      *                                                               *
      *  SRNEWP - Prints new page                                     *
      *  SRRCFP - RCF Processing for Printer File DL1658P1            *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *  ZDATE2 - Convert Midas Day Number into Date (DDMMYY/MMDDYY)  *
      *                                                               *
      *****************************************************************
     D/EJECT
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D*COPY*ZSRSRC,ZEDITZ1**********************************                                  220859
     D/COPY ZSRSRC,ZEDITZ1LE                                                                  220859
      *
     D*COPY*ZSRSRC,ZDATE2Z1*********************************                                  220859
     D/COPY ZSRSRC,ZDATE2Z1LE                                                                 220859
      *
      /SPACE 3
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Data Area giving Installation Control Details
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Program Status Data Structure
     D PSDS           SDS
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  RUSER                254    263
      *
      ** File Information Data Structure for DL1658P1.
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
      ** Data Structure for Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** Data Structure ro receive SDBANKPD details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Branch Details Data structure
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  QQDFA1       E                     EXTFLD(QQDFAC)
      *
      ** Data Structure to receive Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** DS for access programs, long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for access programs, short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Midas SD Dealing data                                                              MD030364
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                MD030364
      /EJECT
      *
      *
     C/TITLE Main Processing
      *
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      ** Perform Initialisation.
      *
     C                   EXSR      SRINIT
      *
      ** Perform Detail Processing.
      *
     C                   EXSR      SRPROC
      *
     C                   EXSR      SRTERM
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT   - Subroutine to do Program Initialisation.          *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *  AOBANKR0 Access Program                                      *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Define LDA
      *
     C     *DTAARA       DEFINE                  LDA
      *
      *
      ** Receive Parameter List
      *
     C     *ENTRY        PLIST
     C                   PARM                    PADLN             6            Deal Number
     C                   PARM                    PASID             1            Deal Side
     C                   PARM                    FXDY1             1 0
     C                   PARM                    PDATE             5 0
      *
      ** Initialise LDA field.
      *
     C                   MOVEL     'DL1658'      DBPGM
      *
      ** Key List to access data from file PF/DLDOISPD via
      ** DLDOISL2
      *
     C     KKON3         KLIST
     C                   KFLD                    KDLN              6 0
     C                   KFLD                    KSID              1
     C                   KFLD                    KDAT              5 0
      *
     C     KKON2         KLIST
     C                   KFLD                    KDLN
     C                   KFLD                    KSID
      *
      ** Initialise all working fields
      *
     C                   MOVE      *BLANKS       RURPT                          Name of Bank
     C                   MOVE      *BLANKS       RMRDT                          Midas Run Date
     C                   MOVE      *BLANKS       RBRCD                          Branch Code
     C                   MOVE      *BLANKS       RBRNM                          Branch Name
     C                   Z-ADD     *ZEROS        RDLNO                          Deal Number
     C                   MOVE      *BLANKS       RCRNM                          Customer Name
     C                   MOVE      *BLANKS       RCRTN                          Town Name
     C                   MOVE      *BLANKS       RSCUR                          Side Currency
     C                   Z-ADD     *ZEROS        RDDAT                          Deal Date
     C                   Z-ADD     *ZEROS        RVDAT                          Value Date
     C                   Z-ADD     *ZEROS        RMDAT                          Maturity Date
     C                   MOVE      *BLANKS       RSIDE                          Deal Side
     C                   MOVE      *BLANKS       RBSDT                          Date
     C                   Z-ADD     *ZEROS        RBSRT                          Base Rate
     C                   Z-ADD     *ZEROS        RCLRT                          Calculated Rate
     C                   Z-ADD     *ZEROS        RCPRT                          Compounding Rate
     C                   Z-ADD     *ZEROS        RINRT                          Interest Date
     C                   MOVE      *BLANKS       RPRIN                          Principle Amnt
     C                   MOVE      *BLANKS       RSETA                          Settlement Amt
     C**********           Z-ADD*ZEROS    WCNUM   60       Customer Number                    CSD027
     C                   Z-ADD     *ZEROS        WSLIP             5 0          Strt/Last P Dat
     C                   Z-ADD     *ZEROS        RCOUNT            5 0          Record count
      *
      ** Fields used to make call to Access programs.
      *
     C                   MOVE      *BLANKS       WKYST             7
      *
      ** Call Access Program to obtain Banks details from PF/SDBANKPD
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '       '     PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Handle Database Error.
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     POPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                     MD030364
      ** Check Dealing ICD access object                                                    MD030364
      *                                                                                     MD030364
     C                   CALL      'AODEALR1'                                               MD030364
     C                   PARM      *BLANKS       PRTCD                                      MD030364
     C                   PARM      '*FIRST '     POPTN                                      MD030364
     C     SDDEAL        PARM      SDDEAL        DSSDY                                      MD030364
                                                                                            MD030364
     C                   IF        PRTCD <> *BLANKS                                         MD030364
     C     *LOCK         IN        LDA                                                      MD030364
     C                   EVAL      DBFILE = 'SDDEALPD'                                      MD030364
     C                   EVAL      DBASE = 5                                                MD030364
     C                   EVAL      DBKEY = POPTN                                            MD030364
     C                   OUT       LDA                                                      MD030364
     C                   EXSR      *PSSR                                                    MD030364
     C                   ENDIF                                                              MD030364
      *
      ** Obtain Banks Name or User Report Title and Midas Run Date
      *
     C                   MOVEL     BJURPT        RURPT                          Bank's Name
     C                   MOVEL     BJMRDT        RMRDT                          Midas Day No.
      *
      ** Check System Date Format, DDMMYY (*IN98 off)
      ** MMDDYY (*IN98 on)
      *
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      '1'           *IN98
     C                   ENDIF
      *
      ** RCF Processing for Printer File
      *
     C                   EXSR      SRRCFP
      *
      ** Report Work fields.
      *
     C                   Z-ADD     0             RQDLN1            3 0
     C                   Z-ADD     0             DIFLN1            3 0
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRPROC
      *****************************************************************
      *                                                               *
      *  SRPROC - Subroutine to do the Detail Processing.             *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *  SRREPT - Process Report Lines                                *
      *  SREND  - Write End of Report                                 *
      *  ZDATE2 - Convert Midas day number into DDMMYY format         *
      *                                                               *
      *****************************************************************
      *
     C     SRPROC        BEGSR
      *
      ** Chain to PF/DEALSDG via logical file DEALS using record
      ** Format name DEALSDGF
      *
     C                   MOVEL     PADLN         DLNON             6 0
      *
     C     DLNON         CHAIN     DEALSDGF                           50
      *
      ** For OUR side of the deal move the OUR START/LAST Interest
      ** Pay Date into a working field
     C     PASID         IFEQ      'O'
     C                   Z-ADD     USLIP         WSLIP
     C                   ENDIF
      *
      ** For THEIR side of the deal move the THEIR START/LAST
      ** Interest Pay Date into a working field
      *
     C     PASID         IFEQ      'T'
     C                   Z-ADD     TSLIP         WSLIP
     C                   ENDIF
      *
     C                   Z-ADD     DLNON         KDLN
     C                   MOVE      PASID         KSID
     C                   Z-ADD     WSLIP         KDAT
      *
      ** Read record from File DLDOISPD via logical file DLDOISL0
      *
     C     KKON3         SETLL     DLDOISD0
     C     KKON2         READE     DLDOISL2                               89
      *
      ** Do Until End of File.
      *
     C     *IN89         DOUEQ     *ON
     C     L1DLNO        ORNE      DLNON
     C     L1OTCD        ORNE      PASID
      *                                                                                       204923
      ** If Rate Fix Days Adjustment is not 0 and record date is equal                        209171
      ** to the previous working day, do not report this record                               209171
      *                                                                                       209171
     C********** FXDY1     ORNE 0                                                      204923 209171
     C     FXDY1         IFNE      0
     C     L1BSDT        ANDEQ     PDATE
      *                                                                                       209171
      ** But if the rate for the deal has been fixed, the record can be reported              209171
      *                                                                                       209171
     C     L1DLNO        CHAIN     DLOISSL3                           56
     C     *IN56         IFEQ      '0'
     C     L5RFIN        ANDNE     'Y'
      *                                                                                       209171
     C     *IN56         OREQ      '0'
     C     L5RFIN        ANDEQ     'Y'
     C     KSID          ANDEQ     'O'
     C     UNIPD         ANDNE     PDATE
      *                                                                                       209171
     C     *IN56         OREQ      '0'
     C     L5RFIN        ANDEQ     'Y'
     C     KSID          ANDEQ     'T'
     C     TNIPD         ANDNE     PDATE
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
      *
      ** Count records read.
      *
     C                   ADD       1             RCOUNT
      *
      ** Extract relevant data from file, for printing.
      *
     C                   Z-ADD     L1DLNO        RDLNO                          Deal Number
     C                   Z-ADD     L1BSRT        RBSRT                          Base Rate
     C                   Z-ADD     L1CLRT        RCLRT                          Calculated Rate
     C                   Z-ADD     L1CPRT        RCPRT                          Compoundng Rate
      *
     C     L1OTCD        IFEQ      'O'                                          OIS on Our Side
     C                   MOVEL(P)  'OUR'         RSIDE
     C                   MOVE      UCUCY         RSCUR                          Our Currency
     C                   ELSE
     C                   MOVEL     'THEIR'       RSIDE                          OIS on Their
     C                   MOVE      TCUCY         RSCUR                          Their Currency
     C                   ENDIF
      *
     C                   EXSR      SRCURR
      *
      ** Round off Interest Rate to the OIS Interest Rate
      ** Decimal Places when Interest Amount is not zero
      *
     C                   Z-ADD     L1INRT        WINRT            11 7
      *
     C     L1AMNT        IFNE      0
     C                   SELECT
     C     A6IRDP        WHENEQ    0
     C                   Z-ADD(H)  L1INRT        WDEC0            11 0
     C                   Z-ADD     WDEC0         WINRT
     C     A6IRDP        WHENEQ    1
     C                   Z-ADD(H)  L1INRT        WDEC1            11 1
     C                   Z-ADD     WDEC1         WINRT
     C     A6IRDP        WHENEQ    2
     C                   Z-ADD(H)  L1INRT        WDEC2            11 2
     C                   Z-ADD     WDEC2         WINRT
     C     A6IRDP        WHENEQ    3
     C                   Z-ADD(H)  L1INRT        WDEC3            11 3
     C                   Z-ADD     WDEC3         WINRT
     C     A6IRDP        WHENEQ    4
     C                   Z-ADD(H)  L1INRT        WDEC4            11 4
     C                   Z-ADD     WDEC4         WINRT
     C     A6IRDP        WHENEQ    5
     C                   Z-ADD(H)  L1INRT        WDEC5            11 5
     C                   Z-ADD     WDEC5         WINRT
     C     A6IRDP        WHENEQ    6
     C                   Z-ADD(H)  L1INRT        WDEC6            11 6
     C                   Z-ADD     WDEC6         WINRT
     C                   ENDSL
     C                   ENDIF
      *
     C                   Z-ADD     WINRT         RINRT                          Interest Rate
      *
      ** Convert Midas day number into DDMMYY format
      *
     C                   Z-ADD     L1BSDT        ZDAYNO            5 0
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         RBSDT
      *
      ** Process Report
      *
     C                   EXSR      SRREPT
      *
      ** Call ZEDIT for fields where decimal places depend on deal
      ** currency
      *
     C                   Z-ADD     A6NBDP        ZADEC
     C                   MOVE      L1PRIN        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        RPRIN
      *
     C                   Z-ADD     A6NBDP        ZADEC
     C                   MOVE      L1AMNT        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        RSETA
      *
     C     L1AMNT        IFEQ      *ZERO
     C                   MOVE      *BLANKS       RSETA
     C                   ENDIF
      *
      ** Print Detail
      *
     C                   EXSR      SRPRNT
      *
      ** Read next record.
      *
     C                   READ      DLDOISL2                               89
      *
      ** End of Do Until, End of Valid Records.
      *
     C                   ENDDO
      *
      ** End of file so write trailer
      *
     C                   EXSR      SREND
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRREPT
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRREPT - Process Report.                                     *
      *                                                               *
      *  Called By: SRPROC                                            *
      *                                                               *
      *  Calls    : SRBRCH, SRDEAL, SRCUST, SRCURR, SRPRNT            *
      *                                                               *
      *****************************************************************
      *
     C     SRREPT        BEGSR
      *
      ** Retrieve Branch Code and Branch Name.
      *
     C                   EXSR      SRBRCH                                       New Branch Info
      *
      ** Retrieve Deal informations from file DEALSDG.
      *
     C                   EXSR      SRDEAL                                       New Deal Info
      *
      ** Retrieve Customer details.
      *
     C                   EXSR      SRCUST                                       New Custom Info
      *
      ** Retrieve Currency code detail from file SDCURRPD.
      *
     C                   EXSR      SRCURR
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRPRNT
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPRNT - Subroutine to decide what format needs to be printed*
      *                                                               *
      *  Called By: SRREPT                                            *
      *                                                               *
      *  Calls    : SRRECD, SRNEWP                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRPRNT        BEGSR
      *
     C     RCOUNT        IFEQ      1
     C                   EXSR      SRNEWP
     C                   EXSR      SRRECD
     C                   ELSE
      *
     C                   EXSR      SRRECD
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRNEWP
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNEWP - Subroutine to print a new page.                     *
      *                                                               *
      *  Called By: SRPRNT                                            *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRNEWP        BEGSR
      *
     C                   WRITE     DL1658R1
     C                   WRITE     DL1658R3
     C                   WRITE     DL1658R2
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRRECD
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRECD - Subroutine to Write a Detail record to the Report.  *
      *                                                               *
      *  Called By: SRPRNT                                            *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRRECD        BEGSR
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     DL1658R1                                     Page Header
     C                   WRITE     DL1658R3                                     Customer Detail
     C                   WRITE     DL1658R2
     C                   ENDIF
      *
      ** Write out Detail Record.
      *
     C                   WRITE     DL1658R4                                     Deal Detail
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SREND
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREND - Subroutine to Write End of Report.                   *
      *                                                               *
      *  Called By: SRPROC                                            *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SREND         BEGSR
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     4             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     DL1658R1
     C                   ENDIF
      *
      ** Write Trailer
      *
     C                   WRITE     DL1658R5
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRBRCH
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBRCH - Subroutine to retrieve Branch Code and Branch Name  *
      *           from file SDBRCHPD                                  *
      *                                                               *
      *  Called By: SRREPT                                            *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRBRCH        BEGSR
      *
     C**********           CALL 'AOBRCHR0'                                                    CGL029
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRTCD                          Return Code
     C                   PARM      '*KEY   '     POPTN                          Option
     C                   PARM      L1BRCA        PBRKY             3            Key
     C     SDBRCH        PARM      SDBRCH        DSSDY                          Return Data
      *
      ** Database error if not found
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   MOVEL     PBRKY         DBKEY
     C                   Z-ADD     2             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      A8BRCD        RBRCD                          Branch Code
     C                   MOVE      A8BRNM        RBRNM                          Branch Name
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRDEAL
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDEAL - Subroutine to retrieve Deal Information from file   *
      *           DEALSDG                                             *
      *                                                               *
      *  Called By: SRREPT                                            *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRDEAL        BEGSR
      *
      ** Convert Midas day number into DDMMYY format
      *
     C                   Z-ADD     DDAT          ZDAYNO
     C                   EXSR      ZDATE2
     C                   Z-ADD     ZDATE         RDDAT                          Deal Date
      *
     C                   Z-ADD     VDAT          ZDAYNO
     C                   EXSR      ZDATE2
     C                   Z-ADD     ZDATE         RVDAT                          Value Date
      *
     C                   Z-ADD     MDAT          ZDAYNO
     C                   EXSR      ZDATE2
     C                   Z-ADD     ZDATE         RMDAT                          Maturity Date
      *
     C     L1OTCD        IFEQ      'O'                                          OIS on Our Side
     C                   MOVEL(P)  'OUR'         RSIDE
     C                   MOVE      UCUCY         RSCUR                          Our Currency
     C                   ELSE
     C                   MOVEL     'THEIR'       RSIDE                          OIS on Their
     C                   MOVE      TCUCY         RSCUR                          Their Currency
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRCUST
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCUST - Subroutine to obtain customer details from file     *
      *           SDCUSTPD                                            *
      *                                                               *
      *  Called By: SRREPT                                            *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRCUST        BEGSR
      *
     C                   MOVEL     CNUM          PCNKY
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCNKY            10
     C                   PARM                    PKYSTS            7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
      *
      ** Database error if not found
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     PCNKY         DBKEY
     C                   Z-ADD     3             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      BBCRNM        RCRNM                          Customer's Name
     C                   MOVE      BBCRTN        RCRTN                          Reporting Town
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRCURR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCURR - Subroutine to retrieve Currency detail from file    *
      *           SDCURRPD                                            *
      *                                                               *
      *  Called By: SRPROC                                            *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRCURR        BEGSR
      *
      ** Call access program to obtain Number of Decimal places for
      ** Currency
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG    '    PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM                    RSCUR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANK
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     4             DBASE
     C                   MOVEL     RSCUR         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/*PSSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      ** Check to see that *PSSR has not already been called.
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
      *
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   ENDIF
      *
      ** If *PSSR already run, then just end the program here.
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRRCFP
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCFP  - Subroutine to register DL1658P1 via RCF.           *
      *                                                               *
      *  Called By: SRINIT                                            *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRRCFP        BEGSR
      *
      ** Ensure Report Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUM1        ZSNUM             6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ              5
     C                   PARM                    SENTY             3
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM      *BLANKS       ZSERR             1
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRTERM
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTERM   - Subroutine to Terminate program                   *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRTERM        BEGSR
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDSR
      *
      *****************************************************************
      *****************************************************************
      /TITLE SR/ZDATE2
     C*COPY*ZSRSRC,ZDATE2Z2*********************************                                  220859
     C/COPY ZSRSRC,ZDATE2Z2LE                                                                 220859
      /EJECT
     C*COPY*ZSRSRC,ZEDITZ22*********************************                                  220859
     C/COPY ZSRSRC,ZEDITZ2LE                                                                  220859
      /EJECT
**  CPY@
(c) Finastra International Limited 2001
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
