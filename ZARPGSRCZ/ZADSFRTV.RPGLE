     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Discount factor/rate retrieval')              *
      *****************************************************************
      *                                                               *
      *  Midas - Copy Source converted into ILE procedures            *
      *                                                               *
      *  RPGLE/ZADSFRTV - Discount Factor Rate Retrieval              *
      *                                                               *
      *  Function: This retrieves a discount factor or rate for a     *
      *            specific date for a Yield Curve, Currency and      *
      *            Int. Calculation Method.  If it does not find a    *
      *            Discount Factor or Rate then it interpolates it    *
      *            based on the Interpolation Method set for the      *
      *            Yield Curve. If this program is called by the      *
      *            Discount Factor Rebuild program, it will always    *
      *            use Exponential Interpolation between discount     *
      *            factors.                                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 230371             Date 05Dec05               *
      *                 CAS008             Date 16Jun04               *
      *                 217651             Date 07May03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001  *CREATE    Date 23Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  230371 - Interpolated Yield Rates are incorrect in LE4111P1. *
      *  CAS008 - IAS 39 Enhancements                                 *
      *  217651 - Incorrect discount factor reported in LE4111 and    *
      *           MM4111                                              *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators:                                           *
      *                                                               *
      *  70             for file LF/SDYLDCL1                          *
      *  91-92-93       for file LF/SDYLDRL2                          *
      *  98             Date format                                   *
      *  LR             End call of program                           *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDYLDRL2  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Yield Rates Master File
 
     FSDYLDCL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Yield Curves Master File
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details ICD retrieval
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for Currency Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS008
      ** External DS for SAR Details                                                          CAS008
                                                                                              CAS008
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long data structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work variables
 
     D WISDat          s              5  0
     D WINDat          s              5  0
     D WIBDat          s              5  0
     D WIFDat          s              5  0
     D WINRat          S             13  9
     D WIFRat          s             13  9
     D WIBRat          s             13  9
 
      ** Parameters
 
     D PNRTCD          s              7
     D PNRATF          s              5
     D PNPYLD          s              5
     D PNPCCY          s              3
     D PNPINC          s              1
     D PNPFDT          s              5  0
     D PDsFac          s             13  9
                                                                                              CAS008
      ** Define work variable for CAS008 enhancement                                          CAS008
     D CAS008          S              1                                                       CAS008
     D WNRDYS          S              2  0                                                    CAS008
     D PSARD           S              6                                                       CAS008
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
 
      ** If interpolation date is less than or equal to spot date,
      ** Discount Factor is 1.
 
     C                   Z-ADD     1             PDsFac
 
     C                   IF        PNPFDT > WNPSDT
 
      **  First find the Discount Factor to use for discounting.
 
     C     KYLDR1        SETLL     SDYLDRL2                           91
 
      **  If not EOF, Read Equal the next record of the yield, currency
      **  and Interest Calculation Method
 
     C                   IF        *IN91 = *OFF
     C     KYLDR2        READE     SDYLDRL2                               92
     C                   ENDIF
 
      ** If a record has not yet been retrieved, reposition the file
      ** and read the last record of the Currency.
 
     C                   IF        *IN91 = *ON OR *IN92 = *ON
     C     KYLDR1        SETGT     SDYLDRL2
     C     KYLDR2        READPE    SDYLDRL2                               93
     C                   ENDIF
 
     C                   SELECT
 
      ** Yield, Currency and Interest Calculation Method combination
      ** is not on File
 
     C                   WHEN      (*IN91 = *ON OR *IN92 = *ON)
     C                             AND *IN93 = *ON
 
     C                   EVAL      PNRTCD = '*NRF   '
     C                   Z-ADD     0             PDsFac                                       217651
 
      ** If a record was read and is the correct date, set up the
      ** Factor
 
     C                   WHEN      *IN91 = *OFF AND *IN92 = *OFF
     C                             AND FSMMDN = PNPFDT
 
     C                   IF        PNRATF = 'YRATE'
     C                   Z-ADD     FSYRAT        PDsFac
     C                   ELSE
     C                   Z-ADD     FSDSCF        PDsFac
     C                   ENDIF
 
      ** If this point has been reached, a record has been found
      ** but it will probably be necessary to use interpolation
 
     C                   OTHER
 
      ** Unknown rate falls after the last known rate
 
     C                   IF        (*IN91 = *ON OR *IN92 = *ON)
     C                             AND *IN93 = *OFF
 
     C                   Z-ADD     *ZERO         WIFDat
     C                   Z-ADD     *ZERO         WIFRat
     C                   Z-ADD     FSMMDN        WINDat
 
     C                   IF        PNRATF = 'YRATE'
     C                   Z-ADD     FSYRAT        WINRat
     C                   ELSE
     C                   Z-ADD     FSDSCF        WINRat
     C                   ENDIF
 
     C                   ELSE
 
      ** Set up Far Date and Far Rate
 
     C                   IF        FSDSCF = 0
     C                   Z-ADD     *ZERO         WIFDat
     C                   Z-ADD     *ZERO         WIFRat
     C                   ELSE
 
     C                   Z-ADD     FSMMDN        WIFDat
 
     C                   IF        PNRATF = 'YRATE'
     C                   Z-ADD     FSYRAT        WIFRat
     C                   ELSE
     C                   Z-ADD     FSDSCF        WIFRat
     C                   ENDIF
 
     C                   ENDIF
 
      ** Read the Previous record to get the Near Discount Factor. If
      ** not found, then the record already retrieved is the first
      ** record of the Currency.
 
     C     KYLDR2        READPE    SDYLDRL2                               91
 
     C                   IF        *IN91 = *ON
 
      ** Unknown rate falls before the first known rate.
 
     C                   Z-ADD     WNPSDT        WINDat
     C                   Z-ADD     1             WINRat
     C                   ELSE
 
      ** Else set up Near Date and Near Factor for interpolation.
 
     C                   Z-ADD     FSMMDN        WINDat
 
     C                   IF        PNRATF = 'YRATE'
     C                   Z-ADD     FSYRAT        WINRat
     C                   ELSE
     C                   Z-ADD     FSDSCF        WINRat
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Set up Broken Date and interpolate the Factor
 
     C                   Z-ADD     PNPFDT        WIBDat
     C                   Z-ADD     WNPSDT        WISDat
     C                   Z-ADD     0             WIBRat
 
     C     PNPYLD        CHAIN     SDYLDCL1                           70
 
     C                   IF        *IN70 = *OFF
 
     C                   SELECT
 
      ** Exponential Interpolation
 
     C                   WHEN      FSINTP = 'E' OR FSINTP = 'R'
     C                   CALL      'ZAEXPIN'
     C                   PARM                    WISDat
     C                   PARM                    WINDat
     C                   PARM                    WIBDat
     C                   PARM                    WIFDat
     C                   PARM                    WINRat
     C                   PARM                    WIFRat
     C                   PARM                    WIBRat
 
      ** Straight Line Interpolation
 
     C                   WHEN      FSINTP = 'S' OR FSINTP = 'Y'
     C                   CALL      'ZAINTPL'
     C                   PARM                    WINDat
     C                   PARM                    WIBDat
     C                   PARM                    WIFDat
     C                   PARM                    WINRat
     C                   PARM                    WIFRat
     C                   PARM                    WIBRat
 
     C                   ENDSL
 
     C                   ELSE
     C                   EVAL      DBFILE = 'SDYLDCPD'
     C                   EVAL      DBASE = 003
     C                   EVAL      DBKEY = PNPYLD
     C                   EVAL      PNRTCD = '*ERROR '
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Z-ADD     WIBRat        PDsFac
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
 
      ** Inputs
 
     C                   PARM                    PNRTCD
     C                   PARM                    PNRATF
     C                   PARM                    PNPYLD
     C                   PARM                    PNPCCY
     C                   PARM                    PNPINC
     C                   PARM                    PNPFDT
      ** Output
     C                   PARM                    PDsFac
 
     C     KYLDR1        KLIST
     C                   KFLD                    PNPYLD
     C                   KFLD                    PNPCCY
     C                   KFLD                    PNPINC
     C                   KFLD                    PNPFDT
 
     C     KYLDR2        KLIST
     C                   KFLD                    PNPYLD
     C                   KFLD                    PNPCCY
     C                   KFLD                    PNPINC
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'ZADSFRTV'
 
      ** Initialise fields.
 
     C                   MOVEA     CPY@          BIS@             80
 
     C                   EVAL      *IN91 = *OFF
     C                   EVAL      *IN92 = *OFF
     C                   EVAL      *IN93 = *OFF
     C                   EVAL      *IN98 = *OFF
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *blanks       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      PNRTCD = '*ERROR '
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CAS008
      ** Check if switchable feature CAS008 is switched on                                    CAS008
                                                                                              CAS008
     C                   CALLB     'AOSARDR0'                                                 CAS008
     C                   PARM      *BLANKS       PRTCD                                        CAS008
     C                   PARM      '*VERIFY '    POPTN                                        CAS008
     C                   PARM      'CAS008'      PSARD                                        CAS008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS008
                                                                                              CAS008
     C                   IF        PRTCD <> *BLANKS AND                                       CAS008
     C                             PRTCD <> '*NRF   '                                         CAS008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS008
     C                   EVAL      DBASE  = 4                                                 CAS008
     C                   EVAL      DBKEY  = 'CAS008'                                          CAS008
     C                   EXSR      *PSSR                                                      CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   IF        PRTCD = *BLANKS                                            CAS008
     C                   EVAL      CAS008 = 'Y'                                               CAS008
     C                   ELSE                                                                 CAS008
     C                   EVAL      CAS008 = 'N'                                               CAS008
     C                   ENDIF                                                                CAS008
 
      ** Set Date Format Indicator
 
     C                   IF        BJDFIN = 'M'
     C                   MOVE      *ON           *IN98
     C                   END
 
      ** If currency, PNPCCY is non-blank, call access object to get details
 
     C                   IF        PNPCCY <> *blanks
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *blanks       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      PNPCCY        PCRKEY            3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRTCD <> *blanks
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 002
     C                   EVAL      DBKEY = PNPCCY
     C                   EVAL      PNRTCD = '*ERROR '
     C                   EXSR      *PSSR
     C                   END
 
      **  Determine Spot Date
 
      ** If CAS008 is installed, use spot days defined for the yield                          CAS008
      ** rates instead of the one defined for the currency when                               CAS008
      ** calculating for spot date.                                                           CAS008
                                                                                              CAS008
     C                   IF        CAS008 = 'Y'                                               CAS008
      *                                                                                       230371
     C     KYLDR2        CHAIN     SDYLDRL2                           92                      230371
     C                   IF        *IN92 = *OFF                                               230371
     C                   EVAL      WNRDYS = FSSPDY                                            CAS008
     C                   ELSE                                                                 230371
     C                   MOVE      PNPCCY        WCCY              3                          230371
     C                   MOVE      *BLANKS       PNPCCY                                       230371
     C     KYLDR2        CHAIN     SDYLDRL2                           92                      230371
     C                   IF        *IN92 = *OFF                                               230371
     C                   EVAL      WNRDYS = FSSPDY                                            230371
     C                   ENDIF                                                                230371
     C                   MOVE      WCCY          PNPCCY                                       230371
     C                   ENDIF                                                                230371
                                                                                              230371
     C                   ELSE                                                                 CAS008
     C                   EVAL      WNRDYS = A6SPDY                                            CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   CALL      'ZFWDT'
     C                   PARM      BJRDNB        WDAYNO            5 0
     C**********         PARM      A6SPDY        WNRDYS            2 0                        CAS008
     C                   PARM                    WNRDYS                                       CAS008
     C                   PARM      0             WDYNBR            5 0
     C                   PARM      PNPCCY        WCCY              3
     C                   PARM      *blanks       WLOC              3
 
     C                   Z-ADD     WDYNBR        WNPSDT            5 0
 
     C                   ELSE
 
      ** Else, currency is blank, use rundate as spot date
 
     C                   Z-ADD     BJRDNB        WNPSDT
 
     C                   ENDIF
 
 
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
