     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FD MM Interest Rates Details Read Module')
      *****************************************************************
      *                                                               *
      *  Midas - FD ILE Module                                        *
      *                                                               *
      *  FDINTRRED - Interest Rates Details Read                      *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the Interest Rates Details File           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Last Amend No. CAP058  *CREATE    Date 13Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP058 - Full API for Money Market Interest Rates            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Interest Rates Details File - by Currency, Period type and Period
     FFDINTRL2  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      *                                                               *
      *      FUNCTION OF INDICATORS                                   *
      *                                                               *
      *       96  End of File                                         *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *      SUBROUTINE DESCRIPTION                                   *
      *                                                               *
      *      *INZSR        - Program Initilisation                    *
      *      SrINIT        - Initialisation                           *
      *      SrVALAC       - Validate Action Code                     *
      *      SrRDFWD       - Read Forwards through Interest Rate      *
      *                      Details File                             *
      *      SrRDBCK       - Read Backwards through Interest Rate     *
      *                      Details File                             *
      *      SrCHKAUT      - Authority Validation processing          *
      *      *PSSR         - Standard Error Subroutine                *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *      PROCEDURES AND PROGRAMS CALLED                           *
      *                                                               *
      *      AOBANKR0      - Access Object for Bank Details           *
      *      ZVACTU        - Validate Authority                       *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
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
 
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             96     96
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Indicator Array
     DIndicatorP       S               *   INZ(%ADDR(*IN))
 
      ** Input Parameter (Action code and Currency screen field,
      ** Read Forward and Read Backward Indicators)
     D PKYACN          S              1A
     D PKYCCY          S              3A
     D PRDFWD          S              1A
     D PRDBCK          S              1A
 
      ** Output Parameter (Error Message Id)
     D PERRMS          S              7A
 
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
 
      ** Initialization
 
     C                   EXSR      SrINIT
 
      ** Check for user authority to browse if not multi-branching
 
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      SrCHAUT
     C                   ENDIF
 
      ** Validate action code if no authority error
 
     C     PERR          IFEQ      *ZERO
     C                   EXSR      SrVALAC
 
      ** Read forwards
 
     C     PERRMS        IFEQ      *BLANK
     C     PRDFWD        IFEQ      'Y'
     C                   EXSR      SrRDFWD
     C                   ELSE
 
      ** Read backwards
 
     C     PRDBCK        IFEQ      'Y'
     C                   EXSR      SrRDBCK
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrINIT - Initialisation                                       *
      *                                                               *
      *****************************************************************
     C     SrINIT        BEGSR
 
      ** Initialise output
 
     C                   MOVEL     *BLANK        PERRMS
 
      ** Set Key fields
 
     C     PRDFWD        IFEQ      'Y'
     C                   EVAL      WKCCY = PKYCCY
     C                   EVAL      WKPTYP = 'Y'
     C                   EVAL      WKPERD = 10
     C                   ELSE
     C     PRDBCK        IFEQ      'Y'
     C                   EVAL      WKCCY = PKYCCY
     C                   EVAL      WKPTYP = 'D'
     C                   EVAL      WKPERD = 1
     C     KYFLDL        SETLL     FDINTRL2
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrVALAC - Validate Action Code                                *
      *                                                               *
      *****************************************************************
     C     SrVALAC       BEGSR
 
      ** Check the action code if invalid
 
     C     PKYACN        IFEQ      'I'
     C                   EVAL      PERRMS = 'FDM0052'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRDFWD - Read Forwards through Interest Rate Details File    *
      *                                                               *
      *****************************************************************
     C     SrRDFWD       BEGSR
 
      ** Position the pointer next to the current record
 
     C     KYFLDL        SETGT     FDINTRL2
 
     C     HWDLTF        DOUEQ     *BLANK
     C     EndOfFile     OREQ      TRUE
     C                   READ      FDINTRL2                               96
 
      ** If end of file was encountered, report this fact
 
     C     EndOfFile     IFEQ      TRUE
     C                   MOVEL     'FDM0053'     PERRMS
     C                   ELSE
 
      ** Otherwise, return selected record
 
     C                   MOVEL     HWCCY         PKYCCY
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRDBCK - Read Backwards through Interest Rate Details File   *
      *                                                               *
      *****************************************************************
     C     SrRDBCK       BEGSR
 
      ** Make an initial read previous to get the currency
 
     C     HWDLTF        DOUEQ     *BLANK
     C     EndOfFile     OREQ      TRUE
     C                   READP     FDINTRL2                               96
 
      ** If beginning of file was encountered, report this fact
 
     C     EndOfFile     IFEQ      TRUE
     C                   MOVEL     'FDM0054'     PERRMS
     C                   ELSE
 
      ** Otherwise, return selected record
 
     C                   MOVEL     HWCCY         PKYCCY
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCHAUT - Check for User Authority if not Multi-Branching     *
      *                                                               *
      *****************************************************************
     C     SrCHAUT       BEGSR
 
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    PERR              1 0
 
      ** Return error message
 
     C     PERR          IFEQ      1
     C                   MOVEL     'FXM0292'     PERRMS
     C                   RETURN
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
 
      ** Parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    PKYACN
     C                   PARM                    PKYCCY
     C                   PARM                    PRDFWD
     C                   PARM                    PRDBCK
     C                   PARM                    PERRMS
 
      ** Initialize program name
 
     C                   MOVEL     'FDINTRRED'   DBPGM
 
      ** Define Key list to be use in accessing interest rate details of the
      ** selected currency
 
     C     KYFLDL        KLIST
     C                   KFLD                    WKCCY             3
     C                   KFLD                    WKPTYP            1
     C                   KFLD                    WKPERD            2 0
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** ==============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
