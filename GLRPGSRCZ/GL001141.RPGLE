     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Amount Amortisation Update & Entry Gen')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL001141 - Midas GL Amount Amortisation Update & Entry       *
      *             Generation                                        *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BUG13574           Date 19Mar07               *
      *                 BUG13288           Date 14Feb07               *
      *                 BUG13056A          Date 29Jan06               *
      *                 BUG13041           Date 16Jan06               *
      *                 BUG12616           Date 15Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242475             Date 03Oct06               *
      *                 242286             Date 27Sep06               *
      *                 CSD027             Date 09Dec05               *
      *                 233545             Date 18May05               *
      *                 CAS011             Date 16May05               *
      *                 CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG13574 - Negative balance in the amount Unamortised posted *
      *             to date/Amortisation in excess of the original    *
      *             discount                                          *
      *  BUG13288 - Overcomputation of GL Amounts                     *
      *  BUG13056A - Overcomputation of GL transaction if next        *
      *             working day is the maturity date.                 *
      *  BUG13041 - Incorrect amount in the "Amount Amortised posted  *
      *           to date"                                            *
      *  BUG12616 - Wrong computation of amortisation amount with     *
      *             respect to last day accrual indicator.            *
      *  242475 - DBASE 104 due to wrong test on PRTCD.               *
      *  242286 - Enhance calculation of interest for calc basis 6.   *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  233545 - Cut-off Date (Recompile)                            *
      *  CAS011 - EIR/AC Accouting Upgrade to MP1                     *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    02         Live detail record.                             *
      *    03         Matured record.                                 *
      *    04         Reversed record.                                *
      *    05         Catchall.                                       *
      *    43         Accrual processing required.                    *
      *    50         Suppress output of amount amortisation record.  *
      *    51         Live record to be output.                       *
      *    52         Posting amount is zero.                         *
      *    53         Posting is to be generated.                     *
      *    54         Posting to be generated is negative.            *
      *    60         Reversal processing performed.                  *
      *    61         Maturity processing performed.                  *
      *    62         Amortisation processing performed.              *
      *                                                               *
      *    U7+U8      Database error.                                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Accounts Master
 
     FGLAMRTL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Amount Amortisations Details File
 
     FGLAMRZPD  IF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(ZZ)
      ** Midas GL Amount Amortisations Trailer File
 
     FGLNAMRPD  O    E             DISK    INFSR(*PSSR)
     F                                     RENAME(GLAMRTD0:GLNAMRD0)
      ** Midas GL New Amount Amortisations Details File
 
     FGLNAMZPD  O    E             DISK    INFSR(*PSSR)
     F                                     RENAME(GLAMRZD0:GLNAMZD0)
     F                                     PREFIX(ZZ)
      ** Midas GL New Amount Amortisations Trailer File
 
     FGEAAPD    O    E             DISK    INFSR(*PSSR) PREFIX(AC)
      ** Midas GL Amount Accruals Generated Entries Detail
 
     FGEAAZZ    UF A E             DISK    INFSR(*PSSR) PREFIX(AA)
      ** Midas GL Generated Entries Amount Accruals Trailer
 
     FGL001141AUO    E             PRINTER
      ** Midas GL Amount Amortisation Update & Entry Generation Audit
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Copyright Statement Array
     D CPY@            S             80A   DIM(1) CTDATA
 
      ** Run Date Data Area Layout
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
      ** Local Data Area Data Structure
     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)
 
      ** Customer Details Data Structure
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Currency Details Data Structure
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** General Ledger Details Data Structure
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** Hedging ICD Data Structure
     D SDHEDG        E DS                  EXTNAME(SDHEDGPD)
 
      ** Account Code Details Data Structure
     D SDACOD        E DS                  EXTNAME(SDACODPD)
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CAS011
 
      ** Module Details Data Structure
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Switchable Feature Details Data Structure
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Posting Narrative Data Structure
     D CGPNAR        E DS                  EXTNAME(CGPNARPD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Access Object Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Access Object Parameters
     D PRtCd           S              7A
     D POptn           S              7A
     D PSARD           S              6A
     D PCust           S             10A
     D PCurr           S              3A
     D PKyst           S              7A
     D PACod           S                   LIKE(A5ACCD)
     D PZRtCd          S              7A
     D PZMgID          S              7A
     D PZParm          S              9A
     D PZNarr          S             50A
     D PZNar1          S                   LIKE(A1NARR)
     D PZNar2          S                   LIKE(A1NARR)
     D PZPNar          S                   LIKE(CGPNAR)
 
      ** Standard Utility Parameters
     D PZDayN          S              5P 0
     D PZDatF          S              1A
     D PZDate          S              6P 0
     D PZADat          S              7A
 
      ** Key Fields
     D KCust           S                   LIKE(CNUM)
     D KCcy            S                   LIKE(CCY)
     D KAcod           S                   LIKE(ACOD)
     D KAcsq           S                   LIKE(ACSQ)
     D KBrca           S                   LIKE(BRCA)
 
      ** Switchable Features
     D GLPNAR          S              1A   INZ('N')
     D*CGL003***       S              1A   INZ('N')                                         BUG13041
 
      ** Standard Subroutine Variables
     D ZZAMT           S             15P 3
     D ZZAMTI          S             15P 0
     D ZZAMTD          S              3P 0
     D ZZNEGD          S              5A
     D ZZTOTI          S             15P 0
     D ZZTOTD          S              3P 0
     D ZZWK2           S              4P 0
     D ZZWK3           S             15P 0
 
      ** Working Variables
     D WNWDM           S              5P 0
     D WMatMY          S              5A
     D WRunMY          S              5A
     D WACod           S                   LIKE(ACOD)
     D WDATp           S                   LIKE(ATYP)
     D WDAcN           S                   LIKE(ACNO)
     D WDAcS           S                   LIKE(A5ACSC)
     D WCATp           S                   LIKE(ATYP)
     D WCAcN           S                   LIKE(ACNO)
     D WCAcS           S                   LIKE(A5ACSC)
     D WKCus           S              6A
     D WKACo           S                   LIKE(A5ACCD)
     D WKAcS           S              2A
     D WBits           S              1A
     D WEvtDat         S              5P 0
     D WNDYr           S              3P 0
     D WDays           S              6P 0
     D Wt              S             15P12
     D WTmp1           S             17P12
     D WAAtbP          S             30P12
     D WAAtbP1         s             30P12                                                  BUG13288
     D WActAmt         S             30P12
     D WPosAmt         S                   LIKE(A1AATD)
     D WAmt            S                   LIKE(A1AATD)
     D WNoReA          S              5P 0
     D WTotAW          S             15P 0
     D WTotAD          S              3P 0
     D WNoReL          S              5P 0
     D WTotLW          S             15P 0
     D WTotLD          S              3P 0
     D WNoReG          S              5P 0
     D WNoRAO          S              5P 0
     D WToAWO          S             15P 0
     D WToADO          S              3P 0
     D WNoRLO          S              5P 0
     D WToLWO          S             15P 0
     D WToLDO          S              3P 0
     D WPAmt           S             15P 0
     D RetCodeOut      S             10
     D***PINT6DY*      S             15  7                                                    242286
     D PINT6DY         S             15  9                                                    242286
     D PINTDY          S              5  0
     D WNOREZ          S              5  0
     D WNORLZ          S              5  0
     D WTOTAZ          S             15P 0
     D WTOTLZ          S             15P 0
     D WTODAZ          S              3P 0
     D WTODLZ          S              3P 0
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
     C     *LOVAL        SETLL     GLAMRTL1
     C                   READ      GLAMRTL1
 
     C                   DOW       NOT %EOF
     C                   EXSR      SRIden
     C                   EXSR      SRProc
     C                   EXSR      SRWrite
     C                   READ      GLAMRTL1
     C                   ENDDO
 
     C                   EXSR      SRAudit
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIden - Identifies an amount amortisation record.           *
      *                                                               *
      *****************************************************************
     C     SRIden        BEGSR
 
     C                   EVAL      *IN02 = *OFF
     C                   EVAL      *IN03 = *OFF
     C                   EVAL      *IN04 = *OFF
     C                   EVAL      *IN05 = *OFF
 
     C                   SELECT
     C                   WHEN      A1RECI = 'D' AND
     C                             A1CHTP <> 'D'
     C                   EVAL      *IN02 = *ON
     C                   WHEN      A1RECI = 'M'
     C                   EVAL      *IN03 = *ON
     C                   WHEN      A1RECI = 'C' AND
     C                             A1CHTP = 'D'
     C                   EVAL      *IN04 = *ON
     C                   OTHER
     C                   EVAL      *IN05 = *ON
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Processes amount amortisation records.              *
      *                                                               *
      *****************************************************************
     C     SRProc        BEGSR
 
     C                   EVAL      *IN50 = *OFF
     C                   EVAL      *IN51 = *OFF
     C                   EVAL      *IN52 = *OFF
     C                   EVAL      *IN53 = *OFF
     C                   EVAL      *IN54 = *OFF
     C                   EVAL      *IN60 = *OFF
     C                   EVAL      *IN61 = *OFF
     C                   EVAL      *IN62 = *OFF
 
      ** Skip processing if not a detail record.
 
     C                   IF        *IN05 = *ON
     C                   LEAVESR
     C                   ENDIF
 
      ** Record count & hash totals for active records.
 
     C                   EVAL      WNoReA = WNoReA + 1
     C                   EVAL      ZZTOTI = WTotAW
     C                   EVAL      ZZTOTD = WTotAD
     C                   EVAL      ZZAMT = *ZERO
     C                   MOVE      A1DSAM        ZZAMT
     C                   EXSR      SRGLZADD
     C                   EVAL      WTotAW = ZZTOTI
     C                   EVAL      WTotAD = ZZTOTD
 
      ** Record count & hash totals for live records.
 
     C                   IF        *IN03 = *OFF AND
     C                             *IN04 = *OFF
     C                   EVAL      WNoReL = WNoReL + 1
     C                   EVAL      ZZTOTI = WTotLW
     C                   EVAL      ZZTOTD = WTotLD
     C                   EVAL      ZZAMT = *ZERO
     C                   MOVE      A1DSAM        ZZAMT
     C                   EXSR      SRGLZADD
     C                   EVAL      WTotLW = ZZTOTI
     C                   EVAL      WTotLD = ZZTOTD
     C                   ENDIF
 
      ** Drop any record that matured in a previous month.
 
     C                   IF        *IN03 = *ON
     C                   EVAL      PZDayN = A1MDAT
     C                   EXSR      SRZDate
     C                   MOVE      PZADat        WMatMY
     C                   MOVE      BJMRDT        WRunMY
 
     C                   IF        WRunMY <> WMatMY
     C                   EVAL      *IN50 = *ON
     C                   EXSR      SRFinish
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
 
      ** Generate entries for reversals.
 
     C                   IF        *IN04 = *ON
     C                   EVAL      *IN60 = *ON
     C                   EXSR      SRRever
     C                   EXSR      SRFinish
     C                   LEAVESR
     C                   ENDIF
 
      ** Process maturing records.
 
     C                   IF        *IN02 = *ON
 
      ** Check if record matures before next working day.
 
     C                   IF        A1MDAT < BJDNWD
     C                   EVAL      *IN61 = *ON
 
      ** Generate entries for maturity.
 
     C                   EXSR      SRMatur
     C                   EXSR      SRFinish
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
 
      ** Do amortisation processing if required.
 
     C                   IF        *IN02 = *OFF OR
     C**********                   (CGL003 = 'N' AND                                        BUG13041
     C**********                   *IN43 = *OFF)                                            BUG13041
     C                             *IN43 = *OFF                                             BUG13041
     C                   EXSR      SRFinish
     C                   LEAVESR
     C                   ENDIF
 
      ** Check if start date has been reached.
 
     C**********         IF        CGL003 = 'N'                                             BUG13041
     C                   IF        BKAPDT < A1STDT
     C                   EXSR      SRFinish
     C                   LEAVESR
     C                   ENDIF
     C**********         ENDIF                                                              BUG13041
 
      ** Get the Amount Amortised to be Posted.
 
     C                   EXSR      SRGetAAtbP
 
      ** Generate entries for amortisation.
 
     C                   EXSR      SRAmort
     C                   EVAL      *IN62 = *ON
     C                   EXSR      SRFinish
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFinish - Finishes amount amortisation record processing.   *
      *                                                               *
      *****************************************************************
     C     SRFinish      BEGSR
 
      ** Get the narratives.
 
     C                   EXSR      SRGetNarr
 
     C                   IF        *IN50 = *OFF
 
      ** Check if live record is to be output.
 
     C                   IF        (*IN02 = *ON AND
     C                             *IN53 = *OFF AND
     C                             *IN61 = *OFF) OR
     C                             *IN62 = *ON
     C                   EVAL      *IN51 = *ON
     C                   ENDIF
 
      ** Record count & hash totals for active records (output).
 
     C                   EVAL      WNoRAO = WNoRAO + 1
     C                   EVAL      ZZTOTI = WToAWO
     C                   EVAL      ZZTOTD = WToADO
     C                   EVAL      ZZAMT = *ZERO
     C                   MOVE      A1DSAM        ZZAMT
     C                   EXSR      SRGLZADD
     C                   EVAL      WToAWO = ZZTOTI
     C                   EVAL      WToADO = ZZTOTD
 
      ** Record count & hash totals for live records (output).
 
     C                   IF        *IN51 = *ON
     C                   EVAL      WNoRLO = WNoRLO + 1
     C                   EVAL      ZZTOTI = WToLWO
     C                   EVAL      ZZTOTD = WToLDO
     C                   EVAL      ZZAMT = *ZERO
     C                   MOVE      A1DSAM        ZZAMT
     C                   EXSR      SRGLZADD
     C                   EVAL      WToLWO = ZZTOTI
     C                   EVAL      WToLDO = ZZTOTD
     C                   ENDIF
 
     C                   ENDIF
 
      ** Record count & hash total of generated entries.
 
     C                   IF        *IN53 = *ON OR
     C                             *IN54 = *ON
     C                   EVAL      WNoReG = WNoReG + 2
     C                   EVAL      ZZTOTI = AAHRWN
     C                   EVAL      ZZTOTD = AAHRDC
     C                   EVAL      WPAmt = WPosAmt * 2
     C                   EVAL      ZZAMT = WPAmt / 1000
     C                   EXSR      SRGLZADD
     C                   EVAL      AAHRWN = ZZTOTI
     C                   EVAL      AAHRDC = ZZTOTD
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrite - Writes output records.                             *
      *                                                               *
      *****************************************************************
     C     SRWrite       BEGSR
 
      ** Write new amount amortisations.
 
     C                   IF        *IN50 = *OFF
     C                   IF        *IN02 = *ON OR
     C                             *IN03 = *ON OR
     C                             *IN04 = *ON
 
     C                   IF        *IN60 = *ON
     C                   EVAL      A1RECI = '*'
     C                   ENDIF
 
     C                   IF        *IN61 = *ON
     C                   EVAL      A1RECI = 'M'
     C                   ENDIF
 
     C                   WRITE     GLNAMRD0
 
      ** Update Trailer File
     C                   EVAL      WNOREZ = WNOREZ + 1
     C                   EVAL      ZZTOTI = WTOTAZ
     C                   EVAL      ZZTOTD = WTODAZ
     C                   EVAL      ZZAMT = *ZERO
     C                   MOVE      A1DSAM        ZZAMT
     C                   EXSR      SRGLZADD
     C                   EVAL      WTOTAZ = ZZTOTI
     C                   EVAL      WTODAZ = ZZTOTD
 
     C                   IF        A1RECI = 'D'
     C                   EVAL      WNORLZ = WNORLZ + 1
     C                   EVAL      ZZTOTI = WTOTLZ
     C                   EVAL      ZZTOTD = WTODLZ
     C                   EVAL      ZZAMT = *ZERO
     C                   MOVE      A1DSAM        ZZAMT
     C                   EXSR      SRGLZADD
     C                   EVAL      WTOTLZ = ZZTOTI
     C                   EVAL      WTODLZ = ZZTOTD
 
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** Generate entries.
 
     C                   IF        *IN53 = *ON OR
     C                             *IN54 = *ON
 
      ** Debit a/c details.
 
     C                   EVAL      ACRECI = 'P'
     C                   EVAL      ACCNUM = A1DRCN
     C                   EVAL      ACCCY  = A1CCY
     C                   EVAL      ACACOD = A1DRCO
     C                   EVAL      ACACSQ = A1DRSQ
     C                   EVAL      ACACNO = WDACN
     C                   EVAL      ACPSTD = BJRDNB
 
     C                   SELECT
     C                   WHEN      *IN60 = *ON
     C                   Z-ADD     BJRDNB        ACVALD
     C                   WHEN      *IN61 = *ON
     C                   Z-ADD     A1MDAT        ACVALD
     C                   WHEN      *IN62 = *ON
     C                   Z-ADD     BKAPDT        ACVALD
     C                   ENDSL
 
     C                   MOVE      PZNAR1        ACPNAR
     C                   Z-ADD     WPosAmt       ACPSTA
 
     C                   IF        *IN54 = *ON
     C                   IF        *IN60 = *ON
     C                   EVAL      ACDRCR = 0
     C                   ELSE
     C                   EVAL      ACDRCR = 1
     C                   ENDIF
     C                   ELSE
     C                   IF        *IN60 = *ON
     C                   EVAL      ACDRCR = 1
     C                   ELSE
     C                   EVAL      ACDRCR = 0
     C                   ENDIF
     C                   ENDIF
 
     C**********         EVAL      ACASOC = *ZERO                                             CSD027
     C                   EVAL      ACASOC = *BLANKS                                           CSD027
     C                   EVAL      ACCHQN = *ZERO
     C                   EVAL      ACSPOS = 'GE-AM'
     C                   EVAL      ACBRCA = A1BRCA
 
     C                   IF        WDATp = 'R'
     C                   EVAL      ACRIND = 1
     C                   ELSE
     C                   EVAL      ACRIND = 0
     C                   ENDIF
 
     C                   EVAL      ACREJC = *ZERO
     C                   EVAL      ACRRNM = *ZERO
     C                   EVAL      ACATYP = WDATp
     C                   BITOFF    '1'           WBits
     C                   EVAL      ACPRIN = WBits
     C                   EVAL      ACGETP = 'M'
     C                   EVAL      ACACUM = 0
     C                   EVAL      ACPRFC = A1PRFC
     C                   EVAL      ACPTIM = 235959
     C                   EVAL      ACVOIN = 0
     C                   EVAL      ACACSC = WDAcS
     C                   MOVE      *BLANKS       ACOTRF
     C                   MOVEL     A1AREF        ACOTRF
     C                   EVAL      ACOTST = *ZERO
     C                   EVAL      ACOTTP = *ZERO
     C                   EVAL      ACSDCB = *ZERO
     C                   EVAL      ACSDLB = *ZERO
 
     C                   WRITE     APOSTPDF
 
      ** Credit a/c details.
 
     C                   EVAL      ACCNUM = A1CRCN
     C                   EVAL      ACACOD = A1CRCO
     C                   EVAL      ACACSQ = A1CRSQ
     C                   EVAL      ACACNO = WCAcN
     C                   EVAL      ACPNAR = PZNar2
 
     C                   IF        *IN54 = *ON
     C                   IF        *IN60 = *ON
     C                   EVAL      ACDRCR = 1
     C                   ELSE
     C                   EVAL      ACDRCR = 0
     C                   ENDIF
     C                   ELSE
     C                   IF        *IN60 = *ON
     C                   EVAL      ACDRCR = 0
     C                   ELSE
     C                   EVAL      ACDRCR = 1
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WCATp = 'R'
     C                   EVAL      ACRIND = 1
     C                   ELSE
     C                   EVAL      ACRIND = 0
     C                   ENDIF
 
     C                   EVAL      ACATYP = WCATp
     C                   EVAL      ACACSC = WCAcS
 
     C                   WRITE     APOSTPDF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Writes audit records.                              *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
 
      ** Write the trailer.
 
     C                   EVAL      AANORE1 = WNoReg + AANORE1
 
     C                   IF        *IN01 = '1'
     C                   EVAL      AARECI = 'T'
     C                   EVAL      AANORE1 = AANORE1 + 2
     C                   WRITE     APOSTZZF
     C                   ELSE
     C                   UPDATE    APOSTZZF
     C                   ENDIF
 
     C                   EVAL      ZZNORE = WNOREZ
     C                   EVAL      ZZLIVN = WNORLZ
     C                   EVAL      ZZHRWN = WTOTAZ
     C                   EVAL      ZZHRDN = WTODAZ
     C                   EVAL      ZZLIVH = WTOTLZ
     C                   EVAL      ZZLVED = WTODLZ
     C                   WRITE     GLNAMZD0
      ** Write the audit report.
 
     C                   WRITE     HEADAU
 
     C                   IF        *INU7 = *OFF AND
     C                             *INU8 = *OFF
 
     C                   EVAL      RNOREA = WNoReA
     C                   EVAL      RTOTAW = WTotAW
     C                   EVAL      RTOTAD = WTotAD
     C                   EVAL      RNOREL = WNoReL
     C                   EVAL      RTOTLW = WTotLW
     C                   EVAL      RTOTLD = WTotLD
     C                   EVAL      RNORLO = WNoRLO
     C                   EVAL      RTOLWO = WToLWO
     C                   EVAL      RTOLDO = WToLDO
     C                   EVAL      RNORAO = WNoRAO
     C                   EVAL      RTOAWO = WToAWO
     C                   EVAL      RTOADO = WToADO
     C                   EVAL      RNOREG = WNoReG
     C                   EVAL      RTOTGW = AAHRWN
     C                   EVAL      RTOTGD = AAHRDC
     C                   WRITE     CONTROL
 
     C                   ELSE
     C                   WRITE     DBERROR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRever - Generates entry details for reversals.             *
      *                                                               *
      *****************************************************************
     C     SRRever       BEGSR
 
      ** Get a/c details for debit & credit account.
 
     C                   EXSR      SRGetAccn
 
     C                   EVAL      *IN52 = *OFF
     C                   EVAL      *IN53 = *OFF
     C                   EVAL      *IN54 = *OFF
 
      ** Generate posting amount.
 
     C                   EVAL      WPosAmt = A1AATD
 
     C                   SELECT
     C                   WHEN      WPosAmt = *ZERO
     C                   EVAL      *IN52 = *ON
     C                   WHEN      WPosAmt > *ZERO
     C                   EVAL      *IN53 = *ON
     C                   WHEN      WPosAmt < *ZERO
     C                   EVAL      *IN54 = *ON
     C                   Z-SUB     WPosAmt       WPosAmt
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMatur - Generates entry & update details for maturity.     *
      *                                                               *
      *****************************************************************
     C     SRMatur       BEGSR
 
      ** Get a/c details for debit & credit account.
 
     C                   EXSR      SRGetAccn
 
      ** Generate posting amount.
 
     C                   EVAL      *IN52 = *OFF
     C                   EVAL      *IN53 = *OFF
     C                   EVAL      *IN54 = *OFF
 
     C                   EVAL      WPosAmt = A1DSAM - A1AATD
 
     C                   SELECT
     C                   WHEN      WPosAmt = *ZERO
     C                   EVAL      *IN52 = *ON
     C                   WHEN      WPosAmt > *ZERO
     C                   EVAL      *IN53 = *ON
     C                   WHEN      WPosAmt < *ZERO
     C                   EVAL      *IN54 = *ON
     C                   Z-SUB     WPosAmt       WPosAmt
     C                   ENDSL
 
      ** Update amortisation file fields.
 
     C                   EVAL      A1AATD = A1DSAM
     C                   EVAL      A1UNAM = *ZERO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAmort - Generates entry & update details for amortisation. *
      *                                                               *
      *****************************************************************
     C     SRAmort       BEGSR
 
      ** Get a/c details for debit & credit account.
 
     C                   EXSR      SRGetAccn
 
      ** Generate posting amount.
 
     C                   EVAL      *IN52 = *OFF
     C                   EVAL      *IN53 = *OFF
     C                   EVAL      *IN54 = *OFF
 
     C                   Z-ADD     WAmt          WPosAmt
 
     C                   SELECT
     C                   WHEN      WPosAmt = *ZERO
     C                   EVAL      *IN52 = *ON
     C                   WHEN      WPosAmt > *ZERO
     C                   EVAL      *IN53 = *ON
     C                   WHEN      WPosAmt < *ZERO
     C                   EVAL      *IN54 = *ON
     C                   Z-SUB     WPosAmt       WPosAmt
     C                   ENDSL
 
      ** Update amortisation file fields.
 
     C                   EVAL      A1AATD = A1AATD + WAmt
     C                   EVAL      A1UNAM = A1UNAM - WAmt
 
     C                   EVAL      *IN51 = *ON
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetAccn - Gets a/c details for postings.                   *
      *                                                               *
      *****************************************************************
     C     SRGetAccn     BEGSR
 
      ** Debit a/c details.
 
     C                   EVAL      KCust = A1DRCN
     C                   EVAL      KCcy =  A1CCY
     C                   EVAL      KACod = A1DRCO
     C                   EVAL      WACod = KACOD
     C                   EVAL      KAcSq = A1DRSQ
     C                   EVAL      KBrca = A1BRCA
     C                   EXSR      SRGetAcct
 
     C                   EVAL      WDATp = ATYP
     C                   EVAL      WDAcN = ACNO
     C                   MOVE      WACod         PACod
     C                   EXSR      SRGetACod
     C                   EVAL      WDAcS = A5ACSC
 
      ** Credit a/c details.
 
     C                   EVAL      KCust = A1CRCN
     C                   EVAL      KCcy = A1CCY
     C                   EVAL      KACod = A1CRCO
     C                   EVAL      WACod = KACOD
     C                   EVAL      KAcSq = A1CRSQ
     C                   EVAL      KBrca = A1BRCA
     C                   EXSR      SRGetAcct
 
     C                   EVAL      WCATp = ATYP
     C                   EVAL      WCAcN = ACNO
     C                   MOVE      WACod         PACod
     C                   EXSR      SRGetACod
     C                   EVAL      WCAcS = A5ACSC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetACod - Gets a/c code details.                           *
      *                                                               *
      *****************************************************************
     C     SRGetACod     BEGSR
 
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PACod
     C*****SDACOD        PARM      SDACOD        DSFDY                                        CAS011
     C     SDACOD        PARM      SDACOD        DSSDY                                        CAS011
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDACODPD'
     C                   EVAL      DBKey = PACod
     C                   EVAL      DBase = 106
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetCurr - Gets currency details.                           *
      *                                                               *
      *****************************************************************
     C     SRGetCurr     BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCurr
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBKey = PCurr
     C                   EVAL      DBase = 107
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetAcct - Gets a/c details.                                *
      *                                                               *
      *****************************************************************
     C     SRGetAcct     BEGSR
 
     C     KACCN         CHAIN     ACCNT
 
     C                   IF        NOT %FOUND OR
     C                             (%FOUND AND
     C                             RECI <> 'D' AND
     C                             RECI <> 'C')
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'ACCNTAB'
     C                   MOVE      KCust         WKCus
     C                   MOVE      KACod         WKACo
     C                   MOVE      KAcSq         WKAcS
     C                   EVAL      DBKey = WKCus + KCcy + WKAco  +
     C                                     WKAcS + KBrca
     C                   EVAL      DBase = 108
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetCust - Gets customer details.                           *
      *                                                               *
      *****************************************************************
     C     SRGetCust     BEGSR
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCust
     C                   PARM      *BLANKS       PKyst
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   EVAL      DBKey = PCust
     C                   EVAL      DBase = 109
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetPNar - Gets narrative details.                          *
      *                                                               *
      *****************************************************************
     C     SRGetPNar     BEGSR
 
     C                   CALL      'AOPNARR0'
     C                   PARM      *BLANKS       PZRtCd
     C                   PARM                    PZMgID
     C                   PARM      *BLANKS       PZParm
     C     CGPNAR        PARM      CGPNAR        PZPNar
     C                   PARM      *BLANKS       PZNarr
 
     C                   IF        PZRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'CGPNARPD'
     C                   EVAL      DBKey = MNCUST
     C                   EVAL      DBase = 110
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetNarr - Gets the narratives.                             *
      *                                                               *
      *****************************************************************
     C     SRGetNarr     BEGSR
 
     C                   EVAL      PZNar1 = *BLANKS
     C                   EVAL      PZNar2 = *BLANKS
 
      ** Get narrative details if GLPNAR is enabled. Use existing
      ** defaults otherwise.
 
     C                   IF        GLPNAR = 'Y'
 
      ** Get debit customer details.
 
     C                   EVAL      PCust = *BLANKS
     C                   MOVEL     A1DRCN        PCust
     C                   EXSR      SRGetCust
 
      ** Get the first narrative.
 
     C                   CLEAR                   CGPNAR
     C                   MOVEL     A1AREF        MNTRNO
     C                   EVAL      MNMODI = 'GL'
     C                   MOVE      A1DRCN        MNCUST
     C                   EVAL      MNBRCA = A1BRCA
     C                   EVAL      MNCYCD = A1CCY
     C                   MOVE      A1DRCO        MNACCD
     C                   MOVE      A1DRSQ        MNACSQ
     C                   EVAL      MNCRNM = BBCRNM
     C                   MOVE      WDACN         MNRACN
     C                   EVAL      MNNARR = A1NARR
     C                   EVAL      PZMgID = 'GB00461'
     C                   EXSR      SRGetPNar
     C                   EVAL      PZNar1 = PZNarr
 
      ** Get credit customer details.
 
     C                   EVAL      PCust = *BLANKS
     C                   MOVEL     A1CRCN        PCust
     C                   EXSR      SRGetCust
 
      ** Get the second narrative.
 
     C                   CLEAR                   CGPNAR
     C                   MOVEL     A1AREF        MNTRNO
     C                   EVAL      MNMODI = 'GL'
     C                   MOVE      A1CRCN        MNCUST
     C                   EVAL      MNBRCA = A1BRCA
     C                   EVAL      MNCYCD = A1CCY
     C                   MOVE      A1CRCO        MNACCD
     C                   MOVE      A1CRSQ        MNACSQ
     C                   EVAL      MNCRNM = BBCRNM
     C                   MOVE      WCACN         MNRACN
     C                   EVAL      MNNARR = A1NARR
     C                   EVAL      PZMgID = 'GB00462'
     C                   EXSR      SRGetPNar
     C                   EVAL      PZNar2 = PZNarr
 
     C                   ELSE
     C                   EVAL      PZNar1 = A1NARR
     C                   EVAL      PZNar2 = A1NARR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetAAtbP - Gets the Amount Amortised to be Posted.         *
      *                                                               *
      *****************************************************************
     C     SRGetAAtbP    BEGSR
 
      ** Set the event date (next working day).
 
     C                   EVAL      WEvtDat = BJDNWD
 
      ** Determine the number of days in a year.
 
     C                   EVAL      WNDYr = *ZERO
 
     C                   SELECT
     C                   WHEN      A1CLBS = '2' OR
     C                             A1CLBS = '3' OR
     C                             A1CLBS = '5'
     C                   EVAL      WNDYr = 360
     C                   WHEN      A1CLBS = '1' OR
     C                             A1CLBS = '4'
     C                   EVAL      WNDYr = 365
     C                   WHEN      A1CLBS = '6'
     C                   EVAL      WNDYr = 366
     C                   ENDSL
 
      ** Calculate the t value.
 
     C**********         IF        BKALDI = 'Y'                                   BUG12616 BUG13056A
     C**********         EVAL      A1STDT = A1STDT + 1                            BUG12616 BUG13056A
     C**********         ENDIF                                                    BUG12616 BUG13056A
 
     C                   CALLB     'ZINTDY'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *ZEROS        PINTDY
     C                   PARM                    A1STDT
     C                   PARM                    WEvtDat
     C                   PARM                    A1CLBS
     C                   PARM      *ZEROS        PINT6DY
 
     C                   EVAL      WDays = PINTDY
 
     C**********         IF        BKALDI <> 'Y'                                            BUG12616
     C**********         EVAL      WDays = WDays + 1                                        BUG12616
     C**********         ENDIF                                                              BUG12616
 
     C**********         IF        BKALDI <> 'Y'                                  BUG13056A BUG13288
      **********                                                                  BUG13056A BUG13288
      ***Only*add 1 day if the next working day is not the maturity date.         BUG13056A BUG13288
      ***This*ensures that no amortisation will occur on the maturity date        BUG13056A BUG13288
      ***itself*for Start Date Amortisations.                                     BUG13056A BUG13288
      **********                                                                  BUG13056A BUG13288
     C**********         IF        A1MDAT <> WEvtDat                              BUG13056A BUG13288
     C**********         EVAL      WDays = WDays + 1                              BUG13056A BUG13288
     C**********         ENDIF                                                    BUG13056A BUG13288
     C**********         ENDIF                                                    BUG13056A BUG13288
      **********                                                                  BUG13056A BUG13288
     C                   EVAL      Wt = WDays/WNDYr
 
      ** Calculate the Amount Amortised to be Posted.
 
      ** For Linear Amortisation ('L'):
      **   A = D * (1 + (r * t)) - D
      **   where
      **     A = Amount Amortised to be Posted
      **     D = Discount Amount
      **     r = Effective Yield
      **     t = (Event Date - Start Date (+ 1 if BKALDI <> 'Y'))/Days in a Year
 
      ** For Non-linear Amortisation ('N'):
      **   A = (D * (1 + r)**t) - D)
 
     C                   IF        A1AMMD = 'L'
     C                   EVAL      WTmp1 = 1 + ((A1EFYL/100) * Wt)
     C                   ELSE
     C                   EVAL      WTmp1 = (1 + (A1EFYL/100))**Wt
     C                   ENDIF
 
     C                   EVAL      WAAtbP = A1DSAM * WTmp1 - A1DSAM
 
      ** Get the working amount.
 
     C                   EVAL      PCurr = A1CCY
     C                   EXSR      SRGetCurr
 
      *                                                                                     BUG13288
     C                   IF        A1MDAT <> WEvtDat                                        BUG13288
     C                   EVAL      WActAmt = WAAtbP - A1AATD
     C                   ELSE                                                               BUG13288
     C                   EVAL      WActAmt = A1PRAM - A1DSAM                                BUG13288
     C                   EVAL      WActAmt = WactAmt -  A1AATD                              BUG13574
                                                                                            BUG13288
     C                   ENDIF                                                              BUG13288
      *                                                                                     BUG13288
     C                   EVAL      WAmt = WActAmt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDate - Converts Midas day numbers to friendly dates.      *
      *                                                               *
      *****************************************************************
     C     SRZDate       BEGSR
 
     C                   CALL      'ZDATE2'
     C                   PARM                    PZDayN
     C                   PARM      BJDFIN        PZDatF
     C                   PARM      *ZERO         PZDate
     C                   PARM      *BLANKS       PZADat
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGLZAdd - Adds a running amount to a total amount.          *
      *                                                               *
      *****************************************************************
     C     SRGLZAdd      BEGSR
 
     C                   IF        ZZAMT = *ZERO
     C                   LEAVESR
     C                   ENDIF
 
      ** Split ZZAMT into integer and decimal fields.
 
     C                   EVAL      ZZAMTI = ZZAMT
     C                   MOVE      ZZAMT         ZZAMTD
 
      ** Both ZZAMTI and ZZAMTD now contain a 'sign' zone.
 
     C                   EXSR      SRGLZSum
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGLZSum - Carries out the addition for SRGLZAdd.            *
      *                                                               *
      *****************************************************************
     C     SRGLZSum      BEGSR
 
     C                   EVAL      *IN91 = *OFF
     C                   EVAL      *IN92 = *OFF
     C                   EVAL      *IN93 = *OFF
     C                   EVAL      *IN94 = *OFF
     C                   EVAL      *IN95 = *OFF
     C                   EVAL      *IN99 = *OFF
 
     C                   IF        ZZAMTI = *ZERO AND
     C                             ZZAMTD = *ZERO
     C                   EXSR      SRZSEnd
     C                   LEAVESR
     C                   ENDIF
 
      ** Determine the sign of ZZAMTI & ZZAMTD.
 
     C                   IF        ZZAMTI < *ZERO OR
     C                             ZZAMTD < *ZERO
     C                   EVAL      *IN92 = *ON
     C                   ENDIF
 
      ** Determine the sign of ZZTOTI and ZZTOTD.
 
     C                   IF        ZZTOTI = *ZERO AND
     C                             ZZTOTD = *ZERO
     C                   EVAL      ZZTOTI = ZZAMTI
     C                   EVAL      ZZTOTD = ZZAMTD
     C                   EXSR      SRZSEnd
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        ZZTOTI < *ZERO OR
     C                             ZZTOTD < *ZERO
     C                   EVAL      *IN91 = *ON
     C                   ENDIF
 
      ** If the signs differ, bypass overflow checks.
 
     C                   IF        *IN91 <> *IN92
     C                   EXSR      SRZOfPs
     C                   LEAVESR
     C                   ENDIF
 
     C                   EVAL      ZZWK2 = ZZAMTD + ZZTOTD
 
     C                   IF        ZZWK2 > 999 OR
     C                             ZZWK2 < -999
 
     C                   IF        *IN92 = *ON
     C                   EVAL      ZZWK3 = ZZAMTI - 1
     C                   ELSE
     C                   EVAL      ZZWK3 = ZZAMTI + 1
     C                   ENDIF
 
     C                   EVAL      ZZWK3 = ZZWK3 + ZZTOTI
 
     C                   ELSE
     C                   EVAL      ZZWK3 = ZZTOTI + ZZAMTI
     C                   ENDIF
 
      ** If mod. ZZWK3 is < mod. ZZTOTI, then overflow has occurred.
 
     C                   IF        (*IN92 = *ON AND ZZWK3 > ZZTOTI) OR
     C                             (*IN92 = *OFF AND ZZWK3 < ZZTOTI)
     C                   EVAL      ZZAMT = *ZERO
     C                   EVAL      *IN99 = *ON
     C                   ELSE
     C                   Z-ADD     ZZWK2         ZZTOTD
     C                   Z-ADD     ZZWK3         ZZTOTI
     C                   ENDIF
 
     C                   EXSR      SRZSEnd
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZOfPs - Bypass overflow processing for SRGLZSum.           *
      *                                                               *
      *****************************************************************
     C     SRZOfPs       BEGSR
 
      ** If ZZAMT was neg., make it pos. for comparison with ZZTOT.
 
     C                   IF        *IN92 = *ON
     C                   Z-SUB     ZZAMTI        ZZAMTI
     C                   Z-SUB     ZZAMTD        ZZAMTD
     C                   ENDIF
 
      ** If ZZTOT was neg., make it pos. for comparison with ZZAMT.
 
     C                   IF        *IN91 = *ON
     C                   Z-SUB     ZZTOTI        ZZTOTI
     C                   Z-SUB     ZZTOTD        ZZTOTD
     C                   ENDIF
 
      ** If ZZTOT = ZZAMT, return zero.
 
     C                   IF        ZZTOTI = ZZAMTI AND
     C                             ZZTOTD = ZZAMTD
     C                   EVAL      ZZTOTI = *ZERO
     C                   EVAL      ZZTOTD = *ZERO
     C                   EXSR      SRZSEnd
     C                   LEAVESR
     C                   ENDIF
 
     C                   EVAL      *IN93 = *OFF
 
     C                   IF        ZZTOTI > ZZAMTI OR
     C                             ZZTOTD > ZZAMTD
 
     C                   EVAL      *IN93 = *ON
 
     C                   IF        ZZAMTD > ZZTOTD
     C                   EVAL      ZZTOTI = ZZTOTI - 1
     C                   EVAL      ZZWK2 = ZZTOTD + 1000
     C                   EVAL      ZZTOTD = ZZWK2 - ZZAMTD
     C                   ELSE
     C                   EVAL      ZZTOTD = ZZTOTD - ZZAMTD
     C                   ENDIF
 
     C                   EVAL      ZZTOTI = ZZTOTI - ZZAMTI
 
     C                   ELSE
 
     C                   IF        ZZTOTD > ZZAMTD
     C                   EVAL      ZZWK3 = ZZAMTI - 1
     C                   EVAL      ZZWK2 = ZZAMTD + 1000
     C                   EVAL      ZZTOTI = ZZWK3 - ZZTOTI
     C                   EVAL      ZZTOTD = ZZWK2 - ZZTOTD
     C                   ELSE
     C                   EVAL      ZZTOTI = ZZAMTI - ZZTOTI
     C                   EVAL      ZZTOTD = ZZAMTD - ZZTOTD
     C                   ENDIF
 
     C                   ENDIF
 
      ** Reverse the sign of ZZTOT if the larger I/P fields were neg.
 
     C                   EVAL      *IN94 = *OFF
 
     C                   IF        (*IN93 = *ON AND *IN91 = *ON) OR
     C                             (*IN93 = *OFF AND *IN92 = *ON)
     C                   EVAL      *IN94 = *ON
     C                   Z-SUB     ZZTOTI        ZZTOTI
     C                   Z-SUB     ZZTOTD        ZZTOTD
     C                   ENDIF
 
      ** Restore the sign of ZZAMTI & ZZAMTD if it was reversed.
 
     C                   IF        *IN92 = *ON
     C                   Z-SUB     ZZAMTI        ZZAMTI
     C                   Z-SUB     ZZAMTD        ZZAMTD
     C                   ENDIF
 
     C                   EXSR      SRZSEnd
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZSEnd - End processing for SRGLZSum.                       *
      *                                                               *
      *****************************************************************
     C     SRZSEnd       BEGSR
 
      ** If ZZTOTD = zero and ZZTOTI is neg., set ZZNEGD.
 
     C                   EVAL      *IN96 = *OFF
     C                   EVAL      *IN91 = *OFF
 
     C                   IF        ZZTOTD = *ZERO AND
     C                             ZZTOTI < *ZERO
     C                   EVAL      ZZNEGD = '.000-'
     C                   EVAL      *IN96 = *ON
     C                   EVAL      *IN91 = *ON
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception subroutine.                        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
 
     C                   EXSR      SRAudit
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Key Lists
 
     C     KACCN         KLIST
     C                   KFLD                    KCust
     C                   KFLD                    KCcy
     C                   KFLD                    KAcod
     C                   KFLD                    KAcsq
     C                   KFLD                    KBrca
 
      ** Access bank details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBase = 101
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access general ledger details.
 
     C**********         CALL      'AOGELRR0'                                                 CAS011
     C                   CALL      'AOGELRR1'                                                 CAS011
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CAS011
     C     SDGELR        PARM      SDGELR        DSSDY                                        CAS011
 
     C                   IF        PRtCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDGELRPD'
     C                   EVAL      DBKey =  POptn
     C                   EVAL      DBase =  102
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Determine if accrual processing is required.
 
     C                   EVAL      *IN43 = *OFF
     C                   EVAL      WNWDM = BJDNWD - 1
     C                   IF        BKAPDT <= WNWDM
     C                   EVAL      *IN43 = *ON
     C                   ENDIF
 
      ** Access module details.
 
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDMMODPD'
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBase = 103
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        BGN1ST = 'Y'
 
      ** Check if GLPNAR is enabled.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'GLPNAR'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C**********         IF        PRtCd <> *BLANKS                                           242475
     C                   IF        PRtCd = *BLANKS                                            242475
     C                   EVAL      GLPNAR = 'Y'
     C                   ELSE
 
     C                   IF        PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBKey = PSARD
     C                   EVAL      DBase = 104
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Check if CGL003 is enabled.
 
     C**********         CALL      'AOSARDR0'                                               BUG13041
     C**********         PARM      *BLANKS       PRtCD                                      BUG13041
     C**********         PARM      '*VERIFY'     POptn                                      BUG13041
     C**********         PARM      'CGL003'      PSARD                                      BUG13041
     C*****SCSARD        PARM      SCSARD        DSFDY                                      BUG13041
 
     C**********         IF        PRtCd = *BLANKS                                          BUG13041
     C**********         EVAL      CGL003 = 'Y'                                             BUG13041
     C**********         ELSE                                                               BUG13041
 
     C**********         IF        PRtCd <> '*NRF   '                                       BUG13041
     C******LOCK         IN        LDA                                                      BUG13041
     C**********         EVAL      DBFile = 'SCSARDPD'                                      BUG13041
     C**********         EVAL      DBKey = PSARD                                            BUG13041
     C**********         EVAL      DBase = 105                                              BUG13041
     C**********         OUT       LDA                                                      BUG13041
     C**********         EXSR      *PSSR                                                    BUG13041
     C**********         ENDIF                                                              BUG13041
 
     C**********         ENDIF                                                              BUG13041
 
     C     1             SETLL     GEAAZZ
     C                   READ      GEAAZZ                                 01
 
     C     1             SETLL     GLAMRZPD
     C                   READ      GLAMRZPD                               02
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2004
