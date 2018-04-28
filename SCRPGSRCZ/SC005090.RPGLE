     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AP Start/End the API database updaters')         *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC005090 - API Start/End of Database Updaters                *
      *                                                               *
      *  Function:  This program prompts for specific database        *
      *             updaters to be started or ended.                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. AR1005781A         Date 19Dec12               *
      *  Prev Amend No. AR1005781          Date 19Dec12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247187             Date 15Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAP183             Date 05Jan06               *
      *                 BUG2616 *CREATE    Date 19May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1005781A - Start DB Updater jobs fails with parm mismatches*
      *             - Additional parameter added due to switching on  *
      *               of CSD087 (Profit Centre Default Matrix)        *
      *               (Child: AR1005782)                              *
      *  AR1005781 - Start DB Updater jobs fails with parm mismatches *
      *              Parameter mismatch error caused by missing       *
      *              parameter due to CGL032, CAS009 and CER034. Fix  *
      *              by adding these missing parameter in APSTRDBU    *
      *              and APENDDBU (Child: AR1005782)                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247187 - Option to start job DBU_PFDM is not being shown in  *
      *           the Start API Database Updaters screen. Every 15th  *
      *           record read from file APDBINFPD is not displayed.   *
      *  CAP183 - Conversion of Market Prices Input into modular      *
      *           structure to use APIs.                              *
      *  BUG2616 - Conversion of API command prompts to subfiles for  *
      *            Midasplus Webfacing.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSC005090DFCF   E             WORKSTN
     F                                     SFILE(SC005090SF:DBURRN)
     FAPDBINFL0 IF   E             DISK
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       70  Start if on else End DBU                            *
      *       80  Next Change record                                  *
      *       81  Error in DBUREP(Reply)                              *
      *       90  EOF of file APDBINFL0                               *
      *       92  EOF of SC005090SF (Subfile)                         *
      *       96  Subfile End                                         *
      *       97  On - Clear subile / Off - Display DBU subfile       *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------
 
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D DBU             S              4A   INZ(*BLANKS)
     D                                     DIM(100)
     D ERR             S             76A   DIM(1) CTDATA PERRCD(1)
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the             ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      * Main processing
     C                   EXSR      MAIN
      *
      * Return
     C                   SETON                                        LR
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS :
     C                   PARM                    APAction          1
 
      * Return code
     C                   PARM                    RetCodeIn
 
     C                   IN        SDSTAT
 
     C                   MOVE      '0'           *IN70
     C                   MOVEL     'End '        WDBUPM           10
     C     APAction      IFEQ      'S'
     C                   MOVE      '1'           *IN70
     C                   MOVEL     'Start '      WDBUPM
     C                   ENDIF
 
     C                   Z-ADD     14            WFLPAG            2 0
     C                   Z-ADD     0             DBURRN
     C                   MOVEA     *BLANKS       DBU
      *
      ** Initialise program name and system prefix
     C                   EVAL      DBPGM = 'SC005090'
     C                   EVAL      SYSTEM = LIBR
      *
      ** Move user and workstation ID to screen fields.
     C                   EVAL      DDUSER = PsUser
     C                   EVAL      DDWID  = PsJobName
      *
     C                   EVAL      *IN97 = *ON
      *
      ** Access Bank Details
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database error
     C                   IF        @RTCD <> *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN processing
      *****************************************************************
     C     MAIN          BEGSR
      *
      ** Initialize DBU default values ('N')
     C                   EXSR      INITDBU
 
      ** Clear Subfile
     C                   MOVE      '1'           *IN97
     C                   WRITE     SC005090SC
     C                   MOVE      '0'           *IN97
 
     C                   EXSR      SRLOAD
 
     C                   MOVE      'N'           W0RSF             1
 
     C     W0RSF         DOWEQ     'N'
 
     C     WERROR        IFNE      0
     C                   MOVE      '1'           *IN81
     C                   ENDIF
 
     C                   WRITE     SC005090HD
     C                   WRITE     SC005090FO
     C                   EXFMT     SC005090SC
 
     C                   MOVE      '0'           *IN81
 
     C                   SELECT
     C     *INKC         WHENEQ    '1'
     C                   EXSR      SREXIT
     C     *INKE         WHENEQ    '1'
     C                   EXSR      SRREFR
     C     *IN98         WHENEQ    '1'
     C                   EXSR      SRLOAD
     C                   OTHER
     C                   EXSR      PROCDB
     C                   ENDSL
     C                   ENDDO
      *
     C                   ENDSR
 
      ****************************************************************
      ** SRLOAD - Load a page in subfile                              *
      ****************************************************************
     C     SRLOAD        BEGSR
 
     C                   Z-ADD     1             WCTR              2 0
     C                   MOVE      '0'           *IN96
 
     C     *INKE         IFEQ      '1'
     C                   Z-ADD     0             DBURRN
     C                   ELSE
     C                   Z-ADD     WLRCD         DBURRN
     C                   ENDIF
 
     C                   READ      APDBINFD0                              90
      *
     C     *IN90         DOWEQ     '0'
     C     WCTR          ANDLE     WFLPAG
 
     C                   EXSR      VALFNCO
 
     C     *IN91         IFEQ      '0'
     C                   MOVE      AQFNCODE      WDBUPM
     C                   MOVEL     WDBUPM        DBUPMT
     C                   MOVE      'job ?'       DBUPMT
     C                   MOVE      'N'           DBUREP
     C                   ADD       1             DBURRN
     C                   MOVE      AQFNCODE      DBU(DBURRN)
 
     C                   WRITE     SC005090SF
 
     C                   ADD       1             WCTR
 
     C                   ENDIF
      *                                                                                       247187
      ** Skip reading next record when counter is greater than the                            247187
      ** subfile page defined.                                                                247187
      *                                                                                       247187
     C                   If        WCTR > WFLPAG                                              247187
     C                   Leave                                                                247187
     C                   Endif                                                                247187
 
     C                   READ      APDBINFD0                              90
     C                   ENDDO
 
     C                   Z-ADD     DBURRN        WLRCD             4 0
 
     C     *IN90         IFEQ      '1'
     C                   MOVE      '1'           *IN96
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      ** VALFNCO - Check if function code read is a valid prompt      *
      ****************************************************************
     C     VALFNCO       BEGSR
      *
     C                   MOVE      '0'           *IN91
 
     C     AQFNCODE      IFEQ      'FCTY'
     C     AQFNCODE      OREQ      'LOAN'
     C     AQFNCODE      OREQ      'PTPU'
     C     AQFNCODE      OREQ      'PTSO'
     C     AQFNCODE      OREQ      'LAPT'
     C     AQFNCODE      OREQ      'LAPF'
     C     AQFNCODE      OREQ      'LAPI'
     C     AQFNCODE      OREQ      'LABC'
     C     AQFNCODE      OREQ      'LASC'
     C     AQFNCODE      OREQ      'LASA'
     C     AQFNCODE      OREQ      'LASL'
     C     AQFNCODE      OREQ      'ROLL'
     C     AQFNCODE      OREQ      'LAMR'
     C                   MOVE      '1'           *IN91
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      ** SRREFR- Refresh the values in the screen                     *
      ****************************************************************
     C     SRREFR        BEGSR
 
      ** Clear subfile and initialize DBU values and error indicators
 
     C                   MOVE      '1'           *IN97
     C                   WRITE     SC005090SC
     C                   MOVE      '0'           *IN97
     C                   MOVE      '0'           *IN81
     C                   Z-ADD     0             WERROR
     C                   EXSR      INITDBU
 
     C     1             SETLL     APDBINFD0
     C                   EXSR      SRLOAD
 
     C                   ENDSR
      ****************************************************************
      ** PROCDB- Store the value of the Start/End indicator to        *
      **         respective variable and call Start/End DBU program   *
      ****************************************************************
     C     PROCDB        BEGSR
 
     C                   Z-ADD     1             DBURRN
     C                   READC     SC005090SF                             92
     C                   Z-ADD     0             WERROR            2 0
     C                   MOVE      '0'           *IN80
 
     C     *IN92         DOWEQ     '0'
     C                   EXSR      VALREP
     C                   SELECT
     C     DBU(DBURRN)   WHENEQ    'LDNI'
     C                   MOVE      DBUREP        LDNI              1
     C     DBU(DBURRN)   WHENEQ    'DEAM'
     C                   MOVE      DBUREP        DEAM              1
     C     DBU(DBURRN)   WHENEQ    'NASP'
     C                   MOVE      DBUREP        NASP              1
     C     DBU(DBURRN)   WHENEQ    'NASS'
     C                   MOVE      DBUREP        NASS              1
     C     DBU(DBURRN)   WHENEQ    'FXDL'
     C                   MOVE      DBUREP        FXDL              1
     C     DBU(DBURRN)   WHENEQ    'FRA'
     C                   MOVE      DBUREP        FRA               1
     C     DBU(DBURRN)   WHENEQ    'SIRS'
     C                   MOVE      DBUREP        SIRS              1
     C     DBU(DBURRN)   WHENEQ    'CIRS'
     C                   MOVE      DBUREP        CIRS              1
     C     DBU(DBURRN)   WHENEQ    'DPMV'
     C                   MOVE      DBUREP        DPMV              1
     C     DBU(DBURRN)   WHENEQ    'TRAD'
     C                   MOVE      DBUREP        TRAD              1
     C     DBU(DBURRN)   WHENEQ    'TRAN'
     C                   MOVE      DBUREP        TRAN              1
     C     DBU(DBURRN)   WHENEQ    'INTC'
     C                   MOVE      DBUREP        INTC              1
     C     DBU(DBURRN)   WHENEQ    'FWRT'
     C                   MOVE      DBUREP        FWRT              1
     C     DBU(DBURRN)   WHENEQ    'INTR'
     C                   MOVE      DBUREP        INTR              1
     C     DBU(DBURRN)   WHENEQ    'PFDM'
     C                   MOVE      DBUREP        PFDM              1
     C     DBU(DBURRN)   WHENEQ    'BITH'
     C                   MOVE      DBUREP        BITH              1
     C     DBU(DBURRN)   WHENEQ    'BITP'
     C                   MOVE      DBUREP        BITP              1
     C     DBU(DBURRN)   WHENEQ    'AMAD'
     C                   MOVE      DBUREP        AMAD              1
     C     DBU(DBURRN)   WHENEQ    'CUSD'
     C                   MOVE      DBUREP        CUSD              1
     C     DBU(DBURRN)   WHENEQ    'OPAY'
     C                   MOVE      DBUREP        OPAY              1
     C     DBU(DBURRN)   WHENEQ    'PRCS'
     C                   MOVE      DBUREP        PRCS              1
     C     DBU(DBURRN)   WHENEQ    'SECD'
     C                   MOVE      DBUREP        SECD              1
     C     DBU(DBURRN)   WHENEQ    'IPAY'
     C                   MOVE      DBUREP        IPAY              1
     C     DBU(DBURRN)   WHENEQ    'SECS'
     C                   MOVE      DBUREP        SECS              1
     C     DBU(DBURRN)   WHENEQ    'SEDE'
     C                   MOVE      DBUREP        SEDE              1
     C     DBU(DBURRN)   WHENEQ    'FUND'
     C                   MOVE      DBUREP        FUND              1
     C     DBU(DBURRN)   WHENEQ    'SPTR'
     C                   MOVE      DBUREP        SPTR              1
     C     DBU(DBURRN)   WHENEQ    'BSRT'
     C                   MOVE      DBUREP        BSRT              1
     C     DBU(DBURRN)   WHENEQ    'BYSL'
     C                   MOVE      DBUREP        BYSL              1
     C     DBU(DBURRN)   WHENEQ    'REPO'
     C                   MOVE      DBUREP        REPO              1
     C     DBU(DBURRN)   WHENEQ    'YRAT'
     C                   MOVE      DBUREP        YRAT              1
     C     DBU(DBURRN)   WHENEQ    'FAMD'
     C                   MOVE      DBUREP        FAMD              1
     C     DBU(DBURRN)   WHENEQ    'RPRT'
     C                   MOVE      DBUREP        RPRT              1
     C     DBU(DBURRN)   WHENEQ    'FPRT'
     C                   MOVE      DBUREP        FPRT              1
     C     DBU(DBURRN)   WHENEQ    'FEAD'
     C                   MOVE      DBUREP        FEAD              1
     C     DBU(DBURRN)   WHENEQ    'FEST'
     C                   MOVE      DBUREP        FEST              1
     C     DBU(DBURRN)   WHENEQ    'ASGN'
     C                   MOVE      DBUREP        ASGN              1
     C     DBU(DBURRN)   WHENEQ    'CACF'
     C                   MOVE      DBUREP        CACF              1
     C     DBU(DBURRN)   WHENEQ    'MVTS'
     C                   MOVE      DBUREP        MVTS              1
     C     DBU(DBURRN)   WHENEQ    'STPR'
     C                   MOVE      DBUREP        STPR              1
     C     DBU(DBURRN)   WHENEQ    'TRSM'
     C                   MOVE      DBUREP        TRSM              1
     C     DBU(DBURRN)   WHENEQ    'LOAM'
     C                   MOVE      DBUREP        LOAM              1
     C     DBU(DBURRN)   WHENEQ    'CLIP'
     C                   MOVE      DBUREP        CLIP              1
     C     DBU(DBURRN)   WHENEQ    'FCIP'
     C                   MOVE      DBUREP        FCIP              1
     C     DBU(DBURRN)   WHENEQ    'LERI'
     C                   MOVE      DBUREP        LERI              1
     C     DBU(DBURRN)   WHENEQ    'MAPY'
     C                   MOVE      DBUREP        MAPY              1
     C     DBU(DBURRN)   WHENEQ    'RPSC'
     C                   MOVE      DBUREP        RPSC              1
     C     DBU(DBURRN)   WHENEQ    'FEEM'
     C                   MOVE      DBUREP        FEEM              1
     C     DBU(DBURRN)   WHENEQ    'DLFE'                                                  AR1005781
     C                   MOVE      DBUREP        DLFE              1                       AR1005781
     C     DBU(DBURRN)   WHENEQ    'ACUD'                                                  AR1005781
     C                   MOVE      DBUREP        ACUD              1                       AR1005781
     C     DBU(DBURRN)   WHENEQ    'CCTX'                                                  AR1005781
     C                   MOVE      DBUREP        CCTX              1                       AR1005781
     C     DBU(DBURRN)   WHENEQ    'JACM'                                                  AR1005781
     C                   MOVE      DBUREP        JACM              1                       AR1005781
     C     DBU(DBURRN)   WHENEQ    'NAHL'                                                  AR1005781
     C                   MOVE      DBUREP        NAHL              1                       AR1005781
     C     DBU(DBURRN)   WHENEQ    'NATX'                                                  AR1005781
     C                   MOVE      DBUREP        NATX              1                       AR1005781
     C     DBU(DBURRN)   WHENEQ    'MPRI'                                                     CAP183
     C                   MOVE      DBUREP        MPRI              1                          CAP183
     C     DBU(DBURRN)   WHENEQ    'CUAH'                                                  AR1005781
     C                   MOVE      DBUREP        CUAH              1                       AR1005781
     C     DBU(DBURRN)   WHENEQ    'PCDM'                                                 AR1005781A
     C                   MOVE      DBUREP        PCDM              1                      AR1005781A
     C                   ENDSL
 
     C                   MOVE      '1'           *IN80
     C                   UPDATE    SC005090SF
     C                   MOVE      '0'           *IN80
     C                   MOVE      '0'           *IN81
 
     C                   READC     SC005090SF                             92
     C                   ENDDO
 
     ** Call Start/End DBU program if no error
     **
     C     WERROR        IFNE      0
 
     C                   EVAL      DBURRN = WERROR
 
     C                   ELSE
 
     C     APAction      IFEQ      'E'
     C                   CALLB     'APENDDBU'
     C                   PARM                    SYSTEM            2
     C                   PARM                    LDNI
     C                   PARM                    DEAM
     C                   PARM                    NASP
     C                   PARM                    NASS
     C                   PARM                    FXDL
     C                   PARM                    FRA
     C                   PARM                    SIRS
     C                   PARM                    CIRS
     C                   PARM                    DPMV
     C                   PARM                    TRAD
     C                   PARM                    TRAN
     C                   PARM                    INTC
     C                   PARM                    FWRT
     C                   PARM                    INTR
     C                   PARM                    PRCS
     C                   PARM                    PFDM
     C                   PARM                    BITH
     C                   PARM                    BITP
     C                   PARM                    OPAY
     C                   PARM                    CUSD
     C                   PARM                    AMAD
     C                   PARM                    IPAY
     C                   PARM                    SECS
     C                   PARM                    SECD
     C                   PARM                    SEDE
     C                   PARM                    SPTR
     C                   PARM                    BSRT
     C                   PARM                    FUND
     C                   PARM                    REPO
     C                   PARM                    BYSL
     C                   PARM                    YRAT
     C                   PARM                    ASGN
     C                   PARM                    RPRT
     C                   PARM                    FPRT
     C                   PARM                    FAMD
     C                   PARM                    FEAD
     C                   PARM                    FEST
     C                   PARM                    CACF
     C                   PARM                    MVTS
     C                   PARM                    TRSM
     C                   PARM                    STPR
     C                   PARM                    FCIP
     C                   PARM                    CLIP
     C                   PARM                    LOAM
     C                   PARM                    LERI
     C                   PARM                    MAPY
     C                   PARM                    FEEM
     C                   PARM                    RPSC
     C                   PARM                    DLFE                                      AR1005781
     C                   PARM                    ACUD                                      AR1005781
     C                   PARM                    CCTX                                      AR1005781
     C                   PARM                    JACM                                      AR1005781
     C                   PARM                    NAHL                                      AR1005781
     C                   PARM                    NATX                                      AR1005781
     C                   PARM                    MPRI                                         CAP183
     C                   PARM                    CUAH                                      AR1005781
     C                   PARM                    PCDM                                     AR1005781A
     C                   ELSE
     C                   CALLB     'APSTRDBU'
     C                   PARM                    SYSTEM
     C                   PARM                    LDNI
     C                   PARM                    DEAM
     C                   PARM                    NASP
     C                   PARM                    NASS
     C                   PARM                    FXDL
     C                   PARM                    FRA
     C                   PARM                    SIRS
     C                   PARM                    CIRS
     C                   PARM                    DPMV
     C                   PARM                    TRAD
     C                   PARM                    TRAN
     C                   PARM                    INTC
     C                   PARM                    FWRT
     C                   PARM                    INTR
     C                   PARM                    PRCS
     C                   PARM                    PFDM
     C                   PARM                    BITH
     C                   PARM                    BITP
     C                   PARM                    OPAY
     C                   PARM                    CUSD
     C                   PARM                    AMAD
     C                   PARM                    IPAY
     C                   PARM                    SECS
     C                   PARM                    SECD
     C                   PARM                    SEDE
     C                   PARM                    SPTR
     C                   PARM                    BSRT
     C                   PARM                    FUND
     C                   PARM                    REPO
     C                   PARM                    BYSL
     C                   PARM                    YRAT
     C                   PARM                    ASGN
     C                   PARM                    RPRT
     C                   PARM                    FPRT
     C                   PARM                    FAMD
     C                   PARM                    FEAD
     C                   PARM                    FEST
     C                   PARM                    CACF
     C                   PARM                    MVTS
     C                   PARM                    TRSM
     C                   PARM                    STPR
     C                   PARM                    FCIP
     C                   PARM                    CLIP
     C                   PARM                    LOAM
     C                   PARM                    LERI
     C                   PARM                    MAPY
     C                   PARM                    FEEM
     C                   PARM                    RPSC
     C                   PARM                    DLFE                                      AR1005781
     C                   PARM                    ACUD                                      AR1005781
     C                   PARM                    CCTX                                      AR1005781
     C                   PARM                    JACM                                      AR1005781
     C                   PARM                    NAHL                                      AR1005781
     C                   PARM                    NATX                                      AR1005781
     C                   PARM                    MPRI                                         CAP183
     C                   PARM                    CUAH                                      AR1005781
     C                   PARM                    PCDM                                     AR1005781A
     C                   ENDIF
 
     C                   MOVE      'Y'           W0RSF
 
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      ** VALREP - Validates Reply for all database
      ****************************************************************
     C     VALREP        BEGSR
 
     C     DBUREP        IFNE      'Y'
     C     DBUREP        ANDNE     'N'
 
     C     DBURRN        IFLT      WERROR
     C     WERROR        ANDNE     0
     C     WERROR        OREQ      0
     C                   Z-ADD     DBURRN        WERROR
     C                   ENDIF
 
     C                   MOVE      '1'           *IN81
     C                   MOVE      ERR(1)        DDERR
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      ** INITDBU - Initialize DBU default values
      ****************************************************************
     C     INITDBU       BEGSR
 
     C                   MOVE      'N'           LDNI
     C                   MOVE      'N'           DEAM
     C                   MOVE      'N'           NASP
     C                   MOVE      'N'           NASS
     C                   MOVE      'N'           FXDL
     C                   MOVE      'N'           FRA
     C                   MOVE      'N'           SIRS
     C                   MOVE      'N'           CIRS
     C                   MOVE      'N'           DPMV
     C                   MOVE      'N'           TRAD
     C                   MOVE      'N'           TRAN
     C                   MOVE      'N'           INTC
     C                   MOVE      'N'           FWRT
     C                   MOVE      'N'           INTR
     C                   MOVE      'N'           PRCS
     C                   MOVE      'N'           PFDM
     C                   MOVE      'N'           BITH
     C                   MOVE      'N'           BITP
     C                   MOVE      'N'           OPAY
     C                   MOVE      'N'           CUSD
     C                   MOVE      'N'           AMAD
     C                   MOVE      'N'           IPAY
     C                   MOVE      'N'           SECS
     C                   MOVE      'N'           SECD
     C                   MOVE      'N'           SEDE
     C                   MOVE      'N'           SPTR
     C                   MOVE      'N'           BSRT
     C                   MOVE      'N'           FUND
     C                   MOVE      'N'           REPO
     C                   MOVE      'N'           BYSL
     C                   MOVE      'N'           YRAT
     C                   MOVE      'N'           ASGN
     C                   MOVE      'N'           RPRT
     C                   MOVE      'N'           FPRT
     C                   MOVE      'N'           FAMD
     C                   MOVE      'N'           FEAD
     C                   MOVE      'N'           FEST
     C                   MOVE      'N'           CACF
     C                   MOVE      'N'           MVTS
     C                   MOVE      'N'           TRSM
     C                   MOVE      'N'           STPR
     C                   MOVE      'N'           FCIP
     C                   MOVE      'N'           CLIP
     C                   MOVE      'N'           LOAM
     C                   MOVE      'N'           LERI
     C                   MOVE      'N'           MAPY
     C                   MOVE      'N'           FEEM
     C                   MOVE      'N'           RPSC
     C                   MOVE      'N'           DLFE                                      AR1005781
     C                   MOVE      'N'           ACUD                                      AR1005781
     C                   MOVE      'N'           CCTX                                      AR1005781
     C                   MOVE      'N'           JACM                                      AR1005781
     C                   MOVE      'N'           NAHL                                      AR1005781
     C                   MOVE      'N'           NATX                                      AR1005781
     C                   MOVE      'N'           MPRI                                         CAP183
     C                   MOVE      'N'           CUAH                                      AR1005781
     C                   MOVE      'N'           PCDM                                     AR1005781A
 
     C                   ENDSR
      ****************************************************************
      ** SREXIT - Exits the program
      ****************************************************************
     C     SREXIT        BEGSR
 
     C                   MOVE      '1'           *INLR
     C                   RETURN
 
     C                   ENDSR
      ****************************************************************
      * *PSSR - Program exception error routine
      ****************************************************************
     C     *PSSR         BEGSR
     C                   DUMP
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
**  ERR
Valid values are 'Y' or 'N'
