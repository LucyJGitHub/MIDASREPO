     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Nostro Codes - Update Module')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDNOSRUPD - Nostro Code Details                              *
      *              database update                                  *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL094             Date 30May14               *
      *                 AR1095725          Date 15Mar13               *
      *       Amend No. AR920354           Date 09Nov12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *  AR1095725- Program fails due to missing SD0152 object.       *
      *             SD0152 is being renamed to SD000152 by AR571693.  *
      *  AR920354 - Nostro attached to Midas transactions can be      *
      *             deleted causing components to fail.               *
      *             Check nostro before deletion against MM, FX, LE   *
      *             and SE transactions. Also against RSACMTPD.       *
      *             Patterned after AR571693. (Child: AR920483)       *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
 
     FSDNOSTL0  UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
      * Midas SD Nostro Code Details Master File
 
     FSDFCTLL0  UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
      * Midas SD Standing Data Controls index
 
     FRSACMTL8  IF   E           K DISK                                                     AR920354
      *                                                                                     AR920354
      ** GL Acc Movts by cust/ccy/acct code/acct seq/branch                                 AR920354
      ** (full a/c)                                                                         AR920354
      *                                                                                     AR920354
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
 
     D ChkNosrFmt    E DS                  EXTNAME(SDNOSTPD)
     D                                     PREFIX(CH)
      ** Rename fields for Timestamp checking
 
     D SDVNosr       E DS                  EXTNAME(SDVNOSRPD)
     D                                     PREFIX(A_)
      ** Intermediary bank fields                                                             CDL094
     D   DBIntermeds         210    347                                                       CDL094
     D   IntBanks                    46    Dim(3)                                             CDL094
     D                                     Overlay(DBIntermeds)                               CDL094
      ** Externally desc'd DS for valid transactions Detail
 
     D OKNosDets     E DS                  EXTNAME(SDENOSRPD)
      * Error indicators
 
     D B_NOSRF       E DS                  EXTNAME(SDNOSTPD)
     D                                     PREFIX(B_)
      **  Externally described DS for 'BEFORE UPDATE' xxxxxxxxxx
 
      **  Transaction Details File
     D NOSRF         E DS                  EXTNAME(SDNOSTPD)
 
      * Data Structures for use with access programs
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * Data structure for bank details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for access programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for access programs, long data structure
 
      ** Midas API Message Header Format Definition
     D APHEAD        E DS                  EXTNAME(APHEADPD)
      * Data Structure for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
                                                                                              CDL094
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CDL094
      **  External Data structure for customer details.                                       CDL094
      **
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
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
      ** Fields defined for Enhancement CDL008
 
     D CDL008          S              1A
     D CSD012          S              1A
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
                                                                                              CDL094
      * CDL094 Work Fields                                                                    CDL094
                                                                                              CDL094
     D CDL094          S               N                                                      CDL094
     D CustInpType     S                   Like(@RtCd)                                        CDL094
     D IdIn            S             18    Inz                                                CDL094
     D Key10           S             10    Inz                                                CDL094
     D x               S              3U 0                                                    CDL094
 
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
     C     A_NVTYLC      CASEQ     'I'           INSERT
     C     A_NVTYLC      CASEQ     'A'           AMEND
     C     A_NVTYLC      CASEQ     'D'           DELETE
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
 
      ** Externally described DS for valid Nostro Codes Detail
     C                   PARM                    SDVNOSR
      *                                                                                     AR920354
      ** Return the ref. no that uses the Nostro account                                    AR920354
      *                                                                                     AR920354
     C                   PARM                    @@MSGD           45                        AR920354
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
     C                   EVAL      DBASE  =  909                                * DBERR 909 *
     C                   EXSR      *PSSR                                        *************
     C                   ENDIF
 
      ** Check if CDL008 is Switched On
     C                   EVAL      CDL008 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CDL008'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        (PRtCd <> *BLANKS) and
     C                             (PRtCd <> '*NRF   ')
     C                   EVAL      DBKEY = 'CDL008'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 900
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CDL008 = 'Y'
     C                   ENDIF
      *                                                                                       CDL094
      ** Check if switchable feature CDL094 is switched on.                                   CDL094
     C                   CALLB     'AOSARDR0'                                                 CDL094
     C                   PARM      *BLANKS       @RTCD                                        CDL094
     C                   PARM      '*VERIFY'     @OPTN                                        CDL094
     C                   PARM      'CDL094'      @SARD                                        CDL094
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL094
      *                                                                                       CDL094
      ** Database Error                                                                       CDL094
     C                   IF        @RTCD <> *BLANKS AND                                       CDL094
     C                             @RTCD <> '*NRF   '                                         CDL094
     C                   EVAL      DBKEY  = 'CDL094'                                          CDL094
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL094
     C                   EVAL      DBASE  = 907                                               CDL094
     C                   EXSR      *PSSR                                                      CDL094
     C                   ENDIF                                                                CDL094
                                                                                              CDL094
     C                   IF        @RTCD = *BLANK                                             CDL094
     C                   EVAL      CDL094 = *ON                                               CDL094
     C                   ELSE                                                                 CDL094
     C                   EVAL      CDL094 = *OFF                                              CDL094
     C                   ENDIF                                                                CDL094
      *
      ** Key to Access Nostro Details
     C     KLCRSL        KLIST
     C                   KFLD                    A_NVCYCD
     C                   KFLD                    A_NVNONB
 
 
      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @Return           6
     C                   PARM                    @Type             1
      *
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CHKOTHUPD - Check for update by another workstation           *
      *                                                               *
      *****************************************************************
     C     CHKOTHUPD     BEGSR
 
      ** Retrieve current Nostro Code details
     C                   MOVE      A_NVCYCD      MidasCYCD         3
     C                   MOVE      A_NVNONB      MidasNONB         2
 
     C                   CALLB     'SDNOSRRTV'
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
     C                   PARM      A_NVTYLC      ACTN              1
      *
      * Front Office Transaction ID
     C                   PARM      A_NVFRNT      FOTRID           20
      *
      * Currency code
     C                   PARM                    MidasCYCD         3
      * Nostro Code
     C                   PARM                    MidasNONB         2
      *
      * Outputs
      *
      * Transaction Details in File Format
     C                   PARM                    ChkNosrFmt
      *
      * OK - Action code
     C                   PARM      *BLANK        DDACTNOK          1
      *
      * OK - Nostro Currency Code
     C                   PARM                    DDCYCDOK          1
      * OK - Nostro Number
     C                   PARM                    DDNONBOK          1
 
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
 
     C                   IF        CHA7TMST <> A_NVTMST
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   ENDIF
 
      ** Batch mode:
     C                   ELSE
     C                   IF        DDACTNOK = 'N' OR
     C                             DDCYCDOK = 'N' OR
     C                             DDNONBOK = 'N'
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
 
      ** Access Nostro Details
     C     KLCRSL        CHAIN     SDNOSTL0                           99
      ** Database error
     C                   IF        *IN99 = *OFF
     C                   EVAL      DBKEY  = A_NVNONB
     C                   EVAL      DBFILE = 'SDNOSTPD'
     C                   EVAL      DBASE  = 901
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialise Nostro Code Detail
     C                   CLEAR                   NOSRF
 
      ** Store Old fields for comparisons
     C                   MOVEL(P)  NOSRF         B_NOSRF
 
      ** SET Nostro Code Detail FIELDS ON INSERT
 
     C                   EVAL      A7CYCD = A_NVCYCD
     C                   EVAL      A7NONB = A_NVNONB
     C                   EVAL      A7ACCD = A_NVACCD
     C                   EVAL      A7LCD  = BJRDNB
     C                   EVAL      A7TYLC = 'I'
     C                   EVAL      A7CUST = A_NVCUST
     C                   EVAL      A7ACSN = A_NVACSN
     C                   EVAL      A7NOSN = A_NVNOSN
     C                   EVAL      A7OACN = A_NVOACN
     C                   EVAL      A7ORAC = A_NVORAC
     C                   EVAL      A7PNOI = A_NVPNOI
     C                   EVAL      A7BRCD = A_NVBRCD
     C                   EVAL      A7OGID = *Blanks
      ** Move additional fields id CDL008 is switched on
     C                   IF        CDL008 = 'Y'
     C                   EVAL      A7CLSD = A_NVCLSD
     C                   EVAL      A7LPR  = A_NVLPR
     C                   EVAL      A7MPGT = A_NVMPGT
     C                   EVAL      A7PMLT = A_NVPMLT
     C                   EVAL      A7BL3C = A_NVBL3C
     C                   EVAL      A7CLSM = A_NVCLSM
     C                   EVAL      A7CLSC = A_NVCLSC
     C                   EVAL      A7ASID = A_NVASID
     C                   ENDIF
 
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
     C                   EVAL      A7TMST  = TimeStamp
      *                                                                                       CDL094
      ** Move Intermediary banks fields if CDL094 is ON                                       CDL094
     C                   If        CDL094                                                     CDL094
     C                   Exsr      SetCustFld                                                 CDL094
     C                   Eval      %Subst(NOSRF:210:138) =                                    CDL094
     C                                %Subst(SDVNosr:210:138)                                 CDL094
     C                   Endif                                                                CDL094
      *
      ** Write new Transaction Detail
     C                   WRITE     @A7REBE
 
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
 
      ** Access Nostro Details                                     HILO
     C     KLCRSL        CHAIN     SDNOSTL0                           9998
      ** Database error (Record Not Found)
     C                   IF        *IN99 = *ON
     C                   EVAL      DBKEY  = A_NVNONB
     C                   EVAL      DBFILE = 'SDNOSTPD'
     C                   EVAL      DBASE  = 901
     C                   EXSR      *PSSR
     C                   ENDIF
      ** Database error (Record Locked)
     C                   IF        *IN98 = *ON
     C                   EVAL      DBKEY  = A_NVNONB
     C                   EVAL      DBFILE = 'SDNOSTPD'
     C                   EVAL      DBASE  = 902
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Update 'BEFORE' status
     C                   MOVEL(P)  NOSRF         B_NOSRF
 
      ** SET Nostro Detail FIELDS ON AMEND
 
     C                   EVAL      A7CYCD = A_NVCYCD
     C                   EVAL      A7NONB = A_NVNONB
     C                   EVAL      A7ACCD = A_NVACCD
     C                   EVAL      A7LCD  = BJRDNB
     C                   EVAL      A7TYLC = 'A'
     C                   EVAL      A7CUST = A_NVCUST
     C                   EVAL      A7ACSN = A_NVACSN
     C                   EVAL      A7NOSN = A_NVNOSN
     C                   EVAL      A7OACN = A_NVOACN
     C                   EVAL      A7ORAC = A_NVORAC
     C                   EVAL      A7PNOI = A_NVPNOI
     C                   EVAL      A7BRCD = A_NVBRCD
     C                   EVAL      A7OGID = *Blanks
      ** Move additional fields id CDL008 is switched on
     C                   IF        CDL008 = 'Y'
     C                   EVAL      A7CLSD = A_NVCLSD
     C                   EVAL      A7LPR  = A_NVLPR
     C                   EVAL      A7MPGT = A_NVMPGT
     C                   EVAL      A7PMLT = A_NVPMLT
     C                   EVAL      A7BL3C = A_NVBL3C
     C                   EVAL      A7CLSM = A_NVCLSM
     C                   EVAL      A7CLSC = A_NVCLSC
     C                   EVAL      A7ASID = A_NVASID
     C                   ENDIF
 
 
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
     C                   EVAL      A7TMST  = TimeStamp
      *                                                                                       CDL094
      ** Move Intermediary banks fields if CDL094 is ON                                       CDL094
     C                   If        CDL094                                                     CDL094
     C                   Exsr      SetCustFld                                                 CDL094
     C                   Eval      %Subst(NOSRF:210:138) =                                    CDL094
     C                                %Subst(SDVNosr:210:138)                                 CDL094
     C                   EndIf                                                                CDL094
 
 
      *
      ** Update Nostro Code Record
     C                   UPDATE    @A7REBE
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
 
      ** Access Nostro Code Details
     C     KLCRSL        CHAIN     SDNOSTL0                           99
      ** Database error
     C                   IF        *IN99 = *ON
     C                   EVAL      DBKEY  = A_NVNONB
     C                   EVAL      DBFILE = 'SDNOSTPD'
     C                   EVAL      DBASE  = 902
     C                   EXSR      *PSSR
     C                   ENDIF
 
      *                                                                                     AR920354
      ** Check if Nostro is used by LIVE transactions                                       AR920354
      *                                                                                     AR920354
     C                   MOVEL     A7ACSN        ##ACSN            2                        AR920354
     C**********         CALL      'SD0152'                                       AR920354 AR1095725
     C                   CALL      'SD000152'                                              AR1095725
     C                   PARM                    A7BRCD                                     AR920354
     C                   PARM                    A7CUST                                     AR920354
     C                   PARM                    A7CYCD                                     AR920354
     C                   PARM                    A7ACCD                                     AR920354
     C                   PARM                    ##ACSN                                     AR920354
     C                   PARM                    A7NONB                                     AR920354
     C                   PARM      *BLANKS       RETURN            1                        AR920354
     C                   PARM      *BLANKS       WMSGD            45                        AR920354
      *                                                                                     AR920354
      ** If Nostro is used for Receipt                                                      AR920354
      *                                                                                     AR920354
     C                   IF        RETURN = 'R'                                             AR920354
     C                   EVAL      @@RTCD = 'R'                                             AR920354
     C                   EVAL      @@MSGD = WMSGD                                           AR920354
     C                   GOTO      DELEXIT                                                  AR920354
     C                   ENDIF                                                              AR920354
      *                                                                                     AR920354
      ** If Nostro is used for Payment                                                      AR920354
      *                                                                                     AR920354
     C                   IF        RETURN = 'P'                                             AR920354
     C                   EVAL      @@RTCD = 'P'                                             AR920354
     C                   EVAL      @@MSGD = WMSGD                                           AR920354
     C                   GOTO      DELEXIT                                                  AR920354
     C                   ENDIF                                                              AR920354
      *                                                                                     AR920354
      ** Check if there are existing records in LF/RSACMTL8.                                AR920354
      ** If yes, do not allow deletion of Nostro Account.                                   AR920354
      *                                                                                     AR920354
     C                   MOVEL     A7CUST        @WCUST            6                        AR920354
     C                   MOVEL     A7ACCD        @WCODE           10 0                      AR920354
      *                                                                                     AR920354
     C     @KRSAC        KLIST                                                              AR920354
     C                   KFLD                    A7BRCD                                     AR920354
     C                   KFLD                    @WCUST                                     AR920354
     C                   KFLD                    A7CYCD                                     AR920354
     C                   KFLD                    @WCODE                                     AR920354
     C                   KFLD                    A7ACSN                                     AR920354
      *                                                                                     AR920354
     C     @KRSAC        CHAIN     RSACMTL8                           41                    AR920354
      *                                                                                     AR920354
      ** If record found, display error message.                                            AR920354
      *                                                                                     AR920354
     C     *IN41         IFEQ      '0'                                                      AR920354
      *                                                                                     AR920354
      ** 'Nostro cannot be deleted.' (1st level).                                           AR920354
      ** 'A full check could not be done. However, there are existing                       AR920354
      ** movement/s for this nostro account. Please refer to Projected                      AR920354
      ** Account Movements enquiry for the affected transactions.'                          AR920354
      *                                                                                     AR920354
     C                   EVAL      @@RTCD = 'Y'                                             AR920354
     C                   GOTO      DELEXIT                                                  AR920354
     C                   ENDIF                                                              AR920354
      *                                                                                     AR920354
      ** Update 'BEFORE' status
     C                   MOVEL(P)  NOSRF         B_NOSRF
 
      ** Delete record
     C                   DELETE    @A7REBE
      * WRITE DELETED RECORD IN STANDING DATA DELETED FILE
     C                   EXSR      WRTDLRC
     C                   EVAL      A7TYLC = 'D'
      * INSERT A RECORD IN THE TABLE TABLETH
     C                   EXSR      UPDTABL
      * UPDATE SD STANDING DATA CONTROL FILE
     C                   EXSR      UPDCTRL
 
     C**********         ENDSR                                                              AR920354
     C     DELEXIT       ENDSR                                                              AR920354
      ****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* UPDTABL - UPDATE TABLE TABLETH                               *
     C*                                                              *
     C****************************************************************
     C     UPDTABL       BEGSR
      *
      * TABLETL - Nostro Codes  *
     C                   CALL      'TABLETL'                            90
     C                   PARM      *BLANKS       WQ0001            7
     C                   PARM      A7CYCD        WQ0002            3
     C                   PARM      A7NONB        WQ0003            4
     C                   PARM      A7ACCD        WQ0004           10
     C                   PARM      A7CUST        WQ0005            6
     C                   PARM      A7ACSN        WQ0006            2 0
     C                   PARM      A7NOSN        WQ0007           10
     C                   PARM      A7OACN        WQ0008           35
     C                   PARM      A7ORAC        WQ0009           25
     C                   PARM      A7PNOI        WQ0010            1
     C                   PARM      A7BRCD        WQ0011            3
     C                   PARM      A7TYLC        WQ0012            1
     C                   PARM      BJRDNB        WQ0013            5 0
 
     C     *IN90         IFEQ      *ON
     C                   MOVEL     A7NONB        DBKEY
     C                   MOVEL     'TABLETL'     DBFILE
     C                   MOVEL     903           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C     WQ0001        IFNE      *BLANKS
     C                   MOVEL     '*ERTBTK'     ReturnCode
     C                   MOVEL     A7CYCD        DBKEY
     C                   MOVEL     'TABLETL'     DBFILE
     C                   MOVEL     004           DBASE
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
     C                   MOVEL     'SDNOSTPD'    WKFLNM
     C     WKFLNM        CHAIN     @AHREAU                            9899
      *
      * Record not found
     C     *IN98         IFEQ      '1'
     C                   MOVEL     'SDNOSTPD'    DBKEY
     C                   MOVEL     'SDFCTLL0'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      * Record locked
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'SDNOSTPD'    DBKEY
     C                   MOVEL     'SDFCTLL0'    DBFILE
     C                   MOVEL     '905'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
     C                   SELECT
      * Input
     C     A_NVTYLC      WHENEQ    'I'
     C                   EVAL      AHNORC = (AHNORC + 1)
     C                   EVAL      AHNOIN = (AHNOIN + 1)
      *
      * Amend
     C     A_NVTYLC      WHENEQ    'A'
     C                   EVAL      AHNOAM = (AHNOAM + 1)
      *
      * Delete
     C     A_NVTYLC      WHENEQ    'D'
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
     C                   MOVEL     SDVNosr       WUDELR
     C                   MOVEL     *BLANKS       WULKEY           50
     C     A_NVCYCD      CAT       A_NVNONB      WULKEY
      * Write Deleted Record - SD Deleted Records File  *
     C                   CLEAR                   PBRC
     C                   MOVEL     'SDNOSTPD'    PBFNME
     C                   MOVEL     WULKEY        PBLKEY
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
     C                   Z-ADD     BJRDNB        PBLCD
     C                   MOVEL     'D'           PBTYLC
      *
     C                   CALL      'SD0520X'                            90
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PBRC
      *
     C     *IN90         IFEQ      '1'
     C     W0RTN         ORNE      *BLANK
     C                   MOVEL     A_NVNONB      DBKEY
     C                   MOVEL     'SD0520X'     DBFILE
     C                   MOVEL     906           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
     C****************************************************************
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
      /EJECT                                                                                  CDL094
     C****************************************************************                        CDL094
     C*                                                              *                        CDL094
     C* SetCustFld - Ensure Intermediary parties are entered         *                        CDL094
     C*              as either BIC or Customer Number only           *                        CDL094
     C*              (If shortname, extract Customer Number first    *                        CDL094
     C*              before updating)                                *                        CDL094
     C*                                                              *                        CDL094
     C****************************************************************                        CDL094
     C     SetCustFld    BEGSR                                                                CDL094
                                                                                              CDL094
     C                   Eval      x = 1                                                      CDL094
     C                   For       x = 1 to 3                                                 CDL094
                                                                                              CDL094
      ** Retrieve Customer Number in case Customer Shortname entered                          CDL094
     C                   Eval      Key10  = %Subst(IntBanks(x):1:10)                          CDL094
                                                                                              CDL094
     C                   CallB     'AOCUSTR0'                                                 CDL094
     C                   Parm      *Blanks       @Rtcd                                        CDL094
     C                   Parm      '*KEY   '     @Optn                                        CDL094
     C                   Parm                    Key10                                        CDL094
     C                   Parm      *Blanks       CustInpType                                  CDL094
     C     SDCUST        PARM      *BLANKS       DSSDY                                        CDL094
                                                                                              CDL094
     C                   IF        @Rtcd = *Blanks                                            CDL094
     C                   Eval      %Subst(IntBanks(x):1:11)                                   CDL094
     C                               = BBCUST                                                 CDL094
     C                   EndIf                                                                CDL094
                                                                                              CDL094
     C                   EndFor                                                               CDL094
                                                                                              CDL094
     C                   ENDSR                                                                CDL094
**  CPY@
(c) Finastra International Limited 2006
