     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Dealing Fees - file to screen format')
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLDLFECVT - DL Fee Conversion: File to Screen Format         *
      *                                                               *
      *  Function:  This module converts the fields of a Fee          *
      *             from their format as on file to a screen format.  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. 232928             Date 08Apr05               *
      *                 CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  232928 - Amortise all fees non-linearly, EIR calculation,    *
      *           Non-linear amortisation calculation & adjustment    *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Fee in File Format
     D CrFeFilFmt    E DS                  EXTNAME(DLFEED)
 
      * Fee in Screen Format
     D CrFeScnFmt    E DS                  EXTNAME(DLDLFEPD)
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D ZAMSID          S              7A
     D ZAMSGF          S             10A
     D ZAMSDA          S            132A
     D ZAMSTP          S            132A
     D WDAYNO          S              5  0
     D ZFLD16          S             16S 0
     D ZFIELD          S             16
     D ZDATE           S              6  0
     D ZDECS           S              1  0
     D ZADATE          S              7A
     D W_ACTN          S              1A
     D PCCY            S              3A
     D DDSTAT          S             16A
     D PRTCD           S              7A
     D POPTN           S              7A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      **************************************************************
 
      ** Initialisation
 
     C                   EXSR      INIT
 
      ** Set output screen fields for screen
     C                   EXSR      SETFLD
 
      * Return
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SETFLD - Set output for screen
      *****************************************************************
     C     SETFLD        BEGSR
 
      ** Fee status
     C     DDACTN        IFNE      'I'
 
     C     DFRECI        IFNE      'M'
     C     DFRECI        ANDNE     'R'
 
     C                   SELECT
     C     DFFSTS        WHENEQ    'C'
     C                   MOVEL     'DLF0001'     ZAMSID
     C     DFFSTS        WHENEQ    'R'
     C                   MOVEL     'DLF0002'     ZAMSID
     C     DFFSTS        WHENEQ    'A'
     C                   MOVEL     'DLF0003'     ZAMSID
     C     DFFSTS        WHENEQ    'D'
     C                   MOVEL     'DLF0004'     ZAMSID
     C                   ENDSL
      *
     C                   ELSE
 
     C                   SELECT
     C     DFRECI        WHENEQ    'M'
     C                   MOVEL     'DLF0005'     ZAMSID
     C     DFRECI        WHENEQ    'R'
     C                   MOVEL     'DLF0002'     ZAMSID
     C                   ENDSL
 
     C                   ENDIF
 
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTP        DDSTAT
     C                   MOVE      *BLANKS       ZAMSID
      *
     C                   ELSE
     C                   MOVE      *BLANK        DDSTAT
     C                   ENDIF
     ** Deal Number
     C     DFDLNO        IFEQ      0
     C                   EVAL      DDDLNO = *BLANKS
     C                   ELSE
     C                   MOVEL     DFDLNO        DDDLNO
     C                   ENDIF
 
     ** Fee Sequence
     C     DFFSEQ        IFEQ      0
     C                   EVAL      DDFSEQ = *BLANKS
     C                   ELSE
     C                   MOVEL     DFFSEQ        DDFSEQ
     C                   ENDIF
 
     ** Customer
     C*****DFCUST        IFEQ      0                                                          CSD027
     C     DFCUST        IFEQ      *blanks                                                    CSD027
     C                   EVAL      DDCUST = *BLANKS
     C                   ELSE
     C                   MOVEL     DFCUST        DDCUST
     C                   ENDIF
     ** Fee Code
     C     DFFCOD        IFEQ      0
     C                   EVAL      DDFCOD = *BLANKS
     C                   ELSE
     C                   MOVEL     DFFCOD        DDFCOD
     C                   ENDIF
     ** Fee currency
     C                   EVAL      DDFCCY = DFFCCY
     ** Frequency
     C                   EVAL      DDFREQ = DFFREQ
     ** Fee Amount
     C     DFFAMT        IFEQ      0
     C                   EVAL      DDFAMT = *BLANKS
     C                   ELSE
     C     DFFAMT        IFLT      0
     C                   Z-SUB     DFFAMT        ZFLD16
     C                   ELSE
     C                   Z-ADD     DFFAMT        ZFLD16
     C                   ENDIF
     C                   MOVE      ZFLD16        ZFIELD
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      FMTAMT
     C                   MOVE      ZFIELD        DDFAMT
     C                   ENDIF
 
     ** Fee Amount sign
     C                   EVAL      DDFSGN = *BLANKS
     C     DFFAMT        IFLT      0
     C                   EVAL      DDFSGN = '-'
     C                   ELSE
     C                   EVAL      DDFSGN = ' '
     C                   ENDIF
 
      ** Start Date
     C                   EVAL      WDAYNO = DFPSTD
     C                   EXSR      CVTDAT
     C                   MOVEL     ZDATE         DDSDAT
      ** End Date
     C                   EVAL      WDAYNO = DFPEND
     C                   EXSR      CVTDAT
     C     ZDATE         IFEQ      0
     C                   EVAL      DDEDAT = *BLANKS
     C                   ELSE
     C                   MOVEL     ZDATE         DDEDAT
     C                   ENDIF
     ** Payment On Indicator
     C                   IF        DFPYON = *BLANK
     C                   MOVE      *BLANKS       DDFIND
     C                   ELSE
     C                   MOVE      DFPYON        DDFIND
     C                   ENDIF
     ** Next Payment Date
     C     DFNPYD        IFEQ      0
     C                   EVAL      DDNPYD = *BLANKS
     C                   ELSE
     C                   EVAL      WDAYNO = DFNPYD
     C                   EXSR      CVTDAT
     C                   MOVEL     ZDATE         DDNPYD
     C                   ENDIF
     ** Day in Month
     C     DFDYIM        IFEQ      0
     C                   MOVE      *BLANKS       DDPDAY
     C                   ELSE
     C                   MOVE      DFDYIM        DDPDAY
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRTEXT  -  Set up text from message file.                     *
      *****************************************************************
     C     SRTEXT        BEGSR
      *
     C                   CALL      'Y2RVMGC'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    ZAMSID                         Message Id.
     C                   PARM      'DRSMM '      ZAMSGF                         Message file.
     C                   PARM                    ZAMSDA                         Message data.
     C                   PARM                    ZAMSTP                         Messge text
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTDAT - CONVERT DATE FROM Midas no. to DDMMYY (OR MMDDYY)    *
      *****************************************************************
     C     CVTDAT        BEGSR
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    WDAYNO                         Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM                    ZDATE                          Value date
     C                   PARM      *ZEROS        ZADATE                         Run-date in DDM
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTAMT - FORMAT AMOUNT FOR DISPLAY                            *
      *****************************************************************
     C     FMTAMT        BEGSR
      *
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZDECS
      *
     C                   EVAL      ZFLD16 = *ZEROS
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      ** BLANK OUTPUTS (EXCEPT FOR ACTION CODE WITHIN ACCOUNT FORMAT)
      *
     C                   MOVEL     DDACTN        W_ACTN
     C                   MOVEL     *BLANK        CrFeScnFmt
     C                   MOVEL     W_ACTN        DDACTN
      *
      ** Get the currency decimal places of Fee ccy
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DFFCCY        PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      * DATABASE ERROR
      *
     C*****@RTCD         IFNE      *BLANKS                                                    232928
     C     PRTCD         IFNE      *BLANKS                                                    232928
     C                   EVAL      RetCodeIn = PRTCD
     C                   EVAL      DBKEY = DFFCCY
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   MOVEL     '901'         DBASE
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** PROGRAM PARAMETERS
 
     C     *ENTRY        PLIST
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Fee in file formats
     C                   PARM                    CrFeFilFmt
 
      ** Output parameters
 
      ** Fee in screen format
     C                   PARM                    CrFeScnFmt
      ** Status
     C                   PARM                    DDSTAT
 
      ** Initialize program name
 
     C                   MOVEL     'DLDLFECVT'   DBPGM
 
      ** Acesss Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     PRTCD         IFNE      *BLANK
     C                   MOVEL     PRTCD         RetCodeIn
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
