      *****************************************************************
/*STD *  RPGBASEBND                                                   *                       220859
/*EXI *  TEXT('Midas DL OIS calculate interest rates for COB')        *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL1649 - OIS Calculate Interest Rates for COB                *
      *                                                               *
      *  Function:  This program finds the appropriate base rate for  *
      *             the deal currency. Then builds and writes a       *
      *             record to DLDOISPD. Also calculates and returns   *
      *             an interest rate.                                 *
      *                                                               *
      *  Called By: DL1642 - OIS Input Cycle Deal Rate Fixing         *
 
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CER059             Date 19Jul10               *
      *                 CER016             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 05Jul06               *
      *                 CPK025             Date 08Jul06               *
      *                 227171             Date 01Mar06               *
      *                 221119             Date 01Mar06               *
      *                 220859             Date 01Mar06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CIR013             Date 18Apr05               *
      *                 CDL028             Date 07Feb05               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209068             Date 11Sep02               *
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
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER016 - German Interest Calculation: Upgarde of FGE059      *
      *           to Midas Plus (Recompile)                           *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CPK025 - add /COPY ZFEB29Z1LE and corrected definition of    *
      *           @@DAYN.                                             *
      *  227171 - Applied fix 221119                                  *
      *  221119 - Interest rates not computed when local currency is  *
      *           on holiday but deal currency is not. Fix is to add  *
      *           handle such a case.                                 *
      *  220859 - Increase the size of Compounding Rate from          *
      *           7 to 15 decimal places. DL1649 was converted to ILE *
      *           due to the change in the number of decimal places.  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CIR013 - Additional Calculation Method for FRA/IRS/CCF       *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  209068 - Extend length of field WRATE to 14,9 to allow for   *
      *           large rates and/or long term backvaluation.         *
      *  CIR007 - Overnight Index Swaps                               *
      *                                                               *
      *****************************************************************
      *
     FDEALS     IF   E           K DISK
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDCF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     FDLDOISL1  UF A E           K DISK
     FDLPCSCPD  IF   E           K DISK
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  70 - Chain to DEALSDG                                        *
      *  71 - EoF on DLDOISPD                                         *
      *  72 - Chain to DLPCSCPD                                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRPROC   - Detail Processing                                 *
      *  SRPRIN   - Checks for a Principal change                     *
      *  SRTERM   - Termination Processing                            *
      *                                                               *
      *  *INZSR   - Program Initialisation                            *
      *  *PSSR    - Error Handling                                    *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*COPY*ZSRSRC,ZDATE9Z1                                                                   CIR013
     D/COPY ZSRSRC,ZDATE9Z1LE                                                                 CIR013
      *
      /SPACE 3
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Data Area giving Installation Control Details
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      *
      ** Program Status Data Structure
     D PSDS           SDS
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Base Rate Details
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      *
      ** Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
     D*COPY*ZSRSRC,ZDATE9Z2                                                                   CIR013
     D/COPY ZSRSRC,ZDATE9Z2LE                                                                 CIR013
     D*COPY*ZSRSRC,ZINTDYZ1                                                                   CIR013
     D/COPY ZSRSRC,ZINTDYZ1LE                                                                 CIR013
     D/COPY ZSRSRC,ZFEB29Z1LE                                                                 CPK025
     C/EJECT
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      ** Perform Detail Processing.
      *
     C                   EXSR      SRPROC
      *
      ** Perform Termination Processing.
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
      *  Calls: AOBANKR0                                              *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Receive Parameter List
      *
     C     *ENTRY        PLIST
     C                   PARM                    POTCD             1
     C                   PARM                    PDLNO             6 0
     C                   PARM                    PINRT
     C                   PARM                    PRTNC
     C                   PARM                    PHDAY             1                          221119
     C                   PARM                    PDATE             5 0                        221119
      *
      ** Initialise LDA field.
      *
     C                   MOVEL     'DL1649'      DBPGM
      *
      ** Initialise all working fields
      *
     C                   Z-ADD     0             PINRT            11 7
     C                   MOVE      *BLANKS       PRTNC             1
     C                   Z-ADD     0             PCNT             13 7
     C**********           Z-ADD0         WRATE  129                                          209068
     C**********         Z-ADD     0             WRATE            14 9                 209068 220859
     C                   Z-ADD     0             WRATE            2015                        220859
     C                   Z-ADD     0             WAPDY             3 0
     C                   Z-ADD     0             WINTN            11 7
     C**********         Z-ADD     0             WCOMP            12 9                        220859
     C                   Z-ADD     0             WCOMP            1815                        220859
     C                   Z-ADD     0             DBASE
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
      *
     C     OISKY1        KLIST
     C                   KFLD                    PDLNO
     C                   KFLD                    POTCD
      *
     C     PCSC          KLIST
     C                   KFLD                    DLNO
     C                   KFLD                    OTIN
     C                   KFLD                    PRDT
      *
      ** Access Bank details via access program
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '       '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     PRTCD         IFNE      *BLANK
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   Z-ADD     1             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR details file to determine if CIR004
      ** is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY '    POPTN
     C                   PARM      'CIR004'      PSARD             6
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   MOVEL     'CIR004'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CIR004            1
     C                   ELSE
     C                   MOVE      'N'           CIR004
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SRPROC   - Subroutine to do Detail Processing                *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls: AOBSRTR0                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRPROC        BEGSR
      *
     C     PDLNO         CHAIN     DEALSDGF                           70
     C     *IN70         IFEQ      '1'
     C                   MOVEL     'DEALSDG'     DBFILE
     C                   MOVEL     PDLNO         DBKEY
     C                   Z-ADD     3             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     POTCD         IFEQ      'O'
     C                   MOVE      UBRTT         PBRTT             2
     C                   ELSE
     C                   MOVE      TBRTT         PBRTT
     C                   ENDIF
      *
      ** Access appropriate Base Rate for Deal Currency
      *
     C                   CALL      'AOBSRTR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY'        POPTN             7
     C                   PARM      UCUCY         PUCUCY            3
     C                   PARM                    PBRTT             2
     C     SDBSRT        PARM      SDBSRT        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBSRTPD'    DBFILE
     C                   MOVEL     UCUCY         WKEY              5
     C                   MOVE      PBRTT         WKEY
     C                   MOVEL     WKEY          DBKEY
     C                   Z-ADD     4             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If RUNDAT is greater or equal to Value Date of Rate Change use
      ** New Base Rate, otherwisw use Current Base Rate
      *
     C     BJRDNB        IFGE      BAVDRC
     C                   Z-ADD     BANBRT        WRATE
     C                   ELSE
     C                   Z-ADD     BACBSR        WRATE
     C                   ENDIF
      *
      ** Save the Base Rate for the new record.
      *
     C                   Z-ADD     WRATE         WBSRT            11 7
      *
      ** Find most recent record for this deal on DLDOISPD
      *
     C     OISKY1        SETLL     DLDOISL1
     C                   READ      DLDOISL1                               71
      *
      ** Find Applicable Days ie RUNDAT less Date on record
      *
     C     PHDAY         IFEQ      'Y'                                                        221119
     C     PDATE         SUB       L1BSDT        WAPDY                                        221119
     C                   ELSE                                                                 221119
     C     BJRDNB        SUB       L1BSDT        WAPDY
     C                   ENDIF                                                                221119
      *
      ** Apply a Spread to the Base Rate if required
      *
     C     POTCD         IFEQ      'O'
     C     USPIN         IFEQ      'A'
     C     WRATE         ADD       URTSP         WRATE
     C                   ENDIF
     C     USPIN         IFEQ      'S'
     C     WRATE         SUB       URTSP         WRATE
     C                   ENDIF
     C     USPIN         IFEQ      'P'
     C     WRATE         MULT      URTSP         PCNT
     C     PCNT          DIV       100           PCNT
     C     WRATE         ADD       PCNT          WRATE
     C                   ENDIF
      *
     C                   ELSE
     C     TSPIN         IFEQ      'A'
     C     WRATE         ADD       TRTSP         WRATE
     C                   ENDIF
     C     TSPIN         IFEQ      'S'
     C     WRATE         SUB       TRTSP         WRATE
     C                   ENDIF
     C     TSPIN         IFEQ      'P'
     C     WRATE         MULT      TRTSP         PCNT
     C     PCNT          DIV       100           PCNT
     C     WRATE         ADD       PCNT          WRATE
     C                   ENDIF
     C                   ENDIF
      *
      ** Multiply the Base Rate by the number of Applicable Days
      *
     C     WRATE         MULT(H)   WAPDY         WRATE
      *                                                                                       CIR013
     C     POTCD         IFEQ      'O'                                                        CIR013
     C     UICBS         ANDEQ     9                                                          CIR013
     C     POTCD         ORNE      'O'                                                        CIR013
     C     TICBS         ANDEQ     9                                                          CIR013
      *                                                                                       CIR013
     C     POTCD         IFEQ      'O'                                                        CIR013
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
     C                   Z-ADD     BJRDNB        @@DAYN                                       CIR013
     C                   EXSR      ZDATE9                                                     CIR013
     C                   Z-ADD     @@VDT         ZZDATB                                       CIR013
      *                                                                                       CIR013
      * Check for the existence of any February 29th within the dates                         CIR013
     C                   EXSR      #FEB29                                                     CIR013
     C                   ENDIF                                                                CIR013
      *
      ** Divide by Our/Their Calculation Basis
      *
     C     POTCD         IFEQ      'O'
     C     UICBS         IFEQ      1
     C     UICBS         OREQ      4
     C     UICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'N'                                                        CIR013
     C     WRATE         DIV(H)    36500         WRATE
     C                   ENDIF
     C     UICBS         IFEQ      2
     C     UICBS         OREQ      3
     C     UICBS         OREQ      5
     C     CIR004        OREQ      'Y'
     C     UICBS         ANDEQ     7
     C     WRATE         DIV(H)    36000         WRATE
     C                   ENDIF
     C     UICBS         IFEQ      6
     C     UICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'Y'                                                        CIR013
     C     WRATE         DIV(H)    36600         WRATE
     C                   ENDIF
     C                   ELSE
     C     TICBS         IFEQ      1
     C     TICBS         OREQ      4
     C     TICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'N'                                                        CIR013
     C     WRATE         DIV(H)    36500         WRATE
     C                   ENDIF
     C     TICBS         IFEQ      2
     C     TICBS         OREQ      3
     C     TICBS         OREQ      5
     C     CIR004        OREQ      'Y'
     C     TICBS         ANDEQ     7
     C     WRATE         DIV(H)    36000         WRATE
     C                   ENDIF
     C     TICBS         IFEQ      6
     C     TICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'Y'                                                        CIR013
     C     WRATE         DIV(H)    36600         WRATE
     C                   ENDIF
     C                   ENDIF
      *
      ** Add 1
      *
     C     WRATE         ADD       1             WRATE
      *
      ** Multiply by Compounding Rate
      *
     C     WRATE         MULT(H)   L1CPRT        WRATE
      *
      ** Subtract 1 from Rate after saving compounded rate for new record
      *
     C                   Z-ADD(H)  WRATE         WCOMP
     C     WRATE         SUB       1             WRATE
      *
      ** Multiply by Our/Their Calculation Basis
      *
     C     POTCD         IFEQ      'O'
     C     UICBS         IFEQ      1
     C     UICBS         OREQ      4
     C     UICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'N'                                                        CIR013
     C     WRATE         MULT(H)   36500         WRATE
     C                   ENDIF
     C     UICBS         IFEQ      2
     C     UICBS         OREQ      3
     C     UICBS         OREQ      5
     C     CIR004        OREQ      'Y'
     C     UICBS         ANDEQ     7
     C     WRATE         MULT(H)   36000         WRATE
     C                   ENDIF
     C     UICBS         IFEQ      6
     C     UICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'Y'                                                        CIR013
     C     WRATE         MULT(H)   36600         WRATE
     C                   ENDIF
     C                   ELSE
     C     TICBS         IFEQ      1
     C     TICBS         OREQ      4
     C     TICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'N'                                                        CIR013
     C     WRATE         MULT(H)   36500         WRATE
     C                   ENDIF
     C     TICBS         IFEQ      2
     C     TICBS         OREQ      3
     C     TICBS         OREQ      5
     C     CIR004        OREQ      'Y'
     C     TICBS         ANDEQ     7
     C     WRATE         MULT(H)   36000         WRATE
     C                   ENDIF
     C     TICBS         IFEQ      6
     C     TICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'Y'                                                        CIR013
     C     WRATE         MULT(H)   36600         WRATE
     C                   ENDIF
     C                   ENDIF
      *
      ** Find number of days since Last Interest Payment Date
      *
     C     PHDAY         IFEQ      'Y'                                                        221119
     C     POTCD         IFEQ      'O'                                                        221119
     C     PDATE         SUB       USLIP         WDAYS             4 0                        221119
     C                   ELSE                                                                 221119
     C     PDATE         SUB       TSLIP         WDAYS                                        221119
     C                   ENDIF                                                                221119
     C                   ELSE                                                                 221119
     C     POTCD         IFEQ      'O'
     C     BJRDNB        SUB       USLIP         WDAYS             4 0
     C                   ELSE
     C     BJRDNB        SUB       TSLIP         WDAYS
     C                   ENDIF
     C                   ENDIF                                                                221119
      *
      ** Divide Rate by number of days.
      *
     C     WRATE         DIV(H)    WDAYS         WRATE
      *
      ** This is the Interest Rate of the New Record.
      *
     C                   Z-ADD(H)  WRATE         WINTN
      *
     C                   MOVEL     BRCA          L1BRCA
     C                   Z-ADD     PDLNO         L1DLNO
     C                   MOVE      'STANDARD'    L1RTYP
     C                   MOVE      POTCD         L1OTCD
      *                                                                                       221119
     C     PHDAY         IFEQ      'Y'                                                        221119
     C                   Z-ADD     PDATE         L1BSDT                                       221119
     C                   ELSE                                                                 221119
     C                   Z-ADD     BJRDNB        L1BSDT
     C                   ENDIF                                                                221119
      *                                                                                       221119
     C                   Z-ADD     WBSRT         L1BSRT
     C                   Z-ADD     0             L1CLRT
     C                   Z-ADD(H)  WCOMP         L1CPRT
     C                   Z-ADD(H)  WRATE         L1INRT
     C                   Z-ADD     WAPDY         L1APDY
     C                   Z-ADD     0             L1AMNT
     C     POTCD         IFEQ      'O'
     C                   Z-ADD     UPAMT         L1PRIN
     C                   ELSE
     C                   Z-ADD     TPAMT         L1PRIN
     C                   ENDIF
      *
      ** Check for a principal change.
      *
     C                   Z-ADD     L1PRIN        WPRIN            13 0
     C                   EXSR      SRPRIN
     C                   Z-ADD     WPRIN         L1PRIN
      *
      ** Write record to DLDOISPD
      *
     C                   WRITE     DLDOISD0
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SRPRIN   - Subroutine to check for a principal change.       *
      *  Called By: SRPROC                                            *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRPRIN        BEGSR
      *
     C                   MOVE      'N'           WENDSR            1
      *
      ** If a principal change is not due today, we bypass the following
      ** code.
      *
     C     POTCD         IFEQ      'O'
     C     BJRDNB        IFNE      UNPCD
     C                   MOVE      'Y'           WENDSR
     C                   ENDIF
     C                   ELSE
     C     BJRDNB        IFNE      TNPCD
     C                   MOVE      'Y'           WENDSR
     C                   ENDIF
     C                   ENDIF
      *
      ** Principal change is due today. Read the Principal Change
      ** Schedule File.
      *
     C     WENDSR        IFEQ      'N'
      *
     C                   Z-ADD     BJRDNB        PRDT
     C                   MOVEL     *BLANKS       OTIN
      *
     C     PCSC          CHAIN     DLPCSCPD                           72
      *
     C     *IN72         IFEQ      '0'
     C                   Z-ADD     PAMT          WPRIN
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SRTERM   - Subroutine to do Terminate program                *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRTERM        BEGSR
      *
     C                   MOVE      WINTN         PINRT
     C                   MOVE      *BLANKS       PRTNC
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *
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
      *
      ********************************************************************                    CIR013
      /EJECT                                                                                  CIR013
     C*COPY*ZSRSRC,ZDATE9Z3                                                                   CIR013
     C/COPY ZSRSRC,ZDATE9Z3LE                                                                 CIR013
      /EJECT                                                                                  CIR013
     C*COPY*ZSRSRC,ZFEB29                                                                     CIR013
     C/COPY ZSRSRC,ZFEB29Z2LE                                                                 CIR013
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN                        CIR013
00366007310109601461
** @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR                           CIR013
00000000310005900090001200015100181002120024300273003040033400365
