     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Event Generation for Premium')
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FF000200 - FF Event Generation for Premium                   *
      *                                                               *
      *  Function:  This module generates events in FOEVED for        *
      *  (COB)      premium paid up front.                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 208818             Date 16Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007  *CREATE    Date 13Feb01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  208818 - DB error in GLC0802A due to blank EBRC in FOEVED.   *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FTRANSD    IF   E             DISK
     FTRSET     IF   E           K DISK
     FFOEVEZZ   UF A E             DISK    INFSR(*PSSR)
     FFOEVED    O  A E             DISK    INFSR(*PSSR)
     FINTYP     IF   E           K DISK
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       01         EOF for TRANSD                               *
      *       02         No record found                              *
      *       03         EOF for FOEVEZZ                              *
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
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
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** General Ledger ICD
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long Data Structure
 
     D                 DS
     D ZZ228                   1    228
     D WTNBR                   1      6  0
     D WCSLT                   7      8  0
     D*WCSLA****               9     20                                                       CGL029
     D*WPTFR****              21     24                                                       CGL029
     D WCSLA                   9     26                                                       CGL029
     D WPTFR                  27     30                                                       CGL029
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PMRKT           S              2
     D PRTCD           S              7
     D POPTN           S              7
     D PCURR           S              3
 
     D WECD            S              5  0
     D WHRDC           S              4  0
     D WNORE           S              5  0
     D ZAMTF           S             15P 0
     D ZCCYF           S              3
     D ZCCYT           S              3
     D ZRATEF          S             13P 8
     D ZRATET          S             13P 8
     D ZMDINF          S              1
     D ZMDINT          S              1
     D ZCDPF           S              1P 0
     D ZCDPT           S              1P 0
     D ZAMTT           S             15P 0
     D ZCRSRT          S             13P 8
     D ZCRSMD          S              1
     D ZZAMT           S             15  3
     D ZZTOTI          S             15  0
     D ZZTOTD          S              3  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      * Main processing
      *
     C                   EXSR      SRMAIN
 
      ** Return
 
     C                   SETON                                        LR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRMAIN - Main Processing
      *****************************************************************
     C     SRMAIN        BEGSR
 
     C                   READ      TRANSD                                 01
 
     C                   DOW       *IN01 = '0'
 
     C                   IF        RECI = 'D'
     C                             AND  VALD > WECD
 
     ** Access Instruments File
     C     ISTT          CHAIN     INTYP                              02
 
     C                   IF        *IN02 = '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'INTYP'
     C                   EVAL      DBKEY = ISTT
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Process Instrument for Options only (Premium paid up front)
     C                   IF        PUPF = 'Y'
 
      ** Access TRSET for events details
     C                   EXSR      SRTRSET
 
      ** Write event to FOEVED
     C                   EXSR      SRWRITE
 
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      TRANSD                                 01
     C                   ENDDO
 
      ** Write or update dealing events trailer
     C                   READ      FOEVEZZ                                03
 
     C                   ADD       ZZTOTI        HRWN
     C     HRDC          ADD       ZZTOTD        WHRDC
     C                   IF        WHRDC >= 1000
     C                   ADD       1             HRWN
     C                   SUB       1000          WHRDC
     C                   ENDIF
     C                   ADD       WHRDC         HRDC
     C                   ADD       WNORE         NORE
 
     C                   IF        *IN03 = '1'
     C                   EVAL      RECI = 'T'
     C                   WRITE     FOEVEZZF
     C                   ELSE
     C                   UPDATE    FOEVEZZF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRTRSET - Access Settlement Details
      *****************************************************************
     C     SRTRSET       BEGSR
 
     ** Access Setllements File
     C     TNBR          CHAIN     TRSET                              02
 
      ** Not found or deleted
     C                   IF        *IN02 = '1'
     C                             OR  RECI <> 'D'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 5
     C                   EVAL      DBFILE = 'TRSET'
     C                   MOVEL     TNBR          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRWRITE - Write Generated Event to FOEVED
      *****************************************************************
     C     SRWRITE       BEGSR
 
      ** Fill in event details
     C                   MOVEL     ORBR          OSBR
     C                   Z-ADD     VALD          EDAT
     C                   MOVEL     ISCY          ECCY
     C                   Z-ADD     PRMP          EAMT
     C                   MOVEL     '93V1'        ETYP
 
     C                   IF        ISCY <> BJCYCD
 
      ** Access currency details
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      ISCY          PCURR
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database error
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 6
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = ISCY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set event exchange rate & sort sequence
     C                   Z-ADD     A6SSNB        ECSS
     C                   Z-ADD     A6SPRT        EXRT
     C                   MOVEL     A6CYCD        ZCCYF
     C                   Z-ADD     A6SPRT        ZRATEF
     C                   MOVEL     A6MDIN        ZMDINF
     C                   Z-ADD     A6NBDP        ZCDPF
     C                   Z-ADD     EAMT          ZAMTF
 
      ** Convert amount to another currency
     C                   CALLB     'ZCCYCN'
     C                   PARM                    ZAMTF
     C                   PARM                    ZCCYF
     C                   PARM                    ZCCYT
     C                   PARM                    ZRATEF
     C                   PARM                    ZRATET
     C                   PARM                    ZMDINF
     C                   PARM                    ZMDINT
     C                   PARM                    ZCDPF
     C                   PARM                    ZCDPT
     C                   PARM                    ZAMTT
     C                   PARM                    ZCRSRT
     C                   PARM                    ZCRSMD
 
     C                   Z-ADD     ZAMTT         BCEQ
     C                   ELSE
     C                   Z-ADD     EAMT          BCEQ
     C                   ENDIF
 
      ** Write generated events only if amount is not zero
     C                   IF        EAMT <> *ZEROS
 
      ** Write record for customer
     C**********         IF        CUSC <> *ZEROS                                             CSD027
     C                   IF        CUSC <> *BLANKS                                            CSD027
     C                   MOVEL     CUSC          CUNR
     C                   Z-ADD     TNBR          WTNBR
     C                   MOVEL     CSLT          WCSLT
     C                   MOVEL     CSLA          WCSLA
     C                   MOVEL     PTFR          WPTFR
 
     C**********         IF        BOCO = *ZEROS                                              CSD027
     C                   IF        BOCO = *BLANKS                                             CSD027
     C                   IF        TRTY = 'P'
     C                   MOVEL     'O'           INOI
     C                   ELSE
     C                   MOVEL     'I'           INOI
     C                   ENDIF
     C                   ELSE
     C                   IF        TRTY = 'P'
     C                   MOVEL     'I'           INOI
     C                   ELSE
     C                   MOVEL     'O'           INOI
     C                   ENDIF
     C                   ENDIF
 
     C                   ADD       1             WNORE
      *                                                                                       208818
     C     BRCA          IFNE      OSBR                                                       208818
     C     OSBR          ANDNE     *BLANKS                                                    208818
     C                   MOVEL     OSBR          EBRC                                         208818
     C                   ELSE                                                                 208818
     C                   MOVEL     BRCA          EBRC                                         208818
     C                   ENDIF                                                                208818
      *                                                                                       208818
     C                   WRITE     FOEVEDF
 
      ** Add amount to hash fields
     C     EAMT          DIV       1000          ZZAMT
     C                   CALLB     'ZZADD'
     C                   PARM                    ZZAMT
     C                   PARM                    ZZTOTI
     C                   PARM                    ZZTOTD
     C                   ENDIF
 
      ** Write record for broker
     C**********         IF        BOCO <> *ZEROS                                             CSD027
     C                   IF        BOCO <> *BLANKS                                            CSD027
     C                   MOVEL     BOCO          CUNR
     C                   Z-ADD     TNBR          WTNBR
     C                   MOVEL     BSLT          WCSLT
     C                   MOVEL     BSLA          WCSLA
     C                   MOVEL     *BLANKS       WPTFR
 
     C                   IF        TRTY = 'P'
     C                   MOVEL     'O'           INOI
     C                   ELSE
     C                   MOVEL     'I'           INOI
     C                   ENDIF
 
     C                   ADD       1             WNORE
      *                                                                                       208818
     C     BRCA          IFNE      OSBR                                                       208818
     C     OSBR          ANDNE     *BLANKS                                                    208818
     C                   MOVEL     OSBR          EBRC                                         208818
     C                   ELSE                                                                 208818
     C                   MOVEL     BRCA          EBRC                                         208818
     C                   ENDIF                                                                208818
      *                                                                                       208818
     C                   WRITE     FOEVEDF
 
      ** Add amount to hash fields
     C     EAMT          DIV       1000          ZZAMT
     C                   CALLB     'ZZADD'
     C                   PARM                    ZZAMT
     C                   PARM                    ZZTOTI
     C                   PARM                    ZZTOTD
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Parameters
     C     *ENTRY        PLIST
     C                   PARM                    PMRKT
 
     C                   EVAL      DBPGM = 'FF000200'
 
      ** Access Bank details via access program
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 1
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Get the General Ledger ICD
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      ** Database error
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        BKAPDT >= BJDNWD
     C     BJDNWD        SUB       1             WECD
     C                   ELSE
     C                   Z-ADD     BKAPDT        WECD
     C                   ENDIF
 
      ** Access currency details
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      BJCYCD        PCURR
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database error
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = BJCYCD
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      ZCCYT = A6CYCD
     C                   EVAL      ZRATET = A6SPRT
     C                   EVAL      ZMDINT = A6MDIN
     C                   EVAL      ZCDPT = A6NBDP
 
     C                   EVAL      WNORE = 0
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
