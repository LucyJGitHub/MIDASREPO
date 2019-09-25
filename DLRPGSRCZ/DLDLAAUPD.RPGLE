     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('DL Adjustment Accrued Interest Database Update')       *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLDLAAUPD - Adjustment to Accrued Interest Database Update   *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 MD022302           Date 09Sep13               *
      *                 AR1044820          Date 17Jul13               *
      *                 AR1096788          Date 18Mar13               *
      *                 AR1005423          Date 28Sep12               *
      *                 AR916823           Date 28Sep12               *
      *                 AR740564           Date 28Sep12               *
      *                 260696             Date 28Sep12               *
      *                 256960D            Date 28Sep12               *
      *                 CAP210   *CREATE   Date 28Sep12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  MD022302 - Introduced missing parameter when calling program *
      *             AOOUMMU0                                          *
      *  AR1044820 - Incorrect projected movements for Adjustment to  *
      *              Accrued Interest. If RCDT = 'C', call AOOUMMU0   *
      *              to project the Interest Adjustment, while adding *
      *              parameters BeDealsDtlC, AfDealsDtlC, and CALLER  *
      *              for AOOUMMU0. (Child: AR1044821)                 *
      *  AR1096788 - DLAA details should be written in core STRANF    *
      *              file instead of the new DLSTRANFPD file          *
      *  AR1005423- Cannot open more than 3300 RE a/cs due to STRAN.  *
      *             Amend program to set RECI to 'F' if insert of     *
      *             record is done. (Child: AR1005425)                *
      *  AR916823 - MT202 was not generated after an Interest         *
      *             Adjustment. Set Confirmation and Pay/Rcv          *
      *             indicators in DTRIXDD. (Child: AR916824)          *
      *  AR740564 - No projection for IRS. Update file RSACMTPD to    *
      *             have a projection in PAMV. (Child: AR740565)      *
      *  260696 - Invalid Account Update via API                      *
      *  256960D - Real-time Projection on Process Account Movements  *
      *  CAP210 - Adjustment to Accrued Interests API                 *
      *                                                               *
      *****************************************************************
      *
     FDEALS     UF   E           K DISK    COMMIT
      *
      ** Midas AI Transaction Details Master File
      *
     F***DLSTRANULLUF A E           K DISK    COMMIT                                       AR1096788
     FSTRANH    UF   E             DISK    COMMIT                                          AR1096788
     F                                     RECNO(A#RRN)                                    AR1096788
      ** Midas GL STRAN Header File                                                        AR1096788
      *                                                                                    AR1096788
     FSTRANF    UF   E             DISK    COMMIT                                          AR1096788
     F                                     RECNO(A#RRN)                                    AR1096788
      ** Midas GL STRAN Record ID 'F' - Dealing                                            AR1096788
      *                                                                                    AR1096788
     FSTRANFL0  UF   E           K DISK    COMMIT                                          AR1096788
     F                                     RENAME(STRANFF:STRANF0)                         AR1096788
      ** Midas GL STRAN Record ID 'F' - by Trans ID                                        AR1096788
      *                                                                                    AR1096788
     FMMDEAULL  IF   E           K DISK                                                    AR1044820
     F                                     INCLUDE(MMDELDP0)                               AR1044820
      *                                                                                    AR1044820
     FSDTIX     UF A E           K DISK    COMMIT                                           AR916823
     F                                     PREFIX(DX)                                       AR916823
      *                                                                                     AR916823
      *****************************************************************
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------

      **---------------------------------------------------------------

      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+

      *****************************************************************

      ** data structure for zalign
0082 D ZA1             S              1    DIM(16)
0083 D ZA2             S              1    DIM(16)

      ** Timestamp for the transaction
     D TimeStamp       S               Z

     D*ChkDlaaFmt    E DS                  EXTNAME(DLSTRANFPD)                             AR1096788
     D ChkDlaaFmt    E DS                  EXTNAME(STRANF)                                 AR1096788
     D                                     PREFIX(CH)
      ** Externally desc'd DS for valid transactions Detail
      ** Rename fields for Timestamp checking
     D DLVDLAA       E DS                  EXTNAME(DLVDLAAPD)
     D                                     PREFIX(A_)
      ** Error indicators
     D OKTrnDets     E DS                  EXTNAME(DLEDLAAPD)
      ****Externally*described*DS*for*'BEFORE*UPDATE'*DLSTRANFPD*******                    AR1096788
      **  Externally described DS for 'BEFORE UPDATE' STRANF                               AR1096788
     D*B_DLAAF       E DS                  EXTNAME(DLSTRANFPD)                             AR1096788
     D B_DLAAF       E DS                  EXTNAME(STRANF)                                 AR1096788
     D                                     PREFIX(B_)
      **  Transaction Details File
     D*DLAAF         E DS                  EXTNAME(DLSTRANFPD)                             AR1096788
     D DLAAF         E DS                  EXTNAME(STRANF)                                 AR1096788
      ** Data Structures for use with access programs
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data structure for currency details
     D @CURR         E DS                  EXTNAME(SDCURRPD)
      ** Data structure for bank details
     D @MMOD         E DS                  EXTNAME(SDMMODPD)
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Data structure for Midas MM Loans and Depst Stamp Tax Ext Dfn                      MD022302
     D DLDLQD        E DS                  EXTNAME(DLSTMPPD)                                MD022302
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A

     D VFMAAM          S                   LIKE(MAAM)
     D VFSIGN          S                   LIKE(SIGN)
     D VFINIRS         S                   LIKE(INIRS)
     D VFUSIT          S                   LIKE(USIT)
     D VFUSGN          S                   LIKE(FLUSGN)
     D VFAACF          S                   LIKE(AACF)
     D VFFSGN          S                   LIKE(FSGN)
     D DETLDC        E DS                  EXTNAME(DEALSDC)                                AR1044820
     D RECI1         E                     EXTFLD(RECI)                                    AR1044820
     D DLNO1         E                     EXTFLD(DLNO)                                    AR1044820
     D CNUM1         E                     EXTFLD(CNUM)                                    AR1044820
     D BRCA1         E                     EXTFLD(BRCA)                                    AR1044820
     D DTYP1         E                     EXTFLD(DTYP)                                    AR1044820
     D CCY1          E                     EXTFLD(CCY)                                     AR1044820
     D LCD1          E                     EXTFLD(LCD)                                     AR1044820
     D TNLU1         E                     EXTFLD(TNLU)                                    AR1044820
     D FSGN1         E                     EXTFLD(FSGN)                                    AR1044820
     D BeDealsDtlC   E DS                  EXTNAME(DEALSDC)                                AR1044820
     D                                     PREFIX(BE_)                                     AR1044820
     D AfDealsDtlC   E DS                  EXTNAME(DEALSDC)                                AR1044820
     D                                     PREFIX(AF_)                                     AR1044820
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
      *
     D WUDELR          DS          3000
     D    WUDR01               1    250
     D    WUDR02             251    500
     D    WUDR03             501    750
     D    WUDR04             751   1000
     D    WUDR05            1001   1250
     D    WUDR06            1251   1500
     D    WUDR07            1501   1750
     D    WUDR08            1751   2000
     D    WUDR09            2001   2250
     D    WUDR10            2251   2500
     D    WUDR11            2501   2750
     D    WUDR12            2751   3000
      *
      **  Data Structure to update last transaction number
      *
     D DNATN           DS             6
     D  FNATN                  1      6  0
      *
     D ##ACCT          DS            18                                                     AR740564
     D ##NOSN                  1      2                                                     AR740564
     D ##ACNO                  1     10                                                     AR740564
     D ##CNUM                  1      6                                                     AR740564
     D ##ACOD                  7     16                                                     AR740564
     D ##ACSQ                 17     18                                                     AR740564
      *                                                                                     AR740564
      ** DS for Settlement Account                                                          AR740564
      *                                                                                     AR740564
     D C#DTA           DS           256                                                     AR740564
     D C#ATYP                  1      1                                                     AR740564
     D C#ACCT                  2     19                                                     AR740564
     D C#CNU1                  2      7                                                     AR740564
     D C#CCY1                  8     10                                                     AR740564
     D C#ACS1                 15     16  0                                                  AR740564
     D C#BRC1                 17     19                                                     AR740564
     D C#NOSN                  2      3  0                                                  AR740564
     D C#NOS                   2      6                                                     AR740564
     D C#ACNO                  2     11  0                                                  AR740564
     D C#CNUM                  2      7                                                     AR740564
     D C#ACSQ                 12     13  0                                                  AR740564
     D C#BRCA                 14     16                                                     AR740564
     D C#IO                   24     24                                                     AR740564
     D C#CCY                  25     27                                                     AR740564
     D C#TRYP                 28     29                                                     AR740564
     D C#NARR                 30     59                                                     AR740564
     D C#CHQN                 60     67  0                                                  AR740564
     D C#PREF                 68     82                                                     AR740564
     D C#TRN                  83     88                                                     AR740564
     D C#AMT                  89     96P 0                                                  AR740564
     D C#PRON                 97     97                                                     AR740564
     D C#OLPS                 98     98                                                     AR740564
     D C#MEMS                 99     99                                                     AR740564
     D C#RSAC                100    100                                                     AR740564
     D C#MOD                 101    102                                                     AR740564
     D C#OLRC                103    104                                                     AR740564
     D C#FTOV                105    105                                                     AR740564
     D C#VDAT                106    108P 0                                                  AR740564
     D C#PSTD                109    111P 0                                                  AR740564
     D C#PSTO                112    112                                                     AR740564
     D C#RPST                113    113                                                     AR740564
     D C#RPNB                114    116  0                                                  AR740564
     D C#RTYP                117    117                                                     AR740564
     D C#BBRN                118    120                                                     AR740564
     D C#ACO1                121    130  0                                                  AR740564
     D C#ACOD                131    140  0                                                  AR740564
      *                                                                                     AR740564
      ** DS for AOSPOSU0                                                                    AR740564
      *                                                                                     AR740564
     D @Timestamp      S             26Z
      ** Account sequence field (packed) for call to CLINTSE
     D WKACSN          S              2P 0
      ** Account sequence field (packed) for call to CLINTSE
     D BLK16           S             16A
      *
     D CIR002          S              1A
     D CIR006          S              1A
     D CDL006          S              1A                                                    AR916823
     D EffSetCcy       S              3A                                                    AR916823
     D @@CNRQ          S              1A                                                    AR916823
     D @CCY            S              3A                                                    AR916823
     D @NOSTR          S              2A                                                    AR916823
     D @@PRI1          S              1  0                                                  AR916823
     D @@PRI2          S              1  0                                                  AR916823
     D @@PRI3          S              1  0                                                  AR916823
     D @TLXDU          S              5  0                                                  AR916823
      *                                                                                     AR916823
     D                 DS                                                                   AR916823
      **  Time data structure for DTRIX                                                     AR916823
     D  @XTIME                 1      6  0                                                  AR916823
     D  DXTIM                  1      4  0                                                  AR916823
      *
     D MMDELD        E DS                  EXTNAME(MMDELDPP)                               AR1044820
     D QQDOR1        E                     EXTFLD(QQDORI)                                  AR1044820
     D QQMOR1        E                     EXTFLD(QQMORI)                                  AR1044820
     D QQDOP1        E                     EXTFLD(QQDOPI)                                  AR1044820
     D QQMOP1        E                     EXTFLD(QQMOPI)                                  AR1044820
     D QQRON1        E                     EXTFLD(QQRONS)                                  AR1044820
     D QQPON1        E                     EXTFLD(QQPONS)                                  AR1044820
     D QQINS1        E                     EXTFLD(QQINSA)                                  AR1044820
      *                                                                                    AR1044820
     D Z#BSTS        E DS                  EXTNAME(Z#BST)                                  AR1044820
     D Z#ASTS        E DS                  EXTNAME(Z#AST)                                  AR1044820
     D Z#WSTS        E DS                  EXTNAME(Z#WST)                                  AR1044820
      *                                                                                    AR1044820
      ** File - Payment Further Settlement Instructions                                    AR1044820
      *                                                                                    AR1044820
     D PFPAYF        E DS                  EXTNAME(SDFSFPPD)                               AR1044820
      *                                                                                    AR1044820
      ** File - Receive Further Settlement Instructions                                    AR1044820
      *                                                                                    AR1044820
     D PFRECF        E DS                  EXTNAME(SDFSFRPD)                               AR1044820
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - MAIN BODY                                              *
      *                                                               *
      *****************************************************************
      *
      ** Ensure transaction has not been updated by another workstation
      ** - if so, bypass updating and return to calling program.
      *
     C                   EXSR      CHKOTHUPD
      *
     C                   IF        @@RTCD <> *BLANKS
     C                   GOTO      EXIT
     C                   ENDIF
      *
     C                   MOVE      *BLANK        UPDBEF            1                       AR1044820
     C                   MOVE      *BLANK        UPDAFT            1                       AR1044820
     C                   CLEAR                   BeDealsDtlC                               AR1044820
     C                   CLEAR                   AfDealsDtlC                               AR1044820
      *                                                                                    AR1044820
      ** Insert, Amend or Delete the Customet
      *
     C     A_VFTYLC      CASEQ     'I'           INSERT
     C     A_VFTYLC      CASEQ     'A'           AMEND
     C     A_VFTYLC      CASEQ     'D'           DELETE
     C                   ENDCS
      *
      ** Exit From Program
      *
     C     EXIT          TAG
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CHKOTHUPD - Check for update by another workstation           *
      *                                                               *
      *****************************************************************
     C     CHKOTHUPD     BEGSR
      *
      ** Retrieve current Customer details
      *
     C                   MOVE      A_VFTRNN      MidasTrNum        6
      *
      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)
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
      *
     C                   IF        @Type = '1' AND
     C                             A_VFTYLC = 'I' AND
     C                             A_VFFRNT <> *BLANKS
      *
     C                   EVAL      @@MODE = '*FRONT'
      *
     C                   ELSE
      *
      ** Otherwise, if running in batch use Front-Office ID
      **            (if insert)
      **            else, use Midas Deal Number
      *
     C                   IF        @Type = '0' AND
     C                             A_VFTYLC = 'I'
     C                   EVAL      @@MODE = '*FRONT'
     C                   ELSE
     C                   EVAL      @@MODE = *BLANKS
     C                   ENDIF
      *
     C                   ENDIF


     C                   CALLB     'DLDLAARTV'
      *
      ** Inputs
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
     C                   PARM      A_VFTYLC      ACTN              1
      ** Front Office Transaction ID
     C                   PARM      A_VFFRNT      FOTRID           20
      ** Midas Transaction Number
     C                   PARM                    MidasTrNum        6
      *
      ** Outputs
      *
      ** Transaction Details in File Format
     C                   PARM                    ChkDlaaFmt
      ** OK - Action code
     C                   PARM      *BLANK        DDACTNOK          1
      ** OK - Transaction Number
     C                   PARM                    DDTRNNOK          1
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *BLANK        FldNameArr
     C                   PARM      *BLANK        MsgIdArr
     C                   PARM      *BLANK        MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM      *ZERO         Ix                3 0
      *
      ** Error if Timestamp is not the same (record has been changed
      **  by another workstation)
      *
      ** Processing varies according to mode program is running in.
      ** In interacive mode simply check whether the timestamp field
      ** has been updated since the original Customer was fetched
      ** by this program.
      ** In batch (API input) check return parameters from Retrieve
      ** module for errors, and send message to system operator.
      *
      ** Interactive mode:
      *
     C                   IF        @TYPE = '1'
      *
     C                   IF        CHFLTMST <> A_VFTMES
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   ENDIF
      *
     C                   IF        ACTN     = 'I' and
     C                             DDACTNOK = 'N' OR
     C                             DDTRNNOK = 'N'
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   ENDIF
      ** Batch mode:
     C                   ELSE
     C                   IF        DDACTNOK = 'N' OR
     C                             DDTRNNOK = 'N'
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   Z-ADD     1             C                 2 0
      *
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
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        ACTN     = 'I' and
     C                             DDACTNOK = 'N' OR
     C                             DDTRNNOK = 'N'
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * INSERT - Insert a Transaction  Details                       *
      *                                                              *
      ****************************************************************
     C     INSERT        BEGSR
      ** Initialize Transaction Detail
     C                   CLEAR                   DLAAF
      ** Store Old fields for comparisons
     C                   MOVEL(P)  DLAAF         B_DLAAF
      *                                                                                    AR1096788
      ** Check STRANF details file if not full                                             AR1096788
      *                                                                                    AR1096788
     C                   Z-ADD     1             A#RRN                                     AR1096788
     C     A#RRN         CHAIN     STRANHF                            80                   AR1096788
     C                   IF        *IN80 = *ON                                             AR1096788
     C                   MOVEL     '*FIRST'      DBKEY                                     AR1096788
     C                   EVAL      DBFILE = 'STRANH '                                      AR1096788
     C                   EVAL      DBASE  = 909                                            AR1096788
     C                   EXSR      SRERR                                                   AR1096788
     C                   ENDIF                                                             AR1096788
      *                                                                                    AR1096788
     C     MNT           SUB       NAVT          A#DIFF                                    AR1096788
     C     A#DIFF        COMP      2                                    8181               AR1096788
     C                   IF        *IN81 = *ON                                             AR1096788
     C                   MOVEL     '*FULL '      DBKEY                                     AR1096788
     C                   EVAL      DBFILE = 'STRANF '                                      AR1096788
     C                   EVAL      DBASE  = 910                                            AR1096788
     C                   EXSR      SRERR                                                   AR1096788
     C                   ENDIF                                                             AR1096788
      *                                                                                    AR1096788
      ** Set Transaction fields on insert
      *                                                                                    AR1096788
     C                   Z-ADD     NAVT          A#RRN                                     AR1096788
     C     A#RRN         CHAIN     STRANFF                            82                   AR1096788
     C                   EVAL        RECI = 'F'                                            AR1005423
     C                   EVAL        DLNO = A_VFDLNO
     C                   EVAL        CNUM = A_VFCNUM
     C                   EVAL        MAAM = A_VFMAAM
     C                   EVAL        SIGN = A_VFSIGN
     C                   EVAL        CCY  = A_VFCCY
     C                   EVAL        DTYP = A_VFDTYP
     C                   EVAL        INIRS = A_VFINIRS
     C                   EVAL        BRCA = A_VFBRCA
     C                   EVAL        RRNT = A_VFRRNT
     C                   EVAL        USIT = A_VFUSIT
     C                   EVAL        FLUSGN = A_VFUSGN
     C                   EVAL        AACF = A_VFAACF
     C                   EVAL        FSGN = A_VFFSGN
      ** Front Office ID
     C                   EVAL      FlFRNT=A_VFFRNT
      ** Associated Front Office ID
     C                   EVAL      FlAFRT=A_VFAFRT
      ** Repair Location
     C                   EVAL      FlREPA=A_VFREPA
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
      *
     C                   EVAL      FlTMST  = TimeStamp
     C                   EVAL      FlTYLC  = 'I'
      *
      **  Obtain next transaction number
      *
     C                   EXSR      ZTNLU1
     C                   MOVE      FNATN         TNLU
     C                   MOVE      FNATN         FLTRNN
      ** Return the Transaction Number
     C                   MOVE      FNATN         A_VFTRNN
      ** Write new Transaction Detail
     C**********         WRITE     DLDTRANFF                                               AR1096788
     C                   UPDATE    STRANFF                                                 AR1096788
      *                                                                                    AR1096788
      ** Update STRAN header file                                                          AR1096788
      *                                                                                    AR1096788
     C                   EXSR      SRUPHead                                                AR1096788
      *
     C                   EVAL      VFMAAM = MAAM
     C                   EVAL      VFSIGN = A_VFSIGN
     C                   EVAL      VFINIRS = A_VFINIRS
     C                   EVAL      VFUSIT = A_VFUSIT
     C                   EVAL      VFUSGN = A_VFUSGN
     C                   EVAL      VFAACF = A_VFAACF
     C                   EVAL      VFFSGN = A_VFFSGN
      ** Update record
     C                   MOVE      'Y'           UPDBEF                                    AR1044820
     C                   MOVE      'Y'           UPDAFT                                    AR1044820
     C                   EXSR      DEALUP
      *                                                                                     AR740564
      ** Pass Movement to generate interest adjustment                                      AR740564
      *                                                                                     AR740564
     C                   IF        RCDT = 'G'                                               AR740564
     C                   EXSR      SRCLR                                                    AR740564
     C                   EXSR      SRMOVE                                                   AR740564
     C                   EXSR      SRUPD                                                    AR740564
     C                   ENDIF                                                              AR740564
      *                                                                                    AR1044820
      ** Generate Interest Projection for RCDT = 'C'                                       AR1044820
      *                                                                                    AR1044820
     C                   IF        RCDT = 'C'                                              AR1044820
     C                   EXSR      PROJDC                                                  AR1044820
     C                   ENDIF                                                             AR1044820
      *                                                                                     AR916823
      ** Generate Confirmation and Pay/Rcv Messages                                         AR916823
      *                                                                                     AR916823
     C                   IF        RCDT = 'C'                                               AR916823
     C                   EXSR      CNFPYRC                                                  AR916823
     C                   ENDIF                                                              AR916823
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * AMEND  - Amend a Transaction Details                         *
      *                                                              *
      ****************************************************************
     C     AMEND         BEGSR
      ** Access Transaction Detail record
     C*****A_VFTRNN      CHAIN     DLSTRANULL                         99                   AR1096788
     C     A_VFTRNN      CHAIN     STRANFL0                           99                   AR1096788
      ** Database error
     C                   IF        *IN99 = *ON
     C                   EVAL      DBKEY  = A_VFTRNN
     C**********         EVAL      DBFILE = 'DLSTRANFPD'                                   AR1096788
     C                   EVAL      DBFILE = 'STRANFL0  '                                   AR1096788
     C                   EVAL      DBASE  = 901
     C                   EXSR      SRERR
     C                   ENDIF
      ** Update 'BEFORE' status
     C                   MOVEL(P)  DLAAF         B_DLAAF
      ** Set Transaction Detail fields on amend
     C                   EVAL        DLNO = A_VFDLNO
     C                   EVAL        CNUM = A_VFCNUM
     C                   EVAL        CCY  = A_VFCCY
     C                   EVAL        MAAM = A_VFMAAM
     C                   EVAL        SIGN = A_VFSIGN
     C                   EVAL        DTYP = A_VFDTYP
     C                   EVAL        INIRS = A_VFINIRS
     C                   EVAL        BRCA = A_VFBRCA
     C                   EVAL        RRNT = A_VFRRNT
     C                   EVAL        USIT = A_VFUSIT
     C                   EVAL        FLUSGN = A_VFUSGN
     C                   EVAL        AACF = A_VFAACF
     C                   EVAL        FSGN = A_VFFSGN
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   EVAL      FlTMST=TimeStamp
      ** Front Office ID
     C                   EVAL      FlFRNT=A_VFFRNT
      ** Associated Front Office ID
     C                   EVAL      FlAFRT=A_VFAFRT
      ** Last amendment type
     C                   EVAL      FlTYLC  = 'A'
      ** Transaction number
     C                   EVAL      FlTRNN  =A_VFTRNN
      ** Update Record
     C**********         UPDATE    DLDTRANFF                                               AR1096788
     C                   UPDATE    STRANF0                                                 AR1096788
      *                                                                                    AR1096788
      ** Update STRAN header file for changes                                              AR1096788
      *                                                                                    AR1096788
     C                   IF        SIGN <> B_SIGN OR                                       AR1096788
     C                             MAAM <> B_MAAM                                          AR1096788
     C                   EXSR      SRRevert                                                AR1096788
     C                   EXSR      SRUPHead                                                AR1096788
     C                   ENDIF                                                             AR1096788
      *                                                                                    AR1096788
     C                   EVAL      VFMAAM = B_MAAM * -1
     C                   EVAL      VFSIGN = B_SIGN
     C                   EVAL      VFINIRS = B_INIRS
     C                   EVAL      VFUSIT = B_USIT * -1
     C                   EVAL      VFAACF = B_AACF * -1
     C                   EVAL      VFFSGN = B_FSGN
     C                   EVAL      VFUSGN = B_FLUSGN
      *                                                                                    AR1044820
     C                   MOVE      'Y'           UPDBEF                                    AR1044820
     C                   MOVE      ' '           UPDAFT                                    AR1044820
     C                   EXSR      DEALUP
      *                                                                                     AR740564
      ** Pass Movement to reverse the interest adjustment                                   AR740564
      *                                                                                     AR740564
     C                   IF        RCDT = 'G'                                               AR740564
     C                   EXSR      SRCLR                                                    AR740564
     C                   EXSR      SRMOVE                                                   AR740564
     C                   ENDIF                                                              AR740564
      *
     C                   EVAL      VFMAAM = MAAM
     C                   EVAL      VFSIGN = SIGN
     C                   EVAL      VFINIRS = INIRS
     C                   EVAL      VFUSIT = USIT
     C                   EVAL      VFUSIT = USIT
     C                   EVAL      VFUSGN = FLUSGN
     C                   EVAL      VFAACF = AACF
     C                   EVAL      VFFSGN = FSGN
      *                                                                                    AR1044820
     C                   MOVE      ' '           UPDBEF                                    AR1044820
     C                   MOVE      'Y'           UPDAFT                                    AR1044820
     C                   EXSR      DEALUP
      *                                                                                     AR740564
      ** Pass Movement to generate new interest adjustment                                  AR740564
      *                                                                                     AR740564
     C                   IF        RCDT = 'G'                                               AR740564
     C                   EXSR      SRMOVE                                                   AR740564
     C                   EXSR      SRUPD                                                    AR740564
     C                   ENDIF                                                              AR740564
      *                                                                                    AR1044820
      ** Generate Interest Projection for RCDT = 'C'                                       AR1044820
      *                                                                                    AR1044820
     C                   IF        RCDT = 'C'                                              AR1044820
     C                   EXSR      PROJDC                                                  AR1044820
     C                   ENDIF                                                             AR1044820
      *                                                                                     AR916823
      ** Generate Confirmation and Pay/Rcv Messages                                         AR916823
      *                                                                                     AR916823
     C                   IF        RCDT = 'C'                                               AR916823
     C                   EXSR      CNFPYRC                                                  AR916823
     C                   ENDIF                                                              AR916823
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * DELETE - Delete a transaction                                *
      *                                                              *
      ****************************************************************
     C     DELETE        BEGSR
      ** Access Transaction Details
     C*****A_VFTRNN      CHAIN     DLSTRANULL                         99                   AR1096788
     C     A_VFTRNN      CHAIN     STRANFL0                           99                   AR1096788
      ** Database error
     C                   IF        *IN99 = *ON
     C                   EVAL      DBKEY  = A_VFTRNN
     C**********         EVAL      DBFILE = 'DLSTRANFPD'                                   AR1096788
     C                   EVAL      DBFILE = 'STRANFL0  '                                   AR1096788
     C                   EVAL      DBASE  = 902
     C                   EXSR      SRERR
     C                   ENDIF
      ** Update 'BEFORE' status
     C                   MOVEL(P)  DLAAF         B_DLAAF
      ** Delete record
     C**********         DELETE    DLSTRANULL                                              AR1096788
     C                   EVAL      RECI = '*'                                              AR1096788
     C                   UPDATE    STRANF0                                                 AR1096788
      *                                                                                    AR1096788
      ** Update STRAN header file                                                          AR1096788
      *                                                                                    AR1096788
     C                   EXSR      SRRevert                                                AR1096788
      *
     C                   EVAL      VFMAAM = MAAM * -1
     C                   EVAL      VFSIGN = SIGN
     C                   EVAL      VFINIRS = INIRS
     C                   EVAL      VFUSIT = USIT * -1
     C                   EVAL      VFUSGN = FLUSGN
     C                   EVAL      VFAACF = AACF * -1
     C                   EVAL      VFFSGN = FSGN
      *                                                                                    AR1044820
     C                   MOVE      'Y'           UPDBEF                                    AR1044820
     C                   MOVE      'Y'           UPDAFT                                    AR1044820
     C                   EXSR      DEALUP
      *                                                                                     AR740564
      ** Pass Movement to reverse interest adjustment                                       AR740564
      *                                                                                     AR740564
     C                   IF        RCDT = 'G'                                               AR740564
     C                   EXSR      SRCLR                                                    AR740564
     C                   EXSR      SRMOVE                                                   AR740564
     C                   EXSR      SRUPD                                                    AR740564
     C                   ENDIF                                                              AR740564
      *                                                                                    AR1044820
      ** Generate Interest Projection for RCDT = 'C'                                       AR1044820
      *                                                                                    AR1044820
     C                   IF        RCDT = 'C'                                              AR1044820
     C                   EXSR      PROJDC                                                  AR1044820
     C                   ENDIF                                                             AR1044820
      *                                                                                     AR916823
      ** Generate Confirmation and Pay/Rcv Messages                                         AR916823
      *                                                                                     AR916823
     C                   IF        RCDT = 'C'                                               AR916823
     C                   EXSR      CNFPYRC                                                  AR916823
     C                   ENDIF                                                              AR916823

     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DEALUP - Update Deals File                                    *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     DEALUP        BEGSR
     C                   CLEAR                   DETLDC                                    AR1044820
      **   Access Deal to be updated
     C     A_VFDLNO      CHAIN     DEALS
      ** Database error
     C                   IF        not %Found
     C                   MOVE      A_VFDLNO      DBKEY
     C                   EVAL      DBFILE = 'DEALSF'
     C                   EVAL      DBASE  = 904
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                    AR1044820
     C                   IF        UPDBEF = 'Y'                                            AR1044820
     C                             AND RCDT = 'C'                                          AR1044820
     C                   MOVE      DETLDC        BeDealsDtlC                               AR1044820
     C                   ENDIF                                                             AR1044820
      *                                                                                    AR1044820
      ** Non FRA/IRS Deal
     C                   IF        RECI = 'D'
     C                             and RCDT = 'C'
     C                             or RECI = 'D'
     C                             and RCDT = 'D'
     C                             or RECI = 'M'
     C                             and RCDT = 'C'
     C                             and IPFR = 'N'
     C                             and NIDT > 0
      *
     C                   IF        VFSIGN = '+'
     C                   EVAL      AIAN = AIAN + VFMAAM
     C                   ENDIF
      *
     C                   IF        VFSIGN = '-'
     C                   EVAL      AIAN = AIAN - VFMAAM
     C                   ENDIF
      ** if Analytical Accounting Module is switched on
     C                   IF        BGN0ST = 'Y'
      *
     C                   IF        VFFSGN = '+'
     C                   EVAL      ACAN = ACAN + VFAACF
     C                   ENDIF
      *
     C                   IF        VFFSGN = '-'
     C                   EVAL      ACAN = ACAN - VFAACF
     C                   ENDIF
     C                   ENDIF
      *
     C                   BITON     '2'           DNSI
     C                   ENDIF
      **  FRA/IRS Deal
     C                   IF        RECI = 'D'
     C                             and RCDT = 'G'
      **  Ours
     C                   IF        VFINIRS = 'O'
      *
     C                   IF        VFSIGN = '+'
     C                   EVAL      UAIAN = UAIAN + VFMAAM
     C                   ENDIF
      *
     C                   IF        VFSIGN = '-'
     C                   EVAL      UAIAN = UAIAN - VFMAAM
     C                   ENDIF
     C                   ENDIF
      *
      **  Theirs
      *
     C                   IF        VFINIRS = 'T'
      *
     C                   IF        VFSIGN = '+'
     C                   EVAL      TAIAN = TAIAN + VFMAAM
     C                   ENDIF
      *
     C                   IF        VFSIGN = '-'
     C                   EVAL      TAIAN = TAIAN - VFMAAM
     C                   ENDIF
     C                   ENDIF
      ** Unsettled Interest Field
     C                   IF        CIR002 = 'Y'
     C                             or CIR006 = 'Y'
      ** Ours
     C                   IF        VFINIRS = 'O'
      *
     C                   IF        VFUSGN = '+'
     C                   EVAL      OUSA = OUSA + VFUSIT
     C                   ENDIF
      *
     C                   IF        VFUSGN = '-'
     C                   EVAL      OUSA = OUSA - VFUSIT
     C                   ENDIF
     C                   ENDIF
      **  Theirs
     C                   IF        VFINIRS = 'T'
      *
     C                   IF        VFUSGN = '+'
     C                   EVAL      TUSA = TUSA + VFUSIT
     C                   ENDIF
      *
     C                   IF        VFUSGN = '-'
     C                   EVAL      TUSA = TUSA - VFUSIT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C**********         IF        RCDT = 'C'                                     AR740564 AR1044820
     C                   IF        RCDT <> 'C'                                             AR1044820
     C                             AND RCDT <> 'G'                                         AR1044820
      *                                                                                      256960D
      ** Process Account Movement for Interest adjustment                                    256960D
      *                                                                                      256960D
     C                   IF        MDAT <> 0                                                 256960D
     C                   MOVE      MDAT          P1MDAT            5 0                       256960D
      *                                                                                      256960D
     C                   IF        NIDT <> 0                                                 256960D
     C                   MOVE      NIDT          W5A               5                         256960D
     C                   MOVE      NIDT          P1MDAT                                      256960D
      *                                                                                      256960D
     C                   ELSE                                                                256960D
     C                   MOVE      BJRDNB        W5A               5                         256960D
     C                   ENDIF                                                               256960D
      *                                                                                      256960D
     C                   MOVEL     *BLANKS       P1KEY1                                       260696
     C                   MOVEL     DTYP          P1KEY1           20                         256960D
     C                   MOVE      DLNO          W6A               6                         256960D
     C                   CAT       W6A:0         P1KEY1                                      256960D
     C                   CAT       W5A:0         P1KEY1                                      256960D
     C                   MOVEL     'SETTLI'      P1OPTN            6                         256960D
      *                                                                                      256960D
     C                   MOVE      VFSIGN        P1SIGN            1                         256960D
     C                   MOVE      VFMAAM        P1AMNT           13 0                       256960D
     C                   MOVE      CCY           P1CCY             3                         256960D
      *                                                                                      256960D
     C                   CALL      'MM0100'                                                  256960D
     C                   PARM                    P1OPTN                                      256960D
     C                   PARM                    P1KEY1                                      256960D
     C                   PARM                    P1SIGN                                      256960D
     C                   PARM                    P1AMNT                                      256960D
     C                   PARM                    P1CCY                                       256960D
     C                   PARM                    P1MDAT                                      256960D
      *                                                                                      256960D
     C                   ENDIF                                                               256960D
     C                   ENDIF                                                              AR740564
      *                                                                                      256960D
     C                   IF        RCDT = 'C'
     C                   UPDATE    DEALSDCF
     C                   ENDIF
      *                                                                                    AR1044820
     C                   IF        RCDT = 'C'                                              AR1044820
     C                             AND UPDAFT ='Y'                                         AR1044820
     C     A_VFDLNO      CHAIN     DEALS                                                   AR1044820
      *                                                                                    AR1044820
      ** Database Error because deal is not found.                                         AR1044820
      *                                                                                    AR1044820
     C                   IF        not %Found                                              AR1044820
     C                   MOVE      A_VFDLNO      DBKEY                                     AR1044820
     C                   EVAL      DBFILE = 'DEALSF'                                       AR1044820
     C                   EVAL      DBASE  = 904                                            AR1044820
     C                   EXSR      SRERR                                                   AR1044820
     C                   ENDIF                                                             AR1044820
      *                                                                                    AR1044820
     C                   MOVE      DETLDC        AfDealsDtlC                               AR1044820
     C                   ENDIF                                                             AR1044820
      *
     C                   IF        RCDT = 'D'
     C                   UPDATE    DEALSDDF
     C                   ENDIF
      *
     C                   IF        RCDT = 'G'
     C                   UPDATE    DEALSDGF
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT                                                                               AR1044820
      *****************************************************************                    AR1044820
      *                                                               *                    AR1044820
      * PROJDC - Account Movement Projection for DEALSDC              *                    AR1044820
      *                                                               *                    AR1044820
      * Called by: INSERT, AMEND, DELETE                              *                    AR1044820
      *                                                               *                    AR1044820
      * Calls: None                                                   *                    AR1044820
      *                                                               *                    AR1044820
      *****************************************************************                    AR1044820
     C     PROJDC        BEGSR                                                             AR1044820
      *                                                                                    AR1044820
      ** CALLER specifies the program that calls AOOUMMU0.                                 AR1044820
      *                                                                                    AR1044820
     C                   MOVEL     'DLDLAAUPD'   CALLER           10                       AR1044820
      *                                                                                    AR1044820
     C                   CLEAR                   Z#BSTS                                    AR1044820
     C                   CLEAR                   Z#ASTS                                    AR1044820
     C                   CLEAR                   Z#WSTS                                    AR1044820
      *                                                                                    AR1044820
     C                   CLEAR                   MMDELD                                    AR1044820
     C     DLNO          CHAIN     MMDELDP0                                                AR1044820
     C                   MOVEL     MMDELD        Z#BSTS                                    AR1044820
     C                   MOVEL     MMDELD        Z#ASTS                                    AR1044820
      *                                                                                    AR1044820
     C                   CALL      'AOOUMMU0'                                              AR1044820
     C                   PARM      *BLANK        ##RTCD            7                       AR1044820
     C                   PARM                    Z#BSTS                                    AR1044820
     C                   PARM                    Z#ASTS                                    AR1044820
     C                   PARM                    Z#WSTS                                    AR1044820
     C                   PARM      *BLANK        @@AURO            1                       AR1044820
     C                   PARM                    PFPAYF                                    AR1044820
     C                   PARM                    PFRECF                                    AR1044820
     C                   PARM                    PBFRCD          100                       AR1044820
     C                   PARM                    PAFRCD          100                       AR1044820
     C                   PARM                    DLDLQD                                     MD022302
     C                   PARM                    BeDealsDtlC                               AR1044820
     C                   PARM                    AfDealsDtlC                               AR1044820
     C                   PARM                    CALLER           10                       AR1044820
      *                                                                                    AR1044820
     C                   ENDSR                                                             AR1044820
      *****************************************************************                    AR1044820
      *****************************************************************                     AR740564
      /EJECT                                                                                AR740564
      *****************************************************************                     AR740564
      *                                                               *                     AR740564
      * SRMOVE - Pass movements to write program                      *                     AR740564
      *                                                               *                     AR740564
      * Called by: INSERT, UPDATE, DELETE                             *                     AR740564
      *                                                               *                     AR740564
      * Calls: AOSPOSU0                                               *                     AR740564
      *                                                               *                     AR740564
      *****************************************************************                     AR740564
     C     SRMOVE        BEGSR                                                              AR740564
      *                                                                                     AR740564
      ** Account movement for Accrued Interest Adjustment for IRS                           AR740564
      *                                                                                     AR740564
     C                   CLEAR                   C#DTA                                      AR740564
     C                   MOVEL     *BLANKS       R#RTN             7                        AR740564
     C                   IF        VFINIRS = 'O'                                            AR740564
     C                   MOVEL     PSTM          ##SETM            2                        AR740564
     C                   MOVEL     UPACC         ##ACCT                                     AR740564
     C                   MOVEL     'I'           C#IO                                       AR740564
     C                   MOVEL     UCUCY         C#CCY                                      AR740564
     C                   IF        UNIPD <> 0                                               AR740564
     C                   MOVEL     UNIPD         C#VDAT                                     AR740564
     C                   MOVEL     UNIPD         C#PSTD                                     AR740564
     C                   ELSE                                                               AR740564
     C                   MOVEL     MDAT          C#VDAT                                     AR740564
     C                   MOVEL     MDAT          C#PSTD                                     AR740564
     C                   ENDIF                                                              AR740564
     C                   ELSE                                                               AR740564
     C                   IF        VFINIRS = 'T'                                            AR740564
     C                   MOVEL     RSTM          ##SETM                                     AR740564
     C                   MOVEL     URACC         ##ACCT                                     AR740564
     C                   MOVEL     'O'           C#IO                                       AR740564
     C                   MOVEL     TCUCY         C#CCY                                      AR740564
     C                   IF        TNIPD <> 0                                               AR740564
     C                   MOVEL     TNIPD         C#VDAT                                     AR740564
     C                   MOVEL     TNIPD         C#PSTD                                     AR740564
     C                   ELSE                                                               AR740564
     C                   MOVEL     MDAT          C#VDAT                                     AR740564
     C                   MOVEL     MDAT          C#PSTD                                     AR740564
     C                   ENDIF                                                              AR740564
     C                   ENDIF                                                              AR740564
     C                   ENDIF                                                              AR740564
      *                                                                                     AR740564
     C                   IF        ##SETM = '01' OR ##SETM = '02'                           AR740564
     C                             OR ##SETM = '07' OR ##SETM = '08'                        AR740564
     C                             OR ##SETM = '12'                                         AR740564
     C                   MOVEL     'N'           C#ATYP                                     AR740564
     C                   MOVEL     ##NOSN        C#NOSN                                     AR740564
     C                   ENDIF                                                              AR740564
     C                   IF        ##SETM = '14'                                            AR740564
     C                   MOVEL     'R'           C#ATYP                                     AR740564
     C                   MOVEL     ##ACNO        C#ACNO                                     AR740564
     C                   ENDIF                                                              AR740564
     C                   IF        ##SETM = '04' OR ##SETM = '05'                           AR740564
     C                   MOVEL     'P'           C#ATYP                                     AR740564
     C                   MOVEL     ##CNUM        C#CNUM                                     AR740564
     C                   MOVEL     ##ACOD        C#ACOD                                     AR740564
     C                   MOVEL     ##ACSQ        C#ACSQ                                     AR740564
     C                   MOVEL     BRCA          C#BRCA                                     AR740564
     C                   ENDIF                                                              AR740564
      *                                                                                     AR740564
     C                   MOVEL     DTYP          C#TRYP                                     AR740564
     C                   MOVEL     'INT. ADJ.'   C#NARR                                     AR740564
     C                   MOVEL     DLNO          C#TRN                                      AR740564
      *                                                                                     AR740564
     C                   IF        VFINIRS = 'O' AND VFSIGN = '-'                           AR740564
     C                   Z-ADD     VFMAAM        C#AMT                                      AR740564
     C                   ELSE                                                               AR740564
     C                   IF        VFINIRS = 'O' AND VFSIGN = '+'                           AR740564
     C                   Z-SUB     VFMAAM        C#AMT                                      AR740564
     C                   ENDIF                                                              AR740564
     C                   ENDIF                                                              AR740564
      *                                                                                     AR740564
     C                   IF        VFINIRS = 'T' AND VFSIGN = '+'                           AR740564
     C                   Z-ADD     VFMAAM        C#AMT                                      AR740564
     C                   ELSE                                                               AR740564
     C                   IF        VFINIRS = 'T' AND VFSIGN = '-'                           AR740564
     C                   Z-SUB     VFMAAM        C#AMT                                      AR740564
     C                   ENDIF                                                              AR740564
     C                   ENDIF                                                              AR740564
      *                                                                                     AR740564
     C                   MOVEL     'DL'          C#MOD                                      AR740564
     C                   MOVEL     '02'          C#OLRC                                     AR740564
     C                   MOVEL     'Y'           C#RPST                                     AR740564
     C                   Z-ADD     003           C#RPNB                                     AR740564
     C                   MOVEL     'C'           C#RTYP                                     AR740564
     C                   MOVEL     BRCA          C#BBRN                                     AR740564
      *                                                                                     AR740564
      ** Call AOSPOSU0 to add new details                                                   AR740564
      *                                                                                     AR740564
     C                   CALL      'AOSPOSU0'                           9090                AR740564
     C     R#RTN         PARM      *BLANKS       O#RTN             7                        AR740564
     C                   PARM      '*ADD    '    W0ACT             8                        AR740564
     C                   PARM      C#DTA         O#DTA           256                        AR740564
     C     *IN90         IFEQ      '1'                                                      AR740564
     C     R#RTN         ORNE      *BLANKS                                                  AR740564
     C                   MOVEL     '*CALL   '    W0FILE            8                        AR740564
     C                   MOVEL     'AOSPOSU0'    W0KEY            29                        AR740564
     C                   Z-ADD     902           W0ERNB            3 0                      AR740564
     C                   EXSR      SRERR                                                    AR740564
     C                   ENDIF                                                              AR740564
      *                                                                                     AR740564
     C                   ENDSR                                                              AR740564
      *****************************************************************                     AR740564
      /EJECT                                                                                AR740564
      *****************************************************************                     AR740564
      *                                                               *                     AR740564
      * SRUPD - Update movements                                      *                     AR740564
      *                                                               *                     AR740564
      * Called by: INSERT, UPDATE, DELETE                             *                     AR740564
      *                                                               *                     AR740564
      * Calls: AOSPOSU0                                               *                     AR740564
      *                                                               *                     AR740564
      *****************************************************************                     AR740564
     C     SRUPD         BEGSR                                                              AR740564
      *                                                                                     AR740564
      ** Call AOSPOSU0 to update                                                            AR740564
      *                                                                                     AR740564
     C                   CALL      'AOSPOSU0'                           9090                AR740564
     C     R#RTN         PARM      *BLANKS       O#RTN             7                        AR740564
     C                   PARM      '*UPDATE '    W0ACT             8                        AR740564
     C                   PARM      C#DTA         O#DTA           256                        AR740564
     C     *IN90         IFEQ      '1'                                                      AR740564
     C     R#RTN         ORNE      *BLANKS                                                  AR740564
     C                   MOVEL     '*CALL   '    W0FILE            8                        AR740564
     C                   MOVEL     'AOSPOSU0'    W0KEY            29                        AR740564
     C                   Z-ADD     903           W0ERNB            3 0                      AR740564
     C                   EXSR      SRERR                                                    AR740564
     C                   ENDIF                                                              AR740564
      *                                                                                     AR740564
     C                   ENDSR                                                              AR740564
      *****************************************************************                     AR740564
      /EJECT                                                                                AR740564
      *****************************************************************                     AR740564
      *                                                               *                     AR740564
      * SRCLR - Clear all postings in store                           *                     AR740564
      *                                                               *                     AR740564
      * Called by: INSERT, UPDATE, DELETE                             *                     AR740564
      *                                                               *                     AR740564
      * Calls: AOSPOSU0                                               *                     AR740564
      *                                                               *                     AR740564
      *****************************************************************                     AR740564
     C     SRCLR         BEGSR                                                              AR740564
      *                                                                                     AR740564
      ** Call AOSPOSU0 to clear                                                             AR740564
      *                                                                                     AR740564
     C                   CLEAR                   C#DTA                                      AR740564
     C                   CALL      'AOSPOSU0'                           9090                AR740564
     C     R#RTN         PARM      *BLANKS       O#RTN             7                        AR740564
     C                   PARM      '*CLEAR'      W0ACT             8                        AR740564
     C                   PARM      C#DTA         O#DTA           256                        AR740564
     C     *IN90         IFEQ      '1'                                                      AR740564
     C     R#RTN         ORNE      *BLANKS                                                  AR740564
     C                   MOVEL     '*CALL   '    W0FILE            8                        AR740564
     C                   MOVEL     'AOSPOSU0'    W0KEY            29                        AR740564
     C                   Z-ADD     901           W0ERNB            3 0                      AR740564
     C                   EXSR      SRERR                                                    AR740564
     C                   ENDIF                                                              AR740564
     C                   ENDSR                                                              AR740564
      *****************************************************************                     AR916823
      /EJECT                                                                                AR916823
      *****************************************************************                     AR916823
      *                                                               *                     AR916823
      * CNFPYRC - Set Confirmation and Pay/Rcv Indicators             *                     AR916823
      *                                                               *                     AR916823
      *****************************************************************                     AR916823
     C     CNFPYRC       BEGSR                                                              AR916823
      *                                                                                     AR916823
     C     A_VFDLNO      CHAIN     DEALSDCF                           92                    AR916823
      *                                                                                     AR916823
     C                   IF        *IN92 = *ON                                              AR916823
     C                   MOVEL     A_VFDLNO      DBKEY                                      AR916823
     C                   EVAL      DBFILE = 'DEALSDC'                                       AR916823
     C                   EVAL      DBASE  = 907                                             AR916823
     C                   EXSR      SRERR                                                    AR916823
     C                   ENDIF                                                              AR916823
      *                                                                                     AR916823
     C                   BITOFF    '0'           CNFI                                       AR916823
     C                   MOVE      'Y'           @@CNRQ                                     AR916823
      *                                                                                     AR916823
      ** Set Pay/Rcv Indicator 2 = Interest Pay Date                                        AR916823
      *                                                                                     AR916823
     C                   Z-ADD     *ZERO         @@PRI1                                     AR916823
     C                   Z-ADD     *ZERO         @@PRI2                                     AR916823
     C                   Z-ADD     *ZERO         @@PRI3                                     AR916823
      *                                                                                     AR916823
      ** Determine if local or deal currency to be used                                     AR916823
      ** in holiday checking                                                                AR916823
      *                                                                                     AR916823
     C                   MOVEL     'L'           @DLOLC                                     AR916823
     C                   MOVEL     *BLANK        @NOSTR                                     AR916823
      *                                                                                     AR916823
     C     DTYP          IFEQ      'IT'                                                     AR916823
     C     DTYP          OREQ      'TD'                                                     AR916823
     C     DTYP          OREQ      'CD'                                                     AR916823
     C     DTYP          OREQ      'FT'                                                     AR916823
     C     CDL006        ANDEQ     'Y'                                                      AR916823
     C     DTYP          OREQ      'DT'                                                     AR916823
     C     CDL006        ANDEQ     'Y'                                                      AR916823
     C     DTYP          OREQ      'LT'                                                     AR916823
     C     CDL006        ANDEQ     'Y'                                                      AR916823
      *                                                                                     AR916823
     C     PSTM          IFEQ      01                                                       AR916823
     C     PSTM          OREQ      07                                                       AR916823
     C     PSTM          OREQ      08                                                       AR916823
     C                   MOVE      'D'           @DLOLC                                     AR916823
     C                   MOVEL     PONS          @NOSTR                                     AR916823
     C                   ENDIF                                                              AR916823
      *                                                                                     AR916823
     C                   ELSE                                                               AR916823
      *                                                                                     AR916823
     C     RSTM          IFEQ      01                                                       AR916823
     C     RSTM          OREQ      07                                                       AR916823
     C     RSTM          OREQ      08                                                       AR916823
     C                   MOVE      'D'           @DLOLC                                     AR916823
     C                   MOVEL     RONS          @NOSTR                                     AR916823
     C                   ENDIF                                                              AR916823
      *                                                                                     AR916823
     C                   ENDIF                                                              AR916823
      *                                                                                     AR916823
      ** Determine Telex Due Date                                                           AR916823
      *                                                                                     AR916823
     C                   EXSR      TLXDUE                                                   AR916823
      *                                                                                     AR916823
      ** Set PRI2 if interest pay date is within telex notice period                        AR916823
      *                                                                                     AR916823
     C     NIDT          IFNE      *ZERO                                                    AR916823
     C     NIDT          ANDGE     BJRDNB                                                   AR916823
     C     NIDT          ANDLE     @TLXDU                                                   AR916823
     C                   Z-ADD     1             @@PRI2                                     AR916823
     C                   ENDIF                                                              AR916823
      *                                                                                     AR916823
      ** Set Pay/Rcv Indicator 3 = Maturity Date                                            AR916823
      *                                                                                     AR916823
     C     @@PRI2        IFNE      1                                                        AR916823
      *                                                                                     AR916823
      ** Determine if local or deal currency to be used                                     AR916823
      ** in holiday checking                                                                AR916823
      *                                                                                     AR916823
     C                   MOVEL     'L'           @DLOLC                                     AR916823
     C                   MOVEL     *BLANK        @NOSTR                                     AR916823
      *                                                                                     AR916823
     C     DTYP          IFEQ      'IT'                                                     AR916823
     C     DTYP          OREQ      'TD'                                                     AR916823
     C     DTYP          OREQ      'CD'                                                     AR916823
     C     DTYP          OREQ      'FT'                                                     AR916823
     C     CDL006        ANDEQ     'Y'                                                      AR916823
     C     DTYP          OREQ      'DT'                                                     AR916823
     C     CDL006        ANDEQ     'Y'                                                      AR916823
     C     DTYP          OREQ      'LT'                                                     AR916823
     C     CDL006        ANDEQ     'Y'                                                      AR916823
      *                                                                                     AR916823
     C     PSTM          IFEQ      01                                                       AR916823
     C     PSTM          OREQ      07                                                       AR916823
     C     PSTM          OREQ      08                                                       AR916823
     C                   MOVE      'D'           @DLOLC                                     AR916823
     C                   MOVEL     PONS          @NOSTR                                     AR916823
     C                   ENDIF                                                              AR916823
      *                                                                                     AR916823
     C                   ELSE                                                               AR916823
      *                                                                                     AR916823
     C     RSTM          IFEQ      01                                                       AR916823
     C     RSTM          OREQ      07                                                       AR916823
     C     RSTM          OREQ      08                                                       AR916823
     C                   MOVE      'D'           @DLOLC                                     AR916823
     C                   MOVEL     RONS          @NOSTR                                     AR916823
     C                   ENDIF                                                              AR916823
      *                                                                                     AR916823
     C                   ENDIF                                                              AR916823
      *                                                                                     AR916823
      ** Determine Telex Due Date                                                           AR916823
      *                                                                                     AR916823
     C                   EXSR      TLXDUE                                                   AR916823
      *                                                                                     AR916823
      ** Set PRI3 if maturity date is within telex notice period                            AR916823
      *                                                                                     AR916823
     C     MDAT          IFGE      BJRDNB                                                   AR916823
     C     MDAT          ANDLE     @TLXDU                                                   AR916823
     C     DTYP          ANDNE     'IL'                                                     AR916823
     C     DTYP          ANDNE     'ID'                                                     AR916823
      *                                                                                     AR916823
     C     AURO          IFNE      'Y'                                                      AR916823
     C     AURO          OREQ      'Y'                                                      AR916823
     C     RBDN          ANDNE     *ZEROS                                                   AR916823
     C                   Z-ADD     1             @@PRI3                                     AR916823
     C                   ENDIF                                                              AR916823
      *                                                                                     AR916823
     C                   ENDIF                                                              AR916823
     C                   ENDIF                                                              AR916823
      *                                                                                     AR916823
      ** Update DEALSDC                                                                     AR916823
      *                                                                                     AR916823
     C                   UPDATE    DEALSDCF                                                 AR916823
      *                                                                                     AR916823
      ** Write a DTRIX record                                                               AR916823
      *                                                                                     AR916823
     C                   EXSR      WRTDTX                                                   AR916823
      *                                                                                     AR916823
      ** Update the DTRIX header record                                                     AR916823
      *                                                                                     AR916823
     C                   EXSR      UPDDTH                                                   AR916823
      *                                                                                     AR916823
     C                   ENDSR                                                              AR916823
      *****************************************************************                     AR916823
      /EJECT                                                                                AR916823
      *****************************************************************                     AR916823
      *                                                               *                     AR916823
      * WRTDTX - Write a DTRIX record                                 *                     AR916823
      *                                                               *                     AR916823
      *****************************************************************                     AR916823
     C     WRTDTX        BEGSR                                                              AR916823
      *                                                                                     AR916823
      **  Set fields on record to be written to DTRIXDD                                     AR916823
      *                                                                                     AR916823
     C                   MOVE      'D'           DXRECI                                     AR916823
     C                   MOVE      'D'           DXRCDT                                     AR916823
     C                   Z-ADD     DLNO          DXDLNO                                     AR916823
     C                   Z-ADD     *ZERO         DXVDAT                                     AR916823
     C                   Z-ADD     *ZERO         DXDASN                                     AR916823
     C                   MOVE      'A'           DXCHTP                                     AR916823
     C                   MOVE      @@CNRQ        DXCNRQ                                     AR916823
     C                   MOVE      'N'           DXCNPR                                     AR916823
     C                   MOVE      ' '           DXREPR                                     AR916823
     C                   TIME                    @XTIME                                     AR916823
     C                   MOVE      @@PRI1        DXPRI1                                     AR916823
     C                   MOVE      @@PRI2        DXPRI2                                     AR916823
     C                   MOVE      @@PRI3        DXPRI3                                     AR916823
     C                   Z-ADD     0             DXICIN                                     AR916823
     C                   MOVEL     BRCA          DXBRCA                                     AR916823
     C                   Z-ADD     *ZERO         DXTNLU                                     AR916823
      *                                                                                     AR916823
     C                   WRITE     DTRIXDF                                                  AR916823
      *                                                                                     AR916823
     C                   ENDSR                                                              AR916823
      *****************************************************************                     AR916823
      /EJECT                                                                                AR916823
      *****************************************************************                     AR916823
      *                                                               *                     AR916823
      * UPDDTH - Update the DTRIX header record                       *                     AR916823
      *                                                               *                     AR916823
      *****************************************************************                     AR916823
     C     UPDDTH        BEGSR                                                              AR916823
      *                                                                                     AR916823
      ** Access the header record                                                           AR916823
      *                                                                                     AR916823
     C                   Z-ADD     *ZERO         DXDLNO                                     AR916823
     C     DXDLNO        CHAIN     DTRIXHF                            91                    AR916823
      *                                                                                     AR916823
      ** Database Error                                                                     AR916823
      *                                                                                     AR916823
     C                   IF        *IN91 = *ON                                              AR916823
     C                   MOVEL     DXDLNO        DBKEY                                      AR916823
     C                   EVAL      DBFILE = 'DTRIXHF '                                      AR916823
     C                   EVAL      DBASE = 908                                              AR916823
     C                   EXSR      SRERR                                                    AR916823
     C                   ENDIF                                                              AR916823
      *                                                                                     AR916823
      ** Add 1 to number of deal records (on DTRIXDD)                                       AR916823
      *                                                                                     AR916823
     C                   ADD       1             DXNDLR                                     AR916823
      *                                                                                     AR916823
     C                   UPDATE    DTRIXHF                                                  AR916823
      *                                                                                     AR916823
     C                   ENDSR                                                              AR916823
      *****************************************************************                     AR916823
      /EJECT                                                                                AR916823
      *****************************************************************                     AR916823
      *                                                               *                     AR916823
      * TLXDUE - Determine Telex Due Date                             *                     AR916823
      *                                                               *                     AR916823
      *****************************************************************                     AR916823
     C     TLXDUE        BEGSR                                                              AR916823
      *                                                                                     AR916823
      ** Effective Settlement Currency                                                      AR916823
      *                                                                                     AR916823
     C     STCY          IFNE      *BLANKS                                                  AR916823
     C                   MOVEL     STCY          EffSetCcy                                  AR916823
     C                   ELSE                                                               AR916823
     C                   MOVEL     CCY           EffSetCcy         3                        AR916823
     C                   ENDIF                                                              AR916823
      *                                                                                     AR916823
     C                   CALLB     'ZATLXDUEDT'                                             AR916823
      *                                                                                     AR916823
      ** Deal or local Currency                                                             AR916823
     C                   PARM                    @DLOLC            1                        AR916823
      *                                                                                     AR916823
      ** Currency                                                                           AR916823
     C                   PARM      EffSetCcy     @CCY              3                        AR916823
      *                                                                                     AR916823
      ** Nostro                                                                             AR916823
     C                   PARM                    @NOSTR            2                        AR916823
      *                                                                                     AR916823
      ** Date of Next Working Day                                                           AR916823
     C                   PARM                    BJDNWD            5 0                      AR916823
      *                                                                                     AR916823
      ** Local Currency                                                                     AR916823
     C                   PARM                    BJLCCY            3                        AR916823
      *                                                                                     AR916823
      ** System Location                                                                    AR916823
     C                   PARM                    BJSLCD            3                        AR916823
      *                                                                                     AR916823
      ** Telex Due Date                                                                     AR916823
     C                   PARM      *ZERO         @TLXDU            5 0                      AR916823
      *                                                                                     AR916823
     C                   ENDSR                                                              AR916823
      *****************************************************************                     AR916823
      /EJECT                                                                                AR916823
      ********************************************************************
      *
      **   ZALIGN SR. TO VALIDATE AND RIGHT-ALIGN NUMERIC FIELDS.
      *
     C     ZALIGN        BEGSR                                                  *** ZALIGN ***
      *
     C                   SETOFF                                       929399
      **   SAVE INPUT FIELD IN ARRAY, ZA1.
     C                   MOVEA     ZFIELD        ZA1
      **   CALCULATION TO DEFINE NUMBER STRUCTURE CONTROL FIELDS.
     C                   Z-ADD     ZADIG         ZADIG             2 0
     C                   Z-ADD     ZADEC         ZADEC             1 0
      **   CALCULATIONS TO DEFINE/CLEAR FIELDS.
     C                   MOVE      ' '           ZA2
     C                   MOVEA     ZA2           ZFIELD           16
     C                   Z-ADD     0             ZX                2 0
     C                   Z-ADD     0             ZY                2 0
      **   ENSURE REQUIRED STRUCTURE OF FIELD IS VALID.
     C     ZADIG         ADD       ZADEC         ZZ                2 0
     C     ZZ            COMP      15                                 99
     C   99              GOTO      ZAEND
      **   LOOP TO FIND DECIMAL POINT, BLANKS AND CHARACTERS.
     C     ZATAG1        TAG
     C     ZX            ADD       1             ZX
      **   CHECK FOR DECIMAL POINT. ERROR IF SECOND DECIMAL POINT.
     C     ZA1(ZX)       COMP      '.'                                    90
     C   90
     CAN 93              SETON                                        99
     C   99              GOTO      ZAEND
      **   CHECK FOR 'M' CONSTANT. ERROR IF NOT LAST CHARACTER ENTERED
     C     ZA1(ZX)       COMP      'M'                                    96
     C   96              DO
     C     ZX            COMP      15                                 99  99
     C   99              GOTO      ZAEND
     C     ZX            ADD       1             ZX
     C     ZA1(ZX)       COMP      ' '                                9999
     C   99              GOTO      ZAEND
     C     ZX            SUB       1             ZX
     C     ZX            COMP      9                                  99
     C   99              GOTO      ZAEND
     C                   END
      **   CHECK FOR 'T' CONSTANT. ERROR IF NOT LAST CHARACTER ENTERED
     C     ZA1(ZX)       COMP      'T'                                    97
     C   97              DO
     C     ZX            COMP      15                                 99  99
     C   99              GOTO      ZAEND
     C     ZX            ADD       1             ZX
     C     ZA1(ZX)       COMP      ' '                                9999
     C   99              GOTO      ZAEND
     C     ZX            SUB       1             ZX
     C     ZX            COMP      12                                 99
     C   99              GOTO      ZAEND
     C                   END
      **   CLEAR ALPHAMERIC CONSTANT FROM ZA1
     C   96
     COR 97              MOVE      ' '           ZA1(ZX)
      **   CHECK FOR BLANKS. BYPASS FOR FIRST BLANK AFTER A DIGIT.
     C     ZA1(ZX)       COMP      ' '                                    91
     C   91
     CAN 92              GOTO      ZATAG2
      **   CHECK FOR NUMERIC, IF NOT '.' OR ' '.
     C  N90
     CANN91ZA1(ZX)       COMP      '0'                                  99
     C  N90
     CANN91
     CANN99ZA1(ZX)       COMP      '9'                                99
     C   99              GOTO      ZAEND
      **   STORE DIGITS IN ARRAY AND HOW MANY.
      **   ZY, TOTAL OF DIGITS IN THE INPUT FIELD.
      **   ZZ, TOTAL OF DIGITS TO THE LEFT OF DECIMAL POINT.
     C  N90
     CANN91ZY            ADD       1             ZY                   92
     C  N90
     CANN91              MOVE      ZA1(ZX)       ZA2(ZY)
     C   90              Z-ADD     ZY            ZZ                   93  93
      *
     C     ZX            COMP      16                                   94
     C   94              GOTO      ZATAG1
      *
     C     ZATAG2        TAG
      **   IF 'M' SPECIFIED, MULTIPLY ZA1 BY 1 MILLION
     C   96ZZ            ADD       6             ZZ
      **   IF 'T' SPECIFIED, MULTIPLY ZA1 BY 1 THOUSAND
     C   97ZZ            ADD       3             ZZ
      **   FILL IN ZEROS IN ANY BLANKS LEFT OF DECIMAL POINT
     C   96
     CAN 93
     COR 97
     CAN 93ZZ            DOWGT     ZY
     C     ZY            ADD       1             ZY
     C                   MOVE      '0'           ZA2(ZY)
     C                   END
      **   IF CONSTANT SPECIFIED WITH NO DECIMAL POINT ZEROISE BLANKS
     C   96
     CANN93              DO        6
     C     ZY            ADD       1             ZY
     C                   MOVE      '0'           ZA2(ZY)
     C                   END
      **
     C   97
     CANN93              DO        3
     C     ZY            ADD       1             ZY
     C                   MOVE      '0'           ZA2(ZY)
     C                   END
      **   IF NO DECIMAL POINT FOUND, SET TOTAL FIELD ZZ.
     C  N93              Z-ADD     ZY            ZZ
      **   CHECK FOR EMBEDDED BLANKS.
     C   91
     CAN 92              MOVEA     ZA1(ZX)       ZFIELD
     C   91
     CAN 92ZFIELD        COMP      ' '                                9999
     C   99              GOTO      ZAEND
      **   ENSURE THAT NUMBER OF DIGITS ENTERED EITHER SIDE
      **   OF DECIMAL POINT ARE NOT MORE THAN ALLOWED.
     C     ZZ            COMP      ZADIG                              99
     C     ZY            SUB       ZZ            ZX
     C  N99ZADEC         SUB       ZX            ZX                     9995
     C   99              GOTO      ZAEND
     C   95              GOTO      ZATAG4
      **   FILL THE TRAILING BLANKS WITH ZEROS.
     C     ZY            ADD       ZX            ZZ
     C     ZATAG3        TAG                                                    ** ZATAG3 TAG *
     C     ZY            ADD       1             ZY
     C                   MOVE      '0'           ZA2(ZY)
     C     ZY            COMP      ZZ                                   94
     C   94              GOTO      ZATAG3
      **   RIGHT-ALIGN THE VALUE BY MOVING BACK TO ARRAY, ZA1.
     C     ZATAG4        TAG                                                    ** ZATAG4 TAG *
     C                   MOVE      '0'           ZA1
     C                   Z-ADD     16            ZX
     C     ZATAG5        TAG                                                    ** ZATAG5 TAG *
     C     ZY            COMP      0                                      94
     C   94              GOTO      ZATAG6
     C                   MOVE      ZA2(ZY)       ZA1(ZX)
     C     ZY            SUB       1             ZY
     C     ZX            SUB       1             ZX
     C                   GOTO      ZATAG5
     C     ZATAG6        TAG                                                    ** ZATAG6 TAG *
      **   MOVE VALIDATED AND RIGHT-ALIGNED NUMBER BACK INTO ZFIELD.
     C                   MOVEA     ZA1           ZFIELD
      *
     C                   SETOFF                                       9697
      *
     C     ZAEND         ENDSR                                                  * ZAEND ENDSR *
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   ZTNLU1 -  Get Next Transaction Number                       *
      *                                                               *
      * Called by: INSERT                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     ZTNLU1        BEGSR
      *
     C     *DTAARA       DEFINE    AAJTN         DNATN
     C     *LOCK         IN        DNATN
     C                   MOVE      FNATN         ZZWK05            6 0
     C                   ADD       1             ZZWK05
     C                   MOVE      ZZWK05        FNATN
     C                   OUT       DNATN
      *
     C                   ENDSR
      *****************************************************************                    AR1096788
      /EJECT                                                                               AR1096788
      *****************************************************************                    AR1096788
      *                                                               *                    AR1096788
      * SRUPHead - Update STRANH Header File                          *                    AR1096788
      *                                                               *                    AR1096788
      *****************************************************************                    AR1096788
     C     SRUPHead      BEGSR                                                             AR1096788
      *                                                                                    AR1096788
      ** Update Trailer Totals depending on the sign of the amount                         AR1096788
      *                                                                                    AR1096788
     C                   Z-ADD     1             A#RRN                                     AR1096788
     C     A#RRN         CHAIN     STRANHF                            80                   AR1096788
     C                   IF        *IN80 = *ON                                             AR1096788
     C                   MOVEL     '*FIRST'      DBKEY                                     AR1096788
     C                   EVAL      DBFILE = 'STRANH '                                      AR1096788
     C                   EVAL      DBASE  = 911                                            AR1096788
     C                   EXSR      SRERR                                                   AR1096788
     C                   ENDIF                                                             AR1096788
      *                                                                                    AR1096788
     C                   IF        A_VFTYLC = 'I'                                          AR1096788
     C                   Z-ADD     NAVT          TNLU                                      AR1096788
     C                   ADD       1             NAVT                                      AR1096788
     C                   ENDIF                                                             AR1096788
      *                                                                                    AR1096788
     C     SIGN          COMP      '+'                                    60               AR1096788
     C     SIGN          COMP      '-'                                    61               AR1096788
      *                                                                                    AR1096788
     C     *IN60         IFEQ      '1'                                                     AR1096788
     C     HDIW          MULT      1000          A#HTOT                                    AR1096788
     C                   ADD       HDID          A#HTOT                                    AR1096788
     C                   ADD       1             NOID                                      AR1096788
     C                   ADD       MAAM          A#HTOT                                    AR1096788
     C                   MOVEL     A#HTOT        HDIW                                      AR1096788
     C                   MOVE      A#HTOT        HDID                                      AR1096788
     C                   ENDIF                                                             AR1096788
      *                                                                                    AR1096788
     C     *IN61         IFEQ      '1'                                                     AR1096788
     C     HDDW          MULT      1000          A#HTOT                                    AR1096788
     C                   ADD       HDDD          A#HTOT                                    AR1096788
     C                   ADD       1             NODD                                      AR1096788
     C                   ADD       MAAM          A#HTOT                                    AR1096788
     C                   MOVEL     A#HTOT        HDDW                                      AR1096788
     C                   MOVE      A#HTOT        HDDD                                      AR1096788
     C                   ENDIF                                                             AR1096788
      *                                                                                    AR1096788
     C                   EVAL        RECI = 'H'                                            AR1096788
     C                   UPDATE    STRANHF                                                 AR1096788
      *                                                                                    AR1096788
     C                   ENDSR                                                             AR1096788
      *****************************************************************                    AR1096788
      /EJECT                                                                               AR1096788
      *****************************************************************                    AR1096788
      *                                                               *                    AR1096788
      * SRRevert - Update STRANH Header File - Reverse                *                    AR1096788
      *                                                               *                    AR1096788
      *****************************************************************                    AR1096788
     C     SRRevert      BEGSR                                                             AR1096788
      *                                                                                    AR1096788
      ** Update Trailer Totals depending on the sign of the amount                         AR1096788
      *                                                                                    AR1096788
     C                   Z-ADD     1             A#RRN                                     AR1096788
     C     A#RRN         CHAIN     STRANHF                            80                   AR1096788
     C                   IF        *IN80 = *ON                                             AR1096788
     C                   MOVEL     '*FIRST'      DBKEY                                     AR1096788
     C                   EVAL      DBFILE = 'STRANH '                                      AR1096788
     C                   EVAL      DBASE  = 912                                            AR1096788
     C                   EXSR      SRERR                                                   AR1096788
     C                   ENDIF                                                             AR1096788
      *                                                                                    AR1096788
     C     B_SIGN        COMP      '+'                                    60               AR1096788
     C     B_SIGN        COMP      '-'                                    61               AR1096788
      *                                                                                    AR1096788
     C     *IN60         IFEQ      '1'                                                     AR1096788
     C     HDIW          MULT      1000          A#HTOT                                    AR1096788
     C                   ADD       HDID          A#HTOT                                    AR1096788
     C                   SUB       1             NOID                                      AR1096788
     C                   SUB       B_MAAM        A#HTOT                                    AR1096788
     C                   MOVEL     A#HTOT        HDIW                                      AR1096788
     C                   MOVE      A#HTOT        HDID                                      AR1096788
     C                   ENDIF                                                             AR1096788
      *                                                                                    AR1096788
     C     *IN61         IFEQ      '1'                                                     AR1096788
     C     HDDW          MULT      1000          A#HTOT                                    AR1096788
     C                   ADD       HDDD          A#HTOT                                    AR1096788
     C                   SUB       1             NODD                                      AR1096788
     C                   SUB       B_MAAM        A#HTOT                                    AR1096788
     C                   MOVEL     A#HTOT        HDDW                                      AR1096788
     C                   MOVE      A#HTOT        HDDD                                      AR1096788
     C                   ENDIF                                                             AR1096788
      *                                                                                    AR1096788
     C                   EVAL        RECI = 'H'                                            AR1096788
     C                   UPDATE    STRANHF                                                 AR1096788
      *                                                                                    AR1096788
     C                   ENDSR                                                             AR1096788
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      **  Program Parameters
     C     *ENTRY        PLIST
      ** Return Code
     C                   PARM                    @@RTCD            7
      ** Externally described DS for valid Transaction Detail
     C                   PARM                    DLVDLAA
      *
      ** Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C                   IF        @RTCD <> *BLANK
     C                   EVAL      DBKEY  = @OPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  =  905
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     @MMOD         PARM      @MMOD         DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '906'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      SRERR
     C                   ENDIF
      ** Check if switchable feature CIR002 is switched on
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CIR002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   EVAL      CIR002 = 'Y'
     C                   ELSE
     C                   EVAL      CIR002 = 'N'
     C                   ENDIF
      ** Check if switchable feature CIR006 is switched on
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CIR006'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   EVAL      CIR006 = 'Y'
     C                   ELSE
     C                   EVAL      CIR006 = 'N'
     C                   ENDIF
      *                                                                                     AR916823
      ** Check if Fiduciary Dealing is installed                                            AR916823
      *                                                                                     AR916823
     C                   CALLB     'AOSARDR0'                                               AR916823
     C                   PARM      *BLANKS       @RTCD                                      AR916823
     C                   PARM      '*VERIFY'     @OPTN                                      AR916823
     C                   PARM      'CDL006'      @SARD                                      AR916823
     C     SCSARD        PARM      SCSARD        DSFDY                                      AR916823
      *                                                                                     AR916823
     C     @RTCD         IFEQ      *BLANKS                                                  AR916823
     C                   EVAL      CDL006 = 'Y'                                             AR916823
     C                   ELSE                                                               AR916823
     C                   EVAL      CDL006 = 'N'                                             AR916823
     C                   ENDIF                                                              AR916823
      *                                                                                    AR1096788
     C                   Z-ADD     0             A#RRN             5 0                     AR1096788
     C                   Z-ADD     0             A#DIFF            5 0                     AR1096788
     C                   Z-ADD     0             A#HTOT           18 0                     AR1096788
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                              *
      * SRERR - EXCEPTION ERRORS                                     *
      *                                                              *
      ****************************************************************
     C     SRERR         BEGSR
      *
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'DLDLAAUPD'   DBPGM            10
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
      **  Terminate the Program
     C                   RETURN
      *
     C                   ENDSR
     C****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
