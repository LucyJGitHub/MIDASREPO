     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Spot Rate Database Update')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDSPTRUPD - Spot Rates Database Update                       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL165             Date 23Feb15               *
      *                 258531             Date 19Aug14               *
      *                 MD025467           Date 09May14               *
      *                 MD025009A          Date 09May14               *
      *                 MD025009           Date 09May14               *
      *                 CFT147             Date 14Jan13               *
      *                 AR744654           Date 13Apr11               *
      *                 CER059             Date 19Jul10               *
      *                 CER048             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 223192             Date 24Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAP185             Date 21Apr06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG8205            Date 26Aug05               *
      *                 BUG8130            Date 10Aug05               *
      *                 BUG7968            Date 01Aug05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 204923             Date 29Apr02               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 03Nov00               *
      *                 CAP057  *CREATE    Date 03Nov00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Witholding Tax                                 *
      *  258531 - Exchange rate is reciprocal of expected rate.       *
      *           Add condition if Mul/Div Indicator is 'M' or 'D'.   *
      *           Applied fix 132330.                                 *
      *  MD025467 - API locking issues Redesign Approach              *
      *  MD025009A - File already open error occured                  *
      *  MD025009 - SDFCTLPA allocation problem                       *
      *  CFT147 - Automatic update of payment charges definitions     *
      *           Added hooks: CFT147_036, CFT147_037, CFT147_038,    *
      *           CFT147_039                                          *
      *  AR744654 - Midas error occurred during confirm authorisation *
      *             of amended spot rates (Child: AR744655)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER048 - German Features - Taxes                             *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  223192 - Record not updated if Last Change Type on file is   *
      *           still 'I' (insert).  Pass 'A' (amend) as action     *
      *           code on call to SDSPTRRTV.                          *
      *  CAP185 - MQ Series Interface                                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG8205 - Use new logical file SDCURRML. Applied fix 209061  *
      *  BUG8130- Recompiled as there have been changes to SDVSPTRPD  *
      *  BUG7968- Parameter Mismatch in SDSPTRUPD when calling SD0021U*
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  204923 - Rate Fix Days Adjustment (OIS)                      *
      *           (Recompiled over changed SDVSPTRPD)                 *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CSD006 - Market Data Feeds                                   *
      *  CAP057 - Conversion of SPOT Rates into Modular APIs         *
      *                                                               *
      *****************************************************************


     F***SDCURRL1  UF A E           K DISK    COMMIT                                         BUG8205
     FSDCURRML  UF A E           K DISK    COMMIT                                            BUG8205
      * Midas SD Transaction Details Master File

     FSDFCTLL0  UF A E           K DISK    COMMIT
      * Midas SD Standing Data Controls index

     F***SDFCTLPAX O    E             DISK    COMMIT                               MD025009 MD025467
     F**********                           PREFIX(X)                               MD025009 MD025467
     F**********                           USROPN                                 MD025009A MD025467
     FSDFCTZTD  O    E           K DISK    COMMIT                                           MD025467
      * Midas SD Standing Data Controls index                                               MD025009
                                                                                            MD025009
     FSDMDFRL0  UF A E           K DISK    COMMIT                               CSD006
      * Market Data Feed Requests Details File                                  CSD006

     FSDMDFIL0  UF A E           K DISK    COMMIT                               CSD006
      * Market Data Feed Requested Details Items File                           CSD006

     FSDMDFHPD  UF A E           K DISK    COMMIT                               CSD006
      * Market Data Feed Rate/Price History File                                CSD006

     F***SDAPDRL0  IF   E        K DISK    INFSR(*PSSR)                            MD025009 MD025467
      *****************************************************************            MD025009 MD025467
      ***Midas*SD*API*Driving*File*************************************            MD025009 MD025467

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
                                                                                              CAP185
     D @TIMESTMPDFT    S             26A                                                      CAP185

     D ChkSPTRFmt    E DS                  EXTNAME(SDCURRPD)
     D                                     PREFIX(CH)
      ** Rename fields for Timestamp checking

      ***Work*Variables*for*Multithreaded*APIs********************                 MD025009 MD025467
     D***WAPIC           S              4A   INZ                                   MD025009 MD025467
     D***WFILN           S             10A   INZ                                   MD025009 MD025467
     D***MTHREAD         S              1A   INZ                                   MD025009 MD025467
      ************************************************************                 MD025009 MD025467
     D***MPHASDA       E DS                  EXTNAME(MPHAS)                        MD025009 MD025467
     D**********                           DTAARA(MPHAS)                           MD025009 MD025467

     D SDVSPTR       E DS                  EXTNAME(SDVSPTRPD)
      ** Externally described DS for valid transactions Detail


     D OKTrnDets     E DS                  EXTNAME(SDESPTRPD)
      * Error indicators


     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D                                     PREFIX(Z_)
      **  Externally described DS for Currency Access Object

     D SDCURR_A      E DS                  EXTNAME(SDCURRPD)
     D  SASPAE       E                     EXTFLD(QQSPAE)                                     CGL029
     D  SAFTAE       E                     EXTFLD(QQFTAE)                                     CGL029
     D  SASWAE       E                     EXTFLD(QQSWAE)                                     CGL029
     D  SATAC4       E                     EXTFLD(QQTAC4)                                     CGL029
     D  SATAC5       E                     EXTFLD(QQTAC5)                                     CGL029
     D  SACSCD       E                     EXTFLD(QQCSCD)                                     CGL029
      **  Externally described DS for 'AFTER UPDATE'

     D SDCURR_B      E DS                  EXTNAME(SDCURRPD)
     D                                     PREFIX(B_)
      **  Externally described DS for 'BEFORE UPDATE'

     D SDCURR_C      E DS                  EXTNAME(SDCURRPD)
     D                                     PREFIX(C_)
      **  Externally described DS for before base currency limits processing


      * Data Structures for use with access programs

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * Data structure for bank details

     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      * Data structure for dealing file details

     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  GLACCD       E                     EXTFLD(QQACCD)                                     CGL029
      * Data structure for general ledger

     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for access programs, short data structure

     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for access programs, long data structure
                                                                                              CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status dataarea                                                                 CSC011
                                                                                              CSC011
     D APHEAD        E DS                  EXTNAME(APHEADPD)                                  CSC011
      ** Midas API Message Header Format Definition                                           CSC011
                                                                                              CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
      ** External DS for SAR Details                                                          CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011

      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A

     D @Timestamp      S             26Z

     D BaseCurrIn      S              1
     D Recip           S              1

      * Parameter definitions for call to SD0028: Spot rates recalculation
     D @PA001          S                   LIKE(A6CYCD)
     D @PA002          S                   LIKE(BKEURO)
     D @PA003          S                   LIKE(BKEUCP)
     D @PA004          S              1
     D @PA005          S              1
     D @PA006          S              7

      * Parameter definitions for call to SD0021U: update old currency files
     D @PB001          S              7
     D @PB002          S                   LIKE(A6CYCD)
     D @PB003          S                   LIKE(A6SPAE)
     D @PB004          S                   LIKE(A6FTAE)
     D @PB005          S                   LIKE(A6SWAE)
     D @PB006          S                   LIKE(A6TAC4)
     D @PB007          S                   LIKE(A6TAC5)
     D @PB008          S                   LIKE(A6CDFN)
     D @PB009          S                   LIKE(A6ECDN)
     D @PB010          S                   LIKE(A6LCD )
     D @PB011          S              1
     D @PB012          S                   LIKE(A6CYNM)
     D @PB013          S                   LIKE(A6SPRT)
     D @PB014          S                   LIKE(A6SWCY)
     D***@PB015          S                   LIKE(A6NBDP)                                    BUG7968
     D @PB015          S              1P 0                                                   BUG7968
     D***@PB016          S                   LIKE(A6TXND)                                    BUG7968
     D @PB016          S              1P 0                                                   BUG7968
     D @PB017          S                   LIKE(A6PRRT)
     D***@PB018          S                   LIKE(A6SRC1)                                    BUG7968
     D @PB018          S              4P 0                                                   BUG7968
     D***@PB019          S                   LIKE(A6SRC2)                                    BUG7968
     D @PB019          S              4P 0                                                   BUG7968
     D @PB020          S                   LIKE(A6DLCI)
     D***@PB021          S          LIKE(A6SSNB)                                             BUG7968
     D @PB021          S              2P 0                                                   BUG7968
     D @PB022          S                   LIKE(A6ERLC)
     D @PB023          S                   LIKE(A6MDIN)
     D @PB024          S                   LIKE(A6MDPR)
     D @PB025          S                   LIKE(A6MDHB)
     D @PB026          S                   LIKE(A6MDEX)
     D @PB027          S                   LIKE(A6NOSN)
     D @PB028          S                   LIKE(A6SPDY)
     D***@PB029          S                   LIKE(A6FXSD)                                    BUG7968
     D @PB029          S              8P 0                                                   BUG7968
     D***@PB030          S                   LIKE(A6MMSD)                                    BUG7968
     D @PB030          S              8P 0                                                   BUG7968
     D***@PB031          S                   LIKE(A6NQDP)                                    BUG7968
     D @PB031          S              1P 0                                                   BUG7968
     D @PB032          S                   LIKE(A6DICB)
     D***@PB033          S                   LIKE(A6SCEX)                                    BUG7968
     D @PB033          S              1P 0                                                   BUG7968
     D @PB034          S                   LIKE(A6EBDA)
     D @PB035          S                   LIKE(A6HBRT)
     D***@PB036          S                   LIKE(A6ENC1)                                    BUG7968
     D @PB036          S              2P 0                                                   BUG7968
     D***@PB037          S                   LIKE(A6ENC2)                                    BUG7968
     D @PB037          S              2P 0                                                   BUG7968
     D @PB038          S                   LIKE(A6CACD)
     D***@PB039          S                   LIKE(A6CNMC)                                    BUG7968
     D @PB039          S              2P 0                                                   BUG7968
     D @PB040          S                   LIKE(A6FRIH)
     D @PB041          S                   LIKE(A6SATH)
     D @PB042          S                   LIKE(A6SUNH)
     D***@PB043          S                   LIKE(A6DPBF)                                    BUG7968
     D @PB043          S              1P 0                                                   BUG7968
     D @PB044          S                   LIKE(A6BYSR)
     D @PB045          S                   LIKE(A6BYSS)
     D @PB046          S                   LIKE(A6SLSR)
     D @PB047          S                   LIKE(A6SLSS)

      * Limit Exchange Rate Work Field
     D WUERLC          S                   LIKE(A6ERLC)
     D WUERLC2         S             15P 8                                                  AR744654
      * Base Currency Limit Change Flag
     D WUBCLC          S              1
                                                                                              CSC011
     D CSC011          S              1A   INZ('N')                                           CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D PTimestamp      S             26A                                                      CSC011
     D***PDealNo         S             18A                                             CSC011 CGL029
     D***PADealNo        S             18A                                             CSC011 CGL029
     D PDealNo         S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
     D/COPY OFCPYSRCZ,CFT147_036                                                              CFT147

      *                                                                                       CER048
      ** Parameter to call AOSARDR0                                                           CER048
      *                                                                                       CER048
     D CER048          S              1A                                                      CER048
      *                                                                                       CER048
     D CGL165          S              1A                                                      CGL165
      *                                                                                       CGL165
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

      ** Amend Process

     C**********         IF        NOT %OPEN(SDFCTLPAX)                           MD025009A MD025467
     C**********         OPEN      SDFCTLPAX                                      MD025009A MD025467
     C**********         ENDIF                                                    MD025009A MD025467
                                                                                           MD025009A
     C                   EXSR      AMEND
                                                                                              CSC011
      ** If 24x7 Midas Availability is installed, write to the standard                       CSC011
      ** log file when support system is active                                               CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' AND                                           CSC011
     C                             S1SUPP = LIBR                                              CSC011
                                                                                              CSC011
      ** Setup Loans/Deposits support log                                                     CSC011
                                                                                              CSC011
     C                   CALLB     'SDSPTRLOG'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    SDVSPTR                                      CSC011
     C                   PARM                    TRANSDTL                                     CSC011
                                                                                              CSC011
      ** Write to support database log file                                                   CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut = *BLANKS                                       CSC011
                                                                                              CSC011
     C                   EVAL      APTGTTYPE = 'SDSPTR'                                       CSC011
     C                   EVAL      APRPRLOCN = AVRPRLOCN                                      CSC011
     C                   EVAL      APFOTRANID = AVFOTRANID                                    CSC011
     C                   EVAL      PDealNo = AVCYCD                                           CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    APHEAD                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM      *BLANKS       PTimestamp                                   CSC011
     C                   PARM                    PDealNo                                      CSC011
     C                   PARM      *BLANKS       PADealNo                                     CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** If error occured,                                                                    CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *BLANKS                                      CSC011
                                                                                              CSC011
     C                   EVAL      @@RTCD = '*ERROR'                                          CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011

      * Exit from program
     C     EXIT          TAG

     C**********         IF        %OPEN(SDFCTLPAX)                               MD025009A MD025467
     C**********         CLOSE     SDFCTLPAX                                      MD025009A MD025467
     C**********         ENDIF                                                    MD025009A MD025467
                                                                                           MD025009A
     C                   RETURN
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CHKOTHUPD - Check for update by another workstation           *
      *                                                               *
      *****************************************************************
     C     CHKOTHUPD     BEGSR

      ** Retrieve current details

     C                   MOVE      AVCYCD        MidasRef          3


      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @Return           6
     C                   PARM                    @Type             1
      *                                                                                       CAP185
      ** If CAP185 is installed and timestamp is loval, set to batch                          CAP185
     C     CAP185        IFEQ      'Y'                                                        CAP185
      *                                                                                       CAP185
     C                   MOVE      AVTMESTMP     @TIMESTMPDFT                                 CAP185
      *                                                                                       CAP185
     C     @Type         IFEQ      '1'                                                        CAP185
     C     @TIMESTMPDFT  ANDEQ     *BLANKS                                                    CAP185
     C                   MOVE      '0'           @Type                                        CAP185
     C                   ENDIF                                                                CAP185
      *                                                                                       CAP185
     C                   ENDIF                                                                CAP185
      *                                                                                       CAP185
      *  Set retrieve mode to blank  (Access using Midas transaction ID).
      *
     C     @Type         IFEQ      '0'
     C                   MOVE      '*FRONT'      ModeofOp
     C                   ELSE
     C                   MOVE      *BLANKS       ModeofOp
     C                   END

     C                   CALLB     'SDSPTRRTV'
      * INPUTS
      *
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM      ' '           RespMode          1
      *
      * Action Code
     C**********         PARM      AVTYLC        ACTN              1                          223192
     C                   PARM      'A'           ACTN              1                          223192
      *
      * Front Office Transaction ID
     C                   PARM      AVFOTRANID    FOTRID           20
      *
      * Midas Currency Reference
     C                   PARM                    MidasRef          3
      *
      * OUTPUTS
      *
      * Transaction Details in File Format
     C                   PARM                    ChkSPTRFmt
      *
      * OK - Action code
     C                   PARM      *BLANK        DDACTNOK          1
      *
      * OK - Transaction Number
     C                   PARM                    DDTRNNOK          1

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
      ** has been updated since the original record was fetched
      ** by this program.
      ** In batch (API input) check return parameters from Retrieve
      ** module for errors, and send message to system operator.

      ** Interactive mode:

     C     @TYPE         IFEQ      '1'

     C     CHA6SRTM      IFNE      AVTMESTMP
     C                   MOVEL     '*RECUPD'     @@RTCD
     C                   END

      ** Batch mode:
     C                   ELSE
     C     DDACTNOK      IFEQ      'N'
     C     DDTRNNOK      OREQ      'N'
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
      * AMEND  - Amend a Transaction Details                         *
      *                                                              *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: GETRECIP                                               *
      *                                                               *
      ****************************************************************
     C     AMEND         BEGSR

      ** Access Transaction Detail record

     C*****AVCYCD        CHAIN     SDCURRL1                           99                     BUG8205
     C     AVCYCD        CHAIN     SDCURRML                           99                     BUG8205

      ** Database error

     C     *IN99         IFEQ      '1'
     C                   MOVEL     AVCYCD        DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   EXSR      SRERR                                        ************
     C                   END

      ** Update 'BEFORE' status

     C                   MOVEL(P)  SDCURR_A      SDCURR_B


      ** Set Transaction Detail fields on amend





     C                   Z-ADD     AVINER        A6INER
     C                   MOVEL     AVINMD        A6INMD
     C                   Z-ADD     AVSPRT        A6SPRT
     C                   MOVEL     AVMDIN        A6MDIN
     C                   MOVEL     AVSWCY        A6SWCY
     C                   MOVEL     AVDLCI        A6DLCI
     C                   MOVEL     AVSPAE        A6SPAE
     C                   MOVEL     AVFTAE        A6FTAE
     C                   MOVEL     AVSWAE        A6SWAE
     C                   MOVEL     AVTAC4        A6TAC4
     C                   MOVEL     AVTAC5        A6TAC5
     C                   MOVEL     AVCDFN        A6CDFN
     C                   MOVEL     AVECDN        A6ECDN
     C                   Z-ADD     BJRDNB        A6LCD
     C                   MOVEL     'A'           A6TYLC
     C                   MOVEL     AVCYNM        A6CYNM
     C                   Z-ADD     AVNBDP        A6NBDP
     C                   Z-ADD     AVTXND        A6TXND
     C                   Z-ADD     AVPRRT        A6PRRT
     C                   Z-ADD     AVSRC1        A6SRC1
     C                   Z-ADD     AVSRC2        A6SRC2
     C                   Z-ADD     AVSSNB        A6SSNB
     C                   Z-ADD     AVERLC        A6ERLC
     C                   MOVEL     AVMDPR        A6MDPR
     C                   MOVEL     AVMDHB        A6MDHB
     C                   MOVEL     AVMDEX        A6MDEX
     C                   MOVEL     AVNOSN        A6NOSN
     C                   Z-ADD     AVSPDY        A6SPDY
     C                   Z-ADD     AVHSRT        A6HSRT
     C                   Z-ADD     AVLSPR        A6LSPR
     C                   Z-ADD     AVFXSD        A6FXSD
     C                   Z-ADD     AVMMSD        A6MMSD
     C                   Z-ADD     AVNQDP        A6NQDP
     C                   MOVEL     AVDICB        A6DICB
     C                   Z-ADD     AVSCEX        A6SCEX
     C                   MOVEL     AVEBDA        A6EBDA
     C                   Z-ADD     AVHBRT        A6HBRT
     C                   Z-ADD     AVENC1        A6ENC1
     C                   Z-ADD     AVENC2        A6ENC2
     C                   MOVEL     AVCACD        A6CACD
     C                   Z-ADD     AVCNMC        A6CNMC
     C                   MOVEL     AVWEDH        A6WEDH
     C                   MOVEL     AVMONH        A6MONH
     C                   MOVEL     AVTUEH        A6TUEH
     C                   MOVEL     AVTHUH        A6THUH
     C                   MOVEL     AVFRIH        A6FRIH
     C                   MOVEL     AVSATH        A6SATH
     C                   MOVEL     AVSUNH        A6SUNH
     C                   Z-ADD     AVDPBF        A6DPBF
     C                   Z-ADD     AVBYSR        A6BYSR
     C                   MOVEL     AVBYSS        A6BYSS
     C                   Z-ADD     AVSLSR        A6SLSR
     C                   MOVEL     AVSLSS        A6SLSS
     C                   Z-ADD     AVRMCM        A6RMCM
     C                   MOVEL     'D'           A6RECI
     C                   MOVEL     AVDPRU        A6DPRU
     C                   MOVEL     AVDNOR        A6DNOR
     C                   MOVEL     AVNDWR        A6NDWR
     C                   MOVEL     AVGMPY        A6GMPY
     C                   MOVEL     AVDLCD        A6DLCD
     C                   MOVEL     AVRDFC        A6RDFC
     C                   MOVEL     AVPMRT        A6PMRT
     C                   Z-ADD     AVRKSQ        A6RKSQ
     C                   MOVEL     AVDFPC        A6DFPC
     C                   MOVEL     AVDDPC        A6DDPC
     C                   Z-ADD     AVTKCC        A6TKCC
     C                   Z-ADD     AVCQCD        A6CQCD
     C                   Z-ADD     AVSMLD        A6SMLD
     C                   MOVEL     AVCSCD        A6CSCD
     C                   Z-ADD     AVISON        A6ISON
     C                   MOVEL     AVDLOC        A6DLOC
     C                   MOVEL     AVMACD        A6MACD
     C                   MOVEL     AVFRAC        A6FRAC
     C                   MOVEL     AVNUWD        A6NUWD
     C                   MOVEL     AVMICD        A6MICD
     C                   MOVEL     AVINCY        A6INCY
     C                   Z-ADD     AVEUER        A6EUER
     C                   MOVEL     AVEUMD        A6EUMD
     C                   Z-ADD     AVTPSD        A6TPSD
     C                   Z-ADD     AVTPED        A6TPED
     C                   MOVEL     AVCYPI        A6CYPI
     C                   Z-ADD     AVEXWC        A6EXWC
     C                   Z-ADD     AVPOWC        A6POWC
     C                   Z-ADD     AVCYD1        A6CYD1
     C                   Z-ADD     AVCYD2        A6CYD2
     C                   Z-ADD     AVCYD3        A6CYD3
     C                   MOVEL     AVCYLD        A6CYLD
     C                   MOVEL     AVCYGR        A6CYGR
     C                   Z-ADD     AVRENO        A6RENO
     C                   Z-ADD     AVSWDP        A6SWDP
     C                   Z-ADD     AVSWDT        A6SWDT
     C                   MOVEL     AVSRDS        A6SRDS
     C                   Z-ADD     AVDFTS        A6DFTS

      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
     C                   Z-ADD     AVTCMP        A6TCMP                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
      * Tax Conversion Rate                                                                   CGL165
     C                   Z-ADD     AVTXCR        A6TXCR                                       CGL165
      *                                                                                       CGL165
      * Front Office ID
     C                   EVAL      A6SRID=  AVFOTRANID
      * Repair Location
     C                   EVAL      A6SRRP=  AVRPRLOCN
      * Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   EVAL      A6SRTM=TimeStamp
     C/COPY OFCPYSRCZ,CFT147_037                                                              CFT147
     C                   MOVEL     AVFRDS        A6FRDS
     C                   MOVEL     AVFRNT        A6FRNT
     C                   MOVEL     AVBODS        A6BODS
     C                   MOVEL     AVBOID        A6BOID
     C                   MOVEL     AVLEDS        A6LEDS
     C                   MOVEL     AVLEID        A6LEID
     C                   MOVEL     AVDTFR        A6DTFR
     C                   MOVE      ' '           A6TLEX

      * Update the currency file

     C                   UPDATE    @A6REA3                              90

     C/COPY OFCPYSRCZ,CFT147_038                                                              CFT147

      ** Spot Rates Recalculation for EMU Currencies

     C     CEU002        IFEQ      'Y'
     C     BJCYCD        ANDNE     BKEURO
     C     A6CYCD        OREQ      BKEURO
     C                   CALL      'SD0028'
     C                   PARM      BJCYCD        @PA001
     C                   PARM      BKEURO        @PA002
     C                   PARM      BKEUCP        @PA003
     C                   PARM      BaseCurrIn    @PA004
     C                   PARM      'N'           @PA005            1
     C                   PARM      *BLANKS       @PA006            7
     C                   ENDIF


      ** Update Standing Data Control file

     C**********         IF        MTHREAD = 'N'                                   MD025009 MD025467
     C*****'SDCURRPD  '  CHAIN     @AHREAU                            90                    MD025467
     C**********         ADD       1             AHNOAM                                     MD025467
     C**********         UPDATE    @AHREAU                                                  MD025467
     C**********         ELSE                                                      MD025009 MD025467
     C                   CLEAR                   SDFCTLA0                                   MD025009
     C                   EVAL      AHFLNM = 'SDCURRPD'                                      MD025467
     C                   EVAL      AHNOAM = 1                                               MD025467
     C**********         EVAL      XAHFLNM = 'SDCURRPD'                            MD025009 MD025467
     C**********         EVAL      XAHNOAM = 1                                     MD025009 MD025467
     C                   WRITE     SDFCTLA0                                                 MD025009
     C**********         ENDIF                                                     MD025009 MD025467
      *
      *
      * Background update of old currency codes files
      *
     C                   CALL      'SD0021U'                            90
     C                   PARM      *BLANK        @PB001
     C                   PARM      A6CYCD        @PB002
     C                   PARM      A6SPAE        @PB003
     C                   PARM      A6FTAE        @PB004
     C                   PARM      A6SWAE        @PB005
     C                   PARM      A6TAC4        @PB006
     C                   PARM      A6TAC5        @PB007
     C                   PARM      A6CDFN        @PB008
     C                   PARM      A6ECDN        @PB009
     C                   PARM      A6LCD         @PB010
     C                   PARM      'A'           @PB011
     C                   PARM      A6CYNM        @PB012
     C                   PARM      A6SPRT        @PB013
     C                   PARM      A6SWCY        @PB014
     C                   PARM      A6NBDP        @PB015
     C                   PARM      A6TXND        @PB016
     C                   PARM      A6PRRT        @PB017
     C                   PARM      A6SRC1        @PB018
     C                   PARM      A6SRC2        @PB019
     C                   PARM      A6DLCI        @PB020
     C                   PARM      A6SSNB        @PB021
     C                   PARM      A6ERLC        @PB022
     C                   PARM      A6MDIN        @PB023
     C                   PARM      A6MDPR        @PB024
     C                   PARM      A6MDHB        @PB025
     C                   PARM      A6MDEX        @PB026
     C                   PARM      A6NOSN        @PB027
     C                   PARM      A6SPDY        @PB028
     C                   PARM      A6FXSD        @PB029
     C                   PARM      A6MMSD        @PB030
     C                   PARM      A6NQDP        @PB031
     C                   PARM      A6DICB        @PB032
     C                   PARM      A6SCEX        @PB033
     C                   PARM      A6EBDA        @PB034
     C                   PARM      A6HBRT        @PB035
     C                   PARM      A6ENC1        @PB036
     C                   PARM      A6ENC2        @PB037
     C                   PARM      A6CACD        @PB038
     C                   PARM      A6CNMC        @PB039
     C                   PARM      A6FRIH        @PB040
     C                   PARM      A6SATH        @PB041
     C                   PARM      A6SUNH        @PB042
     C                   PARM      A6DPBF        @PB043
     C                   PARM      A6BYSR        @PB044
     C                   PARM      A6BYSS        @PB045
     C                   PARM      A6SLSR        @PB046
     C                   PARM      A6SLSS        @PB047

      ** Retrieve dealing currency
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      *BLANK        @RTCD             7            B:Return code
     C                   PARM      '*FIRST'      @OPTN             7            I:Option
     C*****SDDEAL        PARM      *BLANK        DSFDY                          O:FormaT      CGL029
     C     SDDEAL        PARM      *BLANK        DSSDY                                        CGL029
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDDEALPD'    DBFILE
     C                   MOVEL     '910'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

      * A change in dealing currency requires a change to all currencies

     C                   IF        BNCYCD = AVCYCD
     C                   IF        B_A6SPRT <> AVSPRT or
     C                             B_A6MDIN <> AVMDIN

      * Determine 'screen value' of spot rate and multiply divide indicator
     C                   EXSR      SCRVAL
      * For each record on the currency file
     C     *LOVAL        SETLL     @A6REA3
     C                   READ      @A6REA3
     C                   DOW       NOT %EOF

      * if the currency is not base currency or dealing currency
     C                   IF        A6CYCD <> BJCYCD and
     C                             A6CYCD <> BNCYCD

     C                   IF        A6MDIN = WUSMDI
     C**********         EVAL(H)   WUERLC = A6SPRT/WUSSSR                                   AR744654
     C                   EVAL(H)   WUERLC2 = A6SPRT/WUSSSR                                  AR744654
     C                   IF        WUERLC2 >= 100000                                        AR744654
     C                   EVAL      WUERLC = 99999.99999999                                  AR744654
     C                   ELSE                                                               AR744654
     C                   Z-ADD     WUERLC2       WUERLC                                     AR744654
     C                   ENDIF                                                              AR744654
     C                   ELSE
     C                   EVAL(H)   WUERLC = A6SPRT*WUSSSR
     C                   ENDIF
     C                   ENDIF

     C                   IF        A6CYCD = BJCYCD
     C                   IF        A6MDIN = 'M'                                               258531
     C                   IF        WUSMDI = 'M'
     C                   EVAL(H)   WUERLC = 1/WUSSSR
     C                   ELSE
     C                   EVAL      WUERLC = WUSSSR
     C                   ENDIF
                                                                                              258531
     C                   ELSE                                                                 258531
     C                   IF        WUSMDI = 'M'                                               258531
     C                   Z-ADD     WUSSSR        WUERLC                                       258531
     C                   ELSE                                                                 258531
     C                   EVAL(H)   WUERLC = 1/WUSSSR                                          258531
     C                   ENDIF                                                                258531
     C                   ENDIF                                                                258531
                                                                                              258531
     C                   ENDIF

     C                   IF        A6CYCD <> BNCYCD
     C     A6CYCD        CHAIN     @A6REA3                            9091
     C                   EVAL      SDCURR_C = SDCURR_A
     C                   EVAL      A6ERLC = WUERLC
     C                   IF        SDCURR_A <> SDCURR_C
     C                   UPDATE    @A6REA3                              91
     C                   ELSE
     C**********         UNLOCK    SDCURRL1                                                  BUG8205
     C                   UNLOCK    SDCURRML                                                  BUG8205
     C                   ENDIF


      * call SD0023U to update Limit Rate old files (TABTG10)

     C                   CALL      'SD0023U'                            90
     C                   PARM                    WQ0003            7
     C                   PARM      A6CYCD        WQ0004            3
     C                   PARM      WUERLC        WQ0005           13 8

     C                   ENDIF

     C                   READ      @A6REA3                              90
     C                   ENDDO

     C                   ENDIF
     C                   ENDIF


      ** Maintain Market Data Feed files                                        CSD006

     C                   IF        CSD006F = 'Y'                                CSD006

      * If the Data Feed Request ID is not blank,                               CSD006
      * write a new record to MDF Rate/Price History file...                    CSD006

     C                   IF        AVDTFR <> *Blank                             CSD006
     C                   MOVEL     AVDTFR        RHDFRI                         CSD006
     C                   MOVEL     AVCYCD        RHDITM                         CSD006
     C                   MOVEL     AVDFTS        RHDFTS                         CSD006
     C                   MOVEL     AVFOTRANID    RHTREF                         CSD006
     C                   MOVEL     BJRDNB        RHPRCD                         CSD006
     C                   MOVEL     AVTLEX        RHTLEX                         CSD006
     C                   MOVEL     *BLANK        RHAUDT                         CSD006
     C                   MOVEL     'SDCURRPD'    RHFILE                         CSD006
     C                   MOVEL     SDCURR_B      RHBIMG                         CSD006
     C                   MOVEL     SDCURR_A      RHAIMG                         CSD006
     C                   WRITE     SDMDFHD0                                     CSD006

      * and if the Tolerance Exceeded flag is on, update the MDF Requests       CSD006
      * Details and MDF Requested Items files                                   CSD006

     C                   IF        AVTLEX = 'Y'                                 CSD006

     C                   MOVEL     AVDTFR        WKREQI                         CSD006
     C                   MOVEL     A6CYCD        WKDITM                         CSD006
     C     KLMDFI        CHAIN     SDMDFIL0                                     CSD006
     C                   IF        %FOUND(SDMDFIL0)                             CSD006
     C                   EVAL      MITOLX = 'Y'                                 CSD006
     C                   UPDATE    SDMDFID0                                     CSD006

     C     AVDTFR        CHAIN     SDMDFRL0                                     CSD006
     C                   IF        %FOUND(SDMDFRL0)                             CSD006
     C                   EVAL      MRTOLX = 'Y'                                 CSD006
     C                   UPDATE    SDMDFRD0                                     CSD006
     C                   ELSE                                                   CSD006
     C                   UNLOCK    SDMDFRL0                                     CSD006
     C                   ENDIF                                                  CSD006

     C                   ELSE                                                   CSD006
     C                   UNLOCK    SDMDFIL0                                     CSD006
     C                   ENDIF                                                  CSD006

     C
     C                   ENDIF                                                  CSD006

     C                   ENDIF                                                  CSD006

     C                   ENDIF                                                  CSD006

     C                   ENDSR
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
      * Return Code
     C                   PARM                    @@RTCD            7
      * Externally described DS for valid Transaction Detail
     C                   PARM                    SDVSPTR
     C/COPY OFCPYSRCZ,CFT147_039                                                              CFT147

      * Access Bank Details
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
     C                   MOVEL     '902'         DBASE                          * DBERR 902 *
     C                   EXSR      SRERR                                        *************
     C                   END

      * Access Dealing File

     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDDEALPD'    DBFILE                         *************
     C                   MOVEL     '903'         DBASE                          * DBERR 903 *
     C                   EXSR      SRERR                                        *************
     C                   END

      ** Access currency file for base rate details
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      BJCYCD        @CYCD             3
     C     SDCURR_A      PARM      SDCURR_A      DSSDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '905'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Set up Base Currency In indicator
      *
     C                   CALLB     'SDSPTR4EU'
     C                   PARM                    ReturnCode
     C                   PARM      A6INCY        P@incy            1
     C                   PARM      A6TPSD        P@tpsd            5 0
     C     BaseCurrIn    PARM                    CurrIsIn          1
     C     ReturnCode    IFNE      *BLANKS
     C                   MOVEL     'SDSPTR4EU'   DBFILE
     C                   MOVEL     '907'         DBASE
     C                   MOVEL     '*CALL'       DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Check if the feature CGL165 is installed                                             CGL165
      *                                                                                       CGL165
     C                   CALLB     'AOSARDR0'                                                 CGL165
     C                   PARM      *BLANKS       @RTCD             7                          CGL165
     C                   PARM      '*VERIFY'     POPTN                                        CGL165
     C                   PARM      'CGL165'      PSARD                                        CGL165
      *                                                                                       CGL165
     C                   IF        @RTCD = *BLANKS                                            CGL165
     C                   EVAL      CGL165 = 'Y'                                               CGL165
     C                   ELSE                                                                 CGL165
      *                                                                                       CGL165
     C                   EVAL      CGL165 = 'N'                                               CGL165
     C                   ENDIF                                                                CGL165
      *                                                                                       CGL165

      ** Check if switchable feature CEU002 is switched on.
      ** Euro rates
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU002'      @SARD             6
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CEU002'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '906'         DBASE
     C                   EXSR      *PSSR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CEU002            1
     C                   ELSE
     C                   MOVE      'N'           CEU002
     C                   END

      ** Access general ledger for Euro currency name
      *
     C     CEU002        IFEQ      'Y'
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ** Initialise SPOT Rates For a EURO Base or 'IN' Currency Base.
      ** or 'OUT' Base.
      *
     C     CEU002        IFEQ      'Y'
     C                   CALL      'SD0028'
     C                   PARM      BJCYCD        @PA001
     C                   PARM      BKEURO        @PA002
     C                   PARM      BKEUCP        @PA003
     C                   PARM      BaseCurrIn    @PA004
     C                   PARM      'Y'           @PA005
     C                   PARM      *BLANKS       @PA006
     C                   ENDIF                                              6103
      *
      ** Access switchable features file - Market data feed                                   CSD006
      *                                                                                       CSD006
     C                   CALL      'AOSARDR0'                                                 CSD006
     C                   PARM      *BLANKS       @RTCD                                        CSD006
     C                   PARM      '*VERIFY'     @OPTN                                        CSD006
     C                   PARM      'CSD006'      @SARD             6                          CSD006
      *                                                                                       CSD006
     C     @RTCD         IFEQ      *BLANKS                                                    CSD006
     C                   MOVE      'Y'           CSD006F           1                          CSD006
     C                   ELSE                                                                 CSD006
     C                   MOVE      'N'           CSD006F                                      CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *Blanks                                            CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
                                                                                              CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
                                                                                              CSC011
      ** Database error                                                                       CSC011
                                                                                              CSC011
     C                   IF        PRTCD <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 911                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      SRERR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
      *                                                                                       CER048
      ** Check if the feature CER048 is installed                                             CER048
      *                                                                                       CER048
     C                   CALL      'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRTCD                                        CER048
     C                   PARM      '*VERIFY'     POPTN                                        CER048
     C                   PARM      'CER048'      PSARD                                        CER048
     C     SCSARD        PARM      SCSARD        DSSDY                                        CER048
      *                                                                                       CER048
     C                   IF        PRTCD = *BLANKS                                            CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
     C                   ELSE                                                                 CER048
      *                                                                                       CER048
     C                   EVAL      CER048 = 'N'                                               CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        (PRTCD <> *BLANKS) AND                                     CER048
     C                             (PRTCD <> '*NRF   ')                                       CER048
      *                                                                                       CER048
     C                   EVAL      DBKEY = 'CER048'                                           CER048
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER048
     C                   EVAL      DBASE = 912                                                CER048
     C                   EXSR      *PSSR                                                      CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048

      ** Check if CAP185 is installed                                                         CAP185
      *                                                                                       CAP185
     C                   CALL      'AOSARDR0'                                                 CAP185
     C                   PARM      *BLANKS       @RTCD                                        CAP185
     C                   PARM      '*VERIFY'     @OPTN                                        CAP185
     C                   PARM      'CAP185'      @SARD             6                          CAP185
      *                                                                                       CAP185
     C     @RTCD         IFEQ      *BLANKS                                                    CAP185
     C                   MOVE      'Y'           CAP185            1                          CAP185
     C                   ELSE                                                                 CAP185
     C                   MOVE      'N'           CAP185                                       CAP185
     C                   ENDIF                                                                CAP185
      *
      *
      ** Key list for accessing Market Data Feed Requested Items Details

     C     KLMDFI        KLIST                                                  CSD006
     C                   KFLD                    WKREQI           32            CSD006
     C                   KFLD                    WKDITM           20            CSD006

     C*****KAPILST       KLIST                                                     MD025009 MD025467
     C**********         KFLD                    WAPIC                             MD025009 MD025467
     C**********         KFLD                    WFILN                             MD025009 MD025467
                                                                                   MD025009 MD025467
     C**********         IN        MPHASDA                                         MD025009 MD025467
                                                                                   MD025009 MD025467
     C**********         EVAL      MTHREAD = 'N'                                   MD025009 MD025467
     C**********         EVAL      WAPIC = 'SPTR'                                  MD025009 MD025467
     C**********         EVAL      WFILN = 'SDFCTLPA'                              MD025009 MD025467

     C**********         IF        MPHAS = 'A'                                     MD025009 MD025467
     C*****KAPILST       CHAIN     SDAPDRL0                                        MD025009 MD025467
                                                                                            MD025009
     C**********         IF        %FOUND                                          MD025009 MD025467
     C**********         EVAL      MTHREAD = A8MULT                                MD025009 MD025467
     C**********         ENDIF                                                     MD025009 MD025467
                                                                                            MD025009
     C**********         ENDIF                                                     MD025009 MD025467

     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                              *
      * SCRVAL - SCREEN VALUE OF SPOT RATE, MULTIPLY DIVIDE IND      *
      *                                                              *
      ****************************************************************
     C     SCRVAL        BEGSR
     C     *LIKE         DEFINE    B_A6SPRT      WUSSSR
     C     *LIKE         DEFINE    B_A6MDIN      WUSMDI
     C     CEU002        IFEQ      'Y'
     C                   EXSR      FMEURT
     C                   EVAL      WUSSSR = SprtFrDEU
     C                   EVAL      WUSMDI = MdinFrDEU
     C                   ELSE
     C                   EVAL      WUSSSR = AVSPRT
     C                   EVAL      WUSMDI = AVMDIN
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMEURT - FORMATING SPECIFIC TO EURO RATE
      *****************************************************************
     C     FMEURT        BEGSR
     C     *LIKE         DEFINE    AVSPRT        SprtFrDEU
     C     *LIKE         DEFINE    AVCYCD        PrvCycd
     C     *LIKE         DEFINE    AVSPRT        PrvSprt
     C     *LIKE         DEFINE    AVMDIN        PrvMdin
     C     *LIKE         DEFINE    AVINER        PrvIner
     C     *LIKE         DEFINE    AVINMD        PrvInmd
     C     *LIKE         DEFINE    AVDLCI        PrvDlci
     C     *LIKE         DEFINE    AVSWCY        PrvSwcy
     C     *LIKE         DEFINE    AVMDIN        MdinFrDEU
     C     *LIKE         DEFINE    AVMDIN        #SMDI2
     C     *LIKE         DEFINE    DLSW          DLSW2
     C     *LIKE         DEFINE    DLSW          DDDLSW
     C     *LIKE         DEFINE    DLSW          DDDSW2

     C                   CALLB     'SDSPTRDEU'                          90
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM      AVCYCD        PrvCycd
     C                   PARM      AVMDIN        PrvMdin
     C                   PARM      AVSPRT        PrvSprt
     C                   PARM      AVINER        PrvIner
     C                   PARM      AVINMD        PrvInmd
     C                   PARM      AVDLCI        PrvDlci
     C                   PARM      AVSWCY        PrvSwcy
     C                   PARM      *BLANK        SprtFrDEUA       14
     C                   PARM      *BLANK        DLSW              6
     C                   PARM      *BLANK        MdinFrDEU
     C                   PARM      *BLANK        #SPRA2           14
     C                   PARM      *BLANK        DLSW2
     C                   PARM      *BLANK        #SMDI2

     C                   IF        RetCodeIn <> *BLANK OR *IN90
     C                   MOVEL     'SDSPTRDEU'   DBFILE
     C                   MOVEL     '908'         DBASE
     C                   MOVEL     PrvCycd       DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM      SprtFrDEUA    ZFIELD           16
     C                   PARM      8             ZADEC             1 0
     C                   PARM      5             ZADIG             2 0
     C                   IF        ZALIGNok = 'N'
     C                   MOVEL     'ZALIGN'      DBFILE
     C                   MOVEL     '909'         DBASE
     C                   MOVEL     '*CALL'       DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVE      ZFIELD        SprtFrDEU

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
     C                   MOVEL     'SDSPTRUPD'   DBPGM            10
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP

      **  TERMINATE THE PROGRAM

     C                   RETURN

     C                   ENDSR
      ****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
