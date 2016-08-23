     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Yield rates database update')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDYRATUPD - Yield Rates Database Update                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG9328            Date 01Dec05               *
      *                 227577             Date 26Jun04               *
      *                 228390             Date 14Jul04               *
      *                 CAS008             Date 16Jun04               *
      *                 208179             Date 05Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001  *CREATE    Date 23Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE026 - Consumer Banking                                    *
      *  BUG9328 - Record could not be added.  Rectify subr SRAMEND.  *
      *            Applied fix 234388.                                *
      *  227577 - Delay in processing DBU_YRAT job.                   *
      *  228390 - Introduce a new yield curve type 'S' (for swap      *
      *           rates) which will apply the formula currently being *
      *           used by curve type 'Z' and a new formula for type   *
      *           'Z' is to be introduced.                            *
      *  CAS008 - IAS 39 Enhancements                                 *
      *  208179 - 24x7 Midas Availability                             *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *    21         SETLL Indicator for SDYLDRL1                    *
      *    22         READE Indicator for SDYLDRL0                    *
      *    23         Write/Update Error Indicator                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRChkOthUpd - Check for Update by Another Workstation         *
      * SRInsert - Insert a Yield Rate Detail                         *
      * SRAmend - Amend a Yield Rate Detail                           *
      * SRSavArr - Saves Valid File Fields in Array                   *
      * SRErr - Exception Errors                                      *
      *                                                               *
      * *PSSR - Error Processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
     FSDYLDRL1  IF   E           K DISK
      ** Midas SD Yield Rates Master File Retrieval Index
 
     FSDYLDRL0  UF A E           K DISK    COMMIT
     F                                     RENAME(SDYLDRD0:SDYLDRP0)
      ** Midas SD Yield Rates Master File Update Index
 
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
     D/COPY ZACPYSRC,ERR_ARR1
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
 
      ** Period Years Array
     D PYrAr           S              2  0 DIM(98)
 
      ** Period Month Array
     D PMnAr           S              2  0 DIM(98)
 
      ** Period Days Array
     D PDyAr           S              2  0 DIM(98)
 
      ** Maturity Date Array
     D PMatAr          S              5P 0 DIM(98)
 
      ** Discount Factor Array
     D PDisAr          S             13P 9 DIM(98)
 
      ** Rate Array
     D PRatAr          S             13P 9 DIM(98)
 
     D ChkYLDRFmt    E DS                  EXTNAME(SDVYRATPD)
     D                                     PREFIX(CH)
 
      ** Externally Descibed DS for Valid Yield Rates Detail
     D SDVYRAT       E DS                  EXTNAME(SDVYRATPD)
     D                                     PREFIX(A_)
 
      ** Error Indicators
     D OKYldRate     E DS                  EXTNAME(SDEYRATPD)
 
      ** Externally Described DS for 'BEFORE UPDATE'
     D B_YLDRF       E DS                  EXTNAME(SDYLDRPD)
     D                                     PREFIX(B_)
 
      ** Yield Rates Details File
     D YLDRF         E DS                  EXTNAME(SDYLDRPD)
 
      ** Yield Curves Master File
     D SDYLDC        E DS                  EXTNAME(SDYLDCPD)
     D                                     PREFIX(C_)
 
      ** Data Structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Data Area to Hold Midas Run Date in DDMMMYY Format
     D WMRundate       DS
     D  WMRDay                 1      2  0
     D  WMRMon                 3      5
     D  WMRYr                  6      7  0
 
      ** OVRDBF command for QCMDEXC to run
     D PCommandDS      DS
     D                         1     49    INZ('OVRDBF FILE(SDYLDRBD) TOFILE(+
     D                                          SDYLDRL0) SHARE(*NO)')
 
      ** SD data area                                                                         208179
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     208179
                                                                                              208179
      ** 24X7 status data area                                                                208179
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     208179
                                                                                              208179
      ** Midas API Message Header Format Definition                                           208179
     D APHEAD        E DS                  EXTNAME(APHEADPD)                                  208179
                                                                                              208179
      * Data Structure for SAR Details                                                        208179
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  208179
                                                                                              208179
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for ZARTVJOBA
     D PReturn         S              6A
     D PType           S              1A
 
      ** Parameters for ZAMSGTOOPR
     D PMsgSndRtn      S             10A
     D PDBError        S            132A
     D PDummyMsgID     S                   LIKE(#MsgID)
     D PDummyMsgF      S             10A
 
      ** Parameters for SDYRATRTV
     D PRetCodeOut     S             10A
     D PMode           S              6A
     D PRespMode       S              1A
     D PAction         S              1A
     D PYldCurve       S              5A
     D PYldCcy         S              3A
     D PIntCalc        S              1A
     D PYFreq          S              1A
     D*PSpotDays*******S              2P 0                                             CAS008 CRE026
     D PSpotDays       S              2                                                       CRE026
     D PFrontOfId      S             20A
     D PActionOK       S              1A
     D PYLDCOK         S              1A
     D PYCCYOK         S              1A
     D PYICMOK         S              1A
     D PYFRQOK         S              1A
     D PSPDYOK         S              1A                                                      CAS008
     D Idx             S              3P 0
     D PKYCFQ          S              1A
 
      ** Parameters for Access Objects
     D PRtCd           S              7A
     D POptn           S              7A
 
     D PTimestamp      S             26Z
 
     D WTime           S              6  0
 
      ** Fields used as counters
     D Ctr             S              3  0
     D X               S              3  0
 
      ** Command length for QCMDEXC
     D PCommandLen     S             15P 5 INZ(49)
 
      ** Fields defined for Enhancement CSC011                                                208179
                                                                                              208179
     D CSC011          S              1A                                                      208179
     D TRANSDTL        S           5800A                                                      208179
     D PDealNum        S             18A                                                      208179
     D PADealNo        S             18A                                                      208179
     D PTmestamp       S             26A                                                      208179
     D PSard           S              6A                                                      208179
                                                                                              208179
     D CAS008          S              1A                                                      CAS008
     D WRKPDY          S              2  0                                                    CRE026
     D PISPDY          S              2                                                       CRE026
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Main Processing                                               *
      *                                                               *
      *****************************************************************
 
      ** Ensure transaction has not been updated by another workstation
      ** - if so, bypass updating and return to calling program
 
     C                   EXSR      SRChkOthUpd
 
      ** Access SDYLDRL1 to see if details already exist
 
     C     KYieldR       SETLL     SDYLDRL1                               21
 
      ** If details do not exist write records
 
     C                   IF        *IN21 = *OFF
     C                   EXSR      SRInsert
 
      ** If details exist update file
 
     C                   ELSE
     C                   EXSR      SRAmend
     C                   ENDIF
 
     C                   IF        A_FSCHTP = 'I' or A_FSCHTP = 'A'
 
      ** Access Yield Curves file to get Yield Curve Type
 
     C                   CALLB     'AOYLDCR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY    '    POptn
     C                   PARM                    PYldCurve
     C     SDYLDC        PARM      SDYLDC        DSSDY
 
      ** Database error
 
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBKEY  = PYldCurve
     C                   EVAL      DBFILE = 'SDYLDCPD'
     C                   EVAL      DBASE  = 5
     C                   EXSR      SRErr
     C                   ENDIF
 
      ** If Zero-Coupon, rebuild Yield Rates Discount Factor
      ** Or if Swap Rate                                                                      228390
 
     C                   IF        C_FSYLDT = 'Z'
     C                             OR C_FSYLDT = 'S'                                          228390
 
     C                   CALL      'ZADSFRBL'
     C                   PARM                    PRtCd
     C                   PARM                    A_FSYLDC                                     227577
     C                   PARM                    A_FSYCCY                                     227577
     C                   PARM                    A_FSYICM                                     227577
     C**********         PARM                    FSYLDC                                       227577
     C**********         PARM                    FSYCCY                                       227577
     C**********         PARM                    FSYICM                                       227577
 
     C                   ENDIF
 
     C                   ENDIF
                                                                                              208179
      ** If 24x7 Midas Availability is installed                                              208179
      ** and Support System is active                                                         208179
                                                                                              208179
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         208179
                                                                                              208179
     C                   CALLB     'SDYRATLOG'                                                208179
     C                   PARM      *BLANKS       RetCodeOut                                   208179
     C                   PARM                    SDVYRAT                                      208179
     C                   PARM                    TRANSDTL                                     208179
                                                                                              208179
      ** If there is no error, write the log file                                             208179
                                                                                              208179
     C                   IF        RetCodeOut = *BLANKS                                       208179
                                                                                              208179
     C                   EVAL      APTGTTYPE = 'SDYRAT'                                       208179
     C                   EVAL      APFOTRANID = A_FSFOTR                                      208179
     C                   EVAL      APRPRLOCN  = A_FSRPRL                                      208179
     C                   EVAL      APUSERID   = PSUser                                        208179
     C                   EVAL      APMIDUSR   = PSUser                                        208179
                                                                                              208179
     C                   EVAL      PDealNum = A_FSYLDC + A_FSYCCY + A_FSYICM                  208179
                                                                                              208179
     C                   CALLB     'APLOGTRAN'                                                208179
     C                   PARM      *BLANKS       RetCodeOut                                   208179
     C                   PARM                    APHEAD                                       208179
     C                   PARM                    TRANSDTL                                     208179
     C                   PARM      *BLANKS       PTmestamp                                    208179
     C                   PARM                    PDealNum                                     208179
     C                   PARM      *BLANKS       PADealNo                                     208179
                                                                                              208179
     C                   ENDIF                                                                208179
                                                                                              208179
      ** If there is an error in either log file, end program                                 208179
                                                                                              208179
     C                   IF        RetCodeOut <> *BLANKS                                      208179
     C                   EVAL      ReturnCode = '*ERROR'                                      208179
     C                   ENDIF                                                                208179
                                                                                              208179
     C                   ENDIF                                                                208179
 
      ** Exit from program
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkOthUpd - Check for Update by Another Workstation         *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: ZARTVJOBA, SDYRATRTV, ZAMSGTOOPR                       *
      *                                                               *
      *****************************************************************
 
     C     SRChkOthUpd   BEGSR
 
      ** Determine whether program is running interactively or in batch
      ** (0 = batch  1 = interactive)
 
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    PReturn
     C                   PARM                    PType
 
      ** Allow access to transaction record by Front-Office ID when in Repair
      ** mode for inserts. Set *RTV module  parameter PMode to *FRONT
      ** if the pgm is: a) running in Interactive mode - PType = *ON
      **                b) action code is Insert - 'I'
      **                c) Front-Office Id is NOT Blank.
 
     C                   IF        PType = *ON and
     C                             A_FSCHTP = 'I' and
     C                             A_FSFOTR <> *BLANKS
     C                   EVAL      PMode = '*FRONT'
     C                   ELSE
 
      ** Otherwise, if running in batch use Front-Office ID
      **           (if insert)
      **           else, use Midas Deal Number
 
     C                   IF        PType = *OFF and A_FSCHTP = 'I'
     C                   EVAL      PMode = '*FRONT'
     C                   ELSE
     C                   EVAL      PMode = *BLANKS
     C                   ENDIF
 
     C                   ENDIF
                                                                                              CRE026
      ** Format Spot days to 2A PISPDY to call in SDYRATRTY                                   CRE026
     C                   IF        CAS008 = 'Y'                                               CRE026
     C                   Z-ADD     A_FSSPDY      WRKPDY                                       CRE026
     C                   MOVE      WRKPDY        PISPDY                                       CRE026
     C                   ELSE                                                                 CRE026
     C                   MOVE      *BLANKS       PISPDY                                       CRE026
     C                   ENDIF                                                                CRE026
                                                                                              CRE026
     C                   CALLB     'SDYRATRTV'
 
      ** Inputs
      ** Return Code
 
     C                   PARM      *BLANKS       PRetCodeOut
 
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (not Front Office Transaction Interface)
 
     C                   PARM                    PMode
 
      ** Response Mode
 
     C                   PARM      ' '           PRespMode
 
      ** Action Code
 
     C                   PARM      A_FSCHTP      PAction
 
      ** Yield Curve Name
 
     C                   PARM      A_FSYLDC      PYldCurve
 
      ** Yield Curve Currency
 
     C                   PARM      A_FSYCCY      PYldCcy
 
      ** Interest Calculation Method
 
     C                   PARM      A_FSYICM      PIntCalc
 
      ** Frequency
 
     C                   PARM      A_FSYCFQ      PYFreq
 
      ** Spot Days                                                                            CAS008
                                                                                              CAS008
     C**********         PARM      A_FSSPDY      PSpotDays                             CAS008 CRE026
     C                   PARM      PISPDY        PSpotDays                                    CRE026
                                                                                              CAS008
      ** Front Office Transaction ID
 
     C                   PARM      A_FSFOTR      PFrontOfId
 
      ** Outputs
      ** Transaction Details in File Format
 
     C                   PARM                    ChkYLDRFmt
 
      ** OK - Action Code
 
     C                   PARM      *BLANKS       PActionOK
 
      ** OK - Yield Curve
 
     C                   PARM                    PYLDCOK
 
      ** OK - Yield Curve Currency
 
     C                   PARM                    PYCCYOK
 
      ** OK - Interest Calculation Method
 
     C                   PARM                    PYICMOK
 
      ** OK - Frequency
 
     C                   PARM                    PYFRQOK
 
      ** OK - Spot Days                                                                       CAS008
                                                                                              CAS008
     C                   PARM                    PSPDYOK                                      CAS008
                                                                                              CAS008
      ** Error Fields/Message IDs/Message Data (arrays) from/to Caller
 
     C                   PARM      *BLANKS       FldNameAr2
     C                   PARM      *BLANKS       MsgIdAr2
     C                   PARM      *BLANKS       MsgDtaAr2
 
      ** Array Index (3P0) from/to Caller
 
     C                   PARM      *ZERO         Idx
     C                   PARM      'N'           PKYCFQ
 
      ** Error if Timestamp is not the same (record has been changed
      ** by another workstation)
      ** Processing varies according to mode program is running in.
      ** In interactive mode simply check whether the Timestamp field
      ** has been updated since the original Customer was fetched
      ** by this program.
      ** In batch (API input) check return parameters from Retrieve
      ** module for errors, and send message to system operator.
      ** Interactive mode:
 
     C                   IF        PType = *ON
 
     C                   IF        CHFSTMES <> A_FSTMES
     C                   EVAL      RetCodeIn = '*RECUPD   '
     C                   RETURN
     C                   ENDIF
 
      ** Batch mode:
 
     C                   ELSE
 
     C                   IF        PActionOK = 'N' or PYLDCOK = 'N' or
     C                             PYCCYOK = 'N' or PYICMOK = 'N'
 
     C                   EVAL      RetCodeIn = '*RECUPD   '
     C                   Z-ADD     1             X
 
     C                   DOW       X <= ArrayMax3 and
     C                             FldNameAr2(X) <> *BLANKS
 
     C                   CLEAR                   PDBError
     C                   MOVEL     MsgIdAr2(X)   PDBError
 
     C                   EVAL      PDBerror = 'Update error: ' + PFrontOfId
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    PMsgSndRtn
     C                   PARM                    PDBError
     C                   PARM                    PDummyMsgID
     C                   PARM                    PDummyMsgF
 
     C                   ADD       1             X
 
     C                   ENDDO
 
     C                   RETURN
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInsert - Insert a Yield Rate Detail                         *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: ZAGENTMSTM, SRErr, SRSavArr                            *
      *                                                               *
      *****************************************************************
 
     C     SRInsert      BEGSR
 
      ** DB error when the action code is not 'Insert'
 
     C                   IF        A_FSCHTP <> 'I'
     C                   EVAL      DBKEY  = A_FSYLDC + A_FSYCCY + A_FSYICM
     C                   EVAL      DBFILE = 'SDYLDRPD'
     C                   EVAL      DBASE  = 2
     C                   EXSR      SRErr
     C                   ENDIF
 
      ** Generate Timestamp
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimeStamp
 
      ** Save valid file fields to an array
 
     C                   EXSR      SRSavArr
 
     C                   Z-ADD     1             Ctr
     C                   TIME                    WTime
 
     C                   DOW       Ctr < 99
 
      ** Initialize Yield Rates Detail
 
     C                   CLEAR                   YLDRF
 
      ** Store old fields for comparisons
 
     C                   MOVEL(P)  YLDRF         B_YLDRF
 
     C                   IF        Ctr <> 1 and PYrAr(Ctr) = 0 and
     C                             PDyAr(Ctr) = 0 and PMnAr(Ctr) = 0
     C                   LEAVE
     C                   ELSE
 
      ** Set up fields
 
     C                   EVAL      FSRECI = 'D'
     C                   EVAL      FSYLDC = A_FSYLDC
     C                   EVAL      FSYCCY = A_FSYCCY
     C                   EVAL      FSYICM = A_FSYICM
     C                   EVAL      FSYCFQ = A_FSYCFQ
     C                   IF        CAS008 = 'Y'                                               CAS008
     C                   EVAL      FSSPDY = A_FSSPDY                                          CAS008
     C                   ELSE                                                                 CAS008
     C                   EVAL      FSSPDY = *ZERO                                             CAS008
     C                   ENDIF                                                                CAS008
     C                   EVAL      FSCHTP = A_FSCHTP
     C                   EVAL      FSLUSI = PSUser
     C                   EVAL      FSLCD = BJRDNB
     C                   EVAL      FSTLUP = WTime
     C                   EVAL      FSDLUP = WMRDay
     C                   EVAL      FSMLUP = WMRMon
     C                   EVAL      FSYLUP = WMRYr
     C                   EVAL      FSFRNT = A_FSFOTR
     C                   EVAL      FSREPA = A_FSRPRL
     C                   MOVEL     PTimeStamp    FSTMST
 
     C                   EVAL      FSMMDN = PMatAr(Ctr)
     C                   EVAL      FSPDYR = PYrAr(Ctr)
     C                   EVAL      FSPDMN = PMnAr(Ctr)
     C                   EVAL      FSPDDY = PDyAr(Ctr)
     C                   EVAL      FSYRAT  = PRatAr(Ctr)
     C                   EVAL      FSDSCF  = PDisAr(Ctr)
 
      ** Write new Yield Rate Detail
 
     C                   WRITE     SDYLDRP0                             23
 
     C                   IF        *IN23 = *ON
     C                   EVAL      DBFILE = 'SDYLDRPD'
     C                   EVAL      DBASE = 6
     C                   EXSR      *PSSR
     C                   ELSE
     C                   ADD       1             Ctr
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAmend - Amend a Yield Rate Detail                           *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: ZAGENTMSTM, SRErr, SRSavArr                            *
      *                                                               *
      *****************************************************************
 
     C     SRAmend       BEGSR
 
      ** If Amend
 
     C                   IF        A_FSCHTP = 'A'
 
      ** Save valid file fields to an array
 
     C                   EXSR      SRSavArr
 
      ** Generate Timestamp
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimeStamp
 
     C                   TIME                    WTime
 
     C                   ENDIF
 
      ** Read Yield Rates File
 
     C     KYieldR       SETLL     SDYLDRL0
     C     KYieldR       READE     SDYLDRL0                               22
 
      ** Error if record not found
 
     C                   IF        *IN22 = *ON
     C                   EVAL      DBKEY  = A_FSYLDC + A_FSYCCY + A_FSYICM
     C                   EVAL      DBFILE = 'SDYLDRPD'
     C                   EVAL      DBASE  = 3
     C                   EXSR      SRErr
     C                   ENDIF
 
      ** DB error when the record found is still active and the
      ** action is 'Insert'
 
     C                   IF        (*IN22 = *OFF) and (A_FSRECI = 'D') and
     C                             (A_FSCHTP = 'I')
     C                   EVAL      DBKEY  = A_FSYLDC + A_FSYCCY + A_FSYICM
     C                   EVAL      DBFILE = 'SDYLDRPD'
     C                   EVAL      DBASE  = 4
     C                   EXSR      SRErr
     C                   ENDIF
 
     C                   Z-ADD     1             Ctr
 
     C                   DOW       Ctr < 99
 
     C**********         IF        (PRatAr(Ctr) <> *ZERO and FSYCFQ <> *BLANK)               BUG9328
     C**********                   or (PDisAr(Ctr) <> *ZERO and FSYCFQ = *BLANK)             BUG9328
     C                   IF        (PMatAr(Ctr) <> *ZERO)                                    BUG9328
     C                             and A_FSCHTP <> 'D'                                        CRE026
 
      ** Store old fields for comparisons
 
     C                   MOVEL(P)  YLDRF         B_YLDRF
 
      ** Set up fields
 
     C**********         IF        A_FSCHTP = 'A'                                            BUG9328
     C                   EVAL      FSRECI = 'D'
     C                   EVAL      FSYLDC = A_FSYLDC
     C                   EVAL      FSYCCY = A_FSYCCY
     C                   EVAL      FSYICM = A_FSYICM
     C                   EVAL      FSYCFQ = A_FSYCFQ
     C                   IF        CAS008 = 'Y'                                               CAS008
     C                   EVAL      FSSPDY = A_FSSPDY                                          CAS008
     C                   ELSE                                                                 CAS008
     C                   EVAL      FSSPDY = *ZERO                                             CAS008
     C                   ENDIF                                                                CAS008
     C                   EVAL      FSCHTP = A_FSCHTP
     C                   EVAL      FSLUSI = PSUser
     C                   EVAL      FSLCD = BJRDNB
     C                   EVAL      FSTLUP = WTime
     C                   EVAL      FSDLUP = WMRDay
     C                   EVAL      FSMLUP = WMRMon
     C                   EVAL      FSYLUP = WMRYr
     C                   EVAL      FSFRNT = A_FSFOTR
     C                   EVAL      FSREPA = A_FSRPRL
     C                   MOVEL     PTimeStamp    FSTMST
 
     C                   EVAL      FSMMDN = PMatAr(Ctr)
     C                   EVAL      FSPDYR = PYrAr(Ctr)
     C                   EVAL      FSPDMN = PMnAr(Ctr)
     C                   EVAL      FSPDDY = PDyAr(Ctr)
     C                   EVAL      FSYRAT  = PRatAr(Ctr)
     C                   EVAL      FSDSCF  = PDisAr(Ctr)
 
      ** Write/update file
 
     C                   IF        *IN22 = *ON
     C                   MOVE      '1'           *IN25                                       BUG9328
     C                   WRITE     SDYLDRP0                             23
     C                   ELSE
     C                   UPDATE    SDYLDRP0                             23
     C                   ENDIF
 
     C                   IF        *IN23 = *ON
     C                   EVAL      DBFILE = 'SDYLDRPD'
     C                   EVAL      DBASE = 7
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ELSE
     C                   IF        *IN22 = '0'                                               BUG9328
     C                   DELETE    SDYLDRP0
     C                   ENDIF                                                               BUG9328
     C                   ENDIF
 
     C     KYieldR       READE     SDYLDRL0                               22
     C     *IN25         IFEQ      '1'                                                       BUG9328
     C     KYieldR       READE     SDYLDRL0                               22                 BUG9328
     C                   MOVE      '0'           *IN25                                       BUG9328
     C                   ENDIF                                                               BUG9328
 
     C**********         ENDIF                                                               BUG9328
 
     C                   ADD       1             Ctr
 
     C                   ENDDO
 
     C**********         DOW       *IN22 = *OFF                                              BUG9328
     C**********         DELETE    SDYLDRP0                                                  BUG9328
     C*****KYieldR       READE     SDYLDRL0                               22                 BUG9328
     C**********         ENDDO                                                               BUG9328
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSavArr - Saves Valid File Fields in Array                   *
      *                                                               *
      * Called by: SRInsert, SRAmend                                  *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRSavArr      BEGSR
 
     C                   EVAL      PYrAr(1) = A_FSPDYR01
     C                   EVAL      PYrAr(2) = A_FSPDYR02
     C                   EVAL      PYrAr(3) = A_FSPDYR03
     C                   EVAL      PYrAr(4) = A_FSPDYR04
     C                   EVAL      PYrAr(5) = A_FSPDYR05
     C                   EVAL      PYrAr(6) = A_FSPDYR06
     C                   EVAL      PYrAr(7) = A_FSPDYR07
     C                   EVAL      PYrAr(8) = A_FSPDYR08
     C                   EVAL      PYrAr(9) = A_FSPDYR09
     C                   EVAL      PYrAr(10) = A_FSPDYR10
     C                   EVAL      PYrAr(11) = A_FSPDYR11
     C                   EVAL      PYrAr(12) = A_FSPDYR12
     C                   EVAL      PYrAr(13) = A_FSPDYR13
     C                   EVAL      PYrAr(14) = A_FSPDYR14
     C                   EVAL      PYrAr(15) = A_FSPDYR15
     C                   EVAL      PYrAr(16) = A_FSPDYR16
     C                   EVAL      PYrAr(17) = A_FSPDYR17
     C                   EVAL      PYrAr(18) = A_FSPDYR18
     C                   EVAL      PYrAr(19) = A_FSPDYR19
     C                   EVAL      PYrAr(20) = A_FSPDYR20
     C                   EVAL      PYrAr(21) = A_FSPDYR21
     C                   EVAL      PYrAr(22) = A_FSPDYR22
     C                   EVAL      PYrAr(23) = A_FSPDYR23
     C                   EVAL      PYrAr(24) = A_FSPDYR24
     C                   EVAL      PYrAr(25) = A_FSPDYR25
     C                   EVAL      PYrAr(26) = A_FSPDYR26
     C                   EVAL      PYrAr(27) = A_FSPDYR27
     C                   EVAL      PYrAr(28) = A_FSPDYR28
     C                   EVAL      PYrAr(29) = A_FSPDYR29
     C                   EVAL      PYrAr(30) = A_FSPDYR30
     C                   EVAL      PYrAr(31) = A_FSPDYR31
     C                   EVAL      PYrAr(32) = A_FSPDYR32
     C                   EVAL      PYrAr(33) = A_FSPDYR33
     C                   EVAL      PYrAr(34) = A_FSPDYR34
     C                   EVAL      PYrAr(35) = A_FSPDYR35
     C                   EVAL      PYrAr(36) = A_FSPDYR36
     C                   EVAL      PYrAr(37) = A_FSPDYR37
     C                   EVAL      PYrAr(38) = A_FSPDYR38
     C                   EVAL      PYrAr(39) = A_FSPDYR39
     C                   EVAL      PYrAr(40) = A_FSPDYR40
     C                   EVAL      PYrAr(41) = A_FSPDYR41
     C                   EVAL      PYrAr(42) = A_FSPDYR42
     C                   EVAL      PYrAr(43) = A_FSPDYR43
     C                   EVAL      PYrAr(44) = A_FSPDYR44
     C                   EVAL      PYrAr(45) = A_FSPDYR45
     C                   EVAL      PYrAr(46) = A_FSPDYR46
     C                   EVAL      PYrAr(47) = A_FSPDYR47
     C                   EVAL      PYrAr(48) = A_FSPDYR48
     C                   EVAL      PYrAr(49) = A_FSPDYR49
     C                   EVAL      PYrAr(50) = A_FSPDYR50
     C                   EVAL      PYrAr(51) = A_FSPDYR51
     C                   EVAL      PYrAr(52) = A_FSPDYR52
     C                   EVAL      PYrAr(53) = A_FSPDYR53
     C                   EVAL      PYrAr(54) = A_FSPDYR54
     C                   EVAL      PYrAr(55) = A_FSPDYR55
     C                   EVAL      PYrAr(56) = A_FSPDYR56
     C                   EVAL      PYrAr(57) = A_FSPDYR57
     C                   EVAL      PYrAr(58) = A_FSPDYR58
     C                   EVAL      PYrAr(59) = A_FSPDYR59
     C                   EVAL      PYrAr(60) = A_FSPDYR60
     C                   EVAL      PYrAr(61) = A_FSPDYR61
     C                   EVAL      PYrAr(62) = A_FSPDYR62
     C                   EVAL      PYrAr(63) = A_FSPDYR63
     C                   EVAL      PYrAr(64) = A_FSPDYR64
     C                   EVAL      PYrAr(65) = A_FSPDYR65
     C                   EVAL      PYrAr(66) = A_FSPDYR66
     C                   EVAL      PYrAr(67) = A_FSPDYR67
     C                   EVAL      PYrAr(68) = A_FSPDYR68
     C                   EVAL      PYrAr(69) = A_FSPDYR69
     C                   EVAL      PYrAr(70) = A_FSPDYR70
     C                   EVAL      PYrAr(71) = A_FSPDYR71
     C                   EVAL      PYrAr(72) = A_FSPDYR72
     C                   EVAL      PYrAr(73) = A_FSPDYR73
     C                   EVAL      PYrAr(74) = A_FSPDYR74
     C                   EVAL      PYrAr(75) = A_FSPDYR75
     C                   EVAL      PYrAr(76) = A_FSPDYR76
     C                   EVAL      PYrAr(77) = A_FSPDYR77
     C                   EVAL      PYrAr(78) = A_FSPDYR78
     C                   EVAL      PYrAr(79) = A_FSPDYR79
     C                   EVAL      PYrAr(80) = A_FSPDYR80
     C                   EVAL      PYrAr(81) = A_FSPDYR81
     C                   EVAL      PYrAr(82) = A_FSPDYR82
     C                   EVAL      PYrAr(83) = A_FSPDYR83
     C                   EVAL      PYrAr(84) = A_FSPDYR84
     C                   EVAL      PYrAr(85) = A_FSPDYR85
     C                   EVAL      PYrAr(86) = A_FSPDYR86
     C                   EVAL      PYrAr(87) = A_FSPDYR87
     C                   EVAL      PYrAr(88) = A_FSPDYR88
     C                   EVAL      PYrAr(89) = A_FSPDYR89
     C                   EVAL      PYrAr(90) = A_FSPDYR90
     C                   EVAL      PYrAr(91) = A_FSPDYR91
     C                   EVAL      PYrAr(92) = A_FSPDYR92
     C                   EVAL      PYrAr(93) = A_FSPDYR93
     C                   EVAL      PYrAr(94) = A_FSPDYR94
     C                   EVAL      PYrAr(95) = A_FSPDYR95
     C                   EVAL      PYrAr(96) = A_FSPDYR96
     C                   EVAL      PYrAr(97) = A_FSPDYR97
     C                   EVAL      PYrAr(98) = A_FSPDYR98
 
     C                   EVAL      PMnAr(1) = A_FSPDMN01
     C                   EVAL      PMnAr(2) = A_FSPDMN02
     C                   EVAL      PMnAr(3) = A_FSPDMN03
     C                   EVAL      PMnAr(4) = A_FSPDMN04
     C                   EVAL      PMnAr(5) = A_FSPDMN05
     C                   EVAL      PMnAr(6) = A_FSPDMN06
     C                   EVAL      PMnAr(7) = A_FSPDMN07
     C                   EVAL      PMnAr(8) = A_FSPDMN08
     C                   EVAL      PMnAr(9) = A_FSPDMN09
     C                   EVAL      PMnAr(10) = A_FSPDMN10
     C                   EVAL      PMnAr(11) = A_FSPDMN11
     C                   EVAL      PMnAr(12) = A_FSPDMN12
     C                   EVAL      PMnAr(13) = A_FSPDMN13
     C                   EVAL      PMnAr(14) = A_FSPDMN14
     C                   EVAL      PMnAr(15) = A_FSPDMN15
     C                   EVAL      PMnAr(16) = A_FSPDMN16
     C                   EVAL      PMnAr(17) = A_FSPDMN17
     C                   EVAL      PMnAr(18) = A_FSPDMN18
     C                   EVAL      PMnAr(19) = A_FSPDMN19
     C                   EVAL      PMnAr(20) = A_FSPDMN20
     C                   EVAL      PMnAr(21) = A_FSPDMN21
     C                   EVAL      PMnAr(22) = A_FSPDMN22
     C                   EVAL      PMnAr(23) = A_FSPDMN23
     C                   EVAL      PMnAr(24) = A_FSPDMN24
     C                   EVAL      PMnAr(25) = A_FSPDMN25
     C                   EVAL      PMnAr(26) = A_FSPDMN26
     C                   EVAL      PMnAr(27) = A_FSPDMN27
     C                   EVAL      PMnAr(28) = A_FSPDMN28
     C                   EVAL      PMnAr(29) = A_FSPDMN29
     C                   EVAL      PMnAr(30) = A_FSPDMN30
     C                   EVAL      PMnAr(31) = A_FSPDMN31
     C                   EVAL      PMnAr(32) = A_FSPDMN32
     C                   EVAL      PMnAr(33) = A_FSPDMN33
     C                   EVAL      PMnAr(34) = A_FSPDMN34
     C                   EVAL      PMnAr(35) = A_FSPDMN35
     C                   EVAL      PMnAr(36) = A_FSPDMN36
     C                   EVAL      PMnAr(37) = A_FSPDMN37
     C                   EVAL      PMnAr(38) = A_FSPDMN38
     C                   EVAL      PMnAr(39) = A_FSPDMN39
     C                   EVAL      PMnAr(40) = A_FSPDMN40
     C                   EVAL      PMnAr(41) = A_FSPDMN41
     C                   EVAL      PMnAr(42) = A_FSPDMN42
     C                   EVAL      PMnAr(43) = A_FSPDMN43
     C                   EVAL      PMnAr(44) = A_FSPDMN44
     C                   EVAL      PMnAr(45) = A_FSPDMN45
     C                   EVAL      PMnAr(46) = A_FSPDMN46
     C                   EVAL      PMnAr(47) = A_FSPDMN47
     C                   EVAL      PMnAr(48) = A_FSPDMN48
     C                   EVAL      PMnAr(49) = A_FSPDMN49
     C                   EVAL      PMnAr(50) = A_FSPDMN50
     C                   EVAL      PMnAr(51) = A_FSPDMN51
     C                   EVAL      PMnAr(52) = A_FSPDMN52
     C                   EVAL      PMnAr(53) = A_FSPDMN53
     C                   EVAL      PMnAr(54) = A_FSPDMN54
     C                   EVAL      PMnAr(55) = A_FSPDMN55
     C                   EVAL      PMnAr(56) = A_FSPDMN56
     C                   EVAL      PMnAr(57) = A_FSPDMN57
     C                   EVAL      PMnAr(58) = A_FSPDMN58
     C                   EVAL      PMnAr(59) = A_FSPDMN59
     C                   EVAL      PMnAr(60) = A_FSPDMN60
     C                   EVAL      PMnAr(61) = A_FSPDMN61
     C                   EVAL      PMnAr(62) = A_FSPDMN62
     C                   EVAL      PMnAr(63) = A_FSPDMN63
     C                   EVAL      PMnAr(64) = A_FSPDMN64
     C                   EVAL      PMnAr(65) = A_FSPDMN65
     C                   EVAL      PMnAr(66) = A_FSPDMN66
     C                   EVAL      PMnAr(67) = A_FSPDMN67
     C                   EVAL      PMnAr(68) = A_FSPDMN68
     C                   EVAL      PMnAr(69) = A_FSPDMN69
     C                   EVAL      PMnAr(70) = A_FSPDMN70
     C                   EVAL      PMnAr(71) = A_FSPDMN71
     C                   EVAL      PMnAr(72) = A_FSPDMN72
     C                   EVAL      PMnAr(73) = A_FSPDMN73
     C                   EVAL      PMnAr(74) = A_FSPDMN74
     C                   EVAL      PMnAr(75) = A_FSPDMN75
     C                   EVAL      PMnAr(76) = A_FSPDMN76
     C                   EVAL      PMnAr(77) = A_FSPDMN77
     C                   EVAL      PMnAr(78) = A_FSPDMN78
     C                   EVAL      PMnAr(79) = A_FSPDMN79
     C                   EVAL      PMnAr(80) = A_FSPDMN80
     C                   EVAL      PMnAr(81) = A_FSPDMN81
     C                   EVAL      PMnAr(82) = A_FSPDMN82
     C                   EVAL      PMnAr(83) = A_FSPDMN83
     C                   EVAL      PMnAr(84) = A_FSPDMN84
     C                   EVAL      PMnAr(85) = A_FSPDMN85
     C                   EVAL      PMnAr(86) = A_FSPDMN86
     C                   EVAL      PMnAr(87) = A_FSPDMN87
     C                   EVAL      PMnAr(88) = A_FSPDMN88
     C                   EVAL      PMnAr(89) = A_FSPDMN89
     C                   EVAL      PMnAr(90) = A_FSPDMN90
     C                   EVAL      PMnAr(91) = A_FSPDMN91
     C                   EVAL      PMnAr(92) = A_FSPDMN92
     C                   EVAL      PMnAr(93) = A_FSPDMN93
     C                   EVAL      PMnAr(94) = A_FSPDMN94
     C                   EVAL      PMnAr(95) = A_FSPDMN95
     C                   EVAL      PMnAr(96) = A_FSPDMN96
     C                   EVAL      PMnAr(97) = A_FSPDMN97
     C                   EVAL      PMnAr(98) = A_FSPDMN98
 
     C                   EVAL      PDyAr(1) = A_FSPDDY01
     C                   EVAL      PDyAr(2) = A_FSPDDY02
     C                   EVAL      PDyAr(3) = A_FSPDDY03
     C                   EVAL      PDyAr(4) = A_FSPDDY04
     C                   EVAL      PDyAr(5) = A_FSPDDY05
     C                   EVAL      PDyAr(6) = A_FSPDDY06
     C                   EVAL      PDyAr(7) = A_FSPDDY07
     C                   EVAL      PDyAr(8) = A_FSPDDY08
     C                   EVAL      PDyAr(9) = A_FSPDDY09
     C                   EVAL      PDyAr(10) = A_FSPDDY10
     C                   EVAL      PDyAr(11) = A_FSPDDY11
     C                   EVAL      PDyAr(12) = A_FSPDDY12
     C                   EVAL      PDyAr(13) = A_FSPDDY13
     C                   EVAL      PDyAr(14) = A_FSPDDY14
     C                   EVAL      PDyAr(15) = A_FSPDDY15
     C                   EVAL      PDyAr(16) = A_FSPDDY16
     C                   EVAL      PDyAr(17) = A_FSPDDY17
     C                   EVAL      PDyAr(18) = A_FSPDDY18
     C                   EVAL      PDyAr(19) = A_FSPDDY19
     C                   EVAL      PDyAr(20) = A_FSPDDY20
     C                   EVAL      PDyAr(21) = A_FSPDDY21
     C                   EVAL      PDyAr(22) = A_FSPDDY22
     C                   EVAL      PDyAr(23) = A_FSPDDY23
     C                   EVAL      PDyAr(24) = A_FSPDDY24
     C                   EVAL      PDyAr(25) = A_FSPDDY25
     C                   EVAL      PDyAr(26) = A_FSPDDY26
     C                   EVAL      PDyAr(27) = A_FSPDDY27
     C                   EVAL      PDyAr(28) = A_FSPDDY28
     C                   EVAL      PDyAr(29) = A_FSPDDY29
     C                   EVAL      PDyAr(30) = A_FSPDDY30
     C                   EVAL      PDyAr(31) = A_FSPDDY31
     C                   EVAL      PDyAr(32) = A_FSPDDY32
     C                   EVAL      PDyAr(33) = A_FSPDDY33
     C                   EVAL      PDyAr(34) = A_FSPDDY34
     C                   EVAL      PDyAr(35) = A_FSPDDY35
     C                   EVAL      PDyAr(36) = A_FSPDDY36
     C                   EVAL      PDyAr(37) = A_FSPDDY37
     C                   EVAL      PDyAr(38) = A_FSPDDY38
     C                   EVAL      PDyAr(39) = A_FSPDDY39
     C                   EVAL      PDyAr(40) = A_FSPDDY40
     C                   EVAL      PDyAr(41) = A_FSPDDY41
     C                   EVAL      PDyAr(42) = A_FSPDDY42
     C                   EVAL      PDyAr(43) = A_FSPDDY43
     C                   EVAL      PDyAr(44) = A_FSPDDY44
     C                   EVAL      PDyAr(45) = A_FSPDDY45
     C                   EVAL      PDyAr(46) = A_FSPDDY46
     C                   EVAL      PDyAr(47) = A_FSPDDY47
     C                   EVAL      PDyAr(48) = A_FSPDDY48
     C                   EVAL      PDyAr(49) = A_FSPDDY49
     C                   EVAL      PDyAr(50) = A_FSPDDY50
     C                   EVAL      PDyAr(51) = A_FSPDDY51
     C                   EVAL      PDyAr(52) = A_FSPDDY52
     C                   EVAL      PDyAr(53) = A_FSPDDY53
     C                   EVAL      PDyAr(54) = A_FSPDDY54
     C                   EVAL      PDyAr(55) = A_FSPDDY55
     C                   EVAL      PDyAr(56) = A_FSPDDY56
     C                   EVAL      PDyAr(57) = A_FSPDDY57
     C                   EVAL      PDyAr(58) = A_FSPDDY58
     C                   EVAL      PDyAr(59) = A_FSPDDY59
     C                   EVAL      PDyAr(60) = A_FSPDDY60
     C                   EVAL      PDyAr(61) = A_FSPDDY61
     C                   EVAL      PDyAr(62) = A_FSPDDY62
     C                   EVAL      PDyAr(63) = A_FSPDDY63
     C                   EVAL      PDyAr(64) = A_FSPDDY64
     C                   EVAL      PDyAr(65) = A_FSPDDY65
     C                   EVAL      PDyAr(66) = A_FSPDDY66
     C                   EVAL      PDyAr(67) = A_FSPDDY67
     C                   EVAL      PDyAr(68) = A_FSPDDY68
     C                   EVAL      PDyAr(69) = A_FSPDDY69
     C                   EVAL      PDyAr(70) = A_FSPDDY70
     C                   EVAL      PDyAr(71) = A_FSPDDY71
     C                   EVAL      PDyAr(72) = A_FSPDDY72
     C                   EVAL      PDyAr(73) = A_FSPDDY73
     C                   EVAL      PDyAr(74) = A_FSPDDY74
     C                   EVAL      PDyAr(75) = A_FSPDDY75
     C                   EVAL      PDyAr(76) = A_FSPDDY76
     C                   EVAL      PDyAr(77) = A_FSPDDY77
     C                   EVAL      PDyAr(78) = A_FSPDDY78
     C                   EVAL      PDyAr(79) = A_FSPDDY79
     C                   EVAL      PDyAr(80) = A_FSPDDY80
     C                   EVAL      PDyAr(81) = A_FSPDDY81
     C                   EVAL      PDyAr(82) = A_FSPDDY82
     C                   EVAL      PDyAr(83) = A_FSPDDY83
     C                   EVAL      PDyAr(84) = A_FSPDDY84
     C                   EVAL      PDyAr(85) = A_FSPDDY85
     C                   EVAL      PDyAr(86) = A_FSPDDY86
     C                   EVAL      PDyAr(87) = A_FSPDDY87
     C                   EVAL      PDyAr(88) = A_FSPDDY88
     C                   EVAL      PDyAr(89) = A_FSPDDY89
     C                   EVAL      PDyAr(90) = A_FSPDDY90
     C                   EVAL      PDyAr(91) = A_FSPDDY91
     C                   EVAL      PDyAr(92) = A_FSPDDY92
     C                   EVAL      PDyAr(93) = A_FSPDDY93
     C                   EVAL      PDyAr(94) = A_FSPDDY94
     C                   EVAL      PDyAr(95) = A_FSPDDY95
     C                   EVAL      PDyAr(96) = A_FSPDDY96
     C                   EVAL      PDyAr(97) = A_FSPDDY97
     C                   EVAL      PDyAr(98) = A_FSPDDY98
 
     C                   EVAL      PMatAr(1) = A_FSMMDN01
     C                   EVAL      PMatAr(2) = A_FSMMDN02
     C                   EVAL      PMatAr(3) = A_FSMMDN03
     C                   EVAL      PMatAr(4) = A_FSMMDN04
     C                   EVAL      PMatAr(5) = A_FSMMDN05
     C                   EVAL      PMatAr(6) = A_FSMMDN06
     C                   EVAL      PMatAr(7) = A_FSMMDN07
     C                   EVAL      PMatAr(8) = A_FSMMDN08
     C                   EVAL      PMatAr(9) = A_FSMMDN09
     C                   EVAL      PMatAr(10) = A_FSMMDN10
     C                   EVAL      PMatAr(11) = A_FSMMDN11
     C                   EVAL      PMatAr(12) = A_FSMMDN12
     C                   EVAL      PMatAr(13) = A_FSMMDN13
     C                   EVAL      PMatAr(14) = A_FSMMDN14
     C                   EVAL      PMatAr(15) = A_FSMMDN15
     C                   EVAL      PMatAr(16) = A_FSMMDN16
     C                   EVAL      PMatAr(17) = A_FSMMDN17
     C                   EVAL      PMatAr(18) = A_FSMMDN18
     C                   EVAL      PMatAr(19) = A_FSMMDN19
     C                   EVAL      PMatAr(20) = A_FSMMDN20
     C                   EVAL      PMatAr(21) = A_FSMMDN21
     C                   EVAL      PMatAr(22) = A_FSMMDN22
     C                   EVAL      PMatAr(23) = A_FSMMDN23
     C                   EVAL      PMatAr(24) = A_FSMMDN24
     C                   EVAL      PMatAr(25) = A_FSMMDN25
     C                   EVAL      PMatAr(26) = A_FSMMDN26
     C                   EVAL      PMatAr(27) = A_FSMMDN27
     C                   EVAL      PMatAr(28) = A_FSMMDN28
     C                   EVAL      PMatAr(29) = A_FSMMDN29
     C                   EVAL      PMatAr(30) = A_FSMMDN30
     C                   EVAL      PMatAr(31) = A_FSMMDN31
     C                   EVAL      PMatAr(32) = A_FSMMDN32
     C                   EVAL      PMatAr(33) = A_FSMMDN33
     C                   EVAL      PMatAr(34) = A_FSMMDN34
     C                   EVAL      PMatAr(35) = A_FSMMDN35
     C                   EVAL      PMatAr(36) = A_FSMMDN36
     C                   EVAL      PMatAr(37) = A_FSMMDN37
     C                   EVAL      PMatAr(38) = A_FSMMDN38
     C                   EVAL      PMatAr(39) = A_FSMMDN39
     C                   EVAL      PMatAr(40) = A_FSMMDN40
     C                   EVAL      PMatAr(41) = A_FSMMDN41
     C                   EVAL      PMatAr(42) = A_FSMMDN42
     C                   EVAL      PMatAr(43) = A_FSMMDN43
     C                   EVAL      PMatAr(44) = A_FSMMDN44
     C                   EVAL      PMatAr(45) = A_FSMMDN45
     C                   EVAL      PMatAr(46) = A_FSMMDN46
     C                   EVAL      PMatAr(47) = A_FSMMDN47
     C                   EVAL      PMatAr(48) = A_FSMMDN48
     C                   EVAL      PMatAr(49) = A_FSMMDN49
     C                   EVAL      PMatAr(50) = A_FSMMDN50
     C                   EVAL      PMatAr(51) = A_FSMMDN51
     C                   EVAL      PMatAr(52) = A_FSMMDN52
     C                   EVAL      PMatAr(53) = A_FSMMDN53
     C                   EVAL      PMatAr(54) = A_FSMMDN54
     C                   EVAL      PMatAr(55) = A_FSMMDN55
     C                   EVAL      PMatAr(56) = A_FSMMDN56
     C                   EVAL      PMatAr(57) = A_FSMMDN57
     C                   EVAL      PMatAr(58) = A_FSMMDN58
     C                   EVAL      PMatAr(59) = A_FSMMDN59
     C                   EVAL      PMatAr(60) = A_FSMMDN60
     C                   EVAL      PMatAr(61) = A_FSMMDN61
     C                   EVAL      PMatAr(62) = A_FSMMDN62
     C                   EVAL      PMatAr(63) = A_FSMMDN63
     C                   EVAL      PMatAr(64) = A_FSMMDN64
     C                   EVAL      PMatAr(65) = A_FSMMDN65
     C                   EVAL      PMatAr(66) = A_FSMMDN66
     C                   EVAL      PMatAr(67) = A_FSMMDN67
     C                   EVAL      PMatAr(68) = A_FSMMDN68
     C                   EVAL      PMatAr(69) = A_FSMMDN69
     C                   EVAL      PMatAr(70) = A_FSMMDN70
     C                   EVAL      PMatAr(71) = A_FSMMDN71
     C                   EVAL      PMatAr(72) = A_FSMMDN72
     C                   EVAL      PMatAr(73) = A_FSMMDN73
     C                   EVAL      PMatAr(74) = A_FSMMDN74
     C                   EVAL      PMatAr(75) = A_FSMMDN75
     C                   EVAL      PMatAr(76) = A_FSMMDN76
     C                   EVAL      PMatAr(77) = A_FSMMDN77
     C                   EVAL      PMatAr(78) = A_FSMMDN78
     C                   EVAL      PMatAr(79) = A_FSMMDN79
     C                   EVAL      PMatAr(80) = A_FSMMDN80
     C                   EVAL      PMatAr(81) = A_FSMMDN81
     C                   EVAL      PMatAr(82) = A_FSMMDN82
     C                   EVAL      PMatAr(83) = A_FSMMDN83
     C                   EVAL      PMatAr(84) = A_FSMMDN84
     C                   EVAL      PMatAr(85) = A_FSMMDN85
     C                   EVAL      PMatAr(86) = A_FSMMDN86
     C                   EVAL      PMatAr(87) = A_FSMMDN87
     C                   EVAL      PMatAr(88) = A_FSMMDN88
     C                   EVAL      PMatAr(89) = A_FSMMDN89
     C                   EVAL      PMatAr(90) = A_FSMMDN90
     C                   EVAL      PMatAr(91) = A_FSMMDN91
     C                   EVAL      PMatAr(92) = A_FSMMDN92
     C                   EVAL      PMatAr(93) = A_FSMMDN93
     C                   EVAL      PMatAr(94) = A_FSMMDN94
     C                   EVAL      PMatAr(95) = A_FSMMDN95
     C                   EVAL      PMatAr(96) = A_FSMMDN96
     C                   EVAL      PMatAr(97) = A_FSMMDN97
     C                   EVAL      PMatAr(98) = A_FSMMDN98
 
     C                   EVAL      PDisAr(1) = A_FSDSCF01
     C                   EVAL      PDisAr(2) = A_FSDSCF02
     C                   EVAL      PDisAr(3) = A_FSDSCF03
     C                   EVAL      PDisAr(4) = A_FSDSCF04
     C                   EVAL      PDisAr(5) = A_FSDSCF05
     C                   EVAL      PDisAr(6) = A_FSDSCF06
     C                   EVAL      PDisAr(7) = A_FSDSCF07
     C                   EVAL      PDisAr(8) = A_FSDSCF08
     C                   EVAL      PDisAr(9) = A_FSDSCF09
     C                   EVAL      PDisAr(10) = A_FSDSCF10
     C                   EVAL      PDisAr(11) = A_FSDSCF11
     C                   EVAL      PDisAr(12) = A_FSDSCF12
     C                   EVAL      PDisAr(13) = A_FSDSCF13
     C                   EVAL      PDisAr(14) = A_FSDSCF14
     C                   EVAL      PDisAr(15) = A_FSDSCF15
     C                   EVAL      PDisAr(16) = A_FSDSCF16
     C                   EVAL      PDisAr(17) = A_FSDSCF17
     C                   EVAL      PDisAr(18) = A_FSDSCF18
     C                   EVAL      PDisAr(19) = A_FSDSCF19
     C                   EVAL      PDisAr(20) = A_FSDSCF20
     C                   EVAL      PDisAr(21) = A_FSDSCF21
     C                   EVAL      PDisAr(22) = A_FSDSCF22
     C                   EVAL      PDisAr(23) = A_FSDSCF23
     C                   EVAL      PDisAr(24) = A_FSDSCF24
     C                   EVAL      PDisAr(25) = A_FSDSCF25
     C                   EVAL      PDisAr(26) = A_FSDSCF26
     C                   EVAL      PDisAr(27) = A_FSDSCF27
     C                   EVAL      PDisAr(28) = A_FSDSCF28
     C                   EVAL      PDisAr(29) = A_FSDSCF29
     C                   EVAL      PDisAr(30) = A_FSDSCF30
     C                   EVAL      PDisAr(31) = A_FSDSCF31
     C                   EVAL      PDisAr(32) = A_FSDSCF32
     C                   EVAL      PDisAr(33) = A_FSDSCF33
     C                   EVAL      PDisAr(34) = A_FSDSCF34
     C                   EVAL      PDisAr(35) = A_FSDSCF35
     C                   EVAL      PDisAr(36) = A_FSDSCF36
     C                   EVAL      PDisAr(37) = A_FSDSCF37
     C                   EVAL      PDisAr(38) = A_FSDSCF38
     C                   EVAL      PDisAr(39) = A_FSDSCF39
     C                   EVAL      PDisAr(40) = A_FSDSCF40
     C                   EVAL      PDisAr(41) = A_FSDSCF41
     C                   EVAL      PDisAr(42) = A_FSDSCF42
     C                   EVAL      PDisAr(43) = A_FSDSCF43
     C                   EVAL      PDisAr(44) = A_FSDSCF44
     C                   EVAL      PDisAr(45) = A_FSDSCF45
     C                   EVAL      PDisAr(46) = A_FSDSCF46
     C                   EVAL      PDisAr(47) = A_FSDSCF47
     C                   EVAL      PDisAr(48) = A_FSDSCF48
     C                   EVAL      PDisAr(49) = A_FSDSCF49
     C                   EVAL      PDisAr(50) = A_FSDSCF50
     C                   EVAL      PDisAr(51) = A_FSDSCF51
     C                   EVAL      PDisAr(52) = A_FSDSCF52
     C                   EVAL      PDisAr(53) = A_FSDSCF53
     C                   EVAL      PDisAr(54) = A_FSDSCF54
     C                   EVAL      PDisAr(55) = A_FSDSCF55
     C                   EVAL      PDisAr(56) = A_FSDSCF56
     C                   EVAL      PDisAr(57) = A_FSDSCF57
     C                   EVAL      PDisAr(58) = A_FSDSCF58
     C                   EVAL      PDisAr(59) = A_FSDSCF59
     C                   EVAL      PDisAr(60) = A_FSDSCF60
     C                   EVAL      PDisAr(61) = A_FSDSCF61
     C                   EVAL      PDisAr(62) = A_FSDSCF62
     C                   EVAL      PDisAr(63) = A_FSDSCF63
     C                   EVAL      PDisAr(64) = A_FSDSCF64
     C                   EVAL      PDisAr(65) = A_FSDSCF65
     C                   EVAL      PDisAr(66) = A_FSDSCF66
     C                   EVAL      PDisAr(67) = A_FSDSCF67
     C                   EVAL      PDisAr(68) = A_FSDSCF68
     C                   EVAL      PDisAr(69) = A_FSDSCF69
     C                   EVAL      PDisAr(70) = A_FSDSCF70
     C                   EVAL      PDisAr(71) = A_FSDSCF71
     C                   EVAL      PDisAr(72) = A_FSDSCF72
     C                   EVAL      PDisAr(73) = A_FSDSCF73
     C                   EVAL      PDisAr(74) = A_FSDSCF74
     C                   EVAL      PDisAr(75) = A_FSDSCF75
     C                   EVAL      PDisAr(76) = A_FSDSCF76
     C                   EVAL      PDisAr(77) = A_FSDSCF77
     C                   EVAL      PDisAr(78) = A_FSDSCF78
     C                   EVAL      PDisAr(79) = A_FSDSCF79
     C                   EVAL      PDisAr(80) = A_FSDSCF80
     C                   EVAL      PDisAr(81) = A_FSDSCF81
     C                   EVAL      PDisAr(82) = A_FSDSCF82
     C                   EVAL      PDisAr(83) = A_FSDSCF83
     C                   EVAL      PDisAr(84) = A_FSDSCF84
     C                   EVAL      PDisAr(85) = A_FSDSCF85
     C                   EVAL      PDisAr(86) = A_FSDSCF86
     C                   EVAL      PDisAr(87) = A_FSDSCF87
     C                   EVAL      PDisAr(88) = A_FSDSCF88
     C                   EVAL      PDisAr(89) = A_FSDSCF89
     C                   EVAL      PDisAr(90) = A_FSDSCF90
     C                   EVAL      PDisAr(91) = A_FSDSCF91
     C                   EVAL      PDisAr(92) = A_FSDSCF92
     C                   EVAL      PDisAr(93) = A_FSDSCF93
     C                   EVAL      PDisAr(94) = A_FSDSCF94
     C                   EVAL      PDisAr(95) = A_FSDSCF95
     C                   EVAL      PDisAr(96) = A_FSDSCF96
     C                   EVAL      PDisAr(97) = A_FSDSCF97
     C                   EVAL      PDisAr(98) = A_FSDSCF98
 
     C                   EVAL      PRatAr(1) = A_FSYRAT01
     C                   EVAL      PRatAr(2) = A_FSYRAT02
     C                   EVAL      PRatAr(3) = A_FSYRAT03
     C                   EVAL      PRatAr(4) = A_FSYRAT04
     C                   EVAL      PRatAr(5) = A_FSYRAT05
     C                   EVAL      PRatAr(6) = A_FSYRAT06
     C                   EVAL      PRatAr(7) = A_FSYRAT07
     C                   EVAL      PRatAr(8) = A_FSYRAT08
     C                   EVAL      PRatAr(9) = A_FSYRAT09
     C                   EVAL      PRatAr(10) = A_FSYRAT10
     C                   EVAL      PRatAr(11) = A_FSYRAT11
     C                   EVAL      PRatAr(12) = A_FSYRAT12
     C                   EVAL      PRatAr(13) = A_FSYRAT13
     C                   EVAL      PRatAr(14) = A_FSYRAT14
     C                   EVAL      PRatAr(15) = A_FSYRAT15
     C                   EVAL      PRatAr(16) = A_FSYRAT16
     C                   EVAL      PRatAr(17) = A_FSYRAT17
     C                   EVAL      PRatAr(18) = A_FSYRAT18
     C                   EVAL      PRatAr(19) = A_FSYRAT19
     C                   EVAL      PRatAr(20) = A_FSYRAT20
     C                   EVAL      PRatAr(21) = A_FSYRAT21
     C                   EVAL      PRatAr(22) = A_FSYRAT22
     C                   EVAL      PRatAr(23) = A_FSYRAT23
     C                   EVAL      PRatAr(24) = A_FSYRAT24
     C                   EVAL      PRatAr(25) = A_FSYRAT25
     C                   EVAL      PRatAr(26) = A_FSYRAT26
     C                   EVAL      PRatAr(27) = A_FSYRAT27
     C                   EVAL      PRatAr(28) = A_FSYRAT28
     C                   EVAL      PRatAr(29) = A_FSYRAT29
     C                   EVAL      PRatAr(30) = A_FSYRAT30
     C                   EVAL      PRatAr(31) = A_FSYRAT31
     C                   EVAL      PRatAr(32) = A_FSYRAT32
     C                   EVAL      PRatAr(33) = A_FSYRAT33
     C                   EVAL      PRatAr(34) = A_FSYRAT34
     C                   EVAL      PRatAr(35) = A_FSYRAT35
     C                   EVAL      PRatAr(36) = A_FSYRAT36
     C                   EVAL      PRatAr(37) = A_FSYRAT37
     C                   EVAL      PRatAr(38) = A_FSYRAT38
     C                   EVAL      PRatAr(39) = A_FSYRAT39
     C                   EVAL      PRatAr(40) = A_FSYRAT40
     C                   EVAL      PRatAr(41) = A_FSYRAT41
     C                   EVAL      PRatAr(42) = A_FSYRAT42
     C                   EVAL      PRatAr(43) = A_FSYRAT43
     C                   EVAL      PRatAr(44) = A_FSYRAT44
     C                   EVAL      PRatAr(45) = A_FSYRAT45
     C                   EVAL      PRatAr(46) = A_FSYRAT46
     C                   EVAL      PRatAr(47) = A_FSYRAT47
     C                   EVAL      PRatAr(48) = A_FSYRAT48
     C                   EVAL      PRatAr(49) = A_FSYRAT49
     C                   EVAL      PRatAr(50) = A_FSYRAT50
     C                   EVAL      PRatAr(51) = A_FSYRAT51
     C                   EVAL      PRatAr(52) = A_FSYRAT52
     C                   EVAL      PRatAr(53) = A_FSYRAT53
     C                   EVAL      PRatAr(54) = A_FSYRAT54
     C                   EVAL      PRatAr(55) = A_FSYRAT55
     C                   EVAL      PRatAr(56) = A_FSYRAT56
     C                   EVAL      PRatAr(57) = A_FSYRAT57
     C                   EVAL      PRatAr(58) = A_FSYRAT58
     C                   EVAL      PRatAr(59) = A_FSYRAT59
     C                   EVAL      PRatAr(60) = A_FSYRAT60
     C                   EVAL      PRatAr(61) = A_FSYRAT61
     C                   EVAL      PRatAr(62) = A_FSYRAT62
     C                   EVAL      PRatAr(63) = A_FSYRAT63
     C                   EVAL      PRatAr(64) = A_FSYRAT64
     C                   EVAL      PRatAr(65) = A_FSYRAT65
     C                   EVAL      PRatAr(66) = A_FSYRAT66
     C                   EVAL      PRatAr(67) = A_FSYRAT67
     C                   EVAL      PRatAr(68) = A_FSYRAT68
     C                   EVAL      PRatAr(69) = A_FSYRAT69
     C                   EVAL      PRatAr(70) = A_FSYRAT70
     C                   EVAL      PRatAr(71) = A_FSYRAT71
     C                   EVAL      PRatAr(72) = A_FSYRAT72
     C                   EVAL      PRatAr(73) = A_FSYRAT73
     C                   EVAL      PRatAr(74) = A_FSYRAT74
     C                   EVAL      PRatAr(75) = A_FSYRAT75
     C                   EVAL      PRatAr(76) = A_FSYRAT76
     C                   EVAL      PRatAr(77) = A_FSYRAT77
     C                   EVAL      PRatAr(78) = A_FSYRAT78
     C                   EVAL      PRatAr(79) = A_FSYRAT79
     C                   EVAL      PRatAr(80) = A_FSYRAT80
     C                   EVAL      PRatAr(81) = A_FSYRAT81
     C                   EVAL      PRatAr(82) = A_FSYRAT82
     C                   EVAL      PRatAr(83) = A_FSYRAT83
     C                   EVAL      PRatAr(84) = A_FSYRAT84
     C                   EVAL      PRatAr(85) = A_FSYRAT85
     C                   EVAL      PRatAr(86) = A_FSYRAT86
     C                   EVAL      PRatAr(87) = A_FSYRAT87
     C                   EVAL      PRatAr(88) = A_FSYRAT88
     C                   EVAL      PRatAr(89) = A_FSYRAT89
     C                   EVAL      PRatAr(90) = A_FSYRAT90
     C                   EVAL      PRatAr(91) = A_FSYRAT91
     C                   EVAL      PRatAr(92) = A_FSYRAT92
     C                   EVAL      PRatAr(93) = A_FSYRAT93
     C                   EVAL      PRatAr(94) = A_FSYRAT94
     C                   EVAL      PRatAr(95) = A_FSYRAT95
     C                   EVAL      PRatAr(96) = A_FSYRAT96
     C                   EVAL      PRatAr(97) = A_FSYRAT97
     C                   EVAL      PRatAr(98) = A_FSYRAT98
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOBANKR0, SRErr                                        *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Program Parameters
 
     C     *ENTRY        PLIST
 
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Externally Described DS for Valid Yield Rates Detail
 
     C                   PARM                    SDVYRAT
 
      ** Key lists
 
     C     KYieldR       KLIST
     C                   KFLD                    A_FSYLDC
     C                   KFLD                    A_FSYCCY
     C                   KFLD                    A_FSYICM
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    PRtCd
     C                   PARM      '*FIRST  '    POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBKEY  = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 1
     C                   EXSR      SRErr
     C                   ENDIF
                                                                                              208179
      ** Check if CSC011 is installed                                                         208179
                                                                                              208179
     C                   EVAL      CSC011 = 'N'                                               208179
                                                                                              208179
     C                   CALLB     'AOSARDR0'                                                 208179
     C                   PARM      *BLANKS       PRtCd                                        208179
     C                   PARM      '*VERIFY'     POptn                                        208179
     C                   PARM      'CSC011'      PSard                                        208179
     C     SCSARD        PARM      SCSARD        DSFDY                                        208179
                                                                                              208179
      ** Database error                                                                       208179
                                                                                              208179
     C                   IF        (PRtCd <> *BLANKS) and                                     208179
     C                             (PRtCd <> '*NRF   ')                                       208179
     C                   EVAL      DBKEY = 'CSC011'                                           208179
     C                   EVAL      DBFILE = 'SCSARDPD'                                        208179
     C                   EVAL      DBASE = 8                                                  208179
     C                   EXSR      SRERR                                                      208179
     C                   ENDIF                                                                208179
                                                                                              208179
     C                   IF        PRtCd = *BLANKS                                            208179
     C                   EVAL      CSC011 = 'Y'                                               208179
     C                   IN        SDSTAT                                                     208179
     C                   IN        SC24X7                                                     208179
     C                   ENDIF                                                                208179
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
     C                   EVAL      DBASE = 9                                                  CAS008
     C                   EXSR      *PSSR                                                      CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   IF        PRtCd = *BLANKS                                            CAS008
     C                   EVAL      CAS008 = 'Y'                                               CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
 
     C                   MOVE      BJMRDT        WMRundate
 
      ** Override file used by rebuild program
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCommandDS
     C                   PARM                    PCommandLen
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRErr - Exception Errors                                      *
      *                                                               *
      * Called by: *INZSR, SRInsert, SRAmend                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRErr         BEGSR
 
     C                   EVAL      RetCodeIn = '*ERROR    '
     C                   EVAL      DBPGM = 'SDYRATUPD'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
 
      **  Terminate the program
 
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
