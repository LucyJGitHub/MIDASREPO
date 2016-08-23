     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Customer Risk Weighted Assets details database upd')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDRWANUPD - Customer Risk Weighted Assets Details            *
      *              database update                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. BG12238            Date 24Oct06               *
      *  Prev Amend No. CRE026  *CREATE    Date 16May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BG12238 - Conditional writes to files within wholesale/      *
      *            universal customer input                           *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
 
      * Customer Risk Weighted Asset Master File Update
     FSDCRWAL0  UF A E           K DISK    INFSR(*PSSR)
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
 
     D ChkRwanFmt    E DS                  EXTNAME(SDVRWANPD)
     D                                     PREFIX(CH)
      ** Rename fields for Timestamp checking
 
     D SDVRwan       E DS                  EXTNAME(SDVRWANPD)
     D                                     PREFIX(A_)
      ** Externally desc'd DS for valid Customer Risk Weighted Assets
      ** Details
 
     D OKRwaDets     E DS                  EXTNAME(SDERWANPD)
      ** Error indicators
 
     D B_RWANF       E DS                  EXTNAME(SDCRWAPD)
     D                                     PREFIX(B_)
      ** Externally described DS for 'BEFORE UPDATE' Risk Weighted
      ** Assets
 
      ** Customer Risk Weighted Assets Details File
     D RWANF         E DS                  EXTNAME(SDCRWAPD)
 
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
 
     D Cod_Arr         S              2    DIM(36)
      ** RWA Cod_Arr
 
     D Set_Arr         S              1    DIM(36)
      ** RWA Set_Arr
 
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
 
      ** Ensure transaction has not been updated by another workstation
      ** - if so, bypass updating and return to calling program.
 
     C                   EXSR      SRCHKOTHUPD
 
     C                   IF        PRTCD <> *BLANKS
     C                   GOTO      EXIT
     C                   ENDIF
 
      ** Insert, Amend or Delete the transaction
 
     C     A_RACHTP      CASEQ     'I'           SRINSERT
     C     A_RACHTP      CASEQ     'A'           SRAMEND
     C     A_RACHTP      CASEQ     'D'           SRDELETE
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
 
      ** Externally described DS for valid Customer Risk Weighted
      ** Assets Details
 
     C                   PARM                    SDVRWAN
 
      ** From Customer Flag
 
     C                   PARM                    From_Cust
 
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
      *  SRCHKOTHUPD - Check for update by another workstation        *
      *                                                               *
      *****************************************************************
     C     SRCHKOTHUPD   BEGSR
 
      ** Retrieve current Customer details
 
     C                   CALLB     'SDRWANRTV'
 
      ** Inputs
      ** Return code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
 
     C                   PARM                    PMODE
 
      ** Response mode
 
     C                   PARM      ' '           PRSMD
 
      ** Action Code
 
     C                   PARM      A_RACHTP      PACTN
 
      ** Midas Customer Number
 
     C                   PARM                    A_RACUST
 
      ** From Customer Flag
 
     C                   PARM                    From_Cust
 
      ** Outputs
      ** Customer Risk Weighted Assets Details in File Format
 
     C                   PARM                    ChkRwanFmt
 
      ** OK - Action Code
 
     C                   PARM      *BLANK        DDACTNOK
 
      ** OK - Customer Number
 
     C                   PARM                    DDCUSTOK
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM      *BLANK        FldNameArr
     C                   PARM      *BLANK        MsgIdArr
     C                   PARM      *BLANK        MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM      *ZERO         Ix
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
 
     C                   IF        From_Cust = 'N'
 
     C                   IF        PTYPE = '1'
 
     C                   IF        CHRATMST <> A_RATMST
     C                   EVAL      PRTCD = '*RECUPD'
     C                   ENDIF
 
      ** Batch mode:
 
     C                   ELSE
     C                   IF        DDACTNOK = 'N' OR
     C                             DDCUSTOK = 'N'
     C                   EVAL      PRTCD = '*RECUPD'
     C                   Z-ADD     1             C
 
     C                   DOW       C < ArrayMax AND
     C                             FldNameArr(C) <> *BLANKS
     C                   CLEAR                   DBError
     C                   EVAL      DBerror = 'Update error: '
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
     C                   ADD       1             C
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINSERT - Insert a transaction                              *
      *                                                               *
      *****************************************************************
     C     SRINSERT      BEGSR
 
      ** Access Customer Risk Weighted Assets Details
 
     C     A_RACUST      CHAIN     SDCRWAL0                           99
 
      ** Database error
 
     C                   IF        *IN99 = *OFF
     C                   EVAL      DBKEY = A_RACUST
     C                   EVAL      DBFILE = 'SDCRWAPD'
     C                   EVAL      DBASE =  900
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialise Customer Risk Weighted Assets Details
 
     C                   CLEAR                   RWANF
 
      ** SET Customer Risk Weighted Assets FIELDS ON INSERT
 
     C                   MOVEL     A_RARECI      RWRECI
     C                   MOVEL     A_RACUST      RWCUST
     C                   MOVEL     A_RACHTP      RWCHTP
     C                   MOVEL     A_RALCD       RWLCD
 
      ** Timestamp
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
     C                   EVAL      RWTMST  = TimeStamp
     C                   Clear                   Cod_Arr
     C                   Clear                   Set_Arr
     C                   EXSR      SRPop_CodSet
     C                   Eval      Ctr = 1
      *
     C                   DOW       Ctr < 37
 
      ** Store Old fields for comparisons
 
     C                   CLEAR                   B_RWANF
     C                   IF        Ctr <> 1 and Cod_Arr(Ctr)=*BLANKS and
     C                             Set_Arr(Ctr)=*BLANKS
     C                   LEAVE
     C                   ELSE
 
      ** Set up fields
 
     C                   MOVEL     Cod_Arr(Ctr)  RWCODE
     C                   MOVEL     Set_Arr(Ctr)  RWSETN
 
      ** Write new Risk Weighted Assets Detail
 
     C                   WRITE     SDCRWAD0                             23
     C                   IF        *IN23 = *ON
     C                   EVAL      DBKEY  = A_RACUST
     C                   EVAL      DBFILE = 'SDCRWAPD'
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
 
      ** Access Customer Risk Weighted Assets Details
 
     C     A_RACUST      CHAIN     SDCRWAL0                           9998
      ***Database error                                                                      BG12238
     C**********         IF        *IN99 = *ON                                               BG12238
     C**********         EVAL      DBKEY  = A_RACUST                                         BG12238
     C**********         EVAL      DBFILE = 'SDCRWAPD'                                       BG12238
     C**********         EVAL      DBASE  =  902                                             BG12238
     C**********         EXSR      *PSSR                                                     BG12238
     C**********         ENDIF                                                               BG12238
      **Record Locked
 
     C                   IF        *IN98 = *ON
     C                   EVAL      DBKEY  = A_RACUST
     C                   EVAL      DBFILE = 'SDCRWAPD'
     C                   EVAL      DBASE  =  903
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                      BG12238
     C     *IN99         IFEQ      '1'                                                       BG12238
     C                   MOVEL     'I'           A_RACHTP                                    BG12238
     C                   ELSE                                                                BG12238
      *                                                                                      BG12238
     C                   MOVEL     'A'           A_RACHTP                                    BG12238
     C                   ENDIF                                                               BG12238
 
      ** SET Customer Risk Weighted Assets FIELDS ON AMEND
 
     C                   MOVEL     A_RARECI      RWRECI
     C                   MOVEL     A_RACUST      RWCUST
     C                   Clear                   Cod_Arr
     C                   Clear                   Set_Arr
     C                   EXSR      SRPop_CodSet
     C                   Eval      Ctr = 1
 
      ** Read Risk Weighted Assets File
 
     C     A_RACUST      SETLL     SDCRWAL0
     C     A_RACUST      READE     SDCRWAL0                               22
      *
      ***Error*if record not found                                                           BG12238
     C**********         IF        *IN22 = *ON                                               BG12238
     C**********         EVAL      DBKEY  = A_RACUST                                         BG12238
     C**********         EVAL      DBFILE = 'SDCRWAPD'                                       BG12238
     C**********         EVAL      DBASE  =  904                                             BG12238
     C**********         EXSR      *PSSR                                                     BG12238
     C**********         ENDIF                                                               BG12238
      *
     C                   DOW       *IN22 = *OFF
     C                   DELETE    SDCRWAD0
     C     A_RACUST      READE     SDCRWAL0                               22
     C                   ENDDO
 
      ** Timestamp
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
      *
     C                   EVAL      RWTMST  = TimeStamp
      *
     C                   MOVE      *BLANK        WriteY
      *
     C                   DOW       Ctr < 37
      *
     C                   IF        Cod_Arr(Ctr)<>*BLANKS and
     C                             Set_Arr(Ctr)<>*BLANKS
 
      ** Store old fields for comparisons
 
     C                   MOVEL(P)  RWANF         B_RWANF
 
      ** Set up fields
 
     C**********         IF        A_RACHTP = 'A'                                            BG12238
      *
     C                   MOVEL     Cod_Arr(Ctr)  RWCODE
     C                   MOVEL     Set_Arr(Ctr)  RWSETN
     C                   MOVEL     A_RACHTP      RWCHTP
     C                   MOVEL     A_RALCD       RWLCD
 
      ** Write/update file
 
     C                   IF        *IN22 = *ON
     C                   WRITE     SDCRWAD0                             23
     C                   MOVE      'Y'           WriteY
     C                   ENDIF
      *
     C                   IF        *IN23 = *ON
     C                   EVAL      DBKEY  = A_RACUST
     C                   EVAL      DBFILE = 'SDCRWAPD'
     C                   EVAL      DBASE  =  905
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C**********         ELSE                                                                BG12238
     C**********         DELETE    SDCRWAD0                                                  BG12238
     C**********         ENDIF                                                               BG12238
      *
      *
     C                   ENDIF
      *
     C                   ADD       1             Ctr
      *
     C                   ENDDO
      *
     C                   IF        WriteY <> 'Y'
     C                   WRITE     SDCRWAD0
     C                   ENDIF
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      *  SRDELETE - Delete a transaction                             *
      *                                                              *
      ****************************************************************
     C     SRDELETE      BEGSR
 
      ** Access Customer Risk Weighted Assets Details
 
     C     A_RACUST      CHAIN     SDCRWAL0                           9998
 
      ** Database error
 
     C                   IF        *IN99 = *ON
     C                   EVAL      DBKEY  = A_RACUST
     C                   EVAL      DBFILE = 'SDCRWAPD'
     C                   EVAL      DBASE  =  906
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Record Locked
 
     C                   IF        *IN98 = *ON
     C                   EVAL      DBKEY  = A_RACUST
     C                   EVAL      DBFILE = 'SDCRWAPD'
     C                   EVAL      DBASE  =  907
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Clear                   Cod_Arr
     C                   Clear                   Set_Arr
     C                   EXSR      SRPop_CodSet
 
     C                   MOVE      *OFF          *IN01
     C                   MOVE      *OFF          *IN02
     C     A_RACUST      SETLL     SDCRWAL0
     C     *IN01         DOWEQ     *OFF
     C     A_RACUST      READE     SDCRWAL0                               01
 
     C                   IF        *IN01
     C                   ITER
     C                   ENDIF
     C
 
      ** Update 'BEFORE' status
 
     C                   MOVEL(P)  RWANF         B_RWANF
 
     C                   IF        *IN01 = *OFF
     C                   DELETE    SDCRWAD0                             02
      *
     C                   IF        *IN02
     C                   EVAL      DBKEY  = A_RACUST
     C                   EVAL      DBFILE = 'SDCRWAPD'
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
      *  SRPop_CodSet - Populate code & Set array                     *
      *                                                               *
      *****************************************************************
     C     SRPop_CodSet  BEGSR
      *
     C                   Eval      Cod_Arr(1) = A_RACOD1
     C                   Eval      Set_Arr(1) = A_RASET1
     C                   Eval      Cod_Arr(2) = A_RACOD2
     C                   Eval      Set_Arr(2) = A_RASET2
     C                   Eval      Cod_Arr(3) = A_RACOD3
     C                   Eval      Set_Arr(3) = A_RASET3
     C                   Eval      Cod_Arr(4) = A_RACOD4
     C                   Eval      Set_Arr(4) = A_RASET4
     C                   Eval      Cod_Arr(5) = A_RACOD5
     C                   Eval      Set_Arr(5) = A_RASET5
     C                   Eval      Cod_Arr(6) = A_RACOD6
     C                   Eval      Set_Arr(6) = A_RASET6
     C                   Eval      Cod_Arr(7) = A_RACOD7
     C                   Eval      Set_Arr(7) = A_RASET7
     C                   Eval      Cod_Arr(8) = A_RACOD8
     C                   Eval      Set_Arr(8) = A_RASET8
     C                   Eval      Cod_Arr(9) = A_RACOD9
     C                   Eval      Set_Arr(9) = A_RASET9
     C                   Eval      Cod_Arr(10) = A_RACOD10
     C                   Eval      Set_Arr(10) = A_RASET10
     C                   Eval      Cod_Arr(11) = A_RACOD11
     C                   Eval      Set_Arr(11) = A_RASET11
     C                   Eval      Cod_Arr(12) = A_RACOD12
     C                   Eval      Set_Arr(12) = A_RASET12
     C                   Eval      Cod_Arr(13) = A_RACOD13
     C                   Eval      Set_Arr(13) = A_RASET13
     C                   Eval      Cod_Arr(14) = A_RACOD14
     C                   Eval      Set_Arr(14) = A_RASET14
     C                   Eval      Cod_Arr(15) = A_RACOD15
     C                   Eval      Set_Arr(15) = A_RASET15
     C                   Eval      Cod_Arr(16) = A_RACOD16
     C                   Eval      Set_Arr(16) = A_RASET16
     C                   Eval      Cod_Arr(17) = A_RACOD17
     C                   Eval      Set_Arr(17) = A_RASET17
     C                   Eval      Cod_Arr(18) = A_RACOD18
     C                   Eval      Set_Arr(18) = A_RASET18
     C                   Eval      Cod_Arr(19) = A_RACOD19
     C                   Eval      Set_Arr(19) = A_RASET19
     C                   Eval      Cod_Arr(20) = A_RACOD20
     C                   Eval      Set_Arr(20) = A_RASET20
     C                   Eval      Cod_Arr(21) = A_RACOD21
     C                   Eval      Set_Arr(21) = A_RASET21
     C                   Eval      Cod_Arr(22) = A_RACOD22
     C                   Eval      Set_Arr(22) = A_RASET22
     C                   Eval      Cod_Arr(23) = A_RACOD23
     C                   Eval      Set_Arr(23) = A_RASET23
     C                   Eval      Cod_Arr(24) = A_RACOD24
     C                   Eval      Set_Arr(24) = A_RASET24
     C                   Eval      Cod_Arr(25) = A_RACOD25
     C                   Eval      Set_Arr(25) = A_RASET25
     C                   Eval      Cod_Arr(26) = A_RACOD26
     C                   Eval      Set_Arr(26) = A_RASET26
     C                   Eval      Cod_Arr(27) = A_RACOD27
     C                   Eval      Set_Arr(27) = A_RASET27
     C                   Eval      Cod_Arr(28) = A_RACOD28
     C                   Eval      Set_Arr(28) = A_RASET28
     C                   Eval      Cod_Arr(29) = A_RACOD29
     C                   Eval      Set_Arr(29) = A_RASET29
     C                   Eval      Cod_Arr(30) = A_RACOD30
     C                   Eval      Set_Arr(30) = A_RASET30
     C                   Eval      Cod_Arr(31) = A_RACOD31
     C                   Eval      Set_Arr(31) = A_RASET31
     C                   Eval      Cod_Arr(32) = A_RACOD32
     C                   Eval      Set_Arr(32) = A_RASET32
     C                   Eval      Cod_Arr(33) = A_RACOD33
     C                   Eval      Set_Arr(33) = A_RASET33
     C                   Eval      Cod_Arr(34) = A_RACOD34
     C                   Eval      Set_Arr(34) = A_RASET34
     C                   Eval      Cod_Arr(35) = A_RACOD35
     C                   Eval      Set_Arr(35) = A_RASET35
     C                   Eval      Cod_Arr(36) = A_RACOD36
     C                   Eval      Set_Arr(36) = A_RASET36
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
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
(c) Misys International Banking Systems Ltd. 2006
