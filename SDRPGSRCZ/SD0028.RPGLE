     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Currency codes recalculation for EMU')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0028 - Spot Rates Recalculation for EMU Currencies         *
      *                                                               *
      *  Function:  This program recalculates Spot Rates for          *
      *             those currencies that are a part of the           *
      *             EMU and past their transition start date.         *
      *  (phase(s) I/C)                                               *
      *                                                               *
      *  Called By: SD0020M - MIDAS SD Spot Rates Maintenance         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 23Feb15               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER048             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 26Aug03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 204923             Date 29Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CIR007             Date 11May01               *
      *                 191642             Date 07Jul01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 15Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 152522             Date 18Jan99               *
      *                 146103             Date 08Jan99               *
      *                 134658             Date 05May98               *
      *                 CEU002  *CREATE    Date 31Oct97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Wrapper project - convert to ILE                    *
      *  204923 - Rate Fix Days Adjustment (OIS) - (Recompile)        *
      *  CIR007 - Overnight Index Swaps                               *
      *           (Recompiled over changed SDCURRPD)                  *
      *  191642 - If No. of Amend is equal to 10, trailer file        *
      *           will be updated with incorrect value.               *
      *           Changed length of field WUNOAM to 5,0.              *
      *           similar to AHNOAM.                                  *
      *  CSD006 - Market data feed -                                  *
      *           Remove COMIT in order to comply with CTL API        *
      *           structure.                                          *
      *  CDL008 - Continuous Linked Settlement (Recompiled)           *
      *  152522 - Recompile due to changes SDCURRPD.                  *
      *  146103 - Consolidated Euro to remain in step with Euro       *
      *  134658 - Spot rates calculated incorrectly for 'In'          *
      *           currencies                                          *
      *  CEU002 - Additional Currency Details For EMU                 *
      *                                                               *
      *****************************************************************
      /EJECT
     FSDCURRL1  IF   E           K DISK
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Currency codes retrieval
      *
     FSDCURRL0  UF   E           K DISK
     F                                     COMMIT
     F                                     INFSR(*PSSR)
      * UPD : Midas SD Currency codes update
      *
     FSDFCTLL0  UF   E           K DISK
     F                                     COMMIT
     F                                     INFSR(*PSSR)
      * UPD : Midas SD Standing data controls update
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
      /SPACE 3
     D DBERR         E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D QSDFC1        E DS                  EXTNAME(SDFCTLL0)
     D YCRDCS          DS            22
      * UPD : Midas SD Standing data controls update
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      **   Currency details from SDCURRD
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     I* Second DS For Access Programs, LONG DATA STRUCTURE
     I*
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      ***  Perform Initialisation.
      *
     C                   EXSR      INIT
      *
      ***  Perform Detail Processing.
      *
     C                   EXSR      PROCES
      *
      ***  End Program and Return.
      *
     C                   EXSR      EXIT
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
      /EJECT
      *****************************************************************
      *                                                               *
      *  INIT   - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *  AOCURRR0 Access Program (Currency Details)                   *
      *  *PSSR  - Error Control Program                               *
      *                                                               *
      *****************************************************************
      *
     C     INIT          BEGSR                                                  ***  INIT  ***
      *
      ***  Initialise LDA field.
      *
     C                   MOVEL     'SD0028'      DBPGM
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C     AGDFF         IFEQ      'M'
     C                   SETON                                        98
     C                   END
      *
      *  Entry Parameter List
     C     *ENTRY        PLIST
     C                   PARM                    BASCCY            3            Base Ccy
     C                   PARM                    EURCOD            3            EURO Code
     C                   PARM                    CONEUR            3            EURO Consolidat14610
     C                   PARM                    INCCY             1            IN Ccy
     C                   PARM                    INITN             1            First Call?
     C                   PARM                    RCODE             7            Return Code
      *
      ** Access Currency Data For The Base Ccy.
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BASCCY        @KEYCY            3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS                                      ***************
     C                   MOVEL     'SDCURRPD'    DBFILE                         *             *
     C                   MOVEL     '001'         DBASE                          * DBERROR 001 *
     C                   MOVEL     BASCCY        DBKEY                          *             *
     C                   EXSR      *PSSR                                        ***************
     C                   END
      *
      ** Store Exchange Rate and Mult/Div Ind for Base Currency
      ** EURO Rate.
      *
     C     *LIKE         DEFINE    A6EUER        WREUER
     C     *LIKE         DEFINE    A6EUMD        WREUMD
     C                   Z-ADD     A6EUER        WREUER
     C                   MOVEL     A6EUMD        WREUMD
      *
      ** Access Currency Data For The EURO Ccy. Code.
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      EURCOD        @KEYCY
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS                                      ***************
     C                   MOVEL     'SDCURRPD'    DBFILE                         *             *
     C                   MOVEL     '002'         DBASE                          * DBERROR 002 *
     C                   MOVEL     EURCOD        DBKEY                          *             *
     C                   EXSR      *PSSR                                        ***************
     C                   END
      *
      ** Store Exchange Rate and Mult/Div Ind for EURO Ccy Code.
      *
     C     *LIKE         DEFINE    A6SPRT        WRSPRT
     C     *LIKE         DEFINE    A6SPRT        NEWRAT
     C     *LIKE         DEFINE    A6MDIN        WRMDIN
     C                   Z-ADD     A6SPRT        WRSPRT
     C                   MOVEL     A6MDIN        WRMDIN
      *
     C/COPY WNCPYSRC,SD0028C001
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  PROCES - Subroutine to do Program Processing                 *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *  FIRST  - Recalc. Spots For Init. Disp. (Including EURO Base) *
      *  INBASE - Recalculate Spot For all Currencies (Except EURO)   *
      *  OUTBAS - Recalculate Spot For 'IN' Currencies only           *
      *  *PSSR  - Error Control Program                               *
      *                                                               *
      *****************************************************************
      *
     C     PROCES        BEGSR
     C                   SELECT
     C     INITN         WHENEQ    'Y'
     C                   EXSR      FIRST
     C     INCCY         WHENEQ    'Y'
     C                   EXSR      INBASE
     C     INCCY         WHENNE    'Y'
     C                   EXSR      OUTBAS
     C                   ENDSL
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  FIRST  - Subroutine to do Program Processing                 *
      *         - for First Call.                                     *
      *                                                               *
      *  Called By: PROCES                                            *
      *  Calls:                                                       *
      *  *PSSR  - Error Control Program                               *
      *  INBASE - Recalculate Spot For all Currencies (Except EURO)   *
      *  OUTBAS - Recalculate Spot For 'IN' Currencies only           *
      *                                                               *
      *****************************************************************
      *
     C     FIRST         BEGSR
      *
      ** If Base is EURO then Reset 'IN' Currency Spot Rates
      ** The Same as their EURO Rates.
      *
     C     EURCOD        IFEQ      BASCCY
     C     *LOVAL        SETLL     SDCURRL1
     C                   READ      SDCURRL1                               89
     C     *IN89         DOWEQ     *OFF
      *
      ** If Currency is 'IN' Currency, and Past its Start Date
      ** Use The EURO Rate instead of SPOT.
      *
     C     A6INCY        IFEQ      'Y'
     C     A6TPSD        ANDLE     AGRDNB
     C     A6CYCD        ANDNE     EURCOD
     C     A6CYCD        OREQ      CONEUR                                                      14610
     C     CONEUR        ANDNE     EURCOD                                                      14610
     C     A6CYCD        CHAIN     @A6REA4                            89
      *
      ** If Currency Not Found Have DB Error.
      *
     C     *IN89         IFEQ      *ON                                          ***************
     C                   MOVEL     'SDCURRPD'    DBFILE                         *             *
     C                   MOVEL     '003'         DBASE                          * DBERROR 003 *
     C                   MOVEL     A6CYCD        DBKEY                          *             *
     C                   EXSR      *PSSR                                        ***************
     C                   ELSE
     C/COPY WNCPYSRC,SD0028C002
      *                                                                   146103
     C     A6CYCD        IFEQ      CONEUR                                                      14610
      *                                                                   146103
     C                   Z-ADD     WRSPRT        A6SPRT                                        14610
     C                   MOVE      'A'           A6TYLC                                        14610
     C                   MOVE      WRMDIN        A6MDIN                                        14610
     C                   Z-ADD     AGRDNB        A6LCD                                         14610
     C                   ELSE                                                                  14610
      *
      ** Update SPOT Rate to EURO Rate.
      *
     C                   Z-ADD     A6EUER        A6SPRT
     C                   MOVE      'A'           A6TYLC
     C                   MOVE      A6EUMD        A6MDIN
     C                   Z-ADD     AGRDNB        A6LCD
      *                                                                   146103
     C                   END                                                                   14610
      *
      ** Update background files.
      *
     C                   EXSR      BACKUP
      *
     C                   UPDATE    @A6REA4
     C/COPY WNCPYSRC,SD0028C003
     C                   ENDIF
     C                   ENDIF
     C                   READ      SDCURRL1                               89
     C                   ENDDO
     C                   ENDIF
      *
      ** If Base is 'IN' Currency Then Reset EURO Ccy Spot Rate
      ** To EURO Rate for Base Currency.
      *
     C     INCCY         IFEQ      'Y'
     C     EURCOD        CHAIN     @A6REA4                            89
      *
      ** If Currency Not Found Have DB Error.
      *
     C     *IN89         IFEQ      *ON                                          ***************
     C                   MOVEL     'SDCURRPD'    DBFILE                         *             *
     C                   MOVEL     '004'         DBASE                          * DBERROR 004 *
     C                   MOVEL     EURCOD        DBKEY                          *             *
     C                   EXSR      *PSSR                                        ***************
     C                   ELSE
     C/COPY WNCPYSRC,SD0028C004
     C                   Z-ADD     WREUER        A6SPRT
     C                   Z-ADD     WREUER        WRSPRT                                        14610
     C                   MOVE      'A'           A6TYLC
      *
      ** Change m/d indicator because WR* fields represent                134658
      ** 'Base against EUR' and A6* fields represent 'EUR against Base'   134658
     C***********          MOVE WREUMD    A6MDIN                          134658
     C     WREUMD        IFEQ      'M'                                                         13465
     C                   MOVEL     'D'           A6MDIN                                        13465
     C                   MOVEL     'D'           WRMDIN                                        14610
     C                   ELSE                                                                  13465
     C                   MOVEL     'M'           A6MDIN                                        13465
     C                   MOVEL     'M'           WRMDIN                                        14610
     C                   ENDIF                                                                 13465
     C                   Z-ADD     AGRDNB        A6LCD
      *
      ** Update background files.
      *
     C                   EXSR      BACKUP
      *
     C                   UPDATE    @A6REA4
     C/COPY WNCPYSRC,SD0028C005
     C                   ENDIF
      *
      ** Calculate All The Rates Affected by Changing the Base/EURO Rate.
      *
     C                   EXSR      INBASE
     C                   ENDIF
      *
      ** If Base is 'OUT' Currency Then Recalculate Rates in case
      ** EURO Rate has Changed
      *
     C     INCCY         IFEQ      'N'
     C     BASCCY        ANDNE     EURCOD
     C                   EXSR      OUTBAS
     C                   ENDIF
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  INBASE - Subroutine to do Program Processing                 *
      *         - for an 'IN' Base Currency                           *
      *                                                               *
      *  Called By: PROCES                                            *
      *  Calls:                                                       *
      *  *PSSR  - Error Control Program                               *
      *  ZXRATE - FX Rate Calculation Subroutine                      *
      *                                                               *
      *****************************************************************
      *
     C     INBASE        BEGSR
     C     *LOVAL        SETLL     SDCURRL1
     C                   READ      SDCURRL1                               89
     C     *IN89         DOWEQ     *OFF
      *
      ** Don't Process if Currency is Base Currency or EURO.
      *
     C     A6CYCD        IFNE      BASCCY
     C     A6CYCD        ANDNE     EURCOD
      *
      ** If Currency is 'IN' Currency, and Past its Start Date
      ** Use The BASE/EURO Rate against the IN/EURO Rate.
      *
     C     A6INCY        IFEQ      'Y'
     C     A6TPSD        ANDLE     AGRDNB
     C     A6CYCD        OREQ      CONEUR                                                      14610
      *
      ** Setup Details To Calculate Exchange Rate.
      *
      *                                                                   134658
     C***********          Z-ADDWREUER    ZRATE1 138                      134658
     C***********          MOVE WREUMD    ZMDI1   1                       134658
     C***********          Z-ADDA6EUER    ZRATE2 138                      134658
     C***********          MOVE A6EUMD    ZMDI2   1                       134658
     C                   Z-ADD     WREUER        ZRATE2           13 8                         13465
     C                   MOVE      WREUMD        ZMDI2             1                           13465
     C                   Z-ADD     A6EUER        ZRATE1           13 8                         13465
     C                   MOVE      A6EUMD        ZMDI1             1                           13465
     C*****************  EXSR      ZXRATE                                                     CAP084
     C                   CALLB     'ZXRATE'                                                   CAP084
     C                   PARM                    ZRATE1                                       CAP084
     C                   PARM                    ZMDI1                                        CAP084
     C                   PARM                    ZRATE2                                       CAP084
     C                   PARM                    ZMDI2                                        CAP084
     C                   PARM      *ZEROS        ZRATEX           13 8                        CAP084
     C                   PARM      *BLANKS       ZMDIX             1                          CAP084
      *
      ** Update The Currency.
      *
     C     A6CYCD        CHAIN     @A6REA4                            89
      *
      ** If Currency Not Found Have DB Error.
      *
     C     *IN89         IFEQ      *ON                                          ***************
     C                   MOVEL     'SDCURRPD'    DBFILE                         *             *
     C                   MOVEL     '005'         DBASE                          * DBERROR 005 *
     C                   MOVEL     A6CYCD        DBKEY                          *             *
     C                   EXSR      *PSSR                                        ***************
     C                   ELSE
     C/COPY WNCPYSRC,SD0028C006
      *                                                                   146103
     C     A6CYCD        IFEQ      CONEUR                                                      14610
      *                                                                   146103
     C                   Z-ADD     WRSPRT        A6SPRT                                        14610
     C                   MOVE      'A'           A6TYLC                                        14610
     C                   MOVE      WRMDIN        A6MDIN                                        14610
     C                   Z-ADD     AGRDNB        A6LCD                                         14610
     C                   ELSE                                                                  14610
      *                                                                   146103
     C                   Z-ADD     ZRATEX        A6SPRT
     C                   MOVE      'A'           A6TYLC
     C                   MOVE      ZMDIX         A6MDIN
     C                   Z-ADD     AGRDNB        A6LCD
      *                                                                   146103
     C                   END                                                                   14610
      *
      ** Update background files.
      *
     C                   EXSR      BACKUP
      *
     C                   UPDATE    @A6REA4
     C/COPY WNCPYSRC,SD0028C007
     C                   ENDIF
      *
      *
     C                   ENDIF
     C                   ENDIF
     C                   READ      SDCURRL1                               89
     C                   ENDDO
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  OUTBAS - Subroutine to do Program Processing                 *
      *         - for an 'OUT' Base Currency                          *
      *                                                               *
      *  Called By: PROCES                                            *
      *  Calls:                                                       *
      *  *PSSR  - Error Control Program                               *
      *  ZXRATE - FX Rate Calculation Subroutine                      *
      *                                                               *
      *****************************************************************
      *
     C     OUTBAS        BEGSR
      *
     C     *LOVAL        SETLL     SDCURRL1
     C                   READ      SDCURRL1                               89
     C     *IN89         DOWEQ     *OFF
      *
      ** Don't Process if Currency is Base Currency or EURO.
      *
     C     A6CYCD        IFNE      BASCCY
     C     A6CYCD        ANDNE     EURCOD
      *
      ** If Currency is 'IN' Currency, and Past its Start Date
      ** Use The OUT/EURO Rate against the IN/EURO Rate.
      *
     C     A6INCY        IFEQ      'Y'
     C     A6TPSD        ANDLE     AGRDNB
     C     A6CYCD        OREQ      CONEUR                                                      14610
      *
      ** Setup Details To Calculate Exchange Rate.
      *
     C***********          Z-ADDWRSPRT    ZRATE1                          134658
     C***********          MOVE WRMDIN    ZMDI1                           134658
     C***********          Z-ADDA6EUER    ZRATE2                          134658
     C***********          MOVE A6EUMD    ZMDI2                           134658
     C                   Z-ADD     WRSPRT        ZRATE2                                        13465
     C     WRMDIN        IFEQ      'D'                                                         13465
     C                   MOVE      'M'           ZMDI2                                         13465
     C                   ELSE                                                                  13465
     C                   MOVE      'D'           ZMDI2                                         13465
     C                   ENDIF                                                                 13465
     C                   Z-ADD     A6EUER        ZRATE1                                        13465
     C                   MOVE      A6EUMD        ZMDI1                                         13465
     C*****************  EXSR      ZXRATE                                                     CAP084
     C                   CALLB     'ZXRATE'                                                   CAP084
     C                   PARM                    ZRATE1                                       CAP084
     C                   PARM                    ZMDI1                                        CAP084
     C                   PARM                    ZRATE2                                       CAP084
     C                   PARM                    ZMDI2                                        CAP084
     C                   PARM      *ZEROS        ZRATEX                                       CAP084
     C                   PARM      *BLANKS       ZMDIX                                        CAP084
      *
      ** Update The Currency.
      *
     C     A6CYCD        CHAIN     @A6REA4                            89
      *
      ** If Currency Not Found Have DB Error.
      *
     C     *IN89         IFEQ      *ON                                          ***************
     C                   MOVEL     'SDCURRPD'    DBFILE                         *             *
     C                   MOVEL     '006'         DBASE                          * DBERROR 006 *
     C                   MOVEL     A6CYCD        DBKEY                          *             *
     C                   EXSR      *PSSR                                        ***************
     C                   ELSE
     C/COPY WNCPYSRC,SD0028C008
      *                                                                   146103
     C     A6CYCD        IFEQ      CONEUR                                                      14610
      *                                                                   146103
     C                   Z-ADD     WRSPRT        A6SPRT                                        14610
     C                   MOVE      'A'           A6TYLC                                        14610
     C                   MOVE      WRMDIN        A6MDIN                                        14610
     C                   Z-ADD     AGRDNB        A6LCD                                         14610
     C                   ELSE                                                                  14610
      *                                                                   146103
     C                   Z-ADD     ZRATEX        A6SPRT
     C                   MOVE      'A'           A6TYLC
     C                   MOVE      ZMDIX         A6MDIN
     C                   Z-ADD     AGRDNB        A6LCD
      *                                                                   146103
     C                   END                                                                   14610
      *
      ** Update background files.
      *
     C                   EXSR      BACKUP
      *
     C                   UPDATE    @A6REA4
     C/COPY WNCPYSRC,SD0028C009
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   READ      SDCURRL1                               89
     C                   ENDDO
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  BACKUP - Subroutine to do background file                    *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      * RTV for Chg, Add or Del - Currency Codes  *
     C     BACKUP        BEGSR
     C                   MOVEL     *BLANK        W0RTN             7
      * CASE: PAR.Type of Last Change is Amend
     C**********           Z-ADD1         WUNOAM  10       No. of Amends                      191642
     C                   Z-ADD     1             WUNOAM            5 0          No. of Amends
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      STNDAT
      * Background Update CCY - Currency Codes  *
     C                   CALL      'SD0021U'                                    Background Upda
     C     W0RTN         PARM      *BLANK        WQ0022            7            *Return code
     C                   PARM      A6CYCD        WQ0023            3            Currency Code
     C**********         PARM      A6SPAE        WQ0024            4            Spot Trade    CGL029
     C**********         PARM      A6FTAE        WQ0025            4            Fwd Trade     CGL029
     C**********         PARM      A6SWAE        WQ0026            4            Swap Trade    CGL029
     C**********         PARM      A6TAC4        WQ0027            4            Trade Account CGL029
     C**********         PARM      A6TAC5        WQ0028            4            Trade Account CGL029
     C                   PARM      A6SPAE        WQ0024           10                          CGL029
     C                   PARM      A6FTAE        WQ0025           10                          CGL029
     C                   PARM      A6SWAE        WQ0026           10                          CGL029
     C                   PARM      A6TAC4        WQ0027           10                          CGL029
     C                   PARM      A6TAC5        WQ0028           10                          CGL029
     C                   PARM      A6CDFN        WQ0029            2            Cedel Default N
     C                   PARM      A6ECDN        WQ0030            2            Euroclear Defau
     C                   PARM      A6LCD         WQ0031            5 0          Last Change Dat
     C                   PARM      'A'           WQ0032            1            Type of Last Ch
     C                   PARM      A6CYNM        WQ0033           14            Currency Name
     C                   PARM      A6SPRT        WQ0034           13 8          Spot Rate
     C                   PARM      A6SWCY        WQ0035            3            Swift Currency
     C                   PARM      A6NBDP        WQ0036            1 0          Number of Decim
     C                   PARM      A6TXND        WQ0037            1 0          Telex Notice Da
     C                   PARM      A6PRRT        WQ0038           13 8          Par Rate
     C                   PARM      A6SRC1        WQ0039            4 0          Statutory Retur
     C                   PARM      A6SRC2        WQ0040            4 0          Statutory Retur
     C                   PARM      A6DLCI        WQ0041            1            Dealing Currenc
     C                   PARM      A6SSNB        WQ0042            2 0          Sort Sequence N
     C                   PARM      A6ERLC        WQ0043           13 8          Exchange Rate -
     C                   PARM      A6MDIN        WQ0044            1            Multiply/Divide
     C                   PARM      A6MDPR        WQ0045            1            Multiply/Divide
     C                   PARM      A6MDHB        WQ0046            1            Multiply/Divide
     C                   PARM      A6MDEX        WQ0047            1            Multiply/Divide
     C                   PARM      A6NOSN        WQ0048           10            Nostro Shortnam
     C                   PARM      A6SPDY        WQ0049            3 0          Spot Days
     C                   PARM      A6FXSD        WQ0050            8 0          DRS FX Spot Dat
     C                   PARM      A6MMSD        WQ0051            8 0          DRS MM Spot Dat
     C                   PARM      A6NQDP        WQ0052            1 0          Normally Quoted
     C                   PARM      A6DICB        WQ0053            1            Default Int. Ca
     C                   PARM      A6SCEX        WQ0054            1 0          Scaling Exponen
     C                   PARM      A6EBDA        WQ0055           29            Eurobond Data
     C                   PARM      A6HBRT        WQ0056           13 8          Historic Broker
     C                   PARM      A6ENC1        WQ0057            2 0          Euroclear Numer
     C                   PARM      A6ENC2        WQ0058            2 0          Euroclear Numer
     C                   PARM      A6CACD        WQ0059            3            Cedel Alpha Cod
     C                   PARM      A6CNMC        WQ0060            2 0          Cedel Numeric C
     C                   PARM      A6FRIH        WQ0061            1            FRI. Holiday
     C                   PARM      A6SATH        WQ0062            1            SAT. Holiday
     C                   PARM      A6SUNH        WQ0063            1            SUN. Holiday
     C                   PARM      A6DPBF        WQ0064            1 0          Dec.Places in B
     C                   PARM      A6BYSR        WQ0065           13 8          Buy Spread Rate
     C                   PARM      A6BYSS        WQ0066            1            Buy Spread Sign
     C                   PARM      A6SLSR        WQ0067           13 8          Sell Spread Rat
     C                   PARM      A6SLSS        WQ0068            1            Sell Spread Sig
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK                                       ***************
     C                   MOVEL     'SD0021U '    DBFILE                         *             *
     C                   MOVEL     '007'         DBASE                          * DBERROR 007 *
     C                   MOVEL     *BLANKS       DBKEY                          *             *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  STNDAT - Subroutine to do background file                    *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      * RTV for Chg, Add or Del - Currency Codes  *
     C     STNDAT        BEGSR
      *
      * Change Standing Data Cont - Standing Data Controls  *
     C                   MOVEL     *BLANK        W0RTN
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YCRDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDCURRPD'    AHFLNM                         Filename
      *
     C     KLCHSH        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C     KLCHSH        CHAIN     @AHREAU                            8889      *
      *
      * Record not found
     C     *IN88         IFEQ      '1'                                          ***************
     C                   MOVEL     'SD0028  '    DBFILE                         *             *
     C                   MOVEL     '008'         DBASE                          * DBERROR 007 *
     C                   MOVEL     'SDCURRPD'    DBKEY                          *             *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
      *
     C     *IN89         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     RCODE
     C                   GOTO      SHEXIT
     C                   END
      *
      * Store record data for null update check
     C                   MOVE      QSDFC1        YCRDCS
      * USER: Processing after Data read
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
      * Move non-key fields to @AHREAU
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
      *
      * Set PGM.*Record Data Changed flag
     C     QSDFC1        IFNE      YCRDCS
     C                   MOVE      'Y'           YCRDC
     C                   END
      * If changed update record otherwise release record
     C     YCRDC         IFEQ      'Y'
     C                   UPDATE    @AHREAU                              91      *
     C                   ELSE
      * Release record lock
     C                   UNLOCK    SDFCTLL0                             89      *
     C                   END
     C     *IN89         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     RCODE
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *
     C     SHEXIT        ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  EXIT   - Subroutine to do EXIT Program                       *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     EXIT          BEGSR                                                  ***  EXIT  ***
      *
      ** Commit details if first time call of program.
      *
     C     INITN         IFEQ      'Y'
     C*********************COMIT                                   CSD006
     C                   ENDIF
      *
      ** Set on Last record and return to Calling Program
      *
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
      *
     C     *DTAARA       DEFINE                  LDA             256
     C     *LOCK         IN        LDA
     C                   MOVEL     DBERR         LDA
     C                   OUT       LDA
      *
     C                   DUMP
     C                   SETON                                        U7U8LR
      *
     C                   CALL      'DBERRCTL'
      *
     C                   END
      *
      ***  If *PSSR already run, then just end the program here.
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ****Subroutine*to*Calculate*Exchange*Rates                                              CAP084
      *COPY*ZSRSRC*ZXRATEZ1                                                                   CAP084
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
