     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Customer Withholding Tax details database update')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUWTUPD - Customer Withholding Tax Details                 *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD079 - Enhanced Customer Maintenance API                   *
      *                                                               *
      *****************************************************************
 
     FSDWTCSL0  UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
     F                                     RENAME(SDWTCSD0:@WTCSL0)
      ** Midas SD Withholding Tax Detail Master File
 
     FSDFCTLL0  UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
      ** Midas SD Standing Data Controls index
 
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
 
     D TimeStamp       S               Z
      ** Timestamp for the transaction
 
     D ChkCUWTFmt    E DS                  EXTNAME(SDVCUWTPD)
     D                                     PREFIX(CH)
      ** Rename fields for Timestamp checking
 
     D SDVCUWT       E DS                  EXTNAME(SDVCUWTPD)
     D                                     PREFIX(A_)
      ** Externally desc'd DS for valid Withholding Tax Detail
 
     D OKCwhDets     E DS                  EXTNAME(SDECUWTPD)
      ** Error indicators
 
     D B_CUWTF       E DS                  EXTNAME(SDWTCSPD)
     D                                     PREFIX(B_)
      ** Externally described DS for 'BEFORE UPDATE' Customer-
      ** Withholding Tax Details
 
      ** Withholding Tax Details File
     D CUWTF         E DS                  EXTNAME(SDWTCSPD)
 
      * Data Structures for use with access programs
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * Data structure for bank details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for access programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for access programs, long data structure
 
      ** Dummy message ID and message file fields for use on the calls
      ** to ZAMSGTOOPR
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
 
     D WKACSN          S              2P 0
      ** Account sequence field (packed) for call to CLINTSE
 
     D CRTT_Arr        S              2    DIM(30)
      ** Country of tax treaty Arr
 
     D INTS_Arr        S              3    DIM(30)
      ** Intermediary Status Arr
 
     D DCRC_Arr        S              1    DIM(30)
      ** Documentation received_Arr
 
     D DCEX_Arr        S              5P 0 DIM(30)
      ** Documentation Expiry Date_Arr
 
     D EXCD_Arr        S              2    DIM(30)
      ** Exemption code Arr
 
     D BCWA_Arr        S              1    DIM(30)
      ** Backup WHT applicable Y/N Arr
 
     D RPCD_Arr        S              2    DIM(30)
      ** Recipient code Arr
 
     D TXBS_Arr        S              2    DIM(30)
      ** Tax Basket Arr
 
     D RFSI_Arr        S              1    DIM(30)
      ** Report foreign src income Y/N Arr
 
     D DBTT_Arr        S              1    DIM(30)
      ** Double tax treaty Y/N Arr
 
     D TIN_Arr         S             20    DIM(30)
      ** Tax Indentification Number Arr
 
     D Ctr             S              3P 0
 
      ** Entry Parameters
     D PRETCD          S              7A
     D PRTCD           S              7A
     D POPTN           S              7A
 
     D PReturn         S              6A
     D PType           S              1A
 
     D PMODE           S              6A
     D PRSMD           S              6A
     D PACTN           S              1A
     D DDCLAS          S              1A
 
     D Ix              S              3P 0
     D WriteY          S              1A
     D WKFLNM          S             10A
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN - Main processing                                       *
      *                                                               *
      *****************************************************************
 
      ** Ensure transaction has not been updated by another workstation
      ** - if so, bypass updating and return to calling program
 
     C                   EXSR      CHKOTHUPD
 
     C                   IF        PRETCD <> *BLANKS
     C                   GOTO      EXIT
     C                   ENDIF
 
      ** Insert, Amend or Delete the transaction
 
     C     A_WTTYLC      CASEQ     'I'           INSERT
     C     A_WTTYLC      CASEQ     'A'           AMEND
     C     A_WTTYLC      CASEQ     'D'           DELETE
     C                   ENDCS
 
      ** Exit From Program
 
     C     EXIT          TAG
 
     C                   RETURN
      *****************************************************************
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
 
     C                   PARM                    PRETCD
 
      ** Externally described DS for valid Withholding Tax Detail
 
     C                   PARM                    SDVCUWT
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANK
     C                   EVAL      DBKEY  = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 909
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)
 
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    PReturn
     C                   PARM                    PType
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CHKOTHUPD - Check for update by another workstation          *
      *                                                               *
      *****************************************************************
     C     CHKOTHUPD     BEGSR
 
      ** Retrieve current Customer details
 
     C                   CALLB     'SDCUWTRTV'
 
      ** Inputs
      ** Return code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
 
     C                   PARM                    PMODE
 
      ** Response mode
 
     C                   PARM      ' '           PRSMD
 
      ** Action Code
 
     C                   PARM      A_WTTYLC      PACTN
 
      ** Midas Customer Number
 
     C                   PARM                    A_WTCSNO
 
      ** Securities Classifications
 
     C                   PARM      'D'           DDCLAS
 
      ** Outputs
      ** Withholding Tax Details in File Format
 
     C                   PARM                    ChkCUWTFmt
 
      ** OK - Action code
 
     C                   PARM      *BLANK        DDACTNOK
 
      ** OK - Customer Number
 
     C                   PARM                    DDCSNOOK
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM      *BLANK        FldNameArr
     C                   PARM      *BLANK        MsgIdArr
     C                   PARM      *BLANK        MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM      *ZERO         Ix
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  INSERT - Insert a transaction                                *
      *                                                               *
      *****************************************************************
     C     INSERT        BEGSR
 
      ** Access Withholding Tax Details
 
     C     A_WTCSNO      CHAIN     SDWTCSL0
     C                   IF        %FOUND(SDWTCSL0)
      *
     C                   EVAL      DBKEY  = A_WTCSNO
     C                   EVAL      DBFILE = 'SDWTCSPD'
     C                   EVAL      DBASE  = 900
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialise Withholding Tax Detail
 
     C                   CLEAR                   CUWTF
 
      ** Set Withholding Tax details Fields for Insert
 
     C                   EVAL        WHRECI = A_WTRECI
     C                   EVAL        WHCSNO = A_WTCSNO
     C                   EVAL        WHTYLC = A_WTTYLC
     C                   EVAL        WHLCD  = A_WTLCD
 
      ** Timestamp
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
     C                   EVAL      WHTMST  = TimeStamp
     C                   CLEAR                   CRTT_Arr
     C                   CLEAR                   INTS_Arr
     C                   CLEAR                   DCRC_Arr
     C                   CLEAR                   DCEX_Arr
     C                   CLEAR                   EXCD_Arr
     C                   CLEAR                   BCWA_Arr
     C                   CLEAR                   RPCD_Arr
     C                   CLEAR                   TXBS_Arr
     C                   CLEAR                   RFSI_Arr
     C                   CLEAR                   DBTT_Arr
     C                   CLEAR                   TIN_Arr
 
     C                   EXSR      Pop_FldArr
     C                   EVAL      Ctr = 1
 
     C                   DOW       Ctr < 31
 
      ** Store Old fields for comparisons
 
     C                   CLEAR                   B_CUWTF
     C                   IF        Ctr <> 1 and CRTT_Arr(Ctr)=*BLANKS
     C                             and INTS_Arr(Ctr)=*BLANKS and
     C                             DCRC_Arr(Ctr)=*BLANKS and
     C                             DCEX_Arr(Ctr)=*ZEROS  and
     C                             EXCD_Arr(Ctr)=*BLANKS and
     C                             BCWA_Arr(Ctr)=*BLANKS and
     C                             RPCD_Arr(Ctr)=*BLANKS and
     C                             TXBS_Arr(Ctr)=*BLANKS and
     C                             RFSI_Arr(Ctr)=*BLANKS and
     C                             DBTT_Arr(Ctr)=*BLANKS and
     C                             TIN_Arr(Ctr)=*BLANKS
     C                   LEAVE
     C                   ELSE
 
      ** Set up fields
 
     C                   MOVEL     CRTT_Arr(Ctr) WHCRTT
     C                   MOVEL     INTS_Arr(Ctr) WHINTS
     C                   MOVEL     DCRC_Arr(Ctr) WHDCRC
     C                   MOVEL     DCEX_Arr(Ctr) WHDCEX
     C                   MOVEL     EXCD_Arr(Ctr) WHEXCD
     C                   MOVEL     BCWA_Arr(Ctr) WHBCWA
     C                   MOVEL     RPCD_Arr(Ctr) WHRPCD
     C                   MOVEL     TXBS_Arr(Ctr) WHTXBS
     C                   MOVEL     RFSI_Arr(Ctr) WHRFSI
     C                   MOVEL     DBTT_Arr(Ctr) WHDBTT
     C                   MOVEL     TIN_Arr(Ctr)  WHTIN
 
      ** Write new Withholding Tax Detail
 
     C                   WRITE     @WTCSL0                              23
     C                   IF        *IN23 = *ON
     C                   EVAL      DBKEY  = A_WTCSNO
     C                   EVAL      DBFILE = 'SDWTCSPD'
     C                   EVAL      DBASE  =  901
     C                   EXSR      *PSSR
     C                   ELSE
     C                   ADD       1             Ctr
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
      ** Update SD Standing Data Control File
 
     C                   EXSR      UPDCTRL
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  AMEND  - Amend a transaction                                 *
      *                                                               *
      *****************************************************************
     C     AMEND         BEGSR
 
      ** Access Withholding Tax Details
 
     C     A_WTCSNO      CHAIN     SDWTCSL0                           9998
 
      ** Database error
 
     C                   IF        *IN99 = *ON
     C                   EVAL      DBKEY  = A_WTCSNO
     C                   EVAL      DBFILE = 'SDWTCSPD'
     C                   EVAL      DBASE  =902
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Record Locked
 
     C                   IF        *IN98 = *ON
     C                   EVAL      DBKEY  = A_WTCSNO
     C                   EVAL      DBFILE = 'SDWTCSPD'
 
     C                   EVAL      DBASE  =  903
 
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set Withholding Tax detail fields on Amend
 
     C                   EVAL      WHRECI = A_WTRECI
     C                   EVAL      WHCSNO = A_WTCSNO
 
     C                   CLEAR                   CRTT_Arr
     C                   CLEAR                   INTS_Arr
     C                   CLEAR                   DCRC_Arr
     C                   CLEAR                   DCEX_Arr
     C                   CLEAR                   EXCD_Arr
     C                   CLEAR                   BCWA_Arr
     C                   CLEAR                   RPCD_Arr
     C                   CLEAR                   TXBS_Arr
     C                   CLEAR                   RFSI_Arr
     C                   CLEAR                   DBTT_Arr
     C                   CLEAR                   TIN_Arr
 
     C                   EXSR      Pop_FldArr
     C                   Eval      Ctr = 1
 
      ** Read Withholding Tax Details File
 
     C     A_WTCSNO      SETLL     SDWTCSL0
     C     A_WTCSNO      READE     SDWTCSL0                               22
 
      ** Error if record not found
 
     C                   IF        *IN22 = *ON
     C                   EVAL      DBKEY  = A_WTCSNO
     C                   EVAL      DBFILE = 'SDWTCSPD'
     C                   EVAL      DBASE  =  904
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   DOW       *IN22 = *OFF
     C                   DELETE    SDWTCSL0
     C     A_WTCSNO      READE     SDWTCSL0                               22
     C                   ENDDO
 
      ** Timestamp
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
     C                   EVAL      WHTMST  = TimeStamp
 
     C                   MOVE      *BLANK        WriteY
 
     C                   DOW       Ctr < 31
     C                   IF        CRTT_Arr(Ctr)<>*BLANKS
 
      ** Store old fields for comparisons
 
     C                   MOVEL(P)  CUWTF         B_CUWTF
 
      ** Set up fields
 
     C                   IF        A_WTTYLC = 'A'
 
     C                   MOVEL     A_WTTYLC      WHTYLC
     C                   MOVEL     A_WTLCD       WHLCD
     C                   MOVEL     CRTT_Arr(Ctr) WHCRTT
     C                   MOVEL     INTS_Arr(Ctr) WHINTS
     C                   MOVEL     DCRC_Arr(Ctr) WHDCRC
     C                   MOVEL     DCEX_Arr(Ctr) WHDCEX
     C                   MOVEL     EXCD_Arr(Ctr) WHEXCD
     C                   MOVEL     BCWA_Arr(Ctr) WHBCWA
     C                   MOVEL     RPCD_Arr(Ctr) WHRPCD
     C                   MOVEL     TXBS_Arr(Ctr) WHTXBS
     C                   MOVEL     RFSI_Arr(Ctr) WHRFSI
     C                   MOVEL     DBTT_Arr(Ctr) WHDBTT
     C                   MOVEL     TIN_Arr(Ctr)  WHTIN
 
      ** Write/update file
 
     C                   IF        *IN22 = *ON
     C                   WRITE     @WTCSL0                              23
     C                   MOVE      'Y'           WriteY
 
     C                   ENDIF
 
     C                   IF        *IN23 = *ON
     C                   EVAL      DBKEY  = A_WTCSNO
     C                   EVAL      DBFILE = 'SDWTCSPD'
 
     C                   EVAL      DBASE  =  905
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ELSE
     C                   DELETE    @WTCSL0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ADD       1             Ctr
 
     C                   ENDDO
 
     C                   IF        WriteY <> 'Y'
     C                   WRITE     @WTCSL0
     C                   ENDIF
 
      ** Update SD Standing Data Control File
 
     C                   EXSR      UPDCTRL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  DELETE - Delete a transaction                                *
      *                                                               *
      *****************************************************************
     C     DELETE        BEGSR
 
      ** Access Withholding Tax Details
 
     C     A_WTCSNO      CHAIN     SDWTCSL0                           9998
 
      ** Database error
 
     C                   IF        *IN99 = *ON
     C                   EVAL      DBKEY  = A_WTCSNO
     C                   EVAL      DBFILE = 'SDWTCSPD'
     C                   EVAL      DBASE  =906
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Record Locked
 
     C                   IF        *IN98 = *ON
     C                   EVAL      DBKEY  = A_WTCSNO
     C                   EVAL      DBFILE = 'SDWTCSPD'
     C                   EVAL      DBASE  =907
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   CLEAR                   CRTT_Arr
     C                   CLEAR                   INTS_Arr
     C                   CLEAR                   DCRC_Arr
     C                   CLEAR                   DCEX_Arr
     C                   CLEAR                   EXCD_Arr
     C                   CLEAR                   BCWA_Arr
     C                   CLEAR                   RPCD_Arr
     C                   CLEAR                   TXBS_Arr
     C                   CLEAR                   RFSI_Arr
     C                   CLEAR                   DBTT_Arr
     C                   CLEAR                   TIN_Arr
 
     C                   EXSR      Pop_FldArr
 
     C                   MOVE      *OFF          *IN01
     C                   MOVE      *OFF          *IN02
     C     A_WTCSNO      SETLL     SDWTCSL0
     C     *IN01         DOWEQ     *OFF
     C     A_WTCSNO      READE     SDWTCSL0                               01
 
     C                   IF        *IN01
     C                   ITER
     C                   ENDIF
     C
 
      ** Update 'BEFORE' status
 
     C                   MOVEL(P)  CUWTF         B_CUWTF
 
     C                   IF        *IN01 = *OFF
 
      ** Delete record
 
     C                   DELETE    @WTCSL0                              02
     C
     C                   IF        *IN02
     C                   EVAL      DBKEY  = A_WTCSNO
     C                   EVAL      DBFILE = 'SDWTCSPD'
     C                   EVAL      DBASE  =908
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
      ** Update SD Standing Data Control File
 
     C                   EXSR      UPDCTRL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Pop_FldArr - Populate Fields Array                           *
      *                                                               *
      *****************************************************************
     C     PoP_FldArr    BEGSR
      *
     C                   EVAL      CRTT_Arr(1)  = A_WTCRTT1
     C                   EVAL      INTS_Arr(1)  = A_WTINTS1
     C                   EVAL      DCRC_Arr(1)  = A_WTDCRC1
     C                   EVAL      DCEX_Arr(1)  = A_WTDCEX1
     C                   EVAL      EXCD_Arr(1)  = A_WTEXCD1
     C                   EVAL      BCWA_Arr(1)  = A_WTBCWA1
     C                   EVAL      RPCD_Arr(1)  = A_WTRPCD1
     C                   EVAL      TXBS_Arr(1)  = A_WTTXBS1
     C                   EVAL      RFSI_Arr(1)  = A_WTRFSI1
     C                   EVAL      DBTT_Arr(1)  = A_WTDBTT1
     C                   EVAL      TIN_Arr(1)   = A_WTTIN1
      *
     C                   EVAL      CRTT_Arr(2)  = A_WTCRTT2
     C                   EVAL      INTS_Arr(2)  = A_WTINTS2
     C                   EVAL      DCRC_Arr(2)  = A_WTDCRC2
     C                   EVAL      DCEX_Arr(2)  = A_WTDCEX2
     C                   EVAL      EXCD_Arr(2)  = A_WTEXCD2
     C                   EVAL      BCWA_Arr(2)  = A_WTBCWA2
     C                   EVAL      RPCD_Arr(2)  = A_WTRPCD2
     C                   EVAL      TXBS_Arr(2)  = A_WTTXBS2
     C                   EVAL      RFSI_Arr(2)  = A_WTRFSI2
     C                   EVAL      DBTT_Arr(2)  = A_WTDBTT2
     C                   EVAL      TIN_Arr(2)   = A_WTTIN2
      *
     C                   EVAL      CRTT_Arr(3)  = A_WTCRTT3
     C                   EVAL      INTS_Arr(3)  = A_WTINTS3
     C                   EVAL      DCRC_Arr(3)  = A_WTDCRC3
     C                   EVAL      DCEX_Arr(3)  = A_WTDCEX3
     C                   EVAL      EXCD_Arr(3)  = A_WTEXCD3
     C                   EVAL      BCWA_Arr(3)  = A_WTBCWA3
     C                   EVAL      RPCD_Arr(3)  = A_WTRPCD3
     C                   EVAL      TXBS_Arr(3)  = A_WTTXBS3
     C                   EVAL      RFSI_Arr(3)  = A_WTRFSI3
     C                   EVAL      DBTT_Arr(3)  = A_WTDBTT3
     C                   EVAL      TIN_Arr(3)   = A_WTTIN3
      *
     C                   EVAL      CRTT_Arr(4)  = A_WTCRTT4
     C                   EVAL      INTS_Arr(4)  = A_WTINTS4
     C                   EVAL      DCRC_Arr(4)  = A_WTDCRC4
     C                   EVAL      DCEX_Arr(4)  = A_WTDCEX4
     C                   EVAL      EXCD_Arr(4)  = A_WTEXCD4
     C                   EVAL      BCWA_Arr(4)  = A_WTBCWA4
     C                   EVAL      RPCD_Arr(4)  = A_WTRPCD4
     C                   EVAL      TXBS_Arr(4)  = A_WTTXBS4
     C                   EVAL      RFSI_Arr(4)  = A_WTRFSI4
     C                   EVAL      DBTT_Arr(4)  = A_WTDBTT4
     C                   EVAL      TIN_Arr(4)   = A_WTTIN4
      *
     C                   EVAL      CRTT_Arr(5)  = A_WTCRTT5
     C                   EVAL      INTS_Arr(5)  = A_WTINTS5
     C                   EVAL      DCRC_Arr(5)  = A_WTDCRC5
     C                   EVAL      DCEX_Arr(5)  = A_WTDCEX5
     C                   EVAL      EXCD_Arr(5)  = A_WTEXCD5
     C                   EVAL      BCWA_Arr(5)  = A_WTBCWA5
     C                   EVAL      RPCD_Arr(5)  = A_WTRPCD5
     C                   EVAL      TXBS_Arr(5)  = A_WTTXBS5
     C                   EVAL      RFSI_Arr(5)  = A_WTRFSI5
     C                   EVAL      DBTT_Arr(5)  = A_WTDBTT5
     C                   EVAL      TIN_Arr(5)   = A_WTTIN5
      *
     C                   EVAL      CRTT_Arr(6)  = A_WTCRTT6
     C                   EVAL      INTS_Arr(6)  = A_WTINTS6
     C                   EVAL      DCRC_Arr(6)  = A_WTDCRC6
     C                   EVAL      DCEX_Arr(6)  = A_WTDCEX6
     C                   EVAL      EXCD_Arr(6)  = A_WTEXCD6
     C                   EVAL      BCWA_Arr(6)  = A_WTBCWA6
     C                   EVAL      RPCD_Arr(6)  = A_WTRPCD6
     C                   EVAL      TXBS_Arr(6)  = A_WTTXBS6
     C                   EVAL      RFSI_Arr(6)  = A_WTRFSI6
     C                   EVAL      DBTT_Arr(6)  = A_WTDBTT6
     C                   EVAL      TIN_Arr(6)   = A_WTTIN6
      *
     C                   EVAL      CRTT_Arr(7)  = A_WTCRTT7
     C                   EVAL      INTS_Arr(7)  = A_WTINTS7
     C                   EVAL      DCRC_Arr(7)  = A_WTDCRC7
     C                   EVAL      DCEX_Arr(7)  = A_WTDCEX7
     C                   EVAL      EXCD_Arr(7)  = A_WTEXCD7
     C                   EVAL      BCWA_Arr(7)  = A_WTBCWA7
     C                   EVAL      RPCD_Arr(7)  = A_WTRPCD7
     C                   EVAL      TXBS_Arr(7)  = A_WTTXBS7
     C                   EVAL      RFSI_Arr(7)  = A_WTRFSI7
     C                   EVAL      DBTT_Arr(7)  = A_WTDBTT7
     C                   EVAL      TIN_Arr(7)   = A_WTTIN7
      *
     C                   EVAL      CRTT_Arr(8)  = A_WTCRTT8
     C                   EVAL      INTS_Arr(8)  = A_WTINTS8
     C                   EVAL      DCRC_Arr(8)  = A_WTDCRC8
     C                   EVAL      DCEX_Arr(8)  = A_WTDCEX8
     C                   EVAL      EXCD_Arr(8)  = A_WTEXCD8
     C                   EVAL      BCWA_Arr(8)  = A_WTBCWA8
     C                   EVAL      RPCD_Arr(8)  = A_WTRPCD8
     C                   EVAL      TXBS_Arr(8)  = A_WTTXBS8
     C                   EVAL      RFSI_Arr(8)  = A_WTRFSI8
     C                   EVAL      DBTT_Arr(8)  = A_WTDBTT8
     C                   EVAL      TIN_Arr(8)   = A_WTTIN8
      *
     C                   EVAL      CRTT_Arr(9)  = A_WTCRTT9
     C                   EVAL      INTS_Arr(9)  = A_WTINTS9
     C                   EVAL      DCRC_Arr(9)  = A_WTDCRC9
     C                   EVAL      DCEX_Arr(9)  = A_WTDCEX9
     C                   EVAL      EXCD_Arr(9)  = A_WTEXCD9
     C                   EVAL      BCWA_Arr(9)  = A_WTBCWA9
     C                   EVAL      RPCD_Arr(9)  = A_WTRPCD9
     C                   EVAL      TXBS_Arr(9)  = A_WTTXBS9
     C                   EVAL      RFSI_Arr(9)  = A_WTRFSI9
     C                   EVAL      DBTT_Arr(9)  = A_WTDBTT9
     C                   EVAL      TIN_Arr(9)   = A_WTTIN9
      *
     C                   EVAL      CRTT_Arr(10) = A_WTCRTT10
     C                   EVAL      INTS_Arr(10) = A_WTINTS10
     C                   EVAL      DCRC_Arr(10) = A_WTDCRC10
     C                   EVAL      DCEX_Arr(10) = A_WTDCEX10
     C                   EVAL      EXCD_Arr(10) = A_WTEXCD10
     C                   EVAL      BCWA_Arr(10) = A_WTBCWA10
     C                   EVAL      RPCD_Arr(10) = A_WTRPCD10
     C                   EVAL      TXBS_Arr(10) = A_WTTXBS10
     C                   EVAL      RFSI_Arr(10) = A_WTRFSI10
     C                   EVAL      DBTT_Arr(10) = A_WTDBTT10
     C                   EVAL      TIN_Arr(10)  = A_WTTIN10
      *
     C                   EVAL      CRTT_Arr(11) = A_WTCRTT11
     C                   EVAL      INTS_Arr(11) = A_WTINTS11
     C                   EVAL      DCRC_Arr(11) = A_WTDCRC11
     C                   EVAL      DCEX_Arr(11) = A_WTDCEX11
     C                   EVAL      EXCD_Arr(11) = A_WTEXCD11
     C                   EVAL      BCWA_Arr(11) = A_WTBCWA11
     C                   EVAL      RPCD_Arr(11) = A_WTRPCD11
     C                   EVAL      TXBS_Arr(11) = A_WTTXBS11
     C                   EVAL      RFSI_Arr(11) = A_WTRFSI11
     C                   EVAL      DBTT_Arr(11) = A_WTDBTT11
     C                   EVAL      TIN_Arr(11)  = A_WTTIN11
      *
     C                   EVAL      CRTT_Arr(12) = A_WTCRTT12
     C                   EVAL      INTS_Arr(12) = A_WTINTS12
     C                   EVAL      DCRC_Arr(12) = A_WTDCRC12
     C                   EVAL      DCEX_Arr(12) = A_WTDCEX12
     C                   EVAL      EXCD_Arr(12) = A_WTEXCD12
     C                   EVAL      BCWA_Arr(12) = A_WTBCWA12
     C                   EVAL      RPCD_Arr(12) = A_WTRPCD12
     C                   EVAL      TXBS_Arr(12) = A_WTTXBS12
     C                   EVAL      RFSI_Arr(12) = A_WTRFSI12
     C                   EVAL      DBTT_Arr(12) = A_WTDBTT12
     C                   EVAL      TIN_Arr(12)  = A_WTTIN12
      *
     C                   EVAL      CRTT_Arr(13) = A_WTCRTT13
     C                   EVAL      INTS_Arr(13) = A_WTINTS13
     C                   EVAL      DCRC_Arr(13) = A_WTDCRC13
     C                   EVAL      DCEX_Arr(13) = A_WTDCEX13
     C                   EVAL      EXCD_Arr(13) = A_WTEXCD13
     C                   EVAL      BCWA_Arr(13) = A_WTBCWA13
     C                   EVAL      RPCD_Arr(13) = A_WTRPCD13
     C                   EVAL      TXBS_Arr(13) = A_WTTXBS13
     C                   EVAL      RFSI_Arr(13) = A_WTRFSI13
     C                   EVAL      DBTT_Arr(13) = A_WTDBTT13
     C                   EVAL      TIN_Arr(13)  = A_WTTIN13
      *
     C                   EVAL      CRTT_Arr(14) = A_WTCRTT14
     C                   EVAL      INTS_Arr(14) = A_WTINTS14
     C                   EVAL      DCRC_Arr(14) = A_WTDCRC14
     C                   EVAL      DCEX_Arr(14) = A_WTDCEX14
     C                   EVAL      EXCD_Arr(14) = A_WTEXCD14
     C                   EVAL      BCWA_Arr(14) = A_WTBCWA14
     C                   EVAL      RPCD_Arr(14) = A_WTRPCD14
     C                   EVAL      TXBS_Arr(14) = A_WTTXBS14
     C                   EVAL      RFSI_Arr(14) = A_WTRFSI14
     C                   EVAL      DBTT_Arr(14) = A_WTDBTT14
     C                   EVAL      TIN_Arr(14)  = A_WTTIN14
      *
     C                   EVAL      CRTT_Arr(15) = A_WTCRTT15
     C                   EVAL      INTS_Arr(15) = A_WTINTS15
     C                   EVAL      DCRC_Arr(15) = A_WTDCRC15
     C                   EVAL      DCEX_Arr(15) = A_WTDCEX15
     C                   EVAL      EXCD_Arr(15) = A_WTEXCD15
     C                   EVAL      BCWA_Arr(15) = A_WTBCWA15
     C                   EVAL      RPCD_Arr(15) = A_WTRPCD15
     C                   EVAL      TXBS_Arr(15) = A_WTTXBS15
     C                   EVAL      RFSI_Arr(15) = A_WTRFSI15
     C                   EVAL      DBTT_Arr(15) = A_WTDBTT15
     C                   EVAL      TIN_Arr(15)  = A_WTTIN15
      *
     C                   EVAL      CRTT_Arr(16) = A_WTCRTT16
     C                   EVAL      INTS_Arr(16) = A_WTINTS16
     C                   EVAL      DCRC_Arr(16) = A_WTDCRC16
     C                   EVAL      DCEX_Arr(16) = A_WTDCEX16
     C                   EVAL      EXCD_Arr(16) = A_WTEXCD16
     C                   EVAL      BCWA_Arr(16) = A_WTBCWA16
     C                   EVAL      RPCD_Arr(16) = A_WTRPCD16
     C                   EVAL      TXBS_Arr(16) = A_WTTXBS16
     C                   EVAL      RFSI_Arr(16) = A_WTRFSI16
     C                   EVAL      DBTT_Arr(16) = A_WTDBTT16
     C                   EVAL      TIN_Arr(16)  = A_WTTIN16
      *
     C                   EVAL      CRTT_Arr(17) = A_WTCRTT17
     C                   EVAL      INTS_Arr(17) = A_WTINTS17
     C                   EVAL      DCRC_Arr(17) = A_WTDCRC17
     C                   EVAL      DCEX_Arr(17) = A_WTDCEX17
     C                   EVAL      EXCD_Arr(17) = A_WTEXCD17
     C                   EVAL      BCWA_Arr(17) = A_WTBCWA17
     C                   EVAL      RPCD_Arr(17) = A_WTRPCD17
     C                   EVAL      TXBS_Arr(17) = A_WTTXBS17
     C                   EVAL      RFSI_Arr(17) = A_WTRFSI17
     C                   EVAL      DBTT_Arr(17) = A_WTDBTT17
     C                   EVAL      TIN_Arr(17)  = A_WTTIN17
      *
     C                   EVAL      CRTT_Arr(18) = A_WTCRTT18
     C                   EVAL      INTS_Arr(18) = A_WTINTS18
     C                   EVAL      DCRC_Arr(18) = A_WTDCRC18
     C                   EVAL      DCEX_Arr(18) = A_WTDCEX18
     C                   EVAL      EXCD_Arr(18) = A_WTEXCD18
     C                   EVAL      BCWA_Arr(18) = A_WTBCWA18
     C                   EVAL      RPCD_Arr(18) = A_WTRPCD18
     C                   EVAL      TXBS_Arr(18) = A_WTTXBS18
     C                   EVAL      RFSI_Arr(18) = A_WTRFSI18
     C                   EVAL      DBTT_Arr(18) = A_WTDBTT18
     C                   EVAL      TIN_Arr(18)  = A_WTTIN18
      *
     C                   EVAL      CRTT_Arr(19) = A_WTCRTT19
     C                   EVAL      INTS_Arr(19) = A_WTINTS19
     C                   EVAL      DCRC_Arr(19) = A_WTDCRC19
     C                   EVAL      DCEX_Arr(19) = A_WTDCEX19
     C                   EVAL      EXCD_Arr(19) = A_WTEXCD19
     C                   EVAL      BCWA_Arr(19) = A_WTBCWA19
     C                   EVAL      RPCD_Arr(19) = A_WTRPCD19
     C                   EVAL      TXBS_Arr(19) = A_WTTXBS19
     C                   EVAL      RFSI_Arr(19) = A_WTRFSI19
     C                   EVAL      DBTT_Arr(19) = A_WTDBTT19
     C                   EVAL      TIN_Arr(19)  = A_WTTIN19
      *
     C                   EVAL      CRTT_Arr(20) = A_WTCRTT20
     C                   EVAL      INTS_Arr(20) = A_WTINTS20
     C                   EVAL      DCRC_Arr(20) = A_WTDCRC20
     C                   EVAL      DCEX_Arr(20) = A_WTDCEX20
     C                   EVAL      EXCD_Arr(20) = A_WTEXCD20
     C                   EVAL      BCWA_Arr(20) = A_WTBCWA20
     C                   EVAL      RPCD_Arr(20) = A_WTRPCD20
     C                   EVAL      TXBS_Arr(20) = A_WTTXBS20
     C                   EVAL      RFSI_Arr(20) = A_WTRFSI20
     C                   EVAL      DBTT_Arr(20) = A_WTDBTT20
     C                   EVAL      TIN_Arr(20)  = A_WTTIN20
      *
     C                   EVAL      CRTT_Arr(21) = A_WTCRTT21
     C                   EVAL      INTS_Arr(21) = A_WTINTS21
     C                   EVAL      DCRC_Arr(21) = A_WTDCRC21
     C                   EVAL      DCEX_Arr(21) = A_WTDCEX21
     C                   EVAL      EXCD_Arr(21) = A_WTEXCD21
     C                   EVAL      BCWA_Arr(21) = A_WTBCWA21
     C                   EVAL      RPCD_Arr(21) = A_WTRPCD21
     C                   EVAL      TXBS_Arr(21) = A_WTTXBS21
     C                   EVAL      RFSI_Arr(21) = A_WTRFSI21
     C                   EVAL      DBTT_Arr(21) = A_WTDBTT21
     C                   EVAL      TIN_Arr(21)  = A_WTTIN21
      *
     C                   EVAL      CRTT_Arr(22) = A_WTCRTT22
     C                   EVAL      INTS_Arr(22) = A_WTINTS22
     C                   EVAL      DCRC_Arr(22) = A_WTDCRC22
     C                   EVAL      DCEX_Arr(22) = A_WTDCEX22
     C                   EVAL      EXCD_Arr(22) = A_WTEXCD22
     C                   EVAL      BCWA_Arr(22) = A_WTBCWA22
     C                   EVAL      RPCD_Arr(22) = A_WTRPCD22
     C                   EVAL      TXBS_Arr(22) = A_WTTXBS22
     C                   EVAL      RFSI_Arr(22) = A_WTRFSI22
     C                   EVAL      DBTT_Arr(22) = A_WTDBTT22
     C                   EVAL      TIN_Arr(22)  = A_WTTIN22
      *
     C                   EVAL      CRTT_Arr(23) = A_WTCRTT23
     C                   EVAL      INTS_Arr(23) = A_WTINTS23
     C                   EVAL      DCRC_Arr(23) = A_WTDCRC23
     C                   EVAL      DCEX_Arr(23) = A_WTDCEX23
     C                   EVAL      EXCD_Arr(23) = A_WTEXCD23
     C                   EVAL      BCWA_Arr(23) = A_WTBCWA23
     C                   EVAL      RPCD_Arr(23) = A_WTRPCD23
     C                   EVAL      TXBS_Arr(23) = A_WTTXBS23
     C                   EVAL      RFSI_Arr(23) = A_WTRFSI23
     C                   EVAL      DBTT_Arr(23) = A_WTDBTT23
     C                   EVAL      TIN_Arr(23)  = A_WTTIN23
      *
     C                   EVAL      CRTT_Arr(24) = A_WTCRTT24
     C                   EVAL      INTS_Arr(24) = A_WTINTS24
     C                   EVAL      DCRC_Arr(24) = A_WTDCRC24
     C                   EVAL      DCEX_Arr(24) = A_WTDCEX24
     C                   EVAL      EXCD_Arr(24) = A_WTEXCD24
     C                   EVAL      BCWA_Arr(24) = A_WTBCWA24
     C                   EVAL      RPCD_Arr(24) = A_WTRPCD24
     C                   EVAL      TXBS_Arr(24) = A_WTTXBS24
     C                   EVAL      RFSI_Arr(24) = A_WTRFSI24
     C                   EVAL      DBTT_Arr(24) = A_WTDBTT24
     C                   EVAL      TIN_Arr(24)  = A_WTTIN24
      *
     C                   EVAL      CRTT_Arr(25) = A_WTCRTT25
     C                   EVAL      INTS_Arr(25) = A_WTINTS25
     C                   EVAL      DCRC_Arr(25) = A_WTDCRC25
     C                   EVAL      DCEX_Arr(25) = A_WTDCEX25
     C                   EVAL      EXCD_Arr(25) = A_WTEXCD25
     C                   EVAL      BCWA_Arr(25) = A_WTBCWA25
     C                   EVAL      RPCD_Arr(25) = A_WTRPCD25
     C                   EVAL      TXBS_Arr(25) = A_WTTXBS25
     C                   EVAL      RFSI_Arr(25) = A_WTRFSI25
     C                   EVAL      DBTT_Arr(25) = A_WTDBTT25
     C                   EVAL      TIN_Arr(25)  = A_WTTIN25
      *
     C                   EVAL      CRTT_Arr(26) = A_WTCRTT26
     C                   EVAL      INTS_Arr(26) = A_WTINTS26
     C                   EVAL      DCRC_Arr(26) = A_WTDCRC26
     C                   EVAL      DCEX_Arr(26) = A_WTDCEX26
     C                   EVAL      EXCD_Arr(26) = A_WTEXCD26
     C                   EVAL      BCWA_Arr(26) = A_WTBCWA26
     C                   EVAL      RPCD_Arr(26) = A_WTRPCD26
     C                   EVAL      TXBS_Arr(26) = A_WTTXBS26
     C                   EVAL      RFSI_Arr(26) = A_WTRFSI26
     C                   EVAL      DBTT_Arr(26) = A_WTDBTT26
     C                   EVAL      TIN_Arr(26)  = A_WTTIN26
      *
     C                   EVAL      CRTT_Arr(27) = A_WTCRTT27
     C                   EVAL      INTS_Arr(27) = A_WTINTS27
     C                   EVAL      DCRC_Arr(27) = A_WTDCRC27
     C                   EVAL      DCEX_Arr(27) = A_WTDCEX27
     C                   EVAL      EXCD_Arr(27) = A_WTEXCD27
     C                   EVAL      BCWA_Arr(27) = A_WTBCWA27
     C                   EVAL      RPCD_Arr(27) = A_WTRPCD27
     C                   EVAL      TXBS_Arr(27) = A_WTTXBS27
     C                   EVAL      RFSI_Arr(27) = A_WTRFSI27
     C                   EVAL      DBTT_Arr(27) = A_WTDBTT27
     C                   EVAL      TIN_Arr(27)  = A_WTTIN27
      *
     C                   EVAL      CRTT_Arr(28) = A_WTCRTT28
     C                   EVAL      INTS_Arr(28) = A_WTINTS28
     C                   EVAL      DCRC_Arr(28) = A_WTDCRC28
     C                   EVAL      DCEX_Arr(28) = A_WTDCEX28
     C                   EVAL      EXCD_Arr(28) = A_WTEXCD28
     C                   EVAL      BCWA_Arr(28) = A_WTBCWA28
     C                   EVAL      RPCD_Arr(28) = A_WTRPCD28
     C                   EVAL      TXBS_Arr(28) = A_WTTXBS28
     C                   EVAL      RFSI_Arr(28) = A_WTRFSI28
     C                   EVAL      DBTT_Arr(28) = A_WTDBTT28
     C                   EVAL      TIN_Arr(28)  = A_WTTIN28
      *
     C                   EVAL      CRTT_Arr(29) = A_WTCRTT29
     C                   EVAL      INTS_Arr(29) = A_WTINTS29
     C                   EVAL      DCRC_Arr(29) = A_WTDCRC29
     C                   EVAL      DCEX_Arr(29) = A_WTDCEX29
     C                   EVAL      EXCD_Arr(29) = A_WTEXCD29
     C                   EVAL      BCWA_Arr(29) = A_WTBCWA29
     C                   EVAL      RPCD_Arr(29) = A_WTRPCD29
     C                   EVAL      TXBS_Arr(29) = A_WTTXBS29
     C                   EVAL      RFSI_Arr(29) = A_WTRFSI29
     C                   EVAL      DBTT_Arr(29) = A_WTDBTT29
     C                   EVAL      TIN_Arr(29)  = A_WTTIN29
      *
     C                   EVAL      CRTT_Arr(30) = A_WTCRTT30
     C                   EVAL      INTS_Arr(30) = A_WTINTS30
     C                   EVAL      DCRC_Arr(30) = A_WTDCRC30
     C                   EVAL      DCEX_Arr(30) = A_WTDCEX30
     C                   EVAL      EXCD_Arr(30) = A_WTEXCD30
     C                   EVAL      BCWA_Arr(30) = A_WTBCWA30
     C                   EVAL      RPCD_Arr(30) = A_WTRPCD30
     C                   EVAL      TXBS_Arr(30) = A_WTTXBS30
     C                   EVAL      RFSI_Arr(30) = A_WTRFSI30
     C                   EVAL      DBTT_Arr(30) = A_WTDBTT30
     C                   EVAL      TIN_Arr(30)  = A_WTTIN30
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  UPDCTRL - Update Standing Data Control File                  *
      *                                                               *
      *****************************************************************
     C     UPDCTRL       BEGSR
 
     C                   MOVE      *BLANKS       WKFLNM
     C                   MOVEL     'SDWTCSPD'    WKFLNM
     C     WKFLNM        CHAIN     @AHREAU                            9899
 
      ** Record not found
 
     C     *IN98         IFEQ      '1'
     C                   MOVEL     'SDWTCSPD'    DBKEY
     C                   MOVEL     'SDFCTLPA'    DBFILE
 
     C                   MOVEL     '909'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Record locked
 
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'SDWTCSPD'    DBKEY
     C                   MOVEL     'SDFCTLPA'    DBFILE
 
     C                   MOVEL     '910'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   SELECT
 
      ** Input
 
     C     A_WTTYLC      WHENEQ    'I'
     C                   EVAL      AHNORC = (AHNORC + 1)
     C                   EVAL      AHNOIN = (AHNOIN + 1)
 
      ** Amend
 
     C     A_WTTYLC      WHENEQ    'A'
     C                   EVAL      AHNOAM = (AHNOAM + 1)
 
      ** Delete
 
     C     A_WTTYLC      WHENEQ    'D'
     C                   EVAL      AHNORC = (AHNORC - 1)
     C                   EVAL      AHNODL = (AHNODL + 1)
     C                   ENDSL
 
      ** Update the standing data controls file
 
     C                   UPDATE    @AHREAU
 
     C                   ENDSR
 
      *****************************************************************
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
 
      *  Note: if non-standard processing required, use the PSSR_ILENE
      *  subroutine
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2007
