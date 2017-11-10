     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas FT Upgrade Utility 2 (SAR is on)')               *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FT0014 - FT Upgrade Utility 2 (SAR is on)                    *
      *                                                               *
      *  Function:  This program initialises fields for CFT014        *
      *             enhancement.                                      *
      *                                                               *
      *  Called By: FTC0014 - FT Upgrade Utility 2 (SAR is on)        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CFT162             Date 08Sep17               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 30May00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014  *CREATE    Date 25May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT162 - MT900 and MT910 Message Generation (Recompile)      *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CFT009 - Addition of fields for FT fees and charges          *
      *           Recompile                                           *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *                                                               *
      *****************************************************************
      *
      ** Incoming Payment details file
     FINPAY     UF   E           K DISK    INFSR(*PSSR)
      *
      ** Incoming Payment details extension file
     FINPAYXL0  UF A E           K DISK    INFSR(*PSSR)
      *
      ** Outgoing Payment details file
     FOTPAY     IF   E           K DISK    INFSR(*PSSR)
      *
      ** Outgoing Payment details extension file
     FOTPAYXL0  UF A E           K DISK    INFSR(*PSSR)
      *
     FFT0014AU  O    E             PRINTER INFDS(SPOOLU)
     FFT0014P1  O    E             PRINTER INFDS(SPOOL1) USROPN
      *****************************************************************
     D/EJECT
      *****************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
     D POWER           S              7S 3 DIM(7) CTDATA PERRCD(1)
      ** Array of powers of 10 for currency conversions
      *
      /SPACE 3
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
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D SPOOL1          DS
      *
      ** File Information Data Structure for FT0014P1
      *
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
     D SPOOLU          DS
      *
      ** File Information Data Structure for FT0014AU
      *
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
     D/COPY FTCPYSRC,FT0010D001
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External data structure for Bank details
      *
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
      ** External data structure for Funds Transfer details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External data structure for SAR details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External data structure for Currency details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for Access Objects - short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS for Access Objects - long data structure
      *
      *****************************************************************
     D/EJECT
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      ** Perform initialisation.
      *
     C                   EXSR      SRINIT
      *
      ** Perform Incoming Payment detail processing.
      *
     C                   EXSR      SRINPAY
      *
      ** Perform OutgoingPpayment detail processing.
      *
     C                   EXSR      SROTPAY
      *
      ** Output Audit report.
      *
     C                   EXSR      SRAUDIT
      *
      ** End program and return.
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Subroutine to do Program Initialisation             *
      *                                                               *
      *  Called By : Main Processing                                  *
      *  Calls     : AOBANKR0, AOFTFRR0, AOSARDR0, *PSSR              *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      ** Set up Copyright parameter.
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Move program name into *LDA field.
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     'FT0014'      DBPGM
     C                   OUT       LDA
      *
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Handle Database Error.
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Funds Transfer details.
      *
     C                   CALL      'AOFTFRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDFTFR        PARM      SDFTFR        DSFDY
      *
      ** Handle Database Error.
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDFTFRPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBASE = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR details for FX Charge Commissions (S01494).
      *
     C                   MOVEL     'N'           S01494            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'S01494'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** Handle Database Error.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY = 'S01494'
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   EVAL      S01494 = 'Y'
     C                   ENDIF
      *
      ** Access SAR details for FT VAT Processing (S01499).
      *
     C                   MOVEL     'N'           S01499            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'S01499'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** Handle Database Error.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY = 'S01499'
     C                   EVAL      DBASE = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   EVAL      S01499 = 'Y'
     C                   ENDIF
      *
      ** Report Work fields.
      *
     C                   Z-ADD     0             RQDLN1            3 0
     C                   Z-ADD     0             DIFLN1            3 0
     C                   Z-ADD     0             RCNT1
     C                   Z-ADD     0             RCNT2
      *
     C                   MOVE      *BLANK        WRCCY             3
      *
      *                                                                                       CFT120
      ** Access SAR details for CFT120                                                        CFT120
      *                                                                                       CFT120
     C                   MOVEL     'N'           CFT120            1                          CFT120
     C                   CALL      'AOSARDR0'                                                 CFT120
     C                   PARM      *BLANKS       PRTCD                                        CFT120
     C                   PARM      '*VERIFY'     POPTN                                        CFT120
     C                   PARM      'CFT120'      PSARD                                        CFT120
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT120
      *                                                                                       CFT120
      ** Handle Database Error.                                                               CFT120
      *                                                                                       CFT120
     C     PRTCD         IFNE      *BLANKS                                                    CFT120
     C     PRTCD         ANDNE     '*NRF   '                                                  CFT120
     C     *LOCK         IN        LDA                                                        CFT120
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT120
     C                   EVAL      DBKEY = 'CFT120'                                           CFT120
     C                   EVAL      DBASE = 5                                                  CFT120
     C                   OUT       LDA                                                        CFT120
     C                   EXSR      *PSSR                                                      CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C     PRTCD         IFEQ      *BLANKS                                                    CFT120
     C                   EVAL      CFT120 = 'Y'                                               CFT120
     C                   ENDIF                                                                CFT120
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINPAY - Incoming Payment details processing                *
      *                                                               *
      *  Called By : Main Processing                                  *
      *  Calls     : SRUPINX, SRWEND                                  *
      *                                                               *
      *****************************************************************
     C     SRINPAY       BEGSR
      *
     C                   OPEN      FT0014P1
     C                   EVAL      SFILE = 'INPAYDD  '
      *
      ** Read first record from file.
      *
     C     *LOVAL        SETLL     INPAY
     C                   READ      INPAYDDF                               89
      *
      ** Do Until End of File.
      *
     C                   DOW       *IN89 = *OFF
      *
      ** Count records read.
      *
     C                   ADD       1             RCNT1
      *
      ** Update INPAYDD.
      *
     C                   IF        INRCRT = 'N'
     C                   EVAL      INRCRT = 'F'
     C                   MOVEL     INRCO1        WFLD2             2
     C                   EVAL      INRCO1 = SMCY + WFLD2
     C                   ENDIF
      *
     C                   UPDATE    INPAYDDF
      *
      ** Update extension file.
      *
     C                   EXSR      SRUPINX
      *
      ** Read next record.
      *
     C                   READ      INPAYDDF                               89
      *
      ** End of Do Until End of Valid Records.
      *
     C                   ENDDO
      *
      ** Write final record and End of Report.
      *
     C                   EXSR      SRWEND
      *
     C                   CLOSE     FT0014P1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPINX - Update extension file                              *
      *                                                               *
      *  Called By : SRINPAY                                          *
      *  Calls     : SRFT10, SRCURR, SRWREC                           *
      *                                                               *
      *****************************************************************
     C     SRUPINX       BEGSR
      *
     C     PREF          CHAIN     INPAYXDF                           90
      *
      ** Initialise other fields.
      *
     C                   EVAL      INRECI = RECI
     C                   EVAL      INBOCD = 'CRED'
     C                   EVAL      INICD1 = *BLANK
     C                   EVAL      INICD2 = *BLANK
     C                   EVAL      INICD3 = *BLANK
     C                   EVAL      INICD4 = *BLANK
     C                   EVAL      INICD5 = *BLANK
     C                   EVAL      INTTCD = *BLANK
     C                   EVAL      INOEXR = *ZERO
     C                   EVAL      INTRIT = *BLANK
     C                   EVAL      INTRIB = *BLANK
     C                   EVAL      INTRN = *BLANK
     C                   EVAL      INTRI1 = *BLANK
     C                   EVAL      INTRI2 = *BLANK
     C                   EVAL      INTRI3 = *BLANK
     C                   EVAL      INTRI4 = *BLANK
     C                   EVAL      INTRI5 = *BLANK
     C                   EVAL      INSCH1 = *ZERO
     C                   EVAL      INSCH2 = *ZERO
     C                   EVAL      INSCH3 = *ZERO
     C                   EVAL      INSCH4 = *ZERO
     C                   EVAL      INSCH5 = *ZERO
     C                   EVAL      INSCY1 = *BLANK
     C                   EVAL      INSCY2 = *BLANK
     C                   EVAL      INSCY3 = *BLANK
     C                   EVAL      INSCY4 = *BLANK
     C                   EVAL      INSCY5 = *BLANK
     C                   EVAL      INRCRM = *ZERO
     C                   EVAL      INRCNW = *ZERO
     C                   EVAL      INRCCN = *BLANK
     C                   EVAL      INRCUS = *BLANK
     C                   EVAL      INRRP1 = *BLANK
     C                   EVAL      INRRP2 = *BLANK
     C                   EVAL      INRRP3 = *BLANK
     C                   EVAL      INFRNT = FRNT
     C                   EVAL      INREPA = REPA
     C                   EVAL      INTMST = TMST
      *
      ** If Details of Charges is 'OUR', Receiver's Charges Remitted
      ** must be the sum of all the charges in Settle Ccy.
      *
     C                   IF        DTCH = 'OUR'
      *
      ** Determine Charges Currency.
      *
     C                   SELECT
      *
     C**********         WHEN      CDRO <> *ZEROS                                             CFT120
     C                   WHEN      CDRO <> *BLANKS                                            CFT120
     C                   EVAL      WRCCY = BJCYCD
     C                   IF        INCDRC <> *BLANKS                                          CFT120
     C                             AND CFT120 = 'Y'                                           CFT120
     C                   EVAL      WRCCY = INCDRC                                             CFT120
     C                   ENDIF                                                                CFT120
      *
     C                   WHEN      ADDC = 'A'
     C                   EVAL      WRCCY = SMCY
      *
     C                   IF        SND1 = 'CASHIER' AND PCCY = BJCYCD
     C                   EVAL      WRCCY = PCCY
     C                   ENDIF
      *
     C                   OTHER
     C                   EVAL      WRCCY = PCCY
      *
     C                   ENDSL
      *
      ** Get total Charges.
      *
     C                   EVAL      INRCRM = TRCM + TXCH + CQCH + ADCH
     C                   EVAL      INRCRM = INRCRM + TLCH + MSCH
     C                   IF        S01494 = 'Y'
     C                   EVAL      INRCRM = INRCRM + INCHCM
     C                   ENDIF
     C                   IF        S01499 = 'Y'
     C                   EVAL      INRCRM = INRCRM + INVATT
     C                   ENDIF
      *
     C                   IF        WRCCY  <> SMCY
     C                   CLEAR                   P#0010
     C                   Z-ADD     INRCRM        P#FRAM
     C                   MOVE      WRCCY         P#FRCY
     C                   MOVE      SMCY          P#TOCY
     C                   Z-ADD     *ZERO         P#TOAM
     C                   EXSR      SRFT10
     C                   Z-ADD     P#TOAM        INRCRM
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Compute Original Exchange Rate.
      *
     C                   IF        PCCY <> *BLANK AND PYAM <> *ZERO AND
     C                             NDCY <> *BLANK AND NDAM <> *ZERO AND
     C                             INOEXR = 0
      *
     C                   CLEAR                   P#0010
     C                   MOVE      PCCY          P#DBCY
     C                   Z-ADD     PYAM          P#DBAM
     C                   MOVE      NDCY          P#CRCY
     C                   Z-ADD     NDAM          P#CRAM
     C                   EXSR      SRFT10
      *
      ** Get Instructed Currency decimal places.
      *
     C                   MOVEL     NDCY          P@CCY
     C                   EXSR      SRCURR
     C                   Z-ADD     A6NBDP        WNDDEC            1 0
      *
      ** Get Payment Currency decimal places.
      *
     C                   MOVEL     PCCY          P@CCY
     C                   EXSR      SRCURR
     C                   Z-ADD     A6NBDP        WPYDEC            1 0
      *
     C     WNDDEC        SUB       WPYDEC        WDIFF             1 0
      *
     C                   SELECT
      *
      ** Same number of decimal places, set workfield same as amounts.
      *
     C                   WHEN      WDIFF = 0
     C                   Z-ADD     NDAM          WNDAM            13 0
     C                   Z-ADD     PYAM          WPYAM            13 0
      *
      ** Instructed Ccy dec. greater than the Payment Ccy dec.,
      ** align Payment Amount to Instructed Amount.
      *
     C                   WHEN      WDIFF > 0
     C     PYAM          DIV       POWER(WDIFF)  WPYAM
     C                   Z-ADD     NDAM          WNDAM
      *
      ** Instructed Ccy dec. less  than the Payment Ccy dec.,
      ** align Instructed Amount to Payment Amount.
      *
     C                   WHEN      WDIFF < 0
     C                   Z-SUB     WDIFF         WDIFF
     C     NDAM          DIV       POWER(WDIFF)  WNDAM
     C                   Z-ADD     PYAM          WPYAM
      *
     C                   ENDSL
      *
      ** Calculate Original Rate depending on Mult/Div indicator
      ** (1 = Multiply otherwise, Divide) and set result as default.
      *
     C                   IF        P#MDIN =1
     C                   EVAL      INOEXR = WNDAM / WPYAM
     C                   ELSE
     C                   EVAL      INOEXR = WPYAM / WNDAM
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        *IN90 = *OFF
      *
      ** Update record.
      *
     C                   UPDATE    INPAYXDF
     C                   EVAL      SACTN = 'A'
      *
     C                   ELSE
      *
      ** Write record.
      *
     C                   EVAL      INPREF = PREF
     C                   EVAL      INSETM = *BLANK
     C                   EVAL      INSTPI = *BLANK
     C                   EVAL      INAUTO = 'N'
     C                   EVAL      INBANO = *BLANK
     C                   EVAL      INRUSR = *BLANK
     C                   EVAL      INWSID = *BLANK
     C                   EVAL      INRDAT = *BLANK
      *
     C                   WRITE     INPAYXDF
     C                   EVAL      SACTN = 'I'
      *
     C                   ENDIF
      *
      ** Write out the record.
      *
     C                   EXSR      SRWREC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROTPAY - Outgoing Payment details processing                *
      *                                                               *
      *  Called By : Main Processing                                  *
      *  Calls     : SRUPOTX, SRWEND                                  *
      *                                                               *
      *****************************************************************
     C     SROTPAY       BEGSR
      *
      ** Report Work fields.
      *
     C                   Z-ADD     0             RQDLN1
     C                   Z-ADD     0             DIFLN1
     C                   Z-ADD     6448          PRTLN1
      *
     C                   OPEN      FT0014P1
     C                   EVAL      SFILE = 'OTPAYDD  '
      *
      ** Read first record from file.
      *
     c     *LOVAL        SETLL     OTPAY
     C                   READ      OTPAYDDF                               89
      *
      ** Do Until End of File.
      *
     C                   DOW       *IN89 = *OFF
      *
      ** Count records read.
      *
     C                   ADD       1             RCNT2
      *
      ** Update extension file.
      *
     C                   EXSR      SRUPOTX
      *
      ** Read next record.
      *
     C                   READ      OTPAYDDF                               89
      *
      ** End of Do Until End of Valid Records.
      *
     C                   ENDDO
      *
      ** Write final record and End of Report.
      *
     C                   EXSR      SRWEND
      *
     C                   CLOSE     FT0014P1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPOTX - Update extension file                              *
      *                                                               *
      *  Called By : SROTPAY                                          *
      *  Calls     : SRFT10, SRCURR, SRWREC                           *
      *                                                               *
      *****************************************************************
     C     SRUPOTX       BEGSR
      *
     C     PREF          CHAIN     OTPAYXDF                           90
      *
      ** Initialise other fields.
      *
     C                   EVAL      OPRECI = RECI
     C                   EVAL      OPBOCD = 'CRED'
     C                   EVAL      OPICD1 = *BLANK
     C                   EVAL      OPICD2 = *BLANK
     C                   EVAL      OPICD3 = *BLANK
     C                   EVAL      OPICD4 = *BLANK
     C                   EVAL      OPICD5 = *BLANK
     C                   EVAL      OPTTCD = *BLANK
     C                   EVAL      OPOEXR = *ZERO
     C                   EVAL      OPTRIT = *BLANK
     C                   EVAL      OPTRI1 = *BLANK
     C                   EVAL      OPTRI2 = *BLANK
     C                   EVAL      OPTRI3 = *BLANK
     C                   EVAL      OPTRI4 = *BLANK
     C                   EVAL      OPTRI5 = *BLANK
     C                   EVAL      OPSCH1 = *ZERO
     C                   EVAL      OPSCH2 = *ZERO
     C                   EVAL      OPSCH3 = *ZERO
     C                   EVAL      OPSCH4 = *ZERO
     C                   EVAL      OPSCH5 = *ZERO
     C                   EVAL      OPSCC1 = *BLANK
     C                   EVAL      OPSCC2 = *BLANK
     C                   EVAL      OPSCC3 = *BLANK
     C                   EVAL      OPSCC4 = *BLANK
     C                   EVAL      OPSCC5 = *BLANK
     C                   EVAL      OPSCLE = *ZERO
     C                   EVAL      OPRCRM = *ZERO
     C                   EVAL      OPRBCQ = *ZERO
     C                   EVAL      OPRCSC = *ZERO
     C                   EVAL      OPRCSQ = *ZERO
     C                   EVAL      OPRCNW = *ZERO
     C                   EVAL      OPRCCN = *BLANK
     C                   EVAL      OPRCUS = *BLANK
     C                   EVAL      OPRRP1 = *BLANK
     C                   EVAL      OPRRP2 = *BLANK
     C                   EVAL      OPRRP3 = *BLANK
     C                   EVAL      OPFRNT = FRNT
     C                   EVAL      OPREPA = REPA
     C                   EVAL      OPTMST = TMST
      *
      ** If Details of Charges is 'BEN', Sender's Charges Deducted Amount
      ** 1 must be the sum of all the Charges in Pay Ccy.
      *
     C                   IF        DTCH = 'BEN'
      *
      ** Determine Charges Currency.
      *
     C                   SELECT
      *
     C**********         WHEN      CDRO <> *ZEROS                                             CFT120
     C                   WHEN      CDRO <> *BLANKS                                            CFT120
     C                   EVAL      WRCCY = BJCYCD
     C                   IF        OPCDRC <> *BLANKS                                          CFT120
     C                             AND CFT120 = 'Y'                                           CFT120
     C                   EVAL      WRCCY = OPCDRC                                             CFT120
     C                   ENDIF                                                                CFT120
      *
     C                   WHEN      ADDC = 'A'
     C                   EVAL      WRCCY = SMCY
      *
     C                   OTHER
     C                   EVAL      WRCCY = PCCY
      *
     C                   ENDSL
      *
     C                   MOVE      PCCY          OPSCC1
     C                   EVAL      OPSCLE = 1
      *
     C                   EVAL      OPSCH1 = TRCM + TXCH + CQCH + CSTA
     C                   EVAL      OPSCH1 = OPSCH1 + SPCH + MSCH
     C                   IF        S01494 = 'Y'
     C                   EVAL      OPSCH1 = OPSCH1 + OPCHCM
     C                   ENDIF
     C                   IF        S01499 = 'Y'
     C                   EVAL      OPSCH1 = OPSCH1 + OPVATT
     C                   ENDIF
      *
     C                   IF        WRCCY  <> PCCY
     C                   CLEAR                   P#0010
     C                   Z-ADD     OPSCH1        P#FRAM
     C                   MOVE      WRCCY         P#FRCY
     C                   MOVE      PCCY          P#TOCY
     C                   Z-ADD     *ZERO         P#TOAM
     C                   EXSR      SRFT10
     C                   Z-ADD     P#TOAM        OPSCH1
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Compute Original Exchange Rate.
      *
     C                   IF        PCCY <> *BLANK AND PYAM <> *ZERO AND
     C                             PDCY <> *BLANK AND PDAM <> *ZERO AND
     C                             OPOEXR = 0
      *
     C                   CLEAR                   P#0010
     C                   MOVE      PCCY          P#DBCY
     C                   Z-ADD     PYAM          P#DBAM
     C                   MOVE      PDCY          P#CRCY
     C                   Z-ADD     PDAM          P#CRAM
     C                   EXSR      SRFT10
      *
      ** Get Instructed Currency decimal places.
      *
     C                   MOVEL     PDCY          P@CCY
     C                   EXSR      SRCURR
     C                   Z-ADD     A6NBDP        WPDDEC            1 0
      *
      ** Get Payment Currency decimal places.
      *
     C                   MOVEL     PCCY          P@CCY
     C                   EXSR      SRCURR
     C                   Z-ADD     A6NBDP        WPYDEC
      *
     C     WPDDEC        SUB       WPYDEC        WDIFF
      *
     C                   SELECT
      *
      ** Same number of decimal places, set workfield same as amounts.
      *
     C                   WHEN      WDIFF = 0
     C                   Z-ADD     PDAM          WPDAM            11 0
     C                   Z-ADD     PYAM          WPYAM
      *
      ** Instructed Ccy dec. greater than the Payment Ccy dec.,
      ** align Payment Amount to Instructed Amount.
      *
     C                   WHEN      WDIFF > 0
     C     PYAM          DIV       POWER(WDIFF)  WPYAM
     C                   Z-ADD     PDAM          WPDAM
      *
      ** Instructed Ccy dec. less  than the Payment Ccy dec.,
      ** align Instructed Amount to Payment Amount.
      *
     C                   WHEN      WDIFF < 0
     C                   Z-SUB     WDIFF         WDIFF
     C     PDAM          DIV       POWER(WDIFF)  WPDAM
     C                   Z-ADD     PYAM          WPYAM
      *
     C                   ENDSL
      *
      ** Calculate Original Rate depending on Mult/Div indicator
      ** (1 = Multiply otherwise, Divide) and set result as default.
      *
     C                   IF        P#MDIN = 1
     C                   EVAL      OPOEXR = WPDAM / WPYAM
     C                   ELSE
     C                   EVAL      OPOEXR = WPYAM / WPDAM
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        *IN90 = *OFF
      *
      ** Update record.
      *
     C                   UPDATE    OTPAYXDF
     C                   EVAL      SACTN = 'A'
      *
     C                   ELSE
      *
      ** Write record.
      *
     C                   EVAL      OPPREF = PREF
     C                   EVAL      OPBJPR = *BLANK
     C                   EVAL      OPAUTO = 'N'
     C                   EVAL      OPSTPI = *BLANK
     C                   EVAL      OPBANO = *BLANK
     C                   EVAL      OPRUSR = *BLANK
     C                   EVAL      OPWSID = *BLANK
     C                   EVAL      OPRDAT = *BLANK
     C                   MOVE      STMT          OPSETM
      *
     C                   WRITE     OTPAYXDF
     C                   EVAL      SACTN = 'I'
      *
     C                   ENDIF
      *
      ** Write out the record.
      *
     C                   EXSR      SRWREC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWREC - Subroutine to write a Detail record to the Report   *
      *                                                               *
      *  Called By : SRUPINX, SRUPOTX                                 *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
     C     SRWREC        BEGSR
      *
     C                   EVAL      SPREF = PREF
     C                   EVAL      SSTAT = *BLANK
     C                   SELECT
     C                   WHEN      RECI = 'D'
     C                   EVAL      SSTAT = 'LIVE'
     C                   WHEN      RECI = 'M'
     C                   EVAL      SSTAT = 'MATURED'
     C                   WHEN      RECI = 'C'
     C                   EVAL      SSTAT = 'DELETED'
     C                   ENDSL
      *
      ** Check that sufficient lines remain for the Format.  If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADPY
     C                   ENDIF
      *
      ** Write out Detail Record.
      *
     C                   WRITE     DETAIL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWEND - Subroutine to write End of Report                   *
      *                                                               *
      *  Called By : SRINPAY, SROTPAY                                 *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
     C     SRWEND        BEGSR
      *
      ** Check that sufficient lines remain for the Format.  If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     4             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADPY
     C                   ENDIF
      *
      ** Write out Total Format.
      *
     C                   WRITE     TRAILPY
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAUDIT - Output Audit report                                *
      *                                                               *
      *  Called By : Main Processing, *PSSR                           *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
     C     SRAUDIT       BEGSR
      *
      ** Output Report Header.
      *
     C                   WRITE     HEADAU
      *
      ** If there is a DB Error, Output the DB Error Information.
      *
     C     *INU7         IFEQ      *ON
     C                   WRITE     DBERROR
     C                   ELSE
      *
      ** Or, if no records read, output "No Details" message.
      *
     C                   IF        RCNT1 = 0 AND RCNT2 = 0
     C                   WRITE     NODTLS
     C                   ELSE
      *
      ** Output Report Header and File Controls.
      *
     C                   WRITE     CONTROL
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFT10 - Subroutine to convert Amount to another Currency    *
      *                                                               *
      *  Called By : SRUPINX, SRUPOTX                                 *
      *  Calls     : FT0010, *PSSR                                    *
      *                                                               *
      *****************************************************************
     C     SRFT10        BEGSR
      *
     C                   MOVE      *BLANKS       P#NDCY
     C                   Z-ADD     *ZEROS        P#NDAM
     C                   MOVE      *BLANK        P#PDCY
     C                   Z-ADD     *ZEROS        P#PDAM
     C                   Z-ADD     *ZEROS        P#DBDT
     C                   Z-ADD     *ZEROS        P#CRDT
     C                   Z-ADD     *ZEROS        P#RATE
     C                   MOVE      *BLANKS       P#OVRT
     C                   MOVE      *BLANKS       P#SDIN
     C                   MOVE      BTPCRD        P#RTDS
     C                   MOVE      *BLANKS       P#PMSQ
     C                   MOVE      *BLANKS       P#INDC
     C                   MOVE      *BLANKS       P#RTCD
      *
     C                   CALL      'FT0010'
     C                   PARM                    P#0010
      *
     C                   IF        P#RTCD = '*ERROR'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'FT0010 '
     C                   EVAL      DBKEY = '*CALL  '
     C                   EVAL      DBASE = 6
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCURR - Access Currency details                             *
      *                                                               *
      *  Called By : SRUPINX, SRUPOTX                                 *
      *  Calls     : AOCURRR0, *PSSR                                  *
      *                                                               *
      *****************************************************************
     C     SRCURR        BEGSR
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    P@CCY             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = P@CCY
     C                   EVAL      DBASE = 7
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error Control subroutine                            *
      *                                                               *
      *  Called By :                                                  *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
      *
      ** Check to see that *PSSR has not already been called.
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
     C                   EXSR      SRAUDIT
     C                   DUMP
     C                   ENDIF
      *
      ** If *PSSR already run, then just end the program here.
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**   POWER - Array of POWERS of 10 for Currency Conversions
0000001
0000010
0000100
0001000
0010000
0100000
1000000
