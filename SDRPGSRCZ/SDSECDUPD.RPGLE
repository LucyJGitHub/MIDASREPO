     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Securities clients details dbase update')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDSECDUPD - STANDING DATA SECURITY CUSTOMERS DETAILS         *
      *              DATABASE UPDATE                                  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER071             Date 01Aug16               *
      *                 CER070             Date 19Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 AR325335           Date 19May10               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 BUG22529           Date 09Feb09               *
      *                 CER034             Date 28Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 243070             Date 10Jul06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12213           Date 15Jan07               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE070             Date 15Feb05               *
      *                 BUG3122            Date 17Jul04               *
      *                 CGL029             Date 01Sep03               *
      *                 CSE042             Date 05Feb03               *
      *                 CSE041             Date 05Feb03               *
      *                 CSE039             Date 05Feb03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      *                 193883             Date 21Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP013             Date 31Mar00               *
      *                 CAP039  *CREATE    Date 30May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR325335 - 'Other Depot' disappears after input in Security  *
      *             Customer details                                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  BUG22529 - Global Additional Customer Details (Recompile)    *
      *  CER034 - German Features LF046-00                            *
      *  243070 - Recompile over changed PF/SDVSECDPD                 *
      *  BUG12213 - Depot details missing on wholesale customer input *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CSE070 - Repo Coupon Claims Report                           *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CSE042 - Auto Feed of Trades and Movements                   *
      *  CSE041 - DVP/RVP Processing                                  *
      *  CSE039 - Automatic Settlement of Trades                      *
      *  CSC011 - 24x7 Midas Availability                             *
      *  193883 - To avoid DBerr set-up Front ID correctly.           *
      *  CSE022 - Depository Definition Enhancement                   *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  CAP039 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
 
     FSDSECSL1  UF A E           K DISK    COMMIT
      * Midas SD Securities Clients Details Master File
 
     FSDFCTLL0  UF A E           K DISK    COMMIT
      * Midas SD Standing Data Controls index
 
      ** Valid Customer Depository Reference file by Customer Number                          CSE022
     FSDVCSDRL2 IF   E           K DISK                                                       CSE022
                                                                                              CSE022
      ** Customer Depository Reference file by Customer Number                                CSE022
     FSDCSDRL0  UF A E           K DISK    COMMIT                                             CSE022
      *                                                                                       CER034
      ** Midas SD Additional Customer details update                                          CER034
      *                                                                                       CER034
     FSDACUSL0  UF   E           K DISK    COMMIT                                             CER034
 
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
     D ChkSecdFmt    E DS                  EXTNAME(SDSECSPD)
     D                                     PREFIX(CH)
      ** Rename fields for Timestamp checking
 
 
     D SDVSecd       E DS                  EXTNAME(SDVSECDPD)
     D                                     PREFIX(A_)
      ** Externally desc'd DS for valid Securities Clients Detail
 
 
     D OKSecDets     E DS                  EXTNAME(SDESECDPD)
      * Error indicators
 
 
     D B_SECDF       E DS                  EXTNAME(SDSECSPD)
     D                                     PREFIX(B_)
      **  Externally described DS for 'BEFORE UPDATE' securities
 
 
      **  Securities Clients Details File
     D SECDF         E DS                  EXTNAME(SDSECSPD)
 
 
      * Data Structures for use with access programs
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * Data structure for bank details
 
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      * Data structure for securities trading details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for access programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for access programs, long data structure
 
     D DepotSn         S              7    DIM(10)
      ** Depot shortnames array
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
      ** External DS for SAR Details                                                          CSC011
                                                                                              CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                              CSC011
     D APHEAD        E DS                  EXTNAME(APHEADPD)                                  CSC011
      ** Midas API Message Header Format Definition                                           CSC011
                                                                                              CSC011
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
      ** Fields defined for Enhancement CSC011                                                CSC011
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D*PCustNum        S             18A                                               CSC011 CGL029
     D*PACustNo        S             18A                                               CSC011 CGL029
     D PCustNum        S             24A                                                      CGL029
     D PACustNo        S             24A                                                      CGL029
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
     D PTimestamp      S             26A                                                      CSC011
                                                                                              CSC011
      *                                                                                       CER034
      ** Work variable for CER034                                                             CER034
      *                                                                                       CER034
     D CER034          S              1A                                                      CER034
                                                                                              CER034
      * Outward parameters
      * RCD : Midas SD Deleted records file retrieval
     D PBRC            DS          3064
      * I :  File name
     D    PBFNME               1     10
      * I :  Long Key
     D    PBLKEY              11     60
      * I :  Deleted Data Record Pt1
     D    PBDR01              61    310
      * I :  Deleted Data Record Pt2
     D    PBDR02             311    560
      * I :  Deleted Data Record Pt3
     D    PBDR03             561    810
      * I :  Deleted Data Record Pt4
     D    PBDR04             811   1060
      * I :  Deleted Data Record Pt5
     D    PBDR05            1061   1310
      * I :  Deleted Data Record Pt6
     D    PBDR06            1311   1560
      * I :  Deleted Data Record Pt7
     D    PBDR07            1561   1810
      * I :  Deleted Data Record Pt8
     D    PBDR08            1811   2060
      * I :  Deleted Data Record Pt9
     D    PBDR09            2061   2310
      * I :  Deleted Data Record Pt10
     D    PBDR10            2311   2560
      * I :  Deleted Data Record Pt11
     D    PBDR11            2561   2810
      * I :  Deleted Data Record Pt12
     D    PBDR12            2811   3060
      * I :  Last Change Date
     D    PBLCD             3061   3063P 0
      * I :  Type of Last Change
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
 
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - MAIN BODY                                              *
      *                                                               *
      *****************************************************************
 
      ** Ensure transaction has not been updated by another workstation
      ** - if so, bypass updating and return to calling program.
     C                   EXSR      CHKOTHUPD
 
     C     @@RTCD        IFNE      *BLANKS
     C                   GOTO      EXIT
     C                   END
 
      ** INSERT, AMEND OR DELETE THE CUSTOMER
 
     C     A_SETYLC      CASEQ     'I'           INSERT
     C     A_SETYLC      CASEQ     'A'           AMEND
     C     A_SETYLC      CASEQ     'D'           DELETE
     C                   END
                                                                                              CSC011
      ** If 24x7 Midas Availability is installed                                              CSC011
      ** and Support System is active                                                         CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   CALLB     'SDSECDLOG'                                                CSC011
     C                   PARM      *Blanks       RetCodeOut                                   CSC011
     C                   PARM                    SECDF                                        CSC011
     C                   PARM                    TRANSDTL                                     CSC011
                                                                                              CSC011
      ** If there is no error, write the log file                                             CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut = *Blanks                                       CSC011
     C                   EVAL      APTGTTYPE  = 'SDSECD'                                      CSC011
     C                   EVAL      APFOTRANID = BFFRNT                                        CSC011
     C                   EVAL      APRPRLOCN  = BFREPA                                        CSC011
     C                   EVAL      APUSERID   = PSUser                                        CSC011
     C                   EVAL      APMIDUSR   = PSUser                                        CSC011
                                                                                              CSC011
     C                   MOVEL     BFCUST        PCustNum                                     CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    APHEAD                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM      *BLANKS       PTimeStamp                                   CSC011
     C                   PARM                    PCustNum                                     CSC011
     C                   PARM      *BLANKS       PACustNo                                     CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** If there is an error in either log file, end program                                 CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *Blanks                                      CSC011
     C                   EVAL      @@RTCD = '*ERROR'                                          CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
 
      * EXIT FROM PROGRAM
     C     EXIT          TAG
 
     C                   RETURN
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CHKOTHUPD - Check for update by another workstation           *
      *                                                               *
      *****************************************************************
     C     CHKOTHUPD     BEGSR
 
      ** Retrieve current Customer details
 
     C                   MOVE      A_SECUST      MidasTrNum        6
 
      ** CSST field is used to test blank customer select in RTV module
     C                   MOVEL     A_SECUST      DDCSST
 
 
      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @Return           6
     C                   PARM                    @Type             1
      *                                                                         CAP013
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)            CAP013
      *  if insert                                                              CAP013
      * Otherwise                                                               CAP013
      *  Set retrieve mode to blank  (Access using Midas transaction ID).       CAP013
      *                                                                         CAP013
     C*****A_SETYLC      IFne      'I'                                   CAP013 193883
     C**********         MOVEL     '1'           @TYPE                   CAP013 193883
     C**********         ENDIF                                           CAP013 193883
      *
     C     @Type         IFEQ      '0'
     C     A_SETYLC      IFeq      'I'                                          193883
     C                   MOVE      '*FRONT'      @@MODE
     C                   ELSE                                                   193883
     C                   MOVE      *BLANKS       @@MODE                         193883
     C                   ENDIF                                                  193883
     C                   ELSE
     C                   MOVE      *BLANKS       @@MODE
     C                   END
 
     C                   CALLB     'SDSECDRTV'
      * INPUTS
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
     C                   PARM      A_SETYLC      ACTN              1
      *
      * Front Office Transaction ID
     C                   PARM      A_SEFRNT      FOTRID           20
      *
      * Midas Customer Number
     C                   PARM                    MidasTrNum        6
      *                                                                         154562
      * Key Screen number or shortname
     C                   PARM                    DDCSST           10
      *                                                                         154562
      * OUTPUTS
      *
      * Securities Clients Details in File Format
     C                   PARM                    ChkSecdFmt
      *
      * OK - Action code
     C                   PARM      *BLANK        DDACTNOK          1
      *
      * OK - Customer Number
     C                   PARM                    DDCUSTOK          1
      *
      ** Customer Shortname
     C                   PARM                    DDCSSN           10
 
      ** Customer Report Name
     C                   PARM                    DDCRNM           20
 
      ** Customer Report Town
     C                   PARM                    DDCRTN           10
 
      ** Depot Shortnames Array
     C                   PARM                    DepotSn
 
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
 
     C     @TYPE         IFEQ      '1'
 
     C     CHBFTMST      IFNE      A_SETMES
     C                   MOVEL     '*RECUPD'     @@RTCD
     C                   END
 
      ** Batch mode:
     C                   ELSE
     C     DDACTNOK      IFEQ      'N'
     C     DDCUSTOK      OREQ      'N'
     C                   MOVEL     '*RECUPD'     @@RTCD
     C                   Z-ADD     1             C                 2 0
 
     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C                   MOVEL     *BLANKS       DBError          28
     C                   MOVEL     MsgIDArr(C)   DBError
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
     C                   ADD       1             C
     C                   END
 
     C                   END
 
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * INSERT - Insert a Security Customer Details                  *
      *                                                              *
      ****************************************************************
     C     INSERT        BEGSR
 
      ** Access Security Customer Details
 
     C     A_SECUST      CHAIN     SDSECSL1                           99
 
      ** Database error
 
     C     *IN99         IFEQ      '0'
     C                   MOVEL     A_SECUST      DBKEY
     C                   MOVEL     'SDSECSPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   EXSR      SRERR                                        ************
     C                   END
 
      ** Initialize Securities Clients Detail
 
     C                   CLEAR                   SECDF
 
      ** Store Old fields for comparisons
     C                   MOVEL(P)  SECDF         B_SECDF
 
      ** Set securities fields on insert
     C                   EVAL      BFCUST = A_SECUST
     C                   EVAL      BFACCD = A_SEACCD
     C                   EVAL      BFPCYC = A_SEPCYC
     C                   EVAL      BFCYCD = A_SECYCD
     C                   EVAL      BFADCD = A_SEADCD
     C                   EVAL      BFLCD  = BJRDNB
     C                   EVAL      BFTYLC = 'I'
     C                   EVAL      BFACSN = A_SEACSN
     C                   EVAL      BFCLAS = A_SECLAS
     C**********         EVAL      BFDRF1 = A_SEDRF1                                          CSE022
     C                   EVAL      BFNDR1 = A_SENDR1                                          CSE022
     C**********         EVAL      BFDRF2 = A_SEDRF2                                          CSE022
     C                   EVAL      BFNDR2 = A_SENDR2                                          CSE022
     C**********         EVAL      BFDRF3 = A_SEDRF3                                          CSE022
     C                   EVAL      BFNDR3 = A_SENDR3                                          CSE022
     C**********         EVAL      BFDRF4 = A_SEDRF4                                          CSE022
     C                   EVAL      BFNDR4 = A_SENDR4                                          CSE022
     C**********         EVAL      BFDRF5 = A_SEDRF5                                          CSE022
     C                   EVAL      BFNDR5 = A_SENDR5                                          CSE022
     C**********         EVAL      BFDRF6 = A_SEDRF6                                          CSE022
     C                   EVAL      BFNDR6 = A_SENDR6                                          CSE022
     C**********         EVAL      BFDRF7 = A_SEDRF7                                          CSE022
     C                   EVAL      BFNDR7 = A_SENDR7                                          CSE022
     C**********         EVAL      BFDRF8 = A_SEDRF8                                          CSE022
     C                   EVAL      BFNDR8 = A_SENDR8                                          CSE022
     C**********         EVAL      BFDRF9 = A_SEDRF9                                          CSE022
     C                   EVAL      BFNDR9 = A_SENDR9                                          CSE022
     C**********         EVAL      BFDRF0 = A_SEDRF0                                          CSE022
     C                   EVAL      BFNDR0 = A_SENDR0                                          CSE022
     C                   EVAL      BFPNP1 = A_SEPNP1
     C                   EVAL      BFPNP2 = A_SEPNP2
     C                   EVAL      BFPNP3 = A_SEPNP3
     C                   EVAL      BFPNP4 = A_SEPNP4
     C                   EVAL      BFPNP5 = A_SEPNP5
     C                   EVAL      BFPNP6 = A_SEPNP6
     C                   EVAL      BFPNP7 = A_SEPNP7
     C                   EVAL      BFPNP8 = A_SEPNP8
     C                   EVAL      BFPNP9 = A_SEPNP9
     C                   EVAL      BFPNP0 = A_SEPNP0
     C                   EVAL      BFCFIN = A_SECFIN
     C                   EVAL      BFSTFQ = A_SESTFQ
     C                   EVAL      BFNSDT = A_SESNSD
     C                   EVAL      BFSBDM = A_SESBDM
     C                   EVAL      BFPLAG = A_SEPLAG
     C                   EVAL      BFNARR = A_SENARR
     C                   EVAL      BFNTFC = 0
     C                   EVAL      BFSRCD = A_SESRCD
     C                   EVAL      BFTCD  = A_SETXCD
     C                   EVAL      BFASIN = A_SEASIN
     C                   EVAL      BFSBJF = A_SESBJF
     C                   EVAL      BFCFGC = A_SECFGC
     C                   EVAL      BFTDCG = A_SETDCG
     C                   EVAL      BFPSCG = A_SEPSCG
     C                   EVAL      BFSARQ = A_SESARQ                                          CSE039
     C                   EVAL      BFCSCG = A_SECSCG                                          CSE041
     C                   EVAL      BFCSVP = A_SECSVP                                          CSE041
     C                   EVAL      BFEWVF = A_SEEWVF                                          CSE042
     C                   EVAL      BFAFUM = A_SEAFUM                                          CSE042
     C                   EVAL      BFAFFM = A_SEAFFM                                          CSE042
     C                   EVAL      BFARST = A_SEARST                                          CSE042
     C                   EVAL      BFRREQ = A_SERREQ                                          CSE070
 
      ** Front Office ID
     C                   EVAL      BFFRNT=A_SEFRNT
      ** Associated Front Office ID
     C                   EVAL      BFAFRT=A_SEAFRT
      ** Repair Location
     C                   EVAL      BFREPA=A_SEREPA
      *
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
     C                   EVAL      BFTMST  = TimeStamp
 
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IF        BFFRNT = *BLANKS                                           CSC011
     C                   EVAL      BFFRNT = 'MD' + BFCUST                                     CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      *
      ** Write new Securities Clients Detail
 
     C                   WRITE     @BFREDQ
 
     C                   Z-ADD     1             WUNORC            5 0          No of records
     C                   Z-ADD     *ZERO         WUNOAM            5 0          No of Amend
     C                   Z-ADD     *ZERO         WUNODL            5 0          No of delete
     C                   Z-ADD     1             WUNOIN            5 0          No of Insert
 
      * Change Standing Data Cont - Standing Data Controls  *
     C                   MOVEL     'SDSECSPD'    WFLNAME           8            No of delete
     C                   EXSR      CHGSDCTL
      *                                                                                       CER034
      ** Set Securities Customer Flag on Customer Details Database                            CER034
      *                                                                                       CER034
     C                   IF        CER034 = 'Y'                                               CER034
      *                                                                                       CER034
     C     BFCUST        CHAIN     SDACUSL0                                                   CER034
     C                   IF        %FOUND                                                     CER034
     C                   EVAL      E5SECU = 'Y'                                               CER034
     C                   UPDATE    @ACUSL0                                                    CER034
     C                   ELSE                                                                 CER034
     C                   MOVEL     BFCUST        DBKEY                                        CER034
     C                   MOVEL     'SDACUSPD'    DBFILE                                       CER034
     C                   MOVEL     '912'         DBASE                                        CER034
     C                   EXSR      SRERR                                                      CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
 
      * Update CLINTSE - Securitiy Details
 
      ** CLINTSE expects a packed seq field (file field is zoned)
     C                   EVAL      WKACSN = BFACSN
 
     C                   CALL      'CLINTSE'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM                    BFCUST            6
     C**********         PARM                    BFACCD            4                          CGL029
     C                   PARM                    BFACCD           10                          CGL029
     C                   PARM                    BFPCYC            3
     C                   PARM                    BFCYCD            3
     C                   PARM                    BFADCD            1
     C                   PARM                    WKACSN
     C                   PARM                    BFCLAS            1
     C**********         PARM                    BFDRF1            6                          CSE022
     C                   PARM                    BFNDR1           20                          CSE022
     C**********         PARM                    BFDRF2            6                          CSE022
     C                   PARM                    BFNDR2           20                          CSE022
     C**********         PARM                    BFDRF3            6                          CSE022
     C                   PARM                    BFNDR3           20                          CSE022
     C**********         PARM                    BFDRF4            6                          CSE022
     C                   PARM                    BFNDR4           20                          CSE022
     C**********         PARM                    BFDRF5            6                          CSE022
     C                   PARM                    BFNDR5           20                          CSE022
     C**********         PARM                    BFDRF6            6                          CSE022
     C                   PARM                    BFNDR6           20                          CSE022
     C**********         PARM                    BFDRF7            6                          CSE022
     C                   PARM                    BFNDR7           20                          CSE022
     C**********         PARM                    BFDRF8            6                          CSE022
     C                   PARM                    BFNDR8           20                          CSE022
     C**********         PARM                    BFDRF9            6                          CSE022
     C                   PARM                    BFNDR9           20                          CSE022
     C**********         PARM                    BFDRF0            6                          CSE022
     C                   PARM                    BFNDR0           20                          CSE022
     C                   PARM                    BFPNP1            2
     C                   PARM                    BFPNP2            2
     C                   PARM                    BFPNP3            2
     C                   PARM                    BFPNP4            2
     C                   PARM                    BFPNP5            2
     C                   PARM                    BFPNP6            2
     C                   PARM                    BFPNP7            2
     C                   PARM                    BFPNP8            2
     C                   PARM                    BFPNP9            2
     C                   PARM                    BFPNP0            2
     C                   PARM                    BFCFIN            1
     C                   PARM                    BFSTFQ            1
     C                   PARM                    BFNSDT            5 0
     C                   PARM                    BFSBDM            2 0
     C                   PARM                    BFPLAG            1
     C                   PARM                    BFNARR           35
     C                   PARM                    BFNTFC            5 0
     C                   PARM                    BFSRCD            5
     C                   PARM                    BFTCD             2
     C                   PARM                    BFASIN            1
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    BFTYLC            1
 
      * Send message 'Unable to update'
     C     @RTCD         IFEQ      '*ERROR*'
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     BFCUST        DBKEY
     C                   MOVEL     'CLINTSE'     DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   EXSR      SRERR                                        ************
                                                                                              CSE022
      ** Add record to other depot file if no error.                                          CSE022
                                                                                              CSE022
     C                   ELSE                                                                 CSE022
                                                                                              CSE022
     C     A_SECUST      SETLL     SDVCSDRL2                                                  CSE022
     C     A_SECUST      READE     SDVCSDRL2                              98                  CSE022
     C                   DOW       *IN98 <> True                                              CSE022
     C     KCnDpn        CHAIN     SDCSDRL0                           97                      CSE022
     C                   IF        *IN97 = True                                               CSE022
     C                   EVAL      DRCUST = DSCUST                                            CSE022
     C                   EVAL      DRDPOT = DSDPOT                                            CSE022
     C                   EVAL      DRREFN = DSREFN                                            CSE022
     C                   WRITE     SDCSDRD0                                                   CSE022
     C                   ENDIF                                                                CSE022
     C     A_SECUST      READE     SDVCSDRL2                              98                  CSE022
     C                   ENDDO                                                                CSE022
                                                                                              CSE022
     C                   END
 
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * AMEND  - Amend a Securities Clients Detail                   *
      *                                                              *
      ****************************************************************
     C     AMEND         BEGSR
 
      ** Access Securities Clients Detail record
 
     C     A_SECUST      CHAIN     SDSECSL1                           99
 
      ** Database error
 
     C     *IN99         IFEQ      '1'
     C**LH               MOVEL     A_SECUST      DBKEY
     C**LH               MOVEL     'SDSECSPD'    DBFILE                         ************
     C**LH               MOVEL     '903'         DBASE                          * DBERR 903*
     C**LH               EXSR      SRERR                                        ************
     C                   EXSR      INSERT
     C                   ELSE
 
      ** Update 'BEFORE' status
 
     C                   MOVEL(P)  SECDF         B_SECDF
 
      ** Set Securities Clients Detail fields on amend
 
     C                   EVAL      BFCUST = A_SECUST
     C                   EVAL      BFACCD = A_SEACCD
     C                   EVAL      BFPCYC = A_SEPCYC
     C                   EVAL      BFCYCD = A_SECYCD
     C                   EVAL      BFADCD = A_SEADCD
     C                   EVAL      BFLCD  = BJRDNB
     C                   EVAL      BFTYLC = 'A'
     C                   EVAL      BFACSN = A_SEACSN
     C                   EVAL      BFCLAS = A_SECLAS
     C**********         EVAL      BFDRF1 = A_SEDRF1                                          CSE022
     C                   EVAL      BFNDR1 = A_SENDR1                                          CSE022
     C**********         EVAL      BFDRF2 = A_SEDRF2                                          CSE022
     C                   EVAL      BFNDR2 = A_SENDR2                                          CSE022
     C**********         EVAL      BFDRF3 = A_SEDRF3                                          CSE022
     C                   EVAL      BFNDR3 = A_SENDR3                                          CSE022
     C**********         EVAL      BFDRF4 = A_SEDRF4                                          CSE022
     C                   EVAL      BFNDR4 = A_SENDR4                                          CSE022
     C**********         EVAL      BFDRF5 = A_SEDRF5                                          CSE022
     C                   EVAL      BFNDR5 = A_SENDR5                                          CSE022
     C**********         EVAL      BFDRF6 = A_SEDRF6                                          CSE022
     C                   EVAL      BFNDR6 = A_SENDR6                                          CSE022
     C**********         EVAL      BFDRF7 = A_SEDRF7                                          CSE022
     C                   EVAL      BFNDR7 = A_SENDR7                                          CSE022
     C**********         EVAL      BFDRF8 = A_SEDRF8                                          CSE022
     C                   EVAL      BFNDR8 = A_SENDR8                                          CSE022
     C**********         EVAL      BFDRF9 = A_SEDRF9                                          CSE022
     C                   EVAL      BFNDR9 = A_SENDR9                                          CSE022
     C**********         EVAL      BFDRF0 = A_SEDRF0                                          CSE022
     C                   EVAL      BFNDR0 = A_SENDR0                                          CSE022
     C                   EVAL      BFPNP1 = A_SEPNP1
     C                   EVAL      BFPNP2 = A_SEPNP2
     C                   EVAL      BFPNP3 = A_SEPNP3
     C                   EVAL      BFPNP4 = A_SEPNP4
     C                   EVAL      BFPNP5 = A_SEPNP5
     C                   EVAL      BFPNP6 = A_SEPNP6
     C                   EVAL      BFPNP7 = A_SEPNP7
     C                   EVAL      BFPNP8 = A_SEPNP8
     C                   EVAL      BFPNP9 = A_SEPNP9
     C                   EVAL      BFPNP0 = A_SEPNP0
     C                   EVAL      BFCFIN = A_SECFIN
     C                   EVAL      BFSTFQ = A_SESTFQ
     C                   EVAL      BFNSDT = A_SESNSD
     C                   EVAL      BFSBDM = A_SESBDM
     C                   EVAL      BFPLAG = A_SEPLAG
     C                   EVAL      BFNARR = A_SENARR
     C                   EVAL      BFNTFC = A_SENTFC
     C                   EVAL      BFSRCD = A_SESRCD
     C                   EVAL      BFTCD  = A_SETXCD
     C                   EVAL      BFASIN = A_SEASIN
     C                   EVAL      BFSBJF = A_SESBJF
     C                   EVAL      BFCFGC = A_SECFGC
     C                   EVAL      BFTDCG = A_SETDCG
     C                   EVAL      BFPSCG = A_SEPSCG
     C                   EVAL      BFSARQ = A_SESARQ                                          CSE039
     C                   EVAL      BFCSCG = A_SECSCG                                          CSE041
     C                   EVAL      BFCSVP = A_SECSVP                                          CSE041
     C                   EVAL      BFEWVF = A_SEEWVF                                          CSE042
     C                   EVAL      BFAFUM = A_SEAFUM                                          CSE042
     C                   EVAL      BFAFFM = A_SEAFFM                                          CSE042
     C                   EVAL      BFARST = A_SEARST                                          CSE042
     C                   EVAL      BFRREQ = A_SERREQ                                          CSE070
 
 
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   EVAL      BFTMST=TimeStamp                             CAP013
      ** Front Office ID                                                        CAP013
     C                   EVAL      BFFRNT=A_SEFRNT                              CAP013
      ** Associated Front Office ID                                             CAP013
     C                   EVAL      BFAFRT=A_SEAFRT                              CAP013
 
      *
      ** UPDATE RECORD
 
     C                   UPDATE    @BFREDQ
 
 
      * USER: Processing after Data update
     C                   Z-ADD     *ZERO         WUNORC                         No of records
     C                   Z-ADD     1             WUNOAM                         No of Amend
     C                   Z-ADD     *ZERO         WUNOIN                         No of delete
     C                   Z-ADD     *ZERO         WUNODL                         No of Insert
 
      * Change Standing Data Cont - Standing Data Controls  *
     C                   MOVEL     'SDSECSPD'    WFLNAME           8            No of delete
     C                   EXSR      CHGSDCTL
 
 
      * Update CLINTSE - Securities Clients Details
 
      ** CLINTSE expects a packed seq field (file field is zoned)
     C                   EVAL      WKACSN = BFACSN
 
     C                   CALL      'CLINTSE'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM                    BFCUST            6
     C**********         PARM                    BFACCD            4                          CGL029
     C                   PARM                    BFACCD           10                          CGL029
     C                   PARM                    BFPCYC            3
     C                   PARM                    BFCYCD            3
     C                   PARM                    BFADCD            1
     C                   PARM                    WKACSN
     C                   PARM                    BFCLAS            1
     C**********         PARM                    BFDRF1            6                          CSE022
     C                   PARM                    BFNDR1           20                          CSE022
     C**********         PARM                    BFDRF2            6                          CSE022
     C                   PARM                    BFNDR2           20                          CSE022
     C**********         PARM                    BFDRF3            6                          CSE022
     C                   PARM                    BFNDR3           20                          CSE022
     C**********         PARM                    BFDRF4            6                          CSE022
     C                   PARM                    BFNDR4           20                          CSE022
     C**********         PARM                    BFDRF5            6                          CSE022
     C                   PARM                    BFNDR5           20                          CSE022
     C**********         PARM                    BFDRF6            6                          CSE022
     C                   PARM                    BFNDR6           20                          CSE022
     C**********         PARM                    BFDRF7            6                          CSE022
     C                   PARM                    BFNDR7           20                          CSE022
     C**********         PARM                    BFDRF8            6                          CSE022
     C                   PARM                    BFNDR8           20                          CSE022
     C**********         PARM                    BFDRF9            6                          CSE022
     C                   PARM                    BFNDR9           20                          CSE022
     C**********         PARM                    BFDRF0            6                          CSE022
     C                   PARM                    BFNDR0           20                          CSE022
     C                   PARM                    BFPNP1            2
     C                   PARM                    BFPNP2            2
     C                   PARM                    BFPNP3            2
     C                   PARM                    BFPNP4            2
     C                   PARM                    BFPNP5            2
     C                   PARM                    BFPNP6            2
     C                   PARM                    BFPNP7            2
     C                   PARM                    BFPNP8            2
     C                   PARM                    BFPNP9            2
     C                   PARM                    BFPNP0            2
     C                   PARM                    BFCFIN            1
     C                   PARM                    BFSTFQ            1
     C                   PARM                    BFNSDT            5 0
     C                   PARM                    BFSBDM            2 0
     C                   PARM                    BFPLAG            1
     C                   PARM                    BFNARR           35
     C                   PARM                    BFNTFC            5 0
     C                   PARM                    BFSRCD            5
     C                   PARM                    BFTCD             2
     C                   PARM                    BFASIN            1
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    BFTYLC            1
 
      * Send message 'Unable to update'
     C     @RTCD         IFEQ      '*ERROR*'
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     BFCUST        DBKEY
     C                   MOVEL     'CLINTSE'     DBFILE                         ************
     C                   MOVEL     '904'         DBASE                          * DBERR 904*
     C                   EXSR      SRERR                                        ************
                                                                                              CSE022
      ** Add or update record to other depot file if no error.                                CSE022
                                                                                              CSE022
     C                   ELSE                                                                 CSE022
                                                                                              CSE022
     C     @@MODE        IFEQ      '*FRONT'                                                 AR325335
     C     A_SECUST      SETLL     SDCSDRD0                                                 BUG12213
     C     A_SECUST      READE     SDCSDRD0                               22                BUG12213
                                                                                            BUG12213
     C                   DOW       *IN22 = *OFF                                             BUG12213
     C                   DELETE    SDCSDRD0                                                 BUG12213
     C     A_SECUST      READE     SDCSDRD0                               22                BUG12213
     C                   ENDDO                                                              BUG12213
                                                                                            BUG12213
     C                   ENDIF                                                              AR325335
     C     A_SECUST      SETLL     SDVCSDRL2                                                  CSE022
     C     A_SECUST      READE     SDVCSDRL2                              98                  CSE022
     C                   DOW       *IN98 <> True                                              CSE022
     C     KCnDpn        CHAIN     SDCSDRL0                           97                      CSE022
     C                   EVAL      DRCUST = DSCUST                                            CSE022
     C                   EVAL      DRDPOT = DSDPOT                                            CSE022
     C                   EVAL      DRREFN = DSREFN                                            CSE022
     C                   IF        *IN97 = True                                               CSE022
     C                   WRITE     SDCSDRD0                                                   CSE022
     C                   ELSE                                                                 CSE022
     C**********         UPDATE    SDCSDRD0                                                   CSE022
     C     @@MODE        IFNE      '*FRONT'                                                 AR325335
     C                   UPDATE    SDCSDRD0                                                 AR325335
     C                   ENDIF                                                              AR325335
     C                   ENDIF                                                                CSE022
     C     A_SECUST      READE     SDVCSDRL2                              98                  CSE022
     C                   ENDDO                                                                CSE022
                                                                                              CSE022
     C                   END
 
     C                   END
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * DELETE - DELETE A CUSTOMER                                   *
      *                                                              *
      ****************************************************************
     C     DELETE        BEGSR
 
      ** Access Security Customer Details
 
     C     A_SECUST      CHAIN     SDSECSL1                           99
 
      ** Database error
 
     C     *IN99         IFEQ      '1'
     C                   MOVEL     A_SECUST      DBKEY
     C                   MOVEL     'SDSECSPD'    DBFILE                         ************
     C                   MOVEL     '905'         DBASE                          * DBERR 905*
     C                   EXSR      SRERR                                        ************
     C                   END
 
      ** Update 'BEFORE' status
 
     C                   MOVEL(P)  SECDF         B_SECDF
 
 
      ** Delete record
 
     C                   DELETE    @BFREDQ
 
      * USER: Processing after Data update
     C                   MOVEL     SECDF         WUDELR
      * Write Deleted Record - SD Deleted Records File  *
     C                   CLEAR                   PBRC
     C                   MOVEL     'SDSECSPD'    PBFNME
     C                   MOVEL     A_SECUST      PBLKEY
     C                   MOVEL     WUDR01        PBDR01
     C                   MOVEL     WUDR02        PBDR02
     C                   MOVEL     WUDR03        PBDR03
     C                   MOVEL     WUDR04        PBDR04
     C                   MOVEL     WUDR05        PBDR05
     C                   MOVEL     WUDR06        PBDR06
     C                   MOVEL     WUDR07        PBDR07
     C                   MOVEL     WUDR08        PBDR08
     C                   MOVEL     WUDR09        PBDR09
     C                   MOVEL     WUDR10        PBDR10
     C                   MOVEL     WUDR11        PBDR11
     C                   MOVEL     WUDR12        PBDR12
     C                   MOVEL     BJRDNB        PBLCD
     C                   MOVEL     'D'           PBTYLC
 
     C                   CALL      'SD0520X'
     C                   PARM      *BLANK        @RTCD
     C                   PARM                    PBRC
      * Error detected?
     C     @RTCD         IFEQ      '*ERROR*'
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     A_SECUST      DBKEY
     C                   MOVEL     'SDDELRL0'    DBFILE                         ************
     C                   MOVEL     '906'         DBASE                          * DBERR 906*
     C                   EXSR      SRERR                                        ************
     C                   END
 
     C                   Z-ADD     -1            WUNORC                         No of records
     C                   Z-ADD     *ZERO         WUNOAM                         No of Amend
     C                   Z-ADD     *ZERO         WUNOIN                         No of delete
     C                   Z-ADD     1             WUNODL                         No of Insert
      * Change Standing Data Cont - Standing Data Controls  *
     C                   MOVEL     'SDSECSPD'    WFLNAME           8            No of delete
     C                   EXSR      CHGSDCTL
      *                                                                                       CER034
      ** Reset Securities Customer Flag on Customer Details Database                          CER034
      *                                                                                       CER034
     C                   IF        CER034 = 'Y'                                               CER034
      *                                                                                       CER034
     C     BFCUST        CHAIN     SDACUSL0                                                   CER034
     C                   IF        %FOUND                                                     CER034
     C                   EVAL      E5SECU = 'N'                                               CER034
     C                   UPDATE    @ACUSL0                                                    CER034
     C                   ELSE                                                                 CER034
     C                   MOVEL     BFCUST        DBKEY                                        CER034
     C                   MOVEL     'SDACUSPD'    DBFILE                                       CER034
     C                   MOVEL     '913'         DBASE                                        CER034
     C                   EXSR      SRERR                                                      CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
 
     C                   MOVEL     'D'           BFTYLC
      * Update CLINTSE - Securities Clients Details
     C                   CALL      'CLINTSE'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM                    BFCUST            6
     C**********         PARM                    BFACCD            4                          CGL029
     C                   PARM                    BFACCD           10                          CGL029
     C                   PARM                    BFPCYC            3
     C                   PARM                    BFCYCD            3
     C                   PARM                    BFADCD            1
     C                   PARM                    BFACSN            2 0
     C                   PARM                    BFCLAS            1
     C**********         PARM                    BFDRF1            6                          CSE022
     C                   PARM                    BFNDR1           20                          CSE022
     C**********         PARM                    BFDRF2            6                          CSE022
     C                   PARM                    BFNDR2           20                          CSE022
     C**********         PARM                    BFDRF3            6                          CSE022
     C                   PARM                    BFNDR3           20                          CSE022
     C**********         PARM                    BFDRF4            6                          CSE022
     C                   PARM                    BFNDR4           20                          CSE022
     C**********         PARM                    BFDRF5            6                          CSE022
     C                   PARM                    BFNDR5           20                          CSE022
     C**********         PARM                    BFDRF6            6                          CSE022
     C                   PARM                    BFNDR6           20                          CSE022
     C**********         PARM                    BFDRF7            6                          CSE022
     C                   PARM                    BFNDR7           20                          CSE022
     C**********         PARM                    BFDRF8            6                          CSE022
     C                   PARM                    BFNDR8           20                          CSE022
     C**********         PARM                    BFDRF9            6                          CSE022
     C                   PARM                    BFNDR9           20                          CSE022
     C**********         PARM                    BFDRF0            6                          CSE022
     C                   PARM                    BFNDR0           20                          CSE022
     C                   PARM                    BFPNP1            2
     C                   PARM                    BFPNP2            2
     C                   PARM                    BFPNP3            2
     C                   PARM                    BFPNP4            2
     C                   PARM                    BFPNP5            2
     C                   PARM                    BFPNP6            2
     C                   PARM                    BFPNP7            2
     C                   PARM                    BFPNP8            2
     C                   PARM                    BFPNP9            2
     C                   PARM                    BFPNP0            2
     C                   PARM                    BFCFIN            1
     C                   PARM                    BFSTFQ            1
     C                   PARM                    BFNSDT            5 0
     C                   PARM                    BFSBDM            2 0
     C                   PARM                    BFPLAG            1
     C                   PARM                    BFNARR           35
     C                   PARM                    BFNTFC            5 0
     C                   PARM                    BFSRCD            5
     C                   PARM                    BFTCD             2
     C                   PARM                    BFASIN            1
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    BFTYLC            1
 
      * Send message 'Unable to update'
     C     @RTCD         IFEQ      '*ERROR*'
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     BFCUST        DBKEY
     C                   MOVEL     'CLINTSE'     DBFILE                         ************
     C                   MOVEL     '907'         DBASE                          * DBERR 907*
     C                   EXSR      SRERR                                        ************
                                                                                              CSE022
      ** Update other depot file if no error.                                                 CSE022
                                                                                              CSE022
     C                   ELSE                                                                 CSE022
                                                                                              CSE022
     C     A_SECUST      SETLL     SDVCSDRL2                                                  CSE022
     C     A_SECUST      READE     SDVCSDRL2                              98                  CSE022
     C                   DOW       *IN98 <> True                                              CSE022
     C     KCnDpn        CHAIN     SDCSDRL0                           97                      CSE022
     C                   IF        *IN97 <> True                                              CSE022
     C                   DELETE    SDCSDRD0                                                   CSE022
     C                   ENDIF                                                                CSE022
     C     A_SECUST      READE     SDVCSDRL2                              98                  CSE022
     C                   ENDDO                                                                CSE022
                                                                                              CSE022
     C                   END
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CHGSDCTL -  Change Standing Data Controls                     *
      *                                                               *
      *****************************************************************
     C     CHGSDCTL      BEGSR
 
     C                   MOVEL     *BLANK        W0RTN             7
      *
      * Move key fields to @AHREAU
     C                   MOVEL     *BLANK        AHFLNM
     C                   MOVEL     WFLNAME       AHFLNM
      *
     C     KLCHSN        KLIST
     C                   KFLD                    AHFLNM
     C     KLCHSN        CHAIN     @AHREAU                            90
 
      ** Database error
 
     C     *IN90         IFEQ      '1'
     C                   MOVEL     AHFLNM        DBKEY
     C                   MOVEL     'SDFCTLL0'    DBFILE                         ************
     C                   MOVEL     '908'         DBASE                          * DBERR 908*
     C                   EXSR      SRERR                                        ************
     C                   END
 
      * Adjust file counts according to current action
     C                   ADD       WUNORC        AHNORC
     C                   ADD       WUNOIN        AHNOIN
     C                   ADD       WUNOAM        AHNOAM
     C                   ADD       WUNODL        AHNODL
      *
      * Update record
     C                   UPDATE    @AHREAU
      *
     C                   ENDSR
      *****************************************************************
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
 
      ** Externally described DS for valid Securities Clients Detail
     C                   PARM                    SDVSECD
      *
      ** Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '909'         DBASE                          * DBERR 909 *
     C                   EXSR      SRERR                                        *************
     C                   END
 
      ** Keylist for accessing SDCSDRL0.                                                      CSE022
                                                                                              CSE022
     C     KCnDpn        KLIST                                                                CSE022
     C                   KFLD                    DSCUST                                       CSE022
     C                   KFLD                    DSDPOT                                       CSE022
                                                                                              CSE022
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
                                                                                              CSC011
     C                   IF        (PRtCd <> '*NRF') and                                      CSC011
     C                             (PRtCd <> *Blanks)                                         CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 910                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      SRERR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
      *                                                                                       CER034
      ** Check if CER034 is installed                                                         CER034
      *                                                                                       CER034
     C                   CALLB     'AOSARDR0'                                                 CER034
     C                   PARM      *BLANKS       PRtCd                                        CER034
     C                   PARM      '*VERIFY'     POptn                                        CER034
     C                   PARM      'CER034'      PSard                                        CER034
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER034
      *                                                                                       CER034
     C                   IF        PRtCd = *BLANKS                                            CER034
     C                   EVAL      CER034 = 'Y'                                               CER034
     C                   ELSE                                                                 CER034
     C                   EVAL      CER034 = 'N'                                               CER034
      *                                                                                       CER034
     C                   IF        (PRtCd <> '*NRF') AND                                      CER034
     C                             (PRtCd <> *BLANKS)                                         CER034
     C     *LOCK         IN        LDA                                                        CER034
     C                   EVAL      DBKEY = 'CER034'                                           CER034
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER034
     C                   EVAL      DBASE = 911                                                CER034
     C                   OUT       LDA                                                        CER034
     C                   EXSR      SRERR                                                      CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                              *
      * SRERR - EXCEPTION ERRORS                                     *
      *                                                              *
      ****************************************************************
     C     SRERR         BEGSR
 
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'SDSECDUPD'   DBPGM            10
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
 
      **  TERMINATE THE PROGRAM
 
     C                   RETURN
 
     C                   ENDSR
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2001
