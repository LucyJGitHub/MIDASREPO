     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Function Database Update')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFMPRIUPD - Midas FF Market Prices database Update           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027A            Date 03May06               *
      *                 CAP183  *Create    Date 05Jan06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CSD027A - Conversion of customer number to alpha (post       *
      *            build 103). Recompiled.                            *
      *  CAP183 - Conversion of Market Prices Input into modular      *
      *           structure to use APIs.                              *
      *                                                               *
      *****************************************************************
 
      ** Midas FF Transaction Details Master File
     FPRICS3    UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
     F                                     USROPN
 
      ** Midas FF Transaction Trailer File
     FPRICSA    UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
     F                                     USROPN
 
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
 
      ** Timestamp for the transaction
     D Timestamp       S               Z
 
      ** Rename fields for Timestamp checking
     D PricTSTFmt    E DS                  EXTNAME(PRICSD)
     D                                     PREFIX(T_)
 
      ** Externally desc'd DS for valid transactions Detail
     D V_PRICE       E DS                  EXTNAME(FFVMPRIPD)
     D                                     PREFIX(V_:2)
 
     D OKTrnDets     E DS                  EXTNAME(FFEMPRIPD)
      ** Error indicators
 
      ** Externally described DS for 'BEFORE UPDATE' PRICSD File
     D B_PRICE       E DS                  EXTNAME(PRICSD)
     D                                     PREFIX(B_)
 
      ** Market Prices Details in File Format
     D TranFilFmt    E DS                  EXTNAME(PRICSD)
 
      ** Instrument types
     D InstTypes     E DS                  EXTNAME(INTYPD) PREFIX(IT)
 
      ** Data Structures for use with access programs
 
      ** Data structure for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
      ** Outward parameters
      ** RCD : Midas SD Deleted records file retrieval
     D PBRC            DS          3064
      ** I :  File name
     D    PBFNME               1     10
      ** I :  Long Key
     D    PBLKEY              11     60
      ** I :  Deleted Data Record Pt1
     D    PBDR01              61    310
      ** I :  Deleted Data Record Pt2
     D    PBDR02             311    560
      ** I :  Deleted Data Record Pt3
     D    PBDR03             561    810
      ** I :  Deleted Data Record Pt4
     D    PBDR04             811   1060
      ** I :  Deleted Data Record Pt5
     D    PBDR05            1061   1310
      ** I :  Deleted Data Record Pt6
     D    PBDR06            1311   1560
      ** I :  Deleted Data Record Pt7
     D    PBDR07            1561   1810
      ** I :  Deleted Data Record Pt8
     D    PBDR08            1811   2060
      ** I :  Deleted Data Record Pt9
     D    PBDR09            2061   2310
      ** I :  Deleted Data Record Pt10
     D    PBDR10            2311   2560
      ** I :  Deleted Data Record Pt11
     D    PBDR11            2561   2810
      ** I :  Deleted Data Record Pt12
     D    PBDR12            2811   3060
      ** I :  Last Change Date
     D    PBLCD             3061   3063P 0
      ** I :  Type of Last Change
     D    PBTYLC            3064   3064
 
      ** Months Short Names
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)
 
      ** DS for market prices key
     D PRTRNN          DS
     D  PRISTT                 1      5
     D  PRMRKT                 1      2
     D  PRISTC                 3      5
     D  PRMTHN                 6      8
     D  PRYRNO                 9     10
     D  PRPCAL                11     11
     D  PRSTRP                12     27
 
     D WPrice          DS
     D  wISTT                         5A
     D  wMTHN                         2S 0
     D  wYRNO                         2S 0
     D  wPCAL                         1A
     D  wSTRP                        15P 8
 
     D @Timestamp      S             26Z
 
      ** Account sequence field (packed) for call to CLINTSE
     D WKACSN          S              2P 0
 
      ** Index for the warning arrays
     D WIdx            S              3P 0
 
     D PPRSTRP         S             15P 8
 
      ** Flags
     D POTCFlag        S              1A
 
      ** Next available transaction number
     D NATN            S              5P 0
 
     D OKTrans         S             16A
 
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main processing                                        *
      *                                                               *
      *****************************************************************
 
      ** Ensure transaction has not been updated by another workstation
      ** - if so, bypass updating and return to calling program.
     C                   EXSR      CHKOTHUPD
 
     C                   IF        @@RTCD <> *BLANKS
     C                   GOTO      EXIT
     C                   ENDIF
 
      ** Insert, Amend or Delete the transaction
     C     V_CHTP        CASEQ     'I'           SRInsert
     C     V_CHTP        CASEQ     'A'           SRAmend
     C     V_CHTP        CASEQ     'D'           SRDelete
     C                   ENDCS
 
      ** Update Trailer File
     C                   EXSR      SRUpdTrail
 
      ** Exit From Program
     C     EXIT          TAG
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      **  Program Parameters
     C     *ENTRY        PLIST
 
      ** Return Code
     C                   PARM                    @@RTCD            7
 
      ** Externally described DS for valid Transaction Detail
     C                   PARM                    V_PRICE
      ** OTC Flag
     C                   PARM                    POTCFlag
 
      *
     C                   OPEN      PRICS3
     C                   OPEN      PRICSA
      *
      ** Access Bank Details
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
     C                   IF        @RTCD <> *BLANK
     C                   EVAL      DBKEY  = '*FIRST  '
     C                   EVAL      DBFILE = 'SDBANKPD'                          *************
     C                   EVAL      DBASE  = 001                                 * DBERR 001 *
     C                   EXSR      *PSSR                                        *************
     C                   ENDIF
 
      ** Determine whether program is running interactively or in batch
      ** ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @Return           6
     C                   PARM                    @Type             1
      *
      ** Allow access to transaction record by Front-Office ID when in Repair
      ** mode for inserts . Set  *RTV module  parameter @@MODE  to   *FRONT
      ** if the pgm is:  a) running in Interactive mode - @Type= 1   ~~~~~~
      **                 b) action code is Insert - 'I'
      **                 c) Front-Office Id is NOT Blank
     C                   IF        @Type = '1' AND
     C                             V_CHTP  = 'I' AND
     C                             V_FRNT <> *BLANKS
      *
     C                   EVAL      @@MODE = '*FRONT'
      *
     C                   ELSE
      *
      ** Otherwise, if running in batch use Front-Office ID
      ** (if insert) else, use Midas Deal Number
     C                   IF        @Type = '0' AND
     C                             V_CHTP = 'I'
     C                   EVAL      @@MODE = '*FRONT'
     C                   ELSE
     C                   EVAL      @@MODE = *BLANKS
     C                   ENDIF
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDIF
 
     C     KPrice        KLIST
     C                   KFLD                    V_ISTT
     C                   KFLD                    V_YRNO
     C                   KFLD                    V_MTHN
     C                   KFLD                    V_PCAL
     C                   KFLD                    V_STRP
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CHKOTHUPD - Check for update by another workstation           *
      *                                                               *
      *****************************************************************
     C     CHKOTHUPD     BEGSR
 
     C                   MOVE      V_ISTT        PRISTT
     C                   MOVE      V_YRNO        PRYRNO
     C                   IF        V_MTHN > 0
     C                   EVAL      PRMTHN = ZMNM(V_MTHN)
     C                   ELSE
     C                   EVAL      PRMTHN = *BLANKS
     C                   ENDIF
     C                   MOVE      V_PCAL        PRPCAL
     C                   MOVE      *BLANKS       PRSTRP
     C                   EVAL      PPRSTRP = V_STRP
     C                   CLEAR                   InstTypes
     C                   CLEAR                   PricTSTFmt
 
     C                   CALLB     'FFMPRIRTV'
      ** Inputs
      *
      ** Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    @@MODE            6
 
      ** Response mode
     C                   PARM      ' '           @@RSMD            1
 
      ** Action Code
     C                   PARM      V_CHTP        ACTN              1
 
      ** Front Office Transaction ID
     C                   PARM      V_FRNT        FOTRID           20
      *
      ** Transaction key fields in alphanumeric
     C                   PARM                    PRTRNN
 
      ** U = from update to check timestamp of record
 
     C                   PARM      'U'           PSCRN             1
 
      ** OTC Flag
     C                   PARM                    POTCFlag
 
      ** Transaction Details in File Format
     C                   PARM                    PricTSTFmt
 
      ** OK - Transaction Details
     C                   PARM                    OKTrnDets
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *BLANK        FldNameArr
     C                   PARM      *BLANK        MsgIdArr
     C                   PARM      *BLANK        MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM      *ZERO         Ix                3 0
 
      ** Warning
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      ** Market Name
     C                   PARM                    PMKTN            20
 
      ** Business Date in 99MON99 format
     C                   PARM                    PBUSD             7
 
      ** Valid instrument types
     C                   PARM                    InstTypes
 
      ** Numeric strike price
     C                   PARM                    PPRSTRP
      *
      ** Error if Timestamp is not the same (record has been changed
      **  by another workstation)
 
      ** Processing varies according to mode program is running in.
      ** In interacive mode simply check whether the timestamp field
      ** has been updated since the original Customer was fetched
      ** by this program.
      ** In batch (API input) check return parameters from Retrieve
      ** module for errors, and send message to system operator.
 
      ** Interactive mode:
     C                   IF        @TYPE = '1'
 
     C                   IF        T_TMST <> V_TMST
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   ENDIF
 
      ** Batch mode:
     C                   ELSE
     C                   EVAL      OKTrans = OKTrnDets
     C                   IF        %SCAN('N':OKTrans) <> 0
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   Z-ADD     1             C                 2 0
 
     C                   DOW       C < ArrayMax AND
     C                             FldNameArr(C) <> *BLANKS
     C                   CLEAR                   DBError         132
     C                   EVAL      DBerror = 'Update error: ' + FOTRID
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
     C                   ADD       1             C
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRInsert - Insert a transaction                              *
      *                                                              *
      ****************************************************************
     C     SRInsert      BEGSR
 
      ** Access Transaction Details
     C     KPrice        CHAIN     PRICS3                             99
 
      ** Database error
     C                   IF        *IN99 = *OFF
     C                             AND RECI <> '*'
     C                   EVAL      wISTT  = ISTT
     C                   EVAL      wYRNO  = YRNO
     C                   EVAL      wMTHN  = MTHN
     C                   EVAL      wPCAL  = PCAL
     C                   EVAL      wSTRP  = STRP
     C                   EVAL      DBKEY  = WPrice
     C                   EVAL      DBFILE = 'PRICS'                             ************
     C                   EVAL      DBASE  =  002                                * DBERR 002*
     C                   EXSR      *PSSR                                        ************
     C                   ENDIF
 
      ** Initialise Transaction Detail
     C                   CLEAR                   B_PRICE
 
      ** Store Old fields for comparisons
     C                   MOVEL(P)  TranFilFmt    B_PRICE
 
      ** Set Transaction fields on insert
     C                   EVAL      ISTT = V_ISTT
     C                   EVAL      YRNO = V_YRNO
     C                   EVAL      MTHN = V_MTHN
     C                   EVAL      PCAL = V_PCAL
     C                   EVAL      STRP = V_STRP
     C                   EVAL      NEWP = V_NEWP
     C                   EVAL      PLEC = *ZERO
     C                   EVAL      PBEC = *ZERO
     C                   EVAL      PRSM = *ZERO
     C                   EVAL      RSKF = V_RSKF
     C                   EVAL      LCD  = BJRDNB
     C                   EVAL      CHTP = 'I'
     C                   EXSR      SRRtvTNLU
     C                   EVAL      TNLU = NATN
 
      ** Front Office ID
     C                   EVAL      FRNT = V_FRNT
 
      ** Associated Front Office ID
     C                   EVAL      AFRT = V_AFRT
 
      ** Repair Location
     C                   EVAL      REPA = V_REPA
 
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
     C                   EVAL      TMST = TimeStamp
 
      ** Override record when previously deleted
     C                   IF        RECI = '*'
     C                   EVAL      RECI = 'D'
     C                   UPDATE    PRICSDF
     C                   ELSE
      ** Write new Transaction Detail
     C                   EVAL      RECI = 'D'
     C                   WRITE     PRICSDF
     C                   ENDIF
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRAmend  - Amend a transaction                               *
      *                                                              *
      ****************************************************************
     C     SRAmend       BEGSR
 
      ** Access Transaction Detail record
     C     KPrice        CHAIN     PRICS3                             99
 
      ** Database error
     C                   IF        *IN99 = *ON
     C                   EVAL      wISTT  = ISTT
     C                   EVAL      wYRNO  = YRNO
     C                   EVAL      wMTHN  = MTHN
     C                   EVAL      wPCAL  = PCAL
     C                   EVAL      wSTRP  = STRP
     C                   EVAL      DBKEY  = WPrice
     C                   EVAL      DBFILE = 'PRICSD'                            ************
     C                   EVAL      DBASE  =  003                                * DBERR 003*
     C                   EXSR      *PSSR                                        ************
     C                   ENDIF
 
      ** Update 'BEFORE' status
     C                   MOVEL(P)  TranFilFmt    B_PRICE
 
      ** Set Transaction Detail fields on amend
     C                   EVAL      ISTT = V_ISTT
     C                   EVAL      YRNO = V_YRNO
     C                   EVAL      MTHN = V_MTHN
     C                   EVAL      PCAL = V_PCAL
     C                   EVAL      STRP = V_STRP
     C                   EVAL      NEWP = V_NEWP
     C                   EVAL      RSKF = V_RSKF
     C                   EVAL      LCD  = BJRDNB
     C                   EVAL      CHTP = V_CHTP
     C                   EXSR      SRRtvTNLU
     C                   EVAL      TNLU = NATN
 
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   EVAL      TMST = TimeStamp
 
      ** Front Office ID
     C                   EVAL      FRNT = V_FRNT
 
      ** Associated Front Office ID
     C                   EVAL      AFRT = V_AFRT
 
      *
      ** Update Record
     C                   UPDATE    PRICSDF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRDelete - Delete a transaction                              *
      *                                                              *
      ****************************************************************
     C     SRDelete      BEGSR
 
      ** Access Transaction Details
     C     KPrice        CHAIN     PRICS3                             99
 
      ** Database error
     C                   IF        *IN99 = *ON
     C                   EVAL      wISTT  = V_ISTT
     C                   EVAL      wYRNO  = V_YRNO
     C                   EVAL      wMTHN  = V_MTHN
     C                   EVAL      wPCAL  = V_PCAL
     C                   EVAL      wSTRP  = V_STRP
     C                   EVAL      DBKEY  = WPrice
     C                   EVAL      DBFILE = 'PRICSD'                            ************
     C                   EVAL      DBASE  = 004                                 * DBERR 004*
     C                   EXSR      *PSSR                                        ************
     C                   ENDIF
 
      ** Update 'BEFORE' status
     C                   MOVEL(P)  TranFilFmt    B_PRICE
 
      ** Update record to change record id to '*' for deleted records
     C                   EVAL      RECI = '*'
     C                   EVAL      LCD  = BJRDNB
     C                   EVAL      CHTP = V_CHTP
     C                   UPDATE    PRICSDF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRRtvTNLU - Retrieve value for TNLU                          *
      *                                                              *
      ****************************************************************
     C     SRRtvTNLU     BEGSR
 
     C                   RESET                   ReturnCode
     C                   CALLB     'ZTNLU1'
     C                   PARM                    ReturnCode
     C                   PARM                    NATN
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRUpdTrail - Update Trailer File                             *
      *                                                              *
      ****************************************************************
     C     SRUpdTrail    BEGSR
 
     C                   READ      PRICSAF                                99
     C     *IN99         IFEQ      '0'
     C     V_CHTP        IFEQ      'I'
     C                   ADD       1             NORE
     C                   ADD       1             NINS
     C                   ELSE
 
      **   For Amend
     C     V_CHTP        IFEQ      'A'
     C     B_LCD         IFNE      LCD
     C                   ADD       1             NAMD
     C                   END
     C                   ELSE
      **   For Delete
     C                   SUB       1             NORE
     C                   ADD       1             NDEL
 
     C     B_LCD         IFEQ      LCD
 
     C     B_CHTP        IFEQ      'I'
     C                   SUB       1             NINS
     C                   END
 
     C     B_CHTP        IFEQ      'A'
     C                   SUB       1             NAMD
     C                   END
     C                   END
     C                   END
     C                   END
 
     C                   ENDIF
 
      **   Update audit record
     C                   UPDATE    PRICSAF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
