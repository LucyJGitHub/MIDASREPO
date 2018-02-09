     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Financial Loan Diary Extract - Coll Event')   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000040 - Financial Loan Diary Events Extract -             *
      *             Collateral Events                                 *
      *                                                               *
      *  Function:  This module will extract collateral events that   *
      *             will be included in the Financial Loan Diary.     *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248405             Date 12Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244589             Date 19Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 240313             Date 29Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG8071 (Reopen)   Date 11Aug05               *
      *                 BUG8071            Date 08Aug05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3644            Date 12Jul04               *
      *                 BUG3392            Date 24Jun04               *
      *                 CLE025  *CREATE    Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248405 - Correct ZZAMT.                                      *
      *  244589 - Enhance report for syndicated loans.(Recompile)     *
      *  240313 - Applied 239928.                                     *
      *  239928 - LEC07 10005 file out of balance in LE0691AU.        *
      *           ZZAMTD is always 0.                                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type                              *
      *  BUG8071 - (Reopen) ZZAMTD is always 0.                       *
      *  BUG8071 - LEC07 10005 file out of balance in LE0691AU        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  BUG3392 - Program fails with invalid database error          *
      *  CLE025 - Credit Lines                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** Ê F-specs                              Ê
      ** Ê =======                              Ê
      ** +--------------------------------------+
     FGLCOEVPD  IF   E             DISK    INFSR(*PSSR)
     FLVEDS     UF A E           K DISK    INFSR(*PSSR)
     FLE000040AUO    E             PRINTER
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** Ê Automatically included D-specs       Ê
      ** Ê ==============================       Ê
      ** +--------------------------------------+
 
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area Giving Installation Control Details
 
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** Ê End of automatically included D-specsÊ
      ** Ê =====================================Ê
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** Ê Manually included D-specs            Ê
      ** Ê =========================            Ê
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** Ê Named constants                      Ê
      ** Ê ===============                      Ê
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** Ê Arrays and Data Structures           Ê
      ** Ê ==========================           Ê
      ** +--------------------------------------+
 
     D WFACLTY         DS
     D***WCUST**               1      6S 0                                                    CSD027
     D   WCUST                 1      6A                                                      CSD027
     D   WFACT                 7      9S 0
     D   WFCNO                10     11S 0
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D SDCOCC        E DS                  EXTNAME(SDCOCCPD)
      ** External DS for Collateral and Credit Lines ICD
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External DS for Customer Details
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D QQDFAC1       E                     EXTFLD(QQDFAC)
      ** External DS for Branch Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long Data Structure
 
      ** +--------------------------------------+
      ** Ê Declared variables                   Ê
      ** Ê ==================                   Ê
      ** +--------------------------------------+
 
     D PRTCD           S              7
     D POPTN           S              7
     D PCUST           S             10
     D PKEY1           S              7
 
     D WRUN            S              1
     D WFTYP           S              3
     D WFSEQ           S              2
     D WEVDAT          S              1
     D WNOREC          S              5  0
     D WTOTAL          S             15  0
 
     D*ZZAMT***********S             15  3                                                    248405
     D ZZAMT           S             18  3                                                    248405
     D ZZAMTI          S             15  0
     D ZZAMTD          S              3  0
     D ZZTOTI          S             15  0
     D ZZTOTD          S              3  0
     D ZZWK2           S              4  0
     D ZZWK3           S             15  0
     D ZZNEGD          S              5
     D ZDAYNO          S              5  0
     D ZDYNBR          S              5  0
     D ZNRDYS          S              2  0
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** Ê                                                                Ê
      ** Ê Initial processing is performed automatically: the *INZSR is   Ê
      ** Ê executed at program activation.                                Ê
      ** Ê                                                                Ê
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   IF        CCICED = 'Y'
 
     C                   READ      GLCOEVPD
 
     C                   DOW       NOT %EOF(GLCOEVPD)
 
     C                   EVAL      WCUST = COFCUS
     C                   EVAL      WFACT = COFTYP
     C                   EVAL      WFCNO = COFSEQ
 
      ** Calculate number of working days forward
 
     C                   CALLB     'ZFWDT'
     C                   PARM      COEDAT        ZDAYNO
     C                   PARM      10            ZNRDYS
     C                   PARM                    ZDYNBR
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
 
      ** Check if event date is within next 10 working days
 
     C                   IF        COEDAT >= BJDNWD and COEDAT <= ZDYNBR
     C                   EVAL      WEVDAT = 'Y'
     C                   ELSE
     C                   EVAL      WEVDAT = 'N'
     C                   ENDIF
 
     C                   IF        COALLF = 'Y' and COMODS = 'LE' and
     C                             WFACLTY <> *ZEROS and WEVDAT = 'Y'
 
     C                   MOVE      *BLANK        PCUST                                       BUG3392
     C                   MOVE      COCNUM        PCUST
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCUST
     C                   PARM                    PKEY1
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C     PRTCD         IFNE      *BLANKS
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY  = PCUST
     C                   EVAL      DBASE  = 3
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   CALLB     'AOBRCHR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    COBRCA
     C     SDBRCH        PARM      SDBRCH        DSFDY
 
     C     PRTCD         IFNE      *BLANKS
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY  = COBRCA
     C                   EVAL      DBASE  = 4
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EXSR      SRWRTREC
 
     C                   EVAL      WNOREC = WNOREC + 1
     C                   EVAL      WTOTAL = WTOTAL + COVAMT
 
     C                   ENDIF
 
      ** Read next record
 
     C                   READ      GLCOEVPD
 
     C                   ENDDO
 
      ** Update trailer file
 
     C                   EXSR      SRHASH
 
     C                   EXSR      SRAUDIT
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWRTREC - Write Details on Report                           *
      *                                                               *
      *****************************************************************
 
     C     SRWRTREC      BEGSR
 
     C**********         EVAL      RECI = 'R'                                                BUG8071
     C                   EVAL      RECI = 'D'                                                BUG8071
 
      ** Determine event
 
     C                   SELECT
     C                   WHEN      COETYP = 'COST'
     C                   EVAL      EVNT = 'N'
     C                   WHEN      COETYP = 'COMT'
     C                   EVAL      EVNT = 'O'
     C                   WHEN      COETYP = 'CORN'
     C                   EVAL      EVNT = 'P'
     C                   WHEN      COETYP = 'COVL'
     C                   EVAL      EVNT = 'Q'
     C                   ENDSL
 
     C                   EVAL      BWCN = COCNUM
     C                   EVAL      CONI = *BLANKS
     C                   EVAL      CDTI = *BLANKS
     C                   EVAL      ACOC = *BLANKS
     C                   EVAL      EVND = COEDAT
 
     C                   MOVE      COFTYP        WFTYP
     C                   MOVE      COFSEQ        WFSEQ
     C                   EVAL      CFRF = 'F' + WFTYP + WFSEQ
 
     C                   EVAL      EVNF = COFREQ
     C                   EVAL      AMNT = COVAMT
     C**********         EVAL      LDRF = *ZEROS                                              CLE148
     C                   EVAL      LDRF = *BLANKS                                             CLE148
     C                   EVAL      CMCY = COFCCY
     C                   EVAL      DDCY = COCCY
     C                   EVAL      RFXD = *ZEROS
     C                   EVAL      AGNT = *ZEROS
     C                   EVAL      RPYA = *ZEROS
     C                   EVAL      INTA = *ZEROS
     C                   EVAL      WTXI = *BLANKS
     C                   EVAL      OFCD = *ZEROS
     C                   EVAL      CASK = BBCASC
     C                   EVAL      CRNM = BBCRNM
     C                   EVAL      CTWN = BBCRTN
     C                   EVAL      FCUS = COFCUS
     C                   EVAL      AUTO = *BLANKS
     C                   EVAL      LTYP = *BLANKS
     C                   EVAL      SUTP = *BLANKS
     C                   EVAL      CLAS = *BLANKS                                             CLE042
     C                   EVAL      BRCA = COBRCA
     C                   EVAL      CMPYM = A8CMCD
     C                   EVAL      ZZ006 = *BLANKS
     C                   EVAL      FSEQ = *ZEROS
     C                   EVAL      GASI = *BLANKS
     C                   EVAL      CREF = COCREF
     C                   EVAL      COLT = COCOLT
     C                   EVAL      DESC = CODESC
     C                   EVAL      ENTY = COENTY
     C                   EVAL      ENTT = COENTT
     C                   EVAL      GNSP = COGNSP
     C                   EVAL      LAMT = COLAMT
 
     C                   WRITE     LVEDIF1F
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRHASH - Compute Hash Totals                                 *
      *                                                               *
      *****************************************************************
 
     C     SRHASH        BEGSR
 
     C                   READ      LVEDIT2F                               15
 
     C                   IF        *IN15 = *OFF
 
     C                   EVAL      ZZAMT = WTOTAL
     C                   EVAL      ZZAMT = ZZAMT / 1000                                      BUG8071
     C                   EVAL      ZZTOTI = HRWN
     C                   EVAL      ZZTOTD = HRDC
     C                   EXSR      GLZADD
 
     C                   EVAL      NORE = NORE + WNOREC
     C                   EVAL      HRWN = ZZTOTI
     C                   EVAL      HRDC = ZZTOTD
     C                   UPDATE    LVEDIT2F
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GLZADD - Subroutine to Add an Amount to the Total            *
      *                                                               *
      *****************************************************************
 
     C     GLZADD        BEGSR
 
     C     ZZAMT         IFNE      *ZERO
 
      ** Split ZZAMT into integer and decimal fields
 
     C                   Z-ADD     ZZAMT         ZZAMTI
     C                   MOVE      ZZAMT         ZZAMTD
 
      ** Both ZZAMTI and ZZAMTD contain a 'sign' zone now
 
     C                   EXSR      GLZSUM
 
     C                   ENDIF
 
     C     ZZAEND        ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GLZSUM - Subroutine to Carry Out the Addition of Subroutines *
      *                                                               *
      *****************************************************************
 
     C     GLZSUM        BEGSR
 
     C                   Z-ADD     ZZTOTI        ZZTOTI
     C                   Z-ADD     ZZTOTD        ZZTOTD
     C                   SETOFF                                       919293
     C                   SETOFF                                       949599
 
      ** Determine sign of ZZAMTI & D, 92 if negative
 
     C     ZZAMTI        COMP      0                                    9293
     C   93ZZAMTD        COMP      0                                    9293
     C   93              GOTO      ZZSEND
 
      ** Determine sign of ZZTOTI & D, 91 if negative
 
     C     ZZTOTI        COMP      0                                    9193
     C   93ZZTOTD        COMP      0                                    9193
 
      ** If ZZTOTAL is zero, return ZZAMOUNT
 
     C   93              Z-ADD     ZZAMTI        ZZTOTI
     C   93              Z-ADD     ZZAMTD        ZZTOTD
     C   93              GOTO      ZZSEND
 
      ** If signs differ bypass overflow checks
 
     C   91
     CANN92
     CORN91
     CAN 92              GOTO      ZZOFPS
      *
     C     ZZAMTD        ADD       ZZTOTD        ZZWK2
     C     ZZWK2         COMP      999                                93
     C  N93ZZWK2         COMP      -999                                 93
 
     C   93
     CANN92ZZAMTI        ADD       1             ZZWK3
     C   93
     CAN 92ZZAMTI        SUB       1             ZZWK3
     C   93ZZTOTI        ADD       ZZWK3         ZZWK3
     C  N93ZZTOTI        ADD       ZZAMTI        ZZWK3
 
      ** If the modulus of ZZWK3 is < modulus of ZZTOTI then O/F has occured
 
     C  N92ZZWK3         COMP      ZZTOTI                               99
     C   92ZZWK3         COMP      ZZTOTI                             99
     C  N99              Z-ADD     ZZWK2         ZZTOTD
     C  N99              Z-ADD     ZZWK3         ZZTOTI
 
      ** If O/F zeroise ZZAMT, 99 set and ZZTOT fields left intact
 
     C   99              Z-ADD     0             ZZAMT
     C                   GOTO      ZZSEND
 
      ** The 'signs' are different
 
     C     ZZOFPS        TAG
 
      ** If ZZAMT was negative, make it positive to compare with ZZTOT
 
     C   92              Z-SUB     ZZAMTI        ZZAMTI
     C   92              Z-SUB     ZZAMTD        ZZAMTD
 
      ** If ZZTOT was negative, make it positive to compare with ZZAMT
 
     C   91              Z-SUB     ZZTOTI        ZZTOTI
     C   91              Z-SUB     ZZTOTD        ZZTOTD
 
      ** Both ZZAMT and ZZTOT are now positive
 
     C     ZZTOTI        COMP      ZZAMTI                             93  95
     C   95ZZTOTD        COMP      ZZAMTD                             93  95
 
      ** If ZZTOT = ZZAMT return zero
 
     C   95              Z-ADD     0             ZZTOTI
     C   95              Z-ADD     0             ZZTOTD
     C   95              GOTO      ZZSEND
 
      ** If ZZTOT > ZZAMT
 
     C   93ZZAMTD        COMP      ZZTOTD                             94
     C   93
     CAN 94ZZTOTI        SUB       1             ZZTOTI
     C   93
     CAN 94ZZTOTD        ADD       1000          ZZWK2
     C   93ZZTOTI        SUB       ZZAMTI        ZZTOTI
     C   93
     CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD
     C   93
     CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD
 
      ** If ZZAMT > ZZTOT
 
     C  N93ZZTOTD        COMP      ZZAMTD                             94
     C  N93
     CAN 94ZZAMTI        SUB       1             ZZWK3
     C  N93
     CAN 94ZZAMTD        ADD       1000          ZZWK2
     C  N93
     CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI
     C  N93
     CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI
     C  N93
     CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD
     C  N93
     CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD
 
      ** Reverse sign of ZZTOT if larger I/P fields were negative
 
     C                   SETOFF                                       94
     C   93
     CAN 91
     CORN93
     CAN 92              SETON                                        94
     C   94              Z-SUB     ZZTOTI        ZZTOTI
     C   94              Z-SUB     ZZTOTD        ZZTOTD
 
      ** Restore sign of ZZAMTI & ZZAMTD if it was reversed
 
     C   92              Z-SUB     ZZAMTI        ZZAMTI
     C   92              Z-SUB     ZZAMTD        ZZAMTD
     C     ZZSEND        TAG
 
      ** If ZZTOTD is zero, and ZZTOTI is negative set up ZZNEGD
 
     C                   SETOFF                                       96
     C     ZZTOTD        COMP      0                                      91
     C   91ZZTOTI        COMP      0                                    96
     C   96              MOVE      '.000-'       ZZNEGD
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SRAUDIT - Write Audit Report                                 *
      *                                                               *
      *****************************************************************
 
     C     SRAUDIT       BEGSR
 
     C                   WRITE     HEADAU
 
      ** DB error
 
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE
 
      ** No record read
 
     C                   IF        WNOREC = 0
     C                   WRITE     NODTLS
     C                   ELSE
     C                   EVAL      RGNOREC = WNOREC
     C                   EVAL      RGVALUE = WTOTAL
     C                   EVAL      RLNOREC = NORE
     C                   EVAL      RLVALUE = HRWN
     C                   EVAL      RLVALDC = HRDC
     C                   WRITE     CONTROL
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C                   EVAL      DBPGM  = 'LE000040'
 
      ** Access Bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = '*FIRST'
     C                   EVAL      DBASE  = 1
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Collateral and Credit Control ICD
 
     C                   CALL      'AOCOCCR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDCOCC        PARM      SDCOCC        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDCOCCPD'
     C                   EVAL      DBKEY  = '*FIRST'
     C                   EVAL      DBASE  = 2
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialise trailer/hash totals
 
     C                   EVAL      WNOREC = 0
     C                   EVAL      WTOTAL = 0
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program Exception Error Routine                          *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
 
     C                   EXSR      SRAUDIT
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
