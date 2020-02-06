     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('SD Currency/Time of Netting Details Update')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCTNMUPD - SD Currency/Time of Netting Details              *
      *              Database Update                                  *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1086546 *CREATE  Date 13Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1086546 - Upgrade of CDL025 to MP1.4 (Child: AR1086547).   *
      *              Applied for MD021813                             *
      *                                                               *
      *****************************************************************
 
      * Currency/Time of Netting Details Master File Update
     FSDCTNML0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
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
     D TimeStamp       S               Z
 
     D ChkCTNMFmt    E DS                  EXTNAME(SDVCTNMPD)
     D                                     PREFIX(CH)
      ** Rename fields for Timestamp checking
 
     D SDVCTNM       E DS                  EXTNAME(SDVCTNMPD)
     D                                     PREFIX(A_)
      ** Externally desc'd DS for valid Currency/Time if Netting
      ** Details
 
     D OKCtnmDets    E DS                  EXTNAME(SDECTNMPD)
      ** Error indicators
 
     D B_CTNMF       E DS                  EXTNAME(SDCTNMPD)
     D                                     PREFIX(B_)
      ** Externally described DS for 'BEFORE UPDATE' Currency/Time
      ** of Netting Details
 
      ** Currency/Time of Netting Details File
     D CTNMF         E DS                  EXTNAME(SDCTNMPD)
 
      ** Data Structures for use with access programs
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data structure for bank details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long data structure
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
      ** Outward parameters
      **RCD : Midas SD Deleted records file retrieval
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
 
     D @Timestamp      S             26Z
 
      ** Account sequence field (packed) for call to CLINTSE
     D WKACSN          S              2P 0
 
     D Ccy1_Arr        S              3    DIM(10)
      ** Ccy 1 Array
 
     D Ccy2_Arr        S              3    DIM(10)
      ** Ccy 2 Array
 
     D Time_Arr        S              4    DIM(10)
      ** Time Array
 
     D RNot_Arr        S              1  0 DIM(10)
      ** Release Notice Days Array
 
     D Ctr             S              3P 0
 
     D From_Cust       S              1
      **From Customer Flag
 
     D PRTCD           S              7A
     D PRETURN         S              6A
     D PTYPE           S              1A
     D PMODE           S              6A
     D PRSMD           S              1A
     D PACTN           S              1A
     D Ix              S              3P 0
     D C               S              2P 0
     D DBError         S            132A
     D MsgSndRtn       S              2A
     D WriteY          S              1A
 
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main processing                                        *
      *                                                               *
      *****************************************************************
 
      ** Insert, Amend or Delete the transaction
 
     C     A_TNTYLC      CASEQ     'I'           SRINSERT
     C     A_TNTYLC      CASEQ     'A'           SRAMEND
     C     A_TNTYLC      CASEQ     'D'           SRDELETE
     C                   ENDCS
 
      ** Exit From Program
 
     C     EXIT          TAG
 
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
 
     C                   PARM                    PRTCD
 
      ** Externally described DS for valid Currency/Time of
      ** Netting Details
 
     C                   PARM                    SDVCTNM
 
      ** From Customer Flag
 
     C                   PARM                    From_Cust
 
      ** Obtain default message file
     C     *DtaAra       Define    Y2MGFLA       ZADFMF           10
     C                   In        ZADFMF
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        @RTCD <> *BLANK
     C                   EVAL      DBKEY  = @OPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  =  909
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)
 
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    PReturn
     C                   PARM                    PType
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINSERT - Insert a transaction                              *
      *                                                               *
      *****************************************************************
     C     SRINSERT      BEGSR
 
      ** Initialise Currency/Time of Netting Details
 
     C                   CLEAR                   CTNMF
 
      ** SET Currency/Netting Time FIELDS ON INSERT
 
     C                   MOVEL     A_TNCUST      LCUST
     C                   MOVEL     A_TNTYLC      LTYLC
     C                   MOVEL     A_TNLCD       LLCD
 
     C                   Clear                   Ccy1_Arr
     C                   Clear                   Ccy2_Arr
     C                   Clear                   Time_Arr
     C                   Clear                   RNot_Arr
     C                   EXSR      SRPop_CodSet
     C                   Eval      Ctr = 1
 
     C                   DOW       Ctr < 11
 
      ** Store Old fields for comparisons
 
     C                   CLEAR                   B_CTNMF
     C                   IF        Ctr <> 1 and Ccy1_Arr(Ctr)=*BLANKS
     C                   LEAVE
     C                   ELSE
 
      ** Set up fields
 
     C                   MOVEL     Ccy1_Arr(Ctr) LCCY1
     C                   MOVEL     Ccy2_Arr(Ctr) LCCY2
     C                   MOVEL     Time_Arr(Ctr) LTIME
     C                   MOVEL     RNot_Arr(Ctr) LRNTD
 
     C     LCCY2         IFEQ      *BLANKS
     C                   MOVEL     'N'           LNTCP
     C                   ELSE
     C                   MOVEL     'Y'           LNTCP
     C                   ENDIF
 
      ** Write new Currency/Time of Netting Detail
 
     C                   WRITE     SDCTNMP0                             23
     C                   IF        *IN23 = *ON
     C                   EVAL      DBKEY  = A_TNCUST
     C                   EVAL      DBFILE = 'SDCTNMPD'
     C                   EVAL      DBASE  =  901
     C                   EXSR      *PSSR
     C                   ELSE
     C                   ADD       1             Ctr
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      *  SRAMEND  - Amend a transaction                              *
      *                                                              *
      ****************************************************************
     C     SRAMEND       BEGSR
 
      ** Access Currency/Time of Netting Details
 
     C     A_TNCUST      CHAIN     SDCTNML0                           9998
 
      ** Record Locked
 
     C     *IN98         IFEQ      *ON
     C                   EVAL      DBKEY  = A_TNCUST
     C                   EVAL      DBFILE = 'SDCTNMPD'
     C                   EVAL      DBASE  =  903
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'I'           A_TNTYLC
     C                   ELSE
     C                   MOVEL     'A'           A_TNTYLC
     C                   ENDIF
 
      ** Set Currency/Time of Netting Fields on Amend
 
     C                   MOVEL     A_TNCUST      LCUST
     C                   Clear                   Ccy1_Arr
     C                   Clear                   Ccy2_Arr
     C                   Clear                   Time_Arr
     C                   Clear                   RNot_Arr
     C                   EXSR      SRPop_CodSet
     C                   Eval      Ctr = 1
 
      ** Read Currency/Time of Netting Details File
 
     C     A_TNCUST      SETLL     SDCTNML0
     C     A_TNCUST      READE     SDCTNML0                               22
 
     C                   DOW       *IN22 = *OFF
     C                   DELETE    SDCTNMP0
     C     A_TNCUST      READE     SDCTNML0                               22
     C                   ENDDO
 
     C                   MOVE      *BLANK        WriteY
     C                   MOVEL     A_TNTYLC      LTYLC
     C                   MOVEL     A_TNLCD       LLCD
 
     C                   DOW       Ctr < 11
 
     C                   IF        Ccy1_Arr(Ctr)<>*BLANKS
 
      ** Store old fields for comparisons
 
     C                   MOVEL(P)  CTNMF         B_CTNMF
 
      ** Set up fields
 
     C                   MOVEL     Ccy1_Arr(Ctr) LCCY1
     C                   MOVEL     Ccy2_Arr(Ctr) LCCY2
     C                   MOVEL     Time_Arr(Ctr) LTIME
     C                   MOVEL     RNot_Arr(Ctr) LRNTD
 
     C     LCCY2         IFEQ      *BLANKS
     C                   MOVEL     'N'           LNTCP
     C                   ELSE
     C                   MOVEL     'Y'           LNTCP
     C                   ENDIF
 
      ** Write/update file
 
     C                   IF        *IN22 = *ON
     C                   WRITE     SDCTNMP0                             23
     C                   MOVE      'Y'           WriteY
     C                   ENDIF
 
     C                   IF        *IN23 = *ON
     C                   EVAL      DBKEY  = A_TNCUST
     C                   EVAL      DBFILE = 'SDCTNMPD'
     C                   EVAL      DBASE  =  905
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ADD       1             Ctr
     C                   ENDDO
 
     C                   IF        WriteY <> 'Y'
     C     LCCY2         IFEQ      *BLANKS
     C                   MOVEL     'N'           LNTCP
     C                   ELSE
     C                   MOVEL     'Y'           LNTCP
     C                   ENDIF
     C                   WRITE     SDCTNMP0
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      *  SRDELETE - Delete a transaction                             *
      *                                                              *
      ****************************************************************
     C     SRDELETE      BEGSR
 
      ** Access Currency/Time of Netting Details
 
     C     A_TNCUST      CHAIN     SDCTNML0                           9998
 
      ** Record not existing
 
     C                   IF        *IN99 = *ON
     C                   EVAL      DBKEY  = A_TNCUST
     C                   EVAL      DBFILE = 'SDCTNMPD'
     C                   EVAL      DBASE  =  906
     C                   EXSR      *PSSR
     C                   ENDIF
      ** Record Locked
     C                   IF        *IN98 = *ON
     C                   EVAL      DBKEY  = A_TNCUST
     C                   EVAL      DBFILE = 'SDCTNMPD'
     C                   EVAL      DBASE  =  907
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Clear                   Ccy1_Arr
     C                   Clear                   Ccy2_Arr
     C                   Clear                   Time_Arr
     C                   Clear                   RNot_Arr
     C                   EXSR      SRPop_CodSet
     C                   MOVE      *OFF          *IN01
     C                   MOVE      *OFF          *IN02
 
     C     A_TNCUST      SETLL     SDCTNML0
     C     *IN01         DOWEQ     *OFF
     C     A_TNCUST      READE     SDCTNML0                               01
 
     C                   IF        *IN01
     C                   ITER
     C                   ENDIF
 
      ** Update 'BEFORE' status
 
     C                   MOVEL(P)  CTNMF         B_CTNMF
 
     C                   IF        *IN01 = *OFF
 
     C                   DELETE    SDCTNMP0                             02
 
     C                   IF        *IN02
     C                   EVAL      DBKEY  = A_TNCUST
     C                   EVAL      DBFILE = 'SDCTNMPD'
     C                   EVAL      DBASE  =  908
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
      ****************************************************************
      /EJECT
 
      *****************************************************************
      *                                                               *
      *  SRPop_CodSet - Populate Currency, Time & Release Notice Days *
      *                                                               *
      *****************************************************************
     C     SRPop_CodSet  BEGSR
      *
     C                   Eval      Ccy1_Arr(1) = A_TNCCY1_1
     C                   Eval      Ccy2_Arr(1) = A_TNCCY2_1
     C                   Eval      Time_Arr(1) = A_TNTIME_1
     C                   Eval      RNot_Arr(1) = A_TNRNTD_1
     C                   Eval      Ccy1_Arr(2) = A_TNCCY1_2
     C                   Eval      Ccy2_Arr(2) = A_TNCCY2_2
     C                   Eval      Time_Arr(2) = A_TNTIME_2
     C                   Eval      RNot_Arr(2) = A_TNRNTD_2
     C                   Eval      Ccy1_Arr(3) = A_TNCCY1_3
     C                   Eval      Ccy2_Arr(3) = A_TNCCY2_3
     C                   Eval      Time_Arr(3) = A_TNTIME_3
     C                   Eval      RNot_Arr(3) = A_TNRNTD_3
     C                   Eval      Ccy1_Arr(4) = A_TNCCY1_4
     C                   Eval      Ccy2_Arr(4) = A_TNCCY2_4
     C                   Eval      Time_Arr(4) = A_TNTIME_4
     C                   Eval      RNot_Arr(4) = A_TNRNTD_4
     C                   Eval      Ccy1_Arr(5) = A_TNCCY1_5
     C                   Eval      Ccy2_Arr(5) = A_TNCCY2_5
     C                   Eval      Time_Arr(5) = A_TNTIME_5
     C                   Eval      RNot_Arr(5) = A_TNRNTD_5
     C                   Eval      Ccy1_Arr(6) = A_TNCCY1_6
     C                   Eval      Ccy2_Arr(6) = A_TNCCY2_6
     C                   Eval      Time_Arr(6) = A_TNTIME_6
     C                   Eval      RNot_Arr(6) = A_TNRNTD_6
     C                   Eval      Ccy1_Arr(7) = A_TNCCY1_7
     C                   Eval      Ccy2_Arr(7) = A_TNCCY2_7
     C                   Eval      Time_Arr(7) = A_TNTIME_7
     C                   Eval      RNot_Arr(7) = A_TNRNTD_7
     C                   Eval      Ccy1_Arr(8) = A_TNCCY1_8
     C                   Eval      Ccy2_Arr(8) = A_TNCCY2_8
     C                   Eval      Time_Arr(8) = A_TNTIME_8
     C                   Eval      RNot_Arr(8) = A_TNRNTD_8
     C                   Eval      Ccy1_Arr(9) = A_TNCCY1_9
     C                   Eval      Ccy2_Arr(9) = A_TNCCY2_9
     C                   Eval      Time_Arr(9) = A_TNTIME_9
     C                   Eval      RNot_Arr(9) = A_TNRNTD_9
     C                   Eval      Ccy1_Arr(10) = A_TNCCY1_10
     C                   Eval      Ccy2_Arr(10) = A_TNCCY2_10
     C                   Eval      Time_Arr(10) = A_TNTIME_10
     C                   Eval      RNot_Arr(10) = A_TNRNTD_10
      *
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
 
      ** Note: if non-standard processing required, use the PSSR_ILENE
      ** subroutine
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2013
