     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *                       220859
/*EXI *  TEXT('Midas DL OIS Interest Calculation Utility COB')        *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL1665 - Interest Calculation Utility for COB                *
      *                                                               *
      *  Function:  This program realises that in the calculation of  *
      *             interest amounts, a change to the deal principal  *
      *             amount may have taken place between the 'from'    *
      *             and 'to' dates.                                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CDL093             Date 08Apr14               *
      *                 AR996895           Date 25Nov12               *
      *                 263666             Date 01Feb10               *
      *                 CER059             Date 19Jul10               *
      *                 CER016A            Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 246141             Date 26Mar07               *
      *                 164847             Date 30Nov06               *
      *                 BUG12990           Date 05Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242286             Date 25Sep06               *
      *                 CDL049             Date 05Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 220859             Date 01Mar06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CIR013             Date 26Apr05               *
      *                 CDL028             Date 07Feb05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 204923             Date 29Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CIR007  *CREATE    Date 11May01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CDL093 - MM Interest calculation type 9.                     *
      *           Amended to comply with changes added in /GLINTCZ1LE *
      *  AR996895 - Incorrect acrrual interest calculation            *
      *             (Child: AR996897) (Recompile)                     *
      *  263666 - Recompiled due to changes in ZINTDYZ2               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER016A - German Interest Calculation: Upgarde of FGE059     *
      *            to Midas Plus (Recompile)                          *
      *  246141 - Recompiled due to changes in ZINTDYZ2               *
      *  164847 - Recompile over changes in /COPY ZINTDYZ2LE.         *
      *  BUG12990 - Recompiled due to changes in ZINTDYZ2/ZINTDYZ2LE  *
      *  242286 - Recompile over changes in /COPY ZINTDYZ2LE.         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  220859 - Increase the size of Compounding Rate from          *
      *           7 to 15 decimal places. DL1665 was converted to ILE *
      *           due to the change in the number of decimal places.  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CIR013 - Additional Calculation Method for FRA/IRS/CCF       *
      *           Recompile over GLINTC and ZINTDY.                   *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  204923 - Rate Fix Days Adjustment (OIS)                      *
      *  CIR007 - Overnight Index Swaps                               *
      *                                                               *
      *****************************************************************
     FDEALS     IF   E           K DISK
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDCF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     FDLDOISL1  IF   E           K DISK
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  70 - Chain to DEALSDG                                        *
      *  71 - Chain to DLDOISPD                                       *
      *  72 - EoF on DLDOISPD                                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  *INZSR   - Program Initialisation                            *
      *  SRPROC   - Detail Processing                                 *
      *  SRPAMT   - Detail Processing                                 *
      *  SRTOIN   - Detail Processing                                 *
      *  SRTERM   - Termination Processing                            *
      *****************************************************************
      /EJECT
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D*COPY ZSRSRC,ZDATE9Z1                                                                   220859
     D/COPY ZSRSRC,ZDATE9Z1LE                                                                 220859
     D/COPY ZSRSRC,ZFEB29Z1LE                                                                 CDL093
      /EJECT
      *
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
      ** Data Area giving Installation Control Details
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Program Status Data Structure
     D PSDS           SDS
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  204923
      ** Dummy record format for Bank Details                                                 204923
      *                                                                                       204923
      ** Currency details accessed via access program
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Long data structure for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *                                                                                       204923
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     204923
      ** Short data structure for access programs                                             204923
      *
      /EJECT
     D*COPY ZSRSRC,ZINTDYZ1                                                                   220859
     D/COPY ZSRSRC,ZINTDYZ1LE                                                                 220859
      /EJECT
     D*COPY ZSRSRC,ZDATE9Z2                                                                   220859
     D/COPY ZSRSRC,ZDATE9Z2LE                                                                 220859
      /EJECT
     D*COPY ZSRSRC,ZDAT10Z1                                                                   220859
     D/COPY ZSRSRC,ZDAT10Z1LE                                                                 220859
      *
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      ** Perform detail processing
      *
     C                   EXSR      SRPROC
      *
      ** Perform termination processing
      *
     C                   EXSR      SRTERM
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
      *****************************************************************
      *                                                               *
      *  *INZSR   - Subroutine to do Program Initialisation.          *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Receive parameter list
      *
     C     *ENTRY        PLIST
     C                   PARM                    PDLNO             6 0
     C                   PARM                    POTCD             1
     C                   PARM                    PFRDAT            5 0
     C                   PARM                    PTODAT            5 0
     C                   PARM                    PINRT
     C                   PARM                    PRTNC
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      **  Set up key list for OIS Deals Interest Rate File
     C     OISKY1        KLIST
     C                   KFLD                    PDLNO
     C                   KFLD                    POTCD
     C                   KFLD                    PTODAT
      *
      ** Set up key list for LF/DEALS
      *
     C     OISKY2        KLIST
     C                   KFLD                    PDLNO
     C                   KFLD                    POTCD
      *
      ** Initialise all working fields
      *
     C                   MOVEL     'DL1665'      DBPGM
     C                   Z-ADD     0             PINRT            13 0
     C                   MOVE      *BLANKS       PRTNC             1
     C                   Z-ADD     0             WINTR            15 2
     C                   Z-ADD     0             WFRDT             5 0
     C                   Z-ADD     0             DBASE
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
      *                                                                                       204923
      ** Access Bank Details                                                                  204923
      *                                                                                       204923
     C                   CALL      'AOBANKR0'                                                 204923
     C                   PARM      *BLANKS       PRTCD                                        204923
     C                   PARM      '*FIRST '     POPTN                                        204923
     C     SDBANK        PARM      SDBANK        DSFDY                                        204923
      *                                                                                       204923
      ** Database Error.                                                                      204923
      *                                                                                       204923
     C     PRTCD         IFNE      *BLANKS                                                    204923
     C                   MOVE      'SDBANKPD'    DBFILE                                       204923
     C                   Z-ADD     2             DBASE                                        204923
     C                   MOVEL     '*FIRST  '    DBKEY                                        204923
     C                   EXSR      *PSSR                                                      204923
     C                   ENDIF                                                                204923
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SRPROC   - Performs detail processing                        *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls: SRPAMT                                                *
      *         SRTOIN                                                *
      *                                                               *
      *****************************************************************
      *
     C     SRPROC        BEGSR
      *
     C     PDLNO         CHAIN     DEALSDGF                           70
     C     *IN70         IFEQ      '1'
     C                   Z-ADD     1             DBASE
     C                   MOVEL     'DEALSDG'     DBFILE
     C                   MOVEL     PDLNO         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       204923
      ** Access Currency Details                                                              204923
      *                                                                                       204923
     C                   CALL      'AOCURRR0'                                                 204923
     C                   PARM      '*MSG    '    PRTCD             7                          204923
     C                   PARM      '*KEY    '    POPTN             7                          204923
     C                   PARM      UCUCY         PCCY              3                          204923
     C     SDCURR        PARM      SDCURR        DSSDY                                        204923
      *                                                                                       204923
     C     PRTCD         IFNE      *BLANK                                                     204923
     C                   MOVEL     'SDCURRPD'    DBFILE                                       204923
     C                   Z-ADD     3             DBASE                                        204923
     C                   MOVEL     PCCY          DBKEY                                        204923
     C                   EXSR      *PSSR                                                      204923
     C                   ENDIF                                                                204923
      *                                                                                       204923
     C     PTODAT        IFEQ      BJRDNB                                                     204923
      *                                                                                       204923
      ** If A6FXDY not equal to 0, read next record.                                          204923
      *                                                                                       204923
     C     A6FXDY        IFNE      0                                                          204923
     C     OISKY1        CHAIN     DLDOISL1                           72                      204923
     C     OISKY2        READE     DLDOISL1                               72                  204923
     C     *IN72         IFNE      '0'                                                        204923
     C                   EXSR      SRTERM                                                     204923
     C                   ELSE                                                                 204923
     C                   Z-ADD     L1BSDT        PTODAT                                       204923
     C                   ENDIF                                                                204923
     C                   ENDIF                                                                204923
     C                   ENDIF                                                                204923
      *
      ** Find record on DLDOISPD with Record Type of 'SETTLE'
      *
     C     OISKY1        CHAIN     DLDOISL1                           71
      *
      ** If record not found, terminate program
      *
     C     *IN71         IFEQ      '1'
     C                   EXSR      SRTERM
     C                   ENDIF
      *
      ** If record found, retrieve OIS Interest Rate Decimal
      ** Places in the Currencies file
      *
     C********** POTCD     IFEQ 'O'                                                           204923
     C**********           MOVE UCUCY     PCRKEY                                              204923
     C**********           ELSE                                                               204923
     C**********           MOVE TCUCY     PCRKEY                                              204923
     C**********           ENDIF                                                              204923
      **********                                                                              204923
     C**********           CALL 'AOCURRR0'                                                    204923
     C**********           PARM '*MSG   ' PRTCD   7                                           204923
     C**********           PARM '*KEY   ' POPTN   7                                           204923
     C**********           PARM           PCRKEY  3                                           204923
     C********** SDCURR    PARM SDCURR    DSSDY                                               204923
      **********                                                                              204923
     C********** PRTCD     IFNE *BLANKS                                                       204923
     C**********           MOVEL'SDCURRPD'DBFILE                                              204923
     C**********           Z-ADD2         DBASE                                               204923
     C**********           MOVELPCRKEY    DBKEY                                               204923
     C**********           EXSR *PSSR                                                         204923
     C**********           ENDIF                                                              204923
      *
      ** Round off Interest Rate to the OIS Interest Rate
      ** Decimal Places
      *
     C                   Z-ADD     L1INRT        WRATE            11 7
     C                   SELECT
     C     A6IRDP        WHENEQ    0
     C                   Z-ADD(H)  L1INRT        WDEC0            11 0
     C                   Z-ADD     WDEC0         WRATE
     C     A6IRDP        WHENEQ    1
     C                   Z-ADD(H)  L1INRT        WDEC1            11 1
     C                   Z-ADD     WDEC1         WRATE
     C     A6IRDP        WHENEQ    2
     C                   Z-ADD(H)  L1INRT        WDEC2            11 2
     C                   Z-ADD     WDEC2         WRATE
     C     A6IRDP        WHENEQ    3
     C                   Z-ADD(H)  L1INRT        WDEC3            11 3
     C                   Z-ADD     WDEC3         WRATE
     C     A6IRDP        WHENEQ    4
     C                   Z-ADD(H)  L1INRT        WDEC4            11 4
     C                   Z-ADD     WDEC4         WRATE
     C     A6IRDP        WHENEQ    5
     C                   Z-ADD(H)  L1INRT        WDEC5            11 5
     C                   Z-ADD     WDEC5         WRATE
     C     A6IRDP        WHENEQ    6
     C                   Z-ADD(H)  L1INRT        WDEC6            11 6
     C                   Z-ADD     WDEC6         WRATE
     C                   ENDSL
      *
      ** For Interest Calculations, we do not include the interest
      ** payment day (ie the SETTLE record) and so we start from the
      ** day before. Read DLDOISPD again for principal.
      *
     C     OISKY2        READE     DLDOISL1                               72
      *
     C                   Z-ADD     L1PRIN        WPRIN            13 0
     C     PTODAT        SUB       1             WTODT             5 0
      *
      ** Save Base Date from this record.
      *
     C                   Z-ADD     L1BSDT        WFRDT
      *
      ** Read DLDOISPD until From Date reached or end of deals with
      ** same OISKY2
      *
     C     PFRDAT        DOWLT     L1BSDT
     C     *IN72         ANDNE     *ON
     C                   EXSR      SRPAMT
     C                   ENDDO
      *
      ** Subtract 1 from from date to give correct number of days.
      *
     C     PFRDAT        SUB       1             WFRDT
      *
      ** Call SRTOIN to calculate interest for final principal change
      *
     C                   EXSR      SRTOIN
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SRPAMT   - Subroutine to check for changes in the Principal  *
      *             Amount.                                           *
      *                                                               *
      *  Called By: SRPROC                                            *
      *  Calls: GLINTC                                                *
      *         SRTOIN                                                *
      *                                                               *
      *****************************************************************
     C     SRPAMT        BEGSR
      *
      ** If the principal on the record read changes then calculate
      ** the amount of interest owed on that principal amount
      *
     C     L1PRIN        IFNE      WPRIN
      *
      ** The Interest Calculation To Date must be one less than the
      ** Base Date on the record previously read.
      *
     C                   SUB       1             WFRDT
      *
     C                   EXSR      SRTOIN
      *
      ** Overwrite Todate and Principal with new amounts to be
      ** compared to
      *
     C                   Z-ADD     WFRDT         WTODT
     C                   Z-ADD     L1PRIN        WPRIN
     C                   ENDIF
      *
      ** Save record date as From Date
      *
     C                   Z-ADD     L1BSDT        WFRDT
      *
      ** Read next deal with same Deal Number and O/T indicator
      *
     C     OISKY2        READE     DLDOISL1                               72
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SRTOIN   - Subroutine to calculate total interest accrual    *
      *             amounts.                                          *
      *                                                               *
      *  Called By: SRPROC                                            *
      *  Calls: GLINTC                                                *
      *                                                               *
      *****************************************************************
     C     SRTOIN        BEGSR
      *
      ** Set up fields for call to GLINTC
      *
     C                   Z-ADD     WFRDT         ZIBEG
     C                   Z-ADD     WTODT         ZIEND
     C     L1OTCD        IFEQ      'O'
     C                   Z-ADD     UICBS         ZICALC
     C                   ELSE
     C                   Z-ADD     TICBS         ZICALC
     C                   ENDIF
     C                   Z-ADD     WPRIN         ZIAMT
     C                   Z-ADD     WRATE         ZIRATE
     C                   EXSR      GLINTC
      *
      ** Add interest amount returned form GLINTC to Total Interest
      ** Amount for this Deal
      *
     C     ZINTR         ADD       WINTR         WINTR
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SRTERM   - Subroutine to Terminate Program                   *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRTERM        BEGSR
     C                   Z-ADD(H)  WINTR         PINRT
     C                   MOVE      *BLANKS       PRTNC
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   MOVE      'X'           PRTNC
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
     C*COPY ZSRSRC,GLINTCZ1                                                                   220859
     C/COPY ZSRSRC,GLINTCZ1LE                                                                 220859
      /EJECT
     C*COPY ZSRSRC,ZINTDYZ2                                                                   220859
     C/COPY ZSRSRC,ZINTDYZ2LE                                                                 220859
      /EJECT
     C*COPY ZSRSRC,ZDATE9Z3                                                                   220859
     C/COPY ZSRSRC,ZDATE9Z3LE                                                                 220859
     C/COPY ZSRSRC,ZFEB29Z2LE                                                                 CDL093
      /EJECT
     C*COPY ZSRSRC,ZDAT10Z2                                                                   220859
     C/COPY ZSRSRC,ZDAT10Z2LE                                                                 220859
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN
00366007310109601461
** @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
00000000310005900090001200015100181002120024300273003040033400365
