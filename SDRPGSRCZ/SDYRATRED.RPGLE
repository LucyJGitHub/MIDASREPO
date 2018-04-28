     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Yield Rates Read')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDYRATRED - Yield Rates Details Read                         *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the Yield Rates Details File              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CAS008             Date 16Jun04               *
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CAS001  *CREATE    Date 23Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAS008 - IAS 39 Enhancements                                 *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDYLDRL1  IF   E           K DISK    INFSR(*PSSR)
      ** Yield Rates File - by Curve, Currency and Interest Calculation Method
 
      *****************************************************************
      *                                                               *
      * FUNCTION OF INDICATORS                                        *
      *                                                               *
      * 96 - End of File                                              *
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
      *      SrRDFWD       - Read Forwards through Yield Rate         *
      *                      Details File                             *
      *      SrRDBCK       - Read Backwards through Yield Rate        *
      *                      Details File                             *
      *      SrCHAUT       - Authority Validation processing          *
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
                                                                                              CAS008
      ** External DS for SAR details                                                          CAS008
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS008
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Indicator Array
     DIndicatorP       S               *   INZ(%ADDR(*IN))
 
      ** Input Parameter (Action, Yield Curve Name, Currency and Interest Calc.
      ** Method, Frenquency screen fields, Read Forward and Read Backward Indicators)
     D PKYACN          S              1A
     D PKYLDC          S              5A
     D PKYCCY          S              3A
     D PKYICM          S              1A
     D PKYCFQ          S              1A
     D PKSPDY          S              2A                                                      CAS008
     D PRDFWD          S              1A
     D PRDBCK          S              1A
 
      ** Key fields
     D WKYLDC          S              5A
     D WKYCCY          S              3A
     D WKYICM          S              1A
 
      ** Parameter for access object
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSard           S              6A                                                      CAS008
 
      ** Output Parameter (Error Message Id)
     D PERRMS          S              7A
 
     D CAS008          S              1A                                                      CAS008
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
 
     C                   IF        BJSBRC <> *BLANKS
     C                   EXSR      SrCHAUT
     C                   ENDIF
 
      ** Validate action code if no authority error
 
     C                   IF        PERR = *ZERO
     C                   EXSR      SrVALAC
 
      ** Read forwards
 
     C                   IF        PERRMS = *BLANK
     C                   IF        PRDFWD = 'Y'
     C                   EXSR      SrRDFWD
     C                   ELSE
 
      ** Read backwards
 
     C                   IF        PRDBCK = 'Y'
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
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
     C     SrINIT        BEGSR
 
      ** Initialise output
 
     C                   EVAL      PERRMS = *BLANK
 
      ** Set Key fields
 
     C                   EVAL      WKYLDC = PKYLDC
     C                   EVAL      WKYCCY = PKYCCY
     C                   EVAL      WKYICM = PKYICM
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrVALAC - Validate Action Code                                *
      *                                                               *
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
     C     SrVALAC       BEGSR
 
      ** Check the action code if invalid
 
     C                   IF        PKYACN = 'I'
     C                   EVAL      PERRMS = 'USR9248'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRDFWD - Read Forwards through Yield Rate Details File       *
      *                                                               *
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
     C     SrRDFWD       BEGSR
 
      ** Position the pointer next to the current record
 
     C     KYRATL        SETGT     SDYLDRL1
 
     C                   DOU       (FSRECI = 'D') OR (EndOfFile = TRUE)
     C                   READ      SDYLDRL1                               96
 
      ** If end of file was encountered, report this fact
 
     C                   IF        EndOfFile = TRUE
     C                   MOVEL     'USR9249'     PERRMS
     C                   ELSE
 
      ** Otherwise, return selected record
 
     C                   MOVEL     FSYLDC        PKYLDC
     C                   MOVEL     FSYCCY        PKYCCY
     C                   MOVEL     FSYICM        PKYICM
     C                   MOVEL     FSYCFQ        PKYCFQ
     C                   IF        CAS008 = 'Y'                                               CAS008
     C                   MOVEL     FSSPDY        PKSPDY                                       CAS008
     C                   ELSE                                                                 CAS008
     C                   MOVEL     *BLANKS       PKSPDY                                       CAS008
     C                   ENDIF                                                                CAS008
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRDBCK - Read Backwards through Yield Rate Details File      *
      *                                                               *
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
     C     SrRDBCK       BEGSR
 
     C     KYRATL        SETLL     SDYLDRL1
 
      ** Make an initial read previous to get the currency
 
     C                   DOU       (FSRECI = 'D') OR (EndOfFile = TRUE)
     C                   READP     SDYLDRL1                               96
 
      ** If beginning of file was encountered, report this fact
 
     C                   IF        EndOfFile = TRUE
     C                   MOVEL     'USR9250'     PERRMS
     C                   ELSE
 
      ** Otherwise, return selected record
 
     C                   MOVEL     FSYLDC        PKYLDC
     C                   MOVEL     FSYCCY        PKYCCY
     C                   MOVEL     FSYICM        PKYICM
     C                   MOVEL     FSYCFQ        PKYCFQ
     C                   IF        CAS008 = 'Y'                                               CAS008
     C                   MOVEL     FSSPDY        PKSPDY                                       CAS008
     C                   ELSE                                                                 CAS008
     C                   MOVEL     *BLANKS       PKSPDY                                       CAS008
     C                   ENDIF                                                                CAS008
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCHAUT - Check for User Authority if not Multi-Branching     *
      *                                                               *
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
     C     SrCHAUT       BEGSR
 
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    PERR              1 0
 
      ** Return error message
 
     C                   IF        PERR = 1
     C                   MOVEL     'USR9194'     PERRMS
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial Processing                                   *
      *                                                               *
      * Called By : Automatically called upon program execution       *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
 
      ** Input:
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Action Code
 
     C                   PARM                    PKYACN
 
      ** Yield Curve
 
     C                   PARM                    PKYLDC
 
      ** Currency
 
     C                   PARM                    PKYCCY
 
      ** Interest calculation method
 
     C                   PARM                    PKYICM
 
      ** Frequency
 
     C                   PARM                    PKYCFQ
 
      ** Spot Days                                                                            CAS008
                                                                                              CAS008
     C                   PARM                    PKSPDY                                       CAS008
                                                                                              CAS008
      ** Read forward flag
 
     C                   PARM                    PRDFWD
 
      ** Read backward flag
 
     C                   PARM                    PRDBCK
 
      ** Output:
      ** Error message
 
     C                   PARM                    PERRMS
 
      ** Define Key list to be use in accessing yield rate details of the
      ** selected currency
 
     C     KYRATL        KLIST
     C                   KFLD                    WKYLDC
     C                   KFLD                    WKYCCY
     C                   KFLD                    WKYICM
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRTCD <> *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     POPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CAS008
      ** Check if switchable feature CAS008 is switched on.                                   CAS008
                                                                                              CAS008
     C                   EVAL      CAS008 = 'N'                                               CAS008
                                                                                              CAS008
     C                   CALL      'AOSARDR0'                                                 CAS008
     C                   PARM      *BLANKS       PRtCd                                        CAS008
     C                   PARM      '*VERIFY'     POptn                                        CAS008
     C                   PARM      'CAS008'      PSard                                        CAS008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS008
                                                                                              CAS008
      ** Database error                                                                       CAS008
                                                                                              CAS008
     C                   IF        (PRtCd <> *BLANKS) AND                                     CAS008
     C                             (PRtCd <> '*NRF   ')                                       CAS008
     C                   EVAL      DBKEY = 'CAS008'                                           CAS008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS008
     C                   EVAL      DBASE = 2                                                  CAS008
     C                   EXSR      *PSSR                                                      CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   IF        PRtCd = *BLANKS                                            CAS008
     C                   EVAL      CAS008 = 'Y'                                               CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
 
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
