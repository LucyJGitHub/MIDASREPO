      *****************************************************************
/*STD *  RPGBASEBND                                                   *                       220859
/*EXI *  TEXT('Midas DL OIS Interest Rate Correction')                *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL1672 - OIS Interest Rate Correction                        *
      *                                                               *
      *  Function:  This program will recalculate the interest rate   *
      *             using the new rate.                               *
      *                                                               *
      *  Called By: DL1642 - OIS Input Cycle Rate Fixing              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CER059             Date 19Jul10               *
      *                 CER016A            Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 05Jul06               *
      *                 220859             Date 02Mar06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CIR013             Date 22Apr05               *
      *                 CDL028             Date 07Feb05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 204923  *CREATE    Date 29Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER016A - German Interest Calculation: Upgarde of FGE059     *
      *            to Midas Plus (Recompile)                          *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  220859 - Increase the size of Compounding Rate from          *
      *           7 to 15 decimal places. DL1672 was converted to ILE *
      *           due to the change in the number of decimal places.  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CIR013 - Additional Calculation Method for FRA/IRS/CCF       *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  204923 - Rate Fix Days Adjustment (OIS)                      *
      *                                                               *
      *****************************************************************
      *
      ** Logical file built over DEALSDG
     FDEALS     IF   E           K DISK
      *
      ** Logical file built over PF/DLDOISPD  decending
     FDLDOISL1  UF   E           K DISK
     F                                     COMMIT
      *
      *****************************************************************
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D/COPY ZSRSRC,ZDATE9Z1LE                                                                 CIR013
     D/COPY ZSRSRC,ZFEB29Z1LE                                                                 220859
      *
      *****************************************************************
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
     D LDA           E DS           256    EXTNAME(LDA)
      *
      *
      ** Data Structure to receive Deal details
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      *
      ** Data Structure to receive Deal details
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      *
      ** Data Structure to receive SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** Short data structure for access objects
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Short data structure for access objects
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
     D/COPY ZSRSRC,ZDATE9Z2LE                                                                 CIR013
     D/COPY ZSRSRC,ZINTDYZ1LE                                                                 CIR013
      /EJECT
      *****************************************************************
      *                                                               *
      *    M A I N     P R O C E S S I N G                            *
      *                                                               *
      *****************************************************************
      *
     C                   EXSR      SRUPDP
      *
      ** Termination Processing
      *
     C                   MOVE      '1'           *INLR
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPDP - Update previous records                             *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls    : AOBSRTPD, *PSSR                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRUPDP        BEGSR
      *
      ** Access Deals File
      *
     C     PDLNO         CHAIN     DEALSDGF                           52
      *
     C     *IN52         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'DEALSDG'     DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL(P)  PDLNO         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PSIDE         IFEQ      'O'
     C                   MOVEL     UBRTT         PBRTT
     C                   ELSE
     C                   MOVEL     TBRTT         PBRTT
     C                   ENDIF
      *
     C     KKLNO         CHAIN     DLDOISL1                           89
      *
      ** Access Base Rate Details
      *
     C                   CALL      'AOBSRTR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY  '      POPTN             7
     C                   PARM      UCUCY         PCURR             3
     C                   PARM                    PBRTT             2
     C     SDBSRT        PARM      SDBSRT        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBSRTPD'    DBFILE
     C                   MOVEL     UCUCY         WKEY              5
     C                   MOVE      PBRTT         WKEY
     C                   MOVEL     WKEY          DBKEY
     C                   Z-ADD     2             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If RUNDAT is greater or equal to Value Date of Rate Change use
      ** New Base Rate, otherwisw use Current Base Rate
      *
     C     L1BSDT        IFGE      BAVDRC
     C                   Z-ADD     BANBRT        WWRATE           12 9
     C                   ELSE
     C                   Z-ADD     BACBSR        WWRATE
     C                   ENDIF
      *
     C                   Z-ADD     WWRATE        L1BSRT
     C                   UPDATE    DLDOISD0
      *
     C                   READ      DLDOISL1                               89
     C***********        Z-ADD     L1CPRT        WCPRT            12 9                        220859
     C                   Z-ADD     L1CPRT        WCPRT            1815                        220859
      *
     C                   READP     DLDOISL1                               89
      *
      ** Calculate the new componding rate and interest rate for each
      ** of the following records for this deal.
      ** Apply spread to the old base rate on the deal
      *
     C                   Z-ADD     L1BSRT        WRATE            11 7
      *
      ** Spread for Our side.
      *
     C     L1OTCD        IFEQ      'O'
      *
     C     USPIN         IFEQ      'A'
     C     L1BSRT        ADD       URTSP         WRATE
     C                   ENDIF
      *
     C     USPIN         IFEQ      'S'
     C     L1BSRT        SUB       URTSP         WRATE
     C                   ENDIF
      *
     C     USPIN         IFEQ      'P'
     C     L1BSRT        MULT      URTSP         WORK             11 7
     C     WORK          DIV       100           WORK
     C     L1BSRT        ADD       WORK          WRATE
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Spread for Their side
      *
     C     TSPIN         IFEQ      'A'
     C     L1BSRT        ADD       TRTSP         WRATE
     C                   ENDIF
      *
     C     TSPIN         IFEQ      'S'
     C     L1BSRT        SUB       TRTSP         WRATE
     C                   ENDIF
      *
     C     TSPIN         IFEQ      'P'
     C     L1BSRT        MULT      TRTSP         WORK             11 7
     C     WORK          DIV       100           WORK
     C     L1BSRT        ADD       WORK          WRATE
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Multiply the adjusted rate by the number of applicable days
      ** on the deals extension file.
      *
     C     WRATE         MULT(H)   L1APDY        WRESA            12 9
      *                                                                                       CIR013
     C     L1OTCD        IFEQ      'O'                                                        CIR013
     C     UICBS         ANDEQ     9                                                          CIR013
     C     L1OTCD        ORNE      'O'                                                        CIR013
     C     TICBS         ANDEQ     9                                                          CIR013
      *                                                                                       CIR013
     C     L1OTCD        IFEQ      'O'                                                        CIR013
      * Our Last Interest Payment Date                                                        CIR013
     C                   Z-ADD     USLIP         @@DAYN            5 0                        CIR013
     C                   ELSE                                                                 CIR013
      * Their Last Interest Payment Date                                                      CIR013
     C                   Z-ADD     TSLIP         @@DAYN                                       CIR013
     C                   ENDIF                                                                CIR013
      *                                                                                       CIR013
      * Convert start date to YYYYMMDD format                                                 CIR013
     C                   EXSR      ZDATE9                                                     CIR013
     C                   Z-ADD     @@VDT         ZZDATA                                       CIR013
      *                                                                                       CIR013
      * Convert end date to YYYYMMDD format                                                   CIR013
     C                   Z-ADD     L1BSDT        @@DAYN                                       CIR013
     C                   EXSR      ZDATE9                                                     CIR013
     C                   Z-ADD     @@VDT         ZZDATB                                       CIR013
      *                                                                                       CIR013
      * Check for the existence of any February 29th within the dates                         CIR013
     C                   EXSR      #FEB29                                                     CIR013
     C                   ENDIF                                                                CIR013
      *
      ** Divide by Our/Their Calculation Basis
      *
     C     L1OTCD        IFEQ      'O'
      *
     C     UICBS         IFEQ      1
     C     UICBS         OREQ      4
     C     UICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'N'                                                        CIR013
     C     WRESA         DIV(H)    36500         WRESB            12 9
     C                   ENDIF
      *
     C     UICBS         IFEQ      2
     C     UICBS         OREQ      3
     C     UICBS         OREQ      5
     C     CIR004        OREQ      'Y'
     C     UICBS         ANDEQ     7
     C     WRESA         DIV(H)    36000         WRESB
     C                   ENDIF
      *
     C     UICBS         IFEQ      6
     C     UICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'Y'                                                        CIR013
     C     WRESA         DIV(H)    36600         WRESB
     C                   ENDIF
      *
     C                   ELSE
      *
     C     TICBS         IFEQ      1
     C     TICBS         OREQ      4
     C     TICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'N'                                                        CIR013
     C     WRESA         DIV(H)    36500         WRESB
     C                   ENDIF
      *
     C     TICBS         IFEQ      2
     C     TICBS         OREQ      3
     C     TICBS         OREQ      5
     C     CIR004        OREQ      'Y'
     C     TICBS         ANDEQ     7
     C     WRESA         DIV(H)    36000         WRESB
     C                   ENDIF
      *
     C     TICBS         IFEQ      6
     C     TICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'Y'                                                        CIR013
     C     WRESA         DIV(H)    36600         WRESB
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Add 1 to the result.
      *
     C     WRESB         ADD       1             WRESC            12 9
      *
      ** Multiply the result by the compounding rate from the previous
      ** record to get this records compounding rate.
      *
     C*****WRESC         MULT(H)   WCPRT         WRESD            12 9                        220859
     C     WRESC         MULT(H)   WCPRT         WRESD            1815                        220859
     C                   Z-ADD(H)  WRESD         L1CPRT
      *
      ** Subtract one from the result.
      *
     C*****WRESD         SUB       1             WRESE            12 9                        220859
     C     WRESD         SUB       1             WRESE            1815                        220859
      *
      ** Multiply by Our/Their Calculation Basis
      *
     C     L1OTCD        IFEQ      'O'
      *
     C     UICBS         IFEQ      1
     C     UICBS         OREQ      4
     C     UICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'N'                                                        CIR013
     C*****WRESE         MULT(H)   36500         WRESF            12 9                        220859
     C     WRESE         MULT(H)   36500         WRESF            1815                        220859
     C                   ENDIF
      *
     C     UICBS         IFEQ      2
     C     UICBS         OREQ      3
     C     UICBS         OREQ      5
     C     CIR004        OREQ      'Y'
     C     UICBS         ANDEQ     7
     C     WRESE         MULT(H)   36000         WRESF
     C                   ENDIF
      *
     C     UICBS         IFEQ      6
     C     UICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'Y'                                                        CIR013
     C     WRESE         MULT(H)   36600         WRESF
     C                   ENDIF
      *
     C                   ELSE
      *
     C     TICBS         IFEQ      1
     C     TICBS         OREQ      4
     C     TICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'N'                                                        CIR013
     C     WRESE         MULT(H)   36500         WRESF
     C                   ENDIF
      *
     C     TICBS         IFEQ      2
     C     TICBS         OREQ      3
     C     TICBS         OREQ      5
     C     CIR004        OREQ      'Y'
     C     TICBS         ANDEQ     7
     C     WRESE         MULT(H)   36000         WRESF
     C                   ENDIF
      *
     C     TICBS         IFEQ      6
     C     TICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'Y'                                                        CIR013
     C     WRESE         MULT(H)   36600         WRESF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Find number of days since last payment.
      *
     C     L1OTCD        IFEQ      'O'
     C     L1BSDT        SUB       USLIP         WNUMD             3 0
     C                   ELSE
     C     L1BSDT        SUB       TSLIP         WNUMD
     C                   ENDIF
      *
      ** Divide the result by the number of days since last interest
      ** payment date.
      *
     C*****WRESF         DIV(H)    WNUMD         WRESG            12 9                        220859
     C     WRESF         DIV(H)    WNUMD         WRESG            1815                        220859
      *
      ** Update the extension file with this compound rate and interest
      ** rate.
      *
     C                   Z-ADD(H)  WRESG         L1INRT
     C                   Z-ADD(H)  WRESG         PRATE
     C                   UPDATE    DLDOISD0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *  Called By: None                                              *
      *                                                               *
      *  Calls    : AODEALR0, AOSARDR0, *PSSR                         *
      *                                                               *
      *****************************************************************
      *
      ** Perform initial processing
      *
     C     *INZSR        BEGSR
      *
      ** Receive Parameter List
      *
     C     *ENTRY        PLIST
     C                   PARM                    PDLNO             6 0
     C                   PARM                    PSIDE             1
     C                   PARM                    PRATE            11 7
     C                   PARM                    PRTCDE            1
      *
      *
      **  Set up key list for OIS Deals Interest Rate File
      *
     C     KKLNO         KLIST
     C                   KFLD                    PDLNO
     C                   KFLD                    PSIDE
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Initialise LDA field.
      *
     C     *DTAARA       DEFINE                  LDA
     C                   MOVEL     'DL1672'      DBPGM
      *
      ** Access Dealing ICD, divide Hong Kong Tax rate field and divide
      ** by 100 to get working tax rate TAXR.
      *
     C**********           CALL 'AODEALR0'                                                    CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C********** SDDEAL    PARM SDDEAL    DSFDY                                               CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
     C     PRTCD         IFNE      *BLANKS
     C                   Z-ADD     3             DBASE
     C                   MOVE      'SDDEALPD'    DBFILE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     BNHKTR        DIV       100           TAXR              5 4
      *
      ** Check if switchable feature CIR004 is on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CIR004'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF    '
     C     *LOCK         IN        LDA
     C                   Z-ADD     4             DBASE
     C                   MOVE      'SCSARDPD'    DBFILE
     C                   MOVEL     'CIR004'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CIR004            1
     C                   ELSE
     C                   MOVEL     'N'           CIR004
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
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
     C     WERR          IFEQ      *BLANK
     C                   MOVE      'Y'           WERR              1
     C                   SETON                                        U7U8LR
     C                   MOVE      'X'           PRTCDE
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
     C/COPY ZSRSRC,ZDATE9Z3LE                                                                 CIR013
      /EJECT                                                                                  CIR013
     C***/COPY ZSRSRC,ZFEB29LE                                                         CIR013 220859
     C/COPY ZSRSRC,ZFEB29Z2LE                                                                 220859
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
** @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN                        CIR013
00366007310109601461
** @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR                           CIR013
00000000310005900090001200015100181002120024300273003040033400365
