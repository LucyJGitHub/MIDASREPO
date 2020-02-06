     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Account Transfer Event Generation')           *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL004602  - Midas GL Account Transfer Event Generation       *
      *                                                               *
      *  Function:  This program performs the event generation for    *
      *             Retail Account transfer                           *
      *                                                               *
      *  Called By: GLC004602                                         *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1075388          Date 21Nov13               *
      *                 CRE067             Date 05Oct10               *
      *                 BUG27825A          Date 08Jul10               *
      *                 BUG27825           Date 22Jun10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP204  *CREATE    Date 09Feb10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1075388 - Account transfer fees - net (Child:AR1075389)    *
      *              Applied for MD-23536 (Recompile)                 *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  BUG27825A- Use "ADD" operation code for postings             *
      *             counter("ADD" sets value to zero automatically    *
      *             when value exceeds 5 digits)                      *
      *  BUG27825 - Reset trailer counter for more than 99997 records *
      *  CAP204 - Teller Related APIs - Account Transfer              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    91 - Total Amount is Negative                              *
      *    92 - Amount is Negative                                    *
      *    93 - Amount is Zero                                        *
      *    94 - Amount is Greater than Total Amount                   *
      *    95 - Amount and Total Amount is Positive                   *
      *    96 - If ZZTOTD is Zero and ZZTOTI is -ve                   *
      *    99 - Field ZZWK3 is less than ZZTOTI                       *
      *    U7+U8  -  Database Error                                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRPROCESS    - Subroutine to process accounts                *
      *  SRCALLPROC   - Subroutine to call processes for events       *
      *  SRWREVNT     - Write details to events file                  *
      *  SRINTERBRCH  - Check for InterBranch                         *
      *  SRUPDTRL     - Update events trailer file                    *
      *  SRCURR       - Subroutine to get currency details            *
      *  SRCUST       - Subroutine to get customer details            *
      *  SRBRCH       - Subroutine to get branch details              *
      *  SRNOST       - Get Nostro Account Details                    *
      *  SRRCFAU      - Register AU Printer file for                  *
      *                 RCF processing                                *
      *  SRAUDIT      - Output Audit Report                           *
      *  *INZSR       - Program Initialisation Routine                *
      *  *PSSR        - Error handling Routine                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas GL Account Transfer Manual Input
     FGLATMIPD  IF   E           K DISK    INFSR(*PSSR)
 
      ** Account Transfer Event Generation Detail File
     FGLEVNTPD  O  A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Account Transfer Event Generation Trailer File
     FGLEVNTZZ  O  A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     USROPN
 
      ** Account Transfer Event Generation Audit File
     FGL004602AUO    E             Printer INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
     F                                     USROPN
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** Data Structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Data Structure for Branch Codes Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** Data Structure for Currency Code Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Data Structure for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D                                     PREFIX(C_)
 
      ** Data Structure for Nostro Account Details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** File Information Data Structure for GL004602AU
     D SPOOLU          DS
     D  PSFILEU               83     92
     D  PSFNUMU              123    124B 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRTCD           S              7A
     D POPTN           S              7A
     D PCCY            S              3A
     D PCNUM           S             10A
     D PCNST           S              7A
     D PBRCA           S              3A
     D PACCD           S             10A
     D PACSN           S              2A
     D PNONB           S              2A
     D PCSSN           S             10A
     D PPNOI           S              1A
     D WACCT           S              1A
     D WNOSD           S              2A
     D WNOSC           S              2A
     D CRDRBR          S              3A
     D WCCMCD          S              3A
     D WCOMPD          S              3A
     D WCOMPC          S              3A
     D ECSD            S              2  0
     D ECSC            S              2  0
     D WRUN            S              1N
     D WAMT            S             13  0
     D WKNOREC         S              5  0 INZ(0)
     D WKVLINT         S             15  0 INZ(0)
     D WKVLDEC         S              3  0 INZ(0)
 
      ** Fields used in GLZADD/GLZSUM
     D ZZAMT           S             15  3
     D ZZAMTI          S             15  0
     D ZZAMTD          S              3  0
     D ZZTOTI          S             15  0
     D ZZTOTD          S              3  0
     D ZZWk2           S              4  0
     D ZZWk3           S             15  0
     D ZZNEGD          S              5
 
      ** Parameters for ZSFILE
     D PZSEQ           S              5A
     D PZENTY          S              3A
     D PSFILE          S             10A
     D PZSNUM          S              6S 0
     D PZSERR          S              1A
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Processing for Account
 
     C                   EXSR      SRPROCESS
 
      ** Audit Report
 
     C                   EXSR      SRAUDIT
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPROCESS  - Subroutine to process the accounts              *
      *                                                               *
      *****************************************************************
     C     SRPROCESS     BEGSR
 
      ** Read account transfer manual input
 
     C     *START        SETLL     GLATMIPD
     C                   READ      GLATMIPD
 
     C                   DOW       NOT %EOF(GLATMIPD)
 
     C                   IF        R1RECI <> 'D'
     C                   READ      GLATMIPD
     C                   ELSE
 
      ** Call processes for Debit Account
 
     C                   EVAL      WACCT = 'D'
     C                   EVAL      PCCY = R1DBCY
     C                   EVAL      PCNUM = R1DBCU
     C                   EVAL      PBRCA = R1DBBR
     C                   MOVEL     R1DBAC        PACCD
     C                   MOVEL     R1DBSQ        PACSN
     C                   EXSR      SRCALLPROC
 
      ** Call processes for Credit Account
 
     C                   EVAL      WACCT = 'C'
     C                   EVAL      PCCY = R1CRCY
     C                   EVAL      PCNUM = R1CRCU
     C                   EVAL      PBRCA = R1CRBR
     C                   MOVEL     R1CRAC        PACCD
     C                   MOVEL     R1CRSQ        PACSN
     C                   EXSR      SRCALLPROC
 
      ** Call processes for Fees
 
     C                   IF        R1FGRS = 'G'
     C                   EVAL      WACCT = 'F'
     C                   EXSR      SRWREVNT
     C                   ENDIF
 
     C                   READ      GLATMIPD
     C                   ENDIF
     C                   ENDDO
 
     C                   EVAL      RECI = 'T'
     C                   WRITE     GLEVNTZF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCALLPROC - Call Processes                                  *
      *                                                               *
      *                                                               *
      *****************************************************************
     C     SRCALLPROC    BEGSR
 
     C                   EXSR      SRCURR
     C                   EXSR      SRCUST
     C                   EXSR      SRBRCH
     C                   EXSR      SRNOST
     C                   EXSR      SRWREVNT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWREVNT - Subroutine to write debit/credit/fees details     *
      *             to event files                                    *
      *                                                               *
      *****************************************************************
     C     SRWREVNT      BEGSR
 
      ** Move values for event details
      ** Save first the value of Company Code
 
     C                   EVAL      WCCMCD = A8CMCD
 
     C                   EVAL      RECI = 'D'
     C                   EVAL      TREF = R1TREF
     C                   EVAL      RTYP = R1TRTY
     C                   EVAL      RSTP = R1TRST
     C                   EVAL      RATE = R1EXCH
     C                   EVAL      BRCA = R1BRCA
     C                   EVAL      EBRC = R1BRCA
 
      ** Get Company Code of Booking Branch
 
     C                   EVAL      PBRCA = BRCA
     C                   EXSR      SRBRCH
 
     C                   EVAL      COBB = A8CMCD
     C                   EVAL      ECPY = A8CMCD
     C                   EVAL      IBRE = 'N'
     C                   EVAL      ICYE = 'Y'
     C                   EVAL      ECSS = A6SSNB
 
     C                   SELECT
 
      ** Fill events fields with Debit Account details
 
     C                   WHEN      WACCT = 'D'
     C                   EVAL      ETYP = 'DTV1'
     C                   EVAL      EDAT = R1DRVL
     C                   EVAL      EAMT = R1DAMT
     C                   EVAL      ECCY = R1DBCY
     C                   EVAL      OTHD = R1CRVL
     C                   EVAL      OTCY = R1CRCY
     C                   EVAL      OTHA = R1CAMT
     C                   EVAL      CUNR = R1DBCU
     C                   EVAL      INOI = 'I'
     C                   EVAL      WAMT = R1DAMT
     C                   EVAL      CRDRBR = R1DBBR
     C                   EVAL      WNOSD = NOSA
     C                   EVAL      WCOMPD = WCCMCD
     C                   EVAL      ECSD = ECSS
 
      ** Fill events fields with Credit Account details
 
     C                   WHEN      WACCT = 'C'
     C                   EVAL      ETYP = 'CTV1'
     C                   EVAL      EDAT = R1CRVL
     C                   EVAL      EAMT = R1CAMT
     C                   EVAL      ECCY = R1CRCY
     C                   EVAL      OTHD = R1DRVL
     C                   EVAL      OTCY = R1DBCY
     C                   EVAL      OTHA = R1DAMT
     C                   EVAL      CUNR = R1CRCU
     C                   EVAL      INOI = 'O'
     C                   EVAL      WAMT = R1CAMT
     C                   EVAL      CRDRBR = R1CRBR
     C                   EVAL      WNOSC = NOSA
     C                   EVAL      WCOMPC = WCCMCD
     C                   EVAL      ECSC = ECSS
 
      ** Fill events fields with Fees details
 
     C                   WHEN      WACCT = 'F'
 
      ** Sum of all Fee Amounts
 
     C                   EVAL      EAMT = R1F1AM + R1F2AM + R1F3AM +
     C                                    R1F4AM + R1F5AM + R1F6AM
     C                   EVAL      WAMT = EAMT
     C                   EVAL      INOI = 'I'
 
     C                   IF        R1FPAY = 'D'
 
     C                   EVAL      ETYP = 'DTV1'
     C                   EVAL      EDAT = R1DRVL
     C                   EVAL      ECCY = R1DBCY
     C                   EVAL      OTHD = R1CRVL
     C                   EVAL      OTCY = R1CRCY
     C                   EVAL      OTHA = R1CAMT
     C                   EVAL      CUNR = R1DBCU
     C                   EVAL      NOSA = WNOSD
     C                   EVAL      CRDRBR = R1DBBR
     C                   EVAL      WCCMCD = WCOMPD
     C                   EVAL      ECSS = ECSD
 
     C                   ELSE
 
     C                   EVAL      ETYP = 'CTV1'
     C                   EVAL      EDAT = R1CRVL
     C                   EVAL      ECCY = R1CRCY
     C                   EVAL      OTHD = R1DRVL
     C                   EVAL      OTCY = R1DBCY
     C                   EVAL      OTHA = R1DAMT
     C                   EVAL      CUNR = R1CRCU
     C                   EVAL      NOSA = WNOSC
     C                   EVAL      CRDRBR = R1CRBR
     C                   EVAL      WCCMCD = WCOMPC
     C                   EVAL      ECSS = ECSC
 
     C                   ENDIF
 
     C                   ENDSL
 
      ** Output to Even Generation File
      ** Update Trailer file with the total number of records and sum amounts
      ** Check for InterBranch
 
     C                   WRITE     GLEVNTDF
 
     C                   EXSR      SRUPDTRL
 
     C                   EXSR      SRINTERBRCH
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINTERBRCH - Check for Interbranch                          *
      *                                                               *
      *****************************************************************
     C     SRINTERBRCH   BEGSR
 
     C                   IF        CRDRBR <> R1BRCA
 
     C                   EVAL      EBRC = CRDRBR
     C                   EVAL      ECPY = WCCMCD
     C                   EVAL      IBRE = 'Y'
 
     C                   IF        ECPY <> COBB
     C                   EVAL      ICYE = 'N'
     C                   ELSE
     C                   EVAL      ICYE = 'Y'
     C                   ENDIF
     C                   WRITE     GLEVNTDF
     C                   EXSR      SRUPDTRL
 
     C                   IF        INOI = 'I'
     C                   EVAL      INOI = 'O'
     C                   ELSE
     C                   EVAL      INOI = 'I'
     C                   ENDIF
     C                   EVAL      CUNR = A8BICN
 
     C                   WRITE     GLEVNTDF
     C                   EXSR      SRUPDTRL
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPDTRL - Update Trailer File                               *
      *                                                               *
      *****************************************************************
     C     SRUPDTRL      BEGSR
 
      ** Update trailer
 
     C**********         IF        WKNOREC > 99997                                BUG27825 BUG27825A
     C**********         Z-ADD     0             WKNOREC                          BUG27825 BUG27825A
     C**********         ENDIF                                                    BUG27825 BUG27825A
     C**********         EVAL      WKNOREC = WKNOREC + 1                                   BUG27825A
                                                                                           BUG27825A
     C                   ADD       1             WKNOREC                                   BUG27825A
                                                                                           BUG27825A
     C                   EVAL      ZZAMT = WAMT / 1000
     C                   IF        ZZAMT < 0
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF
 
     C                   Z-ADD     WKVLINT       ZZTOTI
     C                   Z-ADD     WKVLDEC       ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        WKVLINT
     C                   Z-ADD     ZZTOTD        WKVLDEC
 
     C**********         EVAL      NORE = WKNOREC                                          BUG27825A
     C                   EVAL      NORE = WKNOREC + 2                                      BUG27825A
     C                   EVAL      HRWN = WKVLINT
     C                   EVAL      HRDC = WKVLDEC
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCURR   - Subroutine to get currency details                *
      *                                                               *
      *****************************************************************
     C     SRCURR        BEGSR
 
      ** Retrieve decimal positions for given currency
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 3
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  = PCCY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCUST   - Subroutine to get customer details                *
      *                                                               *
      *****************************************************************
     C     SRCUST        BEGSR
 
      ** Retrieve customer details
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCNUM
     C                   PARM      *BLANKS       PCNST
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 4
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY  = PCNUM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBRCH - Subroutine to get branch details                    *
      *                                                               *
      *****************************************************************
     C     SRBRCH        BEGSR
 
      ** Call Access Program for Branch Details.
 
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PBRCA
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
      ** Handle Database Error.
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 5
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY = PBRCA
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNOST - Get Nostro Account Details                          *
      *                                                               *
      *****************************************************************
     C     SRNOST        BEGSR
 
      ** Call Access Program for NOSTRO Details.
 
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM                    PCNUM
     C                   PARM                    PCCY
     C                   PARM                    PACCD
     C                   PARM                    PACSN
     C                   PARM      *BLANKS       PNONB
     C                   PARM                    PBRCA
     C                   PARM      *BLANKS       PCSSN
     C                   PARM      *BLANKS       PPNOI
     C     SDNOST        PARM      SDNOST        DSSDY
 
      ** Handle Database Error.
 
     C                   IF        PRTCD <> *BLANKS
     C                             AND PRTCD <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 6
     C                   EVAL      DBFILE = 'SDNOSTPD'
     C                   EVAL      DBKEY = PNONB
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
      ** If record not found
 
     C                   ELSEIF    PRTCD = '*NRF'
     C                   EVAL      NOSA = '00'
     C                   ELSE
     C                   EVAL      NOSA = A7NONB
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GLZADD  -  Adds an amount (ZZAMT) to the total               *
      *             (ZZTOTI,ZZTOTD)                                   *
      *                                                               *
      *****************************************************************
     C     GLZADD        BEGSR
 
     C                   Z-ADD     ZZAMT         ZZAMT                    91
 
     C                   IF        *IN91 = *ON
     C                   GOTO      ZZAEND
     C                   ENDIF
 
      ** Split ZZAMT into integer and decimal fields
 
     C                   Z-ADD     ZZAMT         ZZAMTI
     C                   MOVE      ZZAMT         ZZAMTD
 
      ** Both ZZAMTI and ZZAMTD contain a 'SIGN' zone now
 
     C                   EXSR      GLZSUM
 
     C     ZZAEND        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GLZSUM  -  Carries out the addition of the amounts           *
      *                                                               *
      *****************************************************************
     C     GLZSUM        BEGSR
 
     C                   Z-ADD     ZZTOTI        ZZTOTI
     C                   Z-ADD     ZZTOTD        ZZTOTD
     C                   EVAL      *IN91 = *OFF
     C                   EVAL      *IN92 = *OFF
     C                   EVAL      *IN93 = *OFF
     C                   EVAL      *IN94 = *OFF
     C                   EVAL      *IN95 = *OFF
     C                   EVAL      *IN99 = *OFF
 
      ** Determine sign of ZZAMTI & D, 92 if neg.
 
     C     ZZAMTI        COMP      0                                    9293
 
     C                   IF        *IN93 = *ON
     C     ZZAMTD        COMP      0                                    9293
     C                   ENDIF
 
     C                   IF        *IN93 = *ON
     C                   GOTO      ZZSEND
     C                   ENDIF
 
      ** Determine sign of ZZTOTI & D, 91 if neg.
 
     C     ZZTOTI        COMP      0                                    9193
 
     C                   IF        *IN93 = *ON
     C     ZZTOTD        COMP      0                                    9193
     C                   ENDIF
 
      ** If ZZTOTAL is zero, return ZZAMOUNT.
 
     C                   IF        *IN93 = *ON
     C                   Z-ADD     ZZAMTI        ZZTOTI
     C                   Z-ADD     ZZAMTD        ZZTOTD
     C                   GOTO      ZZSEND
     C                   ENDIF
 
      ** If signs differ bypass overflow checks.
 
     C                   IF        *IN91 = *ON AND
     C                             *IN92 = *OFF OR
     C                             *IN91 = *OFF AND
     C                             *IN92 = *ON
     C                   GOTO      ZZOFPS
     C                   ENDIF
 
     C     ZZAMTD        ADD       ZZTOTD        ZZWK2
     C     ZZWK2         COMP      999                                93
 
     C                   IF        *IN93 = *OFF
     C     ZZWK2         COMP      -999                                 93
     C                   ENDIF
 
     C                   IF        *IN93 = *ON AND
     C                             *IN92 = *OFF
     C     ZZAMTI        ADD       1             ZZWK3
     C                   ENDIF
 
     C                   IF        *IN93 = *ON AND
     C                             *IN92 = *ON
     C     ZZAMTI        SUB       1             ZZWK3
     C                   ENDIF
 
     C                   IF        *IN93 = *ON
     C     ZZTOTI        ADD       ZZWK3         ZZWK3
     C                   ENDIF
 
     C                   IF        *IN93 = *OFF
     C     ZZTOTI        ADD       ZZAMTI        ZZWK3
     C                   ENDIF
 
      ** If the modulus of ZZWk3 is lt mod. ZZTOTI then O/F has occurred
 
     C                   IF        *IN92 = *OFF
     C     ZZWk3         COMP      ZZTOTI                               99
     C                   ENDIF
 
     C                   IF        *IN92 = *ON
     C     ZZWk3         COMP      ZZTOTI                             99
     C                   ENDIF
 
     C                   IF        *IN99 = *OFF
     C                   Z-ADD     ZZWK2         ZZTOTD
     C                   Z-ADD     ZZWK3         ZZTOTI
     C                   ENDIF
 
      ** If O/F zeroise ZZAMT, ind '99' set and ZZTOT fields left intact
 
     C                   IF        *IN99 = *ON
     C                   Z-ADD     0             ZZAMT
     C                   ENDIF
 
     C                   GOTO      ZZSEND
 
      ** The 'SIGNS' are different
 
     C     ZZOFPS        TAG
 
      ** If ZZAMT was negative, make it pos. to comp with ZZTOT
 
     C                   IF        *IN92 = *ON
     C                   Z-SUB     ZZAMTI        ZZAMTI
     C                   Z-SUB     ZZAMTD        ZZAMTD
     C                   ENDIF
 
      ** If ZZTOT was negative, make it pos. to comp with ZZAMT.
 
     C                   IF        *IN91 = *ON
     C                   Z-SUB     ZZTOTI        ZZTOTI
     C                   Z-SUB     ZZTOTD        ZZTOTD
     C                   ENDIF
 
      ** Both ZZAMT and ZZTOT are noe positive
 
     C     ZZTOTI        COMP      ZZAMTI                             93  95
 
     C                   IF        *IN95 = *ON
     C     ZZTOTD        COMP      ZZAMTD                             93  95
     C                   ENDIF
 
      ** If ZZTOT eq. ZZAMT return zero.
 
     C                   IF        *IN95 = *ON
     C                   Z-ADD     0             ZZTOTI
     C                   Z-ADD     0             ZZTOTD
     C                   GOTO      ZZSEND
     C                   ENDIF
 
      ** If ZZTOT gt. ZZAMT.
 
     C                   IF        *IN93 = *ON
     C     ZZAMTD        COMP      ZZTOTD                             94
     C                   ENDIF
 
     C                   IF        *IN93 = *ON AND
     C                             *IN94 = *ON
     C     ZZTOTI        SUB       1             ZZTOTI
     C     ZZTOTD        ADD       1000          ZZWK2
     C                   ENDIF
 
     C                   IF        *IN93 = *ON
     C     ZZTOTI        SUB       ZZAMTI        ZZTOTI
     C                   ENDIF
 
     C                   IF        *IN93 = *ON AND
     C                             *IN94 = *ON
     C     ZZWK2         SUB       ZZAMTD        ZZTOTD
     C                   ENDIF
 
     C                   IF        *IN93 = *ON AND
     C                             *IN94 = *OFF
     C     ZZTOTD        SUB       ZZAMTD        ZZTOTD
     C                   ENDIF
 
      ** If ZZAMT gt. ZZTOT.
 
     C                   IF        *IN93 = *OFF
     C     ZZTOTD        COMP      ZZAMTD                             94
     C                   ENDIF
 
     C                   IF        *IN93 = *OFF AND
     C                             *IN94 = *ON
     C     ZZAMTI        SUB       1             ZZWK3
     C     ZZAMTD        ADD       1000          ZZWK2
     C     ZZWK3         SUB       ZZTOTI        ZZTOTI
     C                   ENDIF
 
     C                   IF        *IN93 = *OFF AND
     C                             *IN94 = *OFF
     C     ZZAMTI        SUB       ZZTOTI        ZZTOTI
     C                   ENDIF
 
     C                   IF        *IN93 = *OFF AND
     C                             *IN94 = *ON
     C     ZZWk2         SUB       ZZTOTD        ZZTOTD
     C                   ENDIF
 
     C                   IF        *IN93 = *OFF AND
     C                             *IN94 = *OFF
     C     ZZAMTD        SUB       ZZTOTD        ZZTOTD
     C                   ENDIF
 
      ** Reverse sign of ZZTOT if larger I/P fields were negative
 
     C                   EVAL      *IN94 = *OFF
 
     C                   IF        *IN93 = *ON AND
     C                             *IN91 = *ON OR
     C                             *IN93 = *OFF AND
     C                             *IN92 = *ON
     C                   EVAL      *IN94 = *ON
     C                   ENDIF
 
     C                   IF        *IN94 = *ON
     C                   Z-SUB     ZZTOTI        ZZTOTI
     C                   Z-SUB     ZZTOTD        ZZTOTD
     C                   ENDIF
 
      ** Restore sign of ZZAMTI & ZZAMTD If It was reversed.
 
     C                   IF        *IN92 = *ON
     C                   Z-SUB     ZZAMTI        ZZAMTI
     C                   Z-SUB     ZZAMTD        ZZAMTD
     C                   ENDIF
 
     C     ZZSEND        TAG
 
      ** If ZZTOTD is zero, and ZZTOTI is neg. set up ZZNEGD.
 
     C                   EVAL      *IN96 = *OFF
 
     C     ZZTOTD        COMP      0                                      91
 
     C                   IF        *IN91 = *ON
     C     ZZTOTI        COMP      0                                    96
     C                   ENDIF
 
     C                   IF        *IN96 = *ON
     C                   MOVE      '.000-'       ZZNEGD
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCFAU  - Register AU Printer file for RCF processing       *
      *                                                               *
      *****************************************************************
     C     SRRCFAU       BEGSR
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   EVAL      PZSNUM = PSFNUMU
     C                   EVAL      PSFILE = PSFILEU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PZSEQ
     C                   PARM                    PZENTY
     C                   PARM                    PSFILE
     C                   PARM                    PZSNUM
     C                   PARM      *BLANKS       PZSERR
 
      ** If error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C                   IF        PZSERR = 'Y'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 7
     C                   EVAL      DBFILE = 'ZSFILE'
     C                   EVAL      DBKEY  = 'GL004602AU'
     C                   OUT       LDA
     C                   DUMP
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAUDIT  - Output Audit Report                               *
      *                                                               *
      *****************************************************************
     C     SRAUDIT       BEGSR
 
     C                   IF        NOT %OPEN(GL004602AU)
     C                   OPEN      GL004602AU
     C                   ENDIF
 
     C                   EXSR      SRRCFAU
 
      ** Output Report Header and File Controls
 
     C                   WRITE     HEADAU
 
      ** If there is a DB Error, Output the DB Error Information.
 
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE
 
      ** Or, if no records read, Output "No Details" message.
 
     C                   IF        WKNOREC =  0
     C                   WRITE     NODTLS
     C                   ELSE
     C                   WRITE     CONTROL
     C                   ENDIF
 
     C                   ENDIF
 
     C                   WRITE     ENDRPT
 
     C                   IF        %OPEN(GLEVNTZZ)
     C                   CLOSE     GLEVNTZZ
     C                   ENDIF
 
     C                   IF        %OPEN(GL004602AU)
     C                   CLOSE     GL004602AU
     C                   ENDIF
 
      ** End program
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR   - Program Initialisation Routine                    *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = *ZERO
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY  = *BLANKS
     C                   EVAL      DBPGM  = 'GL004602'
     C                   OUT       LDA
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = POPTN
     C                   EVAL      DBPGM = 'GL004602'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Retrieve Event Generation Trailer details
 
     C                   IF        NOT %OPEN(GLEVNTZZ)
     C                   OPEN      GLEVNTZZ
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR    - Error handling Routine                            *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
 
     C                   IF        WRUN = *OFF
     C                   EVAL      WRUN = *ON
     C                   DUMP
     C                   EXSR      SRAUDIT
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
