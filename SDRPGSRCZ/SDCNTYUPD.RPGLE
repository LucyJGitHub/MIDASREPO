     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Country Details database update')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCNTYUPD - Country Details database update                  *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
 
     FSDCTRYL0  UF A E           K DISK    COMMIT
     F                                     RENAME(@A4REBS:SDCTRYD0)
     F                                     INFSR(*PSSR)
      * Midas SD Country Details Master File
     FSDCTX1PD  UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
      * Midas IBLC 2002 Country code Details Ext. File
     FSDCTX2PD  UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
      * Midas SD Country Codes - LU Ext. File
 
     FSDFCTLL0  UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
      * Midas SD Standing Data Controls index
 
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
 
     D ChkCntyFmt    E DS                  EXTNAME(SDCTRYPD)
     D                                     PREFIX(CH)
     D ChkCtx1Fmt    E DS                  EXTNAME(SDCTX1PD)
     D                                     PREFIX(CH)
     D ChkCtx2Fmt    E DS                  EXTNAME(SDCTX2PD)
     D                                     PREFIX(CH)
      ** Rename fields for Timestamp checking
 
     D SDVCnty       E DS                  EXTNAME(SDVCNTYPD)
     D                                     PREFIX(A_)
      ** Externally desc'd DS for valid Country Detail
     D SDVCtx1       E DS                  EXTNAME(SDVCTX1PD)
     D                                     PREFIX(A_)
      ** Externally desc'd DS for valid Eur Reporting country Detail
     D SDVCtx2       E DS                  EXTNAME(SDVCTX2PD)
     D                                     PREFIX(A_)
      ** Externally desc'd DS for valid BCL country Detail
 
     D OKCtrDets     E DS                  EXTNAME(SDECNTYPD)
      * Error indicators for country
     D OKCx1Dets     E DS                  EXTNAME(SDECNT3PD)
      * Error indicators for BCL country
     D OKCx2Dets     E DS                  EXTNAME(SDECNT2PD)
      * Error indicators for Eur country
 
     D B_CNTYF       E DS                  EXTNAME(SDCTRYPD)
     D                                     PREFIX(B_)
      **  Externally described DS for 'BEFORE UPDATE' country
     D B_CTX1F       E DS                  EXTNAME(SDCTX1PD)
     D                                     PREFIX(B_)
      **  Externally described DS for 'BEFORE UPDATE' BCL country
     D B_CTX2F       E DS                  EXTNAME(SDCTX2PD)
     D                                     PREFIX(B_)
      **  Externally described DS for 'BEFORE UPDATE' Eur country
 
      **  Country Details File
     D CNTYF         E DS                  EXTNAME(SDCTRYPD)
      **  BCL country Details File
     D CTX1F         E DS                  EXTNAME(SDCTX1PD)
      **  Eur country Details File
     D CTX2F         E DS                  EXTNAME(SDCTX2PD)
      ** Extra Data
     D ExtData       E DS                  EXTNAME(SDCtEXPD)
 
      * Data Structures for use with access programs
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * Data structure for bank details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for access programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for access programs, long data structure
 
     ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
     ** 24X7 status data area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
     ** Midas API Message Header Format Definition
     D APHEAD        E DS                  EXTNAME(APHEADPD)
      * Data Structure for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
      * Outward parameters
      * RCD : Midas SD Deleted records file retrieval
     D PARC            DS          3064
      * I :  File name
     D    PAFNME               1     10
      * I :  Long Key
     D    PALKEY              11     60
      * I :  Deleted Data Record Pt1
     D    PADR01              61    310
      * I :  Deleted Data Record Pt2
     D    PADR02             311    560
      * I :  Deleted Data Record Pt3
     D    PADR03             561    810
      * I :  Deleted Data Record Pt4
     D    PADR04             811   1060
      * I :  Deleted Data Record Pt5
     D    PADR05            1061   1310
      * I :  Deleted Data Record Pt6
     D    PADR06            1311   1560
      * I :  Deleted Data Record Pt7
     D    PADR07            1561   1810
      * I :  Deleted Data Record Pt8
     D    PADR08            1811   2060
      * I :  Deleted Data Record Pt9
     D    PADR09            2061   2310
      * I :  Deleted Data Record Pt10
     D    PADR10            2311   2560
      * I :  Deleted Data Record Pt11
     D    PADR11            2561   2810
      * I :  Deleted Data Record Pt12
     D    PADR12            2811   3060
      * I :  Last Change Date
     D    PALCD             3061   3063P 0
      * I :  Type of Last Change
     D    PATYLC            3064   3064
 
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
     ** Fields defined for Enhancement CSC011
 
     D CSC011          S              1A
     D TRANSDTL        S           5800A
     D PCustNum        S             24A
     D PACustNo        S             24A
     D PTimestamp      S             26A
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D WCust           S              6A
 
      ** Account sequence field (packed) for call to CLINTSE
     D WKACSN          S              2P 0
 
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
     C     A_COTYLC      CASEQ     'I'           INSERT
     C     A_COTYLC      CASEQ     'A'           AMEND
     C     A_COTYLC      CASEQ     'D'           DELETE
     C                   ENDCS
 
      * Exit From Program
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
     C                   PARM                    @@RTCD            7
 
      ** Externally described DS for valid Country Detail
     C                   PARM                    SDVCNTY
      ** Externally described DS for valid Eur Reporting Country Detail
     C                   PARM                    SDVCTX2
      ** Externally described DS for valid BCL Country Detail
     C                   PARM                    SDVCTX1
      *
      ** Access Bank Details
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database Error
     C                   IF        @RTCD <> *BLANK
     C                   EVAL      DBKEY  = @OPTN
     C                   EVAL      DBFILE = 'SDBANKPD'                          *************
     C                   EVAL      DBASE  = 909                                 * DBERR 909 *
     C                   EXSR      *PSSR                                        *************
     C                   ENDIF
 
     ** Check if CSC011 is installed
     C                   EVAL      CSC011 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSC011'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        (PRtCd <> *BLANKS) and
     C                             (PRtCd <> '*NRF   ')
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 907
     C                   EXSR      *PSSR                                        *************
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SDSTAT
     C                   IN        SC24X7
     C                   ENDIF
 
      ** Check if CGL032 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CGL032'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        (PRtCd <> *BLANKS) and
     C                             (PRtCd <> '*NRF   ')
     C                   EVAL      DBKEY = 'CGL032'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 940
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        @RTCD = *BLANK
     C                   MOVE      'Y'           CGL032            1
     C                   ELSE
     C                   MOVE      'N'           CGL032
     C                   ENDIF
 
     ** Check if CGL031 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CGL031'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        (PRtCd <> *BLANKS) and
     C                             (PRtCd <> '*NRF   ')
     C                   EVAL      DBKEY = 'CGL031'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 941
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        @RTCD = *BLANK
     C                   MOVE      'Y'           CGL031            1
     C                   ELSE
     C                   MOVE      'N'           CGL031
     C                   ENDIF
 
      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @Return           6
     C                   PARM                    @Type             1
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CHKOTHUPD - Check for update by another workstation           *
      *                                                               *
      *****************************************************************
     C     CHKOTHUPD     BEGSR
 
     C                   CALLB     'SDCNTYRTV'
      * Inputs
      *
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    @@MODE            6
      *
      * Response mode
     C                   PARM      ' '           @@RSMD            1
      *
      * Action Code
     C                   PARM      A_COTYLC      ACTN              1
      *
      * Front Office Transaction ID
     C                   PARM      A_COFRNT      FOTRID           20
      *
      * Midas Country code
     C                   PARM                    A_COCNCD          2
      *
      * Outputs
      *
      * Country Details in File Format
     C                   PARM                    ChkCntyFmt
      * Eur country Details in File Format
     C                   PARM                    ChkCtx1Fmt
      * BCL country Details in File Format
     C                   PARM                    ChkCtx2Fmt
      * Extra Data
     C                   PARM                    ExtData
 
      *
      * OK - Action code
     C                   PARM      *BLANK        DDACTNOK          1
      *
      * OK - Country code
     C                   PARM                    DDCNCDOK          1
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *BLANK        FldNameArr
     C                   PARM      *BLANK        MsgIdArr
     C                   PARM      *BLANK        MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Ix                3 0
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
 
     C                   IF        CHA4TMST <> A_COTMST
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   ENDIF
 
      ** Batch mode:
     C                   ELSE
     C                   IF        DDACTNOK = 'N' OR
     C                             DDCNCDOK = 'N'
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
      * INSERT - Insert a transaction                                *
      *                                                              *
      ****************************************************************
     C     INSERT        BEGSR
 
      ** Access Country Details
     C     A_COCNCD      CHAIN     SDCTRYL0                           99
      ** Database error
     C                   IF        *IN99 = *OFF
     C                   EVAL      DBKEY  = A_COCNCD
     C                   EVAL      DBFILE = 'SDCTRYPD'
     C                   EVAL      DBASE  = 001
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access BCL country Details
     C     A_COCNCD      CHAIN     SDCTX1PD                           54
      *
      ** Access Eur country Details
     C     A_COCNCD      CHAIN     SDCTX2PD                           55
 
      ** Initialise Country Detail
     C                   CLEAR                   CNTYF
      ** Initialise BCL Country Detail
     C                   CLEAR                   CTX1F
      ** Initialise Eur Country Detail
     C                   CLEAR                   CTX2F
 
      ** Store Old fields for comparisons
     C                   MOVEL(P)  CNTYF         B_CNTYF
     C                   MOVEL(P)  CTX1F         B_CTX1F
     C                   MOVEL(P)  CTX2F         B_CTX2F
 
      ** SET COUNTRY FIELDS ON INSERT
     C                   EVAL      A4CNCD=A_COCNCD
     C                   EVAL      A4RGCD=A_CORGCD
     C                   EVAL      A4LCD=BJRDNB
     C                   EVAL      A4TYLC='I'
     C                   EVAL      A4CNNM=A_COCNNM
     C                   EVAL      A4ISOC=A_COISOC
     C                   EVAL      A4BBAN=A_COBBAN
     C                   EVAL      A4BBRL=A_COBBRL
     C                   EVAL      A4CTAY=A_COCTAY
     C                   EVAL      A4CTZP=A_COCTZP
     C                   EVAL      A4CTWC=A_COCTWC
     C                   EVAL      A4FRNT=A_COFRNT
     C                   EVAL      A4MLOC = *Blank
 
      ** Move relevant fields to file fields if CGL032 is enabled.
      *
     C                   IF        CGL032 = 'Y'
 
     C                   EVAL      A4ETXY=A_COETXY
     C                   EVAL      A4RPFQ=A_CORPFQ
     C                   EVAL      A4JAMG=A_COJAMG
     C                   ELSE
     C                   EVAL      A4ETXY=*ZERO
     C                   EVAL      A4RPFQ=*BLANKS
     C                   EVAL      A4JAMG=*BLANKS
     C                   ENDIF
      *
      ** Move relevant fields to file fields if CGL031 is enabled.
      *
     C                   IF        CGL031 = 'Y'
     C                   EVAL      A4TXCY=A_COTXCY
     C                   EVAL      A4CTTX=A_COCTTX
     C                   ELSE
     C                   EVAL      A4TXCY=*BLANKS
     C                   EVAL      A4CTTX=*BLANKS
     C                   ENDIF
      *
      ** SET BCL country Detail FIELDS ON INSERT
      *
     C                   EVAL      CTCTRY=A_CXCTRY
     C                   EVAL      CTEMUZ=A_CXEMUZ
      *
      ** SET Eur country Detail FIELDS ON INSERT
      *
     C                   EVAL      WFCTRY=A_C2CTRY
     C                   EVAL      WFICTR=A_C2ICTR
     C                   EVAL      WFEMUM=A_C2EMUM
     C                   EVAL      WFISOC=A_C2ISOC
      *
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   EVAL      A4TMST  = TimeStamp
      *
      ** Write new Transaction Detail
     C                   WRITE     SDCTRYD0
      *
      * If BCL Country Details Does not already exist then INSERT
      * Else UPDATE
     C                   IF        *IN54 = *ON
     C                   WRITE     SDCTRYDL
     C                   ELSE
     C                   UPDATE    SDCTRYDL
     C                   ENDIF
      *
      * If Eur Country Details Does not already exist then INSERT
      * Else UPDATE
     C                   IF        *IN55 = *ON
     C                   WRITE     SDCTRYF6
     C                   ELSE
     C                   UPDATE    SDCTRYF6
     C                   ENDIF
 
      * INSERT A RECORD IN THE TABLE TABLETH
     C                   EXSR      UPDTABL
      * UPDATE SD STANDING DATA CONTROL FILE
     C                   EXSR      UPDCTRL
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * AMEND  - Amend a transaction                                 *
      *                                                              *
      ****************************************************************
     C     AMEND         BEGSR
 
      ** Access Country Details
     C     A_COCNCD      CHAIN     SDCTRYL0                           9998
      ** Database error
     C                   IF        *IN99 = *ON
     C                   EVAL      DBKEY  = A_COCNCD
     C                   EVAL      DBFILE = 'SDCTRYPD'
     C                   EVAL      DBASE  = 002
     C                   EXSR      *PSSR
     C                   ENDIF
      ** Record Locked
     C                   IF        *IN98 = *ON
     C                   EVAL      DBKEY  = A_COCNCD
     C                   EVAL      DBFILE = 'SDCTRYPD'
     C                   EVAL      DBASE  = 003
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access BCL country Details
     C     A_COCNCD      CHAIN     SDCTX1PD                           94
      *
      ** Access Eur country Details
     C     A_COCNCD      CHAIN     SDCTX2PD                           95
 
      ** Update 'BEFORE' status of Country
     C                   MOVEL(P)  CNTYF         B_CNTYF
 
      *
     C                   IF        *IN94 = *ON
      ** Initialise 'BEFORE' status of BCL country
     C                   CLEAR                   CTX1F
     C                   ENDIF
      *
     C                   IF        *IN95 = *ON
      ** Initialise 'BEFORE' status of Eur country
     C                   CLEAR                   CTX2F
     C                   ENDIF
 
      ** Update 'BEFORE' status of BCL country
     C                   MOVEL(P)  CTX1F         B_CTX1F
      ** Update 'BEFORE' status of Eur country
     C                   MOVEL(P)  CTX2F         B_CTX2F
      ** SET COUNTRY FIELDS ON AMEND
     C                   EVAL      A4CNCD = A_COCNCD
     C                   EVAL      A4RGCD = A_CORGCD
     C                   EVAL      A4LCD = BJRDNB
     C                   EVAL      A4TYLC = 'A'
     C                   EVAL      A4CNNM = A_COCNNM
     C                   EVAL      A4ISOC = A_COISOC
     C                   EVAL      A4BBAN = A_COBBAN
     C                   EVAL      A4BBRL = A_COBBRL
     C                   EVAL      A4CTAY = A_COCTAY
     C                   EVAL      A4CTZP = A_COCTZP
     C                   EVAL      A4CTWC = A_COCTWC
     C                   EVAL      A4FRNT = A_COFRNT
     C                   EVAL      A4MLOC = *BLANK
      ** Move relevant fields to file fields if CGL032 is enabled.
      *
     C                   IF        CGL032 = 'Y'
 
     C                   EVAL      A4ETXY=A_COETXY
     C                   EVAL      A4RPFQ=A_CORPFQ
     C                   EVAL      A4JAMG=A_COJAMG
     C                   ELSE
     C                   EVAL      A4ETXY=*ZERO
     C                   EVAL      A4RPFQ=*BLANKS
     C                   EVAL      A4JAMG=*BLANKS
     C                   ENDIF
      *
      ** Move relevant fields to file fields if CGL031 is enabled.
      *
     C                   IF        CGL031 = 'Y'
     C                   EVAL      A4TXCY=A_COTXCY
     C                   EVAL      A4CTTX=A_COCTTX
     C                   ELSE
     C                   EVAL      A4TXCY=*BLANKS
     C                   EVAL      A4CTTX=*BLANKS
     C                   ENDIF
      *
      ** SET BCL country Detail FIELDS ON AMEND/INSERT
      *
     C                   EVAL      CTCTRY=A_CXCTRY
     C                   EVAL      CTEMUZ=A_CXEMUZ
      *
      ** SET Eur country Detail FIELDS ON AMEND/INSERT
      *
     C                   EVAL      WFCTRY=A_C2CTRY
     C                   EVAL      WFICTR=A_C2ICTR
     C                   EVAL      WFEMUM=A_C2EMUM
     C                   EVAL      WFISOC=A_C2ISOC
 
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   EVAL      A4TMST  = TimeStamp
 
      *
      ** Update Country Record
     C                   UPDATE    SDCTRYD0
      *
      * If BCL Country Details Does not already exist then INSERT
      * Else UPDATE
     C                   IF        *IN94 = *ON
     C                   WRITE     SDCTRYDL
     C                   ELSE
     C                   UPDATE    SDCTRYDL
     C                   ENDIF
      *
      * If Eur Country Details Does not already exist then INSERT
      * Else UPDATE
     C                   IF        *IN95 = *ON
     C                   WRITE     SDCTRYF6
     C                   ELSE
     C                   UPDATE    SDCTRYF6
     C                   ENDIF
      *
      * INSERT A RECORD IN THE TABLE TABLETH
     C                   EXSR      UPDTABL
      * UPDATE SD STANDING DATA CONTROL FILE
     C                   EXSR      UPDCTRL
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * DELETE - Delete a transaction                                *
      *                                                              *
      ****************************************************************
     C     DELETE        BEGSR
 
      ** Access Country Details
     C     A_COCNCD      CHAIN     SDCTRYL0                           9998
      ** Database error
     C                   IF        *IN99 = *ON
     C                   EVAL      DBKEY  = A_COCNCD
     C                   EVAL      DBFILE = 'SDCTRYPD'
     C                   EVAL      DBASE  = 004
     C                   EXSR      *PSSR
     C                   ENDIF
      ** Record Locked
     C                   IF        *IN98 = *ON
     C                   EVAL      DBKEY  = A_COCNCD
     C                   EVAL      DBFILE = 'SDCTRYPD'
     C                   EVAL      DBASE  = 005
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access BCL country Details
     C     A_COCNCD      CHAIN     SDCTX1PD                           94
      *
      ** Access Eur country Details
     C     A_COCNCD      CHAIN     SDCTX2PD                           95
 
      ** Update 'BEFORE' status
     C                   MOVEL(P)  CNTYF         B_CNTYF
      *
     C                   IF        *IN94 = *ON
      ** Initialise 'BEFORE' status of BCL country
     C                   CLEAR                   CTX1F
     C                   ENDIF
      *
     C                   IF        *IN95 = *ON
      ** Initialise 'BEFORE' status of Eur country
     C                   CLEAR                   CTX2F
     C                   ENDIF
      * Update 'BEFORE' status of BCL country
     C                   MOVEL(P)  CTX1F         B_CTX1F
      * Update 'BEFORE' status of Eur country
     C                   MOVEL(P)  CTX2F         B_CTX2F
 
      ** Delete record
     C                   DELETE    SDCTRYD0
      *
      * If BCL Country Details if exist
     C                   IF        *IN94 = *OFF
     C                   DELETE    SDCTRYDL
     C                   ENDIF
      *
      * If Eur Country Details if exist
     C                   IF        *IN95 = *OFF
     C                   DELETE    SDCTRYF6
     C                   ENDIF
      *
      * WRITE DELETED RECORD IN STANDING DATA DELETED FILE
     C                   EXSR      WRTDLRC
      * INSERT A RECORD IN THE TABLE TABLETH
     C                   EVAL      A4TYLC = 'D'
     C                   EXSR      UPDTABL
      * UPDATE SD STANDING DATA CONTROL FILE
     C                   EXSR      UPDCTRL
 
     C                   ENDSR
      ****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* UPDTABL - UPDATE TABLE TABLETH                               *
     C*                                                              *
     C****************************************************************
     C     UPDTABL       BEGSR
      *
      * TABLETH - Country Codes  *
     C                   CALL      'TABLETH'                            90
     C                   PARM      *BLANKS       WQ0001            7
     C                   PARM      A4CNCD        WQ0002            2
     C                   PARM      A4RGCD        WQ0003            2
     C                   PARM      A4CNNM        WQ0004           30
     C                   PARM      A4TYLC        WQ0005            1
     C                   PARM      BJRDNB        WQ0006            5 0
 
      *
     C     *IN90         IFEQ      *ON
     C                   MOVEL     A4CNCD        DBKEY
     C                   MOVEL     'TABLETH'     DBFILE
     C                   MOVEL     '006'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     WQ0001        IFNE      *BLANKS
     C                   MOVEL     '*ERTBTK'     ReturnCode
     C                   MOVEL     A4CNCD        DBKEY
     C                   MOVEL     'TABLETH'     DBFILE
     C                   MOVEL     '007'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
     C****************************************************************
     C*                                                              *
     C* UPDCTRL - UPDATE STANDING DATA CONTROL FILE                  *
     C*                                                              *
     C****************************************************************
     C     UPDCTRL       BEGSR
      *
     C                   MOVE      *BLANKS       WKFLNM           10
     C                   MOVEL     'SDCTRYPD'    WKFLNM
     C     WKFLNM        CHAIN     @AHREAU                            9899
      *
      * Record not found
     C     *IN98         IFEQ      '1'
     C                   MOVEL     'SDCTRYPD'    DBKEY
     C                   MOVEL     'SDFCTLL0'    DBFILE
     C                   MOVEL     '008'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      * Record locked
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'SDCTRYPD'    DBKEY
     C                   MOVEL     'SDFCTLL0'    DBFILE
     C                   MOVEL     '009'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
     C                   SELECT
      * Input
     C     A4TYLC        WHENEQ    'I'
     C                   EVAL      AHNORC = (AHNORC + 1)
     C                   EVAL      AHNOIN = (AHNOIN + 1)
      *
      * Amend
     C     A4TYLC        WHENEQ    'A'
     C                   EVAL      AHNOAM = (AHNOAM + 1)
      *
      * Delete
     C     A4TYLC        WHENEQ    'D'
     C                   EVAL      AHNORC = (AHNORC - 1)
     C                   EVAL      AHNODL = (AHNODL + 1)
     C                   ENDSL
     C                   UPDATE    @AHREAU
      *
     C                   ENDSR
     C****************************************************************
     C****************************************************************
     C*                                                              *
     C* WRTDLRC - WRITE DELETED RECORD IN STANDING DATA FILE         *
     C*                                                              *
     C****************************************************************
     C     WRTDLRC       BEGSR
     C                   MOVEL     SDVCnty       WUDELR
      * Write Deleted Record - SD Deleted Records File  *
     C                   CLEAR                   PARC
     C                   MOVEL     'SDCTRYPD'    PAFNME
     C                   MOVEL     A_COCNCD      PALKEY
     C                   MOVEL     WUDR01        PADR01
     C                   MOVEL     WUDR02        PADR02
     C                   MOVEL     WUDR03        PADR03
     C                   MOVEL     WUDR04        PADR04
     C                   MOVEL     WUDR05        PADR05
     C                   MOVEL     WUDR06        PADR06
     C                   MOVEL     WUDR07        PADR07
     C                   MOVEL     WUDR08        PADR08
     C                   MOVEL     WUDR09        PADR09
     C                   MOVEL     WUDR10        PADR10
     C                   MOVEL     WUDR11        PADR11
     C                   MOVEL     WUDR12        PADR12
     C                   Z-ADD     BJRDNB        PALCD
     C                   MOVEL     'D'           PATYLC
      *
     C                   CALL      'SD0520X'                            90
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PARC
      *
     C     *IN90         IFEQ      '1'
     C     W0RTN         ORNE      *BLANK
     C                   MOVEL     A_COCNCD      DBKEY
     C                   MOVEL     'SD0520X'     DBFILE
     C                   MOVEL     '010'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
     C****************************************************************
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
(c) Finastra International Limited 2006
