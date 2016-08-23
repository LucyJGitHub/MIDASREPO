     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Fee Events Generation')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL000492 - Midas DL Fee Event Generatiion                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 AR702741           Date 02Feb11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 BUG13712           Date 03Apr07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CAS011             Date 16May05               *
      *                 CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  BUG13712 - Incorrect "Total Adj. to Yield Fees" and          *
      *             Total F/D/P" on MM004620P1                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *                                                               *
      *****************************************************************
     FDLFEEDL1  UF   E           K DISK    INFSR(*PSSR)
     FDEALS     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDGF)
     F                                     IGNORE(DEALSDFF)
     F                                     PREFIX(OB)
 
     FEVNTXED   O    E             DISK    INFSR(*PSSR)
     FEVNTXZZ   UF   E             DISK    INFSR(*PSSR)
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Layout for the RUNDAT data area
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
 
      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Nostro Detaials
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** General Ledger Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CAS011
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for access objects
     D PRTCD           S              7
     D POPTN           S              7
     D PCUST1          S             10
     D PKYST           S              7
     D PCNUM           S              6
 
      ** ZCONVZ1 fields
     D PINPAMT         S             15  0
     D PCVTRAT         S             13  8
     D PBASMD          S              1
     D PFRMCCY         S              3
     D PTOCCY          S              3
     D PFRMDEC         S              1  0
     D PTODEC          S              1  0
     D POUTAMT         S             15  0
 
      ** Parameters for ZFREQB
     D PRetCodeIn      S              7A
     D PZFreq          S              1A
     D PZDayno         S              5P 0
     D PZCcy           S              3A
     D PZLoc           S              3A                                                    AR702741
     D PZMday          S              2P 0
     D PBJDFIN         S              1A
 
     D WKEVCD          S              5P 0
     D WNPYDAT         S              5P 0
     D WSTTL           S              2P 0
     D WTELEX          S              5P 0
 
     D ZDAYNO          S              5  0
     D ZNRDYS          S              2  0
     D ZDYNBR          S              5  0
     D PCCY            S              3
     D ZLOC            S              3
 
     D WOURS           S              6
     D WKEYA           S              6
     D WKEYB           S              3
     D*WKEYC*********  S              4                                                       CAS011
     D WKEYC           S             10                                                       CAS011
     D WKEYD           S              2
     D WKEYE           S              2
     D WBRCD           S              3
     D CSSN            S             10
     D PNOI            S              1
     D WSNDTLX         S              1
 
      ** Standard Subroutine Variables
     D ZZAMT           S             15P 3
     D ZZAMTI          S             15P 0
     D ZZAMTD          S              3P 0
     D ZZNEGD          S              5A
     D ZZTOTI          S             15P 0
     D ZZTOTD          S              3P 0
     D ZZWK2           S              4P 0
     D ZZWK3           S             15P 0
 
     D WNORE           S              5  0
     D WHRWN           S             15  0
     D WHRDC           S              3  0
     D WTOTI           S             15  0
     D WTOTD           S              3  0
                                                                                            BUG13712
     D WDlMatD         S              5  0 INZ(*ZEROS)                                      BUG13712
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
 
     C     *LOVAL        SETLL     DLFEEDL1
     C                   READ      DLFEEDL1                               01
     C                   DOW       *IN01 = *OFF
 
     C                   IF        DFRECI = 'D'
      ** Access SDCURRPD to get telex notice days. Then access SDNOSTPD
      ** to get location code. Use these data to get the TELEX Date.
 
     C                   EXSR      SRCurr
     C                   EXSR      SRLocation
     C                   EXSR      SRTelex
 
      ** Generate event when start date of One Off or Amortising fee is
      ** later than event control date or end date of accruing fee is
      ** later than event control date. Generate event for repetitive
      ** fees until maturity.
 
     C                   IF        DFPYON = *BLANKS OR DFPYON = 'S'
 
     C                   IF        DFPSTD > WKEVCD
     C                   EXSR      SREVENT
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        DFPEND > WKEVCD AND DFPYON = 'E'
     C                   EXSR      SREVENT
     C                   ENDIF
 
     C                   IF        DFPEND > WKEVCD AND DFPYON = 'N'
 
     C     DFDLNO        CHAIN     DEALS                                                    BUG13712
     C                   IF        %FOUND(DEALS)                                            BUG13712
     C                   EVAL      WDlMatD = OBMDAT                                         BUG13712
     C                   ENDIF                                                              BUG13712
                                                                                            BUG13712
     C                   EVAL      PZDAYNO = DFNPYD
     C                   EVAL      PZFREQ = DFFREQ
     C                   EVAL      PZMDAY = DFDYIM
     C                   EVAL      PZCCY = DFFCCY
 
     C**********         DOW       PZDAYNO <= DFPEND                                        BUG13712
     C                   DOW       (PZDAYNO <= DFPEND)                                      BUG13712
     C                             AND (PZDAYNO <= WDlMatD)                                 BUG13712
     C                   EVAL      WNPYDAT = PZDAYNO
     C                   EXSR      SREVENT
     C                   EXSR      SRZFREQ
 
     C                   IF        PZDAYNO > DFPEND AND
     C                             WNPYDAT <> DFPEND
     C                   EVAL      WNPYDAT = DFPEND
     C                   EXSR      SREVENT
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDIF
     C                   IF        WSNDTLX = 'Y'
     C                   EXSR      SRSNDTLX
     C                   EVAL      WSNDTLX = 'N'
     C                   ENDIF
 
     C                   ENDIF
     C                   READ      DLFEEDL1                               01
 
     C                   ENDDO
 
     C                   EXSR      SRTRAIL
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLocation - Access nostro file to get location code (ZLOC)   *
      *                                                               *
      *****************************************************************
     C     SRLocation    BEGSR
 
     C                   EVAL      WSTTL = DFSTTL
     C                   EVAL      ZLOC = *BLANKS
 
      ** For types 01, 02, 07, 08 OR 12 the settlement location is
      ** determined by the nostro branch.
 
     C                   IF        WSTTL = 1 OR WSTTL = 2 OR
     C                             WSTTL = 7 OR WSTTL = 8 OR
     C                             WSTTL = 12
     C                   MOVEL     DFOURS        WOURS
 
     C                   CALL      'AONOSTR0'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      *BLANKS       WKEYA
     C                   PARM      DFFCCY        WKEYB
     C                   PARM      *BLANKS       WKEYC
     C                   PARM      *BLANKS       WKEYD
     C                   PARM      WOURS         WKEYE
     C                   PARM      *BLANKS       WBRCD
     C                   PARM      *BLANKS       CSSN
     C                   PARM      *BLANKS       PNOI
     C     SDNOST        PARM      SDNOST        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAl      DBASE = 1
     C                   EVAL      DBKEY = DFFCCY
     C                   EVAL      DBFILE = 'SDNOSTPD'
     C                   EVAL      DBPGM = 'DL000492'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      A7NOSN        ZLOC
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCurr - Access SDCURRPD to get telex notice days             *
      *                                                               *
      *****************************************************************
     C     SRCurr        BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DFFCCY        PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAl      DBASE = 2
     C                   EVAL      DBKEY = PCCY
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBPGM = 'DL000492'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      ZNRDYS = A6TXND
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTelex - Use ZFWDT to get telex date                         *
      *                                                               *
      *****************************************************************
     C     SRTelex       BEGSR
 
     C                   CALL      'ZFWDT'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZNRDYS
     C                   PARM                    ZDYNBR
     C                   PARM                    PCCY
     C                   PARM                    ZLOC
 
     C                   Z-ADD     ZDYNBR        WTelex
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSNDTLX - Subroutine to send telex                           *
      *                                                               *
      *****************************************************************
     C     SRSNDTLX      BEGSR
 
     C                   SELECT
 
     C                   WHEN      WTelex > EDAT AND DFPYON = 'S' OR
     C                             WTelex > EDAT AND DFPYON = *BLANKS
     C                   IF        DFSPTI = *BLANKS
     C                   EVAL      DFSPTI = 'Y'
     C                   ENDIF
     C                   IF        DFSBTI = *BLANKS
     C                   EVAL      DFSBTI = 'Y'
     C                   ENDIF
 
     C                   WHEN      WTelex < EDAT AND DFPYON = 'E' OR
     C                             WTelex < EDAT AND DFPYON = 'N'
     C                   IF        DFEPTI = *BLANKS
     C                   EVAL      DFEPTI = 'Y'
     C                   ENDIF
     C                   IF        DFEBTI = *BLANKS
     C                   EVAL      DFEBTI = 'Y'
     C                   ENDIF
     C                   ENDSL
 
     C                   UPDATE    DLFEEDD0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREVENT - Subroutine to generate events                       *
      *                                                               *
      *****************************************************************
     C     SREVENT       BEGSR
 
     C                   EVAL      RECI = 'D'
     C                   EVAL      DLNO = DFDLNO
     C                   MOVE      DFCUST        CUNR
     C                   MOVE      DFCUST        PCNUM
     C                   EXSR      SRCUST
 
     C                   SELECT
     C                   WHEN      DFDTYP = 'IP' OR  DFDTYP = 'TI' OR
     C                             DFDTYP = 'CL' OR  DFDTYP = 'DL'
     C                   EVAL      ETYP = '15F1'
     C                   EVAL      INOI = 'I'
     C                   WHEN      DFDTYP = 'IT' OR  DFDTYP = 'TD' OR
     C                             DFDTYP = 'CI' OR  DFDTYP = 'CD'
     C                   EVAL      ETYP = '16F1'
     C                   EVAL      INOI = 'O'
     C                   WHEN      DFDTYP = 'C2' OR  DFDTYP = 'BP' OR
     C                             DFDTYP = 'BD' OR  DFDTYP = 'TB' OR
     C                             DFDTYP = 'DA' OR  DFDTYP = 'TA'
     C                   EVAL      ETYP = '17F1'
     C                   EVAL      INOI = 'I'
     C                   ENDSL
 
      ** Determine event date. If one off or ammortising, use start date
      ** as the event date. If accruing, use end date.
 
     C                   IF        DFPYON = 'S' OR DFPYON = *BLANKS
     C                   EVAL      EDAT = DFPSTD
     C                   ELSE
     C                   EVAL      EDAT = DFPEND
     C                   ENDIF
 
     C                   IF        DFPYON = 'N'
     C                   EVAL      EDAT = WNPYDAT
     C                   ENDIF
 
     C                   EVAL      EAMT = DFFAMT
     C                   EVAL      ECCY = DFFCCY
     C                   EVAL      DTYP = DFDTYP
     C                   EVAL      DLST = DFSTYP
     C                   EVAL      BRCA = DFBRCA
     C                   EVAL      EBRC = DFBRCA
 
     C                   IF        DFFCCY = BJCYCD
     C                   EVAL      DBCE = DFFAMT
     C                   EVAL      BCEQ = DFFAMT
     C                   ELSE
     C                   EVAL      PINPAMT = DFFAMT
     C                   EVAL      PCVTRAT = A6SPRT
     C                   EVAL      PBASMD  = A6MDIN
     C                   EVAL      PFRMCCY = DFFCCY
     C                   EXSR      SRConvert
     C                   EVAL      DBCE = POUTAMT
     C                   EVAL      BCEQ = POUTAMT
     C                   ENDIF
 
     C                   EVAL      SETP = DFSTTL
     C                   MOVEL     DFOURS        OSAC1
     C                   MOVE      DFOURS        OSAC2
     C                   EVAL      TSEN = DFTHER
 
     C                   IF        DFSTTL = 0
     C                   EVAL      FIPI = 'N'
     C                   ENDIF
 
     C                   IF        DFSTTL = 0 OR DFSTTL = 1 OR
     C                             DFSTTL = 2 OR DFSTTL = 5 OR
     C                             DFSTTL = 7 OR DFSTTL = 12 OR
     C                             DFSTTL = 8 AND DFOURS = *BLANKS OR
     C                             DFSTTL = 14 AND DFOURS = *BLANKS
     C                             OR DFTHER = *BLANKS
     C                   EVAL      FIPI = 'N'
     C                   ELSE
     C                   EVAL      FIPI = 'Y'
     C                   ENDIF
 
     C                   EVAL      PTNU = BBPCNB
     C                   IF        BBPAIN = 'P'
     C                   EVAL      PARI = 0
     C                   ELSE
     C                   EVAL      PARI = 1
     C                   ENDIF
     C                   EVAL      CRNM = BBCRNM
     C                   EVAL      CTWN = BBCRTN
     C                   EVAL      CASK = BBCASC
 
     C                   IF        BBPCNB = *BLANKS
     C                   EVAL      PRNM = *BLANKS
     C                   EVAL      PTWN = *BLANKS
     C                   EVAL      PASK = *BLANKS
     C                   ELSE
     C                   EVAL      PCNUM = BBPCNB
     C                   EXSR      SRCUST
     C                   EVAL      PRNM = BBCRNM
     C                   EVAL      PTWN = BBCRTN
     C                   EVAL      PASK = BBCASC
     C                   ENDIF
 
     C                   EVAL      DASN = DFFSEQ
     C     DLNO          CHAIN     DEALS
     C                   IF        %FOUND(DEALS)
     C                   EVAL      BOKC = OBBOKC
     C                   EVAL      PRFC = OBPRFC
     C                   ENDIF
 
     C                   WRITE     EVNTXEDF
     C                   EVAL      WSNDTLX = 'Y'
 
     C                   EVAL      WNORE = WNORE + 1
     C                   EVAL      ZZAMT = EAMT / 1000
     C                   IF        ZZAMT < 0
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF
 
     C                   EVAL      ZZTOTI = WTOTI
     C                   EVAL      ZZTOTD = WTOTD
     C                   EXSR      SRGLZADD
     C                   EVAL      WTOTI = ZZTOTI
GDM  C**********         EVAL      WTOTI = ZZTOTD                                             CAS011
GDM  C                   EVAL      WTOTD = ZZTOTD                                             CAS011
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCUST - Get Customer Name                                    *
      *                                                               *
      *****************************************************************
     C     SRCUST        BEGSR
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      PCNUM         PCUST1
     C                   PARM      *BLANKS       PKYST
     C     SDCUST        PARM      SDCUST        DSSDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 3
     C                   EVAL      DBKEY = PCNUM
     C                   EVAL      DBPGM = 'DL000492'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRConvert - Subroutine to convert event amounts into facility *
      *             currency                                          *
      *                                                               *
      *****************************************************************
     C     SRConvert     BEGSR
 
     C                   CALLB     'ZCONVZ1'
     C                   PARM                    PINPAMT
     C                   PARM                    PCVTRAT
     C                   PARM                    PBASMD
     C                   PARM                    PFRMCCY
     C                   PARM      BJCYCD        PTOCCY
     C                   PARM                    PFRMDEC
     C                   PARM                    PTODEC
     C                   PARM                    POUTAMT
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZFREQ  - Subroutine to get the next payment date            *
      *                                                               *
      *****************************************************************
     C     SRZFREQ       BEGSR
 
     C                   CALLB     'ZFREQB'
     C                   PARM      *BLANKS       PRetCodeIn
     C                   PARM                    PZFreq
     C                   PARM                    PZDayno
     C                   PARM                    PZCcy
     C                   PARM      *BLANKS       PZLoc                                      AR702741
     C                   PARM                    PZMday
     C                   PARM                    PBJDFIN
     C     SDGELR        PARM                    SDGELR
 
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
      *
      *  SRTRAIL - Update trailer
      *
      *****************************************************************
     C     SRTRAIL       BEGSR
 
     C                   EVAL      NORE = WNORE
     C                   EVAL      HRWN = WHRWN + WTOTI
     C                   EVAL      HRDC = WHRDC + WTOTD
 
     C                   UPDATE    EVNTXZZF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Inital processing (Only done first time through)
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      **  Set up Local Data Area
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBPGM = *BLANKS
     C                   EVAL      DBASE = *ZERO
     C                   OUT       LDA
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 4
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBPGM = 'DL000492'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Call access program for General Ledger details
 
     C**********         CALL      'AOGELRR0'                                                 CAS011
     C                   CALL      'AOGELRR1'                                                 CAS011
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CAS011
     C     SDGELR        PARM      SDGELR        DSSDY                                        CAS011
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBASE = 5
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBPGM = 'DL000492'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IN        RUNDAT
     C                   EVAL      ZDAYNO = AGRDNB
 
      ** Get Event Control Date as the lesser between (Next Working Day - 1)
      ** and Accrual Profit Date
 
     C                   EVAL      WkEvCD = BJDNWD - 1
 
     C                   IF        BKAPDT < WkEvCD
     C                   EVAL      WkEvCD = BKAPDT
     C                   ENDIF
 
      ** Read Trailer
     C                   READ      EVNTXZZ
 
     C                   IF        %EOF(EVNTXZZ)
     C                   EVAL      DBFILE = 'EVNTXZZ'
     C                   EVAL      DBASE = 6
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBPGM = 'DL000492'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WNORE = NORE
     C                   EVAL      WHRWN = HRWN
     C                   EVAL      WHRDC = HRDC
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
      /COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2004
