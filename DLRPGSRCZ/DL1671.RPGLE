      *****************************************************************
/*STD *  RPGBASEBND                                                   *                       220859
/*EXI *  TEXT('Midas DL OIS rate correction for COB')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL1671 - OIS Rate Correction for COB                         *
      *                                                               *
      *  Function:  This program recalculates the latest interest rate*
      *             in PF/DLDOISPD when rate fix adjustment is not    *
      *             zero.                                             *
      *                                                               *
      *  Called By: DLC1647 - OIS Deals Details File Maintenance      *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER059             Date 19Jul10               *
      *                 CER016A            Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 240334             Date 17Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CPK025             Date 08Jul06               *
      *                 220859             Date 02Mar06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CIR013             Date 22Apr05               *
      *                 CDL028             Date 07Feb05               *
      *                 CAS008             Date 16Jun06               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. 204923  *CREATE    Date 29Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER016A - German Interest Calculation: Upgarde of FGE059     *
      *            to Midas Plus (Recompile)                          *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *  240334 - Recompile over changes in ZACCHLE.                  *
      *  CPK025 - add /COPY ZFEB29Z1LE and corrected definition of    *
      *           @@DAYN.                                             *
      *  220859 - Increase the size of Compounding Rate from          *
      *           7 to 15 decimal places. DL1671 was converted to ILE *
      *           due to the change in the number of decimal places.  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CIR013 - Additional Calculation Method for FRA/IRS/CCF       *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CAS008 - IAS 39 Enhancements (Recompile)                     *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  204923 - Rate Fix Days Adjustment (OIS)                      *
      *                                                               *
      *****************************************************************
     FSDCURRLE  IF   E           K DISK
     FDLOISGL0  UF   E           K DISK
     FDLDOISL1  UF   E           K DISK
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  01 - EOF SDCURRLE                                            *
      *  70 - READE DLOISGL0                                          *
      *  75 - READ  DLDOISL0                                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRINIT   - Subroutine to do Program Initialisation.          *
      *  SRPROC   - Subroutine to do Detail Processing.               *
      *  SRONIS   - Subroutine to Process the OIS Compounding         *
      *             Interest Rate File, PF/DLDOISPD.                  *
      *  SRRIMD   - Recalculate Interest Amount Due.                  *
      *  SRUPDT   - Updates base rate in PF/DLDOISPD with new rate    *
      *  SRUPT2   - Recalculates the compound rate and interest rate  *
      *  *PSSR    - Program exception error routine.                  *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*COPY ZSRSRC,ZHOLE                                                                      220859
     D/COPY ZSRSRC,ZHOLELE                                                                    220859
     D*COPY*ZSRSRC,ZDATE9Z1                                                                   CIR013
     D/COPY ZSRSRC,ZDATE9Z1LE                                                                 CIR013
     D/COPY ZSRSRC,ZFEB29Z1LE                                                                 CPK025
      ** Array for holiday checking
      *
      /SPACE 3
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
     D LDA           E DS           256    EXTNAME(LDA)
      *
     D*COPY ZSRSRC,ZHOLI                                                                      220859
     D/COPY ZSRSRC,ZHOLILE                                                                    220859
      ** Data structure for holiday checking
      *
      ** Data Structure to receive Deal details
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      *
      ** Data Structure to receive bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Data Structure to receive Base Rate Details
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      *
      ** SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
     D*COPY*ZSRSRC,ZDATE9Z2                                                                   CIR013
     D/COPY ZSRSRC,ZDATE9Z2LE                                                                 CIR013
     D*COPY*ZSRSRC,ZINTDYZ1                                                                   CIR013
     D/COPY ZSRSRC,ZINTDYZ1LE                                                                 CIR013
     C/EJECT
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
      ** Perform Termination Processing.
      *
     C                   SETON                                        LR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initialisation subroutine                           *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls    : AOBANKR0, AODEALR0, AOSARDR0                      *
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
      ** Initialise LDA field.
      *
     C                   MOVEL     'DL1671'      DBPGM
      *
      ** Access Bank details via access program
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Initialise all working fields
      *
     C                   Z-ADD     *ZERO         DBASE
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
      *
      ** Access SDDEALPD, divide Hong Kong Tax rate field and divide
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
     C                   MOVE      'SDDEALPD'    DBFILE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   Z-ADD     2             DBASE
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
     C                   Z-ADD     3             DBASE
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
      ** Determine Previous Working Day
      *
     C                   Z-ADD     1             ZNRDYS
     C                   MOVEL     BJLCCY        ZCCY
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   EXSR      ZBKDT
     C                   Z-ADD     ZDYNBR        WDATE             5 0
      *
      ** Set up a key list to the access records from PF/DLDOISPD
      *
     C     KONIS         KLIST
     C                   KFLD                    L1DLNO
     C                   KFLD                    L1OTCD
     C                   KFLD                    L1BSDT
      *
      ** Set up partial Key List to access deals file.
      *
     C     KDEAL         KLIST
     C                   KFLD                    UCUCY
     C                   KFLD                    BRCA
     C                   KFLD                    DLNO
      *
      ** Set up key list for OIS Deals Interest Rate File
      *
     C     KRIMD         KLIST
     C                   KFLD                    L1DLNO
     C                   KFLD                    L1OTCD
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      /TITLE SR/SRPROC
      *****************************************************************
      *                                                               *
      *  SRPROC - Subroutine to do Detail Processing                  *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls    : SRONIS                                            *
      *                                                               *
      *****************************************************************
      *
     C     SRPROC        BEGSR
      *
     C                   READ      SDCURRLE                               01
      *
     C     *IN01         DOWEQ     '0'
      *
     C     A6CYCD        SETLL     DLOISGL0
      *
      ** Read first record from file
      *
     C     A6CYCD        READE     DLOISGL0                               70
      *
     C     *IN70         DOWEQ     '0'
      *
      ** Ignore all 'RS' deals:
      ** - that are not OIS
      ** - that have not reached its value date.
      ** - where the date passed in as parameter is in a
      **   'CLOSED' interest period.
      ** - for which the base rate code on the OIS side does
      **   not match received parameter (if not blank) from DLC1666
      *
     C     UICFR         IFEQ      'O'
     C     VDAT          ANDLE     BJRDNB
      *
     C*****UBRTT         IFNE      *ZERO                                                      CSD103
     C     UBRTT         IFNE      *BLANKS                                                    CSD103
      *
     C                   MOVE      'O'           L1OTCD
     C                   MOVE      UBRTT         WBRTT
     C                   EXSR      SRONIS
      *
     C                   ENDIF
     C                   ENDIF
      *
     C     TICFR         IFEQ      'O'
     C     VDAT          ANDLE     BJRDNB
      *
     C*****TBRTT         IFNE      *ZERO                                                      CSD103
     C     TBRTT         IFNE      *BLANKS                                                    CSD103
      *
     C                   MOVE      'T'           L1OTCD
     C                   MOVE      TBRTT         WBRTT             2
     C                   EXSR      SRONIS
      *
     C                   ENDIF
     C                   ENDIF
      *
     C     A6CYCD        READE     DLOISGL0                               70
      *
     C                   ENDDO
      *
     C                   READ      SDCURRLE                               01
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      /TITLE SR/SRONIS
      *****************************************************************
      *                                                               *
      *  SRONIS - Process PF/DLDOISPD                                 *
      *                                                               *
      *  Called By: SRPROC                                            *
      *                                                               *
      *  Calls    : SRUPDT, SRUPT2, SRRIMD                            *
      *                                                               *
      *****************************************************************
      *
     C     SRONIS        BEGSR
      *
     C                   Z-ADD     DLNO          L1DLNO
     C                   Z-ADD     WDATE         L1BSDT
      *
      ** For all the deals that are not ignored, attempt to read the
      ** record for the deal on the OIS compounding Interest Rate file.
      ** Logical file DLDOISL1 keyed on L1DLNO, L1OTCD and L1BSDT. L1BSDT
      ** is keyed in Decending order.
      *
     C     KONIS         CHAIN     DLDOISL1                           75
      *
     C     *IN75         IFEQ      *OFF
      *
      ** Updates 'GUESS' record.
      *
     C     L1RTYP        IFNE      'GUESS'
      *
      ** Updates NOT required if the record is a 'Compound' record.
      *
     C     L1RTYP        IFNE      'COMPOUND'
      *
      ** Recalculate the Compound Rate and Interest Rate and update
      ** the OIS Compounding Interest Rate File PF/DLDOISPD.
      *
     C                   EXSR      SRUPDT
     C                   EXSR      SRUPT2
      *
      ** Recalculate the Interest Amount Due.
      *
     C                   EXSR      SRRIMD
      *
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Update OIS Compounding Interest Rate File PF/DLDOISPD.
      *
     C                   EXSR      SRUPDT
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      /TITLE SR/SRUPDT
      *****************************************************************
      *                                                               *
      *  SRUPDT - Updates base rate in PF/DLDOISPD with new rate      *
      *                                                               *
      *  Called By: SRONIS                                            *
      *                                                               *
      *  Calls    : AOBSRTR0                                          *
      *                                                               *
      *****************************************************************
      *
     C     SRUPDT        BEGSR
      *
      ** Access the base rate details
      *
     C                   CALL      'AOBSRTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      A6CYCD        PCYCD             3
     C                   PARM      WBRTT         PBSRT             2
     C     SDBSRT        PARM      SDBSRT        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     UCUCY         WKEY              5
     C                   MOVE      UBRTT         WKEY
     C                   MOVE      'SDBSRTPD'    DBFILE
     C                   MOVEL     WKEY          DBKEY
     C                   Z-ADD     4             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     BJRDNB        IFGT      BAVDRC
     C                   Z-ADD     BANBRT        WBRAT            11 7
     C                   ELSE
     C                   Z-ADD     BACBSR        WBRAT
     C                   ENDIF
      *
      ** Update the present record with the new base rate.
      *
     C                   Z-ADD     WBRAT         L1BSRT
     C     L1RTYP        IFEQ      'GUESS'
     C                   Z-ADD     WBRAT         L1INRT
      *
      ** Update the Effective Interest Rate field in PF/DEALSDG with
      ** the latest Interest Rate.
      *
     C     KDEAL         CHAIN     DLOISGL0                           75
      *
     C     *IN75         IFEQ      *OFF
      *
     C     L1OTCD        IFEQ      'O'
     C                   Z-ADD     L1INRT        UEINR
     C                   ELSE
     C                   Z-ADD     L1INRT        TEINR
     C                   ENDIF
      *
     C                   UPDATE    DEALSDGF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   UPDATE    DLDOISD0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      /TITLE SR/SRUPT2
      *****************************************************************
      *                                                               *
      *  SRUPT2 - Recalculates the compound rate and interest rate    *
      *           fields and updates PF/DLDOISPD                      *
      *                                                               *
      *  Called By: SRONIS                                            *
      *                                                               *
      *  Calls    : NONE                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRUPT2        BEGSR
      *
      ** Save values of deal and side being processed. Used to test and
      ** exit from this processing loop.
      *
     C                   Z-ADD     L1DLNO        WDLNO             6 0
     C                   MOVEL     L1OTCD        WOTCD             1
      *
      ** Find the record just updated.
      *
     C     KONIS         CHAIN(N)  DLDOISL1                           75
      *
     C     *IN75         DOWEQ     *OFF
      *
      ** Save compounding rate from previous record.
      *
     C                   READ(N)   DLDOISL1                               75
      *
     C**********         Z-ADD     L1CPRT        WCPRT            12 9                        220859
     C                   Z-ADD     L1CPRT        WCPRT            1815                        220859
     C                   Z-ADD     L1INRT        WINRT            12 9
      *
      ** Back to the current record again.
      *
     C                   READP     DLDOISL1                               75
      *
      ** Recalculate the compounding rate and interest rate fields.
      ** Apply spread to the old base rate on the deal
      *
     C                   Z-ADD     L1BSRT        WRATE            11 7
      *
      ** Spread for our side.
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
      ** Spread for their side
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
     C     L1BSRT        MULT      TRTSP         WORK
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
      *
     C                   UPDATE    DLDOISD0
      *
      ** READP reads forward (DLDOISL1 in Decending Date order).
      ** Get next record.
      *
     C                   READP     DLDOISL1                               75
      *
      ** Exit the loop when all records for the deal and side have been
      ** processed.
      *
     C     L1DLNO        IFNE      WDLNO
     C     L1OTCD        ORNE      WOTCD
     C                   MOVE      *ON           *IN75
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      /TITLE SR/SRRIMD
      *****************************************************************
      *                                                               *
      *  SRRIMD - Recalculates Interest Amount Due                    *
      *                                                               *
      *  Called by: SRONIS                                            *
      *                                                               *
      *  Calls    : DL1665                                            *
      *                                                               *
      *****************************************************************
      *
     C     SRRIMD        BEGSR
      *
      ** Load up the key with OLD deal
      *
     C                   Z-ADD     WDLNO         DLNO
      *
      ** Load up the key with OLD deal and side value.
      *
     C                   Z-ADD     WDLNO         L1DLNO
     C                   MOVEL     WOTCD         L1OTCD
      *
      ** Position to the last record on the file for the deal
      ** being amended.
      *
     C     KRIMD         SETLL     DLDOISL1                             75
     C                   READ      DLDOISL1                               75
      *
      ** Set the From Date to be either USLIP if Ours of TSLIP if Theirs.
      *
     C     L1OTCD        IFEQ      'O'
     C                   Z-ADD     USLIP         PFDTE
     C                   ELSE
     C                   Z-ADD     TSLIP         PFDTE
     C                   ENDIF
      *
      *
      ** If a settlement record then interest amount due needs
      ** recalculating. Call program DL1665 to calculate the base
      ** amount of interest due.
      *
     C     L1RTYP        IFEQ      'SETTLE'
     C                   CALL      'DL1665'
     C                   PARM      DLNO          PDEAL             6 0
     C                   PARM      L1OTCD        POTCD             1
     C                   PARM                    PFDTE             5 0
     C                   PARM      L1BSDT        PRDNB             5 0
     C                   PARM      *ZERO         PINTA            13 0
     C                   PARM      *BLANKS       PRTCD
      *
     C     L1OTCD        IFEQ      'O'
     C                   ADD       UAIAN         PINTA
     C                   ADD       UAIAP         PINTA
     C                   ELSE
     C                   ADD       TAIAN         PINTA
     C                   ADD       TAIAP         PINTA
     C                   ENDIF
      *
      ** SETTLE records are also GUESS records for a succeeding interest
      ** period, so the compounding rate field must be set to 1.0.
      *
     C                   Z-ADD     1             L1CPRT
      *
      ** If the side is ours, the tax rate is not zero and the taxable
      ** indicator on the deal is 'Y' multiply the tax rate by the
      ** interest amount calculated above
      *
     C     L1OTCD        IFEQ      'O'
     C     TAXR          ANDNE     *ZERO
     C     TAXI          ANDEQ     'Y'
     C     TAXR          MULT(H)   PINTA         WRKTAX           15 0
     C     PINTA         SUB       WRKTAX        PINTA
     C                   ENDIF
      *
     C                   Z-ADD     PINTA         L1AMNT
      *
      ** Update OIS Compounding history file.
      *
     C                   UPDATE    DLDOISD0
      *
     C                   ENDIF
      *
      ** Update the Effective Interest Rate field in PF/DEALSDG with
      ** the latest Interest Rate.
      *
     C     KDEAL         CHAIN     DLOISGL0                           75
      *
     C     *IN75         IFEQ      *OFF
      *
     C     L1OTCD        IFEQ      'O'
     C                   Z-ADD     L1INRT        UEINR
     C                   ELSE
     C                   Z-ADD     L1INRT        TEINR
     C                   ENDIF
      *
     C                   UPDATE    DEALSDGF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      /TITLE SR/*PSSR
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
     C                   ROLBK
     C                   RETURN
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
      /EJECT
     C*COPY ZSRSRC,ZBKDT                                                                      220859
     C/COPY ZSRSRC,ZBKDT_ILE                                                                  220859
      /EJECT
     C*COPY ZSRSRC,ZACCH                                                                      220859
     C/COPY ZSRSRC,ZACCHLE                                                                    220859
      /EJECT
     C*COPY*ZSRSRC,ZDATE9Z3                                                                   CIR013
     C/COPY ZSRSRC,ZDATE9Z3LE                                                                 CIR013
      /EJECT                                                                                  CIR013
     C*COPY*ZSRSRC,ZFEB29                                                                     CIR013
     C/COPY ZSRSRC,ZFEB29Z2LE                                                                 CIR013
      /EJECT                                                                                  CIR013
**  CPY@
(c) Finastra International Limited 2002
** @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN                        CIR013
00366007310109601461
** @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR                           CIR013
00000000310005900090001200015100181002120024300273003040033400365
