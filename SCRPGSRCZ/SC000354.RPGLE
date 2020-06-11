     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Switch from NIGHT to DAY mode')               *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC000354 - Midas SC Switch from NIGHT to DAY Mode            *
      *                                                               *
      *  Function:  This program will read from API24X7SPD from 24x7  *
      *             layer and send details to MQ Queue                *
      *                                                               *
      *  Called By: CLLE/SCC000354 - Midas SC Switch from NIGHT to DAY*
      *               mode                                            *
      *                                                               *
      *  (C) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. CAP735             Date 12May20               *
      *  Prev Amend No. CAP734             Date 12May20               *
      *                 CAP702  *CREATE    Date 12May20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP735 - 24x7 APIs - GL Accounts API                         *
      *  CAP734 - 24x7 APIs - SD Customer details API                 *
      *  CAP702 - 24x7 APIs - Common Processing                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      **
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     F****API24X7SL1UF   E           K DISK    INFSR(*PSSR)
     FAPI24X7SL2UF   E           K DISK    INFSR(*PSSR)
      ** Midas AP Queued Data file
      *
      *
     *****************************************************************
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      ** True       logical = *ON (for indcator processing)
      ** False      logical = *OFF (for indcator processing)
      ** DBErrCtl   10A = 'DBERRCTL' (the name of the database error
      ** handler)
      ** and the following variables:
      ** RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** The following /COPY line includes the definitions for error &
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D                 DS
     D PGlobal                 1      2
     D PZonal                 18     19
     D PWipQueue               1     48

     D                 DS
     D  WPGM                          8
     D  WBJRDNB                       5
     D  WPDCLTS                       7S 0
     D  WPDCLSEQ               1     20

     D                 DS                                                       CAP734
     D  PCUSDAL                1  32000                                         CAP734
     D  PCUSDHD                1    215                                         CAP734
     D  PCUSDDT              216  32000                                         CAP734

     D                 DS                                                       CAP735
     D  PAMADAL                1  32000                                         CAP735
     D  PAMADHD                1    107                                         CAP735
     D  PAMADDT              108  32000                                         CAP735

     D                 DS
     D Msg                     1  32000    DIM(32000)

     D PRtnCode        S              7A
     D PAction         S              1A
     D PValidList      S             10A
     D PLibrary        S             10A
     D PUserName       S            100A
     D PPassword1      S            600A
     D PPassword2      S            600A
     D PDescrptn       S           1000A

     D SysPrefix       S              2A

     D P@OP01          S             20A
     D P@VL01          S            200A
     D P@OP02          S             20A
     D P@VL02          S            200A
     D P@OP03          S             20A
     D P@VL03          S            200A
     D P@OP04          S             20A
     D P@VL04          S            200A
     D P@OP05          S             20A
     D P@VL05          S            200A
     D P@OP06          S             20A
     D P@VL06          S            200A
     D P@OP07          S             20A
     D P@VL07          S            200A
     D P@OP08          S             20A
     D P@VL08          S            200A
     D P@OP09          S             20A
     D P@VL09          S            200A
     D P@OP10          S             20A
     D P@VL10          S            200A

     D PErrMsg         S             30A
     D PRequest        S             10A
     D PQueueNm        S             48A
     D PMQMgr          S             48A
     D PMsgBuf         S          32000A
     D WkRespQ         S             20A
     D WkMQMgr         S             48A
     D WkUser          S             10A
     D P@Key           S              4A
     D PMode           S             10A
     D PAPIName        S            100A
     D Pformat         S            100A
     D PfldTag         S             10A
     D PfldData        S           1000A
     D PfldType        S             10A
     D PfldAttr        S             10A
     D P24X7LCK        S              3A

      ** Variables for setup message
     D MQTGTT          S             32A
     D MQTGTS          S              8A
     D MQSRCS          S              8A

     D ValidList       C                   CONST('GPLDAPVL')

     D PSysVal1        C                   CONST('24x7NoRecordsforLock')
     D PSysVal2        C                   CONST('MQTransSdrQuCOB24x7')
     D PSysVal3        C                   CONST('MQJMSRespQuCOB24x7')
     D PSysVal4        C                   CONST('MQQueueMgrCOB24x7')
     D PSysVal5        C                   CONST('MQUserIDCOB24x7')
     D PSysVal6        C                   CONST('GlobalSystemPrefix')

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)

      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      ** Process transactions
      *
     C     *ENTRY        PLIST
     C                   PARM                    PNBRCD           10 0
     C                   PARM                    PNBRCDI           4 0
     C                   PARM                    PNBRCDP           4 0
     C                   PARM                    PNBRCDR           4 0
     C                   PARM                    PNBRFLG           1
     C                   PARM                    PALLPRC           1
      *
      ** Retrieve System values details
     C                   EXSR      ChkSysValue
      *
      ** Check for switchable feature CAP734                                    CAP734
     C                   Call      'AOSARDR0'                                   CAP734
     C                   Parm      *Blanks       @RTCD             7            CAP734
     C                   Parm      '*VERIFY'     @OPTN             7            CAP734
     C                   Parm      'CAP734'      @SARD             6            CAP734
     C     SCSARD        Parm      SCSARD        DSFDY                          CAP734
                                                                                CAP734
     C                   If        @RTCD = *Blanks                              CAP734
     C                   Movel     'Y'           CAP734            1            CAP734
     C                   Else                                                   CAP734
     C                   Movel     'N'           CAP734                         CAP734
     C                   EndIf                                                  CAP734
      *
      ** Check for switchable feature CAP735                                    CAP735
     C                   Call      'AOSARDR0'                                   CAP735
     C                   Parm      *Blanks       @RTCD             7            CAP735
     C                   Parm      '*VERIFY'     @OPTN             7            CAP735
     C                   Parm      'CAP735'      @SARD             6            CAP735
     C     SCSARD        Parm      SCSARD        DSFDY                          CAP735
                                                                                CAP735
     C                   If        @RTCD = *Blanks                              CAP735
     C                   Movel     'Y'           CAP735            1            CAP735
     C                   Else                                                   CAP735
     C                   Movel     'N'           CAP735                         CAP735
     C                   EndIf                                                  CAP735
      *
      ** Process records
     C                   EXSR      PROCES
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      * ChkSysValue - Check for system values                         *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     ChkSysValue   BEGSR
      *
      ** Check for system values
     C                   EVAL      @RTCD = *BLANKS
     C                   EVAL      P@OP01 = PSysVal1
     C                   EVAL      P@OP02 = PSysVal2
     C                   EVAL      P@OP03 = PSysVal3
     C                   EVAL      P@OP04 = PSysVal4
     C                   EVAL      P@OP05 = PSysVal5
     C                   EVAL      P@OP06 = PSysVal6
      *
     C                   CALL      'AOSVALR0'
     C                   PARM                    @RTCD             7
     C                   PARM                    P@OP01
     C                   PARM      *BLANKS       P@VL01
     C                   PARM                    P@OP02
     C                   PARM      *BLANKS       P@VL02
     C                   PARM                    P@OP03
     C                   PARM      *BLANKS       P@VL03
     C                   PARM                    P@OP04
     C                   PARM      *BLANKS       P@VL04
     C                   PARM                    P@OP05
     C                   PARM      *BLANKS       P@VL05
     C                   PARM                    P@OP06
     C                   PARM      *BLANKS       P@VL06
     C                   PARM      *BLANKS       P@OP07
     C                   PARM      *BLANKS       P@VL07
     C                   PARM      *BLANKS       P@OP08
     C                   PARM      *BLANKS       P@VL08
     C                   PARM      *BLANKS       P@OP09
     C                   PARM      *BLANKS       P@VL09
     C                   PARM      *BLANKS       P@OP10
     C                   PARM      *BLANKS       P@VL10

      ** Setup work fields
      * Set P24x7LCK  = PVL01
      * Set PWIPQueue = PVL02
      * Set WkRespQ   = PVL03
      * Set WkMQMgr   = PVL04
      * Set WkUser    = %TRIM(PVL05)
      *
     C                   MOVE      *BLANKS       P24X7LCK
     C                   EVAL      PWipQueue = *BLANKS
     C                   EVAL      WkRespQ = *BLANKS
     C                   EVAL      WkMQMgr = *BLANKS
     C                   EVAL      WkUser = *BLANKS
      *
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      P24X7LCK = P@VL01
     C                   MOVE      P24X7LCK      W24X7LCK          3 0
     C                   EVAL      PWipQueue = P@VL02
     C                   EVAL      WkRespQ = P@VL03
     C                   EVAL      WkMQMgr = P@VL04
     C                   EVAL      WkUser = %TRIM(P@VL05)
     C                   EVAL      SysPrefix = P@VL06
     C                   ENDIF
      *
      * Retrieve username and password
     C                   EVAL      PValidList = ValidList
     C                   EVAL      PLibrary = SysPrefix + 'GMLIB'
     C                   EXSR      GetPassWord
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * GetPassWord - Get password in Validation List                 *
      *                                                               *
      * Called by: ChkSysValue                                        *
      *                                                               *
      * Calls: UT000033                                               *
      *                                                               *
      *****************************************************************
      *
     C     GetPassWord   BEGSR
      *
     C                   CALL      'UT000033'
     C                   PARM      '*BLANKS'     PRtnCode
     C                   PARM      'F'           PAction
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
     C                   PARM      WkUser        PUserName
     C                   PARM      *BLANKS       PPassword1
     C                   PARM      *BLANKS       PPassword2
     C                   PARM      *BLANKS       PDescrptn
      *
     C                   IF        PRtnCode <> *BLANKS
     C                   EVAL      WRETCD = '*ERROR'
     C                   EVAL      DBKEY  = WkUser
     C                   EVAL      DBFILE = 'GPLDAPVL'
     C                   EVAL      DBASE = 018
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      * PROCES - Process Transactions details                         *
      *                                                               *
      *****************************************************************
      *
     C     PROCES        BEGSR
      *
      ** Initialise work fields for counters
      ** NBRCD = Number of records on file (coming from CLLE/SCC000354)
      ** NBRCDI = number of records processed intermediary
      ** NBRCDP = number of records processed
      ** NBRCDR = number of records remaining
      *
     C                   Z-Add     0             PNBRCDI
     C                   Z-Add     0             PNBRCDP
     C                   Z-Add     0             PNBRCDR
      *
      ***** Read API24X7SL1
      ** Read API24X7SL2
     C**** *LOVAL        SETLL     API24X7SL1
     C****               READ      API24X7SL1                             70
     C     *LOVAL        SETLL     API24X7SL2
     C                   READ      API24X7SL2                             70
     C     *IN70         DOWEQ     *OFF
      *
      ** Count records read (NBRCDP)
     C                   Add       1             PNBRCDP
      *
      ** Count records read Intermediary (NBRCDI)
     C                   Add       1             PNBRCDI
      *
      ** If Customer being processed                                            CAP734
      *                                                                         CAP734
     C     APMAPI        IFEQ      '1CUSD'                                      CAP734
     C     CAP734        ANDEQ     'Y'                                          CAP734
     C     APSTAT        ANDEQ     ' '                                          CAP734
      *                                                                         CAP734
      ** Customer details                                                       CAP734
     C                   EXSR      callCUSD                                     CAP734
      *                                                                         CAP734
      ** Send message to MQ series queue                                        CAP734
     C                   EVAL      PRequest = '*OPEN_PUT'                       CAP734
     C                   EXSR      SRPutMQIO                                    CAP734
      *                                                                         CAP734
     C                   EVAL      PRequest = '*PUT'                            CAP734
     C                   EXSR      SRPutMQIO                                    CAP734
      *                                                                         CAP734
     C                   EVAL      PRequest = '*CLOSE'                          CAP734
     C                   EXSR      SRPutMQIO                                    CAP734
      *                                                                         CAP734
     C                   ENDIF                                                  CAP734
      *
      ** If Account being processed                                             CAP735
      *                                                                         CAP735
     C     APMAPI        IFEQ      '2AMAD'                                      CAP735
     C     CAP735        ANDEQ     'Y'                                          CAP735
     C     APSTAT        ANDEQ     ' '                                          CAP734
      *                                                                         CAP735
      ** Account details                                                        CAP735
     C                   EXSR      callAMAD                                     CAP735
      *                                                                         CAP735
      ** Send message to MQ series queue                                        CAP735
     C                   EVAL      PRequest = '*OPEN_PUT'                       CAP735
     C                   EXSR      SRPutMQIO                                    CAP735
      *                                                                         CAP735
     C                   EVAL      PRequest = '*PUT'                            CAP735
     C                   EXSR      SRPutMQIO                                    CAP735
      *                                                                         CAP735
     C                   EVAL      PRequest = '*CLOSE'                          CAP735
     C                   EXSR      SRPutMQIO                                    CAP735
      *                                                                         CAP735
     C                   ENDIF                                                  CAP735
      *
      ** Check number of records processed and remaining
     C     PNBRCDI       IFEQ      20
     C     PNBRCD        SUB       PNBRCDP       PNBRCDR
     C     PNBRCDR       IFLT      W24X7LCK
     C                   EVAL      PNBRFLG = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
     C     PNBRCDP       IFEQ      PNBRCD
     C                   EVAL      PALLPRC = 'Y'
     C                   ENDIF
      *
     C     PALLPRC       IFEQ      'Y'
     C                   MOVE      *ON           *IN70
     C                   LEAVE
     C                   ELSE
      *
     C*****************  READ      API24X7SL1                             70
     C                   READ      API24X7SL2                             70
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************         CAP734
      * callCUSD - Setup Message for Customer                         *         CAP734
      *                                                               *         CAP734
      *****************************************************************         CAP734
      *                                                                         CAP734
     C     callCUSD      BEGSR                                                  CAP734
      *                                                                         CAP734
     C                   EVAL      PMode    = '*CLEAR'                          CAP734
     C                   EXSR      SRFmtWMsg                                    CAP734
      *                                                                         CAP734
     C                   EVAL      PMode    = '*ENTER'                          CAP734
     C                   EVAL      PAPIName = 'WRITE!MIDAS.CUSD'                CAP734
     C                   EVAL      PFormat  = 'CUSD'                            CAP734
      *                                                                         CAP734
     C                   EVAL      PFldTag  = 'APTGTTYPE'                       CAP734
     C                   EVAL      MQTGTT = 'CUSD'                              CAP734
     C                   EVAL      PFldData = 'CUSD'                            CAP734
     C                   EVAL      PFldType = *BLANK                            CAP734
     C                   EVAL      PFldAttr = *BLANK                            CAP734
     C                   EXSR      SRFmtWMsg                                    CAP734
      *                                                                         CAP734
     C                   EVAL      PFldTag  = 'APTGTSYS'                        CAP734
     C                   EVAL      PFldData = 'MIDAS'                           CAP734
     C                   EVAL      PFldType = *BLANK                            CAP734
     C                   EVAL      PFldAttr = *BLANK                            CAP734
     C                   EVAL      MQTGTS = 'MIDAS'                             CAP734
     C                   EXSR      SRFmtWMsg                                    CAP734
      *                                                                         CAP734
     C                   EVAL      PFldTag  = 'APSRCSYS'                        CAP734
     C                   EVAL      PFldData = 'MIDASCOB'                        CAP734
     C                   EVAL      PFldType = *BLANK                            CAP734
     C                   EVAL      PFldAttr = *BLANK                            CAP734
     C                   EVAL      MQSRCS = 'MIDASCOB'                          CAP734
     C                   EXSR      SRFmtWMsg                                    CAP734
      *                                                                         CAP734
     C                   EVAL      PFldTag  = 'APFOTRANID'                      CAP734
     C                   EVAL      PFldData = APFOTR                            CAP734
     C                   EVAL      PFldType = *BLANK                            CAP734
     C                   EVAL      PFldAttr = *BLANK                            CAP734
     C                   EXSR      SRFmtWMsg                                    CAP734
      *                                                                         CAP734
     C                   EVAL      PFldTag  = 'APRPRLOCN'                       CAP734
     C                   EVAL      PFldData = 'B'                               CAP734
     C                   EVAL      PFldType = *BLANK                            CAP734
     C                   EVAL      PFldAttr = *BLANK                            CAP734
     C                   EXSR      SRFmtWMsg                                    CAP734
      *                                                                         CAP734
     C                   EVAL      PFldTag  = 'APRPYQUEUE'                      CAP734
     C                   EVAL      PFldData = WkRespQ                           CAP734
     C                   EVAL      PFldType = *BLANK                            CAP734
     C                   EVAL      PFldAttr = *BLANK                            CAP734
     C                   EXSR      SRFmtWMsg                                    CAP734
      *                                                                         CAP734
     C                   EVAL      PFldTag  = 'APUSERID'                        CAP734
     C                   EVAL      PFldData = WkUser                            CAP734
     C                   EVAL      PFldType = *BLANK                            CAP734
     C                   EVAL      PFldAttr = *BLANK                            CAP734
     C                   EXSR      SRFmtWMsg                                    CAP734
      *                                                                         CAP734
     C                   EVAL      PFldTag  = 'APPASSWORD'                      CAP734
     C                   EVAL      PFldData = PPassword1                        CAP734
     C                   EVAL      PFldType = *BLANK                            CAP734
     C                   EVAL      PFldAttr = *BLANK                            CAP734
     C                   EXSR      SRFmtWMsg                                    CAP734
      *                                                                         CAP734
      ** Front Office ID                                                        CAP734
     C                   EVAL      PFldTag  = 'DDFRNT'                          CAP734
     C                   EVAL      PFldData = WPDCLSeq                          CAP734
     C                   EVAL      PFldType = *BLANK                            CAP734
     C                   EVAL      PFldAttr = *BLANK                            CAP734
     C                   EXSR      SRFmtWMsg                                    CAP734
      *                                                                         CAP734
      ** +--- XML (CUSD details) -----------------------------------------+     CAP734
      **                                                                  *     CAP734
      **   Statement below will facilitate building of CUSD-XML           *     CAP734
      **   transactions to be sent to MQ for processing                   *     CAP734
      **                                                                  *     CAP734
      ** +----------------------------------------------------------------+     CAP734
      *                                                                         CAP734
      ** Action Code                                                            CAP734
     C                   EVAL      PFldTag  = 'DDACTN'                          CAP734
     C                   EVAL      PFldData = 'I'                               CAP734
     C                   EVAL      PFldType = *BLANK                            CAP734
     C                   EVAL      PFldAttr = *BLANK                            CAP734
     C                   EXSR      SRFmtWMsg                                    CAP734
      *                                                                         CAP734
     C                   EVAL      PCUSDAL = APXML                              CAP734
      *                                                                         CAP734
     C                   MOVE      *BLANK        Msg                            CAP734
     C                   Z-ADD     1             X                 5 0          CAP734
     C                   MOVEA     PMSGBUF       Msg(X)                         CAP734
     C     *BLANK        LOOKUP    Msg(X)                                 99    CAP734
     C                   MOVEA     PCUSDDT       Msg(X)                         CAP734
      *                                                                         CAP734
     C                   MOVEA     Msg           PMsgBuf                        CAP734
      *                                                                         CAP734
      ** Set APMQST as ‘S’ in PF/API24X7SPD and update file                     CAP734
      *                  MOVE      'S'           APMQST                         CAP734
     C                   UPDATE    API24X7SD0                                   CAP734
      *                                                                         CAP734
     C                   ENDSR                                                  CAP734
      *                                                                         CAP734
      *****************************************************************         CAP735
      * callAMAD - Setup Message for Account                          *         CAP735
      *                                                               *         CAP735
      *****************************************************************         CAP735
      *                                                                         CAP735
     C     callAMAD      BEGSR                                                  CAP735
      *                                                                         CAP735
     C                   EVAL      PMode    = '*CLEAR'                          CAP735
     C                   EXSR      SRFmtWMsg                                    CAP735
      *                                                                         CAP735
     C                   EVAL      PMode    = '*ENTER'                          CAP735
     C                   EVAL      PAPIName = 'WRITE!MIDAS.AMAD'                CAP735
     C                   EVAL      PFormat  = 'AMAD'                            CAP735
      *                                                                         CAP735
     C                   EVAL      PFldTag  = 'APTGTTYPE'                       CAP735
     C                   EVAL      MQTGTT = 'AMAD'                              CAP735
     C                   EVAL      PFldData = 'AMAD'                            CAP735
     C                   EVAL      PFldType = *BLANK                            CAP735
     C                   EVAL      PFldAttr = *BLANK                            CAP735
     C                   EXSR      SRFmtWMsg                                    CAP735
      *                                                                         CAP735
     C                   EVAL      PFldTag  = 'APTGTSYS'                        CAP735
     C                   EVAL      PFldData = 'MIDAS'                           CAP735
     C                   EVAL      PFldType = *BLANK                            CAP735
     C                   EVAL      PFldAttr = *BLANK                            CAP735
     C                   EVAL      MQTGTS = 'MIDAS'                             CAP735
     C                   EXSR      SRFmtWMsg                                    CAP735
      *                                                                         CAP735
     C                   EVAL      PFldTag  = 'APSRCSYS'                        CAP735
     C                   EVAL      PFldData = 'MIDASCOB'                        CAP735
     C                   EVAL      PFldType = *BLANK                            CAP735
     C                   EVAL      PFldAttr = *BLANK                            CAP735
     C                   EVAL      MQSRCS = 'MIDASCOB'                          CAP735
     C                   EXSR      SRFmtWMsg                                    CAP735
      *                                                                         CAP735
     C                   EVAL      PFldTag  = 'APFOTRANID'                      CAP735
     C                   EVAL      PFldData = APFOTR                            CAP735
     C                   EVAL      PFldType = *BLANK                            CAP735
     C                   EVAL      PFldAttr = *BLANK                            CAP735
     C                   EXSR      SRFmtWMsg                                    CAP735
      *                                                                         CAP735
     C                   EVAL      PFldTag  = 'APRPRLOCN'                       CAP735
     C                   EVAL      PFldData = 'B'                               CAP735
     C                   EVAL      PFldType = *BLANK                            CAP735
     C                   EVAL      PFldAttr = *BLANK                            CAP735
     C                   EXSR      SRFmtWMsg                                    CAP735
      *                                                                         CAP735
     C                   EVAL      PFldTag  = 'APRPYQUEUE'                      CAP735
     C                   EVAL      PFldData = WkRespQ                           CAP735
     C                   EVAL      PFldType = *BLANK                            CAP735
     C                   EVAL      PFldAttr = *BLANK                            CAP735
     C                   EXSR      SRFmtWMsg                                    CAP735
      *                                                                         CAP735
     C                   EVAL      PFldTag  = 'APUSERID'                        CAP735
     C                   EVAL      PFldData = WkUser                            CAP735
     C                   EVAL      PFldType = *BLANK                            CAP735
     C                   EVAL      PFldAttr = *BLANK                            CAP735
     C                   EXSR      SRFmtWMsg                                    CAP735
      *                                                                         CAP735
     C                   EVAL      PFldTag  = 'APPASSWORD'                      CAP735
     C                   EVAL      PFldData = PPassword1                        CAP735
     C                   EVAL      PFldType = *BLANK                            CAP735
     C                   EVAL      PFldAttr = *BLANK                            CAP735
     C                   EXSR      SRFmtWMsg                                    CAP735
      *                                                                         CAP735
      ** Front Office ID                                                        CAP735
     C                   EVAL      PFldTag  = 'DDFRNT'                          CAP735
     C                   EVAL      PFldData = WPDCLSeq                          CAP735
     C                   EVAL      PFldType = *BLANK                            CAP735
     C                   EVAL      PFldAttr = *BLANK                            CAP735
     C                   EXSR      SRFmtWMsg                                    CAP735
      *                                                                         CAP735
      ** +--- XML (AMAD details) -----------------------------------------+     CAP735
      **                                                                  *     CAP735
      **   Statement below will facilitate building of AMAD-XML           *     CAP735
      **   transactions to be sent to MQ for processing                   *     CAP735
      **                                                                  *     CAP735
      ** +----------------------------------------------------------------+     CAP735
      *                                                                         CAP735
      ** Action Code                                                            CAP735
     C                   EVAL      PFldTag  = 'DDACTN'                          CAP735
     C                   EVAL      PFldData = 'I'                               CAP735
     C                   EVAL      PFldType = *BLANK                            CAP735
     C                   EVAL      PFldAttr = *BLANK                            CAP735
     C                   EXSR      SRFmtWMsg                                    CAP735
      *                                                                         CAP735
     C                   EVAL      PAMADAL = APXML                              CAP735
      *                                                                         CAP735
     C                   MOVE      *BLANK        Msg                            CAP735
     C                   Z-ADD     1             X                 5 0          CAP735
     C                   MOVEA     PMSGBUF       Msg(X)                         CAP735
     C     *BLANK        LOOKUP    Msg(X)                                 99    CAP735
     C                   MOVEA     PAMADDT       Msg(X)                         CAP735
      *                                                                         CAP735
     C                   MOVEA     Msg           PMsgBuf                        CAP735
      *                                                                         CAP735
      ** Set APMQST as ‘S’ in PF/API24X7SPD and update file                     CAP735
      *                  MOVE      'S'           APMQST                         CAP735
     C                   UPDATE    API24X7SD0                                   CAP735
      *                                                                         CAP735
     C                   ENDSR                                                  CAP735
      *                                                                         CAP735
      *****************************************************************
      * SRPutMQIO - Put Message to MQ Series Queue                    *
      *                                                               *
      *****************************************************************
      *
     C     SRPutMQIO     BEGSR
      *
     C                   CALL      'GPMQMIO'
     C                   PARM      *BLANKS       WRETCD            7
     C                   PARM                    PErrMsg
     C                   PARM                    PRequest
     C                   PARM      PWIPQueue     PQueueNm
     C                   PARM                    PMsgBuf
     C                   PARM                    P@Key
     C                   PARM      WkMQMgr       PMQMgr
      *
     C                   IF        WRETCD <> *BLANKS OR PErrMsg <> *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      * SRFmtWMsg - Format the WIP Message (used for header only)     *
      *                                                               *
      *****************************************************************
      *
     C     SRFmtWMsg     BEGSR
      *
     C                   CALL      'GPFMT4WIP'
     C                   PARM                    PMode
     C                   PARM                    PAPIName
     C                   PARM                    Pformat
     C                   PARM                    PfldTag
     C                   PARM                    PfldData
     C                   PARM                    PfldType
     C                   PARM                    PfldAttr
     C                   PARM                    PMsgBuf
      *
     C                   ENDSR
      *
      *****************************************************************
      * *PSSR                                                         *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   DUMP
      *
     C                   RETURN
      *
     C                   ENDSR
