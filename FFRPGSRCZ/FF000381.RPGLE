     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Transn Update Phase I (Charges/Comms)')
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FF000381 - Transactions Update Phase I                       *
      *                                                               *
      *  Function:  This program update charges and commissions       *
      *  (EOC & COB)                                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 222165             Date 26May06               *
      *  Prev Amend No. 219682             Date 26May06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL020             Date 12Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007  *CREATE    Date 13Feb01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  222165 - Fix to avoid reversal of comms & charges twice.     *
      *  219682 - Fix to avoid double generation of commission and    *
      *           premium keys.                                       *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL020 - Midas Compliance Watch - Additional A/C Postings    *
      *           Information.                                        *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FACCNT     IF   E           K DISK    EXTIND(*INU2)
     FACNUM     IF   E           K DISK    EXTIND(*INU2)
     F                                     RENAME(ACCNTABF:ACNUMABF)
     FMKCTL     IF   E           K DISK    USROPN
 
     FMARKT     IF   E           K DISK    USROPN
 
     FCHGCM     IF   E           K DISK
     FINTYP     IF   E           K DISK
     FMEMOSM    UF A E           K DISK    EXTIND(*INU2)
     FPRONOM    UF A E           K DISK    EXTIND(*INU6)
     FFFACMVD   O  A E           K DISK    EXTIND(*INU6)
     FFOKEYA    UF   E             DISK
     FTRANS12   IF   E           K DISK
     FTABTB20   IF   E             DISK
     FTABTB40   IF   E             DISK
     FTRSET     UF   E           K DISK
     FFOKEYD    O  A E             DISK
     FCCREVL0   IF   E           K DISK                                                       222165
     FFF000381AUO    E             PRINTER
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       01         EOF for TRANS12                              *
      *       02         Chain Fails                                  *
      *       03         EOF                                          *
      *       10         Record not found in MEMOSM                   *
      *       11         Record not found in PRONOM                   *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D FULA                           1    DIM(34)
     D                 DS
     D FFT                            1    DIM(34)
     D FFTXT                   1     34
 
     D WRNG            DS            45
      ** Data structure to store all chrg/coms lower range limit
     D  RNG                    1     45  0 DIM(9)
     D  LR01                   1      5  0
     D  LR02                   6     10  0
     D  LR03                  11     15  0
     D  LR04                  16     20  0
     D  LR05                  21     25  0
     D  LR06                  26     30  0
     D  LR07                  31     35  0
     D  LR08                  36     40  0
     D  LR09                  41     45  0
 
     D WAMT            DS           117
      ** Data structure to store all chrg/coms amount
     D  AMT                    1    117  0 DIM(9)
     D  CA01                   1     13  0
     D  CA02                  14     26  0
     D  CA03                  27     39  0
     D  CA04                  40     52  0
     D  CA05                  53     65  0
     D  CA06                  66     78  0
     D  CA07                  79     91  0
     D  CA08                  92    104  0
     D  CA09                 105    117  0
 
     D BRIS            DS             8
      ** Data structure to store branch and broker code
     D  BRCA                   1      3
     D  ISTT                   4      8
 
     D PBRIS           DS             8
      ** Data structure to store branch and broker code
     D  PBRCA                  1      3
     D  PISTT                  4      8
 
     D FFKY            DS            14
      ** FO Account Key
     D  FKEY11                 1      1
     D  FKEY13                 3      3
     D  INVA                   2      2
     D  BOKC                   4      5
     D  TISTT                  6     10
     D  FOKEY2                11     14
 
     D                 DS
     D*FFSETA***               1     12                                                       CGL029
     D FFSETA                  1     18                                                       CGL029
     D*FFSCNM***               1      6  0                                                    CSD027
     D FFSCNM                  1      6A                                                      CSD027
     D*FFSACD***               7     10  0                                                    CGL029
     D*FFSASQ***              11     12  0                                                    CGL029
     D FFSACD                  7     16  0                                                    CGL029
     D FFSASQ                 17     18  0                                                    CGL029
     D FFACMK                  1     10  0
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details
 
     D SDFODA        E DS                  EXTNAME(SDFODAPD)
      ** Futures and Options ICD Details
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** Branch Details
 
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      ** Nostro Details
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
 
     D SDACOD        E DS                  EXTNAME(SDACODPD)
      ** Account Code Details
     D  QQACC2       E                     EXTFLD(QQACCD)                                     CGL029
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CGL020
      ** SAR Details                                                                          CGL020
                                                                                              CGL020
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long Data Structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D FF              S              2  0
     D FFULIN          S              2  0
     D FFNAM           S             20
     D FFDAT           S              7
     D FF1             S              1
 
     D ZDAYNO          S              5  0
     D ZNRDYS          S              2  0
     D ZDYNBR          S              5  0
     D ZCCY            S              3
     D ZLOC            S              3
     D ZDATE           S              6  0
     D ZADATE          S              7
     D ZZAMT           S             15  3
 
     D WBUSD           S              7
     D WWBUSD          S              5  0
 
     D PRTCD           S              7
     D POPTN           S              7
     D PCUST           S              6
     D PCCY            S              3
     D*PACCD****       S              4                                                       CGL029
     D PACCD           S             10                                                       CGL029
     D PACSN           S              2
     D PNONB           S              2
     D PCSSN           S             10
     D PPNOI           S              1
     D*PACOD****       S              4                                                       CGL029
     D PACOD           S             10                                                       CGL029
     D PMRKT           S              2
 
     D FFBRCA          S              3
     D*FFCBCD***       S              6  0                                                    CSD027
     D FFCBCD          S              6A                                                      CSD027
     D FFBRKI          S              1
     D FFSETP          S              2  0
     D FFSETB          S              3
     D FFCCY           S              3
     D FFBRCB          S              3
     D*FFCNUM***       S              6  0                                                    CSD027
     D FFCNUM          S              6A                                                      CSD027
     D*FFACOD***       S              4  0                                                    CGL029
     D FFACOD          S             10  0                                                    CGL029
     D FFACSQ          S              2  0
     D FFNOSN          S              2  0
     D FFMIND          S              1
     D FFPIND          S              1
 
     D WKEY            S              5
     D WBCHP           S             13  0
     D WBCMP           S             13  0
     D WCCHP           S             13  0
     D WCCMP           S             13  0
     D WMKTN           S             20
     D WCONO           S              5  0
     D WRATA           S             13  0
     D TRATA           S             13  0
     D TCONO           S              5  0
     D SNUCO           S              5  0
     D XCPSB           S              5  0
     D XCPDB           S              5  0
     D XCPSC           S              5  0
     D XCPDC           S              5  0
     D BCHCM           S             15  0
     D CCHCM           S             15  0
     D PBCHCM          S             15  0
     D PCCHCM          S             15  0
 
      ** Variables used in CGL020.                                                            CGL020
     D CGL020          S              1                                                       CGL020
     D PSARD           S              6                                                       CGL020
     D SEFA            S             10                                                       CGL020
     D SECP            S              8                                                       CGL020
                                                                                              CGL020
      ** Parameters for ZAAMLSETFF                                                            CGL020
     D*PCBCD****       S              6S 0                                             CGL020 CSD027
     D PCBCD           S              6A                                                      CSD027
                                                                                              CGL020
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
     ITRANSDF
     I              RECI                        TRECI
     I              VALD                        TVDAT
     I              ORED                        TORED
     I              LCD                         TVLCD
     I              PTFR                        TPTFR
      /EJECT
      *================================================================
      *  P R O G R A M     S T A R T
      *================================================================
 
      ** Main processing
 
     C                   EXSR      SRMAIN
 
      ** End processing
 
     C                   EXSR      SREXIT
 
      *================================================================
      *  P R O G R A M     E N D
      *================================================================
      /EJECT
      *****************************************************************
      *                                                               *
      * SREXIT - Update FOKEYA                                        *
      *                                                               *
      *****************************************************************
 
     C     SREXIT        BEGSR
 
      ** Access FOKEYA and update FOKEYA only if there is no database error
     C                   READ      FOKEYAF                                03
 
      ** Database Error
     C     *IN03         IFEQ      '1'
     C     RECI          ORNE      'T'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 8
     C                   EVAL      DBFILE = 'FOKEYA'
     C                   EVAL      DBKEY = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
 
      ** Update FOKEYA only if there is FOKEYD record written out
     C     COUNT         IFNE      0
 
      ** Add hash total to file control total
 
     C                   ADD       ZZTOTI        HRWN
     C     HRDC          ADD       ZZTOTD        TEMP              3 0
 
     C     TEMP          IFLT      HRDC
     C                   ADD       1             HRWN
     C                   ENDIF
 
     C                   Z-ADD     TEMP          HRDC
 
     C                   ADD       COUNT         NORE
     C                   MOVE      'T'           RECI
 
     C                   UPDATE    FOKEYAF
 
     C                   ENDIF
     C                   EXSR      SRAUDIT
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAUDIT- Generates audit report and terminates program        *
      *                                                               *
      *****************************************************************
 
     C     SRAUDIT       BEGSR
 
      ** Output run control report, one page only
 
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
 
     C     *INU7         IFEQ      '1'
     C     *INU8         OREQ      '1'
     C                   WRITE     DBERROR
     C                   ENDIF
 
     C                   WRITE     TRAILER
 
      ** Terminates the program
 
     C                   SETON                                        LR
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMAIN - Process records in TRANS12 file                      *
      *                                                               *
      *****************************************************************
 
     C     SRMAIN        BEGSR
 
      ** Read TRANS12
     C                   READ      TRANS12                                01
 
      ** Do while not EOF
     C     *IN01         DOWEQ     '0'
 
     C                   MOVE      BRCA          PBRCA
 
      ** Access branch details
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PBRCA
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
      ** Database error
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY = PBRCA
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Do while not EOF and same branch
     C     *IN01         DOWEQ     '0'
     C     BRCA          ANDEQ     PBRCA
 
     C                   MOVE      ISTT          PISTT
 
     C     ISTT          CHAIN     INTYP                              02
 
      ** Database error
     C     *IN02         IFEQ      '1'
     C     RECI          ORNE      'D'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 5
     C                   EVAL      DBFILE = 'INTYP'
     C                   EVAL      DBKEY = ISTT
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Do while same instrument type,  same branch code and not EOF
 
     C     BRIS          DOWEQ     PBRIS
     C     *IN01         ANDEQ     '0'
 
      ** Access TRSET for transaction settlement details
 
     C     TNBR          CHAIN     TRSET                              02
 
      ** Database error
     C     *IN02         IFEQ      '1'
     C     *IN02         OREQ      '0'
     C     RECI          ANDNE     TRECI
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 6
     C                   EVAL      DBFILE = 'TRSET'
     C                   MOVEL     TNBR          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Process records with value date less or equal next working day
      ** minus one calendar day. Otherwise bypass processing.
 
      ** If Market process, take Business Date instead of Run Date
     C     PMRKT         IFEQ      *BLANKS
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   ELSE
     C                   Z-ADD     BUSD          ZDAYNO
     C                   ENDIF
     C*
     C                   Z-ADD     1             ZNRDYS
     C                   MOVE      ISCY          ZCCY
 
     C                   CALLB     'ZFWDT'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZNRDYS
     C                   PARM                    ZDYNBR
     C                   PARM                    ZCCY
     C                   PARM      *BLANKS       ZLOC
 
     C     TRECI         IFEQ      'D'
     C     TVDAT         ANDLT     ZDYNBR
     C     TVDAT         ANDGE     ZDAYNO
 
     C     TRECI         OREQ      '*'
     C     ZDAYNO        ANDGT     TVDAT
     C     TVLCD         ANDEQ     ZDAYNO
 
     C     TRECI         OREQ      'D'
     C     TVDAT         ANDLT     ZDYNBR
     C     TORED         ANDEQ     ZDAYNO
 
      ** Store value of customer/broker charges/commissions in order to
      ** reverse out the old figure for the updating of MEMOSM file and
      ** PRONOM file
 
     C                   Z-ADD     BCHP          WBCHP
     C                   Z-ADD     BCMP          WBCMP
     C                   Z-ADD     CCHP          WCCHP
     C                   Z-ADD     CCMP          WCCMP
 
      ** For active and deleted records
 
     C     TRECI         IFEQ      'D'
     C                   EXSR      SRACTVE
     C                   ELSE
      *                                                                                       222165
      ** Access CCREVL0 for reversal details                                                  222165
      *                                                                                       222165
     C     TNBR          CHAIN     CCREVL0                            02                      222165
      *                                                                                       222165
     C     *IN02         IFEQ      '1'                                                        222165
     C     *LOCK         IN        LDA                                                        222165
     C                   EVAL      DBASE = 13                                                 222165
     C                   EVAL      DBFILE = 'CCREVL0'                                         222165
     C                   MOVEL     TNBR          DBKEY                                        222165
     C                   OUT       LDA                                                        222165
     C                   EXSR      *PSSR                                                      222165
     C                   ENDIF                                                                222165
      *                                                                                       222165
     C                   EXSR      SRDELT
     C                   ENDIF
 
      ** Determine if MEMOSM and PRONOM need updating
 
     C                   EXSR      SRUMMPR
 
     C                   ENDIF
 
      ** Update transaction settlement details
     C                   UPDATE    TRSETDF
 
      ** Read next TRANS12 record
     C                   READ      TRANS12                                01
 
     C                   ENDDO
 
     C                   ENDDO
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRACTVE - Process active transactions                         *
      *                                                               *
      *****************************************************************
 
     C     SRACTVE       BEGSR
 
      ** Broker is involved
     C*****BOCO*         IFNE      0                                                          CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
 
     C                   MOVE      'B'           BROCUS            1
 
      ** For future trades at maturity
      ** Use total of broker contracts as number of contracts
     C     ISPT          IFLE      3
     C     TNBR          ANDLT     *ZERO
     C                   Z-ADD     NUCO          SNUCO
     C     CCSB          ADD       CCDB          NUCO
     C                   ENDIF
 
      ** Broker charges
     C     CHCB          IFNE      'Y'                                                        219682
     C                   EXSR      SRPTBCH
     C                   ENDIF                                                                219682
 
      ** Broker commissions
     C     CMCB          IFNE      'Y'                                                        219682
     C     BCPT          IFEQ      'A'
     C                   EXSR      SRBKCMA
     C                   ELSE
     C                   EXSR      SRBPTRN
     C                   ENDIF
     C                   ENDIF                                                                219682
 
      ** For Future trades at maturity
      ** Restore original number of contracts
     C     ISPT          IFLE      3
     C     TNBR          ANDLT     *ZERO
     C                   Z-ADD     SNUCO         NUCO
     C                   ENDIF
 
     C                   ENDIF
 
      ** Customer is involved
     C*****CUSC*         IFNE      0                                                          CSD027
     C     CUSC          IFNE      *BLANKS                                                    CSD027
 
     C                   MOVE      'C'           BROCUS
 
      ** Customer charges
     C     CHCC          IFNE      'Y'                                                        219682
     C                   EXSR      SRPTCCH
     C                   ENDIF                                                                219682
 
      ** Customer commissions
     C     CMCC          IFNE      'Y'                                                        219682
     C     CCPT          IFEQ      'A'
     C                   EXSR      SRCUCMA
     C                   ELSE
     C                   EXSR      SRCPTRN
     C                   ENDIF
     C                   ENDIF                                                                219682
                                                                                              219682
     C                   ENDIF
 
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDELT - Reverse out charges and commissions for deleted      *
      *          transactions                                         *
      *                                                               *
      *****************************************************************
 
     C     SRDELT        BEGSR
 
      ** Broker is involved
     C*****BOCO*         IFNE      0                                                          CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      'B'           BROCUS
 
      ** Reverse broker charges and commissions
     C     BCHR          IFNE      'Y'                                                        222165
     C                   EXSR      SRRVBCH
     C                   ENDIF                                                                222165
      *
     C     BCOR          IFNE      'Y'                                                        222165
     C                   EXSR      SRRVBCM
     C                   ENDIF                                                                222165
      *                                                                                       222165
     C                   END
 
      ** Customer is involved
     C*****CUSC*         IFNE      0                                                          CSD027
     C     CUSC          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      'C'           BROCUS
 
      ** Reverse customer charges and commissions
     C     CCHR          IFNE      'Y'                                                        222165
     C                   EXSR      SRRVCCH
     C                   ENDIF                                                                222165
      *                                                                                       222165
     C     CCOR          IFNE      'Y'                                                        222165
     C                   EXSR      SRRVCCM
     C                   ENDIF                                                                222165
      *                                                                                       222165
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBPTRN - Determine broker charge pattern                     *
      *                                                               *
      *****************************************************************
 
     C     SRBPTRN       BEGSR
 
     C     BCPT          IFEQ      'S'
     C                   EXSR      SRBKCMS
     C                   ENDIF
 
     C     BCPT          IFEQ      'H'
     C                   EXSR      SRBKCMH
     C                   ENDIF
 
     C     BCPT          IFEQ      'E'
     C                   EXSR      SRBKCME
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCPTRN - Determine customer charge pattern                   *
      *                                                               *
      *****************************************************************
 
     C     SRCPTRN       BEGSR
 
     C     CCPT          IFEQ      'S'
     C                   EXSR      SRCUCMS
     C                   ENDIF
 
     C     CCPT          IFEQ      'H'
     C                   EXSR      SRCUCMH
     C                   ENDIF
 
     C     CCPT          IFEQ      'E'
     C                   EXSR      SRCUCME
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPTBCH - Post broker charges                                 *
      *                                                               *
      *****************************************************************
 
     C     SRPTBCH       BEGSR
 
      ** If broker charge amount is non zero, use that amount
 
     C     BCHA          IFNE      0
     C                   Z-ADD     BCHA          EAMT
     C                   ELSE
 
      ** Otherwise if broker charge rate is defined, calculate
      ** broker charge amount
 
     C                   Z-ADD     NUCO          WCONO
     C                   Z-ADD     BCHC          CGCM
     C                   Z-ADD     0             WRATA
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRTTFCL
     C                   ENDIF
     C                   Z-ADD     WRATA         EAMT
     C                   ENDIF
 
      ** Generate broker charge account key and position change
 
     C     EAMT          IFNE      0
     C                   MOVE      'F'           FKEY11
     C                   MOVE      'H'           FKEY13
     C                   MOVE      ' BVB'        FOKEY2
 
     C     TRECI         IFEQ      '*'
     C     BUSD          ANDGT     TVDAT
     C     ECPI          ANDEQ     'Y'
     C                   Z-ADD     1             REVI
     C                   ELSE
     C                   Z-ADD     0             REVI
     C                   ENDIF
 
     C                   EXSR      SRWRITE
     C                   ENDIF
 
     C                   Z-ADD     EAMT          BCHP
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPTCCH - Post customer charges                               *
      *                                                               *
      *****************************************************************
 
     C     SRPTCCH       BEGSR
 
      ** If customer charge amount is non zero, use that amount
 
     C     CCHA          IFNE      0
     C                   Z-ADD     CCHA          EAMT
     C                   ELSE
 
      ** Otherwise if customer charge is defined, calculate the
      ** customer charge amount
 
     C                   Z-ADD     NUCO          WCONO
     C                   Z-ADD     CCHC          CGCM
     C                   Z-ADD     0             WRATA
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRTTFCL
     C                   ENDIF
     C                   Z-ADD     WRATA         EAMT
     C                   ENDIF
 
      ** If customer charges are compounded
 
     C     BXCCC         IFEQ      'Y'
 
      ** If broker charge is non zero, add that amount to customer
      ** charge amount
 
     C     BCHA          IFNE      0
     C                   ADD       BCHA          EAMT
     C                   ELSE
 
      ** Otherwise if broker charge rate is defined, calculate the
      ** broker charge amount and add it to the customer charge amount
 
     C                   Z-ADD     NUCO          WCONO
     C                   Z-ADD     BCHC          CGCM
     C                   Z-ADD     0             WRATA
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRTTFCL
     C                   ENDIF
     C                   ADD       WRATA         EAMT
     C                   ENDIF
     C                   ENDIF
 
      ** Generate customer charge account key and position change
 
     C     EAMT          IFNE      0
     C                   MOVE      'F'           FKEY11
     C                   MOVE      'H'           FKEY13
     C                   MOVE      ' CVC'        FOKEY2
 
     C     TRECI         IFEQ      '*'
     C     BUSD          ANDGT     TVDAT
     C     ECPI          ANDEQ     'Y'
     C                   Z-ADD     1             REVI
     C                   ELSE
     C                   Z-ADD     0             REVI
     C                   ENDIF
 
     C                   EXSR      SRWRITE
     C                   ENDIF
 
     C                   Z-ADD     EAMT          CCHP
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPTBCM - Post broker commissions                             *
      *                                                               *
      *****************************************************************
 
     C     SRPTBCM       BEGSR
 
     C     EAMT          IFNE      0
     C                   MOVE      'F'           FKEY11
     C                   MOVE      'C'           FKEY13
     C                   MOVE      ' BVB'        FOKEY2
 
     C     TRECI         IFEQ      '*'
     C     BUSD          ANDGT     TVDAT
     C     ECPI          ANDEQ     'Y'
     C                   Z-ADD     1             REVI
     C                   ELSE
     C                   Z-ADD     0             REVI
     C                   ENDIF
 
     C                   EXSR      SRWRITE
     C                   ENDIF
 
     C                   Z-ADD     EAMT          BCMP
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPTCCM - Post customer commissions                           *
      *                                                               *
      *****************************************************************
 
     C     SRPTCCM       BEGSR
 
     C     EAMT          IFNE      0
     C                   MOVE      'F'           FKEY11
     C                   MOVE      'C'           FKEY13
     C                   MOVE      ' CVC'        FOKEY2
 
     C     TRECI         IFEQ      '*'
     C     BUSD          ANDGT     TVDAT
     C     ECPI          ANDEQ     'Y'
     C                   Z-ADD     1             REVI
     C                   ELSE
     C                   Z-ADD     0             REVI
     C                   ENDIF
 
     C                   EXSR      SRWRITE
     C                   ENDIF
 
     C                   Z-ADD     EAMT          CCMP
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRVBCH - Reverse broker charges                              *
      *                                                               *
      *****************************************************************
 
     C     SRRVBCH       BEGSR
 
     C     WBCHP         IFNE      0
     C                   Z-ADD     WBCHP         EAMT
     C                   MOVE      'F'           FKEY11
     C                   MOVE      'H'           FKEY13
     C                   MOVE      ' BVB'        FOKEY2
 
     C     TRECI         IFEQ      '*'
     C     BUSD          ANDGT     TVDAT
     C     ECPI          ANDEQ     'Y'
     C                   Z-ADD     1             REVI
     C                   ELSE
     C                   Z-ADD     0             REVI
     C                   ENDIF
 
     C                   EXSR      SRWRITE
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRVCCH - Reverse customer charges                            *
      *                                                               *
      *****************************************************************
 
     C     SRRVCCH       BEGSR
 
     C     WCCHP         IFNE      0
     C                   Z-ADD     WCCHP         EAMT
     C                   MOVE      'F'           FKEY11
     C                   MOVE      'H'           FKEY13
     C                   MOVE      ' CVC'        FOKEY2
 
     C     TRECI         IFEQ      '*'
     C     BUSD          ANDGT     TVDAT
     C     ECPI          ANDEQ     'Y'
     C                   Z-ADD     1             REVI
     C                   ELSE
     C                   Z-ADD     0             REVI
     C                   ENDIF
 
     C                   EXSR      SRWRITE
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRVBCM - Reverse broker commissions                          *
      *                                                               *
      *****************************************************************
 
     C     SRRVBCM       BEGSR
 
     C     WBCMP         IFNE      0
     C                   Z-ADD     WBCMP         EAMT
     C                   MOVE      'F'           FKEY11
     C                   MOVE      'C'           FKEY13
     C                   MOVE      ' BVB'        FOKEY2
 
     C     TRECI         IFEQ      '*'
     C                   Z-ADD     1             REVI
     C                   ELSE
     C                   Z-ADD     0             REVI
     C                   ENDIF
 
     C                   EXSR      SRWRITE
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRVCCM - Reverse customer commissions                        *
      *                                                               *
      *****************************************************************
 
     C     SRRVCCM       BEGSR
 
     C     WCCMP         IFNE      0
     C                   Z-ADD     WCCMP         EAMT
     C                   MOVE      'F'           FKEY11
     C                   MOVE      'C'           FKEY13
     C                   MOVE      ' CVC'        FOKEY2
 
     C     TRECI         IFEQ      '*'
     C     BUSD          ANDGT     TVDAT
     C     ECPI          ANDEQ     'Y'
     C                   Z-ADD     1             REVI
     C                   ELSE
     C                   Z-ADD     0             REVI
     C                   ENDIF
 
     C                   EXSR      SRWRITE
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBKCMA - Post broker commissions type A                      *
      *                                                               *
      *****************************************************************
 
     C     SRBKCMA       BEGSR
 
      ** If broker commission amount is non zero, use that amount
 
     C     BCMA          IFNE      0
     C                   Z-ADD     BCMA          EAMT
 
      ** Post broker commission amount
 
     C                   EXSR      SRPTBCM
 
     C                   ELSE
 
      ** Otherwise if broker commission rate is defined, calculate
      ** the broker commission amount
 
     C                   EXSR      SRBKCMH
     C*
     C                   ENDIF
     C*
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCUCMA - Post customer commission type A                     *
      *                                                               *
      *****************************************************************
 
     C     SRCUCMA       BEGSR
 
      ** If customer commission amount is non zero , use that amount
 
     C     CCMA          IFNE      0
     C                   Z-ADD     CCMA          EAMT
 
      ** IF CUSTOMER CHARGES ARE COMPOUNDED
 
     C     BXCCC         IFEQ      'Y'
 
      ** If broker commission amount is non zero, add that amount
      ** to the customer commission amount
 
     C     BCMA          IFNE      0
     C                   ADD       BCMA          EAMT
     C                   ELSE
 
      ** Otherwise if broker commission rate is defined, calculate
      ** the broker commission amount and add it to the customer
      ** commission amount
 
     C                   Z-ADD     NUCO          WCONO
     C                   Z-ADD     BCMC          CGCM
     C                   Z-ADD     0             WRATA
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRTTFCL
     C                   ENDIF
     C                   ADD       WRATA         EAMT
     C                   ENDIF
 
     C                   ENDIF
 
      ** Post the customer commission amount
 
     C                   EXSR      SRPTCCM
 
     C                   ELSE
 
      ** Otherwise, if customer commission rate is defined calculate
      ** the customer commission amount
 
     C                   EXSR      SRCUCMH
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBKCMS - Post broker commissions type S                      *
      *                                                               *
      *****************************************************************
 
     C     SRBKCMS       BEGSR
 
      ** Check whether broker calculation basis has changed ie
      ** the number of standard and same day contracts for method 'S'
 
     C     NOBO          ADD       OCSB          XCPSB
     C                   Z-ADD     OCDB          XCPDB
     C     XCPSB         IFEQ      CPSB
     C     XCPDB         ANDEQ     CPDB
     C                   ELSE
     C                   Z-ADD     XCPSB         CPSB
     C                   Z-ADD     XCPDB         CPDB
     C                   ENDIF
 
      ** BROKER CONTRACTS OPENING A POSITION  (NOBO,OCSB + OCDB)
 
     C     NOBO          ADD       OCSB          WCONO
 
      ** Broker commission code standard is equal to broker commission
      ** code same day
 
     C     BCMC          IFEQ      BCMS
     C                   ADD       OCDB          WCONO
     C                   Z-ADD     BCMC          CGCM
     C                   Z-ADD     0             WRATA
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRTTFCL
     C                   ENDIF
     C                   Z-ADD     WRATA         EAMT
 
     C                   ELSE
 
      ** Broker commission code standard is different from broker
      ** commission code same day
 
     C                   Z-ADD     BCMC          CGCM
     C                   Z-ADD     0             WRATA
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRTTFCL
     C                   ENDIF
     C                   Z-ADD     WRATA         EAMT
 
     C                   Z-ADD     OCDB          WCONO
     C                   Z-ADD     BCMS          CGCM
     C                   Z-ADD     0             WRATA
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRTTFCL
     C                   ENDIF
     C                   ADD       WRATA         EAMT
     C                   ENDIF
 
     C                   EXSR      SRPTBCM
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCUCMS - Psot customer commissions type S                   *
      *                                                               *
      *****************************************************************
      *
     C     SRCUCMS       BEGSR
 
      ** Check whether customer calculation basis has changed ie
      ** the number of standard and same day contracts for method 'S'
 
     C     NOCO          ADD       OCSC          XCPSC
     C                   Z-ADD     OCDC          XCPDC
     C     XCPSC         IFEQ      CPSC
     C     XCPDC         ANDEQ     CPDC
     C                   ELSE
     C                   Z-ADD     XCPSC         CPSC
     C                   Z-ADD     XCPDC         CPDC
     C                   END
 
      ** Customer contracts opening a position  (NOCO,OCSC + OCDC)
 
     C     NOCO          ADD       OCSC          WCONO
 
      ** Customer commission code standard is equal to customer
      ** commission code same day
 
     C     CCMC          IFEQ      CCMS
     C                   ADD       OCDC          WCONO
     C                   Z-ADD     CCMC          CGCM
     C                   Z-ADD     0             WRATA
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRTTFCL
     C                   ENDIF
     C                   Z-ADD     WRATA         EAMT
 
     C                   ELSE
 
      ** Customer commission code standard is different from customer
      ** commission code same day
 
     C                   Z-ADD     CCMC          CGCM
     C                   Z-ADD     0             WRATA
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRTTFCL
     C                   ENDIF
     C                   Z-ADD     WRATA         EAMT
 
     C                   Z-ADD     OCDC          WCONO
     C                   Z-ADD     CCMS          CGCM
     C                   Z-ADD     0             WRATA
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRTTFCL
     C                   ENDIF
     C                   ADD       WRATA         EAMT
     C                   ENDIF
 
      ** Add broker commission to customer commission if customer
      ** charges are compounded
 
     C     BXCCC         IFEQ      'Y'
 
      ** If broker commission amount is non zero, use that amount
 
     C     BCMA          IFNE      0
     C                   ADD       BCMA          EAMT
     C                   ELSE
 
      ** Otherwise, if broker commission rates are defined calculate
      ** the broker commission amount
 
     C     NOCO          ADD       OCSC          WCONO
 
      ** Broker commission code standard is equal to broker commission
      ** code same day
 
     C     BCMC          IFEQ      BCMS
     C                   ADD       OCDC          WCONO
     C                   Z-ADD     BCMC          CGCM
     C                   Z-ADD     0             WRATA
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRTTFCL
     C                   ENDIF
     C                   ADD       WRATA         EAMT
 
     C                   ELSE
 
      ** Broker commission code standard is different from broker
      ** commission code same day
 
     C                   Z-ADD     BCMC          CGCM
     C                   Z-ADD     0             WRATA
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRTTFCL
     C                   ENDIF
     C                   ADD       WRATA         EAMT
 
     C                   Z-ADD     OCDC          WCONO
     C                   Z-ADD     BCMS          CGCM
     C                   Z-ADD     0             WRATA
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRTTFCL
     C                   ENDIF
     C                   ADD       WRATA         EAMT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   EXSR      SRPTCCM
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBKCMH - Post broker commissions type H                      *
      *                                                               *
      *****************************************************************
 
     C     SRBKCMH       BEGSR
 
      ** Check whether broker calculation basis has changed ie
      ** the number of standard and same day contracts for method 'H'
 
     C     NOBO          ADD       OCSB          XCPSB
     C                   ADD       CCSB          XCPSB
     C     OCDB          ADD       CCDB          XCPDB
     C     XCPSB         IFEQ      CPSB
     C     XCPDB         ANDEQ     CPDB
     C                   ELSE
     C                   Z-ADD     XCPSB         CPSB
     C                   Z-ADD     XCPDB         CPDB
     C                   ENDIF
 
     C     NOBO          ADD       OCSB          WCONO
     C                   ADD       CCSB          WCONO
 
      ** Broker commission code standard is equal to broker commission
      ** code same day
 
     C     BCMC          IFEQ      BCMS
     C                   ADD       OCDB          WCONO
     C                   ADD       CCDB          WCONO
     C                   Z-ADD     BCMC          CGCM
     C                   Z-ADD     0             WRATA
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRTTFCL
     C                   ENDIF
     C                   Z-ADD     WRATA         EAMT
 
     C                   ELSE
 
      ** Broker commission code standard is different from broker
      ** commission code same day
 
     C                   Z-ADD     BCMC          CGCM
     C                   Z-ADD     0             WRATA
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRTTFCL
     C                   ENDIF
     C                   Z-ADD     WRATA         EAMT
 
     C     OCDB          ADD       CCDB          WCONO
     C                   Z-ADD     BCMS          CGCM
     C                   Z-ADD     0             WRATA
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRTTFCL
     C                   ENDIF
     C                   ADD       WRATA         EAMT
     C                   ENDIF
 
     C                   EXSR      SRPTBCM
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCUCMH - Post customer commissions type H                    *
      *                                                               *
      *****************************************************************
 
     C     SRCUCMH       BEGSR
 
      ** Check whether customer calculation basis has changed ie
      ** the number of standard and same day contracts for method 'H'
 
     C     NOCO          ADD       OCSC          XCPSC
     C                   ADD       CCSC          XCPSC
     C     OCDC          ADD       CCDC          XCPDC
     C     XCPSC         IFEQ      CPSC
     C     XCPDC         ANDEQ     CPDC
     C                   ELSE
     C                   Z-ADD     XCPSC         CPSC
     C                   Z-ADD     XCPDC         CPDC
     C                   ENDIF
 
     C     NOCO          ADD       OCSC          WCONO
     C                   ADD       CCSC          WCONO
 
      ** Customer commission code standard is equal to customer
      ** commission code same day
 
     C     CCMC          IFEQ      CCMS
     C                   ADD       OCDC          WCONO
     C                   ADD       CCDC          WCONO
     C                   Z-ADD     CCMC          CGCM
     C                   Z-ADD     0             WRATA
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRTTFCL
     C                   ENDIF
     C                   Z-ADD     WRATA         EAMT
 
      ** Customer commission code standard is different from customer
      ** commission code same day
 
     C                   ELSE
     C                   Z-ADD     CCMC          CGCM
     C                   Z-ADD     0             WRATA
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRTTFCL
     C                   ENDIF
     C                   Z-ADD     WRATA         EAMT
 
     C     OCDC          ADD       CCDC          WCONO
     C                   Z-ADD     CCMS          CGCM
     C                   Z-ADD     0             WRATA
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRTTFCL
     C                   ENDIF
     C                   ADD       WRATA         EAMT
     C                   ENDIF
 
      ** Add broker commission to customer commission if customer charges
      ** are compounded
 
     C     BXCCC         IFEQ      'Y'
 
      ** If broker commission amount is non zero, use that amount
 
     C     BCMA          IFNE      0
     C                   ADD       BCMA          EAMT
     C                   ELSE
 
      ** Otherwise, if broker commission rates are defined calculate
      ** the broker commission amount
 
     C     NOCO          ADD       OCSC          WCONO
     C                   ADD       CCSC          WCONO
 
      ** Broker commission code standard is equal to broker commission
      ** code same day
 
     C     BCMC          IFEQ      BCMS
     C                   ADD       OCDC          WCONO
     C                   ADD       CCDC          WCONO
     C                   Z-ADD     BCMC          CGCM
     C                   Z-ADD     0             WRATA
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRTTFCL
     C                   ENDIF
     C                   ADD       WRATA         EAMT
     C                   ELSE
 
      ** Broker commission code standard is different from broker
      ** commission code same day
 
     C                   Z-ADD     BCMC          CGCM
     C                   Z-ADD     0             WRATA
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRTTFCL
     C                   ENDIF
     C                   ADD       WRATA         EAMT
 
     C     OCDC          ADD       CCDC          WCONO
     C                   Z-ADD     BCMS          CGCM
     C                   Z-ADD     0             WRATA
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRTTFCL
     C                   ENDIF
     C                   ADD       WRATA         EAMT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   EXSR      SRPTCCM
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBKCME - Post broker commissions type E                      *
      *                                                               *
      *****************************************************************
 
     C     SRBKCME       BEGSR
 
      ** Check whether broker calculation basis has changed ie
      ** the number of standard and same day contracts for method 'E'
 
     C                   Z-ADD     CCSB          XCPSB
     C                   Z-ADD     CCDB          XCPDB
     C     XCPSB         IFEQ      CPSB
     C     XCPDB         ANDEQ     CPDB
     C                   ELSE
     C                   Z-ADD     XCPSB         CPSB
     C                   Z-ADD     XCPDB         CPDB
     C                   ENDIF
 
      ** Broker contracts closing a position  (CCSB + CCDB)
 
     C                   Z-ADD     CCSB          WCONO
 
      ** Broker commission code standard is equal to broker commission
      ** code same day
 
     C     BCMC          IFEQ      BCMS
     C                   ADD       CCDB          WCONO
     C                   Z-ADD     BCMC          CGCM
     C                   Z-ADD     0             WRATA
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRTTFCL
     C                   ENDIF
     C                   Z-ADD     WRATA         EAMT
 
     C                   ELSE
 
      ** Broker commission code standard is different from broker
      ** commission code same day
 
     C                   Z-ADD     BCMC          CGCM
     C                   Z-ADD     0             WRATA
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRTTFCL
     C                   ENDIF
     C                   Z-ADD     WRATA         EAMT
 
     C                   Z-ADD     CCDB          WCONO
     C                   Z-ADD     BCMS          CGCM
     C                   Z-ADD     0             WRATA
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRTTFCL
     C                   ENDIF
     C                   ADD       WRATA         EAMT
     C                   ENDIF
 
     C                   EXSR      SRPTBCM
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCUCME - Post customer commissions type E                   *
      *                                                               *
      *****************************************************************
 
     C     SRCUCME       BEGSR
 
      ** Check whether customer calculation basis has changed ie
      ** the number of standard and same day contracts for method 'E'
 
     C                   Z-ADD     CCSC          XCPSC
     C                   Z-ADD     CCDC          XCPDC
     C     XCPSC         IFEQ      CPSC
     C     XCPDC         ANDEQ     CPDC
     C                   ELSE
     C                   Z-ADD     XCPSC         CPSC
     C                   Z-ADD     XCPDC         CPDC
     C                   ENDIF
 
      ** Customer contracts closing a position  (CCSC + CCDC)
 
     C                   Z-ADD     CCSC          WCONO
 
      ** Customer commission code standard is equal to customer
      ** commission code same day
 
     C     CCMC          IFEQ      CCMS
     C                   ADD       CCDC          WCONO
     C                   Z-ADD     CCMC          CGCM
     C                   Z-ADD     0             WRATA
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRTTFCL
     C                   ENDIF
     C                   Z-ADD     WRATA         EAMT
 
     C                   ELSE
 
      ** Customer commission code standard is different from customer
      ** commission code same day
 
     C                   Z-ADD     CCMC          CGCM
     C                   Z-ADD     0             WRATA
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRTTFCL
     C                   ENDIF
     C                   Z-ADD     WRATA         EAMT
 
     C                   Z-ADD     CCDC          WCONO
     C                   Z-ADD     CCMS          CGCM
     C                   Z-ADD     0             WRATA
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRTTFCL
     C                   ENDIF
     C                   ADD       WRATA         EAMT
     C                   ENDIF
 
      ** Add broker commission to customer commission if customer
      ** charges are compounded
 
     C     BXCCC         IFEQ      'Y'
 
      ** If the broker commission amount is non zero, use that amount
 
     C     BCMA          IFNE      0
     C                   ADD       BCMA          EAMT
     C                   ELSE
 
      ** Otherwise, if broker commission rates are defined calculate
      ** the broker commission amount
 
     C                   Z-ADD     CCSC          WCONO
 
      ** Broker commission code standard is equal to broker commission
      ** code same day
 
     C     BCMC          IFEQ      BCMS
     C                   ADD       CCDC          WCONO
     C                   Z-ADD     BCMC          CGCM
     C                   Z-ADD     0             WRATA
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRTTFCL
     C                   ENDIF
     C                   ADD       WRATA         EAMT
 
     C                   ELSE
 
      ** Broker commission code standard is different from broker
      ** commission code same day
 
     C                   Z-ADD     BCMC          CGCM
     C                   Z-ADD     0             WRATA
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRTTFCL
     C                   ENDIF
     C                   ADD       WRATA         EAMT
 
     C                   Z-ADD     CCDC          WCONO
     C                   Z-ADD     BCMS          CGCM
     C                   Z-ADD     0             WRATA
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRTTFCL
     C                   ENDIF
     C                   ADD       WRATA         EAMT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   EXSR      SRPTCCM
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTTFCL - Calculate tier, threshold or flat rate              *
      *                                                               *
      *****************************************************************
 
     C     SRTTFCL       BEGSR
 
      ** Access CHGCM for chrages and commissions detail
 
     C     CHGCMK        CHAIN     CHGCM                              02
 
      ** Database error
     C     *IN02         IFEQ      '1'
     C     RECI          ORNE      'D'
     C     *LOCK         IN        LDA
     C                   MOVEL     ISCY          CHGCMT            5
     C                   MOVE      CGCM          CHGCMT
     C                   EVAL      DBASE = 12
     C                   EVAL      DBFILE = 'CHGCM'
     C                   EVAL      DBKEY = CHGCMT
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Locate the highest valued charged range lower limit on CHGCM
      ** whose value is less than or equal to the contract number
 
     C                   Z-ADD     9             Y                 1 0
     C                   MOVE      'N'           FOUND             1
 
     C     FOUND         DOWEQ     'N'
     C     Y             ANDGT     1
 
     C     RNG(Y)        IFNE      0
     C     RNG(Y)        ANDLE     WCONO
     C                   MOVE      'Y'           FOUND
     C                   ELSE
     C                   SUB       1             Y
     C                   ENDIF
 
     C                   ENDDO
 
      ** If charges are tiered
     C     TTFI          IFEQ      'T'
     C     WCONO         SUB       RNG(Y)        TCONO
     C                   ADD       1             TCONO
     C     TCONO         MULT      AMT(Y)        WRATA
 
     C     Y             DOWGE     2
     C     Y             SUB       1             Z                 1 0
     C     RNG(Y)        SUB       RNG(Z)        TCONO
     C     TCONO         MULT      AMT(Z)        TRATA
     C                   ADD       TRATA         WRATA
     C                   SUB       1             Y
     C                   ENDDO
     C                   ENDIF
 
      ** If charges are threshold
     C     TTFI          IFEQ      'X'
     C     WCONO         MULT      AMT(Y)        WRATA
     C                   ENDIF
 
      ** If charges are flat
     C     TTFI          IFEQ      'F'
     C                   Z-ADD     AMT(Y)        WRATA
     C                   ENDIF
 
      ** If rate amount < min charge commission
     C     WRATA         IFLT      MINC
     C     MINC          ANDNE     0
     C                   Z-ADD     MINC          WRATA
     C                   ENDIF
 
      ** If rate amount > max charge commission
     C     WRATA         IFGT      MAXC
     C     MAXC          ANDNE     0
     C                   Z-ADD     MAXC          WRATA
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWRITE - Post customer/broker/book details                   *
      *                                                               *
      *****************************************************************
 
     C     SRWRITE       BEGSR
 
      ** Accumulate totals for audit file FOKEYA
 
     C                   ADD       1             COUNT
     C     EAMT          DIV       1000          ZZAMT
     C                   CALLB     'ZZADD'
     C                   PARM                    ZZAMT
     C                   PARM                    ZZTOTI
     C                   PARM                    ZZTOTD
 
     C     BROCUS        IFEQ      'B'
     C                   MOVE      BOCO          CBCD
     C                   ELSE
     C                   MOVE      CUSC          CBCD
     C                   ENDIF
 
      ** Generate FO account keys
      ** If OTC, blank out market center and instrument type in FFKY
 
     C     BXISTY        IFEQ      'Y'
     C     ISTI          IFEQ      'Y'
     C                   MOVE      *BLANKS       TISTT
     C                   ELSE
     C                   MOVE      ISTT          TISTT
     C                   MOVEL     MRKT          TISTT
     C                   ENDIF
     C                   ELSE
     C                   MOVE      '     '       TISTT
     C                   ENDIF
 
      ** The processing type is only valid if indicator is 'Y'
 
     C     BXPROT        IFEQ      'Y'
     C                   MOVE      ISPT          INVA
     C                   ELSE
     C                   MOVE      *BLANKS       INVA
     C                   ENDIF
 
     C                   MOVE      BJRDNB        EDAT
     C                   MOVE      ISCY          CCY
     C                   MOVE      TVDAT         VDAT
 
     C     BROCUS        IFEQ      'B'
     C                   MOVE      BSLT          SETP
     C                   MOVE      BSLA          SETA
     C                   MOVE      BSBR          SEBR
     C                   ELSE
     C                   MOVE      CSLT          SETP
     C                   MOVE      CSLA          SETA
     C                   MOVE      BRSC          SEBR
     C                   ENDIF
     C
     C                   MOVEL     TPTFR         PTFR
 
     C                   IF        CGL020 = 'Y'                                               CGL020
                                                                                              CGL020
      **  Initialise F1FLG, F1FVAL, and F1FPCT to 'F', EAMT, and 100                          CGL020
      **  respectively.                                                                       CGL020
                                                                                              CGL020
     C                   EVAL      F1FFLG  = 'F'                                              CGL020
     C                   EVAL      F1FVAL  = EAMT                                             CGL020
     C                   EVAL      F1FPCT  = 100                                              CGL020
                                                                                              CGL020
     C                   IF        BROCUS = 'B'                                               CGL020
     C                   EVAL      SEFA = BFAO                                                CGL020
     C                   EVAL      SECP = BCPN                                                CGL020
     C                   ELSE                                                                 CGL020
     C                   EVAL      SEFA = CFAO                                                CGL020
     C                   EVAL      SECP = CCPN                                                CGL020
     C                   ENDIF                                                                CGL020
                                                                                              CGL020
      **  Access ZAAMLSETFF to extract settlement fields used in                              CGL020
      **  ACcount History export in AML.                                                      CGL020
                                                                                              CGL020
     C                   CALL      'ZAAMLSETFF'                                               CGL020
     C                   PARM      CBCD          PCBCD                                        CGL020
     C                   PARM                    SETA                                         CGL020
     C                   PARM                    SEBR                                         CGL020
     C                   PARM                    SEFA                                         CGL020
     C                   PARM                    SECP                                         CGL020
     C                   PARM                    CCY                                          CGL020
     C                   PARM      *BLANKS       F1RACT                                       CGL020
     C                   PARM      *BLANKS       F1RCTY                                       CGL020
     C                   PARM      *BLANKS       F1RBNK                                       CGL020
     C                   PARM      *BLANKS       F1RCDE                                       CGL020
     C                   PARM      *BLANKS       F1PACT                                       CGL020
     C                   PARM      *BLANKS       F1PCTY                                       CGL020
     C                   PARM      *BLANKS       F1PBNK                                       CGL020
     C                   PARM      *BLANKS       F1PCDE                                       CGL020
     C                   PARM      *BLANKS       F1DACT                                       CGL020
     C                   PARM      *BLANKS       F1DCTY                                       CGL020
     C                   PARM      *BLANKS       F1DBNK                                       CGL020
                                                                                              CGL020
     C                   EVAL      F1SDAT = FCDA                                              CGL020
                                                                                              CGL020
     C                   ENDIF                                                                CGL020
                                                                                              CGL020
     C                   WRITE     FOKEYDF
 
      ** Set F1FLG, F1FVAL, and F1FPCT to blanks/zeros.                                       CGL020
     C                   IF        CGL020 = 'Y'                                               CGL020
     C                   EVAL      F1FFLG  = *BLANK                                           CGL020
     C                   EVAL      F1FVAL  = *ZEROS                                           CGL020
     C                   EVAL      F1FPCT  = *ZEROS                                           CGL020
     C                   ENDIF                                                                CGL020
                                                                                              CGL020
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUMMPR - Determine if MEMOSM and PRONOM updating is required *
      *                                                               *
      *****************************************************************
 
     C     SRUMMPR       BEGSR
 
      ** Prepare parameter to be input to standard subroutine FFSETL
 
     C                   MOVE      BRCA          FFBRCA
 
     C                   MOVE      ISCY          FFCCY
 
      ** Determine if MEMOSM and/or PRONOM need updating when customer
      ** exists
 
     C*****CUSC*         IFNE      0                                                          CSD027
     C     CUSC          IFNE      *BLANKS                                                    CSD027
 
     C                   MOVE      'C'           BROCUS
 
     C**********         Z-ADD     CUSC          FFCBCD                                       CSD027
     C                   EVAL      FFCBCD = CUSC                                              CSD027
     C                   MOVE      'N'           FFBRKI
     C                   MOVE      CSLT          FFSETP
     C                   MOVE      CSLA          FFSETA
     C                   MOVE      BRSC          FFSETB
 
     C                   EXSR      SRFSETL
 
      **  LF/MEMOSM needs updating
 
     C     FFMIND        IFEQ      'Y'
     C                   EXSR      SRUMEMO
 
      ** Set MEMOS/PRONO Update Indicator to 'M'
 
     C                   MOVE      'M'           MPIND             1
 
      ** Write record to PF/FFACMVD
 
     C                   EXSR      SRACMVD
 
     C                   ENDIF
 
      ** LF/PRONOM needs updating
 
     C     FFPIND        IFEQ      'Y'
     C                   EXSR      SRUPRON
 
     C     FFMIND        IFNE      'Y'
 
      ** Set MEMOS/PRONO Update Indicator to 'P'
 
     C                   MOVE      'P'           MPIND
 
      ** Write record to PF/FFACMVD
 
     C                   EXSR      SRACMVD
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Determine if MEMOSM and/or PRONOM need updating when broker exists
 
     C*****BOCO*         IFNE      0                                                          CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
 
     C                   MOVE      'B'           BROCUS
 
     C**********         Z-ADD     BOCO          FFCBCD                                       CSD027
     C                   EVAL      FFCBCD = BOCO                                              CSD027
     C                   MOVE      'Y'           FFBRKI
     C                   MOVE      BSLT          FFSETP
     C                   MOVE      BSLA          FFSETA
     C                   MOVE      BSBR          FFSETB
 
     C                   EXSR      SRFSETL
 
      ** LF/MEMOSM needs updating
 
     C     FFMIND        IFEQ      'Y'
     C                   EXSR      SRUMEMO
 
      ** Set MEMOS/PRONO Update Indicator to 'M'
 
     C                   MOVE      'M'           MPIND
 
      ** Write record to PF/FFACMVD
 
     C                   EXSR      SRACMVD
 
     C                   ENDIF
 
      ** LF/PRONOM needs updating
 
     C     FFPIND        IFEQ      'Y'
     C                   EXSR      SRUPRON
 
     C     FFMIND        IFNE      'Y'
 
      ** Set MEMOS/PRONO Update Indicator to 'P'
 
     C                   MOVE      'P'           MPIND
 
      ** Write record to PF/FFACMVD
 
     C                   EXSR      SRACMVD
     C                   ENDIF
 
     C                   ENDIF
 
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUMEMO - Update MEMOSM for broker or customer               *
      *                                                               *
      *****************************************************************
 
     C     SRUMEMO       BEGSR
 
      ** Access record off LF/MEMOSM
 
     C     MEMKEY        CHAIN     MEMOSMEF                           10
 
     C     *IN10         IFEQ      '1'
     C                   Z-ADD     0             LDBL
     C                   Z-ADD     0             CLBL
     C                   ENDIF
 
      ** Store ledger balance for use in SRACMVD
 
     C                   Z-ADD     LDBL          WLDBL            15 0
 
      ** If it is a MEMOSM update for customer
 
     C     BROCUS        IFEQ      'C'
 
     C     CCHP          ADD       CCMP          CCHCM
     C     WCCHP         ADD       WCCMP         PCCHCM
 
      ** Add the sum of new customer charges and commissions to the ledger
      ** balance and cleared balance if it is an active transaction
 
     C     TRECI         IFNE      '*'
     C                   ADD       CCHCM         LDBL
     C                   ADD       CCHCM         CLBL
     C                   ENDIF
 
      ** Reverse out the old figures by subtracting the sum of the old
      ** customer charges and commissions posted from the ledger balance
      ** and cleared balance
 
     C                   SUB       PCCHCM        LDBL
     C                   SUB       PCCHCM        CLBL
 
     C                   ELSE
 
      ** If it is a MEMOSM update for broker
 
     C     BCHP          ADD       BCMP          BCHCM
     C     WBCHP         ADD       WBCMP         PBCHCM
 
      ** Subtract the sum of new broker charges and commissions from the
      ** ledger balance and cleared balance if it is an active transaction
 
     C     TRECI         IFNE      '*'
     C                   SUB       BCHCM         LDBL
     C                   SUB       BCHCM         CLBL
     C                   ENDIF
 
      ** Reverse out the old figures by adding the sum of the old broker
      ** charges and commissions posted to the ledger balance and cleared
      ** balance
 
     C                   ADD       PBCHCM        LDBL
     C                   ADD       PBCHCM        CLBL
 
     C                   ENDIF
 
     C                   MOVE      'D'           RECI
     C                   MOVE      FFCNUM        CNUM
     C                   MOVE      FFCCY         CCY
     C                   MOVE      FFACOD        ACOD
     C                   MOVE      FFACSQ        ACSQ
 
      ** If record already existed update it
 
     C     *IN10         IFEQ      '0'
     C                   UPDATE    MEMOSMEF
 
     C                   ELSE
 
      ** Write out new record
 
     C                   WRITE     MEMOSMEF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUPRON - Update PRONOM for broker or customer                *
      *                                                               *
      *****************************************************************
 
     C     SRUPRON       BEGSR
 
      ** Access record off LF/PRONOM
 
     C     PROKEY        CHAIN     PRONOMEF                           11
     C*
     C     *IN11         IFEQ      '1'
     C                   Z-ADD     0             PNBL
     C                   ENDIF
 
     C** Store projected nostro balance for use in SRACMVD
 
     C                   Z-ADD     PNBL          WPNBL            15 0
 
      ** If it is a PRONOM update for customer
 
     C     BROCUS        IFEQ      'C'
 
     C     CCHP          ADD       CCMP          CCHCM
     C     WCCHP         ADD       WCCMP         PCCHCM
 
      ** Add the sum of new customer charges and commissions to the
      ** projected nostro balance if it is an active transaction
 
     C     TRECI         IFNE      '*'
     C                   ADD       CCHCM         PNBL
     C                   ENDIF
 
      ** Reverse out the old figures by subtracting the sum of the old
      ** customer charges and commissions posted from the projected nostro
      ** balance
 
     C                   SUB       PCCHCM        PNBL
 
     C                   ELSE
 
      ** If it is a PRONOM update for broker
 
     C     BCHP          ADD       BCMP          BCHCM
     C     WBCHP         ADD       WBCMP         PBCHCM
 
      ** Subtract the sum of new broker charges and commissions from
      ** the projected nostro balance if it is an active transaction
 
     C     TRECI         IFNE      '*'
     C                   SUB       BCHCM         PNBL
     C                   ENDIF
 
      ** Reverse out the old figures by adding the sum of the old broker
      ** charges and commissions posted to the projected nostro balance
 
     C                   ADD       PBCHCM        PNBL
 
     C                   ENDIF
 
     C                   MOVE      'D'           RECI
     C                   MOVE      FFCCY         CCY
     C                   MOVE      FFNOSN        NOSN
 
      **  If record already existed update it
 
     C     *IN11         IFEQ      '0'
     C                   UPDATE    PRONOMEF
 
     C                   ELSE
 
      **  Write out new record
 
     C                   WRITE     PRONOMEF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRACMVD - Write record to FFACMVD                             *
      *                                                               *
      *****************************************************************
 
     C     SRACMVD       BEGSR
 
      ** Set up fields for output to PF/FFACMVD
 
      ** Branch Code
     C                   MOVE      *BLANK        BRCA
 
      ** Customer Number
     C**********         Z-ADD     FFCNUM        CUSN                                         CSD027
     C                   EVAL      CUSN = FFCNUM                                              CSD027
 
      ** Currency Code
     C                   MOVE      FFCCY         CCYD
 
      ** Account Code
     C                   Z-ADD     FFACOD        ACDE
 
      ** Account Sequence
     C                   Z-ADD     FFACSQ        ASNC
 
      **  Posting Date
     C                   Z-ADD     BJRDNB        PTDT
 
      ** Value Date
     C                   Z-ADD     BJRDNB        VUDT
 
      ** Transaction Type
     C                   MOVE      TRTY          TRYP
 
      ** Narrative Code
     C                   Z-ADD     0             NRTC
 
      ** Narrative Description
     C                   MOVEL     ISTN          NRTD
 
      ** Transaction Number
     C                   MOVE      TNBR          TNMR
 
      ** Cheque Number
     C                   Z-ADD     *ZERO         CQNR
 
      ** Movement Amount = change in Ledger Balance/Projected
      **                    Nostro Balance
     C     MPIND         IFEQ      'M'
     C     LDBL          SUB       WLDBL         WMVAM            13 0
     C                   Z-ADD     WMVAM         MVAM
     C                   ENDIF
 
     C     MPIND         IFEQ      'P'
     C     PNBL          SUB       WPNBL         WMVAM
     C                   Z-ADD     WMVAM         MVAM
     C                   ENDIF
 
     C     MVAM          IFNE      *ZERO
 
      ** Debit or Credit
     C     MPIND         IFEQ      'M'
     C     LDBL          IFGE      WLDBL
     C                   Z-ADD     0             DORC
     C                   ELSE
     C                   Z-SUB     MVAM          MVAM
     C                   Z-ADD     1             DORC
     C                   ENDIF
     C                   ENDIF
 
     C     MPIND         IFEQ      'P'
     C     PNBL          IFGE      WPNBL
     C                   Z-ADD     0             DORC
     C                   ELSE
     C                   Z-SUB     MVAM          MVAM
     C                   Z-ADD     1             DORC
     C                   ENDIF
     C                   ENDIF
 
      ** Write record to PF/FFACMVD
     C                   WRITE     FFACMVDF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFFFMT - Setup FF report header                              *
      *                                                               *
      *****************************************************************
 
     C     SRFFFMT       BEGSR
 
     C                   MOVEA     *BLANKS       FFT
     C                   MOVEA     FFNAM         FFT
 
     C                   Z-ADD     20            FF
     C     FFT(FF)       DOWEQ     *BLANKS
     C                   SUB       1             FF
     C                   ENDDO
 
     C     FF            ADD       14            FFULIN
     C                   ADD       2             FF
     C                   MOVEA     'as at'       FFT(FF)
 
     C                   MOVEL     FFDAT         FF1
     C     FF1           IFEQ      *BLANKS
     C                   ADD       5             FF
     C                   ELSE
     C                   ADD       6             FF
     C                   ENDIF
 
     C                   MOVEA     FFDAT         FFT(FF)
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFSETL - Determine from input settlement details whether     *
      *           MEMOS or PRONO processing is required. Also, the    *
      *           associated settlement account ID is contructed.     *
      *                                                               *
      *****************************************************************
 
     C     SRFSETL       BEGSR
 
     C                   MOVE      *BLANKS       FFBRCB
     C**********         MOVE      *ZERO         FFCNUM                                       CSD027
     C                   EVAL      FFCNUM = *BLANKS                                           CSD027
     C                   MOVE      *ZERO         FFACOD
     C                   MOVE      *ZERO         FFACSQ
     C                   MOVE      *ZERO         FFNOSN
     C                   MOVE      'N'           FFMIND
     C                   MOVE      'N'           FFPIND
 
     C     *INU6         IFEQ      '1'
 
     C     FFSETP        IFEQ      01
     C     FFSETP        OREQ      02
     C     FFSETP        OREQ      07
     C     FFSETP        OREQ      08
     C     FFSETP        OREQ      12
 
     C                   MOVE      'Y'           FFPIND
 
     C     FFSETA        IFNE      *BLANKS
     C                   MOVEL     FFSETA        FFNOSN
     C                   MOVEL     FFNOSN        PNONB
 
      ** Access Nostro file
     C                   CALLB     'AONOSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCUST
     C                   PARM      FFCCY         PCCY
     C                   PARM                    PACCD
     C                   PARM                    PACSN
     C                   PARM                    PNONB
     C                   PARM                    PBRCA
     C                   PARM                    PCSSN
     C                   PARM                    PPNOI
     C     SDNOST        PARM      SDNOST        DSSDY
 
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     FFCCY         WKEY
     C                   MOVE      FFNOSN        WKEY
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 9
     C                   EVAL      DBFILE = 'SDNOSTPD'
     C                   EVAL      DBKEY = WKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
 
     C                   MOVEL     A7BRCD        FFBRCB
     C                   MOVEL     A7CUST        FFCNUM
     C                   MOVEL     A7ACCD        FFACOD
     C                   Z-ADD     A7ACSN        FFACSQ
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     FFSETA        IFNE      *BLANKS
 
      ** Settlement type is 03
     C     FFSETP        IFEQ      03
     C                   MOVE      FFBRCA        FFBRCB
     C                   MOVE      A8BICN        FFCNUM
     C                   Z-ADD     CSAC          FFACOD
     C                   Z-ADD     1             FFACSQ
     C                   ENDIF
 
      ** Settlement type is 04
     C     FFSETP        IFEQ      04
     C                   MOVE      FFBRCA        FFBRCB
     C**********         Z-ADD     FFCBCD        FFCNUM                                       CSD027
     C                   EVAL      FFCNUM = FFCBCD                                            CSD027
     C                   Z-ADD     CADC          FFACOD
     C                   Z-ADD     1             FFACSQ
     C                   ENDIF
 
      ** Settlement type is 05
     C     FFSETP        IFEQ      05
     C                   MOVE      FFSETB        FFBRCB
     C**********         Z-ADD     FFSCNM        FFCNUM                                       CSD027
     C                   EVAL      FFCNUM = FFSCNM                                            CSD027
     C                   Z-ADD     FFSACD        FFACOD
     C                   Z-ADD     FFSASQ        FFACSQ
     C                   ENDIF
 
      ** Settlement type is 06
     C     FFSETP        IFEQ      06
     C                   MOVE      FFBRCA        FFBRCB
     C                   MOVE      A8BICN        FFCNUM
     C                   Z-ADD     COMS          FFACOD
     C                   Z-ADD     1             FFACSQ
     C                   ENDIF
 
      ** Settlement type is 14
     C     FFSETP        IFEQ      14
 
     C     FFACMK        CHAIN     ACNUM                              02
 
      ** Database error
     C     *IN02         IFEQ      '1'
     C     RECI          ORNE      'D'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 10
     C                   EVAL      DBFILE = 'ACNUM'
     C                   MOVEL     FFACMK        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVE      BRCA          FFBRCB
     C**********         Z-ADD     CNUM          FFCNUM                                       CSD027
     C                   EVAL      FFCNUM = CNUM                                              CSD027
     C                   Z-ADD     ACOD          FFACOD
     C                   Z-ADD     ACSQ          FFACSQ
     C                   ENDIF
 
      ** Settlement type is 15
     C     FFSETP        IFEQ      15
     C                   MOVE      FFBRCA        FFBRCB
     C**********         Z-ADD     FFCBCD        FFCNUM                                       CSD027
     C                   EVAL      FFCNUM = FFCBCD                                            CSD027
 
     C     FFBRKI        IFEQ      'Y'
     C                   MOVEL     BXACCD        FFACOD
     C                   ELSE
     C                   MOVEL     BXDCAC        FFACOD
     C                   ENDIF
     C                   Z-ADD     1             FFACSQ
     C                   ENDIF
 
     C     *INU2         IFNE      '1'
 
     C                   MOVEL     FFACOD        PACOD
      ** Access account code details
     C                   CALLB     'AOACODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PACOD
     C     SDACOD        PARM      SDACOD        DSSDY
 
      ** Database error
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 11
     C                   EVAL      DBFILE = 'SDACODPD'
     C                   MOVEL     FFACOD        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     A5ACTY        IFEQ      'R'
     C     FFACTK        CHAIN     ACCNT                              02
 
     C     *IN02         IFEQ      '0'
     C     RECI          ANDNE     '*'
     C     ACST          ANDNE     'C'
     C                   MOVE      'Y'           FFMIND
     C                   ELSE
     C                   MOVE      'E'           FFMIND
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial Processing                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PMRKT
 
      ** Reset LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBFile
     C                   MOVE      *BLANKS       DBKey
     C                   Z-ADD     *ZEROS        DBASE
     C                   MOVEL     PSProcMod     DBPgm
     C                   OUT       LDA
 
      ** Access Bank details via access program
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 1
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access SAR Details to see if Midas Compliance Watch-Additional                       CGL020
      ** A/C Posting Information(CGL020) is installed.                                        CGL020
                                                                                              CGL020
     C                   CALL      'AOSARDR0'                                                 CGL020
     C                   PARM      *BLANKS       PRTCD                                        CGL020
     C                   PARM      '*VERIFY '    POPTN                                        CGL020
     C                   PARM      'CGL020'      PSARD                                        CGL020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL020
                                                                                              CGL020
      ** Database error                                                                       CGL020
     C                   IF        PRTCD <> *BLANKS                                           CGL020
     C                             AND PRTCD <> '*NRF'                                        CGL020
     C     *LOCK         IN        LDA                                                        CGL020
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL020
     C                   EVAL      DBASE = 13                                                 CGL020
     C                   EVAL      DBKEY = 'CGL020'                                           CGL020
     C                   OUT       LDA                                                        CGL020
     C                   EXSR      *PSSR                                                      CGL020
     C                   ENDIF                                                                CGL020
                                                                                              CGL020
     C                   IF        PRTCD = *BLANKS                                            CGL020
     C                   EVAL      CGL020 = 'Y'                                               CGL020
     C                   ELSE                                                                 CGL020
     C                   EVAL      CGL020 = 'N'                                               CGL020
     C                   ENDIF                                                                CGL020
                                                                                              CGL020
      ** Access TABTB20
     C                   READ      TABTB20                                03
 
      ** Database error
     C     *IN03         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = 'TABTB20'
     C                   EVAL      DBKEY = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access TABTB40
     C                   READ      TABTB40                                03
 
      ** Database error
     C     *IN03         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'TABTB40'
     C                   EVAL      DBKEY = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Futures and Options Details
     C                   CALL      'AOFODAR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDFODA        PARM      SDFODA        DSFDY
 
      ** Database error
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'SDFODAPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      ** Define key list for chaining to CHGCM FILE
 
     C     CHGCMK        KLIST
     C                   KFLD                    ISCY
     C                   KFLD                    CGCM
 
      ** Define key for LF/MEMOSM
 
     C     MEMKEY        KLIST
     C                   KFLD                    FFBRCA
     C                   KFLD                    FFCNUM
     C                   KFLD                    FFCCY
     C                   KFLD                    FFACOD
     C                   KFLD                    FFACSQ
 
      ** Define key for LF/PRONOM
 
     C     PROKEY        KLIST
     C                   KFLD                    FFCCY
     C                   KFLD                    FFNOSN
 
      ** Define key for LF/ACCNT
     C     FFACTK        KLIST
     C                   KFLD                    FFCNUM
     C                   KFLD                    FFCCY
     C                   KFLD                    FFACOD
     C                   KFLD                    FFACSQ
     C                   KFLD                    FFBRCB
 
      ** Move run date to event date
 
     C                   Z-ADD     BJRDNB        EDAT
     C                   Z-ADD     BJRDNB        VDAT
 
      ** Set up the market center name and the business date for report
 
     C     PMRKT         IFEQ      *BLANKS
 
      ** If the market center is 'Over the Counter', use run date and
      ** 'Over the Counter' as the business date and market name
 
      ** "OVER THE COUNTER"
 
     C                   EVAL      WMKTN = 'OVER THE COUNTER'
     C                   EVAL      WWBUSD   = BJRDNB
     C                   EVAL      WBUSD  = BJMRDT
     C                   EVAL      BUSD = BJRDNB
     C                   ELSE
 
     C                   OPEN      MKCTL
 
      ** Otherwise if a market center code is received, access MKCTL
      ** for business date
 
     C     PMRKT         CHAIN     MKCTL                              02
 
      ** Database error
     C     *IN02         IFEQ      '1'
     C     RECI          ORNE      'D'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 5
     C                   EVAL      DBFILE = 'MKCTL'
     C                   EVAL      DBKEY = PMRKT
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Format business date as DDMMMYY for output to report
     C                   EVAL      ZDAYNO =  BUSD
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
 
     C                   EVAL      WBUSD = ZADATE
     C                   EVAL      WWBUSD = BUSD
 
     C                   OPEN      MARKT
 
      ** Access MARKT for market name
 
     C     MRKT          CHAIN     MARKT                              02
 
      ** Database error
     C     *IN02         IFEQ      '1'
     C     RECI          ORNE      'D'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 6
     C                   EVAL      DBFILE = 'MARKT'
     C                   EVAL      DBKEY = MRKT
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WMKTN = MKTN
 
     C                   ENDIF
 
      ** Setup report header
 
     C                   MOVEL     WMKTN         FFNAM
     C                   MOVEL     WBUSD         FFDAT
     C                   EXSR      SRFFFMT
     C                   MOVEL     FFTXT         RFFTXT
 
      ** Set up underlining for heading
      ** Initialise array index
     C                   Z-ADD     0             X                 2 0
 
      ** FFULIN returned from SR. FFFMT contains number of characters
      ** for underline
     C     X             DOUEQ     FFULIN
     C                   ADD       1             X
     C                   MOVEA     '-'           FULA(X)
     C                   ENDDO
 
      ** Move underline array to output field
     C                   MOVEA     FULA          FULINE
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   EXSR      SRAUDIT
     C                   SETON                                        LR
     C                   RETURN
 
     C                   ENDSR
      **--------------------------------------------------------------------------------------------
      *****************************************************************
     C/EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
